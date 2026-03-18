import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';

class KidsArabicParentDashboardPage extends ConsumerWidget {
  const KidsArabicParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(kidsArabicParentSummaryProvider);
    final preferences = ref.watch(kidsArabicParentPreferencesProvider);
    final weakLetters = ref.watch(kidsArabicWeakLettersProvider);
    final notifier = ref.read(kidsArabicProgressProvider.notifier);
    final latestLetter = summary.latestCompletedLetterId == null
        ? null
        : notifier.letterById(summary.latestCompletedLetterId!);
    final nextLetter = summary.recommendedNextLetterId == null
        ? null
        : notifier.letterById(summary.recommendedNextLetterId!);
    final assignedFocusLetter = preferences.parentAssignedLetterId == null
        ? null
        : notifier.letterById(preferences.parentAssignedLetterId!);
    final assignedReviewLetter =
        preferences.parentAssignedReviewLetterId == null
        ? null
        : notifier.letterById(preferences.parentAssignedReviewLetterId!);
    return LearnHubPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.kidsArabicParentDashboardTitle,
      subtitle: l10n.kidsArabicParentDashboardSubtitle,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.tonalIcon(
            onPressed: () => context.pushNamed('kidsArabicParentSettings'),
            icon: const Icon(Icons.tune_rounded),
            label: Text(l10n.kidsArabicParentSettingsTitle),
          ),
        ),
        const SizedBox(height: 12),
        _DashboardStat(
          label: l10n.kidsArabicLettersCompletedLabel,
          value: '${summary.lettersCompleted}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicLessonsDoneLabel,
          value: '${summary.lessonsCompleted}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicCurrentStreakLabel,
          value: '${summary.currentStreak}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicParentBestStreakLabel,
          value: '${summary.bestStreak}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicParentActiveDaysThisWeekLabel,
          value: '${summary.activeDaysThisWeek}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicParentWeeklyCompletionLabel,
          value: '${summary.weeklyCompletionCount}',
        ),
        _DashboardStat(
          label: l10n.kidsArabicRewardsTitle,
          value: '${summary.earnedStickerCount}',
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: l10n.kidsArabicParentOverviewTitle,
          body: l10n.kidsArabicParentOverviewBody(
            latestLetter?.nameAr ?? l10n.kidsArabicParentNoLatestLetter,
            nextLetter?.nameAr ?? l10n.kidsArabicParentNoNextLetter,
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: l10n.kidsArabicParentAssignmentsTitle,
          body: l10n.kidsArabicParentAssignmentsBody(
            preferences.allowParentAssignedFocus
                ? (assignedFocusLetter?.nameAr ??
                      l10n.kidsArabicParentNoFocusOption)
                : l10n.kidsArabicParentAssignmentsOff,
            preferences.prioritizeReview
                ? (assignedReviewLetter?.nameAr ??
                      l10n.kidsArabicParentNoReviewOption)
                : l10n.kidsArabicParentAssignmentsOff,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.kidsArabicParentWeeklyConsistencyTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E261F),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: summary.weeklyConsistency
              .map(
                (day) => Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: day.completed
                        ? const Color(0xFFE7F3DC)
                        : const Color(0xFFF8F2E8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: day.completed
                          ? const Color(0xFFC8DDAA)
                          : const Color(0xFFE5D5C1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _weekdayLabel(l10n, day.weekday),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5E462A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Icon(
                        day.completed
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: day.completed
                            ? const Color(0xFF5D8A39)
                            : const Color(0xFFB79A72),
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.kidsArabicParentReviewNeededTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E261F),
          ),
        ),
        const SizedBox(height: 8),
        if (weakLetters.isEmpty)
          Text(
            l10n.kidsArabicParentReviewNeededEmpty,
            style: const TextStyle(color: Color(0xFF675B4E)),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: weakLetters
                .map(
                  (letter) => Container(
                    width: 68,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1DE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5C497)),
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
                )
                .toList(growable: false),
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

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F2E8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE5D5C1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E261F),
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A6C49),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}
