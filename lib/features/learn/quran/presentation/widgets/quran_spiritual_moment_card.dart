import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_ayah_action_provider.dart';
import '../../application/quran_spiritual_moment_provider.dart';
import '../../domain/quran_spiritual_moment_models.dart';
import '../../../../../core/theme/app_palette.dart';

class QuranSpiritualMomentCard extends ConsumerStatefulWidget {
  const QuranSpiritualMomentCard({
    super.key,
    required this.bundle,
    required this.surface,
    this.allowDismiss = false,
    this.useHeroGlassShell = false,
  });

  final QuranSpiritualMomentBundle bundle;
  final QuranSpiritualMomentSurface surface;
  final bool allowDismiss;
  final bool useHeroGlassShell;

  @override
  ConsumerState<QuranSpiritualMomentCard> createState() =>
      _QuranSpiritualMomentCardState();
}

class _QuranSpiritualMomentCardState
    extends ConsumerState<QuranSpiritualMomentCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quranSpiritualMomentStateProvider.notifier)
          .recordPresentationIfNeeded(
            surface: widget.surface,
            ayahKey: widget.bundle.primary.ayahKey,
          );
    });
  }

  @override
  void didUpdateWidget(covariant QuranSpiritualMomentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bundle.primary.ayahKey == widget.bundle.primary.ayahKey &&
        oldWidget.surface == widget.surface) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quranSpiritualMomentStateProvider.notifier)
          .recordPresentationIfNeeded(
            surface: widget.surface,
            ayahKey: widget.bundle.primary.ayahKey,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recommendation = widget.bundle.primary;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleForSurface(
                      l10n,
                      widget.surface,
                      widget.bundle.preferKids,
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _reasonLabel(l10n, recommendation.reasonCode),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7A6241),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.allowDismiss)
              IconButton(
                tooltip: l10n.quranPersonalizationDismissAction,
                onPressed: () {
                  ref
                      .read(quranSpiritualMomentStateProvider.notifier)
                      .dismissForToday(
                        surface: widget.surface,
                        ayahKey: recommendation.ayahKey,
                      );
                },
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          recommendation.ref.locationLabel,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          recommendation.explanation.previewText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 10),
        Text(
          widget.bundle.preferKids
              ? l10n.kidsQuranAyahActionTitle
              : l10n.quranAyahActionTitle,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          recommendation.actionRecommendation.action.localizedActionText(
            Localizations.localeOf(context).languageCode,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SpiritualMomentActionButton(
              onPressed: () =>
                  openQuranReferenceLocation(context, ref: recommendation.ref),
              icon: Icons.auto_stories_rounded,
              label: l10n.quranPersonalizationOpenAyahAction,
            ),
            recommendation.actionRecommendation.isCompletedToday
                ? _SpiritualMomentActionButton(
                    onPressed: null,
                    icon: Icons.check_circle_rounded,
                    label: l10n.quranAyahActionCompletedAction,
                  )
                : _SpiritualMomentActionButton(
                    onPressed: () {
                      ref
                          .read(quranAyahActionStateProvider.notifier)
                          .completeAction(
                            recommendation.actionRecommendation.action,
                          );
                    },
                    icon: Icons.done_rounded,
                    label: l10n.quranAyahActionCompleteAction,
                  ),
          ],
        ),
      ],
    );
    if (widget.useHeroGlassShell) {
      return AppHeroGlassShell(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        tintColor: context.palette.accent,
        surfaceAlphaOverride: 0.2,
        radius: 36,
        borderColor: const Color(0x42FFFFFF),
        highlightGradientColors: const [
          Color(0x24FFFFFF),
          Colors.transparent,
          Color(0x16E8C98F),
        ],
        child: content,
      );
    }
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      surfaceVariant: AppSurfaceVariant.panel,
      child: content,
    );
  }
}

String _titleForSurface(
  AppLocalizations l10n,
  QuranSpiritualMomentSurface surface,
  bool preferKids,
) {
  if (preferKids || surface == QuranSpiritualMomentSurface.kidsReader) {
    return l10n.quranSpiritualMomentKidsTitle;
  }
  return switch (surface) {
    QuranSpiritualMomentSurface.home => l10n.quranSpiritualMomentHomeTitle,
    QuranSpiritualMomentSurface.quranHub => l10n.quranSpiritualMomentHubTitle,
    QuranSpiritualMomentSurface.prayer => l10n.quranSpiritualMomentPrayerTitle,
    QuranSpiritualMomentSurface.reader => l10n.quranSpiritualMomentReaderTitle,
    QuranSpiritualMomentSurface.kidsReader =>
      l10n.quranSpiritualMomentKidsTitle,
  };
}

String _reasonLabel(
  AppLocalizations l10n,
  QuranSpiritualMomentReasonCode reason,
) {
  return switch (reason) {
    QuranSpiritualMomentReasonCode.morningCalm =>
      l10n.quranSpiritualMomentReasonMorning,
    QuranSpiritualMomentReasonCode.afterPrayer =>
      l10n.quranSpiritualMomentReasonPostPrayer,
    QuranSpiritualMomentReasonCode.middayPause =>
      l10n.quranSpiritualMomentReasonDhuhr,
    QuranSpiritualMomentReasonCode.afternoonReset =>
      l10n.quranSpiritualMomentReasonAsr,
    QuranSpiritualMomentReasonCode.sunsetGratitude =>
      l10n.quranSpiritualMomentReasonMaghrib,
    QuranSpiritualMomentReasonCode.eveningCalm =>
      l10n.quranSpiritualMomentReasonIsha,
    QuranSpiritualMomentReasonCode.quietNight =>
      l10n.quranSpiritualMomentReasonNight,
    QuranSpiritualMomentReasonCode.fridayReflection =>
      l10n.quranSpiritualMomentReasonFriday,
    QuranSpiritualMomentReasonCode.ramadanReflection =>
      l10n.quranSpiritualMomentReasonRamadan,
    QuranSpiritualMomentReasonCode.kidsMoment =>
      l10n.quranSpiritualMomentReasonKids,
  };
}

class _SpiritualMomentActionButton extends StatelessWidget {
  const _SpiritualMomentActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
