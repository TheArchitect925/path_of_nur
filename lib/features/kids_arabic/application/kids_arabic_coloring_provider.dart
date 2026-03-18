import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kids_arabic_coloring_pages_data.dart';
import '../domain/kids_arabic_coloring_models.dart';
import 'kids_arabic_progress_provider.dart';

final kidsArabicColoringPagesProvider = Provider<List<KidsArabicColoringPage>>((
  ref,
) {
  final completedLetterIds = ref
      .watch(kidsArabicProgressProvider)
      .completedLetterIds;
  return kidsArabicColoringPages
      .map(
        (page) => page.copyWith(
          isUnlocked: completedLetterIds.contains(page.unlockRequirement),
        ),
      )
      .toList(growable: false);
});

final kidsArabicUnlockedColoringPagesCountProvider = Provider<int>((ref) {
  return ref
      .watch(kidsArabicColoringPagesProvider)
      .where((page) => page.isUnlocked)
      .length;
});
