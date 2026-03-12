import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';

class RevelationEraCard extends StatelessWidget {
  const RevelationEraCard({
    super.key,
    required this.title,
    required this.summary,
    required this.regionLabel,
    required this.civilizationTitle,
    required this.civilizationSummary,
    required this.coreMessages,
    required this.humanPatternSummaries,
    required this.growthHabitLabels,
    required this.featuredProphetsLabel,
    required this.started,
    required this.completed,
    required this.current,
    required this.onStartOrContinue,
    required this.onOpenTimeline,
    required this.onOpenMap,
    required this.onOpenQuiz,
  });

  final String title;
  final String summary;
  final String regionLabel;
  final String civilizationTitle;
  final String civilizationSummary;
  final List<String> coreMessages;
  final List<String> humanPatternSummaries;
  final List<String> growthHabitLabels;
  final String featuredProphetsLabel;
  final bool started;
  final bool completed;
  final bool current;
  final VoidCallback onStartOrContinue;
  final VoidCallback onOpenTimeline;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _statusPill(),
            ],
          ),
          const SizedBox(height: 5),
          Text(summary),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('Region • $regionLabel'),
              _chip('Civilization • $civilizationTitle'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            civilizationSummary,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          if (coreMessages.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Main Message of This Era',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            ...coreMessages.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $item'),
              ),
            ),
          ],
          if (humanPatternSummaries.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Human Patterns in This Era',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            ...humanPatternSummaries
                .take(2)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $item'),
                  ),
                ),
          ],
          if (growthHabitLabels.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: growthHabitLabels
                  .map((label) => _chip('Practice • $label'))
                  .toList(),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            featuredProphetsLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: onStartOrContinue,
                child: Text(started ? 'Continue Era' : 'Begin Era'),
              ),
              OutlinedButton(
                onPressed: onOpenTimeline,
                child: const Text('Timeline'),
              ),
              OutlinedButton(
                onPressed: onOpenMap,
                child: const Text('View Region on Map'),
              ),
              OutlinedButton(onPressed: onOpenQuiz, child: const Text('Quiz')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill() {
    final text = completed
        ? 'Completed'
        : current
        ? 'Current'
        : started
        ? 'Started'
        : 'Not started';
    final color = completed
        ? const Color(0xFF2D8F58)
        : current
        ? const Color(0xFFB58947)
        : const Color(0xFF6E6A64);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.8)),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.28),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
    );
  }
}
