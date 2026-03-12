import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/life_progress_provider.dart';
import '../data/life_curriculum_data.dart';
import '../domain/life_models.dart';

enum _LifeLandingTab { overview, themes, lessons }

class LifeLandingPage extends ConsumerStatefulWidget {
  const LifeLandingPage({super.key});

  @override
  ConsumerState<LifeLandingPage> createState() => _LifeLandingPageState();
}

class _LifeLandingPageState extends ConsumerState<LifeLandingPage> {
  late final TextEditingController _searchController;
  _LifeLandingTab _tab = _LifeLandingTab.overview;
  String? _selectedThemeId;
  LifeLessonStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(lifeProgressSummaryProvider);
    final themes = ref.watch(lifeSuggestedThemeOrderProvider);
    final allLessons = lifeCurriculum.lessons;

    final continueLesson = progress.continueLessonId == null
        ? null
        : lifeLessonById(progress.continueLessonId!);
    final featuredLesson = lifeLessonById(lifeCurriculum.featuredLessonId);
    final suggestedLesson = progress.suggestedNextLessonId == null
        ? null
        : lifeLessonById(progress.suggestedNextLessonId!);

    final query = _searchController.text.trim().toLowerCase();
    final filteredLessons = allLessons
        .where((lesson) {
          if (_selectedThemeId != null && lesson.themeId != _selectedThemeId) {
            return false;
          }
          final status = _statusFor(lesson.id);
          if (_selectedStatus != null && status != _selectedStatus) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack =
              '${lesson.title} ${lesson.subtitle} ${lesson.overview}'
                  .toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.learnLifeSectionTitle,
      subtitle: l10n.learnLifeSectionSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedPillControl<_LifeLandingTab>(
                items: _LifeLandingTab.values,
                selectedItem: _tab,
                labelBuilder: _tabLabel,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search lessons, themes, and topics',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(
                      label: _selectedThemeId == null
                          ? 'Theme: Any'
                          : 'Theme: ${lifeThemeById(_selectedThemeId!)?.title ?? _selectedThemeId!}',
                      onTap: () => _showThemePicker(context, themes),
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: _selectedStatus == null
                          ? 'Status: Any'
                          : 'Status: ${_statusLabel(l10n, _selectedStatus!)}',
                      onTap: () => _showStatusPicker(context, l10n),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedThemeId != null ||
                        _selectedStatus != null ||
                        query.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedThemeId = null;
                            _selectedStatus = null;
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear_rounded),
                        label: const Text('Clear'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_tab == _LifeLandingTab.overview) ...[
          _progressCard(context, l10n, progress),
          const SizedBox(height: 12),
          _lessonSurface(
            context,
            title: l10n.lifeContinueLearningTitle,
            lesson: continueLesson,
            emptyText: l10n.learnResumeTopicSubtitleEmpty,
          ),
          const SizedBox(height: 12),
          _lessonSurface(
            context,
            title: l10n.lifeFeaturedLessonTitle,
            lesson: featuredLesson,
            emptyText: l10n.learnContentNotFound,
          ),
          const SizedBox(height: 12),
          _lessonSurface(
            context,
            title: l10n.lifeSuggestedNextLessonTitle,
            lesson: suggestedLesson,
            emptyText: l10n.learnResumeTopicSubtitleEmpty,
          ),
          const SizedBox(height: 12),
          _recentCard(context, l10n, progress),
        ],
        if (_tab == _LifeLandingTab.themes) ...[
          ...themes.map((theme) {
            final themeProgress = ref.watch(
              lifeThemeProgressProvider(theme.id),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(theme.title),
                  subtitle: Text(
                    '${theme.summary}\n${themeProgress.completedLessons}/${themeProgress.totalLessons} completed',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(
                    'lifeThemeDetail',
                    pathParameters: {'themeId': theme.id},
                  ),
                ),
              ),
            );
          }),
        ],
        if (_tab == _LifeLandingTab.lessons) ...[
          if (filteredLessons.isEmpty)
            const PremiumCard(
              child: Text('No lessons match your current search and filters.'),
            )
          else
            ...filteredLessons.map((lesson) {
              final status = _statusFor(lesson.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lesson.title),
                    subtitle: Text(
                      '${lesson.subtitle}\n${_statusLabel(l10n, status)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      'lifeLessonDetail',
                      pathParameters: {'lessonId': lesson.id},
                    ),
                  ),
                ),
              );
            }),
        ],
      ],
    );
  }

  Widget _progressCard(
    BuildContext context,
    AppLocalizations l10n,
    LifeProgressSummary progress,
  ) {
    return PremiumCard(
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
    );
  }

  Widget _lessonSurface(
    BuildContext context, {
    required String title,
    required LifeLesson? lesson,
    required String emptyText,
  }) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (lesson == null)
            Text(emptyText)
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(lesson.title),
              subtitle: Text(lesson.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(
                'lifeLessonDetail',
                pathParameters: {'lessonId': lesson.id},
              ),
            ),
        ],
      ),
    );
  }

  Widget _recentCard(
    BuildContext context,
    AppLocalizations l10n,
    LifeProgressSummary progress,
  ) {
    return PremiumCard(
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
    );
  }

  Widget _filterChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFCEB07D)),
          color: const Color(0xFFFAF3E8),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.3)),
      ),
    );
  }

  void _showThemePicker(BuildContext context, List<LifeTheme> themes) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('Any theme'),
                onTap: () {
                  setState(() => _selectedThemeId = null);
                  Navigator.of(context).pop();
                },
              ),
              ...themes.map(
                (theme) => ListTile(
                  title: Text(theme.title),
                  onTap: () {
                    setState(() => _selectedThemeId = theme.id);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('Any status'),
                onTap: () {
                  setState(() => _selectedStatus = null);
                  Navigator.of(context).pop();
                },
              ),
              ...LifeLessonStatus.values.map(
                (status) => ListTile(
                  title: Text(_statusLabel(l10n, status)),
                  onTap: () {
                    setState(() => _selectedStatus = status);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LifeLessonStatus _statusFor(String lessonId) {
    return ref
            .watch(lifeProgressProvider)
            .lessonProgressById[lessonId]
            ?.status ??
        LifeLessonStatus.notStarted;
  }

  String _tabLabel(_LifeLandingTab tab) {
    switch (tab) {
      case _LifeLandingTab.overview:
        return 'Overview';
      case _LifeLandingTab.themes:
        return 'Themes';
      case _LifeLandingTab.lessons:
        return 'Lessons';
    }
  }

  String _statusLabel(AppLocalizations l10n, LifeLessonStatus status) {
    switch (status) {
      case LifeLessonStatus.notStarted:
        return l10n.lifeStatusNotStarted;
      case LifeLessonStatus.inProgress:
        return l10n.lifeStatusInProgress;
      case LifeLessonStatus.completed:
        return l10n.lifeStatusCompleted;
    }
  }
}
