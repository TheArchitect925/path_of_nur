import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/daily_learning_service.dart';
import '../prophets_daily_copy.dart';

class DailyLearningEntrySurface extends StatelessWidget {
  const DailyLearningEntrySurface({
    super.key,
    required this.bundle,
    required this.onOpenProphets,
    required this.onOpenQuiz,
  });

  final DailyLearningBundle bundle;
  final VoidCallback onOpenProphets;
  final VoidCallback onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    final copy = ProphetsDailyCopy.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_rounded,
                size: 18,
                color: Color(0xFF8A6A3C),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  copy.todayInRevelation,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (bundle.status.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: const Color(0x332D8F58),
                    border: Border.all(color: const Color(0x552D8F58)),
                  ),
                  child: Text(
                    copy.completed,
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bundle.item.subtitle ?? bundle.item.title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 8),
          Text(bundle.item.body, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onOpenProphets,
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(copy.learnMore),
              ),
              OutlinedButton.icon(
                onPressed: onOpenQuiz,
                icon: const Icon(Icons.quiz_rounded),
                label: Text(copy.dailyQuizTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
