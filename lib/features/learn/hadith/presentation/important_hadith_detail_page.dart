import 'package:flutter/material.dart';

import '../data/seeded_hadith_foundation_data.dart';
import 'hadith_lesson_page.dart';

class ImportantHadithDetailPage extends StatelessWidget {
  const ImportantHadithDetailPage({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final essentialEntries = seededHadithEntries
        .where((entry) => entry.collectionIds.contains(essentialCollectionId))
        .toList(growable: false);
    final index = number <= 0 ? 0 : number - 1;
    final resolved = essentialEntries.isEmpty
        ? null
        : essentialEntries[index.clamp(0, essentialEntries.length - 1)];

    if (resolved == null) {
      return const HadithLessonPage(lessonId: 'intentions_core');
    }

    return HadithLessonPage(lessonId: resolved.id);
  }
}
