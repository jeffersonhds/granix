import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_colors.dart';

class SuporteScreen extends StatelessWidget {
  const SuporteScreen({super.key});

  static const _bg = Color(0xFFF1F1F1);
  static const _greenText = Color(0xFF6A9441);
  static const _danger = Color(0xFFC91717);

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
          'SUPORTE',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
        children: const [
          _SuporteCard(
            titulo: 'Exportar Banco de Dados',
            descricao:
                'Envie o banco de dados para a análise de possíveis problemas!',
            corTitulo: _greenText,
            corIcone: _greenText,
            icone: Icons.send,
            fundo: Colors.white,
          ),
          SizedBox(height: 14),
          _SuporteCard(
            titulo: 'Atualizar Dados da Empresa',
            descricao:
                'Caso necessário aqui você poderá atualizar os dados da empresa!',
            corTitulo: _greenText,
            corIcone: _greenText,
            icone: Icons.sync,
            fundo: Colors.white,
          ),
          SizedBox(height: 14),
          _SuporteCard(
            titulo: 'Alterar Chave de Acesso',
            descricao: 'Esta opção irá excluir todos os dados do aplicativo!',
            corTitulo: Colors.white,
            corIcone: Colors.white,
            icone: Icons.refresh,
            fundo: _danger,
            descricaoColor: Colors.white70,
          ),
        ],
      ),
    );
  }
}

class _SuporteCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final Color corTitulo;
  final Color corIcone;
  final Color fundo;
  final IconData icone;
  final Color? descricaoColor;

  const _SuporteCard({
    required this.titulo,
    required this.descricao,
    required this.corTitulo,
    required this.corIcone,
    required this.fundo,
    required this.icone,
    this.descricaoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fundo,
      elevation: 2,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: corTitulo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      descricao,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: descricaoColor ?? Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Icon(
                icone,
                size: 38,
                color: corIcone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
