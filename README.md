# 📱 Observador

Um aplicativo Flutter avançado para monitoramento de rede, análise de dispositivos, controle de tráfego, alertas de IA e gerenciamento de dispositivos em tempo real.

## 🚀 Características

- 📊 **Monitoramento de Rede**: Análise em tempo real do tráfego
- 🤖 **Dual IA**: IA local no app + IA externa robusta  
- 🔧 **API para Roteadores**: Instalação automática de API
- 🔒 **VPN Integrada**: Túnel seguro roteador ↔ app
- 🎨 **Multi-tema**: Suporte a temas personalizáveis
- 🔐 **Biometria**: Autenticação biométrica
- 🔔 **Notificações**: Firebase opcional

## 🏗️ Builds Automatizados

### ✅ Workflows Disponíveis

| Workflow | Descrição | Status |
|----------|-----------|--------|
| 🧪 **Test APK** | APK com dados simulados para testes | ✅ Ativo |
| 📱 **Release APK** | APK de produção para instalação | ✅ Ativo |
| 📦 **Release AAB** | AAB para Google Play Store | ✅ Ativo |
| 🍎 **iOS Build** | Build para iOS | ⏭️ Skip (configurar certificados) |
| 🖥️ **Desktop** | Linux, Windows, macOS | ⏭️ Skip (opcional) |

### 📱 Downloads Diretos

1. Vá para **Actions** → Execução mais recente
2. Baixe o artifact desejado:
   - `🧪-observador-test-apk` - Para testes
   - `📱-observador-release-apk` - Para uso normal  
   - `📦-observador-release-aab` - Para Play Store

### ⏰ Execução Agendada

Os workflows executam automaticamente:
- **Push/PR** na branch `main`
- **Diariamente às 6h UTC** (3h BR)
- **Manualmente** via Actions

## 🌿 Estrutura de Branches

- **`main`** - App principal Flutter
- **`N.O.V.A`** - IA do aplicativo  
- **`TOOLS`** - Ferramentas auxiliares
- **`MeshAgente`** - Agente de malha de rede

## 🔧 Configuração

### Pré-requisitos
- Flutter >= 3.24.5
- Dart >= 3.0.0
- Android Studio ou VS Code

### Instalação
```bash
git clone https://github.com/thyrrel/Observador.git
cd Observador
flutter pub get
flutter run
```

### Firebase (Opcional)
1. Crie projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione app Android: `com.thyrrel.observador`
3. Baixe `google-services.json` → `android/app/`
4. Configure FlutterFire CLI

### 🔑 Signing para Release

Para builds assinados, configure no GitHub:

**Secrets necessários:**
- `KEYSTORE_BASE64` - Keystore em base64
- `KEYSTORE_PASSWORD` - Senha do keystore  
- `KEY_ALIAS` - Alias da chave
- `KEY_PASSWORD` - Senha da chave

## 🤝 Contribuição

1. Fork o projeto
2. Crie sua branch: `git checkout -b feature/nova-feature`
3. Commit: `git commit -m 'Add: nova feature'`
4. Push: `git push origin feature/nova-feature`  
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

🔧 **Configurado automaticamente** | 🚀 **Builds otimizados** | 📱 **Download direto**
