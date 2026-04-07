import 'package:flutter/material.dart';

abstract final class GuidedLearningPathIconRegistry {
  static const Map<String, IconData> _iconsByPathId = <String, IconData>{
    'foundations-starter': Icons.auto_awesome_rounded,
    'salah-starter': Icons.self_improvement_rounded,
    'quran-beginner-starter': Icons.menu_book_rounded,
    'daily-dhikr-starter': Icons.favorite_rounded,
    'character-starter': Icons.emoji_people_rounded,
    'stories-starter': Icons.menu_book_rounded,
    'kids-starter': Icons.child_care_rounded,
  };

  static IconData iconForPathId(String pathId) {
    return _iconsByPathId[pathId] ?? Icons.auto_awesome_rounded;
  }
}
