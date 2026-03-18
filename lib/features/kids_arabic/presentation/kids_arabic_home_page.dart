import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_progression.dart';
import '../application/kids_arabic_coloring_provider.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../application/kids_arabic_daily_mission_service.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_localized_content.dart';

class KidsArabicHomePage extends ConsumerWidget {
  const KidsArabicHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return LearnHubPageScaffold(
      headerIcon: Icons.text_fields_rounded,
      title: l10n.kidsArabicHomeTitle,
      subtitle: l10n.kidsArabicHomeSubtitle,
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
        _KidsArabicSummaryCard(progress: progress),
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
        _SectionHeader(
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
        _SectionHeader(
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
          color: const Color(0xFFF8F2E8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5D5C1)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.format_paint_rounded,
                color: Color(0xFF8A6C49),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.kidsArabicColoringPagesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E261F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.kidsArabicColoringPagesProgressValue(unlockedCount, 5),
                    style: const TextStyle(color: Color(0xFF675B4E)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A6C49)),
          ],
        ),
      ),
    );
  }
}

class _KidsArabicSummaryCard extends StatelessWidget {
  const _KidsArabicSummaryCard({required this.progress});

  final KidsArabicProgressState progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D8BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicProgressTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryPill(
                label: l10n.kidsArabicLettersCompletedValue(
                  progress.completedLetterIds.length,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicLessonsDoneValue(
                  progress.totalLessonsDone,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicCurrentStreakValue(
                  progress.localCurrentStreakDays,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicDropsValue(
                  progress.totalFeatureDropsAwarded,
                ),
              ),
            ],
          ),
        ],
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
    final rewardPreview = l10n.kidsArabicDailyJourneyRewardPreview(
      kidsArabicDailyBonusXp,
      kidsArabicDailyBonusDrops,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFEFF6E6) : const Color(0xFFFFF5E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: completed ? const Color(0xFFD4E4C0) : const Color(0xFFE8D8BE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicDailyJourneyTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            completed
                ? l10n.kidsArabicDailyJourneyCompletedSubtitle
                : localizedKidsArabicDailyMissionTitle(l10n, mission, letter),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4A36),
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
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
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
              _SummaryPill(label: rewardPreview),
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
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF52713A),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E261F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2D2BC)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B583F),
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
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5D4A36),
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
          color: const Color(0xFFF8F2E8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5D5C1)),
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
                style: const TextStyle(
                  fontSize: 42,
                  fontFamily: 'Noto Naskh Arabic',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5E462A),
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
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF52713A),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    letter.nameAr,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E261F),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (showTransliteration) ...[
                    Text(
                      letter.transliteration,
                      style: const TextStyle(
                        color: Color(0xFF8A6C49),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    childLine,
                    textDirection: Directionality.of(context),
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
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
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A6C49),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Color(0xFF876742)),
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
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicFamilySummarySubtitle(
              summary.currentStreak,
              summary.earnedStickerCount,
            ),
            style: const TextStyle(color: Color(0xFF5A6A4A), height: 1.35),
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
    required this.completed,
    required this.needsReview,
    required this.locked,
    required this.onTap,
  });

  final KidsArabicLetter letter;
  final bool completed;
  final bool needsReview;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = locked
        ? const Color(0xFFF2EEE7)
        : needsReview
        ? const Color(0xFFFFF0DC)
        : completed
        ? const Color(0xFFE9F4DF)
        : const Color(0xFFF8F2E8);
    final border = locked
        ? const Color(0xFFD8CFC2)
        : needsReview
        ? const Color(0xFFE5B77B)
        : completed
        ? const Color(0xFFC4DAA9)
        : const Color(0xFFE5D5C1);
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
          style: const TextStyle(
            fontSize: 32,
            fontFamily: 'Noto Naskh Arabic',
            fontWeight: FontWeight.w700,
            color: Color(0xFF5E462A),
          ),
        ),
      ),
    );
  }
}
