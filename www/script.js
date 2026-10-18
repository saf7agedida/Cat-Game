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
