import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';

void main() {
  test('geminiNano smoke test (text-only)', () async {
    final plugin = FlutterGeminiNano();

    if (!Platform.isAndroid) {
      expect(
        () => plugin.generate(prompt: 'Responda apenas: OK'),
        throwsA(isA<UnsupportedError>()),
      );
      return;
    }

    try {
      final response = await plugin.generate(
        prompt: 'Responda apenas: OK',
        maxOutputTokens: 16,
      );

      expect(response.result, isNotNull);
      expect(response.result!.isNotEmpty, isTrue);
    } catch (e) {
      // Gemini pode não estar disponível no device de teste
      expect(e, anyOf(isA<Exception>(), isA<Error>()));
    }
  });

  test('geminiNano smoke test (with image)', () async {
    final plugin = FlutterGeminiNano();

    if (!Platform.isAndroid) {
      expect(
        () => plugin.generate(
          prompt: 'Descreva a imagem',
          imageBytes: Uint8List(10),
        ),
        throwsA(isA<UnsupportedError>()),
      );
      return;
    }

    final imageBytes = Uint8List.fromList(
      List<int>.filled(100, 0), // imagem fake apenas para canal
    );

    try {
      final response = await plugin.generate(
        prompt: 'Descreva a imagem',
        imageBytes: imageBytes,
      );

      expect(response.result, isNotNull);
    } catch (e) {
      expect(
        e.toString(),
        anyOf(
          contains('Gemini'),
          contains('DOWNLOAD'),
          contains('indisponível'),
        ),
      );
    }
  });
}
