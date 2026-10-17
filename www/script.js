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
