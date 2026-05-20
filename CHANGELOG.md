## 1.0.0

### Added
- Initial release of `flutter_gemini_nano`
- Gemini Nano on-device text generation support
- Multimodal support (text + image)
- Configurable generation parameters:
  - temperature
  - topK
  - seed
  - candidateCount
  - maxOutputTokens
- Automatic model download handling
- Graceful handling of unsupported devices
- Public Dart API with typed response (`GeminiNanoResponse`)
- Android implementation using ML Kit GenAI
- Example Flutter application
- Unit tests and integration tests

### Notes
- Currently supported only on Android devices compatible with Gemini Nano.
- All processing is performed locally on the device.