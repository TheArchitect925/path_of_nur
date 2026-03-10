import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/hadith_progress_provider.dart';
import '../data/hadith_curriculum_data.dart';
import '../domain/hadith_models.dart';

class HadithSubcategoryPage extends ConsumerWidget {
  const HadithSubcategoryPage({
    super.key,
    required this.subcategoryId,
  });

  final String subcategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sub = hadithSubcategoryById(subcategoryId);
    if (sub == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: l10n.learnHadithSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final theme = hadithThemeById(sub.themeId);
    final lessons = hadithLessonsForSubcategory(sub.id);
    final progress = ref.watch(hadithSubcategoryProgressProvider(sub.id));

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
                theme?.title ?? l10n.learnHadithSectionTitle,
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
                l10n.lifeLessonsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...lessons.map((lesson) {
                final p = ref.watch(hadithProgressProvider).lessonProgressById[lesson.id];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lesson.title),
                    subtitle: Text('${lesson.subtitle}\n${_statusLabel(l10n, p?.status)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      'hadithLessonDetail',
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

  String _statusLabel(AppLocalizations l10n, HadithLessonStatus? status) {
    switch (status ?? HadithLessonStatus.notStarted) {
      case HadithLessonStatus.notStarted:
        return l10n.lifeStatusNotStarted;
      case HadithLessonStatus.inProgress:
        return l10n.lifeStatusInProgress;
      case HadithLessonStatus.completed:
        return l10n.lifeStatusCompleted;
    }
  }
}
