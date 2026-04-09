# Snapell 技能系統 — v1（完整 13 種 + 結算）

> **v1 技能系統 = 原 MVP 設計，加入 6 種專屬技能 + 完整結算。**
>
> **完整設計來源：** `MVP/SKILL_SYSTEM_MVP.md` — 直接採用。
> **v0 版本：** `MVP-v0/SKILL_SYSTEM_v0.md`（7 種共享，僅定義不結算）

---

## 與 v0 的差異

| 項目 | v0 | v1 |
|------|-----|-----|
| 技能總數 | 7（共享） | **13**（7 共享 + 6 專屬） |
| 結算 | 不結算（僅卡面文字） | **Phase 1~4 完整結算** |
| 專屬技能 | 無 | spite, momentum, leech, hex, final_stand, rebirth |
| 退役規則 | 放寬（共享全可用） | **恢復退役**（atk_boost/def_boost 🟣+退役等） |
| 🔴 神話 | 從共享技能中選 | **專屬 rebirth**（唯一技能） |

---

## v1 新增：6 種專屬技能

| # | 機制 | 專屬稀有度 | 效果 |
|---|------|-----------|------|
| 8 | `spite` | ⚪ 凡品 | 死亡時，對手受已損失 HP × 30% 真傷 |
| 9 | `momentum` | 🟢 精良 | 上回合受傷 → ATK +25% |
| 10 | `leech` | 🔵 稀有 | 造成傷害後，對手下回合 DEF -20% |
| 11 | `hex` | 🟣 史詩 | 對手 DEF -40% |
| 12 | `final_stand` | 🟡 傳說 | HP→0 時 HP=1 + 反擊 ATK×80% 真傷（每場一次） |
| 13 | `rebirth` | 🔴 神話 | 首次死亡 → 50% HP 復活（每場一次） |

---

## v1 完整可用矩陣

### 共享技能

| 技能 | ⚪ | 🟢 | 🔵 | 🟣 | 🟡 | 🔴 |
|------|:--:|:--:|:--:|:--:|:--:|:--:|
| atk_boost | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| def_boost | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| shield | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| counter | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| madness | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ |
| double_strike | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| pierce | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |

### 專屬技能

| 技能 | 專屬稀有度 |
|------|-----------|
| spite | ⚪ |
| momentum | 🟢 |
| leech | 🔵 |
| hex | 🟣 |
| final_stand | 🟡 |
| rebirth | 🔴 |

### 各稀有度池大小

```
⚪ → 5（atk_boost, def_boost, shield, counter + spite）
🟢 → 6（atk_boost, def_boost, shield, counter, madness + momentum）
🔵 → 7（atk_boost, def_boost, shield, counter, madness, double_strike, pierce）→ 不含 leech
     實際 8（+leech）
🟣 → 6（shield, madness, double_strike, pierce + hex）
🟡 → 4（madness, double_strike, pierce + final_stand）
🔴 → 1（rebirth）
```

---

## 完整規格

> **請直接參考 `MVP/SKILL_SYSTEM_MVP.md`：**
> - Section 1：設計總覽（可用矩陣、退役設計）
> - Section 2：技能機制定義（13 種完整數值表）
> - Section 3：詳細機制說明（每種技能的觸發條件、範例、特殊規則）
> - Section 4：結算順序（Phase 1~4 + 邊界處理）
> - Section 5：Firestore skillParams 格式
> - Section 6：AI 技能選擇指引

本文件不重複這些內容。

---

## v0 舊卡處理

v0 期間已生成的卡片**保留原技能不變**：

- v0 的 🟡 傳說如果有 double_strike → v1 後仍然是 double_strike
- v0 的 🔴 神話如果有 madness → v1 後仍然是 madness
- v0 的 🟣 史詩如果有 atk_boost → v1 後仍然是 atk_boost

**只有 v1 之後新生成的卡片才套用新的技能池規則。**

這些「規則外」的舊卡在對戰中完全可以正常使用：
- 結算引擎按 skillMechanic 結算，不管稀有度是否「應該」有這個技能
- 例如 🔴 神話的 madness 使用 ×1.30 倍率（按稀有度查表），結算正常
