import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granix/core/theme/app_colors.dart';

class MateriaisScreen extends StatefulWidget {
  const MateriaisScreen({super.key});

  @override
  State<MateriaisScreen> createState() => _MateriaisScreenState();
}

class _MateriaisScreenState extends State<MateriaisScreen> {
  static const _bg = Color(0xFFF1F1F1);
  static const _yellow = Color(0xFFD6E156);
  static const _green = Color(0xFF68A63D);

  bool _menuAberto = false;

  void _abrirDialogInformarCodigo() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.72),
      builder: (_) => const _InformarMaterialDialog(),
    );
  }

  void _abrirLeitorCodigo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _LeitorCodigoScreen(),
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
          'MATERIAIS',
          style: TextStyle(
            fontSize: 21,
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
      ),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Nenhum registro encontrado!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
          if (_menuAberto)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _menuAberto = false),
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 210,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (_menuAberto) ...[
              Positioned(
                bottom: 118,
                right: 0,
                child: _ActionBubble(
                  label: 'Informar Código',
                  color: _yellow,
                  icon: Icons.keyboard_alt_outlined,
                  onTap: () {
                    setState(() => _menuAberto = false);
                    _abrirDialogInformarCodigo();
                  },
                ),
              ),
              Positioned(
                bottom: 52,
                right: 0,
                child: _ActionBubble(
                  label: 'Ler Código',
                  color: _green,
                  icon: Icons.qr_code_2,
                  onTap: () {
                    setState(() => _menuAberto = false);
                    _abrirLeitorCodigo();
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  heroTag: 'fab-close-materiais',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 6,
                  onPressed: () => setState(() => _menuAberto = false),
                  child: const Icon(Icons.close, size: 34),
                ),
              ),
            ] else
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  heroTag: 'fab-menu-materiais',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 6,
                  onPressed: () => setState(() => _menuAberto = true),
                  child: const Icon(Icons.menu, size: 34),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBubble({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: null,
          mini: false,
          backgroundColor: color,
          foregroundColor: Colors.black,
          elevation: 6,
          onPressed: onTap,
          child: Icon(icon, size: 34),
        ),
      ],
    );
  }
}

class _InformarMaterialDialog extends StatefulWidget {
  const _InformarMaterialDialog();

  @override
  State<_InformarMaterialDialog> createState() => _InformarMaterialDialogState();
}

class _InformarMaterialDialogState extends State<_InformarMaterialDialog> {
  final _codigoCtrl = TextEditingController();

  @override
  void dispose() {
    _codigoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF7F7F7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF7C96A5), width: 1.3),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Informar Material',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _codigoCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8E8E8E),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFB8B8B8),
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6E156),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ENVIAR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: Color(0xFFBFC5C9),
                  size: 34,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeitorCodigoScreen extends StatelessWidget {
  const _LeitorCodigoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0B0F18).withOpacity(0.82),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 290,
                    height: 190,
                    child: CustomPaint(
                      painter: _ScannerPainter(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.transparent;

    final greenPaint = Paint()
      ..color = const Color(0xFF9BFF32)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final redPaint = Paint()
      ..color = const Color(0xFFFF4C39)
      ..strokeWidth = 2;

    canvas.drawRect(Offset.zero & size, overlayPaint);

    const corner = 28.0;

    // topo esquerdo
    canvas.drawLine(const Offset(0, corner), const Offset(0, 0), greenPaint);
    canvas.drawLine(const Offset(0, 0), const Offset(corner, 0), greenPaint);

    // topo direito
    canvas.drawLine(
      Offset(size.width - corner, 0),
      Offset(size.width, 0),
      greenPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, corner),
      greenPaint,
    );

    // baixo esquerdo
    canvas.drawLine(
      Offset(0, size.height - corner),
      Offset(0, size.height),
      greenPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(corner, size.height),
      greenPaint,
    );

    // baixo direito
    canvas.drawLine(
      Offset(size.width - corner, size.height),
      Offset(size.width, size.height),
      greenPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - corner),
      Offset(size.width, size.height),
      greenPaint,
    );

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
