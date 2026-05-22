## 1.0.0

### ➕ Adicionado
- Lançamento inicial do `flutter_gemini_nano`
- Suporte à geração de texto on-device com Gemini Nano
- Suporte multimodal (texto + imagem)
- Parâmetros de geração configuráveis:
  - temperature
  - topK
  - seed
  - candidateCount
  - maxOutputTokens
- Gerenciamento automático do download do modelo
- Tratamento elegante para dispositivos não suportados
- API pública em Dart com resposta tipada (`GeminiNanoResponse`)
- Implementação Android utilizando ML Kit GenAI
- Aplicação Flutter de exemplo
- Testes unitários e testes de integração

### 📝 Observações
- Atualmente suportado apenas em dispositivos Android compatíveis com o Gemini Nano.
- Todo o processamento é realizado localmente no dispositivo (on-device).

---

## 1.0.1

### 🛠 Melhorias
- Melhoria no tratamento de erros
- Pequena refatoração interna

---

## 1.0.2

### 🛠 Correções
- Corrige conflitos de arquitetura entre API pública, Platform Interface e MethodChannel
- Corrige erro de tipagem ao converter o `Map` retornado pelo MethodChannel
- Corrige uso incorreto de API antiga (`instance`) no aplicativo de exemplo
- Remove imports desnecessários e warnings do `flutter analyze`
- Ajusta testes para evitar execução de MethodChannel em ambiente Dart puro

### ✅ Melhorias
- Implementa tratamento explícito para plataformas não suportadas (somente Android)
- Padroniza a API pública em um único método `generate`
- Alinha a implementação ao padrão oficial do Flutter (`plugin_platform_interface`)
- Torna o plugin totalmente compatível com `flutter test` e pipelines de CI

### 📚 Documentação
- Atualiza o README para refletir suporte exclusivo ao Android
- Documenta corretamente limitações e comportamento em plataformas não suportadas

### 🔒 Compatibilidade
- Mantém compatibilidade com versões anteriores (sem breaking changes)
- Nenhuma alteração necessária em Gradle ou pubspec para usuários finais

---

## 1.0.3

### ✅ Estabilização e documentação da API
- Documentação completa em Dart (`///`) para todas as APIs públicas
- Documentação da interface de plataforma (`FlutterGeminiNanoPlatform`)
- Documentação da implementação Android via `MethodChannel`
- Documentação do modelo de resposta `GeminiNanoResponse`
- Padronização dos comentários para compatibilidade com `dartdoc`
- Melhoria na clareza dos parâmetros de geração (`temperature`, `seed`, `topK`, `candidateCount`, `maxOutputTokens`)

## 1.0.4

### ✨ Novos recursos

- Adicionada a API `isAvailable()` para verificar a disponibilidade do Gemini Nano antes da inferência
- Método de plataforma exposto `isGeminiNanoAvailable`
- Segurança aprimorada, prevenindo execução em dispositivos não suportados
- App de exemplo atualizado para:
  - Exibir o status de disponibilidade na interface
  - Desabilitar a execução quando o Gemini Nano estiver indisponível

### 🛠 Melhorias

- Melhor tratamento de erros quando o modelo está indisponível
- Feedback mais claro para plataformas não suportadas
- Validação interna dos parâmetros de geração

## 1.0.5

- Novo README.md com um link para doações para manter o codigo atualizado

## 2.0.0

### 🎉 Primeira versão estável (Stable Release)

Esta versão marca a consolidação do `flutter_gemini_nano` como um plugin
estável, documentado e pronto para uso em produção.

### ✅ Estabilidade da API
- API pública considerada estável
- Método único e padronizado `generate`
- Modelo de resposta tipado e documentado (`GeminiNanoResponse`)
- Compatibilidade mantida com todas as versões 1.x

### 🔍 Verificação de disponibilidade
- API oficial `isAvailable()` para validação prévia do Gemini Nano
- Previne execução em dispositivos não compatíveis
- Comportamento previsível em plataformas não suportadas

### 📚 Documentação
- Documentação completa com `dartdoc`
- README reestruturado com foco em uso real e limitações
- Exemplo funcional e didático

### 🛡️ Segurança e robustez
- Validação de parâmetros de geração
- Tratamento consistente de erros
- Execução 100% on-device (sem rede)

### 🤖 Plataformas
- Android (Gemini Nano via ML Kit GenAI)
- Outras plataformas retornam erro explícito e seguro

> 🔔 **Nota**: Não há breaking changes em relação à linha 1.x.