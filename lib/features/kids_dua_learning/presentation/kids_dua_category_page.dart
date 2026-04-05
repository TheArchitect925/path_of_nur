import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_progress_provider.dart';
import '../application/kids_dua_repository.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaCategoryPage extends ConsumerWidget {
  const KidsDuaCategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final category = ref.watch(kidsDuaCategoryByIdProvider(categoryId));
    final lessons = ref.watch(kidsDuaLessonsForCategoryProvider(categoryId));
    final state = ref.watch(kidsDuaLearningProvider);
    final categoryProgress = ref
        .watch(kidsDuaCategoryProgressListProvider)
        .firstWhere((item) => item.category.id == categoryId);
    if (category == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.routerNotFoundTitle)),
      );
    }
    return LearnHubPageScaffold(
      headerIcon: category.icon,
      title: category.title,
      subtitle: category.subtitle,
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.kidsDuaCategoryProgressValue(
                  categoryProgress.learnedCount,
                  categoryProgress.totalCount,
                ),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: categoryProgress.totalCount == 0
                      ? 0
                      : categoryProgress.learnedCount /
                            categoryProgress.totalCount,
                  backgroundColor: const Color(0xFFF0E7DA),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFB58B4D),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...lessons.map((lesson) {
          final progress = state.progressByLessonId[lesson.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => context.pushNamed(
                'kidsDuaLesson',
                pathParameters: {'lessonId': lesson.id},
              ),
              borderRadius: BorderRadius.circular(20),
              child: PremiumCard(
                surfaceVariant: AppSurfaceVariant.panel,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: _kidsNoorPanelDecoration(context),
                      child: Icon(lesson.icon, color: AppColors.accentGold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson.whenToSay,
                            style: const TextStyle(
                              color: AppColors.onSurfaceSubtle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _StatusChip(status: progress?.status),
                              const SizedBox(width: 8),
                              _LevelChip(level: lesson.level),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.accentGold,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _kidsNoorPillDecoration(context),
      child: Text(
        'L$level',
        style: const TextStyle(
          color: AppColors.accentGold,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final KidsDuaLessonStatus? status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    late final String label;
    late final Color background;
    late final Color foreground;
    switch (status) {
      case KidsDuaLessonStatus.learned:
        label = l10n.kidsDuaStatusLearned;
        background = const Color(0xFFE5F3E0);
        foreground = const Color(0xFF4E7A39);
        break;
      case KidsDuaLessonStatus.inProgress:
        label = l10n.kidsDuaStatusInProgress;
        background = const Color(0xFFFFF1DB);
        foreground = const Color(0xFF9B6B2E);
        break;
      case KidsDuaLessonStatus.notStarted:
      case null:
        label = l10n.kidsDuaStatusNotStarted;
        background = const Color(0xFFF2EEE8);
        foreground = const Color(0xFF6D6255);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _kidsNoorPillDecoration(context, tintColor: background),
      child: Text(
        label,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}

BoxDecoration _kidsNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _kidsNoorPanelDecoration(BuildContext context) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
  );
  return style.decoration(radius: 16);
}
