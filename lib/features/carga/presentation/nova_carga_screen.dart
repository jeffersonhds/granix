import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/data/carga_memory_repository.dart';
import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:granix/features/carga/presentation/cargas_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Cores locais — idênticas ao Graint
// ─────────────────────────────────────────────────────────────────────────────
const _kBg        = Color(0xFFF0F0EC); // fundo off-white igual ao Graint
const _kCard      = Colors.white;
const _kBorder    = Color(0xFFE5E5E5); // borda outline dos campos
const _kLabel     = Color(0xFF888888); // label/hint cinza
const _kSection   = Color(0xFF555555); // título de seção (NOTAS, TRANSPORTE…)

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

  final _laudoCtrl             = TextEditingController();
  final _dataCtrl              = TextEditingController();
  final _placaCtrl             = TextEditingController();
  final _pesoBrutoCtrl         = TextEditingController();
  final _pesoTaraCtrl          = TextEditingController();
  final _pesoLiquidoCtrl       = TextEditingController();
  final _ordemCarregamentoCtrl = TextEditingController();
  final _notaFiscalCtrl        = TextEditingController();
  final _cfopCtrl              = TextEditingController();
  final _dataEmissaoNfCtrl     = TextEditingController();
  final _valorUnitarioCtrl     = TextEditingController();
  final _valorTotalCtrl        = TextEditingController();
  final _chaveNfeCtrl          = TextEditingController();
  final _transportadoraCtrl    = TextEditingController();
  final _aceitoPorCtrl         = TextEditingController();

  // Insetos — toggle switch (igual ao Graint)
  bool _insetosVivos   = false;
  bool _insetosMortos  = false;
  bool _odorEstranho   = false;
  bool _sementesToxicas = false;

  final _umidadeCtrl           = TextEditingController();
  final _materiasImpCtrl       = TextEditingController();
  final _quebradosCtrl         = TextEditingController();
  final _mofadosCtrl           = TextEditingController();
  final _totalAvariadosCtrl    = TextEditingController();
  final _queimadosCtrl         = TextEditingController();
  final _ardidosCtrl           = TextEditingController();
  final _esverdeadosCtrl       = TextEditingController();
  final _fermentadosCtrl       = TextEditingController();
  final _germinadosCtrl        = TextEditingController();
  final _picadosCtrl           = TextEditingController();
  final _observacoesCtrl       = TextEditingController();

  String? _veiculoVistoriado = 'SIM';
  String  _produtoBase       = 'Soja';
  String? _tipoProduto       = 'OGM - Intacta Declarado';

  bool get _isEdicao    => widget.cargaParaEditar != null && widget.indiceEdicao != null;
  bool get _isDuplicacao => widget.cargaParaDuplicar != null;

  List<String> get _tiposSoja => const [
    'OGM - Intacta Declarado', 'OGM - Intacta Negativo',
    'OGM - Intacta Participante', 'OGM - Intacta Positivo',
    'Convencional', 'Não Testado', 'Aflatoxina negativa',
    'Aflatoxina < 20 ppb Qualitativo', 'Aflatoxina 20 > ppb Qualitativo',
  ];
  List<String> get _tiposMilho => const [
    'Milho - OGM', 'Milho - Convencional', 'Milho - Não Testado',
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
      _dataCtrl.text  = _dataHoje();
    } else {
      _laudoCtrl.text = _gerarLaudo();
      _dataCtrl.text  = _dataHoje();
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
      _umidadeCtrl, _materiasImpCtrl, _quebradosCtrl, _mofadosCtrl,
      _totalAvariadosCtrl, _queimadosCtrl, _ardidosCtrl, _esverdeadosCtrl,
      _fermentadosCtrl, _germinadosCtrl, _picadosCtrl,
    ]) { c.text = '0,00'; }
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
    final t = _toDouble(_ardidosCtrl.text)    +
              _toDouble(_queimadosCtrl.text)   +
              _toDouble(_mofadosCtrl.text)     +
              _toDouble(_fermentadosCtrl.text) +
              _toDouble(_germinadosCtrl.text);
    _totalAvariadosCtrl.text = t.toStringAsFixed(2);
  }

  void _preencher(CargaModel c) {
    _laudoCtrl.text              = c.laudo;
    _dataCtrl.text               = c.dataClassificacao;
    _placaCtrl.text              = c.placa;
    _pesoBrutoCtrl.text          = c.pesoBruto;
    _pesoTaraCtrl.text           = c.pesoTara;
    _pesoLiquidoCtrl.text        = c.pesoLiquido;
    _ordemCarregamentoCtrl.text  = c.ordemCarregamento;
    _notaFiscalCtrl.text         = c.notaFiscal;
    _cfopCtrl.text               = c.cfop;
    _dataEmissaoNfCtrl.text      = c.dataEmissaoNf;
    _valorUnitarioCtrl.text      = c.valorUnitario;
    _valorTotalCtrl.text         = c.valorTotal;
    _chaveNfeCtrl.text           = c.chaveNfe;
    _transportadoraCtrl.text     = c.transportadora;
    _aceitoPorCtrl.text          = c.aceitoPor;
    _umidadeCtrl.text            = c.umidade.isEmpty       ? '0,00' : c.umidade;
    _materiasImpCtrl.text        = c.materiasImp.isEmpty   ? '0,00' : c.materiasImp;
    _quebradosCtrl.text          = c.quebrados.isEmpty     ? '0,00' : c.quebrados;
    _mofadosCtrl.text            = c.mofados.isEmpty       ? '0,00' : c.mofados;
    _totalAvariadosCtrl.text     = c.totalAvariados.isEmpty? '0,00' : c.totalAvariados;
    _queimadosCtrl.text          = c.queimados.isEmpty     ? '0,00' : c.queimados;
    _ardidosCtrl.text            = c.ardidos.isEmpty       ? '0,00' : c.ardidos;
    _esverdeadosCtrl.text        = c.esverdeados.isEmpty   ? '0,00' : c.esverdeados;
    _fermentadosCtrl.text        = c.fermentados.isEmpty   ? '0,00' : c.fermentados;
    _germinadosCtrl.text         = c.germinados.isEmpty    ? '0,00' : c.germinados;
    _picadosCtrl.text            = c.picados.isEmpty       ? '0,00' : c.picados;
    _observacoesCtrl.text        = c.observacoes;

    _insetosVivos   = c.insetosVivos;
    _insetosMortos  = c.insetosMortos;
    _odorEstranho   = c.odorEstranho;
    _sementesToxicas = c.sementesToxicas;

    final tipo = c.tipoProduto;
    _produtoBase = tipo.toLowerCase().contains('milho') ? 'Milho' : 'Soja';
    _tipoProduto = _tiposProduto.contains(tipo) ? tipo : _tiposProduto.first;
    _veiculoVistoriado = c.veiculoVistoriado.isEmpty ? 'SIM' : c.veiculoVistoriado;
  }

  @override
  void dispose() {
    for (final c in [
      _laudoCtrl, _dataCtrl, _placaCtrl, _pesoBrutoCtrl, _pesoTaraCtrl,
      _pesoLiquidoCtrl, _ordemCarregamentoCtrl, _notaFiscalCtrl, _cfopCtrl,
      _dataEmissaoNfCtrl, _valorUnitarioCtrl, _valorTotalCtrl, _chaveNfeCtrl,
      _transportadoraCtrl, _aceitoPorCtrl, _umidadeCtrl, _materiasImpCtrl,
      _quebradosCtrl, _mofadosCtrl, _totalAvariadosCtrl, _queimadosCtrl,
      _ardidosCtrl, _esverdeadosCtrl, _fermentadosCtrl, _germinadosCtrl,
      _picadosCtrl, _observacoesCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final carga = CargaModel(
      laudo:             _laudoCtrl.text.trim(),
      dataClassificacao: _dataCtrl.text.trim(),
      placa:             _placaCtrl.text.trim(),
      pesoBruto:         _pesoBrutoCtrl.text.trim(),
      pesoTara:          _pesoTaraCtrl.text.trim(),
      pesoLiquido:       _pesoLiquidoCtrl.text.trim(),
      ordemCarregamento: _ordemCarregamentoCtrl.text.trim(),
      veiculoVistoriado: _veiculoVistoriado ?? '',
      tipoProduto:       _tipoProduto ?? '',
      notaFiscal:        _notaFiscalCtrl.text.trim(),
      cfop:              _cfopCtrl.text.trim(),
      dataEmissaoNf:     _dataEmissaoNfCtrl.text.trim(),
      valorUnitario:     _valorUnitarioCtrl.text.trim(),
      valorTotal:        _valorTotalCtrl.text.trim(),
      chaveNfe:          _chaveNfeCtrl.text.trim(),
      transportadora:    _transportadoraCtrl.text.trim(),
      aceitoPor:         _aceitoPorCtrl.text.trim(),
      insetosVivos:      _insetosVivos,
      insetosMortos:     _insetosMortos,
      odorEstranho:      _odorEstranho,
      sementesToxicas:   _sementesToxicas,
      umidade:           _umidadeCtrl.text.trim(),
      materiasImp:       _materiasImpCtrl.text.trim(),
      quebrados:         _quebradosCtrl.text.trim(),
      mofados:           _mofadosCtrl.text.trim(),
      totalAvariados:    _totalAvariadosCtrl.text.trim(),
      queimados:         _queimadosCtrl.text.trim(),
      ardidos:           _ardidosCtrl.text.trim(),
      esverdeados:       _esverdeadosCtrl.text.trim(),
      fermentados:       _fermentadosCtrl.text.trim(),
      germinados:        _germinadosCtrl.text.trim(),
      picados:           _picadosCtrl.text.trim(),
      observacoes:       _observacoesCtrl.text.trim(),
    );

    if (_isEdicao) await CargaMemoryRepository.removeAt(widget.indiceEdicao!);
    await CargaMemoryRepository.add(carga);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdicao ? 'Carga atualizada.'
            : _isDuplicacao ? 'Carga duplicada.' : 'Carga salva.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CargasScreen()),
      );
    }
  }

  String get _lC1 => _produtoBase == 'Milho' ? 'Danificados'       : 'Quebrados';
  String get _lC2 => _produtoBase == 'Milho' ? 'Quebrados'         : 'Mofados';
  String get _lC3 => _produtoBase == 'Milho' ? 'Avariados'         : 'Total de Avariados';
  String get _lC4 => _produtoBase == 'Milho' ? 'Gessado'           : 'Queimados';
  String get _lC5 => _produtoBase == 'Milho' ? 'Mofados'           : 'Ardidos';
  String get _lC6 => _produtoBase == 'Milho' ? 'Fermentados'       : 'Esverdeados';
  String get _lC7 => _produtoBase == 'Milho' ? 'Ardidos'           : 'Fermentados';
  String get _lC8 => 'Germinados';
  String get _lC9 => _produtoBase == 'Milho' ? 'Carunchados'       : 'Picados';

  @override
  Widget build(BuildContext context) {
    final titulo = _isEdicao ? 'Editar Carga'
        : _isDuplicacao ? 'Duplicar Carga' : 'Nova Carga';
    final textoBotao = _isEdicao ? 'ATUALIZAR'
        : _isDuplicacao ? 'SALVAR CÓPIA' : 'SALVAR';

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        // "Nova Carga" — normal case, peso normal, igual ao Graint
        title: Text(titulo, style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500,
            color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── CARD CABEÇALHO ───────────────────────────────────────────
              _GCard(children: [
                _GField(label: 'Laudo',          ctrl: _laudoCtrl, readOnly: true),
                _row(
                  _GField(label: 'Data de Class.', ctrl: _dataCtrl, readOnly: true),
                  _GField(label: 'Placa',           ctrl: _placaCtrl, required: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                        LengthLimitingTextInputFormatter(8),
                        _UpperCase(),
                      ]),
                ),
                _row(
                  _GField(label: 'Peso Bruto', ctrl: _pesoBrutoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  _GField(label: 'Peso Tara',  ctrl: _pesoTaraCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                ),
                _row(
                  _GField(label: 'Peso Líquido',       ctrl: _pesoLiquidoCtrl, readOnly: true),
                  _GField(label: 'Ordem de Carregamento', ctrl: _ordemCarregamentoCtrl),
                ),
                _GDrop(
                  label: 'Veículo Vistoriado?',
                  value: _veiculoVistoriado,
                  items: const ['SIM', 'NÃO'],
                  onChanged: (v) => setState(() => _veiculoVistoriado = v),
                ),
                _GDrop(
                  label: 'Produto',
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
                _GDrop(
                  label: 'Tipo do Produto',
                  value: _tipoProduto,
                  items: _tiposProduto,
                  onChanged: (v) => setState(() => _tipoProduto = v),
                  last: true,
                ),
              ]),

              const SizedBox(height: 10),

              // ── CARD NOTAS ───────────────────────────────────────────────
              _GCard(title: 'NOTAS', children: [
                _GField(label: 'Nota Fiscal', ctrl: _notaFiscalCtrl),
                _row(
                  _GField(label: 'CFOP',                   ctrl: _cfopCtrl),
                  _GField(label: 'Data de Emissão da NF',  ctrl: _dataEmissaoNfCtrl),
                ),
                _row(
                  _GField(label: 'Valor Unitário (R\$)', ctrl: _valorUnitarioCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  _GField(label: 'Valor Total (R\$)',    ctrl: _valorTotalCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                ),
                _GField(
                  label: 'Chave NF-e Produtor',
                  ctrl: _chaveNfeCtrl,
                  hint: '44 dígitos',
                  keyboardType: TextInputType.number,
                  maxLength: 44,
                  suffix: const Icon(Icons.barcode_reader,
                      size: 20, color: _kLabel),
                  last: true,
                ),
              ]),

              const SizedBox(height: 10),

              // ── CARD TRANSPORTE ──────────────────────────────────────────
              _GCard(title: 'TRANSPORTE', children: [
                _GField(label: 'Transportadora', ctrl: _transportadoraCtrl, last: true),
              ]),

              const SizedBox(height: 10),

              // ── CARD CLASSIFICAÇÃO ───────────────────────────────────────
              _GCard(title: 'CLASSIFICAÇÃO', children: [
                _GField(label: 'Aceito Por', ctrl: _aceitoPorCtrl),

                // Insetos Vivos — toggle switch igual ao Graint
                _ToggleRow(
                  label: 'Insetos Vivos?',
                  value: _insetosVivos,
                  onChanged: (v) => setState(() => _insetosVivos = v),
                ),
                // Insetos Mortos — toggle switch
                _ToggleRow(
                  label: 'Insetos Mortos?',
                  value: _insetosMortos,
                  onChanged: (v) => setState(() => _insetosMortos = v),
                ),
                // Odor Estranho — toggle switch
                _ToggleRow(
                  label: 'Odor Estranho?',
                  value: _odorEstranho,
                  onChanged: (v) => setState(() => _odorEstranho = v),
                ),
                // Sementes Tóxicas — toggle switch
                _ToggleRow(
                  label: 'Sementes Tóxicas?',
                  value: _sementesToxicas,
                  onChanged: (v) => setState(() => _sementesToxicas = v),
                ),

                const SizedBox(height: 8),

                // Campos numéricos — outline arredondado como todos os outros
                _row(_GField(label: 'UMIDADE',           ctrl: _umidadeCtrl,     keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                     _GField(label: 'MATÉRIAS E. E IMP.', ctrl: _materiasImpCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                _row(_GField(label: _lC1, ctrl: _quebradosCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                     _GField(label: _lC2, ctrl: _mofadosCtrl,   keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                _row(
                  _GField(label: _lC3, ctrl: _totalAvariadosCtrl,
                      readOnly: _produtoBase == 'Soja',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  _GField(label: _lC4, ctrl: _queimadosCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                ),
                _row(_GField(label: _lC5, ctrl: _ardidosCtrl,    keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                     _GField(label: _lC6, ctrl: _esverdeadosCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                _row(_GField(label: _lC7, ctrl: _fermentadosCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                     _GField(label: _lC8, ctrl: _germinadosCtrl,  keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                _GField(label: _lC9, ctrl: _picadosCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                _GField(label: 'Observações', ctrl: _observacoesCtrl,
                    maxLines: 3, maxLength: 100, last: true),
              ]),

              const SizedBox(height: 16),

              // ── Botão SALVAR — verde arredondado igual ao Graint ─────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(textoBotao, style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5)),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper — dois campos lado a lado
  Widget _row(Widget l, Widget r) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Expanded(child: l), const SizedBox(width: 10), Expanded(child: r)],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Card de seção — branco, cantos arredondados, título pequeno no topo esquerdo
// Idêntico ao Graint (NOTAS, TRANSPORTE, CLASSIFICAÇÃO)
// ─────────────────────────────────────────────────────────────────────────────
class _GCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _GCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Text(title!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _kSection,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Campo de texto — outline rounded, floating label — idêntico ao Graint
// ─────────────────────────────────────────────────────────────────────────────
class _GField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool readOnly;
  final bool required;
  final bool last;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final String? hint;
  final Widget? suffix;

  const _GField({
    required this.label,
    required this.ctrl,
    this.readOnly = false,
    this.required = false,
    this.last = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 8 : 12),
      child: TextFormField(
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
          color: readOnly ? _kLabel : const Color(0xFF333333),
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: suffix,
          counterText: '',
          isDense: true,
          filled: true,
          fillColor: _kCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: const TextStyle(fontSize: 14, color: _kLabel),
          floatingLabelStyle: const TextStyle(fontSize: 12, color: _kLabel),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _kBorder, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: _kBorder.withOpacity(0.5), width: 1.0),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dropdown — outline rounded, floating label — idêntico ao Graint
// ─────────────────────────────────────────────────────────────────────────────
class _GDrop extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final bool last;

  const _GDrop({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 8 : 12),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: _kLabel, size: 22),
        style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          filled: true,
          fillColor: _kCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: const TextStyle(fontSize: 14, color: _kLabel),
          floatingLabelStyle: const TextStyle(fontSize: 12, color: _kLabel),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _kBorder, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        items: items.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(fontSize: 15, color: Color(0xFF333333))),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle switch row — igual ao Graint (Insetos Vivos/Mortos, Odor, Sementes)
// ─────────────────────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _kBorder, width: 1.0),
      ),
      child: SwitchListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        title: Text(label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF333333),
          ),
        ),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) =>
      n.copyWith(text: n.text.toUpperCase());
}
