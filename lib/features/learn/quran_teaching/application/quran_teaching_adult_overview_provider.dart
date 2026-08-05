import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../arabic/application/arabic_learning_progress_provider.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../domain/quran_teaching_adult_overview_models.dart';
import 'quran_teaching_controller.dart';

final quranTeachingAdultOverviewProvider =
    Provider<QuranTeachingAdultOverviewSummary>((ref) {
      final summary = ref.watch(
        arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
      );
      final catalog = ref.watch(quranTeachingCatalogProvider);
      final beginnerWords = ref.watch(quranTeachingBeginnerWordsProvider);

      final hasCompletedGuidedLessons =
          summary.completedLessons != null &&
          summary.totalLessons != null &&
          summary.totalLessons! > 0 &&
          summary.completedLessons! >= summary.totalLessons!;

      final state = !summary.hasStarted
          ? QuranTeachingAdultOverviewState.firstTime
          : hasCompletedGuidedLessons
          ? QuranTeachingAdultOverviewState.completed
          : QuranTeachingAdultOverviewState.inProgress;

      final foundations = catalog.moduleById('foundations');
      final browseLettersTarget = foundations == null
          ? null
          : ArabicLearningRouteTarget(
              kind: ArabicLearningRouteTargetKind.adultModule,
              contentType: ArabicLearningContinuationContentType.lesson,
              canonicalItemId: foundations.id,
              moduleId: foundations.id,
            );
      final firstWordId =
          beginnerWords.firstOrNull?.sharedBeginnerWordId ??
          beginnerWords.firstOrNull?.id;
      final browseWordsTarget = firstWordId == null
          ? null
          : ArabicLearningRouteTarget(
              kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
              contentType: ArabicLearningContinuationContentType.word,
              canonicalItemId: firstWordId,
              wordId: firstWordId,
            );

      return QuranTeachingAdultOverviewSummary(
        state: state,
        progress: summary,
        primaryTarget: summary.continuation.primaryTarget,
        reviewTarget: summary.reviewSuggestion?.target,
        browseLettersTarget: browseLettersTarget,
        browseWordsTarget: browseWordsTarget,
      );
    });
