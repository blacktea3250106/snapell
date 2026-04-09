import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../widgets/card/card_widget.dart';
import '../widgets/particle_background.dart';

/// 卡片詳情頁 — 暗色玻璃風格 + 卡片光暈
class CardDetailScreen extends StatelessWidget {
  final CardModel card;

  const CardDetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: ParticleBackground(
        particleCount: 15,
        color: card.rarity.color,
        speed: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              // 頂欄
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF9CA3AF)),
                    ),
                    Expanded(
                      child: Text(
                        card.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF3F4F6),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48), // 平衡返回鍵
                  ],
                ),
              ),
              // 可滾動內容
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // 稀有度標籤
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: card.rarity.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: card.rarity.color.withOpacity(0.3)),
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
                      // 卡片 + 光暈
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: card.rarity.color.withOpacity(0.3),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Hero(
                          tag: 'card-${card.id}',
                          child: CardWidget(card: card),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 戰鬥數值
                      _buildStatsBar(),
                      const SizedBox(height: 16),
                      // 資訊面板
                      _buildInfoPanel(),
                      const SizedBox(height: 16),
                      // 咒語面板
                      _buildSpellPanel(),
                      const SizedBox(height: 16),
                      // 分數面板
                      _buildScorePanel(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statColumn('ATK', card.atk, const Color(0xFFEF4444)),
          _statDivider(),
          _statColumn('DEF', card.def, const Color(0xFF3B82F6)),
          _statDivider(),
          _statColumn('SPD', card.spd, const Color(0xFF22C55E)),
        ],
      ),
    );
  }

  Widget _statColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'BarlowCondensed',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.7),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 40, color: const Color(0xFF374151));
  }

  Widget _buildInfoPanel() {
    return _glassPanel(
      title: '卡片資訊',
      children: [
        _infoRow('描述', card.description),
        _infoRow('被動技能', '${card.passive.name}\n${card.passive.description}'),
        _infoRow('地點', card.createdLocation ?? '未知'),
        _infoRow('日期', _formatDate(card.createdAt)),
        _infoRow('編號', '#${card.globalIndex.toString().padLeft(5, '0')}'),
        if (card.globalCount != null)
          _infoRow('全服同類', '${card.globalCount} 張'),
      ],
    );
  }

  Widget _buildSpellPanel() {
    return _glassPanel(
      title: '咒語',
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF374151), width: 0.5),
          ),
          child: Text(
            '「${card.spellText}」',
            style: const TextStyle(
              fontFamily: 'NotoSansTC',
              fontSize: 14,
              color: Color(0xFFD1D5DB),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _scoreChip('契合', card.spellScore.relevance, 10),
            _scoreChip('氣勢', card.spellScore.energy, 10),
            _scoreChip('創意', card.spellScore.creativity, 10),
          ],
        ),
      ],
    );
  }

  Widget _buildScorePanel() {
    return _glassPanel(
      title: '分數明細',
      children: [
        _scoreRow('照片', card.photoScore, 30),
        _scoreRow('咒語', card.spellScore.total, 30),
        _scoreRow('命運', card.fateValue, 40),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: card.rarity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: card.rarity.color.withOpacity(0.2)),
          ),
          child: Text(
            '總分 ${card.totalScore} / 100    倍率 ×${card.levelMultiplier}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: card.rarity.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _glassPanel({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFFD1D5DB))),
          ),
        ],
      ),
    );
  }

  Widget _scoreChip(String label, int value, int max) {
    final ratio = value / max;
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                value: ratio,
                strokeWidth: 3,
                backgroundColor: const Color(0xFF374151),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF59E0B),
                fontFamily: 'Rajdhani',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _scoreRow(String label, int value, int max) {
    final ratio = value / max;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF374151),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                widthFactor: ratio.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '$value/$max',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
                fontFamily: 'Rajdhani',
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}
