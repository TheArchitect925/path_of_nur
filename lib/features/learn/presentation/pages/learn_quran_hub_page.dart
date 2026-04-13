import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/content/page_description_copy.dart';
import '../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../quran/application/quran_learning_system_service.dart';
import '../../quran/application/quran_guided_learning_paths_provider.dart';
import '../../quran/domain/quran_learning_models.dart';
import '../../quran/presentation/quran_learning_path_copy.dart';
import '../../quran/presentation/widgets/quran_learning_personalization_section.dart';
import '../models/learn_category_item.dart';
import '../widgets/learn_category_grid.dart';
import '../widgets/learn_hub_page_scaffold.dart';

enum LearnQuranHubTab { understand, reflect, paths, memorize }

class LearnQuranHubPage extends ConsumerStatefulWidget {
  const LearnQuranHubPage({super.key, this.initialTab});

  final LearnQuranHubTab? initialTab;

  @override
  ConsumerState<LearnQuranHubPage> createState() => _LearnQuranHubPageState();
}

class _LearnQuranHubPageState extends ConsumerState<LearnQuranHubPage> {
  late LearnQuranHubTab _tab;
  bool _quranCompanionExpanded = false;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab ?? LearnQuranHubTab.understand;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final verses = ref.watch(quranLearningVersesProvider);
    final guidedPaths = ref.watch(quranGuidedFeaturedLearningPathsProvider);
    final continueGuidedPath = ref.watch(quranGuidedContinuePathProvider);
    final memorization = ref.watch(quranMemorizationProgressProvider);
    final dueReviews = ref.watch(quranMemorizationDueProvider);
    final memorizationCoverage = ref.watch(quranMemorizationCoverageProvider);
    final reviewEntries = ref.watch(quranMemorizationReviewEntriesProvider);
    final dailyVerse = ref.watch(quranDailyReflectionVerseProvider);
    final quranTools = _quranTools(l10n);

    return LearnHubPageScaffold(
      showDefaultQuote: false,
      headerIcon: Icons.school_rounded,
      title: l10n.learnCategoryQuranLearningTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.quranStudyHub,
        kidsMode: isKidsMode,
      ),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranHubStudyTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranHubStudySubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.pushNamed('quranArabic'),
                  icon: const Icon(Icons.translate_rounded),
                  label: Text(l10n.learningJourneyToolQuranArabicTitle),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              initiallyExpanded: _quranCompanionExpanded,
              onExpansionChanged: (expanded) {
                setState(() => _quranCompanionExpanded = expanded);
              },
              title: Text(
                l10n.quranCompanionSectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(l10n.quranCompanionSectionSubtitle),
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: QuranLearningPersonalizationSection(wrapInCard: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SegmentedPillControl<LearnQuranHubTab>(
          items: LearnQuranHubTab.values,
          selectedItem: _tab,
          labelBuilder: _tabLabel,
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 12),
        if (_tab == LearnQuranHubTab.understand) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnQuranHubTabUnderstand,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.learnQuranHubUnderstandSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...verses.map((verse) {
            final hadithEntries = verse.relatedHadith
                .map((id) => ref.watch(hadithEntryByIdProvider(id)))
                .whereType<HadithEntry>()
                .toList(growable: false);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.quranReferenceViewerReferenceLabel(
                      '${verse.surah}:${verse.ayah}',
                    ),
                  ),
                  subtitle: Text(verse.translation),
                  children: [
                    const SizedBox(height: 8),
                    QuranReferenceBlock(
                      surahNumber: verse.surah,
                      ayahStart: verse.ayah,
                      ayahEnd: verse.ayah,
                      showHeader: false,
                      showOpenButton: false,
                      dense: true,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(verse.explanation),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.learnQuranHubKeyLessonsTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...verse.lessons.map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $item'),
                        ),
                      ),
                    ),
                    if (hadithEntries.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.quranReferenceViewerRelatedHadith,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hadithEntries
                            .map(
                              (item) => ActionChip(
                                label: Text(item.title),
                                onPressed: () => context.pushNamed(
                                  'hadithLessonDetail',
                                  pathParameters: {'lessonId': item.id},
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppLayeredGlassPillButton(
                        onPressed: () => context.pushNamed(
                          'quranReader',
                          pathParameters: {'surahNumber': '${verse.surah}'},
                          queryParameters: {'ayah': '${verse.ayah}'},
                        ),
                        leading: const Icon(
                          Icons.open_in_new_rounded,
                          size: 18,
                        ),
                        label: l10n.learnQuranHubOpenReaderAction,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        if (_tab == LearnQuranHubTab.reflect) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranAyahInsightsHubEntryTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranAyahInsightsHubEntrySubtitle),
                const SizedBox(height: 10),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('quranAyahInsightsBrowse'),
                  leading: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: l10n.quranAyahInsightsBrowseAction,
                ),
                const SizedBox(height: 8),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('quranAyahInsightsPaths'),
                  leading: const Icon(Icons.route_rounded, size: 18),
                  label: l10n.quranAyahInsightPathsAction,
                ),
                const SizedBox(height: 8),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('quranKnowledgeSearch'),
                  leading: const Icon(Icons.manage_search_rounded, size: 18),
                  label: l10n.quranKnowledgeSearchAction,
                ),
                const SizedBox(height: 8),
                AppLayeredGlassPillButton(
                  onPressed: () =>
                      context.pushNamed('quranSurahInsightsBrowse'),
                  leading: const Icon(Icons.layers_outlined, size: 18),
                  label: l10n.quranSurahInsightsBrowseAction,
                ),
                const SizedBox(height: 8),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('quranReflections'),
                  leading: const Icon(Icons.bookmark_added_outlined, size: 18),
                  label: l10n.quranReflectionsHubEntryTitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnQuranHubDailyVerseTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                QuranReferenceBlock(
                  surahNumber: dailyVerse.surah,
                  ayahStart: dailyVerse.ayah,
                  ayahEnd: dailyVerse.ayah,
                  dense: true,
                ),
                const SizedBox(height: 8),
                Text(dailyVerse.explanation),
                const SizedBox(height: 10),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('journalCreate'),
                  leading: const Icon(Icons.edit_note_rounded, size: 18),
                  label: l10n.learnQuranHubWriteJournalAction,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnQuranHubReflectionPromptsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...dailyVerse.reflectionPrompts.map(
                  (prompt) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $prompt'),
                  ),
                ),
                const SizedBox(height: 8),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed(
                    'quranReader',
                    pathParameters: {'surahNumber': '${dailyVerse.surah}'},
                    queryParameters: {'ayah': '${dailyVerse.ayah}'},
                  ),
                  leading: const Icon(Icons.menu_book_rounded, size: 18),
                  label: l10n.learnQuranHubReadFullContextAction,
                ),
              ],
            ),
          ),
        ],
        if (_tab == LearnQuranHubTab.paths) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnQuranHubTabPaths,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.learnQuranHubPathsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (continueGuidedPath != null) ...[
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quranLearningPathsContinueTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedQuranLearningPathTitle(
                      l10n,
                      continueGuidedPath.id,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppLayeredGlassPillButton(
                    onPressed: () => context.pushNamed(
                      'quranLearningPathDetail',
                      pathParameters: {'pathId': continueGuidedPath.id},
                    ),
                    leading: const Icon(
                      Icons.play_circle_outline_rounded,
                      size: 18,
                    ),
                    label: l10n.quranLearningPathsOpenContinueAction,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          ...guidedPaths.take(3).map((path) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.pushNamed(
                    'quranLearningPathDetail',
                    pathParameters: {'pathId': path.id},
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedQuranLearningPathTitle(l10n, path.id),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          localizedQuranLearningPathSubtitle(l10n, path.id),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizedQuranLearningPathDescription(l10n, path.id),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          AppLayeredGlassPillButton(
            onPressed: () => context.pushNamed('quranLearningPaths'),
            leading: const Icon(Icons.route_rounded, size: 18),
            label: l10n.quranLearningPathsBrowseAllAction,
          ),
        ],
        if (_tab == LearnQuranHubTab.memorize) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnQuranHubTabMemorize,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.learnQuranHubMemorizeSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.learnQuranHubMemorizeCoverageSummary(
                    (memorizationCoverage * 100).round(),
                    dueReviews.length,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 10),
                AppLayeredGlassPillButton(
                  onPressed: () => context.pushNamed('quranMemorizationReview'),
                  leading: const Icon(Icons.repeat_rounded, size: 18),
                  label: l10n.quranMemorizationReviewOpenListAction,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (dueReviews.isNotEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.learnQuranHubSpacedReviewTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...reviewEntries
                      .where(
                        (entry) => dueReviews.any(
                          (item) => item.verseId == entry.progress.verseId,
                        ),
                      )
                      .take(5)
                      .map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.surface.withValues(alpha: 0.22),
                              border: Border.all(
                                color: AppColors.accentGoldSoft.withValues(
                                  alpha: 0.28,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.quranReferenceViewerReferenceLabel(
                                    '${entry.surahNumber}:${entry.ayahNumber}',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.learnQuranHubStageAndNext(
                                    _stageLabel(l10n, entry.progress.stage),
                                    _dateLabel(
                                      context,
                                      entry.progress.nextReview,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilledButton.tonal(
                                      onPressed: () => ref
                                          .read(
                                            quranMemorizationProgressProvider
                                                .notifier,
                                          )
                                          .markReviewed(
                                            entry.progress.verseId,
                                            success: true,
                                          ),
                                      child: Text(
                                        l10n.learnQuranHubReviewedWellAction,
                                      ),
                                    ),
                                    FilledButton.tonal(
                                      onPressed: () => ref
                                          .read(
                                            quranMemorizationProgressProvider
                                                .notifier,
                                          )
                                          .markReviewed(
                                            entry.progress.verseId,
                                            success: false,
                                            targetStage:
                                                MemorizationStage.repeating,
                                          ),
                                      child: Text(
                                        l10n.learnQuranHubNeedsRepetitionAction,
                                      ),
                                    ),
                                    AppLayeredGlassPillButton(
                                      onPressed: () => context.pushNamed(
                                        'quranReader',
                                        pathParameters: {
                                          'surahNumber': '${entry.surahNumber}',
                                        },
                                        queryParameters: {
                                          'ayah': '${entry.ayahNumber}',
                                          'review': 'memorization',
                                        },
                                      ),
                                      leading: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 18,
                                      ),
                                      label:
                                          l10n.learnQuranHubReciteVerseAction,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          const SizedBox(height: 10),
          if (reviewEntries.isEmpty)
            ...verses.take(6).map((verse) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.quranReferenceViewerReferenceLabel(
                        '${verse.surah}:${verse.ayah}',
                      ),
                    ),
                    subtitle: Text(verse.translation),
                    onTap: () {
                      ref
                          .read(quranMemorizationProgressProvider.notifier)
                          .getOrCreate(verse.id);
                      context.pushNamed(
                        'quranReader',
                        pathParameters: {'surahNumber': '${verse.surah}'},
                        queryParameters: {
                          'ayah': '${verse.ayah}',
                          'review': 'memorization',
                        },
                      );
                    },
                  ),
                ),
              );
            })
          else
            ...reviewEntries.map((entry) {
              final item = memorization[entry.progress.verseId];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PremiumCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.quranReferenceViewerReferenceLabel(
                        '${entry.surahNumber}:${entry.ayahNumber}',
                      ),
                    ),
                    subtitle: Text(
                      item == null
                          ? l10n.learnQuranHubNotStarted
                          : l10n.learnQuranHubNextReviewSummary(
                              _stageLabel(l10n, item.stage),
                              _dateLabel(context, item.nextReview),
                            ),
                    ),
                    onTap: () {
                      context.pushNamed('quranMemorizationReview');
                    },
                  ),
                ),
              );
            }),
        ],
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnQuranHubQuranToolsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              LearnCategoryGrid(
                items: quranTools,
                onTap: (item) => context.pushNamed(
                  item.routeName,
                  pathParameters: item.pathParameters,
                  queryParameters: item.queryParameters,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<LearnCategoryItem> _quranTools(AppLocalizations l10n) {
    return [
      LearnCategoryItem(
        id: 'quran-top-words',
        title: l10n.quranTopWordsTitle,
        iconKey: 'top_words',
        routeName: 'quranTopWords',
        searchKeywords: ['words', 'vocabulary'],
        tags: ['quran'],
        sectionType: 'module',
      ),
      LearnCategoryItem(
        id: 'quran-word-review',
        title: l10n.learningJourneyToolWordReviewTitle,
        iconKey: 'word_review',
        routeName: 'quranWordReview',
        searchKeywords: ['word review', 'flashcards'],
        tags: ['quran'],
        sectionType: 'module',
      ),
      LearnCategoryItem(
        id: 'quran-universe',
        title: l10n.learningJourneyBrowseQuranUniverseTitle,
        iconKey: 'quran_universe',
        routeName: 'quranUniverse',
        searchKeywords: [
          'quran universe',
          'connections',
          'themes',
          'locations',
        ],
        tags: ['quran', 'exploration'],
        sectionType: 'module',
      ),
      LearnCategoryItem(
        id: 'quran-topics',
        title: l10n.quranTopicsTitle,
        iconKey: 'quran_universe',
        routeName: 'quranTopicExplorer',
        searchKeywords: ['topics', 'patience', 'mercy', 'justice', 'guidance'],
        tags: ['quran', 'knowledge graph'],
        sectionType: 'module',
      ),
      LearnCategoryItem(
        id: 'quran-notes',
        title: l10n.quranNotesTitle,
        iconKey: 'notes',
        routeName: 'quranNotes',
        searchKeywords: ['notes', 'reflection'],
        tags: ['quran'],
        sectionType: 'module',
      ),
      LearnCategoryItem(
        id: 'quran-names-of-allah',
        title: l10n.batch9NamesOfAllahTitle,
        iconKey: 'allah_names',
        routeName: 'quranNamesOfAllah',
        searchKeywords: ['99 names', 'asma ul husna', 'allah names'],
        tags: ['quran', 'reflection'],
        sectionType: 'module',
      ),
    ];
  }

  String _tabLabel(LearnQuranHubTab tab) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case LearnQuranHubTab.understand:
        return l10n.learnQuranHubTabUnderstand;
      case LearnQuranHubTab.reflect:
        return l10n.learnQuranHubTabReflect;
      case LearnQuranHubTab.paths:
        return l10n.learnQuranHubTabPaths;
      case LearnQuranHubTab.memorize:
        return l10n.learnQuranHubTabMemorize;
    }
  }

  String _stageLabel(AppLocalizations l10n, MemorizationStage stage) {
    switch (stage) {
      case MemorizationStage.newVerse:
        return l10n.learnQuranHubStageNewVerse;
      case MemorizationStage.repeating:
        return l10n.learnQuranHubStageRepeating;
      case MemorizationStage.phrasePractice:
        return l10n.learnQuranHubStagePhrasePractice;
      case MemorizationStage.hiddenRecall:
        return l10n.learnQuranHubStageHiddenRecall;
      case MemorizationStage.mastered:
        return l10n.learnQuranHubStageMastered;
    }
  }

  String _dateLabel(BuildContext context, DateTime date) {
    final value = DateTime(date.year, date.month, date.day);
    return MaterialLocalizations.of(context).formatMediumDate(value);
  }
}
