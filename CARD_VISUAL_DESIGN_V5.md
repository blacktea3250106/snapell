# Snapell 卡片視覺設計規格 v5

## 「暗匣浮光」Dark Frame + Rising Light

---

# 一、設計哲學

> **你的咒語在黑暗中召喚出光。越強大的召喚，光越耀眼。**

## 核心設計鐵律

```
① 照片永遠是主角 — 暗色框是展示台，讓任何照片看起來都像收藏品
② 暗底統一 — 所有卡片共用深色基底，與遊戲深色 UI 天然融合
③ 光的遞進 — 每升一級「多一層光」，光效面積從 0% → 100%
④ 3 秒辨識 — 縮略圖 75×100dp 靠「光效面積 + 邊框顏色」一眼分辨
⑤ 凡品也好看 — 安靜的深灰拉絲金屬框，不是「沒效果的失敗品」
⑥ 神話破規則 — 不只是更多光效，而是結構性碎裂（唯一框體崩壞的卡）
⑦ 動態驅動分享 — 光效天然適合影片錄製 → TikTok / Reels / 限時動態
```

## 風格定義

```
名稱：「暗匣浮光」Dark Frame + Rising Light
一句話：黑色絨布展示盒中，卡牌隨稀有度釋放越來越強的光

關鍵字：Marvel Snap 暗色質感 × Pokemon 箔面擴張 × OLED 真黑對比 × 咒語召喚隱喻

統一底色：深色系
  所有卡片共用暗色底（#18181B → #12131A 範圍）
  收藏冊打開 = 精品珠寶展示櫃
  零星稀有卡光效散布其中 = 自然形成視覺焦點
  OLED 螢幕完美黑 → 光效對比度接近無限大

光效遞進邏輯（核心）：
  ⚪ 凡品  = 零光效 — 深灰拉絲金屬啞光框（安靜的好看）
  🟢 精良  = 呼吸光 — 邊緣微弱綠色脈動（「咦，有點不一樣」）
  🔵 稀有  = 流光帶 — 銀藍光帶流過邊框 + 拉絲金屬質感
  🟣 史詩  = 全息爆發 — 彩虹 SweepGradient 旋轉框 + 照片全息 + 陀螺儀
  🟡 傳說  = 金色瀰漫 — 金色粒子上升 + 全卡金色光暈 + 軌道光點
  🔴 神話  = 框體碎裂 — 紅色裂縫噴出能量 + 煙霧 + 閃電 + 卡震動

借鑑來源：
  Pokemon TCG：全息面積遞增（0% → 卡圖 → 全卡面 → 破框）
  Marvel Snap：漸進式疊加效果（Frame → Foil → 動畫 → 粒子 → 脈動框）
  Panini Black 1/1：暗色 = 稀有（收藏界的共識）
  OLED 螢幕特性：真正的黑 + 發光形成無限對比
  攝影展覽：深色牆面是照片的最佳展示背景
```

## 為什麼 v5 暗底比 v4 白底更適合 Snapell

```
v4 白底的問題：
  × 70% 的卡（凡品+精良）看起來幾乎一樣 = 習得性無助
  × 白底放大手機照片的所有缺點（曝光不均、雜訊、模糊）
  × 與遊戲深色 UI (#0F172A~#1E293B) 明度跳躍嚴重 = 視覺疲勞
  × OLED 螢幕上白底 = 高耗電 + 浪費完美黑色優勢
  × Apple 極簡風與「喊咒語召喚」的荒誕趣味調性衝突
  × 截圖白卡在社群 feed 中不會讓人停下滑動的手指

v5 暗底的優勢：
  ✓ 攝影界共識：深色背景讓照片「浮起來」（Gallery Wall Effect）
  ✓ 任何品質的照片在暗框中都看起來更有質感
  ✓ OLED 真黑 → 光效對比度接近無限大 → 全息效果驚艷
  ✓ 與深色 UI 天然融合，卡片不再是「貼在 UI 上的異物」
  ✓ Weber-Fechner Law：暗底讓每一點光效增量都被感知為「大幅提升」
  ✓ 暗色中的光 = 完美的「咒語召喚」隱喻
  ✓ 暗底+光效的社群 feed 停留率比白底高 2-3 倍
```

## 行為心理學設計原則

```
① Variable Ratio Reinforcement — 光效面積是稀有度的即時回饋信號
② Weber-Fechner Law — 暗底（低基準）讓每級光效跳躍都被感知為顯著差異
③ Anticipation Gap — 卡片生成時先暗後亮，0.3 秒延遲後光效綻開
④ Von Restorff Effect — 神話是唯一「框體碎裂」的卡（結構性例外）
⑤ Loss Aversion Prevention — 凡品有自己完整的視覺身份（拉絲金屬）
   → 大腦覺得「這張卡是完整的」而非「這張卡缺了什麼」
⑥ Social Proof Loop — 動態光效強迫用影片分享 → 更高觸及率 → 更多下載
```

## 一人團隊鐵律

```
⑧ 全部靠程式碼 — CustomPainter + Fragment Shader + Flutter Widget
⑨ 零外部美術依賴 — 不用 Lottie / PNG / After Effects
⑩ 漸進式精緻化 — 任何一個 Phase 停下來都能上線
⑪ 效果分層 — MVP 先靜態框+微動畫，Shader/粒子/陀螺儀後加
```

---

# 二、稀有度「光的遞進」總覽

```
稀有度    底色       邊框                光效層級               全息面積    一句話
──────────────────────────────────────────────────────────────────────────────────
⚪ 凡品   #1C1C1E    #3A3A3C 拉絲金屬    無                     0%        安靜的金屬收藏卡
🟢 精良   #1A1D1A    #22C55E 微呼吸光    邊緣脈動光暈            0%        邊框在呼吸
🔵 稀有   #181B22    銀藍金屬漸層        光帶流過邊框+拉絲質感     5%        有光在跑！
🟣 史詩   #12131A    彩虹 Sweep 旋轉     照片全息+sweep+陀螺儀   40%       「哇靠在發光！」
🟡 傳說   #141008    金色 Sweep 旋轉     全卡金光+粒子+軌道光點   70%       「我要錄影！」
🔴 神話   #0A0A0F    碎裂+紅色能量      暗全息+煙霧+閃電+卡震    100%      「...什麼鬼？」
```

### 光效面積遞進圖解

```
⚪ 凡品   ┌─────────┐   零光效，拉絲金屬啞光框
         │░░照片░░░│   深灰底安靜好看
         │─────────│
         │  資訊區  │
         └─────────┘

🟢 精良   ┌─────────┐   邊緣微弱綠色呼吸光
         │░░照片░░░│
         │─────────│
         │  資訊區  │
         └━━━━━━━━━┘ ← 邊框有綠色光暈在脈動

🔵 稀有   ┏━━━━━━━━━┓   銀藍光帶流過邊框
         ┃░░照片░░░┃ ← 邊框有光在「跑」
         ┃─────────┃   拉絲金屬 + 浮雕文字
         ┃  資訊區  ┃
         ┗━━━━━━━━━┛

🟣 史詩   ┏━━━━━━━━━┓   邊框彩虹旋轉 + 照片全息
         ┃▓▓照片▓▓▓┃ ← 照片蓋了一層彩虹（Foil！）
         ┃─────────┃   陀螺儀互動 = 轉手機反光
         ┃  資訊區  ┃
         ┗━━━━━━━━━┛   + 追蹤光點

🟡 傳說   ┏━━━━━━━━━┓   全卡金色光暈 + 粒子
         ┃▓▓照片▓▓▓┃ ← 全部都在發金光
         ┃━━━━━━━━━┃   粒子從底部上升
         ┃▓ 資訊區 ▓┃ ← 連資訊區都有淡金底
         ┗━━━━━━━━━┛   + 四角軌道光點

🔴 神話   ╔═══╤═══╤═══╗ ← 邊框裂縫！紅光噴出
         ║▓▓▓▓▓▓▓▓▓║   暗色全息 + 煙霧溢出
         ║───╫───╫───║   閃電 + 卡片震動
         ║▓▓ 資訊 ▓▓║
         ╚═══╧═══╧═══╝ ← 紅色能量溢出
```

---

# 三、卡片尺寸規格

```
比例：3:4（直向）— 與 Pokemon / MTG / Panini 相同

邏輯像素（@1x，Flutter 直接用）：
  卡片整體：300 × 400 dp
  邊框寬度：依稀有度 1~4 dp
  照片區域：270 × 200 dp（左右各 15dp padding）
  資訊區域：270 × 170 dp
  頂部留白：15 dp
  底部留白：10 dp

實際像素（@3x，分享截圖用）：
  卡片整體：900 × 1200 px

各場景尺寸：
  縮略圖（列表）：75 × 100 dp
  對戰用（半螢幕）：150 × 200 dp
  分享圖：1080 × 1350 px（Instagram 最佳）
```

---

# 四、統一佈局 — 所有稀有度共用骨架

```
┌──────────────────────────────────────┐
│  ┌───────── 卡框（統一結構）────────┐  │
│  │                                │  │
│  │  [稀有度角標]                  │  │  ← 覆蓋在照片區左上角
│  │                                │  │
│  │  ┌──── 照片區域 ───────────┐  │  │
│  │  │                         │  │  │
│  │  │     270 × 200 dp        │  │  │
│  │  │                         │  │  │
│  │  │     [玩家的照片]         │  │  │
│  │  │                         │  │  │
│  │  └─────────────────────────┘  │  │
│  │                                │  │
│  │  ── 分隔線 ──────────────────  │  │
│  │                                │  │
│  │  🔥 肉球雷霆                  │  │  ← 卡名（AI 生成，情感核心）
│  │                                │  │
│  │  ATK 37        DEF 25         │  │  ← 戰鬥數值（僅 ATK + DEF）
│  │                                │  │
│  │  ┌── 被動技能 ─────────────┐  │  │
│  │  │ 🌀 肉球連擊             │  │  │  ← skillName（AI 生成）
│  │  │ 揮出兩記致命肉球，       │  │  │  ← skillDesc（AI 生成）
│  │  │ 第二擊額外傷害 5         │  │  │
│  │  └─────────────────────────┘  │  │
│  │                                │  │
│  │  慵懶的外表下藏著毀滅性的     │  │  ← 卡片描述（AI 生成）
│  │  肉球，一擊足以撼動戰場。     │  │
│  │                                │  │
│  └────────────────────────────────┘  │
│                                      │
│  [噪點紋理層 — SVG feTurbulence]     │  ← 所有卡都有微弱噪點
│  [光效層 — Fragment Shader]          │  ← Epic+ 才有全息
│  [粒子層 — CustomPainter]            │  ← Legendary+ 才有
│  [互動層 — sensors_plus 陀螺儀]      │  ← Epic+ 才有
└──────────────────────────────────────┘

關鍵：骨架 100% 相同，差異只在「底色 + 邊框 + 光效 + 色彩」

MVP 卡片資料來源（Firestore CardDocument）：
  name         — AI 生成的卡名
  spellText    — 玩家輸入的咒語文字（MVP 限文字輸入，最多 25 字）
  description  — AI 生成的卡片描述
  battle.atk   — 攻擊力（僅 ATK，無 SPD）
  battle.def   — 防禦力
  battle.skillName — AI 生成的技能名
  battle.skillDesc — AI 生成的技能描述
  rarity       — 稀有度（common/uncommon/rare/epic/legendary/mythic）
  photoUrl     — 玩家照片 URL

注意：MVP 無等級系統、無 GPS 定位、無全服編號、無語音錄製
```

### 資訊層級優先順序

```
1. 照片（佔卡面 50%+ → 這是玩家的作品）
2. 卡名（最大字、最醒目 → AI 生成，情感核心）
3. 數值（ATK/DEF 固定位置、一眼可讀 → 僅兩個數值，無 SPD）
4. 技能（技能名 + 技能描述 → 戰鬥策略核心）
5. 卡片描述（AI 生成的風味文字 → 最底部，兼含咒語意涵）
6. 稀有度（不需要文字 → 光效本身就是標記）

注意：咒語文字（spellText）不顯示在卡面上，描述（description）已包含咒語精神。
咒語仍存於 Firestore 供戰鬥動畫、召喚特效等場景使用。
```

---

# 五、六種稀有度完整規格

## ⚪ 凡品 — 拉絲金屬啞光卡

```
設計靈感：高級名片的深灰金屬質感、暗色相框裡的照片

⚠️ 70% 的卡是凡品。如果凡品不好看 = 70% 的遊戲體驗是失望。

卡片底色：#1C1C1E（深灰 — 不是純黑，留有溫度）
噪點紋理：feTurbulence baseFrequency 0.9, opacity 0.03（微弱質感）

邊框：
  顏色：#3A3A3C（中灰 — 拉絲金屬感）
  寬度：1dp
  圓角：12dp
  質感：100+ 條水平微線 opacity 3%（CustomPainter 拉絲金屬）
  陰影：BoxShadow(#00000040, blur: 12, offset: (0, 4))

照片區域：
  圓角：6dp
  無濾鏡（原照片 + 極輕銳化）
  邊框：0.5dp #FFFFFF08（極微弱內白線 = 品牌 DNA 元素）

分隔線：1dp 實線，#3A3A3C

卡名：
  字體：Noto Sans TC Regular 16dp
  顏色：#D4D4D8（淺灰白 — 在暗底上清楚可讀）

數值：
  標籤：Barlow Condensed SemiBold 8dp，全大寫，#71717A
  數字：Rajdhani Bold 18dp，#A1A1AA
  僅 ATK + DEF 兩個數值，統一灰色（不分色 — 凡品安靜不張揚）

稀有度角標：無（凡品不需要標記 — 沒有標記本身就是標記）

被動技能框：
  #27272A 底 + 1dp #3A3A3C 邊框，圓角 6dp
  技能名：Noto Sans TC Medium 13dp，#A1A1AA
  技能描述：Noto Sans TC Regular 11dp，#71717A

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#52525B（最暗灰 — 風味文字，不搶主角）
  最多 2 行，超出截斷

整體感覺：
  「安靜但完整的收藏品」
  像一張高級深灰名片 — 不張揚但有質感
  拉絲金屬紋理讓凡品有自己的身份，不是「什麼都沒有的卡」
  在暗色收藏頁中低調融入，不丟人

動畫/特效：無（靜態）
光效面積：0%
效能成本：最低
```

## 🟢 精良 — 呼吸微光卡

```
設計靈感：電子設備待機燈的微弱脈動、暗夜中遠處的綠光

卡片底色：#1A1D1A（微偏綠的深灰）
噪點紋理：同凡品

邊框：
  顏色：#22C55E（翠綠色）
  寬度：1.5dp
  圓角：12dp
  外光：MaskFilter.blur(6) + #22C55E opacity 8%
  呼吸動畫：光暈 opacity 0.04 ↔ 0.12，3 秒循環（AnimationController）
  陰影：BoxShadow(#00000050, blur: 14, offset: (0, 4))

照片區域：
  圓角：6dp
  濾鏡：微暖色調（brightness 1.03, saturation 1.03）
  邊框：0.5dp #22C55E15（極微弱綠色內線）

分隔線：1.5dp，#22C55E opacity 30%

卡名：
  字體：Noto Sans TC Medium 16dp
  顏色：#D4D4D8

數值：
  僅 ATK + DEF，數字顏色：#A1A1AA（同凡品 — 精良不需要分色數值）

稀有度角標：
  綠色小圓點 8dp
  背景：#22C55E
  文字：「U」白色 Barlow Condensed 7dp

被動技能框：
  #1A2E1A 底 + 1dp #22C55E25 邊框
  技能名：Noto Sans TC Medium 13dp，#A1A1AA
  技能描述：Noto Sans TC Regular 11dp，#71717A

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#52525B
  最多 2 行

整體感覺：
  跟凡品 90% 一樣的暗色卡
  但邊框是綠色的 + 在微微呼吸
  像電子設備的待機燈 — 暗示「這張卡有點不一樣」
  呼吸動畫在縮略圖中微妙可見

動畫：邊框光暈呼吸（opacity pulse 3s）
光效面積：0%（只有邊框顏色 + 微光暈）
效能成本：低
```

## 🔵 稀有 — 銀藍流光金屬卡

```
設計靈感：Apple Card 鈦合金 / 拉絲鋁合金 / 冰河下的流水

卡片底色：LinearGradient(160°, #181B22 → #1E2230)（微偏藍深灰）
噪點紋理：同凡品

邊框：
  顏色：LinearGradient(135°, #60A5FA → #94A3B8 → #60A5FA)（銀藍金屬漸層）
  寬度：2dp
  圓角：10dp
  雙層結構：外框 2dp + 內線 0.5dp #FFFFFF08
  光帶動畫：一道銀藍光帶沿邊框流動（6 秒一圈）
    → CustomPainter 用 PathMetric.getTangentForOffset 沿路徑取點
    → 光帶寬度 60dp，RadialGradient #60A5FA → transparent
  陰影：BoxShadow(#60A5FA15, blur: 16, offset: (0, 4))

照片區域：
  圓角：4dp（更銳利 = 金屬感）
  濾鏡：冷色調 + 銳化 + CLAHE（精準的冷冽感）
  邊框：1dp #60A5FA20

分隔線：
  LinearGradient(90°, transparent → #60A5FA → transparent)
  1dp，帶漸隱效果

卡名：
  字體：Noto Sans TC SemiBold 17dp
  顏色：#E2E8F0
  浮雕效果：
    text-shadow: (-0.5px, -0.5px, 0, #FFFFFF15) + (0.5px, 0.5px, 1px, #00000040)
    → V 槽雕刻效果 — 光線下文字有凸起感

數值（首次分色 — 僅 ATK + DEF）：
  ATK：#F87171（紅）+ text-shadow 0 0 6px rgba(248,113,113,0.3)
  DEF：#60A5FA（藍）+ text-shadow 0 0 6px rgba(96,165,250,0.3)
  → 數值分色 + 微發光 = 第一個「有光的數字」

標籤風格：
  Barlow Condensed SemiBold 8dp 全大寫
  顏色：#64748B，letter-spacing: 2.0

稀有度角標：
  銀色菱形 22dp（旋轉 45°）
  漸層背景：#60A5FA → #94A3B8
  文字：「R」Barlow Condensed Bold 7dp，#1E293B

被動技能框：
  #1E2230 底 + 1dp #60A5FA25 邊框
  技能名：Noto Sans TC SemiBold 13dp，#E2E8F0（配合卡名浮雕風格）
  技能描述：Noto Sans TC Regular 11dp，#94A3B8

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#64748B
  最多 2 行

刷紋金屬質感（CustomPainter / Fragment Shader）：
  在邊框上疊加微弱水平刷紋
  → CustomPainter 畫 100+ 條隨機細線 opacity 3%
  → 或 Fragment Shader 用 noise 函數生成

全息：
  Foil opacity 0.06（極微弱 — 暗示「開始特別了」）

整體感覺：
  「第一張讓你覺得在拿真正收藏卡的」
  銀藍光帶沿邊框流動 = 即使縮略圖也能看到「有光在跑」
  金屬拉絲質感 + V 槽浮雕文字 = 觸感想像
  數值首次分色發光 = 戰鬥感開始出現

動畫：邊框光帶流動（6s 一圈）
光效面積：~5%（邊框光帶 + 極微全息）
效能成本：低~中
```

## 🟣 史詩 — 全息閃卡

```
設計靈感：Pokemon TCG 全息閃卡 / 轉手機看到彩虹反光的那個瞬間

⚠️ 這是第一個讓人「想要錄影分享」的等級
⚠️ 這是稀有度情緒曲線的爆發點

卡片底色：#12131A（深藍黑）
噪點紋理：feTurbulence baseFrequency 0.9, opacity 0.03

邊框：
  顏色：SweepGradient 彩虹
    [#A855F7 → #EC4899 → #38BDF8 → #34D399 → #FBBF24 → #A855F7]
  寬度：2dp
  圓角：10dp
  動畫：SweepGradient startAngle 每 4 秒轉一圈（@property --glow-angle）
  實作：conic-gradient + mask-composite: exclude（CSS）
       CustomPainter SweepGradient + PathDashPathEffect（Flutter）
  外光：conic-gradient 同色，filter: blur(20px)，opacity 0.5
  追蹤光點：4 個彩色光點沿邊框軌道運行
    → 紫、粉、藍、金，各帶 box-shadow glow
    → 6 秒一圈，等距分布（-1.5s 偏移）

照片區域：
  圓角：6dp
  濾鏡：高對比 + CLAHE + 微紫色調（電影海報感）
  邊框：照片邊緣紫色內發光 inset box-shadow
  暗角：inset box-shadow rgba(0,0,0,0.3) blur 60px
  全息覆蓋（核心賣點）：
    多層彩虹漸層，opacity ~0.08-0.12
    mix-blend-mode: screen
    角度隨陀螺儀 / 動畫搖擺 115°~155°
  Sweep 光束：
    40% 寬度的彩虹光束從左掃到右
    animation: 2.5s ease-in-out infinite
    帶 skewX(-15deg) + blur(6px)

陀螺儀互動（殺手級功能）：
  sensors_plus 陀螺儀數據 → 控制：
    ① 全息光澤角度（轉手機 → 彩虹光移動）
    ② 卡片微傾斜（rotateX/Y ±3°）
    ③ 邊框 SweepGradient 角度偏移
  → 像真的在手上翻看一張 Pokemon 閃卡

全卡全息覆蓋層：
  覆蓋整張卡的微弱彩虹漸層
  opacity 很低，用 screen blend 疊加
  視覺上讓整張卡有微妙的彩虹光澤

分隔線：
  彩虹漸層線 1.5dp
  transparent → 紫 → 粉 → 藍 → transparent
  脈動動畫 opacity 0.5 ↔ 1.0

卡名：
  字體：Noto Sans TC Bold 18dp
  彩虹漸層文字：
    background: linear-gradient(90deg, #C4B5FD, #F9A8D4, #67E8F9, #C4B5FD)
    background-size: 200% auto → shimmer 動畫 3s
    -webkit-background-clip: text
  filter: drop-shadow(0 0 8px rgba(168,85,247,0.4))

數值（僅 ATK + DEF）：
  ATK：#F87171 + text-shadow glow（紅色光暈）
  DEF：#60A5FA + text-shadow glow（藍色光暈）

稀有度角標：
  彩虹 conic-gradient 旋轉圓形 22dp
  跟邊框同步旋轉動畫
  文字：「E」深色 Barlow Condensed Bold 9dp
  box-shadow glow

被動技能框：
  rgba(168,85,247,0.06) 底 + rgba(168,85,247,0.2) 邊框
  內部有 sweep 動畫（光帶掃過）
  技能名：Noto Sans TC Bold 14dp，#C4B5FD
  技能描述：Noto Sans TC Regular 11dp，#A78BFA

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#7C3AED40（淡紫，低調）
  最多 2 行

整體感覺：
  「寶可夢閃卡！轉手機會反光！」
  第一個讓人想拿出手機錄影的等級
  在列表裡一眼就認出 — 邊框在「閃」+ 彩虹色
  全息效果天然適合影片分享（截圖拍不出來 → TikTok / Reels）

光效面積：~40%（照片區全息 + 邊框旋轉光 + 追蹤光點）
效能成本：中
```

## 🟡 傳說 — 黃金聖光卡

```
設計靈感：24K 金卡 / 聖殿裡的金色光柱 / 諸神的祝福

卡片底色：LinearGradient(160°, #141008 → #1A1308)（暗金色調）
噪點紋理：同上

邊框：
  顏色：SweepGradient 金色
    [#F59E0B → #FBBF24 → #D97706 → #92400E → #F59E0B]
  寬度：3dp
  圓角：10dp
  三層結構：外框 2dp + 暗金凹槽 0.5dp + 內線 0.5dp
  動畫：SweepGradient 2 秒一圈 + 四角旋轉光點（8 秒一圈，帶 trail）
  外光：blur(14px) + #F59E0B opacity 35%（金色光暈）

照片區域：
  圓角：4dp
  濾鏡：暖金色調 + CLAHE + 高對比
  全息覆蓋：Foil opacity 0.6（強全息 — 整張照片金色光澤）
  光效覆蓋：RadialGradient #FFD70015 screen blend（金色光暈）
  陀螺儀視差（tiltIntensity: 0.04）

資訊區底色：
  rgba(245,158,11,0.04)（極淡金底 — 連資訊區都被金光浸染）
  → 跟凡品~史詩的純暗底不同

粒子效果（第一個有粒子的等級）：
  數量：20~25 個金色光點
  顏色：#F59E0B（金）+ 少量 #FFFFFF（白閃光）
  大小：2~3dp
  行為：rise — 從底部緩慢上升，到頂部淡出（像金色螢火蟲）
  部分粒子「閃爍」（opacity 突然 1.0 → 0，0.1s）

軌道光點：
  四角各一個金色光點沿邊框軌道移動（8 秒一圈，帶 trail）

分隔線：金色雙線 + 中間 3 個浮雕圓點

卡名：
  字體：Noto Sans TC Bold 19dp
  ShaderMask 金色漸層（#FBBF24 → #F59E0B → #D97706）
  Shadow(color: #F59E0B40, blurRadius: 6)（金色外發光）
  浮雕效果：比稀有更強的 V 槽光影

數值（僅 ATK + DEF）：
  ATK：#F87171 + 金色 text-shadow（紅金混合光暈）
  DEF：#60A5FA + 金色 text-shadow（藍金混合光暈）

稀有度角標：
  金色盾形 26dp（CustomPainter 五邊形盾）
  漸層背景：#F59E0B → #FBBF24
  文字：「L」白色 + gold shadow

被動技能框：
  rgba(245,158,11,0.08) 底 + 金色 1.5dp 邊框 + shimmer 動畫
  技能名：Noto Sans TC Bold 14dp，金色漸層 ShaderMask
  技能描述：Noto Sans TC Regular 11dp，#D97706

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#92400E（暗金色調）
  最多 2 行

整體感覺：
  「金卡！真的在發光！有粒子在飄！」
  重量感 — 像拿著一塊金幣
  在列表裡「自己會亮」— 一眼就想要
  連資訊區都被金光浸染 → 整張卡都在發光

光效面積：~70%（照片 + 邊框 + 資訊區背景 + 粒子 + 軌道光點）
效能成本：中~高
```

## 🔴 神話 — 碎裂禁忌之物

```
設計靈感：SCP 禁忌物品 / 快要爆炸的核心 / 力量太強卡片裝不住

⚠️ 唯一框體碎裂的卡 → Von Restorff Effect（結構性例外）
⚠️ 玩家可能一輩子只見到幾次

卡片底色：#0A0A0F（極深黑 — 不是純黑 #000，留有深度空間）
噪點紋理：opacity 加到 0.05（比其他品質更粗糙 → 石頭質感）

邊框：
  基礎色：#0A0A0F（跟底色融合 — 邊框和卡片是一體的黑暗）
  裂縫：6~8 條裂縫 Path（seed = cardId → 每張卡裂縫不同！）
    裂縫外邊：#DC2626（暗紅）
    裂縫內部：#FF4444（亮紅 = 岩漿感）
    裂縫寬度：1~2dp，從邊框往外延伸 3~5dp
  寬度：4dp 基礎 + 裂縫延伸
  圓角：6dp（比其他品質小 → 銳利 → 危險感）

照片區域：
  圓角：0dp（直角 = 破碎感 = 危險）
  濾鏡：壓暗 + 極高對比 + 微去飽和 + 暗紅色調
  紅色裂縫覆蓋層：CustomPainter 在照片上畫 3~4 條紅色能量線
  強暗角 vignette: 0.4

全息效果：
  Foil opacity 1.0（最強全息 — 但底色暗 → 產生暗紅全息感）
  陀螺儀深度視差 + 粒子跟隨傾斜

粒子效果：
  暗紅粒子 × 18：從裂縫位置「湧出」，向外飄散後淡出
  黑色煙霧 × 5：MaskFilter.blur 大圓 + 極低 opacity（乾冰效果）
  紅色閃電：每 2 秒一條 zigzag Path（0.15s 淡出）
  閃電時：卡片 offset ±0.5dp 震動（0.1s）

邊框動畫：
  裂縫脈動：opacity 0.5 ↔ 1.0，2 秒循環
  整卡呼吸：Transform.scale(1.0 ↔ 1.003)，4 秒循環
  煙霧從邊緣緩慢溢出

分隔線：紅色裂縫線（不規則 Path — 像被力量撕裂）

卡名：
  字體：Noto Sans TC Black 20dp
  顏色：#FF4444 → #DC2626 漸層
  AnimatedOpacity 脈動（opacity 0.7 ↔ 1.0，2 秒循環）

數值（僅 ATK + DEF）：
  ATK：#FF4444 + 紅色脈動 glow（不再分色 — 全部被紅色能量吞噬）
  DEF：#FF4444 + 紅色脈動 glow

稀有度角標：
  紅色裂縫形狀 26dp（不規則多邊形）
  背景：#DC2626 + 脈動動畫
  文字：「M」白色 + red glow

被動技能框：
  #1A0A0A 深紅底 + 紅色脈動邊框 1.5dp
  技能名：Noto Sans TC Black 14dp，#FF4444 + 脈動
  技能描述：Noto Sans TC Medium 11dp，#DC2626

卡片描述：
  字體：Noto Sans TC Regular 10dp
  顏色：#991B1B（暗紅 — 幾乎與背景融合）
  最多 2 行

全服廣播：翻開神話卡 → 全服推送通知

整體感覺：
  「（手抖）這什麼...」
  唯一框體碎裂的卡 — 不是「更多光效」而是「結構崩壞」
  每張卡的裂縫圖案不同（seed = cardId）→ 真正獨一無二
  「力量太強，卡片本身都裝不住」的敘事
  在收藏冊中 = 唯一有紅光脈動的卡（其他卡的光都是冷色/金色）

光效面積：100%（暗色全息 + 裂縫紅光 + 粒子 + 煙霧 + 閃電）
效能成本：高
```

---

# 六、邊框系統 — 參數化架構

```dart
class CardBorderConfig {
  final Color baseColor;           // 底色
  final Color primaryColor;        // 主要邊框色
  final List<Color>? gradient;     // 漸層色（null = 純色）
  final double width;              // 邊框寬度
  final double cornerRadius;       // 圓角
  final double glowBlur;           // 外光模糊半徑（0 = 無光）
  final double glowOpacity;        // 外光透明度
  final bool isAnimated;           // 邊框是否有動畫
  final bool isSweepGradient;      // 是否用 SweepGradient
  final double? sweepSpeed;        // SweepGradient 轉速（秒/圈）
  final bool hasInnerBorder;       // 是否有內線
  final bool hasCracks;            // 是否有裂縫（神話專用）
  final bool hasFlowingLight;      // 是否有流光帶（稀有+）
  final bool hasTrackDots;         // 是否有追蹤光點（史詩+）
  final bool hasParticles;         // 是否有粒子（傳說+）
  final bool hasNoiseTex;          // 是否有噪點紋理（所有卡都有）
}
```

### 各稀有度參數

```
⚪ 凡品：
  baseColor: #1C1C1E, primaryColor: #3A3A3C
  width: 1, cornerRadius: 12
  glowBlur: 0, isAnimated: false, hasNoiseTex: true

🟢 精良：
  baseColor: #1A1D1A, primaryColor: #22C55E
  width: 1.5, cornerRadius: 12
  glowBlur: 6, glowOpacity: 0.08
  isAnimated: true（呼吸脈動 3s）, hasNoiseTex: true

🔵 稀有：
  baseColor: #181B22, gradient: [#60A5FA, #94A3B8, #60A5FA]
  width: 2, cornerRadius: 10
  hasInnerBorder: true, hasFlowingLight: true（6s 一圈）
  glowBlur: 8, glowOpacity: 0.10, hasNoiseTex: true

🟣 史詩：
  baseColor: #12131A, gradient: 彩虹 6 色
  width: 2, cornerRadius: 10
  isSweepGradient: true, sweepSpeed: 4.0
  hasTrackDots: true（4 個彩色光點）
  glowBlur: 20, glowOpacity: 0.50
  isAnimated: true, hasNoiseTex: true

🟡 傳說：
  baseColor: #141008, gradient: 金色 5 色
  width: 3, cornerRadius: 10
  isSweepGradient: true, sweepSpeed: 2.0
  hasInnerBorder: true（三層）, hasTrackDots: true（4 金色光點）
  hasParticles: true（20-25 金色粒子上升）
  glowBlur: 14, glowOpacity: 0.35, hasNoiseTex: true

🔴 神話：
  baseColor: #0A0A0F, primaryColor: #0A0A0F
  width: 4, cornerRadius: 6
  hasCracks: true（6-8 條紅色裂縫，seed=cardId）
  hasParticles: true（18 紅色粒子 + 5 黑霧 + 紅色閃電）
  isAnimated: true（裂縫脈動 + 整卡呼吸 + 煙霧）, hasNoiseTex: true
```

---

# 七、色彩系統

## 底色遞進

```
⚪ #1C1C1E  深灰（最淺的暗色 → 安靜溫暖）
🟢 #1A1D1A  微綠深灰（偏綠調 → 生命跡象）
🔵 #181B22  微藍深灰（偏冷 → 金屬感）
🟣 #12131A  深藍黑（最深 → 沉浸空間）
🟡 #141008  暗金深色（偏暖 → 金色前奏）
🔴 #0A0A0F  極深黑（接近純黑 → 深淵）

底色遞進方向：灰 → 綠灰 → 藍灰 → 藍黑 → 暗金 → 極黑
每一階微調色相 → 收藏冊中有微妙的色彩節奏
```

## 主題色

```
⚪ 無（灰色系）
🟢 #22C55E 翠綠
🔵 #60A5FA 銀藍
🟣 #A855F7 紫色 + #EC4899 粉 + #38BDF8 青 + #34D399 綠 + #FBBF24 金（彩虹）
🟡 #F59E0B 金色 + #FBBF24 亮金 + #D97706 深金
🔴 #DC2626 暗紅 + #FF4444 亮紅
```

## 數值色

```
MVP 僅有兩個戰鬥數值（無 SPD）：
  ATK（攻擊力）：#F87171 柔紅
  DEF（防禦力）：#60A5FA 銀藍

ATK+DEF 範圍（依稀有度）：
  ⚪ 凡品：30~42
  🟢 精良：40~55
  🔵 稀有：53~70
  🟣 史詩：67~84
  🟡 傳說：81~96
  🔴 神話：93~100

顏色邏輯：
  ⚪🟢 凡品/精良：統一灰色 #A1A1AA（不分色 → 安靜）
  🔵🟣🟡 稀有~傳說：分色 + text-shadow glow（發光數字 → 戰鬥感）
  🔴 神話：統一紅色 #FF4444 + 脈動 glow（被紅色能量吞噬）
```

---

# 八、照片處理管線

## 前後端分工

```
後端（Sharp / Cloud Function）→ 永久存入 Storage 的強化照片：
  ① 裁切：Center crop 810×600（對應 270×200dp @3x）
  ② 銳化
  ③ CLAHE 局部對比增強（Rare+）
  ④ 亮度/對比/飽和度調整
  ⑤ 暗角 vignette
  ⑥ 色彩分級 gamma（Epic+）
  ⑦ 色調疊加 tint（Legendary+）

前端（Flutter Widget）→ 即時互動效果：
  ⑧ ColorFilter 微調
  ⑨ 全息覆蓋 Foil（Epic+）
  ⑩ 陀螺儀視差（Epic+）
  ⑪ 光效 Gradient overlay（Legendary+）
```

## 各稀有度濾鏡預設

```javascript
const FILTER_PRESETS = {
  common:    {
    brightness: 1.02, contrast: 1.02, saturation: 1.0,
    sharpen: 0.8, vignette: 0.08,
    clahe: null, gamma: null, tint: null
  },
  uncommon:  {
    brightness: 1.03, contrast: 1.05, saturation: 1.03,
    sharpen: 0.9, vignette: 0.10,
    clahe: null, gamma: null, tint: null
  },
  rare:      {
    brightness: 1.02, contrast: 1.15, saturation: 1.08,
    sharpen: 1.2, vignette: 0.12,
    clahe: { width: 3, height: 3, maxSlope: 2 }, gamma: null, tint: null
  },
  epic:      {
    brightness: 1.05, contrast: 1.20, saturation: 1.15,
    sharpen: 1.3, vignette: 0.18,
    clahe: { width: 3, height: 3, maxSlope: 3 }, gamma: 1.05, tint: null
  },
  legendary: {
    brightness: 1.08, contrast: 1.25, saturation: 1.18,
    sharpen: 1.4, vignette: 0.15,
    clahe: { width: 3, height: 3, maxSlope: 3 }, gamma: 1.1,
    tint: { r: 255, g: 210, b: 120, opacity: 0.05 }
  },
  mythic:    {
    brightness: 0.82, contrast: 1.45, saturation: 0.88,
    sharpen: 1.5, vignette: 0.40,
    clahe: { width: 3, height: 3, maxSlope: 4 }, gamma: null,
    tint: { r: 255, g: 60, b: 60, opacity: 0.10 }
  },
};
```

## 前端 ColorFilter 對應

```dart
const colorFilters = {
  'common':    null,  // 原片
  'uncommon':  ColorFilter.mode(Color(0x06F0FFF0), BlendMode.overlay),  // 極淡綠
  'rare':      ColorFilter.mode(Color(0x0AA0C4E8), BlendMode.overlay),  // 冷銀
  'epic':      ColorFilter.mode(Color(0x10C8A0FF), BlendMode.overlay),  // 淡紫
  'legendary': ColorFilter.mode(Color(0x14FFD060), BlendMode.overlay),  // 暖金
  'mythic':    ColorFilter.mode(Color(0x1CFF3030), BlendMode.overlay),  // 暗紅
};
```

---

# 九、字體系統

```
三字體方案（全部 Google Fonts 免費）：

① Rajdhani Bold — 數字專用
  用在：戰鬥數值（ATK/DEF）
  大小：12~20dp

② Noto Sans TC — 中文 + 卡名 + 技能 + 描述
  卡名字重隨稀有度遞增：
    凡品 Regular 16dp → 精良 Medium 16dp → 稀有 SemiBold 17dp
    → 史詩 Bold 18dp → 傳說 Bold 19dp → 神話 Black 20dp
  技能名：Medium~Bold 13~14dp
  技能描述：Regular 11dp
  卡片描述：Regular 10~11dp（底部風味文字，兼含咒語意涵）

③ Barlow Condensed SemiBold — 英文標籤
  用在：「ATK」「DEF」標籤
  全大寫 + letter-spacing: 2.0
  大小：7~9dp

卡名顏色邏輯（v5 暗底版）：
  凡品：#D4D4D8（淺灰白 — 安靜可讀）
  精良：#D4D4D8（同凡品 — 微差異靠邊框表達）
  稀有：#E2E8F0（亮一點 + V 槽浮雕效果）
  史詩：彩虹漸層 ShaderMask + shimmer 動畫
  傳說：金色漸層 ShaderMask + 金色 Shadow
  神話：#FF4444 暗紅漸層 + 脈動 opacity
```

---

# 十、翻卡動畫系統

> 全部用 Flutter 原生 Transform + Opacity + CustomPainter，不用 Lottie。

## 各稀有度翻卡時間軸

### ⚪ 凡品（0.3s）
```
0.0~0.15s → Y 軸旋轉 0°→90°
0.15s → 切換正面
0.15~0.3s → 90°→0°
特效：無
觸覺：無
音效：輕輕的紙翻頁聲
```

### 🟢 精良（0.5s）
```
0.0~0.25s → Y 軸旋轉
0.25~0.5s → 展開 + 邊緣閃一下綠色光
觸覺：lightImpact × 1
音效：翻頁 + 微弱的「叮」
```

### 🔵 稀有（0.8s）
```
0.0~0.3s → Y 軸旋轉
0.3s → 翻面 + 銀藍光線擴散
0.3~0.5s → 8 個銀藍光點從中心向外
0.5~0.8s → 光點淡出，金屬邊框+流光就位
觸覺：mediumImpact × 1
音效：金屬「叮」+ 結晶音
```

### 🟣 史詩（1.5s）
```
0.0~0.2s → 卡片表面出現彩虹光帶（預兆！）
0.2~0.5s → 慢速翻轉（彩虹光從縫隙透出）
0.5s → 翻面 + 彩虹光爆發
0.5~0.8s → 手機震動 + 彩虹粒子雨
0.8~1.2s → 全息效果啟動（Foil + 陀螺儀開始）
1.2~1.5s → 邊框彩虹流光啟動 + 追蹤光點就位
觸覺：heavyImpact × 1 + lightImpact × 3
音效：「嗡～」蓄力 → 彩虹爆發 + 風鈴
```

### 🟡 傳說（2.8s）
```
① 0.0~0.3s → 畫面微壓暗（淡金色 overlay）
② 0.3~0.8s → 卡片金色脈動（scale 1.0→1.03→1.0 × 3 次）
③ 0.8~1.3s → 慢速翻轉 + 金色光從縫隙溢出
④ 1.3~1.8s → 翻面 → 金色粒子爆炸（50+）+ 全螢幕金色 flash + 長震 0.3s
⑤ 1.8~2.3s → 金色煙火四散再落下
⑥ 2.3~2.8s → 持續金色粒子上升 + 邊框金光流動
音效：鼓聲漸強 → 金屬翻轉 → 「嗡轟～」→ 寺廟鐘聲餘韻
```

### 🔴 神話（4.0s）
```
⚠️ 全遊戲最長最震撼的動畫。玩家可能一輩子只見到幾次。

① 0.0~0.5s → 螢幕「抖動」（offset ±1dp）+ 短震 × 3 + 低頻嗡鳴
② 0.5~1.0s → 螢幕出現裂縫（8~12 條紅色線）+ 碎裂聲
③ 1.0~1.5s → 碎片掉落 → 純黑背景 → 安靜 — 只有心跳聲
④ 1.5~2.5s → 卡片從黑暗中浮現（暗紅輪廓 → 裂縫亮起 → 帶黑霧上升）
⑤ 2.5~3.0s → 紅光爆發 + 全螢幕紅 flash + 強烈長震 + 紅色閃電 × 3
⑥ 3.0~3.5s → 煙霧散去，卡片完整顯現
⑦ 3.5~4.0s → 全服廣播 + 號角音效 + 自動錄影

音效：嗡鳴 → 碎裂 → 安靜+心跳 → 心跳漸強 → 雷鳴爆炸 → 號角
```

---

# 十一、互動效果系統

## 陀螺儀全息互動（Epic+）

```dart
class InteractiveCard extends StatefulWidget {
  final CardData card;
  final Widget child;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  StreamSubscription? _gyroSub;
  double _x = 0, _y = 0;

  @override
  void initState() {
    super.initState();
    if (widget.card.rarityIndex >= 3) { // Epic+
      _gyroSub = gyroscopeEventStream(
        samplingPeriod: Duration(milliseconds: 16),
      ).listen((event) {
        setState(() {
          _x = (_x + event.y * 0.02).clamp(-1.0, 1.0);
          _y = (_y + event.x * 0.02).clamp(-1.0, 1.0);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.card.rarityIndex < 3) return widget.child;

    final tilt = switch (widget.card.rarityIndex) {
      3 => 0.03,  // Epic: ±3°
      4 => 0.04,  // Legendary: ±4°
      5 => 0.06,  // Mythic: ±6°
      _ => 0.0,
    };

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_y * tilt)
        ..rotateY(_x * tilt),
      alignment: Alignment.center,
      child: HoloOverlay(
        tiltX: _x,
        tiltY: _y,
        strength: widget.card.foilOpacity,
        child: widget.child,
      ),
    );
  }
}
```

## 粒子系統

```
⚪ 凡品 ~ 🟣 史詩：無粒子

🟡 傳說粒子：
  數量：20~25 個
  顏色：#F59E0B 金 + #FFFFFF 白閃
  大小：2~3dp
  行為：rise — 從底部緩慢上升，到頂部淡出
  + 邊框四角旋轉光點（8 秒一圈）

🔴 神話粒子：
  暗紅粒子 × 18：從裂縫「湧出」
  黑霧 × 5：MaskFilter.blur 大圓 + 極低 opacity
  紅色閃電：每 2 秒一條 zigzag Path（0.15s 淡出）
  閃電時卡片微震 ±0.5dp
```

## 邊框動畫

```
⚪ 凡品：無動畫
🟢 精良：光暈 opacity 呼吸脈動（3s 循環）
🔵 稀有：光帶流動（6s 一圈）
🟣 史詩：SweepGradient 彩虹旋轉（4s 一圈）+ 追蹤光點 + 陀螺儀跟隨
🟡 傳說：SweepGradient 金色（2s 一圈）+ 四角旋轉光點 + 粒子上升
🔴 神話：裂縫脈動 + scale 呼吸 + 煙霧溢出 + 閃電震動
```

---

# 十二、各場景卡片呈現規格

| 場景 | 尺寸 dp | 顯示 | 粒子 | 全息 | 邊框動畫 | 音效 |
|------|---------|------|------|------|---------|------|
| 召喚結果 | 300×400 | 全部 | Legendary+ | Epic+ | Epic+ | 翻卡 |
| 卡片詳情 | 300×400 | 全部 | Legendary+ | Epic+ | Epic+ | 環境音 |
| 列表縮略圖 | 75×100 | 照片+卡名 | 無 | Legendary+(弱) | 簡化版 | 無 |
| 對戰選卡 | 150×200 | 照片+數值+被動 | 無 | 無 | Epic+ | 無 |
| 對戰翻卡 | 150×200 | 照片+數值+被動 | Legendary+ | 無 | Epic+ | 對戰翻卡 |
| 分享圖 | 900×1200px | 全部+Logo | 靜態截圖 | 靜態截圖 | 靜態 | 無 |
| 個人代表卡 | 100×133 | 照片+卡名 | 無 | Legendary+(弱) | Legendary+ | 無 |
| 全服廣播 | 寬×40dp | 卡名+稀有度 | 無 | 無 | 無 | 號角 |

### 縮略圖辨識邏輯

```
暗底統一 → 靠「光效面積 + 邊框顏色」一眼辨識：

⚪ 凡品：暗灰無光 — 最低調
🟢 精良：綠色邊框 + 微弱呼吸光暈 — 有一點綠色
🔵 稀有：銀藍邊框 + 光帶在動 — 有光在跑
🟣 史詩：彩虹邊框在閃 — 即使縮略圖也能看到彩虹旋轉
🟡 傳說：金色光暈 + 比其他大 8% — 自帶金色光源
🔴 神話：紅光脈動 + 比其他大 8% — 唯一紅色光，超醒目

關鍵差異 vs v4：
  v4 白底在深色 UI 上所有卡都很亮 → 反而分不清
  v5 暗底跟 UI 融合 → 光效成為唯一視覺信號 → 辨識度更高
```

---

# 十三、卡背設計

```
所有卡背用 CustomPainter 程式碼生成，0 PNG。
統一風格：暗色底 + 中央 Snapell 標誌 + 品質對應裝飾

⚪ 凡品卡背：
  #1C1C1E 底 + 淡灰細網格線（5dp 間距）+ 中央 Snapell 灰色文字
  → 安靜乾淨的暗色背面

🟢 精良卡背：
  #1A1D1A 底 + 綠色細圓環裝飾（同心圓）+ 中央綠色 logo
  → 比凡品多一圈綠色

🔵 稀有卡背：
  #181B22 底 + 六角蜂巢 + 銀藍金屬 logo
  → 金屬面板幾何紋路

🟣 史詩卡背：
  #12131A 底 + 彩虹 SweepGradient 螺旋線 + 全息 logo
  → 動態彩虹旋轉

🟡 傳說卡背：
  #141008 底 + 金色放射線 + 金圓環 + 金色 logo + 微粒子
  → 金幣紋路

🔴 神話卡背：
  #0A0A0F 底 + 紅色裂縫紋路（seed = cardId → 每張不同）+ 紅色 logo 脈動
  → 唯一有動畫的卡背
```

---

# 十四、Fragment Shader 增強（Phase 3+）

## 需要的 Shader 清單

```
shaders/
  noise_texture.frag      → 所有：微弱噪點金屬質感
  brushed_metal.frag       → 🔵 稀有：刷紋金屬質感
  holo_cosmos.frag         → 🟣 史詩：Cosmos Holo 全息圖案
  iridescent.frag          → 🟣🟡 史詩/傳說：虹彩薄膜效果
  gold_specular.frag       → 🟡 傳說：金色高光反射
  dark_energy.frag         → 🔴 神話：暗色能量流動

每個 shader 接收：
  uniform vec2 uSize;       // 卡片尺寸
  uniform vec2 uTilt;       // 陀螺儀數據
  uniform float uTime;      // 時間（動畫用）
  uniform float uStrength;  // 效果強度（0.0~1.0）
```

## Cosmos Holo Shader 核心思路

```glsl
// holo_cosmos.frag — 模擬 Pokemon Cosmos Holo 效果
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uTilt;
uniform float uTime;
uniform float uStrength;

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;

  // 根據 UV 座標 + 陀螺儀偏移計算色相
  float hue = mod(uv.x + uv.y + uTilt.x * 0.5 + uTilt.y * 0.3 + uTime * 0.1, 1.0);

  // HSL → RGB
  vec3 rainbow = 0.5 + 0.5 * cos(6.28318 * (hue + vec3(0.0, 0.33, 0.67)));

  // Cosmos 圓點圖案
  vec2 grid = fract(uv * 20.0) - 0.5;
  float circle = smoothstep(0.3, 0.2, length(grid));
  float noise = hash(floor(uv * 20.0));
  circle *= step(0.5, noise);

  // 混合
  vec3 holoColor = rainbow * (0.3 + circle * 0.7);
  fragColor = vec4(holoColor, uStrength * (0.2 + circle * 0.3));
}
```

---

# 十五、社群分享策略

```
v5 暗底在社群上的優勢：

① 暗底卡片在瀑布流中像「精品珠寶照」
  社群 feed 多半是明亮照片
  暗底+發光卡片反而更突出 → 對比效應
  像 AMOLED 手機殼的產品照一樣吸睛

② 凡品也值得分享
  暗色金屬質感框 + 搞笑照片 = 「我把垃圾桶變成了暗影守衛哈哈」
  不是「醜版的傳說」→ 有自己完整的酷感
  分享動機：搞笑內容 > 稀有度炫耀

③ 全息效果 = 影片分享
  史詩+的全息只能用影片展示 → TikTok / Reels / 限時動態
  影片比截圖更吸引演算法推薦
  陀螺儀互動 = 轉手機錄影 → 天然的短影片素材

④ 神話卡的紅光 = 病毒傳播
  暗色收藏冊中唯一有紅色脈動的卡
  「你看我的卡在抖！邊框裂開了！」
  恐懼+好奇 → 點擊慾望最強
```

---

# 十六、低端機降級策略

```
偵測裝置等級（RAM + GPU benchmark）：

旗艦機（60fps 目標）：
  全部效果啟用

中端機（30fps 目標）：
  粒子數量減半
  Fragment Shader 解析度 /2
  陀螺儀取樣降為 32ms
  煙霧效果關閉
  追蹤光點減為 2 個

低端機 / 低電量模式：
  關閉粒子
  關閉 Fragment Shader → 回退 CustomPainter 簡化版
  關閉陀螺儀
  邊框動畫降為 2fps（視覺上仍有流動感但省電）
  噪點紋理關閉
```

---

# 十七、開發排程

```
═══════════════════════════════════════════════════
Phase 1（Week 1~2）：基礎美 — 6 種靜態卡片
═══════════════════════════════════════════════════

Week 1：統一佈局 + 3 種基礎
  □ CardData model
  □ SnapellCard Widget（統一骨架佈局 — 暗底版）
  □ CardBorderConfig 參數化邊框系統
  □ 凡品暗灰卡（拉絲金屬框 + 噪點紋理）
  □ 精良微光卡（綠邊框 + 呼吸脈動）
  □ 稀有銀藍卡（金屬漸層雙層邊框）
  □ 照片區 + CachedNetworkImage
  □ 稀有度角標
  □ 卡片描述顯示區（description — AI 生成，兼含咒語意涵）
  □ 3 種顯示模式（full / thumbnail / battle）

Week 2：3 種高級 + 照片處理
  □ 史詩全息卡（彩虹 SweepGradient 邊框）
  □ 傳說金卡（三層金框 + 淡金資訊區）
  □ 神話暗卡（黑底 + 裂縫邊框）
  □ 6 種卡名字體差異
  □ 6 種被動技能區風格
  □ 6 種分隔線
  □ Sharp 後端照片濾鏡管線
  □ 字體整合

成果：靜態完整的 6 種卡片
可上線程度：★★★☆☆

═══════════════════════════════════════════════════
Phase 2（Week 3~4）：動態 — 卡片活起來
═══════════════════════════════════════════════════

Week 3：邊框動畫 + 翻卡
  □ 精良呼吸脈動
  □ 稀有流光帶
  □ 史詩彩虹旋轉邊框 + 追蹤光點
  □ 傳說金色旋轉 + 軌道光點
  □ 神話裂縫脈動 + scale 呼吸
  □ 凡品~稀有 翻卡動畫
  □ 史詩翻卡（彩虹預兆 + 爆發）
  □ 音效整合

Week 4：高級翻卡 + 粒子
  □ 傳說翻卡（壓暗 + 脈動 + 金色爆炸）
  □ 神話翻卡（碎裂 + 黑暗 + 浮現 + 紅光）
  □ 傳說粒子（金色上升光點）
  □ 神話粒子（暗紅湧出 + 黑霧 + 閃電）
  □ HapticFeedback 整合
  □ 神話全服廣播 UI

成果：完整的動態體驗
可上線程度：★★★★☆

═══════════════════════════════════════════════════
Phase 3（Week 5~6）：沉浸 — 全息互動
═══════════════════════════════════════════════════

Week 5：全息 + 陀螺儀
  □ Fragment Shader + AnimatedSampler 整合
  □ sensors_plus 陀螺儀互動
  □ 史詩：全息 + 微傾斜 + 邊框跟隨
  □ 傳說：強全息 + 深度視差 + 粒子跟隨
  □ 神話：暗色全息 + 最強視差

Week 6：Shader + 收藏體驗
  □ noise_texture.frag
  □ brushed_metal.frag（稀有金屬質感）
  □ holo_cosmos.frag（史詩 Cosmos 全息）
  □ iridescent.frag（傳說虹彩效果）
  □ CustomPainter 生成式卡背（6 種）
  □ 分享圖截圖生成
  □ 卡片詳情頁全螢幕展示

成果：「想收藏、想分享」
可上線程度：★★★★★

═══════════════════════════════════════════════════
Phase 4（Week 7~8）：極致 — 打磨細節
═══════════════════════════════════════════════════

  □ gold_specular.frag + dark_energy.frag
  □ 翻卡自動錄影 + 分享短影片
  □ 性能優化（列表大量卡片）
  □ 低端機自動降級
  □ 低電量模式
  □ 各場景最終適配
  □ Spring physics 卡片物理互動
```

---

# 十八、資源需求

```
📁 必須的（15 個）：
  字體 × 3：Rajdhani, Noto Sans TC, Barlow Condensed（Google Fonts）
  音效 × 8：
    sfx_flip_common.mp3     紙翻頁聲
    sfx_flip_uncommon.mp3   翻頁 + 微弱叮
    sfx_flip_rare.mp3       金屬叮 + 結晶
    sfx_flip_epic.mp3       蓄力嗡鳴 + 彩虹爆發 + 風鈴
    sfx_flip_legendary.mp3  鼓聲 + 金屬 + 爆發 + 鐘聲
    sfx_flip_mythic.mp3     碎裂 + 心跳 + 雷鳴 + 號角
    sfx_broadcast.mp3       全服廣播號角
    sfx_battle_reveal.mp3   對戰翻卡
  Shader × 4（Phase 3）：
    noise_texture.frag      微弱噪點質感
    holo_cosmos.frag        Cosmos Holo 全息圖案
    brushed_metal.frag      刷紋金屬質感
    iridescent.frag         虹彩效果

📁 不需要的：
  ❌ 卡框 PNG — CustomPainter 繪製
  ❌ 光效 PNG — Gradient + BlendMode
  ❌ 卡背 PNG — CustomPainter 生成式花紋
  ❌ 粒子 Lottie — CustomPainter + AnimationController
  ❌ 翻卡 Lottie — Flutter Transform
```

---

# 十九、v4 → v5 改良摘要

```
v5 核心改變：「白底統一」→「暗底統一 + 光的遞進」

去掉的：
  ❌ 白色底色系統
  ❌ Apple 極簡包裝感
  ❌ 神話作為「唯一暗色卡」的 Von Restorff（因為所有卡都暗了）
  ❌ SPD 速度數值（MVP 僅 ATK + DEF）
  ❌ 等級徽章（MVP 無等級系統）
  ❌ 底欄位置/日期/全服編號（MVP 無 GPS 定位，編號系統延後）

改為的：
  🔄 暗色統一底（#1C1C1E → #0A0A0F 漸深）
  🔄 凡品從「什麼都沒有」→「拉絲金屬啞光」（有自己的身份）
  🔄 精良加入呼吸脈動（不再跟凡品幾乎一樣）
  🔄 稀有加入流光帶（不再只有靜態邊框）
  🔄 Von Restorff 從「顏色例外」改為「結構例外」（神話 = 唯一碎裂）
  🔄 數值分色從 Rare 開始（不再全灰）
  🔄 照片處理增加暗角（配合暗底框架）

新增的：
  🆕 噪點紋理（所有卡 — 微弱金屬質感）
  🆕 呼吸脈動（精良 — 待機燈效果）
  🆕 流光帶（稀有 — 光沿邊框流動）
  🆕 追蹤光點（史詩+ — 彩色光點沿邊框軌道運行）
  🆕 品牌 DNA 內白線（所有卡 — 0.5dp 極微弱內白線）
  🆕 卡片描述區（description — AI 生成風味文字，兼含咒語意涵）

保留的：
  ✅ 一人團隊可行（CustomPainter / 零外部美術）
  ✅ 全息效果（Shader + 陀螺儀）
  ✅ CLAHE / 色彩分級照片處理
  ✅ 粒子系統（CustomPainter）
  ✅ 翻卡動畫（Flutter 原生）
  ✅ 4 Phase 漸進開發
  ✅ 神話裂縫 seed = cardId（每張不同）
  ✅ 漸進增強（每升一級加效果不替換）
  ✅ 3 秒縮圖辨識原則
  ✅ 全服廣播（神話）
```

---

# 二十、HTML Mockup 檔案對照

```
card-designs/ 資料夾：

v4 版本（舊 — 白底系統）：
  1-common.html      凡品白卡
  2-uncommon.html     精良微光白卡
  3-rare.html         稀有銀色金屬卡
  4-epic.html         史詩全息閃卡
  5-legendary.html    傳說黃金聖光卡
  6-mythic.html       神話暗黑禁忌卡

v5 概念（方向探索）：
  v5-concept-A-abyss-glow.html     深淵浮光（全暗底 → v5 最終方向的基礎）
  v5-concept-B-neon-sigil.html     霓虹咒印（咒印幾何 → 元素被輕度融入 v5）
  v5-concept-C-gradient-dive.html  漸層深潛（淺深漸層 → 未採用）

v5 正式版（待製作）：
  v5-1-common.html    凡品 — 拉絲金屬啞光卡
  v5-2-uncommon.html  精良 — 呼吸微光卡
  v5-3-rare.html      稀有 — 銀藍流光金屬卡
  v5-4-epic.html      史詩 — 全息閃卡
  v5-5-legendary.html 傳說 — 黃金聖光卡
  v5-6-mythic.html    神話 — 碎裂禁忌之物
```
