import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF01796F);
  static const primaryDeep = Color(0xFF015F58);
  static const primaryBright = Color(0xFF00BFA5);

  static const lightBg = Color(0xFFF7FBFB);
  static const lightSurface = Colors.white;
  static const lightCard = Color(0xE6FFFFFF);
  static const lightBorder = Color(0x1901796F);
  static const lightText = Color(0xFF0F1B1B);

  static const darkBg = Color(0xFF0C1313);
  static const darkSurface = Color(0xFF111C1C);
  static const darkCard = Color(0x14FFFFFF);
  static const darkBorder = Color(0x22FFFFFF);
  static const darkText = Color(0xFFF5FAFA);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.primaryBright,
      surface: AppColors.lightSurface,
      background: AppColors.lightBg,
      brightness: Brightness.light,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryDeep,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDeep.withOpacity(0.92),
        elevation: 0,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: _inputs(
        fill: AppColors.lightCard,
        border: AppColors.lightBorder,
        focus: AppColors.primary.withOpacity(0.35),
        hint: AppColors.primaryDeep.withOpacity(0.55),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryDeep),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primaryBright,
      secondary: AppColors.primary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBg,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkSurface.withOpacity(0.94),
        elevation: 0,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: _inputs(
        fill: AppColors.darkCard,
        border: AppColors.darkBorder,
        focus: Colors.white.withOpacity(0.35),
        hint: Colors.white70,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  static InputDecorationTheme _inputs({
    required Color fill,
    required Color border,
    required Color focus,
    required Color hint,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: focus)),
      hintStyle: TextStyle(color: hint),
    );
  }
}
