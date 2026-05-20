package br.com.fahz.gemini_nano

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import net.take.blipchat.models.*
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
    LifecycleOwner {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private val lifecycleRegistry = LifecycleRegistry(this)
    override fun getLifecycle(): Lifecycle = lifecycleRegistry

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    private val generativeModel: GenerativeModel by lazy {
        Generation.getClient()
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        lifecycleRegistry.currentState = Lifecycle.State.CREATED

        channel = MethodChannel(
            binding.binaryMessenger,
            "android_channel"
        )
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        scope.cancel()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "gemini_nano" -> {
                scope.launch {
                    try {
                        if (!isGeminiNanoUsable()) {
                            result.success(
                                mapOf("result" to "Gemini Nano não disponível neste dispositivo.")
                            )
                            return@launch
                        }

                        runGeminiNano(call, result)
                    } catch (e: Exception) {
                        result.error(
                            "GEMINI_NANO_ERROR",
                            e.message ?: "Erro desconhecido",
                            null
                        )
                    }
                }
            }

            "check_gemini_status" -> {
                scope.launch {
                    result.success(isGeminiNanoUsable())
                }
            }

            else -> result.notImplemented()
        }
    }

    // -----------------------------
    // Gemini Nano
    // -----------------------------

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
        val prompt: String = call.argument<String>("prompt")?.trim().orEmpty()
        if (prompt.isEmpty()) {
            result.error("INVALID_ARGS", "Argumento 'prompt' é obrigatório.", null)
            return
        }

        val imageBytes: ByteArray? = call.argument("image_bytes")

        val temperature: Float? = call.argument<Double>("temperature")?.toFloat()
        val seed: Int? = call.argument("seed")
        val topK: Int? = call.argument("topK")
        val candidateCount: Int? = call.argument("candidateCount")
        val maxOutputTokens: Int? = call.argument("maxOutputTokensDefault")

        validateConfigOrThrow(
            temperature,
            seed,
            topK,
            candidateCount,
            maxOutputTokens
        )

        withContext(Dispatchers.IO) {
            ensureModelReady()
        }

        val bitmap: Bitmap? = withContext(Dispatchers.IO) {
            imageBytes?.let {
                BitmapFactory.decodeByteArray(it, 0, it.size)
            }
        }

        val request = if (bitmap != null) {
            generateContentRequest(
                ImagePart(bitmap),
                TextPart(prompt)
            ) {
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
        val finishReasons = response.candidates.map { it.finishReason.toString() }

        result.success(
            mapOf(
                "result" to candidates.firstOrNull(),
                "candidates" to candidates,
                "finishReasons" to finishReasons
            )
        )
    }

    private suspend fun ensureModelReady() {
        when (val status = generativeModel.checkStatus()) {
            FeatureStatus.AVAILABLE -> return

            FeatureStatus.DOWNLOADABLE -> {
                generativeModel.download().collect { dl ->
                    if (dl is DownloadStatus.DownloadFailed) {
                        throw dl.e
                    }
                }
            }

            FeatureStatus.DOWNLOADING -> {
                repeat(60) {
                    delay(500)
                    if (generativeModel.checkStatus() == FeatureStatus.AVAILABLE) return
                }
                throw IllegalStateException("Gemini Nano ainda está baixando.")
            }

            FeatureStatus.UNAVAILABLE ->
                throw IllegalStateException("Gemini Nano indisponível neste dispositivo.")

            else -> throw IllegalStateException("Status inesperado: $status")
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