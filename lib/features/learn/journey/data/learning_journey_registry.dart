import 'package:flutter/material.dart';

import '../../../../shared/theme/islamic_icons.dart';
import '../domain/learning_journey_models.dart';

class LearningJourneyRegistry {
  static final bool _validated = _validate();

  static const islands = <LearningJourneyIsland>[
    LearningJourneyIsland(
      id: 'core-knowledge',
      title: 'Core Knowledge',
      subtitle: 'Qur’an, Prophets, Seerah, and Hadith.',
      description:
          'Everything begins with knowing Allah. Build the foundation of your faith here.',
      order: 1,
      icon: IslamicIcons.quran,
      color: Color(0xFFECE5D7),
      accentColor: Color(0xFF6F5A3E),
    ),
    LearningJourneyIsland(
      id: 'practice-worship',
      title: 'Practice & Ibadah',
      subtitle: 'Salah, Dhikr, and Duas for daily life.',
      description:
          'Learn the acts of ibadah that shape daily rhythm, remembrance, and presence.',
      order: 2,
      icon: IslamicIcons.prayer,
      color: Color(0xFFE3EAD8),
      accentColor: Color(0xFF586C45),
    ),
    LearningJourneyIsland(
      id: 'understanding-islam',
      title: 'Understanding Islam',
      subtitle: 'Faith, fiqh, and the larger historical frame.',
      description:
          'Understand the essentials of belief, practice, and historical development with clarity.',
      order: 3,
      icon: IslamicIcons.mosque,
      color: Color(0xFFF0E4D8),
      accentColor: Color(0xFF835E42),
    ),
    LearningJourneyIsland(
      id: 'arabic-learning',
      title: 'Arabic Learning',
      subtitle: 'Alphabet, reading, words, and tajweed basics.',
      description:
          'Grow from letter recognition toward meaning, recitation, and confident repetition.',
      order: 4,
      icon: IslamicIcons.lantern,
      color: Color(0xFFE2E6F2),
      accentColor: Color(0xFF4F5D88),
    ),
    LearningJourneyIsland(
      id: 'discovery',
      title: 'Discovery',
      subtitle: 'Trivia, daily wisdom, stories, and reflective exploration.',
      description:
          'Explore lighter entry points that still lead into real understanding and reflection.',
      order: 5,
      icon: IslamicIcons.ninetyNine,
      color: Color(0xFFE9E0EB),
      accentColor: Color(0xFF755C7C),
    ),
    LearningJourneyIsland(
      id: 'kids-learning',
      title: 'Kids Learning',
      subtitle:
          'Stories, habits, memorization, and guided learning for children.',
      description:
          'Keep children’s learning in one dedicated island so future kids journeys, tools, and activities have a clear home.',
      order: 6,
      icon: IslamicIcons.family,
      color: Color(0xFFFFE9CC),
      accentColor: Color(0xFF9A6233),
      relatedTools: [_kidsArabicLettersTool, _kidsDuaLearningTool],
    ),
    LearningJourneyIsland(
      id: 'browse-all',
      title: 'Browse All',
      subtitle:
          'See the wider map of journeys, tools, collections, and exploration.',
      description:
          'Use one island as the front door to the full learning map when you want everything available in one place.',
      order: 7,
      icon: IslamicIcons.community,
      color: Color(0xFFE4E7F5),
      accentColor: Color(0xFF4E5B8C),
      relatedTools: [_browseAllLearningTool],
    ),
    LearningJourneyIsland(
      id: 'tools-other',
      title: 'Tools & Other',
      subtitle: 'Utilities, family tools, and supporting learning spaces.',
      description:
          'Keep non-journey utilities and supporting spaces in one dedicated island instead of scattering them across the legacy learning hub.',
      order: 8,
      icon: IslamicIcons.locationMosque,
      color: Color(0xFFE6EEF1),
      accentColor: Color(0xFF45636D),
      relatedTools: [_babyNamesTool],
    ),
    LearningJourneyIsland(
      id: 'legacy-learning',
      title: 'Legacy Learning',
      subtitle:
          'Older learning surfaces and migrated sections that still remain in use.',
      description:
          'Keep the legacy learning library in one explicit island while the newer journey structure continues to absorb and replace it over time.',
      order: 9,
      icon: IslamicIcons.kaaba,
      color: Color(0xFFF2E7DB),
      accentColor: Color(0xFF7D5E43),
      relatedTools: [_legacyLearningIslandTool],
    ),
  ];

  static const journeys = <LearningJourney>[
    LearningJourney(
      id: 'islam-foundations',
      islandId: 'core-knowledge',
      title: 'What Is Islam?',
      subtitle: 'A calm first path through Islam, belief, and the pillars.',
      description:
          'Start with the meaning of Islam, who Allah is, the five pillars, and the first steady steps of Muslim life.',
      order: 1,
      stageIds: [
        'islam-what-is-islam',
        'islam-who-is-allah',
        'islam-five-pillars',
        'islam-first-steps',
        'islam-foundations-completion',
      ],
      learningOutcomes: [
        'Understand Islam as surrender, worship, and mercy',
        'See the five pillars as a lived structure rather than a list',
        'Leave with a calm first plan for daily Muslim life',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 35,
      tags: ['islam', 'foundations', 'who is allah', 'pillars', 'beginner'],
      isFeatured: true,
      whyThisMatters:
          'Beginners need one clear first path before they are exposed to the rest of the learning library.',
      relatedTools: [_quranReaderTool, _learnSalahHubTool, _hadithLandingTool],
      mappingNotes:
          'This journey acts as the beginner front door for belief and pillars, then hands learners into salah, Qur’an, and character journeys.',
    ),
    LearningJourney(
      id: 'journey-quran',
      islandId: 'core-knowledge',
      title: 'Journey of the Qur’an',
      subtitle: 'Open the Book, navigate it, and build a first relationship.',
      description:
          'Start with the Qur’an as a living source of guidance through reading, structure, themes, and practical next steps.',
      order: 2,
      stageIds: [
        'quran-open',
        'quran-read',
        'quran-themes',
        'quran-next-steps',
      ],
      learningOutcomes: [
        'Understand how to approach the Qur’an as guidance',
        'Build a first reading rhythm from clear entry points',
        'Use themes, notes, and tools as support rather than distraction',
      ],
      whyThisMatters:
          'A stable relationship with the Qur’an gives the rest of the learning journey its center.',
      relatedTools: [
        _quranReaderTool,
        _quranSearchTool,
        _quranBookmarksTool,
        _quranNotesTool,
      ],
      mappingNotes:
          'This journey now leads the Qur’an experience directly, while reader, notes, bookmarks, and word tools stay secondary.',
    ),
    LearningJourney(
      id: 'understanding-al-fatihah',
      islandId: 'core-knowledge',
      title: 'Understanding Al-Fatihah',
      subtitle: 'Begin with the surah you recite every day.',
      description:
          'Study Al-Fatihah verse by verse as the opening of the Qur’an and the heart of daily salah.',
      order: 3,
      stageIds: [
        'fatihah-read',
        'fatihah-recitation',
        'fatihah-reflection',
        'fatihah-completion',
      ],
      learningOutcomes: [
        'Follow Al-Fatihah verse by verse',
        'Connect its words to daily salah',
        'Leave with a reflective understanding of its central themes',
      ],
      whyThisMatters:
          'Al-Fatihah is recited every day, so understanding it raises the meaning of salah immediately.',
      relatedTools: [_quranReaderTool, _learnSalahHubTool, _quranNotesTool],
      mappingNotes:
          'This is now one of the strongest guided Qur’an journeys and acts as the primary bridge between Qur’an and salah.',
    ),
    LearningJourney(
      id: 'short-surahs',
      islandId: 'core-knowledge',
      title: 'Short Surahs Journey',
      subtitle: 'Build familiarity with the short surahs used often in prayer.',
      description:
          'Use short surahs as an early bridge between recitation, prayer, context, and practical meaning.',
      order: 4,
      stageIds: [
        'short-surahs-ikhlas',
        'short-surahs-falaq',
        'short-surahs-nas',
        'short-surahs-kafirun',
        'short-surahs-kawthar',
        'short-surahs-completion',
      ],
      learningOutcomes: [
        'Learn the short surahs used often in prayer with context',
        'Notice key themes and simple takeaways from each surah',
        'Connect memorized recitation to practical reflection',
      ],
      whyThisMatters:
          'Short surahs are the easiest place to connect memorization, recitation, and meaning.',
      relatedTools: [
        _quranExplorerTool,
        _learnSalahHubTool,
        _quranLearningHubTool,
      ],
      mappingNotes:
          'This journey now treats the short surahs as the primary guided path, with Qur’an tools and salah tools acting as reinforcement.',
    ),
    LearningJourney(
      id: 'prophets-journey',
      islandId: 'core-knowledge',
      title: 'The Prophets Journey',
      subtitle: 'Walk through prophetic lives, eras, and revealed lessons.',
      description:
          'Move through the stories of the Prophets in a guided order and connect them to themes and review.',
      order: 5,
      stageIds: ['prophets-overview', 'prophets-journey-map', 'prophets-quiz'],
      learningOutcomes: [
        'Follow prophetic lives in a guided order',
        'Connect story, chronology, and region',
        'Reinforce learning with quiz review',
      ],
      whyThisMatters:
          'The Prophets are one of the clearest ways to build Islamic understanding through narrative and example.',
      relatedTools: [
        _prophetsTool,
        _prophetsTimelineTool,
        _prophetsMapTool,
        _prophetsFamilyTreeTool,
      ],
      mappingNotes:
          'All stages map to real Prophets surfaces through existing-page adapters rather than risky route indirection.',
    ),
    LearningJourney(
      id: 'seerah-journey',
      islandId: 'core-knowledge',
      title: 'Seerah Journey',
      subtitle: 'A guided path through the life of the Prophet ﷺ.',
      description:
          'Follow the life of the Prophet ﷺ through a simple beginner path from early life to the final sermon.',
      order: 6,
      stageIds: [
        'seerah-early-life',
        'seerah-first-revelation',
        'seerah-makkah-period',
        'seerah-hijrah',
        'seerah-madinah-society',
        'seerah-leadership-character',
        'seerah-final-sermon',
      ],
      learningOutcomes: [
        'Follow the major moments of the Seerah in order',
        'Understand the turning points of prophethood and community building',
        'Connect the life of the Prophet ﷺ to character, worship, and leadership',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 45,
      tags: ['seerah', 'prophet muhammad', 'messenger', 'madinah', 'makkah'],
      isFeatured: true,
      whyThisMatters:
          'Seerah gives emotional and historical context to Qur’an, Hadith, and Muslim life.',
      relatedTools: [_seerahCompanionTool, _prophetsTool, _hadithLandingTool],
      mappingNotes:
          'These stages now open real in-app Seerah lessons while still pointing users toward the existing Prophets and Hadith systems for adjacent exploration.',
    ),
    LearningJourney(
      id: 'hadith-essentials',
      islandId: 'core-knowledge',
      title: 'Hadith Essentials',
      subtitle:
          'Start with the most foundational hadith collections and themes.',
      description:
          'Use a calm beginner path that explains what hadith is, how to start, and how review strengthens understanding.',
      order: 7,
      stageIds: [
        'hadith-essential-collection',
        'hadith-themes',
        'hadith-review',
      ],
      learningOutcomes: [
        'Understand why hadith matters in daily Muslim life',
        'Start with foundational collections and themes',
        'Use review as reinforcement instead of random browsing',
      ],
      whyThisMatters:
          'Hadith grounds everyday practice, character, and understanding of prophetic guidance.',
      relatedTools: [
        _hadithLandingTool,
        _hadithImportantTool,
        _hadithReviewTool,
      ],
      mappingNotes:
          'Stages now use lesson-backed wrappers so the Hadith tools feel guided rather than menu-like.',
    ),
    LearningJourney(
      id: 'salah-foundations',
      islandId: 'practice-worship',
      title: 'Salah Foundations',
      subtitle: 'Build confidence in the structure and flow of prayer.',
      description:
          'Learn why salah matters, how to prepare for it, and how its words and movements work together.',
      order: 1,
      stageIds: [
        'salah-hub',
        'salah-guided-fajr',
        'salah-detail-fajr',
        'salah-words-meaning',
        'salah-khushu-consistency',
        'salah-completion',
      ],
      learningOutcomes: [
        'Understand why salah is central to a Muslim day',
        'Prepare for prayer with wudu, intention, and calm',
        'Connect movements, words, meaning, and consistency',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 40,
      tags: ['salah', 'prayer', 'worship', 'daily worship', 'beginner'],
      isFeatured: true,
      whyThisMatters:
          'Salah is a daily pillar, so even a small increase in clarity changes lived practice quickly.',
      relatedTools: [_learnSalahHubTool, _guidedPrayerTool, _wuduGuideTool],
      mappingNotes:
          'Stages now use lesson wrappers that hand learners into the existing salah trainer, guided prayer, and wudu tools with clearer framing.',
    ),
    LearningJourney(
      id: 'journey-of-wudu',
      islandId: 'practice-worship',
      title: 'Journey of Wudu',
      subtitle:
          'Learn the sequence, sunnah elements, and practice flow of wudu.',
      description:
          'Move from understanding wudu to practicing it, checking what breaks it, and avoiding common mistakes.',
      order: 2,
      stageIds: [
        'wudu-guide',
        'wudu-trainer',
        'wudu-what-breaks',
        'wudu-common-mistakes',
        'wudu-completion',
      ],
      learningOutcomes: [
        'Understand why wudu matters before prayer',
        'Practice the sequence with confidence',
        'Recognize what breaks wudu and how to self-check calmly',
      ],
      whyThisMatters:
          'Wudu is the daily gate into salah, so clarity here removes friction from worship.',
      relatedTools: [_wuduGuideTool, _wuduTrainerTool, _learnSalahHubTool],
      mappingNotes:
          'This journey now teaches learn, practice, and self-check as a sequence instead of dropping users straight into broad utility surfaces.',
    ),
    LearningJourney(
      id: 'daily-dhikr',
      islandId: 'practice-worship',
      title: 'Daily Dhikr Journey',
      subtitle: 'Morning and evening remembrance in a calm habit loop.',
      description:
          'Learn a simple remembrance path that begins with understanding and grows into a light daily routine.',
      order: 3,
      stageIds: [
        'dhikr-what-is',
        'dhikr-morning-adhkar',
        'dhikr-evening-adhkar',
        'dhikr-after-salah',
        'dhikr-simple-routine',
        'dhikr-istighfar',
        'dhikr-salawat',
      ],
      learningOutcomes: [
        'Understand what dhikr is and why it matters',
        'Build morning, evening, and after-salah habits',
        'Use istighfar and salawat naturally in daily life',
      ],
      whyThisMatters:
          'Dhikr is one of the gentlest ways to keep the heart alive, but beginners need a simple guided path rather than utilities alone.',
      relatedTools: [_dhikrCounterTool],
      mappingNotes:
          'These stages now open real lesson content, while the Ibadah dhikr utility remains available as a supporting tool rather than the lesson itself.',
    ),
    LearningJourney(
      id: 'daily-routines',
      islandId: 'practice-worship',
      title: 'Daily Routines',
      subtitle: 'A gentle rhythm for prayer, Qur’an, dhikr, and steadiness.',
      description:
          'Build a realistic daily Muslim routine that begins small, anchors itself to salah, and stays sustainable.',
      order: 4,
      stageIds: [
        'daily-routines-start-day',
        'daily-routines-prayer-anchor',
        'daily-routines-quran-anchor',
        'daily-routines-evening-reset',
        'daily-routines-habit-building',
        'daily-routines-completion',
      ],
      learningOutcomes: [
        'Create a simple daily worship rhythm without overwhelm',
        'Use salah as the anchor for Qur’an, dhikr, and duas',
        'Build habits through small, repeatable actions',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 30,
      tags: ['daily worship', 'routine', 'quran', 'dhikr', 'duas'],
      isFeatured: true,
      whyThisMatters:
          'Many users do not need more information first. They need a realistic structure they can actually live.',
      relatedTools: [_learnSalahHubTool, _duaHubTool, _quranReaderTool],
      mappingNotes:
          'This journey connects worship systems into one daily rhythm and supports path-based progression for practicing and advanced users.',
    ),
    LearningJourney(
      id: 'duas-daily-life',
      islandId: 'practice-worship',
      title: 'Duas for Daily Life',
      subtitle: 'Build a working set of duas you actually use.',
      description:
          'Move through a curated set of verified daily duas organized by real-life moments.',
      order: 5,
      stageIds: [
        'duas-waking-up',
        'duas-sleeping',
        'duas-eating',
        'duas-leaving-home',
        'duas-entering-masjid',
        'duas-travel',
        'duas-distress',
        'duas-gratitude',
      ],
      learningOutcomes: [
        'Memorize a small set of common daily duas',
        'Understand what each dua means and when to use it',
        'Keep journey stages limited to complete and verified entries',
      ],
      whyThisMatters:
          'Dua becomes easier to live when it is organized by actual daily need and repetition.',
      relatedTools: [_duaHubTool],
      mappingNotes:
          'These stages now use curated verified duas and keep the broader Dua Hub available for continued exploration.',
    ),
    LearningJourney(
      id: 'ramadan-foundations',
      islandId: 'practice-worship',
      title: 'Ramadan Foundations',
      subtitle: 'A staged preparation path for fasting and Ramadan worship.',
      description:
          'Move through a simple beginner path that explains fasting, daily rhythm, spiritual goals, and common mistakes in Ramadan.',
      order: 6,
      stageIds: [
        'ramadan-intention',
        'ramadan-why-fast',
        'ramadan-daily-rhythm',
        'ramadan-what-breaks-fast',
        'ramadan-laylat-al-qadr',
        'ramadan-reflection',
        'ramadan-common-mistakes',
      ],
      learningOutcomes: [
        'Understand what Ramadan is and why Muslims fast',
        'Build a practical rhythm from suhoor to iftar',
        'Carry Ramadan with reflection, care, and spiritual goals',
      ],
      whyThisMatters:
          'Ramadan is high impact and time-bound, so it benefits from a dedicated guided preparation path.',
      relatedTools: [_legacyLearnTool, _duaHubTool],
      mappingNotes:
          'Ramadan Foundations is now lesson-backed and points into existing dua and dhikr-adjacent practice surfaces where helpful.',
    ),
    LearningJourney(
      id: 'foundations-of-faith',
      islandId: 'understanding-islam',
      title: 'Foundations of Faith',
      subtitle: 'A structured path through the essentials of belief.',
      description:
          'Study the essentials of faith in a calm beginner sequence with simple language and clear guardrails.',
      order: 1,
      stageIds: [
        'faith-who-is-allah',
        'faith-tawheed',
        'faith-names-of-allah-intro',
        'faith-angels',
        'faith-books',
        'faith-prophets',
        'faith-day-of-judgment',
        'faith-qadr',
        'faith-completion',
      ],
      learningOutcomes: [
        'Understand the core beliefs every Muslim should know',
        'Build a reverent and non-speculative frame for aqeedah',
        'Connect belief to worship, conduct, and hope in Allah',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 50,
      tags: ['aqeedah', 'who is allah', 'names of allah', 'faith', 'belief'],
      isFeatured: true,
      whyThisMatters:
          'Belief gives coherence to all other learning, but it needs careful ownership and clear guardrails.',
      relatedTools: [_namesOfAllahTool, _prophetsTool],
      mappingNotes:
          'These stages now form a fuller beginner aqeedah path with simple explanations, practical reflection, and a clear closing step.',
    ),
    LearningJourney(
      id: 'fiqh-basics',
      islandId: 'understanding-islam',
      title: 'Fiqh Basics',
      subtitle:
          'Begin with the practical language of lawful worship and daily action.',
      description:
          'Study practical fiqh through clear first principles, simple scenarios, and daily examples instead of heavy debate.',
      order: 2,
      stageIds: [
        'fiqh-halal-haram',
        'fiqh-cleanliness',
        'fiqh-prayer-basics',
        'fiqh-fasting-basics',
        'fiqh-zakat-basics',
        'fiqh-daily-life',
        'fiqh-completion',
      ],
      learningOutcomes: [
        'Understand practical lawful and unlawful boundaries',
        'Apply basic fiqh to worship and daily decisions',
        'Gain confidence through simple scenarios instead of abstract terms',
      ],
      whyThisMatters:
          'Fiqh helps users move from uncertainty to practical confidence, but needs careful curation.',
      relatedTools: [_wuduGuideTool, _learnSalahHubTool],
      mappingNotes:
          'Fiqh Basics is now lesson-backed and intentionally practical, with simple examples instead of legal-detail overload.',
    ),
    LearningJourney(
      id: 'timeline-of-islam',
      islandId: 'understanding-islam',
      title: 'Timeline of Islam',
      subtitle: 'Place key events and eras into one understandable sequence.',
      description:
          'Follow the broad history of Islam through connected stages that show how one era leads into the next.',
      order: 3,
      stageIds: [
        'timeline-early-prophets',
        'timeline-prophet-era',
        'timeline-khulafa',
        'timeline-expansion',
        'timeline-golden-age',
        'timeline-modern-context',
        'timeline-completion',
      ],
      learningOutcomes: [
        'Build a simple mental map of Islamic history',
        'See how one era leads into the next',
        'Understand broad historical continuity without overload',
      ],
      whyThisMatters:
          'Timeline context stops knowledge from feeling fragmented and isolated.',
      relatedTools: [_prophetsTimelineTool, _historyArchiveTool],
      mappingNotes:
          'The timeline now teaches broad historical sequence through guided lessons even though a dedicated visual timeline system does not yet exist.',
    ),
    LearningJourney(
      id: 'beautiful-character',
      islandId: 'understanding-islam',
      title: 'Beautiful Character',
      subtitle:
          'Grow through the qualities that beautify faith and daily life.',
      description:
          'Follow a guided journey through sincerity, patience, gratitude, humility, forgiveness, self-control, kindness, and final reflection.',
      order: 4,
      stageIds: [
        'character-ikhlas',
        'character-sabr',
        'character-shukr',
        'character-humility',
        'character-forgiveness',
        'character-anger',
        'character-kindness',
        'character-completion',
      ],
      learningOutcomes: [
        'Understand core qualities of beautiful Islamic character',
        'Connect character to worship, relationships, and daily choices',
        'Leave with one clear next step for personal growth',
      ],
      difficulty: LearningJourneyDifficulty.beginner,
      estimatedDurationMinutes: 45,
      tags: ['character', 'adab', 'sabr', 'shukr', 'ihsan'],
      isFeatured: true,
      whyThisMatters:
          'Knowledge becomes lived Islam when it shapes character, speech, reactions, and service to others.',
      relatedTools: [
        _hadithLandingTool,
        _prophetsTool,
        _characterCompanionTool,
      ],
      mappingNotes:
          'This journey is lesson-backed and cross-links to Hadith, Seerah, and Daily Wisdom so character formation feels integrated rather than isolated.',
    ),
    LearningJourney(
      id: 'arabic-alphabet',
      islandId: 'arabic-learning',
      title: 'Arabic Alphabet Journey',
      subtitle: 'Start with letters, sounds, and recognition.',
      description:
          'Learn the Arabic letters in calm groups, reinforce their sounds, and build a useful review habit before moving into reading.',
      order: 1,
      stageIds: [
        'alphabet-open',
        'alphabet-repeat',
        'alphabet-review',
        'alphabet-completion',
      ],
      learningOutcomes: [
        'Recognize the Arabic letters in manageable groups',
        'Improve pronunciation through repetition',
        'Build a review habit that prepares you for reading basics',
      ],
      whyThisMatters:
          'Letter confidence is the first real threshold into Qur’anic Arabic and reading.',
      relatedTools: [_quranArabicTool],
      mappingNotes:
          'The alphabet path now uses lesson-backed stages to make the handoff into Arabic tools and reading basics feel intentional and progressive.',
    ),
    LearningJourney(
      id: 'reading-basics',
      islandId: 'arabic-learning',
      title: 'Reading Basics',
      subtitle: 'Move from letters toward recitation and reading flow.',
      description:
          'Bridge the alphabet into harakat, joined letters, and calm reading checkpoints before wider recitation.',
      order: 2,
      stageIds: [
        'reading-basics-open',
        'reading-basics-kasra',
        'reading-basics-damma',
        'reading-basics-sukun',
        'reading-basics-shaddah',
        'reading-basics-practice',
        'reading-basics-checkpoint',
        'reading-basics-completion',
      ],
      learningOutcomes: [
        'Recognize the core reading marks and how they change sound',
        'Move from individual letters into joined reading',
        'Use review loops before advancing into wider recitation',
      ],
      whyThisMatters:
          'Users often need a middle layer between alphabet exposure and full recitation.',
      relatedTools: [_quranArabicTool, _quranLearningHubTool],
      mappingNotes:
          'Reading Basics is now a fuller bridge from letters to reading and clearly points forward into understanding what is recited.',
    ),
    LearningJourney(
      id: '100-quranic-words',
      islandId: 'arabic-learning',
      title: '100 Qur’anic Words',
      subtitle: 'Build recognition of recurring vocabulary in the Qur’an.',
      description:
          'Use existing top-words and review tools as the backbone of a staged word journey.',
      order: 3,
      stageIds: ['words-top', 'words-review', 'words-patterns'],
      learningOutcomes: [
        'Recognize recurring Qur’anic vocabulary',
        'Review and retain key words',
        'See simple meaning and pattern groupings',
      ],
      whyThisMatters:
          'Recurring vocabulary is one of the fastest ways to increase Qur’anic comprehension.',
      relatedTools: [_topWordsTool, _wordReviewTool],
      mappingNotes:
          'Top words and review are real, and the patterns stage now uses the current words surface as a partial bridge until curated grouping pedagogy is added.',
    ),
    LearningJourney(
      id: 'understand-what-you-recite',
      islandId: 'arabic-learning',
      title: 'Understand What You Recite',
      subtitle: 'Connect familiar recitation to meaning and structure.',
      description:
          'Start from prayer recitation and move gradually toward comprehension of what you repeat daily.',
      order: 4,
      stageIds: [
        'recite-fatihah',
        'recite-short-surahs',
        'recite-meaning',
        'recite-completion',
      ],
      learningOutcomes: [
        'Understand what you recite in Al-Fatihah',
        'Connect short surahs to prayer meaning',
        'Build comprehension through repetition',
      ],
      whyThisMatters:
          'Understanding familiar recitation often creates the fastest emotional payoff in learning.',
      relatedTools: [_quranReaderTool, _learnSalahHubTool, _quranNotesTool],
      mappingNotes:
          'This journey now sits between Arabic learning and worship so familiar phrases gain clearer meaning and usage.',
    ),
    LearningJourney(
      id: 'tajweed-basics',
      islandId: 'arabic-learning',
      title: 'Tajweed Basics',
      subtitle: 'A calm first path for careful Qur’an recitation.',
      description:
          'Begin with what tajweed is, how articulation shapes sound, and how to carry careful recitation back into short surahs.',
      order: 5,
      stageIds: ['tajweed-intro', 'tajweed-makharij', 'tajweed-application'],
      learningOutcomes: [
        'Understand what tajweed is and why it matters',
        'Notice core articulation differences between letters',
        'Practice one calm correction at a time in real recitation',
      ],
      whyThisMatters:
          'Tajweed becomes sustainable when beginners learn it through clear listening, measured practice, and real Qur’an recitation.',
      relatedTools: [_quranArabicTool, _quranLearningHubTool],
      mappingNotes:
          'This journey now uses lesson-backed stages so Tajweed can sit inside Learn as a real beginner path instead of a contained placeholder.',
    ),
    LearningJourney(
      id: 'trivia-knowledge-paths',
      islandId: 'discovery',
      title: 'Trivia Knowledge Paths',
      subtitle: 'Guided trivia paths that still teach in sequence.',
      description:
          'Use trivia as reinforcement with clear path selection, focused sessions, and guided follow-up into deeper journeys.',
      order: 1,
      stageIds: ['trivia-paths', 'trivia-session', 'trivia-review'],
      learningOutcomes: [
        'Choose a trivia path with a learning purpose',
        'Use short sessions as reinforcement rather than isolated play',
        'Return from review into related journeys for depth',
      ],
      whyThisMatters:
          'Trivia can become a low-friction entry point into structured knowledge when it is staged well.',
      relatedTools: [_triviaPathsTool, _triviaReviewTool],
      mappingNotes:
          'Trivia stages are now lesson-backed so the quiz system feels connected to the wider learning graph.',
    ),
    LearningJourney(
      id: 'daily-wisdom',
      islandId: 'discovery',
      title: 'Daily Wisdom',
      subtitle: 'Short learning moments that can become a daily rhythm.',
      description:
          'Gather one daily item from Qur’an, Hadith, Prophets, reflection, or dhikr into one steady and uncluttered rhythm.',
      order: 2,
      stageIds: [
        'wisdom-daily-quote',
        'wisdom-short-lesson',
        'wisdom-practice',
      ],
      learningOutcomes: [
        'Receive a short daily wisdom prompt',
        'Turn a brief lesson into action',
        'Build a daily rhythm of reflection',
      ],
      whyThisMatters:
          'Short daily wisdom can keep the learning system alive between deeper sessions.',
      relatedTools: [
        _dailyWisdomCompanionTool,
        _hadithLandingTool,
        _quranReaderTool,
        _prophetsTool,
      ],
      mappingNotes:
          'This journey now serves as the unified daily layer so one item can lead cleanly into deeper journeys without duplication.',
    ),
    LearningJourney(
      id: 'stories-signs',
      islandId: 'discovery',
      title: 'Stories & Signs',
      subtitle: 'Follow signs in creation and narratives in revelation.',
      description:
          'Move through signs in creation in a reflective sequence that links the world back to Qur’anic remembrance and wonder.',
      order: 3,
      stageIds: [
        'stories-sky-stars',
        'stories-ocean',
        'stories-mountains',
        'stories-animals',
        'stories-human-creation',
        'stories-day-night',
        'stories-completion',
      ],
      learningOutcomes: [
        'See Qur’anic signs in creation with clarity',
        'Reflect on what those signs mean for the heart and daily life',
        'Use wonder as a doorway into deeper knowledge and gratitude',
      ],
      whyThisMatters:
          'Stories and signs are often the gentlest bridge into deeper belief and reflection.',
      relatedTools: [
        _worldLandingTool,
        _worldExploreCreationTool,
        _worldSignsTool,
        _prophetsTool,
      ],
      mappingNotes:
          'This journey now leans into reflective lesson-backed stages while still exposing the world-and-creation tools as secondary exploration.',
    ),
    LearningJourney(
      id: 'reflection-mode',
      islandId: 'discovery',
      title: 'Reflection Mode',
      subtitle: 'Move from intake toward notes, reflection, and review.',
      description:
          'A softer journey for pausing, writing, and revisiting what you have already learned.',
      order: 4,
      stageIds: [
        'reflection-creation',
        'reflection-notes',
        'reflection-constellation',
      ],
      learningOutcomes: [
        'Open reflection-first content',
        'Write and revisit notes',
        'See knowledge relationships across domains',
      ],
      whyThisMatters:
          'Reflection turns scattered intake into retained insight and intentional practice.',
      relatedTools: [
        _reflectionModeTool,
        _learnNotesTool,
        _knowledgeConstellationTool,
      ],
      mappingNotes:
          'All stages map to real routes and form one of the stronger Discovery journeys.',
    ),
  ];

  static const stages = <LearningJourneyStage>[
    LearningJourneyStage(
      id: 'islam-what-is-islam',
      journeyId: 'islam-foundations',
      title: 'What is Islam?',
      summary:
          'Begin with the meaning of Islam as surrender to Allah, worship, and a complete way of life.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'islam-who-is-allah',
      journeyId: 'islam-foundations',
      title: 'Who is Allah?',
      summary:
          'Learn the first clear foundations of knowing Allah as Creator, Lord, and the One worthy of worship.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'islam-five-pillars',
      journeyId: 'islam-foundations',
      title: 'The five pillars',
      summary:
          'See the pillars as the practical structure that shapes a Muslim life day by day.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'islam-first-steps',
      journeyId: 'islam-foundations',
      title: 'Your first steps',
      summary:
          'Finish with a calm starting plan built around prayer, learning, and beautiful character.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'islam-foundations-completion',
      journeyId: 'islam-foundations',
      title: 'Carry Islam into daily life',
      summary:
          'Review what you have learned and choose the next steady journey in worship and connection.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'daily-routines-start-day',
      journeyId: 'daily-routines',
      title: 'Start your day with intention',
      summary:
          'Build a gentle opening rhythm that begins with intention, remembrance, and a realistic first step.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'daily-routines-prayer-anchor',
      journeyId: 'daily-routines',
      title: 'Let salah anchor the day',
      summary:
          'Use prayer times as the stable structure that keeps the rest of your routine from drifting.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'daily-routines-quran-anchor',
      journeyId: 'daily-routines',
      title: 'Keep a small Qur’an rhythm',
      summary:
          'Choose a manageable way to read, listen, or reflect on the Qur’an every day without pressure.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'daily-routines-evening-reset',
      journeyId: 'daily-routines',
      title: 'End the day with a reset',
      summary:
          'Use evening dhikr, duas, and reflection to close the day with calm rather than drift.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'daily-routines-habit-building',
      journeyId: 'daily-routines',
      title: 'Build habits that last',
      summary:
          'Learn how to stay consistent through small actions, gentle review, and patience with yourself.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'daily-routines-completion',
      journeyId: 'daily-routines',
      title: 'Carry your routine forward',
      summary:
          'Review your rhythm and choose the next journey that will deepen what you are already practicing.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'quran-open',
      journeyId: 'journey-quran',
      title: 'How to approach the Qur’an',
      summary:
          'Begin with a simple frame for reading the Qur’an as guidance, worship, and daily return.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranSearchTool],
    ),
    LearningJourneyStage(
      id: 'quran-read',
      journeyId: 'journey-quran',
      title: 'Begin reading with clarity',
      summary:
          'Start from Al-Fatihah and learn how to make a first reading rhythm feel realistic.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'quran-themes',
      journeyId: 'journey-quran',
      title: 'Themes, notes, and reflection',
      summary:
          'Use themes and simple note-taking to notice recurring guidance without losing the main path.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranBookmarksTool],
    ),
    LearningJourneyStage(
      id: 'quran-next-steps',
      journeyId: 'journey-quran',
      title: 'Carry the Qur’an forward',
      summary:
          'Finish by choosing your next Qur’an path and a simple way to keep the relationship alive.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool, _quranNotesTool],
    ),
    LearningJourneyStage(
      id: 'fatihah-read',
      journeyId: 'understanding-al-fatihah',
      title: 'Verses 1-2: Praise and Lordship',
      summary:
          'Begin with the opening praise of Allah and what it means to call Him the Lord of all worlds.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fatihah-recitation',
      journeyId: 'understanding-al-fatihah',
      title: 'Verses 3-5: Mercy, judgment, and worship',
      summary:
          'See how mercy, accountability, and exclusive worship sit at the center of Al-Fatihah.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fatihah-reflection',
      journeyId: 'understanding-al-fatihah',
      title: 'Verses 6-7: Guidance and the straight path',
      summary:
          'Reflect on what it means to ask Allah for guidance every day inside salah.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranNotesTool],
    ),
    LearningJourneyStage(
      id: 'fatihah-completion',
      journeyId: 'understanding-al-fatihah',
      title: 'Carry Al-Fatihah into salah',
      summary:
          'Gather the themes of Al-Fatihah and choose how to remember them when you stand in prayer.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'short-surahs-ikhlas',
      journeyId: 'short-surahs',
      title: 'Surah Al-Ikhlas',
      summary:
          'Learn the short surah of pure tawheed and why it is so central in meaning.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'short-surahs-falaq',
      journeyId: 'short-surahs',
      title: 'Surah Al-Falaq',
      summary:
          'Study this surah of seeking refuge and notice how it teaches protection through Allah.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'short-surahs-nas',
      journeyId: 'short-surahs',
      title: 'Surah An-Nas',
      summary:
          'Learn how this short surah teaches refuge, dependence, and protection of the heart.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranNotesTool],
    ),
    LearningJourneyStage(
      id: 'short-surahs-kafirun',
      journeyId: 'short-surahs',
      title: 'Surah Al-Kafirun',
      summary:
          'See how this short surah teaches clarity, loyalty to worship, and respectful firmness.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'short-surahs-kawthar',
      journeyId: 'short-surahs',
      title: 'Surah Al-Kawthar',
      summary:
          'Study this short surah of abundance, gratitude, and worship through sacrifice.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'short-surahs-completion',
      journeyId: 'short-surahs',
      title: 'Carry short surahs into prayer',
      summary:
          'Finish by choosing how these short surahs can deepen recitation, memory, and reflection in salah.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'prophets-overview',
      journeyId: 'prophets-journey',
      title: 'Open the Prophets hub',
      summary:
          'Enter the current Prophets system and begin with the story hub.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'prophets_home',
    ),
    LearningJourneyStage(
      id: 'prophets-journey-map',
      journeyId: 'prophets-journey',
      title: 'Follow the Journey of Revelation',
      summary:
          'Use the existing Prophets journey tab to move through the prophetic story arc.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'prophets_journey',
    ),
    LearningJourneyStage(
      id: 'prophets-quiz',
      journeyId: 'prophets-journey',
      title: 'Review with Prophets quiz',
      summary:
          'Use the current Prophets quiz flow to reinforce what you learned.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'prophets_quiz',
    ),
    LearningJourneyStage(
      id: 'seerah-early-life',
      journeyId: 'seerah-journey',
      title: 'Early Life of the Prophet ﷺ',
      summary:
          'A simple introduction to his childhood, care, and trustworthiness before revelation.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_prophetsTool],
    ),
    LearningJourneyStage(
      id: 'seerah-first-revelation',
      journeyId: 'seerah-journey',
      title: 'First Revelation',
      summary:
          'Learn how revelation began in Hira and what the first verses introduced.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool, _hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'seerah-makkah-period',
      journeyId: 'seerah-journey',
      title: 'Makkah Period',
      summary:
          'Follow the years of tawheed, patience, and calling in the Makkan period.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_prophetsTool],
    ),
    LearningJourneyStage(
      id: 'seerah-hijrah',
      journeyId: 'seerah-journey',
      title: 'Hijrah',
      summary:
          'Study migration as a lesson in planning, sacrifice, and tawakkul.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_legacyLearnTool],
    ),
    LearningJourneyStage(
      id: 'seerah-madinah-society',
      journeyId: 'seerah-journey',
      title: 'Madinah Society',
      summary:
          'See how the Prophet ﷺ built worship, brotherhood, and communal life in Madinah.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'seerah-leadership-character',
      journeyId: 'seerah-journey',
      title: 'Leadership & Character',
      summary:
          'Study how mercy, truth, patience, and courage shaped prophetic leadership.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool, _prophetsTool],
    ),
    LearningJourneyStage(
      id: 'seerah-final-sermon',
      journeyId: 'seerah-journey',
      title: 'Final Sermon',
      summary:
          'End with the major principles of dignity, justice, and faithfulness emphasized near the close of the mission.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool, _hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'hadith-essential-collection',
      journeyId: 'hadith-essentials',
      title: 'Why hadith matters',
      summary:
          'Begin with a simple frame for how hadith guides worship, character, and daily life.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'hadith-themes',
      journeyId: 'hadith-essentials',
      title: 'Collections and themes',
      summary:
          'Learn how to begin with essential collections and then browse themes without overload.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'hadith-review',
      journeyId: 'hadith-essentials',
      title: 'Review and live the lesson',
      summary:
          'Use review as reinforcement and connect what you read to character and daily wisdom.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'salah-hub',
      journeyId: 'salah-foundations',
      title: 'Why we pray',
      summary:
          'Begin with the meaning of salah as a daily meeting with Allah and the anchor of worship.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'salah-guided-fajr',
      journeyId: 'salah-foundations',
      title: 'Prepare for prayer',
      summary:
          'Learn how wudu, intention, timing, and calm prepare the heart and body for salah.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'salah-detail-fajr',
      journeyId: 'salah-foundations',
      title: 'Movements of salah',
      summary:
          'Walk through the prayer posture by posture so the sequence feels calm and understandable.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'salah-words-meaning',
      journeyId: 'salah-foundations',
      title: 'Words, meaning, and focus',
      summary:
          'Connect the words of salah to meaning so attention and khushu begin to grow together.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _quranNotesTool],
    ),
    LearningJourneyStage(
      id: 'salah-khushu-consistency',
      journeyId: 'salah-foundations',
      title: 'Consistency and khushu',
      summary:
          'Finish by building a realistic rhythm for protecting prayer and returning after weak days.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'salah-completion',
      journeyId: 'salah-foundations',
      title: 'Carry salah forward',
      summary:
          'Finish by choosing one concrete way to protect prayer, deepen focus, and continue learning.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _guidedPrayerTool],
    ),
    LearningJourneyStage(
      id: 'wudu-guide',
      journeyId: 'journey-of-wudu',
      title: 'Why wudu matters',
      summary:
          'Begin with wudu as preparation, purification, and readiness for salah.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wudu-trainer',
      journeyId: 'journey-of-wudu',
      title: 'Steps and practice flow',
      summary:
          'Walk through the sequence calmly and use guided practice to stabilize the order.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wudu-what-breaks',
      journeyId: 'journey-of-wudu',
      title: 'What breaks wudu',
      summary:
          'Learn the common states that break wudu and how to stay calm instead of confused.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wudu-common-mistakes',
      journeyId: 'journey-of-wudu',
      title: 'Common mistakes and self-check',
      summary:
          'Finish with practical reminders, confidence checks, and a gentle plan for improvement.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_wuduGuideTool, _wuduTrainerTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'wudu-completion',
      journeyId: 'journey-of-wudu',
      title: 'Carry wudu into worship',
      summary:
          'Finish by connecting confident wudu to calmer prayer preparation and steady worship.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_wuduGuideTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'dhikr-what-is',
      journeyId: 'daily-dhikr',
      title: 'What is Dhikr',
      summary:
          'Begin with a simple explanation of remembrance and why it matters.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'dhikr-morning-adhkar',
      journeyId: 'daily-dhikr',
      title: 'Morning Adhkar',
      summary: 'Start the day with a simple authentic remembrance routine.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'dhikr-evening-adhkar',
      journeyId: 'daily-dhikr',
      title: 'Evening Adhkar',
      summary: 'Close the day with remembrance, calm, and trust in Allah.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'dhikr-after-salah',
      journeyId: 'daily-dhikr',
      title: 'After Salah Dhikr',
      summary:
          'Use post-prayer remembrance to extend salah into the rest of your day.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'dhikr-simple-routine',
      journeyId: 'daily-dhikr',
      title: 'Simple Daily Routine',
      summary: 'Build a small sustainable dhikr routine without overload.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'dhikr-istighfar',
      journeyId: 'daily-dhikr',
      title: 'Istighfar',
      summary:
          'Learn a simple daily practice of seeking forgiveness with hope and humility.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'dhikr-salawat',
      journeyId: 'daily-dhikr',
      title: 'Salawat',
      summary:
          'Make sending prayers upon the Prophet ﷺ part of daily remembrance.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'duas-waking-up',
      journeyId: 'duas-daily-life',
      title: 'Waking Up',
      summary:
          'Begin the day with a short authentic dua of gratitude and return.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-sleeping',
      journeyId: 'duas-daily-life',
      title: 'Sleeping',
      summary: 'End the day by placing rest and life in Allah’s care.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-eating',
      journeyId: 'duas-daily-life',
      title: 'Eating',
      summary:
          'Keep food and drink connected to remembrance with short daily duas.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-leaving-home',
      journeyId: 'duas-daily-life',
      title: 'Leaving Home',
      summary: 'Step outside with tawakkul and a short dua of trust.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-entering-masjid',
      journeyId: 'duas-daily-life',
      title: 'Entering Masjid',
      summary:
          'Enter the masjid by asking Allah for mercy and readiness for worship.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-travel',
      journeyId: 'duas-daily-life',
      title: 'Travel',
      summary:
          'Use a travel remembrance that builds humility and awareness of return to Allah.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-distress',
      journeyId: 'duas-daily-life',
      title: 'Distress',
      summary: 'Turn to Allah in hardship with a short and meaningful dua.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'duas-gratitude',
      journeyId: 'duas-daily-life',
      title: 'Gratitude',
      summary: 'Use a Qur’anic dua that joins gratitude to righteous action.',
      order: 8,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_duaHubTool],
    ),
    LearningJourneyStage(
      id: 'ramadan-intention',
      journeyId: 'ramadan-foundations',
      title: 'What is Ramadan',
      summary:
          'Begin with what Ramadan is, why it is honored, and how it becomes a month of worship and mercy.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-why-fast',
      journeyId: 'ramadan-foundations',
      title: 'Why we fast',
      summary:
          'Learn the purpose of fasting and how it trains taqwa, gratitude, and restraint.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-daily-rhythm',
      journeyId: 'ramadan-foundations',
      title: 'Suhoor and iftar',
      summary:
          'Build a practical daily rhythm from pre-dawn preparation to breaking the fast with gratitude.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-what-breaks-fast',
      journeyId: 'ramadan-foundations',
      title: 'What breaks the fast',
      summary:
          'Learn the common things that break the fast and how to avoid anxious uncertainty.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-laylat-al-qadr',
      journeyId: 'ramadan-foundations',
      title: 'Laylat al-Qadr',
      summary:
          'Understand the weight of the last nights and how to seek Laylat al-Qadr with sincerity.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-reflection',
      journeyId: 'ramadan-foundations',
      title: 'Spiritual goals',
      summary:
          'Set simple spiritual goals so Ramadan changes more than your meal schedule.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'ramadan-common-mistakes',
      journeyId: 'ramadan-foundations',
      title: 'Common mistakes',
      summary:
          'Finish with practical reminders that protect fasting from confusion, burnout, and distraction.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-who-is-allah',
      journeyId: 'foundations-of-faith',
      title: 'Who is Allah',
      summary:
          'Begin with a simple introduction to Allah as Lord, Creator, and the One worthy of worship.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-tawheed',
      journeyId: 'foundations-of-faith',
      title: 'Tawheed',
      summary:
          'Learn the simple meaning of singling out Allah in worship and dependence.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-names-of-allah-intro',
      journeyId: 'foundations-of-faith',
      title: 'Names of Allah',
      summary:
          'Use a beginner-friendly introduction to how Allah’s names shape worship and dua.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_namesOfAllahTool],
    ),
    LearningJourneyStage(
      id: 'faith-angels',
      journeyId: 'foundations-of-faith',
      title: 'Angels',
      summary:
          'Study the place of angels in the unseen world and in Muslim belief.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-books',
      journeyId: 'foundations-of-faith',
      title: 'Books',
      summary:
          'Understand revelation and the place of the Qur’an as final guidance.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'faith-prophets',
      journeyId: 'foundations-of-faith',
      title: 'Prophets',
      summary:
          'Learn why Allah sent prophets and how their stories shape belief.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_prophetsTool],
    ),
    LearningJourneyStage(
      id: 'faith-day-of-judgment',
      journeyId: 'foundations-of-faith',
      title: 'Day of Judgment',
      summary:
          'See how belief in the Last Day gives life accountability, justice, and hope.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-qadr',
      journeyId: 'foundations-of-faith',
      title: 'Qadr',
      summary:
          'Study Allah’s decree in a simple way that preserves both trust and responsibility.',
      order: 8,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'faith-completion',
      journeyId: 'foundations-of-faith',
      title: 'Carry belief into life',
      summary:
          'Finish by gathering the core beliefs and choosing where to deepen them next.',
      order: 9,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-halal-haram',
      journeyId: 'fiqh-basics',
      title: 'Halal and haram',
      summary:
          'Begin with what lawful and unlawful mean in a practical Muslim life.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-cleanliness',
      journeyId: 'fiqh-basics',
      title: 'Cleanliness and readiness',
      summary:
          'Learn the role of cleanliness in worship, daily life, and preparation for prayer.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-prayer-basics',
      journeyId: 'fiqh-basics',
      title: 'Salah basics',
      summary:
          'Understand the first practical rules around timing, obligation, and salah readiness.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-fasting-basics',
      journeyId: 'fiqh-basics',
      title: 'Fasting basics',
      summary:
          'Learn the first practical rules of fasting without legal-detail overload.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-zakat-basics',
      journeyId: 'fiqh-basics',
      title: 'Zakat basics',
      summary:
          'See what zakat is, who it serves, and why it matters in simple terms.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-daily-life',
      journeyId: 'fiqh-basics',
      title: 'Daily life scenarios',
      summary:
          'Use simple what-should-I-do scenarios to make fiqh feel practical and usable.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'fiqh-completion',
      journeyId: 'fiqh-basics',
      title: 'Carry fiqh into daily life',
      summary:
          'Finish by choosing one practical area where clearer fiqh should shape your next step.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'character-ikhlas',
      journeyId: 'beautiful-character',
      title: 'Sincerity',
      summary: 'Begin with ikhlas so your actions are rooted in Allah alone.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'character-sabr',
      journeyId: 'beautiful-character',
      title: 'Patience',
      summary:
          'Learn how sabr steadies faith through hardship, delay, and discipline.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'character-shukr',
      journeyId: 'beautiful-character',
      title: 'Gratitude',
      summary:
          'See gratitude as worship of the heart, tongue, and daily choices.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_legacyLearnTool],
    ),
    LearningJourneyStage(
      id: 'character-humility',
      journeyId: 'beautiful-character',
      title: 'Humility',
      summary: 'Practice a humble heart while still standing firm on truth.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_prophetsTool],
    ),
    LearningJourneyStage(
      id: 'character-forgiveness',
      journeyId: 'beautiful-character',
      title: 'Forgiveness',
      summary: 'Learn when forgiveness heals the heart and restores dignity.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool],
    ),
    LearningJourneyStage(
      id: 'character-anger',
      journeyId: 'beautiful-character',
      title: 'Controlling anger',
      summary:
          'Train yourself to pause, restrain anger, and respond with wisdom.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_legacyLearnTool],
    ),
    LearningJourneyStage(
      id: 'character-kindness',
      journeyId: 'beautiful-character',
      title: 'Kindness',
      summary: 'Carry mercy into speech, service, and everyday relationships.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_hadithLandingTool, _legacyLearnTool],
    ),
    LearningJourneyStage(
      id: 'character-completion',
      journeyId: 'beautiful-character',
      title: 'Completion reflection',
      summary:
          'Gather what you learned and choose one character trait to keep practicing.',
      order: 8,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_reflectionModeTool],
    ),
    LearningJourneyStage(
      id: 'timeline-early-prophets',
      journeyId: 'timeline-of-islam',
      title: 'Early prophets overview',
      summary:
          'Begin with the longer prophetic story before the final message of Islam.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-prophet-era',
      journeyId: 'timeline-of-islam',
      title: 'The Prophet Muhammad ﷺ era',
      summary:
          'See how revelation, Makkah, Hijrah, and Madinah form the central era of Islam.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-khulafa',
      journeyId: 'timeline-of-islam',
      title: 'The rightly guided caliphs',
      summary:
          'Understand the first caliphal era and how it carried the prophetic community forward.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-expansion',
      journeyId: 'timeline-of-islam',
      title: 'Expansion of Islam',
      summary:
          'See how Islam spread beyond Arabia and how growth created new historical responsibilities.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-golden-age',
      journeyId: 'timeline-of-islam',
      title: 'Golden age and scholarship',
      summary:
          'Learn how knowledge, civilization, and scholarship flourished across later Muslim history.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-modern-context',
      journeyId: 'timeline-of-islam',
      title: 'Modern context',
      summary:
          'End with a light frame for how Muslims inherit this history in the modern world.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'timeline-completion',
      journeyId: 'timeline-of-islam',
      title: 'Carry the timeline forward',
      summary:
          'Finish by gathering the story flow and choosing where to study history more deeply next.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'alphabet-open',
      journeyId: 'arabic-alphabet',
      title: 'Meet the letters',
      summary:
          'Start with calm letter groups so recognition feels manageable from the first session.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'alphabet-repeat',
      journeyId: 'arabic-alphabet',
      title: 'Repeat and hear the sounds',
      summary:
          'Use repetition and listening to make letter sounds steadier and easier to recall.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'alphabet-review',
      journeyId: 'arabic-alphabet',
      title: 'Review and prepare for reading',
      summary:
          'Use short review loops so the alphabet stays stable before you move into harakat and words.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranArabicTool, _quranLearningHubTool],
    ),
    LearningJourneyStage(
      id: 'alphabet-completion',
      journeyId: 'arabic-alphabet',
      title: 'Ready for reading basics',
      summary:
          'Finish the alphabet journey by reviewing what is stable and moving into reading marks with confidence.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranArabicTool, _quranLearningHubTool],
    ),
    LearningJourneyStage(
      id: 'reading-basics-open',
      journeyId: 'reading-basics',
      title: 'Fathah',
      summary:
          'Begin reading with the short a sound and learn how it opens the mouth gently.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-kasra',
      journeyId: 'reading-basics',
      title: 'Kasrah',
      summary:
          'Learn the short i sound and how it changes the feel of a letter when reading.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-damma',
      journeyId: 'reading-basics',
      title: 'Dammah',
      summary:
          'Practice the short u sound and notice how rounded reading stays calm and precise.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-sukun',
      journeyId: 'reading-basics',
      title: 'Sukun',
      summary:
          'Understand how a resting letter sounds when there is no vowel movement attached to it.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-shaddah',
      journeyId: 'reading-basics',
      title: 'Shaddah',
      summary:
          'Learn how doubled letters sound and how to slow down enough to pronounce them clearly.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-practice',
      journeyId: 'reading-basics',
      title: 'Joining letters',
      summary:
          'Move from single sounds into joined letters and short words without rushing.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-checkpoint',
      journeyId: 'reading-basics',
      title: 'Review and checkpoint',
      summary:
          'Pause, review, and notice which reading skill is ready and which one still needs another calm pass.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'reading-basics-completion',
      journeyId: 'reading-basics',
      title: 'Move into recitation understanding',
      summary:
          'Finish by linking your new reading confidence to Qur’an meaning and familiar recitation.',
      order: 8,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranLearningHubTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'words-top',
      journeyId: '100-quranic-words',
      title: 'Open top Qur’anic words',
      summary: 'Start with the existing top-words exploration tool.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'quranTopWords',
    ),
    LearningJourneyStage(
      id: 'words-review',
      journeyId: '100-quranic-words',
      title: 'Review and retain',
      summary: 'Use the word review tool to revisit recurring vocabulary.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'quranWordReview',
    ),
    LearningJourneyStage(
      id: 'words-patterns',
      journeyId: '100-quranic-words',
      title: 'Patterns and meaning groups',
      summary:
          'Revisit the current top-words surface with a patterns mindset and notice recurring clusters and meanings.',
      order: 3,
      status: LearningJourneyStageStatus.partial,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'quranTopWords',
      relatedTools: [_topWordsTool, _wordReviewTool, _quranLearningHubTool],
    ),
    LearningJourneyStage(
      id: 'recite-fatihah',
      journeyId: 'understand-what-you-recite',
      title: 'Start with Al-Fatihah',
      summary:
          'Read Al-Fatihah in the Qur’an and connect it to repeated recitation.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'recite-short-surahs',
      journeyId: 'understand-what-you-recite',
      title: 'Understand short surahs in prayer',
      summary:
          'Use the current salah hub to connect recitation to meaning-rich repetition.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'recite-meaning',
      journeyId: 'understand-what-you-recite',
      title: 'Link words to meaning',
      summary:
          'A future stage for familiar prayer recitations and their core meanings.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_quranNotesTool, _learnSalahHubTool],
    ),
    LearningJourneyStage(
      id: 'recite-completion',
      journeyId: 'understand-what-you-recite',
      title: 'Carry meaning into worship',
      summary:
          'Finish by connecting familiar phrases to prayer, dhikr, and your next Arabic or Qur’an step.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_learnSalahHubTool, _quranReaderTool],
    ),
    LearningJourneyStage(
      id: 'tajweed-intro',
      journeyId: 'tajweed-basics',
      title: 'What tajweed is',
      summary:
          'Begin with what tajweed means, why careful recitation matters, and how to start without overwhelm.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'tajweed-makharij',
      journeyId: 'tajweed-basics',
      title: 'Sounds and articulation',
      summary:
          'Learn how articulation points shape sound and how slow listening helps correct common mistakes.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'tajweed-application',
      journeyId: 'tajweed-basics',
      title: 'Apply tajweed in recitation',
      summary:
          'Take basic tajweed awareness back into short surahs with listening comparison and one-step practice.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'trivia-paths',
      journeyId: 'trivia-knowledge-paths',
      title: 'Choose a knowledge path',
      summary:
          'Begin by choosing a trivia path that matches a real learning goal, not just random questions.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'trivia-session',
      journeyId: 'trivia-knowledge-paths',
      title: 'Use a short session well',
      summary:
          'Treat each trivia round as focused reinforcement and pay attention to what you miss.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'trivia-review',
      journeyId: 'trivia-knowledge-paths',
      title: 'Review and continue learning',
      summary:
          'Use weak answers as signals for what to revisit, then continue into related real journeys.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wisdom-daily-quote',
      journeyId: 'daily-wisdom',
      title: 'Daily wisdom prompt',
      summary:
          'A future daily wisdom loop will live here with short prompts and consistent revisiting.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wisdom-short-lesson',
      journeyId: 'daily-wisdom',
      title: 'Short daily lesson',
      summary:
          'A future stage for concise learning moments that do not overload the user.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'wisdom-practice',
      journeyId: 'daily-wisdom',
      title: 'Turn wisdom into practice',
      summary:
          'A later stage for reflection, habit suggestions, and applied reminders.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-sky-stars',
      journeyId: 'stories-signs',
      title: 'Sky and stars',
      summary:
          'Begin with the sky as a Qur’anic sign of order, beauty, and divine power.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-ocean',
      journeyId: 'stories-signs',
      title: 'Ocean',
      summary:
          'Reflect on the sea as a sign of mercy, power, and human dependence on Allah.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-mountains',
      journeyId: 'stories-signs',
      title: 'Mountains',
      summary:
          'See mountains as signs of stability, awe, and the scale of Allah’s creation.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-animals',
      journeyId: 'stories-signs',
      title: 'Animals',
      summary:
          'Learn from the signs in animals and how their lives point back to the Creator.',
      order: 4,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-human-creation',
      journeyId: 'stories-signs',
      title: 'Human creation',
      summary:
          'Reflect on your own creation as one of the clearest signs that calls for humility and gratitude.',
      order: 5,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-day-night',
      journeyId: 'stories-signs',
      title: 'Day and night',
      summary:
          'End with the cycle of day and night as a sign of rhythm, mercy, and remembrance.',
      order: 6,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
    ),
    LearningJourneyStage(
      id: 'stories-completion',
      journeyId: 'stories-signs',
      title: 'Carry the signs with you',
      summary:
          'Finish by turning reflection on creation into gratitude, worship, and deeper study.',
      order: 7,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingPage,
      targetReference: 'journey_lesson',
      relatedTools: [_worldSignsTool, _prophetsTool],
    ),
    LearningJourneyStage(
      id: 'reflection-creation',
      journeyId: 'reflection-mode',
      title: 'Reflection mode',
      summary: 'Open the current creation reflection mode.',
      order: 1,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'worldCreationReflectionMode',
    ),
    LearningJourneyStage(
      id: 'reflection-notes',
      journeyId: 'reflection-mode',
      title: 'Write and revisit notes',
      summary:
          'Use the existing learn notes landing page as the current note-keeping surface.',
      order: 2,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'learnNotesLanding',
    ),
    LearningJourneyStage(
      id: 'reflection-constellation',
      journeyId: 'reflection-mode',
      title: 'See connected knowledge',
      summary:
          'Use the knowledge constellation to revisit connections between lessons.',
      order: 3,
      status: LearningJourneyStageStatus.real,
      targetType: LearningJourneyStageTargetType.existingRoute,
      targetReference: 'knowledgeConstellation',
    ),
  ];

  static LearningJourneyIsland? islandById(String id) {
    assert(_validated);
    for (final island in islands) {
      if (island.id == id) return island;
    }
    return null;
  }

  static LearningJourney? journeyById(String id) {
    assert(_validated);
    for (final journey in journeys) {
      if (journey.id == id) return journey;
    }
    return null;
  }

  static LearningJourneyStage? stageById(String id) {
    assert(_validated);
    for (final stage in stages) {
      if (stage.id == id) return stage;
    }
    return null;
  }

  static List<LearningJourney> journeysForIsland(String islandId) {
    assert(_validated);
    final items = journeys.where((item) => item.islandId == islandId).toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  static List<LearningJourneyStage> stagesForJourney(String journeyId) {
    assert(_validated);
    final items = stages.where((item) => item.journeyId == journeyId).toList();
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  static bool _validate() {
    final journeyIds = <String>{};
    for (final journey in journeys) {
      assert(journey.id.trim().isNotEmpty, 'Journey id cannot be empty');
      assert(journey.title.trim().isNotEmpty, 'Journey title cannot be empty');
      assert(
        journey.subtitle.trim().isNotEmpty,
        'Journey subtitle cannot be empty',
      );
      assert(
        journey.description.trim().isNotEmpty,
        'Journey description cannot be empty',
      );
      assert(
        journey.learningOutcomes.isNotEmpty,
        'Journey ${journey.id} must describe what the user will learn',
      );
      assert(
        journeyIds.add(journey.id),
        'Duplicate journey id found: ${journey.id}',
      );
    }

    final stageIds = <String>{};
    final stagesByJourney = <String, List<LearningJourneyStage>>{};
    for (final stage in stages) {
      assert(stage.id.trim().isNotEmpty, 'Stage id cannot be empty');
      assert(stage.title.trim().isNotEmpty, 'Stage title cannot be empty');
      assert(stage.summary.trim().isNotEmpty, 'Stage summary cannot be empty');
      assert(stageIds.add(stage.id), 'Duplicate stage id found: ${stage.id}');
      stagesByJourney
          .putIfAbsent(stage.journeyId, () => <LearningJourneyStage>[])
          .add(stage);
    }

    for (final entry in stagesByJourney.entries) {
      final sorted = [...entry.value]
        ..sort((a, b) => a.order.compareTo(b.order));
      for (var index = 0; index < sorted.length; index += 1) {
        assert(
          sorted[index].order == index + 1,
          'Journey ${entry.key} has non-sequential stage ordering',
        );
      }
    }
    return true;
  }
}

const _quranSearchTool = LearningJourneyToolLink(
  title: 'Search',
  subtitle: 'Search ayat and phrases directly.',
  routeName: 'quranSearch',
);

const _quranBookmarksTool = LearningJourneyToolLink(
  title: 'Bookmarks',
  subtitle: 'Return to saved places you want to revisit.',
  routeName: 'quranBookmarks',
);

const _quranNotesTool = LearningJourneyToolLink(
  title: 'Notes',
  subtitle: 'Keep reflections tied to verses and passages.',
  routeName: 'quranNotes',
);

const _quranReaderTool = LearningJourneyToolLink(
  title: 'Read',
  subtitle: 'Open a direct reading view.',
  routeName: 'quranReader',
  pathParameters: {'surahNumber': '1'},
);

const _quranExplorerTool = LearningJourneyToolLink(
  title: 'Explorer',
  subtitle: 'Browse surahs and open reading routes.',
  routeName: 'quranExplorer',
);

const _wuduGuideTool = LearningJourneyToolLink(
  title: 'Wudu Guide',
  subtitle: 'Open the full wudu guide.',
  routeName: 'learnWuduGuide',
);

const _wuduTrainerTool = LearningJourneyToolLink(
  title: 'Wudu Trainer',
  subtitle: 'Practice step by step.',
  routeName: 'learnWuduTrainer',
);

const _duaHubTool = LearningJourneyToolLink(
  title: 'Dua Hub',
  subtitle: 'Open the current verified dua hub.',
  routeName: 'learnDuaHub',
);

const _dhikrCounterTool = LearningJourneyToolLink(
  title: 'Dhikr Counter',
  subtitle: 'Open the live dhikr practice surface.',
  routeName: 'worshipDhikrPage',
);

const _legacyLearnTool = LearningJourneyToolLink(
  title: 'Legacy Learning Material',
  subtitle: 'Explore the original learning library during migration.',
  // Retained as a broad fallback for older journey metadata where there is
  // not yet a one-to-one canonical destination.
  routeName: 'learnLegacy',
);

const _seerahCompanionTool = LearningJourneyToolLink(
  title: 'Seerah Companion',
  subtitle: 'Open the dedicated Seerah companion surface.',
  routeName: 'learnSeerahCompanion',
);

const _characterCompanionTool = LearningJourneyToolLink(
  title: 'Character Companion',
  subtitle: 'Open the focused character and adab companion surface.',
  routeName: 'learnCharacterCompanion',
  queryParameters: {'focus': 'ikhlas'},
);

const _dailyWisdomCompanionTool = LearningJourneyToolLink(
  title: 'Daily Wisdom',
  subtitle: 'Open the owned daily wisdom and reflection surface.',
  routeName: 'learnDailyWisdomCompanion',
  queryParameters: {'focus': 'gratitude'},
);

const _namesOfAllahTool = LearningJourneyToolLink(
  title: 'Names of Allah',
  subtitle: 'Use the existing names page.',
  routeName: 'quranNamesOfAllah',
);

const _prophetsTool = LearningJourneyToolLink(
  title: 'Prophets',
  subtitle: 'Open the current Prophets system.',
  routeName: 'learnProphetsHub',
  queryParameters: {'tab': 'stories'},
);

const _prophetsTimelineTool = LearningJourneyToolLink(
  title: 'Prophets Timeline',
  subtitle: 'Open the Prophets system and move through chronology.',
  routeName: 'learnProphetsHub',
  queryParameters: {'tab': 'timeline'},
);

const _prophetsMapTool = LearningJourneyToolLink(
  title: 'Prophets Map',
  subtitle: 'Explore prophets by region and place.',
  routeName: 'learnProphetsHub',
  queryParameters: {'tab': 'map'},
);

const _prophetsFamilyTreeTool = LearningJourneyToolLink(
  title: 'Family Tree',
  subtitle: 'See prophetic lineage and relationships.',
  routeName: 'learnProphetsHub',
  queryParameters: {'tab': 'family-tree'},
);

const _quranArabicTool = LearningJourneyToolLink(
  title: 'Qur’anic Arabic',
  subtitle: 'Open the dedicated Arabic learning path.',
  routeName: 'quranArabic',
);

const _topWordsTool = LearningJourneyToolLink(
  title: 'Words',
  subtitle: 'Browse recurring Qur’anic vocabulary.',
  routeName: 'quranTopWords',
);

const _wordReviewTool = LearningJourneyToolLink(
  title: 'Word Review',
  subtitle: 'Review saved and repeated word sets.',
  routeName: 'quranWordReview',
);

const _quranLearningHubTool = LearningJourneyToolLink(
  title: 'Study',
  subtitle: 'Open the study-focused Qur’an learning path.',
  routeName: 'quranLearningHub',
);

const _learnSalahHubTool = LearningJourneyToolLink(
  title: 'Salah Hub',
  subtitle: 'Open the current Salah learning hub.',
  routeName: 'learnSalahHub',
);

const _guidedPrayerTool = LearningJourneyToolLink(
  title: 'Guided Salah',
  subtitle: 'Open a guided salah flow.',
  routeName: 'learnSalahGuidedPrayer',
  pathParameters: {'prayerId': 'fajr'},
);

const _hadithLandingTool = LearningJourneyToolLink(
  title: 'Hadith Hub',
  subtitle: 'Open themes, collections, and paths.',
  routeName: 'learnHadithLanding',
);

const _hadithImportantTool = LearningJourneyToolLink(
  title: 'Essential Hadith',
  subtitle: 'Start with the curated essentials.',
  routeName: 'learnHadithImportant',
);

const _hadithReviewTool = LearningJourneyToolLink(
  title: 'Hadith Review',
  subtitle: 'Revisit due or weak hadith material.',
  routeName: 'hadithReviewQuiz',
);

const _triviaPathsTool = LearningJourneyToolLink(
  title: 'Trivia Paths',
  subtitle: 'Open the guided trivia path system.',
  routeName: 'learnTriviaKnowledgePaths',
);

const _triviaReviewTool = LearningJourneyToolLink(
  title: 'Trivia Review',
  subtitle: 'Review what is due next.',
  routeName: 'learnTriviaReview',
);

const _worldLandingTool = LearningJourneyToolLink(
  title: 'World & Creation',
  subtitle: 'Open the main world-and-creation hub.',
  routeName: 'learnWorldLanding',
);

const _worldExploreCreationTool = LearningJourneyToolLink(
  title: 'Explore Creation',
  subtitle: 'Jump into guided signs in creation.',
  routeName: 'worldExploreCreation',
);

const _worldSignsTool = LearningJourneyToolLink(
  title: 'Signs Explorer',
  subtitle: 'Browse signs-based exploration content.',
  routeName: 'worldSignsExplorer',
);

const _reflectionModeTool = LearningJourneyToolLink(
  title: 'Reflection Mode',
  subtitle: 'Open the current reflection-first creation view.',
  routeName: 'worldCreationReflectionMode',
);

const _learnNotesTool = LearningJourneyToolLink(
  title: 'Learn Notes',
  subtitle: 'Review saved notes and reflections.',
  routeName: 'learnNotesLanding',
);

const _historyArchiveTool = LearningJourneyToolLink(
  title: 'History Archive',
  subtitle: 'Open the main historical archive and timeline surface.',
  routeName: 'learnHistoryArchive',
);

const _knowledgeConstellationTool = LearningJourneyToolLink(
  title: 'Knowledge Constellation',
  subtitle: 'See learning connections across domains.',
  routeName: 'knowledgeConstellation',
);

const _browseAllLearningTool = LearningJourneyToolLink(
  title: 'Browse All Knowledge',
  subtitle:
      'Open the wider map of islands, tools, collections, and exploration.',
  routeName: 'learnExploreAllKnowledge',
);

const _kidsArabicLettersTool = LearningJourneyToolLink(
  title: 'Write and Learn Arabic Letters',
  subtitle:
      'Letters, tracing, review, rewards, and a parent view for children.',
  routeName: 'kidsArabicHome',
);

const _babyNamesTool = LearningJourneyToolLink(
  title: 'Baby Names',
  subtitle: 'Explore Muslim baby names, meanings, favorites, and generators.',
  routeName: 'babyNamesHome',
);

const _legacyLearningIslandTool = LearningJourneyToolLink(
  title: 'Legacy Learning Material',
  subtitle: 'Open the original learning library and older migrated sections.',
  // The hidden legacy-learning island still points at the compatibility
  // library because its migrated sections do not yet have one replacement.
  routeName: 'learnLegacy',
);

const _kidsDuaLearningTool = LearningJourneyToolLink(
  title: 'Kids Dua Learning',
  subtitle: 'Small daily duas for meals, sleep, home, and family life.',
  routeName: 'kidsDuaLanding',
);
