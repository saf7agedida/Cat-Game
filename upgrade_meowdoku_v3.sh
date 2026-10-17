#!/usr/bin/env bash
set -e

echo "🚀 جاري ترقية اللعبة إلى الإصدار الثالث (دعم البروفايلات، اللغتين، الأنيميشن، والضغط المزدوج)..."
cd /workspaces/Cat-Game

# 1. تحديث ملف www/index.html
cat << 'HTML_EOF' > www/index.html
<!DOCTYPE html>
<html lang="ar" dir="rtl" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#fcf7f2">
    <title>Meowdoku</title>
    <link rel="manifest" href="manifest.json">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="app-container">
        <!-- Top Header -->
        <header class="top-bar">
            <button id="back-btn" class="circle-icon-btn" title="Back">🏠</button>
            <div class="top-stats" id="top-game-stats" style="display:none;">
                <div class="stat-col">
                    <span class="stat-label" data-i18n="level">Level</span>
                    <span id="level-num-display" class="stat-val">1</span>
                </div>
                <div class="stat-col">
                    <span class="stat-label" data-i18n="score">Score</span>
                    <span id="score-display" class="stat-val">0</span>
                </div>
            </div>
            <div id="top-home-title" class="top-brand-title">Meowdoku 🐾</div>
            <button id="settings-btn" class="circle-icon-btn" title="Settings">⚙️</button>
        </header>

        <!-- 1. HOME SCREEN -->
        <main id="home-screen" class="screen active">
            <div class="home-hero-card">
                <div class="active-profile-badge" id="home-profile-card">
                    <img id="home-profile-img" src="assets/cats/main_cat.svg" alt="Avatar" class="home-avatar">
                    <div class="home-profile-info">
                        <span class="welcome-sub" data-i18n="welcomePlayer">مرحباً بالبطل:</span>
                        <h2 id="home-profile-name">القطة اللطيفة</h2>
                    </div>
                    <button id="quick-swap-btn" class="swap-pill-btn" data-i18n="changeProfile">تبديل 👥</button>
                </div>

                <div class="home-stats-row">
                    <div class="home-stat-box">
                        <span data-i18n="currentLevel">المستوى الحالي</span>
                        <strong id="home-lvl-val">1</strong>
                    </div>
                    <div class="home-stat-box">
                        <span data-i18n="totalScore">مجموع النقاط</span>
                        <strong id="home-score-val">0</strong>
                    </div>
                </div>

                <div class="home-actions">
                    <button id="play-now-btn" class="big-play-btn">
                        ▶️ <span data-i18n="playNow">العب الآن</span>
                    </button>
                    <button id="open-levels-btn" class="home-sec-btn">
                        🗺️ <span data-i18n="levelsMap">خريطة المستويات (1 - 120)</span>
                    </button>
                    <button id="open-settings-home-btn" class="home-sec-btn">
                        ⚙️ <span data-i18n="settingsAndProfiles">الإعدادات والبروفايلات</span>
                    </button>
                </div>
            </div>
        </main>

        <!-- 2. LEVELS MAP SCREEN -->
        <main id="level-screen" class="screen">
            <div class="levels-header-card">
                <h2 data-i18n="levelsMap">🐾 خريطة المستويات (1 - 120)</h2>
                <p data-i18n="rulesSummary">ضع قطة أو صورة واحدة في كل منطقة لونية، وفي كل صف وعمود، بدون تلامس!</p>
            </div>
            <div id="levels-grid" class="levels-grid"></div>
        </main>

        <!-- 3. GAME SCREEN -->
        <main id="game-screen" class="screen">
            <!-- Cat Silhouettes Bar + 3 Golden Fishes -->
            <div class="status-strip">
                <div id="cat-silhouettes-bar" class="silhouettes-pill"></div>
                <div id="lives-bar" class="lives-pill">
                    <span class="fish-icon">🐟</span>
                    <span class="fish-icon">🐟</span>
                    <span class="fish-icon">🐟</span>
                </div>
            </div>

            <!-- 3 Visual Rules Cards -->
            <div class="rules-strip" dir="ltr">
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span>✕</span><span>✕</span>
                        <span>✕</span><span class="mini-cat">🐱</span><span></span>
                        <span>✕</span><span></span><span></span>
                    </div>
                    <div class="rule-text" data-i18n="rule1">1 Cat per<br>color</div>
                </div>
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span class="mini-cat">🐱</span><span>✕</span>
                        <span></span><span>✕</span><span></span>
                        <span></span><span>✕</span><span></span>
                    </div>
                    <div class="rule-text" data-i18n="rule2">1 Cat per<br>column and<br>row</div>
                </div>
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span>✕</span><span>✕</span>
                        <span>✕</span><span class="mini-cat">🐱</span><span>✕</span>
                        <span>✕</span><span>✕</span><span>✕</span>
                    </div>
                    <div class="rule-text" data-i18n="rule3">Cats cannot<br>touch</div>
                </div>
            </div>

            <!-- Color Regions Board -->
            <div class="board-card">
                <div id="regions-board" class="regions-board" dir="ltr"></div>
            </div>

            <!-- Tap instruction hint -->
            <div class="tap-guide" data-i18n="tapGuide">
                ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع القطة / الصورة</strong>
            </div>

            <!-- 3 Bottom Boosters -->
            <div class="boosters-bar" dir="ltr">
                <button id="booster-cat" class="booster-btn">
                    <img id="booster-cat-img" src="assets/cats/main_cat.svg" alt="Cat" class="booster-img">
                    <span id="badge-cat" class="booster-badge">7</span>
                </button>
                <button id="booster-hint" class="booster-btn">
                    <span class="booster-emoji">💡</span>
                    <span id="badge-hint" class="booster-badge">9</span>
                </button>
                <button id="booster-mouse" class="booster-btn">
                    <span class="booster-emoji">🐭</span>
                    <span id="badge-mouse" class="booster-badge">2</span>
                </button>
            </div>
        </main>

        <!-- STARTUP / SWAP PROFILE PICKER MODAL -->
        <div id="profile-picker-modal" class="modal">
            <div class="modal-content profile-picker-box">
                <h2 data-i18n="whoIsPlaying">👋 من سيلعب اليوم؟</h2>
                <p class="modal-sub-text" data-i18n="chooseProfileSub">اختر البروفايل الخاص بك للبدء بصورتك وأصواتك:</p>
                <div id="startup-profiles-grid" class="startup-profiles-grid"></div>
                <div class="modal-footer">
                    <button id="add-profile-from-picker-btn" class="secondary-btn" data-i18n="addNewProfile">➕ إضافة طفل جديد</button>
                </div>
            </div>
        </div>

        <!-- SETTINGS & PROFILES MODAL -->
        <div id="settings-modal" class="modal">
            <div class="modal-content settings-box">
                <div class="modal-header">
                    <h2 data-i18n="settingsTitle">⚙️ الإعدادات والبروفايلات</h2>
                    <button id="close-settings-btn" class="close-x">✖</button>
                </div>

                <!-- Language & General Toggles Bar -->
                <div class="lang-bar">
                    <span data-i18n="languageLabel">🌐 اللغة / Language:</span>
                    <div class="lang-btns">
                        <button id="lang-ar-btn" class="lang-btn active">العربية</button>
                        <button id="lang-en-btn" class="lang-btn">English</button>
                    </div>
                </div>

                <div class="settings-tabs">
                    <button class="tab-btn active" data-tab="tab-profiles" data-i18n="tabProfiles">👥 البروفايلات</button>
                    <button class="tab-btn" data-tab="tab-correct" data-i18n="tabCorrect">✅ أصوات الصح (6)</button>
                    <button class="tab-btn" data-tab="tab-wrong" data-i18n="tabWrong">❌ أصوات الخطأ (6)</button>
                </div>

                <!-- Tab 1: Profiles Management -->
                <div id="tab-profiles" class="tab-pane active">
                    <p class="tab-hint" data-i18n="profilesHint">اختر البروفايل النشط للعب، أو أضف بروفايل جديد لكل ابن بصورته وأصواته الخاصة:</p>
                    <div id="profiles-list-container" class="profiles-list"></div>

                    <!-- Create / Edit Kid Profile Form -->
                    <div class="new-profile-card">
                        <h3 id="profile-form-title" data-i18n="addKidProfileTitle">➕ إضافة / تعديل بروفايل طفل</h3>
                        <div class="form-row">
                            <img id="new-profile-preview" src="assets/cats/main_cat.svg" class="form-avatar-preview" alt="Preview">
                            <div class="form-inputs">
                                <input type="text" id="new-profile-name" placeholder="اسم الطفل (مثال: سيف)" class="text-input">
                                <label class="upload-main-btn">
                                    📸 <span data-i18n="choosePhoto">اختر صورة الوجه</span>
                                    <input type="file" id="new-profile-photo-input" accept="image/*" style="display:none;">
                                </label>
                            </div>
                        </div>
                        <button id="save-new-profile-btn" class="primary-btn full-w" data-i18n="saveProfileBtn">حفظ البروفايل وتفعيله ✨</button>
                    </div>

                    <div class="toggle-row" style="margin-top:10px;">
                        <label>
                            <input type="checkbox" id="auto-x-toggle" checked>
                            <span data-i18n="autoXLabel">وضع علامات (✕) تلقائياً حول القطة/الصورة الصحيحة</span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <label>
                            <input type="checkbox" id="sound-toggle" checked>
                            <span data-i18n="soundToggleLabel">تشغيل المؤثرات الصوتية 🔊</span>
                        </label>
                    </div>
                </div>

                <!-- Tab 2: Up to 6 Correct Sounds (for Active Profile) -->
                <div id="tab-correct" class="tab-pane">
                    <div class="active-prof-banner">
                        <span data-i18n="editingSoundsFor">تخصيص أصوات البروفايل النشط:</span>
                        <strong id="correct-tab-prof-name"></strong>
                    </div>
                    <p class="tab-hint" data-i18n="correctSoundsHint">أضف حتى 6 صوتيات تعمل عشوائياً عند وضع الصورة في المكان الصحيح:</p>
                    <div id="correct-audio-list" class="audio-list"></div>
                </div>

                <!-- Tab 3: Up to 6 Wrong Sounds (for Active Profile) -->
                <div id="tab-wrong" class="tab-pane">
                    <div class="active-prof-banner">
                        <span data-i18n="editingSoundsFor">تخصيص أصوات البروفايل النشط:</span>
                        <strong id="wrong-tab-prof-name"></strong>
                    </div>
                    <p class="tab-hint" data-i18n="wrongSoundsHint">أضف حتى 6 صوتيات تعمل عشوائياً عند وضع الصورة في مكان خاطئ:</p>
                    <div id="wrong-audio-list" class="audio-list"></div>
                </div>

                <div class="modal-footer">
                    <button id="save-close-btn" class="primary-btn" data-i18n="doneBtn">تم ✅</button>
                </div>
            </div>
        </div>

        <!-- Win Modal -->
        <div id="win-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">😻 🎉 🏆</div>
                <h2><span data-i18n="levelComplete">أحسنت! اكتمل المستوى</span> <span id="win-level-num"></span></h2>
                <p class="win-score-line"><span data-i18n="score">النقاط</span>: <strong id="win-score-val">0</strong></p>
                <div class="modal-footer">
                    <button id="next-level-btn" class="primary-btn" data-i18n="nextLevel">المستوى التالي ⬅️</button>
                </div>
            </div>
        </div>

        <!-- Lose Modal -->
        <div id="lose-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">😿 🐟</div>
                <h2 data-i18n="outOfFishes">انتهت السمكات الثلاث!</h2>
                <p class="win-score-line" data-i18n="loseHint">حاول مرة أخرى وتذكر عدم وضع قطتين في نفس اللون أو الصف أو العمود.</p>
                <div class="modal-footer">
                    <button id="retry-level-btn" class="primary-btn" data-i18n="retryBtn">إعادة المحاولة 🔄</button>
                </div>
            </div>
        </div>

        <!-- Exit Toast Notification -->
        <div id="exit-toast" class="exit-toast">اضغط رجوع مرة أخرى للخروج</div>
    </div>

    <script src="script.js"></script>
</body>
</html>
HTML_EOF

# 2. تحديث ملف www/style.css (مع أنيميشن للصح والخطأ وعلامة X وشاشة البروفايلات)
cat << 'CSS_EOF' > www/style.css
:root {
    --bg-main: #fcf7f2;
    --card-bg: #ffffff;
    --brown-text: #7d5a50;
    --brown-dark: #5c3d36;
    --pill-bg: #ffffff;
    --rule-bg: #f9f1ea;
    --accent: #e58e73;
    --green-ok: #2ecc71;
    --red-err: #e74c3c;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    user-select: none;
    -webkit-tap-highlight-color: transparent;
}

body {
    background-color: var(--bg-main);
    color: var(--brown-text);
    display: flex;
    justify-content: center;
    min-height: 100vh;
    overflow-x: hidden;
}

.app-container {
    width: 100%;
    max-width: 480px;
    padding: 12px 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Header */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 2px;
}

.top-brand-title {
    font-size: 1.4rem;
    font-weight: 800;
    color: var(--brown-dark);
}

.circle-icon-btn {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: var(--card-bg);
    border: none;
    box-shadow: 0 3px 10px rgba(125, 90, 80, 0.12);
    font-size: 1.25rem;
    color: var(--brown-text);
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: transform 0.15s;
}
.circle-icon-btn:active { transform: scale(0.9); }

.top-stats {
    display: flex;
    gap: 32px;
    text-align: center;
}
.stat-col { display: flex; flex-direction: column; }
.stat-label { font-size: 0.9rem; color: #9c7a70; font-weight: 600; }
.stat-val { font-size: 1.5rem; font-weight: 800; color: var(--brown-dark); line-height: 1.1; }

.screen { display: none; flex-direction: column; gap: 10px; }
.screen.active { display: flex; animation: fadeInScreen 0.25s ease; }

@keyframes fadeInScreen {
    from { opacity: 0; transform: translateY(6px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Home Screen */
.home-hero-card {
    background: var(--card-bg);
    border-radius: 24px;
    padding: 20px;
    box-shadow: 0 6px 20px rgba(125, 90, 80, 0.08);
    display: flex;
    flex-direction: column;
    gap: 18px;
    margin-top: 8px;
}

.active-profile-badge {
    display: flex;
    align-items: center;
    gap: 12px;
    background: var(--rule-bg);
    padding: 12px 14px;
    border-radius: 18px;
}

.home-avatar {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid var(--accent);
    background: #fff;
    flex-shrink: 0;
}

.home-profile-info {
    flex: 1;
}
.welcome-sub { font-size: 0.8rem; color: #9c7a70; }
.home-profile-info h2 { font-size: 1.2rem; color: var(--brown-dark); }

.swap-pill-btn {
    background: var(--card-bg);
    border: 2px solid #e2d1c8;
    padding: 7px 12px;
    border-radius: 12px;
    font-weight: bold;
    font-size: 0.8rem;
    color: var(--brown-dark);
    cursor: pointer;
}

.home-stats-row {
    display: flex;
    gap: 12px;
}
.home-stat-box {
    flex: 1;
    background: #fdfaf7;
    border: 1.5px solid #f0e4dc;
    border-radius: 16px;
    padding: 12px;
    text-align: center;
    display: flex;
    flex-direction: column;
    gap: 4px;
}
.home-stat-box span { font-size: 0.8rem; color: #9c7a70; }
.home-stat-box strong { font-size: 1.45rem; color: var(--brown-dark); }

.home-actions {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.big-play-btn {
    background: var(--accent);
    color: #fff;
    border: none;
    padding: 15px;
    border-radius: 16px;
    font-size: 1.15rem;
    font-weight: 800;
    cursor: pointer;
    box-shadow: 0 5px 15px rgba(229, 142, 115, 0.35);
    transition: transform 0.15s;
}
.big-play-btn:active { transform: scale(0.96); }

.home-sec-btn {
    background: var(--rule-bg);
    color: var(--brown-dark);
    border: none;
    padding: 13px;
    border-radius: 14px;
    font-size: 0.95rem;
    font-weight: 700;
    cursor: pointer;
}

/* Status Strip: Cat Silhouettes + 3 Fishes */
.status-strip {
    display: flex;
    gap: 8px;
    align-items: center;
    justify-content: space-between;
    direction: ltr;
}

.silhouettes-pill {
    flex: 1;
    background: var(--pill-bg);
    padding: 7px 12px;
    border-radius: 30px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.04);
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 5px;
    min-height: 42px;
}

.cat-sil {
    width: 24px;
    height: 24px;
    opacity: 0.32;
    transform: scale(0.9);
    transition: all 0.3s cubic-bezier(0.18, 0.89, 0.32, 1.28);
}
.cat-sil.found {
    opacity: 1;
    transform: scale(1.15);
    filter: drop-shadow(0 2px 3px rgba(0,0,0,0.2));
}

.lives-pill {
    background: var(--pill-bg);
    padding: 7px 12px;
    border-radius: 30px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.04);
    display: flex;
    gap: 4px;
    align-items: center;
    min-height: 42px;
}

.fish-icon {
    font-size: 1.25rem;
    transition: all 0.35s ease;
}
.fish-icon.lost {
    opacity: 0.2;
    filter: grayscale(100%);
    transform: scale(0.75) rotate(-20deg);
}

/* 3 Rules Strip */
.rules-strip {
    background: var(--card-bg);
    padding: 8px;
    border-radius: 18px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.03);
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 6px;
}

.rule-card {
    background: var(--rule-bg);
    border-radius: 12px;
    padding: 6px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.mini-grid {
    display: grid;
    grid-template-columns: repeat(3, 13px);
    grid-template-rows: repeat(3, 13px);
    gap: 1.5px;
    flex-shrink: 0;
}
.mini-grid span {
    background: #bfa59b;
    border-radius: 2px;
    font-size: 8px;
    color: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
}
.mini-grid span.mini-cat { background: #7d5a50; font-size: 9px; }
.rule-text { font-size: 0.68rem; font-weight: 700; color: var(--brown-text); line-height: 1.15; }

/* Board & Tiles with Enhanced Animations */
.board-card {
    background: var(--card-bg);
    padding: 12px;
    border-radius: 24px;
    box-shadow: 0 6px 20px rgba(125, 90, 80, 0.08);
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
}

.regions-board {
    display: grid;
    width: 100%;
    aspect-ratio: 1 / 1;
    gap: 5px;
}

.tile {
    border-radius: 9px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    position: relative;
    transition: transform 0.12s ease, box-shadow 0.2s ease;
    box-shadow: inset 0 -2px 0 rgba(0,0,0,0.08);
    overflow: visible;
}

/* X Mark Animations */
.tile-x {
    font-size: 1.2rem;
    font-weight: 900;
    color: rgba(60, 40, 35, 0.62);
    pointer-events: none;
    animation: xPopIn 0.22s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}

.tile-x.removing {
    animation: xPopOut 0.18s ease-in forwards;
}

@keyframes xPopIn {
    0% { transform: scale(0.2) rotate(-45deg); opacity: 0; }
    70% { transform: scale(1.25) rotate(8deg); opacity: 1; }
    100% { transform: scale(1) rotate(0deg); opacity: 1; }
}

@keyframes xPopOut {
    0% { transform: scale(1) rotate(0deg); opacity: 1; }
    100% { transform: scale(0.1) rotate(45deg); opacity: 0; }
}

/* Cat / Kid Photo Correct Placement Animation */
.tile-avatar {
    width: 84%;
    height: 84%;
    border-radius: 50%;
    object-fit: cover;
    pointer-events: none;
    filter: drop-shadow(0 3px 5px rgba(0,0,0,0.25));
    animation: catBounceIn 0.42s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}
.tile-avatar.kid-mode {
    border: 2.5px solid #ffffff;
    background: #fff;
}
.tile-avatar.removing {
    animation: xPopOut 0.18s ease-in forwards;
}

@keyframes catBounceIn {
    0% { transform: scale(0.2) translateY(10px); opacity: 0; }
    55% { transform: scale(1.22) translateY(-4px); opacity: 1; }
    75% { transform: scale(0.92) translateY(1px); }
    100% { transform: scale(1) translateY(0); opacity: 1; }
}

.tile.correct-glow {
    animation: correctTilePulse 0.55s ease-out;
}

@keyframes correctTilePulse {
    0% { box-shadow: 0 0 0 0 rgba(46, 204, 113, 0.85); }
    70% { box-shadow: 0 0 0 12px rgba(46, 204, 113, 0); }
    100% { box-shadow: 0 0 0 0 rgba(46, 204, 113, 0); }
}

/* Wrong Placement Shake & Red Flash Animation */
.tile.error-shake {
    animation: wrongShake 0.45s cubic-bezier(0.36, 0.07, 0.19, 0.97);
    background-color: #ff6b6b !important;
    outline: 3px solid #c0392b;
    z-index: 10;
}

@keyframes wrongShake {
    0%, 100% { transform: translateX(0) rotate(0); }
    20% { transform: translateX(-7px) rotate(-6deg); }
    40% { transform: translateX(7px) rotate(6deg); }
    60% { transform: translateX(-5px) rotate(-4deg); }
    80% { transform: translateX(5px) rotate(4deg); }
}

/* Floating Particles (Sparkles for Correct / Broken Fish for Wrong) */
.fx-particle {
    position: absolute;
    pointer-events: none;
    z-index: 50;
    font-size: 1rem;
    font-weight: bold;
    animation: floatParticle 0.75s ease-out forwards;
}

@keyframes floatParticle {
    0% { transform: translate(0, 0) scale(0.5); opacity: 1; }
    100% { transform: translate(var(--dx), var(--dy)) scale(1.25); opacity: 0; }
}

.fx-wrong-badge {
    position: absolute;
    top: -10px;
    left: 50%;
    transform: translateX(-50%);
    background: #e74c3c;
    color: #fff;
    padding: 2px 7px;
    border-radius: 10px;
    font-size: 0.75rem;
    font-weight: 900;
    white-space: nowrap;
    pointer-events: none;
    z-index: 60;
    box-shadow: 0 3px 8px rgba(0,0,0,0.25);
    animation: floatUpWrong 0.85s ease-out forwards;
}

@keyframes floatUpWrong {
    0% { transform: translate(-50%, 5px) scale(0.7); opacity: 1; }
    30% { transform: translate(-50%, -14px) scale(1.1); opacity: 1; }
    100% { transform: translate(-50%, -32px) scale(0.9); opacity: 0; }
}

.tile.hint-glow {
    animation: pulseGlow 0.8s infinite alternate;
    outline: 3px solid #f1c40f;
    z-index: 5;
}

@keyframes pulseGlow {
    from { transform: scale(0.94); }
    to { transform: scale(1.06); }
}

.tap-guide {
    text-align: center;
    font-size: 0.76rem;
    color: #9c7a70;
    background: var(--rule-bg);
    padding: 6px 10px;
    border-radius: 10px;
}

/* Boosters */
.boosters-bar {
    display: flex;
    justify-content: center;
    gap: 28px;
    margin-top: 2px;
}

.booster-btn {
    width: 62px;
    height: 62px;
    border-radius: 50%;
    background: var(--card-bg);
    border: none;
    box-shadow: 0 5px 15px rgba(125, 90, 80, 0.14);
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    cursor: pointer;
}
.booster-btn:active { transform: scale(0.92); }
.booster-img { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; }
.booster-emoji { font-size: 1.9rem; }
.booster-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    background: #d9534f;
    color: #fff;
    font-size: 0.76rem;
    font-weight: bold;
    min-width: 23px;
    height: 23px;
    padding: 0 5px;
    border-radius: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 2px solid var(--bg-main);
}

/* Levels Grid */
.levels-header-card {
    background: var(--card-bg);
    padding: 15px;
    border-radius: 18px;
    text-align: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.04);
}
.levels-header-card h2 { margin-bottom: 5px; color: var(--brown-dark); font-size: 1.15rem; }
.levels-header-card p { font-size: 0.82rem; line-height: 1.4; }

.levels-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
    gap: 8px;
    max-height: 70vh;
    overflow-y: auto;
    padding: 4px;
}

.lvl-btn {
    background: var(--card-bg);
    border: 2px solid #ebdcd4;
    border-radius: 14px;
    padding: 10px 4px;
    text-align: center;
    cursor: pointer;
    font-weight: bold;
    color: var(--brown-dark);
}
.lvl-btn.completed { background: #e8f8f5; border-color: #76d7c4; }
.lvl-btn.current { border-color: var(--accent); background: #fff5f0; }

/* Modals & Startup Profile Picker */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.55);
    justify-content: center;
    align-items: center;
    padding: 14px;
    z-index: 300;
}
.modal.active { display: flex; }

.modal-content {
    background: var(--card-bg);
    padding: 20px;
    border-radius: 24px;
    width: 100%;
    max-width: 380px;
    text-align: center;
    box-shadow: 0 12px 32px rgba(0,0,0,0.25);
    animation: fadeInScreen 0.2s ease;
}

.profile-picker-box { max-width: 420px; }
.modal-sub-text { font-size: 0.85rem; color: #9c7a70; margin: 6px 0 14px; }

.startup-profiles-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
    gap: 12px;
    max-height: 55vh;
    overflow-y: auto;
    padding: 4px;
}

.picker-card {
    background: var(--rule-bg);
    border: 2.5px solid transparent;
    border-radius: 18px;
    padding: 12px 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    transition: transform 0.15s, border-color 0.15s;
}
.picker-card:hover, .picker-card.active {
    border-color: var(--accent);
    background: #fff5f0;
    transform: translateY(-2px);
}
.picker-card img {
    width: 68px;
    height: 68px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #fff;
    box-shadow: 0 3px 8px rgba(0,0,0,0.12);
    background: #fff;
}
.picker-card strong {
    font-size: 0.9rem;
    color: var(--brown-dark);
}

/* Settings Modal */
.settings-box {
    max-width: 460px;
    max-height: 90vh;
    display: flex;
    flex-direction: column;
    text-align: start;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}
.modal-header h2 { font-size: 1.15rem; color: var(--brown-dark); }
.close-x { background: none; border: none; font-size: 1.3rem; cursor: pointer; color: var(--brown-text); }

.lang-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--rule-bg);
    padding: 8px 12px;
    border-radius: 12px;
    margin-bottom: 10px;
    font-size: 0.85rem;
    font-weight: bold;
}
.lang-btns { display: flex; gap: 6px; }
.lang-btn {
    padding: 5px 12px;
    border-radius: 8px;
    border: 1.5px solid #d5c3b8;
    background: #fff;
    cursor: pointer;
    font-weight: bold;
    font-size: 0.78rem;
}
.lang-btn.active {
    background: var(--brown-dark);
    color: #fff;
    border-color: var(--brown-dark);
}

.settings-tabs { display: flex; gap: 6px; margin-bottom: 10px; }
.tab-btn {
    flex: 1;
    padding: 8px 4px;
    font-size: 0.75rem;
    font-weight: bold;
    background: var(--rule-bg);
    border: none;
    border-radius: 10px;
    color: var(--brown-text);
    cursor: pointer;
}
.tab-btn.active { background: var(--brown-text); color: #fff; }

.tab-pane {
    display: none;
    overflow-y: auto;
    max-height: 52vh;
    padding: 2px;
}
.tab-pane.active { display: block; }

.profiles-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 12px;
}

.prof-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--rule-bg);
    padding: 8px 10px;
    border-radius: 14px;
    border: 2px solid transparent;
}
.prof-item.active {
    border-color: var(--accent);
    background: #fff5f0;
}
.prof-item-left {
    display: flex;
    align-items: center;
    gap: 10px;
}
.prof-item-left img {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    object-fit: cover;
    background: #fff;
    border: 2px solid var(--accent);
}
.prof-item-actions { display: flex; gap: 5px; }

.new-profile-card {
    background: #fff9f5;
    border: 2px dashed var(--accent);
    border-radius: 16px;
    padding: 12px;
}
.new-profile-card h3 { font-size: 0.9rem; margin-bottom: 8px; color: var(--brown-dark); }
.form-row {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 10px;
}
.form-avatar-preview {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid var(--accent);
    background: #fff;
    flex-shrink: 0;
}
.form-inputs {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 6px;
}
.text-input {
    width: 100%;
    padding: 8px 10px;
    border-radius: 10px;
    border: 1.5px solid #decbc0;
    font-size: 0.85rem;
}
.upload-main-btn {
    display: inline-block;
    background: var(--brown-text);
    color: #fff;
    padding: 7px 12px;
    border-radius: 10px;
    font-weight: bold;
    font-size: 0.78rem;
    text-align: center;
    cursor: pointer;
}
.full-w { width: 100%; }

.active-prof-banner {
    background: #fff5f0;
    border: 1.5px solid var(--accent);
    padding: 8px 12px;
    border-radius: 10px;
    font-size: 0.82rem;
    margin-bottom: 8px;
}

.toggle-row {
    background: var(--rule-bg);
    padding: 9px 12px;
    border-radius: 12px;
    margin-bottom: 6px;
    font-size: 0.8rem;
    font-weight: 600;
}

.tab-hint { font-size: 0.78rem; margin-bottom: 8px; color: #8c6d62; }
.audio-list { display: flex; flex-direction: column; gap: 7px; }
.audio-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--rule-bg);
    padding: 7px 10px;
    border-radius: 12px;
    font-size: 0.78rem;
}
.audio-actions { display: flex; gap: 5px; }
.mini-btn {
    padding: 5px 9px;
    border-radius: 8px;
    border: none;
    font-size: 0.73rem;
    font-weight: bold;
    cursor: pointer;
}
.mini-btn.up { background: var(--brown-text); color: #fff; }
.mini-btn.play { background: #76d7c4; color: #1b4f35; }
.mini-btn.del { background: #f5b7b1; color: #78281f; }

.modal-big-icon { font-size: 2.4rem; margin-bottom: 6px; }
.win-score-line { margin: 8px 0 14px; font-size: 0.92rem; }
.modal-footer { display: flex; gap: 8px; margin-top: 12px; }
.primary-btn, .secondary-btn {
    flex: 1;
    padding: 11px;
    border-radius: 12px;
    border: none;
    font-weight: bold;
    cursor: pointer;
}
.primary-btn { background: var(--accent); color: #fff; }
.secondary-btn { background: var(--rule-bg); color: var(--brown-dark); }

.exit-toast {
    position: fixed;
    bottom: 24px;
    left: 50%;
    transform: translateX(-50%);
    background: rgba(44, 62, 80, 0.9);
    color: #fff;
    padding: 8px 18px;
    border-radius: 20px;
    font-size: 0.82rem;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.25s;
    z-index: 500;
}
.exit-toast.show { opacity: 1; }
CSS_EOF

# 3. تحديث ملف www/script.js (محرك البروفايلات، اللغتين، الضغط المزدوج، الأنيميشن، وزر الرجوع)
cat << 'JS_EOF' > www/script.js
const REGION_COLORS = [
    '#f2a66b', '#d9b650', '#add597', '#63ada5', '#79b5dc',
    '#a3b8cf', '#8b78ce', '#efb2c9', '#9a6d4c'
];
const TOTAL_LEVELS = 120;

// --- قاموس اللغتين العربية والإنجليزية ---
const I18N = {
    ar: {
        level: 'المستوى',
        score: 'النقاط',
        welcomePlayer: 'مرحباً بالبطل:',
        changeProfile: 'تبديل 👥',
        currentLevel: 'المستوى الحالي',
        totalScore: 'مجموع النقاط',
        playNow: 'العب الآن',
        levelsMap: 'خريطة المستويات (1 - 120)',
        settingsAndProfiles: 'الإعدادات والبروفايلات',
        rulesSummary: 'ضع قطة أو صورة واحدة في كل منطقة لونية، وفي كل صف وعمود، بدون تلامس!',
        rule1: 'قطة واحدة<br>بكل لون',
        rule2: 'قطة واحدة<br>بكل صف وعمود',
        rule3: 'القطط لا<br>تتلامس',
        tapGuide: 'ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع القطة / الصورة</strong>',
        whoIsPlaying: '👋 من سيلعب اليوم؟',
        chooseProfileSub: 'اختر البروفايل الخاص بك للبدء بصورتك وأصواتك:',
        addNewProfile: '➕ إضافة طفل جديد',
        settingsTitle: '⚙️ الإعدادات والبروفايلات',
        languageLabel: '🌐 اللغة / Language:',
        tabProfiles: '👥 البروفايلات',
        tabCorrect: '✅ أصوات الصح (6)',
        tabWrong: '❌ أصوات الخطأ (6)',
        profilesHint: 'اختر البروفايل النشط للعب، أو أضف بروفايل جديد لكل ابن بصورته وأصواته الخاصة:',
        addKidProfileTitle: '➕ إضافة بروفايل طفل جديد',
        choosePhoto: 'اختر صورة الوجه',
        saveProfileBtn: 'حفظ البروفايل وتفعيله ✨',
        autoXLabel: 'وضع علامات (✕) تلقائياً حول القطة/الصورة الصحيحة',
        soundToggleLabel: 'تشغيل المؤثرات الصوتية 🔊',
        editingSoundsFor: 'تخصيص أصوات البروفايل النشط:',
        correctSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند وضع الصورة في المكان الصحيح:',
        wrongSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند وضع الصورة في مكان خاطئ:',
        doneBtn: 'تم ✅',
        levelComplete: 'أحسنت! اكتمل المستوى',
        nextLevel: 'المستوى التالي ⬅️',
        outOfFishes: 'انتهت السمكات الثلاث!',
        loseHint: 'حاول مرة أخرى وتذكر عدم وضع قطتين في نفس اللون أو الصف أو العمود.',
        retryBtn: 'إعادة المحاولة 🔄',
        defaultCatName: 'القطة اللطيفة',
        activeTag: 'نشط ✓',
        selectTag: 'اختيار',
        soundSlotCorrect: 'صوت صح',
        soundSlotWrong: 'صوت خطأ',
        defaultSound: 'افتراضي',
        uploadSound: '📁 صوت',
        kidNamePlaceholder: 'اسم الطفل (مثال: سيف)',
        exitToastMsg: 'اضغط رجوع مرة أخرى للخروج'
    },
    en: {
        level: 'Level',
        score: 'Score',
        welcomePlayer: 'Welcome Hero:',
        changeProfile: 'Switch 👥',
        currentLevel: 'Current Level',
        totalScore: 'Total Score',
        playNow: 'Play Now',
        levelsMap: 'Levels Map (1 - 120)',
        settingsAndProfiles: 'Settings & Profiles',
        rulesSummary: 'Place 1 Cat/Photo per color region, row, and column without touching!',
        rule1: '1 Cat per<br>color',
        rule2: '1 Cat per<br>column and<br>row',
        rule3: 'Cats cannot<br>touch',
        tapGuide: '1 Tap = Toggle <strong>✕</strong> &nbsp;|&nbsp; Fast Double-Tap = <strong>Place Cat / Photo</strong>',
        whoIsPlaying: '👋 Who is playing today?',
        chooseProfileSub: 'Choose your profile to play with your photo & sounds:',
        addNewProfile: '➕ Add New Kid Profile',
        settingsTitle: '⚙️ Settings & Profiles',
        languageLabel: '🌐 Language / اللغة:',
        tabProfiles: '👥 Profiles',
        tabCorrect: '✅ Correct Audio (6)',
        tabWrong: '❌ Wrong Audio (6)',
        profilesHint: 'Select active profile to play, or create a new profile for each kid with their photo and sounds:',
        addKidProfileTitle: '➕ Add New Kid Profile',
        choosePhoto: 'Choose Face Photo',
        saveProfileBtn: 'Save & Activate Profile ✨',
        autoXLabel: 'Auto-place (✕) around correct Cat/Photo',
        soundToggleLabel: 'Enable Sound Effects 🔊',
        editingSoundsFor: 'Customizing sounds for active profile:',
        correctSoundsHint: 'Add up to 6 sounds played randomly when placing in the right spot:',
        wrongSoundsHint: 'Add up to 6 sounds played randomly when placing in a wrong spot:',
        doneBtn: 'Done ✅',
        levelComplete: 'Awesome! Completed Level',
        nextLevel: 'Next Level ➡️',
        outOfFishes: 'Out of 3 Fishes!',
        loseHint: 'Try again! Remember: 1 per color, row, and column, and no touching.',
        retryBtn: 'Try Again 🔄',
        defaultCatName: 'Cute Cat',
        activeTag: 'Active ✓',
        selectTag: 'Select',
        soundSlotCorrect: 'Correct',
        soundSlotWrong: 'Wrong',
        defaultSound: 'Default',
        uploadSound: '📁 Audio',
        kidNamePlaceholder: 'Kid Name (e.g. Saif)',
        exitToastMsg: 'Press back again to exit'
    }
};

// --- قاعدة بيانات IndexedDB لحفظ البروفايلات المتعددة بصورها وأصواتها ---
class StorageDB {
    constructor() { this.db = null; }
    init() {
        return new Promise((resolve) => {
            const req = indexedDB.open('MeowdokuProfilesDB_v3', 1);
            req.onupgradeneeded = (e) => {
                const db = e.target.result;
                if (!db.objectStoreNames.contains('store')) db.createObjectStore('store');
            };
            req.onsuccess = (e) => { this.db = e.target.result; resolve(); };
            req.onerror = () => resolve();
        });
    }
    set(key, val) {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('store', 'readwrite');
            tx.objectStore('store').put(val, key);
            tx.oncomplete = () => resolve();
        });
    }
    get(key) {
        return new Promise((resolve) => {
            if (!this.db) return resolve(null);
            const tx = this.db.transaction('store', 'readonly');
            const req = tx.objectStore('store').get(key);
            req.onsuccess = () => resolve(req.result || null);
            req.onerror = () => resolve(null);
        });
    }
}

const db = new StorageDB();

let appPrefs = {
    lang: localStorage.getItem('meow_lang') || 'ar',
    autoX: localStorage.getItem('meow_autox') !== 'false',
    soundEnabled: localStorage.getItem('meow_sound') !== 'false',
    activeProfileId: localStorage.getItem('meow_active_prof') || 'default_cat'
};

let profiles = [];

function createDefaultCatProfile() {
    return {
        id: 'default_cat',
        name: 'القطة اللطيفة',
        isDefaultCat: true,
        photo: 'assets/cats/main_cat.svg',
        correctSounds: {},
        wrongSounds: {},
        currentLevel: 1,
        score: 0,
        completed: {},
        boosters: { cat: 7, hint: 9, mouse: 2 }
    };
}

function getActiveProfile() {
    let p = profiles.find(x => x.id === appPrefs.activeProfileId);
    if (!p) {
        p = profiles[0];
        appPrefs.activeProfileId = p.id;
    }
    return p;
}

async function saveProfilesToDB() {
    await db.set('profiles_list', profiles);
    localStorage.setItem('meow_active_prof', appPrefs.activeProfileId);
}

// --- تطبيق اللغة (عربي / إنجليزي) ---
function applyLanguage(lang) {
    appPrefs.lang = lang;
    localStorage.setItem('meow_lang', lang);
    const htmlRoot = document.getElementById('html-root');
    htmlRoot.lang = lang;
    htmlRoot.dir = lang === 'ar' ? 'rtl' : 'ltr';

    document.getElementById('lang-ar-btn').classList.toggle('active', lang === 'ar');
    document.getElementById('lang-en-btn').classList.toggle('active', lang === 'en');

    const dict = I18N[lang];
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (dict[key]) el.innerHTML = dict[key];
    });

    document.getElementById('new-profile-name').placeholder = dict.kidNamePlaceholder;
    document.getElementById('exit-toast').textContent = dict.exitToastMsg;

    const catProf = profiles.find(p => p.id === 'default_cat');
    if (catProf) catProf.name = dict.defaultCatName;

    updateHomeUI();
}

// --- نظام الصوتيات لكل بروفايل ---
class SoundManager {
    constructor() {
        this.defaultCorrect = [
            new Audio('assets/sounds/correct1.wav'),
            new Audio('assets/sounds/correct2.wav'),
            new Audio('assets/sounds/correct3.wav')
        ];
        this.defaultWrong = [
            new Audio('assets/sounds/wrong1.wav'),
            new Audio('assets/sounds/wrong2.wav')
        ];
        this.defaultWin = new Audio('assets/sounds/win.wav');
    }
    playCorrect() {
        if (!appPrefs.soundEnabled) return;
        const prof = getActiveProfile();
        const custom = Object.values(prof.correctSounds || {}).filter(Boolean);
        if (custom.length > 0) {
            const pick = custom[Math.floor(Math.random() * custom.length)];
            new Audio(pick.data).play().catch(() => {});
        } else {
            const pick = this.defaultCorrect[Math.floor(Math.random() * this.defaultCorrect.length)];
            pick.currentTime = 0;
            pick.play().catch(() => {});
        }
    }
    playWrong() {
        if (!appPrefs.soundEnabled) return;
        const prof = getActiveProfile();
        const custom = Object.values(prof.wrongSounds || {}).filter(Boolean);
        if (custom.length > 0) {
            const pick = custom[Math.floor(Math.random() * custom.length)];
            new Audio(pick.data).play().catch(() => {});
        } else {
            const pick = this.defaultWrong[Math.floor(Math.random() * this.defaultWrong.length)];
            pick.currentTime = 0;
            pick.play().catch(() => {});
        }
    }
    playWin() {
        if (!appPrefs.soundEnabled) return;
        this.defaultWin.currentTime = 0;
        this.defaultWin.play().catch(() => {});
    }
}

const sound = new SoundManager();

// --- توليد ألغاز مناطق الألوان (120 مستوى) ---
class SeededRNG {
    constructor(seed) { this.seed = (seed * 2654435761) >>> 0; }
    next() {
        this.seed = (1664525 * this.seed + 1013904223) >>> 0;
        return this.seed / 4294967296;
    }
    nextInt(max) { return Math.floor(this.next() * max); }
    shuffle(arr) {
        const a = [...arr];
        for (let i = a.length - 1; i > 0; i--) {
            const j = this.nextInt(i + 1);
            [a[i], a[j]] = [a[j], a[i]];
        }
        return a;
    }
}

function getGridSizeForLevel(lvl) {
    if (lvl <= 8) return 5;
    if (lvl <= 20) return 6;
    if (lvl <= 35) return 7;
    if (lvl <= 50) return 8;
    return 9;
}

function generateRegionsPuzzle(levelNum) {
    const N = getGridSizeForLevel(levelNum);
    const rng = new SeededRNG(levelNum * 97 + 13);
    const catCols = new Array(N).fill(-1);
    const usedCols = new Array(N).fill(false);

    function placeRow(r) {
        if (r === N) return true;
        const candidates = rng.shuffle(Array.from({ length: N }, (_, i) => i));
        for (const c of candidates) {
            if (usedCols[c]) continue;
            if (r > 0 && Math.abs(c - catCols[r - 1]) <= 1) continue;
            catCols[r] = c;
            usedCols[c] = true;
            if (placeRow(r + 1)) return true;
            usedCols[c] = false;
        }
        return false;
    }
    placeRow(0);

    const colorGrid = Array.from({ length: N }, () => new Array(N).fill(-1));
    const regionMaxCap = new Array(N).fill(N * N);
    const regionOrder = rng.shuffle(Array.from({ length: N }, (_, i) => i));
    regionMaxCap[regionOrder[0]] = 1 + (levelNum % 2);
    if (N >= 6) regionMaxCap[regionOrder[1]] = 3 + (levelNum % 3);

    const regionSizes = new Array(N).fill(1);
    const frontier = [];
    for (let r = 0; r < N; r++) {
        const c = catCols[r];
        colorGrid[r][c] = r;
        frontier.push({ r, c, color: r });
    }

    const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    let unassigned = N * N - N;
    let guard = 0;
    while (unassigned > 0 && guard < 5000) {
        guard++;
        if (guard > 400) regionMaxCap.fill(N * N);
        const cell = frontier[rng.nextInt(frontier.length)];
        if (regionSizes[cell.color] >= regionMaxCap[cell.color]) continue;
        for (const [dr, dc] of rng.shuffle(dirs)) {
            const nr = cell.r + dr, nc = cell.c + dc;
            if (nr >= 0 && nr < N && nc >= 0 && nc < N && colorGrid[nr][nc] === -1) {
                colorGrid[nr][nc] = cell.color;
                regionSizes[cell.color]++;
                unassigned--;
                frontier.push({ r: nr, c: nc, color: cell.color });
                break;
            }
        }
    }

    for (let r = 0; r < N; r++) {
        for (let c = 0; c < N; c++) {
            if (colorGrid[r][c] === -1) {
                for (const [dr, dc] of dirs) {
                    const nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < N && nc >= 0 && nc < N && colorGrid[nr][nc] !== -1) {
                        colorGrid[r][c] = colorGrid[nr][nc];
                        break;
                    }
                }
            }
        }
    }
    return { N, catCols, colorGrid };
}

// --- إدارة الشاشات وزر الرجوع (يذهب للهوم أولاً قبل الخروج) ---
let currentScreen = 'home'; // 'home' | 'levels' | 'game'
let lastBackPress = 0;

function navigateToScreen(screenName, pushHist = true) {
    currentScreen = screenName;
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));

    const topStats = document.getElementById('top-game-stats');
    const topTitle = document.getElementById('top-home-title');
    const backBtn = document.getElementById('back-btn');

    if (screenName === 'home') {
        document.getElementById('home-screen').classList.add('active');
        topStats.style.display = 'none';
        topTitle.style.display = 'block';
        backBtn.textContent = '🐾';
        updateHomeUI();
    } else if (screenName === 'levels') {
        document.getElementById('level-screen').classList.add('active');
        topStats.style.display = 'none';
        topTitle.style.display = 'block';
        backBtn.textContent = '🏠';
        renderLevelsGrid();
    } else if (screenName === 'game') {
        document.getElementById('game-screen').classList.add('active');
        topStats.style.display = 'flex';
        topTitle.style.display = 'none';
        backBtn.textContent = '🏠';
    }

    if (pushHist) {
        history.pushState({ screen: screenName }, '');
    }
}

function handleBackNavigation() {
    // 1. إذا كانت أي نافذة منبثقة مفتوحة، أغلقها أولاً
    const openModal = document.querySelector('.modal.active');
    if (openModal) {
        openModal.classList.remove('active');
        history.pushState({ screen: currentScreen }, '');
        return;
    }

    // 2. إذا كنا داخل اللعب أو خريطة المستويات، ارجع إلى شاشة الهوم أولاً!
    if (currentScreen !== 'home') {
        navigateToScreen('home', false);
        history.pushState({ screen: 'home' }, '');
        return;
    }

    // 3. إذا كنا بالفعل في شاشة الهوم، أظهر تنبيه الخروج عند الضغط مرتين
    const now = Date.now();
    if (now - lastBackPress < 2000) {
        if (navigator.app && navigator.app.exitApp) {
            navigator.app.exitApp();
        }
    } else {
        lastBackPress = now;
        const toast = document.getElementById('exit-toast');
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 1800);
        history.pushState({ screen: 'home' }, '');
    }
}

window.addEventListener('popstate', () => {
    handleBackNavigation();
});

document.getElementById('back-btn').addEventListener('click', () => {
    if (currentScreen !== 'home') {
        navigateToScreen('home');
    } else {
        openProfilePickerModal();
    }
});

// --- تحديث واجهة الهوم ---
function updateHomeUI() {
    const prof = getActiveProfile();
    if (!prof) return;
    document.getElementById('home-profile-img').src = prof.photo;
    document.getElementById('home-profile-name').textContent = prof.name;
    document.getElementById('home-lvl-val').textContent = prof.currentLevel || 1;
    document.getElementById('home-score-val').textContent = prof.score || 0;
    document.getElementById('booster-cat-img').src = prof.photo;
}

// --- حالة اللعب والمؤثرات البصرية (Particles & Animations) ---
let game = {
    level: 1,
    N: 9,
    catCols: [],
    colorGrid: [],
    boardState: [], // 0 = empty, 1 = X, 2 = Cat/Photo
    lives: 3
};

const boardEl = document.getElementById('regions-board');
const silhouettesBar = document.getElementById('cat-silhouettes-bar');

function startLevel(lvl) {
    const prof = getActiveProfile();
    game.level = lvl;
    prof.currentLevel = lvl;
    saveProfilesToDB();

    const puzzle = generateRegionsPuzzle(lvl);
    game.N = puzzle.N;
    game.catCols = puzzle.catCols;
    game.colorGrid = puzzle.colorGrid;
    game.boardState = Array.from({ length: game.N }, () => new Array(game.N).fill(0));
    game.lives = 3;

    document.getElementById('level-num-display').textContent = lvl;
    document.getElementById('score-display').textContent = prof.score || 0;
    document.getElementById('booster-cat-img').src = prof.photo;

    updateBoostersUI();
    renderLivesUI();
    renderSilhouettesBar();
    renderBoard();
    navigateToScreen('game');
}

function renderSilhouettesBar() {
    silhouettesBar.innerHTML = '';
    for (let c = 0; c < game.N; c++) {
        const hex = REGION_COLORS[c % REGION_COLORS.length];
        const div = document.createElement('div');
        div.className = 'cat-sil';
        div.dataset.color = c;
        div.innerHTML = `<svg viewBox="0 0 100 100">
            <path d="M18,45 L14,12 L42,28 Q50,25 58,28 L86,12 L82,45 Q92,60 88,78 Q80,95 50,95 Q20,95 12,78 Q8,60 18,45 Z" fill="${hex}"/>
        </svg>`;
        silhouettesBar.appendChild(div);
    }
    updateSilhouettesStatus();
}

function updateSilhouettesStatus() {
    const foundColors = new Set();
    for (let r = 0; r < game.N; r++) {
        for (let c = 0; c < game.N; c++) {
            if (game.boardState[r][c] === 2) foundColors.add(game.colorGrid[r][c]);
        }
    }
    silhouettesBar.querySelectorAll('.cat-sil').forEach(el => {
        el.classList.toggle('found', foundColors.has(parseInt(el.dataset.color)));
    });
}

function renderLivesUI() {
    document.querySelectorAll('#lives-bar .fish-icon').forEach((f, idx) => {
        f.classList.toggle('lost', idx >= game.lives);
    });
}

function updateBoostersUI() {
    const prof = getActiveProfile();
    document.getElementById('badge-cat').textContent = prof.boosters.cat;
    document.getElementById('badge-hint').textContent = prof.boosters.hint;
    document.getElementById('badge-mouse').textContent = prof.boosters.mouse;
}

// --- نظام الضغطة الواحدة (وضع/إلغاء X) والضغطتين السريعتين (وضع القطة/الصورة) ---
let tapTimer = null;
let lastTappedCoords = null;
let lastTapTime = 0;

function onTilePointerDown(r, c) {
    const now = Date.now();
    const isSameCell = lastTappedCoords && lastTappedCoords.r === r && lastTappedCoords.c === c;

    if (isSameCell && (now - lastTapTime) < 280) {
        // ضغطتان سريعتان (Double Tap) -> وضع القطة / صورة الابن مباشرة!
        clearTimeout(tapTimer);
        tapTimer = null;
        lastTappedCoords = null;
        lastTapTime = 0;
        placeCatAt(r, c);
    } else {
        // ضغطة واحدة (Single Tap) -> تبديل علامة X (وضع X أو إلغاء X)
        lastTappedCoords = { r, c };
        lastTapTime = now;
        clearTimeout(tapTimer);
        tapTimer = setTimeout(() => {
            toggleSingleTapX(r, c);
            tapTimer = null;
        }, 210);
    }
}

function toggleSingleTapX(r, c) {
    const cur = game.boardState[r][c];
    const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);

    if (cur === 0) {
        // المربع فارغ -> ضع علامة X مع أنيميشن
        game.boardState[r][c] = 1;
        if (tileEl) tileEl.innerHTML = `<span class="tile-x">✕</span>`;
    } else if (cur === 1) {
        // المربع فيه X -> الضغطة الواحدة الثانية تلغي علامة X بأنيميشن ناعم!
        game.boardState[r][c] = 0;
        const xEl = tileEl ? tileEl.querySelector('.tile-x') : null;
        if (xEl) {
            xEl.classList.add('removing');
            setTimeout(() => { if (game.boardState[r][c] === 0) tileEl.innerHTML = ''; }, 170);
        } else if (tileEl) {
            tileEl.innerHTML = '';
        }
    } else if (cur === 2) {
        // إذا كان فيه قطة وضغط ضغطة واحدة -> يزيل القطة
        game.boardState[r][c] = 0;
        const imgEl = tileEl ? tileEl.querySelector('.tile-avatar') : null;
        if (imgEl) {
            imgEl.classList.add('removing');
            setTimeout(() => {
                if (game.boardState[r][c] === 0) tileEl.innerHTML = '';
                updateSilhouettesStatus();
            }, 170);
        }
    }
}

// توليد شرارات احتفالية عند وضع الصورة الصحيحة
function spawnCelebrationParticles(tileEl) {
    if (!tileEl) return;
    const emojis = ['✨', '⭐', '💖', '🐾', '🎉'];
    for (let i = 0; i < 6; i++) {
        const span = document.createElement('span');
        span.className = 'fx-particle';
        span.textContent = emojis[i % emojis.length];
        const angle = (Math.PI * 2 * i) / 6;
        const dist = 28 + Math.random() * 18;
        span.style.setProperty('--dx', `${Math.cos(angle) * dist}px`);
        span.style.setProperty('--dy', `${Math.sin(angle) * dist}px`);
        tileEl.appendChild(span);
        setTimeout(() => span.remove(), 750);
    }
}

// توليد أنيميشن الخطأ
function spawnWrongAnimation(tileEl) {
    if (!tileEl) return;
    tileEl.classList.remove('error-shake');
    void tileEl.offsetWidth;
    tileEl.classList.add('error-shake');

    const badge = document.createElement('div');
    badge.className = 'fx-wrong-badge';
    badge.textContent = '❌ -1 🐟';
    tileEl.appendChild(badge);

    setTimeout(() => {
        tileEl.classList.remove('error-shake');
        badge.remove();
    }, 850);
}

function renderBoard() {
    const N = game.N;
    const prof = getActiveProfile();
    boardEl.innerHTML = '';
    boardEl.style.gridTemplateColumns = `repeat(${N}, 1fr)`;
    boardEl.style.gridTemplateRows = `repeat(${N}, 1fr)`;

    for (let r = 0; r < N; r++) {
        for (let c = 0; c < N; c++) {
            const tile = document.createElement('div');
            tile.className = 'tile';
            tile.dataset.r = r;
            tile.dataset.c = c;
            const colorIdx = game.colorGrid[r][c];
            tile.style.backgroundColor = REGION_COLORS[colorIdx % REGION_COLORS.length];

            const state = game.boardState[r][c];
            if (state === 1) {
                tile.innerHTML = `<span class="tile-x">✕</span>`;
            } else if (state === 2) {
                const img = document.createElement('img');
                img.src = prof.photo;
                img.className = `tile-avatar ${!prof.isDefaultCat ? 'kid-mode' : ''}`;
                tile.appendChild(img);
            }

            tile.addEventListener('click', () => onTilePointerDown(r, c));
            boardEl.appendChild(tile);
        }
    }
}

function hasRuleViolation(r, c) {
    if (game.catCols[r] !== c) return true;
    const myColor = game.colorGrid[r][c];
    for (let rr = 0; rr < game.N; rr++) {
        for (let cc = 0; cc < game.N; cc++) {
            if (rr === r && cc === c) continue;
            if (game.boardState[rr][cc] === 2) {
                if (rr === r || cc === c) return true;
                if (game.colorGrid[rr][cc] === myColor) return true;
                if (Math.abs(rr - r) <= 1 && Math.abs(cc - c) <= 1) return true;
            }
        }
    }
    return false;
}

function autoFillXsAround(r, c) {
    if (!appPrefs.autoX) return;
    const myColor = game.colorGrid[r][c];
    for (let rr = 0; rr < game.N; rr++) {
        for (let cc = 0; cc < game.N; cc++) {
            if (game.boardState[rr][cc] !== 0) continue;
            if (rr === r || cc === c || game.colorGrid[rr][cc] === myColor || (Math.abs(rr - r) <= 1 && Math.abs(cc - c) <= 1)) {
                game.boardState[rr][cc] = 1;
                const tEl = boardEl.querySelector(`.tile[data-r="${rr}"][data-c="${cc}"]`);
                if (tEl) tEl.innerHTML = `<span class="tile-x">✕</span>`;
            }
        }
    }
}

function placeCatAt(r, c) {
    const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
    if (hasRuleViolation(r, c)) {
        // خطأ: إذا كان المربع فيه X نتركه أو نفرغه ونشغل أنيميشن وصوت الخطأ
        game.boardState[r][c] = 1;
        if (tileEl) tileEl.innerHTML = `<span class="tile-x">✕</span>`;
        sound.playWrong();
        spawnWrongAnimation(tileEl);

        game.lives--;
        renderLivesUI();
        if (game.lives <= 0) {
            setTimeout(() => {
                document.getElementById('lose-modal').classList.add('active');
            }, 600);
        }
        return;
    }

    // إجابة صحيحة!
    const prof = getActiveProfile();
    game.boardState[r][c] = 2;
    if (tileEl) {
        tileEl.innerHTML = '';
        const img = document.createElement('img');
        img.src = prof.photo;
        img.className = `tile-avatar ${!prof.isDefaultCat ? 'kid-mode' : ''}`;
        tileEl.appendChild(img);
        tileEl.classList.add('correct-glow');
        spawnCelebrationParticles(tileEl);
    }

    autoFillXsAround(r, c);
    sound.playCorrect();

    prof.score = (prof.score || 0) + 10;
    document.getElementById('score-display').textContent = prof.score;
    saveProfilesToDB();

    updateSilhouettesStatus();
    checkVictory();
}

function checkVictory() {
    let count = 0;
    for (let r = 0; r < game.N; r++) {
        if (game.boardState[r][game.catCols[r]] === 2) count++;
    }
    if (count === game.N) {
        const prof = getActiveProfile();
        prof.completed[game.level] = true;
        prof.score = (prof.score || 0) + 50;
        if (game.level < TOTAL_LEVELS) prof.currentLevel = game.level + 1;
        saveProfilesToDB();

        setTimeout(() => {
            sound.playWin();
            document.getElementById('win-level-num').textContent = game.level;
            document.getElementById('win-score-val').textContent = prof.score;
            document.getElementById('win-modal').classList.add('active');
        }, 450);
    }
}

// --- المساعدات الثلاث (Boosters) ---
document.getElementById('booster-cat').addEventListener('click', () => {
    const prof = getActiveProfile();
    if (prof.boosters.cat <= 0) return;
    const unplaced = [];
    for (let r = 0; r < game.N; r++) {
        const c = game.catCols[r];
        if (game.boardState[r][c] !== 2) unplaced.push([r, c]);
    }
    if (!unplaced.length) return;
    prof.boosters.cat--;
    updateBoostersUI();
    saveProfilesToDB();
    const [r, c] = unplaced[Math.floor(Math.random() * unplaced.length)];
    placeCatAt(r, c);
});

document.getElementById('booster-hint').addEventListener('click', () => {
    const prof = getActiveProfile();
    if (prof.boosters.hint <= 0) return;
    for (let r = 0; r < game.N; r++) {
        const c = game.catCols[r];
        if (game.boardState[r][c] !== 2) {
            prof.boosters.hint--;
            updateBoostersUI();
            saveProfilesToDB();
            const tEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
            if (tEl) {
                tEl.classList.add('hint-glow');
                setTimeout(() => tEl.classList.remove('hint-glow'), 2400);
            }
            break;
        }
    }
});

document.getElementById('booster-mouse').addEventListener('click', () => {
    const prof = getActiveProfile();
    if (prof.boosters.mouse <= 0) return;
    const wrongEmpty = [];
    for (let r = 0; r < game.N; r++) {
        for (let c = 0; c < game.N; c++) {
            if (game.boardState[r][c] === 0 && game.catCols[r] !== c) wrongEmpty.push([r, c]);
        }
    }
    if (!wrongEmpty.length) return;
    prof.boosters.mouse--;
    updateBoostersUI();
    saveProfilesToDB();
    wrongEmpty.sort(() => Math.random() - 0.5);
    wrongEmpty.slice(0, 5).forEach(([r, c]) => {
        game.boardState[r][c] = 1;
        const tEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
        if (tEl) tEl.innerHTML = `<span class="tile-x">✕</span>`;
    });
});

// --- خريطة المستويات وأزرار الهوم ---
function renderLevelsGrid() {
    const prof = getActiveProfile();
    const grid = document.getElementById('levels-grid');
    grid.innerHTML = '';
    for (let i = 1; i <= TOTAL_LEVELS; i++) {
        const btn = document.createElement('button');
        const isDone = !!(prof.completed && prof.completed[i]);
        btn.className = `lvl-btn ${isDone ? 'completed' : ''} ${i === prof.currentLevel ? 'current' : ''}`;
        const sz = getGridSizeForLevel(i);
        btn.innerHTML = `<div>${i}</div><div style="font-size:0.7rem">${isDone ? '🐾' : `${sz}×${sz}`}</div>`;
        btn.addEventListener('click', () => startLevel(i));
        grid.appendChild(btn);
    }
}

document.getElementById('play-now-btn').addEventListener('click', () => {
    const prof = getActiveProfile();
    startLevel(prof.currentLevel || 1);
});

document.getElementById('open-levels-btn').addEventListener('click', () => {
    navigateToScreen('levels');
});

document.getElementById('open-settings-home-btn').addEventListener('click', () => {
    openSettingsModal();
});

document.getElementById('quick-swap-btn').addEventListener('click', () => {
    openProfilePickerModal();
});

document.getElementById('next-level-btn').addEventListener('click', () => {
    document.getElementById('win-modal').classList.remove('active');
    const nextLvl = game.level < TOTAL_LEVELS ? game.level + 1 : 1;
    startLevel(nextLvl);
});

document.getElementById('retry-level-btn').addEventListener('click', () => {
    document.getElementById('lose-modal').classList.remove('active');
    startLevel(game.level);
});

// --- نافذة اختيار البروفايل عند بدء اللعبة أو التبديل السريع ---
function openProfilePickerModal() {
    const grid = document.getElementById('startup-profiles-grid');
    grid.innerHTML = '';
    profiles.forEach(p => {
        const card = document.createElement('div');
        card.className = `picker-card ${p.id === appPrefs.activeProfileId ? 'active' : ''}`;
        card.innerHTML = `
            <img src="${p.photo}" alt="${p.name}">
            <strong>${p.name}</strong>
            <span style="font-size:0.72rem; color:#8c6d62;">${I18N[appPrefs.lang].level} ${p.currentLevel || 1}</span>
        `;
        card.addEventListener('click', () => {
            appPrefs.activeProfileId = p.id;
            saveProfilesToDB();
            updateHomeUI();
            if (currentScreen === 'game') startLevel(p.currentLevel || 1);
            document.getElementById('profile-picker-modal').classList.remove('active');
        });
        grid.appendChild(card);
    });
    document.getElementById('profile-picker-modal').classList.add('active');
    history.pushState({ modal: 'picker' }, '');
}

document.getElementById('add-profile-from-picker-btn').addEventListener('click', () => {
    document.getElementById('profile-picker-modal').classList.remove('active');
    openSettingsModal();
});

// --- إدارة الإعدادات والبروفايلات والصوتيات ---
let tempNewProfilePhoto = null;

document.getElementById('new-profile-photo-input').addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => {
        const img = new Image();
        img.onload = () => {
            const canvas = document.createElement('canvas');
            const size = 200;
            canvas.width = size;
            canvas.height = size;
            const ctx = canvas.getContext('2d');
            const minDim = Math.min(img.width, img.height);
            ctx.drawImage(img, (img.width - minDim) / 2, (img.height - minDim) / 2, minDim, minDim, 0, 0, size, size);
            tempNewProfilePhoto = canvas.toDataURL('image/jpeg', 0.88);
            document.getElementById('new-profile-preview').src = tempNewProfilePhoto;
        };
        img.src = ev.target.result;
    };
    reader.readAsDataURL(file);
});

document.getElementById('save-new-profile-btn').addEventListener('click', async () => {
    const nameInput = document.getElementById('new-profile-name');
    const name = nameInput.value.trim() || (appPrefs.lang === 'ar' ? `البطل ${profiles.length}` : `Hero ${profiles.length}`);
    const newProf = {
        id: 'kid_' + Date.now(),
        name: name,
        isDefaultCat: false,
        photo: tempNewProfilePhoto || 'assets/cats/main_cat.svg',
        correctSounds: {},
        wrongSounds: {},
        currentLevel: 1,
        score: 0,
        completed: {},
        boosters: { cat: 7, hint: 9, mouse: 2 }
    };
    profiles.push(newProf);
    appPrefs.activeProfileId = newProf.id;
    nameInput.value = '';
    tempNewProfilePhoto = null;
    document.getElementById('new-profile-preview').src = 'assets/cats/main_cat.svg';

    await saveProfilesToDB();
    renderSettingsModalUI();
    updateHomeUI();
    if (currentScreen === 'game') renderBoard();
});

function renderSettingsModalUI() {
    const dict = I18N[appPrefs.lang];
    const activeProf = getActiveProfile();

    document.getElementById('correct-tab-prof-name').textContent = activeProf.name;
    document.getElementById('wrong-tab-prof-name').textContent = activeProf.name;

    const listEl = document.getElementById('profiles-list-container');
    listEl.innerHTML = '';

    profiles.forEach(p => {
        const isCurrent = p.id === appPrefs.activeProfileId;
        const item = document.createElement('div');
        item.className = `prof-item ${isCurrent ? 'active' : ''}`;

        const left = document.createElement('div');
        left.className = 'prof-item-left';
        left.innerHTML = `
            <img src="${p.photo}" alt="${p.name}">
            <div>
                <strong>${p.name}</strong>
                <div style="font-size:0.72rem; color:#8c6d62;">${dict.level}: ${p.currentLevel || 1} | ${dict.score}: ${p.score || 0}</div>
            </div>
        `;

        const actions = document.createElement('div');
        actions.className = 'prof-item-actions';

        const selectBtn = document.createElement('button');
        selectBtn.className = `mini-btn ${isCurrent ? 'play' : 'up'}`;
        selectBtn.textContent = isCurrent ? dict.activeTag : dict.selectTag;
        selectBtn.onclick = async () => {
            appPrefs.activeProfileId = p.id;
            await saveProfilesToDB();
            renderSettingsModalUI();
            updateHomeUI();
            if (currentScreen === 'game') startLevel(p.currentLevel || 1);
        };
        actions.appendChild(selectBtn);

        if (!p.isDefaultCat) {
            const delBtn = document.createElement('button');
            delBtn.className = 'mini-btn del';
            delBtn.textContent = '🗑️';
            delBtn.onclick = async () => {
                profiles = profiles.filter(x => x.id !== p.id);
                if (appPrefs.activeProfileId === p.id) {
                    appPrefs.activeProfileId = profiles[0].id;
                }
                await saveProfilesToDB();
                renderSettingsModalUI();
                updateHomeUI();
            };
            actions.appendChild(delBtn);
        }

        item.appendChild(left);
        item.appendChild(actions);
        listEl.appendChild(item);
    });

    renderAudioSlotsUI('correct-audio-list', activeProf.correctSounds, dict.soundSlotCorrect);
    renderAudioSlotsUI('wrong-audio-list', activeProf.wrongSounds, dict.soundSlotWrong);
}

function renderAudioSlotsUI(containerId, soundMap, labelText) {
    const dict = I18N[appPrefs.lang];
    const container = document.getElementById(containerId);
    container.innerHTML = '';

    for (let i = 1; i <= 6; i++) {
        const entry = soundMap[i];
        const row = document.createElement('div');
        row.className = 'audio-row';
        row.innerHTML = `<span>🎵 <strong>${labelText} (${i}):</strong> ${entry ? entry.name : dict.defaultSound}</span>`;

        const actions = document.createElement('div');
        actions.className = 'audio-actions';

        if (entry) {
            const playB = document.createElement('button');
            playB.className = 'mini-btn play';
            playB.textContent = '▶️';
            playB.onclick = () => new Audio(entry.data).play();

            const delB = document.createElement('button');
            delB.className = 'mini-btn del';
            delB.textContent = '🗑️';
            delB.onclick = async () => {
                delete soundMap[i];
                await saveProfilesToDB();
                renderSettingsModalUI();
            };
            actions.appendChild(playB);
            actions.appendChild(delB);
        }

        const upLabel = document.createElement('label');
        upLabel.className = 'mini-btn up';
        upLabel.textContent = dict.uploadSound;
        const inp = document.createElement('input');
        inp.type = 'file';
        inp.accept = 'audio/*';
        inp.style.display = 'none';
        inp.onchange = (e) => {
            const f = e.target.files[0];
            if (!f) return;
            const r = new FileReader();
            r.onload = async (ev) => {
                soundMap[i] = { name: f.name.slice(0, 14), data: ev.target.result };
                await saveProfilesToDB();
                renderSettingsModalUI();
            };
            r.readAsDataURL(f);
        };
        upLabel.appendChild(inp);
        actions.appendChild(upLabel);
        row.appendChild(actions);
        container.appendChild(row);
    }
}

function openSettingsModal() {
    renderSettingsModalUI();
    document.getElementById('settings-modal').classList.add('active');
    history.pushState({ modal: 'settings' }, '');
}

document.getElementById('settings-btn').addEventListener('click', openSettingsModal);
document.getElementById('close-settings-btn').addEventListener('click', () => document.getElementById('settings-modal').classList.remove('active'));
document.getElementById('save-close-btn').addEventListener('click', () => document.getElementById('settings-modal').classList.remove('active'));

document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById(btn.dataset.tab).classList.add('active');
    });
});

document.getElementById('lang-ar-btn').addEventListener('click', () => {
    applyLanguage('ar');
    renderSettingsModalUI();
});
document.getElementById('lang-en-btn').addEventListener('click', () => {
    applyLanguage('en');
    renderSettingsModalUI();
});

document.getElementById('auto-x-toggle').addEventListener('change', (e) => {
    appPrefs.autoX = e.target.checked;
    localStorage.setItem('meow_autox', appPrefs.autoX);
});
document.getElementById('sound-toggle').addEventListener('change', (e) => {
    appPrefs.soundEnabled = e.target.checked;
    localStorage.setItem('meow_sound', appPrefs.soundEnabled);
});

// --- تهيئة اللعبة عند الفتح ---
async function initApp() {
    await db.init();
    const savedProfs = await db.get('profiles_list');
    if (savedProfs && Array.isArray(savedProfs) && savedProfs.length > 0) {
        profiles = savedProfs;
    } else {
        profiles = [createDefaultCatProfile()];
        await saveProfilesToDB();
    }

    document.getElementById('auto-x-toggle').checked = appPrefs.autoX;
    document.getElementById('sound-toggle').checked = appPrefs.soundEnabled;

    applyLanguage(appPrefs.lang);
    navigateToScreen('home', true);

    // إذا كان هناك بروفايلات أطفال مضافة، اطلب اختيار البروفايل فور فتح اللعبة!
    if (profiles.length > 1) {
        openProfilePickerModal();
    }
}

initApp();
JS_EOF

# 4. مزامنة الأندرويد ورفع الكود إلى GitHub لبناء الـ APK
echo "🔄 جاري مزامنة التعديلات مع مشروع الأندرويد (Capacitor Sync)..."
npx cap sync android

echo "🚀 جاري رفع التحديث إلى GitHub لبناء الـ APK الجديد تلقائياً..."
git add .
git commit -m "Add multi-kid profiles, AR/EN language toggle, double-tap & animations, and Home screen navigation" || true
git push

echo "=================================================================="
echo "✅ تم تحديث اللعبة ورفعها إلى GitHub بنجاح!"
echo "📱 افتح تبويب Actions في صفحة مستودعك على GitHub لتحميل ملف الـ APK المحدث."
echo "=================================================================="
