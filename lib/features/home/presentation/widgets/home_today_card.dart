import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../learn/quran/application/quran_personalization_provider.dart';
import '../../../learn/quran/application/quran_spiritual_moment_provider.dart';
import '../../../learn/quran/domain/quran_personalization_models.dart';
import '../../../learn/quran/domain/quran_spiritual_moment_models.dart';
import '../../../learn/quran/presentation/widgets/quran_daily_reflection_card.dart';
import '../../../../core/theme/app_icons.dart';

/// The one "Today" unit on the Mihrab Home. The daily reflection is the
/// primary content; the personalized recommendation and spiritual moment —
/// previously two more full-height cards — fold into a compact follow-up
/// chip row underneath it.
class HomeTodayCard extends ConsumerWidget {
  const HomeTodayCard({
    super.key,
    required this.quranBundle,
    required this.spiritualMoment,
    this.showSectionTitle = true,
  });

  final QuranRecommendationBundle? quranBundle;
  final QuranSpiritualMomentBundle? spiritualMoment;

  /// False when an enclosing tile already renders the "Today" header, so the
  /// title is not printed twice.
  final bool showSectionTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSectionTitle) SectionTitle(title: l10n.homeTodayContentTitle),
        const QuranDailyReflectionCard(
          compact: true,
          showCompanionAction: true,
          showSecondaryActions: false,
        ),
        if (quranBundle != null || spiritualMoment != null) ...[
          const SizedBox(height: AppSpacing.xs + 2),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (quranBundle != null)
                _TodayFollowUpChip(
                  icon: Icons.auto_stories_rounded,
                  label: l10n.homeTodayForYouChip(
                    quranBundle!.primary.ref.locationLabel,
                  ),
                  onTap: () => openQuranReferenceLocation(
                    context,
                    ref: quranBundle!.primary.ref,
                  ),
                  onDismiss: () {
                    ref
                        .read(quranPersonalizationStateProvider.notifier)
                        .dismissForToday(
                          surface: quranBundle!.surface,
                          ayahKey: quranBundle!.primary.ayahKey,
                        );
                  },
                ),
              if (spiritualMoment != null)
                _TodayFollowUpChip(
                  icon: AppIcons.reflection,
                  label: l10n.homeTodayMomentChip(
                    spiritualMoment!.primary.ref.locationLabel,
                  ),
                  onTap: () => openQuranReferenceLocation(
                    context,
                    ref: spiritualMoment!.primary.ref,
                  ),
                  onDismiss: () {
                    ref
                        .read(quranSpiritualMomentStateProvider.notifier)
                        .dismissForToday(
                          surface: spiritualMoment!.surface,
                          ayahKey: spiritualMoment!.primary.ayahKey,
                        );
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TodayFollowUpChip extends StatelessWidget {
  const _TodayFollowUpChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.onDismiss,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: NoorGlassCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s,
          AppSpacing.xs,
          AppSpacing.xxs,
          AppSpacing.xs,
        ),
        surfaceVariant: AppSurfaceVariant.pill,
        includeShadow: false,
        borderRadius: 14,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: AppSpacing.xxs + 2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 15,
                tooltip: l10n.quranPersonalizationDismissAction,
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
