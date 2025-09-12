// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 💬 ChatMessage - Modelo de mensagem          ┃
// ┃ 🔧 Representa uma linha de conversa          ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

class ChatMessage {
  final String text;     // Conteúdo da mensagem
  final bool isUser;     // Indica se foi enviada pelo usuário

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}
