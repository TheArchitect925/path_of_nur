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

enum QuranQuotePool {
  quran,
  dhikr,
  reflection,
}

const List<QuranQuote> quranFocusedQuotePool = <QuranQuote>[
  QuranQuote(
    arabic: 'وَقُلْ رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Wa qul Rabbi zidni ilma',
    translation: 'And say: My Lord, increase me in knowledge.',
    surah: 20,
    verse: 114,
    locationLabel: 'Qur’an 20:114',
  ),
  QuranQuote(
    arabic: 'كِتَابٌ أَنْزَلْنَاهُ إِلَيْكَ مُبَارَكٌ لِّيَدَّبَّرُوا آيَاتِهِ',
    transliteration: 'Kitabun anzalnahu ilayka mubarakun liyaddabbaru ayatihi',
    translation:
        'This is a blessed Book which We have revealed to you so that they may reflect upon its verses.',
    surah: 38,
    verse: 29,
    locationLabel: 'Qur’an 38:29',
  ),
  QuranQuote(
    arabic: 'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
    transliteration: 'Inna haza al-Qur’ana yahdi lillati hiya aqwam',
    translation:
        'Surely this Qur’an guides to what is most upright.',
    surah: 17,
    verse: 9,
    locationLabel: 'Qur’an 17:9',
  ),
];

const List<QuranQuote> dhikrFocusedQuotePool = <QuranQuote>[
  QuranQuote(
    arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
    transliteration: 'Ala bidhikrillahi tatmainnul qulub',
    translation: 'Surely in the remembrance of Allah do hearts find rest.',
    surah: 13,
    verse: 28,
    locationLabel: 'Qur’an 13:28',
  ),
  QuranQuote(
    arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
    transliteration: 'Fadhkuruni adhkurkum',
    translation: 'So remember Me; I will remember you.',
    surah: 2,
    verse: 152,
    locationLabel: 'Qur’an 2:152',
  ),
  QuranQuote(
    arabic: 'وَاذْكُرِ اسْمَ رَبِّكَ وَتَبَتَّلْ إِلَيْهِ تَبْتِيلًا',
    transliteration: 'Wadhkur isma rabbika wa tabattal ilayhi tabtila',
    translation:
        'Remember the name of your Lord, and devote yourself to Him fully.',
    surah: 73,
    verse: 8,
    locationLabel: 'Qur’an 73:8',
  ),
];

const List<QuranQuote> reflectionFocusedQuotePool = <QuranQuote>[
  QuranQuote(
    arabic: 'أَفَلَا يَتَدَبَّرُونَ الْقُرْآنَ',
    transliteration: 'Afala yatadabbarunal-Qur’an',
    translation: 'Will they not then reflect upon the Qur’an?',
    surah: 4,
    verse: 82,
    locationLabel: 'Qur’an 4:82',
  ),
  QuranQuote(
    arabic: 'إِنَّ فِي ذَٰلِكَ لَذِكْرَىٰ لِمَن كَانَ لَهُ قَلْبٌ',
    transliteration: 'Inna fi dhalika la-dhikra liman kana lahu qalb',
    translation:
        'Surely in that is a reminder for whoever has a living heart.',
    surah: 50,
    verse: 37,
    locationLabel: 'Qur’an 50:37',
  ),
  QuranQuote(
    arabic: 'الَّذِينَ يَذْكُرُونَ اللَّهَ قِيَامًا وَقُعُودًا وَيَتَفَكَّرُونَ',
    transliteration:
        'Alladhina yadhkurunallaha qiyaman wa quudan wa yatafakkarun',
    translation:
        'Those who remember Allah while standing, sitting, and lying down, and reflect deeply.',
    surah: 3,
    verse: 191,
    locationLabel: 'Qur’an 3:191',
  ),
];

QuranQuote quoteFromPoolForToday(List<QuranQuote> pool, {DateTime? date}) {
  if (pool.isEmpty) {
    return const QuranQuote(
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni ilma',
      translation: 'My Lord, increase me in knowledge.',
      surah: 20,
      verse: 114,
      locationLabel: 'Qur’an 20:114',
    );
  }
  final now = date ?? DateTime.now();
  final dayNumber = DateUtils.dateOnly(now).millisecondsSinceEpoch ~/
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
