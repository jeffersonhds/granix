import 'package:flutter/material.dart';
import 'package:granix/core/theme/app_theme.dart';
import 'package:granix/features/auth/presentation/login_screen.dart';

void main() {
  runApp(const GranixApp());
}

class GranixApp extends StatelessWidget {
  const GranixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GRANIX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
