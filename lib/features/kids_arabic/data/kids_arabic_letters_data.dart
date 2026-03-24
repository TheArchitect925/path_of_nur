import 'package:flutter/material.dart';

import '../../arabic/data/arabic_alphabet_catalog.dart';
import '../domain/kids_arabic_models.dart';

class _KidsArabicLetterContent {
  const _KidsArabicLetterContent({
    required this.strokeCount,
    required this.exampleWord,
    required this.exampleWordAr,
    required this.exampleWordEn,
    required this.childFriendlyLine,
  });

  final int strokeCount;
  final String exampleWord;
  final String exampleWordAr;
  final String exampleWordEn;
  final String childFriendlyLine;
}

const _kidsArabicLetterContentById = <String, _KidsArabicLetterContent>{
  'alif': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'allah',
    exampleWordAr: 'الله',
    exampleWordEn: 'Allah',
    childFriendlyLine: 'Alif reminds us of Allah.',
  ),
  'ba': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'bismillah',
    exampleWordAr: 'بسم الله',
    exampleWordEn: 'Bismillah',
    childFriendlyLine: 'Ba begins Bismillah.',
  ),
  'ta': _KidsArabicLetterContent(
    strokeCount: 3,
    exampleWord: 'taqwa',
    exampleWordAr: 'تقوى',
    exampleWordEn: 'Taqwa',
    childFriendlyLine: 'Ta reminds us of taqwa.',
  ),
  'tha': _KidsArabicLetterContent(
    strokeCount: 4,
    exampleWord: 'thawab',
    exampleWordAr: 'ثواب',
    exampleWordEn: 'Thawab',
    childFriendlyLine: 'Tha reminds us of thawab.',
  ),
  'jim': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'jannah',
    exampleWordAr: 'جنة',
    exampleWordEn: 'Jannah',
    childFriendlyLine: 'Jeem reminds us of Jannah.',
  ),
  'ha': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'halal',
    exampleWordAr: 'حلال',
    exampleWordEn: 'Halal',
    childFriendlyLine: 'Ha reminds us of halal.',
  ),
  'kha': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'khayr',
    exampleWordAr: 'خير',
    exampleWordEn: 'Khayr',
    childFriendlyLine: 'Kha reminds us of khayr.',
  ),
  'dal': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'deen',
    exampleWordAr: 'دين',
    exampleWordEn: 'Deen',
    childFriendlyLine: 'Dal reminds us of deen.',
  ),
  'dhal': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'dhikr',
    exampleWordAr: 'ذكر',
    exampleWordEn: 'Dhikr',
    childFriendlyLine: 'Dhal reminds us of dhikr.',
  ),
  'ra': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'rahmah',
    exampleWordAr: 'رحمة',
    exampleWordEn: 'Rahmah',
    childFriendlyLine: 'Ra reminds us of rahmah.',
  ),
  'zay': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'zakah',
    exampleWordAr: 'زكاة',
    exampleWordEn: 'Zakah',
    childFriendlyLine: 'Zay reminds us of zakah.',
  ),
  'seen': _KidsArabicLetterContent(
    strokeCount: 3,
    exampleWord: 'sujood',
    exampleWordAr: 'سجود',
    exampleWordEn: 'Sujood',
    childFriendlyLine: 'Seen reminds us of sujood.',
  ),
  'sheen': _KidsArabicLetterContent(
    strokeCount: 4,
    exampleWord: 'shukr',
    exampleWordAr: 'شكر',
    exampleWordEn: 'Shukr',
    childFriendlyLine: 'Sheen reminds us of shukr.',
  ),
  'sad': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'salah',
    exampleWordAr: 'صلاة',
    exampleWordEn: 'Salah',
    childFriendlyLine: 'Sad reminds us of salah.',
  ),
  'dad': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'diya',
    exampleWordAr: 'ضياء',
    exampleWordEn: 'Light',
    childFriendlyLine: 'Dad reminds us of light.',
  ),
  'taa': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'taharah',
    exampleWordAr: 'طهارة',
    exampleWordEn: 'Taharah',
    childFriendlyLine: 'Ta reminds us of taharah.',
  ),
  'zaa': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'zuhr',
    exampleWordAr: 'ظهر',
    exampleWordEn: 'Zuhr',
    childFriendlyLine: 'Za reminds us of Zuhr.',
  ),
  'ain': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'ilm',
    exampleWordAr: 'علم',
    exampleWordEn: 'Ilm',
    childFriendlyLine: 'Ain reminds us of ilm.',
  ),
  'ghain': _KidsArabicLetterContent(
    strokeCount: 3,
    exampleWord: 'ghafoor',
    exampleWordAr: 'غفور',
    exampleWordEn: 'Ghafoor',
    childFriendlyLine: 'Ghain reminds us of mercy.',
  ),
  'fa': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'fajr',
    exampleWordAr: 'فجر',
    exampleWordEn: 'Fajr',
    childFriendlyLine: 'Fa reminds us of Fajr.',
  ),
  'qaf': _KidsArabicLetterContent(
    strokeCount: 3,
    exampleWord: 'quran',
    exampleWordAr: 'قرآن',
    exampleWordEn: 'Qur’an',
    childFriendlyLine: 'Qaf reminds us of Qur’an.',
  ),
  'kaf': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'kitab',
    exampleWordAr: 'كتاب',
    exampleWordEn: 'Kitab',
    childFriendlyLine: 'Kaf reminds us of kitab.',
  ),
  'lam': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'layl',
    exampleWordAr: 'ليل',
    exampleWordEn: 'Layl',
    childFriendlyLine: 'Lam reminds us of layl.',
  ),
  'meem': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'masjid',
    exampleWordAr: 'مسجد',
    exampleWordEn: 'Masjid',
    childFriendlyLine: 'Meem reminds us of masjid.',
  ),
  'noon': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'noor',
    exampleWordAr: 'نور',
    exampleWordEn: 'Noor',
    childFriendlyLine: 'Noon reminds us of noor.',
  ),
  'ha2': _KidsArabicLetterContent(
    strokeCount: 2,
    exampleWord: 'huda',
    exampleWordAr: 'هدى',
    exampleWordEn: 'Huda',
    childFriendlyLine: 'Ha reminds us of huda.',
  ),
  'waw': _KidsArabicLetterContent(
    strokeCount: 1,
    exampleWord: 'wudu',
    exampleWordAr: 'وضوء',
    exampleWordEn: 'Wudu',
    childFriendlyLine: 'Waw reminds us of wudu.',
  ),
  'ya': _KidsArabicLetterContent(
    strokeCount: 3,
    exampleWord: 'yaqeen',
    exampleWordAr: 'يقين',
    exampleWordEn: 'Yaqeen',
    childFriendlyLine: 'Ya reminds us of yaqeen.',
  ),
};

final kidsArabicLetters = arabicAlphabetCatalog
    .map((letter) {
      final content = _kidsArabicLetterContentById[letter.id]!;
      return KidsArabicLetter(
        id: letter.id,
        glyph: letter.glyph,
        nameEn: letter.kidsNameEn,
        nameAr: letter.nameAr,
        transliteration: letter.kidsTransliteration,
        soundHint: letter.soundHint,
        strokeCount: content.strokeCount,
        exampleWord: content.exampleWord,
        exampleWordAr: content.exampleWordAr,
        exampleWordEn: content.exampleWordEn,
        childFriendlyLine: content.childFriendlyLine,
        rewardXp: 8,
        rewardDrops: 1,
      );
    })
    .toList(growable: false);

const kidsArabicRecommendedLetterIds = <String>{
  'alif',
  'ba',
  'meem',
  'noon',
  'seen',
};

const kidsArabicStickerDefinitions = <KidsArabicStickerDefinition>[
  KidsArabicStickerDefinition(
    id: 'first-letter',
    requiredCompletedLetters: 1,
    icon: Icons.star_rounded,
    color: Color(0xFFF3C86A),
  ),
  KidsArabicStickerDefinition(
    id: 'first-five',
    requiredCompletedLetters: 5,
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFFB9D77B),
  ),
  KidsArabicStickerDefinition(
    id: 'ten-letters',
    requiredCompletedLetters: 10,
    icon: Icons.celebration_rounded,
    color: Color(0xFF93C8E8),
  ),
  KidsArabicStickerDefinition(
    id: 'full-alphabet',
    requiredCompletedLetters: 28,
    icon: Icons.emoji_events_rounded,
    color: Color(0xFFE2B4EC),
  ),
];
