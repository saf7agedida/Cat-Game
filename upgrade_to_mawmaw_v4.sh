#!/usr/bin/env bash
set -e

echo "🌟 جاري ترقية اللعبة بالكامل إلى هوية MawMaw الجديدة كلياً..."
cd /workspaces/Cat-Game

mkdir -p www/assets/cats
mkdir -p www/assets/sounds

# 1. تحديث capacitor.config.json و manifest.json باسم MawMaw
cat << 'CAP_EOF' > capacitor.config.json
{
  "appId": "com.custom.meowdoku",
  "appName": "MawMaw",
  "webDir": "www",
  "bundledWebRuntime": false
}
CAP_EOF

cat << 'MAN_EOF' > www/manifest.json
{
  "name": "MawMaw - ماوماو",
  "short_name": "MawMaw",
  "start_url": "index.html",
  "display": "standalone",
  "background_color": "#f3f0ff",
  "theme_color": "#6c5ce7",
  "orientation": "portrait"
}
MAN_EOF

# 2. توليد اللوجو المبهج + شخصية MawMaw الجديدة + أيقونات APK للأندرويد + ملفات الصوت
cat << 'ASSET_EOF' > generate_mawmaw_assets.js
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// أ) تصميم شخصية MawMaw المبهجة مع تاج النجوم (مختلفة تماماً عن اللعبة الأصلية)
const mawmawCharSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 140 140">
  <defs>
    <linearGradient id="furGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ff9f43"/>
      <stop offset="100%" stop-color="#ff6b6b"/>
    </linearGradient>
    <linearGradient id="crownGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffeaa7"/>
      <stop offset="100%" stop-color="#fdcb6e"/>
    </linearGradient>
  </defs>
  <!-- Glowing Aura Circle -->
  <circle cx="70" cy="74" r="56" fill="#fff5e6" stroke="#ff9f43" stroke-width="4"/>
  <!-- Cute Ears -->
  <polygon points="26,60 18,20 56,38" fill="url(#furGrad)" stroke="#2d3436" stroke-width="3.5" stroke-linejoin="round"/>
  <polygon points="114,60 122,20 84,38" fill="url(#furGrad)" stroke="#2d3436" stroke-width="3.5" stroke-linejoin="round"/>
  <polygon points="31,52 25,28 50,40" fill="#fab1a0"/>
  <polygon points="109,52 115,28 90,40" fill="#fab1a0"/>
  <!-- Main Head -->
  <ellipse cx="70" cy="78" rx="46" ry="42" fill="url(#furGrad)" stroke="#2d3436" stroke-width="3.5"/>
  <!-- White Cheeks Patch -->
  <ellipse cx="70" cy="86" rx="34" ry="26" fill="#ffffff"/>
  <!-- Rosy Blush -->
  <ellipse cx="40" cy="82" rx="7" ry="4.5" fill="#ff7675" opacity="0.7"/>
  <ellipse cx="100" cy="82" rx="7" ry="4.5" fill="#ff7675" opacity="0.7"/>
  <!-- Big Sparkly Anime Eyes -->
  <circle cx="50" cy="70" r="8.5" fill="#2d3436"/>
  <circle cx="90" cy="70" r="8.5" fill="#2d3436"/>
  <circle cx="47" cy="67" r="3.2" fill="#ffffff"/>
  <circle cx="87" cy="67" r="3.2" fill="#ffffff"/>
  <circle cx="53" cy="73" r="1.6" fill="#ffffff"/>
  <circle cx="93" cy="73" r="1.6" fill="#ffffff"/>
  <!-- Cute Nose & Big Joyful Smile -->
  <polygon points="65,78 75,78 70,84" fill="#e84393"/>
  <path d="M 56,86 Q 70,98 84,86 Z" fill="#ff7675" stroke="#2d3436" stroke-width="2.5" stroke-linejoin="round"/>
  <path d="M 56,86 Q 63,91 70,84 Q 77,91 84,86" fill="none" stroke="#2d3436" stroke-width="3" stroke-linecap="round"/>
  <!-- Little Crown on Top -->
  <polygon points="50,38 56,20 70,30 84,20 90,38" fill="url(#crownGrad)" stroke="#2d3436" stroke-width="2.5" stroke-linejoin="round"/>
  <circle cx="70" cy="25" r="3" fill="#e84393"/>
</svg>`;
fs.writeFileSync('www/assets/cats/main_cat.svg', mawmawCharSvg, 'utf8');

// ب) تصميم لوجو MawMaw الرسمي المبهج للواجهة
const mawmawLogoSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 360 100">
  <defs>
    <linearGradient id="badgeBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#6c5ce7"/>
      <stop offset="50%" stop-color="#a29bfe"/>
      <stop offset="100%" stop-color="#00cec9"/>
    </linearGradient>
    <linearGradient id="txtGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="100%" stop-color="#ffeaa7"/>
    </linearGradient>
  </defs>
  <rect x="6" y="8" width="348" height="84" rx="42" fill="url(#badgeBg)" stroke="#ffffff" stroke-width="4"/>
  <!-- Puzzle Tiles Decoration -->
  <rect x="24" y="24" width="24" height="24" rx="6" fill="#ff7675" transform="rotate(-12 36 36)" stroke="#fff" stroke-width="2"/>
  <rect x="46" y="48" width="24" height="24" rx="6" fill="#fdcb6e" transform="rotate(10 58 60)" stroke="#fff" stroke-width="2"/>
  <rect x="295" y="24" width="24" height="24" rx="6" fill="#55efc4" transform="rotate(14 307 36)" stroke="#fff" stroke-width="2"/>
  <rect x="278" y="50" width="22" height="22" rx="6" fill="#fd79a8" transform="rotate(-8 289 61)" stroke="#fff" stroke-width="2"/>
  <!-- Crown & Stars -->
  <text x="84" y="42" font-size="22">👑</text>
  <text x="255" y="40" font-size="20">✨</text>
  <!-- MawMaw Title -->
  <text x="180" y="64" font-family="'Segoe UI', Arial, sans-serif" font-size="42" font-weight="900" fill="url(#txtGrad)" stroke="#2d3436" stroke-width="2" text-anchor="middle" letter-spacing="1.5">MawMaw</text>
</svg>`;
fs.writeFileSync('www/assets/mawmaw_logo.svg', mawmawLogoSvg, 'utf8');

// ج) توليد أيقونة PNG حقيقية لتطبيق الأندرويد (ic_launcher.png) بدون مكتبات خارجية
function createMawMawPngIcon(size) {
  const raw = Buffer.alloc(size * (size * 4 + 1));
  const cx = size / 2, cy = size / 2;
  const rMax = size * 0.46;

  for (let y = 0; y < size; y++) {
    const rowStart = y * (size * 4 + 1);
    raw[rowStart] = 0; // filter type 0
    for (let x = 0; x < size; x++) {
      const idx = rowStart + 1 + x * 4;
      const dx = x - cx, dy = y - cy;
      const dist = Math.sqrt(dx * dx + dy * dy);

      // خلفية دائرية متدرجة بنفسجية/تركوازية مبهجة
      let r = 108, g = 92, b = 231, a = 255;
      if (dist > rMax) {
        a = 0;
      } else if (dist > rMax - 4) {
        r = 253; g = 203; b = 110; // إطار ذهبي
      } else {
        const t = (x + y) / (size * 2);
        r = Math.round(108 * (1 - t) + 0 * t);
        g = Math.round(92 * (1 - t) + 206 * t);
        b = Math.round(231 * (1 - t) + 201 * t);

        // رسم وجه القطة البرتقالي اللطيف في المنتصف
        const headDist = Math.sqrt(dx * dx + (dy - size * 0.04) * (dy - size * 0.04));
        const leftEar = (x > size * 0.22 && x < size * 0.42 && y > size * 0.18 && y < size * 0.45 && (x - size * 0.22) * 1.3 > (size * 0.45 - y) * 0.4);
        const rightEar = (x < size * 0.78 && x > size * 0.58 && y > size * 0.18 && y < size * 0.45 && (size * 0.78 - x) * 1.3 > (size * 0.45 - y) * 0.4);

        if (headDist < size * 0.29 || leftEar || rightEar) {
          r = 255; g = 159; b = 67; // برتقالي مبهج
        }
        // العينان
        const eyeL = Math.sqrt((x - size * 0.39) ** 2 + (y - size * 0.50) ** 2);
        const eyeR = Math.sqrt((x - size * 0.61) ** 2 + (y - size * 0.50) ** 2);
        if (eyeL < size * 0.045 || eyeR < size * 0.045) {
          r = 45; g = 52; b = 54;
        }
        // لمعة العين
        const glintL = Math.sqrt((x - size * 0.375) ** 2 + (y - size * 0.485) ** 2);
        const glintR = Math.sqrt((x - size * 0.595) ** 2 + (y - size * 0.485) ** 2);
        if (glintL < size * 0.016 || glintR < size * 0.016) {
          r = 255; g = 255; b = 255;
        }
        // الأنف الوردي
        const nose = Math.sqrt(dx * dx + (y - size * 0.58) ** 2);
        if (nose < size * 0.035) {
          r = 232; g = 67; b = 147;
        }
      }
      raw[idx] = r; raw[idx + 1] = g; raw[idx + 2] = b; raw[idx + 3] = a;
    }
  }

  function crc32(buf) {
    let c = -1;
    for (let i = 0; i < buf.length; i++) {
      c = (c >>> 8) ^ crcTable[(c ^ buf[i]) & 0xff];
    }
    return (c ^ -1) >>> 0;
  }
  const crcTable = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = (c & 1) ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1);
    crcTable[n] = c;
  }
  function makeChunk(type, data) {
    const len = Buffer.alloc(4); len.writeUInt32BE(data.length, 0);
    const typeBuf = Buffer.from(type);
    const crcBuf = Buffer.alloc(4);
    crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
    return Buffer.concat([len, typeBuf, data, crcBuf]);
  }

  const sig = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(size, 0); ihdr.writeUInt32BE(size, 4);
  ihdr[8] = 8; ihdr[9] = 6; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
  const idat = zlib.deflateSync(raw);
  return Buffer.concat([sig, makeChunk('IHDR', ihdr), makeChunk('IDAT', idat), makeChunk('IEND', Buffer.alloc(0))]);
}

const iconPng = createMawMawPngIcon(192);
fs.writeFileSync('www/assets/icon.png', iconPng);

// نسخ الأيقونة لمجلدات الأندرويد إن وجدت
const mipmapDirs = ['mipmap-mdpi', 'mipmap-hdpi', 'mipmap-xhdpi', 'mipmap-xxhdpi', 'mipmap-xxxhdpi'];
mipmapDirs.forEach(dir => {
  const fullDir = path.join('android/app/src/main/res', dir);
  if (fs.existsSync(fullDir)) {
    fs.writeFileSync(path.join(fullDir, 'ic_launcher.png'), iconPng);
    fs.writeFileSync(path.join(fullDir, 'ic_launcher_round.png'), iconPng);
    fs.writeFileSync(path.join(fullDir, 'ic_launcher_foreground.png'), iconPng);
  }
});

// تحديث اسم التطبيق في strings.xml للأندرويد ليظهر MawMaw تحت الأيقونة
const stringsPath = 'android/app/src/main/res/values/strings.xml';
if (fs.existsSync(stringsPath)) {
  let xml = fs.readFileSync(stringsPath, 'utf8');
  xml = xml.replace(/<string name="app_name">.*?<\/string>/, '<string name="app_name">MawMaw</string>');
  xml = xml.replace(/<string name="title_activity_main">.*?<\/string>/, '<string name="title_activity_main">MawMaw</string>');
  fs.writeFileSync(stringsPath, xml, 'utf8');
}

console.log("✅ تم توليد لوجو MawMaw، الشخصية الجديدة، وأيقونات الأندرويد بنجاح!");
ASSET_EOF

node generate_mawmaw_assets.js
rm generate_mawmaw_assets.js

# 3. تعديل MainActivity.java للأندرويد لمعالجة زر الرجوع الفعلي (Hardware Back Button)
MAIN_ACT_PATH=$(find android/app/src/main/java -name "MainActivity.java" | head -n 1)
if [ -n "$MAIN_ACT_PATH" ]; then
  PKG_LINE=$(grep "^package " "$MAIN_ACT_PATH" | head -n 1)
  cat << JAVA_EOF > "$MAIN_ACT_PATH"
$PKG_LINE

import android.os.Bundle;
import androidx.activity.OnBackPressedCallback;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                if (getBridge() != null && getBridge().getWebView() != null) {
                    getBridge().getWebView().evaluateJavascript(
                        "(function(){ return window.onHardwareBackPress ? window.onHardwareBackPress() : 'EXIT_NOW'; })()",
                        value -> {
                            if ("\"EXIT_NOW\"".equals(value)) {
                                finish();
                            }
                        }
                    );
                } else {
                    finish();
                }
            }
        });
    }
}
JAVA_EOF
  echo "✅ تم ربط زر الرجوع في الأندرويد (MainActivity.java) بنجاح!"
fi

# 4. إنشاء ملف www/index.html بالهوية الجديدة + عجلة الحظ + الكؤوس + نافذة الخروج + قائمة الـ Cheats السرية
cat << 'HTML_EOF' > www/index.html
<!DOCTYPE html>
<html lang="ar" dir="rtl" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#6c5ce7">
    <title>MawMaw - ماوماو</title>
    <link rel="manifest" href="manifest.json">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Confetti Canvas -->
    <canvas id="confetti-canvas"></canvas>

    <div class="app-container">
        <!-- Top Header -->
        <header class="top-bar">
            <button id="nav-back-btn" class="nav-glass-btn" title="Back">👥</button>

            <!-- Secret Cheat Trigger: Tap Logo 5 times quickly! -->
            <div id="top-logo-wrap" class="top-logo-wrap" title="MawMaw">
                <img src="assets/mawmaw_logo.svg" alt="MawMaw Logo" class="header-logo-img">
            </div>

            <div class="top-stats" id="top-game-stats" style="display:none;">
                <div class="stat-pill">
                    <span class="stat-label" data-i18n="level">المستوى</span>
                    <span id="level-num-display" class="stat-val">1</span>
                </div>
                <div class="stat-pill">
                    <span class="stat-label" data-i18n="score">النقاط</span>
                    <span id="score-display" class="stat-val">0</span>
                </div>
            </div>

            <button id="settings-btn" class="nav-glass-btn" title="Settings">⚙️</button>
        </header>

        <!-- 1. HOME SCREEN -->
        <main id="home-screen" class="screen active">
            <div class="home-card">
                <!-- Active Profile Banner -->
                <div class="hero-profile-strip">
                    <div class="avatar-ring">
                        <img id="home-profile-img" src="assets/cats/main_cat.svg" alt="Avatar" class="home-avatar">
                    </div>
                    <div class="home-profile-info">
                        <span class="welcome-sub" data-i18n="welcomePlayer">مرحباً بالبطل:</span>
                        <h2 id="home-profile-name">ماوماو</h2>
                    </div>
                    <button id="quick-swap-btn" class="swap-btn" data-i18n="changeProfile">تبديل 👥</button>
                </div>

                <!-- Progress Stats -->
                <div class="home-stats-grid">
                    <div class="stat-card-box">
                        <span class="sc-icon">🔓</span>
                        <span class="sc-title" data-i18n="unlockedLvl">أعلى مستوى مفتوح</span>
                        <strong id="home-unlocked-val">1 / 120</strong>
                    </div>
                    <div class="stat-card-box">
                        <span class="sc-icon">⭐</span>
                        <span class="sc-title" data-i18n="totalScore">مجموع النقاط</span>
                        <strong id="home-score-val">0</strong>
                    </div>
                </div>

                <!-- Main Navigation Buttons -->
                <div class="home-menu-btns">
                    <button id="play-now-btn" class="btn-play-main">
                        🚀 <span data-i18n="playNow">العب الآن</span> (<span data-i18n="level">المستوى</span> <span id="play-btn-lvl">1</span>)
                    </button>

                    <div class="home-sub-grid">
                        <button id="open-levels-btn" class="btn-sub-card mint">
                            <span class="sub-icon">🗺️</span>
                            <span data-i18n="levelsMap">خريطة المستويات</span>
                        </button>
                        <button id="open-wheel-btn" class="btn-sub-card sunny">
                            <span class="sub-icon">🎡</span>
                            <span data-i18n="luckyWheel">عجلة الهدايا</span>
                        </button>
                        <button id="open-trophies-btn" class="btn-sub-card coral">
                            <span class="sub-icon">🏆</span>
                            <span data-i18n="trophiesRoom">غرفة الكؤوس</span>
                        </button>
                        <button id="open-settings-home-btn" class="btn-sub-card purple">
                            <span class="sub-icon">⚙️</span>
                            <span data-i18n="settingsAndProfiles">البروفايلات والإعدادات</span>
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <!-- 2. LEVELS MAP SCREEN (Locked Progression per Profile) -->
        <main id="level-screen" class="screen">
            <div class="section-banner">
                <h2 data-i18n="levelsMapTitle">🗺️ مراحل مغامرة MawMaw</h2>
                <p data-i18n="levelsMapSub">افتح المراحل واحدة تلو الأخرى واجمع النجوم الثلاث لكل مرحلة!</p>
            </div>
            <div id="levels-grid" class="levels-grid"></div>
        </main>

        <!-- 3. TROPHIES & STICKERS ROOM SCREEN (New Feature!) -->
        <main id="trophies-screen" class="screen">
            <div class="section-banner">
                <h2 data-i18n="trophiesTitle">🏆 غرفة الكؤوس والأوسمة</h2>
                <p data-i18n="trophiesSub">العب واربح المستويات لتفتح أوسمة الأبطال الخاصة ببروفايلك!</p>
            </div>
            <div id="trophies-grid" class="trophies-grid"></div>
        </main>

        <!-- 4. GAME SCREEN (Distinct MawMaw Arcade Look) -->
        <main id="game-screen" class="screen">
            <!-- Region Progress + 3 Energy Hearts -->
            <div class="game-hud-bar" dir="ltr">
                <div id="region-gems-bar" class="gems-pill"></div>
                <div id="lives-bar" class="hearts-pill">
                    <span class="heart-icon">💖</span>
                    <span class="heart-icon">💖</span>
                    <span class="heart-icon">💖</span>
                </div>
            </div>

            <!-- Distinct MawMaw Rules Pills -->
            <div class="mawmaw-rules-bar">
                <div class="m-rule-chip">🎨 <span data-i18n="mRule1">واحد بكل لون</span></div>
                <div class="m-rule-chip">📏 <span data-i18n="mRule2">واحد بكل صف وعمود</span></div>
                <div class="m-rule-chip">🚫 <span data-i18n="mRule3">ممنوع التلامس</span></div>
            </div>

            <!-- 3D Tactile Puzzle Board -->
            <div class="board-frame">
                <div id="regions-board" class="regions-board" dir="ltr"></div>
            </div>

            <!-- Tap Guide -->
            <div class="tap-hint-pill" data-i18n="tapGuide">
                ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع الشخصية</strong>
            </div>

            <!-- Distinct MawMaw Power-ups -->
            <div class="powerups-dock" dir="ltr">
                <button id="booster-wand" class="power-btn wand-theme">
                    <img id="booster-cat-img" src="assets/cats/main_cat.svg" alt="Wand" class="power-avatar">
                    <span class="power-mini-icon">🪄</span>
                    <span id="badge-cat" class="power-count">7</span>
                </button>
                <button id="booster-compass" class="power-btn compass-theme">
                    <span class="power-emoji">🧭</span>
                    <span id="badge-hint" class="power-count">9</span>
                </button>
                <button id="booster-zap" class="power-btn zap-theme">
                    <span class="power-emoji">⚡</span>
                    <span id="badge-mouse" class="power-count">2</span>
                </button>
            </div>
        </main>

        <!-- LUCKY WHEEL MODAL (New Feature!) -->
        <div id="wheel-modal" class="modal">
            <div class="modal-content wheel-box">
                <div class="modal-header">
                    <h2 data-i18n="luckyWheelTitle">🎡 عجلة هدايا MawMaw</h2>
                    <button id="close-wheel-btn" class="close-x">✖</button>
                </div>
                <p class="modal-sub-text" data-i18n="luckyWheelSub">لف العجلة واربح مساعدات ونقاط مجانية لبروفايلك!</p>

                <div class="wheel-stage">
                    <div class="wheel-pointer">🔻</div>
                    <div id="lucky-wheel-disc" class="lucky-wheel-disc">
                        <div class="wheel-label" style="--rot: 30deg;">🪄 +2</div>
                        <div class="wheel-label" style="--rot: 90deg;">🧭 +3</div>
                        <div class="wheel-label" style="--rot: 150deg;">⚡ +2</div>
                        <div class="wheel-label" style="--rot: 210deg;">⭐ +100</div>
                        <div class="wheel-label" style="--rot: 270deg;">🎁 الكل +1</div>
                        <div class="wheel-label" style="--rot: 330deg;">🪄 +3</div>
                    </div>
                </div>

                <div id="wheel-prize-msg" class="wheel-prize-msg"></div>
                <button id="spin-wheel-btn" class="btn-play-main" data-i18n="spinNowBtn">🎲 لف العجلة الآن!</button>
            </div>
        </div>

        <!-- PROFILE PICKER MODAL -->
        <div id="profile-picker-modal" class="modal">
            <div class="modal-content profile-picker-box">
                <h2 data-i18n="whoIsPlaying">👋 من سيلعب اليوم؟</h2>
                <p class="modal-sub-text" data-i18n="chooseProfileSub">اختر البروفايل الخاص بك للبدء بصورتك وأصواتك ومراحلك:</p>
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
                    <!-- Tap Title 5 times also triggers Secret Cheat Menu -->
                    <h2 id="settings-secret-trigger" data-i18n="settingsTitle">⚙️ الإعدادات والبروفايلات</h2>
                    <button id="close-settings-btn" class="close-x">✖</button>
                </div>

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

                <!-- Tab 1: Profiles -->
                <div id="tab-profiles" class="tab-pane active">
                    <p class="tab-hint" data-i18n="profilesHint">اختر البروفايل النشط، أو أضف بروفايل جديد لكل ابن بصورته وأصواته ومستوياته المستقلة:</p>
                    <div id="profiles-list-container" class="profiles-list"></div>

                    <div class="new-profile-card">
                        <h3 data-i18n="addKidProfileTitle">➕ إضافة بروفايل طفل جديد</h3>
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
                            <span data-i18n="autoXLabel">وضع علامات (✕) تلقائياً حول الإجابة الصحيحة</span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <label>
                            <input type="checkbox" id="sound-toggle" checked>
                            <span data-i18n="soundToggleLabel">تشغيل المؤثرات الصوتية 🔊</span>
                        </label>
                    </div>
                </div>

                <!-- Tab 2: 6 Correct Sounds -->
                <div id="tab-correct" class="tab-pane">
                    <div class="active-prof-banner">
                        <span data-i18n="editingSoundsFor">تخصيص أصوات البروفايل النشط:</span>
                        <strong id="correct-tab-prof-name"></strong>
                    </div>
                    <p class="tab-hint" data-i18n="correctSoundsHint">أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الصحيحة:</p>
                    <div id="correct-audio-list" class="audio-list"></div>
                </div>

                <!-- Tab 3: 6 Wrong Sounds -->
                <div id="tab-wrong" class="tab-pane">
                    <div class="active-prof-banner">
                        <span data-i18n="editingSoundsFor">تخصيص أصوات البروفايل النشط:</span>
                        <strong id="wrong-tab-prof-name"></strong>
                    </div>
                    <p class="tab-hint" data-i18n="wrongSoundsHint">أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الخاطئة:</p>
                    <div id="wrong-audio-list" class="audio-list"></div>
                </div>

                <div class="modal-footer">
                    <button id="save-close-btn" class="primary-btn" data-i18n="doneBtn">تم ✅</button>
                </div>
            </div>
        </div>

        <!-- SECRET CHEAT MODAL (Triggered by 5 Taps on Logo) -->
        <div id="cheat-modal" class="modal">
            <div class="modal-content cheat-box">
                <div class="modal-header">
                    <h2>🕵️‍♂️ لوحة الأسرار (Secret Cheats)</h2>
                    <button id="close-cheat-btn" class="close-x">✖</button>
                </div>
                <p class="modal-sub-text">تحكم سري خاص بك للبروفايل الحالي (<strong id="cheat-prof-name"></strong>):</p>

                <div class="cheat-actions">
                    <button id="cheat-unlock-all-btn" class="cheat-btn gold">
                        🔓 فتح جميع الـ 120 مستوى فوراً
                    </button>
                    <button id="cheat-add-boosters-btn" class="cheat-btn mint">
                        🎁 إضافة +50 لكل المساعدات (🪄 🧭 ⚡)
                    </button>
                    <button id="cheat-add-score-btn" class="cheat-btn purple">
                        🏆 إضافة +1000 نقطة وفتح كل الكؤوس
                    </button>

                    <div class="cheat-jump-row">
                        <input type="number" id="cheat-level-input" min="1" max="120" placeholder="رقم المستوى (1-120)" class="text-input">
                        <button id="cheat-jump-btn" class="primary-btn">انتقال 🚀</button>
                    </div>
                </div>
                <div id="cheat-status-msg" class="cheat-status-msg"></div>
            </div>
        </div>

        <!-- EXIT CONFIRMATION MODAL (When pressing Back on Home Screen) -->
        <div id="exit-confirm-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">🐾 👋</div>
                <h2 data-i18n="exitConfirmTitle">هل تريد الخروج من MawMaw؟</h2>
                <p class="win-score-line" data-i18n="exitConfirmSub">تم حفظ تقدمك وجميع نقاطك تلقائياً.</p>
                <div class="modal-footer">
                    <button id="stay-in-game-btn" class="primary-btn" data-i18n="stayBtn">البقاء في اللعبة ▶️</button>
                    <button id="confirm-exit-btn" class="secondary-btn danger-btn" data-i18n="exitNowBtn">خروج 🚪</button>
                </div>
            </div>
        </div>

        <!-- WIN MODAL -->
        <div id="win-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">🥳 🏆 🎉</div>
                <h2><span data-i18n="levelComplete">أحسنت! اكتمل المستوى</span> <span id="win-level-num"></span></h2>
                <div id="win-stars-row" class="win-stars-row">⭐⭐⭐</div>
                <p class="win-score-line"><span data-i18n="score">النقاط</span>: <strong id="win-score-val">0</strong></p>
                <div class="modal-footer">
                    <button id="next-level-btn" class="primary-btn" data-i18n="nextLevel">المستوى التالي ⬅️</button>
                </div>
            </div>
        </div>

        <!-- LOSE MODAL -->
        <div id="lose-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">💔 😿</div>
                <h2 data-i18n="outOfHearts">نفدت القلوب الثلاثة!</h2>
                <p class="win-score-line" data-i18n="loseHint">حاول مرة أخرى وتذكر: شخصية واحدة فقط في كل لون وصف وعمود بدون تلامس.</p>
                <div class="modal-footer">
                    <button id="retry-level-btn" class="primary-btn" data-i18n="retryBtn">إعادة المحاولة 🔄</button>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
HTML_EOF

# 5. إنشاء ملف التصميم الجديد كلياً (www/style.css) بهوية MawMaw المبهجة
cat << 'CSS_EOF' > www/style.css
:root {
    --bg-grad-start: #f3f0ff;
    --bg-grad-end: #e6fcf5;
    --card-bg: #ffffff;
    --primary: #6c5ce7;
    --primary-dark: #5243c2;
    --mint: #00cec9;
    --coral: #ff7675;
    --sunny: #fdcb6e;
    --text-main: #2d3436;
    --text-muted: #636e72;
    --soft-bg: #f8f6ff;
    --border-soft: #e2dcf5;
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
    background: linear-gradient(145deg, var(--bg-grad-start) 0%, var(--bg-grad-end) 100%);
    color: var(--text-main);
    display: flex;
    justify-content: center;
    min-height: 100vh;
    overflow-x: hidden;
}

#confetti-canvas {
    position: fixed;
    inset: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 400;
}

.app-container {
    width: 100%;
    max-width: 490px;
    padding: 10px 14px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Header */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 0;
}

.top-logo-wrap {
    cursor: pointer;
    transition: transform 0.15s;
    display: flex;
    align-items: center;
}
.top-logo-wrap:active { transform: scale(0.93); }
.header-logo-img {
    height: 44px;
    width: auto;
    filter: drop-shadow(0 3px 6px rgba(108, 92, 231, 0.25));
}

.nav-glass-btn {
    width: 44px;
    height: 44px;
    border-radius: 14px;
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    box-shadow: 0 4px 12px rgba(108, 92, 231, 0.1);
    font-size: 1.25rem;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: transform 0.15s;
}
.nav-glass-btn:active { transform: scale(0.9); }

.top-stats {
    display: flex;
    gap: 10px;
}
.stat-pill {
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    padding: 4px 12px;
    border-radius: 14px;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-width: 72px;
}
.stat-label { font-size: 0.7rem; color: var(--text-muted); font-weight: 700; }
.stat-val { font-size: 1.15rem; font-weight: 900; color: var(--primary); }

.screen { display: none; flex-direction: column; gap: 10px; }
.screen.active { display: flex; animation: screenPop 0.24s ease-out; }

@keyframes screenPop {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Home Screen */
.home-card {
    background: var(--card-bg);
    border-radius: 26px;
    padding: 18px;
    box-shadow: 0 10px 28px rgba(108, 92, 231, 0.12);
    border: 2px solid #ffffff;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.hero-profile-strip {
    display: flex;
    align-items: center;
    gap: 12px;
    background: linear-gradient(135deg, #f3f0ff 0%, #e8fbf8 100%);
    padding: 12px 14px;
    border-radius: 20px;
    border: 2px solid var(--border-soft);
}

.avatar-ring {
    width: 66px;
    height: 66px;
    border-radius: 50%;
    padding: 3px;
    background: linear-gradient(135deg, var(--primary), var(--mint));
    flex-shrink: 0;
}
.home-avatar {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    background: #fff;
    border: 2px solid #fff;
}

.home-profile-info { flex: 1; }
.welcome-sub { font-size: 0.78rem; color: var(--text-muted); font-weight: 600; }
.home-profile-info h2 { font-size: 1.25rem; color: var(--primary-dark); font-weight: 900; }

.swap-btn {
    background: var(--card-bg);
    border: 2px solid var(--primary);
    color: var(--primary);
    padding: 7px 12px;
    border-radius: 12px;
    font-weight: 800;
    font-size: 0.8rem;
    cursor: pointer;
}

.home-stats-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}
.stat-card-box {
    background: var(--soft-bg);
    border: 1.5px solid var(--border-soft);
    border-radius: 18px;
    padding: 12px;
    text-align: center;
    display: flex;
    flex-direction: column;
    gap: 3px;
}
.sc-icon { font-size: 1.35rem; }
.sc-title { font-size: 0.75rem; color: var(--text-muted); font-weight: 700; }
.stat-card-box strong { font-size: 1.25rem; color: var(--text-main); font-weight: 900; }

.home-menu-btns {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.btn-play-main {
    width: 100%;
    background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
    color: #fff;
    border: none;
    padding: 16px;
    border-radius: 18px;
    font-size: 1.15rem;
    font-weight: 900;
    cursor: pointer;
    box-shadow: 0 6px 18px rgba(108, 92, 231, 0.35);
    transition: transform 0.15s;
}
.btn-play-main:active { transform: scale(0.96); }

.home-sub-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}
.btn-sub-card {
    border: none;
    border-radius: 18px;
    padding: 14px 10px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    font-weight: 800;
    font-size: 0.88rem;
    cursor: pointer;
    transition: transform 0.15s;
    box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}
.btn-sub-card:active { transform: scale(0.95); }
.sub-icon { font-size: 1.65rem; }

.btn-sub-card.mint { background: #e3fafc; color: #0b7285; border: 2px solid #99e9f2; }
.btn-sub-card.sunny { background: #fff9db; color: #e67700; border: 2px solid #ffec99; }
.btn-sub-card.coral { background: #fff0f6; color: #a61e4d; border: 2px solid #fcc2d7; }
.btn-sub-card.purple { background: #f3f0ff; color: #5f3dc4; border: 2px solid #d0bfff; }

/* Section Banner & Levels Grid */
.section-banner {
    background: var(--card-bg);
    padding: 14px;
    border-radius: 20px;
    text-align: center;
    border: 2px solid var(--border-soft);
}
.section-banner h2 { color: var(--primary-dark); font-size: 1.15rem; margin-bottom: 4px; }
.section-banner p { font-size: 0.8rem; color: var(--text-muted); }

.levels-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(72px, 1fr));
    gap: 9px;
    max-height: 68vh;
    overflow-y: auto;
    padding: 4px;
}

.lvl-btn {
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    border-radius: 16px;
    padding: 10px 4px;
    text-align: center;
    cursor: pointer;
    font-weight: 800;
    color: var(--text-main);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 3px;
    box-shadow: 0 3px 0 var(--border-soft);
    transition: transform 0.12s;
}
.lvl-btn:active { transform: translateY(2px); }
.lvl-btn.completed {
    background: #e6fcf5;
    border-color: #63e6be;
    box-shadow: 0 3px 0 #63e6be;
}
.lvl-btn.current {
    background: #fff9db;
    border-color: #fcc419;
    box-shadow: 0 3px 0 #fcc419;
}
.lvl-btn.locked {
    background: #f1f3f5;
    border-color: #dee2e6;
    color: #adb5bd;
    box-shadow: none;
    cursor: not-allowed;
    opacity: 0.72;
}

/* Trophies Grid */
.trophies-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
    gap: 10px;
    max-height: 68vh;
    overflow-y: auto;
    padding: 4px;
}
.trophy-card {
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    border-radius: 18px;
    padding: 12px 8px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 5px;
}
.trophy-card.unlocked {
    background: linear-gradient(145deg, #fff9db, #ffffff);
    border-color: #fcc419;
    box-shadow: 0 4px 12px rgba(252, 196, 25, 0.2);
}
.trophy-card.locked {
    filter: grayscale(100%);
    opacity: 0.55;
}
.trophy-icon { font-size: 2.2rem; }
.trophy-title { font-size: 0.82rem; font-weight: 800; color: var(--text-main); }
.trophy-desc { font-size: 0.68rem; color: var(--text-muted); }

/* Game Screen HUD */
.game-hud-bar {
    display: flex;
    gap: 8px;
    align-items: center;
    justify-content: space-between;
}

.gems-pill {
    flex: 1;
    background: var(--card-bg);
    padding: 7px 10px;
    border-radius: 20px;
    border: 2px solid var(--border-soft);
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 6px;
    min-height: 40px;
}
.region-gem {
    width: 20px;
    height: 20px;
    border-radius: 6px;
    transform: rotate(45deg) scale(0.75);
    opacity: 0.35;
    border: 2px solid rgba(0,0,0,0.15);
    transition: all 0.3s cubic-bezier(0.18, 0.89, 0.32, 1.3);
}
.region-gem.found {
    opacity: 1;
    transform: rotate(0deg) scale(1.1);
    border-radius: 50%;
    box-shadow: 0 2px 6px rgba(0,0,0,0.22);
}

.hearts-pill {
    background: var(--card-bg);
    padding: 6px 12px;
    border-radius: 20px;
    border: 2px solid var(--border-soft);
    display: flex;
    gap: 4px;
    align-items: center;
    min-height: 40px;
}
.heart-icon {
    font-size: 1.2rem;
    transition: all 0.35s ease;
}
.heart-icon.lost {
    opacity: 0.2;
    filter: grayscale(100%);
    transform: scale(0.7);
}

.mawmaw-rules-bar {
    display: flex;
    justify-content: space-between;
    gap: 6px;
}
.m-rule-chip {
    flex: 1;
    background: var(--card-bg);
    border: 1.5px solid var(--border-soft);
    border-radius: 12px;
    padding: 6px 4px;
    text-align: center;
    font-size: 0.72rem;
    font-weight: 800;
    color: var(--primary-dark);
}

/* 3D Tactile Board */
.board-frame {
    background: #2d3436;
    padding: 10px;
    border-radius: 24px;
    box-shadow: 0 10px 25px rgba(45, 52, 54, 0.22);
    display: flex;
    justify-content: center;
    align-items: center;
}

.regions-board {
    display: grid;
    width: 100%;
    aspect-ratio: 1 / 1;
    gap: 4px;
}

.tile {
    border-radius: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    position: relative;
    box-shadow: inset 0 2px 0 rgba(255,255,255,0.45), inset 0 -3px 0 rgba(0,0,0,0.18);
    transition: transform 0.1s;
    overflow: visible;
}

.tile-x {
    font-size: 1.2rem;
    font-weight: 900;
    color: rgba(30, 35, 40, 0.65);
    pointer-events: none;
    animation: xPopIn 0.22s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}
.tile-x.removing { animation: xPopOut 0.17s ease-in forwards; }

@keyframes xPopIn {
    0% { transform: scale(0.2) rotate(-45deg); opacity: 0; }
    70% { transform: scale(1.25) rotate(8deg); opacity: 1; }
    100% { transform: scale(1) rotate(0deg); opacity: 1; }
}
@keyframes xPopOut {
    0% { transform: scale(1); opacity: 1; }
    100% { transform: scale(0.1); opacity: 0; }
}

.tile-avatar {
    width: 84%;
    height: 84%;
    border-radius: 50%;
    object-fit: cover;
    pointer-events: none;
    filter: drop-shadow(0 3px 5px rgba(0,0,0,0.28));
    animation: catBounceIn 0.42s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}
.tile-avatar.kid-mode {
    border: 2.5px solid #ffffff;
    background: #fff;
}
.tile-avatar.removing { animation: xPopOut 0.17s ease-in forwards; }

@keyframes catBounceIn {
    0% { transform: scale(0.2) translateY(10px); opacity: 0; }
    55% { transform: scale(1.22) translateY(-4px); opacity: 1; }
    75% { transform: scale(0.92) translateY(1px); }
    100% { transform: scale(1) translateY(0); opacity: 1; }
}

.tile.correct-glow { animation: correctTilePulse 0.55s ease-out; }
@keyframes correctTilePulse {
    0% { box-shadow: 0 0 0 0 rgba(0, 206, 201, 0.85); }
    70% { box-shadow: 0 0 0 12px rgba(0, 206, 201, 0); }
    100% { box-shadow: 0 0 0 0 rgba(0, 206, 201, 0); }
}

.tile.error-shake {
    animation: wrongShake 0.45s cubic-bezier(0.36, 0.07, 0.19, 0.97);
    background-color: #ff5252 !important;
    outline: 3px solid #fff;
    z-index: 10;
}
@keyframes wrongShake {
    0%, 100% { transform: translateX(0); }
    20% { transform: translateX(-7px) rotate(-6deg); }
    40% { transform: translateX(7px) rotate(6deg); }
    60% { transform: translateX(-5px) rotate(-4deg); }
    80% { transform: translateX(5px) rotate(4deg); }
}

.fx-particle {
    position: absolute;
    pointer-events: none;
    z-index: 50;
    font-size: 1rem;
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
    background: #d63031;
    color: #fff;
    padding: 2px 7px;
    border-radius: 10px;
    font-size: 0.75rem;
    font-weight: 900;
    white-space: nowrap;
    pointer-events: none;
    z-index: 60;
    animation: floatUpWrong 0.85s ease-out forwards;
}
@keyframes floatUpWrong {
    0% { transform: translate(-50%, 5px) scale(0.7); opacity: 1; }
    30% { transform: translate(-50%, -14px) scale(1.1); opacity: 1; }
    100% { transform: translate(-50%, -32px) scale(0.9); opacity: 0; }
}

.tile.hint-glow {
    animation: pulseGlow 0.7s infinite alternate;
    outline: 3.5px solid #ffeaa7;
    z-index: 5;
}
@keyframes pulseGlow {
    from { transform: scale(0.93); }
    to { transform: scale(1.06); }
}

.tap-hint-pill {
    text-align: center;
    font-size: 0.75rem;
    color: var(--primary-dark);
    background: var(--card-bg);
    padding: 7px 10px;
    border-radius: 12px;
    border: 1.5px solid var(--border-soft);
}

/* Power-ups Dock */
.powerups-dock {
    display: flex;
    justify-content: center;
    gap: 22px;
}
.power-btn {
    width: 64px;
    height: 64px;
    border-radius: 20px;
    border: 2.5px solid #fff;
    box-shadow: 0 6px 16px rgba(108, 92, 231, 0.2);
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    cursor: pointer;
    transition: transform 0.15s;
}
.power-btn:active { transform: scale(0.9); }
.wand-theme { background: linear-gradient(135deg, #a29bfe, #6c5ce7); }
.compass-theme { background: linear-gradient(135deg, #81ecec, #00cec9); }
.zap-theme { background: linear-gradient(135deg, #ffeaa7, #fdcb6e); }

.power-avatar { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 2px solid #fff; background: #fff; }
.power-mini-icon { position: absolute; bottom: -4px; left: -4px; font-size: 1rem; }
.power-emoji { font-size: 1.9rem; }
.power-count {
    position: absolute;
    top: -6px;
    right: -6px;
    background: #ff7675;
    color: #fff;
    font-size: 0.75rem;
    font-weight: 900;
    min-width: 24px;
    height: 24px;
    padding: 0 5px;
    border-radius: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 2px solid #fff;
}

/* Lucky Wheel Modal */
.wheel-box { max-width: 390px; }
.wheel-stage {
    position: relative;
    width: 220px;
    height: 220px;
    margin: 12px auto;
}
.wheel-pointer {
    position: absolute;
    top: -16px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 1.8rem;
    z-index: 20;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
}
.lucky-wheel-disc {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 6px solid #fff;
    box-shadow: 0 6px 20px rgba(108, 92, 231, 0.25);
    background: conic-gradient(
        #ff7675 0deg 60deg,
        #fdcb6e 60deg 120deg,
        #55efc4 120deg 180deg,
        #74b9ff 180deg 240deg,
        #a29bfe 240deg 300deg,
        #fd79a8 300deg 360deg
    );
    position: relative;
    transition: transform 3.2s cubic-bezier(0.15, 0.85, 0.25, 1);
}
.wheel-label {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: rotate(var(--rot)) translateY(-72px);
    transform-origin: center center;
    font-size: 0.8rem;
    font-weight: 900;
    color: #fff;
    text-shadow: 0 1px 3px rgba(0,0,0,0.5);
    margin-left: -24px;
    margin-top: -10px;
    width: 48px;
    text-align: center;
}
.wheel-prize-msg {
    min-height: 26px;
    font-weight: 800;
    color: var(--primary-dark);
    margin-bottom: 8px;
}

/* Modals */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(30, 25, 50, 0.6);
    justify-content: center;
    align-items: center;
    padding: 14px;
    z-index: 300;
}
.modal.active { display: flex; }
.modal-content {
    background: var(--card-bg);
    padding: 20px;
    border-radius: 26px;
    width: 100%;
    max-width: 380px;
    text-align: center;
    box-shadow: 0 14px 36px rgba(0,0,0,0.28);
}

.profile-picker-box { max-width: 420px; }
.modal-sub-text { font-size: 0.82rem; color: var(--text-muted); margin: 6px 0 12px; }
.startup-profiles-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
    gap: 10px;
    max-height: 52vh;
    overflow-y: auto;
    padding: 4px;
}
.picker-card {
    background: var(--soft-bg);
    border: 2.5px solid var(--border-soft);
    border-radius: 18px;
    padding: 12px 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    cursor: pointer;
}
.picker-card.active {
    border-color: var(--primary);
    background: #f3f0ff;
}
.picker-card img {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #fff;
    background: #fff;
}

/* Settings & Secret Cheats */
.settings-box { max-width: 460px; max-height: 90vh; display: flex; flex-direction: column; text-align: start; }
.modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.modal-header h2 { font-size: 1.1rem; color: var(--primary-dark); cursor: pointer; }
.close-x { background: none; border: none; font-size: 1.3rem; cursor: pointer; color: var(--text-muted); }

.lang-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--soft-bg);
    padding: 8px 12px;
    border-radius: 12px;
    margin-bottom: 10px;
    font-size: 0.82rem;
    font-weight: bold;
}
.lang-btns { display: flex; gap: 6px; }
.lang-btn {
    padding: 5px 12px;
    border-radius: 8px;
    border: 1.5px solid var(--border-soft);
    background: #fff;
    cursor: pointer;
    font-weight: bold;
    font-size: 0.78rem;
}
.lang-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }

.settings-tabs { display: flex; gap: 6px; margin-bottom: 10px; }
.tab-btn {
    flex: 1;
    padding: 8px 4px;
    font-size: 0.75rem;
    font-weight: bold;
    background: var(--soft-bg);
    border: none;
    border-radius: 10px;
    color: var(--text-main);
    cursor: pointer;
}
.tab-btn.active { background: var(--primary); color: #fff; }

.tab-pane { display: none; overflow-y: auto; max-height: 50vh; padding: 2px; }
.tab-pane.active { display: block; }

.profiles-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 12px; }
.prof-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: var(--soft-bg);
    padding: 8px 10px;
    border-radius: 14px;
    border: 2px solid transparent;
}
.prof-item.active { border-color: var(--primary); background: #f3f0ff; }
.prof-item-left { display: flex; align-items: center; gap: 10px; }
.prof-item-left img { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; background: #fff; border: 2px solid var(--primary); }
.prof-item-actions { display: flex; gap: 5px; }

.new-profile-card {
    background: #fcfaff;
    border: 2px dashed var(--primary);
    border-radius: 16px;
    padding: 12px;
}
.new-profile-card h3 { font-size: 0.88rem; margin-bottom: 8px; color: var(--primary-dark); }
.form-row { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
.form-avatar-preview { width: 58px; height: 58px; border-radius: 50%; object-fit: cover; border: 2px solid var(--primary); background: #fff; flex-shrink: 0; }
.form-inputs { flex: 1; display: flex; flex-direction: column; gap: 6px; }
.text-input { width: 100%; padding: 8px 10px; border-radius: 10px; border: 1.5px solid var(--border-soft); font-size: 0.85rem; }
.upload-main-btn { display: inline-block; background: var(--primary); color: #fff; padding: 7px 12px; border-radius: 10px; font-weight: bold; font-size: 0.78rem; text-align: center; cursor: pointer; }
.full-w { width: 100%; }

.active-prof-banner { background: #f3f0ff; border: 1.5px solid var(--primary); padding: 8px 12px; border-radius: 10px; font-size: 0.8rem; margin-bottom: 8px; }
.toggle-row { background: var(--soft-bg); padding: 9px 12px; border-radius: 12px; margin-bottom: 6px; font-size: 0.8rem; font-weight: 600; }
.tab-hint { font-size: 0.78rem; margin-bottom: 8px; color: var(--text-muted); }
.audio-list { display: flex; flex-direction: column; gap: 7px; }
.audio-row { display: flex; justify-content: space-between; align-items: center; background: var(--soft-bg); padding: 7px 10px; border-radius: 12px; font-size: 0.78rem; }
.audio-actions { display: flex; gap: 5px; }
.mini-btn { padding: 5px 9px; border-radius: 8px; border: none; font-size: 0.73rem; font-weight: bold; cursor: pointer; }
.mini-btn.up { background: var(--primary); color: #fff; }
.mini-btn.play { background: #00cec9; color: #fff; }
.mini-btn.del { background: #ff7675; color: #fff; }

/* Cheat Modal */
.cheat-box { max-width: 400px; border: 3px solid var(--sunny); }
.cheat-actions { display: flex; flex-direction: column; gap: 10px; margin: 10px 0; }
.cheat-btn {
    padding: 12px;
    border-radius: 14px;
    border: none;
    font-weight: 900;
    font-size: 0.88rem;
    cursor: pointer;
}
.cheat-btn.gold { background: #ffeaa7; color: #d35400; }
.cheat-btn.mint { background: #81ecec; color: #006266; }
.cheat-btn.purple { background: #d0bfff; color: #4834d4; }
.cheat-jump-row { display: flex; gap: 8px; }
.cheat-status-msg { min-height: 22px; font-weight: 800; color: #00b894; font-size: 0.85rem; }

.modal-big-icon { font-size: 2.5rem; margin-bottom: 6px; }
.win-stars-row { font-size: 2rem; margin: 4px 0; }
.win-score-line { margin: 8px 0 14px; font-size: 0.92rem; }
.modal-footer { display: flex; gap: 8px; margin-top: 12px; }
.primary-btn, .secondary-btn {
    flex: 1;
    padding: 12px;
    border-radius: 14px;
    border: none;
    font-weight: 800;
    cursor: pointer;
}
.primary-btn { background: var(--primary); color: #fff; }
.secondary-btn { background: var(--soft-bg); color: var(--text-main); border: 1.5px solid var(--border-soft); }
.danger-btn { background: #ffe3e3; color: #c92a2a; border-color: #ffa8a8; }
CSS_EOF

# 6. إنشاء ملف www/script.js الكامل (قفل المستويات لكل بروفايل، زر الرجوع، عجلة الحظ، الكؤوس، والـ Cheats)
cat << 'JS_EOF' > www/script.js
// ألوان مناطق MawMaw المبهجة الجديدة (مختلفة عن اللعبة القديمة)
const REGION_COLORS = [
    '#ff9ff3', // 0: وردي كاندي
    '#feca57', // 1: أصفر مشمس
    '#48dbfb', // 2: سماوي مشرق
    '#1dd1a1', // 3: أخضر نعناعي
    '#ff6b6b', // 4: مرجاني دافئ
    '#a29bfe', // 5: لافندر بنفسجي
    '#ff9f43', // 6: برتقالي مانجو
    '#00d2d3', // 7: فيروزي
    '#c8d6e5'  // 8: فضي ناعم
];
const TOTAL_LEVELS = 120;

// قائمة الكؤوس والأوسمة الـ 12 (تفتح مع تقدم كل بروفايل)
const TROPHIES_LIST = [
    { id: 't1', icon: '🐣', reqLvl: 1, ar: 'البداية الشجاعة', en: 'Brave Starter', descAr: 'ابدأ رحلتك في ماوماو', descEn: 'Start your MawMaw journey' },
    { id: 't2', icon: '🌟', reqLvl: 3, ar: 'مكتشف الألوان', en: 'Color Explorer', descAr: 'افتح المستوى 3', descEn: 'Unlock Level 3' },
    { id: 't3', icon: '🧠', reqLvl: 7, ar: 'المفكر الذكي', en: 'Smart Thinker', descAr: 'افتح المستوى 7', descEn: 'Unlock Level 7' },
    { id: 't4', icon: '⚡', reqLvl: 12, ar: 'سريع البديهة', en: 'Quick Mind', descAr: 'افتح المستوى 12', descEn: 'Unlock Level 12' },
    { id: 't5', icon: '🛡️', reqLvl: 20, ar: 'فارس الألغاز', en: 'Puzzle Knight', descAr: 'افتح المستوى 20', descEn: 'Unlock Level 20' },
    { id: 't6', icon: '🎯', reqLvl: 30, ar: 'قناص المربعات', en: 'Tile Sniper', descAr: 'افتح المستوى 30', descEn: 'Unlock Level 30' },
    { id: 't7', icon: '🔥', reqLvl: 45, ar: 'البطل المتألق', en: 'Shining Hero', descAr: 'افتح المستوى 45', descEn: 'Unlock Level 45' },
    { id: 't8', icon: '💎', reqLvl: 60, ar: 'صائد الجواهر', en: 'Gem Hunter', descAr: 'افتح المستوى 60', descEn: 'Unlock Level 60' },
    { id: 't9', icon: '🚀', reqLvl: 75, ar: 'رائد المجرة', en: 'Galaxy Captain', descAr: 'افتح المستوى 75', descEn: 'Unlock Level 75' },
    { id: 't10', icon: '🦁', reqLvl: 90, ar: 'قلب الأسد', en: 'Lion Heart', descAr: 'افتح المستوى 90', descEn: 'Unlock Level 90' },
    { id: 't11', icon: '👑', reqLvl: 105, ar: 'ملك التركيز', en: 'Focus King', descAr: 'افتح المستوى 105', descEn: 'Unlock Level 105' },
    { id: 't12', icon: '🏆', reqLvl: 120, ar: 'أسطورة MawMaw', en: 'MawMaw Legend', descAr: 'الوصول للمستوى 120', descEn: 'Reach Level 120' }
];

// --- قاموس اللغتين العربية والإنجليزية ---
const I18N = {
    ar: {
        level: 'المستوى',
        score: 'النقاط',
        welcomePlayer: 'مرحباً بالبطل:',
        changeProfile: 'تبديل 👥',
        unlockedLvl: 'أعلى مستوى مفتوح',
        totalScore: 'مجموع النقاط',
        playNow: 'العب الآن',
        levelsMap: 'خريطة المستويات',
        luckyWheel: 'عجلة الهدايا',
        trophiesRoom: 'غرفة الكؤوس',
        settingsAndProfiles: 'البروفايلات والإعدادات',
        levelsMapTitle: '🗺️ مراحل مغامرة MawMaw',
        levelsMapSub: 'افتح المراحل واحدة تلو الأخرى واجمع النجوم الثلاث لكل مرحلة!',
        trophiesTitle: '🏆 غرفة الكؤوس والأوسمة',
        trophiesSub: 'العب واربح المستويات لتفتح أوسمة الأبطال الخاصة ببروفايلك!',
        mRule1: 'واحد بكل لون',
        mRule2: 'واحد بكل صف وعمود',
        mRule3: 'ممنوع التلامس',
        tapGuide: 'ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع الشخصية</strong>',
        luckyWheelTitle: '🎡 عجلة هدايا MawMaw',
        luckyWheelSub: 'لف العجلة واربح مساعدات ونقاط مجانية لبروفايلك!',
        spinNowBtn: '🎲 لف العجلة الآن!',
        whoIsPlaying: '👋 من سيلعب اليوم؟',
        chooseProfileSub: 'اختر البروفايل الخاص بك للبدء بصورتك وأصواتك ومراحلك:',
        addNewProfile: '➕ إضافة طفل جديد',
        settingsTitle: '⚙️ الإعدادات والبروفايلات',
        languageLabel: '🌐 اللغة / Language:',
        tabProfiles: '👥 البروفايلات',
        tabCorrect: '✅ أصوات الصح (6)',
        tabWrong: '❌ أصوات الخطأ (6)',
        profilesHint: 'اختر البروفايل النشط، أو أضف بروفايل جديد لكل ابن بصورته وأصواته ومستوياته المستقلة:',
        addKidProfileTitle: '➕ إضافة بروفايل طفل جديد',
        choosePhoto: 'اختر صورة الوجه',
        saveProfileBtn: 'حفظ البروفايل وتفعيله ✨',
        autoXLabel: 'وضع علامات (✕) تلقائياً حول الإجابة الصحيحة',
        soundToggleLabel: 'تشغيل المؤثرات الصوتية 🔊',
        editingSoundsFor: 'تخصيص أصوات البروفايل النشط:',
        correctSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الصحيحة:',
        wrongSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الخاطئة:',
        doneBtn: 'تم ✅',
        exitConfirmTitle: 'هل تريد الخروج من MawMaw؟',
        exitConfirmSub: 'تم حفظ تقدمك وجميع نقاطك تلقائياً.',
        stayBtn: 'البقاء في اللعبة ▶️',
        exitNowBtn: 'خروج 🚪',
        levelComplete: 'أحسنت! اكتمل المستوى',
        nextLevel: 'المستوى التالي ⬅️',
        outOfHearts: 'نفدت القلوب الثلاثة!',
        loseHint: 'حاول مرة أخرى وتذكر: شخصية واحدة فقط في كل لون وصف وعمود بدون تلامس.',
        retryBtn: 'إعادة المحاولة 🔄',
        defaultCatName: 'ماوماو',
        activeTag: 'نشط ✓',
        selectTag: 'اختيار',
        soundSlotCorrect: 'صوت صح',
        soundSlotWrong: 'صوت خطأ',
        defaultSound: 'افتراضي',
        uploadSound: '📁 صوت',
        kidNamePlaceholder: 'اسم الطفل (مثال: سيف)'
    },
    en: {
        level: 'Level',
        score: 'Score',
        welcomePlayer: 'Welcome Hero:',
        changeProfile: 'Switch 👥',
        unlockedLvl: 'Unlocked Level',
        totalScore: 'Total Score',
        playNow: 'Play Now',
        levelsMap: 'Levels Map',
        luckyWheel: 'Lucky Wheel',
        trophiesRoom: 'Trophy Room',
        settingsAndProfiles: 'Profiles & Settings',
        levelsMapTitle: '🗺️ MawMaw Adventure Map',
        levelsMapSub: 'Complete levels one by one to unlock the next challenge!',
        trophiesTitle: '🏆 Trophies & Badges Room',
        trophiesSub: 'Beat levels to unlock special hero trophies for your profile!',
        mRule1: '1 per Color',
        mRule2: '1 per Row & Col',
        mRule3: 'No Touching',
        tapGuide: '1 Tap = Toggle <strong>✕</strong> &nbsp;|&nbsp; Fast Double-Tap = <strong>Place Character</strong>',
        luckyWheelTitle: '🎡 MawMaw Lucky Wheel',
        luckyWheelSub: 'Spin the wheel to win free power-ups and bonus score!',
        spinNowBtn: '🎲 Spin Now!',
        whoIsPlaying: '👋 Who is playing today?',
        chooseProfileSub: 'Choose your profile to play with your photo, sounds & levels:',
        addNewProfile: '➕ Add New Kid Profile',
        settingsTitle: '⚙️ Settings & Profiles',
        languageLabel: '🌐 Language / اللغة:',
        tabProfiles: '👥 Profiles',
        tabCorrect: '✅ Correct Audio (6)',
        tabWrong: '❌ Wrong Audio (6)',
        profilesHint: 'Select active profile, or create a new profile for each kid with independent levels:',
        addKidProfileTitle: '➕ Add New Kid Profile',
        choosePhoto: 'Choose Face Photo',
        saveProfileBtn: 'Save & Activate Profile ✨',
        autoXLabel: 'Auto-place (✕) around correct character',
        soundToggleLabel: 'Enable Sound Effects 🔊',
        editingSoundsFor: 'Customizing sounds for active profile:',
        correctSoundsHint: 'Add up to 6 sounds played randomly when placing in the right spot:',
        wrongSoundsHint: 'Add up to 6 sounds played randomly when placing in a wrong spot:',
        doneBtn: 'Done ✅',
        exitConfirmTitle: 'Exit MawMaw Game?',
        exitConfirmSub: 'Your progress and stars are saved automatically.',
        stayBtn: 'Stay & Play ▶️',
        exitNowBtn: 'Exit 🚪',
        levelComplete: 'Awesome! Completed Level',
        nextLevel: 'Next Level ➡️',
        outOfHearts: 'Out of 3 Hearts!',
        loseHint: 'Try again! Remember: 1 per color, row, and column, and no touching.',
        retryBtn: 'Try Again 🔄',
        defaultCatName: 'MawMaw',
        activeTag: 'Active ✓',
        selectTag: 'Select',
        soundSlotCorrect: 'Correct',
        soundSlotWrong: 'Wrong',
        defaultSound: 'Default',
        uploadSound: '📁 Audio',
        kidNamePlaceholder: 'Kid Name (e.g. Saif)'
    }
};

// --- قاعدة بيانات IndexedDB لحفظ البروفايلات وتقدم المراحل ---
class StorageDB {
    constructor() { this.db = null; }
    init() {
        return new Promise((resolve) => {
            const req = indexedDB.open('MawMawProfilesDB_v4', 1);
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
    lang: localStorage.getItem('mawmaw_lang') || 'ar',
    autoX: localStorage.getItem('mawmaw_autox') !== 'false',
    soundEnabled: localStorage.getItem('mawmaw_sound') !== 'false',
    activeProfileId: localStorage.getItem('mawmaw_active_prof') || 'default_cat'
};

let profiles = [];

function createDefaultProfile() {
    return {
        id: 'default_cat',
        name: 'ماوماو',
        isDefaultCat: true,
        photo: 'assets/cats/main_cat.svg',
        correctSounds: {},
        wrongSounds: {},
        currentLevel: 1,
        unlockedLevel: 1, // المستويات تفتح واحداً تلو الآخر
        stars: {},        // عدد النجوم لكل مستوى مكتمل
        score: 0,
        boosters: { cat: 7, hint: 9, mouse: 2 }
    };
}

function ensureProfileFields(p) {
    if (!p.unlockedLevel || p.unlockedLevel < 1) p.unlockedLevel = 1;
    if (!p.currentLevel || p.currentLevel < 1) p.currentLevel = 1;
    if (!p.stars) p.stars = {};
    if (!p.boosters) p.boosters = { cat: 7, hint: 9, mouse: 2 };
    if (!p.correctSounds) p.correctSounds = {};
    if (!p.wrongSounds) p.wrongSounds = {};
    return p;
}

function getActiveProfile() {
    let p = profiles.find(x => x.id === appPrefs.activeProfileId);
    if (!p) {
        p = profiles[0];
        appPrefs.activeProfileId = p.id;
    }
    return ensureProfileFields(p);
}

async function saveProfilesToDB() {
    await db.set('profiles_list', profiles);
    localStorage.setItem('mawmaw_active_prof', appPrefs.activeProfileId);
}

function applyLanguage(lang) {
    appPrefs.lang = lang;
    localStorage.setItem('mawmaw_lang', lang);
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
    const catProf = profiles.find(p => p.id === 'default_cat');
    if (catProf) catProf.name = dict.defaultCatName;

    updateHomeUI();
}

// --- نظام الصوتيات ---
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

// --- مطر الاحتفال الملون (Confetti) عند الفوز ---
function launchConfetti() {
    const canvas = document.getElementById('confetti-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const pieces = Array.from({ length: 65 }, () => ({
        x: Math.random() * canvas.width,
        y: -20 - Math.random() * 100,
        w: 8 + Math.random() * 6,
        h: 10 + Math.random() * 8,
        color: REGION_COLORS[Math.floor(Math.random() * REGION_COLORS.length)],
        vy: 3 + Math.random() * 4,
        vx: -2 + Math.random() * 4,
        rot: Math.random() * 360,
        vRot: -5 + Math.random() * 10
    }));

    let frame = 0;
    function tick() {
        frame++;
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        pieces.forEach(p => {
            p.x += p.vx;
            p.y += p.vy;
            p.rot += p.vRot;
            ctx.save();
            ctx.translate(p.x, p.y);
            ctx.rotate((p.rot * Math.PI) / 180);
            ctx.fillStyle = p.color;
            ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
            ctx.restore();
        });
        if (frame < 110) requestAnimationFrame(tick);
        else ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
    requestAnimationFrame(tick);
}

// --- إدارة الشاشات وزر الرجوع الفعلي للموبايل (خطوة للوراء + سؤال قبل الخروج) ---
let currentScreen = 'home'; // 'home' | 'levels' | 'trophies' | 'game'

function navigateToScreen(screenName) {
    currentScreen = screenName;
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));

    const topStats = document.getElementById('top-game-stats');
    const topLogo = document.getElementById('top-logo-wrap');
    const backBtn = document.getElementById('nav-back-btn');

    if (screenName === 'home') {
        document.getElementById('home-screen').classList.add('active');
        topStats.style.display = 'none';
        topLogo.style.display = 'flex';
        backBtn.textContent = '👥';
        updateHomeUI();
    } else if (screenName === 'levels') {
        document.getElementById('level-screen').classList.add('active');
        topStats.style.display = 'none';
        topLogo.style.display = 'flex';
        backBtn.textContent = '🏠';
        renderLevelsGrid();
    } else if (screenName === 'trophies') {
        document.getElementById('trophies-screen').classList.add('active');
        topStats.style.display = 'none';
        topLogo.style.display = 'flex';
        backBtn.textContent = '🏠';
        renderTrophiesGrid();
    } else if (screenName === 'game') {
        document.getElementById('game-screen').classList.add('active');
        topStats.style.display = 'flex';
        topLogo.style.display = 'none';
        backBtn.textContent = '🏠';
    }
}

// الدالة التي يستدعيها نظام الأندرويد الأصلي عند ضغط زر الرجوع في الموبايل
window.onHardwareBackPress = function() {
    // 1. إذا كانت نافذة تأكيد الخروج مفتوحة بالفعل وضغط رجوع، أغلقها وابق في اللعبة
    const exitModal = document.getElementById('exit-confirm-modal');
    if (exitModal.classList.contains('active')) {
        exitModal.classList.remove('active');
        return 'STAY';
    }

    // 2. إذا كانت أي نافذة منبثقة أخرى مفتوحة (إعدادات، عجلة حظ، بروفايل)، أغلقها فقط
    const anyModal = document.querySelector('.modal.active');
    if (anyModal) {
        anyModal.classList.remove('active');
        return 'STAY';
    }

    // 3. إذا كان اللاعب داخل المرحلة أو خريطة المستويات أو الكؤوس، يرجع خطوة إلى الشاشة الرئيسية (Home)
    if (currentScreen !== 'home') {
        navigateToScreen('home');
        return 'STAY';
    }

    // 4. إذا كان في الشاشة الرئيسية، افتح نافذة السؤال: "هل تريد الخروج من MawMaw؟"
    exitModal.classList.add('active');
    return 'STAY';
};

// دعم History API للمتصفح العادي أيضاً
history.pushState({ page: 'mawmaw' }, '');
window.addEventListener('popstate', () => {
    window.onHardwareBackPress();
    history.pushState({ page: 'mawmaw' }, '');
});

document.getElementById('nav-back-btn').addEventListener('click', () => {
    if (currentScreen !== 'home') {
        navigateToScreen('home');
    } else {
        openProfilePickerModal();
    }
});

document.getElementById('stay-in-game-btn').addEventListener('click', () => {
    document.getElementById('exit-confirm-modal').classList.remove('active');
});

document.getElementById('confirm-exit-btn').addEventListener('click', () => {
    // إغلاق التطبيق عبر Capacitor أو استدعاء الواجهة الأصلية
    if (window.Capacitor && window.Capacitor.Plugins && window.Capacitor.Plugins.App) {
        window.Capacitor.Plugins.App.exitApp();
    } else if (navigator.app && navigator.app.exitApp) {
        navigator.app.exitApp();
    } else {
        window.close();
    }
});

// --- تحديث الشاشة الرئيسية ---
function updateHomeUI() {
    const prof = getActiveProfile();
    if (!prof) return;
    document.getElementById('home-profile-img').src = prof.photo;
    document.getElementById('home-profile-name').textContent = prof.name;
    document.getElementById('home-unlocked-val').textContent = `${prof.unlockedLevel} / ${TOTAL_LEVELS}`;
    document.getElementById('home-score-val').textContent = prof.score || 0;
    document.getElementById('play-btn-lvl').textContent = prof.unlockedLevel;
    document.getElementById('booster-cat-img').src = prof.photo;
}

// --- توليد ألغاز MawMaw (120 مستوى) ---
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
    const rng = new SeededRNG(levelNum * 131 + 17);
    const catCols = new Array(N).fill(-1);
    const usedCols = new Array(N).fill(false);

    function placeRow(r) {
        if (r === N) return true;
        for (const c of rng.shuffle(Array.from({ length: N }, (_, i) => i))) {
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

// --- حالة اللعب ---
let game = {
    level: 1,
    N: 9,
    catCols: [],
    colorGrid: [],
    boardState: [], // 0 = empty, 1 = X, 2 = Character
    lives: 3
};

const boardEl = document.getElementById('regions-board');
const gemsBar = document.getElementById('region-gems-bar');

function startLevel(lvl) {
    const prof = getActiveProfile();
    // التحقق من أن المستوى مفتوح لهذا البروفايل
    if (lvl > prof.unlockedLevel) return;

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
    renderGemsBar();
    renderBoard();
    navigateToScreen('game');
}

function renderGemsBar() {
    gemsBar.innerHTML = '';
    for (let c = 0; c < game.N; c++) {
        const div = document.createElement('div');
        div.className = 'region-gem';
        div.dataset.color = c;
        div.style.backgroundColor = REGION_COLORS[c % REGION_COLORS.length];
        gemsBar.appendChild(div);
    }
    updateGemsStatus();
}

function updateGemsStatus() {
    const found = new Set();
    for (let r = 0; r < game.N; r++) {
        for (let c = 0; c < game.N; c++) {
            if (game.boardState[r][c] === 2) found.add(game.colorGrid[r][c]);
        }
    }
    gemsBar.querySelectorAll('.region-gem').forEach(el => {
        el.classList.toggle('found', found.has(parseInt(el.dataset.color)));
    });
}

function renderLivesUI() {
    document.querySelectorAll('#lives-bar .heart-icon').forEach((h, idx) => {
        h.classList.toggle('lost', idx >= game.lives);
    });
}

function updateBoostersUI() {
    const prof = getActiveProfile();
    document.getElementById('badge-cat').textContent = prof.boosters.cat;
    document.getElementById('badge-hint').textContent = prof.boosters.hint;
    document.getElementById('badge-mouse').textContent = prof.boosters.mouse;
}

// --- نظام الضغطة الواحدة (X / إلغاء X) والضغطتين السريعتين (وضع الشخصية) ---
let tapTimer = null;
let lastTappedCoords = null;
let lastTapTime = 0;

function onTilePointerDown(r, c) {
    const now = Date.now();
    const isSameCell = lastTappedCoords && lastTappedCoords.r === r && lastTappedCoords.c === c;

    if (isSameCell && (now - lastTapTime) < 280) {
        clearTimeout(tapTimer);
        tapTimer = null;
        lastTappedCoords = null;
        lastTapTime = 0;
        placeCharacterAt(r, c);
    } else {
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
        game.boardState[r][c] = 1;
        if (tileEl) tileEl.innerHTML = `<span class="tile-x">✕</span>`;
    } else if (cur === 1) {
        game.boardState[r][c] = 0;
        const xEl = tileEl ? tileEl.querySelector('.tile-x') : null;
        if (xEl) {
            xEl.classList.add('removing');
            setTimeout(() => { if (game.boardState[r][c] === 0) tileEl.innerHTML = ''; }, 165);
        } else if (tileEl) {
            tileEl.innerHTML = '';
        }
    } else if (cur === 2) {
        game.boardState[r][c] = 0;
        const imgEl = tileEl ? tileEl.querySelector('.tile-avatar') : null;
        if (imgEl) {
            imgEl.classList.add('removing');
            setTimeout(() => {
                if (game.boardState[r][c] === 0) tileEl.innerHTML = '';
                updateGemsStatus();
            }, 165);
        }
    }
}

function spawnCelebrationParticles(tileEl) {
    if (!tileEl) return;
    const emojis = ['✨', '🌟', '💖', '🎉', '👑'];
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

function spawnWrongAnimation(tileEl) {
    if (!tileEl) return;
    tileEl.classList.remove('error-shake');
    void tileEl.offsetWidth;
    tileEl.classList.add('error-shake');

    const badge = document.createElement('div');
    badge.className = 'fx-wrong-badge';
    badge.textContent = '❌ -1 💖';
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

function placeCharacterAt(r, c) {
    const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
    if (hasRuleViolation(r, c)) {
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

    updateGemsStatus();
    checkVictory();
}

function checkVictory() {
    let count = 0;
    for (let r = 0; r < game.N; r++) {
        if (game.boardState[r][game.catCols[r]] === 2) count++;
    }
    if (count === game.N) {
        const prof = getActiveProfile();
        const earnedStars = game.lives === 3 ? 3 : game.lives === 2 ? 2 : 1;
        prof.stars[game.level] = Math.max(prof.stars[game.level] || 0, earnedStars);
        prof.score = (prof.score || 0) + 50;

        // فتح المستوى التالي لهذا البروفايل إذا أنهى أعلى مستوى مفتوح لديه!
        if (game.level === prof.unlockedLevel && prof.unlockedLevel < TOTAL_LEVELS) {
            prof.unlockedLevel++;
        }
        if (game.level < TOTAL_LEVELS) {
            prof.currentLevel = game.level + 1;
        }
        saveProfilesToDB();

        launchConfetti();
        setTimeout(() => {
            sound.playWin();
            document.getElementById('win-level-num').textContent = game.level;
            document.getElementById('win-stars-row').textContent = '⭐'.repeat(earnedStars);
            document.getElementById('win-score-val').textContent = prof.score;
            document.getElementById('win-modal').classList.add('active');
        }, 400);
    }
}

// --- المساعدات الثلاث (العصا السحرية، البوصلة، البرق) ---
document.getElementById('booster-wand').addEventListener('click', () => {
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
    placeCharacterAt(r, c);
});

document.getElementById('booster-compass').addEventListener('click', () => {
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

document.getElementById('booster-zap').addEventListener('click', () => {
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

// --- خريطة المستويات (المستويات مقفولة وتفتح تدريجياً لكل بروفايل) ---
function renderLevelsGrid() {
    const prof = getActiveProfile();
    const grid = document.getElementById('levels-grid');
    grid.innerHTML = '';

    for (let i = 1; i <= TOTAL_LEVELS; i++) {
        const btn = document.createElement('button');
        const isUnlocked = i <= prof.unlockedLevel;
        const stars = (prof.stars && prof.stars[i]) || 0;

        btn.className = `lvl-btn ${!isUnlocked ? 'locked' : stars > 0 ? 'completed' : ''} ${i === prof.unlockedLevel ? 'current' : ''}`;
        if (isUnlocked) {
            btn.innerHTML = `
                <div style="font-size:1.05rem;">${i}</div>
                <div style="font-size:0.65rem;">${stars > 0 ? '⭐'.repeat(stars) : `${getGridSizeForLevel(i)}×${getGridSizeForLevel(i)}`}</div>
            `;
            btn.addEventListener('click', () => startLevel(i));
        } else {
            btn.innerHTML = `
                <div style="font-size:1rem;">🔒</div>
                <div style="font-size:0.7rem;">${i}</div>
            `;
        }
        grid.appendChild(btn);
    }
}

// --- غرفة الكؤوس والأوسمة (Trophies Room) ---
function renderTrophiesGrid() {
    const prof = getActiveProfile();
    const grid = document.getElementById('trophies-grid');
    grid.innerHTML = '';

    TROPHIES_LIST.forEach(t => {
        const isUnlocked = prof.unlockedLevel >= t.reqLvl;
        const card = document.createElement('div');
        card.className = `trophy-card ${isUnlocked ? 'unlocked' : 'locked'}`;
        const title = appPrefs.lang === 'ar' ? t.ar : t.en;
        const desc = appPrefs.lang === 'ar' ? t.descAr : t.descEn;
        card.innerHTML = `
            <div class="trophy-icon">${isUnlocked ? t.icon : '🔒'}</div>
            <div class="trophy-title">${title}</div>
            <div class="trophy-desc">${desc}</div>
        `;
        grid.appendChild(card);
    });
}

// --- عجلة الهدايا المبهجة (Lucky Wheel) ---
let wheelSpinning = false;
let wheelDeg = 0;

document.getElementById('open-wheel-btn').addEventListener('click', () => {
    document.getElementById('wheel-prize-msg').textContent = '';
    document.getElementById('wheel-modal').classList.add('active');
});
document.getElementById('close-wheel-btn').addEventListener('click', () => {
    document.getElementById('wheel-modal').classList.remove('active');
});

document.getElementById('spin-wheel-btn').addEventListener('click', () => {
    if (wheelSpinning) return;
    wheelSpinning = true;
    document.getElementById('wheel-prize-msg').textContent = '...';

    const prizes = [
        { labelAr: '🎉 ربحت +2 عصا سحرية 🪄!', labelEn: '🎉 Won +2 Magic Wands 🪄!', apply: p => p.boosters.cat += 2 },
        { labelAr: '🎉 ربحت +3 بوصلة ذكية 🧭!', labelEn: '🎉 Won +3 Smart Compasses 🧭!', apply: p => p.boosters.hint += 3 },
        { labelAr: '🎉 ربحت +2 برق كاشف ⚡!', labelEn: '🎉 Won +2 Lightning Zaps ⚡!', apply: p => p.boosters.mouse += 2 },
        { labelAr: '🎉 ربحت +100 نقطة ذهبية ⭐!', labelEn: '🎉 Won +100 Bonus Score ⭐!', apply: p => p.score = (p.score || 0) + 100 },
        { labelAr: '🎁 جائزة كبرى! +1 من كل المساعدات!', labelEn: '🎁 Jackpot! +1 of ALL Power-ups!', apply: p => { p.boosters.cat++; p.boosters.hint++; p.boosters.mouse++; } }
    ];

    const pick = prizes[Math.floor(Math.random() * prizes.length)];
    wheelDeg += 1440 + Math.floor(Math.random() * 360);
    document.getElementById('lucky-wheel-disc').style.transform = `rotate(${wheelDeg}deg)`;

    setTimeout(async () => {
        const prof = getActiveProfile();
        pick.apply(prof);
        await saveProfilesToDB();
        updateHomeUI();
        sound.playWin();
        launchConfetti();
        document.getElementById('wheel-prize-msg').textContent = appPrefs.lang === 'ar' ? pick.labelAr : pick.labelEn;
        wheelSpinning = false;
    }, 3250);
});

// --- الطريقة السرية للـ Cheats (5 ضغطات سريعة على لوجو MawMaw أو عنوان الإعدادات) ---
let secretTapCount = 0;
let secretTapTimer = null;

function handleSecretTriggerTap() {
    secretTapCount++;
    clearTimeout(secretTapTimer);
    if (secretTapCount >= 5) {
        secretTapCount = 0;
        openSecretCheatModal();
    } else {
        secretTapTimer = setTimeout(() => { secretTapCount = 0; }, 1400);
    }
}

document.getElementById('top-logo-wrap').addEventListener('click', handleSecretTriggerTap);
document.getElementById('settings-secret-trigger').addEventListener('click', handleSecretTriggerTap);

function openSecretCheatModal() {
    const prof = getActiveProfile();
    document.getElementById('cheat-prof-name').textContent = prof.name;
    document.getElementById('cheat-status-msg').textContent = '';
    document.getElementById('cheat-modal').classList.add('active');
}

document.getElementById('close-cheat-btn').addEventListener('click', () => {
    document.getElementById('cheat-modal').classList.remove('active');
});

document.getElementById('cheat-unlock-all-btn').addEventListener('click', async () => {
    const prof = getActiveProfile();
    prof.unlockedLevel = TOTAL_LEVELS;
    await saveProfilesToDB();
    updateHomeUI();
    if (currentScreen === 'levels') renderLevelsGrid();
    if (currentScreen === 'trophies') renderTrophiesGrid();
    sound.playWin();
    document.getElementById('cheat-status-msg').textContent = '✅ تم فتح جميع الـ 120 مستوى بنجاح!';
});

document.getElementById('cheat-add-boosters-btn').addEventListener('click', async () => {
    const prof = getActiveProfile();
    prof.boosters.cat += 50;
    prof.boosters.hint += 50;
    prof.boosters.mouse += 50;
    await saveProfilesToDB();
    updateBoostersUI();
    sound.playCorrect();
    document.getElementById('cheat-status-msg').textContent = '✅ تمت إضافة +50 لكل المساعدات!';
});

document.getElementById('cheat-add-score-btn').addEventListener('click', async () => {
    const prof = getActiveProfile();
    prof.score = (prof.score || 0) + 1000;
    prof.unlockedLevel = TOTAL_LEVELS;
    await saveProfilesToDB();
    updateHomeUI();
    sound.playWin();
    document.getElementById('cheat-status-msg').textContent = '✅ تمت إضافة 1000 نقطة وفتح كل الكؤوس!';
});

document.getElementById('cheat-jump-btn').addEventListener('click', async () => {
    const val = parseInt(document.getElementById('cheat-level-input').value);
    if (!val || val < 1 || val > TOTAL_LEVELS) return;
    const prof = getActiveProfile();
    if (val > prof.unlockedLevel) prof.unlockedLevel = val;
    await saveProfilesToDB();
    document.getElementById('cheat-modal').classList.remove('active');
    startLevel(val);
});

// --- أزرار التنقل في الشاشة الرئيسية ---
document.getElementById('play-now-btn').addEventListener('click', () => {
    const prof = getActiveProfile();
    startLevel(prof.unlockedLevel || 1);
});
document.getElementById('open-levels-btn').addEventListener('click', () => navigateToScreen('levels'));
document.getElementById('open-trophies-btn').addEventListener('click', () => navigateToScreen('trophies'));
document.getElementById('open-settings-home-btn').addEventListener('click', () => openSettingsModal());
document.getElementById('quick-swap-btn').addEventListener('click', () => openProfilePickerModal());

document.getElementById('next-level-btn').addEventListener('click', () => {
    document.getElementById('win-modal').classList.remove('active');
    const nextLvl = game.level < TOTAL_LEVELS ? game.level + 1 : 1;
    startLevel(nextLvl);
});

document.getElementById('retry-level-btn').addEventListener('click', () => {
    document.getElementById('lose-modal').classList.remove('active');
    startLevel(game.level);
});

// --- نافذة اختيار البروفايل عند الفتح ---
function openProfilePickerModal() {
    const grid = document.getElementById('startup-profiles-grid');
    grid.innerHTML = '';
    profiles.forEach(p => {
        ensureProfileFields(p);
        const card = document.createElement('div');
        card.className = `picker-card ${p.id === appPrefs.activeProfileId ? 'active' : ''}`;
        card.innerHTML = `
            <img src="${p.photo}" alt="${p.name}">
            <strong>${p.name}</strong>
            <span style="font-size:0.72rem; color:#636e72;">🔓 ${I18N[appPrefs.lang].level} ${p.unlockedLevel}</span>
        `;
        card.addEventListener('click', () => {
            appPrefs.activeProfileId = p.id;
            saveProfilesToDB();
            updateHomeUI();
            if (currentScreen === 'game') startLevel(p.unlockedLevel || 1);
            if (currentScreen === 'levels') renderLevelsGrid();
            if (currentScreen === 'trophies') renderTrophiesGrid();
            document.getElementById('profile-picker-modal').classList.remove('active');
        });
        grid.appendChild(card);
    });
    document.getElementById('profile-picker-modal').classList.add('active');
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
        unlockedLevel: 1, // يبدأ من المستوى 1 فقط والباقي مقفول
        stars: {},
        score: 0,
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
});

function renderSettingsModalUI() {
    const dict = I18N[appPrefs.lang];
    const activeProf = getActiveProfile();

    document.getElementById('correct-tab-prof-name').textContent = activeProf.name;
    document.getElementById('wrong-tab-prof-name').textContent = activeProf.name;

    const listEl = document.getElementById('profiles-list-container');
    listEl.innerHTML = '';

    profiles.forEach(p => {
        ensureProfileFields(p);
        const isCurrent = p.id === appPrefs.activeProfileId;
        const item = document.createElement('div');
        item.className = `prof-item ${isCurrent ? 'active' : ''}`;

        const left = document.createElement('div');
        left.className = 'prof-item-left';
        left.innerHTML = `
            <img src="${p.photo}" alt="${p.name}">
            <div>
                <strong>${p.name}</strong>
                <div style="font-size:0.72rem; color:#636e72;">🔓 ${dict.level}: ${p.unlockedLevel} | ⭐ ${p.score || 0}</div>
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
            if (currentScreen === 'levels') renderLevelsGrid();
            if (currentScreen === 'trophies') renderTrophiesGrid();
        };
        actions.appendChild(selectBtn);

        if (!p.isDefaultCat) {
            const delBtn = document.createElement('button');
            delBtn.className = 'mini-btn del';
            delBtn.textContent = '🗑️';
            delBtn.onclick = async () => {
                profiles = profiles.filter(x => x.id !== p.id);
                if (appPrefs.activeProfileId === p.id) appPrefs.activeProfileId = profiles[0].id;
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
    localStorage.setItem('mawmaw_autox', appPrefs.autoX);
});
document.getElementById('sound-toggle').addEventListener('change', (e) => {
    appPrefs.soundEnabled = e.target.checked;
    localStorage.setItem('mawmaw_sound', appPrefs.soundEnabled);
});

// --- تهيئة اللعبة عند الفتح ---
async function initApp() {
    await db.init();
    const savedProfs = await db.get('profiles_list');
    if (savedProfs && Array.isArray(savedProfs) && savedProfs.length > 0) {
        profiles = savedProfs.map(ensureProfileFields);
    } else {
        profiles = [createDefaultProfile()];
        await saveProfilesToDB();
    }

    document.getElementById('auto-x-toggle').checked = appPrefs.autoX;
    document.getElementById('sound-toggle').checked = appPrefs.soundEnabled;

    applyLanguage(appPrefs.lang);
    navigateToScreen('home');

    // إذا كان هناك بروفايلات أطفال مضافة، اطلب اختيار البروفايل فور فتح اللعبة
    if (profiles.length > 1) {
        openProfilePickerModal();
    }
}

initApp();
JS_EOF

# 7. تحديث ملف GitHub Actions للتأكد من الاحتفاظ بتعديل MainActivity.java وأيقونة MawMaw
cat << 'WORKFLOW_EOF' > .github/workflows/build-apk.yml
name: Build Android APK

on:
  push:
    branches: [ "main", "master" ]
  workflow_dispatch:

jobs:
  build-apk:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Install & Sync Android Project
        run: |
          npm install
          npx cap sync android

      - name: Build MawMaw Debug APK
        working-directory: ./android
        run: |
          chmod +x gradlew
          ./gradlew assembleDebug

      - name: Upload MawMaw APK
        uses: actions/upload-artifact@v4
        with:
          name: MawMaw-Android-APK
          path: android/app/build/outputs/apk/debug/app-debug.apk
WORKFLOW_EOF

# 8. مزامنة الأندرويد ورفع التعديلات إلى GitHub
echo "🔄 جاري مزامنة مشروع الأندرويد (Capacitor Sync)..."
npx cap sync android

echo "🚀 جاري رفع نسخة MawMaw الجديدة إلى GitHub لبناء الـ APK..."
git add .
git commit -m "Rebrand to MawMaw, fix native Android back button, lock levels per profile, add Lucky Wheel & Secret Cheats" || true
git push

echo "=================================================================="
echo "🎉 تم تحديث اللعبة بالكامل إلى MawMaw ورفعها إلى GitHub!"
echo "📱 ستجد ملف الـ APK الجديد باسم MawMaw-Android-APK في تبويب Actions."
echo "=================================================================="
