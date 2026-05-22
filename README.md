<a href="https://buymeacoffee.com/malexandrej" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png"
       alt="Buy Me A Coffee"
       width="200"/>
</a>

# flutter_gemini_nano

Plugin Flutter para uso do **Gemini Nano (on-device)** via **ML Kit GenAI**, permitindo
geração de texto e multimodal (texto + imagem) **diretamente no dispositivo Android**,
sem necessidade de chamadas para servidores externos.

## ☕ Support the project

> ✅ Processamento local  
> ✅ Privacidade por design  
> ✅ Ideal para apps offline ou sensíveis a dados  

---

## ✨ Funcionalidades

- ✅ Geração de texto usando Gemini Nano
- ✅ Suporte a prompt multimodal (texto + imagem)
- ✅ Controle de parâmetros de geração:
  - `temperature`
  - `topK`
  - `seed`
  - `candidateCount`
  - `maxOutputTokens`
- ✅ Download automático do modelo quando necessário
- ✅ Tratamento de dispositivos não compatíveis
- ✅ API simples, segura e tipada

---

## 📱 Plataformas suportadas

| Plataforma | Suporte |
|-----------|--------|
| Android   | ✅ Sim (Gemini Nano) |
| iOS       | ❌ Não |
| Web       | ❌ Não |
| Desktop   | ❌ Não |

> ⚠️ O Gemini Nano está disponível apenas em **dispositivos Android compatíveis**  
> e requer suporte do **Google ML Kit GenAI** no dispositivo.

---

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  flutter_gemini_nano: ^1.0.5