/// 被動技能模型
class PassiveSkill {
  final PassiveTemplate template;
  final String name;
  final String description;
  final String condition;
  final String effect;

  const PassiveSkill({
    required this.template,
    required this.name,
    required this.description,
    required this.condition,
    required this.effect,
  });

  Map<String, dynamic> toMap() => {
        'template': template.name,
        'name': name,
        'description': description,
        'condition': condition,
        'effect': effect,
      };

  factory PassiveSkill.fromMap(Map<String, dynamic> map) => PassiveSkill(
        template: PassiveTemplate.values.firstWhere(
          (e) => e.name == map['template'],
          orElse: () => PassiveTemplate.selfAmplify,
        ),
        name: map['name'] as String,
        description: map['description'] as String,
        condition: map['condition'] as String,
        effect: map['effect'] as String,
      );
}

/// 6 種被動技能模板
enum PassiveTemplate {
  selfAmplify, // 自身增幅
  selfSpellBoost, // 自身咒語增強
  enemyDebuff, // 敵方削弱
  floorProtection, // 保底護盾
  gamble, // 賭博型
  chainReaction; // 連鎖反應

  String get label {
    switch (this) {
      case PassiveTemplate.selfAmplify:
        return '自身增幅型';
      case PassiveTemplate.selfSpellBoost:
        return '自身咒語增強型';
      case PassiveTemplate.enemyDebuff:
        return '敵方削弱型';
      case PassiveTemplate.floorProtection:
        return '保底護盾型';
      case PassiveTemplate.gamble:
        return '賭博型';
      case PassiveTemplate.chainReaction:
        return '連鎖反應型';
    }
  }
}
