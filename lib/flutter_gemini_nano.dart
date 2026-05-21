import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gemini_nano/gemini_nano_reponse.dart';
import 'flutter_gemini_nano_platform_interface.dart';

/// Public API for the flutter_gemini_nano plugin.
///
/// Provides access to **Gemini Nano**, an on-device AI model
/// executed locally on supported Android devices.
///
/// ## Supported platforms
/// - ✅ Android
/// - ❌ iOS
/// - ❌ Web
/// - ❌ Desktop
///
/// ## Important
/// If this plugin is used on an unsupported platform,
/// an [UnsupportedError] will be thrown.
class FlutterGeminiNano {
  /// Generates content using the Gemini Nano model.
  ///
  /// Supports:
  /// - Text-only generation
  /// - Multimodal generation (text + image)
  ///
  /// ## Parameters
  /// - [prompt]: Base text prompt for generation.
  /// - [imageBytes]: Optional image bytes for multimodal input.
  /// - [temperature]: Controls response randomness.
  /// - [seed]: Optional value for reproducible results.
  /// - [topK]: Number of candidate tokens considered.
  /// - [candidateCount]: Number of response candidates.
  /// - [maxOutputTokens]: Maximum output length.
  ///
  /// ## Returns
  /// A [GeminiNanoResponse] containing the generated content
  /// and platform metadata.
  ///
  /// ## Throws
  /// - [UnsupportedError] if the platform is not Android.
  Future<GeminiNanoResponse> generate({
    required String prompt,
    Uint8List? imageBytes,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) async {
    _ensureAndroid();

    final result = await FlutterGeminiNanoPlatform.instance.geminiNano(
      prompt: prompt,
      imageBytes: imageBytes,
      temperature: temperature,
      seed: seed,
      topK: topK,
      candidateCount: candidateCount,
      maxOutputTokens: maxOutputTokens,
    );

    return GeminiNanoResponse.fromMap(result);
  }

  /// Ensures the plugin is running on a supported platform.
  ///
  /// Throws an [UnsupportedError] if the platform is not Android.
  void _ensureAndroid() {
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'flutter_gemini_nano is supported only on Android.',
      );
    }
  }
}
