import 'package:flutter/material.dart';

class EmotionScreen extends StatelessWidget {
  const EmotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Emoções')),
      body: const Center(
        child: Text(
          'Tela para registrar emoções e sentimentos após compras.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
