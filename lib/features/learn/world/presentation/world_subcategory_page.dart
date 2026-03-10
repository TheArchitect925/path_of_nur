import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/world_progress_provider.dart';
import '../data/world_curriculum_data.dart';
import '../domain/world_models.dart';

class WorldSubcategoryPage extends ConsumerWidget {
  const WorldSubcategoryPage({
    super.key,
    required this.subcategoryId,
  });

  final String subcategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sub = worldSubcategoryById(subcategoryId);
    if (sub == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: l10n.learnWorldSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final theme = worldThemeById(sub.themeId);
    final lessons = worldLessonsForSubcategory(sub.id);
    final progress = ref.watch(worldSubcategoryProgressProvider(sub.id));

    return AppPageScaffold(
      headerIcon: Icons.list_alt_rounded,
      title: sub.title,
      subtitle: sub.summary,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                theme?.title ?? l10n.learnWorldSectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.worldSubcategoryProgress(
                  progress.completedLessons,
                  progress.totalLessons,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: progress.ratio, minHeight: 8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldLessonsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...lessons.map((lesson) {
                final p = ref.watch(worldProgressProvider).lessonProgressById[lesson.id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lesson.title),
                    subtitle: Text('${lesson.subtitle}\n${_statusLabel(l10n, p?.status)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      'worldLessonDetail',
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

  String _statusLabel(AppLocalizations l10n, WorldLessonStatus? status) {
    switch (status ?? WorldLessonStatus.notStarted) {
      case WorldLessonStatus.notStarted:
        return l10n.worldStatusNotStarted;
      case WorldLessonStatus.inProgress:
        return l10n.worldStatusInProgress;
      case WorldLessonStatus.completed:
        return l10n.worldStatusCompleted;
    }
  }
}
