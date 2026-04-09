import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../models/rarity.dart';
import '../models/passive_skill.dart';
import '../models/spell_score.dart';
import '../widgets/card/card_widget.dart';

/// 卡片預覽頁 — 展示 6 種稀有度的 mock 卡片
class CardPreviewScreen extends StatelessWidget {
  const CardPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('卡片預覽')),
      body: PageView.builder(
        itemCount: _mockCards.length,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (context, index) {
          final card = _mockCards[index];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 稀有度標籤
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: card.rarity.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${card.rarity.label} — Lv.${card.level}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: card.rarity.color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 卡片
                CardWidget(card: card),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 6 張 Mock 卡片（每種稀有度各一張）
final _mockCards = [
  CardModel(
    id: 'mock-common',
    ownerId: 'demo',
    name: '🩴 無敵藍白拖',
    level: 8,
    rarity: Rarity.common,
    passive: const PassiveSkill(
      template: PassiveTemplate.floorProtection,
      name: '💨 拖鞋飛踢',
      description: '對手ATK低於自己時，SPD+3',
      condition: '對手ATK低於自己',
      effect: 'SPD+3',
    ),
    description: '不起眼的藍白拖，卻藏著驚人的速度。',
    spellText: '飛吧我的拖鞋',
    spellScore: const SpellScore(relevance: 3, energy: 2, creativity: 4),
    photoScore: 8,
    fateValue: 6,
    totalScore: 17,
    createdAt: DateTime.now(),
    createdLocation: '台北',
    globalIndex: 42,
  ),
  CardModel(
    id: 'mock-uncommon',
    ownerId: 'demo',
    name: '🐱 窗邊打盹貓',
    level: 25,
    rarity: Rarity.uncommon,
    passive: const PassiveSkill(
      template: PassiveTemplate.selfSpellBoost,
      name: '😴 午後小憩',
      description: '每回合回復DEF+2',
      condition: '每回合',
      effect: 'DEF+2',
    ),
    description: '一隻在窗邊曬太陽打盹的橘貓，看起來很平靜。',
    spellText: '曬太陽的橘貓快醒來',
    spellScore: const SpellScore(relevance: 5, energy: 4, creativity: 5),
    photoScore: 12,
    fateValue: 14,
    totalScore: 35,
    createdAt: DateTime.now(),
    createdLocation: '台北',
    globalIndex: 156,
  ),
  CardModel(
    id: 'mock-rare',
    ownerId: 'demo',
    name: '🍜 深夜覺醒拉麵',
    level: 42,
    rarity: Rarity.rare,
    passive: const PassiveSkill(
      template: PassiveTemplate.selfAmplify,
      name: '🔥 湯底沸騰',
      description: '等級大於對手10+時，ATK×1.3',
      condition: '等級差>10',
      effect: 'ATK×1.3',
    ),
    description: '深夜的一碗拉麵，蘊含著不可思議的能量。',
    spellText: '沸騰吧拉麵之魂',
    spellScore: const SpellScore(relevance: 7, energy: 6, creativity: 7),
    photoScore: 18,
    fateValue: 22,
    totalScore: 53,
    createdAt: DateTime.now(),
    createdLocation: '新宿',
    globalIndex: 891,
  ),
  CardModel(
    id: 'mock-epic',
    ownerId: 'demo',
    name: '⚡ 雷霆柴犬',
    level: 68,
    rarity: Rarity.epic,
    passive: const PassiveSkill(
      template: PassiveTemplate.enemyDebuff,
      name: '⚡ 電光一閃',
      description: '對手SPD>自己時，對手SPD-5',
      condition: '對手SPD>自己',
      effect: '對手SPD-5',
    ),
    description: '一隻被雷擊中卻安然無恙的柴犬，毛都炸開了。',
    spellText: '用雷電之力毀滅一切吧柴犬',
    spellScore: const SpellScore(relevance: 8, energy: 8, creativity: 7),
    photoScore: 24,
    fateValue: 28,
    totalScore: 75,
    createdAt: DateTime.now(),
    createdLocation: '東京',
    globalIndex: 2034,
  ),
  CardModel(
    id: 'mock-legendary',
    ownerId: 'demo',
    name: '👑 黃金肉球炎貓',
    level: 88,
    rarity: Rarity.legendary,
    passive: const PassiveSkill(
      template: PassiveTemplate.chainReaction,
      name: '🔥 不屈之焰',
      description: '上回合輸了的話，本回合所有屬性+8',
      condition: '上回合敗北',
      effect: '全屬性+8',
    ),
    description: '傳說中用肉球噴出金色火焰的貓，比牠看起來危險一百倍。',
    spellText: '燃燒吧黃金肉球用你的靈魂之火淨化這個世界',
    spellScore: const SpellScore(relevance: 9, energy: 9, creativity: 8),
    photoScore: 27,
    fateValue: 34,
    totalScore: 87,
    createdAt: DateTime.now(),
    createdLocation: '京都',
    globalIndex: 3,
    globalCount: 203,
  ),
  CardModel(
    id: 'mock-mythic',
    ownerId: 'demo',
    name: '🔴 虛空吞噬者',
    level: 99,
    rarity: Rarity.mythic,
    passive: const PassiveSkill(
      template: PassiveTemplate.gamble,
      name: '💀 命運輪盤',
      description: '50%機率ATK×2，50%機率ATK歸零',
      condition: '每回合開始',
      effect: '50%:ATK×2 / 50%:ATK=0',
    ),
    description: '從深淵裂縫中爬出的存在，看到它的人都會顫抖。',
    spellText: '虛空之門為我開啟吞噬一切光明的存在現身吧',
    spellScore: const SpellScore(relevance: 10, energy: 10, creativity: 9),
    photoScore: 29,
    fateValue: 38,
    totalScore: 96,
    createdAt: DateTime.now(),
    createdLocation: '???',
    globalIndex: 1,
    globalCount: 17,
  ),
];
