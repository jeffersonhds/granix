import 'dart:convert';

class CargaModel {
  final String laudo;
  final String dataClassificacao;
  final String placa;
  final String pesoBruto;
  final String pesoTara;
  final String pesoLiquido;
  final String ordemCarregamento;
  final String veiculoVistoriado;
  final String tipoProduto;
  final String notaFiscal;
  final String cfop;
  final String dataEmissaoNf;
  final String valorUnitario;
  final String valorTotal;
  final String chaveNfe;
  final String transportadora;
  final String aceitoPor;
  final bool insetosVivos;
  final bool insetosMortos;
  final bool odorEstranho;
  final bool sementesToxicas;
  final String umidade;
  final String materiasImp;
  final String quebrados;
  final String mofados;
  final String totalAvariados;
  final String queimados;
  final String ardidos;
  final String esverdeados;
  final String fermentados;
  final String germinados;
  final String picados;
  final String observacoes;

  const CargaModel({
    required this.laudo,
    required this.dataClassificacao,
    required this.placa,
    required this.pesoBruto,
    required this.pesoTara,
    required this.pesoLiquido,
    required this.ordemCarregamento,
    required this.veiculoVistoriado,
    required this.tipoProduto,
    required this.notaFiscal,
    required this.cfop,
    required this.dataEmissaoNf,
    required this.valorUnitario,
    required this.valorTotal,
    required this.chaveNfe,
    required this.transportadora,
    required this.aceitoPor,
    required this.insetosVivos,
    required this.insetosMortos,
    required this.odorEstranho,
    required this.sementesToxicas,
    required this.umidade,
    required this.materiasImp,
    required this.quebrados,
    required this.mofados,
    required this.totalAvariados,
    required this.queimados,
    required this.ardidos,
    required this.esverdeados,
    required this.fermentados,
    required this.germinados,
    required this.picados,
    required this.observacoes,
  });

  CargaModel copyWith({
    String? laudo,
    String? dataClassificacao,
    String? placa,
    String? pesoBruto,
    String? pesoTara,
    String? pesoLiquido,
    String? ordemCarregamento,
    String? veiculoVistoriado,
    String? tipoProduto,
    String? notaFiscal,
    String? cfop,
    String? dataEmissaoNf,
    String? valorUnitario,
    String? valorTotal,
    String? chaveNfe,
    String? transportadora,
    String? aceitoPor,
    bool? insetosVivos,
    bool? insetosMortos,
    bool? odorEstranho,
    bool? sementesToxicas,
    String? umidade,
    String? materiasImp,
    String? quebrados,
    String? mofados,
    String? totalAvariados,
    String? queimados,
    String? ardidos,
    String? esverdeados,
    String? fermentados,
    String? germinados,
    String? picados,
    String? observacoes,
  }) {
    return CargaModel(
      laudo: laudo ?? this.laudo,
      dataClassificacao: dataClassificacao ?? this.dataClassificacao,
      placa: placa ?? this.placa,
      pesoBruto: pesoBruto ?? this.pesoBruto,
      pesoTara: pesoTara ?? this.pesoTara,
      pesoLiquido: pesoLiquido ?? this.pesoLiquido,
      ordemCarregamento: ordemCarregamento ?? this.ordemCarregamento,
      veiculoVistoriado: veiculoVistoriado ?? this.veiculoVistoriado,
      tipoProduto: tipoProduto ?? this.tipoProduto,
      notaFiscal: notaFiscal ?? this.notaFiscal,
      cfop: cfop ?? this.cfop,
      dataEmissaoNf: dataEmissaoNf ?? this.dataEmissaoNf,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      valorTotal: valorTotal ?? this.valorTotal,
      chaveNfe: chaveNfe ?? this.chaveNfe,
      transportadora: transportadora ?? this.transportadora,
      aceitoPor: aceitoPor ?? this.aceitoPor,
      insetosVivos: insetosVivos ?? this.insetosVivos,
      insetosMortos: insetosMortos ?? this.insetosMortos,
      odorEstranho: odorEstranho ?? this.odorEstranho,
      sementesToxicas: sementesToxicas ?? this.sementesToxicas,
      umidade: umidade ?? this.umidade,
      materiasImp: materiasImp ?? this.materiasImp,
      quebrados: quebrados ?? this.quebrados,
      mofados: mofados ?? this.mofados,
      totalAvariados: totalAvariados ?? this.totalAvariados,
      queimados: queimados ?? this.queimados,
      ardidos: ardidos ?? this.ardidos,
      esverdeados: esverdeados ?? this.esverdeados,
      fermentados: fermentados ?? this.fermentados,
      germinados: germinados ?? this.germinados,
      picados: picados ?? this.picados,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'laudo': laudo,
      'dataClassificacao': dataClassificacao,
      'placa': placa,
      'pesoBruto': pesoBruto,
      'pesoTara': pesoTara,
      'pesoLiquido': pesoLiquido,
      'ordemCarregamento': ordemCarregamento,
      'veiculoVistoriado': veiculoVistoriado,
      'tipoProduto': tipoProduto,
      'notaFiscal': notaFiscal,
      'cfop': cfop,
      'dataEmissaoNf': dataEmissaoNf,
      'valorUnitario': valorUnitario,
      'valorTotal': valorTotal,
      'chaveNfe': chaveNfe,
      'transportadora': transportadora,
      'aceitoPor': aceitoPor,
      'insetosVivos': insetosVivos,
      'insetosMortos': insetosMortos,
      'odorEstranho': odorEstranho,
      'sementesToxicas': sementesToxicas,
      'umidade': umidade,
      'materiasImp': materiasImp,
      'quebrados': quebrados,
      'mofados': mofados,
      'totalAvariados': totalAvariados,
      'queimados': queimados,
      'ardidos': ardidos,
      'esverdeados': esverdeados,
      'fermentados': fermentados,
      'germinados': germinados,
      'picados': picados,
      'observacoes': observacoes,
    };
  }

  factory CargaModel.fromMap(Map<String, dynamic> map) {
    return CargaModel(
      laudo: map['laudo'] ?? '',
      dataClassificacao: map['dataClassificacao'] ?? '',
      placa: map['placa'] ?? '',
      pesoBruto: map['pesoBruto'] ?? '',
      pesoTara: map['pesoTara'] ?? '',
      pesoLiquido: map['pesoLiquido'] ?? '',
      ordemCarregamento: map['ordemCarregamento'] ?? '',
      veiculoVistoriado: map['veiculoVistoriado'] ?? '',
      tipoProduto: map['tipoProduto'] ?? '',
      notaFiscal: map['notaFiscal'] ?? '',
      cfop: map['cfop'] ?? '',
      dataEmissaoNf: map['dataEmissaoNf'] ?? '',
      valorUnitario: map['valorUnitario'] ?? '',
      valorTotal: map['valorTotal'] ?? '',
      chaveNfe: map['chaveNfe'] ?? '',
      transportadora: map['transportadora'] ?? '',
      aceitoPor: map['aceitoPor'] ?? '',
      insetosVivos: map['insetosVivos'] ?? false,
      insetosMortos: map['insetosMortos'] ?? false,
      odorEstranho: map['odorEstranho'] ?? false,
      sementesToxicas: map['sementesToxicas'] ?? false,
      umidade: map['umidade'] ?? '',
      materiasImp: map['materiasImp'] ?? '',
      quebrados: map['quebrados'] ?? '',
      mofados: map['mofados'] ?? '',
      totalAvariados: map['totalAvariados'] ?? '',
      queimados: map['queimados'] ?? '',
      ardidos: map['ardidos'] ?? '',
      esverdeados: map['esverdeados'] ?? '',
      fermentados: map['fermentados'] ?? '',
      germinados: map['germinados'] ?? '',
      picados: map['picados'] ?? '',
      observacoes: map['observacoes'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CargaModel.fromJson(String source) =>
      CargaModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
