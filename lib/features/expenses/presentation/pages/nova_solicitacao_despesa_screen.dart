import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granix/core/theme/app_colors.dart';

class NovaSolicitacaoDespesaScreen extends StatefulWidget {
  const NovaSolicitacaoDespesaScreen({super.key});

  @override
  State<NovaSolicitacaoDespesaScreen> createState() =>
      _NovaSolicitacaoDespesaScreenState();
}

class _NovaSolicitacaoDespesaScreenState
    extends State<NovaSolicitacaoDespesaScreen> {
  static const _bg = Color(0xFFF1F1F1);
  static const _line = Color(0xFFB8B8B8);
  static const _label = Color(0xFF9B9B9B);
  static const _text = Color(0xFF5C5C5C);
  static const _button = Color(0xFF97C46C);

  final _cnpjCtrl = TextEditingController();
  final _fornecedorCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _motivoCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();
  final _valorCtrl = TextEditingController(text: 'R\$ 0,00');

  String _categoria = '';
  String _tipoSolicitacao = 'ABASTECIMENTO';
  final String _dataSolicitacao = '14/04/2026';

  @override
  void dispose() {
    _cnpjCtrl.dispose();
    _fornecedorCtrl.dispose();
    _cidadeCtrl.dispose();
    _motivoCtrl.dispose();
    _obsCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
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
          'NOVA SOLICITAÇÃO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _LineField(
                    label: 'CNPJ Fornecedor',
                    controller: _cnpjCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  width: 72,
                  height: 72,
                  color: _button,
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            _LineField(
              label: 'Fornecedor',
              controller: _fornecedorCtrl,
            ),
            const SizedBox(height: 24),
            _LineField(
              label: 'Cidade - UF',
              controller: _cidadeCtrl,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _DropdownLineField(
                    label: 'Categoria',
                    value: _categoria,
                    items: const ['', 'ALIMENTAÇÃO', 'COMBUSTÍVEL', 'OUTROS'],
                    onChanged: (v) => setState(() => _categoria = v ?? ''),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _DropdownLineField(
                    label: 'Tipo da Solicitação',
                    value: _tipoSolicitacao,
                    items: const [
                      'ABASTECIMENTO',
                      'ADIANTAMENTO',
                      'REEMBOLSO',
                    ],
                    onChanged: (v) =>
                        setState(() => _tipoSolicitacao = v ?? 'ABASTECIMENTO'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ReadOnlyLineField(
                    label: 'Data da Solicitação',
                    value: _dataSolicitacao,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _LineField(
                    label: 'Valor',
                    controller: _valorCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _LineField(
              label: 'Motivo que não houve embarque',
              controller: _motivoCtrl,
            ),
            const SizedBox(height: 24),
            _LineField(
              label: 'Observações',
              controller: _obsCtrl,
              maxLength: 50,
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                '0/50',
                style: TextStyle(
                  fontSize: 12,
                  color: _text,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _button,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'SOLICITAR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const _LineField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: _NovaSolicitacaoDespesaScreenState._text,
      ),
      decoration: const InputDecoration().copyWith(
        labelText: label,
        counterText: '',
        labelStyle: const TextStyle(
          fontSize: 16,
          color: _NovaSolicitacaoDespesaScreenState._label,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          color: _NovaSolicitacaoDespesaScreenState._label,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _NovaSolicitacaoDespesaScreenState._line,
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
    );
  }
}

class _ReadOnlyLineField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyLineField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: _NovaSolicitacaoDespesaScreenState._text,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: _NovaSolicitacaoDespesaScreenState._label,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          color: _NovaSolicitacaoDespesaScreenState._label,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _NovaSolicitacaoDespesaScreenState._line,
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
    );
  }
}

class _DropdownLineField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownLineField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          fontSize: 16,
          color: _NovaSolicitacaoDespesaScreenState._label,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _NovaSolicitacaoDespesaScreenState._line,
            width: 1,
          ),
        ),
      ).copyWith(labelText: label),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_drop_down, color: _NovaSolicitacaoDespesaScreenState._text),
        style: const TextStyle(
          fontSize: 17,
          color: _NovaSolicitacaoDespesaScreenState._text,
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
                    fontWeight: FontWeight.w400,
                    color: _NovaSolicitacaoDespesaScreenState._text,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
