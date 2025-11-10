class TransacaoFinanceira {
  final int? idTransacao;
  final int idUsuario;
  final String tipo; // "despesa" ou "receita"
  final String categoria;
  final double valor;
  final String dataTransacao;
  final String descricao;
  final String? humorAssociado;

  TransacaoFinanceira({
    this.idTransacao,
    required this.idUsuario,
    required this.tipo,
    required this.categoria,
    required this.valor,
    required this.dataTransacao,
    required this.descricao,
    this.humorAssociado,
  });

  // Converter de Map (SQLite) para objeto
  factory TransacaoFinanceira.fromMap(Map<String, dynamic> map) {
    return TransacaoFinanceira(
      idTransacao: map['id_transacao'],
      idUsuario: map['id_usuario'],
      tipo: map['tipo'],
      categoria: map['categoria'],
      valor: map['valor'],
      dataTransacao: map['data_transacao'],
      descricao: map['descricao'],
      humorAssociado: map['humor_associado'],
    );
  }

  get id => null;

  // Converter objeto para Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id_transacao': idTransacao,
      'id_usuario': idUsuario,
      'tipo': tipo,
      'categoria': categoria,
      'valor': valor,
      'data_transacao': dataTransacao,
      'descricao': descricao,
      'humor_associado': humorAssociado,
    };
  }
}
