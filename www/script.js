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
