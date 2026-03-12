import 'package:flutter/material.dart';

import '../../../../shared/theme/islamic_icons.dart';

class LearnIconRegistry {
  const LearnIconRegistry._();

  static const Map<String, String> _assetByKey = {
    'quran': 'assets/icons/learn_quran_cropped.png',
  };

  static const Map<String, IconData> _iconByKey = {
    'quran': IslamicIcons.quran,
    'hadith': IslamicIcons.allahText,
    'life': IslamicIcons.prayingPerson,
    'world': IslamicIcons.locationMuslim,
    'prophets': IslamicIcons.muslim,
    'baby_names': IslamicIcons.family,
    'allah_names': IslamicIcons.allahText,
    'quizzes': Icons.quiz_rounded,
    'notes': Icons.sticky_note_2_rounded,
    'duas': IslamicIcons.tasbih,
    'lessons_library': Icons.library_books_rounded,
    'salah': IslamicIcons.prayer,
    'wudu': IslamicIcons.wudhu,
    'other': Icons.dashboard_customize_rounded,
    'search': Icons.search_rounded,
    'bookmarks': Icons.bookmark_border_rounded,
    'word_review': Icons.spellcheck_rounded,
    'top_words': Icons.translate_rounded,
    'quran_universe': Icons.hub_rounded,
  };

  static IconData iconFor(String key) {
    return _iconByKey[key] ?? Icons.circle_outlined;
  }

  static String? assetFor(String key) {
    return _assetByKey[key];
  }
}
