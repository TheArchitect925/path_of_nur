import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_teaching_controller.dart';
import '../application/quran_teaching_smart_review_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'quran_teaching_daily_review_page.dart';
import 'quran_teaching_lesson_page.dart';
import 'quran_teaching_listen_only_page.dart';
import 'quran_teaching_module_page.dart';
import 'quran_teaching_review_page.dart';
import 'widgets/quran_teaching_review_widgets.dart';

class QuranTeachingSectionPage extends ConsumerStatefulWidget {
  const QuranTeachingSectionPage({super.key});

  @override
  ConsumerState<QuranTeachingSectionPage> createState() =>
      _QuranTeachingSectionPageState();
}

class _QuranTeachingSectionPageState
    extends ConsumerState<QuranTeachingSectionPage> {
  bool _setupPromptShown = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(quranTeachingCatalogProvider);
    final progress = ref.watch(quranTeachingProgressProvider);
    final recommended = ref.watch(quranTeachingRecommendedLessonProvider);
    final weakLessons = ref.watch(quranTeachingWeakLessonsProvider);
    final recentLessons = ref.watch(quranTeachingRecentLessonsProvider);
    final mistakeItems = ref.watch(quranTeachingActiveMistakesProvider);
    final dailyReview = ref.watch(quranTeachingDailyReviewSummaryProvider);
    final reviewStats = ref.watch(quranTeachingReviewDashboardStatsProvider);
    final recommendations = ref.watch(
      quranTeachingPracticeRecommendationsProvider,
    );
    final query = _searchController.text.trim().toLowerCase();

    if (!_setupPromptShown && progress.learnerLevel == null) {
      _setupPromptShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSetupSheet(context, progress.learnerLevel);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quranTeachingSmartReviewProvider.notifier)
          .ensureTodaySession(
            catalog: catalog,
            progress: progress,
            mistakes: mistakeItems,
          );
    });

    final filteredModules =
        catalog.modules
            .where((module) {
              if (query.isEmpty) return true;
              if (module.title.toLowerCase().contains(query) ||
                  module.subtitle.toLowerCase().contains(query) ||
                  module.description.toLowerCase().contains(query)) {
                return true;
              }
              final lessons = catalog.lessonsForModule(module.id);
              for (final lesson in lessons) {
                if (lesson.title.toLowerCase().contains(query) ||
                    lesson.subtitle.toLowerCase().contains(query) ||
                    lesson.searchTerms.any(
                      (term) => term.toLowerCase().contains(query),
                    )) {
                  return true;
                }
              }
              for (final group in module.wordGroups) {
                if (group.title.toLowerCase().contains(query)) return true;
                for (final word in group.words) {
                  if (word.arabic.contains(query) ||
                      word.transliteration.toLowerCase().contains(query) ||
                      word.meaning.toLowerCase().contains(query)) {
                    return true;
                  }
                }
              }
              for (final surah in module.surahPractice) {
                if (surah.title.toLowerCase().contains(query) ||
                    surah.arabicTitle.contains(query)) {
                  return true;
                }
              }
              return false;
            })
            .toList(growable: true)
          ..sort((a, b) => a.order.compareTo(b.order));

    final totalLessons = catalog.lessons.length;
    final completedLessons = progress.completedLessonIds.length;
    final percent = totalLessons == 0 ? 0.0 : completedLessons / totalLessons;
    final continueLesson = progress.lastLessonId == null
        ? null
        : catalog.lessonById(progress.lastLessonId!);

    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      title: 'Learn Qur’anic Arabic',
      subtitle:
          'A calm, visual path for learning letters, sounds, words, and short Qur’anic phrases.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your reading path',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _levelSubtitle(progress.learnerLevel),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _showSetupSheet(context, progress.learnerLevel),
                    icon: const Icon(Icons.tune_rounded),
                    tooltip: l10n.accessibilityLearningSettings,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: percent,
                minHeight: 10,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 10),
              Text('$completedLessons of $totalLessons lessons completed'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ModeChip(label: _modeLabel(progress.accessMode)),
                  _ModeChip(
                    label: progress.visualModeEnabled
                        ? 'Visual Mode on'
                        : 'Standard Mode',
                  ),
                ],
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
                'Continue where you left off',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                continueLesson == null
                    ? 'Start with the recommended lesson below.'
                    : '${continueLesson.title} • ${continueLesson.subtitle}',
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  final lesson = continueLesson ?? recommended;
                  if (lesson == null) return;
                  final module = catalog.moduleById(lesson.moduleId);
                  if (module == null) return;
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuranTeachingLessonPage(
                        lesson: lesson,
                        module: module,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: Text(
                  continueLesson == null ? 'Start lesson' : 'Continue lesson',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        QuranTeachingDailyReviewCard(
          summary: dailyReview,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const QuranTeachingDailyReviewPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended next',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(recommended?.title ?? 'All caught up'),
                    if (recommended != null) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          final module = catalog.moduleById(
                            recommended.moduleId,
                          );
                          if (module == null) return;
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => QuranTeachingLessonPage(
                                lesson: recommended,
                                module: module,
                              ),
                            ),
                          );
                        },
                        child: const Text('Open'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visual Mode',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Picture anchors and gentler prompts for visual learners.',
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: progress.visualModeEnabled,
                      onChanged: (value) => ref
                          .read(quranTeachingProgressProvider.notifier)
                          .setVisualMode(value),
                      title: const Text('Use Visual Mode'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Listen Only',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Audio-first packs for passive repetition, self-testing, and bedtime review.',
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QuranTeachingListenOnlyPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.headphones_rounded),
                      label: const Text('Open Listen Only'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Mistakes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mistakeItems.isEmpty
                          ? 'No review items right now.'
                          : '${mistakeItems.length} items waiting for another pass.',
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QuranTeachingReviewPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        mistakeItems.isEmpty ? 'Open review' : 'Practice now',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review progress',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ModeChip(
                    label: '${reviewStats.lettersReviewed} letters reviewed',
                  ),
                  _ModeChip(
                    label: '${reviewStats.wordsRecognized} words recognized',
                  ),
                  _ModeChip(
                    label: '${reviewStats.phrasesPracticed} phrases practiced',
                  ),
                  _ModeChip(label: '${reviewStats.itemsDueToday} items due'),
                  _ModeChip(label: '${reviewStats.trickyItems} tricky items'),
                  _ModeChip(label: '${reviewStats.masteredCount} mastered'),
                ],
              ),
            ],
          ),
        ),
        if (recommendations.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Practice recommendations',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...recommendations.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: QuranTeachingRecommendationCard(recommendation: item),
            ),
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search letters, rules, words, or surahs',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        if (recentLessons.isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recently learned',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recentLessons
                      .take(4)
                      .map(
                        (lesson) => ActionChip(
                          label: Text(lesson.title),
                          onPressed: () {
                            final module = catalog.moduleById(lesson.moduleId);
                            if (module == null) return;
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => QuranTeachingLessonPage(
                                  lesson: lesson,
                                  module: module,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (weakLessons.isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Practice again',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text('These lessons need one more calm pass.'),
                const SizedBox(height: 10),
                ...weakLessons
                    .take(3)
                    .map(
                      (lesson) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• ${lesson.title}'),
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Learning path',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: catalog.modules
              .map(
                (module) => Chip(
                  avatar: Icon(
                    isModuleUnlocked(
                          module: module,
                          catalog: catalog,
                          progress: progress,
                        )
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    size: 18,
                  ),
                  label: Text(module.title),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 12),
        ...filteredModules.map((module) {
          final unlocked = isModuleUnlocked(
            module: module,
            catalog: catalog,
            progress: progress,
          );
          final completion = moduleCompletionPercent(
            module: module,
            catalog: catalog,
            progress: progress,
          );
          final recommendedHere = recommended?.moduleId == module.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: unlocked
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                QuranTeachingModulePage(module: module),
                          ),
                        );
                      }
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: module.color.withValues(alpha: 0.18),
                          child: Icon(module.icon, color: module.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      module.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  if (recommendedHere)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        color: module.color.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                      child: Text(
                                        'Recommended',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(module.subtitle),
                              const SizedBox(height: 4),
                              Text(
                                module.description,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceSubtle,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: completion,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      unlocked
                          ? '${(completion * 100).round()}% complete'
                          : 'Locked until earlier guided lessons are complete',
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

  Future<void> _showSetupSheet(
    BuildContext context,
    QuranTeachingLearnerLevel? current,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your reading level',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps Path of Nūr open lessons in the right order and keep the pace calm for your level.',
              ),
              const SizedBox(height: 16),
              ...QuranTeachingLearnerLevel.values.map(
                (level) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      ref
                          .read(quranTeachingProgressProvider.notifier)
                          .setLearnerLevel(level);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: current == level
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.surfaceSoft,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _levelLabel(level),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(_levelDescription(level)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surfaceSoft.withValues(alpha: 0.75),
      ),
      child: Text(label),
    );
  }
}

String _modeLabel(QuranTeachingAccessMode mode) {
  switch (mode) {
    case QuranTeachingAccessMode.guided:
      return 'Guided unlocks';
    case QuranTeachingAccessMode.broad:
      return 'Broader unlocks';
    case QuranTeachingAccessMode.open:
      return 'Open reference';
  }
}

String _levelLabel(QuranTeachingLearnerLevel level) {
  switch (level) {
    case QuranTeachingLearnerLevel.completelyNew:
      return 'I’m completely new';
    case QuranTeachingLearnerLevel.knowSomeLetters:
      return 'I know some letters';
    case QuranTeachingLearnerLevel.readSlowly:
      return 'I can read slowly';
    case QuranTeachingLearnerLevel.improveReading:
      return 'I can read Qur’an and want to improve';
    case QuranTeachingLearnerLevel.openReference:
      return 'I just want open access / reference';
  }
}

String _levelDescription(QuranTeachingLearnerLevel level) {
  switch (level) {
    case QuranTeachingLearnerLevel.completelyNew:
      return 'Strict guided steps. Best for complete beginners, children, and anyone wanting a calm path from the start.';
    case QuranTeachingLearnerLevel.knowSomeLetters:
      return 'Opens early modules together while still showing a recommended order.';
    case QuranTeachingLearnerLevel.readSlowly:
      return 'Keeps guidance visible but unlocks broader practice groups sooner.';
    case QuranTeachingLearnerLevel.improveReading:
      return 'Useful for existing readers who want rules, phrases, and review without heavy restriction.';
    case QuranTeachingLearnerLevel.openReference:
      return 'Everything stays open for review, lookup, and self-directed study.';
  }
}

String _levelSubtitle(QuranTeachingLearnerLevel? level) {
  if (level == null) {
    return 'Choose your level so the app can unlock lessons in the right way for you.';
  }
  return '${_levelLabel(level)} • ${_modeLabel(const QuranTeachingProgressState().copyWith(learnerLevel: level).accessMode)}';
}
