import 'package:flutter_gemini_nano/gemini_nano_reponse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GeminiNanoResponse.fromMap funciona corretamente', () {
    final map = {
      'result': 'ok',
      'candidates': ['a', 'b'],
      'finishReasons': ['STOP'],
    };

    final response = GeminiNanoResponse.fromMap(map);

    expect(response.result, 'ok');
    expect(response.candidates, ['a', 'b']);
    expect(response.finishReasons, ['STOP']);
  });

  test('GeminiNanoResponse.fromMap aceita valores nulos', () {
    final map = <String, dynamic>{};

    final response = GeminiNanoResponse.fromMap(map);

    expect(response.result, isNull);
    expect(response.candidates, isEmpty);
    expect(response.finishReasons, isEmpty);
  });
}
