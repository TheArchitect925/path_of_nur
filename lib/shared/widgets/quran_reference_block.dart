import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as q;

import '../../l10n/app_localizations.dart';
import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'premium_card.dart';
import 'quran_navigation.dart';
import 'quran_verse_content.dart';

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
    final safeSurah = surahNumber.clamp(1, q.totalSurahCount);
    final requestedEndAyah = ayahEnd ?? ayahStart;
    final safeStartAyah = ayahStart <= requestedEndAyah
        ? ayahStart
        : requestedEndAyah;
    final safeEndAyah = ayahStart <= requestedEndAyah
        ? requestedEndAyah
        : ayahStart;
    final refLabel = safeStartAyah == safeEndAyah
        ? '$safeSurah:$safeStartAyah'
        : '$safeSurah:$safeStartAyah-$safeEndAyah';
    final quoteRef = QuranQuoteRef(
      surah: safeSurah,
      ayah: safeStartAyah,
      ayahEnd: safeEndAyah,
    );

    return PremiumCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => openQuranReferenceLocation(context, ref: quoteRef),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? l10n.quranReferenceViewerReferenceLabel(refLabel),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              QuranVerseContent(
                source: QuranVerseSource(
                  ref: quoteRef,
                  referenceText:
                      '${surahName ?? q.getSurahName(safeSurah)} • $refLabel',
                ),
                dense: dense,
                center: false,
                arabicBaseSize: dense ? 27 : 30,
              ),
              if (showOpenButton) ...[
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => openQuranReferenceLocation(
                    context,
                    ref: quoteRef,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.quranReferenceViewerOpenInReader),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
