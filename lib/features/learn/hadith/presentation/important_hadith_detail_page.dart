import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/hadith_foundation_repository.dart';
import '../data/seeded_hadith_foundation_data.dart';
import 'hadith_lesson_page.dart';

class ImportantHadithDetailPage extends ConsumerWidget {
  const ImportantHadithDetailPage({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final essentialEntries = ref.watch(
      hadithEntriesForCollectionProvider(essentialCollectionId),
    );
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
