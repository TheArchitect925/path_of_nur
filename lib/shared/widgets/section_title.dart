import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    // Night themes crown their section headers in gold, per the approved
    // app-wide mockups; other themes keep the standard foreground.
    final foreground = appearance?.isNightFamily == true
        ? appearance!.accent
        : appearance?.backgroundForeground ??
              Theme.of(context).colorScheme.onSurface;
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: foreground),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: subtleForeground),
            ),
          ],
        ],
      ),
    );
  }
}
