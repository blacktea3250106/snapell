import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/image_helper.dart';
import '../../providers/summon_provider.dart';
import '../../widgets/glow_button.dart';

/// 步驟 1：拍照 — 魔法陣風格相機按鈕
class CameraStep extends ConsumerStatefulWidget {
  const CameraStep({super.key});

  @override
  ConsumerState<CameraStep> createState() => _CameraStepState();
}

class _CameraStepState extends ConsumerState<CameraStep>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  XFile? _pickedFile;
  bool _isLoading = false;
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
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
            'STEP 1',
            style: TextStyle(
              fontFamily: 'BarlowCondensed',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF59E0B),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '拍攝召喚物',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF3F4F6),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '對準任何物體，它將成為你的卡片',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          if (_pickedFile != null) _buildPreview() else _buildCaptureArea(),
          const Spacer(),
          if (_pickedFile != null) ...[
            Row(
              children: [
                Expanded(
                  child: GlowButton(
                    text: '重拍',
                    isPrimary: false,
                    onPressed: () => setState(() => _pickedFile = null),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlowButton(
                    text: '確認',
                    onPressed: _confirmPhoto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptureArea() {
    return Column(
      children: [
        GestureDetector(
          onTap: _isLoading ? null : () => _pickImage(ImageSource.camera),
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(160, 160),
                      painter: _CaptureRingPainter(
                        progress: _ringController.value,
                      ),
                    );
                  },
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1F2937),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              color: Color(0xFFF59E0B),
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const Icon(Icons.camera_alt, size: 36, color: Color(0xFFF59E0B)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _isLoading ? null : () => _pickImage(ImageSource.gallery),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF374151)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library, size: 16, color: Color(0xFF6B7280)),
                SizedBox(width: 6),
                Text('從相簿選擇', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: buildLocalImage(
          _pickedFile!.path,
          width: 270,
          height: 240,
          fallback: const SizedBox(
            width: 270,
            height: 240,
            child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final photo = await _picker.pickImage(source: source, imageQuality: 70, maxWidth: 1024);
      if (photo != null && mounted) setState(() => _pickedFile = photo);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('無法取得照片：$e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmPhoto() {
    if (_pickedFile != null) ref.read(summonProvider.notifier).setPhoto(_pickedFile!.path);
  }
}

class _CaptureRingPainter extends CustomPainter {
  final double progress;
  _CaptureRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final angle = progress * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle, pi * 0.8, false,
      Paint()
        ..color = const Color(0xFFF59E0B).withOpacity(0.5)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -angle * 0.7 + pi, pi * 0.6, false,
      Paint()
        ..color = const Color(0xFF6366F1).withOpacity(0.35)
        ..style = PaintingStyle.stroke..strokeWidth = 1..strokeCap = StrokeCap.round,
    );
    for (int i = 0; i < 4; i++) {
      final da = angle + (i * pi / 2);
      canvas.drawCircle(
        Offset(center.dx + radius * cos(da), center.dy + radius * sin(da)),
        2, Paint()..color = const Color(0xFFF59E0B).withOpacity(0.6),
      );
    }
  }

  @override
  bool shouldRepaint(_CaptureRingPainter old) => old.progress != progress;
}
