import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../models/rarity.dart';
import '../models/passive_skill.dart';
import '../models/spell_score.dart';
import '../providers/cards_provider.dart';
import '../widgets/card/card_widget.dart';

/// 開發者 Debug 面板 — 手動設定卡片參數並即時預覽
class DebugPanelScreen extends ConsumerStatefulWidget {
  const DebugPanelScreen({super.key});

  @override
  ConsumerState<DebugPanelScreen> createState() => _DebugPanelScreenState();
}

class _DebugPanelScreenState extends ConsumerState<DebugPanelScreen> {
  // 稀有度
  Rarity _rarity = Rarity.common;

  // 等級
  double _level = 10;

  // 分數
  double _photoScore = 15;
  double _relevance = 5;
  double _energy = 5;
  double _creativity = 5;
  double _fateValue = 10;

  // 卡片文字
  final _nameController = TextEditingController(text: '🔮 測試卡片');
  final _descController = TextEditingController(text: '一張用來測試參數的卡片。');
  final _spellController = TextEditingController(text: '測試咒語發動！');

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _spellController.dispose();
    super.dispose();
  }

  int get _totalScore =>
      _photoScore.round() +
      _relevance.round() +
      _energy.round() +
      _creativity.round() +
      _fateValue.round();

  Rarity get _autoRarity => Rarity.fromScore(_totalScore);

  CardModel get _previewCard => CardModel(
        id: 'debug-preview',
        ownerId: 'debug',
        name: _nameController.text,
        level: _level.round(),
        rarity: _rarity,
        passive: const PassiveSkill(
          template: PassiveTemplate.selfAmplify,
          name: '🛠️ Debug 技能',
          description: '開發模式限定技能',
          condition: 'Debug 模式',
          effect: '全屬性+999',
        ),
        description: _descController.text,
        spellText: _spellController.text,
        spellScore: SpellScore(
          relevance: _relevance.round(),
          energy: _energy.round(),
          creativity: _creativity.round(),
        ),
        photoScore: _photoScore.round(),
        fateValue: _fateValue.round(),
        totalScore: _totalScore,
        createdAt: DateTime.now(),
        createdLocation: 'Debug',
        globalIndex: 1,
        globalCount: 1,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
        title: const Text('Debug 面板'),
        actions: [
          TextButton(
            onPressed: _addToCollection,
            child: const Text('加入卡組', style: TextStyle(color: Color(0xFF22C55E))),
          ),
        ],
      ),
      body: Row(
        children: [
          // 左側：即時預覽
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 稀有度 + 等級標籤
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _rarity.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _rarity.color.withOpacity(0.3)),
                      ),
                      child: Text(
                        '${_rarity.label} — Lv.${_level.round()}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _rarity.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 卡片預覽
                    CardWidget(card: _previewCard),
                    const SizedBox(height: 12),
                    // 總分
                    Text(
                      '總分 $_totalScore（自動: ${_autoRarity.label}）',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 右側：控制面板
          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF1F2937),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── 稀有度選擇 ──
                    _sectionTitle('稀有度'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: Rarity.values.map((r) {
                        final selected = _rarity == r;
                        return ChoiceChip(
                          label: Text(
                            r.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: selected ? Colors.white : r.color,
                            ),
                          ),
                          selected: selected,
                          selectedColor: r.color,
                          backgroundColor: r.color.withOpacity(0.15),
                          onSelected: (_) => setState(() {
                            _rarity = r;
                            // 自動調整等級到稀有度範圍內
                            final (minLv, maxLv) = r.levelRange;
                            _level = _level.clamp(minLv.toDouble(), maxLv.toDouble());
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // ── 等級 ──
                    _sliderSection(
                      '等級',
                      _level,
                      _rarity.levelRange.$1.toDouble(),
                      _rarity.levelRange.$2.toDouble(),
                      (v) => setState(() => _level = v),
                      valueLabel: 'Lv.${_level.round()}',
                    ),

                    // ── Photo Score ──
                    _sliderSection(
                      'Photo Score',
                      _photoScore,
                      0,
                      30,
                      (v) => setState(() => _photoScore = v),
                    ),

                    // ── Spell Score ──
                    _sectionTitle('Spell Score'),
                    _miniSlider('關聯性', _relevance, (v) => setState(() => _relevance = v)),
                    _miniSlider('能量', _energy, (v) => setState(() => _energy = v)),
                    _miniSlider('創意', _creativity, (v) => setState(() => _creativity = v)),
                    Text(
                      '小計: ${_relevance.round() + _energy.round() + _creativity.round()}/30',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 12),

                    // ── Fate Value ──
                    _sliderSection(
                      'Fate Value',
                      _fateValue,
                      0,
                      40,
                      (v) => setState(() => _fateValue = v),
                    ),

                    // ── 總分顯示 ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _rarity.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _rarity.color.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '總分: $_totalScore / 100',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: _rarity.color,
                            ),
                          ),
                          Text(
                            'ATK ${_previewCard.atk}  DEF ${_previewCard.def}  SPD ${_previewCard.spd}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 卡片文字 ──
                    _sectionTitle('卡片文字'),
                    _textField('卡名', _nameController),
                    const SizedBox(height: 8),
                    _textField('描述', _descController),
                    const SizedBox(height: 8),
                    _textField('咒語', _spellController),
                    const SizedBox(height: 16),

                    // ── 快捷按鈕 ──
                    _sectionTitle('快捷設定'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _quickButton('最低分', () => setState(() {
                          _photoScore = 0;
                          _relevance = 0;
                          _energy = 0;
                          _creativity = 0;
                          _fateValue = 0;
                          _rarity = Rarity.common;
                          _level = 1;
                        })),
                        _quickButton('中等', () => setState(() {
                          _photoScore = 15;
                          _relevance = 5;
                          _energy = 5;
                          _creativity = 5;
                          _fateValue = 20;
                          _rarity = Rarity.rare;
                          _level = 42;
                        })),
                        _quickButton('滿分', () => setState(() {
                          _photoScore = 30;
                          _relevance = 10;
                          _energy = 10;
                          _creativity = 10;
                          _fateValue = 40;
                          _rarity = Rarity.mythic;
                          _level = 100;
                        })),
                        _quickButton('自動稀有度', () => setState(() {
                          _rarity = _autoRarity;
                          final (minLv, maxLv) = _rarity.levelRange;
                          _level = (minLv + (maxLv - minLv) * _totalScore / 100)
                              .clamp(minLv.toDouble(), maxLv.toDouble());
                        })),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── UI Helpers ──

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFFD1D5DB),
        ),
      ),
    );
  }

  Widget _sliderSection(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    String? valueLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFD1D5DB)),
            ),
            Text(
              valueLabel ?? '${value.round()}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF60A5FA)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: const Color(0xFF3B82F6),
            inactiveTrackColor: const Color(0xFF374151),
            thumbColor: const Color(0xFF60A5FA),
            overlayColor: const Color(0xFF3B82F6).withOpacity(0.2),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _miniSlider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: const Color(0xFF3B82F6),
              inactiveTrackColor: const Color(0xFF374151),
              thumbColor: const Color(0xFF60A5FA),
              overlayColor: const Color(0xFF3B82F6).withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 24,
          child: Text(
            '${value.round()}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF60A5FA)),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _textField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF4B5563), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF111827),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _quickButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFD1D5DB),
        side: const BorderSide(color: Color(0xFF374151)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        textStyle: const TextStyle(fontSize: 12),
      ),
      child: Text(label),
    );
  }

  void _addToCollection() {
    ref.read(cardsProvider.notifier).addCard(_previewCard);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_previewCard.name} 已加入卡組！'),
        backgroundColor: const Color(0xFF22C55E),
      ),
    );
  }
}
