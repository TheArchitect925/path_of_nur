import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class LearnSectionHeader extends StatelessWidget {
  const LearnSectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ??
        Theme.of(context).colorScheme.onSurface;
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
          ),
        ],
      ],
    );
  }
}
