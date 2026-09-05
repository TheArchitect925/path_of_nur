import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../core/theme/app_theme.dart';

/// The counter's action pill. Emphasised pills fill with the accent and pick
/// a foreground that reads on it in every theme (dark on the gold of the
/// night family, the surface tone on a dark accent).
class DhikrPillButton extends StatelessWidget {
  const DhikrPillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.emphasized = false,
    this.expand = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool emphasized;
  final bool expand;
  final bool enabled;

  static Color foregroundOnAccent(BuildContext context) {
    final palette = context.palette;
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final accentIsLight =
        ThemeData.estimateBrightnessForColor(palette.accent) ==
        Brightness.light;
    if (!accentIsLight) return palette.surface;
    return appearance?.isNightFamily == true
        ? palette.background
        : palette.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: palette.accent,
    );
    final foreground = emphasized
        ? foregroundOnAccent(context)
        : palette.onSurface;
    final decoration = emphasized
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            color: AppSurfaceTheme.adaptiveColor(
              context,
              palette.accent,
              alpha: 0.94,
              solidAlphaWhenDisabled: 1,
            ),
          )
        : style
              .decoration(radius: AppRadii.pill, includeShadow: false)
              .copyWith(
                border: Border.all(
                  color: AppSurfaceTheme.adaptiveColor(
                    context,
                    palette.accentSoft,
                    alpha: 0.5,
                    solidAlphaWhenDisabled: 0.6,
                  ),
                ),
              );

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: decoration,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small round glass button for page-corner controls (back, more).
class DhikrRoundButton extends StatelessWidget {
  const DhikrRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: palette.accent,
    );
    return Tooltip(
      message: tooltip,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 44,
            height: 44,
            decoration: style.decoration(radius: 22, includeShadow: false),
            child: Icon(icon, size: 20, color: palette.onSurface),
          ),
        ),
      ),
    );
  }
}
