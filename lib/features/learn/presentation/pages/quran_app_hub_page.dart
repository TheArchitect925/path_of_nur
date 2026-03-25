import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/page_description_copy.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/major_page_shortcuts.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../../quran/application/quran_hub_recommendations_provider.dart';
import '../../quran/application/quran_learning_system_service.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/application/quran_reflections_provider.dart';
import '../../quran/application/quran_guided_learning_paths_provider.dart';
import '../../quran/application/quran_user_intent_provider.dart';
import '../../quran/domain/quran_hub_recommendation_models.dart';
import '../../quran/domain/quran_user_intent_models.dart';
import '../../quran/presentation/quran_learning_path_copy.dart';
import '../../quran/presentation/quran_theme_copy.dart';
import '../../quran/presentation/widgets/quran_daily_reflection_card.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerStatefulWidget {
  const QuranAppHubPage({super.key});

  @override
  ConsumerState<QuranAppHubPage> createState() => _QuranAppHubPageState();
}

class _QuranAppHubPageState extends ConsumerState<QuranAppHubPage> {
  late final TextEditingController _searchController;

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
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
    ref.watch(quranBookmarksProvider);
    ref.watch(quranNotesProvider);
    ref.watch(quranReflectionsProvider);
    final userIntentSummary = ref.watch(quranUserIntentSummaryProvider);
    final recommendations = ref.watch(quranHubRecommendationsProvider);
    final readActions = _readActions(l10n, continueSummary);
    final studyActions = _studyActions(l10n);
    final wordStudyActions = _wordStudyActions(l10n);
    final toolActions = _toolActions(l10n);

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: IslamicIcons.quran,
      title: l10n.quranHubTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.quranHub,
        kidsMode: isKidsMode,
      ),
      shortcutActions: buildMajorPageShortcutActions(
        context,
        ref,
        MajorPageShortcutFamily.quran,
      ),
      children: [
        PremiumCard(
          child: LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.searchSurahHint,
            readOnly: true,
            onTap: () => context.pushNamed('quranSearch'),
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubReadQuranSectionTitle),
        const SizedBox(height: 8),
        SectionHubActionGrid(actions: readActions),
        const SizedBox(height: 12),
        const QuranDailyReflectionCard(showSecondaryActions: false),
        const SizedBox(height: 12),
        if (recommendations.isNotEmpty)
          _QuranRecommendationSection(recommendations: recommendations),
        if (recommendations.isNotEmpty) const SizedBox(height: 12),
        _QuranIntentFocusCard(summary: userIntentSummary),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubStudyToolsTitle),
        const SizedBox(height: 6),
        Text(
          l10n.quranHubStudyToolsSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(actions: studyActions),
        const SizedBox(height: 12),
        _SectionHeader(title: l10n.quranHubWordToolsTitle),
        const SizedBox(height: 6),
        Text(
          l10n.quranHubWordToolsSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
        const SizedBox(height: 10),
        SectionHubActionGrid(actions: wordStudyActions),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranHubRelatedToolsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranHubRelatedToolsSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: toolActions
                    .map(
                      (action) => _SecondaryToolChip(
                        label: action.title,
                        icon: action.icon,
                        onTap: action.onTap,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<SectionHubAction> _readActions(
    AppLocalizations l10n,
    QuranContinueReadingSummary continueSummary,
  ) {
    return [
      SectionHubAction(
        title: l10n.quranHubReadQuranSectionTitle,
        subtitle: l10n.quranExplorerSubtitle,
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFECE5D7),
        accentColor: const Color(0xFF6F5A3E),
        onTap: () => context.pushNamed('quranExplorer'),
      ),
      SectionHubAction(
        title: l10n.quranHubContinueSectionTitle,
        subtitle: continueSummary.locationLabel,
        icon: Icons.play_circle_fill_rounded,
        color: const Color(0xFFF0E2D6),
        accentColor: const Color(0xFF8D6143),
        onTap: () => context.pushNamed(
          'quranReader',
          pathParameters: {
            'surahNumber': continueSummary.surahNumber.toString(),
          },
          queryParameters: {'ayah': continueSummary.ayahNumber.toString()},
        ),
      ),
    ];
  }

  List<_QuranToolAction> _toolActions(AppLocalizations l10n) {
    return [
      _QuranToolAction(
        title: l10n.quranHubMemorizeTitle,
        subtitle: l10n.quranHubMemorizeSubtitle,
        icon: Icons.repeat_rounded,
        onTap: () => context.pushNamed('quranMemorizationReview'),
      ),
      _QuranToolAction(
        title: l10n.learnCategoryQuranLearningTitle,
        subtitle: l10n.quranHubStudySubtitle,
        icon: Icons.school_rounded,
        onTap: () => context.pushNamed('quranLearningHub'),
      ),
      _QuranToolAction(
        title: l10n.learnQuranBookmarksTitle,
        subtitle: l10n.quranHubNotesSubtitle,
        icon: Icons.bookmark_outline_rounded,
        onTap: () => context.pushNamed('quranBookmarks'),
      ),
      _QuranToolAction(
        title: l10n.quranNotesTitle,
        subtitle: l10n.quranHubNotesSubtitle,
        icon: Icons.note_alt_outlined,
        onTap: () => context.pushNamed('quranNotes'),
      ),
      _QuranToolAction(
        title: l10n.quranReflectionsHubEntryTitle,
        subtitle: l10n.quranReflectionsHubEntrySubtitle,
        icon: Icons.collections_bookmark_outlined,
        onTap: () => context.pushNamed('quranReflections'),
      ),
    ];
  }

  List<SectionHubAction> _studyActions(AppLocalizations l10n) {
    return [
      SectionHubAction(
        title: l10n.quranKnowledgeSearchTitle,
        subtitle: l10n.quranKnowledgeSearchSubtitle,
        icon: Icons.manage_search_rounded,
        color: const Color(0xFFE5EBF5),
        accentColor: const Color(0xFF4A628A),
        onTap: () => context.pushNamed('quranKnowledgeSearch'),
      ),
      SectionHubAction(
        title: l10n.quranSurahInsightsBrowseTitle,
        subtitle: l10n.quranSurahInsightsBrowseSubtitle,
        icon: Icons.auto_stories_rounded,
        color: const Color(0xFFE7ECDD),
        accentColor: const Color(0xFF5A7146),
        onTap: () => context.pushNamed('quranSurahInsightsBrowse'),
      ),
      SectionHubAction(
        title: l10n.quranLearningPathsTitle,
        subtitle: l10n.quranLearningPathsHubSubtitle,
        icon: Icons.route_rounded,
        color: const Color(0xFFE9E6F3),
        accentColor: const Color(0xFF6A5891),
        onTap: () => context.pushNamed('quranLearningPaths'),
      ),
      SectionHubAction(
        title: l10n.quranTopicsTitle,
        subtitle: l10n.quranHubTopicsSubtitle,
        icon: Icons.account_tree_outlined,
        color: const Color(0xFFF0E6D8),
        accentColor: const Color(0xFF8A6243),
        onTap: () => context.pushNamed('quranTopicExplorer'),
      ),
    ];
  }

  List<SectionHubAction> _wordStudyActions(AppLocalizations l10n) {
    return [
      SectionHubAction(
        title: l10n.quranTopWordsTitle,
        subtitle: l10n.quranTopWordsSubtitle,
        icon: Icons.translate_rounded,
        color: const Color(0xFFE8E4F4),
        accentColor: const Color(0xFF675796),
        onTap: () => context.pushNamed('quranTopWords'),
      ),
      SectionHubAction(
        title: l10n.quranWordReviewTitle,
        subtitle: l10n.quranWordReviewSubtitle,
        icon: Icons.style_outlined,
        color: const Color(0xFFE6ECEA),
        accentColor: const Color(0xFF4F6F67),
        onTap: () => context.pushNamed('quranWordReview'),
      ),
    ];
  }
}

class _QuranRecommendationSection extends ConsumerWidget {
  const _QuranRecommendationSection({required this.recommendations});

  final List<QuranHubRecommendation> recommendations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranHubRecommendationsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.quranHubRecommendationsSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < recommendations.length; index++) ...[
            _QuranRecommendationTile(recommendation: recommendations[index]),
            if (index + 1 < recommendations.length)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

class _QuranRecommendationTile extends ConsumerWidget {
  const _QuranRecommendationTile({required this.recommendation});

  final QuranHubRecommendation recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final surahMap = ref.watch(quranSurahMapProvider);
    final dueReviews = ref.watch(quranMemorizationDueProvider);
    final selectedIntent = ref.watch(quranSelectedUserIntentProvider);
    final topic = recommendation.topicId == null
        ? null
        : ref.watch(quranHubRecommendationTopicProvider(recommendation.topicId!));
    final journey = recommendation.journeyId == null
        ? null
        : LearningJourneyRegistry.journeyById(recommendation.journeyId!);
    final stage = recommendation.stageId == null
        ? null
        : LearningJourneyRegistry.stageById(recommendation.stageId!);

    final title = _recommendationTitle(
      context,
      l10n,
      recommendation,
      surahMap,
      topic,
      journey,
    );
    final subtitle = _recommendationSubtitle(
      context,
      l10n,
      recommendation,
      surahMap,
      topic,
      stage,
    );
    final reason = _recommendationReason(
      context,
      l10n,
      recommendation,
      topic,
      journey,
      dueReviews.length,
      selectedIntent,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.pushNamed(
        recommendation.routeName,
        pathParameters: recommendation.pathParameters,
        queryParameters: recommendation.queryParameters,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _recommendationIcon(recommendation.type),
                color: AppColors.accentGoldSoft,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text(
                    reason,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceSubtle),
          ],
        ),
      ),
    );
  }
}

IconData _recommendationIcon(QuranHubRecommendationType type) {
  return switch (type) {
    QuranHubRecommendationType.continuePath => Icons.route_rounded,
    QuranHubRecommendationType.dailyReflection => Icons.wb_twilight_rounded,
    QuranHubRecommendationType.reviewMemorization => Icons.repeat_rounded,
    QuranHubRecommendationType.continueSurah => Icons.play_circle_fill_rounded,
    QuranHubRecommendationType.exploreTheme => Icons.account_tree_outlined,
    QuranHubRecommendationType.journeyLinkedStudy => Icons.route_rounded,
  };
}

String _recommendationTitle(
  BuildContext context,
  AppLocalizations l10n,
  QuranHubRecommendation recommendation,
  Map<int, dynamic> surahMap,
  dynamic topic,
  dynamic journey,
) {
  switch (recommendation.type) {
    case QuranHubRecommendationType.continuePath:
      final pathId = recommendation.pathId;
      final pathTitle = pathId == null
          ? l10n.quranLearningPathsTitle
          : localizedQuranLearningPathTitle(l10n, pathId);
      return l10n.quranHubRecommendationContinuePathTitle(pathTitle);
    case QuranHubRecommendationType.dailyReflection:
      return l10n.quranHubRecommendationDailyTitle;
    case QuranHubRecommendationType.reviewMemorization:
      return l10n.quranHubRecommendationReviewTitle;
    case QuranHubRecommendationType.continueSurah:
      final surahName =
          surahMap[recommendation.surahNumber]?.transliteratedName ??
          l10n.quranHubContinueSectionTitle;
      return l10n.quranHubRecommendationContinueSurahTitle(surahName);
    case QuranHubRecommendationType.exploreTheme:
      final topicTitle = topic == null
          ? l10n.quranTopicsTitle
          : localizedQuranTopicTitle(l10n, topic.id as String);
      return l10n.quranHubRecommendationExploreThemeTitle(topicTitle);
    case QuranHubRecommendationType.journeyLinkedStudy:
      final journeyTitle = journey == null
          ? l10n.learningJourneyHomeTitle
          : localizedJourneyTitle(context, journey);
      return l10n.quranHubRecommendationJourneyTitle(journeyTitle);
  }
}

String _recommendationSubtitle(
  BuildContext context,
  AppLocalizations l10n,
  QuranHubRecommendation recommendation,
  Map<int, dynamic> surahMap,
  dynamic topic,
  dynamic stage,
) {
  switch (recommendation.type) {
    case QuranHubRecommendationType.continuePath:
      final pathId = recommendation.pathId;
      return pathId == null
          ? l10n.quranLearningPathsSubtitle
          : localizedQuranLearningPathSubtitle(l10n, pathId);
    case QuranHubRecommendationType.dailyReflection:
      return recommendation.surahNumber == null || recommendation.ayahNumber == null
          ? l10n.quranDailyCompanionSubtitle
          : '${surahMap[recommendation.surahNumber]?.transliteratedName ?? ''} ${recommendation.surahNumber}:${recommendation.ayahNumber}';
    case QuranHubRecommendationType.reviewMemorization:
      final dueCount = recommendation.dueCount ?? 0;
      return l10n.quranMemorizationReviewSummary(dueCount, dueCount);
    case QuranHubRecommendationType.continueSurah:
      final surahName =
          surahMap[recommendation.surahNumber]?.transliteratedName ?? '';
      return '$surahName ${recommendation.surahNumber}:${recommendation.ayahNumber}';
    case QuranHubRecommendationType.exploreTheme:
      return topic == null
          ? l10n.quranHubTopicsSubtitle
          : localizedQuranTopicDescription(l10n, topic.id as String);
    case QuranHubRecommendationType.journeyLinkedStudy:
      return stage == null
          ? l10n.quranDailyCompanionSubtitle
          : localizedStageTitle(context, stage);
  }
}

String _recommendationReason(
  BuildContext context,
  AppLocalizations l10n,
  QuranHubRecommendation recommendation,
  dynamic topic,
  dynamic journey,
  int dueReviewCount,
  QuranUserIntent? selectedIntent,
) {
  switch (recommendation.type) {
    case QuranHubRecommendationType.continuePath:
      if (selectedIntent == QuranUserIntent.guidedPath) {
        return l10n.quranHubRecommendationReasonGuidedPath;
      }
      return l10n.quranHubRecommendationReasonContinuePath;
    case QuranHubRecommendationType.dailyReflection:
      return recommendation.source == QuranHubRecommendationSource.journey &&
              journey != null
          ? l10n.quranHubRecommendationReasonDailyJourney(
              localizedJourneyTitle(context, journey),
            )
          : l10n.quranHubRecommendationReasonDaily;
    case QuranHubRecommendationType.reviewMemorization:
      final count = recommendation.dueCount ?? dueReviewCount;
      if (count > 0) {
        return l10n.quranHubRecommendationReasonReviewDue(count);
      }
      return l10n.quranHubRecommendationReasonMemorizationFocus;
    case QuranHubRecommendationType.continueSurah:
      return l10n.quranHubRecommendationReasonRecentStudy;
    case QuranHubRecommendationType.exploreTheme:
      if (recommendation.source == QuranHubRecommendationSource.journey &&
          topic != null) {
        return l10n.quranHubRecommendationReasonJourneyTheme(
          localizedQuranTopicTitle(l10n, topic.id as String),
        );
      }
      if (recommendation.source == QuranHubRecommendationSource.intent &&
          selectedIntent == QuranUserIntent.themes) {
        return l10n.quranHubRecommendationReasonThemeFocus;
      }
      return l10n.quranHubRecommendationReasonTheme;
    case QuranHubRecommendationType.journeyLinkedStudy:
      if (journey != null && topic != null) {
        return l10n.quranHubRecommendationReasonJourneyThemePair(
          localizedJourneyTitle(context, journey),
          localizedQuranTopicTitle(l10n, topic.id as String),
        );
      }
      if (journey != null) {
        return l10n.quranHubRecommendationReasonDailyJourney(
          localizedJourneyTitle(context, journey),
        );
      }
      return l10n.quranHubRecommendationReasonDaily;
  }
}

class _QuranIntentFocusCard extends ConsumerWidget {
  const _QuranIntentFocusCard({required this.summary});

  final QuranUserIntentSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedIntent = summary.selectedIntent;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranUserIntentTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.quranUserIntentSubtitle),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: QuranUserIntent.values
                .map(
                  (intent) => ChoiceChip(
                    label: Text(_intentLabel(l10n, intent)),
                    selected: selectedIntent == intent,
                    onSelected: (selected) {
                      final notifier = ref.read(
                        quranUserIntentStateProvider.notifier,
                      );
                      if (selected) {
                        notifier.setIntent(intent);
                      } else {
                        notifier.clearIntent();
                      }
                    },
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          if (selectedIntent != null) ...[
            Text(
              l10n.quranUserIntentRecommendedTitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(_intentRecommendationSubtitle(l10n, selectedIntent)),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => _openIntentRecommendation(
                context,
                ref,
                intent: selectedIntent,
                summary: summary,
              ),
              icon: Icon(_intentIcon(selectedIntent)),
              label: Text(_intentActionLabel(l10n, selectedIntent)),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () =>
                  ref.read(quranUserIntentStateProvider.notifier).clearIntent(),
              icon: const Icon(Icons.close_rounded),
              label: Text(l10n.quranUserIntentClearAction),
            ),
          ],
        ],
      ),
    );
  }
}

String _intentLabel(AppLocalizations l10n, QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranUserIntentUnderstandLabel,
    QuranUserIntent.reflect => l10n.quranUserIntentReflectLabel,
    QuranUserIntent.memorize => l10n.quranUserIntentMemorizeLabel,
    QuranUserIntent.themes => l10n.quranUserIntentThemesLabel,
    QuranUserIntent.guidedPath => l10n.quranUserIntentGuidedPathLabel,
  };
}

String _intentActionLabel(AppLocalizations l10n, QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranSurahInsightsBrowseTitle,
    QuranUserIntent.reflect => l10n.quranDailyCompanionTitle,
    QuranUserIntent.memorize => l10n.quranHubMemorizeTitle,
    QuranUserIntent.themes => l10n.quranTopicsTitle,
    QuranUserIntent.guidedPath => l10n.quranLearningPathsTitle,
  };
}

String _intentRecommendationSubtitle(
  AppLocalizations l10n,
  QuranUserIntent intent,
) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranUserIntentUnderstandRecommendation,
    QuranUserIntent.reflect => l10n.quranUserIntentReflectRecommendation,
    QuranUserIntent.memorize => l10n.quranUserIntentMemorizeRecommendation,
    QuranUserIntent.themes => l10n.quranUserIntentThemesRecommendation,
    QuranUserIntent.guidedPath =>
      l10n.quranUserIntentGuidedPathRecommendation,
  };
}

IconData _intentIcon(QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => Icons.auto_stories_rounded,
    QuranUserIntent.reflect => Icons.wb_twilight_rounded,
    QuranUserIntent.memorize => Icons.repeat_rounded,
    QuranUserIntent.themes => Icons.account_tree_outlined,
    QuranUserIntent.guidedPath => Icons.route_rounded,
  };
}

void _openIntentRecommendation(
  BuildContext context,
  WidgetRef ref, {
  required QuranUserIntent intent,
  required QuranUserIntentSummary summary,
}) {
  switch (intent) {
    case QuranUserIntent.understand:
      context.pushNamed('quranSurahInsightsBrowse');
      break;
    case QuranUserIntent.reflect:
      context.pushNamed('quranDailyCompanion');
      break;
    case QuranUserIntent.memorize:
      context.pushNamed('quranMemorizationReview');
      break;
    case QuranUserIntent.themes:
      context.pushNamed('quranTopicExplorer');
      break;
    case QuranUserIntent.guidedPath:
      final path = summary.suggestedPath;
      if (path != null) {
        final firstStep = path.steps.first;
        ref
            .read(quranGuidedLearningContinuityProvider.notifier)
            .markStepOpened(pathId: path.id, stepId: firstStep.id);
        context.pushNamed(
          'quranLearningPathDetail',
          pathParameters: {'pathId': path.id},
        );
      } else {
        context.pushNamed('quranLearningPaths');
      }
      break;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SecondaryToolChip extends StatelessWidget {
  const _SecondaryToolChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _QuranToolAction {
  const _QuranToolAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
