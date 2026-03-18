import 'package:flutter/material.dart';

import '../domain/kids_arabic_models.dart';

const kidsArabicLetters = <KidsArabicLetter>[
  KidsArabicLetter(id: 'alif', glyph: 'ا', nameEn: 'Alif', nameAr: 'ألف', transliteration: 'aa', soundHint: 'aa', strokeCount: 1, exampleWord: 'allah', exampleWordAr: 'الله', exampleWordEn: 'Allah', childFriendlyLine: 'Alif reminds us of Allah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ba', glyph: 'ب', nameEn: 'Ba', nameAr: 'باء', transliteration: 'ba', soundHint: 'ba', strokeCount: 2, exampleWord: 'bismillah', exampleWordAr: 'بسم الله', exampleWordEn: 'Bismillah', childFriendlyLine: 'Ba begins Bismillah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ta', glyph: 'ت', nameEn: 'Ta', nameAr: 'تاء', transliteration: 'ta', soundHint: 'ta', strokeCount: 3, exampleWord: 'taqwa', exampleWordAr: 'تقوى', exampleWordEn: 'Taqwa', childFriendlyLine: 'Ta reminds us of taqwa.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'tha', glyph: 'ث', nameEn: 'Tha', nameAr: 'ثاء', transliteration: 'tha', soundHint: 'tha', strokeCount: 4, exampleWord: 'thawab', exampleWordAr: 'ثواب', exampleWordEn: 'Thawab', childFriendlyLine: 'Tha reminds us of thawab.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'jim', glyph: 'ج', nameEn: 'Jeem', nameAr: 'جيم', transliteration: 'jeem', soundHint: 'jeem', strokeCount: 2, exampleWord: 'jannah', exampleWordAr: 'جنة', exampleWordEn: 'Jannah', childFriendlyLine: 'Jeem reminds us of Jannah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ha', glyph: 'ح', nameEn: 'Ha', nameAr: 'حاء', transliteration: 'haa', soundHint: 'haa', strokeCount: 1, exampleWord: 'halal', exampleWordAr: 'حلال', exampleWordEn: 'Halal', childFriendlyLine: 'Ha reminds us of halal.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'kha', glyph: 'خ', nameEn: 'Kha', nameAr: 'خاء', transliteration: 'kha', soundHint: 'kha', strokeCount: 2, exampleWord: 'khayr', exampleWordAr: 'خير', exampleWordEn: 'Khayr', childFriendlyLine: 'Kha reminds us of khayr.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'dal', glyph: 'د', nameEn: 'Dal', nameAr: 'دال', transliteration: 'da', soundHint: 'da', strokeCount: 1, exampleWord: 'deen', exampleWordAr: 'دين', exampleWordEn: 'Deen', childFriendlyLine: 'Dal reminds us of deen.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'dhal', glyph: 'ذ', nameEn: 'Dhal', nameAr: 'ذال', transliteration: 'dhal', soundHint: 'dhal', strokeCount: 2, exampleWord: 'dhikr', exampleWordAr: 'ذكر', exampleWordEn: 'Dhikr', childFriendlyLine: 'Dhal reminds us of dhikr.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ra', glyph: 'ر', nameEn: 'Ra', nameAr: 'راء', transliteration: 'ra', soundHint: 'ra', strokeCount: 1, exampleWord: 'rahmah', exampleWordAr: 'رحمة', exampleWordEn: 'Rahmah', childFriendlyLine: 'Ra reminds us of rahmah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'zay', glyph: 'ز', nameEn: 'Zay', nameAr: 'زاي', transliteration: 'za', soundHint: 'za', strokeCount: 2, exampleWord: 'zakah', exampleWordAr: 'زكاة', exampleWordEn: 'Zakah', childFriendlyLine: 'Zay reminds us of zakah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'seen', glyph: 'س', nameEn: 'Seen', nameAr: 'سين', transliteration: 'seen', soundHint: 'seen', strokeCount: 3, exampleWord: 'sujood', exampleWordAr: 'سجود', exampleWordEn: 'Sujood', childFriendlyLine: 'Seen reminds us of sujood.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'sheen', glyph: 'ش', nameEn: 'Sheen', nameAr: 'شين', transliteration: 'sheen', soundHint: 'sheen', strokeCount: 4, exampleWord: 'shukr', exampleWordAr: 'شكر', exampleWordEn: 'Shukr', childFriendlyLine: 'Sheen reminds us of shukr.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'sad', glyph: 'ص', nameEn: 'Sad', nameAr: 'صاد', transliteration: 'saad', soundHint: 'saad', strokeCount: 1, exampleWord: 'salah', exampleWordAr: 'صلاة', exampleWordEn: 'Salah', childFriendlyLine: 'Sad reminds us of salah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'dad', glyph: 'ض', nameEn: 'Dad', nameAr: 'ضاد', transliteration: 'daad', soundHint: 'daad', strokeCount: 2, exampleWord: 'diya', exampleWordAr: 'ضياء', exampleWordEn: 'Light', childFriendlyLine: 'Dad reminds us of light.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'taa', glyph: 'ط', nameEn: 'Ta', nameAr: 'طاء', transliteration: 'taa', soundHint: 'taa', strokeCount: 1, exampleWord: 'taharah', exampleWordAr: 'طهارة', exampleWordEn: 'Taharah', childFriendlyLine: 'Ta reminds us of taharah.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'zaa', glyph: 'ظ', nameEn: 'Za', nameAr: 'ظاء', transliteration: 'zaa', soundHint: 'zaa', strokeCount: 2, exampleWord: 'zuhr', exampleWordAr: 'ظهر', exampleWordEn: 'Zuhr', childFriendlyLine: 'Za reminds us of Zuhr.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ain', glyph: 'ع', nameEn: 'Ain', nameAr: 'عين', transliteration: 'ain', soundHint: 'ain', strokeCount: 2, exampleWord: 'ilm', exampleWordAr: 'علم', exampleWordEn: 'Ilm', childFriendlyLine: 'Ain reminds us of ilm.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ghain', glyph: 'غ', nameEn: 'Ghain', nameAr: 'غين', transliteration: 'ghain', soundHint: 'ghain', strokeCount: 3, exampleWord: 'ghafoor', exampleWordAr: 'غفور', exampleWordEn: 'Ghafoor', childFriendlyLine: 'Ghain reminds us of mercy.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'fa', glyph: 'ف', nameEn: 'Fa', nameAr: 'فاء', transliteration: 'fa', soundHint: 'fa', strokeCount: 2, exampleWord: 'fajr', exampleWordAr: 'فجر', exampleWordEn: 'Fajr', childFriendlyLine: 'Fa reminds us of Fajr.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'qaf', glyph: 'ق', nameEn: 'Qaf', nameAr: 'قاف', transliteration: 'qaf', soundHint: 'qaf', strokeCount: 3, exampleWord: 'quran', exampleWordAr: 'قرآن', exampleWordEn: 'Qur’an', childFriendlyLine: 'Qaf reminds us of Qur’an.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'kaf', glyph: 'ك', nameEn: 'Kaf', nameAr: 'كاف', transliteration: 'kaf', soundHint: 'kaf', strokeCount: 2, exampleWord: 'kitab', exampleWordAr: 'كتاب', exampleWordEn: 'Kitab', childFriendlyLine: 'Kaf reminds us of kitab.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'lam', glyph: 'ل', nameEn: 'Lam', nameAr: 'لام', transliteration: 'lam', soundHint: 'lam', strokeCount: 1, exampleWord: 'layl', exampleWordAr: 'ليل', exampleWordEn: 'Layl', childFriendlyLine: 'Lam reminds us of layl.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'meem', glyph: 'م', nameEn: 'Meem', nameAr: 'ميم', transliteration: 'meem', soundHint: 'meem', strokeCount: 2, exampleWord: 'masjid', exampleWordAr: 'مسجد', exampleWordEn: 'Masjid', childFriendlyLine: 'Meem reminds us of masjid.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'noon', glyph: 'ن', nameEn: 'Noon', nameAr: 'نون', transliteration: 'noon', soundHint: 'noon', strokeCount: 2, exampleWord: 'noor', exampleWordAr: 'نور', exampleWordEn: 'Noor', childFriendlyLine: 'Noon reminds us of noor.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ha2', glyph: 'ه', nameEn: 'Ha', nameAr: 'هاء', transliteration: 'ha', soundHint: 'ha', strokeCount: 2, exampleWord: 'huda', exampleWordAr: 'هدى', exampleWordEn: 'Huda', childFriendlyLine: 'Ha reminds us of huda.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'waw', glyph: 'و', nameEn: 'Waw', nameAr: 'واو', transliteration: 'waw', soundHint: 'waw', strokeCount: 1, exampleWord: 'wudu', exampleWordAr: 'وضوء', exampleWordEn: 'Wudu', childFriendlyLine: 'Waw reminds us of wudu.', rewardXp: 8, rewardDrops: 1),
  KidsArabicLetter(id: 'ya', glyph: 'ي', nameEn: 'Ya', nameAr: 'ياء', transliteration: 'yaa', soundHint: 'yaa', strokeCount: 3, exampleWord: 'yaqeen', exampleWordAr: 'يقين', exampleWordEn: 'Yaqeen', childFriendlyLine: 'Ya reminds us of yaqeen.', rewardXp: 8, rewardDrops: 1),
];

const kidsArabicRecommendedLetterIds = <String>{'alif', 'ba', 'meem', 'noon', 'seen'};

const kidsArabicStickerDefinitions = <KidsArabicStickerDefinition>[
  KidsArabicStickerDefinition(id: 'first-letter', requiredCompletedLetters: 1, icon: Icons.star_rounded, color: Color(0xFFF3C86A)),
  KidsArabicStickerDefinition(id: 'first-five', requiredCompletedLetters: 5, icon: Icons.auto_awesome_rounded, color: Color(0xFFB9D77B)),
  KidsArabicStickerDefinition(id: 'ten-letters', requiredCompletedLetters: 10, icon: Icons.celebration_rounded, color: Color(0xFF93C8E8)),
  KidsArabicStickerDefinition(id: 'full-alphabet', requiredCompletedLetters: 28, icon: Icons.emoji_events_rounded, color: Color(0xFFE2B4EC)),
];
