/// 咒語評分（三維度各 0-10）
class SpellScore {
  final int relevance; // 契合度
  final int energy; // 氣勢
  final int creativity; // 創意

  const SpellScore({
    required this.relevance,
    required this.energy,
    required this.creativity,
  });

  /// 總分（0-30）
  int get total => relevance + energy + creativity;

  Map<String, dynamic> toMap() => {
        'relevance': relevance,
        'energy': energy,
        'creativity': creativity,
      };

  factory SpellScore.fromMap(Map<String, dynamic> map) => SpellScore(
        relevance: map['relevance'] as int,
        energy: map['energy'] as int,
        creativity: map['creativity'] as int,
      );
}
