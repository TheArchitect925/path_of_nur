import 'package:flutter/material.dart';

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
    final mode = appearance?.mode;
    final isDark = appearance?.isDark ?? false;

    if (mode == AppThemeMode.midnightManuscript && appearance != null) {
      return QuranSummaryThemePalette(
        pageOverlay: const Color(0xAA0C1016),
        cardTop: Color.alphaBlend(
          appearance.accent.withValues(alpha: 0.08),
          appearance.surfaceSoft,
        ),
        cardBottom: appearance.surface,
        cardBorder: appearance.border.withValues(alpha: 0.92),
        goldAccent: appearance.accent,
        goldSoft: appearance.accentSoft,
        primaryText: appearance.quranArabicEmphasis,
        secondaryText: appearance.onSurface,
        mutedText: appearance.onSurfaceMuted,
        supportText: appearance.onSurfaceSubtle,
        makkiFill: appearance.makkiFill,
        makkiBorder: appearance.makkiBorder,
        madaniFill: appearance.madaniFill,
        madaniBorder: appearance.madaniBorder,
        numberFill: appearance.accent.withValues(alpha: 0.16),
        subtlePanelFill: Color.alphaBlend(
          appearance.accent.withValues(alpha: 0.05),
          appearance.surfaceSoft.withValues(alpha: 0.96),
        ),
        subtlePanelBorder: Color.alphaBlend(
          appearance.accent.withValues(alpha: 0.10),
          appearance.border.withValues(alpha: 0.92),
        ),
        sectionDivider: appearance.accent.withValues(alpha: 0.20),
        progressTrack: appearance.border.withValues(alpha: 0.72),
        progressFill: appearance.accent,
        heroGlow: appearance.accent.withValues(alpha: 0.12),
      );
    }

    if (isDark) {
      return const QuranSummaryThemePalette(
        pageOverlay: Color(0x99211817),
        cardTop: Color(0xFF231A16),
        cardBottom: Color(0xFF17110E),
        cardBorder: Color(0xFF685338),
        goldAccent: Color(0xFFD8BE88),
        goldSoft: Color(0xFFB69561),
        primaryText: Color(0xFFF2E7D3),
        secondaryText: Color(0xFFD6C8B0),
        mutedText: Color(0xFFAA9B85),
        supportText: Color(0xFFC1AF90),
        makkiFill: Color(0x3A9C6F28),
        makkiBorder: Color(0xFFB28C46),
        madaniFill: Color(0x333D7E5A),
        madaniBorder: Color(0xFF71AE8B),
        numberFill: Color(0x33D8BE88),
        subtlePanelFill: Color(0xD31D1714),
        subtlePanelBorder: Color(0x80685338),
        sectionDivider: Color(0x4DD8BE88),
        progressTrack: Color(0x70685338),
        progressFill: Color(0xFFD8BE88),
        heroGlow: Color(0x22D8BE88),
      );
    }

    return const QuranSummaryThemePalette(
      pageOverlay: Color(0x6BE6D8C5),
      cardTop: Color(0xFFF7F0E5),
      cardBottom: Color(0xFFECE0CF),
      cardBorder: Color(0xD19C7A4C),
      goldAccent: Color(0xFF8D6B36),
      goldSoft: Color(0xFFA88450),
      primaryText: Color(0xFF33251A),
      secondaryText: Color(0xFF5B4634),
      mutedText: Color(0xFF786553),
      supportText: Color(0xFF6C5846),
      makkiFill: Color(0x26A67C2C),
      makkiBorder: Color(0xFFA67C2C),
      madaniFill: Color(0x22488667),
      madaniBorder: Color(0xFF4F8264),
      numberFill: Color(0x24A88450),
      subtlePanelFill: Color(0xF2F2E7D7),
      subtlePanelBorder: Color(0xB89C7A4C),
      sectionDivider: Color(0x4DA88450),
      progressTrack: Color(0x579C7A4C),
      progressFill: Color(0xFF8D6B36),
      heroGlow: Color(0x159C7A4C),
    );
  }
}
