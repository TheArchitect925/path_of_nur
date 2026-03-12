import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as q;

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/domain/quran_ayah.dart';
import 'arabic_text_utils.dart';
import 'quran_text_span.dart';

class QuranQuote {
  const QuranQuote({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.surah,
    this.verse,
    this.locationLabel,
  });

  final String arabic;
  final String transliteration;
  final String translation;
  final int? surah;
  final int? verse;
  final String? locationLabel;

  String get locationText {
    if (surah != null && verse != null) {
      final safeSurah = surah!.clamp(1, q.totalSurahCount);
      final surahName = q.getSurahName(safeSurah);
      return '$surahName $safeSurah:$verse';
    }
    if (locationLabel != null && locationLabel!.isNotEmpty) {
      return locationLabel!;
    }
    return 'Qur’an';
  }
}

class QuranQuoteBlock extends ConsumerWidget {
  const QuranQuoteBlock({
    super.key,
    required this.quote,
    this.compact = false,
    this.onTap,
  });

  final QuranQuote quote;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? AppColors.accentGold;
    final surface = appearance?.surface ?? AppColors.surface;
    final borderAlpha =
        appearance?.glassBorderAlpha ?? AppColors.glassBorderAlpha;
    final surfaceAlpha =
        appearance?.glassSurfaceAlpha ?? AppColors.glassSurfaceAlpha;
    final onSurface = appearance?.onSurface ?? const Color(0xFF30231A);
    final onSurfaceSubtle =
        appearance?.onSurfaceSubtle ?? const Color(0xFF564638);

    final readerSettings = ref.watch(quranReaderSettingsProvider);
    final arabicScale = readerSettings.arabicScalePercent / 100.0;
    final transliterationScale =
        readerSettings.transliterationScalePercent / 100.0;
    final translationScale = readerSettings.translationScalePercent / 100.0;

    final arabicSize = (compact ? 30.0 : 32.0) * arabicScale;
    final transliterationSize = 13.5 * transliterationScale;
    final translationSize = 12.8 * translationScale;
    final showTransliteration = readerSettings.showTransliteration;
    final showTranslation = readerSettings.showTranslation;

    final ayahsAsync = quote.surah == null
        ? const AsyncValue<List<QuranAyah>>.data(<QuranAyah>[])
        : ref.watch(quranSurahAyahsProvider(quote.surah!));
    final resolvedAyah = (() {
      final surah = quote.surah;
      final verse = quote.verse;
      if (surah == null || verse == null) return null;
      final ayahs = ayahsAsync.valueOrNull ?? const <QuranAyah>[];
      for (final ayah in ayahs) {
        if (ayah.ayahNumber == verse) return ayah;
      }
      return null;
    })();
    final resolvedArabic = resolvedAyah?.arabic.trim().isNotEmpty == true
        ? resolvedAyah!.arabic
        : quote.arabic;
    final resolvedTransliteration =
        resolvedAyah?.transliteration?.trim().isNotEmpty == true
        ? resolvedAyah!.transliteration!
        : quote.transliteration;
    final resolvedTranslation =
        resolvedAyah?.translation.trim().isNotEmpty == true
        ? resolvedAyah!.translation
        : quote.translation;

    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: borderAlpha)),
        color: surface.withValues(alpha: surfaceAlpha),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final style =
                  AppTextStyles.quranVerse(
                    size: arabicSize,
                    color: onSurface,
                  ).copyWith(
                    height: 1.9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  );
              return Text.rich(
                buildQuranTextWithColoredHarakat(resolvedArabic, style),
                textAlign: textAlignForContent(resolvedArabic),
                textDirection: textDirectionForContent(resolvedArabic),
                strutStyle: StrutStyle(
                  fontFamily: style.fontFamily,
                  fontSize: style.fontSize,
                  height: style.height,
                  forceStrutHeight: true,
                ),
              );
            },
          ),
          if (showTransliteration) ...[
            const SizedBox(height: 8),
            Text(
              resolvedTransliteration,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurfaceSubtle,
                fontFamily: 'serif',
                fontSize: transliterationSize,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (showTranslation) ...[
            const SizedBox(height: 6),
            Text(
              resolvedTranslation,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurfaceSubtle,
                fontSize: translationSize,
                height: 1.35,
              ),
            ),
          ],
          if (!compact) const SizedBox(height: 8),
          if (!compact)
            Text(
              quote.locationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurfaceSubtle,
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: card,
    );
  }
}
