import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../learn_ui_localization.dart';
import '../data/learn_icon_registry.dart';
import '../models/learn_category_item.dart';

class LearnCategoryCard extends StatefulWidget {
  const LearnCategoryCard({
    super.key,
    required this.item,
    required this.height,
    required this.onTap,
  });

  final LearnCategoryItem item;
  final double height;
  final VoidCallback onTap;

  @override
  State<LearnCategoryCard> createState() => _LearnCategoryCardState();
}

class _LearnCategoryCardState extends State<LearnCategoryCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? AppColors.accentGold;
    final onSurface = appearance?.onSurface ?? const Color(0xFF3D3025);
    final onSurfaceSubtle =
        appearance?.onSurfaceSubtle ?? const Color(0xFF6A563F);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.island,
    );
    final featureStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.featureTile,
      tintColor: accent.withValues(alpha: 0.92),
    );
    final badgeStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: accent,
    );

    final icon = LearnIconRegistry.iconFor(widget.item.iconKey);
    final iconAsset = LearnIconRegistry.assetFor(widget.item.iconKey);
    final isQuranCard = widget.item.iconKey == 'quran';

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        height: widget.height,
        decoration: surfaceStyle.decoration(
          radius: AppRadii.card,
          includeShadow: true,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.card),
            onTap: widget.onTap,
            onHighlightChanged: _setPressed,
            splashColor: surfaceStyle.splashColor,
            highlightColor: surfaceStyle.highlightColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: featureStyle.decoration(
                        radius: 16,
                        includeShadow: false,
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: 7,
                                  left: 10,
                                  child: _dustDot(0.12, 2.2),
                                ),
                                Positioned(
                                  top: 13,
                                  right: 14,
                                  child: _dustDot(0.18, 2.8),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 18,
                                  child: _dustDot(0.10, 2.4),
                                ),
                                if (isQuranCard)
                                  Text(
                                    'الْقُرْآن',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.quranVerse(
                                      size: 30,
                                      color: const Color(0xFF4B3C2E),
                                    ).copyWith(height: 1.6),
                                  )
                                else if (iconAsset != null)
                                  Image.asset(
                                    iconAsset,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        icon,
                                        size: 46,
                                        color: onSurfaceSubtle,
                                      );
                                    },
                                  )
                                else
                                  Icon(icon, size: 46, color: onSurfaceSubtle),
                              ],
                            ),
                          ),
                          if (widget.item.localizedBadgeLabel(l10n) != null)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: badgeStyle.decoration(
                                  radius: 999,
                                  includeShadow: false,
                                ),
                                child: Text(
                                  widget.item.localizedBadgeLabel(l10n)!,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.localizedTitle(l10n),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: onSurface,
                      fontFamily: 'serif',
                      fontSize: 15.4,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dustDot(double alpha, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentGold.withValues(alpha: alpha),
      ),
    );
  }
}
