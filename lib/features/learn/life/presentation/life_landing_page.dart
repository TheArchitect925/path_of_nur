import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../application/life_progress_provider.dart';
import '../data/life_curriculum_data.dart';

class LifeLandingPage extends ConsumerWidget {
  const LifeLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(lifeProgressSummaryProvider);
    final themes = ref.watch(lifeSuggestedThemeOrderProvider);
    final unified = ref.watch(learnUnifiedSummaryProvider);

    final continueLesson = progress.continueLessonId == null
        ? null
        : lifeLessonById(progress.continueLessonId!);
    final featuredLesson = lifeLessonById(lifeCurriculum.featuredLessonId);
    final suggestedLesson = progress.suggestedNextLessonId == null
        ? null
        : lifeLessonById(progress.suggestedNextLessonId!);

    return AppPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.learnLifeSectionTitle,
      subtitle: l10n.learnLifeSectionSubtitle,
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
                l10n.lifeProgressOverviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.lifeProgressOverviewBody(
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
            title: l10n.lifeContinueLearningTitle,
            lessonTitle: continueLesson.title,
            lessonSubtitle: continueLesson.subtitle,
            onTap: () => context.pushNamed(
              'lifeLessonDetail',
              pathParameters: {'lessonId': continueLesson.id},
            ),
          )
        else
          PremiumCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.lifeContinueLearningTitle),
              subtitle: Text(l10n.learnResumeTopicSubtitleEmpty),
            ),
          ),
        const SizedBox(height: 12),
        if (featuredLesson != null)
          _LessonSurface(
            title: l10n.lifeFeaturedLessonTitle,
            lessonTitle: featuredLesson.title,
            lessonSubtitle: featuredLesson.subtitle,
            onTap: () => context.pushNamed(
              'lifeLessonDetail',
              pathParameters: {'lessonId': featuredLesson.id},
            ),
          ),
        if (featuredLesson != null) const SizedBox(height: 12),
        if (suggestedLesson != null)
          _LessonSurface(
            title: l10n.lifeSuggestedNextLessonTitle,
            lessonTitle: suggestedLesson.title,
            lessonSubtitle: suggestedLesson.subtitle,
            onTap: () => context.pushNamed(
              'lifeLessonDetail',
              pathParameters: {'lessonId': suggestedLesson.id},
            ),
          ),
        if (suggestedLesson != null) const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lifeSuggestedPathTitle,
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
                l10n.lifeBrowseByThemeTitle,
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
                      'lifeThemeDetail',
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
                l10n.lifeRecentOpenedTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (progress.recentLessonIds.isEmpty)
                Text(l10n.learnResumeTopicSubtitleEmpty),
              ...progress.recentLessonIds.map((id) {
                final lesson = lifeLessonById(id);
                if (lesson == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => context.pushNamed(
                      'lifeLessonDetail',
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
