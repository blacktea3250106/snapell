import 'package:flutter/material.dart';

const String _fontFamily = 'NotoSansTC';

/// VoxCards 暗黑奇幻主題
class AppTheme {
  AppTheme._();

  // ── 核心色彩 ──
  static const Color bgDeep = Color(0xFF0A0A0F);
  static const Color bgPanel = Color(0xFF111827);
  static const Color bgPanelBorder = Color(0xFF1F2937);
  static const Color surface = Color(0xFF111827);

  // 強調色
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentIndigo = Color(0xFF6366F1);

  // 文字
  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textDim = Color(0xFF6B7280);

  // 功能色
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);

  // 稀有度色系
  static const Color commonGray = Color(0xFFE5E7EB);
  static const Color uncommonGreen = Color(0xFF22C55E);
  static const Color rareBlue = Color(0xFF3B82F6);
  static const Color epicPurple = Color(0xFFA855F7);
  static const Color legendaryGold = Color(0xFFF59E0B);
  static const Color mythicRed = Color(0xFFEF4444);
  static const Color mythicDark = Color(0xFF0A0A0F);

  // 漸層
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFFBBF24)],
  );
  static const LinearGradient indigoGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF818CF8)],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: bgDeep,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentIndigo,
        brightness: Brightness.dark,
        surface: surface,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFF59E0B),
        foregroundColor: Color(0xFF0A0A0F),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFF1F2937),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF1F2937),
        contentTextStyle: TextStyle(color: textPrimary),
      ),
    );
  }
}
