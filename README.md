
# Observador

Observador é um aplicativo Flutter para monitoramento de rede, análise de dispositivos, controle de tráfego, alertas de IA e gerenciamento de dispositivos em tempo real. O app suporta múltiplos temas, autenticação biométrica e integração opcional com Firebase para notificações.

---

## Pré-requisitos

- Flutter >= 3.0
- Dart >= 2.18
- Android Studio ou VS Code
- Dispositivo Android ou emulador

---

## Configuração do Firebase (opcional)

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/).
2. Adicione um app Android:
   - Nome do pacote: apenas letras minúsculas, números e hífen, ex: `com-thyrrel-observador`.
3. Baixe o arquivo `google-services.json` e coloque em `android/app/`.
4. Instale o FlutterFire CLI:
   ```bash
   flutter pub global activate flutterfire_cli
