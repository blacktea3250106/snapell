# Snapell 場地卡系統 — v1

> **v1 場地卡 = 原 MVP 設計，無改動。**
>
> **完整設計來源：** `MVP/FIELD_CARDS_MVP.md` — 直接採用。

---

## 與原 MVP 的關係

**本文件確認：v1 場地卡系統完全採用 `MVP/FIELD_CARDS_MVP.md` 的設計，無任何修改。**

原因：
1. 場地卡是對戰策略性的核心支柱，不能簡化
2. 8 張場地卡的實作複雜度已經是精簡後的結果（從 15 張砍到 8 張）
3. 場地卡的 FieldCardEffect 介面和 FieldFlags 機制設計完善，無需調整

---

## 速查：8 張場地卡

| # | ID | 名稱 | 效果 | 掛接點 |
|---|-----|------|------|--------|
| ① | `lightning_blitz` | ⚡ 閃電戰 | 傷害翻倍 | `fieldFlags.damageMultiplier = 2` |
| ② | `sniper_duel` | 🎯 狙擊戰 | 無視 DEF | `fieldFlags.ignoreDef = true` |
| ③ | `reversal` | 🔄 逆轉 | ATK/DEF 互換 | `apply()` swap |
| ④ | `silence_zone` | 🔇 沉默領域 | 技能無效 | `fieldFlags.silenceSkills = true` |
| ⑤ | `iron_fortress` | 🛡️ 鐵壁 | DEF +15 | `apply()` += 15 |
| ⑥ | `healing_spring` | 💊 生命之泉 | 回復 15 HP | `apply()` HP += 15 |
| ⑦ | `bloodlust` | 🩸 嗜血 | 傷害轉 HP | `onPostDamage()` |
| ⑧ | `thorns` | ☠️ 荊棘 | 反彈 50% 傷害 | `onPostDamage()` |

---

## 完整定義

> **請直接參考 `MVP/FIELD_CARDS_MVP.md`：**
> - Section 3：8 張場地卡完整定義（含博弈分析、技能交互、數值舉例、TypeScript 實作）
> - Section 4：結算引擎整合（resolveRound 完整流程）
> - Section 5：Firestore 存儲（加密序列 + 逐回合揭示）
> - Section 6：客戶端 UI 規格（翻開動畫、常駐顯示、歷史）
> - Section 7：平衡性分析（影響力分級、交互矩陣、頻率分析）
> - 附錄 B：邊界條件

本文件不重複這些內容。
