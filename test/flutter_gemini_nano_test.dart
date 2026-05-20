import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gemini_nano/flutter_gemini_nano.dart';

void main() {
  test('FlutterGeminiNano pode ser instanciado', () {
    final plugin = FlutterGeminiNano();
    expect(plugin, isNotNull);
  });
}
