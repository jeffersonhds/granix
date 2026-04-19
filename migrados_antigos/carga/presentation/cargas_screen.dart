import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';
import 'package:granix/features/carga/data/carga_memory_repository.dart';
import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:granix/features/carga/presentation/carga_detalhe_screen.dart';
import 'package:granix/features/carga/presentation/nova_carga_screen.dart';

class CargasScreen extends StatefulWidget {
  const CargasScreen({super.key});

  @override
  State<CargasScreen> createState() => _CargasScreenState();
}

class _CargasScreenState extends State<CargasScreen> {
  bool _loading = true;
  final _buscaCtrl = TextEditingController();
  String _busca = '';

  @override
  void initState() {
    super.initState();
    _carregar();
    _buscaCtrl.addListener(() {
      setState(() => _busca = _buscaCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    await CargaMemoryRepository.init();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _abrirNovaCarga() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => const NovaCargaScreen()));
    await _carregar();
  }

  Future<void> _abrirDetalhe(CargaModel carga, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CargaDetalheScreen(carga: carga, index: index)),
    );
    await _carregar();
  }

  void _confirmarLimparTudo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar cargas'),
        content: const Text('Deseja remover todas as cargas salvas?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              await CargaMemoryRepository.clear();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                await _carregar();
              }
            },
            child: const Text('LIMPAR'),
          ),
        ],
      ),
    );
  }

  void _confirmarExcluir(int index, String placa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir carga'),
        content: Text(
            'Deseja excluir a carga ${placa.isEmpty ? 'SEM PLACA' : placa}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () async {
              await CargaMemoryRepository.removeAt(index);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                await _carregar();
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cargas = CargaMemoryRepository.getAll();
    final filtradas = cargas.asMap().entries.where((e) {
      if (_busca.isEmpty) return true;
      final c = e.value;
      return c.placa.toLowerCase().contains(_busca) ||
          c.laudo.toLowerCase().contains(_busca) ||
          c.dataClassificacao.toLowerCase().contains(_busca);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CARGAS SALVAS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_loading && cargas.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.white, size: 22),
              onPressed: _confirmarLimparTudo,
            ),
        ],
      ),

      // FAB verde arredondado — como no Graint
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirNovaCarga,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add, size: 26),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: [
                  // ── Campo de busca flat ──────────────────────────────
                  TextField(
                    controller: _buscaCtrl,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar por placa, laudo ou data...',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: AppColors.textSecondary),
                      suffixIcon: _buscaCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close,
                                  size: 18, color: AppColors.textSecondary),
                              onPressed: () => _buscaCtrl.clear(),
                            ),
                      isDense: true,
                      filled: false,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.underline, width: 0.9),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primary, width: 1.4),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Contador
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total: ${cargas.length}  |  Exibidos: ${filtradas.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Lista ────────────────────────────────────────────
                  Expanded(
                    child: cargas.isEmpty
                        ? _EmptyState(onAdd: _abrirNovaCarga)
                        : filtradas.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhum resultado encontrado.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtradas.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 1),
                                itemBuilder: (ctx, i) {
                                  final entry = filtradas[i];
                                  final idx = entry.key;
                                  final carga = entry.value;
                                  return _CargaItem(
                                    carga: carga,
                                    onTap: () =>
                                        _abrirDetalhe(carga, idx),
                                    onDelete: () =>
                                        _confirmarExcluir(idx, carga.placa),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Item de carga na lista — estilo flat com linha divisória
// ─────────────────────────────────────────────────────────────────────────────
class _CargaItem extends StatelessWidget {
  final CargaModel carga;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CargaItem({
    required this.carga,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Ícone lateral verde
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Dados
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carga.placa.isEmpty ? 'SEM PLACA' : carga.placa,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Laudo: ${carga.laudo}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Data: ${carga.dataClassificacao}  •  ${carga.tipoProduto}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Botão excluir
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.danger, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Estado vazio
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined,
              size: 56, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 12),
          const Text(
            'Nenhuma carga salva ainda.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Adicionar carga'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
