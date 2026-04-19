
import 'dart:io';
import 'dart:typed_data';

import 'package:granix/features/loads/domain/carga_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CargaPdfService {
  CargaPdfService._();

  static Future<File> gerarESalvarPdf(CargaModel carga) async {
    final bytes = await gerarPdfBytes(carga);
    final directory = await _getSaveDirectory();

    final nomeBase = carga.placa.trim().isNotEmpty ? carga.placa : carga.laudo;
    final nomeArquivo =
        'laudo_${_sanitizeFileName(nomeBase)}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$nomeArquivo');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<Uint8List> gerarPdfBytes(CargaModel carga) async {
    final pdf = pw.Document();

    final regular = pw.Font.helvetica();
    final bold = pw.Font.helveticaBold();

    String limparTexto(String value) {
      return value
          .replaceAll('–', '-')
          .replaceAll('—', '-')
          .replaceAll('−', '-')
          .replaceAll('•', '-')
          .replaceAll('✖', '-')
          .replaceAll('×', 'x')
          .replaceAll('“', '"')
          .replaceAll('”', '"')
          .replaceAll("'", "'")
          .replaceAll('…', '...')
          .replaceAll('\u00A0', ' ')
          .replaceAll(RegExp(r'[^\x20-\x7EÀ-ÿ]'), '')
          .trim();
    }

    String valor(String v) {
      final texto = limparTexto(v);
      return texto.isEmpty ? '-' : texto;
    }

    String simNao(bool v) => v ? 'Sim' : 'Não';

    pw.Widget linha(String texto) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Text(
          limparTexto(texto),
          style: pw.TextStyle(
            font: regular,
            fontSize: 10,
            color: PdfColors.black,
            lineSpacing: 1.2,
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(34, 20, 34, 24),
        build: (context) {
          return pw.Center(
            child: pw.Container(
              width: 360,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'Laudo Técnico de Classificação de Grãos',
                      style: pw.TextStyle(font: bold, fontSize: 18),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 18),
                  pw.Center(
                    child: pw.Text(
                      'Laudo de Acomp. de Embarque',
                      style: pw.TextStyle(font: regular, fontSize: 12),
                    ),
                  ),
                  pw.Center(
                    child: pw.Text(
                      valor(carga.laudo),
                      style: pw.TextStyle(font: regular, fontSize: 10),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  linha('ID do Laudo: ${valor(carga.laudo)}'),
                  linha('Data: ${valor(carga.dataClassificacao)}'),
                  linha('Ordem de Serviço: ${valor(carga.ordemCarregamento)}'),
                  linha('Empresa: --'),
                  linha('CNPJ: --'),
                  linha('Contrato: --'),
                  linha('Produto: --'),
                  linha('Tipo do Produto: ${valor(carga.tipoProduto)}'),
                  linha('Origem: --'),
                  linha('Local Embarque: --'),
                  linha('Produtor: --'),
                  linha('Destino: --'),
                  linha('Local Destino: --'),
                  linha('Placa: ${valor(carga.placa)}'),
                  linha('Peso Bruto: ${valor(carga.pesoBruto)}'),
                  linha('Peso Tara: ${valor(carga.pesoTara)}'),
                  linha('Peso: ${valor(carga.pesoLiquido)}'),
                  linha('Ordem de Carregamento: ${valor(carga.ordemCarregamento)}'),
                  linha('Nota Fiscal: ${valor(carga.notaFiscal)}'),
                  linha('Veículo Vistoriado?: ${valor(carga.veiculoVistoriado)}'),
                  linha('Transportadora: ${valor(carga.transportadora)}'),
                  pw.SizedBox(height: 18),
                  pw.Center(
                    child: pw.Text(
                      '----------- Itens de Classificacao -----------',
                      style: pw.TextStyle(font: regular, fontSize: 10),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  linha('Presença Insetos Vivos: ${simNao(carga.insetosVivos)}'),
                  linha('Qtd. Insetos Vivos: ${valor(carga.qtdInsetosVivos)}'),
                  linha('Presença Insetos Mortos: ${simNao(carga.insetosMortos)}'),
                  linha('Qtd. Insetos Mortos: ${valor(carga.qtdInsetosMortos)}'),
                  linha('Odor Estranho: ${simNao(carga.odorEstranho)}'),
                  linha('Sementes Tóxicas: ${simNao(carga.sementesToxicas)}'),
                  linha('UMIDADE: ${valor(carga.umidade)}'),
                  linha('MATÉRIAS E. e IMP: ${valor(carga.materiasImp)}'),
                  linha('QUEBRADOS: ${valor(carga.quebrados)}'),
                  linha('MOFADOS: ${valor(carga.mofados)}'),
                  linha('TOTAL DE AVARIADOS: ${valor(carga.totalAvariados)}'),
                  linha('QUEIMADOS: ${valor(carga.queimados)}'),
                  linha('ARDIDOS: ${valor(carga.ardidos)}'),
                  linha('ESVERDEADOS: ${valor(carga.esverdeados)}'),
                  linha('FERMENTADOS: ${valor(carga.fermentados)}'),
                  linha('GERMINADOS: ${valor(carga.germinados)}'),
                  linha('PICADOS: ${valor(carga.picados)}'),
                  pw.SizedBox(height: 16),
                  linha('Latitude: -'),
                  linha('Longitude: -'),
                  pw.SizedBox(height: 16),
                  linha('Classificador Responsável: Jefferson'),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<Directory> _getSaveDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/laudos_granix');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static String _sanitizeFileName(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
  }
}
