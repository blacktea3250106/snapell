# v0 → v1 升級指南

> 從「純製卡」升級到「製卡 + 對戰」的完整遷移清單。

---

## 1. Firestore 變更

### 新增 Collections

| Collection | 用途 |
|------------|------|
| `battles/{battleId}` | 對戰房間 + 狀態 |
| `battles/{battleId}/moves/{moveId}` | 每回合出牌記錄 |
| `inviteCodes/{code}` | 邀請碼 |

### 修改 Collections

#### users/{userId} 新增欄位

```javascript
{
  // v0 已有
  totalCardsCreated: 0,
  epicPityCounter: 0,

  // v1 新增
  totalBattlesPlayed: 0,
  totalWins: 0,
  totalLosses: 0,
}
```

#### cards/{cardId} — 無需修改

v0 已正確存儲 `battle` 欄位（atk, def, skillMechanic, skillParams, skillName, skillDesc）和 `stats` 欄位。v1 直接使用。

### 新增 Security Rules

```javascript
// v1 新增規則
match /battles/{battleId} {
  allow read: if request.auth.uid == resource.data.hostId
               || request.auth.uid == resource.data.guestId;
  allow write: if false; // 只有 Cloud Function 可寫
}

match /battles/{battleId}/moves/{moveId} {
  allow create: if request.auth.uid == request.resource.data.playerId;
  allow update, delete: if false;
}

match /inviteCodes/{code} {
  allow read: if request.auth != null;
  allow write: if false; // 只有 Cloud Function 可寫
}
```

---

## 2. Cloud Functions 變更

### v0 端點（保留）

| 端點 | 改動 |
|------|------|
| `createCard` | 無改動 |

### v1 新增端點

| 端點 | 功能 | 規格來源 |
|------|------|---------|
| `createBattleRoom` | 建房 + 生成邀請碼 + 場地卡序列 | `MVP/BATTLE_SYSTEM_MVP.md` §8 |
| `joinBattleRoom` | 加入房間 | 同上 |
| `submitDeck` | 提交 10 張牌庫 + Server shuffle | 同上 |
| `submitMove` | 提交出牌 + 觸發結算 | 同上 |

### 新增模組

| 模組 | 內容 |
|------|------|
| `resolveRound.ts` | 結算引擎（Phase 0.5~4） |
| `fieldCards.ts` | 8 張場地卡效果定義 |
| `skillResolver.ts` | 13 種技能結算邏輯 |

---

## 3. 技能系統變更

### 製卡 Prompt 更新

v0 的 `createCard` 中 AI 技能選擇 prompt 需要更新：

| 項目 | v0 | v1 |
|------|-----|-----|
| 可用技能列表 | 7 種共享（按稀有度過濾） | 13 種（7 共享 + 6 專屬，按稀有度過濾） |
| 專屬技能 | 無 | 每稀有度 1 種，AI 40% 傾向選專屬 |
| 🔴 神話 | 從 3 種共享中選 | **強制 rebirth** |
| 退役規則 | 放寬 | **恢復**（atk_boost/def_boost 🟣+退役等） |

### v0 舊卡處理

**不做資料遷移。** v0 期間生成的卡片保留原技能。

理由：
1. v0 卡片數量少
2. 結算引擎按 skillMechanic 結算，不驗證「這個稀有度是否應該有這個技能」
3. 「早期限定」的特殊卡有收藏價值

---

## 4. 前端變更

### 新增頁面

| 頁面 | 路由 |
|------|------|
| 對戰入口 | `/battle` |
| 建房 / 邀請碼 | `/battle/create` |
| 加入房間 | `/battle/join` |
| 牌庫選擇 | `/battle/deck` |
| 對戰主畫面 | `/battle/play/{battleId}` |
| 對戰結果 | `/battle/result/{battleId}` |

### 修改頁面

| 頁面 | 改動 |
|------|------|
| 首頁 | 新增「對戰」入口按鈕 |
| 卡片詳情 | 新增戰績顯示（勝/敗場數） |
| 卡片列表 | 新增「可用於對戰」的標記 |

### 新增 Riverpod Provider

| Provider | 類型 | 用途 |
|----------|------|------|
| `battleProvider` | StreamProvider | 監聽 battles/{battleId} |
| `battleMovesProvider` | StreamProvider | 監聽 moves subcollection |

---

## 5. 依賴變更

### 不需要新增的依賴

v0 已有的依賴足夠支撐 v1：
- Firebase Auth、Firestore、Storage → 已有
- Riverpod → 已有
- CustomPainter → 已有

### 可選新增

| 依賴 | 用途 | 必要性 |
|------|------|--------|
| `encrypt` (dart) | 場地卡序列加密 | 建議（防作弊） |
| `crypto` (Node.js) | Server 端加密 | 建議 |

---

## 6. 升級檢查清單

```
□ Firestore
  □ 新增 battles collection + Security Rules
  □ 新增 moves subcollection + Security Rules
  □ 新增 inviteCodes collection + Security Rules
  □ users/{userId} 新增對戰欄位

□ Cloud Functions
  □ 新增 createBattleRoom
  □ 新增 joinBattleRoom
  □ 新增 submitDeck
  □ 新增 submitMove（含 resolveRound）
  □ 新增 resolveRound 結算引擎
  □ 新增 8 張場地卡效果模組
  □ 新增 13 種技能結算模組
  □ 更新 createCard Prompt（加入專屬技能）

□ 前端
  □ 對戰入口頁面
  □ 建房 / 邀請碼頁面
  □ 加入房間頁面
  □ 牌庫選擇頁面
  □ 對戰主畫面（手牌 + 場地 + 倒計時 + HP）
  □ 翻卡 + 結果動畫（簡化 3 段）
  □ 對戰結果頁面
  □ 首頁新增對戰入口
  □ 卡片詳情新增戰績
  □ battleProvider + battleMovesProvider

□ 測試
  □ 結算引擎單元測試（13 技能 × 場地卡交互）
  □ 場地卡效果測試（8 張 × 邊界條件）
  □ 超時/斷線流程測試
  □ Security Rules 測試（防作弊）
  □ 端對端對戰流程測試
```
