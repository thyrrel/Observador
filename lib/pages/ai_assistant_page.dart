import 'package:flutter/material.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: _controller.text, isUser: true));
      _messages.add(ChatMessage(
          text: 'Sugestão: priorize seu console agora!', isUser: false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assistente IA')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(message: _messages[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: 'Pergunte algo...',
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.text,
            style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black)),
      ),
    );
  }
}
