import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as q;

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_surah.dart';
import '../widgets/learn_hub_page_scaffold.dart';

class QuranAppHubPage extends ConsumerStatefulWidget {
  const QuranAppHubPage({super.key});

  @override
  ConsumerState<QuranAppHubPage> createState() => _QuranAppHubPageState();
}

class _QuranAppHubPageState extends ConsumerState<QuranAppHubPage> {
  int _selectedJuz = 1;

  static const List<int> _featuredSurahNumbers = <int>[
    1,
    2,
    18,
    36,
    55,
    67,
    112,
    113,
    114,
  ];

  static const List<int> _mostRecitedSurahNumbers = <int>[
    87,
    88,
    89,
    93,
    94,
    95,
    96,
    97,
    99,
    100,
    103,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
  ];

  @override
  Widget build(BuildContext context) {
    final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
    final dailyVerse = ref.watch(quranDailyVerseProvider);
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final selectedJuzSummary = _QuranJuzSummary.fromJuz(
      _selectedJuz,
      surahMap,
    );
    final selectedJuzSurahs = selectedJuzSummary.surahsInJuz;
    final featuredSurahs = _surahsFromNumbers(
      surahMap,
      _featuredSurahNumbers,
    );
    final shortSurahs = _surahsFromNumbers(
      surahMap,
      _mostRecitedSurahNumbers,
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: 'Holy Qur’an',
      subtitle:
          'A focused reading and recitation space with quick access to continue, search, and browse by juz.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reader & Reciter',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                '${continueSummary.surahName} ${continueSummary.surahNumber}:${continueSummary.ayahNumber}',
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      'quranReader',
                      pathParameters: {
                        'surahNumber': continueSummary.surahNumber.toString(),
                      },
                      queryParameters: {
                        'ayah': continueSummary.ayahNumber.toString(),
                      },
                    ),
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    label: const Text('Continue Reading'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('quranExplorer'),
                    icon: const Icon(Icons.library_books_rounded),
                    label: const Text('Surah Explorer'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('quranSearch'),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Search'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('learnQuranLearning'),
                    icon: const Icon(Icons.school_rounded),
                    label: const Text('Open Learning'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today’s Recitation Anchor',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(dailyVerse.locationLabel),
              const SizedBox(height: 4),
              Text(
                dailyVerse.translation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {'surahNumber': dailyVerse.surahNumber.toString()},
                  queryParameters: {'ayah': dailyVerse.ayahNumber.toString()},
                ),
                icon: const Icon(Icons.auto_stories_rounded),
                label: const Text('Open Verse'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bookmarks',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${bookmarks.length} saved locations'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.pushNamed('quranBookmarks'),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${notes.length} reflections saved'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.pushNamed('quranNotes'),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SectionHeader(
          title: 'Featured Surahs',
          subtitle: 'A calmer starting shelf for often-opened and well-loved recitation.',
        ),
        const SizedBox(height: 8),
        ...featuredSurahs.map(
          (surah) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SurahQuickAccessCard(
              surah: surah,
              subtitle:
                  '${surah.englishName} • ${surah.verseCount} ayat • ${surah.revelationClassification}',
            ),
          ),
        ),
        const SizedBox(height: 12),
        _SectionHeader(
          title: 'Short Surahs',
          subtitle:
              'A lighter collection for frequent recitation, memorization, and prayer review.',
        ),
        const SizedBox(height: 8),
        ...shortSurahs.map(
          (surah) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SurahQuickAccessCard(
              surah: surah,
              subtitle:
                  '${surah.englishName} • ${surah.verseCount} ayat • Surah ${surah.number}',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Browse by Juz',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Move through the Qur’an in a calmer reading rhythm, one juz at a time.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceSubtle,
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedPillControl<int>(
                items: List<int>.generate(q.totalJuzCount, (index) => index + 1),
                selectedItem: _selectedJuz,
                labelBuilder: (juz) => 'Juz $juz',
                onChanged: (value) => setState(() => _selectedJuz = value),
              ),
              const SizedBox(height: 12),
              Text(
                'Juz ${selectedJuzSummary.number}',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(selectedJuzSummary.startLabel),
              const SizedBox(height: 4),
              Text(
                'to ${selectedJuzSummary.endLabel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {
                    'surahNumber': selectedJuzSummary.startSurahNumber.toString(),
                  },
                  queryParameters: {
                    'ayah': selectedJuzSummary.startAyah.toString(),
                  },
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Open Juz'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...selectedJuzSurahs.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${item.surah.number}. ${item.surah.transliteratedName}',
                ),
                subtitle: Text(
                  '${item.surah.englishName} • Ayahs ${item.startAyah}-${item.endAyah} in this juz',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed(
                  'quranReader',
                  pathParameters: {'surahNumber': item.surah.number.toString()},
                  queryParameters: {'ayah': item.startAyah.toString()},
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Surah Explorer',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Open the full directory when you want the complete Qur’an in one searchable place.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranExplorer'),
                icon: const Icon(Icons.library_books_rounded),
                label: const Text('Open Full Explorer'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<QuranSurah> _surahsFromNumbers(
    Map<int, QuranSurah> surahMap,
    List<int> numbers,
  ) {
    return numbers
        .map((number) => surahMap[number])
        .whereType<QuranSurah>()
        .toList(growable: false);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceSubtle,
          ),
        ),
      ],
    );
  }
}

class _SurahQuickAccessCard extends StatelessWidget {
  const _SurahQuickAccessCard({required this.surah, required this.subtitle});

  final QuranSurah surah;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('${surah.number}. ${surah.transliteratedName}'),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': surah.number.toString()},
        ),
      ),
    );
  }
}

class _QuranJuzSummary {
  const _QuranJuzSummary({
    required this.number,
    required this.startSurahNumber,
    required this.startAyah,
    required this.startLabel,
    required this.endLabel,
    required this.surahCount,
    required this.surahsInJuz,
  });

  factory _QuranJuzSummary.fromJuz(
    int juzNumber,
    Map<int, QuranSurah> surahMap,
  ) {
    final verses = q.getSurahAndVersesFromJuz(juzNumber);
    final orderedEntries = verses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final first = orderedEntries.first;
    final last = orderedEntries.last;
    final startSurah = surahMap[first.key];
    final endSurah = surahMap[last.key];
    final startLabel =
        '${startSurah?.transliteratedName ?? 'Surah ${first.key}'} ${first.value.first}';
    final endLabel =
        '${endSurah?.transliteratedName ?? 'Surah ${last.key}'} ${last.value.last}';

    return _QuranJuzSummary(
      number: juzNumber,
      startSurahNumber: first.key,
      startAyah: first.value.first,
      startLabel: startLabel,
      endLabel: endLabel,
      surahCount: orderedEntries.length,
      surahsInJuz: orderedEntries
          .map(
            (entry) => _QuranJuzSurah(
              surah: surahMap[entry.key]!,
              startAyah: entry.value.first,
              endAyah: entry.value.last,
            ),
          )
          .toList(growable: false),
    );
  }

  final int number;
  final int startSurahNumber;
  final int startAyah;
  final String startLabel;
  final String endLabel;
  final int surahCount;
  final List<_QuranJuzSurah> surahsInJuz;
}

class _QuranJuzSurah {
  const _QuranJuzSurah({
    required this.surah,
    required this.startAyah,
    required this.endAyah,
  });

  final QuranSurah surah;
  final int startAyah;
  final int endAyah;
}
