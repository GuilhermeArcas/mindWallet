import 'package:flutter/material.dart';
import '../../database/dao/transacao_dao.dart';
import '../../models/transacao_model.dart';

class NovaTransacaoScreen extends StatefulWidget {
  const NovaTransacaoScreen({super.key});

  @override
  State<NovaTransacaoScreen> createState() => _NovaTransacaoScreenState();
}

class _NovaTransacaoScreenState extends State<NovaTransacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final dao = TransacaoDAO();

  String tipo = 'despesa';
  String categoria = 'Alimentação';
  String emocao = 'neutro';
  String descricao = '';
  double valor = 0.0;

  final categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Educação',
    'Saúde',
    'Outros',
  ];

  final emocoes = ['feliz', 'neutro', 'ansioso', 'triste', 'estressado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Transação"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Tipo (Despesa ou Receita)
              const Text(
                "Tipo de transação",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Despesa'),
                      value: 'despesa',
                      groupValue: tipo,
                      onChanged: (value) => setState(() => tipo = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Receita'),
                      value: 'receita',
                      groupValue: tipo,
                      onChanged: (value) => setState(() => tipo = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Categoria
              const Text(
                "Categoria",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                value: categoria,
                items: categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => categoria = v!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              /// Valor
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Valor (R\$)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o valor" : null,
                onSaved: (v) => valor = double.tryParse(v!) ?? 0.0,
              ),
              const SizedBox(height: 16),

              /// Emoção associada
              const Text(
                "Como você se sentiu?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                value: emocao,
                items: emocoes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => emocao = v!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              /// Descrição
              TextFormField(
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => descricao = v ?? '',
              ),
              const SizedBox(height: 24),

              /// Botão de salvar
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Salvar Transação",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
                onPressed: _salvarTransacao,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarTransacao() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transacao = TransacaoFinanceira(
        idUsuario: 1, // simulação de usuário logado
        tipo: tipo,
        categoria: categoria,
        valor: valor,
        dataTransacao: DateTime.now().toString(),
        descricao: descricao,
        humorAssociado: emocao,
      );

      await dao.inserirTransacao(transacao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transação salva com sucesso!")),
        );
        Navigator.pop(context, true); // retorna ao Dashboard
      }
    }
  }
}
