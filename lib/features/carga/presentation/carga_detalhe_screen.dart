import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:granix/features/carga/presentation/nova_carga_screen.dart';

class CargaDetalheScreen extends StatelessWidget {
  final CargaModel carga;
  final int? index;

  const CargaDetalheScreen({
    super.key,
    required this.carga,
    this.index,
  });

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
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_outlined,
                color: Colors.white, size: 20),
            onPressed: () => _duplicar(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
            onPressed: () => _editar(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 80),
        children: [
          // ── CABEÇALHO ──────────────────────────────────────────────────
          const _SectionBar(label: 'CABEÇALHO'),
          _DetalheGroup(children: [
            _DetalheRow('Laudo', carga.laudo),
            _DetalheRow('Data de Classificação', carga.dataClassificacao),
            _DetalheRow('Placa', carga.placa),
            _DetalheRow('Peso Bruto', carga.pesoBruto),
            _DetalheRow('Peso Tara', carga.pesoTara),
            _DetalheRow('Peso Líquido', carga.pesoLiquido),
            _DetalheRow('Ordem de Carregamento', carga.ordemCarregamento),
            _DetalheRow('Veículo Vistoriado', carga.veiculoVistoriado),
            _DetalheRow('Tipo do Produto', carga.tipoProduto),
          ]),

          // ── NOTAS ──────────────────────────────────────────────────────
          const _SectionBar(label: 'NOTAS'),
          _DetalheGroup(children: [
            _DetalheRow('Nota Fiscal', carga.notaFiscal),
            _DetalheRow('CFOP', carga.cfop),
            _DetalheRow('Data de Emissão da NF', carga.dataEmissaoNf),
            _DetalheRow('Valor Unitário', carga.valorUnitario),
            _DetalheRow('Valor Total', carga.valorTotal),
            _DetalheRow('Chave NF-e Produtor', carga.chaveNfe),
          ]),

          // ── TRANSPORTE ─────────────────────────────────────────────────
          const _SectionBar(label: 'TRANSPORTE'),
          _DetalheGroup(children: [
            _DetalheRow('Transportadora', carga.transportadora),
          ]),

          // ── CLASSIFICAÇÃO ──────────────────────────────────────────────
          const _SectionBar(label: 'CLASSIFICAÇÃO'),
          _DetalheGroup(children: [
            _DetalheRow('Aceito Por', carga.aceitoPor),
            _DetalheRow('Insetos Vivos', carga.insetosVivos ? 'Sim' : 'Não'),
            _DetalheRow('Qtd. Insetos Vivos', carga.qtdInsetosVivos),
            _DetalheRow('Insetos Mortos', carga.insetosMortos ? 'Sim' : 'Não'),
            _DetalheRow('Qtd. Insetos Mortos', carga.qtdInsetosMortos),
            _DetalheRow('Odor Estranho', carga.odorEstranho ? 'Sim' : 'Não'),
            _DetalheRow(
                'Sementes Tóxicas', carga.sementesToxicas ? 'Sim' : 'Não'),
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
          ]),
        ],
      ),

      // FABs — editar e duplicar
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
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
                  fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Barra de seção — igual ao nova_carga_screen
// ─────────────────────────────────────────────────────────────────────────────
class _SectionBar extends StatelessWidget {
  final String label;
  const _SectionBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sectionBar,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 0),
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

// ─────────────────────────────────────────────────────────────────────────────
// Grupo de campos — fundo branco com divisórias finas
// ─────────────────────────────────────────────────────────────────────────────
class _DetalheGroup extends StatelessWidget {
  final List<Widget> children;
  const _DetalheGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: children,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Linha de detalhe — label + valor com divisória inferior
// ─────────────────────────────────────────────────────────────────────────────
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
        const Divider(height: 0, thickness: 0.6, color: AppColors.divider),
      ],
    );
  }
}
