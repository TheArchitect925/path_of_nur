import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../application/quran_providers.dart';
import '../domain/quran_surah.dart';
import 'widgets/quran_compact_search_results_section.dart';

enum _QuranExplorerSort { surahNumber, revelation }

class QuranSurahExplorerPage extends ConsumerStatefulWidget {
  const QuranSurahExplorerPage({super.key});

  @override
  ConsumerState<QuranSurahExplorerPage> createState() =>
      _QuranSurahExplorerPageState();
}

class _QuranSurahExplorerPageState
    extends ConsumerState<QuranSurahExplorerPage> {
  late final TextEditingController _searchController;
  String _query = '';
  _QuranExplorerSort _sort = _QuranExplorerSort.surahNumber;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranFilteredSurahListProvider(_query));
    final sortedSurahs = _sortedSurahs(surahs);

    return AppPageScaffold(
      headerIcon: Icons.explore_outlined,
      title: l10n.quranExplorerTitle,
      subtitle: l10n.quranExplorerSubtitle,
      children: [
        PremiumCard(
          child: Column(
            children: [
              LearnDiscoverySearchField(
                controller: _searchController,
                hintText: l10n.searchSurahHint,
                onChanged: (value) => setState(() => _query = value),
                onSubmitted: (value) => context.pushNamed(
                  'quranSearch',
                  queryParameters: value.trim().isEmpty
                      ? const {}
                      : {'q': value.trim()},
                ),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.pushNamed(
                    'quranSearch',
                    queryParameters: _query.trim().isEmpty
                        ? const {}
                        : {'q': _query.trim()},
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(l10n.quranSearchTitle),
                ),
              ),
            ],
          ),
        ),
        if (_query.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          QuranCompactSearchResultsSection(query: _query, maxResults: 4),
        ],
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
