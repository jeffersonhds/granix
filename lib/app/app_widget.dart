import 'package:flutter/material.dart';
import 'package:granix/app/app_routes.dart';
import 'package:granix/core/theme/app_theme.dart';
import 'package:granix/features/auth/presentation/login_screen.dart';

class GranixApp extends StatelessWidget {
  const GranixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Granix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routes: AppRoutes.routes,
      home: const LoginScreen(),
    );
  }
}
