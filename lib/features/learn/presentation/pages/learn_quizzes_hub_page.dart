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
import '../widgets/learn_hub_page_scaffold.dart';

enum LearnQuizFilter { all, prophets, hadith, review }

class LearnQuizzesHubPage extends ConsumerStatefulWidget {
  const LearnQuizzesHubPage({super.key});

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
    final prophetItems = filtered
        .where((item) => item.module == 'Prophets')
        .toList(growable: false);
    final hadithItems = filtered
        .where((item) => item.module == 'Hadith' && item.group != 'Review')
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
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.learnQuizzesSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: LearnQuizFilter.values
                      .map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_filterLabel(filter)),
                            selected: _filter == filter,
                            onSelected: (_) => setState(() => _filter = filter),
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
          _chip(l10n.learnQuizzesLearningModulesLive('2')),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
      ],
    );
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
                _chip(_moduleLabel(l10n, item.module)),
                _chip(_groupLabel(l10n, item.group)),
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
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999),
      child: Text(label),
    );
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

    final reviewItems = [
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

    return [...prophetItems, ...hadithChapterItems, ...reviewItems];
  }

  bool _matchesFilter(_QuizCatalogItem item) {
    switch (_filter) {
      case LearnQuizFilter.all:
        return true;
      case LearnQuizFilter.prophets:
        return item.module == 'Prophets';
      case LearnQuizFilter.hadith:
        return item.module == 'Hadith' && item.group != 'Review';
      case LearnQuizFilter.review:
        return item.group == 'Review';
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
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  String _filterLabel(LearnQuizFilter filter) {
    final l10n = AppLocalizations.of(context);
    switch (filter) {
      case LearnQuizFilter.all:
        return l10n.learnHubCategoryGroupAll;
      case LearnQuizFilter.prophets:
        return l10n.learnHubItemTypeProphet;
      case LearnQuizFilter.hadith:
        return l10n.learnHubItemTypeHadith;
      case LearnQuizFilter.review:
        return l10n.learnQuizzesFilterReview;
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

class _QuizCatalogItem {
  const _QuizCatalogItem({
    required this.id,
    required this.module,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.routeName,
    required this.ctaLabel,
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
  final int? questionCount;
  final String? difficultyLabel;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String ctaLabel;
}
