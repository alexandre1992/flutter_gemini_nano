import 'dart:typed_data';

import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano_platform_interface.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterGeminiNanoPlatform
    with MockPlatformInterfaceMixin
    implements FlutterGeminiNanoPlatform {
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
    return {
      'result': 'Resposta simulada para: $prompt',
      'candidates': ['Resposta simulada para: $prompt', 'Outra resposta'],
      'finishReasons': ['STOP', 'STOP'],
    };
  }
}

void main() {
  final FlutterGeminiNanoPlatform initialPlatform =
      FlutterGeminiNanoPlatform.instance;

  test('$MethodChannelFlutterGeminiNano is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGeminiNano>());
  });

  test('geminiNano returns mocked response', () async {
    final mockPlatform = MockFlutterGeminiNanoPlatform();
    FlutterGeminiNanoPlatform.instance = mockPlatform;

    final response = await FlutterGeminiNanoPlatform.instance.geminiNano(
      prompt: 'Teste',
    );

    expect(response, isA<Map<String, dynamic>>());
    expect(response['result'], contains('Teste'));
    expect(response['candidates'], isA<List>());
    expect(response['finishReasons'], isA<List>());
  });

  test('FlutterGeminiNano.generate returns GeminiNanoResponse', () async {
    final mockPlatform = MockFlutterGeminiNanoPlatform();
    FlutterGeminiNanoPlatform.instance = mockPlatform;

    final plugin = FlutterGeminiNano.instance;

    final response = await plugin.generate(
      prompt: 'Olá Gemini',
      temperature: 0.7,
    );

    expect(response.result, contains('Olá Gemini'));
    expect(response.candidates.length, 2);
    expect(response.finishReasons.first, 'STOP');
  });
}
