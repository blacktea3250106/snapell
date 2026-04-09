# VoxCards — Figma Make AI Prompt 大全

> 用這些 Prompt 在 Figma Make 生成專業級遊戲介面
> 每個 Prompt 都可以直接貼進 Figma Make 使用

---

## 使用方式

1. 打開 [Figma Make](https://www.figma.com/make/)
2. 複製下方任一 Prompt，貼入 Figma Make 的文字框
3. 生成後，用後續的「追加 Prompt」來迭代優化
4. 所有 Prompt 使用英文（Figma Make 對英文理解力最好），UI 文字用中文

---

## 全局風格設定（每次新頁面都先貼這段）

```
Style guide for all screens:
- Mobile-first design (iPhone 15 Pro, 393 × 852 px)
- Dark theme: background #0F172A to #1E293B gradient
- Primary accent: purple-blue gradient (#7C3AED to #3B82F6)
- Card elements use white/light backgrounds on dark UI
- Font: Inter for UI, Noto Sans TC for Chinese text
- Rounded corners: 16px for cards, 12px for buttons, 24px for modals
- Subtle glow effects on interactive elements
- Visual style: premium collectible card game × Apple-level polish × magical atmosphere
- All card thumbnails use 3:4 aspect ratio
- Rarity colors: Gray #E5E7EB, Green #22C55E, Silver #94A3B8, Rainbow gradient, Gold #F59E0B, Dark red #DC2626 on black #0A0A0F
```

---

## Prompt 1：首頁大廳 (Home Lobby)

```
Design a mobile game home lobby screen for "VoxCards" — a card battle game where players photograph real objects and shout incantations to create unique battle cards with AI.

Screen elements (top to bottom):
1. TOP BAR: Player avatar (circle, 40px) + username "咒術師Hao" + rank badge "⚡ 高階咒術師" on the left. Gold coin count "💰 2,450" on the right.

2. FEATURED CARD: Center display of the player's representative card — a white 3:4 card with a cat photo, gold border glowing, card name "肉球炎貓 Lv.72" below it. Card floats with subtle shadow.

3. DAILY FORTUNE: A mystical banner below the card showing "今日運勢 🔥🔥🔥🔥🔥" with subtitle "火焰高漲的一天！" — translucent dark panel with purple glow edge.

4. SUMMON BUTTON: The largest, most prominent element — a glowing circular button (80px) with a magical portal animation feel, text "召喚" (Summon). Purple-blue gradient with outer glow ring. This is THE primary action.

5. QUICK ACTION ROW: 4 icon buttons in a horizontal row below:
   - ⚔️ 對戰 (Battle)
   - 🃏 卡組 (Collection)
   - 📋 任務 (Quests)
   - 👤 個人 (Profile)

6. BOTTOM MARQUEE: A scrolling news ticker at the very bottom: "🔴 玩家StarKnight 剛剛召喚了一張神話卡！全服震動！"

7. REMAINING SUMMONS: Small indicator near the summon button: "今日剩餘 3/5"

Dark mystical background with subtle particle effects. The overall vibe should feel like opening a magical portal — premium, mysterious, and inviting.
```

### 追加優化 Prompt：
```
Make the Summon button larger and add concentric glowing rings around it like a magic circle. Add a subtle animated gradient on the fortune banner. Make the featured card tilt slightly in 3D perspective to show depth.
```

---

## Prompt 2：召喚流程 — 拍照頁 (Camera Capture)

```
Design a fullscreen camera capture screen for a card summoning game "VoxCards".

Layout:
1. CAMERA VIEWFINDER: Full screen live camera preview as background.

2. TOP OVERLAY: Semi-transparent dark gradient from top. Shows:
   - Back arrow (top-left)
   - "召喚素材" title (center)
   - Remaining summons "3/5" (top-right)

3. CORNER BRACKETS: Four decorative corner brackets (like a magical targeting frame) overlaid on the camera view — thin white lines with subtle glow, framing the center capture area.

4. HINT TEXT: Floating text in the center-top area: "拍下你想召喚的東西" (Capture what you want to summon) — white text with text-shadow.

5. BOTTOM CONTROLS: Dark gradient overlay from bottom containing:
   - Gallery thumbnail (left, 48px rounded square)
   - CAPTURE BUTTON (center, 72px) — white outer ring + inner gradient circle (purple-blue). When pressed, it should look like a magical seal activating.
   - Flash toggle (right)

6. SUBTLE RUNE DECORATION: Very faint magical rune circles around the capture button area.

The feel should be "you're about to capture something magical from reality" — not a regular camera app, but a summoning ritual tool.
```

---

## Prompt 3：召喚流程 — 咒語頁 (Incantation Recording)

```
Design a voice recording screen for casting an incantation spell in the card game "VoxCards". The player has just taken a photo and now needs to shout their spell.

Layout:
1. PHOTO PREVIEW: The captured photo shown at top (180px wide, 3:4 ratio, rounded corners 12px, subtle white border). Slightly dimmed to not compete with the recording UI.

2. RECORDING AREA (center, main focus):
   - Large circular waveform visualization (200px diameter) — concentric rings that pulse with voice amplitude. Colors shift from blue to purple to red based on volume intensity.
   - Center icon: microphone icon when idle, animated sound waves when recording.
   - Timer display below: "0:03 / 0:10" counting up.
   - Status text: "對著它喊出你的咒語！" (Shout your incantation!)

3. RECORDING INDICATOR: Glowing red dot + "REC" label when recording is active.

4. VOLUME METER: Vertical bars on both sides of the waveform showing real-time decibel levels — like audio equalizer bars.

5. MODE INDICATOR (bottom):
   - Three mode pills: "🗣️ 語音" (active/highlighted) | "⌨️ 文字" | "🤖  自動"
   - Currently in voice mode.

6. ACTION BUTTON: "完成" (Done) button at bottom, disabled/gray until minimum 3 seconds recorded.

Background: Dark with subtle magical particles floating. The waveform should feel alive and responsive — like the voice is feeding energy into a spell.
```

---

## Prompt 4：召喚流程 — AI 煉成中 (AI Forging Loading)

```
Design a magical loading/processing screen for "VoxCards" where AI is forging a card from a photo + incantation.

Layout:
1. CENTER ALCHEMY CIRCLE: A large (280px) intricate magical circle/alchemy diagram — concentric rings with rune-like decorations, slowly rotating. The circle has multiple layers rotating at different speeds.

2. MERGING ELEMENTS: Inside the circle:
   - Player's photo (small, 80px) floating on the left
   - Sound waveform icon floating on the right
   - Both being drawn toward the center by energy lines
   - They're visually "merging" in the center

3. PROGRESS STAGES (below the circle): Text that changes through stages:
   - Stage 1: "📷 正在分析素材..." (Analyzing material...)
   - Stage 2: "🗣️ 正在解析咒語..." (Parsing incantation...)
   - Stage 3: "🌀 正在融合靈魂..." (Fusing soul...)
   - Stage 4: "🃏 即將誕生..." (About to be born...)

4. PROGRESS BAR: A thin, elegant progress bar below the text — glowing gradient (blue → purple → gold as it approaches completion).

5. BACKGROUND PARTICLES: Small glowing particles spiraling inward toward the alchemy circle — creating a sense of energy gathering.

6. AMBIENT GLOW: Soft radial glow emanating from the center circle, color shifting as progress advances.

This should feel like a sacred ritual — not a boring loading screen. The player should feel anticipation and excitement. Premium, mystical, worthy of the 3-6 second wait.
```

---

## Prompt 5：卡片誕生 — 翻卡結果頁 (Card Reveal Result)

```
Design a card reveal/result screen for "VoxCards" showing a newly summoned card.

Layout:
1. DIMMED BACKGROUND: The entire background is dimmed/darkened to focus attention on the card.

2. THE CARD (center, hero element):
   - Size: 270 × 360 dp (large display)
   - A beautiful white card with 3:4 ratio
   - Top section: Photo of an orange cat (270 × 200dp area)
   - Rarity badge: top-left corner, blue diamond with "R" (Rare tier)
   - Level badge: top-right, "Lv.52"
   - Divider line: silver gradient line
   - Card name: "肉球炎貓" in semibold
   - Stats row: "ATK 72  DEF 58  SPD 85" in condensed font
   - Passive skill box: "💢 不屈之焰" with description "等級比對手低時，咒語分 +5"
   - Bottom info: "📍台北  🗣️▶  02.27  #00042"
   - Border: 2dp silver metallic gradient (this is a Rare card)
   - Subtle outer glow matching rarity color

3. RARITY LABEL: Above the card, animated text "🔵 稀有" (Rare) with glow effect.

4. ACTION BUTTONS (bottom row, 3 buttons):
   - "📋 詳情" (Details) — outlined button
   - "🔄 再召喚" (Summon Again) — primary gradient button, largest
   - "📤 分享" (Share) — outlined button

5. PARTICLE EFFECTS: Silver sparkles floating around the card (matching Rare tier).

6. SPELL REPLAY: Small play button near the card: "▶️ 播放咒語" (Play incantation)

The card should look like a precious collectible item floating in space. Make it feel like unwrapping a special present.
```

---

## Prompt 6：卡組收藏頁 (Card Collection)

```
Design a card collection/inventory screen for "VoxCards" mobile game.

Layout:
1. TOP BAR:
   - Back arrow (left)
   - Title "我的卡組" (My Collection) center
   - Card count "127 張" (right)

2. FILTER/SORT BAR: Horizontal scrollable pills:
   - "全部" (All) — active
   - "⚪ 凡品" | "🟢 精良" | "🔵 稀有" | "🟣 史詩" | "🟡 傳說" | "🔴 神話"
   - Sort icon on far right (by level / by date / by rarity)

3. CARD GRID: 3-column grid of card thumbnails (75 × 100dp each):
   - Each card shows: photo thumbnail + level number overlay at bottom
   - Cards have colored borders matching their rarity:
     - Gray border = Common
     - Green border = Uncommon
     - Silver metallic border = Rare
     - Rainbow animated border = Epic
     - Gold glowing border = Legendary (slightly larger, 8% bigger)
     - Black with red cracks = Mythic (slightly larger, 8% bigger)
   - The grid has a white/light card wall feel — all cards on unified white backgrounds
   - One Mythic card should stand out dramatically (dark card in a sea of white ones)

4. Show approximately 12-15 cards in the grid, with variety across rarities. Most should be Common/Uncommon (realistic distribution).

5. FLOATING ACTION: A "+" button (bottom-right) for quick summon access.

Background: Very dark (#0F172A). The card grid should look like opening a premium collector's album — organized, clean, satisfying. The contrast between the dark UI and the white card thumbnails makes each card pop.
```

---

## Prompt 7：對戰選卡階段 (Battle Card Selection)

```
Design a battle card selection screen for "VoxCards" — a 1v1 card battle game.

Context: Player needs to choose 3 cards from 5 randomly drawn cards, then set their play order. 15-second time limit.

Layout:
1. TOP: Match info bar
   - Left: Your avatar + "咒術師Hao" + rank icon
   - Center: "VS" with lightning effect
   - Right: Opponent avatar + "ShadowMage" + rank icon
   - Timer: Large "0:12" countdown, turns red below 5 seconds

2. INSTRUCTION TEXT: "選擇 3 張卡並排列出場順序" (Select 3 cards and set play order)

3. CARD SELECTION AREA (center):
   - 5 cards displayed in a fan/arc arrangement (150 × 200dp each)
   - Each card shows: photo + name + level + rarity border
   - Tap to select → card lifts up and gets a blue selection ring + number indicator (①②③)
   - Unselected cards are slightly dimmed
   - Selected cards show their battle order number

4. SELECTED ORDER (below the fan):
   - 3 slots labeled "Round 1" "Round 2" "Round 3"
   - Selected cards slide into these slots in order
   - Slots show mini card thumbnails once filled
   - Can tap to rearrange

5. CONFIRM BUTTON: "確認出戰！" (Confirm Battle!) — large gradient button, disabled until 3 cards selected. Glows when ready.

6. BACKGROUND: Dark arena atmosphere with subtle spotlight from above. Dramatic but not distracting.

The screen should create strategic tension — "which cards do I pick? what order?"
```

---

## Prompt 8：對戰回合 — 咒語時間 (Battle Round - Spell Time)

```
Design the battle spell-casting screen for "VoxCards" — the moment both players shout their incantations simultaneously.

Layout (split screen):
1. TOP SECTION (card confrontation):
   - Left side: Your card (120 × 160dp) — "肉球炎貓 Lv.52"
   - Center: "VS" with electric sparks
   - Right side: Opponent's card (120 × 160dp) — "暗影狼 Lv.67"
   - Passive skill effects displayed if triggered: floating text like "+5 咒語分"

2. COUNTDOWN: Large "0:04" timer in the center, pulsing.

3. YOUR SPELL AREA (bottom half, main interaction):
   - Large circular voice waveform (160px) — pulsing rings that react to voice volume
   - Real-time volume bars on sides
   - Text: "喊出你的咒語！" (Shout your incantation!)
   - Small mode indicator: "🗣️ 語音模式"

4. OPPONENT AREA (top-right, small):
   - Small sound wave indicator showing opponent is also casting (but details hidden)
   - "對手正在施咒..." (Opponent is casting...)

5. ROUND INDICATOR: "Round 1 of 3" at the very top with score dots (● ○ ○)

6. ENERGY EFFECTS: As the player speaks louder, energy lines flow from the waveform toward your card — visual feedback that voice energy powers the card.

Atmosphere: Intense, dramatic. Two cards facing off, both players powering them with voice. Like a magical duel where your voice IS the weapon.
```

---

## Prompt 9：對戰結算 (Battle Result)

```
Design a battle result/scoring screen for "VoxCards" after both players have cast their spells.

Layout:
1. CARDS FACE-OFF (top): Your card (left) vs Opponent card (right), both at 120 × 160dp.

2. SCORE BREAKDOWN (center, main content):
   Left column (Your scores):         Right column (Opponent scores):
   🎯 契合度: 8/10                    🎯 契合度: 6/10
   "提到了貓的特徵"                    "內容有些偏題"

   🔥 氣勢: 7/10                      🔥 氣勢: 5/10
   "聲音有力度"                        "氣勢不足"

   🎪 創意: 6/10                      🎪 創意: 7/10
   "意象不錯"                          "說法很獨特"

   Total: 21                          Total: 18

3. BATTLE POWER CALCULATION:
   Left: "21 × 1.6 = 33.6"           Right: "18 × 2.0 = 36.0"
   (showing spell score × level multiplier)

4. RESULT BANNER: Large "敗北" (Defeat) or "勝利！" (Victory!) banner.
   - Victory: Gold/green burst effect
   - Defeat: Muted red/gray

5. SPECIAL EVENT (if triggered): "⚡ 險勝！戰鬥力差距僅 2.4！" banner with special effects

6. ROUND PROGRESS: "Score 0:1" — dots showing ● (opponent won round 1)

7. NEXT BUTTON: "下一回合 →" (Next Round) or "查看最終結果" (View Final Result)

Show this in the "opponent barely wins" scenario — the numbers should be close and dramatic. Display scores with a sequential reveal animation feel (scores appearing one by one).
```

---

## Prompt 10：對戰最終結果 (Match Final Result)

```
Design the final match result screen for a BO3 (best of 3) battle in "VoxCards".

Layout:
1. RESULT HEADER: Large text "勝利！" (VICTORY!) with golden burst effects and particles. Or "敗北" (DEFEAT) with muted effects.

2. SCORE: "2 : 1" in large display — each number has the winning/losing round cards as small thumbnails below them.

3. MATCH SUMMARY (3 rounds):
   Round 1: 🃏 肉球炎貓 vs 暗影狼 → ❌ Lost (33.6 vs 36.0)
   Round 2: 🃏 雷霆虎 vs 冰晶鳥 → ✅ Won (48.0 vs 31.5)
   Round 3: 🃏 石牆守衛 vs 暗影狼 → ✅ Won (42.0 vs 38.0)

4. SPECIAL EVENTS: Badges/icons for events triggered:
   "🔥 以下犯上 ×1" "⚡ 險勝 ×1"

5. REWARDS:
   💰 +100 金幣
   ⭐ 卡片經驗 +2 (each card)
   🏆 段位分 +18

6. BEST SPELL REPLAY: "🎤 本場最佳咒語" — a play button to replay the highest-scoring spell from the match, showing the text and a play audio button.

7. ACTION BUTTONS (bottom):
   - "🔄 再來一局" (Rematch) — primary button
   - "📤 分享戰報" (Share) — secondary
   - "🏠 返回大廳" (Return) — tertiary/text link

Victory screen should feel celebratory and rewarding. Make the player want to screenshot and share this.
```

---

## Prompt 11：段位個人資料 (Rank & Profile)

```
Design a player profile/rank screen for "VoxCards" mobile game.

Layout:
1. PROFILE HEADER:
   - Large avatar (80px circle) with rank border decoration
   - Username: "咒術師Hao" (large, white)
   - Rank title: "⚡ 高階咒術師" with rank icon
   - Rank points progress bar: "720 / 1000" — gradient fill bar (blue to purple)
   - Next rank label: "下一段位：🌙 大咒術師"

2. STATS CARDS (horizontal scroll, 3 cards):
   - Card 1: "戰績" — 42 勝 / 18 敗 (70% 勝率) with mini chart
   - Card 2: "收藏" — 127 張卡 | 最高 🟡 傳說 with rarity distribution mini bar
   - Card 3: "成就" — 15/50 已解鎖 with star rating

3. REPRESENTATIVE CARD: "代表卡" section showing the player's chosen showcase card (150 × 200dp) with full rarity effects. Card name and level displayed.

4. RANK LADDER (scrollable list): Show all 7 ranks vertically:
   💀 禁咒者 (1500+ ★) — locked/grayed, top
   👑 傳說咒術師 (1500+)
   🌙 大咒術師 (1000-1499)
   ⚡ 高階咒術師 (600-999) — CURRENT (highlighted with glow)
   🔮 正式咒術師 (300-599)
   📖 學徒咒術師 (100-299)
   🐣 見習咒術師 (0-99)
   Each rank shows its icon, name, and point range. Current rank is highlighted.

5. RECENT MATCHES: Last 3 match results as compact rows (Win/Loss + opponent + score)

Dark premium background. The profile should feel like a warrior's achievement hall — impressive and worth showing off.
```

---

## Prompt 12：卡片詳情頁 (Card Detail)

```
Design a full-screen card detail view for "VoxCards".

Layout:
1. BACKGROUND: Blurred, darkened version of the card's photo as full-screen background.

2. THE CARD (center, large display, 270 × 360dp):
   A Legendary (gold) tier card:
   - White-to-pale-gold gradient background
   - Photo area: A majestic tiger photo with warm golden filter
   - Gold triple-layer border with outer glow
   - Gold shimmer particles floating around the card
   - Rarity badge: Gold shield "L" (top-left)
   - Level: "Lv.88" in gold circle (top-right)
   - Card name: "霸王金虎" in gold gradient text with gold shadow
   - Stats: "ATK 92  DEF 78  SPD 85"
   - Passive: "👑 王者之怒 — 3:0 完封時，下場對戰所有咒語分 +3"
   - Bottom: "📍東京  🗣️▶  01.15  #00007"
   - The entire card radiates golden warmth

3. CARD INFO (below card, scrollable):
   - "召喚者：咒術師Hao"
   - "召喚地點：東京鐵塔"
   - "召喚日期：2026.01.15"
   - "▶️ 播放原始咒語" — audio play button with waveform
   - Card lore/description: "在東京鐵塔的頂端，一聲咆哮震碎了夜空..."

4. ACTION BAR (bottom, fixed):
   - "⭐ 設為代表" (Set as Featured)
   - "🍖 餵養" (Feed)
   - "🔄 融合" (Fuse)
   - "📤 分享" (Share)

The legendary card should feel PRECIOUS — like holding a golden artifact. Warm light, premium feel.
```

---

## Prompt 13：六種卡片稀有度對比 (6 Rarity Cards Showcase)

```
Design a showcase screen displaying all 6 card rarities side by side for "VoxCards".

Show 6 cards in 2 rows of 3 (each card approximately 160 × 213dp):

Row 1:
1. ⚪ COMMON "野貓" Lv.8 — Pure white card, gray 1dp border, matte finish, clean and minimal. No effects.

2. 🟢 UNCOMMON "花園蝶" Lv.25 — White card, green #22C55E border 1.5dp, very subtle green edge glow. 95% same as Common.

3. 🔵 RARE "銀翼鷹" Lv.45 — Slight silver gradient background, metallic silver border 2dp with double-line structure. Text has embossed/debossed effect. Feels like a premium metal card.

Row 2:
4. 🟣 EPIC "虹光龍" Lv.65 — White card, rainbow gradient border (sweeping animation feel), photo area has holographic rainbow overlay at 35% opacity. The border should look like it's shimmering with all colors.

5. 🟡 LEGENDARY "霸王金虎" Lv.88 — Warm white-to-gold gradient background, thick gold triple-layer border with outer golden glow, gold particles rising upward. Even the info area has pale gold tint. Everything radiates gold.

6. 🔴 MYTHIC "深淵凝視者" Lv.97 — THE ONLY DARK CARD. Deep black #0A0A0F background, red crack lines along the border that pulse, dark red photo filter, red particles emerging from cracks, black smoke effect. Dramatically different from all others.

Below each card: rarity name + Chinese label + "光效面積: X%"

Title at top: "稀有度「光的遞進」" (Rarity: Light Progression)

The visual story: white → white with green edge → silver metal → rainbow holographic → golden radiance → VOID DARKNESS. This shows the "progressive light enhancement" design philosophy — and the dramatic Von Restorff effect of the Mythic card being the only dark one.
```

---

## Prompt 14：賽季挑戰模式選擇 (Season Challenge Selection)

```
Design a battle mode selection screen for "VoxCards" with 6 game modes shown as cards/tiles.

Layout:
1. HEADER: "對戰模式" (Battle Modes) with a sword-cross icon

2. MODE TILES (2-column grid, each tile ~170 × 120dp):

   Tile 1 — "⚔️ 排位賽" (Ranked)
   Subtitle: "同段位 · BO3"
   Badge: Current rank "⚡ 720分"
   Color accent: Purple, competitive feel

   Tile 2 — "🌍 開放賽" (Open)
   Subtitle: "隨機配對 · 奇蹟之地"
   Color accent: Blue, adventurous feel

   Tile 3 — "👥 好友對決" (Friend Match)
   Subtitle: "邀請好友 · 可語音"
   Color accent: Green, social feel

   Tile 4 — "⚡ 單卡決鬥" (Quick Duel)
   Subtitle: "一張卡 · 30秒"
   Badge: "FAST" tag
   Color accent: Yellow, speed feel

   Tile 5 — "🐉 世界Boss" (World Boss)
   Subtitle: "全服合作 · 每週一次"
   Badge: "Boss HP: 432,891 / 1,000,000"
   Progress bar showing server damage
   Color accent: Red, epic feel

   Tile 6 — "🎭 賽季挑戰" (Season Challenge)
   Subtitle: Current event: "🤫 低語之戰 — 必須用氣音悄悄話"
   Badge: "限時 6天"
   Color accent: Rainbow/special, unique feel

3. Each tile has a distinct illustration/icon, a subtle gradient background matching its color accent, and a "進入" (Enter) affordance.

Dark background. Each mode should feel distinct but cohesive. The World Boss tile should feel urgent (progress bar). The Season Challenge should feel special/limited.
```

---

## Prompt 15：每日任務頁 (Daily Quests)

```
Design a daily quest/mission screen for "VoxCards" mobile game.

Layout:
1. HEADER: "每日任務" (Daily Quests) + reset timer "重置倒數 04:32:15"

2. DAILY FORTUNE CARD: Decorative banner at top:
   "今日召喚運勢 🔥🔥🔥🔥🔥"
   "「火焰高漲的一天！」"
   Mystical card-style design with purple/blue gradient border.

3. QUEST LIST (checkmark-style tasks):
   ☐ 完成 3 場對戰 ................ 💰 200
   ☐ 贏得 1 場排位賽 .............. 📦 ×1 免費召喚
   ☐ 觸發任意特殊事件 ............. 💰 300
   ☑ 進行 1 次召喚 ................ 💰 100 (completed, green check, strikethrough)
   ☐ 在單卡決鬥贏 5 場 ............ ⭐ 經驗藥水

   Each quest is a card/row with: checkbox, description, reward, progress indicator (e.g., "2/3").
   Completed quests have green checkmark and dimmed styling.

4. SPECIAL DAILY MISSION (highlighted section):
   "📷 今日素材挑戰"
   "拍一棵樹來召喚！全服用各種樹比誰強"
   Reward: "🏆 樹之冠軍 限定頭銜框"
   Timer: "剩餘 16:22:30"
   This should stand out with a special border/glow.

5. PROGRESS SUMMARY: Bottom area showing "今日完成 1/5 · 全部完成獎勵：📦 ×2" with a progress bar.

Clean, organized, satisfying-to-check-off design. Make completed tasks feel rewarding.
```

---

## Prompt 16：分享戰報卡 (Battle Share Card)

```
Design a social media share card for "VoxCards" battle results — optimized for Instagram Stories (1080 × 1920px) or square format (1080 × 1080px).

Layout (vertical story format):
1. TOP: VoxCards logo + "⚔️ 對戰戰報"

2. PLAYER VS PLAYER:
   Left: Avatar + "咒術師Hao" + "⚡ 高階咒術師"
   Center: "2:1" in large golden text
   Right: Avatar + "ShadowMage" + "🔮 正式咒術師"

3. HIGHLIGHT CARDS: The 3 winning cards displayed in a row (small thumbnails with rarity borders)

4. BEST MOMENT:
   "🎤 本場最佳咒語"
   "「燃燒吧小貓咪！用你的肉球拍爆他！」"
   Score: 🎯8 🔥7 🎪6 = 21/30

5. SPECIAL EVENTS: "🔥 以下犯上 ×1" badge

6. BOTTOM: "VoxCards — 萬物皆卡，以聲召喚" + app download QR code placeholder

Background: Dark with subtle magical particles. The share card should look premium, exciting, and make viewers curious about the game. This is a viral marketing tool.
```

---

## Prompt 17：全服廣播 — 神話卡通知 (Server Broadcast)

```
Design a dramatic server-wide broadcast notification that appears when any player summons a Mythic (rarest) card in "VoxCards".

This is a toast/overlay that appears on TOP of whatever screen the player is viewing.

Layout:
1. OVERLAY: Semi-transparent dark backdrop dimming the entire screen.

2. BROADCAST BANNER (center, full width):
   - Background: Deep black to dark red gradient with crack/fracture lines
   - Red energy glow emanating from edges
   - Icon: ⚠️ or 🔴 pulsing
   - Title: "🔴 神話降臨！" (Mythic Descends!) in red glowing text
   - Player info: "玩家 StarKnight 召喚了"
   - Card name: "「深淵凝視者」Lv.97" in large, dramatic red text
   - Card thumbnail: Small dark mythic card preview
   - Timestamp: "剛剛"
   - Dismiss: "✕" close button or auto-dismiss after 5 seconds

3. EFFECTS: Red lightning cracks at the edges of the banner. The overall feeling should be "something forbidden just happened" — like an alarm going off in a magical world.

4. Below the banner, a subtle "全服僅 3 張" (Only 3 in server) counter.

This notification should make EVERY player stop what they're doing and feel awe/envy/excitement. It's the rarest event in the game.
```

---

## 進階迭代 Prompt 集（用來優化已生成的頁面）

### 統一風格校正
```
Adjust the overall design to be more consistent: use #0F172A as the darkest background, #1E293B for card surfaces, and ensure all interactive buttons use the purple-blue gradient (#7C3AED to #3B82F6). All card elements should have white/light backgrounds to contrast with the dark UI.
```

### 增加質感
```
Add subtle noise texture (2% opacity) to all dark backgrounds for a premium feel. Add glass-morphism effect (background blur + border opacity) to overlay panels. Make all shadows softer and more diffused.
```

### 手機適配
```
Ensure all screens fit iPhone 15 Pro dimensions (393 × 852 px). Add safe areas for top notch (59px) and bottom home indicator (34px). Make all touch targets at least 44px. Ensure text is readable at arm's length.
```

### 動效提示（給 Figma 原型用）
```
Add interaction annotations: the Summon button should have a scale-up bounce on press, cards should have a tilt hover effect, the fortune banner should have a slow gradient animation, and all screen transitions should use a 300ms ease-in-out slide.
```

---

## 附錄：關鍵設計數據速查

| 項目 | 數值 |
|------|------|
| 螢幕 | iPhone 15 Pro, 393 × 852 px |
| 卡片比例 | 3:4 直向 |
| 卡片全尺寸 | 300 × 400 dp |
| 卡片縮略圖 | 75 × 100 dp |
| 對戰用卡片 | 150 × 200 dp |
| 分享圖 | 1080 × 1350 px |
| 品質色：凡品 | #E5E7EB 灰 |
| 品質色：精良 | #22C55E 綠 |
| 品質色：稀有 | #94A3B8 銀 |
| 品質色：史詩 | 彩虹 SweepGradient |
| 品質色：傳說 | #F59E0B 金 |
| 品質色：神話 | #DC2626 紅 + #0A0A0F 黑 |
| UI 背景 | #0F172A ~ #1E293B |
| 主要強調 | #7C3AED → #3B82F6 漸層 |
| 圓角：卡片 | 10~12 dp |
| 圓角：按鈕 | 12 dp |
| 字體 | Rajdhani / Noto Sans TC / Barlow Condensed |
