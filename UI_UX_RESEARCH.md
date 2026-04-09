# 主流卡牌遊戲 UI/UX 設計語言研究

> 研究目的：為 VoxCards 暗色奇幻主題手遊提煉可落地的視覺設計洞察
> 研究日期：2026-02-27

---

## 目錄
1. [Marvel Snap](#1-marvel-snap)
2. [Hearthstone 爐石戰記](#2-hearthstone-爐石戰記)
3. [Genshin Impact 原神](#3-genshin-impact-原神)
4. [Pokemon TCG Pocket](#4-pokemon-tcg-pocket)
5. [Legends of Runeterra 符文大地傳說](#5-legends-of-runeterra-符文大地傳說)
6. [跨遊戲稀有度色彩體系對比](#6-跨遊戲稀有度色彩體系對比)
7. [暗色主題 UI 最佳實踐](#7-暗色主題-ui-最佳實踐)
8. [VoxCards 可落地設計建議](#8-voxcards-可落地設計建議)

---

## 1. Marvel Snap

### 設計哲學
- **「鋼琴黑玻璃」(Piano Glass)** 為核心視覺主題：所有 UI 元素以暗色光滑表面為底，按鈕和互動元素呈現為「光的投影全息圖(hologram)」
- **設計問題**：「未來的漫畫會長什麼樣？」——科幻漫畫美學
- **卡牌永遠在視覺層級最高位**：UI 的存在是為了襯托卡牌，而非搶奪注意力
- **半色調圓點(Halftone Dots)** 致敬 Marvel 漫畫印刷傳統

### 色彩系統
| 用途 | 色調描述 | 備註 |
|------|---------|------|
| 主背景 | 深黑帶微藍/紫光 (#0A0A12 ~ #12121F 區間) | 鋼琴黑玻璃質感 |
| 全息按鈕 | 青藍/紫色漸層光暈 | 按鈕本身是「光」不是「物件」 |
| 強調色 | 亮黃/橘色 (能量、CTA) | 用於 Snap 機制、重要操作 |
| 勝利指示 | 綠色光暈 (位置邊框發光) | 邊框向贏家方向發光 |
| 文字 | 白色/淺灰 | 在深色背景上保持高對比 |
| 半色調裝飾 | 低透明度圓點陣列 | 背景紋理層，不干擾內容 |

### 字體
- **主要字體**：Montserrat（載入 100-900 全部字重，含斜體）
- **特點**：幾何無襯線，現代感強，多字重讓層級分明
- **層級運用**：粗體用於標題/數值，細體用於說明文字

### 按鈕設計語言
- 按鈕不是傳統的「容器」——而是**光的投影**
- 主要 CTA 使用亮色漸層 + 外發光(glow)效果
- 圓角矩形，邊緣帶微妙光暈
- 按下時全息效果增強 + 觸覺回饋(haptic feedback)
- **Snap 機制**：觸發時「戲劇性燈光秀(dramatic light show)」+ 震動

### 卡牌視覺升級系統（核心參考）
Marvel Snap 的卡牌升級是**漸進式視覺增強**，完全對標 VoxCards 的「光的遞進」理念：

| 等級 | 視覺效果 | 對標 VoxCards |
|------|---------|-------------|
| **Common** | 基礎 2D 平面卡面 | 啞光白 |
| **Uncommon** | **Frame Break** — 卡面角色突破邊框 | 綠色邊框 |
| **Rare** | **3D 視差(Parallax)** — 傾斜手機可見層次感 | 銀色金屬 |
| **Epic** | **動畫(Animated)** — 卡面元素微動 | 全息彩虹 |
| **Legendary** | **閃亮 Logo** — 卡名反射光線 | 金色粒子 |
| **Ultra** | **動畫邊框** — 邊框能量脈衝流動 | — |
| **Infinite** | **Infinity Split** — 隨機特殊效果(墨水/金箔/宇宙) | 神話暗卡 |

### Infinity Split 系統（卡牌頂級裝飾）
- **Finishes（底層效果）**：改變卡面背景/底色，如墨水風、金箔、宇宙星空
- **Flares（頂層效果）**：3D 空間中的粒子/光線圖層，疊加在卡面之上
- **Custom Card**：玩家可自由組合 Finish + Flare，個性化程度極高

### 導航與佈局
- **底部操作區**：配合手機人機工學，將互動元素移至螢幕下半
- **旋轉木馬(Carousel)式主畫面**：水平滑動切換不同功能區
- **大型 CTA 按鈕** + 圖示導航
- **模組化設計**：所有元件可重用，支持 A/B 測試快速迭代

### 首次體驗 (FTUE)
- 極簡規則入門：1 種卡牌類型、3 個位置、6 回合
- **退卻顯示「Escaped!」而非「Lost」**——語言重構(reframing)消除負面情緒
- 觸控優先設計，無需卡牌遊戲經驗即可上手
- 隱藏複雜系統，只在需要時逐步揭示

### 關鍵洞察（VoxCards 可用）
1. **「光作為 UI」概念**：按鈕不是容器，是光的投射——在暗色主題中極為有效
2. **卡牌升級的漸進式視覺增強**：與 VoxCards 的「光的遞進」理念完全一致
3. **Frame Break 概念**：卡面角色突破邊框，增加「活」的感覺
4. **Finish + Flare 分層**：底層效果 + 頂層效果的組合系統，靈活度極高

---

## 2. Hearthstone 爐石戰記

### 設計哲學
- **酒館(Tavern)沉浸式世界觀**：整個 UI 就是一間奇幻酒館
- **擬物感(Physicality)**：讓數位卡牌擁有「摸得到」的觸感
- **溫暖與舒適**：色彩、材質、聲音都在傳達「坐在壁爐旁」的感覺

### 色彩系統
| 用途 | 色值/描述 | 備註 |
|------|---------|------|
| 木質主色 | #836B4F (Golden Hearthstone) | 拋光木材/溫暖爐火 |
| Logo 色系 | Cluster(深褐) + Rich Orange + Lightning Yellow + Average Yellow + Full White + Bayside(青) | 暖色為主，冷色點綴 |
| 背景紋理 | 深棕木紋 + 石材紋理 | 酒館桌面和牆壁 |
| 金屬裝飾 | 暗金/銅色 | 邊框、鉚釘、金屬飾件 |
| 魔法效果 | 飽和藍/紫/橘光 | 法術施放、卡牌效果 |
| 常見文字 | 奶白色 | 不是純白，帶暖色調 |

### 字體
- **卡牌標題/Logo**：**Belwe**（襯線字體，粗壯厚重，帶奇幻手寫感）
- **說明文字**：**ITC Franklin Gothic Condensed**（無襯線，緊湊易讀）
- **數值文字**：Belwe Bold 或定制數字字型
- **層級策略**：Belwe 帶出奇幻/古典感，Franklin Gothic 提供現代可讀性

### 稀有度色彩指示（寶石系統）
| 稀有度 | 寶石顏色 | 開包發光色 | 酒館老闆反應 |
|--------|---------|-----------|------------|
| Free | 無寶石 | — | — |
| **Common** | 白色寶石 | 無特殊光暈 | 無 |
| **Rare** | 藍色寶石 | 藍色光暈 | 一般反應 |
| **Epic** | 紫色寶石 | 粉/紫色光暈 | 興奮語氣 |
| **Legendary** | 橘色寶石 | 橘色光暈 + 爆發粒子 | 狂喜(enthusiastic)呼喊 |

### 開包動畫序列（精華流程）
1. **包裹出現**：帶物理感的 3D 包裝，隨擴展版有不同主題設計
2. **拆開動畫**：短暫的拆封動效
3. **5 張牌面朝下排列**：玩家逐一翻開（主動控制感）
4. **懸停預覽**：滑鼠/手指懸停時，卡背發出**對應稀有度的彩色光暈**（核心驚喜機制——翻開前就能感知稀有度）
5. **翻牌揭示**：高稀有度卡牌有色彩爆發(burst)效果
6. **新卡標記**：未擁有的卡牌顯示「NEW!」+ 藍色發光邊框

### 金色卡牌動畫系統
- 金色邊框取代普通邊框，**每張金卡有獨特動畫**
- 動畫限制 **4 個圖層**——迫使動畫師精簡且有創意地複用效果
- 製作流程：Photoshop 分離卡面元素 → After Effects 動畫化 → 加入粒子效果
- 金卡上方/下方的**色帶(ribbon)**顯示職業顏色（因為金色邊框覆蓋了原本的職業色）
- 效果類型：火焰飄動、煙霧繚繞、閃電脈衝、水波紋、光影流動

### 按鈕/面板設計
- **按鈕**：3D 立體感，帶金屬邊框/鉚釘裝飾，按下有凹陷物理回饋
- **面板**：木紋質感卡片，帶捲軸(scroll)或書本翻頁效果
- **邊角**：圓角但帶有手工雕刻感，非精確幾何圓角
- **陰影**：厚重投影，強化物件「浮在桌面上」的感覺

### 關鍵洞察（VoxCards 可用）
1. **翻牌前的光暈預示**：在揭示前就給出稀有度暗示，建立期待感——VoxCards 的卡牌生成等待畫面可用
2. **4 圖層限制**：限制讓創意更好，VoxCards 的 Fragment Shader 也需要性能約束
3. **Belwe + Franklin Gothic 組合**：襯線（奇幻感）+ 無襯線（可讀性）的經典搭配模式
4. **酒館老闆反應隨稀有度升級**：NPC/UI 的情緒回饋強化玩家的情緒峰值

---

## 3. Genshin Impact 原神

### 設計哲學
- **極簡東方美學**：UI 追求「清晰、簡潔、不干擾遊戲世界」
- **字體即品牌**：自有字體貫穿所有語言版本
- **祈願(Wish)系統是情緒設計的巔峰**：從期待到揭示，每一幀都在操控情緒

### 色彩系統
| 用途 | 色值 | 備註 |
|------|------|------|
| 通用 UI 藍 | #1455B4 | 按鈕、連結、互動元素 |
| 溫暖膚色/羊皮紙 | #DCC0AD | 背景面板、對話框 |
| 深紅棕 | #632720 | 強調、警告、稀有元素 |
| 暗金 | #A38D56 | 金屬裝飾、5 星暗示 |
| 柔霧藍 | #9CBFD1 | 次要元素、背景漸層 |
| 深藍灰 | #38424F | 暗色面板、導航區 |

### 稀有度色彩系統（精確 Hex）
| 星級 | Hex 色值 | 色調描述 |
|------|---------|---------|
| 1 星 | #85949C | 灰藍 |
| 2 星 | #649C74 | 深綠 |
| 3 星 | #54A4B4 | 青藍 |
| 4 星 | #9174A9 | 煙紫 |
| 5 星 | #DCA454 | 琥珀金 |

### 字體
- **主要字體**：**漢儀文黑 85W (HYWenHei-85W)** — miHoYo 定制版
  - 黑體（無襯線），Extra Bold 字重
  - 清晰極簡，兼顧奇幻冒險感
- **中文**：完整 GB2312-80 簡體 + GB12345-90 繁體（6,763 + 6,763 字）
- **日文**：基於同字體修改，加入新字體片假名/平假名
- **韓文**：主要取自 **Nanum Gothic Extrabold**，部分 miHoYo 定制
- **拉丁/西里爾**：miHoYo 另行設計的專屬字體
- **設計特點**：全遊戲統一一套字體處理所有 UI、對話、菜單

### 祈願動畫序列（逐步拆解）
這是手遊 gacha 動畫的業界標杆：

**單抽流程**：
1. **按下祈願按鈕**：命運之綾(Intertwined Fate)飛入天空
2. **流星劃過黑色星空**：3~5 秒的懸念等待
3. **關鍵色彩暗示**：
   - 流星維持**藍色** → 3 星（失望）
   - 流星轉為**紫色** → 4 星（驚喜）
   - 流星轉為**金色** → 5 星（狂喜）
   - 金色又轉**紫色且閃爍** → Capturing Radiance（5.0 新機制，命定角色）
4. **全屏爆發**：對應顏色的光芒充滿畫面
5. **角色/武器揭示**：全屏 Splash Art + 星級標示

**十連抽流程**：
1. 10 道流星同時劃過
2. 結果按優先級排序顯示：5 星角色 > 5 星武器 > 4 星角色 > 4/3 星武器
3. 未擁有的標記「New」

**設計精髓**：
- **色彩轉變瞬間是情緒巔峰**：藍→金的那一刻是整個遊戲最讓人尖叫的時刻
- **黑色星空背景**：最大化光效對比，讓流星和爆發效果極致醒目
- **延遲揭示**：3~5 秒的等待故意製造緊張感

### 按鈕/面板設計
- **按鈕**：扁平化設計，帶微妙漸層，圓角矩形
- **面板**：半透明深色背景 + 細邊框，帶高斯模糊(backdrop blur)
- **導航**：底部 Tab + 側邊滑出面板
- **空狀態**：極簡文字 + 插圖引導
- **整體風格**：Apple-like 的克制與留白

### 關鍵洞察（VoxCards 可用）
1. **色彩轉變 = 情緒巔峰**：VoxCards 卡牌生成時的稀有度揭示可以用流星/光球的顏色變化來暗示
2. **黑色背景最大化光效**：祈願畫面純黑星空是為了讓光有最大舞台——VoxCards 的 Mythic 暗卡同理
3. **統一字體策略**：一套字體貫穿所有 UI，簡化設計且強化品牌
4. **稀有度 Hex 色值**：直接可參考的精確色彩體系

---

## 4. Pokemon TCG Pocket

### 設計哲學
- **數位重現實體觸感**：整個 app 在模擬「打開實體卡包、摸到實體卡片」的感覺
- **Immersive Card（沉浸式卡牌）** 是殺手級功能：長按卡面可「潛入」卡牌世界
- **收藏展示 > 對戰功能**：app 的核心價值是「欣賞和收藏卡牌」

### 稀有度視覺指示系統
Pokemon TCG Pocket 使用**符號系統**而非單純顏色：

| 稀有度 | 符號 | 視覺效果 |
|--------|------|---------|
| 普通 | ♢ (1~4 鑽石) | 基礎卡面，無特殊效果 |
| 稀有 | ☆ (1~3 星) | 全彩插畫 + 全息效果 |
| 2 星 | ☆☆ | 全版面(Full Art) ex 寶可夢 + 全息 |
| 3 星 | ☆☆☆ | **沉浸式卡牌** — 黑色漩渦邊框 + 互動動畫 |
| 超稀有 | ♕ (Crown Rare) | 金色全息邊框 + CGI 效果 + 金色螺旋背景 |

### 全息效果實現（2D 模擬技術）
來自 simeydotme 的 CSS Pokemon Cards 開源專案精確還原了 Sword & Shield 時代的全息效果：

- **三層效果結構**：
  1. **Glare（眩光）**：隨傾斜角度移動的白色高光
  2. **Shine（光澤）**：彩虹色漸層，用 `color-dodge` 混合模式
  3. **Mask（遮罩）**：定義全息區域的形狀

- **CSS 技術棧**：
  - `CSS Transforms` — 3D 傾斜效果
  - `CSS Gradients` — 彩虹/全息漸層
  - `Blend Modes (color-dodge)` — 收藏家認得的那種全息感
  - `CSS Filters` — 飽和度/亮度微調

### 沉浸式卡牌(Immersive Card)設計
- **觸發方式**：長按(long-press)卡面
- **視覺標識**：黑色漩渦邊框，與普通全版面插畫區分
- **動畫效果**：鏡頭「推入」卡面，平移穿越多層插畫(parallax)，揭示隱藏的寶可夢和背景細節
- **音樂配合**：每張沉浸式卡牌有專屬配樂

### 開包動畫
- 模擬實體開包的撕開手勢
- 卡牌逐一翻轉揭示
- 高稀有度卡牌有全螢幕動畫接管
- **Crown Rare** 開出時：金色全息效果 + 特殊 CGI 演出

### 關鍵洞察（VoxCards 可用）
1. **沉浸式卡牌概念**：長按「潛入」卡牌世界——VoxCards 可考慮類似的卡牌詳情展示
2. **三層全息效果**（Glare/Shine/Mask）：可直接對應 Fragment Shader 的實現方式
3. **符號 + 顏色雙重稀有度指示**：比純顏色更強的辨識系統
4. **黑色漩渦邊框 = 最稀有**：黑色在滿是彩色的卡牌中反而最突出（Von Restorff 效應，與 VoxCards Mythic 暗卡一致）

---

## 5. Legends of Runeterra 符文大地傳說

### 設計哲學
- **「符文大地田野手冊」**：原始概念是玩家帶著的冒險手冊/guidebook
- **材質層級系統**：不同材質代表不同 UI 層級
- **區域(Region)留白**：主色保持中性，給各區域的專屬配色留空間
- **後期轉向扁平化**：從擬物逐漸轉向極簡(flat UI)

### 色彩/材質層級系統
| 材質 | 用途 | 視覺表現 |
|------|------|---------|
| **Runeterran Canvas** | 背景層 | 羊皮紙/帆布質感，紮根在「真實世界」 |
| **Gold & Glass** | 高價值互動 | 金色金屬 + 玻璃質感，用於「Play」按鈕和卡牌本身 |
| **Fiery Embers** | 慶祝/新內容 | 火焰餘燼粒子效果，表示進度更新或新內容 |

### 字體
- **標題/Display**：**Beaufort**（襯線字體）
  - 與 League of Legends 共享字族
  - **Beaufort for LOL** — 多字重可用
  - 搭配金色和羊皮紙色形成「符文大地手稿」美感
- **Logo 字體**：基於 **LHF Factory** 修改，字母內有精緻的纖維狀裝飾線(filigree)代表不同區域
- **層級策略**：Beaufort 的襯線感提供古典/奇幻權威感，但不過度裝飾

### 色彩系統
| 用途 | 描述 |
|------|------|
| 主色調 | 深藍黑 (#0A0E1A ~ #151A2E 區間) |
| 金色強調 | 暖金 (#C8A96E ~ #D4AF37 區間) |
| 羊皮紙 | 米白/淡黃 (#E8DCC8 ~ #F0E6D0 區間) |
| 區域專屬色 | 每個區域有獨特配色（例：Demacia 藍白、Noxus 紅黑） |
| 文字色 | 暖白/淡金 |
| 輔助暗色 | 深藍灰，用於次要面板 |

### 卡牌設計系統
- 模板化設計，可擴展至 **1000+ 張卡牌**
- **一眼可讀**：法力值、攻防數值、稀有度、效果——在卡牌的固定位置，用高對比排版
- 稀有度通過**卡框變化**傳達
- 英雄升級有**動態狀態(dynamic states)**——類似 VoxCards 的動畫卡
- 區域專屬色彩和圖示設計

### 面板/容器設計
- **金屬邊框 + 寶石鑲嵌**：高級面板
- **羊皮紙底色**：一般容器
- **毛玻璃(Glass)**：懸浮資訊面板
- **深色半透明**：遊戲內疊加層
- **圓角**：柔和但保留工藝感，非極致圓角

### 按鈕設計
- **Play 按鈕**：金色 + 玻璃質感（最高視覺層級）
- **一般按鈕**：暗色底 + 金色邊框/文字
- **輔助按鈕**：純文字或低對比
- **禁用狀態**：灰化 + 降低不透明度

### FTUE / 空狀態
- 初始概念為「手冊翻閱」引導方式
- 區域解鎖逐步揭示世界觀
- 通過區域主題變化保持新鮮感

### 關鍵洞察（VoxCards 可用）
1. **三層材質系統**：Canvas/Gold+Glass/Embers 的分層概念，VoxCards 可設計 Matte/Metal/Holographic 三級
2. **主色中性，留白給稀有度**：背景保持深色中性，讓卡牌的稀有度色彩成為最亮眼的元素
3. **Beaufort 襯線體的權威感**：VoxCards 的 Rajdhani 字體也是半襯線(semi-serif)，類似策略
4. **1000+ 卡牌的模板化設計**：卡牌框架必須高度系統化才能規模化

---

## 6. 跨遊戲稀有度色彩體系對比

### 業界標準（Blizzard/WoW 奠定）
| 稀有度 | Blizzard 標準 | Fortnite | Genshin | DotA 2 |
|--------|-------------|----------|---------|--------|
| Common | 白/灰 | 灰 | 灰藍 #85949C | 藍灰 |
| Uncommon | 綠 | 綠 | 綠 #649C74 | 淺藍 |
| Rare | 藍 | 藍 | 青藍 #54A4B4 | 藍 |
| Epic | 紫 | 紫 | 紫 #9174A9 | 紫 |
| Legendary | 橘/金 | 黃/金 | 金 #DCA454 | 粉紅 |
| Mythic | — | — | — | 金 |

### 關鍵規律
1. **冷色 → 暖色遞進**：灰→綠→藍→紫→橘/金，色彩溫度隨稀有度上升
2. **飽和度遞進**：低稀有度灰暗，高稀有度鮮豔飽和
3. **紫色是「Epic」的通用色**：幾乎所有遊戲都用紫色標記 Epic 級
4. **金色 = 最高級**：金色在所有文化中都代表「最頂級」
5. **Hearthstone 用寶石，Pokemon 用符號+邊框**：色彩之外的輔助指示很重要

### VoxCards 建議色值
基於業界共識，為 VoxCards 6 階稀有度建議：

| 稀有度 | 建議 Hex | 色調 | 參考 |
|--------|---------|------|------|
| Common | #B0B8C0 | 冷灰 | 低飽和，不搶注意力 |
| Uncommon | #4CAF7A | 翠綠 | 自然、成長感 |
| Rare | #4A9ED6 | 天藍 | 清澈、價值感起步 |
| Epic | #9B59B6 | 皇紫 | 高貴、稀有感 |
| Legendary | #F0A030 | 琥珀金 | 溫暖、珍貴 |
| Mythic | #E84040 | 深紅 | 危險、禁忌、Von Restorff（暗卡反差） |

---

## 7. 暗色主題 UI 最佳實踐

### 基礎原則
| 原則 | 具體做法 |
|------|---------|
| **不用純黑** | 用深灰 #121212（Material Design 推薦）或深藍黑 #0A0E1A |
| **不用純白文字** | 用微暖灰白 #E0E0E0 ~ #F0EDED，避免視覺震顫 |
| **避免飽和色** | 在暗色表面上，飽和色會「視覺震動(vibrate)」，用降飽和版本 |
| **對比度標準** | 正文文字 ≥ 4.5:1，大標題 ≥ 3:1（WCAG） |
| **60-30-10 法則** | 60% 主色(暗色背景) + 30% 次色(面板/容器) + 10% 強調色(金色/CTA) |

### 玻璃擬態(Glassmorphism)在暗色 UI 中的應用
- **背景模糊(backdrop blur)** + **半透明背景(10~30% 不透明度)** = 玻璃面板
- **關鍵**：必須有分層環境(layered environment)，否則玻璃效果會塌為普通半透明
- **暗色模式調整**：用深色染色(tint)替代白色，加入微妙的有色邊緣（海軍藍、紫、青）
- **文字可讀性**：在玻璃面板上加半透明固色覆蓋層(10-30% opacity solid overlay)

### 光線方向一致性
- **單一光源方向**：所有面板的高光和陰影必須對齊
- **Marvel Snap 做法**：光從上方投射，按鈕上緣有亮邊
- **LoR 做法**：金色元素的光澤方向一致

### 深色面板層級
```
層級 0 (最深): 主背景          — #0A0E1A (接近純黑的深藍)
層級 1: 內容區域              — #141824 (稍亮的深藍)
層級 2: 卡片/面板             — #1E2436 (可見的暗色容器)
層級 3: 懸浮/彈出             — #283048 (最亮的暗色)
層級 4: 互動元素              — 帶色彩的元素(按鈕、標籤)
層級 5: 焦點元素              — 發光/金色(CTA、稀有卡牌)
```

---

## 8. VoxCards 可落地設計建議

### 8.1 整體視覺策略
結合五款遊戲的精華，為 VoxCards 建議的視覺方向：

**「暗夜工坊 (Dark Forge)」**——在黑暗中鍛造光之卡牌
- 取 Marvel Snap 的「光作為 UI」+ Hearthstone 的「物理觸感」
- 背景：深藍黑(不是純黑)，帶微妙粒子漂浮
- 卡牌：唯一的「光源」——稀有度越高，光越強
- 按鈕：半透明玻璃 + 邊緣發光，不是實心色塊

### 8.2 色彩系統建議
```
// 背景層級
$bg-deepest:     #0B0E16;   // 最深背景（近純黑帶藍）
$bg-primary:     #121826;   // 主要內容區
$bg-secondary:   #1A2236;   // 面板/卡片容器
$bg-elevated:    #243048;   // 懸浮面板/彈出層
$bg-glass:       rgba(26, 34, 54, 0.7);  // 玻璃面板底色

// 文字層級
$text-primary:   #F0EDED;   // 主文字（微暖灰白，非純白）
$text-secondary: #8B95A8;   // 次要文字（藍灰）
$text-tertiary:  #5A6478;   // 輔助文字（暗灰）
$text-gold:      #D4AF37;   // 金色強調文字

// 稀有度色彩
$rarity-common:    #B0B8C0;
$rarity-uncommon:  #4CAF7A;
$rarity-rare:      #4A9ED6;
$rarity-epic:      #9B59B6;
$rarity-legendary: #F0A030;
$rarity-mythic:    #E84040;

// 功能色
$accent-primary:   #4A9ED6;  // 主強調（操作、連結）
$accent-cta:       #F0A030;  // CTA 按鈕（金色系）
$accent-success:   #4CAF7A;  // 成功
$accent-warning:   #F0A030;  // 警告
$accent-danger:    #E84040;  // 危險/錯誤
```

### 8.3 字體層級建議
已選定的字體搭配 (Rajdhani + Noto Sans TC + Barlow Condensed) 的使用層級：

| 元素 | 字體 | 字重 | 大小建議 | 備註 |
|------|------|------|---------|------|
| 卡牌名稱 | Rajdhani | Bold (700) | 18-24sp | 半襯線帶科幻感，類 LoR 的 Beaufort |
| 數值(攻防) | Barlow Condensed | Bold (700) | 28-36sp | 窄體數字，節省空間 |
| UI 標題 | Rajdhani | SemiBold (600) | 16-20sp | 功能區標題 |
| 正文/說明 | Noto Sans TC | Regular (400) | 14-16sp | 中文可讀性最佳 |
| 按鈕文字 | Rajdhani | SemiBold (600) | 14-16sp | 全大寫英文/中文 |
| 輔助文字 | Noto Sans TC | Light (300) | 12-13sp | 時間戳、次要資訊 |
| 稀有度標籤 | Barlow Condensed | SemiBold (600) | 10-12sp | 全大寫字母間距加寬 |

### 8.4 按鈕設計系統

**主要 CTA (Play/戰鬥/生成)**
```
背景: 金色漸層 linear-gradient(135deg, #D4AF37, #F0C854)
邊框: 1px solid rgba(212, 175, 55, 0.5)
圓角: 12px
陰影: 0 0 20px rgba(212, 175, 55, 0.3)  // 外發光
文字: #0B0E16 (深色字在金色底上)
```

**次要按鈕**
```
背景: rgba(26, 34, 54, 0.8)  // 半透明深色
邊框: 1px solid rgba(74, 158, 214, 0.3)  // 微妙藍色邊
圓角: 8px
文字: #F0EDED
hover: 邊框亮度提升，加微妙外發光
```

**幽靈按鈕 (Ghost)**
```
背景: transparent
邊框: 1px solid rgba(240, 237, 237, 0.2)
文字: #8B95A8
hover: 背景出現 rgba(255,255,255,0.05)
```

### 8.5 面板/容器設計

**標準內容面板**
```
背景: $bg-secondary (#1A2236)
邊框: 1px solid rgba(255, 255, 255, 0.06)
圓角: 16px
內距: 16-20px
```

**玻璃面板 (用於疊加層)**
```
背景: rgba(26, 34, 54, 0.7)
backdrop-filter: blur(20px)
邊框: 1px solid rgba(255, 255, 255, 0.08)
圓角: 20px
```

**卡牌展示面板 (高級)**
```
背景: radial-gradient(ellipse at center, #1A2236, #0B0E16)
邊框: 1px solid rgba(212, 175, 55, 0.15)  // 微金邊
圓角: 24px
陰影: inset 0 1px 0 rgba(255,255,255,0.05)  // 頂部亮線
```

### 8.6 卡牌生成/揭示動畫建議（結合各遊戲精華）

參考 Genshin 的祈願 + Hearthstone 的開包 + Marvel Snap 的升級：

**Phase 1 — 期待建立 (2秒)**
- 深黑背景 + 微弱粒子漂浮（類原神星空）
- 玩家的照片 + 咒語文字浮現又消散
- 音效：低沉蓄力聲

**Phase 2 — 命運暗示 (1-2秒)**
- 光球從畫面中心形成
- **色彩暗示稀有度**（類原神流星變色）：
  - 灰白光 → Common
  - 綠光閃現 → Uncommon
  - 藍光脈衝 → Rare
  - 紫光漩渦 → Epic
  - 金光爆發 → Legendary
  - 光突然熄滅，然後暗紅裂縫 → Mythic
- 音效隨稀有度升級（類 Hearthstone 酒館老闆的反應層級）

**Phase 3 — 卡牌揭示 (1-2秒)**
- 卡牌從光中凝聚成形
- 自動播放該稀有度的特效（全息/金粒子等）
- 高稀有度(Epic+)：全螢幕接管 + 震動 + 環境光變化

**Phase 4 — 展示與互動 (無限)**
- 卡牌懸浮展示，支持陀螺儀互動（Epic+）
- 底部顯示卡牌屬性
- 「分享」按鈕突出（利用病毒傳播）

### 8.7 首次體驗 (FTUE) 建議

結合 Marvel Snap 和業界最佳實踐：

1. **前 60 秒**：只展示核心循環（拍照→念咒→獲得卡牌），隱藏所有複雜系統
2. **首張卡牌保底 Rare**：確保首次體驗就能看到不錯的視覺效果
3. **語言重構**：失敗不叫「失敗」——如果照片品質低，說「這張照片中的魔力較為微弱...」
4. **漸進式揭示**：戰鬥系統、收藏系統、社交功能在第 2-5 次遊戲逐步解鎖
5. **空狀態設計**：卡牌收藏為空時，顯示一張半透明的幻影卡牌 + 「去創造你的第一張卡牌吧」的引導

---

## 參考來源

### Marvel Snap
- [Marvel Snap UI Design — Tiffany Smart](https://www.tiffanysmart.com/work/marvel-snap)
- [SNAPPY U.I. — Andrew Hutcheson (ArtStation)](https://www.artstation.com/artwork/GemNDd)
- [Marvel Snap UI/UX Case Study — Medium](https://medium.com/design-bootcamp/marvels-snap-ui-ux-case-study-9f727d8f3875)
- [Behind the Design: Marvel Snap — Apple Developer](https://developer.apple.com/news/?id=sosm2p7q)
- [Game UI Database — Marvel Snap](https://www.gameuidatabase.com/gameData.php?id=1785)
- [Marvel Snap Card Rarity Guide — Marvel Snap Zone](https://marvelsnapzone.com/marvel-snap-card-rarity-guide/)
- [Infinity Splits — Marvel Snap Zone](https://marvelsnapzone.com/infinity-splits/)

### Hearthstone
- [Rarity — Hearthstone Wiki](https://hearthstone.fandom.com/wiki/Rarity)
- [Card Pack — Hearthstone Wiki](https://hearthstone.fandom.com/wiki/Card_pack)
- [Golden Card — Hearthstone Wiki](https://hearthstone.fandom.com/wiki/Golden_card)
- [Hearthside Chat: Golden Cards — Blizzard](https://playhearthstone.com/en-us/blog/18053404/)
- [Design and Development — Hearthstone Wiki](https://hearthstone.fandom.com/wiki/Design_and_development_of_Hearthstone)
- [Hearthstone Logo Colors — SchemeColor](https://www.schemecolor.com/hearthstone-logo-colors.php)
- [Designing Hearthstone Card Packs — TouchArcade](https://toucharcade.com/2017/04/04/designing-hearthstone-card-packs-animations-iterations-ungoro-and-more-with-art-director-ben-thompson/)
- [Game UI Database — Hearthstone](https://www.gameuidatabase.com/gameData.php?id=628)

### Genshin Impact
- [Typeface — Genshin Impact Wiki](https://genshin-impact.fandom.com/wiki/Typeface)
- [Quality — Genshin Impact Wiki](https://genshin-impact.fandom.com/wiki/Quality)
- [Wish — Genshin Impact Wiki](https://genshin-impact.fandom.com/wiki/Wish)
- [Genshin Impact UI Color Palette — ColorsWall](https://colorswall.com/palette/143096)
- [Genshincolor Template — Moegirlpedia](https://en.moegirl.org.cn/Template:Genshincolor)
- [Game UI Database — Genshin Impact](https://www.gameuidatabase.com/gameData.php?id=470)

### Pokemon TCG
- [Immersive Card — Bulbapedia](https://bulbapedia.bulbagarden.net/wiki/Immersive_card_(TCG_Pocket))
- [Pokemon Cards CSS Holographic Effect — simeydotme](https://poke-holo.simey.me/)
- [Pokemon Card Holo Effect — CodePen](https://codepen.io/simeydotme/pen/PrQKgo)
- [Pokemon TCG Pocket Card Rarity Guide — Sportskeeda](https://www.sportskeeda.com/pokemon/pokemon-tcg-pocket-card-rarity-guide)
- [Holographic Cards in React Native using Skia — Medium](https://medium.com/@jerinjohnk/shiny-holographic-cards-in-react-native-using-skia-81a334fa182d)

### Legends of Runeterra
- [LoR Typography & Color Palette — Aaron Sather (Dribbble)](https://dribbble.com/shots/11421394-LoR-Typography-Color-Palette)
- [Legends of Runeterra — Pentagram](https://www.pentagram.com/work/legends-of-runeterra/story)
- [Legends of Runeterra Case Study — Ryan Odon](https://www.ryanodon.com/case-studies/legends-of-runeterra)
- [LoR Visual Identity — Behance](https://www.behance.net/gallery/125951493/Legends-of-Runeterra-Visual-Identity)
- [Legends of Runeterra UI Elements — Dribbble](https://dribbble.com/shots/18750848-Legends-of-Runeterra-UI-Elements)
- [Bringing Features to Life in LoR — Riot Games Technology](https://technology.riotgames.com/news/bringing-features-life-legends-runeterra)

### 通用 UI 設計
- [Dark UI Design Principles — Toptal](https://www.toptal.com/designers/ui/dark-ui-design)
- [Glassmorphism: Definition and Best Practices — NN/g](https://www.nngroup.com/articles/glassmorphism/)
- [Glassmorphism UI Features — UXPilot](https://uxpilot.ai/blogs/glassmorphism-ui)
- [Color-Coded Item Tiers — TV Tropes](https://tvtropes.org/pmwiki/pmwiki.php/Main/ColorCodedItemTiers)
- [Dark Theme Mobile UI Best Practices — Hakuna Matata Tech](https://www.hakunamatatatech.com/our-resources/blog/mobile-app-dark-theme-best-practices)
- [Colors in Game UI — Dakota Galayde](https://www.galaydegames.com/blog/colors-i)
