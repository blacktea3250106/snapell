import 'rarity.dart';
import 'passive_skill.dart';
import 'spell_score.dart';

/// VoxCards 卡片資料模型
class CardModel {
  final String id;
  final String ownerId;
  final String name;
  final int level;
  final Rarity rarity;
  final PassiveSkill passive;
  final String description;
  final String? photoUrl; // 原始照片
  final String? voiceUrl; // 咒語音檔
  final String? cardImageUrl; // 處理後卡面圖
  final String? localPhotoPath; // 本地照片路徑（mock 用）
  final String spellText;
  final SpellScore spellScore;
  final int photoScore;
  final int fateValue;
  final int totalScore;
  final DateTime createdAt;
  final String? createdLocation;
  final int globalIndex; // 全服同類第 N 張
  final int? globalCount; // 全服同類總數

  // 戰鬥屬性（從等級衍生）
  int get atk => (level * 0.8 + (spellScore.energy * 2)).round();
  int get def => (level * 0.7 + (spellScore.relevance * 2)).round();
  int get spd => (level * 0.6 + (spellScore.creativity * 3)).round();

  const CardModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.level,
    required this.rarity,
    required this.passive,
    required this.description,
    this.photoUrl,
    this.voiceUrl,
    this.cardImageUrl,
    this.localPhotoPath,
    required this.spellText,
    required this.spellScore,
    required this.photoScore,
    required this.fateValue,
    required this.totalScore,
    required this.createdAt,
    this.createdLocation,
    this.globalIndex = 0,
    this.globalCount,
  });

  /// 等級倍率
  double get levelMultiplier {
    if (level <= 20) return 1.0;
    if (level <= 40) return 1.3;
    if (level <= 60) return 1.6;
    if (level <= 80) return 2.0;
    if (level <= 99) return 2.5;
    return 3.0;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'level': level,
        'rarity': rarity.name,
        'passive': passive.toMap(),
        'description': description,
        'photoUrl': photoUrl,
        'voiceUrl': voiceUrl,
        'cardImageUrl': cardImageUrl,
        'spellText': spellText,
        'spellScore': spellScore.toMap(),
        'photoScore': photoScore,
        'fateValue': fateValue,
        'totalScore': totalScore,
        'createdAt': createdAt.toIso8601String(),
        'createdLocation': createdLocation,
        'globalIndex': globalIndex,
        'globalCount': globalCount,
      };

  factory CardModel.fromMap(Map<String, dynamic> map) => CardModel(
        id: map['id'] as String,
        ownerId: map['ownerId'] as String,
        name: map['name'] as String,
        level: map['level'] as int,
        rarity: Rarity.values.firstWhere((e) => e.name == map['rarity']),
        passive: PassiveSkill.fromMap(map['passive'] as Map<String, dynamic>),
        description: map['description'] as String,
        photoUrl: map['photoUrl'] as String?,
        voiceUrl: map['voiceUrl'] as String?,
        cardImageUrl: map['cardImageUrl'] as String?,
        spellText: map['spellText'] as String,
        spellScore:
            SpellScore.fromMap(map['spellScore'] as Map<String, dynamic>),
        photoScore: map['photoScore'] as int,
        fateValue: map['fateValue'] as int,
        totalScore: map['totalScore'] as int,
        createdAt: DateTime.parse(map['createdAt'] as String),
        createdLocation: map['createdLocation'] as String?,
        globalIndex: map['globalIndex'] as int? ?? 0,
        globalCount: map['globalCount'] as int?,
      );
}
