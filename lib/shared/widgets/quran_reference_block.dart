import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as q;

import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/domain/quran_ayah.dart';
import 'arabic_text_utils.dart';
import 'premium_card.dart';
import 'quran_text_span.dart';

class QuranReferenceBlock extends ConsumerWidget {
  const QuranReferenceBlock({
    super.key,
    required this.surahNumber,
    required this.ayahStart,
    this.ayahEnd,
    this.surahName,
    this.title,
    this.showOpenButton = true,
    this.dense = false,
  });

  final int surahNumber;
  final int ayahStart;
  final int? ayahEnd;
  final String? surahName;
  final String? title;
  final bool showOpenButton;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(quranReaderSettingsProvider);
    final safeSurah = surahNumber.clamp(1, q.totalSurahCount);
    final requestedEndAyah = ayahEnd ?? ayahStart;
    final safeStartAyah = ayahStart <= requestedEndAyah
        ? ayahStart
        : requestedEndAyah;
    final safeEndAyah = ayahStart <= requestedEndAyah
        ? requestedEndAyah
        : ayahStart;
    final ayahsAsync = ref.watch(quranSurahAyahsProvider(safeSurah));

    final ayahs = ayahsAsync.valueOrNull ?? const <QuranAyah>[];
    final ayahCount = ayahs.length;
    final boundedStart = ayahCount == 0
        ? safeStartAyah
        : safeStartAyah.clamp(1, ayahCount);
    final boundedEnd = ayahCount == 0
        ? safeEndAyah
        : safeEndAyah.clamp(1, ayahCount);
    final selected = ayahs
        .where(
          (a) => a.ayahNumber >= boundedStart && a.ayahNumber <= boundedEnd,
        )
        .toList(growable: false);

    final arabic = selected.map((a) => a.arabic).join(' ').trim();
    final transliteration = selected
        .map((a) => (a.transliteration ?? '').trim())
        .where((s) => s.isNotEmpty)
        .join(' ')
        .trim();
    final translation = selected.map((a) => a.translation).join(' ').trim();

    final arabicScale = settings.arabicScalePercent / 100.0;
    final transliterationScale = settings.transliterationScalePercent / 100.0;
    final translationScale = settings.translationScalePercent / 100.0;

    final refLabel = boundedStart == boundedEnd
        ? '$safeSurah:$boundedStart'
        : '$safeSurah:$boundedStart-$boundedEnd';

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? l10n.quranReferenceViewerReferenceLabel(refLabel),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (ayahsAsync.hasError)
            Text(
              l10n.quranReferenceBlockLoadError,
              style: Theme.of(context).textTheme.bodySmall,
            )
          else if (arabic.isEmpty)
            const LinearProgressIndicator(minHeight: 6)
          else
            Text.rich(
              buildQuranTextWithColoredHarakat(
                arabic,
                AppTextStyles.quranVerse(
                  size: (dense ? 27 : 30) * arabicScale,
                ).copyWith(height: 1.75),
              ),
              textAlign: textAlignForContent(arabic),
              textDirection: textDirectionForContent(arabic),
            ),
          if (settings.showTransliteration) ...[
            const SizedBox(height: 8),
            Text(
              transliteration.isEmpty
                  ? l10n.quranReferenceBlockTransliterationUnavailable
                  : transliteration,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 13.5 * transliterationScale,
              ),
            ),
          ],
          if (settings.showTranslation) ...[
            const SizedBox(height: 8),
            Text(
              translation.isEmpty
                  ? l10n.quranReferenceBlockLoadingTranslation
                  : translation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.8 * translationScale,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${surahName ?? l10n.quranReferenceBlockSurahLabel} • $refLabel',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (showOpenButton) ...[
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed(
                'quranReader',
                pathParameters: {'surahNumber': '$safeSurah'},
                queryParameters: {
                  'ayah': '$boundedStart',
                  'endAyah': '$boundedEnd',
                  'autoplay': 'true',
                },
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l10n.quranReferenceViewerOpenInReader),
            ),
          ],
        ],
      ),
    );
  }
}
