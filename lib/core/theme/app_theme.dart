import 'package:flutter/material.dart';

/// Warna khusus aplikasi di luar ColorScheme.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00897B);
  static const Color background = Color(0xFFF5F8FA);

  static const Color takenFg = Color(0xFF2E7D32);
  static const Color takenBg = Color(0xFFE6F4EA);
  static const Color missedFg = Color(0xFFC62828);
  static const Color missedBg = Color(0xFFFDECEA);
  static const Color upcomingFg = Color(0xFF00695C);
  static const Color upcomingBg = Color(0xFFE0F2F1);
  static const Color neutralFg = Color(0xFF546E7A);
  static const Color neutralBg = Color(0xFFECEFF1);
  static const Color border = Color(0xFFDDE3E8);
}

/// Tema aplikasi. Dibuat ramah bagi pengguna lanjut usia.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1B2B34),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}