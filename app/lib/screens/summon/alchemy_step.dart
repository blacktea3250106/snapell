import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/summon_provider.dart';

/// 步驟 3：煉成等待畫面
///
/// 在 Mock 卡片生成服務處理期間顯示動畫。
/// 從 SummonProvider 監聽狀態，自動切換到 RevealStep。
class AlchemyStep extends ConsumerStatefulWidget {
  const AlchemyStep({super.key});

  @override
  ConsumerState<AlchemyStep> createState() => _AlchemyStepState();
}

class _AlchemyStepState extends ConsumerState<AlchemyStep>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _pulseController;
  late final AnimationController _glowController;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    // 旋轉動畫 — 符文環繞
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // 脈衝動畫 — 中心呼吸
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // 光暈閃爍
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // 文字動畫（...）
    _startDotAnimation();
  }

  void _startDotAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() => _dotCount = (_dotCount + 1) % 4);
      return mounted;
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 監聽錯誤
    final error = ref.watch(summonProvider.select((s) => s.error));
    if (error != null) {
      return _buildError(error);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 煉成動畫
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 外圈光暈
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, _) {
                    final opacity = 0.1 + _glowController.value * 0.2;
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF59E0B).withOpacity(opacity),
                      ),
                    );
                  },
                ),
                // 旋轉符文環 — CustomPainter 繪製
                AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(160, 160),
                      painter: _RuneCirclePainter(
                        progress: _rotateController.value,
                      ),
                    );
                  },
                ),
                // 中心水晶球 — 呼吸縮放
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    final scale = 0.85 + _pulseController.value * 0.3;
                    return Transform.scale(
                      scale: scale,
                      child: const Text('🔮', style: TextStyle(fontSize: 52)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // 煉成中文字
          Text(
            '煉成中${'.' * _dotCount}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF59E0B),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '正在將你的照片和咒語融合...',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          // 顯示咒語文字
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Consumer(
              builder: (context, ref, _) {
                final spell = ref.watch(
                  summonProvider.select((s) => s.spellText ?? ''),
                );
                return Text(
                  '「$spell」',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(fontSize: 16, color: Color(0xFFEF4444)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(summonProvider.notifier).reset();
              },
              child: const Text('重新開始'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 旋轉符文環 — CustomPainter 繪製弧線 + 光點
class _RuneCirclePainter extends CustomPainter {
  final double progress;

  _RuneCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final angle = progress * 2 * pi;

    // 外圈弧線（旋轉）
    final arcPaint = Paint()
      ..color = const Color(0xFFF59E0B).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle,
      pi * 1.2,
      false,
      arcPaint,
    );

    // 第二段弧線（紫色）
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle + pi,
      pi * 0.8,
      false,
      Paint()
        ..color = const Color(0xFFA855F7).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // 內圈弧線（反向旋轉，藍色）
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.75),
      -angle * 1.5,
      pi * 1.4,
      false,
      Paint()
        ..color = const Color(0xFF3B82F6).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    // 軌道上的光點
    for (int i = 0; i < 6; i++) {
      final dotAngle = angle + (i * pi / 3);
      final dotPos = Offset(
        center.dx + radius * cos(dotAngle),
        center.dy + radius * sin(dotAngle),
      );
      final dotOpacity =
          0.3 + 0.7 * ((sin(dotAngle * 2 + progress * 4) + 1) / 2);

      canvas.drawCircle(
        dotPos,
        3,
        Paint()..color = const Color(0xFFF59E0B).withOpacity(dotOpacity),
      );
    }
  }

  @override
  bool shouldRepaint(_RuneCirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
