import 'package:flutter/material.dart';

/// 6 種卡片稀有度
enum Rarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic;

  /// 稀有度中文名
  String get label {
    switch (this) {
      case Rarity.common:
        return '凡品';
      case Rarity.uncommon:
        return '精良';
      case Rarity.rare:
        return '稀有';
      case Rarity.epic:
        return '史詩';
      case Rarity.legendary:
        return '傳說';
      case Rarity.mythic:
        return '神話';
    }
  }

  /// 稀有度代表色
  Color get color {
    switch (this) {
      case Rarity.common:
        return const Color(0xFF9CA3AF);
      case Rarity.uncommon:
        return const Color(0xFF22C55E);
      case Rarity.rare:
        return const Color(0xFF3B82F6);
      case Rarity.epic:
        return const Color(0xFFA855F7);
      case Rarity.legendary:
        return const Color(0xFFF59E0B);
      case Rarity.mythic:
        return const Color(0xFFEF4444);
    }
  }

  /// 邊框寬度
  double get borderWidth {
    switch (this) {
      case Rarity.common:
        return 1.0;
      case Rarity.uncommon:
        return 1.5;
      case Rarity.rare:
        return 2.0;
      case Rarity.epic:
        return 2.5;
      case Rarity.legendary:
        return 3.0;
      case Rarity.mythic:
        return 4.0;
    }
  }

  /// 卡片底色
  Color get cardBackground {
    switch (this) {
      case Rarity.mythic:
        return const Color(0xFF0A0A0F); // 唯一深色卡
      case Rarity.legendary:
        return const Color(0xFFFFFCF5); // 暖白
      default:
        return const Color(0xFFFFFFFF); // 白色
    }
  }

  /// 文字顏色（神話卡用淺色）
  Color get textColor {
    switch (this) {
      case Rarity.mythic:
        return const Color(0xFFE5E7EB);
      default:
        return const Color(0xFF1A1A2E);
    }
  }

  /// 次要文字顏色
  Color get secondaryTextColor {
    switch (this) {
      case Rarity.mythic:
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// 星星數量（視覺指示稀有度）
  int get starCount {
    switch (this) {
      case Rarity.common:
        return 1;
      case Rarity.uncommon:
        return 2;
      case Rarity.rare:
        return 3;
      case Rarity.epic:
        return 4;
      case Rarity.legendary:
        return 5;
      case Rarity.mythic:
        return 6;
    }
  }

  /// 翻卡動畫時長（毫秒）
  int get flipDurationMs {
    switch (this) {
      case Rarity.common:
        return 300;
      case Rarity.uncommon:
        return 500;
      case Rarity.rare:
        return 800;
      case Rarity.epic:
        return 1200;
      case Rarity.legendary:
        return 2800;
      case Rarity.mythic:
        return 3500;
    }
  }

  /// 從總分判定稀有度
  static Rarity fromScore(int score) {
    if (score >= 94) return Rarity.mythic;
    if (score >= 81) return Rarity.legendary;
    if (score >= 66) return Rarity.epic;
    if (score >= 46) return Rarity.rare;
    if (score >= 26) return Rarity.uncommon;
    return Rarity.common;
  }

  /// 等級範圍
  (int min, int max) get levelRange {
    switch (this) {
      case Rarity.common:
        return (1, 15);
      case Rarity.uncommon:
        return (12, 35);
      case Rarity.rare:
        return (28, 55);
      case Rarity.epic:
        return (45, 80);
      case Rarity.legendary:
        return (68, 95);
      case Rarity.mythic:
        return (88, 100);
    }
  }
}
