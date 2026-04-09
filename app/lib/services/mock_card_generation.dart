import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/card_model.dart';
import '../models/rarity.dart';
import '../models/passive_skill.dart';
import '../models/spell_score.dart';
import 'card_generation_service.dart';

/// Mock 卡片生成服務 — 本地隨機生成，模擬 AI 回傳
///
/// 用於前端開發階段，不需要 Firebase / Claude / Deepgram。
/// 產生邏輯：
/// 1. 根據咒語文字長度模擬 SpellScore
/// 2. 隨機 PhotoScore + FateValue
/// 3. 總分 → 稀有度 → 等級
/// 4. 從預設池隨機選名稱和被動技能
class MockCardGeneration implements CardGenerationService {
  static const _uuid = Uuid();
  final _random = Random();

  /// 模擬延遲（秒），模擬 AI 處理時間
  final int delaySeconds;

  /// 全域卡片計數器（模擬全服編號）
  int _globalCounter = 100;

  MockCardGeneration({this.delaySeconds = 3});

  @override
  Future<CardGenerationResult> generateCard({
    required String photoPath,
    required String spellText,
    String ownerName = 'Player',
    Rarity? forcedRarity,
  }) async {
    // 模擬 AI 處理延遲
    await Future.delayed(Duration(seconds: delaySeconds));

    // 1. 計算各項分數
    final spellScore = _calculateSpellScore(spellText);
    int photoScore;
    int fateValue;
    int totalScore;
    Rarity rarity;

    if (forcedRarity != null) {
      // 指定稀有度 → 反推出合理的分數
      rarity = forcedRarity;
      final scores = _scoresForRarity(forcedRarity, spellScore.total);
      photoScore = scores.$1;
      fateValue = scores.$2;
      // 確保 totalScore 落在該稀有度的合法區間
      final raw = spellScore.total + photoScore + fateValue;
      final (minS, maxS) = switch (forcedRarity) {
        Rarity.common => (0, 25),
        Rarity.uncommon => (26, 45),
        Rarity.rare => (46, 65),
        Rarity.epic => (66, 80),
        Rarity.legendary => (81, 93),
        Rarity.mythic => (94, 100),
      };
      totalScore = raw.clamp(minS, maxS);
    } else {
      photoScore = _randomPhotoScore();
      fateValue = _randomFateValue();
      totalScore = spellScore.total + photoScore + fateValue;
      rarity = Rarity.fromScore(totalScore);
    }

    // 3. 決定等級
    final level = _calculateLevel(rarity, totalScore);

    // 4. 選擇卡名和描述
    final nameAndDesc = _pickNameAndDescription(rarity);

    // 5. 選擇被動技能
    final passive = _pickPassiveSkill(rarity);

    // 6. 編號
    _globalCounter++;
    final globalCount = rarity.index >= Rarity.legendary.index
        ? _random.nextInt(200) + 10
        : null;

    final card = CardModel(
      id: _uuid.v4(),
      ownerId: 'local-player',
      name: nameAndDesc.$1,
      level: level,
      rarity: rarity,
      passive: passive,
      description: nameAndDesc.$2,
      localPhotoPath: photoPath,
      spellText: spellText,
      spellScore: spellScore,
      photoScore: photoScore,
      fateValue: fateValue,
      totalScore: totalScore,
      createdAt: DateTime.now(),
      createdLocation: _pickLocation(),
      globalIndex: _globalCounter,
      globalCount: globalCount,
    );

    final forced = forcedRarity != null ? '[指定${forcedRarity.label}] ' : '';
    final debugInfo = '${forced}Photo:$photoScore + Spell:${spellScore.total} '
        '(R${spellScore.relevance}/E${spellScore.energy}/C${spellScore.creativity}) '
        '+ Fate:$fateValue = $totalScore → ${rarity.label} Lv.$level';

    return CardGenerationResult(card: card, debugInfo: debugInfo);
  }

  /// 根據咒語文字模擬評分
  SpellScore _calculateSpellScore(String text) {
    final length = text.length;

    // 咒語越長、越有氣勢 → 分數越高（但有上限）
    // 模擬 Claude 評分的隨機性
    int relevance = _clamp((length ~/ 3) + _random.nextInt(4) - 1, 0, 10);
    int energy = _clamp((length ~/ 4) + _random.nextInt(4) - 1, 0, 10);
    int creativity = _clamp((length ~/ 5) + _random.nextInt(5) - 1, 0, 10);

    // 空咒語 → 固定低分（模擬「自動」模式）
    if (text.isEmpty) {
      relevance = 3;
      energy = 3;
      creativity = 3;
    }

    return SpellScore(
      relevance: relevance,
      energy: energy,
      creativity: creativity,
    );
  }

  /// 隨機照片分數 (0-30)
  int _randomPhotoScore() {
    // 常態分佈模擬：多數在 10-20
    return _clamp(
      10 + _random.nextInt(11) + _random.nextInt(5) - _random.nextInt(5),
      0,
      30,
    );
  }

  /// 隨機命運值 (0-40)
  int _randomFateValue() {
    // 偏低分佈 — 高命運值很稀有
    final base = _random.nextInt(25); // 0-24
    final bonus = _random.nextDouble() < 0.15 ? _random.nextInt(16) : 0;
    return _clamp(base + bonus, 0, 40);
  }

  /// 根據稀有度和總分計算等級
  int _calculateLevel(Rarity rarity, int totalScore) {
    final (minLv, maxLv) = rarity.levelRange;
    // 總分越高，等級在範圍內越高
    final ratio = totalScore / 100;
    final level = minLv + ((maxLv - minLv) * ratio).round();
    return level.clamp(minLv, maxLv);
  }

  /// 從預設池選擇卡名和描述
  (String name, String description) _pickNameAndDescription(Rarity rarity) {
    final pool = _namePool[rarity]!;
    return pool[_random.nextInt(pool.length)];
  }

  /// 從預設池選擇被動技能
  PassiveSkill _pickPassiveSkill(Rarity rarity) {
    final pool = _skillPool[rarity]!;
    return pool[_random.nextInt(pool.length)];
  }

  /// 隨機地點
  String _pickLocation() {
    const locations = ['台北', '新北', '台中', '高雄', '新竹', '桃園', '台南', '花蓮'];
    return locations[_random.nextInt(locations.length)];
  }

  /// 指定稀有度時，反推合理的 photoScore + fateValue
  (int photoScore, int fateValue) _scoresForRarity(Rarity rarity, int spellTotal) {
    // 每個稀有度的合法總分區間
    final (minScore, maxScore) = switch (rarity) {
      Rarity.common => (0, 25),
      Rarity.uncommon => (26, 45),
      Rarity.rare => (46, 65),
      Rarity.epic => (66, 80),
      Rarity.legendary => (81, 93),
      Rarity.mythic => (94, 100),
    };
    // 在合法區間內隨機選目標總分
    final targetTotal = minScore + _random.nextInt(maxScore - minScore + 1);
    final remaining = (targetTotal - spellTotal).clamp(0, 70);
    // 隨機分配到 photo 和 fate，確保不超過各自上限
    final photo = _clamp(remaining * 30 ~/ 70 + _random.nextInt(5) - 2, 0, 30);
    final fate = _clamp(remaining - photo, 0, 40);
    return (photo, fate);
  }

  int _clamp(int value, int min, int max) => value.clamp(min, max);
}

// ── 預設卡名池 ──

const Map<Rarity, List<(String, String)>> _namePool = {
  Rarity.common: [
    ('🩴 路邊藍白拖', '被遺忘在路邊的塑膠拖鞋，意外地很耐穿。'),
    ('🥤 便利商店紅茶', '一杯再普通不過的紅茶，冰塊已經融化了。'),
    ('📎 文具盒迴紋針', '不知道夾過多少文件的迴紋針，已經有點彎了。'),
    ('🧹 倉庫裡的掃把', '角落積灰的掃把，但握起來意外順手。'),
    ('🪨 公園小石頭', '公園步道旁的石頭，被小孩踢過無數次。'),
  ],
  Rarity.uncommon: [
    ('🐱 窗邊午睡貓', '在窗台上曬太陽打盹的橘貓，偶爾翻個身。'),
    ('🌵 辦公桌仙人掌', '放在螢幕旁邊的小仙人掌，據說能防輻射。'),
    ('☕ 早安美式咖啡', '每天早上的精神寄託，少糖少冰。'),
    ('🎸 生鏽的吉他弦', '車庫裡發現的舊吉他，弦都鏽了但還能響。'),
    ('🌙 陽台月光', '深夜陽台上意外清澈的月光，讓人靜下來。'),
  ],
  Rarity.rare: [
    ('🍜 深夜覺醒拉麵', '凌晨三點的一碗拉麵，蘊含著不可思議的能量。'),
    ('🦊 操場小狐狸', '半夜出現在校園操場的狐狸，眼睛閃著光。'),
    ('⛩️ 巷弄神社貓', '躲在巷弄小神社裡的三色貓，帶有神秘氣息。'),
    ('🌊 海岸漂流瓶', '被海浪沖上岸的玻璃瓶，裡面有張褪色的紙條。'),
    ('🎪 街頭魔術師', '夜市路口表演的魔術師，硬幣在指尖消失了。'),
  ],
  Rarity.epic: [
    ('⚡ 雷擊柴犬', '被雷擊中卻安然無恙的柴犬，毛全炸開了。'),
    ('🐉 水溝蓋之龍', '水溝蓋上的龍形浮雕，雨天會微微發光。'),
    ('🔮 算命阿嬤的水晶球', '夜市算命攤的水晶球，看進去會頭暈。'),
    ('🎭 廢墟裡的面具', '廢棄工廠發現的京劇面具，表情隨光線改變。'),
  ],
  Rarity.legendary: [
    ('👑 黃金肉球炎貓', '傳說中用肉球噴出金色火焰的貓，比看起來危險一百倍。'),
    ('🌋 陽明山硫磺靈', '從硫磺噴氣孔中凝聚的精靈，溫度高達 200 度。'),
    ('🐋 基隆港鯨影', '只在滿月夜現身基隆港的巨大鯨魚幻影。'),
  ],
  Rarity.mythic: [
    ('🔴 虛空吞噬者', '從深淵裂縫中爬出的存在，看到它的人都會顫抖。'),
    ('💀 時間裂縫', '在捷運站月台出現的時空裂縫，穿過的人回到三分鐘前。'),
  ],
};

// ── 預設被動技能池 ──

const Map<Rarity, List<PassiveSkill>> _skillPool = {
  Rarity.common: [
    PassiveSkill(
      template: PassiveTemplate.floorProtection,
      name: '💨 拖鞋飛踢',
      description: '對手ATK低於自己時，SPD+3',
      condition: '對手ATK低於自己',
      effect: 'SPD+3',
    ),
    PassiveSkill(
      template: PassiveTemplate.selfSpellBoost,
      name: '🫧 平凡之力',
      description: '每回合DEF+1',
      condition: '每回合',
      effect: 'DEF+1',
    ),
  ],
  Rarity.uncommon: [
    PassiveSkill(
      template: PassiveTemplate.selfSpellBoost,
      name: '😴 午後小憩',
      description: '每回合回復DEF+2',
      condition: '每回合',
      effect: 'DEF+2',
    ),
    PassiveSkill(
      template: PassiveTemplate.selfAmplify,
      name: '☕ 咖啡因覺醒',
      description: 'SPD>對手時，ATK+3',
      condition: 'SPD>對手',
      effect: 'ATK+3',
    ),
  ],
  Rarity.rare: [
    PassiveSkill(
      template: PassiveTemplate.selfAmplify,
      name: '🔥 湯底沸騰',
      description: '等級大於對手10+時，ATK×1.3',
      condition: '等級差>10',
      effect: 'ATK×1.3',
    ),
    PassiveSkill(
      template: PassiveTemplate.enemyDebuff,
      name: '🌊 潮汐壓制',
      description: '對手DEF<自己時，對手ATK-4',
      condition: '對手DEF<自己',
      effect: '對手ATK-4',
    ),
  ],
  Rarity.epic: [
    PassiveSkill(
      template: PassiveTemplate.enemyDebuff,
      name: '⚡ 電光一閃',
      description: '對手SPD>自己時，對手SPD-5',
      condition: '對手SPD>自己',
      effect: '對手SPD-5',
    ),
    PassiveSkill(
      template: PassiveTemplate.chainReaction,
      name: '🐉 龍脈共鳴',
      description: '連續出場3回合，每回合ATK+4',
      condition: '連續出場3回合',
      effect: '每回合ATK+4',
    ),
  ],
  Rarity.legendary: [
    PassiveSkill(
      template: PassiveTemplate.chainReaction,
      name: '🔥 不屈之焰',
      description: '上回合輸了的話，本回合所有屬性+8',
      condition: '上回合敗北',
      effect: '全屬性+8',
    ),
    PassiveSkill(
      template: PassiveTemplate.selfAmplify,
      name: '👑 王者氣場',
      description: '等級>80時，全屬性+5',
      condition: '等級>80',
      effect: '全屬性+5',
    ),
  ],
  Rarity.mythic: [
    PassiveSkill(
      template: PassiveTemplate.gamble,
      name: '💀 命運輪盤',
      description: '50%機率ATK×2，50%機率ATK歸零',
      condition: '每回合開始',
      effect: '50%:ATK×2 / 50%:ATK=0',
    ),
    PassiveSkill(
      template: PassiveTemplate.gamble,
      name: '🔴 虛空崩塌',
      description: '30%機率全屬性×3，70%機率全屬性歸零',
      condition: '每回合開始',
      effect: '30%:全×3 / 70%:全=0',
    ),
  ],
};
