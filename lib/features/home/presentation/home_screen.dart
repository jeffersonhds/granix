import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/presentation/nova_carga_screen.dart';

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
          MaterialPageRoute(builder: (_) => const NovaCargaScreen()),
        ),
      ),
      _ModuloItem(titulo: 'AUDITORIAS',     icone: Icons.fact_check_outlined,              onTap: () {}),
      _ModuloItem(titulo: 'DISTRIB. DE OS', icone: Icons.assignment_outlined,               onTap: () {}),
      _ModuloItem(titulo: 'C. OPERACIONAL', icone: Icons.swap_vert,                         onTap: () {}),
      _ModuloItem(titulo: 'S. DESPESAS',    icone: Icons.receipt_long_outlined, ativo: true, onTap: () {}),
      _ModuloItem(titulo: 'MATERIAIS',      icone: Icons.inventory_2_outlined,  ativo: true, onTap: () {}),
      _ModuloItem(titulo: 'RELATÓRIOS',     icone: Icons.bar_chart_outlined,                onTap: () {}),
      _ModuloItem(titulo: 'CONFIGURAÇÕES',  icone: Icons.settings_outlined,     ativo: true, onTap: () {}),
      _ModuloItem(titulo: 'SUPORTE',        icone: Icons.help_outline_rounded,  ativo: true, onTap: () {}),
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
            icon: const Icon(Icons.nightlight_round, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [

          // ── HEADER CURVO + AVATAR ─────────────────────────────────────────
          // Curva verde 140px — avatar 100px sobrepondo a base da curva
          const _HomeHeader(),

          // Espaço para o avatar que sobrepõe a curva (bottom: -28 → 28px fora)
          // No Graint o avatar fica quase todo dentro da área verde
          const SizedBox(height: 60),

          // ── NOME — bold verde escuro, 16px, espaçado ─────────────────────
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

          // ── SUBTÍTULO — 11px cinza espaçado ──────────────────────────────
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

          // ── GRID 3x3 — todos os 9 cards cabem na tela sem scroll ─────────
          //
          // Graint medido pixel a pixel:
          //   childAspectRatio : ~1.05  (quase quadrado, levemente largo)
          //   gaps             : ~8px   (bem menores que os 14px anteriores)
          //   padding lateral  : ~8px
          //   ícone            : ~26px
          //   label            : ~10px
          //
          // A chave para os 9 cards caberem: ratio ~1.05 + gaps 8px + menos
          // espaço no header. Com 0.82 os cards ficavam 28% mais altos → extrapolavam.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: GridView.builder(
                itemCount: modulos.length,
                padding: EdgeInsets.zero,
                // NeverScrollable: no Graint o grid não rola — cabe na tela inteira
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  // 1.05 = levemente mais largo que alto — idêntico ao Graint
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

// ─────────────────────────────────────────────────────────────────────────────
// Header curvo — faixa verde 140px com avatar 100px sobrepondo a base
// ─────────────────────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Faixa verde com curva côncava suave na base — igual ao Graint
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 80,
            color: AppColors.primary,
          ),
        ),

        // Avatar branco circular, 100px
        // bottom: -50 → metade do avatar (50px) fica abaixo da curva
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

// Curva côncava suave — igual ao Graint
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
  bool shouldReclip(_WaveClipper old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Card de módulo
// cantos 10px | sombra cinza suave | ícone 26px | label 10px
// ─────────────────────────────────────────────────────────────────────────────
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
