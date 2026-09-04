import 'package:flutter/material.dart';

import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/theme/islamic_icons.dart';

class ProfileComingSoonPage extends StatelessWidget {
  const ProfileComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      title: l10n.settingsComingSoonTitle,
      subtitle: l10n.settingsComingSoonSubtitle,
      children: [
        SectionTitle(
          title: l10n.profileComingSoonRoadmapTitle,
          subtitle: l10n.profileComingSoonRoadmapSubtitle,
        ),
        _ComingSoonCard(
          icon: IslamicIcons.quran,
          title: l10n.profileComingSoonCard1Title,
          description: l10n.profileComingSoonCard1Description,
        ),
        const SizedBox(height: 14),
        _ComingSoonCard(
          icon: Icons.quiz_rounded,
          title: l10n.profileComingSoonCard2Title,
          description: l10n.profileComingSoonCard2Description,
        ),
        const SizedBox(height: 14),
        _ComingSoonCard(
          icon: IslamicIcons.prayer,
          title: l10n.profileComingSoonCard3Title,
          description: l10n.profileComingSoonCard3Description,
        ),
        const SizedBox(height: 14),
        _ComingSoonCard(
          icon: Icons.auto_awesome_rounded,
          title: l10n.profileComingSoonCard4Title,
          description: l10n.profileComingSoonCard4Description,
        ),
      ],
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSurface = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
    );
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: iconSurface.decoration(
              radius: 14,
              includeShadow: false,
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
