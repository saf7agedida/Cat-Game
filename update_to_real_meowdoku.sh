#!/usr/bin/env bash
set -e

echo "🔧 جاري ضبط مسار الملفات في المجلد الرئيسي..."
cd /workspaces/Cat-Game

if [ -d "Meowdoku_Android" ]; then
  shopt -s dotglob
  cp -rf Meowdoku_Android/* . 2>/dev/null || true
  rm -rf Meowdoku_Android build_meowdoku_project.sh
fi

mkdir -p www/assets/cats
mkdir -p www/assets/sounds
mkdir -p .github/workflows

# 1. توليد صورة القطة الافتراضية + الأيقونات + 6 ملفات صوتية WAV
cat << 'GEN_EOF' > generate_assets.js
const fs = require('fs');

// صورة القطة الافتراضية اللطيفة (تشبه القطة في الصورة المرفقة)
const mainCatSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <!-- Ears -->
  <polygon points="22,52 14,14 50,32" fill="#2f3542" stroke="#1e272e" stroke-width="3" stroke-linejoin="round"/>
  <polygon points="98,52 106,14 70,32" fill="#2f3542" stroke="#1e272e" stroke-width="3" stroke-linejoin="round"/>
  <polygon points="26,46 20,22 44,34" fill="#ff9ff3"/>
  <polygon points="94,46 100,22 76,34" fill="#ff9ff3"/>
  <!-- Head -->
  <circle cx="60" cy="66" r="40" fill="#ffffff" stroke="#2f3542" stroke-width="3.5"/>
  <!-- Black patches like the winking cat in screenshot -->
  <path d="M 22,55 Q 35,26 60,30 Q 48,55 24,68 Z" fill="#2f3542"/>
  <path d="M 98,55 Q 85,26 60,30 Q 72,55 96,68 Z" fill="#2f3542"/>
  <!-- Left Eye (Open) -->
  <circle cx="43" cy="62" r="6.5" fill="#1e272e"/>
  <circle cx="41" cy="59.5" r="2.2" fill="#ffffff"/>
  <!-- Right Eye (Cute Wink) -->
  <path d="M 70,62 Q 77,55 84,62" fill="none" stroke="#1e272e" stroke-width="4" stroke-linecap="round"/>
  <!-- Pink Nose & Happy Mouth -->
  <polygon points="56,70 64,70 60,75" fill="#ff6b81"/>
  <path d="M 50,77 Q 60,83 70,77" fill="none" stroke="#1e272e" stroke-width="3" stroke-linecap="round"/>
  <path d="M 54,79 Q 60,92 66,79 Z" fill="#ff6b81"/>
  <!-- Whiskers -->
  <line x1="12" y1="66" x2="30" y2="69" stroke="#2f3542" stroke-width="2.5" stroke-linecap="round"/>
  <line x1="12" y1="75" x2="30" y2="75" stroke="#2f3542" stroke-width="2.5" stroke-linecap="round"/>
  <line x1="108" y1="66" x2="90" y2="69" stroke="#2f3542" stroke-width="2.5" stroke-linecap="round"/>
  <line x1="108" y1="75" x2="90" y2="75" stroke="#2f3542" stroke-width="2.5" stroke-linecap="round"/>
</svg>`;

fs.writeFileSync('www/assets/cats/main_cat.svg', mainCatSvg, 'utf8');

// توليد ملفات الصوت WAV
function createWavFile(filepath, notes) {
  const sampleRate = 22050;
  let samples = [];
  notes.forEach(({ freq, duration, type }) => {
    const count = Math.floor(sampleRate * duration);
    for (let i = 0; i < count; i++) {
      const t = i / sampleRate;
      const env = Math.exp(-3.5 * (i / count));
      let val = 0;
      if (type === 'meow') {
        const slideFreq = freq + Math.sin(t * 14) * 90;
        val = Math.sin(2 * Math.PI * slideFreq * t) * 0.65 + Math.sin(4 * Math.PI * slideFreq * t) * 0.2;
      } else if (type === 'error') {
        val = (2 * ((t * freq) - Math.floor(0.5 + t * freq))) * 0.65;
      } else {
        val = Math.sin(2 * Math.PI * freq * t) * 0.7;
      }
      samples.push(Math.max(-1, Math.min(1, val * env)));
    }
  });

  const dataSize = samples.length * 2;
  const buffer = Buffer.alloc(44 + dataSize);
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(36 + dataSize, 4);
  buffer.write('WAVE', 8);
  buffer.write('fmt ', 12);
  buffer.writeUInt32LE(16, 16);
  buffer.writeUInt16LE(1, 20);
  buffer.writeUInt16LE(1, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * 2, 28);
  buffer.writeUInt16LE(2, 32);
  buffer.writeUInt16LE(16, 34);
  buffer.write('data', 36);
  buffer.writeUInt32LE(dataSize, 40);

  for (let i = 0; i < samples.length; i++) {
    buffer.writeInt16LE(Math.floor(samples[i] * 32767), 44 + i * 2);
  }
  fs.writeFileSync(filepath, buffer);
}

createWavFile('www/assets/sounds/correct1.wav', [{ freq: 540, duration: 0.14, type: 'meow' }, { freq: 760, duration: 0.22, type: 'meow' }]);
createWavFile('www/assets/sounds/correct2.wav', [{ freq: 620, duration: 0.12, type: 'meow' }, { freq: 880, duration: 0.20, type: 'meow' }]);
createWavFile('www/assets/sounds/correct3.wav', [{ freq: 500, duration: 0.12, type: 'meow' }, { freq: 680, duration: 0.14, type: 'meow' }, { freq: 920, duration: 0.2, type: 'meow' }]);
createWavFile('www/assets/sounds/wrong1.wav', [{ freq: 210, duration: 0.18, type: 'error' }, { freq: 150, duration: 0.28, type: 'error' }]);
createWavFile('www/assets/sounds/wrong2.wav', [{ freq: 185, duration: 0.20, type: 'error' }, { freq: 125, duration: 0.30, type: 'error' }]);
createWavFile('www/assets/sounds/win.wav', [
  { freq: 523.25, duration: 0.13, type: 'win' },
  { freq: 659.25, duration: 0.13, type: 'win' },
  { freq: 783.99, duration: 0.13, type: 'win' },
  { freq: 1046.50, duration: 0.35, type: 'win' }
]);

console.log("✅ تم تجهيز رسومات القطة والصوتيات الافتراضية!");
GEN_EOF

node generate_assets.js
rm generate_assets.js

# 2. إنشاء واجهة اللعبة المطابقة للصورة (www/index.html)
cat << 'HTML_EOF' > www/index.html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#fcf7f2">
    <title>Meowdoku - مناطق الألوان</title>
    <link rel="manifest" href="manifest.json">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="app-container">
        <!-- Top Bar (Exact Match to Screenshot) -->
        <header class="top-bar">
            <button id="back-btn" class="circle-icon-btn" title="المستويات">➜</button>
            <div class="top-stats">
                <div class="stat-col">
                    <span class="stat-label">Level</span>
                    <span id="level-num-display" class="stat-val">1</span>
                </div>
                <div class="stat-col">
                    <span class="stat-label">Score</span>
                    <span id="score-display" class="stat-val">0</span>
                </div>
            </div>
            <button id="settings-btn" class="circle-icon-btn" title="الإعدادات">⚙️</button>
        </header>

        <!-- Level Selection Screen -->
        <main id="level-screen" class="screen">
            <div class="levels-header-card">
                <h2>🐾 خريطة المستويات (1 - 120)</h2>
                <p>ضع قطة واحدة (أو صورة ابنك) في كل منطقة لونية، وفي كل صف وعمود، بشرط ألا تتلامس القطط حتى قطرياً!</p>
                <div class="mode-Quick-bar">
                    <span>اضغط <strong>⚙️</strong> بالأعلى لإضافة صورة ابنك وأصواتك الخاصة!</span>
                </div>
            </div>
            <div id="levels-grid" class="levels-grid"></div>
        </main>

        <!-- Game Screen (Exact Match to Screenshot) -->
        <main id="game-screen" class="screen active">
            <!-- Cat Silhouettes Bar + 3 Golden Fishes -->
            <div class="status-strip">
                <div id="cat-silhouettes-bar" class="silhouettes-pill"></div>
                <div id="lives-bar" class="lives-pill">
                    <span class="fish-icon">🐟</span>
                    <span class="fish-icon">🐟</span>
                    <span class="fish-icon">🐟</span>
                </div>
            </div>

            <!-- 3 Visual Rules Cards (Exact Match to Screenshot) -->
            <div class="rules-strip" dir="ltr">
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span>✕</span><span>✕</span>
                        <span>✕</span><span class="mini-cat">🐱</span><span></span>
                        <span>✕</span><span></span><span></span>
                    </div>
                    <div class="rule-text">1 Cat per<br>color</div>
                </div>
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span class="mini-cat">🐱</span><span>✕</span>
                        <span></span><span>✕</span><span></span>
                        <span></span><span>✕</span><span></span>
                    </div>
                    <div class="rule-text">1 Cat per<br>column and<br>row</div>
                </div>
                <div class="rule-card">
                    <div class="mini-grid">
                        <span>✕</span><span>✕</span><span>✕</span>
                        <span>✕</span><span class="mini-cat">🐱</span><span>✕</span>
                        <span>✕</span><span>✕</span><span>✕</span>
                    </div>
                    <div class="rule-text">Cats cannot<br>touch</div>
                </div>
            </div>

            <!-- Color Regions Board -->
            <div class="board-card">
                <div id="regions-board" class="regions-board" dir="ltr"></div>
            </div>

            <!-- Tap instruction hint -->
            <div class="tap-guide">
                ضغطة 1 = علامة <strong>✕</strong> &nbsp;|&nbsp; ضغطة 2 = <strong>وضع القطة / الصورة</strong> &nbsp;|&nbsp; ضغطة 3 = مسح
            </div>

            <!-- 3 Bottom Boosters (Cat, Lightbulb, Mouse) -->
            <div class="boosters-bar" dir="ltr">
                <button id="booster-cat" class="booster-btn" title="كشف قطة صحيحة">
                    <img id="booster-cat-img" src="assets/cats/main_cat.svg" alt="Cat" class="booster-img">
                    <span id="badge-cat" class="booster-badge">7</span>
                </button>
                <button id="booster-hint" class="booster-btn" title="تلميح ذكي">
                    <span class="booster-emoji">💡</span>
                    <span id="badge-hint" class="booster-badge">9</span>
                </button>
                <button id="booster-mouse" class="booster-btn" title="الفأر المساعد: استبعاد مربعات خاطئة">
                    <span class="booster-emoji">🐭</span>
                    <span id="badge-mouse" class="booster-badge">2</span>
                </button>
            </div>
        </main>

        <!-- Settings Modal (Son's Photo + 6 Correct & 6 Wrong Sounds) -->
        <div id="settings-modal" class="modal">
            <div class="modal-content settings-box">
                <div class="modal-header">
                    <h2>⚙️ إعدادات اللعبة والتخصيص</h2>
                    <button id="close-settings-btn" class="close-x">✖</button>
                </div>

                <div class="settings-tabs">
                    <button class="tab-btn active" data-tab="tab-photo">🖼️ صورة ابني / القطة</button>
                    <button class="tab-btn" data-tab="tab-correct">✅ أصوات الصح (6)</button>
                    <button class="tab-btn" data-tab="tab-wrong">❌ أصوات الخطأ (6)</button>
                </div>

                <!-- Tab 1: Son's Photo vs Cat -->
                <div id="tab-photo" class="tab-pane active">
                    <div class="mode-switch">
                        <label class="radio-option">
                            <input type="radio" name="avatar-mode" value="cat" checked>
                            <span>🐱 شكل القطة الافتراضي</span>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="avatar-mode" value="son">
                            <span>👦 صورة وجه ابني</span>
                        </label>
                    </div>

                    <div class="son-upload-card">
                        <div class="son-preview-wrap">
                            <img id="settings-son-preview" src="assets/cats/main_cat.svg" alt="Preview">
                        </div>
                        <p>ارفع صورة وجه ابنك لتظهر في المربعات الملونة بدلاً من القطة في جميع المستويات!</p>
                        <label class="upload-main-btn">
                            📸 اختر صورة ابنك من الجهاز
                            <input type="file" id="son-photo-input" accept="image/*" style="display:none;">
                        </label>
                    </div>

                    <div class="toggle-row">
                        <label>
                            <input type="checkbox" id="auto-x-toggle" checked>
                            وضع علامات (✕) تلقائياً حول القطة الصحيحة وفي صفها وعمودها ولونها
                        </label>
                    </div>
                    <div class="toggle-row">
                        <label>
                            <input type="checkbox" id="sound-toggle" checked>
                            تشغيل المؤثرات الصوتية 🔊
                        </label>
                    </div>
                </div>

                <!-- Tab 2: Up to 6 Correct Sounds -->
                <div id="tab-correct" class="tab-pane">
                    <p class="tab-hint">أضف حتى <strong>6 صوتيات</strong> تعمل عشوائياً عند وضع القطة/صورة ابنك في <strong>المكان الصحيح</strong>:</p>
                    <div id="correct-audio-list" class="audio-list"></div>
                </div>

                <!-- Tab 3: Up to 6 Wrong Sounds -->
                <div id="tab-wrong" class="tab-pane">
                    <p class="tab-hint">أضف حتى <strong>6 صوتيات</strong> تعمل عشوائياً عند وضع القطة/صورة ابنك في <strong>مكان خاطئ</strong>:</p>
                    <div id="wrong-audio-list" class="audio-list"></div>
                </div>

                <div class="modal-footer">
                    <button id="reset-defaults-btn" class="secondary-btn">إعادة الافتراضي 🔄</button>
                    <button id="save-close-btn" class="primary-btn">حفظ وإغلاق ✅</button>
                </div>
            </div>
        </div>

        <!-- Win Modal -->
        <div id="win-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">😻 🎉 🏆</div>
                <h2>رائع! اكتمل المستوى <span id="win-level-num"></span></h2>
                <p class="win-score-line">النقاط الحالية: <strong id="win-score-val">0</strong></p>
                <div class="modal-footer">
                    <button id="next-level-btn" class="primary-btn">المستوى التالي ⬅️</button>
                </div>
            </div>
        </div>

        <!-- Game Over Modal (Lost 3 Fishes) -->
        <div id="lose-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">😿 🐟</div>
                <h2>انتهت السمكات الثلاث!</h2>
                <p class="win-score-line">تذكر: لا يمكن لقطتين التواجد في نفس اللون أو الصف أو العمود أو التلامس.</p>
                <div class="modal-footer">
                    <button id="retry-level-btn" class="primary-btn">إعادة المحاولة 🔄</button>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
HTML_EOF

# 3. إنشاء ملف التصميم المطابق للصورة (www/style.css)
cat << 'CSS_EOF' > www/style.css
:root {
    --bg-main: #fcf7f2;
    --card-bg: #ffffff;
    --brown-text: #7d5a50;
    --brown-dark: #5c3d36;
    --pill-bg: #ffffff;
    --rule-bg: #f9f1ea;
    --accent: #e58e73;
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
}

.app-container {
    width: 100%;
    max-width: 480px;
    padding: 12px 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Top Header like screenshot */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 2px;
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
}
.circle-icon-btn:active { transform: scale(0.92); }

.top-stats {
    display: flex;
    gap: 36px;
    text-align: center;
}
.stat-col {
    display: flex;
    flex-direction: column;
}
.stat-label {
    font-size: 0.95rem;
    color: #9c7a70;
    font-weight: 600;
}
.stat-val {
    font-size: 1.55rem;
    font-weight: 800;
    color: var(--brown-dark);
    line-height: 1.1;
}

.screen { display: none; flex-direction: column; gap: 10px; }
.screen.active { display: flex; }

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
    opacity: 0.35;
    transform: scale(0.92);
    transition: all 0.25s ease;
}
.cat-sil.found {
    opacity: 1;
    transform: scale(1.12);
    filter: drop-shadow(0 2px 3px rgba(0,0,0,0.18));
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
    transition: opacity 0.3s, transform 0.3s;
}
.fish-icon.lost {
    opacity: 0.2;
    filter: grayscale(100%);
    transform: scale(0.8);
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
.mini-grid span.mini-cat {
    background: #7d5a50;
    font-size: 9px;
}

.rule-text {
    font-size: 0.68rem;
    font-weight: 700;
    color: var(--brown-text);
    line-height: 1.15;
}

/* Board Card & Rounded Color Tiles */
.board-card {
    background: var(--card-bg);
    padding: 12px;
    border-radius: 24px;
    box-shadow: 0 6px 20px rgba(125, 90, 80, 0.08);
    display: flex;
    justify-content: center;
    align-items: center;
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
    transition: transform 0.12s ease, filter 0.15s ease;
    box-shadow: inset 0 -2px 0 rgba(0,0,0,0.08);
}
.tile:active {
    transform: scale(0.92);
}

.tile-x {
    font-size: 1.15rem;
    font-weight: 900;
    color: rgba(60, 40, 35, 0.55);
    pointer-events: none;
    animation: popIn 0.15s ease-out;
}

.tile-avatar {
    width: 82%;
    height: 82%;
    border-radius: 50%;
    object-fit: cover;
    pointer-events: none;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.22));
    animation: popIn 0.22s cubic-bezier(0.18, 0.89, 0.32, 1.28);
}
.tile-avatar.son-mode {
    border: 2.5px solid #ffffff;
    background: #fff;
}

.tile.error-shake {
    animation: errorShake 0.4s;
    outline: 3px solid #e74c3c;
}

.tile.hint-glow {
    animation: pulseGlow 1s infinite alternate;
    outline: 3px solid #f1c40f;
}

.tap-guide {
    text-align: center;
    font-size: 0.76rem;
    color: #9c7a70;
}

/* Bottom 3 Boosters */
.boosters-bar {
    display: flex;
    justify-content: center;
    gap: 28px;
    margin-top: 2px;
}

.booster-btn {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: var(--card-bg);
    border: none;
    box-shadow: 0 5px 15px rgba(125, 90, 80, 0.14);
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    cursor: pointer;
    transition: transform 0.15s;
}
.booster-btn:active { transform: scale(0.92); }

.booster-img {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    object-fit: cover;
}
.booster-emoji {
    font-size: 2rem;
}

.booster-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    background: #d9534f;
    color: #fff;
    font-size: 0.78rem;
    font-weight: bold;
    min-width: 24px;
    height: 24px;
    padding: 0 6px;
    border-radius: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 2px solid var(--bg-main);
}

/* Levels Screen */
.levels-header-card {
    background: var(--card-bg);
    padding: 16px;
    border-radius: 18px;
    text-align: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.04);
}
.levels-header-card h2 { margin-bottom: 6px; color: var(--brown-dark); }
.levels-header-card p { font-size: 0.85rem; line-height: 1.4; margin-bottom: 8px; }
.mode-Quick-bar {
    background: var(--rule-bg);
    padding: 6px 12px;
    border-radius: 12px;
    font-size: 0.8rem;
}

.levels-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(64px, 1fr));
    gap: 8px;
    max-height: 68vh;
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
.lvl-btn.completed {
    background: #e8f8f5;
    border-color: #76d7c4;
}
.lvl-btn.current {
    border-color: var(--accent);
    background: #fff5f0;
}

/* Modals */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.5);
    justify-content: center;
    align-items: center;
    padding: 14px;
    z-index: 300;
}
.modal.active { display: flex; }

.modal-content {
    background: var(--card-bg);
    padding: 22px;
    border-radius: 24px;
    width: 100%;
    max-width: 360px;
    text-align: center;
    box-shadow: 0 12px 32px rgba(0,0,0,0.22);
}

.settings-box {
    max-width: 460px;
    max-height: 88vh;
    display: flex;
    flex-direction: column;
    text-align: right;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}
.modal-header h2 { font-size: 1.15rem; color: var(--brown-dark); }
.close-x { background: none; border: none; font-size: 1.3rem; cursor: pointer; color: var(--brown-text); }

.settings-tabs {
    display: flex;
    gap: 6px;
    margin-bottom: 12px;
}
.tab-btn {
    flex: 1;
    padding: 8px 4px;
    font-size: 0.76rem;
    font-weight: bold;
    background: var(--rule-bg);
    border: 2px solid transparent;
    border-radius: 10px;
    color: var(--brown-text);
    cursor: pointer;
}
.tab-btn.active {
    background: var(--brown-text);
    color: #fff;
}

.tab-pane {
    display: none;
    overflow-y: auto;
    max-height: 54vh;
}
.tab-pane.active { display: block; }

.mode-switch {
    display: flex;
    gap: 8px;
    margin-bottom: 12px;
}
.radio-option {
    flex: 1;
    background: var(--rule-bg);
    padding: 10px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 0.82rem;
    font-weight: bold;
    cursor: pointer;
}

.son-upload-card {
    background: #fff9f5;
    border: 2px dashed var(--accent);
    border-radius: 16px;
    padding: 14px;
    text-align: center;
    margin-bottom: 12px;
}
.son-preview-wrap {
    width: 76px;
    height: 76px;
    margin: 0 auto 8px;
    border-radius: 50%;
    overflow: hidden;
    border: 3px solid var(--accent);
    background: #fff;
}
.son-preview-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
.son-upload-card p {
    font-size: 0.8rem;
    margin-bottom: 10px;
}
.upload-main-btn {
    display: inline-block;
    background: var(--accent);
    color: #fff;
    padding: 8px 16px;
    border-radius: 12px;
    font-weight: bold;
    font-size: 0.85rem;
    cursor: pointer;
}

.toggle-row {
    background: var(--rule-bg);
    padding: 10px 12px;
    border-radius: 12px;
    margin-bottom: 8px;
    font-size: 0.82rem;
    font-weight: 600;
}

.tab-hint {
    font-size: 0.8rem;
    margin-bottom: 10px;
}
.audio-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.audio-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--rule-bg);
    padding: 8px 10px;
    border-radius: 12px;
    font-size: 0.8rem;
}
.audio-actions {
    display: flex;
    gap: 5px;
}
.mini-btn {
    padding: 5px 9px;
    border-radius: 8px;
    border: none;
    font-size: 0.74rem;
    font-weight: bold;
    cursor: pointer;
}
.mini-btn.up { background: var(--brown-text); color: #fff; }
.mini-btn.play { background: #76d7c4; color: #1b4f35; }
.mini-btn.del { background: #f5b7b1; color: #78281f; }

.modal-big-icon { font-size: 2.5rem; margin-bottom: 8px; }
.win-score-line { margin: 10px 0 16px; font-size: 0.95rem; }

.modal-footer {
    display: flex;
    gap: 8px;
    margin-top: 14px;
}
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

@keyframes popIn {
    0% { transform: scale(0.4); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
}
@keyframes errorShake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-5px); }
    75% { transform: translateX(5px); }
}
@keyframes pulseGlow {
    from { transform: scale(0.95); }
    to { transform: scale(1.04); }
}
CSS_EOF

# 4. إنشاء محرك اللعبة الكامل (www/script.js) بنفس ألوان وقواعد الصورة المرفقة
cat << 'JS_EOF' > www/script.js
// الألوان الـ 9 المطابقة للصورة المرفقة (Level 117)
const REGION_COLORS = [
    '#f2a66b', // 0: البرتقالي الفاتح
    '#d9b650', // 1: الأصفر الذهبي
    '#add597', // 2: الأخضر الفاتح
    '#63ada5', // 3: التركواز (الأخضر المزرق)
    '#79b5dc', // 4: الأزرق السماوي
    '#a3b8cf', // 5: الرمادي المزرق
    '#8b78ce', // 6: البنفسجي
    '#efb2c9', // 7: الوردي
    '#9a6d4c'  // 8: البني
];

const TOTAL_LEVELS = 120;

// --- قاعدة بيانات IndexedDB لحفظ صورة الابن و12 ملف صوتي (6 صح + 6 خطأ) ---
class CustomStorageDB {
    constructor() { this.db = null; }
    init() {
        return new Promise((resolve) => {
            const req = indexedDB.open('MeowdokuRegionsDB', 1);
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
    del(key) {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('store', 'readwrite');
            tx.objectStore('store').delete(key);
            tx.oncomplete = () => resolve();
        });
    }
    clear() {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('store', 'readwrite');
            tx.objectStore('store').clear();
            tx.oncomplete = () => resolve();
        });
    }
}

const db = new CustomStorageDB();

let settings = {
    avatarMode: localStorage.getItem('meow_mode') || 'cat', // 'cat' or 'son'
    sonPhoto: null,
    autoX: localStorage.getItem('meow_autox') !== 'false',
    soundEnabled: localStorage.getItem('meow_sound') !== 'false',
    correctSounds: {}, // 1..6
    wrongSounds: {}    // 1..6
};

async function loadSettingsFromDB() {
    await db.init();
    settings.sonPhoto = await db.get('son_photo');
    for (let i = 1; i <= 6; i++) {
        const c = await db.get(`correct_snd_${i}`);
        if (c) settings.correctSounds[i] = c;
        const w = await db.get(`wrong_snd_${i}`);
        if (w) settings.wrongSounds[i] = w;
    }
    updateBoosterAvatar();
}

function getActiveAvatarSrc() {
    if (settings.avatarMode === 'son' && settings.sonPhoto) {
        return settings.sonPhoto;
    }
    return 'assets/cats/main_cat.svg';
}

function updateBoosterAvatar() {
    const img = document.getElementById('booster-cat-img');
    const prev = document.getElementById('settings-son-preview');
    const src = getActiveAvatarSrc();
    if (img) img.src = src;
    if (prev) prev.src = settings.sonPhoto || 'assets/cats/main_cat.svg';
}

// --- نظام الصوتيات (يشغل عشوائياً من الـ 6 أصوات المرفوعة أو الأصوات الافتراضية) ---
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
        if (!settings.soundEnabled) return;
        const custom = Object.values(settings.correctSounds).filter(Boolean);
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
        if (!settings.soundEnabled) return;
        const custom = Object.values(settings.wrongSounds).filter(Boolean);
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
        if (!settings.soundEnabled) return;
        this.defaultWin.currentTime = 0;
        this.defaultWin.play().catch(() => {});
    }
}

const sound = new SoundManager();

// --- مولد الأرقام العشوائية الثابت لكل مستوى ---
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

// تحديد حجم الشبكة حسب المستوى (من 5×5 للمبتدئين حتى 9×9 للمستويات المتقدمة مثل 117)
function getGridSizeForLevel(lvl) {
    if (lvl <= 8) return 5;
    if (lvl <= 20) return 6;
    if (lvl <= 35) return 7;
    if (lvl <= 50) return 8;
    return 9;
}

// --- توليد لغز مناطق الألوان (Star Battle / Queens) ---
function generateRegionsPuzzle(levelNum) {
    const N = getGridSizeForLevel(levelNum);
    const rng = new SeededRNG(levelNum * 97 + 13);

    // 1. إيجاد أماكن N قطط بحيث لا تشترك في صف أو عمود ولا تتلامس حتى قطرياً
    const catCols = new Array(N).fill(-1);
    const usedCols = new Array(N).fill(false);

    function placeRow(r) {
        if (r === N) return true;
        const candidates = rng.shuffle(Array.from({ length: N }, (_, i) => i));
        for (const c of candidates) {
            if (usedCols[c]) continue;
            // منع التلامس القطري أو الرأسي مع الصف السابق
            if (r > 0 && Math.abs(c - catCols[r - 1]) <= 1) continue;
            catCols[r] = c;
            usedCols[c] = true;
            if (placeRow(r + 1)) return true;
            usedCols[c] = false;
        }
        return false;
    }
    placeRow(0);

    // 2. بناء N مناطق لونية متصلة حول مواقع القطط (بأحجام متفاوتة تشبه المستوى 117)
    const colorGrid = Array.from({ length: N }, () => new Array(N).fill(-1));
    const regionMaxCap = new Array(N).fill(N * N);

    // جعل منطقة أو منطقتين صغيرتين (خلية واحدة أو 3 خلايا) لمساعدة اللاعب على بدء الحل منطقياً
    const regionOrder = rng.shuffle(Array.from({ length: N }, (_, i) => i));
    regionMaxCap[regionOrder[0]] = 1 + (levelNum % 2); // منطقة صغيرة جداً كمفتاح للحل
    if (N >= 6) regionMaxCap[regionOrder[1]] = 3 + (levelNum % 3);

    const regionSizes = new Array(N).fill(1);
    const frontier = [];

    for (let r = 0; r < N; r++) {
        const c = catCols[r];
        colorGrid[r][c] = r; // رقم اللون 0..N-1
        frontier.push({ r, c, color: r });
    }

    const dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    let unassigned = N * N - N;

    let guard = 0;
    while (unassigned > 0 && guard < 5000) {
        guard++;
        // إذا وصلت كل المناطق المفتوحة للحد الأقصى، ارفع الحد الأقصى
        if (guard > 400) regionMaxCap.fill(N * N);

        const idx = rng.nextInt(frontier.length);
        const cell = frontier[idx];
        const color = cell.color;

        if (regionSizes[color] >= regionMaxCap[color]) continue;

        const shuffledDirs = rng.shuffle(dirs);
        let expanded = false;
        for (const [dr, dc] of shuffledDirs) {
            const nr = cell.r + dr;
            const nc = cell.c + dc;
            if (nr >= 0 && nr < N && nc >= 0 && nc < N && colorGrid[nr][nc] === -1) {
                colorGrid[nr][nc] = color;
                regionSizes[color]++;
                unassigned--;
                frontier.push({ r: nr, c: nc, color });
                expanded = true;
                break;
            }
        }
    }

    // تعبئة أي خلية متبقية بأقرب لون مجاور
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

// --- حالة اللعب المحفوظة ---
let saveState = JSON.parse(localStorage.getItem('meowdoku_regions_save')) || {
    currentLevel: 1,
    completed: {},
    score: 0,
    boosters: { cat: 7, hint: 9, mouse: 2 }
};

function persistSave() {
    localStorage.setItem('meowdoku_regions_save', JSON.stringify(saveState));
}

let game = {
    level: 1,
    N: 9,
    catCols: [],
    colorGrid: [],
    boardState: [], // 0 = empty, 1 = X, 2 = Cat
    lives: 3
};

// --- عناصر الواجهة ---
const levelScreen = document.getElementById('level-screen');
const gameScreen = document.getElementById('game-screen');
const boardEl = document.getElementById('regions-board');
const silhouettesBar = document.getElementById('cat-silhouettes-bar');

function startLevel(lvl) {
    game.level = lvl;
    saveState.currentLevel = lvl;
    persistSave();

    const puzzle = generateRegionsPuzzle(lvl);
    game.N = puzzle.N;
    game.catCols = puzzle.catCols;
    game.colorGrid = puzzle.colorGrid;
    game.boardState = Array.from({ length: game.N }, () => new Array(game.N).fill(0));
    game.lives = 3;

    document.getElementById('level-num-display').textContent = lvl;
    document.getElementById('score-display').textContent = saveState.score;
    updateBoostersUI();
    renderLivesUI();
    renderSilhouettesBar();
    renderBoard();

    levelScreen.classList.remove('active');
    gameScreen.classList.add('active');
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
            if (game.boardState[r][c] === 2) {
                foundColors.add(game.colorGrid[r][c]);
            }
        }
    }
    silhouettesBar.querySelectorAll('.cat-sil').forEach(el => {
        const colIdx = parseInt(el.dataset.color);
        el.classList.toggle('found', foundColors.has(colIdx));
    });
}

function renderLivesUI() {
    const fishes = document.querySelectorAll('#lives-bar .fish-icon');
    fishes.forEach((f, idx) => {
        f.classList.toggle('lost', idx >= game.lives);
    });
}

function updateBoostersUI() {
    document.getElementById('badge-cat').textContent = saveState.boosters.cat;
    document.getElementById('badge-hint').textContent = saveState.boosters.hint;
    document.getElementById('badge-mouse').textContent = saveState.boosters.mouse;
}

function renderBoard() {
    const N = game.N;
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
                img.src = getActiveAvatarSrc();
                img.className = `tile-avatar ${settings.avatarMode === 'son' && settings.sonPhoto ? 'son-mode' : ''}`;
                tile.appendChild(img);
            }

            tile.addEventListener('click', () => onTileTap(r, c));
            boardEl.appendChild(tile);
        }
    }
}

// التحقق مما إذا كان وضع قطة في (r, c) يخالف القواعد الثلاث
function hasRuleViolation(r, c) {
    // هل هي الخلية الصحيحة للحل؟
    if (game.catCols[r] !== c) return true;

    const myColor = game.colorGrid[r][c];
    for (let rr = 0; rr < game.N; rr++) {
        for (let cc = 0; cc < game.N; cc++) {
            if (rr === r && cc === c) continue;
            if (game.boardState[rr][cc] === 2) {
                if (rr === r || cc === c) return true; // نفس الصف أو العمود
                if (game.colorGrid[rr][cc] === myColor) return true; // نفس اللون
                if (Math.abs(rr - r) <= 1 && Math.abs(cc - c) <= 1) return true; // تلامس
            }
        }
    }
    return false;
}

// وضع علامات X تلقائياً حول القطة وفي صفها وعمودها ولونها
function autoFillXsAround(r, c) {
    if (!settings.autoX) return;
    const myColor = game.colorGrid[r][c];
    for (let rr = 0; rr < game.N; rr++) {
        for (let cc = 0; cc < game.N; cc++) {
            if (game.boardState[rr][cc] !== 0) continue;
            const sameRowCol = (rr === r || cc === c);
            const sameColor = (game.colorGrid[rr][cc] === myColor);
            const touching = (Math.abs(rr - r) <= 1 && Math.abs(cc - c) <= 1);
            if (sameRowCol || sameColor || touching) {
                game.boardState[rr][cc] = 1;
            }
        }
    }
}

function onTileTap(r, c) {
    const cur = game.boardState[r][c];
    if (cur === 0) {
        // الضغطة الأولى: وضع علامة X
        game.boardState[r][c] = 1;
        renderBoard();
    } else if (cur === 1) {
        // الضغطة الثانية: محاولة وضع القطة / صورة الابن
        placeCatAt(r, c);
    } else if (cur === 2) {
        // الضغطة الثالثة: مسح
        game.boardState[r][c] = 0;
        renderBoard();
        updateSilhouettesStatus();
    }
}

function placeCatAt(r, c) {
    if (hasRuleViolation(r, c)) {
        // إجابة خاطئة! تشغيل صوت الخطأ العشوائي وإنقاص سمكة
        sound.playWrong();
        game.lives--;
        renderLivesUI();

        const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
        if (tileEl) {
            tileEl.classList.add('error-shake');
            setTimeout(() => tileEl.classList.remove('error-shake'), 450);
        }

        if (game.lives <= 0) {
            setTimeout(() => {
                document.getElementById('lose-modal').classList.add('active');
            }, 350);
        }
        return;
    }

    // إجابة صحيحة! تشغيل صوت الصح العشوائي وإضافة النقاط
    game.boardState[r][c] = 2;
    autoFillXsAround(r, c);
    sound.playCorrect();

    saveState.score += 10;
    document.getElementById('score-display').textContent = saveState.score;
    persistSave();

    renderBoard();
    updateSilhouettesStatus();
    checkVictory();
}

function checkVictory() {
    let catsPlaced = 0;
    for (let r = 0; r < game.N; r++) {
        const c = game.catCols[r];
        if (game.boardState[r][c] === 2) catsPlaced++;
    }
    if (catsPlaced === game.N) {
        saveState.completed[game.level] = true;
        saveState.score += 50;
        persistSave();
        setTimeout(() => {
            sound.playWin();
            document.getElementById('win-level-num').textContent = game.level;
            document.getElementById('win-score-val').textContent = saveState.score;
            document.getElementById('win-modal').classList.add('active');
        }, 250);
    }
}

// --- الأزرار المساعدة الثلاثة بالأسفل (القطة، المصباح، الفأر) ---
document.getElementById('booster-cat').addEventListener('click', () => {
    if (saveState.boosters.cat <= 0) return;
    const unplacedRows = [];
    for (let r = 0; r < game.N; r++) {
        const c = game.catCols[r];
        if (game.boardState[r][c] !== 2) unplacedRows.push([r, c]);
    }
    if (unplacedRows.length === 0) return;
    saveState.boosters.cat--;
    updateBoostersUI();
    persistSave();

    const [r, c] = unplacedRows[Math.floor(Math.random() * unplacedRows.length)];
    placeCatAt(r, c);
});

document.getElementById('booster-hint').addEventListener('click', () => {
    if (saveState.boosters.hint <= 0) return;
    for (let r = 0; r < game.N; r++) {
        const c = game.catCols[r];
        if (game.boardState[r][c] !== 2) {
            saveState.boosters.hint--;
            updateBoostersUI();
            persistSave();
            const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
            if (tileEl) {
                tileEl.classList.add('hint-glow');
                setTimeout(() => tileEl.classList.remove('hint-glow'), 2500);
            }
            break;
        }
    }
});

document.getElementById('booster-mouse').addEventListener('click', () => {
    if (saveState.boosters.mouse <= 0) return;
    const wrongEmpty = [];
    for (let r = 0; r < game.N; r++) {
        for (let c = 0; c < game.N; c++) {
            if (game.boardState[r][c] === 0 && game.catCols[r] !== c) {
                wrongEmpty.push([r, c]);
            }
        }
    }
    if (wrongEmpty.length === 0) return;
    saveState.boosters.mouse--;
    updateBoostersUI();
    persistSave();

    // الفأر يضع X في 5 مربعات فارغة خاطئة
    wrongEmpty.sort(() => Math.random() - 0.5);
    wrongEmpty.slice(0, 5).forEach(([r, c]) => {
        game.boardState[r][c] = 1;
    });
    renderBoard();
});

// --- خريطة المستويات (1 - 120) ---
function renderLevelsGrid() {
    const grid = document.getElementById('levels-grid');
    grid.innerHTML = '';
    for (let i = 1; i <= TOTAL_LEVELS; i++) {
        const btn = document.createElement('button');
        const isDone = !!saveState.completed[i];
        btn.className = `lvl-btn ${isDone ? 'completed' : ''} ${i === game.level ? 'current' : ''}`;
        btn.innerHTML = `<div>${i}</div><div style="font-size:0.7rem">${isDone ? '🐾' : `${getGridSizeForLevel(i)}×${getGridSizeForLevel(i)}`}</div>`;
        btn.addEventListener('click', () => startLevel(i));
        grid.appendChild(btn);
    }
}

document.getElementById('back-btn').addEventListener('click', () => {
    if (gameScreen.classList.contains('active')) {
        gameScreen.classList.remove('active');
        levelScreen.classList.add('active');
        renderLevelsGrid();
    } else {
        levelScreen.classList.remove('active');
        gameScreen.classList.add('active');
    }
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

// --- نافذة الإعدادات (صورة الابن + 6 صوتيات صح + 6 صوتيات خطأ) ---
const settingsModal = document.getElementById('settings-modal');

document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        document.getElementById(btn.dataset.tab).classList.add('active');
    });
});

document.querySelectorAll('input[name="avatar-mode"]').forEach(radio => {
    radio.addEventListener('change', (e) => {
        settings.avatarMode = e.target.value;
        localStorage.setItem('meow_mode', settings.avatarMode);
        updateBoosterAvatar();
        renderBoard();
    });
});

document.getElementById('auto-x-toggle').addEventListener('change', (e) => {
    settings.autoX = e.target.checked;
    localStorage.setItem('meow_autox', settings.autoX);
});

document.getElementById('sound-toggle').addEventListener('change', (e) => {
    settings.soundEnabled = e.target.checked;
    localStorage.setItem('meow_sound', settings.soundEnabled);
});

// رفع وقص صورة وجه الابن تلقائياً
document.getElementById('son-photo-input').addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => {
        const img = new Image();
        img.onload = async () => {
            const canvas = document.createElement('canvas');
            const size = 200;
            canvas.width = size;
            canvas.height = size;
            const ctx = canvas.getContext('2d');
            const minDim = Math.min(img.width, img.height);
            ctx.drawImage(img, (img.width - minDim) / 2, (img.height - minDim) / 2, minDim, minDim, 0, 0, size, size);
            const dataUrl = canvas.toDataURL('image/jpeg', 0.88);
            settings.sonPhoto = dataUrl;
            settings.avatarMode = 'son';
            localStorage.setItem('meow_mode', 'son');
            await db.set('son_photo', dataUrl);
            renderSettingsUI();
            updateBoosterAvatar();
            renderBoard();
        };
        img.src = ev.target.result;
    };
    reader.readAsDataURL(file);
});

function renderAudioSlotsUI(containerId, mapObj, dbPrefix, labelText) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';
    for (let i = 1; i <= 6; i++) {
        const item = mapObj[i];
        const row = document.createElement('div');
        row.className = 'audio-row';
        row.innerHTML = `<span>🎵 <strong>${labelText} (${i}):</strong> ${item ? item.name : 'افتراضي'}</span>`;

        const actions = document.createElement('div');
        actions.className = 'audio-actions';

        if (item) {
            const playB = document.createElement('button');
            playB.className = 'mini-btn play';
            playB.textContent = '▶️';
            playB.onclick = () => new Audio(item.data).play();

            const delB = document.createElement('button');
            delB.className = 'mini-btn del';
            delB.textContent = '🗑️';
            delB.onclick = async () => {
                delete mapObj[i];
                await db.del(`${dbPrefix}${i}`);
                renderSettingsUI();
            };
            actions.appendChild(playB);
            actions.appendChild(delB);
        }

        const upLabel = document.createElement('label');
        upLabel.className = 'mini-btn up';
        upLabel.textContent = '📁 صوت';
        const inp = document.createElement('input');
        inp.type = 'file';
        inp.accept = 'audio/*';
        inp.style.display = 'none';
        inp.onchange = (e) => {
            const f = e.target.files[0];
            if (!f) return;
            const r = new FileReader();
            r.onload = async (ev) => {
                const entry = { name: f.name.slice(0, 15), data: ev.target.result };
                mapObj[i] = entry;
                await db.set(`${dbPrefix}${i}`, entry);
                renderSettingsUI();
            };
            r.readAsDataURL(f);
        };
        upLabel.appendChild(inp);
        actions.appendChild(upLabel);
        row.appendChild(actions);
        container.appendChild(row);
    }
}

function renderSettingsUI() {
    document.querySelectorAll('input[name="avatar-mode"]').forEach(r => {
        r.checked = (r.value === settings.avatarMode);
    });
    document.getElementById('auto-x-toggle').checked = settings.autoX;
    document.getElementById('sound-toggle').checked = settings.soundEnabled;
    updateBoosterAvatar();
    renderAudioSlotsUI('correct-audio-list', settings.correctSounds, 'correct_snd_', 'صوت صح');
    renderAudioSlotsUI('wrong-audio-list', settings.wrongSounds, 'wrong_snd_', 'صوت خطأ');
}

document.getElementById('settings-btn').addEventListener('click', () => {
    renderSettingsUI();
    settingsModal.classList.add('active');
});

document.getElementById('close-settings-btn').addEventListener('click', () => settingsModal.classList.remove('active'));
document.getElementById('save-close-btn').addEventListener('click', () => settingsModal.classList.remove('active'));

document.getElementById('reset-defaults-btn').addEventListener('click', async () => {
    await db.clear();
    settings.avatarMode = 'cat';
    settings.sonPhoto = null;
    settings.correctSounds = {};
    settings.wrongSounds = {};
    localStorage.setItem('meow_mode', 'cat');
    renderSettingsUI();
    renderBoard();
});

// تشغيل اللعبة عند التحميل
loadSettingsFromDB().then(() => {
    startLevel(saveState.currentLevel || 1);
});
JS_EOF

# 5. مزامنة ملفات الويب الجديدة مع مشروع الأندرويد ورفعها إلى GitHub لبناء الـ APK
echo "🔄 جاري مزامنة التعديلات مع مشروع الأندرويد (Capacitor Sync)..."
if ! grep -q "node_modules" .gitignore 2>/dev/null; then
  echo "node_modules/" >> .gitignore
fi

npx cap sync android

echo "🚀 جاري رفع التحديث إلى GitHub لبناء الـ APK الجديد تلقائياً..."
git add .
git commit -m "Update game to real Meowdoku Color Regions puzzle with 120 levels" || true
git push

echo "=================================================================="
echo "✅ تم تحديث اللعبة بالكامل لتطابق صورة Meowdoku (مناطق الألوان)!"
echo "📱 اذهب الآن إلى تبويب Actions في مستودعك على GitHub لتحميل ملف الـ APK الجاهز."
echo "=================================================================="
