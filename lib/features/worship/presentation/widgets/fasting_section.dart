import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../application/fasting_controller.dart';
import '../../application/fasting_insights_provider.dart';
import '../../domain/fasting_status.dart';
import '../../domain/fasting_type.dart';

class FastingSection extends ConsumerWidget {
  const FastingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fasting = ref.watch(fastingControllerProvider);
    final notifier = ref.read(fastingControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.fastingSectionTitle,
          subtitle: l10n.fastingSectionSubtitle,
        ),
        const _FastingRhythmCard(),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fastingTodayTitle,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.fastingStatusValue(fasting.todayStatus.label),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.fastingTypeValue(fasting.selectedType.label),
                style: TextStyle(color: context.palette.onSurfaceSubtle),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _statusProgress(fasting.todayStatus),
                backgroundColor: context.palette.surfaceSoft,
                minHeight: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.fastingFastTypeTitle,
          subtitle: l10n.fastingFastTypeSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...FastingType.values.map((type) {
              final isSelected = fasting.selectedType == type;
              return _FastingChoicePill(
                label: type.label,
                isSelected: isSelected,
                onTap: () => notifier.setType(type),
              );
            }),
          ],
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.fastingTodayStatusTitle,
          subtitle: l10n.fastingTodayStatusSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...FastingStatus.values.map((status) {
              final selected = fasting.todayStatus == status;
              return _FastingChoicePill(
                label: status.label,
                isSelected: selected,
                onTap: () => notifier.setStatus(status),
              );
            }),
          ],
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.fastingRecentHistoryTitle,
          subtitle: l10n.fastingRecentHistorySubtitle,
        ),
        ...fasting.history.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PremiumCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: context.palette.success,
                    child: Icon(
                      Icons.spa_outlined,
                      size: 18,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.dateLabel,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.fastingHistoryEntry(
                            entry.type.label,
                            entry.status.label,
                          ),
                          style: TextStyle(
                            color: context.palette.onSurfaceSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.fastingGentleReminderTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                l10n.fastingGentleReminderBody,
                style: TextStyle(
                  color: context.palette.onSurfaceSubtle,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _statusProgress(FastingStatus status) {
    switch (status) {
      case FastingStatus.notFasting:
        return 0.18;
      case FastingStatus.intending:
        return 0.45;
      case FastingStatus.completed:
        return 1.0;
      case FastingStatus.broken:
        return 0.25;
    }
  }
}

class _FastingChoicePill extends StatelessWidget {
  const _FastingChoicePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: context.palette.accent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: style
            .decoration(radius: AppRadii.pill, includeShadow: false)
            .copyWith(
              color: isSelected
                  ? AppSurfaceTheme.adaptiveColor(
                      context,
                      context.palette.accent,
                      alpha: 0.18,
                      solidAlphaWhenDisabled: 0.28,
                    )
                  : style.backgroundColor,
              gradient: isSelected ? null : style.gradient,
              border: Border.all(
                color: isSelected
                    ? context.palette.accent
                    : AppSurfaceTheme.adaptiveColor(
                        context,
                        context.palette.accentSoft,
                        alpha: 0.45,
                        solidAlphaWhenDisabled: 0.55,
                      ),
              ),
            ),
        child: Text(
          label,
          style: TextStyle(
            color: context.palette.onSurface,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Sunnah-aware rhythm: today's suggestion, suhoor/iftar times from the
/// prayer schedule, and simple momentum numbers (calm, not gamified).
class _FastingRhythmCard extends ConsumerWidget {
  const _FastingRhythmCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final suggestion = ref.watch(fastingSuggestionProvider);
    final insights = ref.watch(fastingInsightsProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final fajr = scheduleContext.items
        .where((item) => item.id == 'fajr')
        .firstOrNull;
    final maghrib = scheduleContext.items
        .where((item) => item.id == 'maghrib')
        .firstOrNull;

    final rows = <Widget>[];
    if (suggestion != null) {
      rows.add(
        Row(
          children: [
            Icon(
              Icons.tips_and_updates_outlined,
              size: 18,
              color: context.palette.accentSoft,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                suggestion.label(l10n),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }
    if (fajr != null || maghrib != null) {
      rows.add(
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            if (fajr != null)
              Text(
                l10n.fastingSuhoorEndsAt(fajr.offerTime),
                style: const TextStyle(fontSize: 13),
              ),
            if (maghrib != null)
              Text(
                l10n.fastingIftarAt(maghrib.offerTime),
                style: const TextStyle(fontSize: 13),
              ),
          ],
        ),
      );
    }
    if (insights.completedThisMonth > 0 || insights.streakDays > 0) {
      rows.add(
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            if (insights.completedThisMonth > 0)
              Text(
                l10n.fastingCompletedThisMonth(insights.completedThisMonth),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (insights.streakDays > 1)
              Text(
                l10n.fastingStreakDays(insights.streakDays),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
