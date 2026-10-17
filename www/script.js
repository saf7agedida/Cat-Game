const ITEMS_META = [
    { id: 1, svg: 'assets/cats/cat1.svg', border: '#E53935', bg: '#FFCDD2', badge: '🐾', name: 'مشمش' },
    { id: 2, svg: 'assets/cats/cat2.svg', border: '#1E88E5', bg: '#BBDEFB', badge: '🕶️', name: 'سمسم' },
    { id: 3, svg: 'assets/cats/cat3.svg', border: '#43A047', bg: '#C8E6C9', badge: '🎀', name: 'لوزة' },
    { id: 4, svg: 'assets/cats/cat4.svg', border: '#FDD835', bg: '#FFF9C4', badge: '🤠', name: 'زعبلاوي' },
    { id: 5, svg: 'assets/cats/cat5.svg', border: '#8E24AA', bg: '#E1BEE7', badge: '👑', name: 'سيمبا' },
    { id: 6, svg: 'assets/cats/cat6.svg', border: '#FB8C00', bg: '#FFE0B2', badge: '🦸', name: 'نمر' },
    { id: 7, svg: 'assets/cats/cat7.svg', border: '#00ACC1', bg: '#B2EBF2', badge: '⚽', name: 'كابتن' },
    { id: 8, svg: 'assets/cats/cat8.svg', border: '#6D4C41', bg: '#D7CCC8', badge: '🚀', name: 'فضائي' },
    { id: 9, svg: 'assets/cats/cat9.svg', border: '#D81B60', bg: '#F8BBD0', badge: '🎓', name: 'عبقري' }
];

// --- قاعدة بيانات IndexedDB لحفظ الصور و12 مقطع صوتي بدون حدود حجم ---
class CustomStorageDB {
    constructor() {
        this.db = null;
    }
    init() {
        return new Promise((resolve) => {
            const req = indexedDB.open('MeowdokuCustomDB', 1);
            req.onupgradeneeded = (e) => {
                const db = e.target.result;
                if (!db.objectStoreNames.contains('assets')) {
                    db.createObjectStore('assets');
                }
            };
            req.onsuccess = (e) => {
                this.db = e.target.result;
                resolve();
            };
            req.onerror = () => resolve();
        });
    }
    setItem(key, val) {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('assets', 'readwrite');
            tx.objectStore('assets').put(val, key);
            tx.oncomplete = () => resolve();
        });
    }
    getItem(key) {
        return new Promise((resolve) => {
            if (!this.db) return resolve(null);
            const tx = this.db.transaction('assets', 'readonly');
            const req = tx.objectStore('assets').get(key);
            req.onsuccess = () => resolve(req.result || null);
            req.onerror = () => resolve(null);
        });
    }
    deleteItem(key) {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('assets', 'readwrite');
            tx.objectStore('assets').delete(key);
            tx.oncomplete = () => resolve();
        });
    }
    clearAll() {
        return new Promise((resolve) => {
            if (!this.db) return resolve();
            const tx = this.db.transaction('assets', 'readwrite');
            tx.objectStore('assets').clear();
            tx.oncomplete = () => resolve();
        });
    }
}

const storageDB = new CustomStorageDB();

// الحالة المحملة للتخصيص
let customization = {
    mode: localStorage.getItem('meow_avatar_mode') || 'cats', // 'cats' or 'son'
    unifiedSonPhoto: null,
    individualPhotos: {}, // 1..9
    correctSounds: {},    // 1..6 (DataURL)
    wrongSounds: {}       // 1..6 (DataURL)
};

async function loadCustomAssetsFromDB() {
    await storageDB.init();
    customization.unifiedSonPhoto = await storageDB.getItem('unified_son_photo');
    for (let i = 1; i <= 9; i++) {
        const img = await storageDB.getItem(`son_photo_${i}`);
        if (img) customization.individualPhotos[i] = img;
    }
    for (let i = 1; i <= 6; i++) {
        const cSnd = await storageDB.getItem(`correct_snd_${i}`);
        if (cSnd) customization.correctSounds[i] = cSnd;
        const wSnd = await storageDB.getItem(`wrong_snd_${i}`);
        if (wSnd) customization.wrongSounds[i] = wSnd;
    }
    updateHeaderBranding();
}

function updateHeaderBranding() {
    const iconEl = document.getElementById('header-icon');
    const titleEl = document.getElementById('game-title');
    if (customization.mode === 'son') {
        iconEl.textContent = '👦✨';
        titleEl.textContent = 'سودوكو البطل';
    } else {
        iconEl.textContent = '🐾';
        titleEl.textContent = 'Meowdoku';
    }
}

// إنشاء عنصر القطة أو صورة الابن
function createAvatarElement(itemId) {
    const meta = ITEMS_META[itemId - 1];
    const wrap = document.createElement('div');
    wrap.className = 'avatar-wrap';

    const img = document.createElement('img');
    img.className = 'avatar-img';

    if (customization.mode === 'son') {
        const customSrc = customization.individualPhotos[itemId] || customization.unifiedSonPhoto;
        if (customSrc) {
            img.src = customSrc;
            img.style.border = `3px solid ${meta.border}`;
            img.style.backgroundColor = meta.bg;
            const badge = document.createElement('span');
            badge.className = 'avatar-badge';
            badge.textContent = meta.badge;
            wrap.appendChild(img);
            wrap.appendChild(badge);
            return wrap;
        }
    }

    // الافتراضي: صورة القطة المدمجة
    img.src = meta.svg;
    wrap.appendChild(img);
    return wrap;
}

// --- نظام الصوتيات المتقدم (يدعم حتى 6 أصوات صحيحة و6 أصوات خاطئة + ملفات WAV الافتراضية) ---
class SoundSystem {
    constructor() {
        this.enabled = true;
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

    playRandomCorrect() {
        if (!this.enabled) return;
        const customList = Object.values(customization.correctSounds).filter(Boolean);
        if (customList.length > 0) {
            const pick = customList[Math.floor(Math.random() * customList.length)];
            const audio = new Audio(pick.data);
            audio.play().catch(() => {});
        } else {
            const pick = this.defaultCorrect[Math.floor(Math.random() * this.defaultCorrect.length)];
            pick.currentTime = 0;
            pick.play().catch(() => {});
        }
    }

    playRandomWrong() {
        if (!this.enabled) return;
        const customList = Object.values(customization.wrongSounds).filter(Boolean);
        if (customList.length > 0) {
            const pick = customList[Math.floor(Math.random() * customList.length)];
            const audio = new Audio(pick.data);
            audio.play().catch(() => {});
        } else {
            const pick = this.defaultWrong[Math.floor(Math.random() * this.defaultWrong.length)];
            pick.currentTime = 0;
            pick.play().catch(() => {});
        }
    }

    playWin() {
        if (!this.enabled) return;
        this.defaultWin.currentTime = 0;
        this.defaultWin.play().catch(() => {});
    }
}

const sound = new SoundSystem();

// --- إعدادات الـ 50 مستوى ---
function getLevelConfig(levelNum) {
    if (levelNum <= 15) {
        const emptyCount = 4 + Math.floor((levelNum - 1) * 0.45);
        return { level: levelNum, size: 4, boxR: 2, boxC: 2, empty: emptyCount };
    } else if (levelNum <= 35) {
        const emptyCount = 12 + Math.floor((levelNum - 16) * 0.55);
        return { level: levelNum, size: 6, boxR: 2, boxC: 3, empty: emptyCount };
    } else {
        const emptyCount = 30 + Math.floor((levelNum - 36) * 1.3);
        return { level: levelNum, size: 9, boxR: 3, boxC: 3, empty: emptyCount };
    }
}

class SeededRNG {
    constructor(seed) { this.seed = seed * 98765 + 12345; }
    next() {
        this.seed = (this.seed * 1664525 + 1013904223) % 4294967296;
        return this.seed / 4294967296;
    }
    nextInt(max) { return Math.floor(this.next() * max); }
    shuffle(array) {
        const arr = [...array];
        for (let i = arr.length - 1; i > 0; i--) {
            const j = this.nextInt(i + 1);
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    }
}

function generateLevelPuzzle(levelNum) {
    const config = getLevelConfig(levelNum);
    const { size, boxR, boxC, empty } = config;
    const rng = new SeededRNG(levelNum);

    let board = Array.from({ length: size }, (_, r) =>
        Array.from({ length: size }, (_, c) =>
            ((r * boxC + Math.floor(r / boxR) + c) % size) + 1
        )
    );

    const symbolMap = rng.shuffle(Array.from({ length: size }, (_, i) => i + 1));
    board = board.map(row => row.map(val => symbolMap[val - 1]));

    for (let b = 0; b < size / boxR; b++) {
        const rowIndices = rng.shuffle(Array.from({ length: boxR }, (_, i) => b * boxR + i));
        const tempRows = rowIndices.map(r => [...board[r]]);
        for (let i = 0; i < boxR; i++) board[b * boxR + i] = tempRows[i];
    }

    for (let b = 0; b < size / boxC; b++) {
        const colIndices = rng.shuffle(Array.from({ length: boxC }, (_, i) => b * boxC + i));
        const tempCols = board.map(row => colIndices.map(c => row[c]));
        for (let r = 0; r < size; r++) {
            for (let i = 0; i < boxC; i++) board[r][b * boxC + i] = tempCols[r][i];
        }
    }

    const solution = board.map(row => [...row]);
    const puzzle = board.map(row => [...row]);

    const allCoords = [];
    for (let r = 0; r < size; r++) for (let c = 0; c < size; c++) allCoords.push([r, c]);
    const shuffledCoords = rng.shuffle(allCoords);

    let removed = 0;
    for (const [r, c] of shuffledCoords) {
        if (removed >= empty) break;
        const rowRemaining = puzzle[r].filter(v => v !== 0).length;
        const colRemaining = puzzle.map(row => row[c]).filter(v => v !== 0).length;
        if (rowRemaining > 1 && colRemaining > 1) {
            puzzle[r][c] = 0;
            removed++;
        }
    }
    return { config, solution, puzzle };
}

let progressData = JSON.parse(localStorage.getItem('meowdoku_v2_save')) || {
    unlockedLevel: 1,
    stars: {}
};

let currentState = {
    level: 1,
    config: null,
    solution: [],
    initialPuzzle: [],
    userBoard: [],
    selectedCell: null,
    mistakes: 0,
    hintsLeft: 3,
    seconds: 0,
    timerInterval: null
};

const levelScreen = document.getElementById('level-screen');
const gameScreen = document.getElementById('game-screen');
const levelsGrid = document.getElementById('levels-grid');
const completedCountEl = document.getElementById('completed-count');
const menuBtn = document.getElementById('menu-btn');
const soundBtn = document.getElementById('sound-btn');
const settingsBtn = document.getElementById('settings-btn');
const boardEl = document.getElementById('sudoku-board');
const paletteEl = document.getElementById('item-palette');
const winModal = document.getElementById('win-modal');
const settingsModal = document.getElementById('settings-modal');

function renderLevelSelect() {
    levelsGrid.innerHTML = '';
    completedCountEl.textContent = Object.keys(progressData.stars).length;

    for (let i = 1; i <= 50; i++) {
        const btn = document.createElement('div');
        const isUnlocked = i <= progressData.unlockedLevel;
        const stars = progressData.stars[i] || 0;

        btn.className = `level-btn ${isUnlocked ? 'unlocked' : 'locked'} ${stars > 0 ? 'completed' : ''}`;
        btn.innerHTML = `
            <span class="level-num">${isUnlocked ? i : '🔒'}</span>
            <span class="level-stars">${stars > 0 ? '⭐'.repeat(stars) : ''}</span>
        `;
        if (isUnlocked) btn.addEventListener('click', () => startLevel(i));
        levelsGrid.appendChild(btn);
    }
}

function startLevel(levelNum) {
    const generated = generateLevelPuzzle(levelNum);
    currentState = {
        level: levelNum,
        config: generated.config,
        solution: generated.solution,
        initialPuzzle: generated.puzzle.map(r => [...r]),
        userBoard: generated.puzzle.map(r => [...r]),
        selectedCell: null,
        mistakes: 0,
        hintsLeft: 3,
        seconds: 0,
        timerInterval: null
    };

    document.getElementById('current-level-display').textContent = levelNum;
    document.getElementById('mistakes-display').textContent = '0';
    document.getElementById('hints-left').textContent = '3';
    document.getElementById('timer-display').textContent = '00:00';

    levelScreen.classList.remove('active');
    gameScreen.classList.add('active');
    menuBtn.style.display = 'block';

    renderBoard();
    renderPalette();
    startTimer();
}

function renderBoard() {
    if (!currentState.config) return;
    const { size, boxR, boxC } = currentState.config;
    boardEl.innerHTML = '';
    boardEl.style.gridTemplateColumns = `repeat(${size}, 1fr)`;
    boardEl.style.gridTemplateRows = `repeat(${size}, 1fr)`;

    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            const cell = document.createElement('div');
            cell.className = 'cell';
            cell.dataset.r = r;
            cell.dataset.c = c;

            if ((r + 1) % boxR === 0 && r < size - 1) cell.style.borderBottom = '3px solid var(--border-strong)';
            if ((c + 1) % boxC === 0 && c < size - 1) cell.style.borderLeft = '3px solid var(--border-strong)';

            const val = currentState.userBoard[r][c];
            if (currentState.initialPuzzle[r][c] !== 0) cell.classList.add('fixed');
            if (val !== 0) cell.appendChild(createAvatarElement(val));

            cell.addEventListener('click', () => selectCell(r, c));
            boardEl.appendChild(cell);
        }
    }
    updateBoardHighlights();
}

function renderPalette() {
    if (!currentState.config) return;
    const { size } = currentState.config;
    paletteEl.innerHTML = '';

    for (let i = 0; i < size; i++) {
        const meta = ITEMS_META[i];
        const btn = document.createElement('button');
        btn.className = 'palette-btn';

        const box = document.createElement('div');
        box.className = 'palette-avatar-box';
        box.appendChild(createAvatarElement(meta.id));

        const nameSpan = document.createElement('span');
        nameSpan.className = 'palette-name';
        nameSpan.textContent = meta.name;

        btn.appendChild(box);
        btn.appendChild(nameSpan);
        btn.addEventListener('click', () => placeItem(meta.id));
        paletteEl.appendChild(btn);
    }
}

function selectCell(r, c) {
    currentState.selectedCell = { r, c };
    updateBoardHighlights();
}

function hasConflict(r, c, val) {
    const { size, boxR, boxC } = currentState.config;
    const board = currentState.userBoard;
    for (let i = 0; i < size; i++) {
        if (i !== c && board[r][i] === val) return true;
        if (i !== r && board[i][c] === val) return true;
    }
    const startR = Math.floor(r / boxR) * boxR;
    const startC = Math.floor(c / boxC) * boxC;
    for (let rr = startR; rr < startR + boxR; rr++) {
        for (let cc = startC; cc < startC + boxC; cc++) {
            if ((rr !== r || cc !== c) && board[rr][cc] === val) return true;
        }
    }
    return false;
}

function updateBoardHighlights() {
    const { boxR, boxC } = currentState.config;
    const sel = currentState.selectedCell;
    const selectedVal = sel ? currentState.userBoard[sel.r][sel.c] : 0;

    boardEl.querySelectorAll('.cell').forEach(cell => {
        const r = parseInt(cell.dataset.r);
        const c = parseInt(cell.dataset.c);
        const val = currentState.userBoard[r][c];

        cell.classList.remove('selected', 'related', 'same-item', 'error');

        if (sel) {
            const sameBox = Math.floor(r / boxR) === Math.floor(sel.r / boxR) &&
                            Math.floor(c / boxC) === Math.floor(sel.c / boxC);
            if (r === sel.r && c === sel.c) cell.classList.add('selected');
            else if (r === sel.r || c === sel.c || sameBox) cell.classList.add('related');
            if (val !== 0 && val === selectedVal) cell.classList.add('same-item');
        }

        if (val !== 0 && (hasConflict(r, c, val) || val !== currentState.solution[r][c])) {
            cell.classList.add('error');
        }
    });
}

function placeItem(itemId) {
    const sel = currentState.selectedCell;
    if (!sel) return;
    const { r, c } = sel;
    if (currentState.initialPuzzle[r][c] !== 0) return;

    currentState.userBoard[r][c] = itemId;
    const cellEl = boardEl.querySelector(`.cell[data-r="${r}"][data-c="${c}"]`);
    cellEl.innerHTML = '';
    cellEl.appendChild(createAvatarElement(itemId));
    cellEl.classList.remove('pop');
    void cellEl.offsetWidth;
    cellEl.classList.add('pop');

    // فحص ما إذا كان المكان صحيحاً أم خاطئاً وتشغيل الصوت العشوائي المناسب
    const isCorrectSpot = (itemId === currentState.solution[r][c]) && !hasConflict(r, c, itemId);
    if (isCorrectSpot) {
        sound.playRandomCorrect();
    } else {
        currentState.mistakes++;
        document.getElementById('mistakes-display').textContent = currentState.mistakes;
        sound.playRandomWrong();
    }

    updateBoardHighlights();
    checkWinCondition();
}

document.getElementById('erase-btn').addEventListener('click', () => {
    const sel = currentState.selectedCell;
    if (!sel) return;
    const { r, c } = sel;
    if (currentState.initialPuzzle[r][c] !== 0) return;
    currentState.userBoard[r][c] = 0;
    boardEl.querySelector(`.cell[data-r="${r}"][data-c="${c}"]`).innerHTML = '';
    updateBoardHighlights();
});

document.getElementById('hint-btn').addEventListener('click', () => {
    if (currentState.hintsLeft <= 0) return;
    const { size } = currentState.config;
    let target = currentState.selectedCell;
    if (!target || currentState.userBoard[target.r][target.c] === currentState.solution[target.r][target.c]) {
        target = null;
        for (let r = 0; r < size; r++) {
            for (let c = 0; c < size; c++) {
                if (currentState.userBoard[r][c] !== currentState.solution[r][c]) {
                    target = { r, c };
                    break;
                }
            }
            if (target) break;
        }
    }
    if (target) {
        currentState.hintsLeft--;
        document.getElementById('hints-left').textContent = currentState.hintsLeft;
        currentState.selectedCell = target;
        placeItem(currentState.solution[target.r][target.c]);
    }
});

document.getElementById('restart-btn').addEventListener('click', () => startLevel(currentState.level));

function checkWinCondition() {
    const { size } = currentState.config;
    for (let r = 0; r < size; r++) {
        for (let c = 0; c < size; c++) {
            const val = currentState.userBoard[r][c];
            if (val === 0 || val !== currentState.solution[r][c]) return;
        }
    }
    clearInterval(currentState.timerInterval);
    setTimeout(() => sound.playWin(), 250);

    const stars = currentState.mistakes === 0 ? 3 : currentState.mistakes <= 2 ? 2 : 1;
    progressData.stars[currentState.level] = Math.max(progressData.stars[currentState.level] || 0, stars);
    if (currentState.level === progressData.unlockedLevel && currentState.level < 50) {
        progressData.unlockedLevel++;
    }
    localStorage.setItem('meowdoku_v2_save', JSON.stringify(progressData));

    document.getElementById('win-time').textContent = formatTime(currentState.seconds);
    document.getElementById('win-mistakes').textContent = currentState.mistakes;
    document.getElementById('win-stars').textContent = '⭐'.repeat(stars);
    document.getElementById('next-level-btn').style.display = currentState.level < 50 ? 'block' : 'none';
    winModal.classList.add('active');
}

function startTimer() {
    clearInterval(currentState.timerInterval);
    currentState.seconds = 0;
    currentState.timerInterval = setInterval(() => {
        currentState.seconds++;
        document.getElementById('timer-display').textContent = formatTime(currentState.seconds);
    }, 1000);
}

function formatTime(sec) {
    const m = String(Math.floor(sec / 60)).padStart(2, '0');
    const s = String(sec % 60).padStart(2, '0');
    return `${m}:${s}`;
}

// --- إدارة نافذة الإعدادات (الصور + 6 أصوات صحيحة + 6 أصوات خاطئة) ---
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
        customization.mode = e.target.value;
        localStorage.setItem('meow_avatar_mode', customization.mode);
        updateHeaderBranding();
        if (gameScreen.classList.contains('active')) {
            renderBoard();
            renderPalette();
        }
    });
});

function resizeImageFile(file, callback) {
    const reader = new FileReader();
    reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
            const canvas = document.createElement('canvas');
            const size = 180;
            canvas.width = size;
            canvas.height = size;
            const ctx = canvas.getContext('2d');
            const minDim = Math.min(img.width, img.height);
            ctx.drawImage(img, (img.width - minDim) / 2, (img.height - minDim) / 2, minDim, minDim, 0, 0, size, size);
            callback(canvas.toDataURL('image/jpeg', 0.85));
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
}

// رفع صورة موحدة للابن
document.getElementById('single-son-input').addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    resizeImageFile(file, async (dataUrl) => {
        customization.unifiedSonPhoto = dataUrl;
        customization.mode = 'son';
        localStorage.setItem('meow_avatar_mode', 'son');
        await storageDB.setItem('unified_son_photo', dataUrl);
        renderSettingsContent();
        updateHeaderBranding();
        if (gameScreen.classList.contains('active')) {
            renderBoard();
            renderPalette();
        }
    });
});

function renderSettingsContent() {
    // ضبط زر الراديو الحالي
    document.querySelectorAll('input[name="avatar-mode"]').forEach(r => {
        r.checked = (r.value === customization.mode);
    });

    // 1. قائمة الـ 9 صور الفردية
    const facesList = document.getElementById('custom-faces-list');
    facesList.innerHTML = '';
    ITEMS_META.forEach(meta => {
        const row = document.createElement('div');
        row.className = 'custom-row';

        const info = document.createElement('div');
        info.className = 'row-info';
        const previewBox = document.createElement('div');
        previewBox.style.width = '36px';
        previewBox.style.height = '36px';
        previewBox.appendChild(createAvatarElement(meta.id));
        info.appendChild(previewBox);
        info.insertAdjacentHTML('beforeend', `<span><strong>شكل ${meta.id}:</strong> ${meta.name} ${meta.badge}</span>`);

        const actions = document.createElement('div');
        actions.className = 'row-actions';
        const upLabel = document.createElement('label');
        upLabel.className = 'mini-btn upload';
        upLabel.textContent = '📷 صورة';
        const inp = document.createElement('input');
        inp.type = 'file';
        inp.accept = 'image/*';
        inp.style.display = 'none';
        inp.addEventListener('change', (e) => {
            if (!e.target.files[0]) return;
            resizeImageFile(e.target.files[0], async (dataUrl) => {
                customization.individualPhotos[meta.id] = dataUrl;
                customization.mode = 'son';
                localStorage.setItem('meow_avatar_mode', 'son');
                await storageDB.setItem(`son_photo_${meta.id}`, dataUrl);
                renderSettingsContent();
                if (gameScreen.classList.contains('active')) { renderBoard(); renderPalette(); }
            });
        });
        upLabel.appendChild(inp);
        actions.appendChild(upLabel);
        row.appendChild(info);
        row.appendChild(actions);
        facesList.appendChild(row);
    });

    // 2. قائمة الـ 6 أصوات للإجابة الصحيحة
    renderAudioSlots('correct-sounds-list', customization.correctSounds, 'correct_snd_', 'صوت صحيح');

    // 3. قائمة الـ 6 أصوات للإجابة الخاطئة
    renderAudioSlots('wrong-sounds-list', customization.wrongSounds, 'wrong_snd_', 'صوت خطأ');
}

function renderAudioSlots(containerId, soundMap, dbPrefix, labelPrefix) {
    const container = document.getElementById(containerId);
    container.innerHTML = '';

    for (let i = 1; i <= 6; i++) {
        const currentAudio = soundMap[i];
        const row = document.createElement('div');
        row.className = 'custom-row';

        const info = document.createElement('div');
        info.className = 'row-info';
        info.innerHTML = `<span>🎵 <strong>${labelPrefix} (${i}):</strong> ${currentAudio ? currentAudio.name : 'افتراضي (صوت القطة)'}</span>`;

        const actions = document.createElement('div');
        actions.className = 'row-actions';

        if (currentAudio) {
            const playBtn = document.createElement('button');
            playBtn.className = 'mini-btn play';
            playBtn.textContent = '▶️ سماع';
            playBtn.addEventListener('click', () => {
                new Audio(currentAudio.data).play();
            });

            const delBtn = document.createElement('button');
            delBtn.className = 'mini-btn delete';
            delBtn.textContent = '🗑️';
            delBtn.addEventListener('click', async () => {
                delete soundMap[i];
                await storageDB.deleteItem(`${dbPrefix}${i}`);
                renderSettingsContent();
            });

            actions.appendChild(playBtn);
            actions.appendChild(delBtn);
        }

        const upLabel = document.createElement('label');
        upLabel.className = 'mini-btn upload';
        upLabel.textContent = '📁 رفع صوت';
        const inp = document.createElement('input');
        inp.type = 'file';
        inp.accept = 'audio/*';
        inp.style.display = 'none';
        inp.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = async (ev) => {
                const entry = { name: file.name.slice(0, 18), data: ev.target.result };
                soundMap[i] = entry;
                await storageDB.setItem(`${dbPrefix}${i}`, entry);
                renderSettingsContent();
            };
            reader.readAsDataURL(file);
        });

        upLabel.appendChild(inp);
        actions.appendChild(upLabel);
        row.appendChild(info);
        row.appendChild(actions);
        container.appendChild(row);
    }
}

settingsBtn.addEventListener('click', () => {
    renderSettingsContent();
    settingsModal.classList.add('active');
});

document.getElementById('close-settings-top').addEventListener('click', () => settingsModal.classList.remove('active'));
document.getElementById('save-settings-btn').addEventListener('click', () => settingsModal.classList.remove('active'));

document.getElementById('reset-all-custom-btn').addEventListener('click', async () => {
    await storageDB.clearAll();
    customization = { mode: 'cats', unifiedSonPhoto: null, individualPhotos: {}, correctSounds: {}, wrongSounds: {} };
    localStorage.setItem('meow_avatar_mode', 'cats');
    updateHeaderBranding();
    renderSettingsContent();
    if (gameScreen.classList.contains('active')) { renderBoard(); renderPalette(); }
});

menuBtn.addEventListener('click', () => {
    clearInterval(currentState.timerInterval);
    gameScreen.classList.remove('active');
    levelScreen.classList.add('active');
    menuBtn.style.display = 'none';
    renderLevelSelect();
});

soundBtn.addEventListener('click', () => {
    sound.enabled = !sound.enabled;
    soundBtn.textContent = sound.enabled ? '🔊' : '🔇';
});

document.getElementById('next-level-btn').addEventListener('click', () => {
    winModal.classList.remove('active');
    startLevel(currentState.level + 1);
});

document.getElementById('back-to-menu-btn').addEventListener('click', () => {
    winModal.classList.remove('active');
    menuBtn.click();
});

// بدء اللعبة بعد تحميل الإعدادات المحفوظة
loadCustomAssetsFromDB().then(() => {
    renderLevelSelect();
});
