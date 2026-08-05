import '../domain/quran_content_refs.dart';
import '../domain/quran_readiness_bridge_models.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';

const _kidsTajweedJourneyTarget = ArabicLearningRouteTarget(
  kind: ArabicLearningRouteTargetKind.goNamed,
  contentType: ArabicLearningContinuationContentType.lesson,
  canonicalItemId: 'tajweed-basics:tajweed-application',
  routeName: 'learnJourneyStage',
  pathParameters: <String, String>{
    'journeyId': 'tajweed-basics',
    'stageId': 'tajweed-application',
  },
);

const _adultLongVowelsTarget = ArabicLearningRouteTarget(
  kind: ArabicLearningRouteTargetKind.adultLesson,
  contentType: ArabicLearningContinuationContentType.lesson,
  canonicalItemId: 'long_vowels_intro',
  moduleId: 'foundations',
  lessonId: 'long_vowels_intro',
);

const _adultQalqalahTarget = ArabicLearningRouteTarget(
  kind: ArabicLearningRouteTargetKind.adultLesson,
  contentType: ArabicLearningContinuationContentType.lesson,
  canonicalItemId: 'qalqalah_intro',
  moduleId: 'tajweed_basics',
  lessonId: 'qalqalah_intro',
);

const quranReadinessBridgeSeeds = <QuranReadinessBridgeSeed>[
  QuranReadinessBridgeSeed(
    id: 'bismillah_bridge',
    order: 1,
    level: QuranReadinessBridgeLevel.firstRecognition,
    ref: QuranQuoteRef(surah: 1, ayah: 1),
    snippetArabic: 'بِسْمِ اللَّهِ',
    transliteration: 'bismillah',
    simpleMeaning: 'In the name of Allah',
    sharedPhraseId: 'bismillah',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/bismillah.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'bismillah_clear',
        type: QuranReadinessPronunciationHintType.clear,
        focusArabic: 'بِسْمِ',
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'alhamdulillah_bridge',
    order: 2,
    level: QuranReadinessBridgeLevel.firstRecognition,
    ref: QuranQuoteRef(surah: 1, ayah: 2),
    snippetArabic: 'الْحَمْدُ لِلّٰهِ',
    transliteration: 'alhamdulillah',
    simpleMeaning: 'All praise is for Allah',
    sharedPhraseId: 'alhamdulillah',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/alhamdulillah.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'alhamdulillah_clear',
        type: QuranReadinessPronunciationHintType.clear,
        focusArabic: 'الْحَمْدُ',
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'rabbil_alamin_bridge',
    order: 3,
    level: QuranReadinessBridgeLevel.firstRecognition,
    ref: QuranQuoteRef(surah: 1, ayah: 2),
    snippetArabic: 'رَبِّ الْعَالَمِينَ',
    transliteration: 'rabbil alamin',
    simpleMeaning: 'Lord of the worlds',
    sharedPhraseId: 'rabbil-alamin',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/rabbil_alamin.mp3',
    familiarWordIds: <String>['rabb'],
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'rabbil_alamin_stretch',
        type: QuranReadinessPronunciationHintType.stretch,
        focusArabic: 'عَا',
        adultTarget: _adultLongVowelsTarget,
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'maliki_yawm_id_deen_bridge',
    order: 4,
    level: QuranReadinessBridgeLevel.familiarPhrases,
    ref: QuranQuoteRef(surah: 1, ayah: 4),
    snippetArabic: 'مَالِكِ يَوْمِ الدِّينِ',
    transliteration: 'maliki yawm id-deen',
    simpleMeaning: 'Master of the Day of Judgment',
    audioAssetPath:
        'assets/audio/quran_teacher/phrases/maliki_yawm_id_deen.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'maliki_stretch',
        type: QuranReadinessPronunciationHintType.stretch,
        focusArabic: 'مَا',
        adultTarget: _adultLongVowelsTarget,
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'iyyaka_nabudu_bridge',
    order: 5,
    level: QuranReadinessBridgeLevel.familiarPhrases,
    ref: QuranQuoteRef(surah: 1, ayah: 5),
    snippetArabic: 'إِيَّاكَ نَعْبُدُ',
    transliteration: 'iyyaka nabudu',
    simpleMeaning: 'You alone we worship',
    sharedPhraseId: 'iyyaka-nabudu',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/iyyaka_nabud.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'iyyaka_stretch',
        type: QuranReadinessPronunciationHintType.stretch,
        focusArabic: 'إِيَّا',
        adultTarget: _adultLongVowelsTarget,
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'ihdina_sirat_bridge',
    order: 6,
    level: QuranReadinessBridgeLevel.familiarPhrases,
    ref: QuranQuoteRef(surah: 1, ayah: 6),
    snippetArabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    transliteration: 'ihdina s-sirata l-mustaqim',
    simpleMeaning: 'Guide us to the straight path',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/ihdina_sirat.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'ihdina_stretch',
        type: QuranReadinessPronunciationHintType.stretch,
        focusArabic: 'نَا',
        adultTarget: _adultLongVowelsTarget,
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'qul_huwa_allahu_ahad_bridge',
    order: 7,
    level: QuranReadinessBridgeLevel.ayahConfidence,
    ref: QuranQuoteRef(surah: 112, ayah: 1),
    snippetArabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
    transliteration: 'qul huwa Allahu ahad',
    simpleMeaning: 'Say: He is Allah, One',
    audioAssetPath:
        'assets/audio/quran_teacher/phrases/qul_huwa_allahu_ahad.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'ahad_qalqalah',
        type: QuranReadinessPronunciationHintType.bounce,
        focusArabic: 'أَحَدٌ',
        adultTarget: _adultQalqalahTarget,
        kidsTarget: _kidsTajweedJourneyTarget,
      ),
    ],
  ),
  QuranReadinessBridgeSeed(
    id: 'allahu_samad_bridge',
    order: 8,
    level: QuranReadinessBridgeLevel.ayahConfidence,
    ref: QuranQuoteRef(surah: 112, ayah: 2),
    snippetArabic: 'اللَّهُ الصَّمَدُ',
    transliteration: 'Allahu s-samad',
    simpleMeaning: 'Allah, the Eternal Refuge',
    audioAssetPath: 'assets/audio/quran_teacher/phrases/allahu_samad.mp3',
    hints: <QuranReadinessPronunciationHintSeed>[
      QuranReadinessPronunciationHintSeed(
        id: 'samad_clear',
        type: QuranReadinessPronunciationHintType.clear,
        focusArabic: 'الصَّ',
      ),
    ],
  ),
];
