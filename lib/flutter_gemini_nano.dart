import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_gemini_nano/gemini_nano_reponse.dart';

import 'flutter_gemini_nano_platform_interface.dart';

class FlutterGeminiNano {
  /// Geração principal (texto ou multimodal)
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

  void _ensureAndroid() {
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'flutter_gemini_nano é suportado apenas no Android.',
      );
    }
  }
}
