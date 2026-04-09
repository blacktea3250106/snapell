# Snapell 戰鬥結算引擎 — MVP 需求規格書

> **MVP 原則：** 一人團隊，只做結算引擎 + 好友對戰。砍掉配對、排位、觀戰、回放。
>
> **引用：** 技能系統 → [`SKILL_SYSTEM_MVP.md`](./SKILL_SYSTEM_MVP.md)（13 種技能）｜場地卡 → [`FIELD_CARDS_MVP.md`](./FIELD_CARDS_MVP.md)（待寫）｜製卡 → [`CARD_CREATION_SYSTEM_SPEC_MVP.md`](./CARD_CREATION_SYSTEM_SPEC_MVP.md)

---

## MVP 範圍定義

### 保留（核心循環）

| 功能 | 理由 |
|------|------|
| 好友對戰（邀請碼建房） | 最簡配對，零後端配對邏輯 |
| 100HP 牌庫 10 張結算引擎 | 戰鬥本體 |
| 13 技能完整結算 | 技能是勝負差異來源 |
| 場地卡結算介面 | 場地卡 = 對戰策略性的支柱（見下方說明） |
| Firestore 即時同步 | 雙方同步看到翻卡、傷害、HP 變化 |
| Cloud Function 結算 | Server 權威，防作弊基礎 |
| 基礎防作弊 | move 鎖定 + server 結算 + 卡片歸屬驗證 |
| 4 種特殊事件 | 以下犯上、輾壓、險勝、大逆轉 |
| 超時 / 斷線處理 | 不能因為一方斷線就卡住 |
| 戰績更新 | 打完更新 wins/losses |

### 延後（v2+）

| 功能 | 延後原因 |
|------|---------|
| 🔀 隨機配對 / 排位 | 需要配對伺服器 + ELO，好友對戰先驗證核心 |
| 🏆 段位 / 賽季 | 排位前置功能 |
| 👁️ 觀戰 / 回放 | 額外資料結構 + 前端工作量大 |
| 💾 卡組預設管理 | 每次對戰前選 10 張即可，不需要存卡組 |
| 🎁 對戰獎勵 | 初期不需要獎勵驅動 |
| 📊 分享戰報 | 社交功能可後加 |

### 為什麼場地卡是 MVP 必要功能

```
沒有場地卡的對戰 = 5 局盲猜石頭剪刀布
  → 選卡無資訊依據
  → 中段情緒平坦
  → 策略深度為零

有場地卡的對戰 = 每回合都是一局有公牌的德州撲克
  → 場地卡先翻（公開資訊）→ 再選卡（秘密決策）→ 博弈產生
  → 每回合開頭翻場地卡 = 新的揭示瞬間 = 情緒節拍
  → 場地卡是對戰可玩性的支柱，不是可選功能
```

---

## 1. 系統概述

### 一句話

場地卡翻開 → 雙方根據場地選卡 → 同時翻牌結算。德州撲克的讀心 × 卡牌對戰的爽快。

### 設計哲學

```
對戰的樂趣不是「誰的數值大」，是：
  1. 看到場地卡，腦中瞬間閃過「這回合該出哪張」（決策快感）
  2. 翻牌瞬間看到對手出了什麼 — 猜對了 or 完全沒料到（博弈驚喜）
  3. 技能交鋒的戲劇性 — madness vs counter、hex vs shield（機制碰撞）
  4. 對手卡片的照片和咒語太好笑了（社交貨幣）

場地卡 = 德州撲克的公牌。你的手牌 = 底牌。牌庫 = 命運。
公牌一樣，底牌不同，抽牌運不同，決策不同 → 這就是博弈。
```

### 技術依賴

| 服務 | 用途 |
|------|------|
| Firestore | 對戰房間即時同步（Real-time Listener） |
| Cloud Functions 2nd gen | 結算引擎（asia-east1, 512MiB） |
| Firebase Auth | 玩家身份驗證 |

### 與其他系統的關係

```
CARD_CREATION_SYSTEM_SPEC_MVP.md
  → 產出 cards/{cardId} 含 battle.atk, battle.def, battle.skillMechanic, battle.skillParams
  → 本系統讀取這些欄位進行結算

SKILL_SYSTEM_MVP.md
  → 定義 13 種技能機制 + 結算順序 + skillParams 格式
  → 本系統的結算引擎依照其 Phase 1~4 順序執行

FIELD_CARDS_MVP.md（待寫）
  → 定義具體場地卡效果
  → 本系統預留 FieldCardEffect 介面供場地卡掛接
```

---

## 2. 基礎規則

### 核心數值

| 項目 | 數值 | 設計依據 |
|------|------|---------|
| 初始 HP | 100 | 直覺好算，平均每回合受傷 ~15 → 大多數對戰 6~8 回合自然結束 |
| 牌庫大小 | 10 | 對戰前從收藏中選 10 張組成牌庫 |
| 起手手牌 | 4 | 開局抽 4 張，第 1 回合抽 1 張湊滿 5 → 立刻建立「每回合都有新牌」的預期 |
| 手牌上限 | 5 | 選擇夠多但不爆炸 |
| 每回合抽牌 | 1 | 牌庫有牌且手牌 < 5 → 抽 1 張 |
| 理論最大回合 | 10 | 10 張牌全打完（實際多數 6~8 回合 HP 歸零結束） |
| 選卡時間 | 8 秒 | 友善節奏：看場地 2s + 思考 3s + 選卡 3s，允許 System 2 理性分析介入 |
| 每回合時間 | ~17 秒 | 一場 6~8 回合 ≈ 1.5~2.5 分鐘 |

### 回合流程

```
┌─ 抽牌階段（1 秒）─────────────────────────┐
│                                           │
│  從牌庫抽 1 張加入手牌                        │
│  （牌庫空 → 跳過；手牌已 5 張 → 跳過）         │
│  新抽到的卡短暫高亮                           │
│  顯示牌庫剩餘張數                             │
│                                           │
├─ 場地揭示（2 秒）─────────────────────────┤
│                                           │
│  📍 場地卡從天而降，翻轉展開                  │
│  全螢幕顯示場地效果文字                       │
│  雙方同時看到                               │
│                                           │
├─ 選卡階段（8 秒）─────────────────────────┤
│                                           │
│  畫面分割：上方場地效果，下方自己的手牌          │
│  點擊選擇一張卡（8 秒倒計時）                  │
│  超時 → 系統隨機選一張手牌中的卡               │
│  選完後看到「等待對手選擇...」                  │
│                                           │
├─ 同時翻卡（1.5 秒）───────────────────────┤
│                                           │
│  「3... 2... 1...」倒數                     │
│  雙方卡片同時翻開                             │
│  顯示：卡面、ATK、DEF、技能名稱               │
│                                           │
├─ 場地效果生效（1 秒）─────────────────────┤
│                                           │
│  場地卡效果文字閃爍                           │
│  受影響的數值出現變化動畫                       │
│                                           │
├─ 技能發動（1.5 秒）───────────────────────┤
│                                           │
│  雙方技能同時發動                             │
│  技能效果動畫播放                             │
│  數值變化即時更新                             │
│                                           │
├─ 傷害結算（2 秒）─────────────────────────┤
│                                           │
│  雙方同時造成傷害                             │
│  HP 條同步下降                               │
│  傷害數字飛出（紅色扣血）                      │
│  如果一方 HP 歸零 → 勝負已定                   │
│                                           │
├─ 回合結束（1 秒）─────────────────────────┤
│                                           │
│  用過的卡牌飛出畫面（進入棄牌堆）               │
│  顯示雙方剩餘 HP + 牌庫/手牌數量               │
│  如果還有牌可出 → 進入下一回合                  │
│  雙方手牌 + 牌庫皆空 → 戰鬥結束               │
│                                           │
└────────────────────────────────────────┘
```

### 勝負條件

```
1. 某方 HP ≤ 0 → 該方敗（即使雙方同時 ≤ 0，見邊界條件）
2. 雙方手牌 + 牌庫皆空（所有牌打完）→ HP 高的贏
3. HP 相同 → 總造成傷害高的贏
4. 總傷害也相同 → 平手（極罕見，雙方都不加分不扣分）
```

### 牌庫 / 手牌規則

```
牌庫：
  - 對戰前從收藏中選 10 張組成牌庫
  - 同一張卡不能重複放入牌庫
  - 對戰開始時系統 shuffle 牌庫（抽牌順序隨機，雙方各自隨機）
  - 牌庫內容對手不可見，但剩餘張數公開

手牌：
  - 開局抽 4 張起手手牌（牌庫剩 6）
  - 每回合開始從牌庫抽 1 張（牌庫空或手牌 ≥ 5 → 跳過抽牌）
  - 手牌上限 5 張
  - 手牌內容只有自己看得到

出牌：
  - 每回合從手牌中選 1 張出戰
  - 出過的卡進入棄牌堆（用過即棄，本場不能再用）
  - 超時 8 秒 → 系統隨機選手牌中一張

節奏推演：
  起手 4 張 → 第 1 回合抽到 5 → 出 1 回到 4
  → 第 2~6 回合：手牌恆定 4 張（抽 1 出 1）
  → 第 7 回合起：牌庫空，不抽只打，手牌 3→2→1→0
  → 最多 10 回合打完所有牌（但通常 6~8 回合 HP 先歸零）
```

### 稀有度數值在戰鬥中的體現

引用 `CARD_CREATION_SYSTEM_SPEC_MVP.md` Section 6.1：

| 稀有度 | ATK+DEF 總和範圍 | 中位數 | 技能倍率 |
|--------|-----------------|--------|---------|
| ⚪ 凡品 | 30~42 | 36 | ×0.55 |
| 🟢 精良 | 40~55 | 47.5 | ×0.70 |
| 🔵 稀有 | 53~70 | 61.5 | ×0.85 |
| 🟣 史詩 | 67~84 | 75.5 | ×1.00 |
| 🟡 傳說 | 81~96 | 88.5 | ×1.15 |
| 🔴 神話 | 93~100 | 96.5 | ×1.30 |

**設計意圖：** 高稀有度 = ATK+DEF 總和更高 + 技能效果更強。跨級碾壓是合理的。同級對決靠技能種類 + 場地卡互動 + 手牌管理決勝。10 張牌庫構築 = 長線策略，每回合出哪張 = 短線博弈。

---

## 3. 傷害公式

### 基礎傷害

```
damage = max(ATK - DEF, 1)
```

- **雙方同時造成傷害**，每回合兩人 HP 都在下降
- 最低 1 點保底 → 任何卡都能造成傷害
- 減法公式 → 玩家 1 秒內可心算

### 真實傷害 vs 普通傷害

| 類型 | 定義 | 來源 |
|------|------|------|
| 普通傷害 | `max(ATK - DEF, 1)`，受 shield 減免 | 正常攻擊 |
| 真實傷害 | 固定數值，無視 DEF 和 shield | spite 反傷、final_stand 反擊、場地卡特殊效果 |

### 各技能對傷害的修正概要

> 完整定義見 `SKILL_SYSTEM_MVP.md` Section 2-3

**Phase 1 — 修改 ATK/DEF（傷害公式輸入值改變）：**

| 技能 | 修正 |
|------|------|
| atk_boost | 自己 ATK +X% |
| def_boost | 自己 DEF +X% |
| hex | 對手 DEF -40% |
| momentum | 條件觸發：自己 ATK +25% |
| madness | 自己 ATK ×N，自己 DEF = 0 |

**Phase 2 — 修改傷害計算方式：**

| 技能 | 修正 |
|------|------|
| pierce | 傷害 = ATK - DEF×(1-X%) |
| double_strike | 第一擊正常 + 第二擊額外 |
| shield | 受到的傷害 ×(1-X%) |

**Phase 3 — HP 結算時的特殊觸發：**

| 技能 | 觸發 |
|------|------|
| rebirth | HP ≤ 0 → 復活（HP = 50） |
| final_stand | HP ≤ 0 → HP = 1 + 反擊真傷 |
| spite | 真正死亡 → 對手受真傷 |

**Phase 4 — 傷害結算後的額外效果：**

| 技能 | 效果 |
|------|------|
| counter | 反彈受到傷害的 X% |
| leech | 對手下回合 DEF -20% |

---

## 4. 回合結算流程（核心）

### RoundContext Interface

```typescript
interface RoundContext {
  round: number;                    // 當前回合（1~10）
  fieldCard: FieldCardEffect;       // 本回合場地卡
  playerA: PlayerRoundState;
  playerB: PlayerRoundState;
}

interface PlayerRoundState {
  playerId: string;
  card: {
    cardId: string;
    baseAtk: number;                // 卡片原始 ATK
    baseDef: number;                // 卡片原始 DEF
    skillMechanic: SkillMechanic;   // 技能機制 ID
    skillParams: Record<string, number | boolean>;
    rarity: Rarity;
  };
  currentHp: number;                // 當前 HP（進入本回合時）
  effectiveAtk: number;             // 計算用 ATK（會被技能修正）
  effectiveDef: number;             // 計算用 DEF（會被技能修正）
  damageDealt: number;              // 本回合造成的傷害
  damageReceived: number;           // 本回合受到的傷害
  wasDamagedLastRound: boolean;     // 上回合是否受傷（momentum 用）
  leechApplied: boolean;            // 是否被 leech 影響中
  leechOriginalDef: number;         // leech 前的原始 DEF
  fieldFlags: FieldFlags;           // 場地卡設定的結算 flags
}
```

### BattleState Interface（跨回合狀態）

```typescript
interface BattleState {
  battleId: string;
  playerA: PlayerBattleState;
  playerB: PlayerBattleState;
  currentRound: number;
  fieldCardSequence: string[];      // 預生成的場地卡 ID 序列（10 張）
  roundResults: RoundResult[];
  status: 'playing' | 'finished';
  winner: string | null;            // null = 平手
}

interface PlayerBattleState {
  playerId: string;
  hp: number;
  deckCardIds: string[];            // 牌庫（初始 10 張，shuffle 後的順序）
  handCardIds: string[];            // 手牌（上限 5 張）
  discardedCardIds: string[];       // 棄牌堆（用過即棄）
  totalDamageDealt: number;         // 累計造成傷害（平手判定用）

  // 跨回合技能狀態
  hasTriggeredFinalStand: boolean;  // final_stand 是否已觸發
  hasTriggeredRebirth: boolean;     // rebirth 是否已觸發
  wasDamagedLastRound: boolean;     // 上回合是否受傷（momentum 用）
  leechActive: boolean;             // 是否被 leech 影響
  leechSourceDef: number;           // leech 影響的原始 DEF 基礎值
}
```

### 完整 resolveRound() 虛擬碼

```typescript
function resolveRound(state: BattleState, moveA: MoveDocument, moveB: MoveDocument): RoundResult {
  const round = state.currentRound;
  let fieldCard = getFieldCard(state.fieldCardSequence[round - 1]);

  // === 特殊場地卡預處理（詳見 FIELD_CARDS_MVP.md Section 4）===
  if (fieldCard.id === 'dark_card') {
    const usedIds = state.roundResults.map(r => r.fieldCardId);
    const excludeIds = [...usedIds, 'dark_card', 'chaos'];
    const pool = ALL_FIELD_CARDS.filter(fc => !excludeIds.includes(fc.id));
    fieldCard = pool[Math.floor(Math.random() * pool.length)];
  }
  if (fieldCard.id === 'chaos') {
    const excludeIds = ['chaos', 'dark_card'];
    const pool = ALL_FIELD_CARDS.filter(fc => !excludeIds.includes(fc.id));
    fieldCard = pool[Math.floor(Math.random() * pool.length)];
  }

  // === 初始化回合狀態 ===
  const ctxA = initPlayerRoundState(state.playerA, moveA, state);
  const ctxB = initPlayerRoundState(state.playerB, moveB, state);

  // === Phase 0.5: 場地卡效果 ===
  // apply() 可修改 ATK/DEF/HP，並設定 fieldFlags（沉默、鏡像、狙擊等）
  fieldCard.apply(ctxA, ctxB, round);
  const silenced = ctxA.fieldFlags.silenceSkills === true;

  // === Phase 0.7: 鏡像處理（場地卡 flag）===
  if (ctxA.fieldFlags.swapSkills) {
    swapCardSkills(ctxA, ctxB);
  }

  // === Phase 1: 技能修正階段 ===
  // 沉默 = 全技能無效（Phase 1/2/3/4 全跳過技能部分）
  if (!silenced) {
    resolvePhase1_SkillModifiers(ctxA, ctxB);
  }

  // === Phase 2: 傷害計算 ===
  // 絕殺場地：完全覆蓋傷害計算
  if (ctxA.fieldFlags.overrideDamageCalc) {
    ctxA.fieldFlags.overrideDamageCalc(ctxA, ctxB);
  } else {
    // 沉默時：calcDamage 忽略 pierce/double_strike，applyShield 忽略 shield
    resolvePhase2_DamageCalc(ctxA, ctxB, silenced);
  }

  // === Phase 2.5: 場地卡傷害後效果（嗜血/荊棘）===
  if (fieldCard.onPostDamage) {
    fieldCard.onPostDamage(ctxA, ctxB, round);
  }

  // === Phase 3: HP 結算 ===
  // 沉默時：純扣血，跳過 final_stand/rebirth/spite 觸發
  resolvePhase3_HpSettlement(ctxA, ctxB, state, silenced);

  // === Phase 4: 後處理 ===
  // 沉默時：跳過 counter/leech
  if (!silenced) {
    resolvePhase4_PostProcess(ctxA, ctxB, state);
  }

  // === 更新跨回合狀態 ===
  updateBattleState(state, ctxA, ctxB);

  // === 檢測特殊事件 ===
  const events = detectEvents(ctxA, ctxB, state);

  // === 出牌後處理 ===
  // 將出過的卡從手牌移至棄牌堆（在 updateBattleState 中處理）

  // === 判定勝負 ===
  // 1. HP ≤ 0 → 該方敗
  // 2. 雙方手牌 + 牌庫皆空 → HP 高的贏
  const roundWinner = checkBattleEnd(state);

  // === 如果戰鬥繼續：為下回合抽牌 ===
  if (!roundWinner) {
    drawCard(state.playerA); // 牌庫有牌且手牌 < 5 → 抽 1 張
    drawCard(state.playerB);
  }

  return buildRoundResult(round, fieldCard, ctxA, ctxB, events, roundWinner);
}
```

### Phase 1: 技能修正

```typescript
function resolvePhase1_SkillModifiers(a: PlayerRoundState, b: PlayerRoundState): void {
  // 0. 場地卡：暴走（技能數值倍率）
  const multiplier = a.fieldFlags.skillParamsMultiplier ?? 1;
  if (multiplier !== 1) {
    scaleSkillParams(a, multiplier);
    scaleSkillParams(b, multiplier);
  }

  // 1. momentum 檢查（上回合受傷 → ATK +25%）
  applyMomentum(a);
  applyMomentum(b);

  // 2. leech 效果（上回合被 leech → 本回合 DEF -20%，以原始 DEF 為基礎）
  applyLeechDebuff(a);
  applyLeechDebuff(b);

  // 3. hex 結算（對手 DEF -40%）
  applyHex(a, b);  // 如果 a 有 hex → 修改 b.effectiveDef
  applyHex(b, a);

  // 4. atk_boost / def_boost 結算
  applyAtkBoost(a);
  applyAtkBoost(b);
  applyDefBoost(a);
  applyDefBoost(b);

  // 5. madness 結算（ATK ×N, DEF=0）— 最後執行，覆蓋前面的 DEF 修正
  applyMadness(a);
  applyMadness(b);
}
```

**Phase 1 順序設計依據：**
```
momentum 最先：條件判定用上回合狀態，不受本回合修正影響
leech debuff：在其他修正之前生效，以原始 DEF 為基礎計算
hex 在 boost 之前：hex 削的是對手 DEF，先削再加 = 加成基數變小
madness 最後：DEF=0 覆蓋所有前面的 DEF 修正
```

### Phase 2: 傷害計算

```typescript
function resolvePhase2_DamageCalc(a: PlayerRoundState, b: PlayerRoundState): void {
  // 計算 A 對 B 的傷害
  a.damageDealt = calcDamage(a, b);
  // 計算 B 對 A 的傷害
  b.damageDealt = calcDamage(b, a);

  // 場地卡傷害倍率（閃電戰 = ×2）
  const multiplier = a.fieldFlags.damageMultiplier ?? 1;
  if (multiplier !== 1) {
    a.damageDealt = Math.round(a.damageDealt * multiplier);
    b.damageDealt = Math.round(b.damageDealt * multiplier);
  }

  // shield 減免（受方視角）
  a.damageReceived = applyShield(b.damageDealt, a);
  b.damageReceived = applyShield(a.damageDealt, b);
}

function calcDamage(attacker: PlayerRoundState, defender: PlayerRoundState): number {
  const skill = attacker.card.skillMechanic;

  // 場地卡：狙擊戰（無視 DEF）
  if (attacker.fieldFlags.ignoreDef) {
    return attacker.effectiveAtk; // DEF 無效，ATK 直接就是傷害
  }

  if (skill === 'pierce') {
    // 穿透：削減對手 DEF 有效值
    const pierceRatio = attacker.card.skillParams.pierceRatio;
    const effectiveDef = defender.effectiveDef * (1 - pierceRatio);
    const firstHit = Math.max(attacker.effectiveAtk - Math.round(effectiveDef), 1);
    return firstHit;
  }

  if (skill === 'double_strike') {
    // 二連擊：第一擊正常，第二擊 = 第一擊傷害 × X%
    const firstHit = Math.max(attacker.effectiveAtk - defender.effectiveDef, 1);
    const secondHit = Math.round(firstHit * attacker.card.skillParams.secondHitRatio);
    return firstHit + secondHit;
  }

  // 正常傷害
  return Math.max(attacker.effectiveAtk - defender.effectiveDef, 1);
}

function applyShield(incomingDamage: number, defender: PlayerRoundState): number {
  if (defender.card.skillMechanic === 'shield') {
    const reduction = defender.card.skillParams.damageReductionRatio;
    return Math.round(incomingDamage * (1 - reduction));
  }
  return incomingDamage;
}
```

### Phase 3: HP 結算

```typescript
function resolvePhase3_HpSettlement(
  a: PlayerRoundState,
  b: PlayerRoundState,
  state: BattleState
): void {
  // 扣減 HP
  a.currentHp -= a.damageReceived;
  b.currentHp -= b.damageReceived;

  // rebirth 檢查（🔴 專屬）
  if (a.currentHp <= 0 && a.card.skillMechanic === 'rebirth'
      && !state.playerA.hasTriggeredRebirth) {
    a.currentHp = Math.round(100 * a.card.skillParams.reviveRatio); // HP = 50
    state.playerA.hasTriggeredRebirth = true;
  }
  if (b.currentHp <= 0 && b.card.skillMechanic === 'rebirth'
      && !state.playerB.hasTriggeredRebirth) {
    b.currentHp = Math.round(100 * b.card.skillParams.reviveRatio);
    state.playerB.hasTriggeredRebirth = true;
  }

  // final_stand 檢查（🟡 專屬）
  if (a.currentHp <= 0 && a.card.skillMechanic === 'final_stand'
      && !state.playerA.hasTriggeredFinalStand) {
    a.currentHp = 1;
    const counterDmg = Math.round(a.effectiveAtk * a.card.skillParams.counterRatio);
    b.currentHp -= counterDmg; // 真實傷害，直接扣
    state.playerA.hasTriggeredFinalStand = true;
  }
  if (b.currentHp <= 0 && b.card.skillMechanic === 'final_stand'
      && !state.playerB.hasTriggeredFinalStand) {
    b.currentHp = 1;
    const counterDmg = Math.round(b.effectiveAtk * b.card.skillParams.counterRatio);
    a.currentHp -= counterDmg;
    state.playerB.hasTriggeredFinalStand = true;
  }

  // spite 檢查（⚪ 專屬）— 只在「真正死亡」時觸發
  if (a.currentHp <= 0 && a.card.skillMechanic === 'spite') {
    const hpLost = 100 - a.currentHp; // 已損失的 HP（含本回合）
    const spiteDmg = Math.round(hpLost * a.card.skillParams.damageRatio);
    b.currentHp -= spiteDmg; // 真實傷害
  }
  if (b.currentHp <= 0 && b.card.skillMechanic === 'spite') {
    const hpLost = 100 - b.currentHp;
    const spiteDmg = Math.round(hpLost * b.card.skillParams.damageRatio);
    a.currentHp -= spiteDmg;
  }
}
```

### Phase 4: 後處理

```typescript
function resolvePhase4_PostProcess(
  a: PlayerRoundState,
  b: PlayerRoundState,
  state: BattleState
): void {
  // counter 反彈
  if (a.card.skillMechanic === 'counter' && a.damageReceived > 0) {
    const counterDmg = Math.round(a.damageReceived * a.card.skillParams.counterRatio);
    b.currentHp -= counterDmg;
  }
  if (b.card.skillMechanic === 'counter' && b.damageReceived > 0) {
    const counterDmg = Math.round(b.damageReceived * b.card.skillParams.counterRatio);
    a.currentHp -= counterDmg;
  }

  // leech 設定（對手下回合 DEF -X%）
  if (a.card.skillMechanic === 'leech' && a.damageDealt > 0) {
    state.playerB.leechActive = true;
    state.playerB.leechSourceDef = b.card.baseDef; // 以原始 DEF 為基礎
  }
  if (b.card.skillMechanic === 'leech' && b.damageDealt > 0) {
    state.playerA.leechActive = true;
    state.playerA.leechSourceDef = a.card.baseDef;
  }
}
```

### RoundResult Interface

```typescript
interface RoundResult {
  round: number;
  fieldCardId: string;              // 原始抽到的場地卡
  actualFieldCardId: string;        // 實際生效的場地卡（暗牌/混沌替換後，通常同 fieldCardId）
  playerA: {
    cardId: string;
    effectiveAtk: number;       // 技能修正後的 ATK
    effectiveDef: number;       // 技能修正後的 DEF
    damageDealt: number;
    damageReceived: number;
    hpBefore: number;
    hpAfter: number;
    skillTriggered: string[];   // 本回合觸發的技能效果
  };
  playerB: {
    // 同上
  };
  events: BattleEvent[];        // 特殊事件
  roundWinner: string | null;   // 本回合擊殺判定（null = 雙方都活著）
}
```

---

## 5. 技能結算引擎

### 結算順序總覽

引用 `SKILL_SYSTEM_MVP.md` Section 4，MVP 簡化為 Phase 1~4：

```
Phase 0.5: 場地卡效果生效
  → 場地卡修改 ATK/DEF/規則

Phase 1: 技能修正階段
  → momentum 檢查（上回合受傷 → ATK +25%）
  → leech debuff（上回合被 leech → DEF -20%）
  → hex 結算（對手 DEF -40%）
  → atk_boost, def_boost 結算
  → madness 結算（ATK ×N, DEF=0）

Phase 2: 傷害計算
  → 正常: damage = ATK - DEF (min 1)
  → pierce: damage = ATK - DEF×(1-X%)
  → double_strike: 第一擊正常 + 第二擊 = 第一擊傷害×X%
  → shield: damage × (1 - X%)

Phase 3: HP 結算
  → 扣減 HP
  → rebirth 檢查（HP ≤ 0 → 復活 50 HP）
  → final_stand 檢查（HP ≤ 0 → HP=1 + 反擊真傷）
  → spite 檢查（真正死亡 → 對手受真傷）

Phase 4: 後處理
  → counter 反彈
  → leech 設定（對手下回合 DEF -X%）
  → 更新跨回合狀態（wasDamagedLastRound 等）
```

### 跨回合狀態管理

只有三種跨回合效果需要追蹤：

| 效果 | 追蹤方式 | 持續時間 |
|------|---------|---------|
| momentum | `wasDamagedLastRound: boolean` | 每回合更新 |
| leech | `leechActive: boolean` + `leechSourceDef: number` | 下一回合結束 |
| final_stand / rebirth | `hasTriggered: boolean` | 整場對戰 |

### leech 跨回合結算細節

```typescript
function applyLeechDebuff(player: PlayerRoundState): void {
  if (player.leechApplied) {
    // 以原始 DEF 為基礎計算削弱量（不可疊加）
    const reduction = Math.round(player.leechOriginalDef * 0.20);
    player.effectiveDef = Math.max(player.effectiveDef - reduction, 0);
  }
}
```

**關鍵規則：** leech 每回合重新計算，以對手原始 DEF 為基礎。不可疊加。效果只持續一回合。

---

## 6. 場地卡介面

### FieldCardEffect Interface

```typescript
interface FieldCardEffect {
  id: string;
  name: string;
  description: string;
  category: 'victory' | 'skill' | 'play' | 'resource';

  // ─── Phase 0.5：場地卡主效果 ───
  // 修改 ATK/DEF/HP/skillParams，設定場地 flags
  apply(
    playerA: PlayerRoundState,
    playerB: PlayerRoundState,
    round: number
  ): void;

  // ─── Phase 2.5：傷害後效果（可選）───
  // 嗜血（吸血）、荊棘（反彈）等需要在傷害計算後觸發
  onPostDamage?(
    playerA: PlayerRoundState,
    playerB: PlayerRoundState,
    round: number
  ): void;

  // MVP：無 clientHints（盲選/偵察/暗牌已延後至 v2）
  // 所有 8 張場地卡都走標準結算流程，無特殊客戶端行為
}

// ─── 場地 Flags：場地卡在 apply() 中設定，結算引擎讀取 ───
interface FieldFlags {
  silenceSkills?: boolean;          // 沉默：全技能無效（Phase 1/2/3/4 技能相關邏輯全跳過）
  ignoreDef?: boolean;              // 狙擊戰：Phase 2 無視 DEF
  damageMultiplier?: number;        // 閃電戰：傷害倍率（預設 1）
  // MVP 已移除：skillParamsMultiplier（暴走）、swapSkills（鏡像）、overrideDamageCalc（絕殺）
}
```

### 結算時機

```
Phase 0.5  = 場地卡 apply()：修改 ATK/DEF/HP，設定 fieldFlags
Phase 1    = 技能修正：若 silenceSkills 為 true，跳過此階段
Phase 2    = 傷害計算：ignoreDef/damageMultiplier 在此生效
Phase 2.5  = 場地卡 onPostDamage()：嗜血吸血、荊棘反彈
Phase 3    = HP 結算
Phase 4    = 後處理

→ 場地卡修改的數值會被技能進一步修正
→ 例：鐵壁 DEF +15 → 然後 madness 把 DEF 強制為 0（madness 覆蓋鐵壁）
```

### 場地卡序列生成

```typescript
function generateFieldCardSequence(): string[] {
  const allFieldCards = getFieldCardPool(); // 8 張場地卡 ID
  const shuffled = shuffle(allFieldCards);
  return shuffled.slice(0, 6); // 抽 6 張（覆蓋大多數對戰）
}
```

- 每場對戰開始時由 Server 生成 **6 張**場地卡序列（從 8 張池中抽取）
- 場地卡不重複（8 選 6）
- 每回合揭示 1 張，雙方同時看到
- 場地卡效果只持續該回合
- 如果對戰提前結束（HP 歸零），剩餘場地卡不揭示
- 如果對戰打超過 6 回合，第 7 回合起無場地效果（極罕見情況）

### 場地卡加密存儲

```javascript
// battles/{battleId} 中
{
  fieldCardSequence: ["encrypted_hash_1", ...], // 加密存儲
  revealedFieldCards: [                          // 已揭示的場地卡（明文）
    // 詳見 FIELD_CARDS_MVP.md Section 5
    {
      round: 1,
      fieldCardId: "lightning_blitz",
      name: "閃電戰",
      description: "本回合傷害翻倍",
    },
  ],
}
```

每回合開始時，Server 將當前回合的場地卡從加密序列中取出，寫入 `revealedFieldCards`。客戶端只能看到已揭示的場地卡，無法提前知道未來回合的場地。

### 場地卡具體效果

> 8 張場地卡的具體效果定義見 `FIELD_CARDS_MVP.md`。
> 本文件只定義介面和結算時機，確保結算引擎能正確掛接任何場地卡效果。

**MVP 8 張場地卡 → 介面覆蓋對照表：**

| # | 場地卡 | 效果 | 介面掛接點 |
|---|--------|------|-----------|
| ① | ⚡ 閃電戰 | 傷害翻倍 | `fieldFlags.damageMultiplier = 2` |
| ② | 🎯 狙擊戰 | 無視 DEF | `fieldFlags.ignoreDef = true` |
| ③ | 🔄 逆轉 | ATK/DEF 互換 | `apply()` → swap `effectiveAtk/Def` |
| ④ | 🔇 沉默 | 技能無效 | `fieldFlags.silenceSkills = true` |
| ⑤ | 🛡️ 鐵壁 | DEF +15 | `apply()` → 修改 `effectiveDef` |
| ⑥ | 💊 生命之泉 | 回復 15 HP | `apply()` → 修改 `currentHp` |
| ⑦ | 🩸 嗜血 | 傷害 → HP | `onPostDamage()` → 吸血 |
| ⑧ | ☠️ 荊棘 | 反彈 50% 傷害 | `onPostDamage()` → 反彈 |

---

## 7. Firestore 資料結構

### battles/{battleId}

```javascript
{
  // === 基礎 ===
  battleId: "auto-generated-uuid",
  status: "playing",              // waiting | selecting_deck | playing | finished
  mode: "friend",                 // MVP 只有 friend
  createdAt: Timestamp,
  updatedAt: Timestamp,

  // === 玩家 ===
  hostId: "userA",                // 房主
  guestId: "userB",               // 加入者
  players: {
    "userA": {
      hp: 100,
      deckCardIds: [],            // 牌庫（shuffle 後的順序，初始 10 張，逐漸減少）
      handCardIds: [],            // 手牌（上限 5 張）
      discardedCardIds: [],       // 棄牌堆（用過即棄）
      totalDamageDealt: 0,        // 累計傷害

      // 跨回合技能狀態
      hasTriggeredFinalStand: false,
      hasTriggeredRebirth: false,
      wasDamagedLastRound: false,
      leechActive: false,
      leechSourceDef: 0,
    },
    "userB": { /* 同上 */ },
  },

  // === 場地卡 ===
  fieldCardSequence: ["encrypted_1", "encrypted_2", ...],  // 加密，客戶端不可讀（10 張）
  revealedFieldCards: [],                                    // 已揭示，客戶端可讀

  // === 戰鬥進度 ===
  currentRound: 0,                // 0 = 尚未開始，1~10 = 進行中
  rounds: {},                     // RoundResult 集合（見下方）

  // === 結果 ===
  winner: null,                   // 勝方 userId | "draw" | null
  finishedAt: null,

  // === 邀請碼 ===
  inviteCode: "A3X7K9",
}
```

### battles/{battleId}/moves/{round}

```javascript
// 每回合每個玩家提交一個 move
{
  round: 1,
  playerId: "userA",
  cardId: "card-uuid-123",       // 本回合出的卡
  submittedAt: Timestamp,
}
```

**設計重點：** 使用 subcollection 存 move，Security Rules 可以確保：
- 每人每回合只能提交一次
- 提交後不能修改
- 不能看到對手的 move（直到結算完成）

### inviteCodes/{code}

```javascript
{
  code: "A3X7K9",
  battleId: "battle-uuid",
  hostId: "userA",
  createdAt: Timestamp,
  expiresAt: Timestamp,           // createdAt + 10 分鐘
  used: false,
}
```

### Security Rules 要點

```javascript
match /battles/{battleId} {
  // 只有參戰玩家可讀
  allow read: if request.auth.uid in resource.data.players;

  // 不允許客戶端直接寫入 battles 文件（只有 Cloud Function 可以）
  allow write: if false;
}

match /battles/{battleId}/moves/{moveId} {
  // 只能寫入自己的 move
  allow create: if request.auth.uid == request.resource.data.playerId
    && !exists(/databases/$(database)/documents/battles/$(battleId)/moves/$(moveId));

  // 寫入後不能修改或刪除
  allow update, delete: if false;
}
```

---

## 8. Cloud Function 端點

### 配置

```
Region: asia-east1
Memory: 512MiB
minInstances: 1（避免冷啟動）
Timeout: 60s
```

### createBattleRoom（HTTPS Callable）

```typescript
// 輸入
interface CreateBattleRoomRequest {
  // 無需參數，從 auth context 取 userId
}

// 輸出
interface CreateBattleRoomResponse {
  battleId: string;
  inviteCode: string;             // 6 位英數字，10 分鐘有效
}

// 流程
1. 驗證身份
2. 生成 6 位邀請碼（大寫英文 + 數字，排除易混淆字元 0O1I）
3. 生成場地卡序列（10 張，加密存儲）
4. 建立 battles/{battleId}（status = waiting）
5. 建立 inviteCodes/{code}
6. 回傳 battleId + inviteCode
```

### joinBattleRoom（HTTPS Callable）

```typescript
// 輸入
interface JoinBattleRoomRequest {
  inviteCode: string;
}

// 輸出
interface JoinBattleRoomResponse {
  battleId: string;
}

// 流程
1. 驗證身份
2. 查詢 inviteCodes/{code}
3. 檢查：未過期、未使用、不是自己的房間
4. 原子操作：
   a. 更新 battles/{battleId}（guestId = userId, status = selecting_deck）
   b. 標記 inviteCodes/{code}.used = true
5. 回傳 battleId
```

### submitDeck（HTTPS Callable）

```typescript
// 輸入
interface SubmitDeckRequest {
  battleId: string;
  cardIds: string[];              // 10 張卡 ID
}

// 流程
1. 驗證身份 + 是該場對戰的玩家
2. 驗證 10 張卡都屬於該玩家（防作弊）
3. 驗證無重複卡
4. Server 端 shuffle cardIds → 寫入 deckCardIds（牌庫順序由 Server 決定）
5. 從 deckCardIds 前 4 張移入 handCardIds（起手 4 張）
6. deckCardIds 剩餘 6 張
7. 如果雙方都已提交 → status = playing, currentRound = 1
   → 揭示第 1 張場地卡（寫入 revealedFieldCards）
```

### submitMove（HTTPS Callable + 觸發結算）

```typescript
// 輸入
interface SubmitMoveRequest {
  battleId: string;
  cardId: string;                 // 本回合出的卡 ID（必須在手牌中）
}

// 流程
1. 驗證身份 + 是該場對戰的玩家
2. 驗證 cardId 在玩家手牌（handCardIds）中
3. 寫入 battles/{battleId}/moves/{round}_{userId}
4. 檢查對手是否也已提交本回合 move
5. 如果雙方都已提交 → 觸發結算：
   a. 讀取雙方卡片資料（從 cards/{cardId}）
   b. 讀取本回合場地卡
   c. 執行 resolveRound()
   d. 將出過的卡從 handCardIds 移至 discardedCardIds
   e. 原子寫入結果到 battles/{battleId}
   f. 如果戰鬥未結束：
      - currentRound++
      - 為雙方執行抽牌：若牌庫有牌且手牌 < 5 → deckCardIds.shift() 移入 handCardIds
      - 揭示下一張場地卡
      - 檢查結束條件：若雙方手牌 + 牌庫皆空 → 按 HP 判定勝負
   g. 如果戰鬥結束 → status = finished → 更新雙方卡片戰績
```

**為什麼 submitMove 內部直接觸發結算：**
```
替代方案：Firestore trigger 監聽 moves 寫入
問題：trigger 可能延遲、可能重複觸發、可能失序
直接在 submitMove 中檢查 + 結算 = 最可靠、最簡單
```

---

## 9. 好友對戰流程

### 完整時序

```
Host                    Server                    Guest
  │                        │                        │
  │── createBattleRoom ──→ │                        │
  │←── inviteCode ────────│                        │
  │                        │                        │
  │   （把邀請碼給朋友）                               │
  │                        │                        │
  │                        │←── joinBattleRoom ────│
  │←── guest joined ──────│──→ battle joined ──────│
  │                        │                        │
  │   status = selecting_deck                       │
  │                        │                        │
  │── submitDeck(10卡) ──→ │                        │
  │                        │←── submitDeck(10卡) ──│
  │                        │                        │
  │   Server shuffle 牌庫 → 抽 4 張起手手牌           │
  │   雙方都選好 → status = playing                   │
  │←── 起手手牌 + round 1 ─│──→ 起手手牌 + round 1 ─│
  │                        │                        │
  │   ┌── 回合循環（最多 10 回合）──┐                 │
  │   │                          │                  │
  │   │   抽牌階段（牌庫→手牌）                        │
  │   │   場地卡揭示                                  │
  │   │── submitMove(cardId) ──→ │                  │
  │   │                          │←── submitMove ──│
  │   │                          │                  │
  │   │   雙方都出牌 → resolveRound()               │
  │   │   出過的卡 → 棄牌堆                           │
  │   │←── roundResult ─────────│──→ roundResult ──│
  │   │                          │                  │
  │   │   結束條件檢查：                               │
  │   │   1. HP ≤ 0 → 戰鬥結束                       │
  │   │   2. 雙方手牌+牌庫皆空 → HP 判定              │
  │   │   否則 → 抽牌 + 揭示下一張場地卡 → 下一回合    │
  │   └──────────────────────────┘                  │
  │                        │                        │
  │←── battle finished ───│──→ battle finished ───│
  │                        │                        │
```

### 邀請碼設計

```
格式：6 位大寫英數字
字元集：ABCDEFGHJKLMNPQRSTUVWXYZ23456789（排除 0O1I 避免混淆）
有效期：10 分鐘
唯一性：用 inviteCodes collection 確保唯一
```

### 牌庫選擇流程

```
1. 雙方加入房間後 → status = selecting_deck
2. 各自從收藏中選 10 張卡組成牌庫
3. 超時 90 秒 → 系統隨機選 10 張
4. Server shuffle 各自牌庫 → 抽前 4 張為起手手牌
5. 雙方都選好 → status = playing
6. 揭示第 1 張場地卡 → 第 1 回合開始（回合開始先抽 1 張到手牌 5）
```

---

## 10. 防作弊

### 核心原則

```
客戶端只提交 cardId → Server 做所有結算 → 客戶端只播放動畫
```

### 具體措施

| 措施 | 實現方式 |
|------|---------|
| move 鎖定 | Security Rules：每人每回合只能寫入一次，寫入後不可修改刪除 |
| Server 結算 | Cloud Function 執行 resolveRound()，客戶端無法篡改結果 |
| 場地卡加密 | fieldCardSequence 加密存儲，每回合逐一揭示到 revealedFieldCards |
| 卡片歸屬驗證 | submitDeck 和 submitMove 都驗證卡片屬於該玩家 |
| 對手 move 不可見 | moves subcollection 的 Security Rules 限制讀取 |

### 心跳機制（MVP 簡化版）

```
客戶端每 5 秒向 battles/{battleId}/heartbeat/{userId} 寫入 timestamp
Server 檢查：
  > 15 秒未更新 → 標記為「可能斷線」
  > 30 秒未更新 → 判定為斷線（見 Section 13 邊界條件）
```

---

## 11. 同步機制

### Firestore Real-time Listener 架構

```
客戶端監聽：
  1. battles/{battleId}        → 整場對戰狀態
  2. battles/{battleId}/moves  → 檢測雙方出牌狀態

狀態變化 → onSnapshot 觸發 → 播放對應動畫
```

### Riverpod StreamProvider 模式

```dart
// 對戰狀態 Provider
final battleProvider = StreamProvider.autoDispose.family<BattleDocument, String>(
  (ref, battleId) {
    return FirebaseFirestore.instance
        .collection('battles')
        .doc(battleId)
        .snapshots()
        .map((snapshot) => BattleDocument.fromFirestore(snapshot));
  },
);
```

### 延遲處理分級

| 延遲 | 處理 |
|------|------|
| < 500ms | 正常（不感知） |
| 500ms ~ 2s | 「等待對手...」遮罩 |
| 2s ~ 5s | 顯示載入動畫 |
| 5s ~ 15s | 顯示「對手可能斷線」提示 |
| > 15s | 顯示「對手已斷線」+ 等待 / 離開選項 |

### 狀態機

```
waiting → selecting_deck → playing → finished
   │                          │
   └── 10分鐘超時 → 自動銷毀    └── 某方斷線 30s → finished（斷線方敗）
```

---

## 12. 特殊事件系統（MVP 簡化）

### 4 種事件

| 事件 | ID | 觸發條件 |
|------|----|---------|
| 以下犯上 | `upset` | 低稀有度卡打出比高稀有度卡更高傷害 |
| 輾壓 | `domination` | 單回合造成 ≥ 40 傷害 |
| 險勝 | `close_call` | 勝方最終 HP ≤ 10 |
| 大逆轉 | `comeback` | HP 曾落後 30+ 卻最終獲勝 |

### detectEvents()

```typescript
function detectEvents(a: PlayerRoundState, b: PlayerRoundState, state: BattleState): BattleEvent[] {
  const events: BattleEvent[] = [];

  // 以下犯上：稀有度低的一方造成更高傷害
  if (rarityRank(a.card.rarity) < rarityRank(b.card.rarity) && a.damageDealt > b.damageDealt) {
    events.push({ type: 'upset', playerId: a.playerId, round: state.currentRound });
  }
  if (rarityRank(b.card.rarity) < rarityRank(a.card.rarity) && b.damageDealt > a.damageDealt) {
    events.push({ type: 'upset', playerId: b.playerId, round: state.currentRound });
  }

  // 輾壓：單回合 ≥ 40 傷害
  if (a.damageDealt >= 40) {
    events.push({ type: 'domination', playerId: a.playerId, round: state.currentRound });
  }
  if (b.damageDealt >= 40) {
    events.push({ type: 'domination', playerId: b.playerId, round: state.currentRound });
  }

  // 險勝、大逆轉在戰鬥結束時檢測（不在每回合）
  return events;
}
```

---

## 13. 邊界條件

### 超時處理

| 場景 | 超時 | 處理 |
|------|------|------|
| 選卡超時 | 8 秒 | 系統隨機選手牌中一張 |
| 選牌庫超時 | 90 秒 | 系統隨機選 10 張 |
| AFK | 連續 3 次選卡超時 | 判負 |

### 斷線處理

| 階段 | 時間 | 處理 |
|------|------|------|
| 心跳停止 | 0~15 秒 | 等待（可能是短暫網路波動） |
| 標記斷線 | 15 秒 | 對手看到「對手可能斷線」 |
| 判負 | 30 秒 | 斷線方判負，對戰結束 |
| 重連 | 30 秒內 | 讀取 battles/{battleId} 恢復狀態，繼續對戰 |

### 同時死亡

```
雙方 HP 同時 ≤ 0：
  1. 比較剩餘 HP（HP 較高者勝，即使都是負數）
  2. HP 相同 → 比較本回合造成的傷害（高者勝）
  3. 傷害也相同 → 平手
```

### 技能邊界規則

引用 `SKILL_SYSTEM_MVP.md` Section 4 底部：

| 場景 | 處理 |
|------|------|
| final_stand / rebirth 觸發 → spite 不觸發 | 不同稀有度不會同時出現，但邏輯要正確 |
| hex + 對手 madness（DEF=0） | hex 無效果 → 自然處理 |
| leech + 對手下回合 madness | leech 先削 DEF → madness 覆蓋 DEF=0 → leech 實質無效 |
| counter + shield | shield 先減傷 → counter 反彈的是減傷後的傷害 |
| 所有 13 種 MVP 技能 | 線性結算，無需特殊互動處理 |

### 房間清理

| 狀態 | 超時 | 處理 |
|------|------|------|
| waiting | 10 分鐘無人加入 | 刪除房間 + 邀請碼 |
| selecting_deck | 3 分鐘無人選卡 | 刪除房間 |
| playing | 10 分鐘異常（心跳停止） | 強制結束，無勝負 |

---

## 附錄 A：技能系統

MVP 技能規格（13 種機制）見：

> **[SKILL_SYSTEM_MVP.md](./SKILL_SYSTEM_MVP.md)**（MVP 版，13 種技能）
> **[SKILL_SYSTEM.md](./SKILL_SYSTEM.md)**（完整版，30 種技能，v2 目標）

---

## 附錄 B：場地卡系統

場地卡規格（15 張）見：

> **[FIELD_CARDS_MVP.md](./FIELD_CARDS_MVP.md)**（待寫）

本文件已預留 `FieldCardEffect` 介面（Section 6），支持所有 BATTLE_SYSTEM.md 中定義的場地卡效果類型。

---

## 附錄 C：MVP → 完整版升級路線

| 階段 | 新增功能 | 涉及改動 |
|------|---------|---------|
| v1.1 | 完整 30 技能 | 引擎加入 Phase -1（apocalypse）、Phase 0（domain）、Phase 5（overkill）、Phase 6（paradox） |
| v1.1 | mirror / eclipse 等複雜技能 | 12 種邊界互動處理 |
| v1.1 | doppelganger 雙技能 | cards 加 secondSkill* 欄位，結算引擎支援雙技能 |
| v1.2 | 隨機配對 | 配對伺服器 + 等待佇列 |
| v1.2 | 排位 / 段位 | users 加 rank/elo，每場更新 |
| v1.3 | 賽季系統 | 賽季 meta 修正（場地卡權重、技能加成） |
| v1.4 | 觀戰 | battles 加 spectators，即時推送 |
| v1.5 | 回放 | 儲存完整 moves 序列 + 回放引擎 |
| v2.0 | 牌庫預設管理 | decks/{userId} collection |
| v2.0 | 對戰獎勵 | 勝利獎勵 + 連勝加成 |
| v2.0 | 分享戰報 | 自動截圖 + 深連結 |
