import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Brand & Palette Colors
  // ─────────────────────────────────────────────

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF1F5F9); // Soft modern slate background
  static const Color textColor = Color(0xFF334155);
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);

  static const Color navy = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Dashboard feature colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEA580C);
  static const Color purple = Color(0xFF9333EA);

  // Soft icon backgrounds
  static const Color blueSoft = Color(0xFFEFF6FF);
  static const Color greenSoft = Color(0xFFF0FDF4);
  static const Color orangeSoft = Color(0xFFFFF7ED);
  static const Color purpleSoft = Color(0xFFFDF4FF);

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: primaryBlue,
      surface: surface,
      onSurface: textPrimary,
      error: const Color(0xFFEF4444),
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.6,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.4,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.2,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: border, width: 1),
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFF8FAFC),
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF94A3B8),
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
