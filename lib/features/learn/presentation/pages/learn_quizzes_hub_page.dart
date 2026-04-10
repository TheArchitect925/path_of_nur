// FREE ACCESS: no path-gating — all content accessible ✓
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../hadith/data/seeded_hadith_path_quiz_data.dart';
import '../../prophets/application/prophet_quiz_pool_service.dart';
import '../../prophets/domain/prophet_quiz.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../widgets/learn_section_header.dart';

enum LearnQuizFilter {
  all,
  trivia,
  prophets,
  hadith,
  crossword,
  wordSearch,
  matching,
  ayahCompletion,
  hadithReflection,
  dailyKnowledge,
  review,
}

class LearnQuizzesHubPage extends ConsumerStatefulWidget {
  const LearnQuizzesHubPage({
    super.key,
    this.initialFilter = LearnQuizFilter.all,
  });

  final LearnQuizFilter initialFilter;

  @override
  ConsumerState<LearnQuizzesHubPage> createState() =>
      _LearnQuizzesHubPageState();
}

class _LearnQuizzesHubPageState extends ConsumerState<LearnQuizzesHubPage> {
  late final TextEditingController _searchController;
  LearnQuizFilter _filter = LearnQuizFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filter = widget.initialFilter;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final items = _allQuizItems();
    final filtered = items
        .where(_matchesFilter)
        .where(_matchesQuery)
        .toList(growable: false);
    final triviaItems = filtered
        .where((item) => item.module == 'Trivia' && item.group != 'Review')
        .toList(growable: false);
    final prophetItems = filtered
        .where((item) => item.module == 'Prophets')
        .toList(growable: false);
    final hadithItems = filtered
        .where((item) => item.module == 'Hadith' && item.group != 'Review')
        .toList(growable: false);
    final crosswordItems = filtered
        .where((item) => item.module == 'Crossword')
        .toList(growable: false);
    final wordSearchItems = filtered
        .where((item) => item.module == 'Word Search')
        .toList(growable: false);
    final matchingItems = filtered
        .where((item) => item.module == 'Matching')
        .toList(growable: false);
    final ayahCompletionItems = filtered
        .where((item) => item.module == 'Ayah Completion')
        .toList(growable: false);
    final hadithReflectionItems = filtered
        .where((item) => item.module == 'Hadith Reflection')
        .toList(growable: false);
    final dailyKnowledgeItems = filtered
        .where((item) => item.module == 'Daily Knowledge')
        .toList(growable: false);
    final reviewItems = filtered
        .where((item) => item.group == 'Review')
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: Icons.quiz_rounded,
      title: l10n.learnCategoryQuizzesTitle,
      subtitle: l10n.learnQuizzesHubSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LearnDiscoverySearchField(
                controller: _searchController,
                hintText: l10n.searchQuizzesHint,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: LearnQuizFilter.values
                      .map((filter) {
                        final selected = _filter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _filter = filter),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: _noorPillDecoration(
                                context,
                                tintColor: selected
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.14)
                                    : null,
                              ),
                              child: Text(_filterLabel(filter)),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _summaryCard(context, l10n, numberFormat, items.length),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.learnQuizzesNoMatchTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.learnQuizzesNoMatchSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          )
        else ...[
          if (dailyKnowledgeItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesDailyKnowledgeSectionTitle,
              l10n.learnQuizzesDailyKnowledgeSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...dailyKnowledgeItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (triviaItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnCategoryIslamicTriviaTitle,
              l10n.learnHubSubcategoryIslamicTriviaSubtitle,
            ),
            const SizedBox(height: 8),
            ...triviaItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (prophetItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesProphetsSectionTitle,
              l10n.learnQuizzesProphetsSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...prophetItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (hadithItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesHadithSectionTitle,
              l10n.learnQuizzesHadithSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...hadithItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (crosswordItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesCrosswordSectionTitle,
              l10n.learnQuizzesCrosswordSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...crosswordItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (wordSearchItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesWordSearchSectionTitle,
              l10n.learnQuizzesWordSearchSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...wordSearchItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (matchingItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesMatchingSectionTitle,
              l10n.learnQuizzesMatchingSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...matchingItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (ayahCompletionItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesAyahCompletionSectionTitle,
              l10n.learnQuizzesAyahCompletionSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...ayahCompletionItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (hadithReflectionItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesHadithReflectionSectionTitle,
              l10n.learnQuizzesHadithReflectionSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...hadithReflectionItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (reviewItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              l10n.learnQuizzesReviewSectionTitle,
              l10n.learnQuizzesReviewSectionSubtitle,
            ),
            const SizedBox(height: 8),
            ...reviewItems.map(_quizCard),
          ],
        ],
      ],
    );
  }

  Widget _summaryCard(
    BuildContext context,
    AppLocalizations l10n,
    NumberFormat numberFormat,
    int total,
  ) {
    return PremiumCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip(l10n.learnQuizzesAvailableCount(numberFormat.format(total))),
          _chip(
            l10n.learnQuizzesHadithChapterCount(
              numberFormat.format(seededHadithChapterQuizzes.length),
            ),
          ),
          _chip(
            l10n.learnQuizzesProphetModeCount(
              numberFormat.format(ProphetQuizMode.values.length),
            ),
          ),
          _chip(l10n.learnQuizzesLearningModulesLive('6')),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, String subtitle) {
    return LearnSectionHeader(title: title, subtitle: subtitle);
  }

  Widget _quizCard(_QuizCatalogItem item) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(item.moduleLabel ?? _moduleLabel(l10n, item.module)),
                _chip(item.groupLabel ?? _groupLabel(l10n, item.group)),
                if (item.questionCount != null)
                  _chip(
                    l10n.triviaQuestionsCount(
                      numberFormat.format(item.questionCount!),
                    ),
                  ),
                if (item.difficultyLabel != null) _chip(item.difficultyLabel!),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed(
                item.routeName,
                pathParameters: item.pathParameters,
                queryParameters: item.queryParameters,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(item.ctaLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _noorPillDecoration(context),
      child: Text(label),
    );
  }

  BoxDecoration _noorPillDecoration(BuildContext context, {Color? tintColor}) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: tintColor,
    );
    return style.decoration(radius: 999);
  }

  List<_QuizCatalogItem> _allQuizItems() {
    final prophetPool = ProphetQuizPoolService.buildExpandedPool();
    final prophetItems = ProphetQuizMode.values.map((mode) {
      final count = prophetPool
          .where((question) => question.mode == mode)
          .length;
      return _QuizCatalogItem(
        id: 'prophets_${mode.name}',
        module: 'Prophets',
        group: 'Mode Quiz',
        title: _prophetModeLabel(mode),
        subtitle: _prophetModeSummary(mode),
        questionCount: count,
        difficultyLabel: AppLocalizations.of(context).learnQuizzesStartsAtEasy,
        routeName: 'learnProphetsHub',
        queryParameters: {
          'tab': 'quiz',
          'quizMode': mode.name,
          'quizDifficulty': ProphetQuizDifficulty.easy.name,
        },
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenProphetQuiz,
      );
    });

    final hadithChapterItems = seededHadithChapterQuizzes.map((quiz) {
      return _QuizCatalogItem(
        id: quiz.id,
        module: 'Hadith',
        group: 'Chapter Quiz',
        title: quiz.title,
        subtitle: quiz.description,
        questionCount: quiz.questions.length,
        routeName: 'hadithChapterQuiz',
        pathParameters: {'pathId': quiz.pathId, 'chapterId': quiz.chapterId},
        ctaLabel: AppLocalizations.of(context).learnQuizzesStartChapterQuiz,
      );
    });

    final triviaItems = [
      _QuizCatalogItem(
        id: 'trivia_home',
        module: 'Trivia',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(
          context,
        ).learnCategoryIslamicTriviaTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).learnCategoryIslamicTriviaTitle,
        subtitle: AppLocalizations.of(context).triviaHomeSubtitle,
        routeName: 'learnQuizzesTriviaHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenIslamicTrivia,
      ),
      _QuizCatalogItem(
        id: 'trivia_paths',
        module: 'Trivia',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(
          context,
        ).learnCategoryIslamicTriviaTitle,
        groupLabel: AppLocalizations.of(context).triviaHomeKnowledgePathsTitle,
        title: AppLocalizations.of(context).triviaHomeKnowledgePathsTitle,
        subtitle: AppLocalizations.of(context).triviaKnowledgePathsPageSubtitle,
        routeName: 'learnTriviaKnowledgePaths',
        ctaLabel: AppLocalizations.of(
          context,
        ).triviaHomeOpenKnowledgePathsAction,
      ),
    ];

    final crosswordItems = [
      _QuizCatalogItem(
        id: 'crossword_home',
        module: 'Crossword',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).crosswordHomeTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).crosswordHomeTitle,
        subtitle: AppLocalizations.of(context).crosswordHomeSubtitle,
        routeName: 'learnCrosswordHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenCrossword,
      ),
    ];

    final wordSearchItems = [
      _QuizCatalogItem(
        id: 'word_search_home',
        module: 'Word Search',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).wordSearchHomeTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).wordSearchHomeTitle,
        subtitle: AppLocalizations.of(context).wordSearchHomeSubtitle,
        routeName: 'learnWordSearchHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenWordSearch,
      ),
    ];

    final matchingItems = [
      _QuizCatalogItem(
        id: 'matching_home',
        module: 'Matching',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).matchingHomeTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).matchingHomeTitle,
        subtitle: AppLocalizations.of(context).matchingHomeSubtitle,
        routeName: 'learnMatchingHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenMatching,
      ),
    ];

    final ayahCompletionItems = [
      _QuizCatalogItem(
        id: 'ayah_completion_home',
        module: 'Ayah Completion',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).ayahCompletionHomeTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).ayahCompletionHomeTitle,
        subtitle: AppLocalizations.of(context).ayahCompletionHomeSubtitle,
        routeName: 'learnAyahCompletionHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenAyahCompletion,
      ),
    ];

    final hadithReflectionItems = [
      _QuizCatalogItem(
        id: 'hadith_reflection_home',
        module: 'Hadith Reflection',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).hadithReflectionHomeTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).hadithReflectionHomeTitle,
        subtitle: AppLocalizations.of(context).hadithReflectionHomeSubtitle,
        routeName: 'learnHadithReflectionHome',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenHadithReflection,
      ),
    ];

    final dailyKnowledgeItems = [
      _QuizCatalogItem(
        id: 'daily_knowledge_hub',
        module: 'Daily Knowledge',
        group: 'Mode Quiz',
        moduleLabel: AppLocalizations.of(context).dailyKnowledgeHubTitle,
        groupLabel: AppLocalizations.of(context).learnCategoryQuizzesTitle,
        title: AppLocalizations.of(context).dailyKnowledgeHubTitle,
        subtitle: AppLocalizations.of(context).dailyKnowledgeHubSubtitle,
        routeName: 'learnDailyKnowledgeHub',
        ctaLabel: AppLocalizations.of(context).learnQuizzesOpenDailyKnowledge,
      ),
    ];

    final reviewItems = [
      _QuizCatalogItem(
        id: 'trivia_review_queue',
        module: 'Trivia',
        group: 'Review',
        moduleLabel: AppLocalizations.of(
          context,
        ).learnCategoryIslamicTriviaTitle,
        title: AppLocalizations.of(context).triviaReviewMistakesTitle,
        subtitle: AppLocalizations.of(context).triviaReviewMistakesSubtitle,
        routeName: 'learnTriviaReview',
        ctaLabel: AppLocalizations.of(context).triviaReviewMistakesAction,
      ),
      _QuizCatalogItem(
        id: 'trivia_stats',
        module: 'Trivia',
        group: 'Review',
        moduleLabel: AppLocalizations.of(
          context,
        ).learnCategoryIslamicTriviaTitle,
        title: AppLocalizations.of(context).triviaHomeProgressStatsAction,
        subtitle: AppLocalizations.of(context).triviaStatsSubtitle,
        routeName: 'learnTriviaStats',
        ctaLabel: AppLocalizations.of(context).triviaHomeProgressStatsAction,
      ),
      _QuizCatalogItem(
        id: 'hadith_review_random',
        module: 'Hadith',
        group: 'Review',
        title: 'Random Hadith Review',
        subtitle: AppLocalizations.of(
          context,
        ).learnQuizzesRandomHadithReviewSubtitle,
        routeName: 'hadithReviewQuiz',
        queryParameters: const {'mode': 'random'},
        ctaLabel: AppLocalizations.of(context).triviaReviewStartAction,
      ),
      _QuizCatalogItem(
        id: 'hadith_review_weekly',
        module: 'Hadith',
        group: 'Review',
        title: AppLocalizations.of(context).learnQuizzesWeeklyKnowledgeCheck,
        subtitle: AppLocalizations.of(
          context,
        ).learnQuizzesWeeklyKnowledgeCheckSubtitle,
        routeName: 'hadithReviewQuiz',
        queryParameters: const {'mode': 'weekly'},
        ctaLabel: AppLocalizations.of(context).learnQuizzesStartWeeklyQuiz,
      ),
    ];

    return [
      ...dailyKnowledgeItems,
      ...triviaItems,
      ...prophetItems,
      ...hadithChapterItems,
      ...crosswordItems,
      ...wordSearchItems,
      ...matchingItems,
      ...ayahCompletionItems,
      ...hadithReflectionItems,
      ...reviewItems,
    ];
  }

  bool _matchesFilter(_QuizCatalogItem item) {
    switch (_filter) {
      case LearnQuizFilter.all:
        return true;
      case LearnQuizFilter.trivia:
        return item.module == 'Trivia';
      case LearnQuizFilter.prophets:
        return item.module == 'Prophets';
      case LearnQuizFilter.hadith:
        return item.module == 'Hadith' && item.group != 'Review';
      case LearnQuizFilter.review:
        return item.group == 'Review';
      case LearnQuizFilter.crossword:
        return item.module == 'Crossword';
      case LearnQuizFilter.wordSearch:
        return item.module == 'Word Search';
      case LearnQuizFilter.matching:
        return item.module == 'Matching';
      case LearnQuizFilter.ayahCompletion:
        return item.module == 'Ayah Completion';
      case LearnQuizFilter.hadithReflection:
        return item.module == 'Hadith Reflection';
      case LearnQuizFilter.dailyKnowledge:
        return item.module == 'Daily Knowledge';
    }
  }

  bool _matchesQuery(_QuizCatalogItem item) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;
    final haystack = [
      item.title,
      item.subtitle,
      item.module,
      item.group,
      item.moduleLabel ?? '',
      item.groupLabel ?? '',
      item.difficultyLabel ?? '',
      item.ctaLabel,
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  String _filterLabel(LearnQuizFilter filter) {
    final l10n = AppLocalizations.of(context);
    switch (filter) {
      case LearnQuizFilter.all:
        return l10n.learnHubCategoryGroupAll;
      case LearnQuizFilter.trivia:
        return l10n.learnCategoryIslamicTriviaTitle;
      case LearnQuizFilter.prophets:
        return l10n.learnHubItemTypeProphet;
      case LearnQuizFilter.hadith:
        return l10n.learnHubItemTypeHadith;
      case LearnQuizFilter.review:
        return l10n.learnQuizzesFilterReview;
      case LearnQuizFilter.crossword:
        return l10n.crosswordHomeTitle;
      case LearnQuizFilter.wordSearch:
        return l10n.wordSearchHomeTitle;
      case LearnQuizFilter.matching:
        return l10n.matchingHomeTitle;
      case LearnQuizFilter.ayahCompletion:
        return l10n.ayahCompletionHomeTitle;
      case LearnQuizFilter.hadithReflection:
        return l10n.hadithReflectionHomeTitle;
      case LearnQuizFilter.dailyKnowledge:
        return l10n.dailyKnowledgeHubTitle;
    }
  }

  String _prophetModeLabel(ProphetQuizMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return l10n.learnQuizzesProphetModeIdentification;
      case ProphetQuizMode.timelineOrder:
        return l10n.learnQuizzesProphetModeTimeline;
      case ProphetQuizMode.storyMatching:
        return l10n.learnQuizzesProphetModeStoryMatching;
      case ProphetQuizMode.quranReference:
        return l10n.learnQuizzesProphetModeQuranReference;
      case ProphetQuizMode.lessonRecognition:
        return l10n.learnQuizzesProphetModeLessonRecognition;
    }
  }

  String _prophetModeSummary(ProphetQuizMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return l10n.learnQuizzesProphetModeIdentificationSubtitle;
      case ProphetQuizMode.timelineOrder:
        return l10n.learnQuizzesProphetModeTimelineSubtitle;
      case ProphetQuizMode.storyMatching:
        return l10n.learnQuizzesProphetModeStoryMatchingSubtitle;
      case ProphetQuizMode.quranReference:
        return l10n.learnQuizzesProphetModeQuranReferenceSubtitle;
      case ProphetQuizMode.lessonRecognition:
        return l10n.learnQuizzesProphetModeLessonRecognitionSubtitle;
    }
  }

  String _moduleLabel(AppLocalizations l10n, String module) {
    switch (module) {
      case 'Prophets':
        return l10n.learnHubItemTypeProphet;
      case 'Hadith':
        return l10n.learnHubItemTypeHadith;
      case 'Crossword':
        return l10n.crosswordHomeTitle;
      case 'Word Search':
        return l10n.wordSearchHomeTitle;
      case 'Matching':
        return l10n.matchingHomeTitle;
      case 'Ayah Completion':
        return l10n.ayahCompletionHomeTitle;
      case 'Hadith Reflection':
        return l10n.hadithReflectionHomeTitle;
      case 'Daily Knowledge':
        return l10n.dailyKnowledgeHubTitle;
      default:
        return module;
    }
  }

  String _groupLabel(AppLocalizations l10n, String group) {
    switch (group) {
      case 'Mode Quiz':
        return l10n.learnQuizzesModeQuizGroup;
      case 'Chapter Quiz':
        return l10n.learnQuizzesChapterQuizGroup;
      case 'Review':
        return l10n.learnQuizzesFilterReview;
      default:
        return group;
    }
  }
}

LearnQuizFilter learnQuizFilterFromQuery(String? value) {
  switch (value) {
    case 'trivia':
      return LearnQuizFilter.trivia;
    case 'prophets':
      return LearnQuizFilter.prophets;
    case 'hadith':
      return LearnQuizFilter.hadith;
    case 'review':
      return LearnQuizFilter.review;
    case 'crossword':
      return LearnQuizFilter.crossword;
    case 'word-search':
      return LearnQuizFilter.wordSearch;
    case 'matching':
      return LearnQuizFilter.matching;
    case 'ayah-completion':
      return LearnQuizFilter.ayahCompletion;
    case 'hadith-reflection':
      return LearnQuizFilter.hadithReflection;
    case 'daily-knowledge':
      return LearnQuizFilter.dailyKnowledge;
    case 'all':
    default:
      return LearnQuizFilter.all;
  }
}

class _QuizCatalogItem {
  const _QuizCatalogItem({
    required this.id,
    required this.module,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.routeName,
    required this.ctaLabel,
    this.moduleLabel,
    this.groupLabel,
    this.questionCount,
    this.difficultyLabel,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final String module;
  final String group;
  final String title;
  final String subtitle;
  final String? moduleLabel;
  final String? groupLabel;
  final int? questionCount;
  final String? difficultyLabel;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String ctaLabel;
}
