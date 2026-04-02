import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_theme.dart';

enum QuranFeatureRevelationTone { makki, madani, neutral }

@immutable
class QuranSummaryThemePalette {
  const QuranSummaryThemePalette({
    required this.pageOverlay,
    required this.cardTop,
    required this.cardBottom,
    required this.cardBorder,
    required this.goldAccent,
    required this.goldSoft,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.supportText,
    required this.makkiFill,
    required this.makkiBorder,
    required this.madaniFill,
    required this.madaniBorder,
    required this.numberFill,
    required this.subtlePanelFill,
    required this.subtlePanelBorder,
    required this.sectionDivider,
    required this.progressTrack,
    required this.progressFill,
    required this.heroGlow,
  });

  final Color pageOverlay;
  final Color cardTop;
  final Color cardBottom;
  final Color cardBorder;
  final Color goldAccent;
  final Color goldSoft;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final Color supportText;
  final Color makkiFill;
  final Color makkiBorder;
  final Color madaniFill;
  final Color madaniBorder;
  final Color numberFill;
  final Color subtlePanelFill;
  final Color subtlePanelBorder;
  final Color sectionDivider;
  final Color progressTrack;
  final Color progressFill;
  final Color heroGlow;

  LinearGradient get elevatedSurfaceGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardTop, cardBottom],
  );

  BoxDecoration elevatedSurfaceDecoration({
    double radius = 28,
    bool emphasize = false,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: elevatedSurfaceGradient,
      border: Border.all(color: emphasize ? goldAccent : cardBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: emphasize ? 0.11 : 0.08),
          blurRadius: emphasize ? 22 : 16,
          offset: const Offset(0, 8),
        ),
        if (emphasize)
          BoxShadow(
            color: heroGlow,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
      ],
    );
  }

  BoxDecoration subtlePanelDecoration({
    double radius = 20,
    bool emphasize = false,
  }) {
    return BoxDecoration(
      color: subtlePanelFill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: emphasize ? goldSoft.withValues(alpha: 0.72) : subtlePanelBorder,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: emphasize ? 0.08 : 0.05),
          blurRadius: emphasize ? 18 : 12,
          offset: const Offset(0, 6),
        ),
        if (emphasize)
          BoxShadow(
            color: heroGlow.withValues(alpha: 0.8),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
      ],
    );
  }

  Color chipFillForTone(QuranFeatureRevelationTone tone) => switch (tone) {
    QuranFeatureRevelationTone.makki => makkiFill,
    QuranFeatureRevelationTone.madani => madaniFill,
    QuranFeatureRevelationTone.neutral => numberFill,
  };

  Color chipBorderForTone(QuranFeatureRevelationTone tone) => switch (tone) {
    QuranFeatureRevelationTone.makki => makkiBorder,
    QuranFeatureRevelationTone.madani => madaniBorder,
    QuranFeatureRevelationTone.neutral => cardBorder,
  };

  Color chipTextForTone(QuranFeatureRevelationTone tone) => switch (tone) {
    QuranFeatureRevelationTone.makki => makkiBorder,
    QuranFeatureRevelationTone.madani => madaniBorder,
    QuranFeatureRevelationTone.neutral => secondaryText,
  };

  static QuranSummaryThemePalette resolve(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isDark = appearance?.isDark ?? false;
    final accent = appearance?.accent ?? AppColors.accentGold;
    final elevatedStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.card,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: accent,
    );
    final panelStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: accent,
    );
    final content = AppSurfaceTheme.contentColors(
      context,
      treatment: AppSurfaceTreatment.denseSanctuary,
    );

    return QuranSummaryThemePalette(
      pageOverlay: (isDark ? Colors.black : accent).withValues(
        alpha: isDark ? 0.18 : 0.10,
      ),
      cardTop: elevatedStyle.gradient.colors.first,
      cardBottom: elevatedStyle.gradient.colors.last,
      cardBorder: elevatedStyle.borderColor,
      goldAccent: accent,
      goldSoft:
          appearance?.accentSoft ??
          Color.lerp(accent, Colors.white, 0.28) ??
          accent,
      primaryText: content.foreground,
      secondaryText: content.subtleForeground,
      mutedText: content.captionForeground,
      supportText: Color.alphaBlend(
        (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        content.subtleForeground,
      ),
      makkiFill: accent.withValues(alpha: isDark ? 0.24 : 0.14),
      makkiBorder:
          appearance?.makkiBorder ??
          Color.lerp(accent, const Color(0xFFA67C2C), 0.48) ??
          accent,
      madaniFill: appearance?.madaniFill ?? const Color(0x22488667),
      madaniBorder: appearance?.madaniBorder ?? const Color(0xFF4F8264),
      numberFill: accent.withValues(alpha: isDark ? 0.20 : 0.12),
      subtlePanelFill: panelStyle.backgroundColor,
      subtlePanelBorder: panelStyle.borderColor,
      sectionDivider: accent.withValues(alpha: isDark ? 0.30 : 0.18),
      progressTrack: panelStyle.borderColor.withValues(
        alpha: isDark ? 0.80 : 0.58,
      ),
      progressFill: accent,
      heroGlow: (appearance?.sanctuaryEdgeLight ?? accent).withValues(
        alpha: isDark ? 0.18 : 0.11,
      ),
    );
  }
}
