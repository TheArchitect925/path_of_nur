import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as q;

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'arabic_text_utils.dart';
import 'quran_text_span.dart';

class QuranQuote {
  const QuranQuote({required this.ref});

  final QuranQuoteRef ref;

  String get locationText {
    if (ref.surah > 0 && ref.ayah > 0) {
      final safeSurah = ref.surah.clamp(1, q.totalSurahCount);
      final surahName = q.getSurahName(safeSurah);
      if (ref.ayahEnd != null && ref.ayahEnd != ref.ayah) {
        return '$surahName $safeSurah:${ref.ayah}-${ref.ayahEnd}';
      }
      return '$surahName $safeSurah:${ref.ayah}';
    }
    return 'Qur’an';
  }
}

enum QuranQuotePool { quran, dhikr, reflection }

const List<QuranQuote> quranFocusedQuotePool = <QuranQuote>[
  QuranQuote(ref: QuranQuoteRef(surah: 20, ayah: 114)),
  QuranQuote(ref: QuranQuoteRef(surah: 38, ayah: 29)),
  QuranQuote(ref: QuranQuoteRef(surah: 17, ayah: 9)),
];

const List<QuranQuote> dhikrFocusedQuotePool = <QuranQuote>[
  QuranQuote(ref: QuranQuoteRef(surah: 13, ayah: 28)),
  QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 152)),
  QuranQuote(ref: QuranQuoteRef(surah: 73, ayah: 8)),
];

const List<QuranQuote> reflectionFocusedQuotePool = <QuranQuote>[
  QuranQuote(ref: QuranQuoteRef(surah: 4, ayah: 82)),
  QuranQuote(ref: QuranQuoteRef(surah: 50, ayah: 37)),
  QuranQuote(ref: QuranQuoteRef(surah: 3, ayah: 191)),
];

QuranQuote quoteFromPoolForToday(List<QuranQuote> pool, {DateTime? date}) {
  if (pool.isEmpty) {
    return const QuranQuote(ref: QuranQuoteRef(surah: 20, ayah: 114));
  }
  final now = date ?? DateTime.now();
  final dayNumber =
      DateUtils.dateOnly(now).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
  return pool[dayNumber % pool.length];
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
    final onSurface = appearance?.onSurface ?? const Color(0xFF30231A);
    final onSurfaceSubtle =
        appearance?.onSurfaceSubtle ?? const Color(0xFF564638);
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: accent,
    );

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

    final quoteContentAsync = ref.watch(quranQuoteContentProvider(quote.ref));
    final resolvedArabic = quoteContentAsync.valueOrNull?.arabic ?? '';
    final resolvedTransliteration =
        quoteContentAsync.valueOrNull?.transliteration ?? '';
    final resolvedTranslation =
        quoteContentAsync.valueOrNull?.translation ?? '';
    final contentReady = resolvedArabic.trim().isNotEmpty;

    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: surfaceStyle.decoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (contentReady)
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
            )
          else
            SizedBox(
              height: compact ? 56 : 72,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      accent.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ),
          if (contentReady &&
              showTransliteration &&
              resolvedTransliteration.isNotEmpty) ...[
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
          if (contentReady &&
              showTranslation &&
              resolvedTranslation.isNotEmpty) ...[
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
      onTap: contentReady ? onTap : null,
      child: card,
    );
  }
}
