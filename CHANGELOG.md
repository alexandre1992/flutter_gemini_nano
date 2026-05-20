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

## 1.0.1
- Improve error handling
- Minor internal refactor

## 1.0.2

### 🛠 Correções
- Corrige conflitos de arquitetura entre API pública, Platform Interface e MethodChannel
- Corrige erro de tipagem ao converter Map retornado pelo MethodChannel
- Corrige uso incorreto de API antiga (`instance`) no example
- Remove imports desnecessários e warnings do `flutter analyze`
- Ajusta testes para não executar MethodChannel em ambiente Dart puro

### ✅ Melhorias
- Implementa tratamento explícito para plataformas não suportadas (Android-only)
- Padroniza a API pública em um único método `generate`
- Alinha a implementação ao padrão oficial do Flutter (`plugin_platform_interface`)
- Torna o plugin totalmente compatível com `flutter test` e CI

### 📚 Documentação
- Atualiza README para refletir suporte exclusivo a Android
- Documenta corretamente limitações e comportamento em plataformas não suportadas

### 🔒 Compatibilidade
- Mantém compatibilidade com versões anteriores (sem breaking changes)
- Nenhuma alteração necessária em Gradle ou pubspec para usuários finais