import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class QuranSacredBlockChrome extends StatelessWidget {
  const QuranSacredBlockChrome({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 18,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isDark = appearance?.isDark ?? false;
    final sanctuaryIvoryGold = Color.lerp(
      appearance?.sanctuaryEdgeLight ?? const Color(0xFFF6E3B7),
      const Color(0xFFF3E7C7),
      0.38,
    )!;
    final champagneGold = Color.lerp(
      appearance?.sanctuaryEdgeLight ?? const Color(0xFFF6E3B7),
      Colors.white,
      0.22,
    )!;
    final antiqueGold = Color.lerp(
      appearance?.accent ?? const Color(0xFFDABE8D),
      const Color(0xFF8F7449),
      isDark ? 0.34 : 0.42,
    )!;
    final deepShadowTint = Color.lerp(
      antiqueGold,
      const Color(0xFF4E3C27),
      isDark ? 0.48 : 0.58,
    )!;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: sanctuaryIvoryGold.withValues(alpha: isDark ? 0.18 : 0.17),
            blurRadius: isDark ? 30 : 34,
            spreadRadius: isDark ? -8 : -6,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: champagneGold.withValues(alpha: isDark ? 0.11 : 0.09),
            blurRadius: isDark ? 20 : 24,
            spreadRadius: isDark ? -11 : -9,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: antiqueGold.withValues(alpha: isDark ? 0.16 : 0.12),
            blurRadius: isDark ? 24 : 28,
            spreadRadius: isDark ? -10 : -8,
            offset: const Offset(0, 13),
          ),
          BoxShadow(
            color: deepShadowTint.withValues(alpha: isDark ? 0.24 : 0.13),
            blurRadius: isDark ? 28 : 32,
            spreadRadius: isDark ? -10 : -8,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}
