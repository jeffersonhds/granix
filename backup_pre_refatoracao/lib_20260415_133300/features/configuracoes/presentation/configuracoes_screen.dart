import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  static const _bg = Color(0xFFF1F1F1);
  static const _line = Color(0xFFB8B8B8);
  static const _label = Color(0xFF9B9B9B);
  static const _text = Color(0xFF5C5C5C);
  static const _button = Color(0xFF6C9C47);
  static const _buttonLight = Color(0xFF97C46C);
  static const _danger = Color(0xFFFF4A3D);

  String _dispositivo = '-';
  String _versaoImpressao = 'Nova';
  String _tamanhoImpressao = '80mm';
  String _metodoQrCode = 'Imagem';
  String _metodoCodigoBarras = 'Imagem';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CONFIGURAÇÕES',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: _button,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'Por favor, tenha certeza que o Bluetooth esteja ligado e\nque a impressora já tenha sido pareada nas configurações\ndo aparelho!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Dispositivos Diponíveis',
              style: TextStyle(
                fontSize: 16,
                color: _label,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _dispositivo,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _line, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: _text),
                    style: const TextStyle(
                      fontSize: 18,
                      color: _text,
                    ),
                    items: const [
                      DropdownMenuItem(value: '-', child: Text('-')),
                      DropdownMenuItem(value: 'Printer 01', child: Text('Printer 01')),
                      DropdownMenuItem(value: 'Printer 02', child: Text('Printer 02')),
                    ],
                    onChanged: (v) => setState(() => _dispositivo = v ?? '-'),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 72,
                  height: 72,
                  color: _button,
                  child: const Icon(Icons.refresh, color: Colors.white, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonLight,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'SELECIONAR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: _InfoBlock(
                    titulo: 'Impressora',
                    valor: '--',
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: _InfoBlock(
                    titulo: 'Endereço',
                    valor: '--',
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 68,
                  height: 68,
                  color: _danger,
                  child: const Icon(Icons.close, color: Colors.white, size: 36),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SelectLine(
                    label: 'Versão de Impressão',
                    value: _versaoImpressao,
                    items: const ['Nova', 'Antiga'],
                    onChanged: (v) =>
                        setState(() => _versaoImpressao = v ?? 'Nova'),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _SelectLine(
                    label: 'Tamanho da Impressão',
                    value: _tamanhoImpressao,
                    items: const ['80mm', '58mm'],
                    onChanged: (v) =>
                        setState(() => _tamanhoImpressao = v ?? '80mm'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SelectLine(
                    label: 'Método Impressão QRCode',
                    value: _metodoQrCode,
                    items: const ['Normal', 'Imagem'],
                    onChanged: (v) =>
                        setState(() => _metodoQrCode = v ?? 'Imagem'),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _SelectLine(
                    label: 'Método Impressão Código de B...',
                    value: _metodoCodigoBarras,
                    items: const ['Normal', 'Imagem'],
                    onChanged: (v) => setState(
                      () => _metodoCodigoBarras = v ?? 'Imagem',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String titulo;
  final String valor;

  const _InfoBlock({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            color: _ConfiguracoesScreenState._text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            color: _ConfiguracoesScreenState._button,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _SelectLine extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _SelectLine({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: _ConfiguracoesScreenState._label,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 14,
          color: _ConfiguracoesScreenState._label,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _ConfiguracoesScreenState._line,
            width: 1,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.2,
          ),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: _ConfiguracoesScreenState._text),
      style: const TextStyle(
        fontSize: 17,
        color: _ConfiguracoesScreenState._text,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  color: _ConfiguracoesScreenState._text,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
