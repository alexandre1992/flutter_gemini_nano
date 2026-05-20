# flutter_gemini_nano

Plugin Flutter para uso do **Gemini Nano (on-device)** via **ML Kit GenAI**, permitindo
geração de texto e multimodal (texto + imagem) **diretamente no dispositivo Android**,
sem necessidade de chamadas para servidores externos.

> ✅ Processamento local  
> ✅ Privacidade por design  
> ✅ Ideal para apps offline ou sensíveis a dados  

---

## ✨ Funcionalidades

- ✅ Geração de texto usando Gemini Nano
- ✅ Suporte a prompt multimodal (texto + imagem)
- ✅ Controle de parâmetros:
  - temperature
  - topK
  - seed
  - candidateCount
  - maxOutputTokens
- ✅ Download automático do modelo quando necessário
- ✅ Tratamento de dispositivos não compatíveis
- ✅ API simples e segura

---

## 📱 Plataformas Suportadas

| Plataforma | Suporte |
|-----------|--------|
| Android   | ✅ Sim (Gemini Nano) |
| iOS       | ❌ Não (ainda não disponível) |
| Web       | ❌ Não |
| Desktop   | ❌ Não |

> ⚠️ O Gemini Nano está disponível apenas em **dispositivos Android compatíveis**.

---

## 📦 Instalação

No `pubspec.yaml`:

```yaml
dependencies:
  flutter_gemini_nano: ^1.0.0