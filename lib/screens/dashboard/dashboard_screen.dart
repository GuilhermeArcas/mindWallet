import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../emotions/emotion_screen.dart';
import '../chat/chat_screen.dart';
import '../habits/habits_screen.dart';
import '../progress/progress_screen.dart';
import '../../database/dao/transacao_dao.dart';
import '../../models/transacao_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardHome(),
    EmotionScreen(),
    ChatScreen(),
    HabitsScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood_rounded),
            label: 'Emoções',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_rounded),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Progresso',
          ),
        ],
      ),
    );
  }
}

/// =============================================
/// DASHBOARD PRINCIPAL — RESUMO FINANCEIRO E EMOCIONAL
/// =============================================
class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final dao = TransacaoDAO();
  List<TransacaoFinanceira> transacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
    _debugListarTransacoes();
  }

  /// Carrega todas as transações do usuário
  Future<void> _carregarTransacoes() async {
    final lista = await dao.listarTransacoes(1); // simulação: usuário ID 1
    setState(() {
      transacoes = lista;
    });
  }

  /// Logs para depuração
  Future<void> _debugListarTransacoes() async {
    final lista = await dao.listarTransacoes(1);
    if (kDebugMode) {
      print('🧾 Transações retornadas do banco:');
    }
    for (var t in lista) {
      if (kDebugMode) {
        print(
          '➡️ id=${t.id}, tipo=${t.tipo}, categoria=${t.categoria}, valor=${t.valor}, humor=${t.humorAssociado}',
        );
      }
    }
  }

  /// Calcula o total de despesas
  double get totalDespesas => transacoes.fold(
    0.0,
    (sum, t) => sum + (t.tipo == 'despesa' ? t.valor : 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('MindWallet'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final resultado = await Navigator.pushNamed(
                context,
                '/novaTransacao',
              );
              if (resultado == true) {
                await _carregarTransacoes();

                // Atualiza gráfico também
                // ignore: use_build_context_synchronously
                final chartState = context
                    .findAncestorStateOfType<_PieChartFromDatabaseState>();
                chartState?._carregarGastos();

                setState(() {}); // força rebuild geral
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _carregarTransacoes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Seção: Saudação emocional
              Text(
                "Seu equilíbrio hoje",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Você tende a gastar mais em dias de estresse.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              /// Seção: Gráfico de gastos
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Distribuição de Gastos",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: PieChartFromDatabase(idUsuario: 1),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Total de despesas: R\$ ${totalDespesas.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Seção: Lista de transações reais
              Text(
                "Suas últimas transações",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 10),

              if (transacoes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "Nenhuma transação registrada ainda.\nToque em + para adicionar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transacoes.length,
                  itemBuilder: (context, index) {
                    final t = transacoes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          t.tipo == 'despesa'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.tipo == 'despesa'
                              ? Colors.redAccent
                              : Colors.green,
                        ),
                        title: Text(
                          "${t.categoria} - R\$ ${t.valor.toStringAsFixed(2)}",
                        ),
                        subtitle: Text(
                          "${t.descricao}\n${t.dataTransacao.split(' ').first}",
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),

              const SizedBox(height: 30),

              /// Seção: Micro-hábitos
              Text(
                "Micro-hábitos sugeridos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 12),

              const HabitCard(
                icon: Icons.timer_rounded,
                text: "Espere 10 minutos antes de comprar por impulso.",
              ),
              const HabitCard(
                icon: Icons.self_improvement_rounded,
                text: "Pratique respiração consciente após um gasto alto.",
              ),
              const HabitCard(
                icon: Icons.nightlight_round,
                text: "Evite compras após as 22h.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =============================================
/// GRÁFICO DE PIZZA COM DADOS REAIS DO BANCO
/// =============================================
class PieChartFromDatabase extends StatefulWidget {
  final int idUsuario;
  const PieChartFromDatabase({super.key, required this.idUsuario});

  @override
  State<PieChartFromDatabase> createState() => _PieChartFromDatabaseState();
}

class _PieChartFromDatabaseState extends State<PieChartFromDatabase> {
  final dao = TransacaoDAO();
  Map<String, double> gastosPorCategoria = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarGastos();
  }

  /// Carrega as transações do banco e agrupa por categoria
  Future<void> _carregarGastos() async {
    if (kDebugMode) {
      print('🔄 Carregando transações do banco...');
    }
    try {
      final lista = await dao.listarTransacoes(widget.idUsuario);
      if (kDebugMode) {
        print('📦 Total de transações encontradas: ${lista.length}');
      }

      final Map<String, double> totais = {};

      for (var t in lista) {
        if (t.tipo == 'despesa' && t.valor > 0 && t.categoria.isNotEmpty) {
          totais[t.categoria] = (totais[t.categoria] ?? 0) + t.valor;
        }
      }

      if (kDebugMode) {
        print('📊 Gastos por categoria: $totais');
      }

      setState(() {
        gastosPorCategoria = totais;
        carregando = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao carregar transações: $e');
      }
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (gastosPorCategoria.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum gasto registrado ainda',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final total = gastosPorCategoria.values.fold(0.0, (a, b) => a + b);
    final sections = gastosPorCategoria.entries.map((e) {
      final percentual = (e.value / total) * 100;
      final color = _corAleatoria(e.key);

      return PieChartSectionData(
        value: e.value,
        color: color,
        title: "${e.key}\n${percentual.toStringAsFixed(1)}%",
        radius: 65,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 2),
    );
  }

  Color _corAleatoria(String categoria) {
    final cores = [
      Colors.teal,
      Colors.blueAccent,
      Colors.orange,
      Colors.purple,
      Colors.redAccent,
      Colors.green,
      Colors.pink,
    ];
    final index = categoria.hashCode % cores.length;
    return cores[index];
  }
}

/// =============================================
/// COMPONENTE DE MICRO-HÁBITOS
/// =============================================
class HabitCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const HabitCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
