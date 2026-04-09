import 'package:flutter/material.dart';
import '../../models/card_model.dart';
import '../../models/rarity.dart';
import '../../core/image_helper.dart';
import 'rarity_theme.dart';

/// VoxCards 統一卡片 Widget
///
/// 結構：
/// ┌─ 邊框（稀有度決定）──────────┐
/// │  [等級徽章]                    │
/// │  ┌─ 照片區 270×240 ─────┐    │
/// │  │  玩家照片 + 稀有度濾鏡 │    │
/// │  └───────────────────────┘    │
/// │  ── 分隔線（稀有度色）────    │
/// │  卡名                          │
/// │  ATK  DEF  SPD                 │
/// │  ┌ 被動技能 ──────────┐       │
/// │  │ 技能名 + 描述       │       │
/// │  └─────────────────────┘       │
/// │  📍地點  日期  #編號           │
/// └────────────────────────────────┘
class CardWidget extends StatelessWidget {
  final CardModel card;
  final double scale;

  const CardWidget({
    super.key,
    required this.card,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RarityTheme(card.rarity);
    final w = 300.0 * scale;
    final h = 400.0 * scale;

    return SizedBox(
      width: w,
      height: h,
      child: DecoratedBox(
        decoration: theme.borderDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12 * scale),
          child: Column(
            children: [
              // 照片區
              _buildPhotoArea(theme),
              // 資訊區
              Expanded(child: _buildInfoArea(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea(RarityTheme theme) {
    return Container(
      width: 270 * scale,
      height: 240 * scale,
      margin: EdgeInsets.only(top: 15 * scale),
      child: Stack(
        children: [
          // 照片
          ClipRRect(
            borderRadius: BorderRadius.circular(6 * scale),
            child: _buildPhoto(),
          ),
          // 等級徽章
          Positioned(
            top: 8 * scale,
            right: 8 * scale,
            child: _buildLevelBadge(theme),
          ),
          // 稀有度角標（Epic+ 才有）
          if (card.rarity.index >= Rarity.epic.index)
            Positioned(
              top: 8 * scale,
              left: 8 * scale,
              child: _buildRarityBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    // 本地照片
    if (card.localPhotoPath != null) {
      return buildLocalImage(
        card.localPhotoPath!,
        width: 270 * scale,
        height: 240 * scale,
        fallback: _buildPhotoPlaceholder(),
      );
    }
    // 網路照片
    if (card.photoUrl != null) {
      return Image.network(
        card.photoUrl!,
        width: 270 * scale,
        height: 240 * scale,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPhotoPlaceholder(),
      );
    }
    return _buildPhotoPlaceholder();
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 270 * scale,
      height: 240 * scale,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3F4F6),
            Color(0xFFE5E7EB),
            Color(0xFFF3F4F6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_camera,
                size: 32 * scale, color: const Color(0xFFD1D5DB)),
            SizedBox(height: 4 * scale),
            Text(
              '玩家的照片',
              style: TextStyle(
                fontSize: 11 * scale,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(RarityTheme theme) {
    return Container(
      width: 28 * scale,
      height: 28 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.85),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lv.${card.level}',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontWeight: FontWeight.w700,
              fontSize: 8 * scale,
              color: const Color(0xFF374151),
              height: 1,
            ),
          ),
          SizedBox(height: 1 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              card.rarity.starCount.clamp(1, 3),
              (i) => Container(
                width: 3 * scale,
                height: 3 * scale,
                margin: EdgeInsets.symmetric(horizontal: 0.5 * scale),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: card.rarity.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRarityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6 * scale,
        vertical: 2 * scale,
      ),
      decoration: BoxDecoration(
        color: card.rarity.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4 * scale),
      ),
      child: Text(
        card.rarity.label,
        style: TextStyle(
          fontSize: 9 * scale,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoArea(RarityTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15 * scale,
        vertical: 6 * scale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分隔線
          Container(
            height: 1 * scale,
            color: theme.dividerColor,
            margin: EdgeInsets.only(bottom: 4 * scale),
          ),
          // 卡名
          Text(
            card.name,
            style: TextStyle(
              fontFamily: 'NotoSansTC',
              fontSize: 16 * scale,
              fontWeight: theme.nameWeight,
              color: card.rarity.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2 * scale),
          // ATK DEF SPD
          _buildStatsRow(theme),
          SizedBox(height: 4 * scale),
          // 被動技能
          _buildSkillBox(theme),
          const Spacer(),
          // 底欄
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildStatsRow(RarityTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat('⚔️', card.atk, theme),
        _buildStat('🛡️', card.def, theme),
        _buildStat('⚡', card.spd, theme),
      ],
    );
  }

  Widget _buildStat(String icon, int value, RarityTheme theme) {
    return Row(
      children: [
        Text(icon, style: TextStyle(fontSize: 13 * scale)),
        SizedBox(width: 2 * scale),
        Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontWeight: FontWeight.w700,
            fontSize: 18 * scale,
            color: theme.statColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBox(RarityTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6 * scale),
      decoration: theme.skillBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.passive.name,
            style: TextStyle(
              fontFamily: 'NotoSansTC',
              fontSize: 11 * scale,
              fontWeight: FontWeight.w700,
              color: card.rarity.secondaryTextColor,
            ),
          ),
          SizedBox(height: 1 * scale),
          Text(
            card.passive.description,
            style: TextStyle(
              fontFamily: 'NotoSansTC',
              fontSize: 9 * scale,
              color: card.rarity.secondaryTextColor.withOpacity(0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(RarityTheme theme) {
    final date =
        '${card.createdAt.month.toString().padLeft(2, '0')}.${card.createdAt.day.toString().padLeft(2, '0')}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '📍${card.createdLocation ?? '未知'}  🗣️▶  $date',
          style: TextStyle(
            fontSize: 8 * scale,
            color: card.rarity.secondaryTextColor.withOpacity(0.6),
          ),
        ),
        Text(
          '#${card.globalIndex.toString().padLeft(5, '0')}',
          style: TextStyle(
            fontSize: 8 * scale,
            color: card.rarity.secondaryTextColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
