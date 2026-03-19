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
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? surfaceAlphaOverride;
  final Color? surfaceTintColor;
  final AppSurfaceVariant surfaceVariant;

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
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: widget.surfaceVariant,
      tintColor: widget.surfaceTintColor,
      surfaceAlphaOverride: widget.surfaceAlphaOverride,
    );

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: reduceMotion ? 1 : (_pressed ? 0.992 : 1),
        duration: Duration(milliseconds: reduceMotion ? 0 : 140),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: widget.padding,
          decoration: surfaceStyle.decoration(radius: AppRadii.card),
          child: widget.child,
        ),
      ),
    );
  }
}
