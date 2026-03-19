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
        decoration:
            BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.card),
            ).copyWith(
              color: surfaceStyle.backgroundColor,
              gradient: surfaceStyle.gradient,
              border: Border.all(color: surfaceStyle.borderColor, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: surfaceStyle.shadowColor,
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.35),
                          radius: 1.18,
                          colors: [
                            const Color(0xFFFFF8EE).withValues(alpha: 0.92),
                            const Color(0xFFF1E5D6).withValues(alpha: 0.72),
                            const Color(0xFFE8DACB).withValues(alpha: 0.45),
                          ],
                        ),
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: accent.withValues(alpha: 0.22),
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  widget.item.localizedBadgeLabel(l10n)!,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: onSurface,
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
        color: const Color(0xFFD8B779).withValues(alpha: alpha),
      ),
    );
  }
}
