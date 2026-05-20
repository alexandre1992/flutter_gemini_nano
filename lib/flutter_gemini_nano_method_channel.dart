import 'package:flutter/services.dart';

import 'flutter_gemini_nano_platform_interface.dart';

class MethodChannelFlutterGeminiNano extends FlutterGeminiNanoPlatform {
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
        message: 'Resposta nula do método geminiNano',
      );
    }

    return Map<String, dynamic>.from(result);
  }
}
