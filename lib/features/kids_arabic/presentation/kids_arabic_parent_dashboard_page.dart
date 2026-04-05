import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../arabic/presentation/arabic_learning_route_target_navigation.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_parent_overview_models.dart';
import 'kids_arabic_localized_content.dart';

class KidsArabicParentDashboardPage extends ConsumerWidget {
  const KidsArabicParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final overview = ref.watch(kidsArabicParentOverviewSummaryProvider);
    final preferences = ref.watch(kidsArabicParentPreferencesProvider);
    final summary = ref.watch(kidsArabicParentSummaryProvider);
    final achievement = ref.watch(kidsArabicLatestAchievementProvider);
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final latestLetter = overview.latestCompletedLetterId == null
        ? null
        : notifier.letterById(overview.latestCompletedLetterId!);
    final reviewLetter = summary.reviewNeededLetterIds.isEmpty
        ? null
        : notifier.letterById(summary.reviewNeededLetterIds.first);
    final focusLetter = preferences.parentAssignedLetterId == null
        ? null
        : notifier.letterById(preferences.parentAssignedLetterId!);

    return LearnHubPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.kidsArabicParentDashboardTitle,
      subtitle: l10n.kidsArabicParentDashboardSubtitle,
      children: [
        _OverviewHeroCard(
          overview: overview,
          latestLetterName: latestLetter?.nameAr,
          onPrimaryTap: () => openArabicLearningRouteTarget(
            context,
            target: overview.continuation.primaryTarget,
          ),
          onSecondaryTap: overview.reviewSuggestion == null
              ? null
              : () => openArabicLearningRouteTarget(
                  context,
                  target: overview.reviewSuggestion!.target,
                ),
        ),
        const SizedBox(height: 12),
        _ProgressSnapshotRow(overview: overview),
        const SizedBox(height: 12),
        if (achievement != null) ...[
          _InfoCard(
            title: l10n.kidsArabicParentLatestMilestoneTitle,
            body: l10n.kidsArabicParentLatestMilestoneBody(
              localizedKidsArabicAchievementTitle(l10n, achievement),
            ),
            trailing: Text(
              localizedKidsArabicAchievementSubtitle(l10n, achievement),
              style: const TextStyle(color: Color(0xFF6A5E50), height: 1.35),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (overview.recentActivity != null) ...[
          _InfoCard(
            title: l10n.kidsArabicParentRecentActivityTitle,
            body: l10n.kidsArabicParentRecentActivityBody(
              overview.recentActivity!.title,
            ),
            arabicPreview: overview.recentActivity!.arabicText,
          ),
          const SizedBox(height: 12),
        ],
        _InfoCard(
          title: l10n.kidsArabicParentGuidanceTitle,
          body: l10n.kidsArabicParentGuidanceBody(
            focusLetter?.nameAr ?? l10n.kidsArabicParentNoFocusOption,
            reviewLetter?.nameAr ?? l10n.kidsArabicParentReviewNotNeeded,
          ),
          actionLabel: l10n.kidsArabicParentSettingsTitle,
          onActionTap: () => context.pushNamed('kidsArabicParentSettings'),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: l10n.kidsArabicParentWeeklyConsistencyTitle,
          body: l10n.kidsArabicParentWeeklyConsistencyBody(
            summary.weeklyCompletionCount,
            summary.currentStreak,
          ),
          trailing: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: summary.weeklyConsistency
                .map(
                  (day) => _ConsistencyDot(
                    label: _weekdayLabel(l10n, day.weekday),
                    completed: day.completed,
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  String _weekdayLabel(AppLocalizations l10n, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.kidsArabicWeekdayMon;
      case DateTime.tuesday:
        return l10n.kidsArabicWeekdayTue;
      case DateTime.wednesday:
        return l10n.kidsArabicWeekdayWed;
      case DateTime.thursday:
        return l10n.kidsArabicWeekdayThu;
      case DateTime.friday:
        return l10n.kidsArabicWeekdayFri;
      case DateTime.saturday:
        return l10n.kidsArabicWeekdaySat;
      case DateTime.sunday:
      default:
        return l10n.kidsArabicWeekdaySun;
    }
  }
}

class _OverviewHeroCard extends StatelessWidget {
  const _OverviewHeroCard({
    required this.overview,
    required this.onPrimaryTap,
    required this.latestLetterName,
    this.onSecondaryTap,
  });

  final KidsArabicParentOverviewSummary overview;
  final String? latestLetterName;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = !overview.hasStarted
        ? l10n.kidsArabicParentOverviewStartTitle
        : overview.hasFinishedCurrentBeginnerSet
        ? l10n.kidsArabicParentOverviewCompletedTitle
        : l10n.kidsArabicParentOverviewProgressTitle;
    final body = !overview.hasStarted
        ? l10n.kidsArabicParentOverviewStartBody
        : overview.hasFinishedCurrentBeginnerSet
        ? l10n.kidsArabicParentOverviewCompletedBody
        : latestLetterName == null
        ? l10n.kidsArabicParentOverviewProgressFallback
        : l10n.kidsArabicParentOverviewProgressBody(latestLetterName!);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE1D5C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(
                label: overview.practicedToday
                    ? l10n.kidsArabicParentPracticedToday
                    : l10n.kidsArabicParentNotPracticedToday,
              ),
              if (overview.reviewNeededCount > 0)
                _HeroChip(
                  label: l10n.kidsArabicParentReviewCountValue(
                    overview.reviewNeededCount,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF64584A), height: 1.35),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: onPrimaryTap,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  !overview.hasStarted
                      ? l10n.kidsArabicParentStartArabicAction
                      : l10n.kidsArabicParentContinueArabicAction,
                ),
              ),
              if (onSecondaryTap != null)
                FilledButton.tonalIcon(
                  onPressed: onSecondaryTap,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.kidsArabicParentReviewAction),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressSnapshotRow extends StatelessWidget {
  const _ProgressSnapshotRow({required this.overview});

  final KidsArabicParentOverviewSummary overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatPill(
          label: l10n.kidsArabicParentLettersValue(overview.lettersLearned),
        ),
        _StatPill(
          label: l10n.kidsArabicParentWordsValue(overview.wordsPracticed),
        ),
        _StatPill(
          label: l10n.kidsArabicParentPhrasesValue(overview.phrasesHeard),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      fillColor: const Color(0xFFFFFBF4),
      borderColor: const Color(0xFFE3D7C5),
      borderRadius: 18,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF5E4C36),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.body,
    this.arabicPreview,
    this.trailing,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String body;
  final String? arabicPreview;
  final Widget? trailing;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5D5C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
          ),
          if (arabicPreview != null) ...[
            const SizedBox(height: 10),
            Text(
              arabicPreview!,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 26,
                fontFamily: 'AmiriQuran',
                fontWeight: FontWeight.w700,
                color: Color(0xFF7B5D2E),
              ),
            ),
          ],
          if (trailing != null) ...[const SizedBox(height: 12), trailing!],
          if (actionLabel != null && onActionTap != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onActionTap,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConsistencyDot extends StatelessWidget {
  const _ConsistencyDot({required this.label, required this.completed});

  final String label;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFE6F2DE) : const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? const Color(0xFFC6D9B4) : const Color(0xFFE3D7C5),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF5E4C36),
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: completed
                ? const Color(0xFF61893D)
                : const Color(0xFFB79A72),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2D7C7)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF6A5A46),
        ),
      ),
    );
  }
}
