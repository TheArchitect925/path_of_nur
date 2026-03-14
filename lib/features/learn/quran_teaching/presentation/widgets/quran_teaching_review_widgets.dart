import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/quran_teaching_smart_review_controller.dart';
import '../../domain/quran_teaching_review_models.dart';
import '../quran_teaching_theme.dart';

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
    final title = !summary.hasAnyLearnedItems
        ? 'Daily Review'
        : summary.isComplete
            ? 'Today’s review is complete'
            : summary.inProgress
                ? 'Continue today’s practice'
                : 'Review for today';
    final subtitle = !summary.hasAnyLearnedItems
        ? 'Start a few lessons and your daily review will appear here.'
        : !summary.hasDueItems
            ? 'No review due right now. A new lesson will build your next session.'
            : summary.inProgress
                ? '${summary.completedCount} of ${summary.itemCount} items completed. ${summary.mixSummary}'
            : summary.mixSummary;
    final actionLabel = summary.isComplete
        ? 'Practice more'
        : summary.itemCount == 0
            ? 'Open review'
            : summary.inProgress
                ? 'Continue today’s practice'
                : 'Start review';

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
                  '${summary.estimatedMinutes} min',
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
                  ? '${summary.completedCount} / ${summary.itemCount} items'
                  : '${summary.itemCount} items',
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
                  recommendation.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(recommendation.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
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
    final (label, color) = switch (memoryState) {
      QuranTeachingMemoryState.newItem => ('New', Colors.blueGrey),
      QuranTeachingMemoryState.practicing => ('Practicing', Colors.orange),
      QuranTeachingMemoryState.familiar => ('Familiar', Colors.blue),
      QuranTeachingMemoryState.recognized => ('Recognized', Colors.green),
      QuranTeachingMemoryState.mastered => ('Mastered', Colors.teal),
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
    final progress = total == 0 ? 0.0 : current / total;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Practice',
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
          Text('$current of $total completed'),
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
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nice progress.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text('Correct or remembered: $correctCount'),
          Text('Still due soon: $needsMoreCount'),
          const SizedBox(height: 10),
          Text(
            'A few items are getting stronger. The next short review will bring back anything that still needs another pass.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}
