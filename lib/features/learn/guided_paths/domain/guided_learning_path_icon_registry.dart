import 'package:flutter/material.dart';
import '../../../../core/theme/app_icons.dart';

abstract final class GuidedLearningPathIconRegistry {
  static const Map<String, IconData> _iconsByPathId = <String, IconData>{
    'foundations-starter': AppIcons.insights,
    'salah-starter': AppIcons.salah,
    'quran-beginner-starter': AppIcons.quran,
    'daily-dhikr-starter': AppIcons.dhikr,
    'character-starter': AppIcons.character,
    'stories-starter': AppIcons.quran,
    'kids-starter': AppIcons.kids,
  };

  static IconData iconForPathId(String pathId) {
    return _iconsByPathId[pathId] ?? AppIcons.insights;
  }
}
