import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';

void main() {
  test('Lança UnsupportedError fora do Android', () {
    if (Platform.isAndroid) {
      return; // não testa em Android
    }

    final plugin = FlutterGeminiNano();

    expect(
      () => plugin.generate(prompt: 'teste'),
      throwsA(isA<UnsupportedError>()),
    );
  });
}
