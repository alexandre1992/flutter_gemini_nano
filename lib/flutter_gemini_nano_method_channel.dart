import 'package:flutter/services.dart';
import 'flutter_gemini_nano_platform_interface.dart';

/// Android implementation of the flutter_gemini_nano plugin.
///
/// Uses a [MethodChannel] to communicate with the native
/// Android layer responsible for interacting with
/// Android AI Core and executing Gemini Nano.
class MethodChannelFlutterGeminiNano extends FlutterGeminiNanoPlatform {
  /// Method channel used to communicate with native Android code.
  static const MethodChannel _channel = MethodChannel('flutter_gemini_nano');

  @override
  Future<Map<String, dynamic>> geminiNano({
    required String prompt,
    Uint8List? imageBytes,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) async {
    final Map<dynamic, dynamic>? result =
        await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'geminiNano',
      {
        'prompt': prompt,
        'imageBytes': imageBytes,
        'temperature': temperature,
        'seed': seed,
        'topK': topK,
        'candidateCount': candidateCount,
        'maxOutputTokens': maxOutputTokens,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Null response returned from geminiNano method',
      );
    }

    return Map<String, dynamic>.from(result);
  }

  @override
  Future<bool> isGeminiNanoAvailable() async {
    final bool? result =
        await _channel.invokeMethod<bool>('isGeminiNanoAvailable');

    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Null response returned from isGeminiNanoAvailable',
      );
    }

    return result;
  }
}
