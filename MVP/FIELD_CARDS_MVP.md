# Snapell 場地卡系統 — MVP 需求規格書

> **MVP 原則：** 一人團隊，8 張場地卡（從 15 張精選）。每張都真正改變博弈邏輯，零花瓶卡。
>
> **引用：** 戰鬥引擎 → [`BATTLE_SYSTEM_MVP.md`](./BATTLE_SYSTEM_MVP.md)（FieldCardEffect 介面）｜技能 → [`SKILL_SYSTEM_MVP.md`](./SKILL_SYSTEM_MVP.md)（13 種技能）｜製卡 → [`CARD_CREATION_SYSTEM_SPEC_MVP.md`](./CARD_CREATION_SYSTEM_SPEC_MVP.md)

---

## 為什麼場地卡是 MVP 核心

```
沒有場地卡 → 每回合盲猜石頭剪刀布 → 策略深度 = 0
有了場地卡 → 每回合都是有公牌的德州撲克 → 博弈產生

場地卡 = 公開資訊（公牌）
手牌   = 秘密資訊（底牌）
公牌一樣，底牌不同，決策不同 → 這就是博弈
```

---

## 1. 設計理念

### 一句話

**場地卡改變每回合的「最優策略」，迫使玩家在 8 秒內根據公開資訊做出差異化選擇。**

### 設計原則

| 原則 | 說明 |
|------|------|
| 改變博弈邏輯 | 每張場地卡改變的是「怎麼選才對」，不只是「數字變大/小」 |
| 沒有最優解 | 最佳選擇取決於你猜對手怎麼選，不存在固定正解 |
| 一句話說清楚 | 每張場地卡的效果都能在 3 秒內理解 |
| 每場不同 | 8 抽 6 → C(8,6) = 28 種場地組合 × 排列順序 → 每場不同策略生態 |

### 四大類別

| 類別 | 數量 | 改變什麼 | 代表 |
|------|------|---------|------|
| 🏆 勝負邏輯類（victory） | 3 張 | 怎樣算贏 | 閃電戰、狙擊戰、逆轉 |
| ✨ 技能規則類（skill） | 1 張 | 技能互動 | 沉默領域 |
| 💎 資源規則類（resource） | 3 張 | HP/傷害相關 | 生命之泉、嗜血、荊棘 |
| 🛡️ 防禦邏輯類（defense） | 1 張 | DEF 數值 | 鐵壁 |

### MVP 精選原則

從完整版 15 張中精選 8 張，篩選標準：

| 條件 | 說明 |
|------|------|
| 真正改變結算邏輯 | 不是只改 UI/時間的花瓶卡 |
| 實作簡單 | 一人團隊寫得完、測得完 |
| 無崩壞風險 | 不需要特殊 cap 邏輯或多層邊界處理 |
| 效果秒懂 | 新手第一次看到就知道該怎麼反應 |

### 砍掉的 7 張 + 原因 + 回歸版本

| 砍掉 | 原因 | 回歸 |
|------|------|------|
| 💀 絕殺 | `overrideDamageCalc` 獨立結算路徑，shield/counter 無效等特例多，實作成本高 | v2 |
| 🔮 暴走 | madness ×3.6 一擊必殺 + counter 反彈 77%，需要多個技能 cap → 複雜度爆炸 | v2（含 cap 體系） |
| 🪞 鏡像 | 交換技能 = 13×13 交互矩陣要全測，一人團隊測不完 | v2 |
| 🎭 盲選 | 純客戶端效果，不改變結算邏輯。2 秒含翻卡動畫 = 實際無法操作 | v2（改為 5 秒） |
| 👁️ 偵察 | ATK 範圍資訊太弱，不改變決策。純客戶端效果 | v2（改為揭示更有價值的資訊） |
| 🃏 暗牌 | 破壞「公牌→選牌」核心原則，等於沒場地卡的回合 | v2（改為「3 選 1」設計） |
| 🌪️ 混沌 | 依賴所有場地卡都已實作。選到偵察/盲選 = 無效果 = 設計缺陷 | v2（排除無效池） |

---

## 2. 場地卡基礎規則

### 序列生成

- 每場對戰開始時，Server 從 8 張場地卡池中隨機抽取 **6 張**（不重複）
- 前 N 回合各用 1 張（N = 實際回合數，理論最大 10 回合但多數 6~8 回合 HP 歸零結束）
- 若比賽打超過 6 回合，第 7 回合起無場地效果（極罕見情況）
- 場地卡序列加密存儲，每回合開始時才揭示當前場地卡

### 時間設定

| 項目 | 時間 | 設計依據 |
|------|------|---------|
| 選卡時間 | **8 秒** | 給玩家足夠時間看場地效果 + 思考 + 選卡。5 秒太趕（尤其新手），10 秒太慢（節奏拖沓） |
| 場地揭示動畫 | 2 秒 | 翻卡 + 顯示效果文字 |
| 同時翻卡倒數 | 1.5 秒 | 「3...2...1...」緊張感 |
| 場地效果生效 | 1 秒 | 數值變化動畫 |
| 技能發動 | 1.5 秒 | 技能動畫 |
| 傷害結算 | 2 秒 | HP 條下降 + 傷害數字 |
| 回合結束 | 1 秒 | 棄牌 + 顯示剩餘資訊 |
| **每回合總時間** | **~17 秒** | 一場 6~8 回合 ≈ **1.5~2.5 分鐘** |

**友善時間設計理由：**
```
舊版 5 秒 → 新手看完場地卡說明就用掉 3 秒 → 只剩 2 秒選卡 → 焦慮
新版 8 秒 → 看場地卡 2 秒 + 思考 3 秒 + 選卡 3 秒 → 從容但不拖沓

8 秒的心理學根據：
  - Miller's Law: 短期記憶 7±2 個 chunk
  - 玩家需處理：場地效果(1) + 自己手牌(3~5) + 對手可能出什麼(1) = 5~7 chunks
  - 5 秒只夠 System 1（直覺），8 秒允許 System 2（理性分析）介入
  - 但 8 秒仍有時間壓力 → 保留緊張感，不變成回合制慢棋
```

### 生效規則

- 場地卡效果**只持續該回合**
- 雙方**同時看到**場地卡（公開資訊）
- 先翻場地卡 → 再選手牌 → 博弈產生
- 場地卡在 **Phase 0.5** 生效（技能修正 Phase 1 之前）

### 與技能的交互

```
場地卡先改數值 → 技能再改數值
場地卡改的是「這回合的規則」
技能改的是「這張卡的能力」

例：鐵壁（DEF +15）+ madness（DEF = 0）
  → Phase 0.5：DEF +15
  → Phase 1：madness 把 DEF 強制為 0
  → 結果：DEF = 0（madness 覆蓋鐵壁）

例：閃電戰（傷害 ×2）+ double_strike
  → Phase 2：double_strike 計算完總傷害
  → Phase 2 後：閃電戰把總傷害 ×2
  → 結果：爆炸傷害
```

---

## 3. 8 張場地卡完整定義

### 共通 Interface

所有場地卡都實作 `FieldCardEffect` 介面（定義於 `BATTLE_SYSTEM_MVP.md` Section 6）：

```typescript
interface FieldCardEffect {
  id: string;
  name: string;
  description: string;
  category: 'victory' | 'skill' | 'resource' | 'defense';

  apply(a: PlayerRoundState, b: PlayerRoundState, round: number): void;
  onPostDamage?(a: PlayerRoundState, b: PlayerRoundState, round: number): void;
}
```

> **MVP 簡化：** 移除 `clientHints`（盲選/偵察/暗牌已砍）。所有 8 張場地卡都走標準結算流程，無特殊客戶端行為。

---

### 🏆 第一類：勝負邏輯類（victory）

---

#### ① ⚡ 閃電戰 — Lightning Blitz

```
效果：本回合傷害翻倍
一句話：打多少 × 2
```

**博弈分析：**
- 高 ATK 卡的價值暴漲（30 傷 → 60 傷）
- 但對手也知道，可能也出王牌 → 互爆
- 出小卡試探 → 小虧但保住王牌給後面的回合

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `double_strike` | 爆炸組合：兩次攻擊的總傷害再翻倍 |
| `shield` | shield 先減免，減免後的傷害再翻倍 → shield 效果被稀釋 |
| `madness` | DEF=0 + 傷害翻倍 → 雙方互毆最大化 |
| `counter` | 反彈量也翻倍（因為受到的傷害翻倍） |
| `spite` | 若被打死，損失 HP 翻倍 → spite 反傷也暴漲 |

**數值舉例（🔵 vs 🔵，ATK=37 DEF=25）：**
```
正常：37 - 25 = 12 傷害
閃電戰：12 × 2 = 24 傷害 ← 一回合打掉近 1/4 HP
```

**實作：**
```typescript
const lightningBlitz: FieldCardEffect = {
  id: 'lightning_blitz',
  name: '閃電戰',
  description: '本回合傷害翻倍',
  category: 'victory',

  apply(a, b, round) {
    a.fieldFlags.damageMultiplier = 2;
    b.fieldFlags.damageMultiplier = 2;
  },
};
```

---

#### ② 🎯 狙擊戰 — Sniper Duel

```
效果：本回合無視 DEF，ATK 直接就是傷害
一句話：DEF 變成廢數據
```

**博弈分析：**
- ATK 高 = 傷害高，DEF 完全無用
- 「ATK 高但 DEF 低」的脆皮卡不怕反噬
- 全能卡（ATK≈DEF）反而不划算 → DEF 那半是浪費

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `pierce` | 無效化：DEF 已經是 0，穿透沒意義 |
| `def_boost` | 無效化：DEF 再高也被無視 |
| `hex` | 無效化：削對手 DEF 沒意義 |
| `shield` | 仍有效：shield 減的是「受到的傷害」不是 DEF |
| `madness` | DEF=0 的副作用消失 → 純增益 |

**數值舉例（🟣攻擊型 ATK=50 DEF=34 vs 🟣防禦型 ATK=34 DEF=50）：**
```
正常：攻→防 = 50-50 = min 1  ←  防禦型完全扛住
狙擊戰：攻→防 = 50 傷害      ←  DEF 50 完全浪費
        防→攻 = 34 傷害
差距：50 vs 34 = 16 HP 差 ← 攻擊型大勝
```

**實作：**
```typescript
const sniperDuel: FieldCardEffect = {
  id: 'sniper_duel',
  name: '狙擊戰',
  description: '本回合無視 DEF',
  category: 'victory',

  apply(a, b, round) {
    a.fieldFlags.ignoreDef = true;
    b.fieldFlags.ignoreDef = true;
  },
};
```

---

#### ③ 🔄 逆轉 — Reversal

```
效果：本回合 ATK 和 DEF 互換
一句話：攻守交換
```

**博弈分析：**
- 高 DEF 低 ATK 的「肉盾卡」變成攻擊怪獸
- 高 ATK 低 DEF 的「脆皮卡」變成高防低攻
- 均衡型卡（ATK≈DEF）幾乎不受影響

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `madness` | 逆轉後 DEF=0 → 原本 ATK 高的數值被清零 |
| `atk_boost` | 加成的是「逆轉後的 ATK」（即原 DEF） |
| `def_boost` | 加成的是「逆轉後的 DEF」（即原 ATK） |
| `shield` | 正常運作（不依賴 DEF 數值） |

**數值舉例（🔵防禦型 ATK=22 DEF=40）：**
```
正常出場：ATK 22, DEF 40（攻低防高）
逆轉後：ATK 40, DEF 22（攻高防低）← 攻擊力翻了近一倍
```

**實作：**
```typescript
const reversal: FieldCardEffect = {
  id: 'reversal',
  name: '逆轉',
  description: '本回合 ATK 和 DEF 互換',
  category: 'victory',

  apply(a, b, round) {
    [a.effectiveAtk, a.effectiveDef] = [a.effectiveDef, a.effectiveAtk];
    [b.effectiveAtk, b.effectiveDef] = [b.effectiveDef, b.effectiveAtk];
  },
};
```

---

### ✨ 第二類：技能規則類（skill）

---

#### ④ 🔇 沉默領域 — Silence Zone

```
效果：本回合雙方技能無效
一句話：純比數值
```

**博弈分析：**
- 技能強但數值普通的卡 → 這回合別出
- 數值怪獸但技能爛的卡 → 完美時機！
- 改變了「技能決定勝負」的常態，回歸原始的數值對撞

**與技能的交互：**

全部技能無效。具體影響：

| 技能 | 影響程度 |
|------|---------|
| `madness` | **利好**：不會觸發 DEF=0 副作用，但也沒有 ATK 暴增 |
| `shield` / `counter` | **利空**：失去防禦/反擊能力 |
| `double_strike` / `pierce` | **利空**：失去穿透/雙擊 |
| `final_stand` / `rebirth` | **利空**：被動也無效 → 死了就是死了 |
| `momentum` | **利空**：條件觸發也無效 |
| `leech` / `hex` | **利空**：無法施加 debuff |
| `spite` | **利空**：死後反傷也無效 |

**沉默 = 全技能無效：Phase 1/2/3/4 所有技能相關邏輯全部跳過。**
- Phase 1：跳過所有技能修正（momentum, leech debuff, hex, boost, madness）
- Phase 2：忽略 pierce/double_strike/shield（純 ATK-DEF 計算）
- Phase 3：跳過 final_stand/rebirth/spite 觸發（死了就是死了）
- Phase 4：跳過 counter/leech

**結算引擎對沉默的處理：**
```
silenceSkills = true 時：
  Phase 1 → 跳過（所有技能修正無效）
  Phase 2 → 正常計算（damage = ATK - DEF, min 1，無 pierce/double_strike/shield）
  Phase 3 → 跳過 final_stand/rebirth/spite 觸發
  Phase 4 → 跳過 counter/leech
```

**實作：**
```typescript
const silenceZone: FieldCardEffect = {
  id: 'silence_zone',
  name: '沉默領域',
  description: '本回合雙方技能無效',
  category: 'skill',

  apply(a, b, round) {
    a.fieldFlags.silenceSkills = true;
    // 結算引擎在 Phase 1/2/3/4 都檢查此 flag
  },
};
```

---

### 🛡️ 第三類：防禦邏輯類（defense）

---

#### ⑤ 🛡️ 鐵壁 — Iron Fortress

```
效果：本回合雙方 DEF +15
一句話：所有人都變硬了
```

**博弈分析：**
- 低 ATK 卡幾乎只能打 min 1 傷害
- 只有高 ATK 卡才能打穿加固防禦
- 但你出高 ATK 卡，對手可能出高 DEF 卡硬扛

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `pierce` | 效果倍增：穿透 DEF × 45% 時，多穿 15 × 45% = 7 點 |
| `hex` | 對沖：hex 削 DEF -40%，但基數變大（base DEF + 15） |
| `madness` | DEF = 0 覆蓋鐵壁加成，madness 使用者不受益也不受損 |
| `def_boost` | 疊加：鐵壁 +15 → def_boost 再 +X% → 鐵桶 |

**數值舉例（⚪ vs ⚪，ATK=18 DEF=18）：**
```
正常：18 - 18 = min 1 傷害
鐵壁：18 - (18+15) = 18 - 33 = min 1 傷害 ← 低稀有度沒差
```

**數值舉例（🟡 vs 🟡，ATK=55 DEF=38）：**
```
正常：55 - 38 = 17 傷害
鐵壁：55 - (38+15) = 55 - 53 = 2 傷害 ← 傷害驟減
```

**實作：**
```typescript
const ironFortress: FieldCardEffect = {
  id: 'iron_fortress',
  name: '鐵壁',
  description: '本回合雙方 DEF +15',
  category: 'defense',

  apply(a, b, round) {
    a.effectiveDef += 15;
    b.effectiveDef += 15;
  },
};
```

---

### 💎 第四類：資源規則類（resource）

---

#### ⑥ 💊 生命之泉 — Healing Spring

```
效果：本回合開始前，雙方各回復 15 HP（不超過 100）
一句話：大家都回血
```

**博弈分析：**
- 領先方 → 優勢被稀釋，需要打更多彌補
- 落後方 → 喘息空間，可以更大膽出牌
- 低 HP 時出現 = 翻盤機會
- 滿血或接近滿血時 = 幾乎無感（HP cap 100）

**與遊戲節奏的關係：**
- 如果在第 1-2 回合出現：影響小（雙方 HP 都接近 100）
- 如果在第 3-5 回合出現：影響大（HP 已拉開差距）
- 場地卡序列隨機 → 不可控 → 增加每場遊戲的獨特性

**數值舉例：**
```
A: 60 HP, B: 35 HP（A 領先 25）
生命之泉後：A: 75 HP, B: 50 HP（A 仍領先 25）
→ 絕對差距不變，但 B 的存活回合數增加
→ B 從「2 回合內可能被殺」→「至少還能撐 3 回合」
```

**實作：**
```typescript
const healingSpring: FieldCardEffect = {
  id: 'healing_spring',
  name: '生命之泉',
  description: '本回合開始前，雙方各回復 15 HP',
  category: 'resource',

  apply(a, b, round) {
    a.currentHp = Math.min(a.currentHp + 15, 100);
    b.currentHp = Math.min(b.currentHp + 15, 100);
  },
};
```

---

#### ⑦ 🩸 嗜血 — Bloodlust

```
效果：本回合造成的傷害會回復為自己的 HP（吸血效果）
一句話：打多少回多少血
```

**博弈分析：**
- 攻擊就是治療，高 ATK 卡的價值飆升
- 跟閃電戰不同：閃電戰是「打更多」，嗜血是「打多少回多少」
- 落後方出高 ATK 卡 → 打傷害 + 回血 = 雙重收益

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `double_strike` | 兩次攻擊的總傷害都轉回 HP |
| `pierce` | 穿透造成更多傷害 → 回更多血 |
| `madness` | ATK 暴增 → 傷害暴增 → 回血暴增（但 DEF=0 也吃更多傷害） |
| `shield` | 對手 shield 減少你的傷害 → 減少你的吸血量 |

**數值舉例（🟣 ATK=50 DEF=34 vs 🟣 ATK=42 DEF=42）：**
```
A 傷害：50 - 42 = 8 → 回復 8 HP
B 傷害：42 - 34 = 8 → 回復 8 HP
→ 雙方同傷害 → 嗜血效果互相抵消

A (madness): ATK=100, DEF=0
A 傷害：100 - 42 = 58 → 回復 58 HP
B 傷害：42 - 0 = 42
→ A 打出 58 傷 + 回 58 血，但受到 42 傷
→ A 淨收益 = +58 -42 = +16 HP，B 淨收益 = -58 +42 = -16 HP
```

**吸血 HP cap：** 回復後 HP 不超過 100。

**實作：**
```typescript
const bloodlust: FieldCardEffect = {
  id: 'bloodlust',
  name: '嗜血',
  description: '本回合造成的傷害回復為自己的 HP',
  category: 'resource',

  apply(a, b, round) {
    // 主效果在 onPostDamage 中執行
  },

  onPostDamage(a, b, round) {
    // 吸血 = 造成的「實際傷害」（經過 shield 減免後對手受到的傷害）
    const healA = b.damageReceived; // A 對 B 造成的傷害 = B 受到的傷害
    const healB = a.damageReceived; // B 對 A 造成的傷害 = A 受到的傷害
    a.currentHp = Math.min(a.currentHp + healA, 100);
    b.currentHp = Math.min(b.currentHp + healB, 100);
  },
};
```

---

#### ⑧ ☠️ 荊棘 — Thorns

```
效果：本回合受到的傷害反彈 50% 給攻擊方
一句話：打我也痛你
```

**博弈分析：**
- 打越重 → 自己也越痛
- 出高 ATK 卡：打對手 30，自己吃 15 反彈
- 出低 ATK 卡：打得少反彈也少，但推進不夠
- 雙方都不敢出太重 → 但如果你猜到對手會保守... 你就出重拳

**與技能的交互：**
| 技能 | 交互效果 |
|------|---------|
| `shield` | shield 先減免，減免後的傷害再反彈 50%（你受到的少 → 反彈的也少） |
| `counter` | 疊加！受到傷害 → 反彈 50%（荊棘）+ 反彈 X%（counter） |
| `madness` | DEF=0 受傷多 → 反彈多。但你自己打出的傷害也大 → 也吃反彈 |
| `double_strike` | 兩次攻擊的總傷害反彈 50% |

**荊棘 + counter 疊加計算：**
```
A 對 B 造成 30 傷害（B 有 counter 38% + 荊棘 50%）：
  荊棘反彈：30 × 50% = 15 → A 受到 15 傷害
  counter 反彈：30 × 38% = 11 → A 額外受到 11 傷害
  A 總共額外受到：15 + 11 = 26 傷害
→ A 出了 30 傷害的拳，自己吃了 26 傷害
→ 荊棘 + counter 組合 = 恐怖的「攻高即自殘」
```

**反彈傷害不會觸發連鎖反彈。** A 的反彈傷害不會再被 B 的荊棘反彈。

**實作：**
```typescript
const thorns: FieldCardEffect = {
  id: 'thorns',
  name: '荊棘',
  description: '本回合受到的傷害反彈 50% 給攻擊方',
  category: 'resource',

  apply(a, b, round) {
    // 主效果在 onPostDamage 中執行
  },

  onPostDamage(a, b, round) {
    const thornA = Math.round(a.damageReceived * 0.50); // A 受傷反彈給 B
    const thornB = Math.round(b.damageReceived * 0.50); // B 受傷反彈給 A

    // 反彈傷害直接扣 HP（不經過 shield/counter，不觸發連鎖反彈）
    a.currentHp -= thornB; // A 被 B 的荊棘反彈
    b.currentHp -= thornA; // B 被 A 的荊棘反彈

    // 反彈傷害可以致死（HP 可以降到 0 以下，在 Phase 3 統一處理）
  },
};
```

**重要：荊棘反彈傷害與 `damageReceived` 的關係**
- **獨立。** 荊棘反彈直接扣 HP，不修改 `damageReceived`。
- 原因：如果反彈計入 `damageReceived`，會造成 counter 二次反彈的邏輯循環。
- 荊棘反彈直接修改 `currentHp`，但 Phase 3 的死亡保護判定使用的是 Phase 3 結算後的 HP，所以 `final_stand`/`rebirth` 仍能在 Phase 3 觸發保護。

---

## 4. 結算引擎整合

### resolveRound 完整流程（含場地卡）

```typescript
function resolveRound(state: BattleState, moveA: MoveDocument, moveB: MoveDocument): RoundResult {
  const round = state.currentRound;

  // === 取得場地卡（可能為 null，超過 6 回合時） ===
  const fieldCardId = state.fieldCardSequence[round - 1];
  const fieldCard = fieldCardId ? getFieldCard(fieldCardId) : null;

  // === 初始化回合狀態 ===
  const ctxA = initPlayerRoundState(state.playerA, moveA, state);
  const ctxB = initPlayerRoundState(state.playerB, moveB, state);

  // === Phase 0.5: 場地卡 apply() ===
  if (fieldCard) {
    fieldCard.apply(ctxA, ctxB, round);
  }

  // === Phase 1: 技能修正 ===
  if (!ctxA.fieldFlags.silenceSkills) {
    resolvePhase1_SkillModifiers(ctxA, ctxB);
  }

  // === Phase 2: 傷害計算 ===
  resolvePhase2_DamageCalc(ctxA, ctxB);

  // === Phase 2.5: 場地卡傷害後效果 ===
  if (fieldCard?.onPostDamage) {
    fieldCard.onPostDamage(ctxA, ctxB, round);
  }

  // === Phase 3: HP 結算 ===
  if (!ctxA.fieldFlags.silenceSkills) {
    resolvePhase3_HpSettlement(ctxA, ctxB, state);
  } else {
    resolvePhase3_HpSettlement_Silent(ctxA, ctxB, state);
  }

  // === Phase 4: 後處理 ===
  if (!ctxA.fieldFlags.silenceSkills) {
    resolvePhase4_PostProcess(ctxA, ctxB, state);
  }

  // === 更新跨回合狀態 ===
  updateBattleState(state, ctxA, ctxB);

  // === 檢測特殊事件 ===
  const events = detectEvents(ctxA, ctxB, state);

  // === 判定勝負 ===
  const roundWinner = checkRoundEnd(state);

  return buildRoundResult(round, fieldCard, ctxA, ctxB, events, roundWinner);
}
```

### 場地卡結算順序總覽

```
Phase 0    場地卡翻開（客戶端顯示場地卡動畫）
             ↓
Phase 0.5  fieldCard.apply()
           → 修改 ATK/DEF/HP
           → 設定 fieldFlags（沉默/狙擊/閃電）
             ↓
Phase 1    技能修正（silenceSkills → 跳過）
           → momentum → leech debuff → hex → boost → madness
             ↓
Phase 2    傷害計算
           → ignoreDef（狙擊戰）
           → 正常 calcDamage + shield
           → damageMultiplier（閃電戰）
             ↓
Phase 2.5  fieldCard.onPostDamage()
           → 嗜血（吸血）
           → 荊棘（反彈）
             ↓
Phase 3    HP 結算（silenceSkills → 跳過技能觸發）
           → 扣 HP
           → rebirth / final_stand / spite
             ↓
Phase 4    後處理（silenceSkills → 跳過）
           → counter 反彈
           → leech 設定
```

> **MVP 簡化：** 無 Phase 0.7（鏡像已砍）、無 overrideDamageCalc（絕殺已砍）、無 skillParamsMultiplier（暴走已砍）、無特殊場地卡預處理（暗牌/混沌已砍）。結算流程大幅簡化。

---

## 5. Firestore 存儲

### 場地卡定義（靜態資料）

場地卡定義直接寫在 Cloud Function 程式碼中（硬編碼），不存 Firestore。原因：
- 只有 8 張，不會動態增減
- Server 專用資料，客戶端不需要獨立讀取
- 避免額外 Firestore 讀取開銷

### 對戰中的場地卡資料

```javascript
// battles/{battleId} 中
{
  // 加密存儲（客戶端不可直接讀取）
  fieldCardSequence: [
    "encrypted_hash_1",
    "encrypted_hash_2",
    "encrypted_hash_3",
    "encrypted_hash_4",
    "encrypted_hash_5",
    "encrypted_hash_6",
  ],

  // 已揭示的場地卡（客戶端可讀）
  revealedFieldCards: [
    {
      round: 1,
      fieldCardId: "lightning_blitz",
      name: "閃電戰",
      description: "本回合傷害翻倍",
    },
  ],
}
```

### RoundResult 中的場地卡資料

```javascript
// battles/{battleId}/rounds/{round}
{
  round: 1,
  fieldCardId: "lightning_blitz",       // 本回合場地卡（null = 超過 6 回合）
  fieldFlags: {                         // 本回合生效的 flags（用於客戶端動畫）
    damageMultiplier: 2,
  },
  // ... 其餘傷害/HP 資料
}
```

### Security Rules 要點

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /battles/{battleId} {
      // 場地卡序列：任何玩家都不可讀取加密序列
      allow read: if request.auth != null
                  && (resource.data.hostId == request.auth.uid
                      || resource.data.guestId == request.auth.uid);
      // 注意：fieldCardSequence 通過 Cloud Function 間接訪問
      // 客戶端只讀 revealedFieldCards

      // 玩家不可修改場地卡相關欄位
      allow update: if request.auth != null
                    && !request.resource.data.diff(resource.data).affectedKeys()
                       .hasAny(['fieldCardSequence', 'revealedFieldCards']);
    }
  }
}
```

---

## 6. 客戶端 UI 規格

### 場地卡翻開動畫

```
時序（每回合開頭）：
  0.0s  場地卡背面出現在畫面中央
  0.3s  翻轉動畫開始
  0.8s  正面顯示（場地卡名稱 + icon + 一句話效果）
  1.2s  效果文字浮現
  2.0s  場地卡縮到頂部常駐顯示 → 選卡計時器開始（8 秒）
```

### 場地卡常駐顯示

```
對戰畫面頂部中央：
  ┌─────────────────────────┐
  │  ⚡ 閃電戰 — 傷害翻倍    │
  └─────────────────────────┘

選卡時：場地卡持續可見，提醒玩家當前規則
結算時：場地卡仍然顯示，直到回合結束
```

### 場地卡歷史

```
畫面側邊（可收合）：
  Round 1: ⚡ 閃電戰
  Round 2: 🔇 沉默領域
  Round 3: 🩸 嗜血        ← 當前回合（高亮）
  Round 4: ？
  Round 5: ？
  Round 6: ？
```

### 無場地回合（第 7+ 回合）

```
如果比賽打到第 7 回合以上（6 張場地卡用完）：
  頂部顯示：「—— 無場地效果 ——」（灰色文字）
  正常結算，無場地修正
```

---

## 7. 平衡性分析

### 場地卡影響力分級

| 等級 | 場地卡 | 對單回合 HP 差距的影響 |
|------|--------|---------------------|
| 🔴 高影響 | ⚡ 閃電戰 | 可造成 20-50 HP 差 |
| 🟡 中影響 | 🎯 狙擊、🔄 逆轉、🔇 沉默、🩸 嗜血、☠️ 荊棘 | 可造成 10-30 HP 差 |
| 🟢 低影響 | 🛡️ 鐵壁、💊 生命之泉 | 0-15 HP 差 |

**分佈：** 1 高 + 5 中 + 2 低 = 大部分回合有感但不至於一擊翻盤。

### 場地卡 × 技能交互矩陣（關鍵組合）

| 場地卡 | 最強技能組合 | 最弱技能組合 |
|--------|------------|------------|
| ⚡ 閃電 | madness（爆炸傷害）、double_strike | shield（被稀釋）、def_boost |
| 🛡️ 鐵壁 | pierce（穿透更多）、madness（無視） | atk_boost（可能仍打不穿） |
| 🎯 狙擊 | madness（無副作用）、atk_boost | pierce/hex/def_boost（無效） |
| 🔄 逆轉 | def_boost 型卡（高 DEF 變高 ATK） | 攻擊型卡（高 ATK 變高 DEF） |
| 🔇 沉默 | 數值怪獸（純比數值） | 技能依賴型卡（技能浪費） |
| 🩸 嗜血 | madness（打多回多）、pierce | shield 對手（降低吸血） |
| ☠️ 荊棘 | counter（疊加反彈 88%!） | madness（DEF=0 被打爆+反彈） |

### 場地卡出現頻率分析

```
每場 6 張場地卡（從 8 張中抽）：

每張場地卡在某場比賽出現的機率：
  P(出現) = 1 - C(7,6)/C(8,6) = 1 - 7/28 = 75%

→ 每場比賽中，任何一張場地卡都有 75% 機率出現
→ 玩家需要準備應對所有場地卡
→ 不確定性來自「順序」而非「有沒有出現」
→ 只有 2 張不會出現 → 策略差異來自「少了哪兩張」
```

### 與稀有度的交互

| 場地卡 | 低稀有度（⚪🟢）影響 | 高稀有度（🟡🔴）影響 |
|--------|-------------------|-------------------|
| ⚡ 閃電 | 傷害小，翻倍仍不多 | 傷害大，翻倍後爆炸 |
| 🛡️ 鐵壁 | +15 幾乎免傷（ATK 低） | +15 只是微減 |
| 🎯 狙擊 | ATK 低，傷害也不高 | ATK 高，直接高傷 |
| 🔇 沉默 | 技能本就不強，影響小 | 強技能被廢，影響大 |
| 🩸 嗜血 | 傷害低回血少 | 傷害高回血多 |
| ☠️ 荊棘 | 傷害低反彈少 | 傷害高反彈多 → 雙方都痛 |

---

## 附錄 A：8 張場地卡速查表

| # | ID | 名稱 | 類別 | 效果一句話 | 掛接點 |
|---|-----|------|------|-----------|--------|
| ① | `lightning_blitz` | ⚡ 閃電戰 | victory | 傷害翻倍 | `fieldFlags.damageMultiplier` |
| ② | `sniper_duel` | 🎯 狙擊戰 | victory | 無視 DEF | `fieldFlags.ignoreDef` |
| ③ | `reversal` | 🔄 逆轉 | victory | ATK/DEF 互換 | `apply()` |
| ④ | `silence_zone` | 🔇 沉默領域 | skill | 技能無效 | `fieldFlags.silenceSkills` |
| ⑤ | `iron_fortress` | 🛡️ 鐵壁 | defense | DEF +15 | `apply()` |
| ⑥ | `healing_spring` | 💊 生命之泉 | resource | 回復 15 HP | `apply()` |
| ⑦ | `bloodlust` | 🩸 嗜血 | resource | 傷害轉 HP | `onPostDamage()` |
| ⑧ | `thorns` | ☠️ 荊棘 | resource | 反彈 50% 傷害 | `onPostDamage()` |

---

## 附錄 B：場地卡邊界條件

| 情況 | 處理 |
|------|------|
| 比賽打超過 6 回合 | 第 7 回合起無場地效果（fieldCard = null） |
| 荊棘 + 雙方都被打死 | Phase 2.5 反彈後 HP ≤ 0 → Phase 3 統一處理死亡判定 |
| 荊棘反彈 + final_stand | 反彈在 Phase 2.5，final_stand 在 Phase 3 → final_stand 可觸發 |
| 沉默 + final_stand/rebirth | 沉默無效化所有技能 → 死了就是死了 |
| 逆轉 + madness | Phase 0.5 先交換 → Phase 1 madness 使 DEF=0 → 結果：ATK=原DEF×N，DEF=0 |
| 每回合只有 1 張場地卡 | 閃電+狙擊、沉默+鐵壁、嗜血+荊棘等組合不可能同回合出現 |
| 場地卡 apply() 不受沉默影響 | 沉默在 apply() 中設定 flag → apply() 本身已執行完畢 |

---

## 附錄 C：v2 回歸場地卡規劃

| 場地卡 | v2 改進方向 |
|--------|-----------|
| 💀 絕殺 | 保留概念，簡化實作（可能改為「ATK 差距 > 10 時額外 +15 傷害」） |
| 🔮 暴走 | 加入 cap 體系（madness ×2.5 cap, counter 反彈 60% cap） |
| 🪞 鏡像 | 等 v2 技能系統穩定後回歸 |
| 🎭 盲選 | 改為 5 秒選卡（比正常 8 秒短但仍可操作） |
| 👁️ 偵察 | 改為揭示對手出的卡的 1 個屬性（ATK/DEF/技能 隨機） |
| 🃏 暗牌 | 改為「顯示 3 張候選場地卡，出牌後隨機選 1 張生效」 |
| 🌪️ 混沌 | 排除無效果池（只從結算類場地卡中隨機） |

---

## 附錄 D：與其他文件的交叉引用

| 本文件 | 引用文件 | 引用內容 |
|--------|---------|---------|
| FieldCardEffect interface | BATTLE_SYSTEM_MVP.md §6 | 介面定義 |
| FieldFlags interface | BATTLE_SYSTEM_MVP.md §6 | flags 定義 |
| PlayerRoundState | BATTLE_SYSTEM_MVP.md §4 | 回合狀態結構 |
| resolveRound() 流程 | BATTLE_SYSTEM_MVP.md §4 | 完整結算虛擬碼 |
| 13 技能定義 | SKILL_SYSTEM_MVP.md §2 | 技能效果 + 數值 |
| ATK+DEF 總和範圍 | CARD_CREATION_SYSTEM_SPEC_MVP.md §6.1 | 稀有度數值範圍 |
| Firestore 結構 | BATTLE_SYSTEM_MVP.md §7 | battles/{battleId} |
| Security Rules | BATTLE_SYSTEM_MVP.md §10 | 防作弊規則 |

> **已同步：** BATTLE_SYSTEM_MVP.md 的選卡時間和每回合時間已更新為 8 秒 / ~17 秒。
