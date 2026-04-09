import 'dart:math';
import 'package:flutter/material.dart';

/// 飄浮粒子背景 — 用於營造魔法氛圍
///
/// CustomPainter 繪製隨機光點，緩慢飄浮移動。
/// [particleCount] 粒子數量，[color] 粒子顏色，[speed] 移動速度倍率。
class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double speed;
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.particleCount = 40,
    this.color = const Color(0xFFF59E0B),
    this.speed = 1.0,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(widget.particleCount, (_) => _Particle(rng));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _controller.value,
                  color: widget.color,
                  speed: widget.speed,
                ),
              );
            },
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Particle {
  final double x; // 0~1
  final double y; // 0~1
  final double size; // 0.5~3
  final double opacity; // 0.1~0.6
  final double speedX; // -0.02~0.02
  final double speedY; // -0.01~-0.05 (mostly upward)
  final double phase; // 0~2pi (for twinkle)

  _Particle(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        size = 0.5 + rng.nextDouble() * 2.5,
        opacity = 0.1 + rng.nextDouble() * 0.5,
        speedX = (rng.nextDouble() - 0.5) * 0.04,
        speedY = -(0.01 + rng.nextDouble() * 0.04),
        phase = rng.nextDouble() * 2 * pi;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final double speed;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Position wraps around
      final time = progress * 10 * speed;
      var px = (p.x + p.speedX * time) % 1.0;
      var py = (p.y + p.speedY * time) % 1.0;
      if (px < 0) px += 1;
      if (py < 0) py += 1;

      // Twinkle effect
      final twinkle = (sin(time * 3 + p.phase) + 1) / 2;
      final alpha = p.opacity * (0.3 + 0.7 * twinkle);

      canvas.drawCircle(
        Offset(px * size.width, py * size.height),
        p.size,
        Paint()..color = color.withOpacity(alpha.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
