import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../../learn/quran_teaching/presentation/quran_teaching_beginner_words_page.dart';
import '../../learn/quran_teaching/presentation/quran_teaching_daily_review_page.dart';
import '../../learn/quran_teaching/presentation/quran_teaching_lesson_page.dart';
import '../../learn/quran_teaching/presentation/quran_teaching_module_page.dart';
import '../application/arabic_learning_route_target_helpers.dart';
import '../domain/arabic_learning_continuity_models.dart';

void openArabicLearningRouteTarget(
  BuildContext context, {
  required ArabicLearningRouteTarget target,
  QuranTeachingCatalog? adultCatalog,
}) {
  final location = arabicLearningRouteLocationForTarget(target);
  if (location != null) {
    context.push(location);
    return;
  }
  switch (target.kind) {
    case ArabicLearningRouteTargetKind.goNamed:
      final routeName = target.routeName;
      if (routeName == null) {
        return;
      }
      context.pushNamed(
        routeName,
        pathParameters: target.pathParameters,
        queryParameters: target.queryParameters,
      );
    case ArabicLearningRouteTargetKind.adultLesson:
      final catalog = adultCatalog;
      final lessonId = target.lessonId;
      final moduleId = target.moduleId;
      if (catalog == null || lessonId == null || moduleId == null) {
        return;
      }
      final lesson = catalog.lessonById(lessonId);
      final module = catalog.moduleById(moduleId);
      if (lesson == null || module == null) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => QuranTeachingLessonPage(lesson: lesson, module: module),
        ),
      );
    case ArabicLearningRouteTargetKind.adultModule:
      final catalog = adultCatalog;
      final moduleId = target.moduleId;
      if (catalog == null || moduleId == null) {
        return;
      }
      final module = catalog.moduleById(moduleId);
      if (module == null) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => QuranTeachingModulePage(module: module),
        ),
      );
    case ArabicLearningRouteTargetKind.adultBeginnerWords:
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              QuranTeachingBeginnerWordsPage(initialWordId: target.wordId),
        ),
      );
    case ArabicLearningRouteTargetKind.adultDailyReview:
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const QuranTeachingDailyReviewPage()));
  }
}
