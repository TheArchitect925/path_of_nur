import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';

class LearnIconRegistry {
  const LearnIconRegistry._();

  static const Map<String, String> _assetByKey = {
    'quran': 'assets/icons/learn_quran_cropped.webp',
  };

  static const Map<String, IconData> _iconByKey = {
    'quran': AppIcons.quran,
    'quran_arabic': AppIcons.arabic,
    'islamic_trivia': AppIcons.quiz,
    'hadith': AppIcons.namesOfAllah,
    'life': AppIcons.family,
    'world': AppIcons.world,
    'prophets': AppIcons.prophets,
    'baby_names': AppIcons.babyNames,
    'allah_names': AppIcons.namesOfAllah,
    'quizzes': AppIcons.quiz,
    'notes': AppIcons.notes,
    'duas': AppIcons.dua,
    'lessons_library': AppIcons.lesson,
    'salah': AppIcons.salah,
    'wudu': AppIcons.wudu,
    'other': AppIcons.browseAll,
    'search': AppIcons.search,
    'bookmarks': AppIcons.bookmarkOff,
    'word_review': AppIcons.wordDeck,
    'top_words': AppIcons.arabic,
    'quran_universe': AppIcons.universe,
    'history': AppIcons.history,
    'ramadan': AppIcons.ramadan,
    'dua': AppIcons.dua,
    'seerah': AppIcons.seerah,
    'women_in_islam': Icons.groups_2_rounded,
    'akhlaq': AppIcons.character,
  };

  static IconData iconFor(String key) {
    return _iconByKey[key] ?? AppIcons.dotHollow;
  }

  static String? assetFor(String key) {
    return _assetByKey[key];
  }
}
