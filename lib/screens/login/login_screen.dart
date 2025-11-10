import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Cadastro')),
      body: const Center(
        child: Text('Tela de Login e Cadastro', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
