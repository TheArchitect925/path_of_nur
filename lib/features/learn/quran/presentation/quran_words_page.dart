import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_words_provider.dart';
import '../domain/quran_core_word.dart';

enum _BandFilter { top25, top50, top100, all }

enum _WordSort { mostFrequent, rank, alphabetical }

class QuranWordsPage extends ConsumerStatefulWidget {
  const QuranWordsPage({super.key});

  @override
  ConsumerState<QuranWordsPage> createState() => _QuranWordsPageState();
}

class _QuranWordsPageState extends ConsumerState<QuranWordsPage> {
  _BandFilter _filter = _BandFilter.top50;
  _WordSort _sort = _WordSort.mostFrequent;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(quranCoreWordsProvider);
    final progress = ref.watch(quranWordsProgressProvider);
    final progressNotifier = ref.read(quranWordsProgressProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.translate_rounded,
      title: l10n.quranTopWordsTitle,
      subtitle: l10n.batch9QuranWordsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.batch9QuranWordsStudyBands,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _BandChip(
                    label: l10n.batch9QuranWordsTop25,
                    selected: _filter == _BandFilter.top25,
                    onTap: () => setState(() => _filter = _BandFilter.top25),
                  ),
                  _BandChip(
                    label: l10n.batch9QuranWordsTop50,
                    selected: _filter == _BandFilter.top50,
                    onTap: () => setState(() => _filter = _BandFilter.top50),
                  ),
                  _BandChip(
                    label: l10n.batch9QuranWordsTop100,
                    selected: _filter == _BandFilter.top100,
                    onTap: () => setState(() => _filter = _BandFilter.top100),
                  ),
                  _BandChip(
                    label: l10n.batch9QuranWordsAllLoaded,
                    selected: _filter == _BandFilter.all,
                    onTap: () => setState(() => _filter = _BandFilter.all),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<_WordSort>(
                initialValue: _sort,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: l10n.batch9SortBy,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: _WordSort.mostFrequent,
                    child: Text(l10n.batch9QuranWordsSortMostFrequent),
                  ),
                  DropdownMenuItem(
                    value: _WordSort.rank,
                    child: Text(l10n.batch9QuranWordsSortRank),
                  ),
                  DropdownMenuItem(
                    value: _WordSort.alphabetical,
                    child: Text(l10n.batch9SortAlphabetical),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _sort = value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: l10n.batch9QuranWordsSearchHint,
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        wordsAsync.when(
          data: (words) {
            final visible = _applyFilter(words, _filter, _query, _sort);
            final visibleRanks = visible.map((e) => e.rank).toSet();
            final masteredVisible = progress.masteredRanks
                .where(visibleRanks.contains)
                .length;
            final ratio = visible.isEmpty
                ? 0.0
                : masteredVisible / visible.length;
            final sample = visible.isEmpty
                ? null
                : visible[math.Random().nextInt(visible.length)];

            return Column(
              children: [
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.batch9QuranWordsMasteredSummary(
                          '$masteredVisible',
                          '${visible.length}',
                          masteredVisible,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: ratio,
                        ),
                      ),
                      if (sample != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          l10n.batch9QuranWordsFlashCard(
                            sample.transliteration,
                            sample.meaning,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF6A5A4A),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (visible.isEmpty)
                  PremiumCard(child: Text(l10n.batch9QuranWordsEmpty))
                else
                  ...visible.map((word) {
                    final mastered = progress.masteredRanks.contains(word.rank);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '#${word.rank} • ${word.transliteration}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            word.occurrences > 0
                                ? l10n.batch9QuranWordsOccurrenceSummary(
                                    word.meaning,
                                    '${word.occurrences}',
                                  )
                                : word.meaning,
                          ),
                          trailing: Checkbox(
                            value: mastered,
                            onChanged: (_) =>
                                progressNotifier.toggleMastered(word.rank),
                          ),
                          onTap: () =>
                              progressNotifier.toggleMastered(word.rank),
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
          loading: () => const PremiumCard(child: LinearProgressIndicator()),
          error: (error, _) => PremiumCard(
            child: Text(l10n.batch9QuranWordsLoadError('$error')),
          ),
        ),
      ],
    );
  }

  List<QuranCoreWord> _applyFilter(
    List<QuranCoreWord> words,
    _BandFilter filter,
    String query,
    _WordSort sort,
  ) {
    var output = words;
    switch (filter) {
      case _BandFilter.top25:
        output = words.where((item) => item.rank <= 25).toList();
        break;
      case _BandFilter.top50:
        output = words.where((item) => item.rank <= 50).toList();
        break;
      case _BandFilter.top100:
        output = words.where((item) => item.rank <= 100).toList();
        break;
      case _BandFilter.all:
        break;
    }
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      output = output.where((item) {
        return item.transliteration.toLowerCase().contains(trimmed) ||
            item.meaning.toLowerCase().contains(trimmed);
      }).toList();
    }

    switch (sort) {
      case _WordSort.mostFrequent:
        output.sort((a, b) {
          final byFreq = b.occurrences.compareTo(a.occurrences);
          if (byFreq != 0) return byFreq;
          return a.rank.compareTo(b.rank);
        });
        break;
      case _WordSort.rank:
        output.sort((a, b) => a.rank.compareTo(b.rank));
        break;
      case _WordSort.alphabetical:
        output.sort(
          (a, b) => a.transliteration.toLowerCase().compareTo(
            b.transliteration.toLowerCase(),
          ),
        );
        break;
    }
    return output;
  }
}

class _BandChip extends StatelessWidget {
  const _BandChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
