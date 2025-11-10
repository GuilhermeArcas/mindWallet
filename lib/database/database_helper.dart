import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mindwallet.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Criação das tabelas principais com base no PDF
    await db.execute('''
      CREATE TABLE usuario (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        senha_hash TEXT,
        renda_mensal REAL,
        perfil_emocional TEXT,
        data_cadastro TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE transacao_financeira (
        id_transacao INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        tipo TEXT,
        categoria TEXT,
        valor REAL,
        data_transacao TEXT,
        descricao TEXT,
        humor_associado TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      );
    ''');

    await db.execute('''
      CREATE TABLE registro_emocional (
        id_emocao INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        data_registro TEXT,
        emocao_detectada TEXT,
        intensidade INTEGER,
        observacao TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      );
    ''');

    await db.execute('''
      CREATE TABLE habito_sugerido (
        id_habito INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        descricao TEXT,
        tipo TEXT,
        status TEXT,
        data_sugerido TEXT,
        data_conclusao TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      );
    ''');

    await db.execute('''
      CREATE TABLE relatorio_evolucao (
        id_relatorio INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        periodo_inicial TEXT,
        periodo_final TEXT,
        nivel_controle_emocional REAL,
        reducao_gastos_impulsivos REAL,
        observacoes_ia TEXT,
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
