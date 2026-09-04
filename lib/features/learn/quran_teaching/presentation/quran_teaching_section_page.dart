import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../arabic/application/arabic_learning_asset_bundle.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../arabic/domain/arabic_learning_search_models.dart';
import '../../../arabic/data/arabic_alphabet_catalog.dart';
import '../../../arabic/application/arabic_learning_lesson_packs_provider.dart';
import '../../../arabic/application/arabic_learning_assessment_provider.dart';
import '../../../arabic/application/arabic_learning_progress_provider.dart';
import '../../../arabic/application/arabic_learning_quick_resume_provider.dart';
import '../../../arabic/application/arabic_learning_search_provider.dart';
import '../../../arabic/presentation/arabic_learning_route_target_navigation.dart';
import '../../../arabic/presentation/widgets/arabic_learning_discovery_search_section.dart';
import '../../../arabic/presentation/widgets/arabic_learning_lesson_packs_section.dart';
import '../../../arabic/presentation/widgets/arabic_learning_quick_resume_section.dart';
import '../../quran/application/quran_readiness_bridge_provider.dart';
import '../../quran/application/quran_guided_passage_readiness_provider.dart';
import '../../quran/application/quran_short_surah_readiness_provider.dart';
import '../../quran/domain/quran_guided_passage_readiness_models.dart';
import '../../quran/domain/quran_short_surah_readiness_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_teaching_adult_overview_provider.dart';
import '../application/quran_teaching_controller.dart';
import '../application/quran_teaching_smart_review_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'quran_teaching_daily_review_page.dart';
import 'quran_teaching_beginner_words_page.dart';
import 'quran_teaching_lesson_page.dart';
import 'quran_teaching_listen_only_page.dart';
import 'quran_teaching_module_page.dart';
import 'quran_teaching_review_page.dart';
import 'widgets/quran_teaching_adult_overview_card.dart';
import 'widgets/quran_teaching_review_widgets.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';

class QuranTeachingSectionPage extends ConsumerStatefulWidget {
  const QuranTeachingSectionPage({super.key});

  @override
  ConsumerState<QuranTeachingSectionPage> createState() =>
      _QuranTeachingSectionPageState();
}

class _QuranTeachingSectionPageState
    extends ConsumerState<QuranTeachingSectionPage> {
  bool _setupPromptShown = false;
  bool _offlineWarmupQueued = false;
  String? _lastReviewSyncSignature;
  final TextEditingController _searchController = TextEditingController();
  final Set<ArabicLearningSearchFilter> _selectedFilters =
      <ArabicLearningSearchFilter>{};

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
    final discoveryResults = ref.watch(
      arabicLearningSearchResultsProvider(
        ArabicLearningSearchQuery(
          audience: ArabicLearningAudience.adult,
          query: _searchController.text,
          filters: _selectedFilters,
        ),
      ),
    );
    final foundationsModule = catalog.moduleById('foundations');
    final shapeLesson = catalog.lessonById('letter_shapes_core');
    final beginnerWords = ref.watch(quranTeachingBeginnerWordsProvider);
    final quranReadiness = ref.watch(
      quranReadinessBridgeSummaryProvider(ArabicLearningAudience.adult),
    );
    final shortSurahs = ref.watch(
      quranShortSurahReadinessSummaryProvider(ArabicLearningAudience.adult),
    );
    final guidedPassages = ref.watch(
      quranGuidedPassageReadinessSummaryProvider(ArabicLearningAudience.adult),
    );
    final lessonPacks = ref.watch(
      arabicLearningLessonPacksProvider(ArabicLearningAudience.adult),
    );
    final miniAssessment = ref.watch(
      arabicLearningMiniAssessmentSessionProvider(ArabicLearningAudience.adult),
    );
    final progressSummary = ref.watch(
      arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
    );
    final quickResume = ref.watch(
      arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.adult),
    );
    final adultOverview = ref.watch(quranTeachingAdultOverviewProvider);
    if (!_setupPromptShown && progress.learnerLevel == null) {
      _setupPromptShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSetupSheet(context, progress.learnerLevel);
      });
    }

    final reviewSyncSignature = [
      DateTime.now().toIso8601String().substring(0, 10),
      progress.visualModeEnabled ? 'visual:on' : 'visual:off',
      ...progress.completedLessonIds.toList(growable: false)..sort(),
      ...mistakeItems.map((item) => item.quizId).toList(growable: false)
        ..sort(),
    ].join('|');
    if (_lastReviewSyncSignature != reviewSyncSignature) {
      _lastReviewSyncSignature = reviewSyncSignature;
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
    }

    if (!_offlineWarmupQueued) {
      _offlineWarmupQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final warmer = ref.read(arabicLearningOfflineWarmupProvider);
        warmer.prewarmContinuationTarget(
          audience: ArabicLearningAudience.adult,
          continuation: progressSummary.continuation,
          adultCatalog: catalog,
        );
        warmer.prewarmAudienceStartBundle(ArabicLearningAudience.adult);
      });
    }

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
    return LearnHubPageScaffold(
      headerIcon: AppIcons.arabic,
      title: l10n.quranTeachingSectionTitle,
      subtitle: l10n.quranTeachingSectionSubtitle,
      children: [
        QuranTeachingAdultOverviewCard(
          summary: adultOverview,
          onPrimaryTap: () => openArabicLearningRouteTarget(
            context,
            target: adultOverview.primaryTarget,
            adultCatalog: catalog,
          ),
          onReviewTap: adultOverview.reviewTarget == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: adultOverview.reviewTarget!,
                  adultCatalog: catalog,
                ),
          onBrowseLettersTap: adultOverview.browseLettersTarget == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: adultOverview.browseLettersTarget!,
                  adultCatalog: catalog,
                ),
          onBrowseWordsTap: adultOverview.browseWordsTarget == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: adultOverview.browseWordsTarget!,
                  adultCatalog: catalog,
                ),
        ),
        const SizedBox(height: 12),
        ArabicLearningQuickResumeSection(
          variant: ArabicLearningQuickResumeSectionVariant.adult,
          summary: quickResume,
          onPrimaryTap: () => openArabicLearningRouteTarget(
            context,
            target: quickResume.primaryTarget,
            adultCatalog: catalog,
          ),
          onReviewTap: !quickResume.hasReviewAction
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: quickResume.reviewTarget!,
                  adultCatalog: catalog,
                ),
        ),
        const SizedBox(height: 12),
        _ShortSurahsAdultCard(summary: shortSurahs),
        const SizedBox(height: 12),
        _GuidedPassagesAdultCard(summary: guidedPassages),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranTeachingMiniAssessmentCardTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranTeachingMiniAssessmentCardSubtitle(
                  miniAssessment.questions.length,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranArabicMiniAssessment'),
                icon: const Icon(AppIcons.practice),
                label: Text(l10n.quranTeachingMiniAssessmentCardAction),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ArabicLearningDiscoverySearchSection(
          variant: ArabicLearningDiscoveryVariant.adult,
          controller: _searchController,
          selectedFilters: _selectedFilters,
          results: discoveryResults,
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
          onToggleFilter: (filter) {
            setState(() {
              if (!_selectedFilters.add(filter)) {
                _selectedFilters.remove(filter);
              }
            });
          },
          onOpenResult: (item) {
            openArabicLearningRouteTarget(
              context,
              target: item.target,
              adultCatalog: catalog,
            );
          },
        ),
        const SizedBox(height: 12),
        ArabicLearningLessonPacksSection(
          variant: ArabicLearningLessonPacksVariant.adult,
          packs: lessonPacks,
          onOpenPack: (pack) => openArabicLearningRouteTarget(
            context,
            target: pack.primaryTarget,
            adultCatalog: catalog,
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranTeachingBeginnerWordsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(l10n.quranTeachingBeginnerWordsSectionSubtitle),
              if (beginnerWords.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  beginnerWords
                      .take(3)
                      .map((word) => word.arabic)
                      .join('  •  '),
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: AppFonts.quranArabic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.quranTeachingBeginnerWordsPreview(
                    beginnerWords.first.transliteration,
                    beginnerWords.first.meaning,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: beginnerWords.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const QuranTeachingBeginnerWordsPage(),
                          ),
                        );
                      },
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.quranTeachingBeginnerWordsOpenAction),
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
                l10n.quranReadinessAdultCardTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                quranReadiness.hasArabicFoundationStarted
                    ? l10n.quranReadinessAdultCardSubtitle(
                        quranReadiness.snippet.transliteration,
                      )
                    : l10n.quranReadinessAdultCardStartSubtitle,
              ),
              const SizedBox(height: 12),
              Text(
                quranReadiness.snippet.snippetArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: AppFonts.quranArabic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${quranReadiness.snippet.surahName} • ${quranReadiness.snippet.ref.locationLabel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  quranReadiness.routeName,
                  queryParameters: <String, String>{
                    'snippet': quranReadiness.snippet.id,
                  },
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: Text(switch (quranReadiness.intent) {
                  ArabicLearningContinuationIntent.review =>
                    l10n.quranReadinessAdultReviewAction,
                  ArabicLearningContinuationIntent.continueForward =>
                    l10n.quranReadinessAdultContinueAction,
                  _ => l10n.quranReadinessAdultStartAction,
                }),
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
                l10n.quranTeachingAlphabetOverviewTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quranTeachingAlphabetOverviewSubtitle(
                  arabicAlphabetCatalog.length,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: context.palette.surfaceSoft.withValues(alpha: 0.45),
                ),
                child: Text(
                  arabicAlphabetCatalog
                      .take(10)
                      .map((letter) => letter.glyph)
                      .join('  '),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontFamily: AppFonts.quranArabic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ModeChip(
                    label: l10n.quranTeachingAlphabetOverviewCount(
                      arabicAlphabetCatalog.length,
                    ),
                  ),
                  _ModeChip(label: l10n.quranTeachingAlphabetOverviewForms),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: foundationsModule == null
                        ? null
                        : () => _openModule(context, foundationsModule),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: Text(l10n.quranTeachingAlphabetOverviewBrowseAction),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: foundationsModule == null || shapeLesson == null
                        ? null
                        : () => _openLesson(
                            context,
                            lesson: shapeLesson,
                            module: foundationsModule,
                          ),
                    icon: const Icon(Icons.auto_fix_high_rounded),
                    label: Text(l10n.quranTeachingAlphabetOverviewShapesAction),
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quranTeachingPathTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _levelSubtitle(l10n, progress.learnerLevel),
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
              ProgressBar(value: percent, height: 10),
              const SizedBox(height: 10),
              Text(
                l10n.quranTeachingProgressSummary(
                  completedLessons,
                  totalLessons,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ModeChip(label: _modeLabel(l10n, progress.accessMode)),
                  _ModeChip(
                    label: progress.visualModeEnabled
                        ? l10n.quranTeachingVisualModeOn
                        : l10n.quranTeachingVisualModeOff,
                  ),
                ],
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
                      l10n.quranTeachingRecommendedTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recommended?.title ?? l10n.quranTeachingRecommendedEmpty,
                    ),
                    if (recommended != null) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          final module = catalog.moduleById(
                            recommended.moduleId,
                          );
                          if (module == null) return;
                          _openLesson(
                            context,
                            lesson: recommended,
                            module: module,
                          );
                        },
                        child: Text(l10n.quranTeachingOpenAction),
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
                      l10n.quranTeachingVisualModeTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.quranTeachingVisualModeSubtitle),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: progress.visualModeEnabled,
                      onChanged: (value) => ref
                          .read(quranTeachingProgressProvider.notifier)
                          .setVisualMode(value),
                      title: Text(l10n.quranTeachingVisualModeToggle),
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
                      l10n.batch9ListenOnlyTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.quranTeachingListenOnlySubtitle),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        _openListenOnly(context);
                      },
                      icon: const Icon(Icons.headphones_rounded),
                      label: Text(l10n.quranTeachingOpenListenOnlyAction),
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
                      l10n.quranTeachingReviewMistakesTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mistakeItems.isEmpty
                          ? l10n.quranTeachingReviewMistakesEmpty
                          : l10n.quranTeachingReviewMistakesSummary(
                              mistakeItems.length,
                            ),
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
                        mistakeItems.isEmpty
                            ? l10n.quranTeachingOpenReviewAction
                            : l10n.quranTeachingPracticeNowAction,
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
                l10n.quranTeachingReviewProgressTitle,
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
                    label: l10n.quranTeachingReviewLetters(
                      reviewStats.lettersReviewed,
                    ),
                  ),
                  _ModeChip(
                    label: l10n.quranTeachingReviewWords(
                      reviewStats.wordsRecognized,
                    ),
                  ),
                  _ModeChip(
                    label: l10n.quranTeachingReviewPhrases(
                      reviewStats.phrasesPracticed,
                    ),
                  ),
                  _ModeChip(
                    label: l10n.quranTeachingReviewDue(
                      reviewStats.itemsDueToday,
                    ),
                  ),
                  _ModeChip(
                    label: l10n.quranTeachingReviewTricky(
                      reviewStats.trickyItems,
                    ),
                  ),
                  _ModeChip(
                    label: l10n.quranTeachingReviewMastered(
                      reviewStats.masteredCount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (recommendations.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.quranTeachingPracticeRecommendationsTitle,
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
        if (recentLessons.isNotEmpty) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranTeachingRecentlyLearnedTitle,
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
                            _openLesson(
                              context,
                              lesson: lesson,
                              module: module,
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
                  l10n.quranTeachingPracticeAgainTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranTeachingPracticeAgainSubtitle),
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
          l10n.quranTeachingLearningPathTitle,
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
        if (filteredModules.isEmpty && query.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnHubSearchEmptyTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.learnHubSearchEmptySubtitle),
              ],
            ),
          )
        else
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
                            backgroundColor: module.color.withValues(
                              alpha: 0.18,
                            ),
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
                                          l10n.quranTeachingRecommendedBadge,
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
                                        color: context.palette.onSurfaceSubtle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProgressBar(value: completion, height: 8),
                      const SizedBox(height: 8),
                      Text(
                        unlocked
                            ? l10n.quranTeachingModuleCompletion(
                                (completion * 100).round(),
                              )
                            : l10n.quranTeachingModuleLocked,
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
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranTeachingChooseLevelTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.quranTeachingChooseLevelSubtitle),
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
                              : context.palette.surfaceSoft,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _levelLabel(l10n, level),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(_levelDescription(l10n, level)),
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

class _ShortSurahsAdultCard extends StatelessWidget {
  const _ShortSurahsAdultCard({required this.summary});

  final QuranShortSurahReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranShortSurahsAdultCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            summary.hasSnippetBridgeStarted
                ? l10n.quranShortSurahsAdultCardSubtitle(
                    summary.surah.surahTransliteratedName,
                  )
                : l10n.quranShortSurahsAdultCardStartSubtitle,
          ),
          const SizedBox(height: 12),
          Text(
            summary.surah.surahArabicName,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 30,
              fontFamily: AppFonts.quranArabic,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.quranShortSurahsSurahMeta(
              summary.surah.surahTransliteratedName,
              summary.surah.ayahCount,
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              summary.routeName,
              queryParameters: <String, String>{
                'surah': summary.surah.surahNumber.toString(),
              },
            ),
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(switch (summary.intent) {
              ArabicLearningContinuationIntent.review =>
                l10n.quranShortSurahsAdultReviewAction,
              ArabicLearningContinuationIntent.continueForward =>
                l10n.quranShortSurahsAdultContinueAction,
              _ => l10n.quranShortSurahsAdultStartAction,
            }),
          ),
        ],
      ),
    );
  }
}

class _GuidedPassagesAdultCard extends StatelessWidget {
  const _GuidedPassagesAdultCard({required this.summary});

  final QuranGuidedPassageReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actionLabel = switch (summary.intent) {
      ArabicLearningContinuationIntent.start =>
        l10n.quranGuidedPassagesAdultStartAction,
      ArabicLearningContinuationIntent.review =>
        l10n.quranGuidedPassagesAdultReviewAction,
      ArabicLearningContinuationIntent.resume ||
      ArabicLearningContinuationIntent.continueForward =>
        l10n.quranGuidedPassagesAdultContinueAction,
    };

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranGuidedPassagesAdultCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            summary.openedCount > 0
                ? l10n.quranGuidedPassagesAdultCardSubtitle(
                    _guidedPassageTitle(l10n, summary.passage.id),
                  )
                : l10n.quranGuidedPassagesAdultCardStartSubtitle,
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              summary.routeName,
              queryParameters: <String, String>{'passage': summary.passage.id},
            ),
            icon: const Icon(Icons.menu_book_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

String _guidedPassageTitle(AppLocalizations l10n, String passageId) {
  switch (passageId) {
    case 'fatihah_opening_passage':
      return l10n.quranGuidedPassagesOpeningTitle;
    case 'fatihah_response_passage':
      return l10n.quranGuidedPassagesResponseTitle;
    case 'fatihah_full_passage':
      return l10n.quranGuidedPassagesFullTitle;
  }
  return passageId;
}

void _openLesson(
  BuildContext context, {
  required QuranTeachingLesson lesson,
  required QuranTeachingModule module,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => QuranTeachingLessonPage(lesson: lesson, module: module),
    ),
  );
}

void _openModule(BuildContext context, QuranTeachingModule module) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => QuranTeachingModulePage(module: module),
    ),
  );
}

void _openListenOnly(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const QuranTeachingListenOnlyPage(),
    ),
  );
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
        color: context.palette.surfaceSoft.withValues(alpha: 0.75),
      ),
      child: Text(label),
    );
  }
}

String _modeLabel(AppLocalizations l10n, QuranTeachingAccessMode mode) {
  switch (mode) {
    case QuranTeachingAccessMode.guided:
      return l10n.quranTeachingModeGuided;
    case QuranTeachingAccessMode.broad:
      return l10n.quranTeachingModeBroad;
    case QuranTeachingAccessMode.open:
      return l10n.quranTeachingModeOpen;
  }
}

String _levelLabel(AppLocalizations l10n, QuranTeachingLearnerLevel level) {
  switch (level) {
    case QuranTeachingLearnerLevel.completelyNew:
      return l10n.quranTeachingLevelCompletelyNewTitle;
    case QuranTeachingLearnerLevel.knowSomeLetters:
      return l10n.quranTeachingLevelKnowSomeLettersTitle;
    case QuranTeachingLearnerLevel.readSlowly:
      return l10n.quranTeachingLevelReadSlowlyTitle;
    case QuranTeachingLearnerLevel.improveReading:
      return l10n.quranTeachingLevelImproveReadingTitle;
    case QuranTeachingLearnerLevel.openReference:
      return l10n.quranTeachingLevelOpenReferenceTitle;
  }
}

String _levelDescription(
  AppLocalizations l10n,
  QuranTeachingLearnerLevel level,
) {
  switch (level) {
    case QuranTeachingLearnerLevel.completelyNew:
      return l10n.quranTeachingLevelCompletelyNewDescription;
    case QuranTeachingLearnerLevel.knowSomeLetters:
      return l10n.quranTeachingLevelKnowSomeLettersDescription;
    case QuranTeachingLearnerLevel.readSlowly:
      return l10n.quranTeachingLevelReadSlowlyDescription;
    case QuranTeachingLearnerLevel.improveReading:
      return l10n.quranTeachingLevelImproveReadingDescription;
    case QuranTeachingLearnerLevel.openReference:
      return l10n.quranTeachingLevelOpenReferenceDescription;
  }
}

String _levelSubtitle(AppLocalizations l10n, QuranTeachingLearnerLevel? level) {
  if (level == null) {
    return l10n.quranTeachingPathSubtitle;
  }
  return l10n.quranTeachingPathActiveLevel(
    _levelLabel(l10n, level),
    _modeLabel(
      l10n,
      const QuranTeachingProgressState()
          .copyWith(learnerLevel: level)
          .accessMode,
    ),
  );
}
