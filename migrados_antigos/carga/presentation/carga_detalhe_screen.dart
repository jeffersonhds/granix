import 'dart:io';

import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:granix/features/carga/presentation/nova_carga_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class CargaDetalheScreen extends StatelessWidget {
  final CargaModel carga;
  final int? index;

  const CargaDetalheScreen({
    super.key,
    required this.carga,
    this.index,
  });

  static const _kResponsavelPdf = 'JEFFERSON HENRIQUE DA SILVA';

  Future<void> _editar(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NovaCargaScreen(
          cargaParaEditar: carga,
          indiceEdicao: index,
        ),
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _duplicar(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NovaCargaScreen(cargaParaDuplicar: carga),
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }

  String _v(String value) {
    final t = value.trim();
    return t.isEmpty ? '--' : t;
  }

  String _boolText(bool value) => value ? 'Sim' : 'Não';

  String _produtoTitulo() {
    final tipo = carga.tipoProduto.toLowerCase();
    if (tipo.contains('milho')) return 'MILHO';
    return 'SOJA';
  }

  String _percent(String value) {
    final v = value.trim();
    if (v.isEmpty || v == '--') return '--';
    if (v.contains('%')) return v;
    return '$v %';
  }

  String _rotuloClassificacao(String campo) {
    final isMilho = carga.tipoProduto.toLowerCase().contains('milho');

    switch (campo) {
      case 'quebrados':
        return isMilho ? 'DANIFICADOS' : 'DANIFICADOS';
      case 'mofados':
        return isMilho ? 'QUEBRADOS' : 'MOFADOS';
      case 'totalAvariados':
        return isMilho ? 'AVARIADOS' : 'TOTAL DE AVARIADOS';
      case 'queimados':
        return isMilho ? 'GESSADOS' : 'QUEIMADOS';
      case 'ardidos':
        return isMilho ? 'MOFADOS' : 'ARDIDOS';
      case 'esverdeados':
        return isMilho ? 'FERMENTADOS' : 'ESVERDEADOS';
      case 'fermentados':
        return isMilho ? 'ARDIDOS' : 'FERMENTADOS';
      case 'germinados':
        return 'GERMINADOS';
      case 'picados':
        return isMilho ? 'IMATUROS' : 'IMATUROS/CHOCHOS';
      default:
        return campo;
    }
  }

  pw.Widget _pdfLinha(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label: ',
            style: const pw.TextStyle(
              fontSize: 11.5,
              color: PdfColors.black,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 11.5,
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfLinhaResponsavel(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        '$label: $value',
        style: const pw.TextStyle(
          fontSize: 10.5,
          color: PdfColors.black,
        ),
        softWrap: false,
      ),
    );
  }

  pw.Widget _pdfTituloSecao(String titulo) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 18, bottom: 10),
      child: pw.Center(
        child: pw.Text(
          '------------ $titulo ------------',
          style: const pw.TextStyle(
            fontSize: 11.5,
            color: PdfColors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _compartilharPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      final placaTitulo =
          carga.placa.trim().isEmpty ? 'SEM PLACA' : carga.placa.trim();
      final nomeSeguro =
          placaTitulo.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(36, 12, 36, 24),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  'GRANIX',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'Relatório de Carga',
                  style: const pw.TextStyle(
                    fontSize: 12.5,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  _v(carga.laudo),
                  style: const pw.TextStyle(
                    fontSize: 11.5,
                    color: PdfColors.black,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.SizedBox(
                  width: 320,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _pdfLinha('ID do Laudo', '--'),
                      _pdfLinha('Data', _v(carga.dataClassificacao)),
                      _pdfLinha('Placa', _v(carga.placa)),
                      _pdfLinha('Produto', _produtoTitulo()),
                      _pdfLinha('Tipo do Produto', _v(carga.tipoProduto)),
                      _pdfLinha('Peso Bruto', _v(carga.pesoBruto)),
                      _pdfLinha('Peso Tara', _v(carga.pesoTara)),
                      _pdfLinha('Peso', _v(carga.pesoLiquido)),
                      _pdfLinha(
                        'Ordem de Carregamento',
                        _v(carga.ordemCarregamento),
                      ),
                      _pdfLinha('Nota Fiscal', _v(carga.notaFiscal)),
                      _pdfLinha(
                        'Veículo Vistoriado?',
                        _v(carga.veiculoVistoriado),
                      ),
                      _pdfLinha('Transportadora', _v(carga.transportadora)),
                      _pdfTituloSecao('Itens de Classificacao'),
                      _pdfLinha(
                        'Presença Insetos Vivos',
                        _boolText(carga.insetosVivos),
                      ),
                      _pdfLinha(
                        'Presença Insetos Mortos',
                        _boolText(carga.insetosMortos),
                      ),
                      _pdfLinha(
                        'Odor Estranho',
                        _boolText(carga.odorEstranho),
                      ),
                      _pdfLinha(
                        'Sementes Tóxicas',
                        _boolText(carga.sementesToxicas),
                      ),
                      _pdfLinha('UMIDADE', _percent(carga.umidade)),
                      _pdfLinha(
                        'MATÉRIAS E. e IMP',
                        _percent(carga.materiasImp),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('quebrados'),
                        _percent(carga.quebrados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('mofados'),
                        _percent(carga.mofados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('totalAvariados'),
                        _percent(carga.totalAvariados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('queimados'),
                        _percent(carga.queimados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('ardidos'),
                        _percent(carga.ardidos),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('esverdeados'),
                        _percent(carga.esverdeados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('fermentados'),
                        _percent(carga.fermentados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('germinados'),
                        _percent(carga.germinados),
                      ),
                      _pdfLinha(
                        _rotuloClassificacao('picados'),
                        _percent(carga.picados),
                      ),
                      if (carga.observacoes.trim().isNotEmpty) ...[
                        pw.SizedBox(height: 10),
                        _pdfLinha('Observações', _v(carga.observacoes)),
                      ],
                      pw.SizedBox(height: 18),
                      _pdfLinhaResponsavel(
                        'Classificador Responsável',
                        _kResponsavelPdf,
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/relatorio_$nomeSeguro.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Relatório da carga $placaTitulo',
        subject: 'Relatório de Carga',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar PDF: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          carga.placa.isEmpty ? 'DETALHE DA CARGA' : carga.placa,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 120),
        children: [
          const _SectionBar(label: 'CABEÇALHO'),
          _DetalheGroup(
            children: [
              _DetalheRow('Laudo', carga.laudo),
              _DetalheRow('Data de Classificação', carga.dataClassificacao),
              _DetalheRow('Placa', carga.placa),
              _DetalheRow('Peso Bruto', carga.pesoBruto),
              _DetalheRow('Peso Tara', carga.pesoTara),
              _DetalheRow('Peso Líquido', carga.pesoLiquido),
              _DetalheRow('Ordem de Carregamento', carga.ordemCarregamento),
              _DetalheRow('Veículo Vistoriado', carga.veiculoVistoriado),
              _DetalheRow('Tipo do Produto', carga.tipoProduto),
            ],
          ),
          const _SectionBar(label: 'NOTAS'),
          _DetalheGroup(
            children: [
              _DetalheRow('Nota Fiscal', carga.notaFiscal),
              _DetalheRow('CFOP', carga.cfop),
              _DetalheRow('Data de Emissão da NF', carga.dataEmissaoNf),
              _DetalheRow('Valor Unitário', carga.valorUnitario),
              _DetalheRow('Valor Total', carga.valorTotal),
              _DetalheRow('Chave NF-e Produtor', carga.chaveNfe),
            ],
          ),
          const _SectionBar(label: 'TRANSPORTE'),
          _DetalheGroup(
            children: [
              _DetalheRow('Transportadora', carga.transportadora),
            ],
          ),
          const _SectionBar(label: 'CLASSIFICAÇÃO'),
          _DetalheGroup(
            children: [
              _DetalheRow('Aceito Por', carga.aceitoPor),
              _DetalheRow(
                'Insetos Vivos',
                carga.insetosVivos ? 'Sim' : 'Não',
              ),
              _DetalheRow('Qtd. Insetos Vivos', carga.qtdInsetosVivos),
              _DetalheRow(
                'Insetos Mortos',
                carga.insetosMortos ? 'Sim' : 'Não',
              ),
              _DetalheRow('Qtd. Insetos Mortos', carga.qtdInsetosMortos),
              _DetalheRow(
                'Odor Estranho',
                carga.odorEstranho ? 'Sim' : 'Não',
              ),
              _DetalheRow(
                'Sementes Tóxicas',
                carga.sementesToxicas ? 'Sim' : 'Não',
              ),
              _DetalheRow('Umidade', carga.umidade),
              _DetalheRow('Matérias E. e Imp.', carga.materiasImp),
              _DetalheRow('Quebrados', carga.quebrados),
              _DetalheRow('Mofados', carga.mofados),
              _DetalheRow('Total de Avariados', carga.totalAvariados),
              _DetalheRow('Queimados', carga.queimados),
              _DetalheRow('Ardidos', carga.ardidos),
              _DetalheRow('Esverdeados', carga.esverdeados),
              _DetalheRow('Fermentados', carga.fermentados),
              _DetalheRow('Germinados', carga.germinados),
              _DetalheRow('Picados', carga.picados),
              _DetalheRow('Observações', carga.observacoes),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'pdf',
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 2,
            onPressed: () => _compartilharPdf(context),
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: const Text(
              'PDF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'dup',
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            elevation: 2,
            onPressed: () => _duplicar(context),
            icon: const Icon(Icons.copy_all_outlined, size: 18),
            label: const Text(
              'DUPLICAR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'edit',
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            onPressed: () => _editar(context),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'EDITAR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBar extends StatelessWidget {
  final String label;

  const _SectionBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sectionBar,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _DetalheGroup extends StatelessWidget {
  final List<Widget> children;

  const _DetalheGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: children),
    );
  }
}

class _DetalheRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetalheRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final display = value.trim().isEmpty ? '-' : value;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  display,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 0.6,
          color: AppColors.divider,
        ),
      ],
    );
  }
}
