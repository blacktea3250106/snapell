# Snapell 卡面渲染 — v0 版（前端 CustomPainter）

> **v0 決策：** 不用 Sharp 後端合成卡面圖，改由前端 CustomPainter 即時渲染。
> 省掉 Sharp 依賴、後端合成時間、Storage 卡面圖片存儲。
>
> **完整設計參考：** `CARD_VISUAL_DESIGN.md`（v4 統一風格 + 光的遞進）

---

## 1. v0 卡面渲染策略

### 為什麼前端渲染

| 方案 | 優點 | 缺點 |
|------|------|------|
| **Sharp 後端合成**（原 MVP） | 產出固定圖片，跨平台一致 | 需要 Sharp + 模板 + Storage 存儲 + 合成時間 1~2s |
| **前端 CustomPainter**（v0） | 零後端依賴，即時渲染，迭代快 | 需要 Flutter 端實作，分享時需要截圖 |

v0 選前端渲染，原因：
1. 一人團隊，少一個後端依賴 = 少一個出錯點
2. 卡面設計還在迭代，前端改起來比後端快
3. 製卡 API 回傳資料即可，不需要等合成
4. 分享截圖用 `RepaintBoundary` + `toImage()` 即可解決

### v0→v1 遷移

v1 如果需要 Sharp 合成（例如：分享圖品質、SEO 預覽圖），可以補一個背景 Cloud Function 在卡片建立後異步合成。**不影響 v0 的資料結構。**

---

## 2. 卡面佈局

### 基礎結構

```
┌─────────────────────────────────┐
│  ┌───────────────────────────┐  │
│  │                           │  │  ← 照片區域（上半）
│  │      [玩家照片]            │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  稀有度 icon   卡片名稱          │  ← 標題行
│                                 │
│  「咒語文字」                    │  ← 咒語行（灰色斜體）
│                                 │
│  ATK ██     DEF ██             │  ← 數值行
│                                 │
│  [技能 icon] 技能名稱            │  ← 技能行
│  技能效果描述                    │
│                                 │
│  卡片描述文字...                 │  ← 描述行（小字）
│                                 │
└─────────────────────────────────┘
```

### 尺寸規格

| 項目 | 數值 |
|------|------|
| 卡片比例 | 2.5:3.5（標準撲克牌比例） |
| 渲染寬度 | 300dp（列表卡片）/ 螢幕寬 - 32dp padding（詳情） |
| 照片區域 | 佔卡面高度 45% |
| 圓角 | 12dp |
| 邊框 | 2dp（稀有度對應色） |

---

## 3. 稀有度視覺差異（v0 簡化版）

v0 只用**邊框顏色 + 背景色微調**區分稀有度，不做 Shader 特效。

| 稀有度 | 邊框色 | 背景色 | v0 額外效果 |
|--------|--------|--------|-----------|
| ⚪ 凡品 | `#9E9E9E` 灰 | 純白 `#FFFFFF` | 無 |
| 🟢 精良 | `#4CAF50` 綠 | 白 `#FAFFF5` | 無 |
| 🔵 稀有 | `#2196F3` 藍 | 白 `#F5F9FF` | 邊框加粗 3dp |
| 🟣 史詩 | `#9C27B0` 紫 | 白 `#FBF5FF` | 邊框加粗 3dp |
| 🟡 傳說 | `#FFC107` 金 | 白 `#FFFDF0` | 邊框加粗 4dp + 外發光 |
| 🔴 神話 | `#F44336` 紅 | 深色 `#1A1A2E` | 邊框加粗 4dp + 外發光 + 文字白色 |

### v0 不做

- Fragment Shader（brushed metal、holographic、iridescent）
- 陀螺儀互動
- 粒子動畫
- 光暈漸變

這些都是 v1+ 的視覺增強，v0 只要「看得出稀有度差異」即可。

---

## 4. 字型

| 用途 | 字型 | 備註 |
|------|------|------|
| 卡片名稱 | Noto Sans TC Bold | 繁體中文 |
| 咒語文字 | Noto Sans TC Regular Italic | 斜體 |
| ATK/DEF 數值 | Barlow Condensed Bold | 英數字 |
| 技能名稱 | Noto Sans TC Medium | 繁體中文 |
| 技能描述 | Noto Sans TC Regular | 繁體中文 |
| 卡片描述 | Noto Sans TC Light | 小字 |

所有字型都是 Google Fonts，免費。

---

## 5. CustomPainter 實作要點

### Widget 結構

```dart
class CardWidget extends StatelessWidget {
  final CardDocument card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor(card.rarity),
        border: Border.all(
          color: _borderColor(card.rarity),
          width: _borderWidth(card.rarity),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _shouldGlow(card.rarity)
          ? [BoxShadow(color: _borderColor(card.rarity).withOpacity(0.4), blurRadius: 12)]
          : null,
      ),
      child: Column(
        children: [
          // 照片區域
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(card.photoUrl, fit: BoxFit.cover),
          ),
          // 標題行
          _buildTitleRow(),
          // 咒語
          if (card.spellText.isNotEmpty) _buildSpellText(),
          // 數值
          _buildStatsRow(),
          // 技能
          _buildSkillSection(),
          // 描述
          _buildDescription(),
        ],
      ),
    );
  }
}
```

### 分享截圖

```dart
// 用 RepaintBoundary 包裹 CardWidget
final boundary = _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
final image = await boundary.toImage(pixelRatio: 3.0);
final byteData = await image.toByteData(format: ImageByteFormat.png);
// → 存為臨時檔案 → 呼叫系統分享
```

---

## 6. 卡片列表視覺

### 列表模式

```
┌─────┐  ┌─────┐  ┌─────┐
│ 🔵  │  │ ⚪  │  │ 🟢  │
│     │  │     │  │     │
│ ATK │  │ ATK │  │ ATK │
│ DEF │  │ DEF │  │ DEF │
└─────┘  └─────┘  └─────┘

兩列 GridView，卡片寬度 = (螢幕寬 - 48) / 2
```

### 篩選

- 按稀有度篩選（6 個 chip 按鈕）
- 按建立時間排序（預設最新在前）

---

## 7. v0 → v1 視覺升級路線

| 階段 | 新增視覺 |
|------|---------|
| v1.0 | Fragment Shader（🔵+ 才有）— brushed metal、holographic |
| v1.0 | 陀螺儀互動（🟣+） |
| v1.5 | 粒子特效（🟡+） |
| v1.5 | 完整 6 級煉成動畫 |
| v2.0 | Sharp 後端合成（分享圖品質、SEO 預覽） |

v0 的 CustomPainter 卡面在視覺升級後仍然保留作為「基礎渲染層」，Shader 效果疊加在上面。
