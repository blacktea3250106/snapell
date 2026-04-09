import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../models/rarity.dart';
import '../services/card_generation_service.dart';
import '../services/mock_card_generation.dart';

/// 召喚流程狀態
enum SummonStep {
  idle, // 等待開始
  camera, // 拍照中
  spell, // 錄咒語中
  alchemy, // AI 煉成中
  reveal, // 翻卡揭曉
}

/// 召喚流程狀態
class SummonState {
  final SummonStep step;
  final String? photoPath; // 本地照片路徑
  final String? voicePath; // 本地音檔路徑
  final String? spellText; // 咒語文字（語音辨識或手動輸入）
  final Rarity? forcedRarity; // 指定稀有度（null = 隨機）
  final CardModel? generatedCard; // 生成的卡片
  final String? debugInfo; // 除錯：分數明細
  final String? error;

  const SummonState({
    this.step = SummonStep.idle,
    this.photoPath,
    this.voicePath,
    this.spellText,
    this.forcedRarity,
    this.generatedCard,
    this.debugInfo,
    this.error,
  });

  SummonState copyWith({
    SummonStep? step,
    String? photoPath,
    String? voicePath,
    String? spellText,
    Rarity? forcedRarity,
    bool clearForcedRarity = false,
    CardModel? generatedCard,
    String? debugInfo,
    String? error,
  }) {
    return SummonState(
      step: step ?? this.step,
      photoPath: photoPath ?? this.photoPath,
      voicePath: voicePath ?? this.voicePath,
      spellText: spellText ?? this.spellText,
      forcedRarity: clearForcedRarity ? null : (forcedRarity ?? this.forcedRarity),
      generatedCard: generatedCard ?? this.generatedCard,
      debugInfo: debugInfo ?? this.debugInfo,
      error: error,
    );
  }
}

/// 卡片生成服務 Provider — 可替換 Mock / Firebase
final cardGenerationServiceProvider = Provider<CardGenerationService>((ref) {
  return MockCardGeneration();
});

class SummonNotifier extends StateNotifier<SummonState> {
  final CardGenerationService _generationService;

  SummonNotifier(this._generationService) : super(const SummonState());

  void startSummon() {
    state = const SummonState(step: SummonStep.camera);
  }

  void setPhoto(String path) {
    state = state.copyWith(step: SummonStep.spell, photoPath: path);
  }

  void setForcedRarity(Rarity? rarity) {
    state = state.copyWith(
      forcedRarity: rarity,
      clearForcedRarity: rarity == null,
    );
  }

  /// 設定咒語後自動觸發煉成
  Future<void> setSpellAndGenerate({
    String? voicePath,
    required String text,
  }) async {
    state = state.copyWith(
      step: SummonStep.alchemy,
      voicePath: voicePath,
      spellText: text,
    );

    try {
      final result = await _generationService.generateCard(
        photoPath: state.photoPath ?? '',
        spellText: text,
        forcedRarity: state.forcedRarity,
      );
      if (!mounted) return;
      state = state.copyWith(
        step: SummonStep.reveal,
        generatedCard: result.card,
        debugInfo: result.debugInfo,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(error: '卡片生成失敗：$e');
    }
  }

  void reset() {
    state = const SummonState();
  }
}

final summonProvider =
    StateNotifierProvider<SummonNotifier, SummonState>((ref) {
  final service = ref.watch(cardGenerationServiceProvider);
  return SummonNotifier(service);
});
