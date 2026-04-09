# Snapell 製卡系統 — v0 需求規格書

> **v0 目標：** 驗證「拍照 + 咒語 → AI 生成卡片」這件事好不好玩。不做對戰。
>
> **完整設計參考：** `MVP/CARD_CREATION_SYSTEM_SPEC_MVP.md`

---

## v0 範圍定義

### 做

| 功能 | 理由 |
|------|------|
| 拍照 + 文字咒語 → AI 生成卡片 | 遊戲本體 |
| 稀有度純機率抽選 + 新手保底 | 翻卡驚喜感 |
| ATK/DEF 生成（咒語張力決定方向） | 卡片必須有數值 |
| 技能分配（AI 從 7 種共享技能中選） | 卡面需要顯示技能 |
| 煉成動畫（簡化版 3 級） | 核心爽感 |
| 卡片列表 + 卡片詳情 | 基礎瀏覽 |
| 文字內容審核 | 上線必須有 |
| 分享功能（卡片截圖） | 驗證病毒性 |

### 不做

| 功能 | 原因 |
|------|------|
| 對戰系統全部 | v1 驗證 |
| 場地卡全部 | v1 驗證 |
| 結算引擎全部 | v1 驗證 |
| 6 種專屬技能 | v0 技能不結算，7 種共享足夠豐富 |
| Sharp 後端卡面合成 | 前端 CustomPainter 直出，省後端工作量 |
| 語音錄音 | v2+ |
| 保底系統（五重保底） | 簡化版保底即可 |
| 卡片分解 / 碎片 | 無對戰時不需要 |

---

## 1. 系統概述

### 一句話

玩家拍照 + 輸入咒語文字 → AI 分析 → 生成卡片。稀有度靠運氣，卡片個性靠咒語。

### 技術依賴

| 服務 | 用途 |
|------|------|
| Claude Vision API | 照片分析 |
| Claude API (text) | 咒語分析 + 卡片生成 + 技能選擇 + 審核 |
| Firebase Storage | 照片存儲 |
| Firestore | 卡片資料 |
| Cloud Functions 2nd gen | 後端邏輯 |

---

## 2. 製卡流程

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
  │                                  │── 7. Claude API → 技能選擇 + 卡片命名
  │                                  │── 8. 存入 Firestore + Storage
  │                                  │
  │←── 9. 回傳卡片資料 ─────────    │
  │                                  │
  │── 10. 煉成動畫 ──               │
```

**與完整 MVP 的差異：** 移除 Step 8 的 Sharp 卡面合成。卡面由前端 CustomPainter 即時渲染。

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
  elements: string[];       // 辨識到的元素
}
```

與完整 MVP 完全一致，無簡化。

---

## 4. 咒語系統

與完整 MVP 一致：文字模式、三向張力判定、內容審核。

```typescript
interface SpellAnalysis {
  tensionDirection: "outward" | "inward" | "neutral";
  moderationResult: "clean" | "mild" | "severe";
}
```

---

## 5. 稀有度系統

與完整 MVP 完全一致：

| 稀有度 | 機率 |
|--------|------|
| ⚪ 凡品 | 31.5% |
| 🟢 精良 | 38.0% |
| 🔵 稀有 | 17.0% |
| 🟣 史詩 | 10.0% |
| 🟡 傳說 | 3.0% |
| 🔴 神話 | 0.5% |

**保留 6 級稀有度。** 稀有度是翻卡驚喜的核心，不能砍。

### 新手保護

```
第 1 次製卡：100% 🔵稀有以上
第 2 次起：走正常機率表
```

### v0 新增：簡易保底

```
連續 20 次未出 🟣史詩以上 → 下次保底 🟣史詩
（用 users/{userId}.epicPityCounter 追蹤）
```

防止 Extinction Burst（消退爆發），成本極低。

---

## 6. 戰鬥屬性生成

### 6.1 ATK + DEF 總和

與完整 MVP 完全一致：

| 稀有度 | ATK+DEF 總和範圍 |
|--------|-----------------|
| ⚪ 凡品 | 30~42 |
| 🟢 精良 | 40~55 |
| 🔵 稀有 | 53~70 |
| 🟣 史詩 | 67~84 |
| 🟡 傳說 | 81~96 |
| 🔴 神話 | 93~100 |

### 6.2 ATK/DEF 分配

與完整 MVP 完全一致：稀有度決定自由度 → 咒語張力決定方向。

### 6.3 技能分配（v0 精簡版）

**v0 只有 7 種共享技能，無專屬技能。** AI 從 7 種中選擇最適合照片+咒語的技能。

技能在 v0 階段**只是卡面顯示的文字**，不進行結算。但數值必須正確計算（v1 直接拿來結算）。

各稀有度可用池（v0）：

| 稀有度 | 可用技能 | 池大小 |
|--------|---------|--------|
| ⚪ 凡品 | atk_boost, def_boost, shield, counter | 4 |
| 🟢 精良 | atk_boost, def_boost, shield, counter, madness | 5 |
| 🔵 稀有 | atk_boost, def_boost, shield, counter, madness, double_strike, pierce | 7 |
| 🟣 史詩 | shield, madness, double_strike, pierce | 4 |
| 🟡 傳說 | madness, double_strike, pierce | 3 |
| 🔴 神話 | madness, double_strike, pierce | 3 |

> **v0→v1 遷移注意：** v1 加入 6 種專屬技能後，🟡傳說和🔴神話的技能池會變化。v0 期間已生成的🟡🔴卡片保留原技能不變。

### 6.4 數值倍率

與完整 MVP 一致：

| 稀有度 | 倍率 |
|--------|------|
| ⚪ 凡品 | ×0.55 |
| 🟢 精良 | ×0.70 |
| 🔵 稀有 | ×0.85 |
| 🟣 史詩 | ×1.00 |
| 🟡 傳說 | ×1.15 |
| 🔴 神話 | ×1.30 |

---

## 7. 煉成動畫（v0 簡化版）

### 三級特效

| 等級 | 對應稀有度 | 特效 |
|------|-----------|------|
| 無 | ⚪ 凡品、🟢 精良 | 卡片翻轉，無額外特效 |
| 光暈 | 🔵 稀有、🟣 史詩 | 卡片翻轉 + 藍/紫色光暈 + haptic |
| 全螢幕 | 🟡 傳說、🔴 神話 | 卡片翻轉 + 全螢幕金/紅色特效 + 長震動 |

**v0 不做：** 6 級各自的精緻特效（粒子、光柱等），v1 對戰時再補。

### 翻卡後展示

```
┌──────────────────────────────┐
│  [卡面圖像 — CustomPainter]     │
│                              │
│  ⚡ 肉球雷霆        🔵 稀有    │
│  「肉球之下無人倖存」          │
│                              │
│  ATK 37  DEF 25              │
│  肉球連擊 — 攻擊兩次，第二擊+5 │
│                              │
│  慵懶的外表下藏著毀滅性的      │
│  肉球，一擊足以撼動戰場。      │
│                              │
│  [分享]  [完成]               │
└──────────────────────────────┘
```

---

## 8. 內容審核

與完整 MVP 完全一致：

| moderationResult | 處理 |
|-----------------|------|
| `clean` | 不處理 |
| `mild` | spellText 替換為 `***` |
| `severe` | spellText 替換為 `（咒語已封印）` |

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
  spellText: "肉球之下無人倖存",

  // === 卡片屬性 ===
  name: "肉球雷霆",
  description: "慵懶的外表下藏著毀滅性的肉球...",
  rarity: "rare",

  // === 戰鬥屬性（v0 不結算，但數值正確存儲，v1 直接使用）===
  battle: {
    atk: 37,
    def: 25,
    skillMechanic: "double_strike",
    skillParams: { secondHitRatio: 0.43 },
    skillName: "肉球連擊",
    skillDesc: "揮出兩記致命肉球，第二擊額外傷害 5",
  },

  // === 戰績（v0 不用，v1 啟用）===
  stats: {
    battlesPlayed: 0,
    wins: 0,
    losses: 0,
  },
}
```

### users/{userId}

```javascript
{
  totalCardsCreated: 0,
  epicPityCounter: 0,       // v0 新增：連續未出紫的計數器
}
```

---

## 10. Cloud Function 端點

### v0 只有 1 個端點

#### POST /createCard

與完整 MVP 基本一致，差異：

```
完整 MVP 流程：
  1~7. （相同）
  8. Sharp 卡面合成 ← v0 移除
  9~10. 存入 Firestore + Storage ← v0 只存照片，不存合成卡面
  11~12. （相同）
  新增：13. 更新 epicPityCounter

v0 流程：
  1. 上傳照片 → Storage
  2. 並行：Claude Vision + Claude API（咒語分析+審核）
  3. 稀有度抽選（檢查新手保護 + 簡易保底）
  4. ATK/DEF 生成
  5. 查表獲取可用技能列表（7 種共享，按稀有度過濾）
  6. Claude API → 技能選擇 + 卡片命名 + 技能命名
  7. 計算 skillParams（skillMechanic + rarity 查表）
  8. 寫入 Firestore cards/{cardId}
  9. 更新 users/{userId}（totalCardsCreated + epicPityCounter）
  10. 回傳 CreateCardResponse
```

**AI 呼叫次數：** 3 次（與完整 MVP 相同）
**預估耗時：** 3~5 秒（省掉 Sharp 合成的 1~2 秒）

---

## 11. 前端頁面清單

| 頁面 | 功能 |
|------|------|
| 首頁 | 「製作新卡片」按鈕 + 最近卡片 |
| 製卡相機 | 拍照 + 輸入咒語文字 + 送出 |
| 煉成動畫 | 翻卡 + 稀有度特效（3 級） |
| 卡片詳情 | 完整卡片資訊 + 分享按鈕 |
| 卡片列表 | 所有卡片 + 稀有度篩選 |
| 設定 | 帳號基本資訊 |

**v0 不需要：** 對戰相關頁面、牌庫管理、好友列表、戰績頁面

---

## 12. Claude API Prompt 設計

### 12.1 照片分析

與完整 MVP 完全一致。

### 12.2 咒語分析 + 審核

與完整 MVP 完全一致。

### 12.3 卡片生成 + 技能選擇（v0 版）

與完整 MVP 基本一致，差異：
- `{availableSkillList}` 只包含 7 種共享技能（按稀有度過濾後的子集）
- 不包含專屬技能
- 其餘命名規則、語氣指引完全相同

---

## 13. v0 → v1 遷移事項

| 項目 | v0 狀態 | v1 需要做的 |
|------|--------|------------|
| cards/{cardId} | 結構完整，battle 欄位已正確填充 | 直接使用，不需遷移 |
| users/{userId} | 有 totalCardsCreated + epicPityCounter | 新增對戰相關欄位 |
| 技能 | 7 種共享，v0 期間🟡🔴卡片使用共享技能 | v1 新卡片加入專屬技能；舊卡保留原技能 |
| 卡面 | 前端 CustomPainter 渲染 | 不需改動（或後續補 Sharp 合成） |
| Cloud Functions | 只有 createCard | 新增 4 個對戰端點 |
