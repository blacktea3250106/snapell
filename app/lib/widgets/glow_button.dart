import 'package:flutter/material.dart';

/// 遊戲風格發光按鈕
///
/// 金色漸層背景 + 光暈 + 按壓縮放動畫。
/// [isPrimary] true = 金色主按鈕，false = 描邊次要按鈕。
class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final double width;
  final bool pulsing; // 是否加脈動光暈

  const GlowButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.width = double.infinity,
    this.pulsing = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.pulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressing = true),
      onTapUp: (_) {
        setState(() => _pressing = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressing = false),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          final pulseValue = widget.pulsing ? _pulseController.value : 0.0;
          final scale = _pressing ? 0.95 : 1.0;

          return AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: widget.isPrimary
                  ? _primaryDecoration(pulseValue)
                  : _secondaryDecoration(pulseValue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 20,
                      color: widget.isPrimary
                          ? const Color(0xFF0A0A0F)
                          : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: widget.isPrimary
                          ? const Color(0xFF0A0A0F)
                          : const Color(0xFFF3F4F6),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _primaryDecoration(double pulse) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFFBBF24)],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFF59E0B).withOpacity(0.3 + pulse * 0.3),
          blurRadius: 16 + pulse * 12,
          spreadRadius: pulse * 4,
        ),
      ],
    );
  }

  BoxDecoration _secondaryDecoration(double pulse) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF374151).withOpacity(0.6 + pulse * 0.4),
        width: 1.5,
      ),
      boxShadow: widget.pulsing
          ? [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(pulse * 0.2),
                blurRadius: 8 + pulse * 8,
              ),
            ]
          : null,
    );
  }
}
