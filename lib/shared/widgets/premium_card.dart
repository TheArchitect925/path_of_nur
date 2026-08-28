import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_surfaces.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import 'app_layered_section_glass_card.dart';

/// Visual density of a [PremiumCard]. Density chooses the corner radius and
/// the default content padding so lists can mix hero cards with scannable
/// rows without hand-tuning either.
enum PremiumCardDensity {
  /// The classic full-size glass card (36px radius, generous padding).
  comfortable,

  /// Mid-size card for grouped content and secondary sections.
  compact,

  /// Row-height tile for dense collections (surah lists, duas, hadith).
  tile,
}

class PremiumCard extends ConsumerStatefulWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.density = PremiumCardDensity.comfortable,
    this.onTap,
    this.leading,
    this.title,
    this.trailing,
    this.surfaceAlphaOverride,
    this.surfaceTintColor,
    this.surfaceVariant = AppSurfaceVariant.card,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.includeShadow = true,
  });

  final Widget child;

  /// Explicit padding wins; otherwise the density default applies.
  final EdgeInsetsGeometry? padding;
  final PremiumCardDensity density;

  /// Makes the whole card tappable, keeping the existing press-scale
  /// affordance as feedback.
  final VoidCallback? onTap;

  /// Optional header row rendered above [child]. The header only appears when
  /// at least one of [leading], [title], [trailing] is set.
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

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

  double get _radius {
    switch (widget.density) {
      case PremiumCardDensity.comfortable:
        return AppRadii.glassCard;
      case PremiumCardDensity.compact:
        return AppRadii.glassCompact;
      case PremiumCardDensity.tile:
        return AppRadii.glassTile;
    }
  }

  EdgeInsetsGeometry get _padding {
    final explicit = widget.padding;
    if (explicit != null) return explicit;
    switch (widget.density) {
      case PremiumCardDensity.comfortable:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 30);
      case PremiumCardDensity.compact:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 16);
      case PremiumCardDensity.tile:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
    }
  }

  bool get _hasHeader =>
      widget.leading != null || widget.title != null || widget.trailing != null;

  Widget _buildContent(TextTheme surfaceTextTheme) {
    if (!_hasHeader) return widget.child;
    final title = widget.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: AppSpacing.s),
            ],
            if (title != null)
              Expanded(
                child: DefaultTextStyle.merge(
                  style: surfaceTextTheme.titleSmall,
                  child: title,
                ),
              )
            else
              const Spacer(),
            if (widget.trailing != null) ...[
              const SizedBox(width: AppSpacing.s),
              widget.trailing!,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        widget.child,
      ],
    );
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
    final surfaceTextTheme = contentColors.applyTo(theme.textTheme);

    Widget card = Material(
      type: MaterialType.transparency,
      child: AppLayeredSectionGlassCard(
        width: double.infinity,
        contentPadding: _padding,
        outerRadius: _radius,
        innerRadius: _radius,
        surfaceVariant: widget.surfaceVariant,
        surfaceTreatment: widget.surfaceTreatment,
        surfaceTintColor: widget.surfaceTintColor,
        surfaceAlphaOverride: widget.surfaceAlphaOverride,
        includeShadow: widget.includeShadow,
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
              child: _buildContent(surfaceTextTheme),
            ),
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      card = Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: card,
        ),
      );
    }

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: reduceMotion ? 1 : (_pressed ? 0.992 : 1),
        duration: Duration(milliseconds: reduceMotion ? 0 : 140),
        curve: Curves.easeOutCubic,
        child: card,
      ),
    );
  }
}
