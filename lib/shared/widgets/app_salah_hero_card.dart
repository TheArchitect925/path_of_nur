import 'package:flutter/material.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import 'arabic_text_utils.dart';
import 'app_hero_glass_shell.dart';
import 'noor_glass_card.dart';
import 'noor_liquid_glass.dart';

class AppSalahHeroStat {
  const AppSalahHeroStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tint;
}

class AppSalahHeroMetaChipData {
  const AppSalahHeroMetaChipData({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF6E5D4C),
  });

  final IconData icon;
  final String label;
  final Color color;
}

class AppSalahHeroCard extends StatelessWidget {
  const AppSalahHeroCard({
    super.key,
    required this.locationLabel,
    required this.nextName,
    required this.nextArabic,
    required this.offerByLabel,
    required this.offerByValue,
    required this.stats,
    required this.onOpenSalahTimes,
    required this.onOpenLocationPicker,
    this.metaChips = const <AppSalahHeroMetaChipData>[],
  });

  final String locationLabel;
  final String nextName;
  final String nextArabic;
  final String offerByLabel;
  final String offerByValue;
  final List<AppSalahHeroStat> stats;
  final VoidCallback onOpenSalahTimes;
  final VoidCallback onOpenLocationPicker;
  final List<AppSalahHeroMetaChipData> metaChips;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onOpenLocationPicker,
              child: NoorGlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                surfaceVariant: AppSurfaceVariant.pill,
                surfaceTintColor: const Color(0xFFE2BC72),
                surfaceAlphaOverride: 0.16,
                includeShadow: false,
                mode: NoorLiquidGlassMode.fake,
                borderRadius: 16,
                child: Builder(
                  builder: (context) {
                    final appearance = Theme.of(
                      context,
                    ).extension<AppAppearanceTheme>();
                    final accent =
                        appearance?.accentSoft ?? const Color(0xFF7A5A33);
                    final ink =
                        appearance?.onSurface ?? const Color(0xFF4D4036);
                    return Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: accent,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ink,
                              fontSize: 12.8,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: accent,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          NoorGlassCard(
            padding: const EdgeInsets.all(14),
            surfaceVariant: AppSurfaceVariant.panel,
            surfaceTintColor: const Color(0xFFE4BE74),
            surfaceAlphaOverride: 0.16,
            includeShadow: false,
            mode: NoorLiquidGlassMode.fake,
            borderRadius: 22,
            child: _AppSalahHeroPrimaryRow(
              nextName: nextName,
              nextArabic: nextArabic,
              offerByLabel: offerByLabel,
              offerByValue: offerByValue,
            ),
          ),
          for (var index = 0; index < metaChips.length; index++) ...[
            const SizedBox(height: 10),
            _AppSalahHeroMetaChip(data: metaChips[index]),
          ],
          const SizedBox(height: 14),
          _AppSalahHeroStatsLayer(stats: stats),
        ],
      ),
    );

    return AppHeroGlassShell(
      padding: EdgeInsets.zero,
      onTap: onOpenSalahTimes,
      child: content,
    );
  }
}

class _AppSalahHeroStatsLayer extends StatelessWidget {
  const _AppSalahHeroStatsLayer({required this.stats});

  final List<AppSalahHeroStat> stats;

  @override
  Widget build(BuildContext context) {
    return NoorGlassCard(
      padding: const EdgeInsets.all(5),
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: const Color(0xFFE5C88F),
      surfaceAlphaOverride: 0.14,
      includeShadow: false,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: 26,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < stats.length; index++) ...[
              Expanded(child: _AppSalahHeroStatCard(stat: stats[index])),
              if (index + 1 < stats.length) const SizedBox(width: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppSalahHeroStatCard extends StatelessWidget {
  const _AppSalahHeroStatCard({required this.stat});

  final AppSalahHeroStat stat;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final tint = appearance?.isDark == true
        ? Color.lerp(stat.tint, Colors.white, 0.45) ?? stat.tint
        : stat.tint;
    final card = NoorGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: stat.tint,
      surfaceAlphaOverride: 0.12,
      includeShadow: false,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(stat.icon, size: 14, color: tint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: tint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: appearance?.onSurface ?? const Color(0xFF2F2923),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.2,
              color: appearance?.onSurfaceSubtle ?? const Color(0xFF6E5D4C),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
    return card;
  }
}

class _AppSalahHeroPrimaryRow extends StatelessWidget {
  const _AppSalahHeroPrimaryRow({
    required this.nextName,
    required this.nextArabic,
    required this.offerByLabel,
    required this.offerByValue,
  });

  final String nextName;
  final String nextArabic;
  final String offerByLabel;
  final String offerByValue;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final ink = appearance?.onSurface ?? const Color(0xFF202228);
    final subtleInk = appearance?.onSurfaceSubtle ?? const Color(0xFF6E5D4C);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NoorGlassCard(
          padding: EdgeInsets.zero,
          surfaceVariant: AppSurfaceVariant.panel,
          surfaceTintColor: const Color(0xFFE5C583),
          surfaceAlphaOverride: 0.12,
          includeShadow: false,
          mode: NoorLiquidGlassMode.fake,
          borderRadius: 16,
          width: 46,
          child: const SizedBox(
            height: 46,
            child: Center(
              child: Icon(
                Icons.schedule_rounded,
                size: 22,
                color: Color(0xFF6E9A73),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nextName,
                style: TextStyle(
                  fontSize: 23.25,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  fontFamily: AppFonts.latinSerif,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                nextArabic,
                textAlign: textAlignForContent(nextArabic),
                textDirection: textDirectionForContent(nextArabic),
                style: TextStyle(
                  fontSize: 12.4,
                  color: subtleInk,
                  fontFamily: AppFonts.latinSerif,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              offerByValue,
              style: TextStyle(
                fontSize: 18.75,
                fontWeight: FontWeight.w700,
                color: ink,
                fontFamily: AppFonts.latinSerif,
              ),
            ),
            Text(
              offerByLabel,
              style: TextStyle(fontSize: 12.5, color: subtleInk),
            ),
          ],
        ),
      ],
    );
  }
}

class _AppSalahHeroMetaChip extends StatelessWidget {
  const _AppSalahHeroMetaChip({required this.data});

  final AppSalahHeroMetaChipData data;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    // Dark grounds keep the chip's semantic hue but lift it into legibility.
    final content = appearance?.isDark == true
        ? Color.lerp(data.color, Colors.white, 0.45) ?? data.color
        : data.color;
    return NoorGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      surfaceVariant: AppSurfaceVariant.pill,
      surfaceTintColor: data.color,
      surfaceAlphaOverride: 0.16,
      includeShadow: false,
      mode: NoorLiquidGlassMode.fake,
      borderRadius: 14,
      child: Row(
        children: [
          Icon(data.icon, size: 15, color: content),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              data.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: content,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
