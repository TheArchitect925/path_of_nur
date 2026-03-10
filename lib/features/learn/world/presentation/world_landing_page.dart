import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../application/world_progress_provider.dart';
import '../data/world_curriculum_data.dart';

class WorldLandingPage extends ConsumerWidget {
  const WorldLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(worldProgressSummaryProvider);
    final themes = ref.watch(worldSuggestedThemeOrderProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);

    final continueLesson = progress.continueLessonId == null
        ? null
        : worldLessonById(progress.continueLessonId!);
    final featuredLesson = worldLessonById(worldCurriculum.featuredLessonId);
    final suggestedLesson = progress.suggestedNextLessonId == null
        ? null
        : worldLessonById(progress.suggestedNextLessonId!);

    return AppPageScaffold(
      headerIcon: Icons.public_rounded,
      title: l10n.learnWorldSectionTitle,
      subtitle: l10n.learnWorldSectionSubtitle,
      children: [
        if (unified.continueItem != null)
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.learnContentContinueTitle),
              subtitle: Text(unified.continueItem!.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(
                unified.continueItem!.routeName,
                pathParameters: unified.continueItem!.pathParameters,
                queryParameters: unified.continueItem!.queryParameters,
              ),
            ),
          ),
        if (unified.continueItem != null) const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldProgressOverviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.worldProgressOverviewBody(
                  progress.completedCount,
                  progress.totalLessons,
                  progress.inProgressCount,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress.completionRatio,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (continueLesson != null)
          _LessonSurface(
            title: l10n.worldContinueLearningTitle,
            lessonTitle: continueLesson.title,
            lessonSubtitle: continueLesson.subtitle,
            onTap: () => context.pushNamed(
              'worldLessonDetail',
              pathParameters: {'lessonId': continueLesson.id},
            ),
          )
        else
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.worldContinueLearningTitle),
              subtitle: Text(l10n.learnResumeTopicSubtitleEmpty),
            ),
          ),
        const SizedBox(height: 12),
        if (featuredLesson != null)
          _LessonSurface(
            title: l10n.worldFeaturedLessonTitle,
            lessonTitle: featuredLesson.title,
            lessonSubtitle: featuredLesson.subtitle,
            onTap: () => context.pushNamed(
              'worldLessonDetail',
              pathParameters: {'lessonId': featuredLesson.id},
            ),
          ),
        if (featuredLesson != null) const SizedBox(height: 12),
        if (suggestedLesson != null)
          _LessonSurface(
            title: l10n.worldSuggestedNextLessonTitle,
            lessonTitle: suggestedLesson.title,
            lessonSubtitle: suggestedLesson.subtitle,
            onTap: () => context.pushNamed(
              'worldLessonDetail',
              pathParameters: {'lessonId': suggestedLesson.id},
            ),
          ),
        if (suggestedLesson != null) const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.worldSuggestedPathTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...themes.map(
                (theme) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• ${theme.title}'),
                ),
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
                l10n.worldBrowseByThemeTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...themes.map(
                (theme) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(theme.title),
                    subtitle: Text(theme.summary),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      'worldThemeDetail',
                      pathParameters: {'themeId': theme.id},
                    ),
                  ),
                ),
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
                l10n.worldRecentOpenedTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (progress.recentLessonIds.isEmpty)
                Text(l10n.learnResumeTopicSubtitleEmpty),
              ...progress.recentLessonIds.map((id) {
                final lesson = worldLessonById(id);
                if (lesson == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => context.pushNamed(
                      'worldLessonDetail',
                      pathParameters: {'lessonId': lesson.id},
                    ),
                    child: Text('• ${lesson.title}'),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _LessonSurface extends StatelessWidget {
  const _LessonSurface({
    required this.title,
    required this.lessonTitle,
    required this.lessonSubtitle,
    required this.onTap,
  });

  final String title;
  final String lessonTitle;
  final String lessonSubtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(lessonTitle),
            subtitle: Text(lessonSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
