import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../section_title.dart';

/// One titled group of destination rows on a hub page — the "one list, one
/// search" pattern: every destination appears exactly once, as a compact row
/// under a gold section header.
class HubListGroup extends StatelessWidget {
  const HubListGroup({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title: title),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1)
            const SizedBox(height: AppSpacing.xxs + 2),
        ],
      ],
    );
  }
}

/// Standard leading icon chip for hub list rows.
class HubLeadingIcon extends StatelessWidget {
  const HubLeadingIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: accent.withValues(alpha: 0.10),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Icon(icon, size: 19, color: accent),
    );
  }
}

/// Small accent badge for rows that are newly surfaced (e.g. "New").
class HubNewBadge extends StatelessWidget {
  const HubNewBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs + 1,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: accent.withValues(alpha: 0.14),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}
