import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/fasting_controller.dart';
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
                l10n.fastingStatusValue(
                  fasting.todayStatus.label,
                  fasting.todayStatus.label,
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.fastingTypeValue(
                  fasting.selectedType.label,
                  fasting.selectedType.label,
                ),
                style: const TextStyle(color: AppColors.onSurfaceSubtle),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _statusProgress(fasting.todayStatus),
                backgroundColor: AppColors.surfaceSoft,
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
              return InkWell(
                onTap: () => notifier.setType(type),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    color: isSelected
                        ? AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.accentGold,
                            alpha: 0.18,
                            solidAlphaWhenDisabled: 0.28,
                          )
                        : AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.surface,
                            alpha: 0.4,
                            solidAlphaWhenDisabled: 0.96,
                          ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentGold
                          : AppSurfaceTheme.adaptiveColor(
                              context,
                              AppColors.accentGoldSoft,
                              alpha: 0.45,
                              solidAlphaWhenDisabled: 0.55,
                            ),
                    ),
                  ),
                  child: Text(
                    type.label,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
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
              return InkWell(
                onTap: () => notifier.setStatus(status),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    color: selected
                        ? AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.accentGold,
                            alpha: 0.2,
                            solidAlphaWhenDisabled: 0.30,
                          )
                        : AppSurfaceTheme.adaptiveColor(
                            context,
                            AppColors.surfaceSoft,
                            alpha: 0.45,
                            solidAlphaWhenDisabled: 0.96,
                          ),
                    border: Border.all(
                      color: selected
                          ? AppColors.accentGold
                          : AppSurfaceTheme.adaptiveColor(
                              context,
                              AppColors.accentGoldSoft,
                              alpha: 0.45,
                              solidAlphaWhenDisabled: 0.55,
                            ),
                    ),
                  ),
                  child: Text(
                    status.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
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
                    backgroundColor: AppColors.success,
                    child: const Icon(
                      Icons.spa_outlined,
                      size: 18,
                      color: AppColors.onSurface,
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
                            entry.dateLabel,
                          ),
                          style: const TextStyle(
                            color: AppColors.onSurfaceSubtle,
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
                  color: AppColors.onSurfaceSubtle,
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
