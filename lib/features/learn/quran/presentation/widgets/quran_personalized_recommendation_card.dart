import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../application/quran_ayah_action_provider.dart';
import '../../application/quran_guided_learning_paths_provider.dart';
import '../../application/quran_personalization_provider.dart';
import '../../domain/quran_personalization_models.dart';
import '../quran_learning_path_copy.dart';

class QuranPersonalizedRecommendationCard extends ConsumerStatefulWidget {
  const QuranPersonalizedRecommendationCard({
    super.key,
    required this.bundle,
    required this.surface,
    this.allowDismiss = false,
    this.useHeroGlassShell = false,
  });

  final QuranRecommendationBundle bundle;
  final QuranPersonalizationSurface surface;
  final bool allowDismiss;
  final bool useHeroGlassShell;

  @override
  ConsumerState<QuranPersonalizedRecommendationCard> createState() =>
      _QuranPersonalizedRecommendationCardState();
}

class _QuranPersonalizedRecommendationCardState
    extends ConsumerState<QuranPersonalizedRecommendationCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quranPersonalizationStateProvider.notifier)
          .recordPresentationIfNeeded(
            surface: widget.surface,
            ayahKey: widget.bundle.primary.ayahKey,
          );
    });
  }

  @override
  void didUpdateWidget(
    covariant QuranPersonalizedRecommendationCard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bundle.primary.ayahKey == widget.bundle.primary.ayahKey &&
        oldWidget.surface == widget.surface) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(quranPersonalizationStateProvider.notifier)
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
    final suggestedJourney = recommendation.suggestedJourney;
    final suggestedPath = suggestedJourney == null
        ? null
        : ref.watch(
            quranGuidedLearningPathByIdProvider(suggestedJourney.pathId),
          );

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
                    _reasonLabel(
                      l10n,
                      recommendation.reasonCode,
                      preferKids: widget.bundle.preferKids,
                    ),
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
                      .read(quranPersonalizationStateProvider.notifier)
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
          recommendation.explanationPreview,
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
          recommendation.actionRecommendation.action.actionText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (suggestedPath != null) ...[
          const SizedBox(height: 10),
          Text(
            l10n.quranPersonalizationPathHintTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            localizedQuranLearningPathTitle(l10n, suggestedPath.id),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _RecommendationActionButton(
              onPressed: () =>
                  openQuranReferenceLocation(context, ref: recommendation.ref),
              icon: Icons.auto_stories_rounded,
              label: l10n.quranPersonalizationOpenAyahAction,
            ),
            recommendation.actionRecommendation.isCompletedToday
                ? _RecommendationActionButton(
                    onPressed: null,
                    icon: Icons.check_circle_rounded,
                    label: l10n.quranAyahActionCompletedAction,
                  )
                : _RecommendationActionButton(
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
            if (suggestedPath != null && suggestedJourney != null)
              _RecommendationActionButton(
                onPressed: () => context.pushNamed(
                  suggestedJourney.routeName,
                  pathParameters: suggestedJourney.pathParameters,
                ),
                icon: Icons.route_rounded,
                label: l10n.quranPersonalizationOpenPathAction,
              ),
          ],
        ),
      ],
    );
    if (widget.useHeroGlassShell) {
      return AppHeroGlassShell(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        tintColor: const Color(0xFFE7C98C),
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
  QuranPersonalizationSurface surface,
  bool preferKids,
) {
  if (preferKids || surface == QuranPersonalizationSurface.kidsReader) {
    return l10n.quranPersonalizationKidsTitle;
  }
  return switch (surface) {
    QuranPersonalizationSurface.home => l10n.quranPersonalizationHomeTitle,
    QuranPersonalizationSurface.quranHub => l10n.quranPersonalizationHubTitle,
    QuranPersonalizationSurface.reader => l10n.quranPersonalizationReaderTitle,
    QuranPersonalizationSurface.growth => l10n.quranPersonalizationGrowthTitle,
    QuranPersonalizationSurface.kidsReader =>
      l10n.quranPersonalizationKidsTitle,
  };
}

class _RecommendationActionButton extends StatelessWidget {
  const _RecommendationActionButton({
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

String _reasonLabel(
  AppLocalizations l10n,
  QuranRecommendationReasonCode reason, {
  required bool preferKids,
}) {
  if (preferKids) {
    return switch (reason) {
      QuranRecommendationReasonCode.continueReading =>
        l10n.quranPersonalizationKidsReasonContinue,
      QuranRecommendationReasonCode.beginnerFriendly ||
      QuranRecommendationReasonCode.kidsFriendly =>
        l10n.quranPersonalizationKidsReasonEasy,
      _ => l10n.quranPersonalizationKidsReasonToday,
    };
  }

  return switch (reason) {
    QuranRecommendationReasonCode.continueReading =>
      l10n.quranPersonalizationReasonContinueReading,
    QuranRecommendationReasonCode.recentReflection =>
      l10n.quranPersonalizationReasonRecentReflection,
    QuranRecommendationReasonCode.dailyAnchor =>
      l10n.quranPersonalizationReasonDailyAnchor,
    QuranRecommendationReasonCode.guidedPathFocus =>
      l10n.quranPersonalizationReasonGuidedPathFocus,
    QuranRecommendationReasonCode.prayerSupport =>
      l10n.quranPersonalizationReasonPrayerSupport,
    QuranRecommendationReasonCode.remembranceRhythm =>
      l10n.quranPersonalizationReasonRemembranceRhythm,
    QuranRecommendationReasonCode.memorizationReview =>
      l10n.quranPersonalizationReasonMemorizationReview,
    QuranRecommendationReasonCode.beginnerFriendly =>
      l10n.quranPersonalizationReasonBeginnerFriendly,
    QuranRecommendationReasonCode.kidsFriendly =>
      l10n.quranPersonalizationReasonKidsFriendly,
    QuranRecommendationReasonCode.keepMomentum =>
      l10n.quranPersonalizationReasonKeepMomentum,
    QuranRecommendationReasonCode.gentleForToday =>
      l10n.quranPersonalizationReasonGentleForToday,
    QuranRecommendationReasonCode.growthFocus =>
      l10n.quranPersonalizationReasonGrowthFocus,
  };
}
