import '../models/card_model.dart';
import '../models/rarity.dart';

/// 卡片生成結果
class CardGenerationResult {
  final CardModel card;
  final String debugInfo; // 除錯用：顯示分數組成

  const CardGenerationResult({
    required this.card,
    required this.debugInfo,
  });
}

/// 卡片生成服務介面
///
/// 接收照片 + 咒語 → 回傳生成的卡片。
/// 實作有 Mock 版（本地隨機）和未來的 Firebase 版（Cloud Functions + Claude）。
abstract class CardGenerationService {
  /// 生成一張卡片
  ///
  /// [photoPath] 照片檔案路徑
  /// [spellText] 咒語文字（語音轉文字後）
  /// [ownerName] 召喚者名稱
  Future<CardGenerationResult> generateCard({
    required String photoPath,
    required String spellText,
    String ownerName = 'Player',
    Rarity? forcedRarity,
  });
}
