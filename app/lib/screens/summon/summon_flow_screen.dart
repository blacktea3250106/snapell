import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/summon_provider.dart';
import '../../widgets/particle_background.dart';
import 'camera_step.dart';
import 'spell_step.dart';
import 'alchemy_step.dart';
import 'reveal_step.dart';

/// 召喚流程容器 — 根據 SummonStep 顯示不同階段 + 步驟指示器
class SummonFlowScreen extends ConsumerWidget {
  const SummonFlowScreen({super.key});

  // ignore: unused_field — kept for reference
  static const _stepLabels = ['拍照', '咒語', '煉成', '揭曉'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summonState = ref.watch(summonProvider);
    final stepIndex = _stepToIndex(summonState.step);

    return PopScope(
      canPop: summonState.step == SummonStep.idle ||
          summonState.step == SummonStep.reveal,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitDialog(context, ref);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: ParticleBackground(
          particleCount: 20,
          color: const Color(0xFF6366F1),
          speed: 0.3,
          child: SafeArea(
            child: Column(
              children: [
                // 步驟指示器
                _buildStepIndicator(stepIndex),
                // 主內容
                Expanded(child: _buildCurrentStep(summonState)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Row(
        children: List.generate(4, (i) {
          final isActive = i <= currentIndex;
          final isCurrent = i == currentIndex;
          return Expanded(
            child: Row(
              children: [
                // 圓點
                Container(
                  width: isCurrent ? 12 : 8,
                  height: isCurrent ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF374151),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                // 連接線
                if (i < 3)
                  Expanded(
                    child: Container(
                      height: 1,
                      color: isActive && i < currentIndex
                          ? const Color(0xFFF59E0B).withOpacity(0.4)
                          : const Color(0xFF374151),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(SummonState state) {
    switch (state.step) {
      case SummonStep.idle:
        return const Center(child: Text('準備中...'));
      case SummonStep.camera:
        return const CameraStep();
      case SummonStep.spell:
        return const SpellStep();
      case SummonStep.alchemy:
        return const AlchemyStep();
      case SummonStep.reveal:
        return const RevealStep();
    }
  }

  int _stepToIndex(SummonStep step) {
    switch (step) {
      case SummonStep.idle:
      case SummonStep.camera:
        return 0;
      case SummonStep.spell:
        return 1;
      case SummonStep.alchemy:
        return 2;
      case SummonStep.reveal:
        return 3;
    }
  }

  void _showExitDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('放棄召喚？'),
        content: const Text('目前的進度將不會保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('繼續', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          TextButton(
            onPressed: () {
              ref.read(summonProvider.notifier).reset();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('放棄', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}
