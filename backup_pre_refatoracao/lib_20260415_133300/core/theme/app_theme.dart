import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granix/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 22),
      ),
      // Underline global — campos flat sem caixa
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        filled: false,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        hintStyle: TextStyle(fontSize: 13, color: AppColors.textHint),
        contentPadding: EdgeInsets.only(bottom: 6, top: 2),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.underline, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.underline, width: 1.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.danger, width: 1.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border, width: 0.9),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
      // MaterialStateProperty — API correta para Flutter 3.3.x
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected)
              ? AppColors.primary
              : Colors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected)
              ? const Color(0xFFB0C060)
              : const Color(0xFFD0D0D0),
        ),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
      dividerColor: AppColors.divider,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.8,
        space: 0,
      ),
    );
  }
}
