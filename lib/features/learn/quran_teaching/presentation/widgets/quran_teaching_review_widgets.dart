import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/quran_teaching_smart_review_controller.dart';
import '../../domain/quran_teaching_review_models.dart';

class QuranTeachingDailyReviewCard extends StatelessWidget {
  const QuranTeachingDailyReviewCard({
    super.key,
    required this.summary,
    required this.onPressed,
  });

  final QuranTeachingDailyReviewSummary summary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = !summary.hasAnyLearnedItems
        ? l10n.quranTeachingDailyReviewCardEmptyTitle
        : summary.isComplete
            ? l10n.quranTeachingDailyReviewCardCompleteTitle
            : summary.inProgress
                ? l10n.quranTeachingDailyReviewCardContinueTitle
                : l10n.quranTeachingDailyReviewCardReadyTitle;
    final subtitle = !summary.hasAnyLearnedItems
        ? l10n.quranTeachingDailyReviewCardEmptySubtitle
        : !summary.hasDueItems
            ? l10n.quranTeachingDailyReviewCardNothingDueSubtitle
            : summary.inProgress
                ? l10n.quranTeachingDailyReviewCardProgressSubtitle(
                    summary.completedCount,
                    summary.itemCount,
                    summary.mixSummary,
                  )
                : summary.mixSummary;
    final actionLabel = summary.isComplete
        ? l10n.quranTeachingDailyReviewCardPracticeMoreAction
        : summary.itemCount == 0
            ? l10n.quranTeachingDailyReviewCardOpenAction
            : summary.inProgress
                ? l10n.quranTeachingDailyReviewCardContinueAction
                : l10n.quranTeachingDailyReviewCardStartAction;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (summary.itemCount > 0)
                Text(
                  l10n.quranTeachingDailyReviewCardEstimatedMinutes(
                    summary.estimatedMinutes,
                  ),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle),
          if (summary.itemCount > 0) ...[
            const SizedBox(height: 10),
            Text(
              summary.inProgress
                  ? l10n.quranTeachingDailyReviewCardItemProgress(
                      summary.completedCount,
                      summary.itemCount,
                    )
                  : l10n.quranTeachingDailyReviewCardItemCount(
                      summary.itemCount,
                    ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class QuranTeachingRecommendationCard extends StatelessWidget {
  const QuranTeachingRecommendationCard({
    super.key,
    required this.recommendation,
  });

  final QuranTeachingPracticeRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(recommendation.icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleForRecommendation(l10n),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_subtitleForRecommendation(l10n)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _titleForRecommendation(AppLocalizations l10n) {
    switch (recommendation.type) {
      case QuranTeachingPracticeRecommendationType.weakArea:
        switch (recommendation.tag) {
          case 'harakat':
            return l10n.quranTeachingPracticeRecommendationHarakatTitle;
          case 'similar_letters':
            return l10n.quranTeachingPracticeRecommendationSimilarLettersTitle;
          case 'word_meaning':
          case 'word_recognition':
            return l10n.quranTeachingPracticeRecommendationWordsTitle;
          case 'phrase_reading':
            return l10n.quranTeachingPracticeRecommendationPhrasesTitle;
          case 'reading_rules':
            return l10n.quranTeachingPracticeRecommendationReadingRulesTitle;
          default:
            return l10n.quranTeachingPracticeRecommendationWeakAreaTitle;
        }
      case QuranTeachingPracticeRecommendationType.dueWords:
        return l10n.quranTeachingPracticeRecommendationWordsTitle;
      case QuranTeachingPracticeRecommendationType.duePhrases:
        return l10n.quranTeachingPracticeRecommendationPhrasesTitle;
      case QuranTeachingPracticeRecommendationType.lightReview:
        return l10n.quranTeachingPracticeRecommendationLightTitle;
    }
  }

  String _subtitleForRecommendation(AppLocalizations l10n) {
    switch (recommendation.type) {
      case QuranTeachingPracticeRecommendationType.weakArea:
        return l10n.quranTeachingPracticeRecommendationWeakAreaSubtitle;
      case QuranTeachingPracticeRecommendationType.dueWords:
        return l10n.quranTeachingPracticeRecommendationWordsSubtitle(
          recommendation.count ?? 0,
        );
      case QuranTeachingPracticeRecommendationType.duePhrases:
        return l10n.quranTeachingPracticeRecommendationPhrasesSubtitle(
          recommendation.count ?? 0,
        );
      case QuranTeachingPracticeRecommendationType.lightReview:
        return l10n.quranTeachingPracticeRecommendationLightSubtitle;
    }
  }
}

class QuranTeachingWeakAreaCard extends StatelessWidget {
  const QuranTeachingWeakAreaCard({
    super.key,
    required this.label,
    required this.subtitle,
  });

  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}

class QuranTeachingMemoryStateChip extends StatelessWidget {
  const QuranTeachingMemoryStateChip({
    super.key,
    required this.memoryState,
  });

  final QuranTeachingMemoryState memoryState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (memoryState) {
      QuranTeachingMemoryState.newItem => (
          l10n.quranTeachingMemoryStateNew,
          Colors.blueGrey,
        ),
      QuranTeachingMemoryState.practicing => (
          l10n.quranTeachingMemoryStatePracticing,
          Colors.orange,
        ),
      QuranTeachingMemoryState.familiar => (
          l10n.quranTeachingMemoryStateFamiliar,
          Colors.blue,
        ),
      QuranTeachingMemoryState.recognized => (
          l10n.quranTeachingMemoryStateRecognized,
          Colors.green,
        ),
      QuranTeachingMemoryState.mastered => (
          l10n.quranTeachingMemoryStateMastered,
          Colors.teal,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class QuranTeachingReviewSessionHeader extends StatelessWidget {
  const QuranTeachingReviewSessionHeader({
    super.key,
    required this.current,
    required this.total,
    required this.summary,
  });

  final int current;
  final int total;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = total == 0 ? 0.0 : current / total;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranTeachingReviewSessionHeaderTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(summary),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 8),
          Text(l10n.quranTeachingReviewSessionHeaderProgress(current, total)),
        ],
      ),
    );
  }
}

class QuranTeachingReviewCompletionCard extends StatelessWidget {
  const QuranTeachingReviewCompletionCard({
    super.key,
    required this.correctCount,
    required this.needsMoreCount,
  });

  final int correctCount;
  final int needsMoreCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranTeachingReviewCompletionTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.quranTeachingReviewCompletionCorrectCount(correctCount),
          ),
          Text(
            l10n.quranTeachingReviewCompletionNeedsMoreCount(needsMoreCount),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.quranTeachingReviewCompletionBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}
