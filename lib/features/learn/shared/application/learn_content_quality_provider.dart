import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../hadith/data/hadith_curriculum_data.dart';
import '../../life/data/life_curriculum_data.dart';
import '../../world/data/world_curriculum_data.dart';

class LearnContentQualitySummary {
  const LearnContentQualitySummary({
    required this.score,
    required this.duplicateLessonIds,
    required this.brokenRelatedLinks,
    required this.totalLessons,
  });

  final int score;
  final int duplicateLessonIds;
  final int brokenRelatedLinks;
  final int totalLessons;
}

final learnContentQualitySummaryProvider = Provider<LearnContentQualitySummary>(
  (ref) {
    final lifeLessons = lifeCurriculum.lessons;
    final worldLessons = worldCurriculum.lessons;
    final hadithLessons = hadithCurriculum.lessons;
    final totalLessons =
        lifeLessons.length + worldLessons.length + hadithLessons.length;

    int duplicateIds = 0;
    int brokenRelated = 0;

    void inspect<T>(
      List<T> lessons, {
      required String Function(T lesson) idOf,
      required List<String> Function(T lesson) relatedOf,
    }) {
      final idCounts = <String, int>{};
      for (final lesson in lessons) {
        idCounts[idOf(lesson)] = (idCounts[idOf(lesson)] ?? 0) + 1;
      }
      duplicateIds += idCounts.values.where((count) => count > 1).length;

      final validIds = idCounts.keys.toSet();
      for (final lesson in lessons) {
        for (final relatedId in relatedOf(lesson)) {
          if (!validIds.contains(relatedId)) {
            brokenRelated += 1;
          }
        }
      }
    }

    inspect(
      lifeLessons,
      idOf: (item) => item.id,
      relatedOf: (item) => item.relatedLessonIds,
    );
    inspect(
      worldLessons,
      idOf: (item) => item.id,
      relatedOf: (item) => item.relatedLessonIds,
    );
    inspect(
      hadithLessons,
      idOf: (item) => item.id,
      relatedOf: (item) => item.relatedLessonIds,
    );

    final penalties = duplicateIds * 8 + brokenRelated * 2;
    final score = (100 - penalties).clamp(0, 100);

    return LearnContentQualitySummary(
      score: score,
      duplicateLessonIds: duplicateIds,
      brokenRelatedLinks: brokenRelated,
      totalLessons: totalLessons,
    );
  },
);
