import 'package:flutter/material.dart';

void main() {
  runApp(const OlaMundoApp());
}

class OlaMundoApp extends StatelessWidget {
  const OlaMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Teste de Build'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Olá, Mundo! O build funcionou!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
