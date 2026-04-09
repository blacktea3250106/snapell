import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../providers/cards_provider.dart';
import '../providers/summon_provider.dart';
import '../widgets/card/card_widget.dart';
import '../widgets/particle_background.dart';
import '../widgets/glow_button.dart';
import 'card_detail_screen.dart';
import 'card_preview_screen.dart';
import 'debug_panel_screen.dart';
import 'summon/summon_flow_screen.dart';

/// 主頁 — 暗黑奇幻風格卡片收藏 + 召喚入口
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);

    return Scaffold(
      body: ParticleBackground(
        particleCount: 30,
        color: const Color(0xFFF59E0B),
        speed: 0.5,
        child: SafeArea(
          child: Column(
            children: [
              // ── 頂欄 ──
              _buildTopBar(context, cards.length),
              // ── 主內容 ──
              Expanded(
                child: cards.isEmpty
                    ? _buildEmptyState()
                    : _buildCardShowcase(context, cards),
              ),
              // ── 底部召喚按鈕 ──
              _buildSummonButton(context, ref),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int cardCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          const Text(
            'VOXCARDS',
            style: TextStyle(
              fontFamily: 'BarlowCondensed',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF59E0B),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(width: 12),
          // 卡片數量
          if (cardCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$cardCount',
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          const Spacer(),
          // Debug
          _topBarIcon(
            Icons.tune,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DebugPanelScreen()),
            ),
          ),
          const SizedBox(width: 8),
          // 預覽
          _topBarIcon(
            Icons.style,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CardPreviewScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF374151), width: 0.5),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 魔法陣
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _MagicCirclePainter(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '你的卡組是空的',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF3F4F6),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '拍攝物體、唸出咒語\n召喚你的第一張卡片',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardShowcase(BuildContext context, List<CardModel> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 區段標題
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '我的卡組',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF3F4F6),
                ),
              ),
            ],
          ),
        ),
        // 卡片展示
        Expanded(
          child: cards.length <= 4
              ? _buildCardGrid(context, cards)
              : _buildCardScroll(context, cards),
        ),
      ],
    );
  }

  Widget _buildCardGrid(BuildContext context, List<CardModel> cards) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: cards.map((card) => _buildCardItem(context, card)).toList(),
      ),
    );
  }

  Widget _buildCardScroll(BuildContext context, List<CardModel> cards) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(child: _buildCardItem(context, cards[index])),
        );
      },
    );
  }

  Widget _buildCardItem(BuildContext context, CardModel card) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: card.rarity.color.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Hero(
          tag: 'card-${card.id}',
          child: CardWidget(card: card, scale: 0.55),
        ),
      ),
    );
  }

  Widget _buildSummonButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GlowButton(
        text: '召喚',
        icon: Icons.auto_awesome,
        pulsing: true,
        onPressed: () {
          ref.read(summonProvider.notifier).startSummon();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SummonFlowScreen()),
          );
        },
      ),
    );
  }
}

/// 空狀態魔法陣
class _MagicCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFF59E0B).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 同心圓
    for (double r = 20; r <= 70; r += 16) {
      canvas.drawCircle(center, r, paint);
    }

    // 六角形
    final hexPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();
    for (int i = 0; i <= 6; i++) {
      final angle = (i * pi / 3) - pi / 2;
      final p = Offset(center.dx + 55 * cos(angle), center.dy + 55 * sin(angle));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, hexPaint);

    // 中心十字
    final crossPaint = Paint()
      ..color = const Color(0xFFF59E0B).withOpacity(0.2)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - 10, center.dy),
      Offset(center.dx + 10, center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 10),
      Offset(center.dx, center.dy + 10),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
