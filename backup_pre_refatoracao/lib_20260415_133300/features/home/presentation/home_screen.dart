import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/presentation/cargas_screen.dart';
import 'package:granix/features/configuracoes/presentation/configuracoes_screen.dart';
import 'package:granix/features/despesas/presentation/solicitacao_despesas_screen.dart';
import 'package:granix/features/materiais/presentation/materiais_screen.dart';
import 'package:granix/features/suporte/presentation/suporte_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modulos = <_ModuloItem>[
      _ModuloItem(
        titulo: 'CLASSIFICAÇÃO',
        icone: Icons.grain,
        ativo: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CargasScreen()),
        ),
      ),
      _ModuloItem(
        titulo: 'AUDITORIAS',
        icone: Icons.fact_check_outlined,
        onTap: () {},
      ),
      _ModuloItem(
        titulo: 'DISTRIB. DE OS',
        icone: Icons.assignment_outlined,
        onTap: () {},
      ),
      _ModuloItem(
        titulo: 'C. OPERACIONAL',
        icone: Icons.swap_vert,
        onTap: () {},
      ),
      _ModuloItem(
        titulo: 'S. DESPESAS',
        icone: Icons.receipt_long_outlined,
        ativo: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SolicitacaoDespesasScreen(),
          ),
        ),
      ),
      _ModuloItem(
        titulo: 'MATERIAIS',
        icone: Icons.inventory_2_outlined,
        ativo: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MateriaisScreen()),
        ),
      ),
      _ModuloItem(
        titulo: 'RELATÓRIOS',
        icone: Icons.bar_chart_outlined,
        onTap: () {},
      ),
      _ModuloItem(
        titulo: 'CONFIGURAÇÕES',
        icone: Icons.settings_outlined,
        ativo: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ConfiguracoesScreen(),
          ),
        ),
      ),
      _ModuloItem(
        titulo: 'SUPORTE',
        icone: Icons.help_outline_rounded,
        ativo: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SuporteScreen()),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F1),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () {},
        ),
        title: const Text(
          'GRANIX',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const _HomeHeader(),
          const SizedBox(height: 60),
          const Text(
            'JEFFERSON HENRIQUE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF3A5410),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'SAPEZAL / MATO GROSSO - MT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: GridView.builder(
                itemCount: modulos.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  childAspectRatio: 1.33,
                ),
                itemBuilder: (ctx, i) => _ModuloCard(item: modulos[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 80,
            color: AppColors.primary,
          ),
        ),
        Positioned(
          bottom: -50,
          child: Container(
            width: 115,
            height: 115,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.grain,
                size: 63,
                color: AppColors.primary.withOpacity(0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.lineTo(0, size.height - 40);
    p.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => false;
}

class _ModuloCard extends StatelessWidget {
  final _ModuloItem item;

  const _ModuloCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.20),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icone,
                size: 26,
                color: item.ativo
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.38),
              ),
              const SizedBox(height: 6),
              Text(
                item.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: item.ativo
                      ? AppColors.primary
                      : AppColors.textSecondary.withOpacity(0.38),
                  letterSpacing: 0.1,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuloItem {
  final String titulo;
  final IconData icone;
  final bool ativo;
  final VoidCallback onTap;

  _ModuloItem({
    required this.titulo,
    required this.icone,
    this.ativo = false,
    required this.onTap,
  });
}
