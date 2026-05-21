/// Represents a response returned by the Gemini Nano model.
///
/// This class encapsulates the structured result produced by
/// the on-device Gemini Nano inference, including the main output,
/// alternative candidates, and finish reasons reported by the model.
class GeminiNanoResponse {
  /// The primary generated result.
  ///
  /// This field may be `null` if the model did not return
  /// a direct textual output.
  final String? result;

  /// List of generated candidate responses.
  ///
  /// Each entry represents an alternative output generated
  /// by the model during inference.
  final List<String> candidates;

  /// List of finish reasons associated with each candidate.
  ///
  /// Finish reasons indicate why the model stopped generating output
  /// (for example: length limit reached, completed successfully, etc.).
  final List<String> finishReasons;

  /// Creates a new [GeminiNanoResponse] instance.
  ///
  /// - [result]: Primary generated text, if available.
  /// - [candidates]: List of generated response candidates.
  /// - [finishReasons]: Reasons explaining why generation ended.
  GeminiNanoResponse({
    this.result,
    required this.candidates,
    required this.finishReasons,
  });

  /// Creates a [GeminiNanoResponse] from a platform response map.
  ///
  /// This factory is typically used internally to convert
  /// the raw data returned from the native platform layer
  /// into a strongly typed Dart object.
  ///
  /// Missing values are safely converted into empty lists.
  factory GeminiNanoResponse.fromMap(Map<String, dynamic> map) {
    return GeminiNanoResponse(
      result: map['result'] as String?,
      candidates: List<String>.from(map['candidates'] ?? const []),
      finishReasons: List<String>.from(map['finishReasons'] ?? const []),
    );
  }
}
