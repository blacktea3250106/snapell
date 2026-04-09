# VoxCards 卡片系統完整實作指南

## 稀有度評分 × 機率設計 × 視覺收藏系統

---

# 一、卡片稀有度評分系統 — 怎麼評分最具成癮性

## 核心設計原則

> **玩家不能「算出」結果，但必須「感覺到」自己的行為有影響。**

成癮的關鍵不是純隨機（那叫老虎機），而是**「我覺得我能控制結果，但每次都有驚喜」**。

---

## 稀有度等級定義

| 稀有度 | 代號 | 色系 | 等級範圍 | 感覺 |
|--------|------|------|---------|------|
| ⚪ **凡品** | Common | 灰白 | Lv.1~15 | 「哦，一張卡」 |
| 🟢 **精良** | Uncommon | 翠綠 | Lv.12~35 | 「不錯喔」 |
| 🔵 **稀有** | Rare | 寶藍 | Lv.28~55 | 「喔喔喔！」 |
| 🟣 **史詩** | Epic | 紫金 | Lv.45~80 | 「我的天！！」 |
| 🟡 **傳說** | Legendary | 金橙 | Lv.68~95 | 「不可能吧！！！」 |
| 🔴 **神話** | Mythic | 暗紅+黑 | Lv.88~100 | 「（尖叫）（手抖）（截圖）」 |

### 為什麼等級範圍要重疊？

```
🟢 精良最高 Lv.35
🔵 稀有最低 Lv.28

→ 一張 Lv.30 的卡可能是「精良裡的精英」或「稀有裡的新手」
→ 這個模糊地帶讓玩家產生「差一點就...」的感覺
→ 「差一點」是最強的成癮驅動力
```

---

## 評分公式：三維分數 → 稀有度

### 輸入：三個可控因子

```
📷 照片分數（Photo Score）= 0 ~ 30
🗣️ 咒語分數（Spell Score）= 0 ~ 30
🎲 命運值（Fate Value）    = 0 ~ 40

總分（Total）= Photo + Spell + Fate = 0 ~ 100
```

### 各因子怎麼算

**📷 照片分數（0~30）— 玩家可控 30%**

```
Claude Vision API 分析後打分：

清晰度（0~10）：
  模糊/太暗/過曝 → 0~3
  普通清晰 → 4~6
  構圖好/光線好 → 7~10

趣味度（0~10）：
  路邊石頭 → 1~3
  寵物/食物 → 4~6
  獨特場景/稀有物體 → 7~10

主體辨識度（0~10）：
  看不出拍什麼 → 0~3
  清楚辨識 → 4~7
  完美呈現 → 8~10
```

**🗣️ 咒語分數（0~30）— 玩家可控 30%**

```
Claude API 分析後打分：

契合度（0~10）：咒語跟照片有多相關
氣勢（0~10）：音量/情緒張力（文字模式上限 5）
創意（0~10）：說法獨特程度（重複懲罰）
```

**🎲 命運值（0~40）— 玩家不可控 40%**

```
這是「開盲盒」的核心。

基礎隨機值：0~30（純隨機）
環境加成：0~10（根據時空條件）

環境加成條件：
  深夜 11PM~3AM → +3
  GPS 在知名地標 → +3
  拍照當天是節日 → +2
  連續 3 天登入 → +2
  帳號生日當天 → +5
  當月沒出過史詩以上 → +3（保底機制偽裝成運氣）
```

### 總分 → 稀有度對照表

```
總分 0~25    → ⚪ 凡品
總分 26~45   → 🟢 精良
總分 46~65   → 🔵 稀有
總分 66~80   → 🟣 史詩
總分 81~93   → 🟡 傳說
總分 94~100  → 🔴 神話
```

### 等級 = 總分 ± 微調

```
基礎等級 = 總分
微調 = random(-5, +5)
最終等級 = clamp(基礎等級 + 微調, 1, 100)

→ 同一個稀有度裡的等級不完全一樣
→ 每張卡都是「唯一」的
```

---

## 為什麼這個評分系統會上癮

```
❶ 30% 照片 + 30% 咒語 = 「我的努力有用」
   → 拍好照片、喊好咒語確實能提升品質
   → 但不是 100% 決定 → 不會變成「做題」

❷ 40% 命運值 = 「每次都有驚喜」
   → 即使做了一樣的事，結果也不同
   → 偶爾會「超常發揮」→ 驚喜感
   → 偶爾會「手感不好」→ 下次再來

❸ 環境加成 = 「隱藏的秘密」
   → 玩家會發現「晚上出的卡比較好？」
   → 社群開始討論「最佳召喚時機」
   → 有些是真的，有些是倖存者偏差
   → 無論如何都創造了話題

❹ 保底偽裝成運氣 = 「差不多該出好的了」
   → 玩家不知道有保底
   → 當保底觸發時，以為是「終於歐了」
   → 產生「只要堅持就會好運」的錯覺
```

---

# 二、卡片稀有度出現機率 — 怎麼做最具成癮性

## 核心設計原則

> **不是固定機率。是動態機率。玩家永遠覺得「下一次會更好」。**

---

## 基礎機率表（玩家不知道的底層數據）

| 稀有度 | 基礎出率 | 等效原神 |
|--------|---------|---------|
| ⚪ 凡品 | 45% | 3★ 武器 |
| 🟢 精良 | 30% | 4★ 普通 |
| 🔵 稀有 | 15% | 4★ 角色 |
| 🟣 史詩 | 7% | 5★ 常駐 |
| 🟡 傳說 | 2.5% | 5★ 限定 |
| 🔴 神話 | 0.5% | 無對標 |

---

## 動態機率系統：五重保底（Pity System）

### 第一重：漸進保底（Soft Pity）

```
連續 N 次沒出 🟣 史詩以上 → 史詩以上機率逐漸提升

第 1~15 次：基礎機率（10%）
第 16 次：+2%（12%）
第 17 次：+4%（14%）
第 18 次：+6%（16%）
第 19 次：+10%（20%）
第 20 次：+15%（25%）
...
第 25 次：+40%（50%）
第 30 次：100%（硬保底）

玩家不知道具體數字
但他會「感覺到」連續出白的時候，下一次好像特別容易出好的
→ 「再抽一次！感覺快要出了！」
```

### 第二重：新手保護

```
前 5 次召喚的機率：

第 1 次：100% 🔵稀有以上（保證好的開始體驗）
第 2 次：基礎機率 + 20%（還在蜜月期）
第 3 次：基礎機率 + 15%
第 4 次：基礎機率 + 10%
第 5 次：基礎機率 + 5%
第 6 次起：正常機率

→ 新手前幾次體驗特別好 → 建立「這遊戲出率不錯」的第一印象
→ 之後回到正常機率 → 但他已經上鉤了
```

### 第三重：每日首抽加成

```
每天第一次召喚：
  🟣 史詩以上機率 ×2
  🟡 傳說以上機率 ×1.5

→ 每天都有理由打開遊戲
→ 「每天第一抽特別準」→ 真的是
→ 養成每天召喚的習慣
```

### 第四重：回歸獎勵

```
超過 48 小時沒登入 → 下次召喚：
  所有稀有度機率 +50%
  且觸發隱藏環境加成 +5

→ 「哇我好久沒玩，回來第一抽就出傳說！」
→ 截圖發社群 → 其他流失玩家看到 → 也回來
→ 不知不覺變成「回歸廣告」
```

### 第五重：情緒補償

```
連續對戰 3 敗 → 下次召喚：
  史詩以上機率 ×1.5

→ 玩家打輸了很沮喪
→ 去抽卡散心 → 出了好東西
→ 「雖然打輸了但抽到好卡！」
→ 負面情緒轉正 → 繼續玩
```

---

## 機率呈現方式 — 不顯示具體數字

> **絕對不要告訴玩家具體機率。**

玩家看到的是：

```
┌────────────────────────────┐
│  今日召喚運勢：🔥🔥🔥🔥🔥     │
│  「火焰高漲的一天！」        │
│                            │
│  💫 命運之輪正在轉動...      │
│  ⬆️ 凌晨時段運勢加成中       │
│  🎂 生日月份福利進行中       │
└────────────────────────────┘
```

而不是：

```
❌ 傳說機率：2.5%
❌ 史詩機率：7%
❌ 保底距離：還差 12 抽
```

**為什麼不顯示？**

```
顯示機率 → 變成數學題 → 「性價比不高不抽了」
不顯示   → 變成感覺 → 「我覺得今天手感很好！」→ 繼續抽
```

---

## 特殊機率事件 — 製造社群話題

### ⚡ 天命時刻（每日隨機 1 小時）

```
每天隨機選一個小時（全服不同玩家時間不同）
該小時內所有召喚：🟡 傳說以上機率 ×3

玩家會發現：
「我今天下午三點連出兩張史詩！」
「我是早上七點出的傳說！」

→ 社群開始猜測規律 → 其實是每個人不同 → 但討論永遠不會停
```

### 🌈 連鎖反應

```
出了 🟣 史詩以上後，下一次召喚：
  機率不變，但出的卡 100% 跟上一張有關聯

例：
  出了「炎貓」→ 下一張可能出「冰鼠」（對立屬性）
  出了「深夜拉麵」→ 下一張可能出「半夜肚子餓的上班族」

→ 出好卡後馬上想再抽一張 → 「看看會出什麼對應的！」
→ 收集「成對卡片」的動力
```

### 💀 逆轉召喚

```
連續 3 次出 ⚪ 凡品 → 第 4 次觸發「逆轉」：
  視覺效果：召喚動畫突然壞掉、畫面碎裂
  實際效果：機率表反轉
    原本 45% 凡品 → 變成 45% 的機率出 🟣 史詩以上

→ 連續出白的挫敗 → 突然看到異常效果 → 興奮感
→ 「三白必出金」成為社群梗
→ 出白也不會太難過 → 「再來兩張白的就要逆轉了！」
```

---

## 機率系統的技術實作

```javascript
// Cloud Function: calculateCardRarity

function calculateRarity(userId, photoScore, spellScore) {

  // 1. 計算命運值
  let fateValue = Math.random() * 30; // 基礎隨機 0~30
  fateValue += getEnvironmentBonus(userId); // 環境加成 0~10

  // 2. 總分
  const totalScore = photoScore + spellScore + fateValue;

  // 3. 套用保底修正
  const pityBonus = calculatePityBonus(userId);
  const adjustedScore = totalScore + pityBonus;

  // 4. 判定稀有度
  const rarity = scoreToRarity(adjustedScore);

  // 5. 計算等級
  const level = calculateLevel(adjustedScore, rarity);

  // 6. 更新保底計數器
  updatePityCounter(userId, rarity);

  return { rarity, level, totalScore: adjustedScore };
}

function calculatePityBonus(userId) {
  const userData = getUserData(userId);
  let bonus = 0;

  // 漸進保底
  const pullsSinceEpic = userData.pullsSinceEpic || 0;
  if (pullsSinceEpic > 15) {
    bonus += (pullsSinceEpic - 15) * 2; // 每多一抽 +2
  }
  if (pullsSinceEpic >= 30) {
    bonus += 50; // 硬保底
  }

  // 新手保護
  const totalPulls = userData.totalPulls || 0;
  if (totalPulls === 0) bonus += 30; // 第一抽保底稀有
  else if (totalPulls < 5) bonus += (5 - totalPulls) * 5;

  // 每日首抽
  if (userData.todayPulls === 0) bonus += 8;

  // 回歸獎勵
  const hoursSinceLastLogin = getHoursSinceLastLogin(userId);
  if (hoursSinceLastLogin > 48) bonus += 12;

  // 情緒補償
  if (userData.recentBattleLosses >= 3) bonus += 6;

  // 逆轉召喚
  if (userData.consecutiveCommons >= 3) bonus += 25;

  return bonus;
}

function getEnvironmentBonus(userId) {
  let bonus = 0;
  const now = new Date();
  const hour = now.getHours();

  // 深夜加成
  if (hour >= 23 || hour <= 3) bonus += 3;

  // 節日加成（需要維護節日表）
  if (isHoliday(now)) bonus += 2;

  // 連續登入加成
  const loginStreak = getLoginStreak(userId);
  if (loginStreak >= 3) bonus += 2;

  // 生日加成
  if (isBirthday(userId, now)) bonus += 5;

  // 月度保底（當月沒出過史詩）
  if (!hasEpicThisMonth(userId)) bonus += 3;

  // 天命時刻（每日隨機 1 小時，每人不同）
  if (isFateHour(userId, now)) bonus += 8;

  return Math.min(bonus, 10); // 上限 10
}

function scoreToRarity(score) {
  if (score >= 94) return 'mythic';
  if (score >= 81) return 'legendary';
  if (score >= 66) return 'epic';
  if (score >= 46) return 'rare';
  if (score >= 26) return 'uncommon';
  return 'common';
}

function calculateLevel(score, rarity) {
  // 在稀有度範圍內根據總分微調等級
  const ranges = {
    common:    { min: 1,  max: 15 },
    uncommon:  { min: 12, max: 35 },
    rare:      { min: 28, max: 55 },
    epic:      { min: 45, max: 80 },
    legendary: { min: 68, max: 95 },
    mythic:    { min: 88, max: 100 },
  };

  const range = ranges[rarity];
  const ratio = Math.random(); // 在範圍內隨機
  const level = Math.round(range.min + ratio * (range.max - range.min));

  // 微調 ±3
  const jitter = Math.round((Math.random() - 0.5) * 6);
  return Math.max(1, Math.min(100, level + jitter));
}
```

### Firestore 資料結構（保底追蹤）

```
users/{userId}/summonStats: {
  totalPulls: 156,              // 總召喚次數
  todayPulls: 3,                // 今日已用次數
  pullsSinceEpic: 8,            // 距離上次史詩以上的次數
  pullsSinceLegendary: 42,      // 距離上次傳說以上的次數
  consecutiveCommons: 0,        // 連續凡品次數
  recentBattleLosses: 1,        // 近期連敗次數
  lastEpicDate: Timestamp,      // 上次出史詩的日期
  thisMonthEpicCount: 2,        // 本月史詩出現次數
  personalFateHourSeed: 0.73,   // 個人天命時刻種子
  lastLoginAt: Timestamp,       // 上次登入時間
  loginStreak: 5,               // 連續登入天數
  birthday: "03-15",            // 生日
  createdAt: Timestamp
}
```

---

# 三、卡片外觀設計 — 怎麼做最具收藏價值

## 核心設計原則

> **收藏慾望來自三件事：稀缺感、辨識度、炫耀性。**
>
> **一張卡拿出來，3 秒內別人就知道你有多厲害。**

---

## 卡片視覺結構

```
┌─ 卡框（稀有度決定） ─────────────────────────────┐
│                                                    │
│  ┌─ 卡面（玩家照片 + 濾鏡） ─────────────────┐   │
│  │                                             │   │
│  │         [玩家拍的照片]                       │   │
│  │         + 品質對應濾鏡                       │   │
│  │         + 品質對應粒子特效                    │   │
│  │                                             │   │
│  └─────────────────────────────────────────────┘   │
│                                                    │
│  ╔══════════════════════════════════╗              │
│  ║  ⭐⭐⭐⭐  Lv.72                  ║  ← 等級條   │
│  ╚══════════════════════════════════╝              │
│                                                    │
│  🔥 肉球炎貓                          ← 卡名       │
│                                                    │
│  ┌ 被動技能 ────────────────────────┐              │
│  │ 💢 不屈之焰                       │              │
│  │ 等級比對手低時，咒語分 +5          │              │
│  └──────────────────────────────────┘              │
│                                                    │
│  ┌ 底欄 ────────────────────────────┐              │
│  │ 📍 台北市 · 2026.02.27           │              │
│  │ 🗣️ ▶ 播放咒語                    │              │
│  │ 👤 召喚者：HaoFu                 │              │
│  └──────────────────────────────────┘              │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 各稀有度視覺差異 — 「一眼就認出」

### ⚪ 凡品（Common）

```
卡框：淺灰色細邊框，無裝飾
濾鏡：無（照片原樣）
粒子：無
卡名字體：普通白字
底欄：淺灰背景
翻卡動畫：普通翻轉（0.3s）
卡背：純灰色幾何圖案

感覺：「就是一張卡」
```

### 🟢 精良（Uncommon）

```
卡框：翠綠邊框，邊角有小型葉片裝飾
濾鏡：微光（輕微提亮 + 柔焦邊緣）
粒子：偶爾飄過 1~2 個綠色光點
卡名字體：帶淺綠色光暈
底欄：深綠背景
翻卡動畫：翻轉 + 微光閃爍（0.5s）
卡背：綠色藤蔓圖案

感覺：「比灰的好看一點」
```

### 🔵 稀有（Rare）

```
卡框：寶藍金屬質感邊框，邊角有水晶裝飾
濾鏡：冷藍色調 + 銳利化 + 微光
粒子：持續飄浮的藍色光點（5~8 個）
卡名字體：藍色金屬光澤
底欄：深藍 + 銀色邊線
翻卡動畫：翻轉 + 藍光爆發 + 碎片飛散（0.8s）
卡背：藍色水晶矩陣圖案
特殊：卡片長按時，照片會有「呼吸感」（微微縮放）

感覺：「喔！有藍光！不錯」
```

### 🟣 史詩（Epic）

```
卡框：紫金雙色邊框，有流動的能量線條
濾鏡：紫色暗角 + 對比增強 + 光暈
粒子：紫金色粒子持續環繞（15~20 個）+ 偶爾電弧
卡名字體：紫色 + 金色雙層描邊 + 微發光
底欄：暗紫 + 金色花紋
翻卡動畫：翻轉 + 紫金爆發 + 螢幕震動 + 粒子雨（1.2s）
卡背：紫金漩渦圖案（會動）
特殊：
  - 卡片閒置時有「能量脈動」動畫
  - 照片自動套用「史詩級」光影效果
  - 被動技能區域有發光邊框

感覺：「臥槽紫色的！！」
```

### 🟡 傳說（Legendary）

```
卡框：純金邊框 + 浮雕紋路 + 四角有旋轉的符文
濾鏡：金色暖調 + 光芒放射 + HDR 效果
粒子：金色光粒持續噴發（30+ 個）+ 環繞的光環
卡名字體：金色浮雕，帶陰影和光芒
底欄：黑金配色 + 動態花紋
翻卡動畫：
  ① 畫面先暗下來（0.3s）
  ② 卡片發出強烈金光（0.5s）
  ③ 翻轉 + 金色粒子爆炸 + 全螢幕光芒（1s）
  ④ 螢幕閃爍 + 震動（0.5s）
  ⑤ 卡片落定 + 持續金色粒子（0.5s）
  總時長：2.8s
卡背：金色龍紋 + 旋轉符文陣
特殊：
  - 永久動態卡面（照片有微風/光影流動效果）
  - 卡片邊緣有「火焰」效果
  - 查看卡片時背景音效改變
  - 在卡組列表中特別突出（比其他卡大 10%）

感覺：「（尖叫）（錄影）（發社群）」
```

### 🔴 神話（Mythic）

```
卡框：暗紅 + 黑色 + 金色三層框，有裂縫般的能量線
濾鏡：暗黑風格 + 紅色能量線 + 扭曲效果
粒子：暗紅粒子 + 黑色煙霧 + 偶爾閃電
卡名字體：紅色裂縫字體，像要爆裂一樣
底欄：純黑 + 紅色脈動
翻卡動畫：
  ① 全螢幕碎裂效果（0.5s）
  ② 黑暗中只有紅光（0.5s）
  ③ 卡片從裂縫中浮出（1s）
  ④ 暗紅爆發 + 全螢幕閃紅 + 強烈震動（1s）
  ⑤ 卡片定格 + 背景持續暗紅煙霧（0.5s）
  ⑥ 全服廣播彈出：「XXX 召喚出了 [神話] 卡片！」
  總時長：3.5s+
卡背：黑色深淵 + 紅色裂縫（持續變化）
特殊：
  - 永久動態全卡面（整張卡都在「燃燒」）
  - 在所有列表中有專屬紅光邊框
  - 查看時有專屬 BGM
  - 召喚出的瞬間自動錄製 15 秒分享影片
  - 全服動態牆推播
  - 卡組裡放這張卡 → 卡組背景變暗紅

感覺：「（手抖到截不了圖）（社群爆炸）」
```

---

## 卡面照片處理 — 讓手機照片變成「藝術品」

### 濾鏡管線（小團隊可行方案）

```
不用 AI 生成圖片。用照片 + 程式化處理。

方案：Cloud Function 上用 Sharp (Node.js)

步驟：
  ① 裁切成卡片比例（3:4）
  ② 根據稀有度套用濾鏡組合
  ③ 疊上粒子/光效圖層（預製 PNG）
  ④ 疊上卡框圖層（預製 PNG）
  ⑤ 加上文字
  ⑥ 輸出最終圖片
```

### 各稀有度濾鏡參數

```javascript
const filterPresets = {
  common: {
    // 不處理
    brightness: 1.0,
    contrast: 1.0,
    saturation: 1.0,
    blur: 0,
    tint: null,
    vignette: 0,
  },
  uncommon: {
    brightness: 1.05,
    contrast: 1.02,
    saturation: 1.1,
    blur: 0,       // 邊緣微糊用 vignette
    tint: { r: 200, g: 255, b: 200, opacity: 0.05 }, // 微微綠
    vignette: 0.1,  // 輕微暗角
  },
  rare: {
    brightness: 1.1,
    contrast: 1.1,
    saturation: 1.15,
    blur: 0,
    tint: { r: 150, g: 200, b: 255, opacity: 0.08 }, // 冷藍
    vignette: 0.15,
    sharpen: 1.2,
  },
  epic: {
    brightness: 1.0,
    contrast: 1.25,
    saturation: 1.2,
    blur: 0,
    tint: { r: 180, g: 130, b: 255, opacity: 0.12 }, // 紫色
    vignette: 0.25,
    sharpen: 1.3,
    overlay: 'epic_glow.png', // 預製的紫金光效圖層
  },
  legendary: {
    brightness: 1.15,
    contrast: 1.3,
    saturation: 1.25,
    blur: 0,
    tint: { r: 255, g: 200, b: 100, opacity: 0.15 }, // 金色暖調
    vignette: 0.2,
    sharpen: 1.4,
    overlay: 'legendary_rays.png', // 預製的金色光芒圖層
  },
  mythic: {
    brightness: 0.85,  // 偏暗
    contrast: 1.5,     // 超高對比
    saturation: 0.9,   // 微微去飽和
    blur: 0,
    tint: { r: 255, g: 80, b: 80, opacity: 0.18 }, // 暗紅
    vignette: 0.4,     // 強暗角
    sharpen: 1.5,
    overlay: 'mythic_cracks.png', // 預製的裂縫能量線圖層
  },
};
```

### 卡框資源需求

```
需要設計師製作：

📁 assets/card_frames/
  ├── common_frame.png        （灰色細邊框）
  ├── uncommon_frame.png      （綠色 + 葉片）
  ├── rare_frame.png          （藍色金屬 + 水晶）
  ├── epic_frame.png          （紫金 + 能量線）
  ├── legendary_frame.png     （純金 + 浮雕 + 符文）
  └── mythic_frame.png        （暗紅黑金 + 裂縫）

📁 assets/card_overlays/
  ├── epic_glow.png           （紫金光效）
  ├── legendary_rays.png      （金色光芒）
  └── mythic_cracks.png       （紅色裂縫線）

📁 assets/card_backs/
  ├── common_back.png
  ├── uncommon_back.png
  ├── rare_back.png
  ├── epic_back.png
  ├── legendary_back.png
  └── mythic_back.png

📁 assets/card_particles/     （前端用，Lottie 動畫）
  ├── rare_particles.json
  ├── epic_particles.json
  ├── legendary_particles.json
  └── mythic_particles.json

📁 assets/card_flip_anim/     （翻卡動畫，Lottie）
  ├── common_flip.json
  ├── uncommon_flip.json
  ├── rare_flip.json
  ├── epic_flip.json
  ├── legendary_flip.json
  └── mythic_flip.json

總計需要設計師製作：
  - 6 個卡框 PNG
  - 3 個光效覆蓋 PNG
  - 6 個卡背 PNG
  - 4 個粒子動畫（Lottie JSON）
  - 6 個翻卡動畫（Lottie JSON）
  = 25 個資源檔案
```

---

## 前端動態效果實作

### 粒子系統（Flutter）

```dart
// 用 Lottie 播放粒子動畫，疊在卡面上
// 不需要自己寫粒子引擎

dependencies:
  lottie: ^3.x.x

// 卡片 Widget 結構
class CardWidget extends StatelessWidget {
  final CardData card;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 底層：卡框
        Image.asset('assets/card_frames/${card.rarity}_frame.png'),

        // 中層：照片 + 濾鏡（用 ColorFiltered 或 ImageFiltered）
        Positioned(
          // 照片區域
          child: ColorFiltered(
            colorFilter: getColorFilter(card.rarity),
            child: Image.network(card.cardImageUrl),
          ),
        ),

        // 上層：粒子動畫（稀有以上才有）
        if (card.rarityIndex >= 2) // rare+
          Lottie.asset(
            'assets/card_particles/${card.rarity}_particles.json',
            repeat: true,
          ),

        // 文字層：卡名、等級、被動技能
        _buildCardInfo(card),
      ],
    );
  }
}
```

### 翻卡動畫（Flutter）

```dart
// 翻卡效果：3D 翻轉 + 稀有度對應的特效

class CardFlipAnimation extends StatefulWidget {
  final CardData card;
  final VoidCallback onFlipComplete;
  // ...
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  // 根據稀有度決定翻卡時長
  Duration get flipDuration {
    switch (widget.card.rarity) {
      case 'common': return Duration(milliseconds: 300);
      case 'uncommon': return Duration(milliseconds: 500);
      case 'rare': return Duration(milliseconds: 800);
      case 'epic': return Duration(milliseconds: 1200);
      case 'legendary': return Duration(milliseconds: 2800);
      case 'mythic': return Duration(milliseconds: 3500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 前半段顯示卡背，後半段顯示卡面
        final isBackSide = _flipAnimation.value < 0.5;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 透視效果
            ..rotateY(_flipAnimation.value * 3.14159),
          alignment: Alignment.center,
          child: isBackSide
            ? _buildCardBack()
            : Transform(
                transform: Matrix4.identity()..rotateY(3.14159),
                alignment: Alignment.center,
                child: _buildCardFront(),
              ),
        );
      },
    );
  }
}
```

---

## 收藏價值三要素設計

### 要素一：稀缺感 —「這張卡全服只有 N 張」

```
每張卡顯示：

┌────────────────────┐
│  #00042 / ∞        │  ← 凡品：不顯示編號（太多了）
│  #00042 / ∞        │  ← 精良：不顯示編號
│  #00042 / ∞        │  ← 稀有：顯示個人編號
│  #00042 / 12,847   │  ← 史詩：顯示「全服共 N 張同類」
│  #00003 / 203      │  ← 傳說：顯示「全服共 N 張同類」（數字小）
│  #00001 / 17       │  ← 神話：顯示「全服共 N 張同類」（極少）
└────────────────────┘

「同類」= 同一個主體（如「貓」類卡片中的傳說級）

→ 看到全服只有 17 張 → 截圖炫耀
→ 看到自己是 #00001 → 「我是第一個！」
```

### 要素二：辨識度 —「3 秒內看出品質」

```
視覺分級越高越明顯：

遠距離（縮略圖大小）就能辨識：
  ⚪ 灰色邊框 → 「灰卡」
  🟢 綠色邊框 → 「綠卡」
  🔵 藍色 + 微光 → 「藍卡」
  🟣 紫金 + 明顯粒子 → 「紫卡」
  🟡 金色 + 強烈發光 → 「金卡！」
  🔴 暗紅 + 裂縫 + 煙霧 → 「紅卡！！！」

對手翻卡時，你 0.1 秒就知道對面出了什麼品質
→ 金色翻出來 → 心跳加速
→ 紅色翻出來 → 「完了...」
```

### 要素三：炫耀性 —「讓別人知道我有好卡」

```
個人主頁展示：
  可設定 1 張「代表卡」→ 其他玩家看到你第一眼就看到
  傳說 / 神話 代表卡 → 名字旁邊有金色/紅色光效

對戰中：
  出金卡 / 紅卡 → 對手畫面出現特殊提示
  「對手派出了 【傳說】肉球炎貓！」→ 金色大字

卡組分享：
  可以生成「卡組圖鑑」分享圖
  自動排列你所有的高品質卡
  像寶可夢圖鑑一樣好看

社群標籤：
  「🟡×3 傳說收藏家」（擁有 3 張傳說）
  「🔴 神話持有者」（擁有任一神話）
  「📷 萬物獵人」（召喚過 100 種不同主體的卡）
  → 標籤顯示在對戰畫面和個人主頁
```

---

## 額外收藏機制：圖鑑系統

### 素材圖鑑 — 收集驅動力

```
遊戲內有一本「萬物圖鑑」

分類：
  🐱 動物（貓、狗、鳥...）
  🌿 植物（花、樹、草...）
  🍜 食物（拉麵、壽司、pizza...）
  🏠 建築（房子、橋、塔...）
  ⚙️ 物品（杯子、電腦、鞋子...）
  🌅 自然（天空、海、山...）
  👤 人物（自拍、路人、朋友...）
  ❓ 特殊（???）

每個分類下有 N 個可收集的主體
  例：動物 → 貓、狗、倉鼠、金魚、烏龜...

收集進度顯示：
  🐱 動物：23/50 （46%）
  ████████░░░░░░░░

收集獎勵：
  單類 25% → 該類召喚時 +1 環境加成
  單類 50% → 專屬卡框解鎖
  單類 100% → 專屬稱號 + 圖鑑金色完成印章
  全圖鑑 100% → ??? （沒人知道，但所有人都想知道）
```

### 卡片圖鑑 — 每張卡都值得留

```
你召喚過的每一張卡都會記錄在個人圖鑑中
即使你融合掉了，圖鑑裡還有記錄

圖鑑記錄：
  - 卡面截圖
  - 召喚日期和地點
  - 咒語錄音
  - 稀有度和等級
  - 「是否仍持有」標記

→ 就算卡片被融合了，回憶還在
→ 「我以前有一張傳說的貓！」→ 可以翻圖鑑給朋友看
→ 增加召喚動力：「這個東西我圖鑑裡還沒有」
```

---

# 四、完整技術棧總結

## 後端（Cloud Functions / Node.js）

```
需要的套件：
  @anthropic-ai/sdk          → Claude API（照片分析 + 卡片生成）
  openai                     → Whisper API（語音轉文字）
  sharp                      → 圖片處理（濾鏡 + 合成）
  firebase-admin             → Firestore + Storage
  fluent-ffmpeg              → 音量分析

API 呼叫次數（每次召喚）：
  Claude Vision API   ×1（照片分析）
  Claude API          ×1（綜合判定 + 生成屬性）
  Whisper API         ×1（語音轉文字，語音模式才需要）
  Sharp               ×1（本地圖片合成，不花錢）
  ffmpeg              ×1（本地音量分析，不花錢）

費用：
  每次召喚約 $0.02 ~ 0.04 USD
```

## 前端（Flutter）

```
需要的套件：
  camera               → 拍照
  record               → 錄音
  audioplayers         → 音訊播放
  lottie               → 粒子/翻卡動畫
  firebase_core        → Firebase 核心
  firebase_auth        → 登入
  cloud_firestore      → 資料庫
  firebase_storage     → 檔案儲存
  cloud_functions      → 呼叫後端
  flutter_animate      → UI 動畫
  cached_network_image → 圖片快取
```

## 設計師需要製作

```
卡框 PNG ×6              （各稀有度）
光效覆蓋 PNG ×3          （史詩/傳說/神話）
卡背 PNG ×6              （各稀有度）
粒子動畫 Lottie ×4       （稀有/史詩/傳說/神話）
翻卡動畫 Lottie ×6       （各稀有度）
─────────────────────
共 25 個檔案

建議：先做 凡品 + 稀有 + 傳說 三套（最低可行）
其他品質上線後再補
```

## Firestore 新增 / 更新欄位

```
users/{userId}/summonStats: {
  totalPulls,
  todayPulls,
  pullsSinceEpic,
  pullsSinceLegendary,
  consecutiveCommons,
  recentBattleLosses,
  lastEpicDate,
  thisMonthEpicCount,
  personalFateHourSeed,
  lastLoginAt,
  loginStreak,
  birthday,
}

cards/{cardId}: {
  ...原有欄位,
  rarity: "common" | "uncommon" | "rare" | "epic" | "legendary" | "mythic",
  rarityScore: 72,           // 總分（debug 用，玩家看不到）
  photoScore: 22,            // 照片分數
  spellScore: 25,            // 咒語分數
  fateValue: 25,             // 命運值
  globalIndex: 42,           // 全服同類第 N 張
  globalCount: 12847,        // 全服同類總數
}

collections/{category}/{subject}: {
  totalCards: 12847,          // 全服該主體卡片總數
  rarityBreakdown: {
    common: 5721,
    uncommon: 3842,
    rare: 1928,
    epic: 901,
    legendary: 320,
    mythic: 17,
  }
}

codex/{userId}/{category}: {
  discovered: ["貓", "狗", "倉鼠"],
  total: 50,
  progress: 0.06,
}
```

---

# 五、開發排程（卡片系統 8 週）

```
第 1~2 週：基礎召喚
  ✅ 拍照 + 錄音 UI
  ✅ 上傳到 Firebase Storage
  ✅ Claude Vision 分析
  ✅ Whisper 語音轉文字
  ✅ Claude 綜合判定（含稀有度評分公式）
  ✅ Sharp 卡面合成（先做凡品卡框）

第 3~4 週：稀有度系統
  ✅ 保底系統（五重保底邏輯）
  ✅ 環境加成計算
  ✅ Firestore 保底追蹤資料結構
  ✅ 稀有度濾鏡管線（6 種濾鏡參數）
  ✅ 3 套卡框（凡品 + 稀有 + 傳說，最低可行）

第 5~6 週：視覺效果
  ✅ 翻卡動畫（至少 3 種：普通/中等/史詩級）
  ✅ 粒子效果（Lottie 整合）
  ✅ 卡片詳情頁 UI
  ✅ 全服編號系統
  ✅ 卡組列表 UI（不同稀有度視覺差異）

第 7~8 週：收藏與打磨
  ✅ 素材圖鑑系統
  ✅ 卡片圖鑑系統
  ✅ 今日運勢 UI
  ✅ 特殊機率事件（天命時刻、逆轉召喚）
  ✅ 補齊其餘卡框 + 動畫資源
  ✅ 測試 + 調參（機率平衡）
```

---

# 六、成癮性自檢清單

```
✅ 玩家覺得「自己的行為有影響」？
   → 照片 30% + 咒語 30% = 60% 可控

✅ 每次結果都不一樣？
   → 命運值 40% 隨機 + 環境加成變化

✅ 有「差一點」的感覺？
   → 稀有度範圍重疊 + 分數微調

✅ 有保底機制避免過度挫敗？
   → 五重保底，最多 30 抽必出史詩

✅ 新手前幾次體驗好？
   → 第一抽保底稀有，前 5 抽加成

✅ 每天都有理由打開？
   → 每日首抽加成 + 運勢系統

✅ 出好卡有足夠的儀式感？
   → 6 級翻卡動畫，越稀有越震撼

✅ 有炫耀的管道？
   → 代表卡 + 社群標籤 + 圖鑑分享

✅ 壞運氣也有補償？
   → 連白觸發逆轉 + 敗場情緒補償

✅ 有社群討論空間？
   → 天命時刻 + 環境加成 → 永遠有「都市傳說」
```
