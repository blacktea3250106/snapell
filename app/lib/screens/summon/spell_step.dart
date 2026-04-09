import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../models/rarity.dart';
import '../../providers/summon_provider.dart';
import '../../widgets/glow_button.dart';

/// 步驟 2：輸入咒語 — 魔法能量球風格
class SpellStep extends ConsumerStatefulWidget {
  const SpellStep({super.key});

  @override
  ConsumerState<SpellStep> createState() => _SpellStepState();
}

class _SpellStepState extends ConsumerState<SpellStep>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _useTextMode = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;
  final _textController = TextEditingController();
  late final AnimationController _pulseController;
  late final AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _textController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'STEP 2',
            style: TextStyle(
              fontFamily: 'BarlowCondensed',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA855F7),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '唸出咒語',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF3F4F6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _useTextMode ? '輸入你的咒語文字' : '長按能量球，大聲唸出咒語',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          if (_useTextMode) _buildTextInput() else _buildVoiceInput(),
          const Spacer(),
          // 稀有度選擇器
          _buildRaritySelector(),
          const SizedBox(height: 12),
          // 模式切換
          GestureDetector(
            onTap: () => setState(() {
              _useTextMode = !_useTextMode;
              if (_isRecording) _stopRecording();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF374151)),
              ),
              child: Text(
                _useTextMode ? '切換到語音模式' : '改用文字輸入',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVoiceInput() {
    return Column(
      children: [
        // 能量環動畫
        SizedBox(
          height: 60,
          child: _isRecording ? _buildEnergyWave() : const SizedBox(),
        ),
        const SizedBox(height: 16),
        if (_isRecording)
          Text(
            '$_recordSeconds 秒 / ${AppConstants.spellMaxDuration} 秒',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFA855F7),
            ),
          ),
        const SizedBox(height: 24),
        // 能量球按鈕
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopRecording(),
          child: AnimatedBuilder(
            animation: _orbController,
            builder: (context, _) {
              return SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 旋轉外環
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _OrbRingPainter(
                        progress: _orbController.value,
                        isActive: _isRecording,
                      ),
                    ),
                    // 中心能量球
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) {
                        final scale = _isRecording
                            ? 1.0 + _pulseController.value * 0.15
                            : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: _isRecording
                                    ? [
                                        const Color(0xFFEF4444),
                                        const Color(0xFFEF4444).withOpacity(0.6),
                                        const Color(0xFF7F1D1D),
                                      ]
                                    : [
                                        const Color(0xFFA855F7).withOpacity(0.8),
                                        const Color(0xFF6366F1).withOpacity(0.5),
                                        const Color(0xFF1F2937),
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRecording
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFFA855F7))
                                      .withOpacity(0.4),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isRecording ? Icons.mic : Icons.mic_none,
                              size: 32,
                              color: Colors.white,
                            ),
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
        const SizedBox(height: 16),
        Text(
          _isRecording ? '放開結束錄音' : '長按開始錄音',
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildEnergyWave() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(20, (i) {
            final offset = (i * 0.15 + _pulseController.value * pi * 2);
            final height = 10 + 30 * ((offset % pi).abs() / pi);
            return Container(
              width: 3,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTextInput() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                blurRadius: 12,
              ),
            ],
          ),
          child: TextField(
            controller: _textController,
            style: const TextStyle(color: Color(0xFFF3F4F6), fontSize: 16),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '例如：「燃燒吧！黃金肉球！」',
              hintStyle: TextStyle(color: Color(0xFF4B5563)),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        GlowButton(
          text: '發動咒語！',
          icon: Icons.bolt,
          onPressed: _submitTextSpell,
        ),
      ],
    );
  }

  Widget _buildRaritySelector() {
    final forcedRarity = ref.watch(summonProvider.select((s) => s.forcedRarity));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_fix_high, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                forcedRarity == null ? '稀有度：隨機' : '稀有度：${forcedRarity.label}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: forcedRarity?.color ?? const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _rarityChip(null, '隨機', const Color(0xFF6B7280), forcedRarity == null),
              for (final r in Rarity.values)
                _rarityChip(r, r.label, r.color, forcedRarity == r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rarityChip(Rarity? rarity, String label, Color color, bool selected) {
    return GestureDetector(
      onTap: () => ref.read(summonProvider.notifier).setForcedRarity(rarity),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : const Color(0xFF374151),
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? color : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  void _startRecording() {
    setState(() { _isRecording = true; _recordSeconds = 0; });
    _pulseController.repeat();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordSeconds++);
      if (_recordSeconds >= AppConstants.spellMaxDuration) _stopRecording();
    });
  }

  void _stopRecording() {
    _recordTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    if (!_isRecording) return;
    setState(() => _isRecording = false);

    if (_recordSeconds < AppConstants.spellMinDuration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('咒語太短了！至少需要 3 秒')),
      );
      return;
    }
    _showMockTranscriptDialog();
  }

  void _showMockTranscriptDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('語音辨識（模擬）'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Phase 1 尚未接語音辨識，請手動輸入咒語文字：'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                style: const TextStyle(color: Color(0xFFF3F4F6)),
                decoration: InputDecoration(
                  hintText: '輸入你剛才唸的咒語...',
                  hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF374151)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                final text = controller.text.trim();
                if (text.isNotEmpty) _submitSpell(text);
              },
              child: const Text('確認', style: TextStyle(color: Color(0xFFF59E0B))),
            ),
          ],
        );
      },
    );
  }

  void _submitTextSpell() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('咒語不能是空的！')),
      );
      return;
    }
    _submitSpell(text);
  }

  void _submitSpell(String text) {
    ref.read(summonProvider.notifier).setSpellAndGenerate(text: text);
  }
}

/// 能量球外環
class _OrbRingPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  _OrbRingPainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final angle = progress * 2 * pi;
    final color = isActive ? const Color(0xFFEF4444) : const Color(0xFFA855F7);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle, pi * 1.0, false,
      Paint()
        ..color = color.withOpacity(0.4)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.85),
      -angle * 1.3, pi * 0.7, false,
      Paint()
        ..color = const Color(0xFF6366F1).withOpacity(0.3)
        ..style = PaintingStyle.stroke..strokeWidth = 1..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_OrbRingPainter old) => old.progress != progress || old.isActive != isActive;
}
