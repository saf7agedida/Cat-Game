#!/usr/bin/env bash
set -e

echo "🎨 جاري ترقية MawMaw إلى الإصدار الاحترافي الخامس (3D Pro Logo + BGM Ducking + Exact Wheel + Auto-Save)..."
cd /workspaces/Cat-Game

mkdir -p www/assets/cats
mkdir -p www/assets/sounds

# 1. توليد اللوجو الـ 3D الاحترافي + شخصية MawMaw 3D + ملفات الصوت والموسيقى الخلفية الهادئة
cat << 'ASSET_EOF' > generate_pro_assets.js
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// أ) تصميم لوجو MawMaw ثلاثي الأبعاد احترافي (3D Extruded Pro Game Logo)
const pro3DLogoSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 135">
  <defs>
    <!-- 3D Emblem Background Gradient -->
    <linearGradient id="shieldGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#4834d4"/>
      <stop offset="50%" stop-color="#6c5ce7"/>
      <stop offset="100%" stop-color="#00cec9"/>
    </linearGradient>
    <linearGradient id="goldRim" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#fff6d6"/>
      <stop offset="35%" stop-color="#ffd32a"/>
      <stop offset="75%" stop-color="#f39c12"/>
      <stop offset="100%" stop-color="#b33939"/>
    </linearGradient>
    <!-- 3D Text Face Gradients -->
    <linearGradient id="textFaceGold" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="25%" stop-color="#ffeaa7"/>
      <stop offset="65%" stop-color="#fdcb6e"/>
      <stop offset="100%" stop-color="#e17055"/>
    </linearGradient>
    <linearGradient id="textFaceCyan" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="30%" stop-color="#81ecec"/>
      <stop offset="75%" stop-color="#00cec9"/>
      <stop offset="100%" stop-color="#0984e3"/>
    </linearGradient>
    <linearGradient id="cubePink" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ff9ff3"/>
      <stop offset="100%" stop-color="#e84393"/>
    </linearGradient>
    <linearGradient id="cubeMint" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#55efc4"/>
      <stop offset="100%" stop-color="#00b894"/>
    </linearGradient>
    <filter id="proShadow" x="-15%" y="-15%" width="130%" height="140%">
      <feDropShadow dx="0" dy="8" stdDeviation="6" flood-color="#130f40" flood-opacity="0.65"/>
    </filter>
    <filter id="glowAura" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="4" result="blur"/>
      <feComposite in="SourceGraphic" in2="blur" operator="over"/>
    </filter>
  </defs>

  <!-- Outer 3D Base Shadow Plate -->
  <rect x="18" y="24" width="424" height="94" rx="47" fill="#130f40" opacity="0.55"/>
  <!-- 3D Extruded Bottom Rim -->
  <rect x="18" y="18" width="424" height="92" rx="46" fill="#2c2c54" stroke="url(#goldRim)" stroke-width="5" filter="url(#proShadow)"/>
  <!-- Main Glossy 3D Shield Body -->
  <rect x="22" y="14" width="416" height="86" rx="43" fill="url(#shieldGrad)" stroke="#ffffff" stroke-width="2.5"/>
  <!-- Top Specular Glass Reflection -->
  <path d="M 55,20 L 405,20 C 425,20 432,35 432,48 C 320,36 140,36 28,48 C 28,35 35,20 55,20 Z" fill="#ffffff" opacity="0.24"/>

  <!-- Left 3D Isometric Puzzle Cube -->
  <g transform="translate(28, 30) rotate(-12)" filter="url(#proShadow)">
    <rect x="0" y="6" width="38" height="38" rx="9" fill="#833471"/>
    <rect x="0" y="0" width="38" height="38" rx="9" fill="url(#cubePink)" stroke="#ffffff" stroke-width="2"/>
    <path d="M 11,11 L 27,27 M 27,11 L 11,27" stroke="#ffffff" stroke-width="4.5" stroke-linecap="round"/>
  </g>

  <!-- Right 3D Isometric Puzzle Cube -->
  <g transform="translate(392, 24) rotate(14)" filter="url(#proShadow)">
    <rect x="0" y="6" width="38" height="38" rx="9" fill="#006266"/>
    <rect x="0" y="0" width="38" height="38" rx="9" fill="url(#cubeMint)" stroke="#ffffff" stroke-width="2"/>
    <circle cx="19" cy="19" r="10" fill="#ffeaa7" stroke="#fff" stroke-width="2"/>
  </g>

  <!-- Center Top 3D Royal Crown Mascot Crest -->
  <g transform="translate(230, 14)" filter="url(#proShadow)">
    <polygon points="-28,12 -20,-10 0,2 20,-10 28,12" fill="url(#goldRim)" stroke="#ffffff" stroke-width="2" stroke-linejoin="round"/>
    <circle cx="-20" cy="-11" r="4" fill="#00cec9"/>
    <circle cx="0" cy="-13" r="5" fill="#ff7675"/>
    <circle cx="20" cy="-11" r="4" fill="#00cec9"/>
  </g>

  <!-- 3D EXTRUDED TYPOGRAPHY: "MawMaw" -->
  <g font-family="'Segoe UI', 'Arial Black', Impact, sans-serif" font-size="56" font-weight="900" text-anchor="middle" letter-spacing="2">
    <!-- Layer 1: Deep Ambient Shadow -->
    <text x="230" y="86" fill="#0c0728" stroke="#0c0728" stroke-width="14" stroke-linejoin="round">MawMaw</text>
    <!-- Layer 2: 3D Extrusion Depth (Bottom-Right) -->
    <text x="230" y="83" fill="#2c1654" stroke="#2c1654" stroke-width="11" stroke-linejoin="round">MawMaw</text>
    <text x="230" y="80" fill="#4834d4" stroke="#4834d4" stroke-width="9" stroke-linejoin="round">MawMaw</text>
    <!-- Layer 3: Outer Metallic Gold Bevel -->
    <text x="230" y="75" fill="none" stroke="url(#goldRim)" stroke-width="8" stroke-linejoin="round">MawMaw</text>
    <!-- Layer 4: Inner Dark Contour -->
    <text x="230" y="75" fill="none" stroke="#1e272e" stroke-width="3.5" stroke-linejoin="round">MawMaw</text>
    <!-- Layer 5: Main 3D Glossy Face -->
    <text x="230" y="75" fill="url(#textFaceGold)">MawMaw</text>
    <!-- Layer 6: Top Specular Highlight Stroke -->
    <text x="230" y="73.5" fill="none" stroke="#ffffff" stroke-width="1.2" opacity="0.85">MawMaw</text>
  </g>

  <!-- Sparkles -->
  <g filter="url(#glowAura)" fill="#ffffff">
    <polygon points="92,26 95,34 103,37 95,40 92,48 89,40 81,37 89,34"/>
    <polygon points="368,28 370,34 376,36 370,38 368,44 366,38 360,36 366,34"/>
    <circle cx="135" cy="24" r="3" fill="#ffeaa7"/>
    <circle cx="330" cy="88" r="3.5" fill="#81ecec"/>
  </g>
</svg>`;
fs.writeFileSync('www/assets/mawmaw_logo.svg', pro3DLogoSvg, 'utf8');

// ب) تصميم شخصية MawMaw ثلاثية الأبعاد (3D Shaded Mascot)
const mawmaw3DCharSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 140 140">
  <defs>
    <radialGradient id="head3D" cx="38%" cy="32%" r="65%">
      <stop offset="0%" stop-color="#ffd32a"/>
      <stop offset="45%" stop-color="#ff9f43"/>
      <stop offset="85%" stop-color="#ee5253"/>
      <stop offset="100%" stop-color="#b33939"/>
    </radialGradient>
    <radialGradient id="cheek3D" cx="50%" cy="40%" r="60%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="80%" stop-color="#f5f6fa"/>
      <stop offset="100%" stop-color="#dcdde1"/>
    </radialGradient>
    <linearGradient id="crown3D" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#fff6d6"/>
      <stop offset="50%" stop-color="#ffd32a"/>
      <stop offset="100%" stop-color="#e67e22"/>
    </linearGradient>
    <filter id="drop3D" x="-15%" y="-15%" width="130%" height="130%">
      <feDropShadow dx="0" dy="5" stdDeviation="4" flood-color="#1e272e" flood-opacity="0.45"/>
    </filter>
  </defs>
  <g filter="url(#drop3D)">
    <!-- 3D Ears -->
    <polygon points="24,62 16,18 56,36" fill="url(#head3D)" stroke="#ffffff" stroke-width="3" stroke-linejoin="round"/>
    <polygon points="116,62 124,18 84,36" fill="url(#head3D)" stroke="#ffffff" stroke-width="3" stroke-linejoin="round"/>
    <polygon points="30,54 24,26 50,38" fill="#ff7675"/>
    <polygon points="110,54 116,26 90,38" fill="#ff7675"/>
    <!-- 3D Sphere Head -->
    <ellipse cx="70" cy="78" rx="48" ry="43" fill="url(#head3D)" stroke="#ffffff" stroke-width="3.5"/>
    <!-- 3D Muzzle Cushion -->
    <ellipse cx="70" cy="87" rx="35" ry="26" fill="url(#cheek3D)"/>
    <!-- Top Specular Head Shine -->
    <ellipse cx="55" cy="48" rx="18" ry="7" fill="#ffffff" opacity="0.35" transform="rotate(-12 55 48)"/>
    <!-- Glossy 3D Eyes -->
    <circle cx="49" cy="70" r="9.5" fill="#1e272e"/>
    <circle cx="91" cy="70" r="9.5" fill="#1e272e"/>
    <circle cx="46" cy="66.5" r="3.8" fill="#ffffff"/>
    <circle cx="88" cy="66.5" r="3.8" fill="#ffffff"/>
    <circle cx="52" cy="73.5" r="2" fill="#48dbfb"/>
    <circle cx="94" cy="73.5" r="2" fill="#48dbfb"/>
    <!-- Pink 3D Nose & Smile -->
    <ellipse cx="70" cy="80" rx="6" ry="4.5" fill="#ff6b81"/>
    <path d="M 55,86 Q 70,100 85,86 Z" fill="#eb4d4b" stroke="#1e272e" stroke-width="2.5" stroke-linejoin="round"/>
    <path d="M 55,86 Q 63,92 70,84 Q 77,92 85,86" fill="none" stroke="#1e272e" stroke-width="3" stroke-linecap="round"/>
    <!-- 3D Royal Crown -->
    <polygon points="48,37 54,15 70,27 86,15 92,37" fill="url(#crown3D)" stroke="#ffffff" stroke-width="2.2" stroke-linejoin="round"/>
    <circle cx="70" cy="21" r="3.5" fill="#ff4757"/>
  </g>
</svg>`;
fs.writeFileSync('www/assets/cats/main_cat.svg', mawmaw3DCharSvg, 'utf8');

// ج) توليد أيقونة PNG ثلاثية الأبعاد عالية الدقة للأندرويد (ic_launcher.png)
function createPro3DPngIcon(size) {
  const raw = Buffer.alloc(size * (size * 4 + 1));
  const cx = size / 2, cy = size / 2;
  const rMax = size * 0.47;

  for (let y = 0; y < size; y++) {
    const rowStart = y * (size * 4 + 1);
    raw[rowStart] = 0;
    for (let x = 0; x < size; x++) {
      const idx = rowStart + 1 + x * 4;
      const nx = (x - cx) / rMax;
      const ny = (y - cy) / rMax;
      const dist = Math.sqrt(nx * nx + ny * ny);

      if (dist > 1.0) {
        raw[idx] = 0; raw[idx + 1] = 0; raw[idx + 2] = 0; raw[idx + 3] = 0;
        continue;
      }

      // 3D Gold Bevel Outer Ring
      let r = 72, g = 52, b = 212, a = 255;
      if (dist > 0.88) {
        const bevelLight = Math.max(0, Math.min(1, (1 - ny * 0.7)));
        r = Math.round(210 + 45 * bevelLight);
        g = Math.round(150 + 85 * bevelLight);
        b = Math.round(30 + 90 * bevelLight);
      } else {
        // 3D Spherical Glossy Background (Deep Purple to Cyan with Specular Highlight)
        const sphereZ = Math.sqrt(Math.max(0, 1 - dist * dist));
        const light = Math.max(0, (-0.35 * nx - 0.55 * ny + 0.75 * sphereZ));
        r = Math.min(255, Math.round(55 + 110 * Math.pow(light, 1.5)));
        g = Math.min(255, Math.round(35 + 175 * Math.pow(light, 1.2)));
        b = Math.min(255, Math.round(170 + 85 * light));

        // 3D Shaded Mascot Head in Center
        const hnx = nx / 0.62;
        const hny = (ny - 0.06) / 0.56;
        const hDist = Math.sqrt(hnx * hnx + hny * hny);

        const earL = (nx > -0.58 && nx < -0.18 && ny > -0.62 && ny < -0.12 && (nx + 0.58) * 1.3 > (-0.12 - ny) * 0.45);
        const earR = (nx < 0.58 && nx > 0.18 && ny > -0.62 && ny < -0.12 && (0.58 - nx) * 1.3 > (-0.12 - ny) * 0.45);

        if (hDist < 1.0 || earL || earR) {
          const hZ = hDist < 1.0 ? Math.sqrt(1 - hDist * hDist) : 0.5;
          const hLight = Math.max(0.2, (-0.3 * hnx - 0.5 * hny + 0.8 * hZ));
          r = Math.min(255, Math.round(235 * hLight + 40));
          g = Math.min(255, Math.round(135 * hLight + 20));
          b = Math.min(255, Math.round(45 * hLight));

          // White 3D Muzzle
          const mDist = Math.sqrt((nx / 0.44) ** 2 + ((ny - 0.19) / 0.34) ** 2);
          if (mDist < 1.0) {
            const mLight = 0.88 + 0.12 * (1 - mDist);
            r = Math.round(255 * mLight);
            g = Math.round(252 * mLight);
            b = Math.round(250 * mLight);
          }

          // 3D Eyes with Specular Glint
          const eyeL = Math.sqrt((nx + 0.24) ** 2 + (ny - 0.02) ** 2);
          const eyeR = Math.sqrt((nx - 0.24) ** 2 + (ny - 0.02) ** 2);
          if (eyeL < 0.11 || eyeR < 0.11) {
            r = 25; g = 30; b = 40;
            const glintL = Math.sqrt((nx + 0.27) ** 2 + (ny + 0.01) ** 2);
            const glintR = Math.sqrt((nx - 0.21) ** 2 + (ny + 0.01) ** 2);
            if (glintL < 0.038 || glintR < 0.038) {
              r = 255; g = 255; b = 255;
            }
          }

          // Cute Pink Nose
          const noseD = Math.sqrt((nx / 0.09) ** 2 + ((ny - 0.13) / 0.065) ** 2);
          if (noseD < 1.0) {
            r = 255; g = 95; b = 125;
          }
        }
      }
      raw[idx] = r; raw[idx + 1] = g; raw[idx + 2] = b; raw[idx + 3] = a;
    }
  }

  function crc32(buf) {
    let c = -1;
    for (let i = 0; i < buf.length; i++) c = (c >>> 8) ^ crcTable[(c ^ buf[i]) & 0xff];
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

const iconPng = createPro3DPngIcon(256);
fs.writeFileSync('www/assets/icon.png', iconPng);

const mipmapDirs = ['mipmap-mdpi', 'mipmap-hdpi', 'mipmap-xhdpi', 'mipmap-xxhdpi', 'mipmap-xxxhdpi'];
mipmapDirs.forEach(dir => {
  const fullDir = path.join('android/app/src/main/res', dir);
  if (fs.existsSync(fullDir)) {
    fs.writeFileSync(path.join(fullDir, 'ic_launcher.png'), iconPng);
    fs.writeFileSync(path.join(fullDir, 'ic_launcher_round.png'), iconPng);
    fs.writeFileSync(path.join(fullDir, 'ic_launcher_foreground.png'), iconPng);
  }
});

// د) توليد ملفات الصوت (بما فيها صوت X الخفيف + الموسيقى الخلفية الهادئة BGM)
function writeWavBuffer(filepath, samples, sampleRate = 22050) {
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
    const s = Math.max(-1, Math.min(1, samples[i]));
    buffer.writeInt16LE(Math.floor(s * 32767), 44 + i * 2);
  }
  fs.writeFileSync(filepath, buffer);
}

// 1. صوت ضغطة علامة X الخفيف والمريح (Soft Bubble Tick)
{
  const sr = 22050;
  const dur = 0.055;
  const count = Math.floor(sr * dur);
  const samples = [];
  for (let i = 0; i < count; i++) {
    const t = i / sr;
    const env = Math.sin((Math.PI * i) / count) * Math.exp(-4 * (i / count));
    const freq = 520 - (i / count) * 240;
    samples.push(Math.sin(2 * Math.PI * freq * t) * 0.35 * env);
  }
  writeWavBuffer('www/assets/sounds/x_tap.wav', samples, sr);
}

// 2. موسيقى خلفية هادئة ومريحة (Calm Ambient Music Box Loop - 12.8 seconds)
{
  const sr = 22050;
  // نغمات هادئة على سلم خماسي مريح للأعصاب (C Major Pentatonic)
  const melody = [
    { f: 523.25, b: 261.63, d: 0.8 }, // C5 + C4
    { f: 659.25, b: 329.63, d: 0.8 }, // E5 + E4
    { f: 783.99, b: 392.00, d: 0.8 }, // G5 + G4
    { f: 659.25, b: 329.63, d: 0.8 }, // E5
    { f: 880.00, b: 220.00, d: 0.8 }, // A5 + A3
    { f: 783.99, b: 392.00, d: 0.8 }, // G5
    { f: 659.25, b: 329.63, d: 0.8 }, // E5
    { f: 587.33, b: 293.66, d: 0.8 }, // D5 + D4
    { f: 523.25, b: 261.63, d: 0.8 }, // C5
    { f: 587.33, b: 293.66, d: 0.8 }, // D5
    { f: 659.25, b: 329.63, d: 0.8 }, // E5
    { f: 783.99, b: 392.00, d: 0.8 }, // G5
    { f: 659.25, b: 220.00, d: 0.8 }, // E5 + A3
    { f: 587.33, b: 293.66, d: 0.8 }, // D5
    { f: 523.25, b: 261.63, d: 1.6 }  // C5 Warm Resolve
  ];
  const samples = [];
  melody.forEach(note => {
    const count = Math.floor(sr * note.d);
    for (let i = 0; i < count; i++) {
      const t = i / sr;
      const attack = Math.min(1, i / (sr * 0.03));
      const decay = Math.exp(-2.8 * (i / count));
      const env = attack * decay;
      const lead = Math.sin(2 * Math.PI * note.f * t) * 0.22 + Math.sin(4 * Math.PI * note.f * t) * 0.05;
      const bass = Math.sin(2 * Math.PI * note.b * t) * 0.18;
      samples.push((lead + bass) * env);
    }
  });
  writeWavBuffer('www/assets/sounds/bgm.wav', samples, sr);
}

console.log("✅ تم توليد اللوجو الـ 3D الاحترافي، صوت X، والموسيقى الخلفية الهادئة!");
ASSET_EOF

node generate_pro_assets.js
rm generate_pro_assets.js

# 2. تحديث ملف www/index.html
cat << 'HTML_EOF' > www/index.html
<!DOCTYPE html>
<html lang="ar" dir="rtl" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#4834d4">
    <title>MawMaw - ماوماو</title>
    <link rel="manifest" href="manifest.json">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <canvas id="confetti-canvas"></canvas>

    <!-- Achievement Unlocked Toast -->
    <div id="trophy-toast" class="trophy-toast">
        🏆 <span id="trophy-toast-text">فتحت كأساً جديداً + لفة عجلة حظ مجانية!</span>
    </div>

    <div class="app-container">
        <!-- Top Header -->
        <header class="top-bar">
            <button id="nav-back-btn" class="nav-glass-btn" title="Back">👥</button>

            <!-- Pro 3D Logo (Tap 5 times quickly for Secret Cheats) -->
            <div id="top-logo-wrap" class="top-logo-wrap" title="MawMaw">
                <img src="assets/mawmaw_logo.svg" alt="MawMaw 3D Logo" class="header-logo-img">
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

            <div class="header-right-btns">
                <button id="bgm-quick-btn" class="nav-glass-btn" title="الموسيقى الخلفية">🎵</button>
                <button id="settings-btn" class="nav-glass-btn" title="Settings">⚙️</button>
            </div>
        </header>

        <!-- 1. HOME SCREEN -->
        <main id="home-screen" class="screen active">
            <div class="home-card">
                <!-- 3D Logo Showcase on Home -->
                <div class="home-logo-showcase" id="home-logo-secret">
                    <img src="assets/mawmaw_logo.svg" alt="MawMaw 3D" class="home-big-logo">
                </div>

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
                        🚀 <span id="play-now-label" data-i18n="playNow">العب الآن</span> (<span data-i18n="level">المستوى</span> <span id="play-btn-lvl">1</span>)
                    </button>

                    <div class="home-sub-grid">
                        <button id="open-levels-btn" class="btn-sub-card mint">
                            <span class="sub-icon">🗺️</span>
                            <span data-i18n="levelsMap">خريطة المستويات</span>
                        </button>
                        <button id="open-wheel-btn" class="btn-sub-card sunny">
                            <span class="sub-icon">🎡</span>
                            <span><span data-i18n="luckyWheel">عجلة الهدايا</span> <strong id="home-wheel-badge" class="wheel-mini-badge">1</strong></span>
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

        <!-- 2. LEVELS MAP SCREEN -->
        <main id="level-screen" class="screen">
            <div class="section-banner">
                <h2 data-i18n="levelsMapTitle">🗺️ مراحل مغامرة MawMaw</h2>
                <p data-i18n="levelsMapSub">افتح المراحل واحدة تلو الأخرى؛ يتم حفظ تقدمك داخل المرحلة تلقائياً!</p>
            </div>
            <div id="levels-grid" class="levels-grid"></div>
        </main>

        <!-- 3. TROPHIES ROOM SCREEN -->
        <main id="trophies-screen" class="screen">
            <div class="section-banner">
                <h2 data-i18n="trophiesTitle">🏆 غرفة الكؤوس والأوسمة</h2>
                <p data-i18n="trophiesSub">كل كأس تفتحه يمنحك لفة هدية مجانية في عجلة الحظ 🎡!</p>
            </div>
            <div id="trophies-grid" class="trophies-grid"></div>
        </main>

        <!-- 4. GAME SCREEN -->
        <main id="game-screen" class="screen">
            <div class="game-hud-bar" dir="ltr">
                <div id="region-gems-bar" class="gems-pill"></div>
                <div id="lives-bar" class="hearts-pill">
                    <span class="heart-icon">💖</span>
                    <span class="heart-icon">💖</span>
                    <span class="heart-icon">💖</span>
                </div>
            </div>

            <div class="mawmaw-rules-bar">
                <div class="m-rule-chip">🎨 <span data-i18n="mRule1">واحد بكل لون</span></div>
                <div class="m-rule-chip">📏 <span data-i18n="mRule2">واحد بكل صف وعمود</span></div>
                <div class="m-rule-chip">🚫 <span data-i18n="mRule3">ممنوع التلامس</span></div>
            </div>

            <div class="board-frame">
                <div id="regions-board" class="regions-board" dir="ltr"></div>
            </div>

            <div class="tap-hint-pill" data-i18n="tapGuide">
                ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع الشخصية</strong>
            </div>

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
                <button id="restart-lvl-btn" class="power-btn reset-theme" title="إعادة المرحلة من البداية">
                    <span class="power-emoji">🔄</span>
                </button>
            </div>
        </main>

        <!-- LUCKY WHEEL MODAL (Exact Slice Alignment + Weekly/Trophy Spins) -->
        <div id="wheel-modal" class="modal">
            <div class="modal-content wheel-box">
                <div class="modal-header">
                    <h2 data-i18n="luckyWheelTitle">🎡 عجلة هدايا MawMaw</h2>
                    <button id="close-wheel-btn" class="close-x">✖</button>
                </div>

                <div class="wheel-quota-banner">
                    <div><span data-i18n="spinsAvailable">اللفات المتاحة الآن:</span> <strong id="wheel-spins-count">0</strong> 🎟️</div>
                    <div id="wheel-cooldown-text" class="wheel-cooldown-sub"></div>
                </div>

                <div class="wheel-stage" dir="ltr">
                    <div class="wheel-pointer">🔻</div>
                    <div id="lucky-wheel-disc" class="lucky-wheel-disc">
                        <!-- 6 Slices: each 60deg, centers at 30, 90, 150, 210, 270, 330 -->
                        <div class="wheel-label" style="--rot: 30deg;"><span>🪄 +2</span></div>
                        <div class="wheel-label" style="--rot: 90deg;"><span>🧭 +3</span></div>
                        <div class="wheel-label" style="--rot: 150deg;"><span>⚡ +2</span></div>
                        <div class="wheel-label" style="--rot: 210deg;"><span>⭐ +100</span></div>
                        <div class="wheel-label" style="--rot: 270deg;"><span>🎁 +1</span></div>
                        <div class="wheel-label" style="--rot: 330deg;"><span>🪄 +3</span></div>
                        <div class="wheel-center-knob">👑</div>
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
                <p class="modal-sub-text" data-i18n="chooseProfileSub">اختر البروفايل الخاص بك للبدء بصورتك وأصواتك ومراحلك المحفوظة:</p>
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
                    <div class="toggle-row">
                        <label>
                            <input type="checkbox" id="bgm-toggle" checked>
                            <span data-i18n="bgmToggleLabel">موسيقى هادئة في الخلفية أثناء اللعب 🎵</span>
                        </label>
                    </div>
                </div>

                <!-- Tab 2: 6 Correct Sounds -->
                <div id="tab-correct" class="tab-pane">
                    <div class="active-prof-banner">
                        <span data-i18n="editingSoundsFor">تخصيص أصوات البروفايل النشط:</span>
                        <strong id="correct-tab-prof-name"></strong>
                    </div>
                    <p class="tab-hint" data-i18n="correctSoundsHint">أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الصحيحة (ينخفض صوت الموسيقى الخلفية تلقائياً عند تشغيلها):</p>
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

        <!-- SECRET CHEAT MODAL (5 Taps on Logo) -->
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
                    <button id="cheat-add-spins-btn" class="cheat-btn sunny">
                        🎡 إضافة +10 لفات مجانية لعجلة الحظ
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

        <!-- EXIT CONFIRMATION MODAL -->
        <div id="exit-confirm-modal" class="modal">
            <div class="modal-content">
                <div class="modal-big-icon">🐾 👋</div>
                <h2 data-i18n="exitConfirmTitle">هل تريد الخروج من MawMaw؟</h2>
                <p class="win-score-line" data-i18n="exitConfirmSub">تم حفظ خطواتك داخل المستوى وتقدمك تلقائياً.</p>
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

# 3. تحديث ملف www/style.css (علامة X بحجم 75% مع Glow + تصميم عجلة الحظ الدقيق + الشعار الـ 3D)
cat << 'CSS_EOF' > www/style.css
:root {
    --bg-grad-start: #f3f0ff;
    --bg-grad-end: #e6fcf5;
    --card-bg: #ffffff;
    --primary: #6c5ce7;
    --primary-dark: #4834d4;
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

/* Trophy Unlocked Toast */
.trophy-toast {
    position: fixed;
    top: 16px;
    left: 50%;
    transform: translateX(-50%) translateY(-100px);
    background: linear-gradient(135deg, #ffd32a, #ff9f43);
    color: #1e272e;
    padding: 12px 20px;
    border-radius: 30px;
    font-weight: 900;
    font-size: 0.88rem;
    box-shadow: 0 8px 25px rgba(0,0,0,0.25);
    border: 2.5px solid #fff;
    z-index: 500;
    transition: transform 0.4s cubic-bezier(0.18, 0.89, 0.32, 1.28);
    white-space: nowrap;
}
.trophy-toast.show {
    transform: translateX(-50%) translateY(0);
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
    padding: 2px 0;
}

.header-right-btns {
    display: flex;
    gap: 6px;
}

.top-logo-wrap {
    cursor: pointer;
    transition: transform 0.15s;
    display: flex;
    align-items: center;
}
.top-logo-wrap:active { transform: scale(0.94); }
.header-logo-img {
    height: 50px;
    width: auto;
}

.home-logo-showcase {
    display: flex;
    justify-content: center;
    margin-bottom: -4px;
    cursor: pointer;
}
.home-big-logo {
    width: 88%;
    max-width: 310px;
    height: auto;
    animation: floatLogo 3s ease-in-out infinite alternate;
}

@keyframes floatLogo {
    from { transform: translateY(0px); }
    to { transform: translateY(-5px); }
}

.nav-glass-btn {
    width: 42px;
    height: 42px;
    border-radius: 14px;
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    box-shadow: 0 4px 12px rgba(108, 92, 231, 0.1);
    font-size: 1.2rem;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: transform 0.15s;
}
.nav-glass-btn:active { transform: scale(0.9); }

.top-stats { display: flex; gap: 8px; }
.stat-pill {
    background: var(--card-bg);
    border: 2px solid var(--border-soft);
    padding: 3px 11px;
    border-radius: 14px;
    display: flex;
    flex-direction: column;
    align-items: center;
    min-width: 68px;
}
.stat-label { font-size: 0.68rem; color: var(--text-muted); font-weight: 700; }
.stat-val { font-size: 1.1rem; font-weight: 900; color: var(--primary); }

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
    padding: 16px;
    box-shadow: 0 10px 28px rgba(108, 92, 231, 0.12);
    border: 2px solid #ffffff;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.hero-profile-strip {
    display: flex;
    align-items: center;
    gap: 12px;
    background: linear-gradient(135deg, #f3f0ff 0%, #e8fbf8 100%);
    padding: 10px 14px;
    border-radius: 20px;
    border: 2px solid var(--border-soft);
}

.avatar-ring {
    width: 62px;
    height: 62px;
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
.welcome-sub { font-size: 0.76rem; color: var(--text-muted); font-weight: 600; }
.home-profile-info h2 { font-size: 1.2rem; color: var(--primary-dark); font-weight: 900; }

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

.home-stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.stat-card-box {
    background: var(--soft-bg);
    border: 1.5px solid var(--border-soft);
    border-radius: 18px;
    padding: 10px;
    text-align: center;
    display: flex;
    flex-direction: column;
    gap: 2px;
}
.sc-icon { font-size: 1.3rem; }
.sc-title { font-size: 0.74rem; color: var(--text-muted); font-weight: 700; }
.stat-card-box strong { font-size: 1.2rem; color: var(--text-main); font-weight: 900; }

.home-menu-btns { display: flex; flex-direction: column; gap: 10px; }

.btn-play-main {
    width: 100%;
    background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
    color: #fff;
    border: none;
    padding: 15px;
    border-radius: 18px;
    font-size: 1.1rem;
    font-weight: 900;
    cursor: pointer;
    box-shadow: 0 6px 18px rgba(108, 92, 231, 0.35);
    transition: transform 0.15s;
}
.btn-play-main:active { transform: scale(0.96); }
.btn-play-main:disabled {
    background: #b2bec3;
    box-shadow: none;
    cursor: not-allowed;
}

.home-sub-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.btn-sub-card {
    border: none;
    border-radius: 18px;
    padding: 12px 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 5px;
    font-weight: 800;
    font-size: 0.85rem;
    cursor: pointer;
    transition: transform 0.15s;
}
.btn-sub-card:active { transform: scale(0.95); }
.sub-icon { font-size: 1.55rem; }

.wheel-mini-badge {
    display: inline-block;
    background: #e17055;
    color: #fff;
    padding: 1px 7px;
    border-radius: 10px;
    font-size: 0.75rem;
    margin-right: 4px;
}

.btn-sub-card.mint { background: #e3fafc; color: #0b7285; border: 2px solid #99e9f2; }
.btn-sub-card.sunny { background: #fff9db; color: #e67700; border: 2px solid #ffec99; }
.btn-sub-card.coral { background: #fff0f6; color: #a61e4d; border: 2px solid #fcc2d7; }
.btn-sub-card.purple { background: #f3f0ff; color: #5f3dc4; border: 2px solid #d0bfff; }

/* Levels & Trophies */
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
}
.lvl-btn.completed { background: #e6fcf5; border-color: #63e6be; box-shadow: 0 3px 0 #63e6be; }
.lvl-btn.current { background: #fff9db; border-color: #fcc419; box-shadow: 0 3px 0 #fcc419; }
.lvl-btn.locked { background: #f1f3f5; border-color: #dee2e6; color: #adb5bd; box-shadow: none; cursor: not-allowed; opacity: 0.72; }

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
.trophy-card.locked { filter: grayscale(100%); opacity: 0.55; }
.trophy-icon { font-size: 2.2rem; }
.trophy-title { font-size: 0.82rem; font-weight: 800; }
.trophy-desc { font-size: 0.68rem; color: var(--text-muted); }

/* Game HUD & 3D Board */
.game-hud-bar { display: flex; gap: 8px; align-items: center; justify-content: space-between; }
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
.heart-icon { font-size: 1.2rem; transition: all 0.35s ease; }
.heart-icon.lost { opacity: 0.2; filter: grayscale(100%); transform: scale(0.7); }

.mawmaw-rules-bar { display: flex; justify-content: space-between; gap: 6px; }
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

.board-frame {
    background: #1e272e;
    padding: 10px;
    border-radius: 24px;
    box-shadow: 0 10px 25px rgba(30, 39, 46, 0.28);
    display: flex;
    justify-content: center;
    align-items: center;
}

.regions-board {
    display: grid;
    width: 100%;
    aspect-ratio: 1 / 1;
    gap: 4.5px;
}

.tile {
    border-radius: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    position: relative;
    box-shadow: inset 0 2px 0 rgba(255,255,255,0.45), inset 0 -3px 0 rgba(0,0,0,0.2);
    overflow: visible;
}

/* 3. X Mark: Fills 75% of Tile Area + Glowing Neon Aura */
.tile-x-svg {
    width: 75%;
    height: 75%;
    pointer-events: none;
    filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.95)) drop-shadow(0 0 10px rgba(72, 52, 212, 0.85));
    animation: xPopIn 0.22s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}
.tile-x-svg.removing {
    animation: xPopOut 0.16s ease-in forwards;
}

@keyframes xPopIn {
    0% { transform: scale(0.2) rotate(-45deg); opacity: 0; }
    70% { transform: scale(1.18) rotate(6deg); opacity: 1; }
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
    filter: drop-shadow(0 3px 5px rgba(0,0,0,0.3));
    animation: catBounceIn 0.42s cubic-bezier(0.18, 0.89, 0.32, 1.35) forwards;
}
.tile-avatar.kid-mode { border: 2.5px solid #ffffff; background: #fff; }
.tile-avatar.removing { animation: xPopOut 0.16s ease-in forwards; }

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
.powerups-dock { display: flex; justify-content: center; gap: 16px; }
.power-btn {
    width: 60px;
    height: 60px;
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
.reset-theme { background: linear-gradient(135deg, #fab1a0, #ff7675); }

.power-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #fff; background: #fff; }
.power-mini-icon { position: absolute; bottom: -4px; left: -4px; font-size: 1rem; }
.power-emoji { font-size: 1.75rem; }
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

/* Lucky Wheel Modal (Exact Math Alignment) */
.wheel-box { max-width: 400px; }
.wheel-quota-banner {
    background: var(--soft-bg);
    border: 1.5px solid var(--border-soft);
    padding: 8px 12px;
    border-radius: 14px;
    margin-bottom: 10px;
    font-size: 0.85rem;
}
.wheel-cooldown-sub {
    font-size: 0.73rem;
    color: var(--text-muted);
    margin-top: 3px;
}

.wheel-stage {
    position: relative;
    width: 230px;
    height: 230px;
    margin: 12px auto;
}
.wheel-pointer {
    position: absolute;
    top: -18px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 2rem;
    z-index: 25;
    filter: drop-shadow(0 3px 4px rgba(0,0,0,0.35));
}
.lucky-wheel-disc {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 6px solid #fff;
    box-shadow: 0 8px 24px rgba(108, 92, 231, 0.3);
    /* 6 exact 60-degree slices clockwise from top (0deg) */
    background: conic-gradient(
        from 0deg,
        #ff7675 0deg 60deg,
        #fdcb6e 60deg 120deg,
        #55efc4 120deg 180deg,
        #74b9ff 180deg 240deg,
        #a29bfe 240deg 300deg,
        #fd79a8 300deg 360deg
    );
    position: relative;
    transition: transform 3.4s cubic-bezier(0.14, 0.86, 0.22, 1);
}
.wheel-label {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    transform: rotate(var(--rot));
}
.wheel-label span {
    display: block;
    transform: translate(-50%, -82px);
    font-size: 0.82rem;
    font-weight: 900;
    color: #fff;
    text-shadow: 0 1px 4px rgba(0,0,0,0.65);
    white-space: nowrap;
}
.wheel-center-knob {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: #fff;
    box-shadow: 0 3px 8px rgba(0,0,0,0.25);
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 1.3rem;
}
.wheel-prize-msg {
    min-height: 26px;
    font-weight: 900;
    color: var(--primary-dark);
    margin-bottom: 8px;
    font-size: 0.92rem;
}

/* Modals */
.modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(30, 25, 50, 0.62);
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
.picker-card.active { border-color: var(--primary); background: #f3f0ff; }
.picker-card img { width: 64px; height: 64px; border-radius: 50%; object-fit: cover; border: 3px solid #fff; background: #fff; }

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
.lang-btn { padding: 5px 12px; border-radius: 8px; border: 1.5px solid var(--border-soft); background: #fff; cursor: pointer; font-weight: bold; font-size: 0.78rem; }
.lang-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }

.settings-tabs { display: flex; gap: 6px; margin-bottom: 10px; }
.tab-btn { flex: 1; padding: 8px 4px; font-size: 0.75rem; font-weight: bold; background: var(--soft-bg); border: none; border-radius: 10px; color: var(--text-main); cursor: pointer; }
.tab-btn.active { background: var(--primary); color: #fff; }

.tab-pane { display: none; overflow-y: auto; max-height: 50vh; padding: 2px; }
.tab-pane.active { display: block; }

.profiles-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 12px; }
.prof-item { display: flex; justify-content: space-between; align-items: center; background: var(--soft-bg); padding: 8px 10px; border-radius: 14px; border: 2px solid transparent; }
.prof-item.active { border-color: var(--primary); background: #f3f0ff; }
.prof-item-left { display: flex; align-items: center; gap: 10px; }
.prof-item-left img { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; background: #fff; border: 2px solid var(--primary); }
.prof-item-actions { display: flex; gap: 5px; }

.new-profile-card { background: #fcfaff; border: 2px dashed var(--primary); border-radius: 16px; padding: 12px; }
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

.cheat-box { max-width: 400px; border: 3px solid var(--sunny); }
.cheat-actions { display: flex; flex-direction: column; gap: 8px; margin: 10px 0; }
.cheat-btn { padding: 11px; border-radius: 14px; border: none; font-weight: 900; font-size: 0.85rem; cursor: pointer; }
.cheat-btn.gold { background: #ffeaa7; color: #d35400; }
.cheat-btn.mint { background: #81ecec; color: #006266; }
.cheat-btn.sunny { background: #fab1a0; color: #6d214f; }
.cheat-btn.purple { background: #d0bfff; color: #4834d4; }
.cheat-jump-row { display: flex; gap: 8px; }
.cheat-status-msg { min-height: 22px; font-weight: 800; color: #00b894; font-size: 0.85rem; }

.modal-big-icon { font-size: 2.5rem; margin-bottom: 6px; }
.win-stars-row { font-size: 2rem; margin: 4px 0; }
.win-score-line { margin: 8px 0 14px; font-size: 0.92rem; }
.modal-footer { display: flex; gap: 8px; margin-top: 12px; }
.primary-btn, .secondary-btn { flex: 1; padding: 12px; border-radius: 14px; border: none; font-weight: 800; cursor: pointer; }
.primary-btn { background: var(--primary); color: #fff; }
.secondary-btn { background: var(--soft-bg); color: var(--text-main); border: 1.5px solid var(--border-soft); }
.danger-btn { background: #ffe3e3; color: #c92a2a; border-color: #ffa8a8; }
CSS_EOF

# 4. تحديث ملف www/script.js (حفظ حالة المستوى + عجلة الحظ الدقيقة والأسبوعية + صوت X و75% Glow + BGM Ducking)
cat << 'JS_EOF' > www/script.js
const REGION_COLORS = [
    '#ff9ff3', '#feca57', '#48dbfb', '#1dd1a1', '#ff6b6b',
    '#a29bfe', '#ff9f43', '#00d2d3', '#c8d6e5'
];
const TOTAL_LEVELS = 120;
const ONE_WEEK_MS = 7 * 24 * 60 * 60 * 1000;

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

const I18N = {
    ar: {
        level: 'المستوى',
        score: 'النقاط',
        welcomePlayer: 'مرحباً بالبطل:',
        changeProfile: 'تبديل 👥',
        unlockedLvl: 'أعلى مستوى مفتوح',
        totalScore: 'مجموع النقاط',
        playNow: 'العب الآن',
        continuePlay: 'استكمال اللعب',
        levelsMap: 'خريطة المستويات',
        luckyWheel: 'عجلة الهدايا',
        trophiesRoom: 'غرفة الكؤوس',
        settingsAndProfiles: 'البروفايلات والإعدادات',
        levelsMapTitle: '🗺️ مراحل مغامرة MawMaw',
        levelsMapSub: 'افتح المراحل واحدة تلو الأخرى؛ يتم حفظ تقدمك داخل المرحلة تلقائياً!',
        trophiesTitle: '🏆 غرفة الكؤوس والأوسمة',
        trophiesSub: 'كل كأس تفتحه يمنحك لفة هدية مجانية في عجلة الحظ 🎡!',
        mRule1: 'واحد بكل لون',
        mRule2: 'واحد بكل صف وعمود',
        mRule3: 'ممنوع التلامس',
        tapGuide: 'ضغطة واحدة = وضع/إلغاء <strong>✕</strong> &nbsp;|&nbsp; ضغطتان سريعتان = <strong>وضع الشخصية</strong>',
        luckyWheelTitle: '🎡 عجلة هدايا MawMaw',
        spinsAvailable: 'اللفات المتاحة الآن:',
        spinNowBtn: '🎲 لف العجلة الآن!',
        noSpinsBtn: '⏳ لا توجد لفات متاحة حالياً',
        whoIsPlaying: '👋 من سيلعب اليوم؟',
        chooseProfileSub: 'اختر البروفايل الخاص بك للبدء بصورتك وأصواتك ومراحلك المحفوظة:',
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
        bgmToggleLabel: 'موسيقى هادئة في الخلفية أثناء اللعب 🎵',
        editingSoundsFor: 'تخصيص أصوات البروفايل النشط:',
        correctSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الصحيحة (ينخفض صوت الموسيقى الخلفية تلقائياً عند تشغيلها):',
        wrongSoundsHint: 'أضف حتى 6 صوتيات تعمل عشوائياً عند الإجابة الخاطئة:',
        doneBtn: 'تم ✅',
        exitConfirmTitle: 'هل تريد الخروج من MawMaw؟',
        exitConfirmSub: 'تم حفظ خطواتك داخل المستوى وتقدمك تلقائياً.',
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
        continuePlay: 'Continue Level',
        levelsMap: 'Levels Map',
        luckyWheel: 'Lucky Wheel',
        trophiesRoom: 'Trophy Room',
        settingsAndProfiles: 'Profiles & Settings',
        levelsMapTitle: '🗺️ MawMaw Adventure Map',
        levelsMapSub: 'Unlock levels one by one; your in-level moves are auto-saved!',
        trophiesTitle: '🏆 Trophies & Badges Room',
        trophiesSub: 'Every trophy you unlock grants +1 Free Spin on the Lucky Wheel 🎡!',
        mRule1: '1 per Color',
        mRule2: '1 per Row & Col',
        mRule3: 'No Touching',
        tapGuide: '1 Tap = Toggle <strong>✕</strong> &nbsp;|&nbsp; Fast Double-Tap = <strong>Place Character</strong>',
        luckyWheelTitle: '🎡 MawMaw Lucky Wheel',
        spinsAvailable: 'Available Spins:',
        spinNowBtn: '🎲 Spin Now!',
        noSpinsBtn: '⏳ No Spins Available',
        whoIsPlaying: '👋 Who is playing today?',
        chooseProfileSub: 'Choose your profile to play with your photo, sounds & saved progress:',
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
        bgmToggleLabel: 'Calm Background Music while playing 🎵',
        editingSoundsFor: 'Customizing sounds for active profile:',
        correctSoundsHint: 'Add up to 6 sounds played randomly when right (BGM ducks automatically):',
        wrongSoundsHint: 'Add up to 6 sounds played randomly when wrong:',
        doneBtn: 'Done ✅',
        exitConfirmTitle: 'Exit MawMaw Game?',
        exitConfirmSub: 'Your in-level board moves and stars are saved automatically.',
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

// عنصر SVG لعلامة X يملأ 75% من مساحة المربع مع توهج Glow
function getGlowingXSvg() {
    return `<svg class="tile-x-svg" viewBox="0 0 100 100">
        <path d="M 18,18 L 82,82 M 82,18 L 18,82" stroke="#ffffff" stroke-width="18" stroke-linecap="round"/>
        <path d="M 18,18 L 82,82 M 82,18 L 18,82" stroke="#4834d4" stroke-width="8" stroke-linecap="round"/>
    </svg>`;
}

// --- قاعدة بيانات IndexedDB ---
class StorageDB {
    constructor() { this.db = null; }
    init() {
        return new Promise((resolve) => {
            const req = indexedDB.open('MawMawProfilesDB_v5', 1);
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
    bgmEnabled: localStorage.getItem('mawmaw_bgm') !== 'false',
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
        unlockedLevel: 1,
        stars: {},
        score: 0,
        boosters: { cat: 7, hint: 9, mouse: 2 },
        savedGame: null,          // حفظ خطوات المستوى الحالي عند الخروج
        lastWeeklySpin: 0,        // طابع زمني للفة الأسبوعية
        bonusSpins: 0,            // لفات هدية عند تحقيق كأس جديد
        unlockedTrophies: { t1: true }
    };
}

function ensureProfileFields(p) {
    if (!p.unlockedLevel || p.unlockedLevel < 1) p.unlockedLevel = 1;
    if (!p.currentLevel || p.currentLevel < 1) p.currentLevel = 1;
    if (!p.stars) p.stars = {};
    if (!p.boosters) p.boosters = { cat: 7, hint: 9, mouse: 2 };
    if (!p.correctSounds) p.correctSounds = {};
    if (!p.wrongSounds) p.wrongSounds = {};
    if (typeof p.lastWeeklySpin !== 'number') p.lastWeeklySpin = 0;
    if (typeof p.bonusSpins !== 'number') p.bonusSpins = 0;
    if (!p.unlockedTrophies) p.unlockedTrophies = { t1: true };
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

// فحص ما إذا كان اللاعب قد فتح كأساً جديداً لمنحه لفة عجلة حظ مجانية!
function checkAndGrantNewTrophies(prof) {
    let newlyUnlocked = [];
    TROPHIES_LIST.forEach(t => {
        if (prof.unlockedLevel >= t.reqLvl && !prof.unlockedTrophies[t.id]) {
            prof.unlockedTrophies[t.id] = true;
            prof.bonusSpins = (prof.bonusSpins || 0) + 1;
            newlyUnlocked.push(appPrefs.lang === 'ar' ? t.ar : t.en);
        }
    });
    if (newlyUnlocked.length > 0) {
        const toast = document.getElementById('trophy-toast');
        const txt = document.getElementById('trophy-toast-text');
        txt.textContent = appPrefs.lang === 'ar'
            ? `فتحت وسام "${newlyUnlocked[0]}" + لفة عجلة حظ مجانية 🎡!`
            : `Unlocked "${newlyUnlocked[0]}" + 1 Free Wheel Spin 🎡!`;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 4000);
    }
}

// حساب اللفات المتاحة للبروفايل (لفة أسبوعية + لفات الكؤوس)
function getProfileSpinInfo(prof) {
    const now = Date.now();
    const elapsed = now - (prof.lastWeeklySpin || 0);
    const hasWeekly = elapsed >= ONE_WEEK_MS;
    const totalSpins = (hasWeekly ? 1 : 0) + (prof.bonusSpins || 0);
    const remainingMs = hasWeekly ? 0 : (ONE_WEEK_MS - elapsed);
    return { hasWeekly, totalSpins, remainingMs };
}

function formatRemainingCooldown(ms) {
    const days = Math.floor(ms / (24 * 60 * 60 * 1000));
    const hours = Math.floor((ms % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000));
    if (appPrefs.lang === 'ar') {
        return `اللفة الأسبوعية القادمة بعد: ${days} يوم و ${hours} ساعة (أو افتح كأساً جديداً 🏆!)`;
    }
    return `Next weekly spin in: ${days}d ${hours}h (or unlock a new Trophy 🏆!)`;
}

// --- نظام الصوتيات والموسيقى الخلفية مع خفض الصوت الذكي (Audio Ducking) ---
class SoundManager {
    constructor() {
        this.xTapAudio = new Audio('assets/sounds/x_tap.wav');
        this.xTapAudio.volume = 0.45;

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

        // موسيقى خلفية هادئة
        this.bgm = new Audio('assets/sounds/bgm.wav');
        this.bgm.loop = true;
        this.normalBgmVol = 0.16; // صوت خفيف وهادئ في الخلفية
        this.duckedBgmVol = 0.015; // يوطى جداً عند ظهور الأصوات المسجلة
        this.bgm.volume = this.normalBgmVol;
        this.duckTimer = null;
        this.fadeInterval = null;
    }

    updateBgmState() {
        const btn = document.getElementById('bgm-quick-btn');
        if (btn) btn.textContent = appPrefs.bgmEnabled ? '🎵' : '🔇';
        if (appPrefs.bgmEnabled && currentScreen === 'game') {
            this.bgm.play().catch(() => {});
        } else {
            this.bgm.pause();
        }
    }

    // خفض صوت الموسيقى الخلفية فوراً عند تشغيل صوت القطة أو التسجيل الصوتي
    duckBgm(minDurationMs = 1200) {
        if (!appPrefs.bgmEnabled) return;
        clearInterval(this.fadeInterval);
        clearTimeout(this.duckTimer);
        this.bgm.volume = this.duckedBgmVol;

        this.duckTimer = setTimeout(() => {
            this.restoreBgmSmoothly();
        }, minDurationMs);
    }

    restoreBgmSmoothly() {
        clearInterval(this.fadeInterval);
        this.fadeInterval = setInterval(() => {
            if (this.bgm.volume < this.normalBgmVol - 0.015) {
                this.bgm.volume = Math.min(this.normalBgmVol, this.bgm.volume + 0.015);
            } else {
                this.bgm.volume = this.normalBgmVol;
                clearInterval(this.fadeInterval);
            }
        }, 60);
    }

    playXTap() {
        if (!appPrefs.soundEnabled) return;
        this.xTapAudio.currentTime = 0;
        this.xTapAudio.play().catch(() => {});
    }

    playVoiceWithDucking(audioObj, fallbackMs = 1100) {
        this.duckBgm(fallbackMs);
        audioObj.onended = () => {
            clearTimeout(this.duckTimer);
            this.restoreBgmSmoothly();
        };
        audioObj.play().catch(() => {});
    }

    playCorrect() {
        if (!appPrefs.soundEnabled) return;
        const prof = getActiveProfile();
        const custom = Object.values(prof.correctSounds || {}).filter(Boolean);
        if (custom.length > 0) {
            const pick = custom[Math.floor(Math.random() * custom.length)];
            const customAudio = new Audio(pick.data);
            this.playVoiceWithDucking(customAudio, 3500);
        } else {
            const pick = this.defaultCorrect[Math.floor(Math.random() * this.defaultCorrect.length)];
            pick.currentTime = 0;
            this.playVoiceWithDucking(pick, 900);
        }
    }

    playWrong() {
        if (!appPrefs.soundEnabled) return;
        const prof = getActiveProfile();
        const custom = Object.values(prof.wrongSounds || {}).filter(Boolean);
        if (custom.length > 0) {
            const pick = custom[Math.floor(Math.random() * custom.length)];
            const customAudio = new Audio(pick.data);
            this.playVoiceWithDucking(customAudio, 3500);
        } else {
            const pick = this.defaultWrong[Math.floor(Math.random() * this.defaultWrong.length)];
            pick.currentTime = 0;
            this.playVoiceWithDucking(pick, 900);
        }
    }

    playWin() {
        if (!appPrefs.soundEnabled) return;
        this.defaultWin.currentTime = 0;
        this.playVoiceWithDucking(this.defaultWin, 1500);
    }
}

const sound = new SoundManager();

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

// --- مطر الاحتفال الملون (Confetti) ---
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
            p.x += p.vx; p.y += p.vy; p.rot += p.vRot;
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

// --- إدارة الشاشات وزر الرجوع ---
let currentScreen = 'home';

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

    sound.updateBgmState();
}

window.onHardwareBackPress = function() {
    const exitModal = document.getElementById('exit-confirm-modal');
    if (exitModal.classList.contains('active')) {
        exitModal.classList.remove('active');
        return 'STAY';
    }
    const anyModal = document.querySelector('.modal.active');
    if (anyModal) {
        anyModal.classList.remove('active');
        return 'STAY';
    }
    if (currentScreen !== 'home') {
        navigateToScreen('home');
        return 'STAY';
    }
    exitModal.classList.add('active');
    return 'STAY';
};

history.pushState({ page: 'mawmaw' }, '');
window.addEventListener('popstate', () => {
    window.onHardwareBackPress();
    history.pushState({ page: 'mawmaw' }, '');
});

document.getElementById('nav-back-btn').addEventListener('click', () => {
    if (currentScreen !== 'home') navigateToScreen('home');
    else openProfilePickerModal();
});

document.getElementById('stay-in-game-btn').addEventListener('click', () => {
    document.getElementById('exit-confirm-modal').classList.remove('active');
});

document.getElementById('confirm-exit-btn').addEventListener('click', () => {
    if (window.Capacitor && window.Capacitor.Plugins && window.Capacitor.Plugins.App) {
        window.Capacitor.Plugins.App.exitApp();
    } else if (navigator.app && navigator.app.exitApp) {
        navigator.app.exitApp();
    } else {
        window.close();
    }
});

// --- تحديث واجهة الشاشة الرئيسية ---
function updateHomeUI() {
    const prof = getActiveProfile();
    if (!prof) return;
    const dict = I18N[appPrefs.lang];

    document.getElementById('home-profile-img').src = prof.photo;
    document.getElementById('home-profile-name').textContent = prof.name;
    document.getElementById('home-unlocked-val').textContent = `${prof.unlockedLevel} / ${TOTAL_LEVELS}`;
    document.getElementById('home-score-val').textContent = prof.score || 0;

    // إذا كان هناك مستوى محفوظ قيد اللعب، اعرض رقمه واستكماله
    const targetLvl = (prof.savedGame && prof.savedGame.level) ? prof.savedGame.level : prof.unlockedLevel;
    document.getElementById('play-btn-lvl').textContent = targetLvl;
    document.getElementById('play-now-label').textContent = (prof.savedGame && prof.savedGame.level) ? dict.continuePlay : dict.playNow;

    document.getElementById('booster-cat-img').src = prof.photo;

    const spinInfo = getProfileSpinInfo(prof);
    document.getElementById('home-wheel-badge').textContent = spinInfo.totalSpins;
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

// --- 1. حفظ واسترجاع خطوات المستوى تلقائياً ---
let game = {
    level: 1,
    N: 9,
    catCols: [],
    colorGrid: [],
    boardState: [],
    lives: 3
};

const boardEl = document.getElementById('regions-board');
const gemsBar = document.getElementById('region-gems-bar');

function saveCurrentLevelProgress() {
    const prof = getActiveProfile();
    prof.savedGame = {
        level: game.level,
        boardState: game.boardState.map(row => [...row]),
        lives: game.lives
    };
    saveProfilesToDB();
}

function clearSavedLevelProgress() {
    const prof = getActiveProfile();
    prof.savedGame = null;
    saveProfilesToDB();
}

function startLevel(lvl, forceFresh = false) {
    const prof = getActiveProfile();
    if (lvl > prof.unlockedLevel) return;

    game.level = lvl;
    prof.currentLevel = lvl;

    const puzzle = generateRegionsPuzzle(lvl);
    game.N = puzzle.N;
    game.catCols = puzzle.catCols;
    game.colorGrid = puzzle.colorGrid;

    // استرجاع اللوحة المحفوظة إذا كان اللاعب قد بدأ هذا المستوى ولم ينهه بعد
    if (!forceFresh && prof.savedGame && prof.savedGame.level === lvl &&
        Array.isArray(prof.savedGame.boardState) && prof.savedGame.boardState.length === game.N) {
        game.boardState = prof.savedGame.boardState.map(row => [...row]);
        game.lives = prof.savedGame.lives || 3;
    } else {
        game.boardState = Array.from({ length: game.N }, () => new Array(game.N).fill(0));
        game.lives = 3;
        saveCurrentLevelProgress();
    }

    document.getElementById('level-num-display').textContent = lvl;
    document.getElementById('score-display').textContent = prof.score || 0;
    document.getElementById('booster-cat-img').src = prof.photo;

    updateBoostersUI();
    renderLivesUI();
    renderGemsBar();
    renderBoard();
    navigateToScreen('game');
}

document.getElementById('restart-lvl-btn').addEventListener('click', () => {
    startLevel(game.level, true);
});

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

// --- 3. نظام الضغط وعلامة X المتوهجة بحجم 75% مع الصوت الخفيف ---
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

    sound.playXTap();

    if (cur === 0) {
        game.boardState[r][c] = 1;
        if (tileEl) tileEl.innerHTML = getGlowingXSvg();
        saveCurrentLevelProgress();
    } else if (cur === 1) {
        game.boardState[r][c] = 0;
        const xEl = tileEl ? tileEl.querySelector('.tile-x-svg') : null;
        if (xEl) {
            xEl.classList.add('removing');
            setTimeout(() => { if (game.boardState[r][c] === 0) tileEl.innerHTML = ''; }, 160);
        } else if (tileEl) {
            tileEl.innerHTML = '';
        }
        saveCurrentLevelProgress();
    } else if (cur === 2) {
        game.boardState[r][c] = 0;
        const imgEl = tileEl ? tileEl.querySelector('.tile-avatar') : null;
        if (imgEl) {
            imgEl.classList.add('removing');
            setTimeout(() => {
                if (game.boardState[r][c] === 0) tileEl.innerHTML = '';
                updateGemsStatus();
            }, 160);
        }
        saveCurrentLevelProgress();
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
                tile.innerHTML = getGlowingXSvg();
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
                if (tEl) tEl.innerHTML = getGlowingXSvg();
            }
        }
    }
}

function placeCharacterAt(r, c) {
    const tileEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
    if (hasRuleViolation(r, c)) {
        game.boardState[r][c] = 1;
        if (tileEl) tileEl.innerHTML = getGlowingXSvg();
        sound.playWrong();
        spawnWrongAnimation(tileEl);

        game.lives--;
        renderLivesUI();

        if (game.lives <= 0) {
            clearSavedLevelProgress();
            setTimeout(() => {
                document.getElementById('lose-modal').classList.add('active');
            }, 600);
        } else {
            saveCurrentLevelProgress();
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
    saveCurrentLevelProgress();

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

        if (game.level === prof.unlockedLevel && prof.unlockedLevel < TOTAL_LEVELS) {
            prof.unlockedLevel++;
        }
        if (game.level < TOTAL_LEVELS) {
            prof.currentLevel = game.level + 1;
        }

        // مسح اللوحة المحفوظة لأن المستوى اكتمل بنجاح، وفحص ما إذا فتح كأساً جديداً!
        prof.savedGame = null;
        checkAndGrantNewTrophies(prof);
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

// --- المساعدات الثلاث ---
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
    wrongEmpty.sort(() => Math.random() - 0.5);
    wrongEmpty.slice(0, 5).forEach(([r, c]) => {
        game.boardState[r][c] = 1;
        const tEl = boardEl.querySelector(`.tile[data-r="${r}"][data-c="${c}"]`);
        if (tEl) tEl.innerHTML = getGlowingXSvg();
    });
    sound.playXTap();
    saveCurrentLevelProgress();
});

// --- خريطة المستويات وغرفة الكؤوس ---
function renderLevelsGrid() {
    const prof = getActiveProfile();
    const grid = document.getElementById('levels-grid');
    grid.innerHTML = '';

    for (let i = 1; i <= TOTAL_LEVELS; i++) {
        const btn = document.createElement('button');
        const isUnlocked = i <= prof.unlockedLevel;
        const stars = (prof.stars && prof.stars[i]) || 0;
        const hasSaved = prof.savedGame && prof.savedGame.level === i;

        btn.className = `lvl-btn ${!isUnlocked ? 'locked' : stars > 0 ? 'completed' : ''} ${i === prof.unlockedLevel ? 'current' : ''}`;
        if (isUnlocked) {
            btn.innerHTML = `
                <div style="font-size:1.05rem;">${i} ${hasSaved ? '⏳' : ''}</div>
                <div style="font-size:0.65rem;">${stars > 0 ? '⭐'.repeat(stars) : `${getGridSizeForLevel(i)}×${getGridSizeForLevel(i)}`}</div>
            `;
            btn.addEventListener('click', () => startLevel(i, false));
        } else {
            btn.innerHTML = `
                <div style="font-size:1rem;">🔒</div>
                <div style="font-size:0.7rem;">${i}</div>
            `;
        }
        grid.appendChild(btn);
    }
}

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

// --- 2. عجلة الحظ الدقيقة 100% + نظام مرة أسبوعياً ومرة لكل كأس ---
let wheelSpinning = false;
let wheelDeg = 0;

// تعريف الـ 6 خانات بنفس ترتيب الـ conic-gradient والـ wheel-label في HTML بالضبط:
// Slice 0 (center 30deg):  🪄 +2
// Slice 1 (center 90deg):  🧭 +3
// Slice 2 (center 150deg): ⚡ +2
// Slice 3 (center 210deg): ⭐ +100
// Slice 4 (center 270deg): 🎁 +1 الكل
// Slice 5 (center 330deg): 🪄 +3
const WHEEL_SLICES = [
    { index: 0, centerDeg: 30,  ar: '🎉 ربحت +2 عصا سحرية 🪄!', en: '🎉 Won +2 Magic Wands 🪄!', apply: p => p.boosters.cat += 2 },
    { index: 1, centerDeg: 90,  ar: '🎉 ربحت +3 بوصلة ذكية 🧭!', en: '🎉 Won +3 Smart Compasses 🧭!', apply: p => p.boosters.hint += 3 },
    { index: 2, centerDeg: 150, ar: '🎉 ربحت +2 برق كاشف ⚡!', en: '🎉 Won +2 Lightning Zaps ⚡!', apply: p => p.boosters.mouse += 2 },
    { index: 3, centerDeg: 210, ar: '🎉 ربحت +100 نقطة ذهبية ⭐!', en: '🎉 Won +100 Bonus Score ⭐!', apply: p => p.score = (p.score || 0) + 100 },
    { index: 4, centerDeg: 270, ar: '🎁 جائزة كبرى! +1 لكل المساعدات!', en: '🎁 Jackpot! +1 of ALL Power-ups!', apply: p => { p.boosters.cat++; p.boosters.hint++; p.boosters.mouse++; } },
    { index: 5, centerDeg: 330, ar: '🎉 ربحت +3 عصا سحرية 🪄!', en: '🎉 Won +3 Magic Wands 🪄!', apply: p => p.boosters.cat += 3 }
];

function updateWheelModalUI() {
    const prof = getActiveProfile();
    const info = getProfileSpinInfo(prof);
    const dict = I18N[appPrefs.lang];

    document.getElementById('wheel-spins-count').textContent = info.totalSpins;
    const spinBtn = document.getElementById('spin-wheel-btn');
    const subText = document.getElementById('wheel-cooldown-text');

    if (info.totalSpins > 0) {
        spinBtn.disabled = false;
        spinBtn.textContent = dict.spinNowBtn;
        subText.textContent = info.hasWeekly
            ? (appPrefs.lang === 'ar' ? '✨ لفتك الأسبوعية المجانية جاهزة الآن!' : '✨ Your Weekly Free Spin is ready!')
            : (appPrefs.lang === 'ar' ? `🏆 لديك ${prof.bonusSpins} لفة هدية من الكؤوس!` : `🏆 You have ${prof.bonusSpins} Trophy Bonus Spins!`);
    } else {
        spinBtn.disabled = true;
        spinBtn.textContent = dict.noSpinsBtn;
        subText.textContent = formatRemainingCooldown(info.remainingMs);
    }
    updateHomeUI();
}

document.getElementById('open-wheel-btn').addEventListener('click', () => {
    document.getElementById('wheel-prize-msg').textContent = '';
    updateWheelModalUI();
    document.getElementById('wheel-modal').classList.add('active');
});

document.getElementById('close-wheel-btn').addEventListener('click', () => {
    if (!wheelSpinning) document.getElementById('wheel-modal').classList.remove('active');
});

document.getElementById('spin-wheel-btn').addEventListener('click', async () => {
    if (wheelSpinning) return;
    const prof = getActiveProfile();
    const info = getProfileSpinInfo(prof);
    if (info.totalSpins <= 0) return;

    wheelSpinning = true;
    document.getElementById('spin-wheel-btn').disabled = true;
    document.getElementById('wheel-prize-msg').textContent = '...';

    // خصم اللفة (الأولوية للفة الأسبوعية ثم لفات الكؤوس)
    if (info.hasWeekly) {
        prof.lastWeeklySpin = Date.now();
    } else {
        prof.bonusSpins = Math.max(0, (prof.bonusSpins || 0) - 1);
    }
    await saveProfilesToDB();

    // اختيار الجائزة وحساب الزاوية الهندسية الدقيقة ليقف المؤشر العلوي (0deg) في منتصف الخانة تماماً!
    const chosenSlice = WHEEL_SLICES[Math.floor(Math.random() * WHEEL_SLICES.length)];
    const targetMod = (360 - chosenSlice.centerDeg) % 360;
    const currentMod = ((wheelDeg % 360) + 360) % 360;
    let delta = targetMod - currentMod;
    if (delta <= 0) delta += 360;

    // 5 لفات كاملة (1800 درجة) + الزاوية الدقيقة للخانة المختارة
    wheelDeg += 1800 + delta;
    document.getElementById('lucky-wheel-disc').style.transform = `rotate(${wheelDeg}deg)`;

    setTimeout(async () => {
        chosenSlice.apply(prof);
        await saveProfilesToDB();
        sound.playWin();
        launchConfetti();
        document.getElementById('wheel-prize-msg').textContent = appPrefs.lang === 'ar' ? chosenSlice.ar : chosenSlice.en;
        wheelSpinning = false;
        updateWheelModalUI();
    }, 3450);
});

// --- لوحة الأسرار (Secret Cheats) ---
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
document.getElementById('home-logo-secret').addEventListener('click', handleSecretTriggerTap);
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
    checkAndGrantNewTrophies(prof);
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

document.getElementById('cheat-add-spins-btn').addEventListener('click', async () => {
    const prof = getActiveProfile();
    prof.bonusSpins = (prof.bonusSpins || 0) + 10;
    await saveProfilesToDB();
    updateHomeUI();
    sound.playCorrect();
    document.getElementById('cheat-status-msg').textContent = '✅ تمت إضافة +10 لفات لعجلة الحظ!';
});

document.getElementById('cheat-add-score-btn').addEventListener('click', async () => {
    const prof = getActiveProfile();
    prof.score = (prof.score || 0) + 1000;
    prof.unlockedLevel = TOTAL_LEVELS;
    checkAndGrantNewTrophies(prof);
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
    startLevel(val, true);
});

// --- أزرار الشاشة الرئيسية ---
document.getElementById('play-now-btn').addEventListener('click', () => {
    const prof = getActiveProfile();
    const targetLvl = (prof.savedGame && prof.savedGame.level) ? prof.savedGame.level : (prof.unlockedLevel || 1);
    startLevel(targetLvl, false);
});
document.getElementById('open-levels-btn').addEventListener('click', () => navigateToScreen('levels'));
document.getElementById('open-trophies-btn').addEventListener('click', () => navigateToScreen('trophies'));
document.getElementById('open-settings-home-btn').addEventListener('click', () => openSettingsModal());
document.getElementById('quick-swap-btn').addEventListener('click', () => openProfilePickerModal());

document.getElementById('bgm-quick-btn').addEventListener('click', () => {
    appPrefs.bgmEnabled = !appPrefs.bgmEnabled;
    localStorage.setItem('mawmaw_bgm', appPrefs.bgmEnabled);
    document.getElementById('bgm-toggle').checked = appPrefs.bgmEnabled;
    sound.updateBgmState();
});

document.getElementById('next-level-btn').addEventListener('click', () => {
    document.getElementById('win-modal').classList.remove('active');
    const nextLvl = game.level < TOTAL_LEVELS ? game.level + 1 : 1;
    startLevel(nextLvl, true);
});

document.getElementById('retry-level-btn').addEventListener('click', () => {
    document.getElementById('lose-modal').classList.remove('active');
    startLevel(game.level, true);
});

// --- نافذة اختيار البروفايل ---
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
            if (currentScreen === 'game') {
                const targetLvl = (p.savedGame && p.savedGame.level) ? p.savedGame.level : (p.unlockedLevel || 1);
                startLevel(targetLvl, false);
            }
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
        unlockedLevel: 1,
        stars: {},
        score: 0,
        boosters: { cat: 7, hint: 9, mouse: 2 },
        savedGame: null,
        lastWeeklySpin: 0,
        bonusSpins: 0,
        unlockedTrophies: { t1: true }
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
            playB.onclick = () => {
                const a = new Audio(entry.data);
                sound.playVoiceWithDucking(a, 3000);
            };

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
document.getElementById('bgm-toggle').addEventListener('change', (e) => {
    appPrefs.bgmEnabled = e.target.checked;
    localStorage.setItem('mawmaw_bgm', appPrefs.bgmEnabled);
    sound.updateBgmState();
});

// --- تهيئة اللعبة ---
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
    document.getElementById('bgm-toggle').checked = appPrefs.bgmEnabled;
    sound.updateBgmState();

    applyLanguage(appPrefs.lang);
    navigateToScreen('home');

    if (profiles.length > 1) {
        openProfilePickerModal();
    }
}

initApp();
JS_EOF

# 5. مزامنة الأندرويد ورفع التحديث إلى GitHub لبناء الـ APK الجديد
echo "🔄 جاري مزامنة مشروع الأندرويد (Capacitor Sync)..."
npx cap sync android

echo "🚀 جاري رفع التحديث الاحترافي الخامس إلى GitHub لبناء الـ APK..."
git add .
git commit -m "Upgrade MawMaw v5: 3D Pro Logo, mid-level auto-save, exact wheel math + weekly/trophy spins, 75% glowing X with sound, and BGM with audio ducking" || true
git push

echo "=================================================================="
echo "🎉 تم تحديث اللعبة بالكامل ورفعها إلى GitHub بنجاح!"
echo "📱 اذهب إلى تبويب Actions في صفحة مستودعك لتحميل ملف MawMaw-Android-APK."
echo "=================================================================="
