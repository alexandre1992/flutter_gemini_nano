package br.com.example.flutter_gemini_nano

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import com.google.mlkit.genai.common.DownloadStatus
import com.google.mlkit.genai.common.FeatureStatus
import com.google.mlkit.genai.prompt.Generation
import com.google.mlkit.genai.prompt.GenerativeModel
import com.google.mlkit.genai.prompt.ImagePart
import com.google.mlkit.genai.prompt.TextPart
import com.google.mlkit.genai.prompt.generateContentRequest

class FlutterGeminiNanoPlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private val generativeModel: GenerativeModel by lazy {
        Generation.getClient()
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "flutter_gemini_nano")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val lifecycleOwner = activity as? LifecycleOwner
        if (lifecycleOwner == null) {
            result.error("NO_ACTIVITY", "Activity não disponível", null)
            return
        }

        when (call.method) {
            "gemini_nano" -> {
                lifecycleOwner.lifecycleScope.launch {
                    runGeminiNano(call, result)
                }
            }
            "isGeminiNanoAvailable" -> {
                lifecycleOwner.lifecycleScope.launch {
                    result.success(isGeminiNanoUsable())
                }
            }
            else -> result.notImplemented()
        }
    }
    
    private suspend fun getGeminiNanoStatus(): Int {
        return generativeModel.checkStatus()
    }

    private suspend fun isGeminiNanoUsable(): Boolean {
        return when (getGeminiNanoStatus()) {
            FeatureStatus.AVAILABLE,
            FeatureStatus.DOWNLOADABLE,
            FeatureStatus.DOWNLOADING -> true
            else -> false
        }
    }

    private suspend fun runGeminiNano(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        try {
            if (!isGeminiNanoUsable()) {
                result.success(
                    mapOf("result" to "Gemini Nano não disponível neste dispositivo.")
                )
                return
            }

            val prompt = call.argument<String>("prompt")?.trim().orEmpty()
            if (prompt.isEmpty()) {
                result.error("INVALID_ARGS", "Argumento 'prompt' é obrigatório.", null)
                return
            }

            val imageBytes = call.argument<ByteArray>("image_bytes")

            val temperature = call.argument<Double>("temperature")?.toFloat()
            val seed = call.argument<Int>("seed")
            val topK = call.argument<Int>("topK")
            val candidateCount = call.argument<Int>("candidateCount")
            val maxOutputTokens = call.argument<Int>("maxOutputTokens")

            validateConfigOrThrow(
                temperature,
                seed,
                topK,
                candidateCount,
                maxOutputTokens
            )

            ensureModelReady()

            val bitmap: Bitmap? = withContext(Dispatchers.IO) {
                imageBytes?.let {
                    BitmapFactory.decodeByteArray(it, 0, it.size)
                }
            }

            val request = if (bitmap != null) {
                generateContentRequest(ImagePart(bitmap), TextPart(prompt)) {
                    this.temperature = temperature
                    this.seed = seed
                    this.topK = topK
                    this.candidateCount = candidateCount
                    this.maxOutputTokens = maxOutputTokens
                }
            } else {
                generateContentRequest(TextPart(prompt)) {
                    this.temperature = temperature
                    this.seed = seed
                    this.topK = topK
                    this.candidateCount = candidateCount
                    this.maxOutputTokens = maxOutputTokens
                }
            }

            val response = withContext(Dispatchers.IO) {
                generativeModel.generateContent(request)
            }

            val candidates = response.candidates.map { it.text }
            val finishReasons = response.candidates.map {
                it.finishReason.toString()
            }

            result.success(
                mapOf(
                    "result" to candidates.firstOrNull(),
                    "candidates" to candidates,
                    "finishReasons" to finishReasons
                )
            )
        } catch (e: Exception) {
            result.error("GEMINI_NANO_ERROR", e.message, null)
        }
    }

    private suspend fun isGeminiNanoUsable(): Boolean =
        when (generativeModel.checkStatus()) {
            FeatureStatus.AVAILABLE,
            FeatureStatus.DOWNLOADABLE,
            FeatureStatus.DOWNLOADING -> true
            else -> false
        }

    private suspend fun ensureModelReady() {
        when (generativeModel.checkStatus()) {
            FeatureStatus.AVAILABLE -> return
            FeatureStatus.DOWNLOADABLE -> {
                generativeModel.download().collect {
                    if (it is DownloadStatus.DownloadFailed) throw it.e
                }
            }
            FeatureStatus.DOWNLOADING -> {
                repeat(60) {
                    delay(500)
                    if (generativeModel.checkStatus() == FeatureStatus.AVAILABLE) return
                }
                throw IllegalStateException("Gemini Nano ainda está baixando.")
            }
            else -> throw IllegalStateException("Gemini Nano indisponível.")
        }
    }

    private fun validateConfigOrThrow(
        temperature: Float?,
        seed: Int?,
        topK: Int?,
        candidateCount: Int?,
        maxOutputTokens: Int?
    ) {
        temperature?.let { require(it in 0.0f..1.0f) }
        seed?.let { require(it >= 0) }
        topK?.let { require(it >= 1) }
        candidateCount?.let { require(it in 1..8) }
        maxOutputTokens?.let { require(it in 1..256) }
    }
}