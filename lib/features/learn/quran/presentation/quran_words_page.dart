import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/display/progress_bar.dart';
import '../../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_presentation_style.dart';
import '../application/quran_providers.dart';
import '../application/quran_words_provider.dart';
import '../domain/quran_core_word.dart';
import 'widgets/quran_word_study_sections.dart';
import '../../../../core/theme/app_icons.dart';

enum _BandFilter { top25, top50, top100, all }

enum _WordSort { mostFrequent, rank, alphabetical }

enum _ProgressFilter { all, learned, notLearned }

class QuranWordsPage extends ConsumerStatefulWidget {
  const QuranWordsPage({super.key});

  @override
  ConsumerState<QuranWordsPage> createState() => _QuranWordsPageState();
}

class _QuranWordsPageState extends ConsumerState<QuranWordsPage> {
  _BandFilter _filter = _BandFilter.top50;
  _WordSort _sort = _WordSort.mostFrequent;
  _ProgressFilter _progressFilter = _ProgressFilter.all;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(quranCoreWordsProvider);
    final progress = ref.watch(quranWordsProgressProvider);
    final progressNotifier = ref.read(quranWordsProgressProvider.notifier);
    final readerSettings = ref.watch(quranReaderSettingsProvider);
    final usageIndexAsync = ref.watch(quranTopWordUsageIndexProvider);
    final arabicScale = readerSettings.arabicScalePercent / 100.0;
    final transliterationScale =
        readerSettings.transliterationScalePercent / 100.0;
    final translationScale = readerSettings.translationScalePercent / 100.0;

    return AppPageScaffold(
      headerIcon: AppIcons.arabic,
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
              Text(
                l10n.batch9QuranWordsProgressFilterTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _BandChip(
                    label: l10n.batch9QuranWordsFilterAll,
                    selected: _progressFilter == _ProgressFilter.all,
                    onTap: () =>
                        setState(() => _progressFilter = _ProgressFilter.all),
                  ),
                  _BandChip(
                    label: l10n.batch9QuranWordsFilterLearned,
                    selected: _progressFilter == _ProgressFilter.learned,
                    onTap: () => setState(
                      () => _progressFilter = _ProgressFilter.learned,
                    ),
                  ),
                  _BandChip(
                    label: l10n.batch9QuranWordsFilterNotLearned,
                    selected: _progressFilter == _ProgressFilter.notLearned,
                    onTap: () => setState(
                      () => _progressFilter = _ProgressFilter.notLearned,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<_WordSort>(
                initialValue: _sort,
                isExpanded: true,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: l10n.batch9SortBy,
                  border: const OutlineInputBorder(),
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
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        wordsAsync.when(
          data: (words) {
            final visible = _applyFilter(
              words,
              _filter,
              _progressFilter,
              progress.masteredRanks,
              _query,
              _sort,
            );
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
            final usageIndex =
                usageIndexAsync.valueOrNull ??
                const <int, QuranWordUsageSummary>{};
            final usageIndexLoading =
                usageIndexAsync.isLoading && usageIndex.isEmpty;

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
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ProgressBar(value: ratio, height: 8),
                      if (sample != null) ...[
                        const SizedBox(height: 12),
                        _WordPreview(
                          word: sample,
                          arabicScale: arabicScale,
                          transliterationScale: transliterationScale,
                          translationScale: translationScale,
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
                      child: _QuranWordCard(
                        word: word,
                        mastered: mastered,
                        arabicScale: arabicScale,
                        transliterationScale: transliterationScale,
                        translationScale: translationScale,
                        usageSummary: usageIndex[word.rank],
                        usageLoading: usageIndexLoading,
                        onOpenDetail: () => context.pushNamed(
                          'quranTopWordDetail',
                          pathParameters: {'rank': word.rank.toString()},
                        ),
                        onToggleMastered: () =>
                            progressNotifier.toggleMastered(word.rank),
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
    _ProgressFilter progressFilter,
    Set<int> masteredRanks,
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

    switch (progressFilter) {
      case _ProgressFilter.all:
        break;
      case _ProgressFilter.learned:
        output = output
            .where((item) => masteredRanks.contains(item.rank))
            .toList();
        break;
      case _ProgressFilter.notLearned:
        output = output
            .where((item) => !masteredRanks.contains(item.rank))
            .toList();
        break;
    }

    final rawQuery = query.trim();
    final normalized = rawQuery.toLowerCase();
    if (normalized.isNotEmpty) {
      output = output.where((item) {
        return item.arabic.contains(rawQuery) ||
            item.transliteration.toLowerCase().contains(normalized) ||
            item.meaning.toLowerCase().contains(normalized);
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

class _QuranWordCard extends StatelessWidget {
  const _QuranWordCard({
    required this.word,
    required this.mastered,
    required this.arabicScale,
    required this.transliterationScale,
    required this.translationScale,
    required this.usageSummary,
    required this.usageLoading,
    required this.onOpenDetail,
    required this.onToggleMastered,
  });

  final QuranCoreWord word;
  final bool mastered;
  final double arabicScale;
  final double transliterationScale;
  final double translationScale;
  final QuranWordUsageSummary? usageSummary;
  final bool usageLoading;
  final VoidCallback onOpenDetail;
  final VoidCallback onToggleMastered;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compactHeader = constraints.maxWidth < 560;
              final metaRow = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _MetaPill(label: '#${word.rank}'),
                  _MetaPill(
                    label: l10n.batch9QuranWordsOccurrenceCount(
                      '${word.occurrences}',
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              );
              final learnedButton = _LearnedToggleButton(
                mastered: mastered,
                learnedLabel: l10n.batch9QuranWordsLearned,
                markLearnedLabel: l10n.batch9QuranWordsMarkLearned,
                onPressed: onToggleMastered,
              );

              if (compactHeader) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    metaRow,
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: learnedButton,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: metaRow),
                  const SizedBox(width: 8),
                  learnedButton,
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            word.arabic,
            style: AppTextStyles.arabicLearning(
              size: 28 * arabicScale,
              weight: FontWeight.w700,
            ),
            textAlign: textAlignForContent(word.arabic),
            textDirection: textDirectionForContent(word.arabic),
          ),
          const SizedBox(height: 8),
          Text(
            word.transliteration,
            style: QuranPresentationStyle.quranSupportTextStyle(
              context,
              TextStyle(
                fontSize: 16 * transliterationScale,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
              italic: true,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            word.meaning,
            style: QuranPresentationStyle.quranSupportTextStyle(
              context,
              TextStyle(fontSize: 15 * translationScale, height: 1.35),
            ),
          ),
          const SizedBox(height: 12),
          if (usageLoading)
            const LinearProgressIndicator(minHeight: 3)
          else if (usageSummary?.exampleRef != null) ...[
            Text(
              l10n.batch9QuranWordsExampleAyahTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: QuranPresentationStyle.quranSupportTextColor(context),
              ),
            ),
            const SizedBox(height: 8),
            QuranWordExampleAyahSection(
              usageSummary: usageSummary!,
              arabicScale: arabicScale,
              transliterationScale: transliterationScale,
              translationScale: translationScale,
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final compactActions = constraints.maxWidth < 420;
                if (compactActions) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => showQuranWordUsageSheet(
                          context,
                          summary: usageSummary!,
                          arabicScale: arabicScale,
                          transliterationScale: transliterationScale,
                          translationScale: translationScale,
                        ),
                        child: Text(
                          l10n.batch9QuranWordsViewOccurrences(
                            usageSummary!.ayahCount,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onOpenDetail,
                        child: Text(l10n.batch9QuranWordsOpenStudy),
                      ),
                    ],
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton(
                      onPressed: () => showQuranWordUsageSheet(
                        context,
                        summary: usageSummary!,
                        arabicScale: arabicScale,
                        transliterationScale: transliterationScale,
                        translationScale: translationScale,
                      ),
                      child: Text(
                        l10n.batch9QuranWordsViewOccurrences(
                          usageSummary!.ayahCount,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onOpenDetail,
                      child: Text(l10n.batch9QuranWordsOpenStudy),
                    ),
                  ],
                );
              },
            ),
          ] else
            Text(
              l10n.batch9QuranWordsNoUsageAvailable,
              style: TextStyle(
                color: QuranPresentationStyle.quranSupportTextColor(context),
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

class _WordPreview extends StatelessWidget {
  const _WordPreview({
    required this.word,
    required this.arabicScale,
    required this.transliterationScale,
    required this.translationScale,
  });

  final QuranCoreWord word;
  final double arabicScale;
  final double transliterationScale;
  final double translationScale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word.arabic,
          style: AppTextStyles.arabicLearning(
            size: 22 * arabicScale,
            weight: FontWeight.w700,
          ),
          textAlign: textAlignForContent(word.arabic),
          textDirection: textDirectionForContent(word.arabic),
        ),
        const SizedBox(height: 6),
        Text(
          word.transliteration,
          style: QuranPresentationStyle.quranSupportTextStyle(
            context,
            TextStyle(
              fontSize: 15 * transliterationScale,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
            italic: true,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          word.meaning,
          style: QuranPresentationStyle.quranSupportTextStyle(
            context,
            TextStyle(fontSize: 14 * translationScale, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      fillColor: const Color(0xFFF1E7D8),
      expandToWidth: false,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF47382B),
        ),
      ),
    );
  }
}

class _LearnedToggleButton extends StatelessWidget {
  const _LearnedToggleButton({
    required this.mastered,
    required this.learnedLabel,
    required this.markLearnedLabel,
    required this.onPressed,
  });

  final bool mastered;
  final String learnedLabel;
  final String markLearnedLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        mastered
            ? Icons.check_circle_rounded
            : Icons.check_circle_outline_rounded,
        size: 18,
      ),
      label: Text(mastered ? learnedLabel : markLearnedLabel),
    );
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
