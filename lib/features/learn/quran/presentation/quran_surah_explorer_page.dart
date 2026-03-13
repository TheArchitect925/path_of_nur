import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../application/quran_providers.dart';
import '../domain/quran_surah.dart';

enum _QuranExplorerSort { surahNumber, revelation }

class QuranSurahExplorerPage extends ConsumerStatefulWidget {
  const QuranSurahExplorerPage({super.key});

  @override
  ConsumerState<QuranSurahExplorerPage> createState() =>
      _QuranSurahExplorerPageState();
}

class _QuranSurahExplorerPageState
    extends ConsumerState<QuranSurahExplorerPage> {
  _QuranExplorerSort _sort = _QuranExplorerSort.surahNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranFilteredSurahListProvider);
    final sortedSurahs = _sortedSurahs(surahs);

    return AppPageScaffold(
      headerIcon: Icons.explore_outlined,
      title: l10n.quranExplorerTitle,
      subtitle: l10n.quranExplorerSubtitle,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (value) =>
                      ref.read(quranSearchQueryProvider.notifier).state = value,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: l10n.quranSearchHint,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.pushNamed('quranSearch'),
                icon: const Icon(Icons.tune_rounded, size: 18),
                tooltip: l10n.quranSearchTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: SegmentedPillControl<_QuranExplorerSort>(
            items: _QuranExplorerSort.values,
            selectedItem: _sort,
            labelBuilder: _sortLabel,
            onChanged: (value) => setState(() => _sort = value),
          ),
        ),
        const SizedBox(height: 14),
        if (sortedSurahs.isEmpty)
          PremiumCard(child: Text(l10n.quranSearchNoResults))
        else
          ...sortedSurahs.map(
            (surah) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: InkWell(
                  onTap: () => context.pushNamed(
                    'quranReader',
                    pathParameters: {'surahNumber': surah.number.toString()},
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD8C49A,
                          ).withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          surah.number.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.arabicName,
                              textAlign: textAlignForContent(surah.arabicName),
                              textDirection: textDirectionForContent(
                                surah.arabicName,
                              ),
                              style: AppTextStyles.arabicLearning(
                                size: 22,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${surah.transliteratedName} • ${surah.englishName}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6A5A4A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${surah.verseCount} ${l10n.quranAyahsLabel} • ${surah.revelationPlace} • ${surah.revelationClassification} • Revelation ${surah.revelationOrder} • ${surah.revelationPeriod}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A5A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _sortLabel(_QuranExplorerSort sort) {
    switch (sort) {
      case _QuranExplorerSort.surahNumber:
        return 'Sort by Surah #';
      case _QuranExplorerSort.revelation:
        return 'Sort by Revelation';
    }
  }

  List<QuranSurah> _sortedSurahs(List<QuranSurah> surahs) {
    final sorted = List<QuranSurah>.of(surahs);
    switch (_sort) {
      case _QuranExplorerSort.surahNumber:
        sorted.sort((a, b) => a.number.compareTo(b.number));
      case _QuranExplorerSort.revelation:
        sorted.sort((a, b) {
          final byOrder = a.revelationOrder.compareTo(b.revelationOrder);
          if (byOrder != 0) return byOrder;
          return a.number.compareTo(b.number);
        });
    }
    return sorted;
  }
}
