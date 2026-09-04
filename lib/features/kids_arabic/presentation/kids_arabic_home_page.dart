import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../kids/shared/presentation/kids_page_scaffold.dart';
import '../../arabic/application/arabic_learning_asset_bundle.dart';
import '../../arabic/application/arabic_learning_assessment_provider.dart';
import '../../arabic/application/arabic_learning_lesson_packs_provider.dart';
import '../../arabic/application/arabic_learning_progress_provider.dart';
import '../../arabic/application/arabic_learning_quick_resume_provider.dart';
import '../../arabic/application/arabic_learning_search_provider.dart';
import '../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../arabic/domain/arabic_learning_search_models.dart';
import '../../arabic/presentation/arabic_learning_route_target_navigation.dart';
import '../../arabic/presentation/widgets/arabic_learning_discovery_search_section.dart';
import '../../arabic/presentation/widgets/arabic_learning_lesson_packs_section.dart';
import '../../arabic/presentation/widgets/arabic_learning_progress_dashboard_card.dart';
import '../../arabic/presentation/widgets/arabic_learning_quick_resume_section.dart';
import '../../learn/quran/application/quran_readiness_bridge_provider.dart';
import '../../learn/quran/application/quran_guided_passage_readiness_provider.dart';
import '../../learn/quran/application/quran_short_surah_readiness_provider.dart';
import '../../learn/quran/domain/quran_guided_passage_readiness_models.dart';
import '../../learn/quran/domain/quran_readiness_bridge_models.dart';
import '../../learn/quran/domain/quran_short_surah_readiness_models.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../application/kids_arabic_mastery_provider.dart';
import '../application/kids_arabic_phrases_provider.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_words_provider.dart';
import '../application/kids_arabic_coloring_provider.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_achievement_models.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_icons.dart';
import '../../../shared/widgets/section_title.dart';

class KidsArabicHomePage extends ConsumerStatefulWidget {
  const KidsArabicHomePage({super.key});

  @override
  ConsumerState<KidsArabicHomePage> createState() => _KidsArabicHomePageState();
}

class _KidsArabicHomePageState extends ConsumerState<KidsArabicHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<ArabicLearningSearchFilter> _selectedFilters =
      <ArabicLearningSearchFilter>{};
  bool _offlineWarmupQueued = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(kidsArabicProgressProvider);
    final dailyMission = ref.watch(kidsArabicDailyMissionProvider);
    final dailyProgress = ref.watch(kidsArabicDailyProgressProvider);
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final parentSummary = ref.watch(kidsArabicParentSummaryProvider);
    final parentActivity = ref.watch(
      kidsArabicParentRecommendedActivityProvider,
    );
    final parentReviewLetter = ref.watch(kidsArabicParentReviewLetterProvider);
    final recommended = ref.watch(kidsArabicRecommendedLettersProvider);
    final orderedLetters = ref.watch(kidsArabicProgressionLettersProvider);
    final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
    final unlockedColoringPages = ref.watch(
      kidsArabicUnlockedColoringPagesCountProvider,
    );
    final masterySummary = ref.watch(kidsArabicMasterySummaryProvider);
    final masteryRecommendation = ref.watch(
      kidsArabicMasteryRecommendationProvider,
    );
    final achievementSummary = ref.watch(kidsArabicAchievementSummaryProvider);
    final progressSummary = ref.watch(
      arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids),
    );
    final quickResume = ref.watch(
      arabicLearningQuickResumeSummaryProvider(ArabicLearningAudience.kids),
    );
    final miniAssessment = ref.watch(
      arabicLearningMiniAssessmentSessionProvider(ArabicLearningAudience.kids),
    );
    final lessonPacks = ref.watch(
      arabicLearningLessonPacksProvider(ArabicLearningAudience.kids),
    );
    final nextWord = ref.watch(kidsArabicNextRecommendedWordProvider);
    final completedWordsCount = ref.watch(
      kidsArabicCompletedWordsCountProvider,
    );
    final phrase = ref.watch(kidsArabicMiniPhraseRecommendedProvider);
    final heardPhrases = ref.watch(kidsArabicMiniPhraseHeardCountProvider);
    final quranReadiness = ref.watch(
      quranReadinessBridgeSummaryProvider(ArabicLearningAudience.kids),
    );
    final shortSurahs = ref.watch(
      quranShortSurahReadinessSummaryProvider(ArabicLearningAudience.kids),
    );
    final guidedPassages = ref.watch(
      quranGuidedPassageReadinessSummaryProvider(ArabicLearningAudience.kids),
    );
    final searchResults = ref.watch(
      arabicLearningSearchResultsProvider(
        ArabicLearningSearchQuery(
          audience: ArabicLearningAudience.kids,
          query: _searchController.text,
          filters: _selectedFilters,
        ),
      ),
    );
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final guidedLetter = parentActivity == null
        ? null
        : notifier.letterById(parentActivity.letterId);
    final homeRecommended = parentPreferences.guidedProgressionEnabled
        ? recommended
        : orderedLetters
              .where((letter) => unlockedLetterIds.contains(letter.id))
              .take(5)
              .toList(growable: false);

    if (!_offlineWarmupQueued) {
      _offlineWarmupQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final warmer = ref.read(arabicLearningOfflineWarmupProvider);
        warmer.prewarmContinuationTarget(
          audience: ArabicLearningAudience.kids,
          continuation: progressSummary.continuation,
        );
        warmer.prewarmAudienceStartBundle(ArabicLearningAudience.kids);
      });
    }

    return KidsPageScaffold(
      headerIcon: AppIcons.letters,
      title: l10n.kidsArabicHomeTitle,
      subtitle: l10n.kidsArabicHomeSubtitle,
      heroAsset: 'assets/images/learn_art/kids_arabic.webp',
      heroTitle: l10n.kidsDoorLettersTitle,
      heroSubtitle: l10n.kidsDoorLettersSubtitle,
      children: [
        if (guidedLetter != null &&
            (parentActivity!.source ==
                    KidsArabicRecommendedActivitySource.parentAssignedFocus ||
                parentActivity.source ==
                    KidsArabicRecommendedActivitySource
                        .parentAssignedReview)) ...[
          _ParentGuidanceCard(
            activity: parentActivity,
            letter: guidedLetter,
            reviewLetter: parentReviewLetter,
          ),
          const SizedBox(height: 12),
        ],
        if (dailyMission != null) ...[
          _DailyJourneyCard(
            mission: dailyMission,
            dailyProgress: dailyProgress,
            letter:
                notifier.letterById(dailyMission.targetLetterId) ??
                recommended.first,
            overrideActivity: parentActivity,
          ),
          const SizedBox(height: 12),
        ],
        ArabicLearningProgressDashboardCard(
          variant: ArabicLearningProgressDashboardVariant.kids,
          summary: progressSummary,
          kidsHighlight: achievementSummary.latestAchievement == null
              ? null
              : localizedKidsArabicAchievementTitle(
                  l10n,
                  achievementSummary.latestAchievement!,
                ),
          onPrimaryTap: () => openArabicLearningRouteTarget(
            context,
            target: progressSummary.continuation.primaryTarget,
          ),
          onSecondaryTap: progressSummary.reviewSuggestion == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: progressSummary.reviewSuggestion!.target,
                ),
        ),
        const SizedBox(height: 12),
        ArabicLearningQuickResumeSection(
          variant: ArabicLearningQuickResumeSectionVariant.kids,
          summary: quickResume,
          onPrimaryTap: () => openArabicLearningRouteTarget(
            context,
            target: quickResume.primaryTarget,
          ),
          onReviewTap: !quickResume.hasReviewAction
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: quickResume.reviewTarget!,
                ),
        ),
        const SizedBox(height: 12),
        _QuickPracticeCard(questionCount: miniAssessment.questions.length),
        const SizedBox(height: 12),
        ArabicLearningDiscoverySearchSection(
          variant: ArabicLearningDiscoveryVariant.kids,
          controller: _searchController,
          selectedFilters: _selectedFilters,
          results: searchResults,
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
            openArabicLearningRouteTarget(context, target: item.target);
          },
        ),
        const SizedBox(height: 12),
        ArabicLearningLessonPacksSection(
          variant: ArabicLearningLessonPacksVariant.kids,
          packs: lessonPacks,
          onOpenPack: (pack) => openArabicLearningRouteTarget(
            context,
            target: pack.primaryTarget,
          ),
        ),
        const SizedBox(height: 12),
        _MasterySnapshotCard(
          summary: masterySummary,
          recommendation: masteryRecommendation,
        ),
        const SizedBox(height: 12),
        _AchievementsCard(
          summary: achievementSummary,
          recommendation: masteryRecommendation,
        ),
        const SizedBox(height: 12),
        _BeginnerWordsCard(
          nextWordId: nextWord?.id,
          nextWordAr: nextWord?.wordAr,
          completedWordsCount: completedWordsCount,
        ),
        const SizedBox(height: 12),
        _MiniPhrasesCard(initialPhraseId: phrase?.id, heardCount: heardPhrases),
        const SizedBox(height: 12),
        _QuranReadinessCard(summary: quranReadiness),
        const SizedBox(height: 12),
        _ShortSurahsCard(summary: shortSurahs),
        const SizedBox(height: 12),
        _GuidedPassagesCard(summary: guidedPassages),
        const SizedBox(height: 12),
        if (progress.totalLessonsDone > 0) ...[
          _FamilySummaryCard(summary: parentSummary),
          const SizedBox(height: 12),
        ],
        _ColoringPagesCard(unlockedCount: unlockedColoringPages),
        const SizedBox(height: 12),
        _ActionRow(
          items: [
            _ActionRowItem(
              icon: Icons.auto_stories_rounded,
              label: l10n.kidsArabicReviewTitle,
              onTap: () => context.pushNamed('kidsArabicReview'),
            ),
            _ActionRowItem(
              icon: Icons.emoji_events_rounded,
              label: l10n.kidsArabicRewardsTitle,
              onTap: () => context.pushNamed('kidsArabicRewards'),
            ),
            _ActionRowItem(
              icon: Icons.family_restroom_rounded,
              label: l10n.kidsArabicParentDashboardTitle,
              onTap: () => context.pushNamed('kidsArabicParentDashboard'),
            ),
            _ActionRowItem(
              icon: Icons.tune_rounded,
              label: l10n.kidsArabicParentSettingsTitle,
              onTap: () => context.pushNamed('kidsArabicParentSettings'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.kidsArabicRecommendedTitle,
          subtitle: l10n.kidsArabicRecommendedSubtitle,
        ),
        const SizedBox(height: 10),
        ...homeRecommended.map(
          (letter) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LetterCard(
              letter: letter,
              childLine: localizedKidsArabicChildLine(l10n, letter.id),
              progress: progress.progressByLetterId[letter.id],
              locked: !unlockedLetterIds.contains(letter.id),
              showTransliteration: parentPreferences.showTransliteration,
              badgeLabel: kidsArabicStarterReleaseOrderIds.contains(letter.id)
                  ? l10n.kidsArabicStartHereBadge
                  : null,
              onTap: unlockedLetterIds.contains(letter.id)
                  ? () => context.pushNamed(
                      'kidsArabicLesson',
                      pathParameters: {'letterId': letter.id},
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          title: l10n.kidsArabicAlphabetTitle,
          subtitle: l10n.kidsArabicAlphabetSubtitle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: orderedLetters
              .map(
                (letter) => _GlyphButton(
                  letter: letter,
                  practicing:
                      unlockedLetterIds.contains(letter.id) &&
                      !progress.completedLetterIds.contains(letter.id),
                  completed:
                      (progress
                              .progressByLetterId[letter.id]
                              ?.lessonsCompleted ??
                          0) >
                      0,
                  needsReview: progress.reviewNeededLetterIds.contains(
                    letter.id,
                  ),
                  locked: !unlockedLetterIds.contains(letter.id),
                  onTap: unlockedLetterIds.contains(letter.id)
                      ? () => context.pushNamed(
                          'kidsArabicLesson',
                          pathParameters: {'letterId': letter.id},
                        )
                      : null,
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _ShortSurahsCard extends StatelessWidget {
  const _ShortSurahsCard({required this.summary});

  final QuranShortSurahReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranShortSurahsKidsCardTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            summary.hasSnippetBridgeStarted
                ? l10n.quranShortSurahsKidsCardSubtitle(
                    summary.surah.surahTransliteratedName,
                  )
                : l10n.quranShortSurahsKidsCardStartSubtitle,
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
            style: Theme.of(context).textTheme.bodySmall,
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
                l10n.quranShortSurahsKidsReviewAction,
              ArabicLearningContinuationIntent.continueForward =>
                l10n.quranShortSurahsKidsContinueAction,
              _ => l10n.quranShortSurahsKidsStartAction,
            }),
          ),
        ],
      ),
    );
  }
}

class _QuickPracticeCard extends StatelessWidget {
  const _QuickPracticeCard({required this.questionCount});

  final int questionCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7D6B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicMiniAssessmentCardTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(l10n.kidsArabicMiniAssessmentCardSubtitle(questionCount)),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed('kidsArabicMiniAssessment'),
            icon: const Icon(AppIcons.practice),
            label: Text(l10n.kidsArabicMiniAssessmentCardAction),
          ),
        ],
      ),
    );
  }
}

class _QuranReadinessCard extends StatelessWidget {
  const _QuranReadinessCard({required this.summary});

  final QuranReadinessBridgeSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.pushNamed(
        summary.routeName,
        queryParameters: <String, String>{'snippet': summary.snippet.id},
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE7D9B6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quranReadinessKidsCardTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              summary.hasArabicFoundationStarted
                  ? l10n.quranReadinessKidsCardSubtitle(
                      summary.snippet.snippetArabic,
                    )
                  : l10n.quranReadinessKidsCardStartSubtitle,
              style: const TextStyle(color: Color(0xFF665744), height: 1.35),
            ),
            const SizedBox(height: 12),
            Text(
              summary.snippet.snippetArabic,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 30,
                fontFamily: AppFonts.quranArabic,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A5622),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => context.pushNamed(
                summary.routeName,
                queryParameters: <String, String>{
                  'snippet': summary.snippet.id,
                },
              ),
              child: Text(switch (summary.intent) {
                ArabicLearningContinuationIntent.review =>
                  l10n.quranReadinessKidsReviewAction,
                ArabicLearningContinuationIntent.continueForward =>
                  l10n.quranReadinessKidsContinueAction,
                _ => l10n.quranReadinessKidsStartAction,
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidedPassagesCard extends StatelessWidget {
  const _GuidedPassagesCard({required this.summary});

  final QuranGuidedPassageReadinessSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actionLabel = switch (summary.intent) {
      ArabicLearningContinuationIntent.start =>
        l10n.quranGuidedPassagesKidsStartAction,
      ArabicLearningContinuationIntent.review =>
        l10n.quranGuidedPassagesKidsReviewAction,
      ArabicLearningContinuationIntent.resume ||
      ArabicLearningContinuationIntent.continueForward =>
        l10n.quranGuidedPassagesKidsContinueAction,
    };

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranGuidedPassagesKidsCardTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summary.openedCount > 0
                ? l10n.quranGuidedPassagesKidsCardSubtitle(
                    _guidedPassageTitle(l10n, summary.passage.id),
                  )
                : l10n.quranGuidedPassagesKidsCardStartSubtitle,
            style: TextStyle(color: context.palette.onSurface, height: 1.35),
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

class _ColoringPagesCard extends StatelessWidget {
  const _ColoringPagesCard({required this.unlockedCount});

  final int unlockedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.pushNamed('kidsArabicColoringPages'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.palette.surfaceSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.format_paint_rounded,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.kidsArabicColoringPagesTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.kidsArabicColoringPagesProgressValue(unlockedCount, 5),
                    style: TextStyle(color: context.palette.onSurfaceSubtle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPhrasesCard extends StatelessWidget {
  const _MiniPhrasesCard({
    required this.initialPhraseId,
    required this.heardCount,
  });

  final String? initialPhraseId;
  final int heardCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.pushNamed(
        'kidsArabicMiniPhrases',
        queryParameters: initialPhraseId == null
            ? <String, String>{}
            : {'phrase': initialPhraseId!},
      ),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.palette.success.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: context.palette.success.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFCFFF8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: context.palette.successInk,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.kidsArabicMiniPhrasesHomeTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.kidsArabicMiniPhrasesHomeSubtitle(heardCount),
                    style: TextStyle(
                      color: context.palette.successInk,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyJourneyCard extends StatelessWidget {
  const _DailyJourneyCard({
    required this.mission,
    required this.dailyProgress,
    required this.letter,
    this.overrideActivity,
  });

  final KidsArabicDailyMission mission;
  final KidsArabicDailyProgress dailyProgress;
  final KidsArabicLetter letter;
  final KidsArabicRecommendedActivity? overrideActivity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final completed =
        mission.isCompleted || dailyProgress.todayMissionCompleted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: completed
            ? context.palette.success.withValues(alpha: 0.25)
            : context.palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: completed
              ? context.palette.success.withValues(alpha: 0.45)
              : context.palette.surfaceSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicDailyJourneyTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            completed
                ? l10n.kidsArabicDailyJourneyCompletedSubtitle
                : localizedKidsArabicDailyMissionTitle(l10n, mission, letter),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            completed
                ? l10n.kidsArabicDailyJourneyReturnTomorrow
                : localizedKidsArabicDailyMissionDescription(
                    l10n,
                    mission,
                    letter,
                  ),
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryPill(
                label: l10n.kidsArabicDailyJourneyStreakValue(
                  dailyProgress.currentStreak,
                ),
              ),
              if (dailyProgress.graceDaysAvailable > 0)
                _SummaryPill(
                  label: l10n.kidsArabicDailyJourneyGraceValue(
                    dailyProgress.graceDaysAvailable,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (!completed)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (overrideActivity != null) {
                    if (overrideActivity!.opensReview) {
                      context.pushNamed('kidsArabicReview');
                    } else {
                      context.pushNamed(
                        'kidsArabicLesson',
                        pathParameters: {
                          'letterId': overrideActivity!.letterId,
                        },
                      );
                    }
                    return;
                  }
                  switch (mission.type) {
                    case KidsArabicDailyMissionType.newLetter:
                    case KidsArabicDailyMissionType.tracePractice:
                      context.pushNamed(
                        'kidsArabicLesson',
                        pathParameters: {'letterId': mission.targetLetterId},
                      );
                    case KidsArabicDailyMissionType.review:
                      context.pushNamed('kidsArabicReview');
                  }
                },
                child: Text(l10n.kidsArabicDailyJourneyContinueAction),
              ),
            )
          else
            Text(
              l10n.kidsArabicDailyJourneyTomorrowHint,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.palette.successInk,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      // The pill sits in a Wrap; the default expands it to the full row.
      expandToWidth: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      fillColor: Colors.white,
      borderColor: context.palette.surfaceSoft,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: context.palette.onSurfaceSubtle,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.items});

  final List<_ActionRowItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F0E6),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE6D7C5)),
                    ),
                    child: Column(
                      children: [
                        Icon(item.icon, color: const Color(0xFF876742)),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: context.palette.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ActionRowItem {
  const _ActionRowItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard({
    required this.summary,
    required this.recommendation,
  });

  final KidsArabicAchievementSummary summary;
  final KidsArabicMasteryRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final latest = summary.latestAchievement;
    final nextStep = switch (recommendation?.type) {
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewLetterTitle(recommendation!.letter.nameAr),
      KidsArabicMasteryRecommendationType.continueSequence =>
        l10n.kidsArabicMasteryContinueLetterTitle(
          recommendation!.letter.nameAr,
        ),
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryCelebrateTitle,
      null => l10n.kidsArabicPracticeTitle,
    };
    return InkWell(
      onTap: () => context.pushNamed('kidsArabicRewards'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4EA),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.palette.surfaceSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.kidsArabicAchievementsHomeTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              latest == null
                  ? l10n.kidsArabicAchievementsHomeEmptyTitle
                  : localizedKidsArabicAchievementTitle(l10n, latest),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              latest == null
                  ? l10n.kidsArabicAchievementsHomeEmptySubtitle
                  : localizedKidsArabicAchievementSubtitle(l10n, latest),
              style: TextStyle(
                color: context.palette.onSurfaceSubtle,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryPill(
                  label: l10n.kidsArabicBadgesUnlockedValue(
                    summary.badgesUnlocked,
                  ),
                ),
                _SummaryPill(
                  label: l10n.kidsArabicMilestonesUnlockedValue(
                    summary.milestonesUnlocked,
                  ),
                ),
                _SummaryPill(
                  label: l10n.kidsArabicWordsCompletedValue(
                    summary.wordsCompleted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.kidsArabicAchievementsNextStepLabel(nextStep),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.pushNamed('kidsArabicRewards'),
                child: Text(l10n.kidsArabicAchievementsOpenAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MasterySnapshotCard extends StatelessWidget {
  const _MasterySnapshotCard({
    required this.summary,
    required this.recommendation,
  });

  final KidsArabicMasterySummary summary;
  final KidsArabicMasteryRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (recommendation?.type) {
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewLetterTitle(recommendation!.letter.nameAr),
      KidsArabicMasteryRecommendationType.continueSequence =>
        l10n.kidsArabicMasteryContinueLetterTitle(
          recommendation!.letter.nameAr,
        ),
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryCelebrateTitle,
      null => l10n.kidsArabicMasteryMapTitle,
    };
    final subtitle = switch (recommendation?.type) {
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewLetterBody,
      KidsArabicMasteryRecommendationType.continueSequence =>
        l10n.kidsArabicMasteryContinueLetterBody,
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryCelebrateBody(recommendation!.letter.nameAr),
      null => l10n.kidsArabicMasteryHomeSubtitle,
    };
    return InkWell(
      onTap: () => context.pushNamed('kidsArabicProgressMap'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8EF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD5E6CF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.kidsArabicMasteryHomeTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.palette.successInk,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(color: context.palette.successInk, height: 1.35),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryPill(
                  label: l10n.kidsArabicLettersCompletedValue(
                    summary.completedCount,
                  ),
                ),
                _SummaryPill(
                  label: l10n.kidsArabicMasteryPracticingCountValue(
                    summary.practicingCount,
                  ),
                ),
                _SummaryPill(
                  label: l10n.kidsArabicMasteryReviewCountValue(
                    summary.reviewCount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.pushNamed('kidsArabicProgressMap'),
                child: Text(l10n.kidsArabicMasteryOpenMapAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeginnerWordsCard extends StatelessWidget {
  const _BeginnerWordsCard({
    required this.nextWordId,
    required this.nextWordAr,
    required this.completedWordsCount,
  });

  final String? nextWordId;
  final String? nextWordAr;
  final int completedWordsCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.pushNamed('kidsArabicWordsHome'),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD5DEF6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.kidsArabicWordsTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF24324A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              nextWordAr == null
                  ? l10n.kidsArabicWordsHomeSubtitle
                  : l10n.kidsArabicWordsNextSubtitle(nextWordAr!),
              textDirection: nextWordAr == null
                  ? Directionality.of(context)
                  : TextDirection.rtl,
              style: const TextStyle(color: Color(0xFF4A5870), height: 1.35),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryPill(
                  label: l10n.kidsArabicWordsCompletedValue(
                    completedWordsCount,
                  ),
                ),
                if (nextWordId != null)
                  _SummaryPill(label: l10n.kidsArabicWordsContinueAction),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => context.pushNamed('kidsArabicWordsHome'),
                    child: Text(l10n.kidsArabicWordsOpenAction),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed(
                      'kidsArabicReadingMode',
                      queryParameters: nextWordId == null
                          ? <String, String>{}
                          : {'word': nextWordId!},
                    ),
                    child: Text(l10n.kidsArabicReadingModeOpenAction),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterCard extends StatelessWidget {
  const _LetterCard({
    required this.letter,
    required this.childLine,
    required this.progress,
    required this.locked,
    required this.showTransliteration,
    required this.onTap,
    this.badgeLabel,
  });

  final KidsArabicLetter letter;
  final String childLine;
  final KidsArabicLetterProgress? progress;
  final bool locked;
  final bool showTransliteration;
  final VoidCallback? onTap;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final lessonsCompleted = progress?.lessonsCompleted ?? 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.palette.surfaceSoft),
        ),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                letter.glyph,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'Noto Naskh Arabic',
                  fontWeight: FontWeight.w700,
                  color: context.palette.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badgeLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F2D7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeLabel!,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: context.palette.successInk,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    letter.nameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (showTransliteration) ...[
                    Text(
                      letter.transliteration,
                      style: TextStyle(
                        color: context.palette.onSurfaceSubtle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    childLine,
                    textDirection: Directionality.of(context),
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locked
                        ? AppLocalizations.of(context).kidsArabicLockedStatus
                        : lessonsCompleted == 0
                        ? AppLocalizations.of(context).kidsArabicReadyToStart
                        : AppLocalizations.of(
                            context,
                          ).kidsArabicLessonsDoneValue(lessonsCompleted),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentGuidanceCard extends StatelessWidget {
  const _ParentGuidanceCard({
    required this.activity,
    required this.letter,
    required this.reviewLetter,
  });

  final KidsArabicRecommendedActivity activity;
  final KidsArabicLetter letter;
  final KidsArabicLetter? reviewLetter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isReview =
        activity.source ==
        KidsArabicRecommendedActivitySource.parentAssignedReview;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD5DEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isReview
                ? l10n.kidsArabicParentReviewNextTitle
                : l10n.kidsArabicParentTodayFocusTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24324A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isReview
                ? l10n.kidsArabicParentReviewNextSubtitle(
                    reviewLetter?.nameAr ?? letter.nameAr,
                  )
                : l10n.kidsArabicParentTodayFocusSubtitle(letter.nameAr),
            textDirection: Directionality.of(context),
            style: const TextStyle(color: Color(0xFF4A5870), height: 1.35),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () {
                if (isReview) {
                  context.pushNamed('kidsArabicReview');
                } else {
                  context.pushNamed(
                    'kidsArabicLesson',
                    pathParameters: {'letterId': letter.id},
                  );
                }
              },
              child: Text(l10n.kidsArabicDailyJourneyContinueAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilySummaryCard extends StatelessWidget {
  const _FamilySummaryCard({required this.summary});

  final KidsArabicParentSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD5E6CF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicFamilySummaryTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicFamilySummarySubtitle(
              summary.currentStreak,
              summary.earnedStickerCount,
            ),
            style: TextStyle(color: context.palette.successInk, height: 1.35),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.pushNamed('kidsArabicParentDashboard'),
              child: Text(l10n.kidsArabicFamilySummaryAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlyphButton extends StatelessWidget {
  const _GlyphButton({
    required this.letter,
    required this.practicing,
    required this.completed,
    required this.needsReview,
    required this.locked,
    required this.onTap,
  });

  final KidsArabicLetter letter;
  final bool practicing;
  final bool completed;
  final bool needsReview;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = locked
        ? context.palette.surface
        : needsReview
        ? const Color(0xFFFFF0DC)
        : practicing
        ? const Color(0xFFFFF4DF)
        : completed
        ? const Color(0xFFE9F4DF)
        : context.palette.surface;
    final border = locked
        ? context.palette.surfaceSoft
        : needsReview
        ? const Color(0xFFE5B77B)
        : practicing
        ? const Color(0xFFE6C485)
        : completed
        ? const Color(0xFFC4DAA9)
        : context.palette.surfaceSoft;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 72,
        height: 80,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          letter.glyph,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'Noto Naskh Arabic',
            fontWeight: FontWeight.w700,
            color: context.palette.onSurface,
          ),
        ),
      ),
    );
  }
}
