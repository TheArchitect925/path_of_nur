import 'package:flutter/material.dart';

import 'app_layered_glass_pill_button.dart';

class AppShortcutPill extends StatelessWidget {
  const AppShortcutPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.trailingText,
    this.tintColor,
    this.foregroundColor,
    this.fillColor,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final String? trailingText;
  final Color? tintColor;
  final Color? foregroundColor;
  final Color? fillColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final resolvedForeground =
        foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    return AppLayeredGlassPillButton(
      label: label,
      onPressed: onPressed,
      tintColor: tintColor,
      foregroundColor: resolvedForeground,
      fillColor: fillColor,
      borderColor: borderColor,
      expandToWidth: false,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      leading: Icon(icon, size: 18, color: resolvedForeground),
      trailing: trailingText == null
          ? null
          : Text(
              trailingText!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: resolvedForeground.withValues(alpha: 0.86),
              ),
            ),
    );
  }
}
