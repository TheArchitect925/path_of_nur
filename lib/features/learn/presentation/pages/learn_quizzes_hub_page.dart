import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
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
      title: 'Quizzes',
      subtitle:
          'Practice what you have learned across the different learning sections with one organized quiz hub.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search quiz titles, modules, topics...',
                  prefixIcon: Icon(Icons.search_rounded),
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
        _summaryCard(context, items.length),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('No quizzes match this filter.'),
                const SizedBox(height: 6),
                Text(
                  'Try a broader keyword or switch categories.',
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
              'Prophets Quizzes',
              'Mode-based quizzes from the Prophets module.',
            ),
            const SizedBox(height: 8),
            ...prophetItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (hadithItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              'Hadith Chapter Quizzes',
              'Path and chapter quizzes from the Hadith module.',
            ),
            const SizedBox(height: 8),
            ...hadithItems.map(_quizCard),
            const SizedBox(height: 12),
          ],
          if (reviewItems.isNotEmpty) ...[
            _sectionTitle(
              context,
              'Hadith Review Quizzes',
              'Review-style quizzes from your Hadith learning.',
            ),
            const SizedBox(height: 8),
            ...reviewItems.map(_quizCard),
          ],
        ],
      ],
    );
  }

  Widget _summaryCard(BuildContext context, int total) {
    return PremiumCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip('$total quizzes available'),
          _chip('${seededHadithChapterQuizzes.length} hadith chapter quizzes'),
          _chip('${ProphetQuizMode.values.length} prophet quiz modes'),
          _chip('2 learning modules live'),
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
                _chip(item.module),
                _chip(item.group),
                if (item.questionCount != null)
                  _chip('${item.questionCount} questions'),
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
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.glassSurfaceAlpha),
        borderRadius: BorderRadius.circular(999),
      ),
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
        difficultyLabel: 'Starts at Easy',
        routeName: 'learnSectionHub',
        pathParameters: const {'sectionId': 'prophets'},
        queryParameters: {
          'tab': 'quiz',
          'quizMode': mode.name,
          'quizDifficulty': ProphetQuizDifficulty.easy.name,
        },
        ctaLabel: 'Open prophet quiz',
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
        ctaLabel: 'Start chapter quiz',
      );
    });

    final reviewItems = [
      _QuizCatalogItem(
        id: 'hadith_review_random',
        module: 'Hadith',
        group: 'Review',
        title: 'Random Hadith Review',
        subtitle: 'Mixed review from completed or available hadith lessons.',
        routeName: 'hadithReviewQuiz',
        queryParameters: const {'mode': 'random'},
        ctaLabel: 'Start review',
      ),
      _QuizCatalogItem(
        id: 'hadith_review_weekly',
        module: 'Hadith',
        group: 'Review',
        title: 'Weekly Knowledge Check',
        subtitle: 'A weekly hadith check-in pulled from learned material.',
        routeName: 'hadithReviewQuiz',
        queryParameters: const {'mode': 'weekly'},
        ctaLabel: 'Start weekly quiz',
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
    switch (filter) {
      case LearnQuizFilter.all:
        return 'All';
      case LearnQuizFilter.prophets:
        return 'Prophets';
      case LearnQuizFilter.hadith:
        return 'Hadith';
      case LearnQuizFilter.review:
        return 'Review';
    }
  }

  String _prophetModeLabel(ProphetQuizMode mode) {
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return 'Prophet Identification';
      case ProphetQuizMode.timelineOrder:
        return 'Timeline Order';
      case ProphetQuizMode.storyMatching:
        return 'Story Matching';
      case ProphetQuizMode.quranReference:
        return 'Qur’an Reference';
      case ProphetQuizMode.lessonRecognition:
        return 'Lesson Recognition';
    }
  }

  String _prophetModeSummary(ProphetQuizMode mode) {
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return 'Recognize prophets through names, roles, and core traits.';
      case ProphetQuizMode.timelineOrder:
        return 'Practice chronology and placement across prophetic history.';
      case ProphetQuizMode.storyMatching:
        return 'Match prophets to events, tests, and story details.';
      case ProphetQuizMode.quranReference:
        return 'Connect prophets with their Qur’anic references and contexts.';
      case ProphetQuizMode.lessonRecognition:
        return 'Identify the life lessons each prophetic story teaches.';
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
