import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../../shared/widgets/display/index_rail.dart';
import '../../../../../shared/widgets/display/progress_bar.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/segmented_pill_control.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../application/quran_providers.dart';
import '../domain/quran_reading_progress.dart';
import '../domain/quran_surah.dart';
import 'widgets/quran_compact_search_results_section.dart';
import '../../../../core/theme/app_icons.dart';

enum _QuranExplorerSort { surahNumber, revelation }

class QuranSurahExplorerPage extends ConsumerStatefulWidget {
  const QuranSurahExplorerPage({super.key});

  @override
  ConsumerState<QuranSurahExplorerPage> createState() =>
      _QuranSurahExplorerPageState();
}

class _QuranSurahExplorerPageState
    extends ConsumerState<QuranSurahExplorerPage> {
  static const _railLabels = <String>[
    '1',
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '114',
  ];

  late final TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpToRailIndex(int railIndex) {
    if (!_scrollController.hasClients) return;
    final surahNumber = int.tryParse(_railLabels[railIndex]) ?? 1;
    final fraction = ((surahNumber - 1) / 114).clamp(0.0, 1.0);
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent * fraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surahs = ref.watch(quranFilteredSurahListProvider(_query));
    final sortedSurahs = _sortedSurahs(surahs);
    final readingProgress = ref.watch(quranReadingProgressProvider);
    final showRail =
        _query.trim().isEmpty && _sort == _QuranExplorerSort.surahNumber;

    return Stack(
      children: [
        AppPageScaffold(
          headerIcon: AppIcons.surahs,
          title: l10n.quranExplorerTitle,
          subtitle: l10n.quranExplorerSubtitle,
          scrollController: _scrollController,
          bodySlivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, showRail ? 16 + 26 : 16, 0),
              sliver: sortedSurahs.isEmpty
                  ? SliverToBoxAdapter(
                      child: PremiumCard(
                        child: Text(l10n.quranSearchNoResults),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: sortedSurahs.length,
                      itemBuilder: (context, index) => _SurahTile(
                        surah: sortedSurahs[index],
                        readingProgress: readingProgress,
                        l10n: l10n,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    ),
            ),
          ],
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
          ],
        ),
        if (showRail)
          Positioned(
            right: 2,
            top: 200,
            bottom: 160,
            child: SafeArea(
              child: IndexRail(
                labels: _railLabels,
                onSelected: _jumpToRailIndex,
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

class _SurahTile extends StatelessWidget {
  const _SurahTile({
    required this.surah,
    required this.readingProgress,
    required this.l10n,
  });

  final QuranSurah surah;
  final QuranReadingProgress readingProgress;
  final AppLocalizations l10n;

  bool get _isMakki => surah.revelationPlace.toLowerCase().contains('makk');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final tint = _isMakki ? appearance?.makkiFill : appearance?.madaniFill;
    final isLastRead = readingProgress.surahNumber == surah.number;
    final lastReadFraction = surah.verseCount == 0
        ? 0.0
        : readingProgress.ayahNumber / surah.verseCount;

    return PremiumCard(
      density: PremiumCardDensity.tile,
      surfaceTintColor: tint,
      onTap: () => context.pushNamed(
        'quranReader',
        pathParameters: {'surahNumber': surah.number.toString()},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompactTileBadge(label: surah.number.toString(), size: 34),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${surah.transliteratedName} \u2022 ${surah.englishName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          surah.arabicName,
                          textDirection: textDirectionForContent(
                            surah.arabicName,
                          ),
                          style: AppTextStyles.arabicLearning(
                            size: 20,
                            color:
                                theme.textTheme.titleSmall?.color ??
                                theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${surah.verseCount} ${l10n.quranAyahsLabel} \u2022 ${surah.revelationPlace} \u2022 ${surah.revelationPeriod}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLastRead) ...[
            const SizedBox(height: AppSpacing.xs),
            ProgressBar(value: lastReadFraction, height: 4),
          ],
        ],
      ),
    );
  }
}
