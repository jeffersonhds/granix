import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/despesas/presentation/nova_solicitacao_despesa_screen.dart';

class SolicitacaoDespesasScreen extends StatefulWidget {
  const SolicitacaoDespesasScreen({super.key});

  @override
  State<SolicitacaoDespesasScreen> createState() =>
      _SolicitacaoDespesasScreenState();
}

class _SolicitacaoDespesasScreenState extends State<SolicitacaoDespesasScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _bg = Color(0xFFF1F1F1);
  static const _tabLine = Color(0xFF6F9A46);
  static const _fab = Color(0xFF97C46C);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _emptyBody() {
    return const Center(
      child: Text(
        'Nenhuma solicitação encontrada!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SOLICITAÇÃO DE DESPESAS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: _tabLine,
              indicatorWeight: 4,
              labelColor: _tabLine,
              unselectedLabelColor: const Color(0xFFC8C8C8),
              labelStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: 'SOLICITAÇÕES'),
                Tab(text: 'APROVAÇÕES'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _emptyBody(),
          _emptyBody(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _fab,
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NovaSolicitacaoDespesaScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 36),
      ),
    );
  }
}
