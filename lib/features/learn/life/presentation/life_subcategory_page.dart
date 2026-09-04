import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/life_progress_provider.dart';
import '../data/life_curriculum_data.dart';
import '../domain/life_models.dart';

class LifeSubcategoryPage extends ConsumerWidget {
  const LifeSubcategoryPage({super.key, required this.subcategoryId});

  final String subcategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sub = lifeSubcategoryById(subcategoryId);
    if (sub == null) {
      return AppPageScaffold(
        title: l10n.learnLifeSectionTitle,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final theme = lifeThemeById(sub.themeId);
    final lessons = lifeLessonsForSubcategory(sub.id);
    final progress = ref.watch(lifeSubcategoryProgressProvider(sub.id));

    return AppPageScaffold(
      title: sub.title,
      subtitle: sub.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                theme?.title ?? l10n.learnLifeSectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.lifeSubcategoryProgress(
                  progress.completedLessons,
                  progress.totalLessons,
                ),
              ),
              const SizedBox(height: 8),
              ProgressBar(value: progress.ratio, height: 8),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (sub.themeId == 'family')
          CompactListTile(
            title: l10n.babyNamesTitle,
            subtitle: l10n.babyNamesSubtitle,
            onTap: () => context.pushNamed('babyNamesHome'),
          ),
        if (sub.themeId == 'family') const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lifeLessonsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...lessons.map((lesson) {
                final p = ref
                    .watch(lifeProgressProvider)
                    .lessonProgressById[lesson.id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lesson.title),
                    subtitle: Text(
                      '${lesson.subtitle}\n${_statusLabel(l10n, p?.status)}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      'lifeLessonDetail',
                      pathParameters: {'lessonId': lesson.id},
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(AppLocalizations l10n, LifeLessonStatus? status) {
    switch (status ?? LifeLessonStatus.notStarted) {
      case LifeLessonStatus.notStarted:
        return l10n.lifeStatusNotStarted;
      case LifeLessonStatus.inProgress:
        return l10n.lifeStatusInProgress;
      case LifeLessonStatus.completed:
        return l10n.lifeStatusCompleted;
    }
  }
}
