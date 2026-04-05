import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/quran_surah_summary_models.dart';
import '../../../presentation/widgets/learn_discovery_search_field.dart';
import '../quran_summary_theme.dart';

class QuranFeatureSectionCard extends StatelessWidget {
  const QuranFeatureSectionCard({
    super.key,
    required this.title,
    required this.palette,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final QuranSummaryThemePalette palette;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isMidnight = appearance?.mode == AppThemeMode.midnightManuscript;
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: palette.goldAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isMidnight)
                Container(
                  width: 24,
                  height: 2,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: palette.goldAccent.withValues(alpha: 0.82),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.supportText,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  palette.sectionDivider,
                  palette.sectionDivider.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class QuranFeatureMetadataChip extends StatelessWidget {
  const QuranFeatureMetadataChip({
    super.key,
    required this.label,
    required this.palette,
    this.tone = QuranFeatureRevelationTone.neutral,
  });

  final String label;
  final QuranSummaryThemePalette palette;
  final QuranFeatureRevelationTone tone;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isMidnight = appearance?.mode == AppThemeMode.midnightManuscript;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.chipFillForTone(tone),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.chipBorderForTone(tone)),
        boxShadow: isMidnight
            ? [
                BoxShadow(
                  color: palette.heroGlow.withValues(alpha: 0.7),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: palette.chipTextForTone(tone),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

class QuranFeatureThemeChip extends StatelessWidget {
  const QuranFeatureThemeChip({
    super.key,
    required this.label,
    required this.palette,
  });

  final String label;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isMidnight = appearance?.mode == AppThemeMode.midnightManuscript;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMidnight
            ? palette.subtlePanelFill.withValues(alpha: 0.95)
            : palette.cardBottom.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isMidnight ? palette.subtlePanelBorder : palette.cardBorder,
        ),
        boxShadow: isMidnight
            ? [
                BoxShadow(
                  color: palette.heroGlow.withValues(alpha: 0.7),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isMidnight ? palette.primaryText : palette.secondaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class QuranFeatureSearchCard extends StatelessWidget {
  const QuranFeatureSearchCard({
    super.key,
    required this.controller,
    required this.hintText,
    required this.palette,
    this.onChanged,
    this.onClear,
    this.onTap,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final QuranSummaryThemePalette palette;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: palette.goldSoft,
      child: LearnDiscoverySearchField(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
  }
}

class QuranFeatureEmptyState extends ConsumerWidget {
  const QuranFeatureEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.palette,
    this.icon = Icons.auto_stories_outlined,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highContrast = ref.watch(
      profileSettingsProvider.select((value) => value.highContrastText),
    );
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: palette.goldAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: palette.goldAccent, size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: palette.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: highContrast ? palette.primaryText : palette.secondaryText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class QuranFeatureFilterChip extends StatelessWidget {
  const QuranFeatureFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final QuranSummaryThemePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isMidnight = appearance?.mode == AppThemeMode.midnightManuscript;
    final chipStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: palette.goldAccent,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: chipStyle
            .decoration(radius: 999, includeShadow: false)
            .copyWith(
              color: selected
                  ? (isMidnight
                        ? palette.goldAccent.withValues(alpha: 0.22)
                        : palette.goldAccent.withValues(alpha: 0.20))
                  : (isMidnight
                        ? palette.cardBottom.withValues(alpha: 0.90)
                        : palette.cardBottom.withValues(alpha: 0.78)),
              gradient: selected ? null : chipStyle.gradient,
              border: Border.all(
                color: selected
                    ? palette.goldAccent
                    : isMidnight
                    ? palette.subtlePanelBorder
                    : palette.cardBorder,
              ),
            ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected
                ? (isMidnight ? palette.primaryText : palette.goldAccent)
                : palette.secondaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

String quranSummaryRevelationLabel(
  AppLocalizations l10n,
  QuranFeatureRevelationTone tone,
) {
  return switch (tone) {
    QuranFeatureRevelationTone.makki => l10n.quranSummaryFilterMakki,
    QuranFeatureRevelationTone.madani => l10n.quranSummaryFilterMadani,
    QuranFeatureRevelationTone.neutral => l10n.quranSummaryRevelationMixed,
  };
}

String quranSummaryThemeLabel(AppLocalizations l10n, QuranSurahThemeTag tag) {
  return switch (tag) {
    QuranSurahThemeTag.tawhid => l10n.quranSummaryThemeTawhid,
    QuranSurahThemeTag.revelation => l10n.quranSummaryThemeRevelation,
    QuranSurahThemeTag.guidance => l10n.quranSummaryThemeGuidance,
    QuranSurahThemeTag.mercy => l10n.quranSummaryThemeMercy,
    QuranSurahThemeTag.judgment => l10n.quranSummaryThemeJudgment,
    QuranSurahThemeTag.patience => l10n.quranSummaryThemePatience,
    QuranSurahThemeTag.repentance => l10n.quranSummaryThemeRepentance,
    QuranSurahThemeTag.prophethood => l10n.quranSummaryThemeProphethood,
    QuranSurahThemeTag.resurrection => l10n.quranSummaryThemeResurrection,
    QuranSurahThemeTag.worship => l10n.quranSummaryThemeWorship,
    QuranSurahThemeTag.law => l10n.quranSummaryThemeLaw,
    QuranSurahThemeTag.community => l10n.quranSummaryThemeCommunity,
    QuranSurahThemeTag.gratitude => l10n.quranSummaryThemeGratitude,
    QuranSurahThemeTag.justice => l10n.quranSummaryThemeJustice,
    QuranSurahThemeTag.signsOfCreation => l10n.quranSummaryThemeSignsOfCreation,
    QuranSurahThemeTag.hypocrisy => l10n.quranSummaryThemeHypocrisy,
    QuranSurahThemeTag.charity => l10n.quranSummaryThemeCharity,
    QuranSurahThemeTag.family => l10n.quranSummaryThemeFamily,
    QuranSurahThemeTag.struggle => l10n.quranSummaryThemeStruggle,
    QuranSurahThemeTag.paradiseAndHell => l10n.quranSummaryThemeParadiseAndHell,
  };
}
