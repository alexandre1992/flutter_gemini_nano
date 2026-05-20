import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_gemini_nano_platform_interface.dart';

class MethodChannelFlutterGeminiNano extends FlutterGeminiNanoPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('android_channel');

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
    final result = await methodChannel.invokeMethod<Map>('gemini_nano', {
      'prompt': prompt,
      'image_bytes': imageBytes,
      'temperature': temperature,
      'seed': seed,
      'topK': topK,
      'candidateCount': candidateCount,
      'maxOutputTokensDefault': maxOutputTokens,
    });

    return Map<String, dynamic>.from(result ?? {});
  }
}
