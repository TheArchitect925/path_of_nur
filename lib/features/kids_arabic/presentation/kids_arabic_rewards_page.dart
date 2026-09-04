import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_achievements_provider.dart';
import '../domain/kids_arabic_achievement_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicRewardsPage extends ConsumerWidget {
  const KidsArabicRewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final achievementSummary = ref.watch(kidsArabicAchievementSummaryProvider);
    final achievementStatuses = ref.watch(
      kidsArabicAchievementStatusesProvider,
    );
    final latestAchievement = achievementSummary.latestAchievement;
    final badgeStatuses = achievementStatuses
        .where(
          (status) => status.definition.kind == KidsArabicAchievementKind.badge,
        )
        .toList(growable: false);
    final milestoneStatuses = achievementStatuses
        .where(
          (status) =>
              status.definition.kind == KidsArabicAchievementKind.milestone,
        )
        .toList(growable: false);
    return LearnHubPageScaffold(
      title: l10n.kidsArabicRewardsTitle,
      subtitle: l10n.kidsArabicRewardsSubtitle,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.palette.surfaceSoft),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryPill(
                label: l10n.kidsArabicLettersCompletedValue(
                  achievementSummary.lettersCompleted,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicWordsCompletedValue(
                  achievementSummary.wordsCompleted,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicBadgesUnlockedValue(
                  achievementSummary.badgesUnlocked,
                ),
              ),
              _SummaryPill(
                label: l10n.kidsArabicMilestonesUnlockedValue(
                  achievementSummary.milestonesUnlocked,
                ),
              ),
            ],
          ),
        ),
        if (latestAchievement != null) ...[
          const SizedBox(height: 12),
          _LatestAchievementCard(achievement: latestAchievement),
        ],
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicMilestonesSectionTitle,
          subtitle: l10n.kidsArabicMilestonesSectionSubtitle,
        ),
        const SizedBox(height: 10),
        ...milestoneStatuses.map(
          (status) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AchievementCard(status: status),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsArabicBadgesSectionTitle,
          subtitle: l10n.kidsArabicBadgesSectionSubtitle,
        ),
        const SizedBox(height: 10),
        ...badgeStatuses.map(
          (status) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AchievementCard(status: status),
          ),
        ),
      ],
    );
  }
}

class _LatestAchievementCard extends StatelessWidget {
  const _LatestAchievementCard({required this.achievement});

  final KidsArabicAchievementDefinition achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.success.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.palette.success.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: achievement.color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(achievement.icon, color: achievement.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsArabicLatestAchievementTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsArabicAchievementTitle(l10n, achievement),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.palette.successInk,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsArabicAchievementSubtitle(l10n, achievement),
                  style: TextStyle(
                    color: context.palette.successInk,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.status});

  final KidsArabicAchievementStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.unlocked
            ? context.palette.surface
            : const Color(0xFFF5F1EB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: status.unlocked
              ? status.definition.color.withValues(alpha: 0.45)
              : const Color(0xFFE4D8CC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: status.definition.color.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(status.definition.icon, color: status.definition.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedKidsArabicAchievementTitle(l10n, status.definition),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizedKidsArabicAchievementSubtitle(
                    l10n,
                    status.definition,
                  ),
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status.unlocked
                ? l10n.kidsArabicStickerEarned
                : l10n.kidsArabicStickerLocked,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: status.unlocked
                  ? context.palette.successInk
                  : context.palette.onSurfaceSubtle,
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
