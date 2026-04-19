import 'package:flutter/material.dart';
import 'package:granix/core/routes/route_names.dart';
import 'package:granix/features/expenses/presentation/pages/solicitacao_despesas_screen.dart';
import 'package:granix/features/home/presentation/home_screen.dart';
import 'package:granix/features/loads/presentation/pages/cargas_screen.dart';
import 'package:granix/features/materials/presentation/pages/materiais_screen.dart';
import 'package:granix/features/settings/presentation/pages/configuracoes_screen.dart';
import 'package:granix/features/support/presentation/pages/suporte_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        RouteNames.home: (_) => const HomeScreen(),
        RouteNames.loads: (_) => const CargasScreen(),
        RouteNames.expenses: (_) => const SolicitacaoDespesasScreen(),
        RouteNames.materials: (_) => const MateriaisScreen(),
        RouteNames.settings: (_) => const ConfiguracoesScreen(),
        RouteNames.support: (_) => const SuporteScreen(),
      };
}
