import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_gemini_nano_method_channel.dart';

abstract class FlutterGeminiNanoPlatform extends PlatformInterface {
  FlutterGeminiNanoPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGeminiNanoPlatform _instance = MethodChannelFlutterGeminiNano();

  static FlutterGeminiNanoPlatform get instance => _instance;

  static set instance(FlutterGeminiNanoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
