import 'package:flutter/material.dart';
import '../../models/rarity.dart';

/// 各稀有度的視覺參數
class RarityTheme {
  final Rarity rarity;

  const RarityTheme(this.rarity);

  /// 邊框裝飾
  BoxDecoration get borderDecoration {
    switch (rarity) {
      case Rarity.common:
        return BoxDecoration(
          color: rarity.cardBackground,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        );
      case Rarity.uncommon:
        return BoxDecoration(
          color: rarity.cardBackground,
          border: Border.all(color: rarity.color, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case Rarity.rare:
        return BoxDecoration(
          color: rarity.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFB0BEC5), // 銀色
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case Rarity.epic:
        return BoxDecoration(
          color: rarity.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rarity.color, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case Rarity.legendary:
        return BoxDecoration(
          color: rarity.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rarity.color, width: 3),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case Rarity.mythic:
        return BoxDecoration(
          color: rarity.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF7F1D1D), // 暗紅
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.4),
              blurRadius: 28,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Color(0x33000000),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        );
    }
  }

  /// 分隔線顏色
  Color get dividerColor {
    switch (rarity) {
      case Rarity.mythic:
        return const Color(0xFF7F1D1D);
      default:
        return rarity.color.withOpacity(0.3);
    }
  }

  /// 卡名字重
  FontWeight get nameWeight {
    switch (rarity) {
      case Rarity.common:
        return FontWeight.w400;
      case Rarity.uncommon:
        return FontWeight.w500;
      case Rarity.rare:
        return FontWeight.w700;
      case Rarity.epic:
      case Rarity.legendary:
      case Rarity.mythic:
        return FontWeight.w900;
    }
  }

  /// 數值顏色
  Color get statColor {
    switch (rarity) {
      case Rarity.mythic:
        return const Color(0xFFE5E7EB);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// 技能框裝飾
  BoxDecoration get skillBoxDecoration {
    switch (rarity) {
      case Rarity.mythic:
        return BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(color: const Color(0xFF7F1D1D), width: 1),
          borderRadius: BorderRadius.circular(6),
        );
      default:
        return BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: rarity.color.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        );
    }
  }

  /// 銀色金屬漸層（稀有用）
  Gradient? get borderGradient {
    switch (rarity) {
      case Rarity.rare:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB0BEC5),
            Color(0xFFECEFF1),
            Color(0xFF90A4AE),
            Color(0xFFECEFF1),
            Color(0xFFB0BEC5),
          ],
        );
      case Rarity.epic:
        return const SweepGradient(
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFFA07A),
            Color(0xFFFFD700),
            Color(0xFF98FB98),
            Color(0xFF87CEEB),
            Color(0xFFDDA0DD),
            Color(0xFFFF6B6B),
          ],
        );
      case Rarity.legendary:
        return const SweepGradient(
          colors: [
            Color(0xFFF59E0B),
            Color(0xFFFBBF24),
            Color(0xFFFDE68A),
            Color(0xFFFBBF24),
            Color(0xFFF59E0B),
            Color(0xFFD97706),
            Color(0xFFF59E0B),
          ],
        );
      default:
        return null;
    }
  }
}
