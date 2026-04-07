import 'package:flutter/material.dart';

abstract final class LearnEnrichmentIconRegistry {
  static const Map<int, IconData> _iconsByCodePoint = <int, IconData>{
    0xe80c: Icons.auto_stories_rounded,
    0xe86c: Icons.check_circle_outline_rounded,
    0xe876: Icons.task_alt_rounded,
    0xe865: Icons.menu_book_rounded,
    0xeb97: Icons.child_friendly_rounded,
    0xe8b5: Icons.schedule_rounded,
    0xe5d5: Icons.refresh_rounded,
  };

  static IconData iconForCodePoint(int codePoint) {
    return _iconsByCodePoint[codePoint] ?? Icons.auto_awesome_rounded;
  }
}
