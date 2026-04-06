import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_surfaces.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import 'noor_liquid_glass.dart';

class NoorGlassCard extends ConsumerStatefulWidget {
  const NoorGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.surfaceVariant = AppSurfaceVariant.card,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.surfaceTintColor,
    this.surfaceAlphaOverride,
    this.includeShadow = true,
    this.mode = NoorLiquidGlassMode.liquid,
    this.borderRadius,
    this.width = double.infinity,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final AppSurfaceVariant surfaceVariant;
  final AppSurfaceTreatment surfaceTreatment;
  final Color? surfaceTintColor;
  final double? surfaceAlphaOverride;
  final bool includeShadow;
  final NoorLiquidGlassMode mode;
  final double? borderRadius;
  final double? width;

  @override
  ConsumerState<NoorGlassCard> createState() => _NoorGlassCardState();
}

class _NoorGlassCardState extends ConsumerState<NoorGlassCard> {
  NoorLiquidGlassSpec _spec() {
    final base = switch (widget.surfaceVariant) {
      AppSurfaceVariant.card => NoorLiquidGlassSpec.card(
        mode: widget.mode,
        padding: widget.padding,
        fallbackTreatment: widget.surfaceTreatment,
        tintColor: widget.surfaceTintColor,
        surfaceAlphaOverride: widget.surfaceAlphaOverride,
        includeShadow: widget.includeShadow,
      ),
      AppSurfaceVariant.panel => NoorLiquidGlassSpec.panel(
        mode: widget.mode,
        padding: widget.padding,
        fallbackTreatment: widget.surfaceTreatment,
        tintColor: widget.surfaceTintColor,
        surfaceAlphaOverride: widget.surfaceAlphaOverride,
        includeShadow: widget.includeShadow,
      ),
      AppSurfaceVariant.pill => NoorLiquidGlassSpec.pill(
        mode: widget.mode,
        padding: widget.padding,
        fallbackTreatment: widget.surfaceTreatment,
        tintColor: widget.surfaceTintColor,
        surfaceAlphaOverride: widget.surfaceAlphaOverride,
        includeShadow: widget.includeShadow,
      ),
      _ => NoorLiquidGlassSpec.card(
        mode: widget.mode,
        padding: widget.padding,
        fallbackTreatment: widget.surfaceTreatment,
        tintColor: widget.surfaceTintColor,
        surfaceAlphaOverride: widget.surfaceAlphaOverride,
        includeShadow: widget.includeShadow,
      ),
    };
    return widget.borderRadius == null
        ? base
        : base.copyWith(borderRadius: widget.borderRadius);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(profileSettingsProvider.select((value) => value.reduceMotion));
    final contentColors = AppSurfaceTheme.contentColors(
      context,
      treatment: widget.surfaceTreatment,
    );
    final theme = Theme.of(context);
    final surfaceTextTheme = contentColors.applyTo(theme.textTheme);
    return Listener(
      child: NoorLiquidGlassContainer(
        spec: _spec(),
        width: widget.width,
        child: Theme(
          data: theme.copyWith(
            textTheme: surfaceTextTheme,
            iconTheme: theme.iconTheme.copyWith(color: contentColors.iconColor),
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
    );
  }
}
