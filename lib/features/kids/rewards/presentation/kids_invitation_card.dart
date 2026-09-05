import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../../shared/widgets/premium_card.dart';

/// What a first-time child sees instead of a row of zeros: one thing to do,
/// with a picture and a big button.
class KidsInvitationCard extends StatelessWidget {
  const KidsInvitationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.imageAsset,
    this.fallbackIcon = AppIcons.fun,
    this.actionLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? imageAsset;
  final IconData fallbackIcon;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageAsset != null) ...[
            ArtHeaderCard(
              imageAsset: imageAsset!,
              title: title,
              fallbackIcon: fallbackIcon,
              fallbackColor: Theme.of(context).colorScheme.primary,
              aspectRatio: 16 / 9,
              onTap: onTap,
            ),
            const SizedBox(height: 14),
          ] else
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          if (imageAsset == null) const SizedBox(height: 6),
          Text(subtitle, style: textTheme.bodyLarge),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            child: Text(actionLabel ?? l10n.kidsInvitationStartAction),
          ),
        ],
      ),
    );
  }
}
