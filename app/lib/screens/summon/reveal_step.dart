import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/rarity.dart';
import '../../providers/summon_provider.dart';
import '../../providers/cards_provider.dart';
import '../../widgets/card/card_widget.dart';
import '../../widgets/glow_button.dart';

/// 步驟 4：翻卡揭曉 — 2D 翻轉 + 粒子爆發 + 螢幕震動
class RevealStep extends ConsumerStatefulWidget {
  const RevealStep({super.key});

  @override
  ConsumerState<RevealStep> createState() => _RevealStepState();
}

class _RevealStepState extends ConsumerState<RevealStep>
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final AnimationController _shineController;
  late final AnimationController _shakeController;
  bool _revealed = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    final card = ref.read(summonProvider).generatedCard;
    final duration = card?.rarity.flipDurationMs ?? 800;

    _flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Epic+ 震動效果
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _shineController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summonProvider);
    final card = state.generatedCard;

    if (card == null) {
      return const Center(child: Text('發生錯誤', style: TextStyle(color: Colors.white)));
    }

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, _) {
        // 震動偏移（Epic+）
        final shakeOffset = _shakeController.isAnimating
            ? Offset(
                sin(_shakeController.value * pi * 8) * 3,
                cos(_shakeController.value * pi * 6) * 2,
              )
            : Offset.zero;

        return Transform.translate(
          offset: shakeOffset,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 稀有度標籤
                AnimatedOpacity(
                  opacity: _revealed ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: card.rarity.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: card.rarity.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${card.rarity.label} — Lv.${card.level}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: card.rarity.color,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // 翻卡
                GestureDetector(
                  onTap: _revealed ? null : _startReveal,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, _) {
                      final progress = _flipAnimation.value;
                      final isFront = progress >= 0.5;
                      final scaleX = isFront
                          ? (progress - 0.5) * 2
                          : 1 - progress * 2;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(scaleX, 1.0, 1.0),
                        child: Stack(
                          children: [
                            if (isFront)
                              CardWidget(card: card)
                            else
                              _buildCardBack(),
                            // 閃光
                            if (_revealed)
                              AnimatedBuilder(
                                animation: _shineController,
                                builder: (context, _) {
                                  final opacity = (1 - _shineController.value) * 0.6;
                                  return Container(
                                    width: 300,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: card.rarity.color
                                          .withOpacity(opacity.clamp(0.0, 1.0)),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                // 提示 / 按鈕
                if (!_revealed) ...[
                  const Text(
                    '點擊翻開卡片',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.4, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOut,
                    builder: (_, value, child) => Opacity(opacity: value, child: child),
                    onEnd: () {},
                    child: const Icon(Icons.touch_app, color: Color(0xFF6B7280), size: 28),
                  ),
                ] else ...[
                  // 除錯資訊
                  if (state.debugInfo != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF374151), width: 0.5),
                      ),
                      child: Text(
                        state.debugInfo!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // 操作按鈕
                  Row(
                    children: [
                      Expanded(
                        child: GlowButton(
                          text: '再召喚一次',
                          isPrimary: false,
                          onPressed: () => ref.read(summonProvider.notifier).reset(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlowButton(
                          text: _saved ? '回到首頁' : '收藏卡片',
                          onPressed: _saved
                              ? () {
                                  ref.read(summonProvider.notifier).reset();
                                  Navigator.pop(context);
                                }
                              : () => _saveAndReturn(card),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF1E1B4B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _CardBackPatternPainter())),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.5), width: 2),
                  ),
                  child: const Center(
                    child: Text('V', style: TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF818CF8),
                    )),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'VOXCARDS',
                  style: TextStyle(
                    fontFamily: 'BarlowCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF818CF8),
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startReveal() {
    setState(() => _revealed = true);
    final card = ref.read(summonProvider).generatedCard;

    _flipController.forward().then((_) {
      _shineController.forward();
      // Epic+ 螢幕震動
      if (card != null && card.rarity.index >= Rarity.epic.index) {
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });
  }

  void _saveAndReturn(card) {
    ref.read(cardsProvider.notifier).addCard(card);
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.name} 已加入你的卡組！'),
        backgroundColor: const Color(0xFF22C55E),
      ),
    );
  }
}

class _CardBackPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4338CA).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (double r = 30; r < 160; r += 25) {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + 150 * cos(angle), cy + 150 * sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
