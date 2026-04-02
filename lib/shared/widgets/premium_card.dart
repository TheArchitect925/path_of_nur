import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_surfaces.dart';
import '../../features/profile/application/profile_settings_provider.dart';

class PremiumCard extends ConsumerStatefulWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.surfaceAlphaOverride,
    this.surfaceTintColor,
    this.surfaceVariant = AppSurfaceVariant.card,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.includeShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? surfaceAlphaOverride;
  final Color? surfaceTintColor;
  final AppSurfaceVariant surfaceVariant;
  final AppSurfaceTreatment surfaceTreatment;
  final bool includeShadow;

  @override
  ConsumerState<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends ConsumerState<PremiumCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final theme = Theme.of(context);
    final contentColors = AppSurfaceTheme.contentColors(
      context,
      treatment: widget.surfaceTreatment,
    );
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: widget.surfaceVariant,
      treatment: widget.surfaceTreatment,
      tintColor: widget.surfaceTintColor,
      surfaceAlphaOverride: widget.surfaceAlphaOverride,
    );
    final surfaceTextTheme = contentColors.applyTo(theme.textTheme);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: reduceMotion ? 1 : (_pressed ? 0.992 : 1),
        duration: Duration(milliseconds: reduceMotion ? 0 : 140),
        curve: Curves.easeOutCubic,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: double.infinity,
            padding: widget.padding,
            decoration: surfaceStyle.decoration(
              radius: AppRadii.card,
              includeShadow: widget.includeShadow,
            ),
            child: Theme(
              data: theme.copyWith(
                textTheme: surfaceTextTheme,
                iconTheme: theme.iconTheme.copyWith(
                  color: contentColors.iconColor,
                ),
                listTileTheme: theme.listTileTheme.copyWith(
                  iconColor: contentColors.iconColor,
                  textColor: contentColors.foreground,
                ),
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: contentColors.iconColor),
                child: DefaultTextStyle.merge(
                  style:
                      surfaceTextTheme.bodyMedium ??
                      TextStyle(color: contentColors.subtleForeground),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
