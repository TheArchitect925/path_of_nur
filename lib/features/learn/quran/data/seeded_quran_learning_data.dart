import '../domain/quran_learning_models.dart';

const List<QuranLearningVerse> seededQuranLearningVerses = [
  QuranLearningVerse(
    id: 'q_1_5',
    surah: 1,
    ayah: 5,
    arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    translation: 'You alone we worship, and You alone we ask for help.',
    explanation:
        'This verse anchors worship, dependence, and sincerity in every act of devotion.',
    lessons: [
      'Worship is directed to Allah alone.',
      'Seeking help is a form of worship and trust.',
      'Daily recitation renews intention.',
    ],
    relatedHadith: ['intentions_core', 'religion_sincerity'],
    reflectionPrompts: [
      'Where do I seek strength before turning to Allah?',
      'How can this verse reshape my daily intention?',
      'What does sincere dependence look like today?',
    ],
    pathIds: ['foundations_faith', 'stories_prophets'],
    themeTag: 'faith',
  ),
  QuranLearningVerse(
    id: 'q_2_153',
    surah: 2,
    ayah: 153,
    arabicText:
        'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
    translation: 'O you who believe, seek help through patience and prayer.',
    explanation:
        'Allah links resilience and salah as practical supports during hardship.',
    lessons: [
      'Patience is active endurance, not passivity.',
      'Prayer is spiritual strength in trial.',
      'Faith responds to hardship with worship.',
    ],
    relatedHadith: ['patience_first_strike', 'closest_in_sujud'],
    reflectionPrompts: [
      'How do I respond first when stress rises?',
      'Can I turn one worry into dua after salah?',
      'What patient action is needed this week?',
    ],
    pathIds: ['character_quran', 'hereafter'],
    themeTag: 'patience',
  ),
  QuranLearningVerse(
    id: 'q_16_90',
    surah: 16,
    ayah: 90,
    arabicText:
        'إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَى',
    translation:
        'Indeed, Allah commands justice, excellence, and giving to relatives.',
    explanation:
        'A foundational verse for personal ethics, social justice, and community responsibility.',
    lessons: [
      'Justice is a command, not an option.',
      'Excellence goes beyond minimum fairness.',
      'Family rights are part of worship ethics.',
    ],
    relatedHadith: ['trust_honesty', 'help_brother_oppressor_oppressed'],
    reflectionPrompts: [
      'Where do I need to be more fair in daily dealings?',
      'How can I add ihsan to one regular task?',
      'Which relative needs my support this week?',
    ],
    pathIds: ['character_quran', 'signs_creation'],
    themeTag: 'justice',
  ),
  QuranLearningVerse(
    id: 'q_29_45',
    surah: 29,
    ayah: 45,
    arabicText: 'إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ',
    translation: 'Indeed, prayer restrains from indecency and wrongdoing.',
    explanation:
        'Salah is not only ritual form; it should transform choices and character.',
    lessons: [
      'Consistent prayer should shape conduct.',
      'Worship and ethics are inseparable.',
      'Inner attentiveness strengthens behavior.',
    ],
    relatedHadith: ['pray_as_you_have_seen_me', 'first_account_prayer'],
    reflectionPrompts: [
      'How has prayer changed one of my habits?',
      'What blocks deeper khushu in salah?',
      'What one behavior should I reform through prayer?',
    ],
    pathIds: ['foundations_faith', 'character_quran'],
    themeTag: 'prayer',
  ),
  QuranLearningVerse(
    id: 'q_39_53',
    surah: 39,
    ayah: 53,
    arabicText:
        'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا ... لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ',
    translation: 'Do not despair of the mercy of Allah.',
    explanation:
        'A central Qur\'anic call to hope, repentance, and return after sin.',
    lessons: [
      'Despair is not the believer\'s path.',
      'Repentance remains open while life remains.',
      'Mercy calls for renewed obedience.',
    ],
    relatedHadith: ['repentance_joy', 'every_son_of_adam_sins'],
    reflectionPrompts: [
      'Where do I need to renew hope in Allah?',
      'What sincere step of tawbah can I take tonight?',
      'How can mercy lead to practical reform?',
    ],
    pathIds: ['foundations_faith', 'hereafter'],
    themeTag: 'repentance',
  ),
  QuranLearningVerse(
    id: 'q_67_2',
    surah: 67,
    ayah: 2,
    arabicText:
        'الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا',
    translation:
        'He created death and life to test which of you is best in deeds.',
    explanation:
        'Life is a purposeful test measured by quality of deeds and sincerity.',
    lessons: [
      'Life and death are purposeful signs.',
      'Allah values best deeds, not only many deeds.',
      'Quality grows through sincerity and consistency.',
    ],
    relatedHadith: [
      'be_in_world_as_traveler',
      'intelligent_prepares_after_death',
    ],
    reflectionPrompts: [
      'What would make my deeds better in quality this week?',
      'How does this verse change my priorities?',
      'What is one deed I can improve with sincerity?',
    ],
    pathIds: ['hereafter', 'signs_creation'],
    themeTag: 'purpose',
  ),
];

const List<QuranLearningPath> seededQuranLearningPaths = [
  QuranLearningPath(
    id: 'foundations_faith',
    title: 'Foundations of Faith',
    description:
        'Core verses for worship, trust, sincerity, and return to Allah.',
    verseIds: ['q_1_5', 'q_29_45', 'q_39_53'],
  ),
  QuranLearningPath(
    id: 'character_quran',
    title: 'Character in the Qur’an',
    description: 'Verses guiding justice, patience, and disciplined conduct.',
    verseIds: ['q_2_153', 'q_16_90', 'q_29_45'],
  ),
  QuranLearningPath(
    id: 'stories_prophets',
    title: 'Stories of the Prophets',
    description:
        'Verses connected to prophetic calls and recurring guidance themes.',
    verseIds: ['q_1_5', 'q_39_53', 'q_67_2'],
  ),
  QuranLearningPath(
    id: 'hereafter',
    title: 'The Hereafter',
    description:
        'Verses nurturing accountability, hope, and preparation for return.',
    verseIds: ['q_39_53', 'q_67_2', 'q_2_153'],
  ),
  QuranLearningPath(
    id: 'signs_creation',
    title: 'Signs in Creation',
    description:
        'Verses reflecting on purpose, justice, and divine wisdom in life.',
    verseIds: ['q_16_90', 'q_67_2'],
  ),
];
