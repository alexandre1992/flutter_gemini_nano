import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('geminiNano integration test (text-only)', (
    WidgetTester tester,
  ) async {
    final plugin = FlutterGeminiNano.instance;

    try {
      final response = await plugin.generate(
        prompt: 'Responda apenas: OK',
        maxOutputTokens: 16,
      );

      expect(response.result, isNotNull);
      expect(response.result!.isNotEmpty, true);
    } catch (e) {
      expect(
        e.toString(),
        anyOf(
          contains('Gemini Nano não disponível'),
          contains('indisponível'),
          contains('DOWNLOAD'),
        ),
      );
    }
  });

  testWidgets('geminiNano integration test with image', (
    WidgetTester tester,
  ) async {
    final plugin = FlutterGeminiNano.instance;

    final imageBytes = Uint8List.fromList(
      List<int>.filled(100, 0), // imagem fake só para canal
    );

    try {
      final response = await plugin.generate(
        prompt: 'Descreva a imagem',
        imageBytes: imageBytes,
      );

      expect(response.result, isNotNull);
    } catch (e) {
      expect(e.toString(), contains('Gemini'));
    }
  });
}
