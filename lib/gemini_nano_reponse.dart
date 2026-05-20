class GeminiNanoResponse {
  final String? result;
  final List<String> candidates;
  final List<String> finishReasons;

  GeminiNanoResponse({
    this.result,
    required this.candidates,
    required this.finishReasons,
  });

  factory GeminiNanoResponse.fromMap(Map<String, dynamic> map) {
    return GeminiNanoResponse(
      result: map['result'] as String?,
      candidates: List<String>.from(map['candidates'] ?? const []),
      finishReasons: List<String>.from(map['finishReasons'] ?? const []),
    );
  }
}
