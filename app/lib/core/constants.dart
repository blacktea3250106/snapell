/// VoxCards 全域常數
class AppConstants {
  AppConstants._();

  static const String appName = 'VoxCards';

  // 卡片尺寸比例 3:4
  static const double cardAspectRatio = 3 / 4;
  static const double cardWidth = 300;
  static const double cardHeight = 400;

  // 照片區域
  static const double photoWidth = 270;
  static const double photoHeight = 240;

  // 召喚
  static const int spellMinDuration = 3; // 最短咒語秒數
  static const int spellMaxDuration = 10; // 最長咒語秒數
  static const int maxPhotoSizeKB = 500; // 照片壓縮上限

  // 稀有度分數閾值
  static const int commonMax = 25;
  static const int uncommonMax = 45;
  static const int rareMax = 65;
  static const int epicMax = 80;
  static const int legendaryMax = 93;
  // 94-100 = mythic

  // 等級範圍（含重疊）
  static const Map<String, List<int>> levelRanges = {
    'common': [1, 15],
    'uncommon': [12, 35],
    'rare': [28, 55],
    'epic': [45, 80],
    'legendary': [68, 95],
    'mythic': [88, 100],
  };
}
