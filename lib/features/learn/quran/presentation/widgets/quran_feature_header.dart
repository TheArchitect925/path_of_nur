import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../features/profile/application/profile_settings_provider.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../quran_summary_theme.dart';
import 'quran_feature_components.dart';

enum QuranFeatureHeaderDensity { compact, spacious }

class QuranFeatureHeader extends ConsumerWidget {
  const QuranFeatureHeader({
    super.key,
    required this.palette,
    this.overline,
    this.arabicTitle,
    required this.primaryTitle,
    this.subtitle,
    this.numberBadge,
    this.metadata = const <Widget>[],
    this.trailing,
    this.density = QuranFeatureHeaderDensity.spacious,
  });

  final QuranSummaryThemePalette palette;
  final String? overline;
  final String? arabicTitle;
  final String primaryTitle;
  final String? subtitle;
  final int? numberBadge;
  final List<Widget> metadata;
  final Widget? trailing;
  final QuranFeatureHeaderDensity density;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disableGlassTransparency = ref.watch(
      profileSettingsProvider.select((value) => value.disableGlassTransparency),
    );
    final highContrast = ref.watch(
      profileSettingsProvider.select((value) => value.highContrastText),
    );
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isMidnight = appearance?.mode == AppThemeMode.midnightManuscript;
    final compact = density == QuranFeatureHeaderDensity.compact;
    final baseDecoration = palette.elevatedSurfaceDecoration(
      radius: compact ? 24 : 30,
      emphasize: compact,
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: reduceMotion ? 0 : 180),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 20),
      decoration: disableGlassTransparency
          ? baseDecoration.copyWith(gradient: null, color: palette.cardTop)
          : baseDecoration,
      child: Stack(
        children: [
          if (isMidnight)
            Positioned(
              top: -18,
              right: -12,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.heroGlow.withValues(alpha: 0.95),
                        blurRadius: compact ? 40 : 56,
                        spreadRadius: compact ? 8 : 10,
                      ),
                    ],
                  ),
                  child: const SizedBox(width: 72, height: 72),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numberBadge != null || trailing != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (numberBadge != null)
                      _QuranFeatureNumberBadge(
                        number: numberBadge!,
                        palette: palette,
                      ),
                    if (numberBadge != null && trailing != null)
                      const SizedBox(width: 12),
                    if (trailing != null) Expanded(child: trailing!),
                  ],
                ),
              if (numberBadge != null || trailing != null)
                SizedBox(height: compact ? 12 : 16),
              if (overline != null) ...[
                Text(
                  overline!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: palette.goldAccent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                if (isMidnight) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: compact ? 58 : 72,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          palette.goldAccent.withValues(alpha: 0.88),
                          palette.goldSoft.withValues(alpha: 0.36),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
              ],
              if (arabicTitle != null) ...[
                Text(
                  arabicTitle!,
                  textAlign: textAlignForContent(arabicTitle!),
                  textDirection: textDirectionForContent(arabicTitle!),
                  style:
                      AppTextStyles.arabicLearning(
                        size: compact ? 28 : 32,
                        weight: FontWeight.w700,
                      ).copyWith(
                        color: isMidnight
                            ? palette.primaryText
                            : palette.goldAccent,
                        shadows: isMidnight
                            ? [
                                Shadow(
                                  color: palette.goldAccent.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 14,
                                ),
                              ]
                            : null,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                primaryTitle,
                style:
                    (compact
                            ? Theme.of(context).textTheme.titleLarge
                            : Theme.of(context).textTheme.headlineSmall)
                        ?.copyWith(
                          color: palette.primaryText,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: highContrast
                        ? palette.primaryText
                        : palette.supportText,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
              if (metadata.isNotEmpty) ...[
                SizedBox(height: compact ? 12 : 14),
                Wrap(spacing: 8, runSpacing: 8, children: metadata),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _QuranFeatureNumberBadge extends StatelessWidget {
  const _QuranFeatureNumberBadge({required this.number, required this.palette});

  final int number;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.numberFill.withValues(alpha: 0.95),
            palette.goldAccent.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.goldAccent.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: palette.heroGlow.withValues(alpha: 0.95),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        number.toString(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: palette.goldAccent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

List<Widget> buildQuranFeatureMetadata({
  required QuranSummaryThemePalette palette,
  required List<({String label, QuranFeatureRevelationTone tone})> items,
}) {
  return items
      .map(
        (item) => QuranFeatureMetadataChip(
          label: item.label,
          tone: item.tone,
          palette: palette,
        ),
      )
      .toList(growable: false);
}
