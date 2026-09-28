import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/occasion_offer_provider.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../profile/application/profile_settings_provider.dart';

/// Invisible Home resident that watches for an arriving occasion and offers
/// its dress-up once, via a gentle bottom sheet. Each occasion is asked
/// about exactly once — accepting turns the dress-up on, declining (or
/// dismissing) just records the offer as seen.
class OccasionOfferCoordinator extends ConsumerStatefulWidget {
  const OccasionOfferCoordinator({super.key});

  @override
  ConsumerState<OccasionOfferCoordinator> createState() =>
      _OccasionOfferCoordinatorState();
}

class _OccasionOfferCoordinatorState
    extends ConsumerState<OccasionOfferCoordinator> {
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOffer());
  }

  void _maybeOffer() {
    if (!mounted || _sheetOpen) return;
    final kind = ref.read(pendingOccasionOfferProvider);
    if (kind == null) return;
    _sheetOpen = true;
    var accepted = false;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _OccasionOfferSheet(
        kind: kind,
        onAccept: () {
          accepted = true;
          Navigator.of(sheetContext).pop();
        },
      ),
    ).whenComplete(() {
      _sheetOpen = false;
      if (!mounted) return;
      final notifier = ref.read(profileSettingsProvider.notifier);
      notifier.markOccasionOfferSeen(kind.wireName);
      if (accepted) {
        switch (kind) {
          case OccasionOfferKind.qadrNights:
            notifier.setDressUpQadrNights(true);
          case OccasionOfferKind.eid:
            notifier.setDressUpEid(true);
          case OccasionOfferKind.ramadan:
            notifier.setDressUpRamadan(true);
          case OccasionOfferKind.jummah:
            notifier.setDressUpFridays(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OccasionOfferKind?>(pendingOccasionOfferProvider, (
      previous,
      next,
    ) {
      if (next != null) _maybeOffer();
    });
    return const SizedBox.shrink();
  }
}

class _OccasionOfferSheet extends StatelessWidget {
  const _OccasionOfferSheet({required this.kind, required this.onAccept});

  final OccasionOfferKind kind;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final surface =
        appearance?.surface ?? Theme.of(context).colorScheme.surface;
    final onSurface =
        appearance?.onSurface ?? Theme.of(context).colorScheme.onSurface;

    final (IconData icon, String title, String body) = switch (kind) {
      OccasionOfferKind.qadrNights => (
        Icons.auto_awesome_rounded,
        l10n.occasionOfferQadrTitle,
        l10n.occasionOfferQadrBody,
      ),
      OccasionOfferKind.eid => (
        Icons.celebration_rounded,
        l10n.occasionOfferEidTitle,
        l10n.occasionOfferEidBody,
      ),
      OccasionOfferKind.ramadan => (
        IslamicIcons.lantern,
        l10n.occasionOfferRamadanTitle,
        l10n.occasionOfferRamadanBody,
      ),
      OccasionOfferKind.jummah => (
        // The font's `mosque` codepoint draws a person; this one is the
        // domed building.
        IslamicIcons.locationMosque,
        l10n.occasionOfferJummahTitle,
        l10n.occasionOfferJummahBody,
      ),
    };

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: (appearance?.border ?? onSurface).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 34, color: appearance?.accent),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: appearance?.onSurfaceSubtle ?? onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('occasion-offer-accept'),
                onPressed: onAccept,
                style: FilledButton.styleFrom(
                  backgroundColor: appearance?.accent,
                  foregroundColor: appearance?.isDark == true
                      ? appearance?.background
                      : null,
                ),
                child: Text(l10n.occasionOfferAccept),
              ),
            ),
            TextButton(
              key: const ValueKey('occasion-offer-decline'),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.occasionOfferDecline,
                style: TextStyle(color: appearance?.onSurfaceSubtle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
