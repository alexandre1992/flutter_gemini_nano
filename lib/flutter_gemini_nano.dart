// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'dart:typed_data';
import 'package:flutter_gemini_nano/gemini_nano_reponse.dart';

import 'flutter_gemini_nano_platform_interface.dart';

class FlutterGeminiNano {
  static final FlutterGeminiNano instance = FlutterGeminiNano._internal();

  FlutterGeminiNano._internal();

  Future<GeminiNanoResponse> generate({
    required String prompt,
    Uint8List? imageBytes,
    double? temperature,
    int? seed,
    int? topK,
    int? candidateCount,
    int? maxOutputTokens,
  }) async {
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
}
