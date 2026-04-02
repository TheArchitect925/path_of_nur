import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as q;

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'quran_verse_content.dart';

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
    this.showReference = true,
    this.arabicTransform,
    this.transliterationTransform,
    this.translationTransform,
  });

  final QuranQuote quote;
  final bool compact;
  final VoidCallback? onTap;
  final bool showReference;
  final String Function(String arabic)? arabicTransform;
  final String Function(String transliteration)? transliterationTransform;
  final String Function(String translation)? translationTransform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? AppColors.accentGold;
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      treatment: AppSurfaceTreatment.denseSanctuary,
      tintColor: accent,
    );

    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: surfaceStyle.decoration(radius: 18, includeShadow: true),
      child: QuranVerseContent(
        source: QuranVerseSource(
          ref: quote.ref,
          referenceText: quote.locationText,
        ),
        dense: compact,
        center: true,
        showReference: showReference,
        arabicBaseSize: compact ? 30 : 32,
        transliterationBaseSize: 13.5,
        translationBaseSize: 12.8,
        arabicTransform: arabicTransform,
        transliterationTransform: transliterationTransform,
        translationTransform: translationTransform,
      ),
    );

    if (onTap == null) {
      return card;
    }
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
