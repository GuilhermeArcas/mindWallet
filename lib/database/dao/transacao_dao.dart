// ignore: unused_import
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../models/transacao_model.dart';

class TransacaoDAO {
  final dbHelper = DatabaseHelper.instance;

  /// Inserir nova transação
  Future<int> inserirTransacao(TransacaoFinanceira transacao) async {
    final db = await dbHelper.database;
    return await db.insert('transacao_financeira', transacao.toMap());
  }

  /// Listar todas as transações de um usuário
  Future<List<TransacaoFinanceira>> listarTransacoes(int idUsuario) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'transacao_financeira',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'data_transacao DESC',
    );
    return result.map((map) => TransacaoFinanceira.fromMap(map)).toList();
  }

  /// Deletar uma transação
  Future<int> deletarTransacao(int idTransacao) async {
    final db = await dbHelper.database;
    return await db.delete(
      'transacao_financeira',
      where: 'id_transacao = ?',
      whereArgs: [idTransacao],
    );
  }

  /// Atualizar transação existente
  Future<int> atualizarTransacao(TransacaoFinanceira transacao) async {
    final db = await dbHelper.database;
    return await db.update(
      'transacao_financeira',
      transacao.toMap(),
      where: 'id_transacao = ?',
      whereArgs: [transacao.idTransacao],
    );
  }

  /// Calcular total de despesas e receitas
  Future<Map<String, double>> calcularTotais(int idUsuario) async {
    final db = await dbHelper.database;
    final despesas = await db.rawQuery(
      'SELECT SUM(valor) as total FROM transacao_financeira WHERE id_usuario = ? AND tipo = "despesa"',
      [idUsuario],
    );
    final receitas = await db.rawQuery(
      'SELECT SUM(valor) as total FROM transacao_financeira WHERE id_usuario = ? AND tipo = "receita"',
      [idUsuario],
    );

    return {
      'despesas': despesas.first['total'] != null
          ? despesas.first['total'] as double
          : 0.0,
      'receitas': receitas.first['total'] != null
          ? receitas.first['total'] as double
          : 0.0,
    };
  }
}
