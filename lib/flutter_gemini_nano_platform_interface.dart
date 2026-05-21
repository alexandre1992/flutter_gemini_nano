import 'dart:typed_data';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_gemini_nano_method_channel.dart';

/// Base platform interface for the flutter_gemini_nano plugin.
///
/// This class defines the contract that all platform implementations
/// must follow. By default, the plugin uses
/// [MethodChannelFlutterGeminiNano] as its implementation.
///
/// The [PlatformInterface] pattern ensures that only authorized
/// implementations can replace the active platform instance.
abstract class FlutterGeminiNanoPlatform extends PlatformInterface {
  /// Creates a new platform interface instance.
  ///
  /// The token is used to verify legitimate platform implementations
  /// according to Flutter plugin best practices.
  FlutterGeminiNanoPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGeminiNanoPlatform _instance = MethodChannelFlutterGeminiNano();

  /// The current platform-specific implementation.
  ///
  /// Defaults to a MethodChannel-based implementation.
  static FlutterGeminiNanoPlatform get instance => _instance;

  /// Sets a new platform-specific implementation.
  ///
  /// This is typically used only for testing or mocking purposes.
  static set instance(FlutterGeminiNanoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Executes a Gemini Nano request on the underlying platform.
  ///
  /// This method is implemented by the platform layer
  /// (for example, Android via MethodChannel).
  ///
  /// ## Parameters
  /// - [prompt]: Text prompt sent to the model.
  /// - [imageBytes]: Optional image bytes for multimodal prompts.
  /// - [temperature]: Controls response creativity.
  /// - [seed]: Optional value for deterministic outputs.
  /// - [topK]: Limits the number of candidate tokens.
  /// - [candidateCount]: Number of generated candidates.
  /// - [maxOutputTokens]: Maximum output token count.
  ///
  /// ## Returns
  /// A [Map] containing the raw platform response.
  ///
  /// ## Note
  /// This method should not be called directly by applications.
  /// Use the public API exposed by [FlutterGeminiNano] instead.
  Future<Map<String, dynamic>> geminiNano({
    required String prompt,
    Uint8List? imageBytes,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  });
}
