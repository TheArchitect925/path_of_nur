import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/daily_learning_item.dart';
import '../prophets_daily_copy.dart';

class DailyRevelationCard extends StatelessWidget {
  const DailyRevelationCard({
    super.key,
    required this.item,
    required this.isOpened,
    required this.onOpen,
    required this.onTakeQuiz,
    required this.onPracticeLesson,
    this.showPracticeLesson = false,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.useHeroGlassShell = false,
  });

  final DailyLearningItem item;
  final bool isOpened;
  final VoidCallback onOpen;
  final VoidCallback onTakeQuiz;
  final VoidCallback onPracticeLesson;
  final bool showPracticeLesson;
  final AppSurfaceTreatment surfaceTreatment;
  final bool useHeroGlassShell;

  @override
  Widget build(BuildContext context) {
    final copy = ProphetsDailyCopy.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: Color(0xFF8A6A3C),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (isOpened)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: const Color(0x332D8F58),
                  border: Border.all(color: const Color(0x552D8F58)),
                ),
                child: Text(
                  copy.opened,
                  style: const TextStyle(fontSize: 11.5),
                ),
              ),
          ],
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            item.subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(item.body),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonalIcon(
              onPressed: onOpen,
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(copy.learnMore),
            ),
            OutlinedButton.icon(
              onPressed: onTakeQuiz,
              icon: const Icon(Icons.quiz_rounded),
              label: Text(copy.takeTodaysQuiz),
            ),
            if (showPracticeLesson)
              OutlinedButton.icon(
                onPressed: onPracticeLesson,
                icon: const Icon(Icons.auto_graph_rounded),
                label: Text(copy.practiceLesson),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          copy.returnTomorrow,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.palette.onSurfaceSubtle,
          ),
        ),
      ],
    );
    if (useHeroGlassShell) {
      return AppHeroGlassShell(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        tintColor: context.palette.accent,
        surfaceAlphaOverride: 0.2,
        radius: 36,
        borderColor: const Color(0x42FFFFFF),
        highlightGradientColors: const [
          Color(0x24FFFFFF),
          Colors.transparent,
          Color(0x16E8C98F),
        ],
        child: content,
      );
    }
    return PremiumCard(surfaceTreatment: surfaceTreatment, child: content);
  }
}
