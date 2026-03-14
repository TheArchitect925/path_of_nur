import 'package:flutter/material.dart';

import '../domain/quran_teaching_models.dart';

class QuranTeacherLetterSeed {
  const QuranTeacherLetterSeed({
    required this.id,
    required this.letter,
    required this.name,
    required this.transliteration,
    required this.simpleExplanation,
    required this.exampleWord,
    required this.exampleMeaning,
    required this.exampleReference,
    required this.audioAsset,
    this.visualModeAnchorId,
    this.visualHint,
    this.visualImageAsset,
    this.visualIcon,
  });

  final String id;
  final String letter;
  final String name;
  final String transliteration;
  final String simpleExplanation;
  final String exampleWord;
  final String exampleMeaning;
  final String exampleReference;
  final String audioAsset;
  final String? visualModeAnchorId;
  final String? visualHint;
  final String? visualImageAsset;
  final IconData? visualIcon;
}

class QuranTeacherLetterShapeSeed {
  const QuranTeacherLetterShapeSeed({
    required this.id,
    required this.letter,
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.finalForm,
  });

  final String id;
  final String letter;
  final String isolated;
  final String initial;
  final String medial;
  final String finalForm;
}

class QuranTeacherReadingExampleSeed {
  const QuranTeacherReadingExampleSeed({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.audioAsset,
    required this.verseReference,
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String audioAsset;
  final String verseReference;
}

class QuranTeacherRuleSeed {
  const QuranTeacherRuleSeed({
    required this.id,
    required this.title,
    required this.simpleExplanation,
    required this.examples,
    required this.exampleSourceReferences,
    required this.audioAsset,
    this.symbol,
  });

  final String id;
  final String title;
  final String simpleExplanation;
  final List<String> examples;
  final List<String> exampleSourceReferences;
  final String audioAsset;
  final String? symbol;
}

class QuranTeacherWordSeed {
  const QuranTeacherWordSeed({
    required this.id,
    required this.word,
    required this.transliteration,
    required this.meaning,
    required this.audioAsset,
    required this.category,
    required this.exampleVerse,
    this.frequencyHint,
    this.imageAsset,
  });

  final String id;
  final String word;
  final String transliteration;
  final String meaning;
  final String audioAsset;
  final String category;
  final String exampleVerse;
  final String? frequencyHint;
  final String? imageAsset;
}

class QuranTeacherPhraseSeed {
  const QuranTeacherPhraseSeed({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.audioAsset,
    required this.lessonLink,
    required this.sourceReference,
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String audioAsset;
  final String lessonLink;
  final String sourceReference;
}

class QuranTeacherSurahSeed {
  const QuranTeacherSurahSeed({
    required this.surahId,
    required this.arabicName,
    required this.englishName,
    required this.transliteration,
    required this.ayahCount,
    required this.description,
    required this.lessonEntry,
    this.ayahPreview = const <String>[],
  });

  final String surahId;
  final String arabicName;
  final String englishName;
  final String transliteration;
  final int ayahCount;
  final String description;
  final String lessonEntry;
  final List<String> ayahPreview;
}

class QuranTeacherQuizSeed {
  const QuranTeacherQuizSeed({
    required this.quizId,
    required this.quizType,
    required this.prompt,
    required this.options,
    required this.correctAnswerIds,
    required this.explanation,
    this.audioAsset,
    this.imageAsset,
    this.promptArabic,
    this.promptSecondary,
    this.buildOrder = const <String>[],
    this.truthAnswer = true,
  });

  final String quizId;
  final QuranTeachingQuizType quizType;
  final String prompt;
  final List<QuranTeachingQuizOption> options;
  final List<String> correctAnswerIds;
  final String explanation;
  final String? audioAsset;
  final String? imageAsset;
  final String? promptArabic;
  final String? promptSecondary;
  final List<String> buildOrder;
  final bool truthAnswer;
}

class QuranTeacherListenPackSeed {
  const QuranTeacherListenPackSeed({
    required this.packId,
    required this.title,
    required this.description,
    required this.moduleId,
    required this.category,
    required this.itemIds,
  });

  final String packId;
  final String title;
  final String description;
  final String moduleId;
  final QuranTeachingAudioPackCategory category;
  final List<String> itemIds;
}

class QuranTeacherListenItemSeed {
  const QuranTeacherListenItemSeed({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.audioAsset,
    this.imageAsset,
    this.visualHint,
    this.moduleId,
    this.lessonId,
  });

  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String audioAsset;
  final String? imageAsset;
  final String? visualHint;
  final String? moduleId;
  final String? lessonId;
}

const _wordCategoryTitles = <String, String>{
  'core': 'Core Words',
  'worship': 'Worship Words',
  'mercy': 'Mercy Words',
  'creation': 'Creation Words',
  'hereafter': 'Hereafter Words',
  'connector': 'Connector Words',
};

const _wordCategorySubtitles = <String, String>{
  'core': 'Starter words that return again and again in the Qur’an.',
  'worship': 'Words connected to devotion, obedience, and practice.',
  'mercy': 'Words of mercy, guidance, forgiveness, and care.',
  'creation': 'Words about creation, signs, and the world around us.',
  'hereafter': 'Words tied to judgement, return, and the next life.',
  'connector': 'Small words that appear everywhere and help connect meaning.',
};

const quranTeacherAlphabetSeeds = <QuranTeacherLetterSeed>[
  QuranTeacherLetterSeed(
    id: 'letter_alif',
    letter: 'ا',
    name: 'Alif',
    transliteration: 'a',
    simpleExplanation:
        'Alif is a straight letter that often carries vowel sounds.',
    exampleWord: 'أَب',
    exampleMeaning: 'father',
    exampleReference: 'Qur’an 12:4',
    audioAsset: 'assets/audio/quran_teacher/letters/alif.mp3',
    visualModeAnchorId: 'apple',
    visualHint: 'Apple helps you remember Alif.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png',
    visualIcon: Icons.filter_vintage_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_ba',
    letter: 'ب',
    name: 'Ba',
    transliteration: 'ba',
    simpleExplanation: 'Ba makes a b sound and has one dot below.',
    exampleWord: 'بَيْت',
    exampleMeaning: 'house',
    exampleReference: 'Qur’an 2:125',
    audioAsset: 'assets/audio/quran_teacher/letters/ba.mp3',
    visualModeAnchorId: 'ball',
    visualHint: 'Ball helps you remember Ba.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png',
    visualIcon: Icons.sports_baseball_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_ta',
    letter: 'ت',
    name: 'Ta',
    transliteration: 'ta',
    simpleExplanation: 'Ta makes a t sound and has two dots above.',
    exampleWord: 'تَابَ',
    exampleMeaning: 'he turned back in repentance',
    exampleReference: 'Qur’an 2:37',
    audioAsset: 'assets/audio/quran_teacher/letters/ta.mp3',
    visualModeAnchorId: 'tree',
    visualHint: 'Tree helps you remember Ta.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png',
    visualIcon: Icons.park_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_tha',
    letter: 'ث',
    name: 'Tha',
    transliteration: 'tha',
    simpleExplanation: 'Tha is softer than ta and has three dots above.',
    exampleWord: 'ثَوَاب',
    exampleMeaning: 'reward',
    exampleReference: 'Qur’an 3:145',
    audioAsset: 'assets/audio/quran_teacher/letters/tha.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_jeem',
    letter: 'ج',
    name: 'Jeem',
    transliteration: 'jeem',
    simpleExplanation: 'Jeem is a j sound in beginner reading lessons.',
    exampleWord: 'جَنَّة',
    exampleMeaning: 'garden',
    exampleReference: 'Qur’an 2:25',
    audioAsset: 'assets/audio/quran_teacher/letters/jeem.mp3',
    visualModeAnchorId: 'juice',
    visualHint: 'Juice helps you remember Jeem.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/jeem_juice.png',
    visualIcon: Icons.local_drink_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_haa_soft',
    letter: 'ح',
    name: 'Haa',
    transliteration: 'haa',
    simpleExplanation: 'This haa is a soft breathy sound from deeper in the throat.',
    exampleWord: 'حَقّ',
    exampleMeaning: 'truth',
    exampleReference: 'Qur’an 10:32',
    audioAsset: 'assets/audio/quran_teacher/letters/haa_soft.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_khaa',
    letter: 'خ',
    name: 'Khaa',
    transliteration: 'khaa',
    simpleExplanation: 'Khaa is a rougher throat sound than haa.',
    exampleWord: 'خَلَق',
    exampleMeaning: 'created',
    exampleReference: 'Qur’an 96:1',
    audioAsset: 'assets/audio/quran_teacher/letters/khaa.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_daal',
    letter: 'د',
    name: 'Daal',
    transliteration: 'daal',
    simpleExplanation: 'Daal makes a d sound.',
    exampleWord: 'دِين',
    exampleMeaning: 'religion',
    exampleReference: 'Qur’an 109:6',
    audioAsset: 'assets/audio/quran_teacher/letters/daal.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_dhaal',
    letter: 'ذ',
    name: 'Dhaal',
    transliteration: 'dhaal',
    simpleExplanation: 'Dhaal is a softer th sound with the tongue forward.',
    exampleWord: 'ذِكْر',
    exampleMeaning: 'remembrance',
    exampleReference: 'Qur’an 15:9',
    audioAsset: 'assets/audio/quran_teacher/letters/dhaal.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_raa',
    letter: 'ر',
    name: 'Raa',
    transliteration: 'raa',
    simpleExplanation: 'Raa is a light rolling r sound.',
    exampleWord: 'رَبّ',
    exampleMeaning: 'Lord',
    exampleReference: 'Qur’an 1:2',
    audioAsset: 'assets/audio/quran_teacher/letters/raa.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_zay',
    letter: 'ز',
    name: 'Zay',
    transliteration: 'zay',
    simpleExplanation: 'Zay makes a z sound.',
    exampleWord: 'زَكَاة',
    exampleMeaning: 'purifying charity',
    exampleReference: 'Qur’an 2:43',
    audioAsset: 'assets/audio/quran_teacher/letters/zay.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_seen',
    letter: 'س',
    name: 'Seen',
    transliteration: 'seen',
    simpleExplanation: 'Seen makes an s sound and has a flowing tooth-like shape.',
    exampleWord: 'سَمَاء',
    exampleMeaning: 'sky',
    exampleReference: 'Qur’an 2:19',
    audioAsset: 'assets/audio/quran_teacher/letters/seen.mp3',
    visualModeAnchorId: 'sun',
    visualHint: 'Sun helps you remember Seen.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png',
    visualIcon: Icons.wb_sunny_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_sheen',
    letter: 'ش',
    name: 'Sheen',
    transliteration: 'sheen',
    simpleExplanation: 'Sheen looks like seen but adds three dots above.',
    exampleWord: 'شَمْس',
    exampleMeaning: 'sun',
    exampleReference: 'Qur’an 91:1',
    audioAsset: 'assets/audio/quran_teacher/letters/sheen.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_saad',
    letter: 'ص',
    name: 'Saad',
    transliteration: 'saad',
    simpleExplanation: 'Saad is a heavier s sound.',
    exampleWord: 'صَبْر',
    exampleMeaning: 'patience',
    exampleReference: 'Qur’an 2:153',
    audioAsset: 'assets/audio/quran_teacher/letters/saad.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_daad',
    letter: 'ض',
    name: 'Daad',
    transliteration: 'daad',
    simpleExplanation: 'Daad is a heavier d sound.',
    exampleWord: 'أَرْض',
    exampleMeaning: 'earth',
    exampleReference: 'Qur’an 2:22',
    audioAsset: 'assets/audio/quran_teacher/letters/daad.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_taa_heavy',
    letter: 'ط',
    name: 'Taa',
    transliteration: 'taa',
    simpleExplanation: 'This taa is heavier than regular ta.',
    exampleWord: 'طَيِّب',
    exampleMeaning: 'good / pure',
    exampleReference: 'Qur’an 2:168',
    audioAsset: 'assets/audio/quran_teacher/letters/taa_heavy.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_zaa_heavy',
    letter: 'ظ',
    name: 'Zaa',
    transliteration: 'zaa',
    simpleExplanation: 'This zaa is a heavier deep sound.',
    exampleWord: 'ظُلْم',
    exampleMeaning: 'wrongdoing',
    exampleReference: 'Qur’an 6:82',
    audioAsset: 'assets/audio/quran_teacher/letters/zaa_heavy.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_ayn',
    letter: 'ع',
    name: 'Ayn',
    transliteration: 'ayn',
    simpleExplanation: 'Ayn comes from deep in the throat. Keep it gentle.',
    exampleWord: 'عِلْم',
    exampleMeaning: 'knowledge',
    exampleReference: 'Qur’an 2:32',
    audioAsset: 'assets/audio/quran_teacher/letters/ayn.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_ghayn',
    letter: 'غ',
    name: 'Ghayn',
    transliteration: 'ghayn',
    simpleExplanation: 'Ghayn is related to ayn but has a rougher sound.',
    exampleWord: 'غَفُور',
    exampleMeaning: 'all-forgiving',
    exampleReference: 'Qur’an 2:173',
    audioAsset: 'assets/audio/quran_teacher/letters/ghayn.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_faa',
    letter: 'ف',
    name: 'Faa',
    transliteration: 'faa',
    simpleExplanation: 'Faa makes an f sound.',
    exampleWord: 'فِي',
    exampleMeaning: 'in',
    exampleReference: 'Qur’an 1:6',
    audioAsset: 'assets/audio/quran_teacher/letters/faa.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_qaaf',
    letter: 'ق',
    name: 'Qaaf',
    transliteration: 'qaaf',
    simpleExplanation: 'Qaaf is deeper than kaaf.',
    exampleWord: 'قَلْب',
    exampleMeaning: 'heart',
    exampleReference: 'Qur’an 50:37',
    audioAsset: 'assets/audio/quran_teacher/letters/qaaf.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_kaaf',
    letter: 'ك',
    name: 'Kaaf',
    transliteration: 'kaaf',
    simpleExplanation: 'Kaaf makes a k sound.',
    exampleWord: 'كِتَاب',
    exampleMeaning: 'book',
    exampleReference: 'Qur’an 2:2',
    audioAsset: 'assets/audio/quran_teacher/letters/kaaf.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_laam',
    letter: 'ل',
    name: 'Laam',
    transliteration: 'laam',
    simpleExplanation: 'Laam makes a clear l sound.',
    exampleWord: 'لَيْل',
    exampleMeaning: 'night',
    exampleReference: 'Qur’an 92:1',
    audioAsset: 'assets/audio/quran_teacher/letters/laam.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_meem',
    letter: 'م',
    name: 'Meem',
    transliteration: 'meem',
    simpleExplanation: 'Meem makes an m sound.',
    exampleWord: 'مَاء',
    exampleMeaning: 'water',
    exampleReference: 'Qur’an 2:22',
    audioAsset: 'assets/audio/quran_teacher/letters/meem.mp3',
    visualModeAnchorId: 'moon',
    visualHint: 'Moon helps you remember Meem.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png',
    visualIcon: Icons.nightlight_round,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_noon',
    letter: 'ن',
    name: 'Noon',
    transliteration: 'noon',
    simpleExplanation: 'Noon makes an n sound.',
    exampleWord: 'نُور',
    exampleMeaning: 'light',
    exampleReference: 'Qur’an 24:35',
    audioAsset: 'assets/audio/quran_teacher/letters/noon.mp3',
    visualModeAnchorId: 'nest',
    visualHint: 'Nest helps you remember Noon.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png',
    visualIcon: Icons.egg_alt_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_haa',
    letter: 'هـ',
    name: 'Haa',
    transliteration: 'haa',
    simpleExplanation: 'This haa is the lighter h sound used in many common words.',
    exampleWord: 'هُدًى',
    exampleMeaning: 'guidance',
    exampleReference: 'Qur’an 2:2',
    audioAsset: 'assets/audio/quran_teacher/letters/haa.mp3',
  ),
  QuranTeacherLetterSeed(
    id: 'letter_waw',
    letter: 'و',
    name: 'Waw',
    transliteration: 'waw',
    simpleExplanation: 'Waw can be a letter and later help make a long vowel.',
    exampleWord: 'وَلَد',
    exampleMeaning: 'child',
    exampleReference: 'Qur’an 19:88',
    audioAsset: 'assets/audio/quran_teacher/letters/waw.mp3',
    visualModeAnchorId: 'water',
    visualHint: 'Water helps you remember Waw.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png',
    visualIcon: Icons.water_drop_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'letter_yaa',
    letter: 'ي',
    name: 'Yaa',
    transliteration: 'yaa',
    simpleExplanation: 'Yaa can be a letter and later help make a long vowel.',
    exampleWord: 'يَوْم',
    exampleMeaning: 'day',
    exampleReference: 'Qur’an 1:4',
    audioAsset: 'assets/audio/quran_teacher/letters/yaa.mp3',
  ),
];

const quranTeacherLetterShapeSeeds = <QuranTeacherLetterShapeSeed>[
  QuranTeacherLetterShapeSeed(
    id: 'shape_ba',
    letter: 'ب',
    isolated: 'ب',
    initial: 'بـ',
    medial: 'ـبـ',
    finalForm: 'ـب',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_ta',
    letter: 'ت',
    isolated: 'ت',
    initial: 'تـ',
    medial: 'ـتـ',
    finalForm: 'ـت',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_tha',
    letter: 'ث',
    isolated: 'ث',
    initial: 'ثـ',
    medial: 'ـثـ',
    finalForm: 'ـث',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_jeem',
    letter: 'ج',
    isolated: 'ج',
    initial: 'جـ',
    medial: 'ـجـ',
    finalForm: 'ـج',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_haa_soft',
    letter: 'ح',
    isolated: 'ح',
    initial: 'حـ',
    medial: 'ـحـ',
    finalForm: 'ـح',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_khaa',
    letter: 'خ',
    isolated: 'خ',
    initial: 'خـ',
    medial: 'ـخـ',
    finalForm: 'ـخ',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_seen',
    letter: 'س',
    isolated: 'س',
    initial: 'سـ',
    medial: 'ـسـ',
    finalForm: 'ـس',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_sheen',
    letter: 'ش',
    isolated: 'ش',
    initial: 'شـ',
    medial: 'ـشـ',
    finalForm: 'ـش',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_ayn',
    letter: 'ع',
    isolated: 'ع',
    initial: 'عـ',
    medial: 'ـعـ',
    finalForm: 'ـع',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_ghayn',
    letter: 'غ',
    isolated: 'غ',
    initial: 'غـ',
    medial: 'ـغـ',
    finalForm: 'ـغ',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_faa',
    letter: 'ف',
    isolated: 'ف',
    initial: 'فـ',
    medial: 'ـفـ',
    finalForm: 'ـف',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_qaaf',
    letter: 'ق',
    isolated: 'ق',
    initial: 'قـ',
    medial: 'ـقـ',
    finalForm: 'ـق',
  ),
  QuranTeacherLetterShapeSeed(
    id: 'shape_yaa',
    letter: 'ي',
    isolated: 'ي',
    initial: 'يـ',
    medial: 'ـيـ',
    finalForm: 'ـي',
  ),
];

const quranTeacherTwoLetterSeeds = <QuranTeacherReadingExampleSeed>[
  QuranTeacherReadingExampleSeed(
    id: 'read_rabb_short',
    arabic: 'رَب',
    transliteration: 'Rab',
    meaning: 'Lord',
    audioAsset: 'assets/audio/quran_teacher/words/rabb.mp3',
    verseReference: 'Qur’an 1:2',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_min',
    arabic: 'مِن',
    transliteration: 'Min',
    meaning: 'From',
    audioAsset: 'assets/audio/quran_teacher/words/min.mp3',
    verseReference: 'Qur’an 1:7',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_fi',
    arabic: 'فِي',
    transliteration: 'Fi',
    meaning: 'In',
    audioAsset: 'assets/audio/quran_teacher/words/fee.mp3',
    verseReference: 'Qur’an 1:6',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_lan',
    arabic: 'لَن',
    transliteration: 'Lan',
    meaning: 'Will not',
    audioAsset: 'assets/audio/quran_teacher/words/lan.mp3',
    verseReference: 'Qur’an 2:95',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_lahu',
    arabic: 'لَهُ',
    transliteration: 'Lahu',
    meaning: 'For him',
    audioAsset: 'assets/audio/quran_teacher/words/lahu.mp3',
    verseReference: 'Qur’an 112:4',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_bihi',
    arabic: 'بِهِ',
    transliteration: 'Bihi',
    meaning: 'With it / with him',
    audioAsset: 'assets/audio/quran_teacher/words/bihi.mp3',
    verseReference: 'Qur’an 2:2',
  ),
];

const quranTeacherThreeLetterSeeds = <QuranTeacherReadingExampleSeed>[
  QuranTeacherReadingExampleSeed(
    id: 'read_kataba',
    arabic: 'كَتَبَ',
    transliteration: 'Kataba',
    meaning: 'He wrote',
    audioAsset: 'assets/audio/quran_teacher/words/kataba.mp3',
    verseReference: 'Qur’an 2:183',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_abd',
    arabic: 'عَبْد',
    transliteration: 'Abd',
    meaning: 'Servant',
    audioAsset: 'assets/audio/quran_teacher/words/abd.mp3',
    verseReference: 'Qur’an 17:1',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_alima',
    arabic: 'عَلِمَ',
    transliteration: 'Alima',
    meaning: 'He knew',
    audioAsset: 'assets/audio/quran_teacher/words/ilm.mp3',
    verseReference: 'Qur’an 2:235',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_khalaqa',
    arabic: 'خَلَقَ',
    transliteration: 'Khalaqa',
    meaning: 'He created',
    audioAsset: 'assets/audio/quran_teacher/words/khalaqa.mp3',
    verseReference: 'Qur’an 96:1',
  ),
  QuranTeacherReadingExampleSeed(
    id: 'read_samia',
    arabic: 'سَمِعَ',
    transliteration: 'Samia',
    meaning: 'He heard',
    audioAsset: 'assets/audio/quran_teacher/words/samia.mp3',
    verseReference: 'Qur’an 58:1',
  ),
];

const quranTeacherRuleSeeds = <QuranTeacherRuleSeed>[
  QuranTeacherRuleSeed(
    id: 'rule_sukun',
    title: 'Sukun',
    simpleExplanation: 'Sukun means the letter stops and has no vowel sound.',
    examples: <String>['مِنْ', 'لَمْ', 'الْحَمْدُ'],
    exampleSourceReferences: <String>['Qur’an 1:7', 'Qur’an 112:3', 'Qur’an 1:2'],
    audioAsset: 'assets/audio/quran_teacher/rules/sukun_intro.mp3',
    symbol: 'ْ',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_shaddah',
    title: 'Shaddah',
    simpleExplanation: 'Shaddah doubles the sound of a letter.',
    examples: <String>['إِنَّ', 'ثُمَّ', 'رَبِّ'],
    exampleSourceReferences: <String>['Qur’an 2:2', 'Qur’an 2:51', 'Qur’an 1:2'],
    audioAsset: 'assets/audio/quran_teacher/rules/shaddah_intro.mp3',
    symbol: 'ّ',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_tanween',
    title: 'Tanween',
    simpleExplanation: 'Tanween adds an ending sound like un, in, or an.',
    examples: <String>['كِتَابٌ', 'هُدًى', 'عَلِيمًا'],
    exampleSourceReferences: <String>['Qur’an 2:2', 'Qur’an 2:2', 'Qur’an 4:11'],
    audioAsset: 'assets/audio/quran_teacher/rules/tanween_damma.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_sun_letters',
    title: 'Sun letters',
    simpleExplanation: 'With sun letters, the l sound blends into the next letter.',
    examples: <String>['الشَّمْس'],
    exampleSourceReferences: <String>['Qur’an 91:1'],
    audioAsset:
        'assets/audio/quran_teacher/rules/sun_letter_example_ash_shams.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_moon_letters',
    title: 'Moon letters',
    simpleExplanation: 'With moon letters, the l sound stays clear.',
    examples: <String>['الْقَمَر'],
    exampleSourceReferences: <String>['Qur’an 54:1'],
    audioAsset:
        'assets/audio/quran_teacher/rules/moon_letter_example_al_qamar.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_hamzah',
    title: 'Hamzah',
    simpleExplanation: 'Hamzah can appear in different shapes. Start by noticing it.',
    examples: <String>['أَحَدٌ', 'إِيَّاكَ', 'السَّمَاءِ'],
    exampleSourceReferences: <String>['Qur’an 112:1', 'Qur’an 1:5', 'Qur’an 86:1'],
    audioAsset: 'assets/audio/quran_teacher/rules/hamzah_intro.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_alif_maqsurah',
    title: 'Alif Maqsurah',
    simpleExplanation:
        'This final shape looks like ya but sounds like a long a.',
    examples: <String>['هُدَى', 'مُوسَى'],
    exampleSourceReferences: <String>['Qur’an 2:38', 'Qur’an 2:136'],
    audioAsset: 'assets/audio/quran_teacher/rules/alif_maqsurah_intro.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'rule_silent_letters',
    title: 'Silent letters',
    simpleExplanation:
        'Sometimes a letter is written but not strongly heard in beginner reading.',
    examples: <String>['هٰذَا'],
    exampleSourceReferences: <String>['Qur’an 2:2'],
    audioAsset: 'assets/audio/quran_teacher/rules/silent_letters_intro.mp3',
  ),
];

const quranTeacherTajweedSeeds = <QuranTeacherRuleSeed>[
  QuranTeacherRuleSeed(
    id: 'tajweed_qalqalah',
    title: 'Qalqalah',
    simpleExplanation:
        'Qalqalah is a slight bounce on certain still letters.',
    examples: <String>['الْفَلَقِ', 'أَحَدٌ', 'يَلِدْ'],
    exampleSourceReferences: <String>['Qur’an 113:1', 'Qur’an 112:1', 'Qur’an 112:3'],
    audioAsset: 'assets/audio/quran_teacher/tajweed/qalqalah_intro.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'tajweed_ghunnah',
    title: 'Ghunnah',
    simpleExplanation: 'Ghunnah is a soft nasal sound in certain places.',
    examples: <String>['إِنَّ'],
    exampleSourceReferences: <String>['Qur’an 97:1'],
    audioAsset: 'assets/audio/quran_teacher/tajweed/ghunnah_intro.mp3',
  ),
  QuranTeacherRuleSeed(
    id: 'tajweed_noon_saakin',
    title: 'Noon Saakin',
    simpleExplanation:
        'With noon saakin, the next letter can change how the sound is heard.',
    examples: <String>['مِنْ رَبِّهِمْ'],
    exampleSourceReferences: <String>['Qur’an 2:5'],
    audioAsset: 'assets/audio/quran_teacher/tajweed/noon_saakin_intro.mp3',
  ),
];

const quranTeacherFirst100Words = <QuranTeacherWordSeed>[
  QuranTeacherWordSeed(id: 'word_allah', word: 'اللّٰه', transliteration: 'Allah', meaning: 'Allah', audioAsset: 'assets/audio/quran_teacher/words/allah.mp3', category: 'core', exampleVerse: 'Qur’an 1:1', frequencyHint: 'Very frequent'),
  QuranTeacherWordSeed(id: 'word_rabb', word: 'رَبّ', transliteration: 'Rabb', meaning: 'Lord', audioAsset: 'assets/audio/quran_teacher/words/rabb.mp3', category: 'core', exampleVerse: 'Qur’an 1:2', frequencyHint: 'Very frequent'),
  QuranTeacherWordSeed(id: 'word_yawm', word: 'يَوْم', transliteration: 'Yawm', meaning: 'Day', audioAsset: 'assets/audio/quran_teacher/words/yawm.mp3', category: 'core', exampleVerse: 'Qur’an 1:4'),
  QuranTeacherWordSeed(id: 'word_kitab', word: 'كِتَاب', transliteration: 'Kitab', meaning: 'Book', audioAsset: 'assets/audio/quran_teacher/words/kitab.mp3', category: 'core', exampleVerse: 'Qur’an 2:2'),
  QuranTeacherWordSeed(id: 'word_ayah', word: 'آيَة', transliteration: 'Ayah', meaning: 'Sign / verse', audioAsset: 'assets/audio/quran_teacher/words/ayah.mp3', category: 'core', exampleVerse: 'Qur’an 2:248'),
  QuranTeacherWordSeed(id: 'word_nur', word: 'نُور', transliteration: 'Nur', meaning: 'Light', audioAsset: 'assets/audio/quran_teacher/words/noor.mp3', category: 'core', exampleVerse: 'Qur’an 24:35'),
  QuranTeacherWordSeed(id: 'word_haqq', word: 'حَقّ', transliteration: 'Haqq', meaning: 'Truth', audioAsset: 'assets/audio/quran_teacher/words/haqq.mp3', category: 'core', exampleVerse: 'Qur’an 10:32'),
  QuranTeacherWordSeed(id: 'word_quran', word: 'قُرْآن', transliteration: 'Qur’an', meaning: 'Qur’an', audioAsset: 'assets/audio/quran_teacher/words/quran.mp3', category: 'core', exampleVerse: 'Qur’an 17:9'),
  QuranTeacherWordSeed(id: 'word_qawl', word: 'قَوْل', transliteration: 'Qawl', meaning: 'Word / saying', audioAsset: 'assets/audio/quran_teacher/words/qawl.mp3', category: 'core', exampleVerse: 'Qur’an 39:18'),
  QuranTeacherWordSeed(id: 'word_ilm', word: 'عِلْم', transliteration: 'Ilm', meaning: 'Knowledge', audioAsset: 'assets/audio/quran_teacher/words/ilm.mp3', category: 'core', exampleVerse: 'Qur’an 2:32'),
  QuranTeacherWordSeed(id: 'word_amr', word: 'أَمْر', transliteration: 'Amr', meaning: 'Command', audioAsset: 'assets/audio/quran_teacher/words/amr.mp3', category: 'core', exampleVerse: 'Qur’an 16:1'),
  QuranTeacherWordSeed(id: 'word_din', word: 'دِين', transliteration: 'Din', meaning: 'Religion / way', audioAsset: 'assets/audio/quran_teacher/words/din.mp3', category: 'core', exampleVerse: 'Qur’an 1:4'),
  QuranTeacherWordSeed(id: 'word_hikmah', word: 'حِكْمَة', transliteration: 'Hikmah', meaning: 'Wisdom', audioAsset: 'assets/audio/quran_teacher/words/hikmah.mp3', category: 'core', exampleVerse: 'Qur’an 2:269'),
  QuranTeacherWordSeed(id: 'word_qalb', word: 'قَلْب', transliteration: 'Qalb', meaning: 'Heart', audioAsset: 'assets/audio/quran_teacher/words/qalb.mp3', category: 'core', exampleVerse: 'Qur’an 50:37'),
  QuranTeacherWordSeed(id: 'word_nafs', word: 'نَفْس', transliteration: 'Nafs', meaning: 'Self / soul', audioAsset: 'assets/audio/quran_teacher/words/nafs.mp3', category: 'core', exampleVerse: 'Qur’an 3:185'),
  QuranTeacherWordSeed(id: 'word_mulk', word: 'مُلْك', transliteration: 'Mulk', meaning: 'Kingdom', audioAsset: 'assets/audio/quran_teacher/words/mulk.mp3', category: 'core', exampleVerse: 'Qur’an 67:1'),
  QuranTeacherWordSeed(id: 'word_rahman', word: 'رَحْمٰن', transliteration: 'Rahman', meaning: 'Most Merciful', audioAsset: 'assets/audio/quran_teacher/words/rahman.mp3', category: 'core', exampleVerse: 'Qur’an 1:3'),
  QuranTeacherWordSeed(id: 'word_rahim', word: 'رَحِيم', transliteration: 'Rahim', meaning: 'Especially Merciful', audioAsset: 'assets/audio/quran_teacher/words/rahim.mp3', category: 'core', exampleVerse: 'Qur’an 1:3'),
  QuranTeacherWordSeed(id: 'word_sirat', word: 'صِرَاط', transliteration: 'Sirat', meaning: 'Path', audioAsset: 'assets/audio/quran_teacher/words/sirat.mp3', category: 'core', exampleVerse: 'Qur’an 1:6'),
  QuranTeacherWordSeed(id: 'word_akhira', word: 'آخِرَة', transliteration: 'Akhirah', meaning: 'Hereafter', audioAsset: 'assets/audio/quran_teacher/words/akhirah.mp3', category: 'core', exampleVerse: 'Qur’an 87:17'),

  QuranTeacherWordSeed(id: 'word_salah', word: 'صَلَاة', transliteration: 'Salah', meaning: 'Prayer', audioAsset: 'assets/audio/quran_teacher/words/salah.mp3', category: 'worship', exampleVerse: 'Qur’an 2:43'),
  QuranTeacherWordSeed(id: 'word_zakah', word: 'زَكَاة', transliteration: 'Zakah', meaning: 'Purifying charity', audioAsset: 'assets/audio/quran_teacher/words/zakah.mp3', category: 'worship', exampleVerse: 'Qur’an 2:43'),
  QuranTeacherWordSeed(id: 'word_sabr', word: 'صَبْر', transliteration: 'Sabr', meaning: 'Patience', audioAsset: 'assets/audio/quran_teacher/words/sabr.mp3', category: 'worship', exampleVerse: 'Qur’an 2:153'),
  QuranTeacherWordSeed(id: 'word_dhikr', word: 'ذِكْر', transliteration: 'Dhikr', meaning: 'Remembrance', audioAsset: 'assets/audio/quran_teacher/words/dhikr.mp3', category: 'worship', exampleVerse: 'Qur’an 15:9'),
  QuranTeacherWordSeed(id: 'word_dua', word: 'دُعَاء', transliteration: 'Dua', meaning: 'Supplication', audioAsset: 'assets/audio/quran_teacher/words/dua.mp3', category: 'worship', exampleVerse: 'Qur’an 13:14'),
  QuranTeacherWordSeed(id: 'word_abd', word: 'عَبْد', transliteration: 'Abd', meaning: 'Servant', audioAsset: 'assets/audio/quran_teacher/words/abd.mp3', category: 'worship', exampleVerse: 'Qur’an 17:1'),
  QuranTeacherWordSeed(id: 'word_sujud', word: 'سُجُود', transliteration: 'Sujud', meaning: 'Prostration', audioAsset: 'assets/audio/quran_teacher/words/sujud.mp3', category: 'worship', exampleVerse: 'Qur’an 50:40'),
  QuranTeacherWordSeed(id: 'word_ruku', word: 'رُكُوع', transliteration: 'Ruku', meaning: 'Bowing', audioAsset: 'assets/audio/quran_teacher/words/ruku.mp3', category: 'worship', exampleVerse: 'Qur’an 2:43'),
  QuranTeacherWordSeed(id: 'word_siyam', word: 'صِيَام', transliteration: 'Siyam', meaning: 'Fasting', audioAsset: 'assets/audio/quran_teacher/words/siyam.mp3', category: 'worship', exampleVerse: 'Qur’an 2:183'),
  QuranTeacherWordSeed(id: 'word_hajj', word: 'حَجّ', transliteration: 'Hajj', meaning: 'Pilgrimage', audioAsset: 'assets/audio/quran_teacher/words/hajj.mp3', category: 'worship', exampleVerse: 'Qur’an 2:196'),
  QuranTeacherWordSeed(id: 'word_taqwa', word: 'تَقْوَى', transliteration: 'Taqwa', meaning: 'God-consciousness', audioAsset: 'assets/audio/quran_teacher/words/taqwa.mp3', category: 'worship', exampleVerse: 'Qur’an 2:197'),
  QuranTeacherWordSeed(id: 'word_iman', word: 'إِيمَان', transliteration: 'Iman', meaning: 'Faith', audioAsset: 'assets/audio/quran_teacher/words/iman.mp3', category: 'worship', exampleVerse: 'Qur’an 49:14'),
  QuranTeacherWordSeed(id: 'word_islam', word: 'إِسْلَام', transliteration: 'Islam', meaning: 'Submission', audioAsset: 'assets/audio/quran_teacher/words/islam.mp3', category: 'worship', exampleVerse: 'Qur’an 3:19'),
  QuranTeacherWordSeed(id: 'word_shukr', word: 'شُكْر', transliteration: 'Shukr', meaning: 'Gratitude', audioAsset: 'assets/audio/quran_teacher/words/shukr.mp3', category: 'worship', exampleVerse: 'Qur’an 14:7'),
  QuranTeacherWordSeed(id: 'word_tawbah', word: 'تَوْبَة', transliteration: 'Tawbah', meaning: 'Repentance', audioAsset: 'assets/audio/quran_teacher/words/tawbah.mp3', category: 'worship', exampleVerse: 'Qur’an 9:104'),

  QuranTeacherWordSeed(id: 'word_rahmah', word: 'رَحْمَة', transliteration: 'Rahmah', meaning: 'Mercy', audioAsset: 'assets/audio/quran_teacher/words/rahmah.mp3', category: 'mercy', exampleVerse: 'Qur’an 7:156'),
  QuranTeacherWordSeed(id: 'word_huda', word: 'هُدًى', transliteration: 'Huda', meaning: 'Guidance', audioAsset: 'assets/audio/quran_teacher/words/huda.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:2'),
  QuranTeacherWordSeed(id: 'word_maghfirah', word: 'مَغْفِرَة', transliteration: 'Maghfirah', meaning: 'Forgiveness', audioAsset: 'assets/audio/quran_teacher/words/maghfirah.mp3', category: 'mercy', exampleVerse: 'Qur’an 3:133'),
  QuranTeacherWordSeed(id: 'word_karim', word: 'كَرِيم', transliteration: 'Karim', meaning: 'Generous / noble', audioAsset: 'assets/audio/quran_teacher/words/karim.mp3', category: 'mercy', exampleVerse: 'Qur’an 27:29'),
  QuranTeacherWordSeed(id: 'word_ghafur', word: 'غَفُور', transliteration: 'Ghafur', meaning: 'All-Forgiving', audioAsset: 'assets/audio/quran_teacher/words/ghafur.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:173'),
  QuranTeacherWordSeed(id: 'word_tawwab', word: 'تَوَّاب', transliteration: 'Tawwab', meaning: 'Accepting repentance', audioAsset: 'assets/audio/quran_teacher/words/tawwab.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:37'),
  QuranTeacherWordSeed(id: 'word_latif', word: 'لَطِيف', transliteration: 'Latif', meaning: 'Subtle / gentle', audioAsset: 'assets/audio/quran_teacher/words/latif.mp3', category: 'mercy', exampleVerse: 'Qur’an 6:103'),
  QuranTeacherWordSeed(id: 'word_wadud', word: 'وَدُود', transliteration: 'Wadud', meaning: 'Loving', audioAsset: 'assets/audio/quran_teacher/words/wadud.mp3', category: 'mercy', exampleVerse: 'Qur’an 11:90'),
  QuranTeacherWordSeed(id: 'word_afw', word: 'عَفْو', transliteration: 'Afw', meaning: 'Pardon', audioAsset: 'assets/audio/quran_teacher/words/afw.mp3', category: 'mercy', exampleVerse: 'Qur’an 4:149'),
  QuranTeacherWordSeed(id: 'word_furqan', word: 'فُرْقَان', transliteration: 'Furqan', meaning: 'Criterion', audioAsset: 'assets/audio/quran_teacher/words/furqan.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:185'),
  QuranTeacherWordSeed(id: 'word_barakah', word: 'بَرَكَة', transliteration: 'Barakah', meaning: 'Blessing', audioAsset: 'assets/audio/quran_teacher/words/barakah.mp3', category: 'mercy', exampleVerse: 'Qur’an 7:96'),
  QuranTeacherWordSeed(id: 'word_sami', word: 'سَمِيع', transliteration: 'Sami', meaning: 'All-Hearing', audioAsset: 'assets/audio/quran_teacher/words/sami.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:127'),
  QuranTeacherWordSeed(id: 'word_basir', word: 'بَصِير', transliteration: 'Basir', meaning: 'All-Seeing', audioAsset: 'assets/audio/quran_teacher/words/basir.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:110'),
  QuranTeacherWordSeed(id: 'word_hakim', word: 'حَكِيم', transliteration: 'Hakim', meaning: 'Wise', audioAsset: 'assets/audio/quran_teacher/words/hakim.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:129'),
  QuranTeacherWordSeed(id: 'word_alim', word: 'عَلِيم', transliteration: 'Alim', meaning: 'All-Knowing', audioAsset: 'assets/audio/quran_teacher/words/alim.mp3', category: 'mercy', exampleVerse: 'Qur’an 2:29'),

  QuranTeacherWordSeed(id: 'word_sama', word: 'سَمَاء', transliteration: 'Sama', meaning: 'Sky', audioAsset: 'assets/audio/quran_teacher/words/sama.mp3', category: 'creation', exampleVerse: 'Qur’an 2:19'),
  QuranTeacherWordSeed(id: 'word_ard', word: 'أَرْض', transliteration: 'Ard', meaning: 'Earth', audioAsset: 'assets/audio/quran_teacher/words/ard.mp3', category: 'creation', exampleVerse: 'Qur’an 2:22'),
  QuranTeacherWordSeed(id: 'word_shams', word: 'شَمْس', transliteration: 'Shams', meaning: 'Sun', audioAsset: 'assets/audio/quran_teacher/words/shams.mp3', category: 'creation', exampleVerse: 'Qur’an 91:1', imageAsset: 'assets/images/quran_teacher/visual_mode/words/shams_sun.png'),
  QuranTeacherWordSeed(id: 'word_qamar', word: 'قَمَر', transliteration: 'Qamar', meaning: 'Moon', audioAsset: 'assets/audio/quran_teacher/words/qamar.mp3', category: 'creation', exampleVerse: 'Qur’an 54:1', imageAsset: 'assets/images/quran_teacher/visual_mode/words/qamar_moon.png'),
  QuranTeacherWordSeed(id: 'word_layl', word: 'لَيْل', transliteration: 'Layl', meaning: 'Night', audioAsset: 'assets/audio/quran_teacher/words/layl.mp3', category: 'creation', exampleVerse: 'Qur’an 92:1'),
  QuranTeacherWordSeed(id: 'word_nahar', word: 'نَهَار', transliteration: 'Nahar', meaning: 'Daytime', audioAsset: 'assets/audio/quran_teacher/words/nahar.mp3', category: 'creation', exampleVerse: 'Qur’an 92:2'),
  QuranTeacherWordSeed(id: 'word_maa', word: 'مَاء', transliteration: 'Maa', meaning: 'Water', audioAsset: 'assets/audio/quran_teacher/words/maa.mp3', category: 'creation', exampleVerse: 'Qur’an 2:22', imageAsset: 'assets/images/quran_teacher/visual_mode/words/maa_water.png'),
  QuranTeacherWordSeed(id: 'word_bahr', word: 'بَحْر', transliteration: 'Bahr', meaning: 'Sea', audioAsset: 'assets/audio/quran_teacher/words/bahr.mp3', category: 'creation', exampleVerse: 'Qur’an 2:50'),
  QuranTeacherWordSeed(id: 'word_jabal', word: 'جَبَل', transliteration: 'Jabal', meaning: 'Mountain', audioAsset: 'assets/audio/quran_teacher/words/jabal.mp3', category: 'creation', exampleVerse: 'Qur’an 7:143'),
  QuranTeacherWordSeed(id: 'word_nahr', word: 'نَهْر', transliteration: 'Nahr', meaning: 'River', audioAsset: 'assets/audio/quran_teacher/words/nahr.mp3', category: 'creation', exampleVerse: 'Qur’an 54:54'),
  QuranTeacherWordSeed(id: 'word_shajar', word: 'شَجَر', transliteration: 'Shajar', meaning: 'Tree', audioAsset: 'assets/audio/quran_teacher/words/shajar.mp3', category: 'creation', exampleVerse: 'Qur’an 16:10'),
  QuranTeacherWordSeed(id: 'word_hajar', word: 'حَجَر', transliteration: 'Hajar', meaning: 'Stone', audioAsset: 'assets/audio/quran_teacher/words/hajar.mp3', category: 'creation', exampleVerse: 'Qur’an 2:60'),
  QuranTeacherWordSeed(id: 'word_reeh', word: 'رِيح', transliteration: 'Reeh', meaning: 'Wind', audioAsset: 'assets/audio/quran_teacher/words/reeh.mp3', category: 'creation', exampleVerse: 'Qur’an 10:22'),
  QuranTeacherWordSeed(id: 'word_matar', word: 'مَطَر', transliteration: 'Matar', meaning: 'Rain', audioAsset: 'assets/audio/quran_teacher/words/matar.mp3', category: 'creation', exampleVerse: 'Qur’an 4:102'),
  QuranTeacherWordSeed(id: 'word_turab', word: 'تُرَاب', transliteration: 'Turab', meaning: 'Dust / soil', audioAsset: 'assets/audio/quran_teacher/words/turab.mp3', category: 'creation', exampleVerse: 'Qur’an 3:59'),
  QuranTeacherWordSeed(id: 'word_insan', word: 'إِنْسَان', transliteration: 'Insan', meaning: 'Human being', audioAsset: 'assets/audio/quran_teacher/words/insan.mp3', category: 'creation', exampleVerse: 'Qur’an 76:1'),
  QuranTeacherWordSeed(id: 'word_anam', word: 'أَنْعَام', transliteration: 'Anam', meaning: 'Cattle', audioAsset: 'assets/audio/quran_teacher/words/anam.mp3', category: 'creation', exampleVerse: 'Qur’an 16:5'),
  QuranTeacherWordSeed(id: 'word_dabbah', word: 'دَابَّة', transliteration: 'Dabbah', meaning: 'Living creature', audioAsset: 'assets/audio/quran_teacher/words/dabbah.mp3', category: 'creation', exampleVerse: 'Qur’an 24:45'),
  QuranTeacherWordSeed(id: 'word_nahr_light', word: 'نُور', transliteration: 'Nur', meaning: 'Light', audioAsset: 'assets/audio/quran_teacher/words/noor.mp3', category: 'creation', exampleVerse: 'Qur’an 24:35'),
  QuranTeacherWordSeed(id: 'word_falak', word: 'فَلَك', transliteration: 'Falak', meaning: 'Orbit', audioAsset: 'assets/audio/quran_teacher/words/falak.mp3', category: 'creation', exampleVerse: 'Qur’an 21:33'),

  QuranTeacherWordSeed(id: 'word_jannah', word: 'جَنَّة', transliteration: 'Jannah', meaning: 'Paradise', audioAsset: 'assets/audio/quran_teacher/words/jannah.mp3', category: 'hereafter', exampleVerse: 'Qur’an 2:25'),
  QuranTeacherWordSeed(id: 'word_nar', word: 'نَار', transliteration: 'Nar', meaning: 'Fire', audioAsset: 'assets/audio/quran_teacher/words/nar.mp3', category: 'hereafter', exampleVerse: 'Qur’an 2:24'),
  QuranTeacherWordSeed(id: 'word_hisab', word: 'حِسَاب', transliteration: 'Hisab', meaning: 'Account', audioAsset: 'assets/audio/quran_teacher/words/hisab.mp3', category: 'hereafter', exampleVerse: 'Qur’an 2:202'),
  QuranTeacherWordSeed(id: 'word_akhirah_h', word: 'آخِرَة', transliteration: 'Akhirah', meaning: 'Hereafter', audioAsset: 'assets/audio/quran_teacher/words/akhirah.mp3', category: 'hereafter', exampleVerse: 'Qur’an 87:17'),
  QuranTeacherWordSeed(id: 'word_bath', word: 'بَعْث', transliteration: 'Bath', meaning: 'Resurrection', audioAsset: 'assets/audio/quran_teacher/words/bath.mp3', category: 'hereafter', exampleVerse: 'Qur’an 22:7'),
  QuranTeacherWordSeed(id: 'word_qiyamah', word: 'قِيَامَة', transliteration: 'Qiyamah', meaning: 'Resurrection day', audioAsset: 'assets/audio/quran_teacher/words/qiyamah.mp3', category: 'hereafter', exampleVerse: 'Qur’an 75:1'),
  QuranTeacherWordSeed(id: 'word_jaza', word: 'جَزَاء', transliteration: 'Jaza', meaning: 'Recompense', audioAsset: 'assets/audio/quran_teacher/words/jaza.mp3', category: 'hereafter', exampleVerse: 'Qur’an 78:26'),
  QuranTeacherWordSeed(id: 'word_ajr', word: 'أَجْر', transliteration: 'Ajr', meaning: 'Reward', audioAsset: 'assets/audio/quran_teacher/words/ajr.mp3', category: 'hereafter', exampleVerse: 'Qur’an 2:62'),
  QuranTeacherWordSeed(id: 'word_jahannam', word: 'جَهَنَّم', transliteration: 'Jahannam', meaning: 'Hell', audioAsset: 'assets/audio/quran_teacher/words/jahannam.mp3', category: 'hereafter', exampleVerse: 'Qur’an 15:43'),
  QuranTeacherWordSeed(id: 'word_mizan', word: 'مِيزَان', transliteration: 'Mizan', meaning: 'Scale', audioAsset: 'assets/audio/quran_teacher/words/mizan.mp3', category: 'hereafter', exampleVerse: 'Qur’an 55:9'),
  QuranTeacherWordSeed(id: 'word_firdaws', word: 'فِرْدَوْس', transliteration: 'Firdaws', meaning: 'Highest garden', audioAsset: 'assets/audio/quran_teacher/words/firdaws.mp3', category: 'hereafter', exampleVerse: 'Qur’an 18:107'),
  QuranTeacherWordSeed(id: 'word_sair', word: 'سَعِير', transliteration: 'Sair', meaning: 'Blazing fire', audioAsset: 'assets/audio/quran_teacher/words/sair.mp3', category: 'hereafter', exampleVerse: 'Qur’an 67:5'),
  QuranTeacherWordSeed(id: 'word_khulud', word: 'خُلُود', transliteration: 'Khulud', meaning: 'Lasting forever', audioAsset: 'assets/audio/quran_teacher/words/khulud.mp3', category: 'hereafter', exampleVerse: 'Qur’an 21:34'),
  QuranTeacherWordSeed(id: 'word_liqa', word: 'لِقَاء', transliteration: 'Liqa', meaning: 'Meeting', audioAsset: 'assets/audio/quran_teacher/words/liqa.mp3', category: 'hereafter', exampleVerse: 'Qur’an 18:110'),
  QuranTeacherWordSeed(id: 'word_hashr', word: 'حَشْر', transliteration: 'Hashr', meaning: 'Gathering', audioAsset: 'assets/audio/quran_teacher/words/hashr.mp3', category: 'hereafter', exampleVerse: 'Qur’an 59:2'),

  QuranTeacherWordSeed(id: 'word_fi', word: 'فِي', transliteration: 'Fi', meaning: 'In', audioAsset: 'assets/audio/quran_teacher/words/fee.mp3', category: 'connector', exampleVerse: 'Qur’an 1:6'),
  QuranTeacherWordSeed(id: 'word_min', word: 'مِن', transliteration: 'Min', meaning: 'From', audioAsset: 'assets/audio/quran_teacher/words/min.mp3', category: 'connector', exampleVerse: 'Qur’an 1:7'),
  QuranTeacherWordSeed(id: 'word_ila', word: 'إِلَى', transliteration: 'Ila', meaning: 'To', audioAsset: 'assets/audio/quran_teacher/words/ila.mp3', category: 'connector', exampleVerse: 'Qur’an 96:8'),
  QuranTeacherWordSeed(id: 'word_ala', word: 'عَلَى', transliteration: 'Ala', meaning: 'Upon', audioAsset: 'assets/audio/quran_teacher/words/ala.mp3', category: 'connector', exampleVerse: 'Qur’an 2:5'),
  QuranTeacherWordSeed(id: 'word_inna', word: 'إِنَّ', transliteration: 'Inna', meaning: 'Indeed', audioAsset: 'assets/audio/quran_teacher/words/inna.mp3', category: 'connector', exampleVerse: 'Qur’an 2:2'),
  QuranTeacherWordSeed(id: 'word_la', word: 'لَا', transliteration: 'La', meaning: 'No / not', audioAsset: 'assets/audio/quran_teacher/words/la.mp3', category: 'connector', exampleVerse: 'Qur’an 1:7'),
  QuranTeacherWordSeed(id: 'word_wa', word: 'وَ', transliteration: 'Wa', meaning: 'And', audioAsset: 'assets/audio/quran_teacher/words/wa.mp3', category: 'connector', exampleVerse: 'Qur’an 103:1'),
  QuranTeacherWordSeed(id: 'word_fa', word: 'فَ', transliteration: 'Fa', meaning: 'Then / so', audioAsset: 'assets/audio/quran_teacher/words/fa.mp3', category: 'connector', exampleVerse: 'Qur’an 108:2'),
  QuranTeacherWordSeed(id: 'word_thumma', word: 'ثُمَّ', transliteration: 'Thumma', meaning: 'Then', audioAsset: 'assets/audio/quran_teacher/words/thumma.mp3', category: 'connector', exampleVerse: 'Qur’an 2:29'),
  QuranTeacherWordSeed(id: 'word_idha', word: 'إِذَا', transliteration: 'Idha', meaning: 'When', audioAsset: 'assets/audio/quran_teacher/words/idha.mp3', category: 'connector', exampleVerse: 'Qur’an 99:1'),
  QuranTeacherWordSeed(id: 'word_ma', word: 'مَا', transliteration: 'Ma', meaning: 'What / that which', audioAsset: 'assets/audio/quran_teacher/words/ma.mp3', category: 'connector', exampleVerse: 'Qur’an 2:26'),
  QuranTeacherWordSeed(id: 'word_man', word: 'مَنْ', transliteration: 'Man', meaning: 'Who', audioAsset: 'assets/audio/quran_teacher/words/man.mp3', category: 'connector', exampleVerse: 'Qur’an 1:7'),
  QuranTeacherWordSeed(id: 'word_alladhi', word: 'الَّذِي', transliteration: 'Alladhi', meaning: 'The one who', audioAsset: 'assets/audio/quran_teacher/words/alladhi.mp3', category: 'connector', exampleVerse: 'Qur’an 96:1'),
  QuranTeacherWordSeed(id: 'word_lan', word: 'لَنْ', transliteration: 'Lan', meaning: 'Will not', audioAsset: 'assets/audio/quran_teacher/words/lan.mp3', category: 'connector', exampleVerse: 'Qur’an 2:95'),
  QuranTeacherWordSeed(id: 'word_lam', word: 'لَمْ', transliteration: 'Lam', meaning: 'Did not', audioAsset: 'assets/audio/quran_teacher/words/lam.mp3', category: 'connector', exampleVerse: 'Qur’an 112:3'),
];

const quranTeacherPhraseSeeds = <QuranTeacherPhraseSeed>[
  QuranTeacherPhraseSeed(
    id: 'phrase_alhamdulillah',
    arabic: 'الْحَمْدُ لِلّٰهِ',
    transliteration: 'Al-hamdu lillah',
    meaning: 'All praise is for Allah',
    audioAsset: 'assets/audio/quran_teacher/phrases/alhamdulillah.mp3',
    lessonLink: 'phrase_fatihah_1',
    sourceReference: 'Qur’an 1:2',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_rabb_alamin',
    arabic: 'رَبِّ الْعَالَمِينَ',
    transliteration: 'Rabbil alamin',
    meaning: 'Lord of the worlds',
    audioAsset: 'assets/audio/quran_teacher/phrases/rabb_al_alamin.mp3',
    lessonLink: 'phrase_fatihah_1',
    sourceReference: 'Qur’an 1:2',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_bismillah',
    arabic: 'بِسْمِ اللّٰهِ',
    transliteration: 'Bismillah',
    meaning: 'In the name of Allah',
    audioAsset: 'assets/audio/quran_teacher/phrases/bismillah.mp3',
    lessonLink: 'phrase_fatihah_1',
    sourceReference: 'Qur’an 1:1',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_maliki_yawmiddin',
    arabic: 'مَالِكِ يَوْمِ الدِّينِ',
    transliteration: 'Maliki yawmid-din',
    meaning: 'Master of the Day of Judgement',
    audioAsset: 'assets/audio/quran_teacher/phrases/maliki_yawm_id_deen.mp3',
    lessonLink: 'phrase_fatihah_2',
    sourceReference: 'Qur’an 1:4',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_iyyaka_nabud',
    arabic: 'إِيَّاكَ نَعْبُدُ',
    transliteration: 'Iyyaka nabudu',
    meaning: 'You alone we worship',
    audioAsset: 'assets/audio/quran_teacher/phrases/iyyaka_nabud.mp3',
    lessonLink: 'phrase_fatihah_2',
    sourceReference: 'Qur’an 1:5',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_ihdina',
    arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    transliteration: 'Ihdinas-siratal-mustaqim',
    meaning: 'Guide us to the straight path',
    audioAsset: 'assets/audio/quran_teacher/phrases/ihdina_sirat.mp3',
    lessonLink: 'phrase_fatihah_2',
    sourceReference: 'Qur’an 1:6',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_qul_huwa_allahu_ahad',
    arabic: 'قُلْ هُوَ اللّٰهُ أَحَدٌ',
    transliteration: 'Qul huwa Allahu ahad',
    meaning: 'Say: He is Allah, the One',
    audioAsset: 'assets/audio/quran_teacher/phrases/qul_huwa_allahu_ahad.mp3',
    lessonLink: 'phrase_ikhlas_1',
    sourceReference: 'Qur’an 112:1',
  ),
  QuranTeacherPhraseSeed(
    id: 'phrase_allahu_samad',
    arabic: 'اللّٰهُ الصَّمَدُ',
    transliteration: 'Allahu-s-samad',
    meaning: 'Allah, the Eternal Refuge',
    audioAsset: 'assets/audio/quran_teacher/phrases/allahu_samad.mp3',
    lessonLink: 'phrase_ikhlas_1',
    sourceReference: 'Qur’an 112:2',
  ),
];

const quranTeacherSurahSeeds = <QuranTeacherSurahSeed>[
  QuranTeacherSurahSeed(
    surahId: 'surah_001',
    arabicName: 'الفاتحة',
    englishName: 'Al-Fatihah',
    transliteration: 'Al-Fatihah',
    ayahCount: 7,
    description: 'The opening surah recited every day in salah.',
    lessonEntry: 'surah_practice_fatihah',
    ayahPreview: <String>[
      'الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ',
      'مَالِكِ يَوْمِ الدِّينِ',
    ],
  ),
  QuranTeacherSurahSeed(
    surahId: 'surah_112',
    arabicName: 'الإخلاص',
    englishName: 'Al-Ikhlas',
    transliteration: 'Al-Ikhlas',
    ayahCount: 4,
    description: 'A short surah with clear repeated lines.',
    lessonEntry: 'surah_practice_ikhlas',
    ayahPreview: <String>['قُلْ هُوَ اللّٰهُ أَحَدٌ', 'اللّٰهُ الصَّمَدُ'],
  ),
  QuranTeacherSurahSeed(
    surahId: 'surah_113',
    arabicName: 'الفلق',
    englishName: 'Al-Falaq',
    transliteration: 'Al-Falaq',
    ayahCount: 5,
    description: 'Protection phrases with short repeated wording.',
    lessonEntry: 'surah_practice_protection',
    ayahPreview: <String>['مِن شَرِّ مَا خَلَقَ'],
  ),
  QuranTeacherSurahSeed(
    surahId: 'surah_114',
    arabicName: 'الناس',
    englishName: 'An-Nas',
    transliteration: 'An-Nas',
    ayahCount: 6,
    description: 'A short surah with recurring words and sounds.',
    lessonEntry: 'surah_practice_protection',
    ayahPreview: <String>['قُلْ أَعُوذُ بِرَبِّ النَّاسِ'],
  ),
  QuranTeacherSurahSeed(
    surahId: 'surah_108',
    arabicName: 'الكوثر',
    englishName: 'Al-Kawthar',
    transliteration: 'Al-Kawthar',
    ayahCount: 3,
    description: 'Very short and ideal for beginner review loops.',
    lessonEntry: 'surah_practice_protection',
    ayahPreview: <String>['إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ'],
  ),
];

const quranTeacherVisualModeSeeds = <QuranTeacherLetterSeed>[
  QuranTeacherLetterSeed(
    id: 'visual_alif',
    letter: 'ا',
    name: 'Alif',
    transliteration: 'a',
    simpleExplanation: 'Alif can be remembered with Apple.',
    exampleWord: 'أَب',
    exampleMeaning: 'father',
    exampleReference: 'Qur’an 12:4',
    audioAsset: 'assets/audio/quran_teacher/letters/alif.mp3',
    visualModeAnchorId: 'apple',
    visualHint: 'Apple helps you remember Alif.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png',
    visualIcon: Icons.filter_vintage_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_ba',
    letter: 'ب',
    name: 'Ba',
    transliteration: 'ba',
    simpleExplanation: 'Ba can be remembered with Ball.',
    exampleWord: 'بَيْت',
    exampleMeaning: 'house',
    exampleReference: 'Qur’an 2:125',
    audioAsset: 'assets/audio/quran_teacher/letters/ba.mp3',
    visualModeAnchorId: 'ball',
    visualHint: 'Ball helps you remember Ba.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png',
    visualIcon: Icons.sports_baseball_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_ta',
    letter: 'ت',
    name: 'Ta',
    transliteration: 'ta',
    simpleExplanation: 'Ta can be remembered with Tree.',
    exampleWord: 'تَابَ',
    exampleMeaning: 'He turned in repentance',
    exampleReference: 'Qur’an 2:37',
    audioAsset: 'assets/audio/quran_teacher/letters/ta.mp3',
    visualModeAnchorId: 'tree',
    visualHint: 'Tree helps you remember Ta.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png',
    visualIcon: Icons.park_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_jeem',
    letter: 'ج',
    name: 'Jeem',
    transliteration: 'jeem',
    simpleExplanation: 'Jeem can be remembered with Juice.',
    exampleWord: 'جَنَّة',
    exampleMeaning: 'garden',
    exampleReference: 'Qur’an 2:25',
    audioAsset: 'assets/audio/quran_teacher/letters/jeem.mp3',
    visualModeAnchorId: 'juice',
    visualHint: 'Juice helps you remember Jeem.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/jeem_juice.png',
    visualIcon: Icons.local_drink_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_seen',
    letter: 'س',
    name: 'Seen',
    transliteration: 'seen',
    simpleExplanation: 'Seen can be remembered with Sun.',
    exampleWord: 'سَمَاء',
    exampleMeaning: 'sky',
    exampleReference: 'Qur’an 86:1',
    audioAsset: 'assets/audio/quran_teacher/letters/seen.mp3',
    visualModeAnchorId: 'sun',
    visualHint: 'Sun helps you remember Seen.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png',
    visualIcon: Icons.wb_sunny_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_meem',
    letter: 'م',
    name: 'Meem',
    transliteration: 'meem',
    simpleExplanation: 'Meem can be remembered with Moon.',
    exampleWord: 'مَاء',
    exampleMeaning: 'water',
    exampleReference: 'Qur’an 21:30',
    audioAsset: 'assets/audio/quran_teacher/letters/meem.mp3',
    visualModeAnchorId: 'moon',
    visualHint: 'Moon helps you remember Meem.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png',
    visualIcon: Icons.nightlight_round,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_noon',
    letter: 'ن',
    name: 'Noon',
    transliteration: 'noon',
    simpleExplanation: 'Noon can be remembered with Nest.',
    exampleWord: 'نُور',
    exampleMeaning: 'light',
    exampleReference: 'Qur’an 24:35',
    audioAsset: 'assets/audio/quran_teacher/letters/noon.mp3',
    visualModeAnchorId: 'nest',
    visualHint: 'Nest helps you remember Noon.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png',
    visualIcon: Icons.egg_alt_rounded,
  ),
  QuranTeacherLetterSeed(
    id: 'visual_waw',
    letter: 'و',
    name: 'Waw',
    transliteration: 'waw',
    simpleExplanation: 'Waw can be remembered with Water.',
    exampleWord: 'وَلَد',
    exampleMeaning: 'child',
    exampleReference: 'Qur’an 112:3',
    audioAsset: 'assets/audio/quran_teacher/letters/waw.mp3',
    visualModeAnchorId: 'water',
    visualHint: 'Water helps you remember Waw.',
    visualImageAsset: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png',
    visualIcon: Icons.water_drop_rounded,
  ),
];

const quranTeacherListenItemSeeds = <QuranTeacherListenItemSeed>[
  QuranTeacherListenItemSeed(id: 'pack_alif', arabic: 'ا', transliteration: 'Alif', meaning: 'Letter Alif', audioAsset: 'assets/audio/quran_teacher/letters/alif.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png', visualHint: 'Apple', moduleId: 'foundations', lessonId: 'alphabet_letters_1'),
  QuranTeacherListenItemSeed(id: 'pack_ba', arabic: 'ب', transliteration: 'Ba', meaning: 'Letter Ba', audioAsset: 'assets/audio/quran_teacher/letters/ba.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png', visualHint: 'Ball', moduleId: 'foundations', lessonId: 'alphabet_letters_1'),
  QuranTeacherListenItemSeed(id: 'pack_ta', arabic: 'ت', transliteration: 'Ta', meaning: 'Letter Ta', audioAsset: 'assets/audio/quran_teacher/letters/ta.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png', visualHint: 'Tree', moduleId: 'foundations', lessonId: 'alphabet_letters_1'),
  QuranTeacherListenItemSeed(id: 'pack_tha', arabic: 'ث', transliteration: 'Tha', meaning: 'Letter Tha', audioAsset: 'assets/audio/quran_teacher/letters/tha.mp3', moduleId: 'foundations', lessonId: 'alphabet_letters_1'),
  QuranTeacherListenItemSeed(id: 'pack_jeem', arabic: 'ج', transliteration: 'Jeem', meaning: 'Letter Jeem', audioAsset: 'assets/audio/quran_teacher/letters/jeem.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/jeem_juice.png', visualHint: 'Juice', moduleId: 'foundations', lessonId: 'alphabet_letters_1'),
  QuranTeacherListenItemSeed(id: 'pack_haa', arabic: 'ح', transliteration: 'Haa', meaning: 'Letter Haa', audioAsset: 'assets/audio/quran_teacher/letters/haa_soft.mp3', moduleId: 'foundations', lessonId: 'alphabet_letters_2'),
  QuranTeacherListenItemSeed(id: 'pack_khaa', arabic: 'خ', transliteration: 'Khaa', meaning: 'Letter Khaa', audioAsset: 'assets/audio/quran_teacher/letters/khaa.mp3', moduleId: 'foundations', lessonId: 'alphabet_letters_2'),
  QuranTeacherListenItemSeed(id: 'pack_seen', arabic: 'س', transliteration: 'Seen', meaning: 'Letter Seen', audioAsset: 'assets/audio/quran_teacher/letters/seen.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png', visualHint: 'Sun', moduleId: 'foundations', lessonId: 'alphabet_letters_3'),
  QuranTeacherListenItemSeed(id: 'pack_meem', arabic: 'م', transliteration: 'Meem', meaning: 'Letter Meem', audioAsset: 'assets/audio/quran_teacher/letters/meem.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png', visualHint: 'Moon', moduleId: 'foundations', lessonId: 'alphabet_letters_4'),
  QuranTeacherListenItemSeed(id: 'pack_noon', arabic: 'ن', transliteration: 'Noon', meaning: 'Letter Noon', audioAsset: 'assets/audio/quran_teacher/letters/noon.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png', visualHint: 'Nest', moduleId: 'foundations', lessonId: 'alphabet_letters_4'),
  QuranTeacherListenItemSeed(id: 'pack_ba_fatha', arabic: 'بَ', transliteration: 'Ba', meaning: 'Ba with fatha', audioAsset: 'assets/audio/quran_teacher/harakat/ba_fatha.mp3', moduleId: 'foundations', lessonId: 'fatha_intro'),
  QuranTeacherListenItemSeed(id: 'pack_ba_kasra', arabic: 'بِ', transliteration: 'Bi', meaning: 'Ba with kasra', audioAsset: 'assets/audio/quran_teacher/harakat/ba_kasra.mp3', moduleId: 'foundations', lessonId: 'kasra_intro'),
  QuranTeacherListenItemSeed(id: 'pack_ba_damma', arabic: 'بُ', transliteration: 'Bu', meaning: 'Ba with damma', audioAsset: 'assets/audio/quran_teacher/harakat/ba_damma.mp3', moduleId: 'foundations', lessonId: 'damma_intro'),
  QuranTeacherListenItemSeed(id: 'pack_ta_fatha', arabic: 'تَ', transliteration: 'Ta', meaning: 'Ta with fatha', audioAsset: 'assets/audio/quran_teacher/harakat/ta_fatha.mp3', moduleId: 'foundations', lessonId: 'fatha_intro'),
  QuranTeacherListenItemSeed(id: 'pack_ta_kasra', arabic: 'تِ', transliteration: 'Ti', meaning: 'Ta with kasra', audioAsset: 'assets/audio/quran_teacher/harakat/ta_kasra.mp3', moduleId: 'foundations', lessonId: 'kasra_intro'),
  QuranTeacherListenItemSeed(id: 'pack_ta_damma', arabic: 'تُ', transliteration: 'Tu', meaning: 'Ta with damma', audioAsset: 'assets/audio/quran_teacher/harakat/ta_damma.mp3', moduleId: 'foundations', lessonId: 'damma_intro'),
  QuranTeacherListenItemSeed(id: 'pack_meem_fatha', arabic: 'مَ', transliteration: 'Ma', meaning: 'Meem with fatha', audioAsset: 'assets/audio/quran_teacher/harakat/meem_fatha.mp3', moduleId: 'foundations', lessonId: 'fatha_intro'),
  QuranTeacherListenItemSeed(id: 'pack_meem_kasra', arabic: 'مِ', transliteration: 'Mi', meaning: 'Meem with kasra', audioAsset: 'assets/audio/quran_teacher/harakat/meem_kasra.mp3', moduleId: 'foundations', lessonId: 'kasra_intro'),
  QuranTeacherListenItemSeed(id: 'pack_meem_damma', arabic: 'مُ', transliteration: 'Mu', meaning: 'Meem with damma', audioAsset: 'assets/audio/quran_teacher/harakat/meem_damma.mp3', moduleId: 'foundations', lessonId: 'damma_intro'),
  QuranTeacherListenItemSeed(id: 'pack_word_rabb', arabic: 'رَبّ', transliteration: 'Rabb', meaning: 'Lord', audioAsset: 'assets/audio/quran_teacher/words/rabb.mp3', moduleId: 'reading_basics', lessonId: 'two_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_word_min', arabic: 'مِن', transliteration: 'Min', meaning: 'From', audioAsset: 'assets/audio/quran_teacher/words/min.mp3', moduleId: 'reading_basics', lessonId: 'two_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_word_fi', arabic: 'فِي', transliteration: 'Fi', meaning: 'In', audioAsset: 'assets/audio/quran_teacher/words/fee.mp3', moduleId: 'reading_basics', lessonId: 'two_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_word_lahu', arabic: 'لَهُ', transliteration: 'Lahu', meaning: 'For him', audioAsset: 'assets/audio/quran_teacher/words/lahu.mp3', moduleId: 'reading_basics', lessonId: 'two_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_word_abd', arabic: 'عَبْد', transliteration: 'Abd', meaning: 'Servant', audioAsset: 'assets/audio/quran_teacher/words/abd.mp3', moduleId: 'reading_basics', lessonId: 'three_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_word_alima', arabic: 'عَلِمَ', transliteration: 'Alima', meaning: 'He knew', audioAsset: 'assets/audio/quran_teacher/words/ilm.mp3', moduleId: 'reading_basics', lessonId: 'three_letter_reading'),
  QuranTeacherListenItemSeed(id: 'pack_common_allah', arabic: 'اللّٰه', transliteration: 'Allah', meaning: 'Allah', audioAsset: 'assets/audio/quran_teacher/words/allah.mp3', moduleId: 'recognize_words', lessonId: 'core_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_common_rabb', arabic: 'رَبّ', transliteration: 'Rabb', meaning: 'Lord', audioAsset: 'assets/audio/quran_teacher/words/rabb.mp3', moduleId: 'recognize_words', lessonId: 'core_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_common_rahmah', arabic: 'رَحْمَة', transliteration: 'Rahmah', meaning: 'Mercy', audioAsset: 'assets/audio/quran_teacher/words/rahmah.mp3', moduleId: 'recognize_words', lessonId: 'mercy_guidance_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_common_huda', arabic: 'هُدًى', transliteration: 'Huda', meaning: 'Guidance', audioAsset: 'assets/audio/quran_teacher/words/huda.mp3', moduleId: 'recognize_words', lessonId: 'mercy_guidance_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_common_nur', arabic: 'نُور', transliteration: 'Nur', meaning: 'Light', audioAsset: 'assets/audio/quran_teacher/words/noor.mp3', moduleId: 'recognize_words', lessonId: 'core_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_common_maa', arabic: 'مَاء', transliteration: 'Maa', meaning: 'Water', audioAsset: 'assets/audio/quran_teacher/words/maa.mp3', imageAsset: 'assets/images/quran_teacher/visual_mode/words/maa_water.png', visualHint: 'Water', moduleId: 'recognize_words', lessonId: 'creation_signs_words_intro'),
  QuranTeacherListenItemSeed(id: 'pack_phrase_alhamdulillah', arabic: 'الْحَمْدُ لِلّٰهِ', transliteration: 'Al-hamdu lillah', meaning: 'All praise is for Allah', audioAsset: 'assets/audio/quran_teacher/phrases/alhamdulillah.mp3', moduleId: 'phrase_reading', lessonId: 'phrase_fatihah_1'),
  QuranTeacherListenItemSeed(id: 'pack_phrase_bismillah', arabic: 'بِسْمِ اللّٰهِ', transliteration: 'Bismillah', meaning: 'In the name of Allah', audioAsset: 'assets/audio/quran_teacher/phrases/bismillah.mp3', moduleId: 'phrase_reading', lessonId: 'phrase_fatihah_1'),
  QuranTeacherListenItemSeed(id: 'pack_phrase_rabbilalamin', arabic: 'رَبِّ الْعَالَمِينَ', transliteration: 'Rabbil alamin', meaning: 'Lord of the worlds', audioAsset: 'assets/audio/quran_teacher/phrases/rabb_al_alamin.mp3', moduleId: 'phrase_reading', lessonId: 'phrase_fatihah_1'),
];

const quranTeacherListenPackSeeds = <QuranTeacherListenPackSeed>[
  QuranTeacherListenPackSeed(
    packId: 'alphabet_basics',
    title: 'Alphabet Pack',
    description: 'The first letters for calm listening practice.',
    moduleId: 'foundations',
    category: QuranTeachingAudioPackCategory.alphabet,
    itemIds: <String>[
      'pack_alif',
      'pack_ba',
      'pack_ta',
      'pack_tha',
      'pack_jeem',
      'pack_haa',
      'pack_khaa',
      'pack_seen',
      'pack_meem',
      'pack_noon',
    ],
  ),
  QuranTeacherListenPackSeed(
    packId: 'harakat_practice',
    title: 'Harakat Pack',
    description: 'Short vowel sounds for easy repetition.',
    moduleId: 'foundations',
    category: QuranTeachingAudioPackCategory.harakat,
    itemIds: <String>[
      'pack_ba_fatha',
      'pack_ba_kasra',
      'pack_ba_damma',
      'pack_ta_fatha',
      'pack_ta_kasra',
      'pack_ta_damma',
      'pack_meem_fatha',
      'pack_meem_kasra',
      'pack_meem_damma',
    ],
  ),
  QuranTeacherListenPackSeed(
    packId: 'first_words',
    title: 'First Words Pack',
    description: 'Very short words for passive repetition.',
    moduleId: 'reading_basics',
    category: QuranTeachingAudioPackCategory.firstWords,
    itemIds: <String>[
      'pack_word_rabb',
      'pack_word_min',
      'pack_word_fi',
      'pack_word_lahu',
      'pack_word_abd',
      'pack_word_alima',
    ],
  ),
  QuranTeacherListenPackSeed(
    packId: 'common_quran_words',
    title: 'Common Qur’an Words Pack',
    description: 'Core words you will meet again and again.',
    moduleId: 'recognize_words',
    category: QuranTeachingAudioPackCategory.commonWords,
    itemIds: <String>[
      'pack_common_allah',
      'pack_common_rabb',
      'pack_common_rahmah',
      'pack_common_huda',
      'pack_common_nur',
      'pack_common_maa',
    ],
  ),
  QuranTeacherListenPackSeed(
    packId: 'phrase_pack',
    title: 'Phrase Pack',
    description: 'Short real Qur’anic phrases for calm review.',
    moduleId: 'phrase_reading',
    category: QuranTeachingAudioPackCategory.phrases,
    itemIds: <String>[
      'pack_phrase_alhamdulillah',
      'pack_phrase_bismillah',
      'pack_phrase_rabbilalamin',
    ],
  ),
];

const quranTeacherQuizSeeds = <QuranTeacherQuizSeed>[
  QuranTeacherQuizSeed(
    quizId: 'quiz_audio_letter_ba',
    quizType: QuranTeachingQuizType.audioSelectLetter,
    prompt: 'Hear the sound and choose the correct letter.',
    promptSecondary: 'Audio: Ba',
    audioAsset: 'assets/audio/quran_teacher/letters/ba.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'ba', label: 'Ba', arabic: 'ب'),
      QuranTeachingQuizOption(id: 'ta', label: 'Ta', arabic: 'ت'),
      QuranTeachingQuizOption(id: 'tha', label: 'Tha', arabic: 'ث'),
      QuranTeachingQuizOption(id: 'noon', label: 'Noon', arabic: 'ن'),
    ],
    correctAnswerIds: <String>['ba'],
    explanation: 'Ba has one dot below.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_audio_letter_meem',
    quizType: QuranTeachingQuizType.audioSelectLetter,
    prompt: 'Hear the sound and choose the correct letter.',
    promptSecondary: 'Audio: Meem',
    audioAsset: 'assets/audio/quran_teacher/letters/meem.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'meem', label: 'Meem', arabic: 'م'),
      QuranTeachingQuizOption(id: 'waw', label: 'Waw', arabic: 'و'),
      QuranTeachingQuizOption(id: 'noon', label: 'Noon', arabic: 'ن'),
      QuranTeachingQuizOption(id: 'haa', label: 'Haa', arabic: 'هـ'),
    ],
    correctAnswerIds: <String>['meem'],
    explanation: 'Meem is the round m letter.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_audio_harakah_bu',
    quizType: QuranTeachingQuizType.audioSelectHarakahForm,
    prompt: 'Hear the sound and choose the correct form.',
    promptSecondary: 'Audio: Bu',
    audioAsset: 'assets/audio/quran_teacher/harakat/ba_damma.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'ba', label: 'Ba', arabic: 'بَ'),
      QuranTeachingQuizOption(id: 'bi', label: 'Bi', arabic: 'بِ'),
      QuranTeachingQuizOption(id: 'bu', label: 'Bu', arabic: 'بُ'),
      QuranTeachingQuizOption(id: 'bstop', label: 'B', arabic: 'بْ'),
    ],
    correctAnswerIds: <String>['bu'],
    explanation: 'Damma gives the short u sound.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_audio_harakah_ti',
    quizType: QuranTeachingQuizType.audioSelectHarakahForm,
    prompt: 'Hear the sound and choose the correct form.',
    promptSecondary: 'Audio: Ti',
    audioAsset: 'assets/audio/quran_teacher/harakat/ta_kasra.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'tu', label: 'Tu', arabic: 'تُ'),
      QuranTeachingQuizOption(id: 'ti', label: 'Ti', arabic: 'تِ'),
      QuranTeachingQuizOption(id: 'ta', label: 'Ta', arabic: 'تَ'),
      QuranTeachingQuizOption(id: 'tstop', label: 'T', arabic: 'تْ'),
    ],
    correctAnswerIds: <String>['ti'],
    explanation: 'Kasra gives the short i sound.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_letter_name_seen',
    quizType: QuranTeachingQuizType.identifyLetter,
    prompt: 'What is the name of this letter?',
    promptArabic: 'س',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'seen', label: 'Seen'),
      QuranTeachingQuizOption(id: 'sheen', label: 'Sheen'),
      QuranTeachingQuizOption(id: 'saad', label: 'Saad'),
      QuranTeachingQuizOption(id: 'noon', label: 'Noon'),
    ],
    correctAnswerIds: <String>['seen'],
    explanation: 'Seen has the flowing tooth-like shape without dots.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_select_maa_sound',
    quizType: QuranTeachingQuizType.promptSelectCorrectForm,
    prompt: 'Which one says maa?',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'ma', label: 'Ma', arabic: 'مَ'),
      QuranTeachingQuizOption(id: 'mi', label: 'Mi', arabic: 'مِ'),
      QuranTeachingQuizOption(id: 'mu', label: 'Mu', arabic: 'مُ'),
      QuranTeachingQuizOption(id: 'maa', label: 'Maa', arabic: 'مَا'),
    ],
    correctAnswerIds: <String>['maa'],
    explanation: 'Maa uses alif after fatha to stretch the sound.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_visual_apple_alif',
    quizType: QuranTeachingQuizType.matchPictureToLetter,
    prompt: 'Which letter matches the Apple memory aid?',
    imageAsset: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'alif', label: 'Alif', arabic: 'ا', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png'),
      QuranTeachingQuizOption(id: 'ba', label: 'Ba', arabic: 'ب', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png'),
      QuranTeachingQuizOption(id: 'ta', label: 'Ta', arabic: 'ت', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png'),
      QuranTeachingQuizOption(id: 'jeem', label: 'Jeem', arabic: 'ج', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/jeem_juice.png'),
    ],
    correctAnswerIds: <String>['alif'],
    explanation: 'Apple is the memory aid for Alif.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_visual_moon_meem',
    quizType: QuranTeachingQuizType.matchPictureToLetter,
    prompt: 'Which letter matches the Moon memory aid?',
    imageAsset: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'meem', label: 'Meem', arabic: 'م', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png'),
      QuranTeachingQuizOption(id: 'noon', label: 'Noon', arabic: 'ن', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png'),
      QuranTeachingQuizOption(id: 'waw', label: 'Waw', arabic: 'و', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png'),
      QuranTeachingQuizOption(id: 'seen', label: 'Seen', arabic: 'س', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png'),
    ],
    correctAnswerIds: <String>['meem'],
    explanation: 'Moon is the memory aid for Meem.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_letter_to_picture_ba',
    quizType: QuranTeachingQuizType.matchLetterToPicture,
    prompt: 'Which picture matches this letter?',
    promptArabic: 'ب',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'ball', label: 'Ball', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png'),
      QuranTeachingQuizOption(id: 'tree', label: 'Tree', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png'),
      QuranTeachingQuizOption(id: 'sun', label: 'Sun', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png'),
      QuranTeachingQuizOption(id: 'moon', label: 'Moon', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png'),
    ],
    correctAnswerIds: <String>['ball'],
    explanation: 'Ba is paired with Ball as a memory aid.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_word_audio_rabb',
    quizType: QuranTeachingQuizType.wordAudio,
    prompt: 'Hear the word and choose the correct written form.',
    audioAsset: 'assets/audio/quran_teacher/words/rabb.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'rabb', label: 'Rabb', arabic: 'رَبّ'),
      QuranTeachingQuizOption(id: 'labb', label: 'Labb', arabic: 'لَبّ'),
      QuranTeachingQuizOption(id: 'tabb', label: 'Tabb', arabic: 'تَبّ'),
      QuranTeachingQuizOption(id: 'ban', label: 'Ban', arabic: 'بَن'),
    ],
    correctAnswerIds: <String>['rabb'],
    explanation: 'Rabb has the opening r sound and doubled b.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_rule_shaddah',
    quizType: QuranTeachingQuizType.ruleIdentification,
    prompt: 'What does this sign do?',
    promptArabic: 'ّ',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'silent', label: 'Makes the letter silent'),
      QuranTeachingQuizOption(id: 'double', label: 'Doubles the sound'),
      QuranTeachingQuizOption(id: 'stretch', label: 'Stretches the sound'),
      QuranTeachingQuizOption(id: 'remove_dot', label: 'Removes the dot'),
    ],
    correctAnswerIds: <String>['double'],
    explanation: 'Shaddah doubles the sound of a letter.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_rule_sukun',
    quizType: QuranTeachingQuizType.ruleIdentification,
    prompt: 'What does this sign mean?',
    promptArabic: 'ْ',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'long', label: 'Long vowel'),
      QuranTeachingQuizOption(id: 'stop', label: 'No vowel / stop'),
      QuranTeachingQuizOption(id: 'double', label: 'Double sound'),
      QuranTeachingQuizOption(id: 'tanween', label: 'Tanween'),
    ],
    correctAnswerIds: <String>['stop'],
    explanation: 'Sukun means the letter stops with no vowel.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_word_meaning_maa',
    quizType: QuranTeachingQuizType.identifyLetter,
    prompt: 'What does ماء mean?',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'water', label: 'Water'),
      QuranTeachingQuizOption(id: 'moon', label: 'Moon'),
      QuranTeachingQuizOption(id: 'night', label: 'Night'),
      QuranTeachingQuizOption(id: 'mercy', label: 'Mercy'),
    ],
    correctAnswerIds: <String>['water'],
    explanation: 'ماء means water.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_phrase_bismillah',
    quizType: QuranTeachingQuizType.wordAudio,
    prompt: 'Which phrase is this?',
    promptArabic: 'بِسْمِ اللّٰهِ',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'bismillah', label: 'Bismillah'),
      QuranTeachingQuizOption(id: 'alhamdulillah', label: 'Al-hamdu lillah'),
      QuranTeachingQuizOption(id: 'rabbilalamin', label: 'Rabbil alamin'),
      QuranTeachingQuizOption(id: 'qulhuwa', label: 'Qul huwa Allahu ahad'),
    ],
    correctAnswerIds: <String>['bismillah'],
    explanation: 'This phrase is Bismillah.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_build_min',
    quizType: QuranTeachingQuizType.tapInOrderBuildWord,
    prompt: 'Tap the pieces in order to build Min.',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'm', label: 'م'),
      QuranTeachingQuizOption(id: 'i', label: 'ِ'),
      QuranTeachingQuizOption(id: 'n', label: 'ن'),
    ],
    correctAnswerIds: <String>['ok'],
    buildOrder: <String>['م', 'ِ', 'ن'],
    explanation: 'Min is made from Meem with kasra, then Noon.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_true_false_sukun',
    quizType: QuranTeachingQuizType.trueFalse,
    prompt: 'Sukun means the letter has a short vowel sound.',
    options: <QuranTeachingQuizOption>[],
    correctAnswerIds: <String>['false'],
    truthAnswer: false,
    explanation: 'Sukun means there is no vowel sound on that letter.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_audio_letter_noon',
    quizType: QuranTeachingQuizType.audioSelectLetter,
    prompt: 'Hear the sound and choose the correct letter.',
    promptSecondary: 'Audio: Noon',
    audioAsset: 'assets/audio/quran_teacher/letters/noon.mp3',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'noon', label: 'Noon', arabic: 'ن'),
      QuranTeachingQuizOption(id: 'meem', label: 'Meem', arabic: 'م'),
      QuranTeachingQuizOption(id: 'waw', label: 'Waw', arabic: 'و'),
      QuranTeachingQuizOption(id: 'yaa', label: 'Yaa', arabic: 'ي'),
    ],
    correctAnswerIds: <String>['noon'],
    explanation: 'Noon is the n sound.',
  ),
  QuranTeacherQuizSeed(
    quizId: 'quiz_visual_water_waw',
    quizType: QuranTeachingQuizType.matchPictureToLetter,
    prompt: 'Which letter matches the Water memory aid?',
    imageAsset: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png',
    options: <QuranTeachingQuizOption>[
      QuranTeachingQuizOption(id: 'waw', label: 'Waw', arabic: 'و', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png'),
      QuranTeachingQuizOption(id: 'noon', label: 'Noon', arabic: 'ن', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png'),
      QuranTeachingQuizOption(id: 'meem', label: 'Meem', arabic: 'م', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png'),
      QuranTeachingQuizOption(id: 'ba', label: 'Ba', arabic: 'ب', imageAssetPath: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png'),
    ],
    correctAnswerIds: <String>['waw'],
    explanation: 'Water is the memory aid for Waw.',
  ),
];

QuranTeachingCatalog buildQuranTeachingCatalog() {
  const modules = <QuranTeachingModule>[
    QuranTeachingModule(
      id: 'foundations',
      title: 'Foundations',
      subtitle: 'Letters, shapes, and first sounds.',
      description:
          'Start with the Arabic alphabet, letter shapes, harakat, and long vowels.',
      type: QuranTeachingModuleType.foundations,
      order: 0,
      icon: Icons.text_fields_rounded,
      color: Color(0xFF6D8B74),
      lessonIds: <String>[
        'alphabet_letters_1',
        'alphabet_letters_2',
        'alphabet_letters_3',
        'alphabet_letters_4',
        'letter_shapes_core',
        'fatha_intro',
        'kasra_intro',
        'damma_intro',
        'long_vowels_intro',
      ],
    ),
    QuranTeachingModule(
      id: 'reading_basics',
      title: 'Reading Basics',
      subtitle: 'Blend small sounds into words.',
      description:
          'Practice short words, sukun, shaddah, and tanween in gentle steps.',
      type: QuranTeachingModuleType.readingBasics,
      order: 1,
      icon: Icons.merge_type_rounded,
      color: Color(0xFF6E7F9D),
      lessonIds: <String>[
        'two_letter_reading',
        'three_letter_reading',
        'sukun_intro',
        'shaddah_intro',
        'tanween_intro',
      ],
    ),
    QuranTeachingModule(
      id: 'reading_rules',
      title: 'Reading Rules',
      subtitle: 'A light first look at common patterns.',
      description:
          'Meet sun and moon letters, hamzah, alif maqsurah, and silent letters.',
      type: QuranTeachingModuleType.readingRules,
      order: 2,
      icon: Icons.rule_rounded,
      color: Color(0xFF8B7A63),
      lessonIds: <String>[
        'sun_moon_letters_intro',
        'hamzah_intro',
        'alif_maqsurah_intro',
        'silent_letters_intro',
      ],
    ),
    QuranTeachingModule(
      id: 'tajweed_basics',
      title: 'Tajweed Basics',
      subtitle: 'Starter tajweed without overload.',
      description:
          'A calm first introduction to qalqalah, ghunnah, and noon saakin.',
      type: QuranTeachingModuleType.tajweedBasics,
      order: 3,
      icon: Icons.graphic_eq_rounded,
      color: Color(0xFF7A6D8B),
      lessonIds: <String>[
        'qalqalah_intro',
        'ghunnah_intro',
        'noon_saakin_intro',
      ],
    ),
    QuranTeachingModule(
      id: 'recognize_words',
      title: 'Recognize Qur’an Words',
      subtitle: 'The first 100 Qur’an words.',
      description:
          'A starter bank of common Qur’an words grouped into practical categories.',
      type: QuranTeachingModuleType.recognizeWords,
      order: 4,
      icon: Icons.auto_awesome_mosaic_rounded,
      color: Color(0xFF5F8F87),
      lessonIds: <String>[
        'core_words_intro',
        'worship_words_intro',
        'mercy_words_intro',
        'creation_words_intro',
        'hereafter_words_intro',
        'connector_words_intro',
      ],
    ),
    QuranTeachingModule(
      id: 'phrase_reading',
      title: 'Phrase Reading',
      subtitle: 'Short real Qur’anic phrases.',
      description:
          'Practice short phrases you already hear often in recitation and salah.',
      type: QuranTeachingModuleType.phraseReading,
      order: 5,
      icon: Icons.short_text_rounded,
      color: Color(0xFF4F7D73),
      lessonIds: <String>[
        'phrase_fatihah_1',
        'phrase_fatihah_2',
        'phrase_ikhlas_1',
      ],
    ),
    QuranTeachingModule(
      id: 'surah_practice',
      title: 'Surah Practice',
      subtitle: 'Starter short surahs.',
      description:
          'Begin with familiar short surahs using an audio-ready practice structure.',
      type: QuranTeachingModuleType.surahPractice,
      order: 6,
      icon: Icons.menu_book_rounded,
      color: Color(0xFF5E6A7E),
      lessonIds: <String>[
        'surah_practice_fatihah',
        'surah_practice_ikhlas',
        'surah_practice_protection',
      ],
    ),
  ];

  final alphabetLessons = <QuranTeachingLesson>[
    _alphabetLesson(
      id: 'alphabet_letters_1',
      title: 'Alphabet 1: Alif to Khaa',
      subtitle: 'The first seven letters.',
      order: 0,
      letters: quranTeacherAlphabetSeeds.sublist(0, 7),
      quizIds: <String>['quiz_audio_letter_ba', 'quiz_visual_apple_alif'],
    ),
    _alphabetLesson(
      id: 'alphabet_letters_2',
      title: 'Alphabet 2: Daal to Seen',
      subtitle: 'The next six letters.',
      order: 1,
      letters: quranTeacherAlphabetSeeds.sublist(7, 13),
      quizIds: <String>['quiz_letter_name_seen'],
    ),
    _alphabetLesson(
      id: 'alphabet_letters_3',
      title: 'Alphabet 3: Sheen to Ghayn',
      subtitle: 'A group of heavier and deeper sounds.',
      order: 2,
      letters: quranTeacherAlphabetSeeds.sublist(12, 19),
      quizIds: <String>[],
    ),
    _alphabetLesson(
      id: 'alphabet_letters_4',
      title: 'Alphabet 4: Faa to Yaa',
      subtitle: 'The final group of letters.',
      order: 3,
      letters: quranTeacherAlphabetSeeds.sublist(19, 28),
      quizIds: <String>['quiz_audio_letter_meem', 'quiz_visual_moon_meem', 'quiz_visual_water_waw'],
    ),
  ];

  final shapeLesson = QuranTeachingLesson(
    id: 'letter_shapes_core',
    moduleId: 'foundations',
    title: 'Letter Shapes',
    subtitle: 'How letters change shape in words.',
    summary: 'See isolated, beginning, middle, and end forms.',
    kind: QuranTeachingLessonKind.standard,
    order: 4,
    estimatedSeconds: 40,
    searchTerms: <String>['letter shapes', 'initial', 'medial', 'final'],
    steps: quranTeacherLetterShapeSeeds
        .map(
          (shape) => QuranTeachingStep(
            id: shape.id,
            title: 'Shape of ${shape.letter}',
            type: QuranTeachingStepType.letterShapes,
            focusArabic:
                '${shape.isolated} / ${shape.initial} / ${shape.medial} / ${shape.finalForm}',
            explanation:
                'This letter changes shape as it moves through the word.',
          ),
        )
        .toList(growable: false),
    quizzes: const <QuranTeachingQuizItem>[],
  );

  final harakatLessons = <QuranTeachingLesson>[
    _harakahLesson(
      id: 'fatha_intro',
      title: 'Fatha',
      subtitle: 'Fatha gives an a sound.',
      order: 5,
      focusArabic: 'بَ  تَ  مَ',
      transliteration: 'Ba • Ta • Ma',
      explanation: 'Fatha gives the letter an a sound.',
      exampleIds: <String>['pack_ba_fatha', 'pack_ta_fatha', 'pack_meem_fatha'],
      quizIds: <String>['quiz_select_maa_sound'],
    ),
    _harakahLesson(
      id: 'kasra_intro',
      title: 'Kasra',
      subtitle: 'Kasra gives an i sound.',
      order: 6,
      focusArabic: 'بِ  تِ  مِ',
      transliteration: 'Bi • Ti • Mi',
      explanation: 'Kasra gives the letter an i sound.',
      exampleIds: <String>['pack_ba_kasra', 'pack_ta_kasra', 'pack_meem_kasra'],
      quizIds: <String>['quiz_audio_harakah_ti'],
    ),
    _harakahLesson(
      id: 'damma_intro',
      title: 'Damma',
      subtitle: 'Damma gives a u sound.',
      order: 7,
      focusArabic: 'بُ  تُ  مُ',
      transliteration: 'Bu • Tu • Mu',
      explanation: 'Damma gives the letter a u sound.',
      exampleIds: <String>['pack_ba_damma', 'pack_ta_damma', 'pack_meem_damma'],
      quizIds: <String>['quiz_audio_harakah_bu'],
    ),
    QuranTeachingLesson(
      id: 'long_vowels_intro',
      moduleId: 'foundations',
      title: 'Long Vowels',
      subtitle: 'Stretch the sound a little longer.',
      summary: 'Meet alif after fatha, yaa after kasra, and waw after damma.',
      kind: QuranTeachingLessonKind.standard,
      order: 8,
      estimatedSeconds: 35,
      searchTerms: <String>['long vowels', 'baa', 'bii', 'buu'],
      steps: const <QuranTeachingStep>[
        QuranTeachingStep(
          id: 'long_a',
          title: 'Alif after fatha',
          type: QuranTeachingStepType.harakat,
          focusArabic: 'بَا',
          transliteration: 'Baa',
          explanation: 'The sound is stretched a little longer.',
        ),
        QuranTeachingStep(
          id: 'long_i',
          title: 'Yaa after kasra',
          type: QuranTeachingStepType.harakat,
          focusArabic: 'بِي',
          transliteration: 'Bii',
          explanation: 'The sound is stretched a little longer.',
        ),
        QuranTeachingStep(
          id: 'long_u',
          title: 'Waw after damma',
          type: QuranTeachingStepType.harakat,
          focusArabic: 'بُو',
          transliteration: 'Buu',
          explanation: 'The sound is stretched a little longer.',
        ),
      ],
      quizzes: const <QuranTeachingQuizItem>[],
    ),
  ];

  final readingBasicsLessons = <QuranTeachingLesson>[
    QuranTeachingLesson(
      id: 'two_letter_reading',
      moduleId: 'reading_basics',
      title: 'Two-Letter Reading',
      subtitle: 'Start blending short words.',
      summary: 'Read short combinations slowly and clearly.',
      kind: QuranTeachingLessonKind.standard,
      order: 0,
      estimatedSeconds: 35,
      searchTerms: const <String>['rab', 'min', 'fi', 'lan', 'lahu', 'bihi'],
      steps: <QuranTeachingStep>[
        QuranTeachingStep(
          id: 'two_letter_examples',
          title: 'Short reading examples',
          type: QuranTeachingStepType.wordFormation,
          focusArabic: quranTeacherTwoLetterSeeds.map((e) => e.arabic).join('  '),
          explanation: 'Take each word calmly. One sound at a time is enough.',
          examples: quranTeacherTwoLetterSeeds
              .map(
                (entry) => QuranTeachingExample(
                  arabic: entry.arabic,
                  transliteration: entry.transliteration,
                  meaning: entry.meaning,
                  audio: _audioFromPath(entry.id, entry.transliteration, entry.audioAsset),
                  verseReference: entry.verseReference,
                ),
              )
              .toList(growable: false),
        ),
      ],
      quizzes: _quizList(const <String>['quiz_word_audio_rabb', 'quiz_build_min']),
    ),
    QuranTeachingLesson(
      id: 'three_letter_reading',
      moduleId: 'reading_basics',
      title: 'Three-Letter Reading',
      subtitle: 'Read simple three-letter words.',
      summary: 'These words help reading comfort grow without heavy grammar.',
      kind: QuranTeachingLessonKind.standard,
      order: 1,
      estimatedSeconds: 35,
      searchTerms: const <String>['kataba', 'abd', 'alima', 'khalaqa', 'samia'],
      steps: <QuranTeachingStep>[
        QuranTeachingStep(
          id: 'three_letter_examples',
          title: 'Three-letter examples',
          type: QuranTeachingStepType.wordFormation,
          focusArabic:
              quranTeacherThreeLetterSeeds.map((e) => e.arabic).join('  '),
          explanation:
              'Read each word gently. You do not need grammar first to start reading.',
          examples: quranTeacherThreeLetterSeeds
              .map(
                (entry) => QuranTeachingExample(
                  arabic: entry.arabic,
                  transliteration: entry.transliteration,
                  meaning: entry.meaning,
                  audio: _audioFromPath(entry.id, entry.transliteration, entry.audioAsset),
                  verseReference: entry.verseReference,
                ),
              )
              .toList(growable: false),
        ),
      ],
      quizzes: const <QuranTeachingQuizItem>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'sukun_intro',
      order: 2,
      seed: quranTeacherRuleSeeds[0],
      quizIds: <String>['quiz_rule_sukun', 'quiz_true_false_sukun'],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'shaddah_intro',
      order: 3,
      seed: quranTeacherRuleSeeds[1],
      quizIds: <String>['quiz_rule_shaddah'],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'tanween_intro',
      order: 4,
      seed: quranTeacherRuleSeeds[2],
      quizIds: const <String>[],
    ),
  ];

  final readingRuleLessons = <QuranTeachingLesson>[
    QuranTeachingLesson(
      id: 'sun_moon_letters_intro',
      moduleId: 'reading_rules',
      title: 'Sun and Moon Letters',
      subtitle: 'What happens to ال at the beginning.',
      summary: 'Some letters blend the l sound and some keep it clear.',
      kind: QuranTeachingLessonKind.standard,
      order: 0,
      estimatedSeconds: 35,
      searchTerms: const <String>['sun letters', 'moon letters', 'ash-shams', 'al-qamar'],
      steps: <QuranTeachingStep>[
        _ruleStepFromSeed(quranTeacherRuleSeeds[3]),
        _ruleStepFromSeed(quranTeacherRuleSeeds[4]),
      ],
      quizzes: const <QuranTeachingQuizItem>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'hamzah_intro',
      order: 1,
      seed: quranTeacherRuleSeeds[5],
      quizIds: const <String>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'alif_maqsurah_intro',
      order: 2,
      seed: quranTeacherRuleSeeds[6],
      quizIds: const <String>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'silent_letters_intro',
      order: 3,
      seed: quranTeacherRuleSeeds[7],
      quizIds: const <String>[],
    ),
  ];

  final tajweedLessons = <QuranTeachingLesson>[
    _ruleLessonAsTeachingLesson(
      lessonId: 'qalqalah_intro',
      order: 0,
      seed: quranTeacherTajweedSeeds[0],
      moduleId: 'tajweed_basics',
      quizIds: const <String>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'ghunnah_intro',
      order: 1,
      seed: quranTeacherTajweedSeeds[1],
      moduleId: 'tajweed_basics',
      quizIds: const <String>[],
    ),
    _ruleLessonAsTeachingLesson(
      lessonId: 'noon_saakin_intro',
      order: 2,
      seed: quranTeacherTajweedSeeds[2],
      moduleId: 'tajweed_basics',
      quizIds: const <String>[],
    ),
  ];

  final wordLessons = <QuranTeachingLesson>[
    _wordLesson('core_words_intro', 0, 'core', 'Core Words'),
    _wordLesson('worship_words_intro', 1, 'worship', 'Worship Words'),
    _wordLesson('mercy_words_intro', 2, 'mercy', 'Mercy Words'),
    _wordLesson('creation_words_intro', 3, 'creation', 'Creation Words'),
    _wordLesson('hereafter_words_intro', 4, 'hereafter', 'Hereafter Words'),
    _wordLesson('connector_words_intro', 5, 'connector', 'Connector Words'),
  ];

  final phraseLessons = <QuranTeachingLesson>[
    _phraseLesson(
      id: 'phrase_fatihah_1',
      order: 0,
      title: 'Phrases from Al-Fatihah 1',
      subtitle: 'Short familiar phrases.',
      phraseIds: const <String>[
        'phrase_alhamdulillah',
        'phrase_rabb_alamin',
        'phrase_bismillah',
      ],
      quizIds: const <String>['quiz_phrase_bismillah'],
    ),
    _phraseLesson(
      id: 'phrase_fatihah_2',
      order: 1,
      title: 'Phrases from Al-Fatihah 2',
      subtitle: 'More short familiar phrases.',
      phraseIds: const <String>[
        'phrase_maliki_yawmiddin',
        'phrase_iyyaka_nabud',
        'phrase_ihdina',
      ],
      quizIds: const <String>[],
    ),
    _phraseLesson(
      id: 'phrase_ikhlas_1',
      order: 2,
      title: 'Phrases from Al-Ikhlas',
      subtitle: 'Two short powerful lines.',
      phraseIds: const <String>[
        'phrase_qul_huwa_allahu_ahad',
        'phrase_allahu_samad',
      ],
      quizIds: const <String>[],
    ),
  ];

  final surahLessons = <QuranTeachingLesson>[
    _surahLesson(
      id: 'surah_practice_fatihah',
      order: 0,
      surahIds: const <String>['surah_001'],
      title: 'Surah Practice: Al-Fatihah',
      subtitle: 'A beginner-friendly practice entry.',
    ),
    _surahLesson(
      id: 'surah_practice_ikhlas',
      order: 1,
      surahIds: const <String>['surah_112'],
      title: 'Surah Practice: Al-Ikhlas',
      subtitle: 'Short, clear, repeatable lines.',
    ),
    _surahLesson(
      id: 'surah_practice_protection',
      order: 2,
      surahIds: const <String>['surah_113', 'surah_114', 'surah_108'],
      title: 'Surah Practice: Al-Falaq, An-Nas, Al-Kawthar',
      subtitle: 'A grouped starter shelf for short surahs.',
    ),
  ];

  final lessons = <QuranTeachingLesson>[
    ...alphabetLessons,
    shapeLesson,
    ...harakatLessons,
    ...readingBasicsLessons,
    ...readingRuleLessons,
    ...tajweedLessons,
    ...wordLessons,
    ...phraseLessons,
    ...surahLessons,
  ];

  final wordGroups = _buildWordGroups();
  final surahEntries = _buildSurahPracticeEntries();
  final audioPacks = _buildListenOnlyPacks();

  final enrichedModules = modules.map((module) {
    if (module.id == 'recognize_words') {
      return QuranTeachingModule(
        id: module.id,
        title: module.title,
        subtitle: module.subtitle,
        description: module.description,
        type: module.type,
        order: module.order,
        icon: module.icon,
        color: module.color,
        lessonIds: module.lessonIds,
        wordGroups: wordGroups,
      );
    }
    if (module.id == 'surah_practice') {
      return QuranTeachingModule(
        id: module.id,
        title: module.title,
        subtitle: module.subtitle,
        description: module.description,
        type: module.type,
        order: module.order,
        icon: module.icon,
        color: module.color,
        lessonIds: module.lessonIds,
        surahPractice: surahEntries,
      );
    }
    return module;
  }).toList(growable: false);

  return QuranTeachingCatalog(
    modules: enrichedModules,
    lessons: lessons,
    audioPracticePacks: audioPacks,
  );
}

QuranTeachingLesson _alphabetLesson({
  required String id,
  required String title,
  required String subtitle,
  required int order,
  required List<QuranTeacherLetterSeed> letters,
  required List<String> quizIds,
}) {
  return QuranTeachingLesson(
    id: id,
    moduleId: 'foundations',
    title: title,
    subtitle: subtitle,
    summary: 'Meet these letters with gentle explanations and examples.',
    kind: QuranTeachingLessonKind.standard,
    order: order,
    estimatedSeconds: 40,
    searchTerms: letters.map((e) => e.name.toLowerCase()).toList(growable: false),
    steps: letters.map(_letterStepFromSeed).toList(growable: false),
    quizzes: _quizList(quizIds),
  );
}

QuranTeachingStep _letterStepFromSeed(QuranTeacherLetterSeed seed) {
  final anchor = seed.visualModeAnchorId == null
      ? null
      : QuranVisualAnchor(
          label: seed.visualModeAnchorId![0].toUpperCase() +
              seed.visualModeAnchorId!.substring(1),
          hint: seed.visualHint ?? '',
          icon: seed.visualIcon ?? Icons.image_rounded,
          imageAssetPath: seed.visualImageAsset,
        );
  return QuranTeachingStep(
    id: seed.id,
    title: seed.name,
    type: QuranTeachingStepType.letterIntroduction,
    focusArabic: seed.letter,
    explanation: seed.simpleExplanation,
    transliteration: seed.transliteration,
    audio: _audioFromPath(seed.id, seed.name, seed.audioAsset),
    visualAnchor: anchor,
    sourceReference: seed.exampleReference,
    examples: <QuranTeachingExample>[
      QuranTeachingExample(
        arabic: seed.exampleWord,
        meaning: seed.exampleMeaning,
        note: 'Qur’anic example for ${seed.name}',
        verseReference: seed.exampleReference,
      ),
    ],
  );
}

QuranTeachingLesson _harakahLesson({
  required String id,
  required String title,
  required String subtitle,
  required int order,
  required String focusArabic,
  required String transliteration,
  required String explanation,
  required List<String> exampleIds,
  required List<String> quizIds,
}) {
  final examples = exampleIds
      .map(_listenItemById)
      .whereType<QuranTeacherListenItemSeed>()
      .map(
        (entry) => QuranTeachingExample(
          arabic: entry.arabic,
          transliteration: entry.transliteration,
          meaning: entry.meaning,
          audio: _audioFromPath(entry.id, entry.transliteration, entry.audioAsset),
        ),
      )
      .toList(growable: false);
  return QuranTeachingLesson(
    id: id,
    moduleId: 'foundations',
    title: title,
    subtitle: subtitle,
    summary: explanation,
    kind: QuranTeachingLessonKind.standard,
    order: order,
    estimatedSeconds: 30,
    searchTerms: <String>[title.toLowerCase()],
    steps: <QuranTeachingStep>[
      QuranTeachingStep(
        id: '${id}_step',
        title: title,
        type: QuranTeachingStepType.harakat,
        focusArabic: focusArabic,
        transliteration: transliteration,
        explanation: explanation,
        examples: examples,
      ),
    ],
    quizzes: _quizList(quizIds),
  );
}

QuranTeachingStep _ruleStepFromSeed(QuranTeacherRuleSeed seed) {
  return QuranTeachingStep(
    id: seed.id,
    title: seed.title,
    type: QuranTeachingStepType.rule,
    focusArabic: seed.examples.join('  '),
    explanation: seed.simpleExplanation,
    audio: _audioFromPath(seed.id, seed.title, seed.audioAsset),
    sourceReference: seed.exampleSourceReferences.join(' • '),
    examples: List<QuranTeachingExample>.generate(
      seed.examples.length,
      (index) => QuranTeachingExample(
        arabic: seed.examples[index],
        verseReference: seed.exampleSourceReferences[index],
      ),
      growable: false,
    ),
  );
}

QuranTeachingLesson _ruleLessonAsTeachingLesson({
  required String lessonId,
  required int order,
  required QuranTeacherRuleSeed seed,
  String moduleId = 'reading_basics',
  List<String> quizIds = const <String>[],
}) {
  return QuranTeachingLesson(
    id: lessonId,
    moduleId: moduleId,
    title: seed.title,
    subtitle: seed.simpleExplanation,
    summary: seed.simpleExplanation,
    kind: QuranTeachingLessonKind.standard,
    order: order,
    estimatedSeconds: 28,
    searchTerms: <String>[seed.title.toLowerCase()],
    steps: <QuranTeachingStep>[_ruleStepFromSeed(seed)],
    quizzes: _quizList(quizIds),
  );
}

QuranTeachingLesson _wordLesson(
  String id,
  int order,
  String category,
  String title,
) {
  final words = quranTeacherFirst100Words
      .where((word) => word.category == category)
      .toList(growable: false);
  return QuranTeachingLesson(
    id: id,
    moduleId: 'recognize_words',
    title: title,
    subtitle: _wordCategorySubtitles[category]!,
    summary: 'Learn a first set of $title in calm small steps.',
    kind: QuranTeachingLessonKind.words,
    order: order,
    estimatedSeconds: 35,
    searchTerms: words.map((e) => e.transliteration.toLowerCase()).toList(growable: false),
    steps: <QuranTeachingStep>[
      QuranTeachingStep(
        id: '${id}_step',
        title: title,
        type: QuranTeachingStepType.wordFormation,
        focusArabic: words.take(8).map((e) => e.word).join('  '),
        explanation: 'These are useful words to see often.',
        examples: words
            .take(8)
            .map(
              (word) => QuranTeachingExample(
                arabic: word.word,
                transliteration: word.transliteration,
                meaning: word.meaning,
                audio: _audioFromPath(word.id, word.transliteration, word.audioAsset),
                verseReference: word.exampleVerse,
                imageAssetPath: word.imageAsset,
              ),
            )
            .toList(growable: false),
      ),
    ],
    quizzes: id == 'core_words_intro'
        ? _quizList(const <String>['quiz_word_meaning_maa'])
        : const <QuranTeachingQuizItem>[],
  );
}

QuranTeachingLesson _phraseLesson({
  required String id,
  required int order,
  required String title,
  required String subtitle,
  required List<String> phraseIds,
  required List<String> quizIds,
}) {
  final phrases = phraseIds
      .map(_phraseById)
      .whereType<QuranTeacherPhraseSeed>()
      .toList(growable: false);
  return QuranTeachingLesson(
    id: id,
    moduleId: 'phrase_reading',
    title: title,
    subtitle: subtitle,
    summary: 'Read short real Qur’anic phrases with calm repetition.',
    kind: QuranTeachingLessonKind.standard,
    order: order,
    estimatedSeconds: 35,
    searchTerms: phrases
        .map((e) => e.transliteration.toLowerCase())
        .toList(growable: false),
    steps: phrases
        .map(
          (phrase) => QuranTeachingStep(
            id: phrase.id,
            title: phrase.transliteration,
            type: QuranTeachingStepType.phrase,
            focusArabic: phrase.arabic,
            transliteration: phrase.transliteration,
            explanation: phrase.meaning,
            audio: _audioFromPath(phrase.id, phrase.transliteration, phrase.audioAsset),
            sourceReference: phrase.sourceReference,
          ),
        )
        .toList(growable: false),
    quizzes: _quizList(quizIds),
  );
}

QuranTeachingLesson _surahLesson({
  required String id,
  required int order,
  required List<String> surahIds,
  required String title,
  required String subtitle,
}) {
  final surahs = surahIds
      .map(_surahById)
      .whereType<QuranTeacherSurahSeed>()
      .toList(growable: false);
  return QuranTeachingLesson(
    id: id,
    moduleId: 'surah_practice',
    title: title,
    subtitle: subtitle,
    summary: 'Use short surahs for gentle repetition and phrase review.',
    kind: QuranTeachingLessonKind.surah,
    order: order,
    estimatedSeconds: 40,
    searchTerms: surahs
        .map((e) => e.transliteration.toLowerCase())
        .toList(growable: false),
    steps: surahs
        .map(
          (surah) => QuranTeachingStep(
            id: surah.surahId,
            title: surah.englishName,
            type: QuranTeachingStepType.phrase,
            focusArabic: surah.ayahPreview.join('\n'),
            transliteration: surah.transliteration,
            explanation: surah.description,
          ),
        )
        .toList(growable: false),
    quizzes: const <QuranTeachingQuizItem>[],
  );
}

List<QuranTeachingQuizItem> _quizList(List<String> ids) {
  return ids
      .map(_quizById)
      .whereType<QuranTeacherQuizSeed>()
      .map(
        (quiz) => QuranTeachingQuizItem(
          id: quiz.quizId,
          type: quiz.quizType,
          prompt: quiz.prompt,
          promptArabic: quiz.promptArabic,
          promptSecondary: quiz.promptSecondary,
          audio: quiz.audioAsset == null
              ? null
              : _audioFromPath(quiz.quizId, quiz.prompt, quiz.audioAsset!),
          promptImageAssetPath: quiz.imageAsset,
          options: quiz.options,
          correctOptionIds: quiz.correctAnswerIds,
          buildOrder: quiz.buildOrder,
          truthAnswer: quiz.truthAnswer,
          feedbackCorrect: 'Correct! ${quiz.explanation}',
          feedbackIncorrect: 'Not quite. ${quiz.explanation}',
        ),
      )
      .toList(growable: false);
}

QuranAudioCue _audioFromPath(String id, String label, String assetPath) {
  return QuranAudioCue(
    id: id,
    label: label,
    assetPath: assetPath,
    fallbackTextLabel: label,
  );
}

QuranTeacherListenItemSeed? _listenItemById(String id) {
  for (final item in quranTeacherListenItemSeeds) {
    if (item.id == id) return item;
  }
  return null;
}

QuranTeacherPhraseSeed? _phraseById(String id) {
  for (final phrase in quranTeacherPhraseSeeds) {
    if (phrase.id == id) return phrase;
  }
  return null;
}

QuranTeacherSurahSeed? _surahById(String id) {
  for (final surah in quranTeacherSurahSeeds) {
    if (surah.surahId == id) return surah;
  }
  return null;
}

QuranTeacherQuizSeed? _quizById(String id) {
  for (final quiz in quranTeacherQuizSeeds) {
    if (quiz.quizId == id) return quiz;
  }
  return null;
}

List<QuranWordGroup> _buildWordGroups() {
  return _wordCategoryTitles.entries.map((entry) {
    final words = quranTeacherFirst100Words
        .where((word) => word.category == entry.key)
        .map(
          (word) => QuranWordEntry(
            id: word.id,
            arabic: word.word,
            transliteration: word.transliteration,
            meaning: word.meaning,
            frequencyLabel: word.frequencyHint ?? 'Common Qur’an word',
            audio: _audioFromPath(word.id, word.transliteration, word.audioAsset),
            exampleReference: word.exampleVerse,
            imageAssetPath: word.imageAsset,
            categoryTag: word.category,
          ),
        )
        .toList(growable: false);
    return QuranWordGroup(
      id: entry.key,
      title: entry.value,
      subtitle: _wordCategorySubtitles[entry.key]!,
      words: words,
    );
  }).toList(growable: false);
}

List<QuranSurahPracticeEntry> _buildSurahPracticeEntries() {
  return quranTeacherSurahSeeds
      .map(
        (surah) => QuranSurahPracticeEntry(
          id: surah.surahId,
          surahNumber: int.parse(surah.surahId.split('_')[1]),
          title: surah.englishName,
          arabicTitle: surah.arabicName,
          transliteration: surah.transliteration,
          subtitle: surah.description,
          verseCount: surah.ayahCount,
          focus: 'Beginner-friendly surah practice',
          ayahPreview: surah.ayahPreview,
        ),
      )
      .toList(growable: false);
}

List<QuranTeachingAudioPracticePack> _buildListenOnlyPacks() {
  return quranTeacherListenPackSeeds
      .map(
        (pack) => QuranTeachingAudioPracticePack(
          id: pack.packId,
          title: pack.title,
          description: pack.description,
          category: pack.category,
          moduleId: pack.moduleId,
          items: pack.itemIds
              .map(_listenItemById)
              .whereType<QuranTeacherListenItemSeed>()
              .map(
                (item) => QuranTeachingAudioPracticeItem(
                  id: item.id,
                  audio: _audioFromPath(item.id, item.transliteration, item.audioAsset),
                  arabic: item.arabic,
                  transliteration: item.transliteration,
                  meaning: item.meaning,
                  visualAnchor: item.visualHint == null
                      ? null
                      : QuranVisualAnchor(
                          label: item.visualHint!,
                          hint: item.visualHint!,
                          icon: Icons.image_rounded,
                          imageAssetPath: item.imageAsset,
                        ),
                  imageAssetPath: item.imageAsset,
                  tags: <String>[pack.category.name],
                  sourceLessonId: item.lessonId,
                  sourceModuleId: item.moduleId,
                ),
              )
              .toList(growable: false),
        ),
      )
      .toList(growable: false);
}
