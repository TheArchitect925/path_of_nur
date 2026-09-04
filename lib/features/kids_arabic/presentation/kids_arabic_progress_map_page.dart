import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../application/kids_arabic_mastery_provider.dart';
import '../domain/kids_arabic_achievement_models.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicProgressMapPage extends ConsumerWidget {
  const KidsArabicProgressMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(kidsArabicMasterySummaryProvider);
    final statuses = ref.watch(kidsArabicMasteryStatusesProvider);
    final recommendation = ref.watch(kidsArabicMasteryRecommendationProvider);
    final reviewCandidates = ref.watch(kidsArabicReviewCandidatesProvider);
    final achievementSummary = ref.watch(kidsArabicAchievementSummaryProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.map_rounded,
      title: l10n.kidsArabicMasteryMapTitle,
      subtitle: l10n.kidsArabicMasteryMapSubtitle,
      children: [
        _MasteryOverviewCard(summary: summary),
        const SizedBox(height: 12),
        _AchievementSnapshotCard(summary: achievementSummary),
        const SizedBox(height: 12),
        if (recommendation != null) ...[
          _RecommendationCard(recommendation: recommendation),
          const SizedBox(height: 12),
        ],
        if (reviewCandidates.isNotEmpty) ...[
          _ReviewSection(reviewCandidates: reviewCandidates),
          const SizedBox(height: 18),
        ],
        _SectionHeader(
          title: l10n.kidsArabicMasteryProgressMapSectionTitle,
          subtitle: l10n.kidsArabicMasteryProgressMapSectionSubtitle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: statuses
              .map((status) => _ProgressTile(status: status))
              .toList(growable: false),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicMasteryCompletedSectionTitle,
          subtitle: l10n.kidsArabicMasteryCompletedSectionSubtitle(
            summary.completedCount,
            summary.totalLetters,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses
              .where((item) => item.state == KidsArabicMasteryState.completed)
              .map((item) => _CompletedChip(letter: item.letter))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _AchievementSnapshotCard extends StatelessWidget {
  const _AchievementSnapshotCard({required this.summary});

  final KidsArabicAchievementSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final latest = summary.latestAchievement;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D0B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicMilestonesSectionTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            latest == null
                ? l10n.kidsArabicAchievementsHomeEmptySubtitle
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
                ? l10n.kidsArabicMilestonesSectionSubtitle
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
            ],
          ),
        ],
      ),
    );
  }
}

class _MasteryOverviewCard extends StatelessWidget {
  const _MasteryOverviewCard({required this.summary});

  final KidsArabicMasterySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _SummaryPill(
            label: l10n.kidsArabicLettersCompletedValue(summary.completedCount),
          ),
          _SummaryPill(
            label: l10n.kidsArabicMasteryPracticingCountValue(
              summary.practicingCount,
            ),
          ),
          _SummaryPill(
            label: l10n.kidsArabicMasteryReviewCountValue(summary.reviewCount),
          ),
          _SummaryPill(
            label: l10n.kidsArabicMasteryTotalLettersValue(
              summary.totalLetters,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final KidsArabicMasteryRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (recommendation.type) {
      KidsArabicMasteryRecommendationType.continueSequence =>
        l10n.kidsArabicMasteryContinueLetterTitle(recommendation.letter.nameAr),
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewLetterTitle(recommendation.letter.nameAr),
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryCelebrateTitle,
    };
    final body = switch (recommendation.type) {
      KidsArabicMasteryRecommendationType.continueSequence =>
        l10n.kidsArabicMasteryContinueLetterBody,
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewLetterBody,
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryCelebrateBody(recommendation.letter.nameAr),
    };
    final actionLabel = switch (recommendation.type) {
      KidsArabicMasteryRecommendationType.reviewLetter =>
        l10n.kidsArabicMasteryReviewAction,
      KidsArabicMasteryRecommendationType.continueSequence ||
      KidsArabicMasteryRecommendationType.celebrateProgress =>
        l10n.kidsArabicMasteryContinueAction,
    };
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.success.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.palette.success.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicMasteryNextStepTitle,
            style: TextStyle(
              fontSize: 18,
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
            body,
            style: TextStyle(color: context.palette.successInk, height: 1.35),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                switch (recommendation.type) {
                  case KidsArabicMasteryRecommendationType.reviewLetter:
                    context.pushNamed('kidsArabicReview');
                  case KidsArabicMasteryRecommendationType.continueSequence:
                  case KidsArabicMasteryRecommendationType.celebrateProgress:
                    context.pushNamed(
                      'kidsArabicLesson',
                      pathParameters: {'letterId': recommendation.letter.id},
                    );
                }
              },
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.reviewCandidates});

  final List<KidsArabicLetter> reviewCandidates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D0B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsArabicMasteryReviewSectionTitle,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsArabicMasteryReviewSectionSubtitle,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: reviewCandidates
                .map((letter) => _CompletedChip(letter: letter))
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonal(
              onPressed: () => context.pushNamed('kidsArabicReview'),
              child: Text(l10n.kidsArabicMasteryReviewAction),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.status});

  final KidsArabicMasteryLetterStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final background = switch (status.state) {
      KidsArabicMasteryState.completed => const Color(0xFFE9F4DF),
      KidsArabicMasteryState.practicing => const Color(0xFFFFF4DF),
      KidsArabicMasteryState.notStarted => context.palette.surface,
    };
    final border = switch (status.state) {
      KidsArabicMasteryState.completed => const Color(0xFFC4DAA9),
      KidsArabicMasteryState.practicing => const Color(0xFFE6C485),
      KidsArabicMasteryState.notStarted => context.palette.surfaceSoft,
    };
    final stateLabel = switch (status.state) {
      KidsArabicMasteryState.completed => l10n.kidsArabicMasteryStateCompleted,
      KidsArabicMasteryState.practicing =>
        l10n.kidsArabicMasteryStatePracticing,
      KidsArabicMasteryState.notStarted =>
        l10n.kidsArabicMasteryStateNotStarted,
    };
    return InkWell(
      onTap: status.isUnlocked
          ? () => context.pushNamed(
              'kidsArabicLesson',
              pathParameters: {'letterId': status.letter.id},
            )
          : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 102,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              status.letter.glyph,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 34,
                fontFamily: 'Noto Naskh Arabic',
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              status.letter.nameAr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: context.palette.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              stateLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
            if (status.reviewRecommended) ...[
              const SizedBox(height: 6),
              Text(
                l10n.kidsArabicMasteryReviewBadge,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9A6425),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompletedChip extends StatelessWidget {
  const _CompletedChip({required this.letter});

  final KidsArabicLetter letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Text(
        '${letter.glyph} ${letter.nameAr}',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: context.palette.onSurfaceSubtle,
        ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.palette.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: context.palette.onSurfaceSubtle,
            height: 1.35,
          ),
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
    return AppLayeredGlassPill(
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
