# Snapell 製卡系統 — MVP 需求規格書

> **MVP 原則：** 一人團隊，先做能跑的核心循環。砍掉一切「沒有也能玩」的功能。

---

## MVP 範圍定義

### 保留（核心循環）

| 功能 | 理由 |
|------|------|
| 拍照 + 文字咒語 → AI 生成卡片 | 這就是遊戲本體 |
| 稀有度純機率抽選 | 每次製卡的驚喜感 |
| ATK/DEF 生成（咒語張力決定方向） | 卡片必須有數值才能打 |
| 技能分配（AI 直選 + 動態命名） | 對戰需要 |
| 煉成動畫 | 核心爽感 |
| 卡片列表 + 卡片詳情 | 基礎瀏覽 |
| 文字內容審核 | 上線必須有 |

### 延後（v2+）

| 功能 | 延後原因 |
|------|---------|
| 🗣️ 語音錄音 + 對戰播放 | 沒語音也能玩，省大量前後端工作 |
| 📷 照片粒子動畫（打字特效） | 純視覺，不影響功能 |
| 🎲 五重保底（Pity System） | 先用簡化版保底，玩家初期感受不到差異 |
| 🏷️ 自動標籤 / 徽章系統 | 收藏系統可後加 |
| 🏆 成就系統 | 同上 |
| 🎭 咒語反應系統 | 需要對戰系統先完成 |
| 💔 卡片分解 + 煉金碎片 | 初期卡少不需要分解 |
| 📜 誕生指紋 / 限定標記 | 交易前置，交易本身就是未來功能 |
| 🔄 收藏價值 / 交易體系 | 明確標為未來功能 |
| 🖼️ 個人展櫃 | 社交功能可後加 |
| 🌍 GPS 地點 / 天氣 | 需要額外 API + 權限，不影響核心 |
| 🎬 frameHint 懸念系統 | 煉成動畫簡化即可 |

---

## 1. 系統概述

### 一句話

玩家拍照 + 輸入咒語文字 → AI 分析 → 生成卡片。稀有度靠運氣，卡片個性靠你的咒語。

### 設計哲學

```
製卡的樂趣不是「拿到好卡」，是：
  1. 看 AI 把你的照片和咒語變成什麼東西（好奇心）
  2. 想出一句很酷/很搞笑的咒語，知道對手會看到（表演慾）
  3. 翻卡瞬間不知道會出什麼稀有度（驚喜感）
  4. 用咒語影響 ATK/DEF 方向和技能選擇（策略性）

稀有度是命運給的驚喜，不是努力的獎勵。
照片和咒語決定「這張卡是什麼」，不是「這張卡有多好」。
```

### 技術依賴

| 服務 | 用途 |
|------|------|
| Claude Vision API | 照片分析（物體辨識、分類） |
| Claude API (text) | 卡片名稱描述生成 + 咒語張力判定 + 內容審核 |
| Firebase Storage | 照片 + 卡面圖片 |
| Firestore | 卡片資料 |
| Cloud Functions 2nd gen | 所有後端邏輯 |
| Sharp (Node.js) | 卡面合成 |

**MVP 不需要：** 語音相關（record, ffmpeg）、GPS、天氣 API

---

## 2. 製卡流程

### 簡化時序

```
Client                          Server (Cloud Function)
  │                                  │
  │── 1. 拍照 ──                    │
  │── 2. 輸入咒語文字 ──            │
  │                                  │
  │── 3. 上傳 photo + spellText ──→ │
  │                                  │── 4a. Claude Vision → 照片分析
  │                                  │── 4b. Claude API → 咒語分析 + 審核
  │                                  │      (4a, 4b 並行)
  │                                  │
  │                                  │── 5. 稀有度抽選（純機率）
  │                                  │── 6. ATK/DEF 生成
  │                                  │── 7. Claude API → 技能選擇 + 卡片命名 + 技能命名
  │                                  │── 8. Sharp → 卡面合成
  │                                  │── 9. 存入 Firestore + Storage
  │                                  │
  │←── 10. 回傳卡片資料 ────────    │
  │                                  │
  │── 11. 煉成動畫 ──               │
```

### 上傳 payload

```typescript
interface CreateCardRequest {
  photo: File;          // JPEG, ≤ 500KB
  spellText: string;    // 咒語文字（可為空字串）
}
```

### 回傳 payload

```typescript
interface CreateCardResponse {
  cardId: string;
  card: CardDocument;
}
```

---

## 3. 照片處理

### Claude Vision API 輸出

```typescript
interface PhotoAnalysis {
  object: string;           // 主要物體，例："橘色的貓"
  mood: string;             // 氛圍，例："慵懶"
  elements: string[];       // 辨識到的元素，例：["貓", "沙發", "陽光"]
}
```

照片分析只提取物體、氛圍、元素。**不做分類。** 技能由 AI 在後續步驟中根據照片 + 咒語語境直接選擇（見 Section 6.3）。

---

## 4. 咒語系統（MVP 簡化版）

### MVP 只有文字模式

```
玩家輸入咒語文字 → 送出
```

- 無語音錄製
- 無自動模式
- 無打字粒子特效

### 咒語的作用（不是評分，是影響卡片個性）

| 咒語影響什麼 | 怎麼影響 | 範例 |
|-------------|---------|------|
| ATK/DEF 方向 | 攻擊性咒語 → ATK 偏高 | 「毀滅吧」→ 高 ATK |
| 技能選擇 | AI 從該稀有度可用池中選擇最適合的技能 | 拍貓寫「連續肉球」→ double_strike |
| 卡片名稱 | AI 用咒語生成卡片名 | 「肉球之下無人倖存」→「肉球雷霆」 |
| 卡片描述 | AI 用咒語生成描述 | 咒語越有畫面感，描述越戲劇性 |
| 技能命名 | AI 根據照片 + 咒語為技能生成獨特名稱 | double_strike →「珍珠連射」（拍奶茶時） |
| 對戰中顯示 | 翻卡時對手看到你的咒語文字 | 社交表演 |

**咒語不影響：** 稀有度、ATK/DEF 總和、數值高低、技能百分比數值。

### 空咒語處理

```
玩家沒輸入咒語就按送出：
  tensionDirection = "neutral"（ATK/DEF 均分）
  卡片名稱、描述、技能名稱只根據照片生成
  對戰時不顯示咒語文字
```

### Claude API 咒語分析回傳

```typescript
interface SpellAnalysis {
  tensionDirection: "outward" | "inward" | "neutral";
  moderationResult: "clean" | "mild" | "severe";
}
```

不回傳分數、不回傳等級、不回傳類別。只回傳方向性判定 + 審核結果。

---

## 5. 稀有度系統

### 純機率抽選

每次製卡都用同一張機率表，跟照片品質、咒語品質完全無關：

| 稀有度 | enum | 機率 |
|--------|------|------|
| ⚪ 凡品 | `common` | 31.5% |
| 🟢 精良 | `uncommon` | 38.0% |
| 🔵 稀有 | `rare` | 17.0% |
| 🟣 史詩 | `epic` | 10.0% |
| 🟡 傳說 | `legendary` | 3.0% |
| 🔴 神話 | `mythic` | 0.5% |

**設計重點：精良（38%）> 凡品（31.5%），玩家的基線情緒是「出綠」而非「出白」。**

### MVP 簡化保底

只保留一個機制：**新手保護**

```
第 1 次製卡：100% 🔵稀有以上（直接在 rare/epic/legendary/mythic 中按比例抽）
第 2 次起：走正常機率表
```

存儲：`users/{userId}.totalCardsCreated`

### 為什麼稀有度不受玩家輸入影響

```
迷因性 > 公平性

拍大便出神話 = 爆笑截圖 = 病毒傳播
寫「喵」出傳說 = 不可思議 = 群組話題
拍老闆出凡品 = 合理但好笑 = 社交貨幣

如果品質影響稀有度：
  拍大便 → 一定出凡品 → 無聊
  認真拍 → 一定出好卡 → 可預測 → 無聊

隨機 = 反差 = 好笑 = 分享
```

---

## 6. 戰鬥屬性生成

稀有度決定三件事：**數值池**、**分配自由度**、**技能數值等級**。

### 6.1 ATK + DEF 總和

稀有度越高，ATK+DEF 總和越大。**相鄰稀有度有 2~3 點重疊**，讓滿 roll 的低稀有度卡有機會比低 roll 的高稀有度卡更強：

| 稀有度 | ATK+DEF 總和範圍 | 與下一級重疊 |
|--------|-----------------|------------|
| ⚪ 凡品 | 30~42 | 42 vs 精良 40 → 重疊 2 點 |
| 🟢 精良 | 40~55 | 55 vs 稀有 53 → 重疊 2 點 |
| 🔵 稀有 | 53~70 | 70 vs 史詩 67 → 重疊 3 點 |
| 🟣 史詩 | 67~84 | 84 vs 傳說 81 → 重疊 3 點 |
| 🟡 傳說 | 81~96 | 96 vs 神話 93 → 重疊 3 點 |
| 🔴 神話 | 93~100 | — |

在範圍內隨機取值。

### 6.2 ATK/DEF 怎麼分配

分兩步：**稀有度決定自由度** → **咒語張力決定方向**。

**稀有度 → 分配自由度（ATK 允許佔總和的百分比範圍）：**

| 稀有度 | ATK 佔比範圍 | 白話 |
|--------|-------------|------|
| ⚪ 凡品 | 45%~55% | 幾乎均分，無法偏科 |
| 🟢 精良 | 40%~60% | 輕微偏科 |
| 🔵 稀有 | 35%~65% | 明顯偏科 |
| 🟣 史詩 | 30%~70% | 大幅偏科 |
| 🟡 傳說 | 25%~75% | 極端偏科 |
| 🔴 神話 | 20%~80% | 純攻或純防 |

**咒語張力 → 在自由度範圍內決定偏向哪邊：**

| tensionDirection | 含義 | ATK 佔比傾向 |
|-----------------|------|-------------|
| `outward` | 攻擊性咒語（「毀滅吧」「燃燒」） | 往上限靠 |
| `inward` | 防禦性咒語（「守護」「堅不可摧」） | 往下限靠 |
| `neutral` | 中性/空咒語（「你好嗎」「今天天氣不錯」） | 取中間值 |

**具體公式：**

```typescript
function distributeStats(statTotal: number, rarity: Rarity, tension: TensionDirection): { atk: number, def: number } {
  const { minRatio, maxRatio } = ATK_RATIO_BY_RARITY[rarity];

  let atkRatio: number;
  switch (tension) {
    case 'outward':
      // 偏向上限：在中間值~上限之間隨機
      atkRatio = (0.5 * (minRatio + maxRatio) + maxRatio) / 2
                 + Math.random() * (maxRatio - 0.5 * (minRatio + maxRatio)) / 2;
      break;
    case 'inward':
      // 偏向下限：在下限~中間值之間隨機
      atkRatio = minRatio
                 + Math.random() * (0.5 * (minRatio + maxRatio) - minRatio) / 2;
      break;
    case 'neutral':
    default:
      // 取中間區段隨機
      const mid = 0.5 * (minRatio + maxRatio);
      const spread = (maxRatio - minRatio) * 0.15;
      atkRatio = mid - spread + Math.random() * spread * 2;
  }

  const atk = Math.round(statTotal * atkRatio);
  const def = statTotal - atk;
  return { atk, def };
}
```

### 6.3 技能分配（AI 直選）

**核心設計：** 不做照片分類，不做分類→技能池映射。由 Claude API 在生成卡片名稱時，**從該稀有度可用的技能池中選擇最適合的一種**。

```
AI 選擇依據（按優先度）：
  1. 稀有度限制（強制）：系統只傳入該稀有度可用的技能列表（見 SKILL_SYSTEM_MVP.md Section 1）
  2. 照片物體的本質（貓 → 可能 double_strike「連續肉球」或 dodge「優雅閃避」）
  3. 咒語語境（「堅不可摧」→ 可能 fortress 或 shield）
  4. 照片氛圍（「慵懶」→ 可能 counter「反擊」而非 madness「暴走」）
  5. 專屬技能傾向：當稀有度有專屬技能時，適度優先選擇專屬技能（增加稀有度辨識度）
  6. 製造驚喜（偶爾打破直覺：拍食物 → madness「暴食暴走」）
```

**MVP：13 種技能機制（7 共享 + 6 稀有度專屬），每個稀有度 1 個專屬技能，階梯式解鎖 + 退役。** 技能數值由稀有度決定百分比，卡面顯示計算後的絕對值。🔴 神話卡 = rebirth（唯一專屬）。v2 擴展至完整 30 種。

**各稀有度可用技能數（MVP）：** ⚪5（4共享+1專屬） → 🟢6（5+1） → 🔵7（6+1） → 🟣6（5+1） → 🟡4（3+1） → 🔴1（0+1）。完整可用矩陣見 SKILL_SYSTEM_MVP.md Section 1。

**技能數值等級：** 每種技能有 6 級數值，對應 6 種稀有度。使用連續遞增比例：

| 稀有度 | 數值倍率 | 設計意圖 |
|--------|---------|---------|
| ⚪ 凡品 | ×0.55 | 效果明顯弱，但極端技能（madness）仍有高風險高回報 |
| 🟢 精良 | ×0.70 | 略弱於基準 |
| 🔵 稀有 | ×0.85 | 略弱於基準 |
| 🟣 史詩 | ×1.00 | 基準值 |
| 🟡 傳說 | ×1.15 | 略強於基準 |
| 🔴 神話 | ×1.30 | 效果最強 |

MVP 13 種技能的數值表和各稀有度可用技能池見附錄 A（SKILL_SYSTEM_MVP.md）。

**AI 動態命名：** Claude API 根據照片 + 咒語 + 選中的技能機制，生成獨特的 `skillName`（技能顯示名稱）和 `skillDesc`（技能效果描述）。同樣的 `double_strike` 機制：
- 拍貓 →「肉球連擊：攻擊兩次，第二擊額外傷害 6」
- 拍奶茶 →「珍珠連射：攻擊兩次，第二擊額外傷害 3」
- 拍跑車 →「雙渦輪衝擊：攻擊兩次，第二擊額外傷害 9」

卡面顯示絕對值，玩家不需要知道背後是百分比計算。

**邊界規則（MVP）：**
- `madness` vs `counter`：madness 方 ATK 暴增打出高傷害，counter 方反彈該傷害 → 合法互動
- `hex` + 對手 `madness`：對手 DEF 已為 0，hex 無額外效果 → 自然處理
- `final_stand` / `rebirth` 觸發時阻止 `spite`（不同稀有度不會同時出現，但邏輯要正確）
- MVP 的 13 種技能之間無需特殊互動處理，所有效果線性結算

### 6.4 完整範例

```
玩家拍了一隻貓，寫了「肉球之下無人倖存」

─── Step 1: AI 分析（並行）───
照片：object="橘色的貓", mood="慵懶", elements=["貓", "沙發", "陽光"]
咒語：tensionDirection=outward, moderationResult=clean

─── Step 2: 稀有度 ───
純機率抽選 → roll 0.73 → 🔵 稀有（落在 69.5%~86.5% 區間）

─── Step 3: ATK+DEF 總和 ───
稀有度 🔵稀有 → 範圍 53~70
隨機取值 → 62

─── Step 4: ATK/DEF 分配 ───
稀有度 🔵稀有 → ATK 佔比允許 35%~65%
tensionDirection = outward → ATK 偏上限
→ ATK 佔比 ≈ 60%
→ ATK = 37, DEF = 25

─── Step 5: 技能選擇（系統決定）───
稀有度 🔵 → 查 SKILL_SYSTEM_MVP.md 可用矩陣 → 7 種可選（6 共享 + 1 專屬）
AI 從可用池中選擇 → double_strike
double_strike 🔵稀有 secondHitRatio = 43%
→ 第一擊傷害 = 37-25 = 12，第二擊額外 = round(12 × 0.43) = 5

─── Step 6: AI 生成卡片 + 技能命名 ───
Claude API 輸入：object, mood, spellText, rarity, atk, def, skillMechanic, skillEffect
回傳：
  name = "肉球雷霆"
  description = "慵懶的外表下藏著毀滅性的肉球，一擊足以撼動戰場。"
  skillName = "肉球連擊"
  skillDesc = "揮出兩記致命肉球，第二擊額外傷害 5"

─── 最終卡片 ───
名稱：肉球雷霆
咒語：「肉球之下無人倖存」
稀有度：🔵 稀有
ATK: 37  DEF: 25
技能：肉球連擊 — 攻擊兩次，第二擊額外傷害 5
```

---

## 7. 煉成動畫（MVP 簡化版）

### 兩階段揭示

**第一階段：卡面翻轉（2s）**
- 卡片從背面翻轉到正面

**第二階段：稀有度特效（1s）**

| 稀有度 | 特效 |
|--------|------|
| ⚪ 凡品 | 無 |
| 🟢 精良 | 綠色光暈 |
| 🔵 稀有 | 藍色粒子 |
| 🟣 史詩 | 紫色光柱 + haptic |
| 🟡 傳說 | 金色爆裂 + 音效 |
| 🔴 神話 | 全螢幕特效 + 長震動 |

**MVP 不做：** frameHint 懸念系統、技能系浮現階段

### 翻卡後展示

不顯示分數。展示卡片本身：

```
┌──────────────────────────────┐
│  [卡面圖像]                    │
│                              │
│  ⚡ 肉球雷霆        🔵 稀有    │
│  「肉球之下無人倖存」          │
│                              │
│  ATK 37  DEF 25              │
│  肉球連擊 — 攻擊兩次，第二擊額外傷害 5 │
│                              │
│  慵懶的外表下藏著毀滅性的      │
│  肉球，一擊足以撼動戰場。      │
└──────────────────────────────┘
```

---

## 8. 內容審核

### 文字審核（製卡時同步執行）

- 與咒語分析合併為同一次 Claude API 呼叫
- Claude API 回傳 `moderationResult`：

| moderationResult | 處理 |
|-----------------|------|
| `clean` | 不處理 |
| `mild` | spellText 替換為 `***` |
| `severe` | spellText 替換為 `（咒語已封印）` |

不影響卡片屬性，只替換顯示文字。

---

## 9. Firestore 資料結構

### cards/{cardId}

```javascript
{
  // === 基礎 ===
  cardId: "auto-generated-uuid",
  userId: "user123",
  createdAt: Timestamp,

  // === 照片 ===
  photoUrl: "gs://voxcards/photos/...",

  // === 咒語 ===
  spellText: "肉球之下無人倖存",  // 空字串表示沒有咒語

  // === 卡片屬性 ===
  name: "肉球雷霆",
  description: "慵懶的外表下藏著毀滅性的肉球...",
  rarity: "rare",            // common|uncommon|rare|epic|legendary|mythic

  // === 戰鬥（技能欄位定義見 SKILL_SYSTEM_MVP.md Section 5）===
  battle: {
    atk: 37,
    def: 25,
    skillMechanic: "double_strike",   // 30 種機制 ID 之一（受稀有度限制）
    skillParams: {                    // 該機制在此稀有度的具體參數
      secondHitRatio: 0.43
    },
    skillName: "肉球連擊",            // AI 生成的獨特技能名稱
    skillDesc: "揮出兩記致命肉球，第二擊額外傷害 5",  // AI 生成的效果描述
    // === doppelganger 專用（v2，MVP 不需要）===
    // secondSkillMechanic: null,
    // secondSkillParams: null,
    // secondSkillName: null,
    // secondSkillDesc: null,
  },

  // === 戰績（初始值）===
  stats: {
    battlesPlayed: 0,
    wins: 0,
    losses: 0,
  },
}
```

### users/{userId} 相關欄位

```javascript
{
  totalCardsCreated: 0,     // 用於新手保護判定
}
```

---

## 10. Cloud Function 端點

### POST /createCard

**輸入：** `{ photo: File, spellText: string }`

**處理流程：**

```
1. 上傳照片到 Storage → photoUrl
2. 如果 spellText 為空 → 跳過咒語分析，使用預設值
3. 並行：
   a. Claude Vision API → photoAnalysis (object, mood, elements)
   b. Claude API → tensionDirection + moderationResult
4. 如果文字違規 → 替換 spellText
5. 稀有度 = 純機率抽選（檢查新手保護）
6. ATK+DEF 總和 = 在稀有度範圍內隨機
7. ATK/DEF 分配 = 自由度範圍 × 張力方向
8. 根據 rarity 查表獲取可用技能列表（共享 + 該稀有度專屬，見 SKILL_SYSTEM_MVP.md Section 1）
9. Claude API → 技能選擇 + 卡片名稱描述 + 技能名稱描述
   輸入：object, mood, elements, spellText, rarity, atk, def, availableSkills
   回傳：skillMechanic, name, description, skillName, skillDesc
10. 根據 skillMechanic + rarity 查表計算 skillParams（見 SKILL_SYSTEM_MVP.md Section 5）
// 10b. [v2] 如果 skillMechanic = doppelganger → 隨機抽取🟡池第二技能（排除禁止組合）
11. Sharp → 卡面合成
12. 上傳卡面 → Storage
13. 寫入 Firestore cards/{cardId}
14. 更新 users/{userId}.totalCardsCreated +1
15. 回傳 CreateCardResponse
```

**AI 呼叫次數：** 3 次（照片分析 + 咒語分析審核 + 卡片生成含技能選擇），前兩次並行。

**預估耗時：** 3~6 秒

---

## 11. 前端頁面清單

| 頁面 | 功能 |
|------|------|
| 製卡相機 | 拍照 + 輸入咒語文字 + 送出 |
| 煉成動畫 | 翻卡 + 稀有度特效 |
| 卡片詳情 | 完整卡片資訊 |
| 卡組管理 | 卡片列表 + 篩選 |

---

## 12. Claude API Prompt 設計

### 12.1 照片分析 Prompt（Claude Vision）

```
分析這張照片，回傳 JSON：
{
  "object": "主要物體描述（繁體中文，5~15字）",
  "mood": "照片氛圍（繁體中文，2~4字）",
  "elements": ["辨識到的元素（繁體中文）"]
}

如果照片有多個物體，選最顯眼的當主體。
```

### 12.2 咒語分析 + 審核 Prompt（Claude API）

```
你是卡片遊戲的咒語分析系統。

玩家咒語：「{spellText}」

回傳 JSON：
{
  "tensionDirection": "outward|inward|neutral",
  "moderationResult": "clean|mild|severe"
}

tensionDirection 判定：
- outward: 咒語帶有攻擊性、破壞性、狂暴感
- inward: 咒語帶有守護性、防禦性、沉穩感
- neutral: 平衡、哲學、描述性、或跟戰鬥無關

moderationResult 判定：
- clean: 正常內容
- mild: 輕度不當（髒話）
- severe: 重度不當（人身攻擊、色情、仇恨）
```

### 12.3 卡片生成 + 技能選擇 + 命名 Prompt（Claude API）

此步驟合併三件事：**選擇技能機制** + **生成卡片名稱描述** + **生成技能名稱描述**。

```
你是卡片遊戲的卡片設計師。根據以下資訊，選擇最適合的技能並生成卡片內容。

照片物體：{object}
照片氛圍：{mood}
照片元素：{elements}
玩家咒語：「{spellText}」
稀有度：{rarity}
ATK：{atk}  DEF：{def}

可選技能機制（{availableCount} 種，已根據稀有度過濾）：
{availableSkillList}

（注意：以上技能列表已根據此卡片的稀有度過濾。只能從中選擇，不可選擇未列出的技能。）

回傳 JSON：
{
  "skillMechanic": "從可用列表中選擇的機制 ID",
  "name": "卡片名稱",
  "description": "卡片描述",
  "skillName": "技能顯示名稱",
  "skillDesc": "技能效果描述（包含計算後的絕對數字）"
}

技能選擇原則：
- 選擇最契合照片物體 + 咒語意境的機制
- 偶爾可以選出乎意料但仍能自圓其說的組合（製造驚喜）
- 不需要考慮數值平衡（系統已自動平衡）

命名規則：
- name（卡片名稱）：繁體中文，2~6 字，有中二感，融合照片物體和咒語意境
- description（卡片描述）：繁體中文，15~30 字，像在介紹一個傳說中的存在
- skillName（技能名稱）：繁體中文，2~5 字，要跟照片物體有關聯
  例：拍貓的 double_strike →「肉球連擊」，拍奶茶的 double_strike →「珍珠連射」
- skillDesc（技能描述）：繁體中文，包含效果和絕對數字
  例：「揮出兩記致命肉球，第二擊 ATK {計算值}」
- 如果咒語搞笑，名稱也要幽默
- 如果咒語為空，只根據照片生成
- 稀有度越高，用詞越霸氣
```

**Cloud Function 先根據 rarity 查 SKILL_SYSTEM_MVP.md 的可用矩陣，將 `{availableSkillList}` 和 `{availableCount}` 注入 Prompt。** 技能數值由 skillMechanic + rarity 查表計算後注入 `{計算值}` 位置。

---

## 13. 本系統產出欄位

| 欄位 | 對戰系統用途 |
|------|-------------|
| `battle.atk` / `battle.def` | 傷害公式 |
| `battle.skillMechanic` / `battle.skillParams` | 技能結算（見 SKILL_SYSTEM_MVP.md） |
| `battle.skillName` / `battle.skillDesc` | 卡面 + 對戰中顯示 |
| `rarity` | 卡面視覺等級 |
| `spellText` | 對戰中顯示 |

---

## 附錄 A：技能系統

MVP 技能規格（13 種機制，精簡自完整版 30 種）見：

> **[SKILL_SYSTEM_MVP.md](./SKILL_SYSTEM_MVP.md)**（MVP 版，13 種技能）
> **[SKILL_SYSTEM.md](./SKILL_SYSTEM.md)**（完整版，30 種技能，v2 目標）

---

## 附錄 B：卡面合成規格

> TODO: 將 Sharp 卡面合成所需的模板尺寸、圖層順序、字型設定補入此處。

---

## 附錄 C：MVP → 完整版升級路線

| 階段 | 新增功能 | 涉及改動 |
|------|---------|---------|
| v1.1 | 語音錄製 + 對戰播放 | CreateCardRequest 加 voice, Firestore 加 hasVoice/spellAudioUrl |
| v1.1 | 自動模式（5秒超時） | 前端 timer + tensionDirection 固定 neutral |
| v1.2 | 五重保底系統 | users 加 pityCounter/dailySummons/lastLoginAt/consecutiveLosses |
| v1.3 | 自動標籤 / 徽章 | Firestore 加 badges 欄位 |
| v1.3 | 成就系統 | users 加 achievements |
| v1.4 | 卡片分解 + 碎片 | 新增 /decomposeCard endpoint, users 加 alchemyFragments |
| v1.5 | 個人展櫃 | users 加 showcase |
| v1.5 | 咒語反應系統 | 新增 social 欄位 + /addReaction endpoint |
| v2.0 | GPS / 天氣 / 限定標記 | CreateCardRequest 加 location, 接天氣 API |
| v2.0 | 誕生指紋 | Firestore 加 birth 欄位 |
| v3.0 | 收藏價值 / 交易體系 | 完整交易市場 |
