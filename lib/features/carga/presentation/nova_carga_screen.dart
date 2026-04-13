import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/data/carga_memory_repository.dart';
import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:granix/features/carga/presentation/cargas_screen.dart';

const _kBg = Colors.white;
const _kSurface = Colors.white;
const _kLine = Color(0xFFBDBDBD);
const _kLabel = Color(0xFF8B8B8B);
const _kText = Color(0xFF4A4A4A);
const _kSectionBar = Color(0xFFADADAD);
const _kSectionText = Colors.white;

class NovaCargaScreen extends StatefulWidget {
  final CargaModel? cargaParaEditar;
  final int? indiceEdicao;
  final CargaModel? cargaParaDuplicar;

  const NovaCargaScreen({
    super.key,
    this.cargaParaEditar,
    this.indiceEdicao,
    this.cargaParaDuplicar,
  });

  @override
  State<NovaCargaScreen> createState() => _NovaCargaScreenState();
}

class _NovaCargaScreenState extends State<NovaCargaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _laudoCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _placaCtrl = TextEditingController();
  final _pesoBrutoCtrl = TextEditingController();
  final _pesoTaraCtrl = TextEditingController();
  final _pesoLiquidoCtrl = TextEditingController();
  final _ordemCarregamentoCtrl = TextEditingController();
  final _notaFiscalCtrl = TextEditingController();
  final _cfopCtrl = TextEditingController();
  final _dataEmissaoNfCtrl = TextEditingController();
  final _valorUnitarioCtrl = TextEditingController();
  final _valorTotalCtrl = TextEditingController();
  final _chaveNfeCtrl = TextEditingController();
  final _transportadoraCtrl = TextEditingController();
  final _aceitoPorCtrl = TextEditingController();

  bool _insetosVivos = false;
  bool _insetosMortos = false;
  bool _odorEstranho = false;
  bool _sementesToxicas = false;

  final _umidadeCtrl = TextEditingController();
  final _materiasImpCtrl = TextEditingController();
  final _quebradosCtrl = TextEditingController();
  final _mofadosCtrl = TextEditingController();
  final _totalAvariadosCtrl = TextEditingController();
  final _queimadosCtrl = TextEditingController();
  final _ardidosCtrl = TextEditingController();
  final _esverdeadosCtrl = TextEditingController();
  final _fermentadosCtrl = TextEditingController();
  final _germinadosCtrl = TextEditingController();
  final _picadosCtrl = TextEditingController();
  final _observacoesCtrl = TextEditingController();

  String? _veiculoVistoriado = 'SIM';
  String _produtoBase = 'Soja';
  String? _tipoProduto = 'OGM - Intacta Declarado';

  bool get _isEdicao =>
      widget.cargaParaEditar != null && widget.indiceEdicao != null;
  bool get _isDuplicacao => widget.cargaParaDuplicar != null;

  List<String> get _tiposSoja => const [
        'OGM - Intacta Declarado',
        'OGM - Intacta Negativo',
        'OGM - Intacta Participante',
        'OGM - Intacta Positivo',
        'Convencional',
        'Não Testado',
        'Aflatoxina negativa',
        'Aflatoxina < 20 ppb Qualitativo',
        'Aflatoxina 20 > ppb Qualitativo',
      ];

  List<String> get _tiposMilho => const [
        'Milho - OGM',
        'Milho - Convencional',
        'Milho - Não Testado',
      ];

  List<String> get _tiposProduto =>
      _produtoBase == 'Milho' ? _tiposMilho : _tiposSoja;

  @override
  void initState() {
    super.initState();
    if (_isEdicao) {
      _preencher(widget.cargaParaEditar!);
    } else if (_isDuplicacao) {
      _preencher(widget.cargaParaDuplicar!);
      _laudoCtrl.text = _gerarLaudo();
      _dataCtrl.text = _dataHoje();
    } else {
      _laudoCtrl.text = _gerarLaudo();
      _dataCtrl.text = _dataHoje();
      _preencherZeros();
    }

    _pesoBrutoCtrl.addListener(_calcPesoLiquido);
    _pesoTaraCtrl.addListener(_calcPesoLiquido);
    _ardidosCtrl.addListener(_calcTotalAvariados);
    _queimadosCtrl.addListener(_calcTotalAvariados);
    _mofadosCtrl.addListener(_calcTotalAvariados);
    _fermentadosCtrl.addListener(_calcTotalAvariados);
    _germinadosCtrl.addListener(_calcTotalAvariados);
  }

  void _preencherZeros() {
    for (final c in [
      _umidadeCtrl,
      _materiasImpCtrl,
      _quebradosCtrl,
      _mofadosCtrl,
      _totalAvariadosCtrl,
      _queimadosCtrl,
      _ardidosCtrl,
      _esverdeadosCtrl,
      _fermentadosCtrl,
      _germinadosCtrl,
      _picadosCtrl,
    ]) {
      c.text = '0,00';
    }
  }

  String _gerarLaudo() {
    final r = Random.secure();
    return List.generate(20, (_) => r.nextInt(10)).join();
  }

  String _dataHoje() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  double _toDouble(String v) =>
      double.tryParse(v.replaceAll(',', '.').trim()) ?? 0.0;

  void _calcPesoLiquido() {
    final l = _toDouble(_pesoBrutoCtrl.text) - _toDouble(_pesoTaraCtrl.text);
    _pesoLiquidoCtrl.text = l < 0 ? '0.00' : l.toStringAsFixed(2);
  }

  void _calcTotalAvariados() {
    if (_produtoBase == 'Milho') return;
    final t = _toDouble(_ardidosCtrl.text) +
        _toDouble(_queimadosCtrl.text) +
        _toDouble(_mofadosCtrl.text) +
        _toDouble(_fermentadosCtrl.text) +
        _toDouble(_germinadosCtrl.text);
    _totalAvariadosCtrl.text = t.toStringAsFixed(2);
  }

  void _preencher(CargaModel c) {
    _laudoCtrl.text = c.laudo;
    _dataCtrl.text = c.dataClassificacao;
    _placaCtrl.text = c.placa;
    _pesoBrutoCtrl.text = c.pesoBruto;
    _pesoTaraCtrl.text = c.pesoTara;
    _pesoLiquidoCtrl.text = c.pesoLiquido;
    _ordemCarregamentoCtrl.text = c.ordemCarregamento;
    _notaFiscalCtrl.text = c.notaFiscal;
    _cfopCtrl.text = c.cfop;
    _dataEmissaoNfCtrl.text = c.dataEmissaoNf;
    _valorUnitarioCtrl.text = c.valorUnitario;
    _valorTotalCtrl.text = c.valorTotal;
    _chaveNfeCtrl.text = c.chaveNfe;
    _transportadoraCtrl.text = c.transportadora;
    _aceitoPorCtrl.text = c.aceitoPor;
    _umidadeCtrl.text = c.umidade.isEmpty ? '0,00' : c.umidade;
    _materiasImpCtrl.text = c.materiasImp.isEmpty ? '0,00' : c.materiasImp;
    _quebradosCtrl.text = c.quebrados.isEmpty ? '0,00' : c.quebrados;
    _mofadosCtrl.text = c.mofados.isEmpty ? '0,00' : c.mofados;
    _totalAvariadosCtrl.text =
        c.totalAvariados.isEmpty ? '0,00' : c.totalAvariados;
    _queimadosCtrl.text = c.queimados.isEmpty ? '0,00' : c.queimados;
    _ardidosCtrl.text = c.ardidos.isEmpty ? '0,00' : c.ardidos;
    _esverdeadosCtrl.text = c.esverdeados.isEmpty ? '0,00' : c.esverdeados;
    _fermentadosCtrl.text = c.fermentados.isEmpty ? '0,00' : c.fermentados;
    _germinadosCtrl.text = c.germinados.isEmpty ? '0,00' : c.germinados;
    _picadosCtrl.text = c.picados.isEmpty ? '0,00' : c.picados;
    _observacoesCtrl.text = c.observacoes;

    _insetosVivos = c.insetosVivos;
    _insetosMortos = c.insetosMortos;
    _odorEstranho = c.odorEstranho;
    _sementesToxicas = c.sementesToxicas;

    final tipo = c.tipoProduto;
    _produtoBase = tipo.toLowerCase().contains('milho') ? 'Milho' : 'Soja';
    _tipoProduto = _tiposProduto.contains(tipo) ? tipo : _tiposProduto.first;
    _veiculoVistoriado =
        c.veiculoVistoriado.isEmpty ? 'SIM' : c.veiculoVistoriado;
  }

  @override
  void dispose() {
    for (final c in [
      _laudoCtrl,
      _dataCtrl,
      _placaCtrl,
      _pesoBrutoCtrl,
      _pesoTaraCtrl,
      _pesoLiquidoCtrl,
      _ordemCarregamentoCtrl,
      _notaFiscalCtrl,
      _cfopCtrl,
      _dataEmissaoNfCtrl,
      _valorUnitarioCtrl,
      _valorTotalCtrl,
      _chaveNfeCtrl,
      _transportadoraCtrl,
      _aceitoPorCtrl,
      _umidadeCtrl,
      _materiasImpCtrl,
      _quebradosCtrl,
      _mofadosCtrl,
      _totalAvariadosCtrl,
      _queimadosCtrl,
      _ardidosCtrl,
      _esverdeadosCtrl,
      _fermentadosCtrl,
      _germinadosCtrl,
      _picadosCtrl,
      _observacoesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final carga = CargaModel(
      laudo: _laudoCtrl.text.trim(),
      dataClassificacao: _dataCtrl.text.trim(),
      placa: _placaCtrl.text.trim(),
      pesoBruto: _pesoBrutoCtrl.text.trim(),
      pesoTara: _pesoTaraCtrl.text.trim(),
      pesoLiquido: _pesoLiquidoCtrl.text.trim(),
      ordemCarregamento: _ordemCarregamentoCtrl.text.trim(),
      veiculoVistoriado: _veiculoVistoriado ?? '',
      tipoProduto: _tipoProduto ?? '',
      notaFiscal: _notaFiscalCtrl.text.trim(),
      cfop: _cfopCtrl.text.trim(),
      dataEmissaoNf: _dataEmissaoNfCtrl.text.trim(),
      valorUnitario: _valorUnitarioCtrl.text.trim(),
      valorTotal: _valorTotalCtrl.text.trim(),
      chaveNfe: _chaveNfeCtrl.text.trim(),
      transportadora: _transportadoraCtrl.text.trim(),
      aceitoPor: _aceitoPorCtrl.text.trim(),
      insetosVivos: _insetosVivos,
      insetosMortos: _insetosMortos,
      odorEstranho: _odorEstranho,
      sementesToxicas: _sementesToxicas,
      umidade: _umidadeCtrl.text.trim(),
      materiasImp: _materiasImpCtrl.text.trim(),
      quebrados: _quebradosCtrl.text.trim(),
      mofados: _mofadosCtrl.text.trim(),
      totalAvariados: _totalAvariadosCtrl.text.trim(),
      queimados: _queimadosCtrl.text.trim(),
      ardidos: _ardidosCtrl.text.trim(),
      esverdeados: _esverdeadosCtrl.text.trim(),
      fermentados: _fermentadosCtrl.text.trim(),
      germinados: _germinadosCtrl.text.trim(),
      picados: _picadosCtrl.text.trim(),
      observacoes: _observacoesCtrl.text.trim(),
    );

    if (_isEdicao) await CargaMemoryRepository.removeAt(widget.indiceEdicao!);
    await CargaMemoryRepository.add(carga);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdicao
                ? 'Carga atualizada.'
                : _isDuplicacao
                    ? 'Carga duplicada.'
                    : 'Carga salva.',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CargasScreen()),
      );
    }
  }

  String get _lC1 => _produtoBase == 'Milho' ? 'Danificados' : 'Quebrados';
  String get _lC2 => _produtoBase == 'Milho' ? 'Quebrados' : 'Mofados';
  String get _lC3 =>
      _produtoBase == 'Milho' ? 'Avariados' : 'Total de Avariados';
  String get _lC4 => _produtoBase == 'Milho' ? 'Gessado' : 'Queimados';
  String get _lC5 => _produtoBase == 'Milho' ? 'Mofados' : 'Ardidos';
  String get _lC6 => _produtoBase == 'Milho' ? 'Fermentados' : 'Esverdeados';
  String get _lC7 => _produtoBase == 'Milho' ? 'Ardidos' : 'Fermentados';
  String get _lC8 => 'Germinados';
  String get _lC9 => _produtoBase == 'Milho' ? 'Carunchados' : 'Picados';

  @override
  Widget build(BuildContext context) {
    final titulo = _isEdicao
        ? 'Editar Carga'
        : _isDuplicacao
            ? 'Duplicar Carga'
            : 'Nova Carga';

    final textoBotao = _isEdicao
        ? 'ATUALIZAR'
        : _isDuplicacao
            ? 'SALVAR CÓPIA'
            : 'SALVAR';

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB7C853),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FlatField(
                label: 'Laudo',
                ctrl: _laudoCtrl,
                readOnly: true,
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'Data de Class.',
                  ctrl: _dataCtrl,
                  readOnly: true,
                ),
                _FlatField(
                  label: 'Placa',
                  ctrl: _placaCtrl,
                  required: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    LengthLimitingTextInputFormatter(8),
                    _UpperCase(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'Peso Bruto',
                  ctrl: _pesoBrutoCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: 'Peso Tara',
                  ctrl: _pesoTaraCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'Peso',
                  ctrl: _pesoLiquidoCtrl,
                  readOnly: true,
                ),
                _FlatField(
                  label: 'Ordem Carregamento',
                  ctrl: _ordemCarregamentoCtrl,
                ),
              ),
              const SizedBox(height: 12),
              _FlatChoiceField(
                label: 'Veículo Vistoriado?',
                child: _SimpleDropdown(
                  value: _veiculoVistoriado,
                  items: const ['SIM', 'NÃO'],
                  onChanged: (v) => setState(() => _veiculoVistoriado = v),
                ),
              ),
              const SizedBox(height: 12),
              _FlatChoiceField(
                label: 'Produto',
                child: _SimpleDropdown(
                  value: _produtoBase,
                  items: const ['Soja', 'Milho'],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _produtoBase = v;
                      _tipoProduto = _tiposProduto.first;
                      if (_produtoBase == 'Milho') {
                        _totalAvariadosCtrl.text = '0,00';
                      } else {
                        _calcTotalAvariados();
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _FlatChoiceField(
                label: 'Tipo do Produto',
                child: _SimpleDropdown(
                  value: _tipoProduto,
                  items: _tiposProduto,
                  onChanged: (v) => setState(() => _tipoProduto = v),
                ),
              ),

              const SizedBox(height: 18),
              const _SectionBar(title: 'NOTAS'),
              const SizedBox(height: 12),

              _FlatField(
                label: 'Nota Fiscal',
                ctrl: _notaFiscalCtrl,
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'CFOP',
                  ctrl: _cfopCtrl,
                ),
                _FlatField(
                  label: 'Data de Emissão da N.F.',
                  ctrl: _dataEmissaoNfCtrl,
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'Valor Unitário',
                  ctrl: _valorUnitarioCtrl,
                  prefixText: 'R\$ ',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: 'Valor Total',
                  ctrl: _valorTotalCtrl,
                  prefixText: 'R\$ ',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _BarcodeField(
                label: 'Chave NF-e Produtor',
                ctrl: _chaveNfeCtrl,
                hint: '0/44',
              ),

              const SizedBox(height: 18),
              const _SectionBar(title: 'TRANSPORTE'),
              const SizedBox(height: 12),

              _FlatField(
                label: 'Transportadora',
                ctrl: _transportadoraCtrl,
              ),

              const SizedBox(height: 18),
              const _SectionBar(title: 'CLASSIFICAÇÃO'),
              const SizedBox(height: 12),

              _FlatField(
                label: 'Aceito Por',
                ctrl: _aceitoPorCtrl,
              ),
              const SizedBox(height: 10),

              _BoolChoiceRow(
                label: 'Insetos Vivos?',
                value: _insetosVivos,
                onChanged: (v) => setState(() => _insetosVivos = v),
              ),
              const SizedBox(height: 10),
              _BoolChoiceRow(
                label: 'Insetos Mortos?',
                value: _insetosMortos,
                onChanged: (v) => setState(() => _insetosMortos = v),
              ),
              const SizedBox(height: 10),
              _BoolChoiceRow(
                label: 'Odor Estranho?',
                value: _odorEstranho,
                onChanged: (v) => setState(() => _odorEstranho = v),
              ),
              const SizedBox(height: 10),
              _BoolChoiceRow(
                label: 'Sementes Tóxicas?',
                value: _sementesToxicas,
                onChanged: (v) => setState(() => _sementesToxicas = v),
              ),

              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: 'Umidade',
                  ctrl: _umidadeCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: 'Matérias E. e Imp.',
                  ctrl: _materiasImpCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: _lC1,
                  ctrl: _quebradosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: _lC2,
                  ctrl: _mofadosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: _lC3,
                  ctrl: _totalAvariadosCtrl,
                  readOnly: _produtoBase == 'Soja',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: _lC4,
                  ctrl: _queimadosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: _lC5,
                  ctrl: _ardidosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: _lC6,
                  ctrl: _esverdeadosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _row(
                _FlatField(
                  label: _lC7,
                  ctrl: _fermentadosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                _FlatField(
                  label: _lC8,
                  ctrl: _germinadosCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 12),
              _FlatField(
                label: _lC9,
                ctrl: _picadosCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              _FlatField(
                label: 'Observações',
                ctrl: _observacoesCtrl,
                maxLines: 3,
                maxLength: 100,
              ),

              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB7C853),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: Text(
                    textoBotao,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(Widget l, Widget r) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: l),
          const SizedBox(width: 18),
          Expanded(child: r),
        ],
      );
}

class _SectionBar extends StatelessWidget {
  final String title;

  const _SectionBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      color: _kSectionBar,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _kSectionText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _FlatField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool readOnly;
  final bool required;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final String? hint;
  final String? prefixText;

  const _FlatField({
    required this.label,
    required this.ctrl,
    this.readOnly = false,
    this.required = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.hint,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null
          : null,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: readOnly ? _kLabel : _kText,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        counterText: '',
        isDense: true,
        filled: true,
        fillColor: _kSurface,
        contentPadding: const EdgeInsets.only(top: 12, bottom: 8),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _kLabel,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _kLabel,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _kLine, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.2),
        ),
      ),
    );
  }
}

class _FlatChoiceField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FlatChoiceField({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        filled: true,
        fillColor: _kSurface,
        isDense: true,
        contentPadding: EdgeInsets.only(top: 12, bottom: 8),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _kLine, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _kLabel,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _SimpleDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;

  const _SimpleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.arrow_drop_down, color: _kLabel, size: 22),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: _kText,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: _kText,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _BoolChoiceRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BoolChoiceRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        filled: true,
        fillColor: _kSurface,
        isDense: true,
        contentPadding: EdgeInsets.only(top: 10, bottom: 6),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _kLine, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _kLabel,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _ChoiceChipMini(
                text: 'SIM',
                selected: value,
                onTap: () => onChanged(true),
              ),
              const SizedBox(width: 8),
              _ChoiceChipMini(
                text: 'NÃO',
                selected: !value,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoiceChipMini extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChipMini({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE9EDCF) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD0D0D0),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : _kLabel,
          ),
        ),
      ),
    );
  }
}

class _BarcodeField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;

  const _BarcodeField({
    required this.label,
    required this.ctrl,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        filled: true,
        fillColor: _kSurface,
        isDense: true,
        contentPadding: EdgeInsets.only(top: 12, bottom: 8),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _kLine, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              maxLength: 44,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: _kText,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                counterText: '',
                isDense: true,
                filled: true,
                fillColor: _kSurface,
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _kLabel,
                ),
                floatingLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _kLabel,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Icon(
              Icons.qr_code_2,
              color: _kText,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue o,
    TextEditingValue n,
  ) =>
      n.copyWith(text: n.text.toUpperCase());
}
