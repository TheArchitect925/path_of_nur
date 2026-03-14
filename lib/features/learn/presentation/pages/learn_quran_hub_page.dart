import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_block.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../hadith/application/hadith_foundation_repository.dart';
import '../../hadith/domain/hadith_foundation_models.dart';
import '../../quran/application/quran_learning_system_service.dart';
import '../../quran/domain/quran_learning_models.dart';
import '../models/learn_category_item.dart';
import '../widgets/learn_category_grid.dart';
import '../widgets/learn_hub_page_scaffold.dart';

enum _QuranLearningTab { understand, reflect, paths, memorize }

class LearnQuranHubPage extends ConsumerStatefulWidget {
  const LearnQuranHubPage({super.key});

  @override
  ConsumerState<LearnQuranHubPage> createState() => _LearnQuranHubPageState();
}

class _LearnQuranHubPageState extends ConsumerState<LearnQuranHubPage> {
  _QuranLearningTab _tab = _QuranLearningTab.understand;

  static const List<LearnCategoryItem> _quranTools = [
    LearnCategoryItem(
      id: 'quran-top-words',
      title: 'Top Quran Words',
      iconKey: 'top_words',
      routeName: 'quranTopWords',
      searchKeywords: ['words', 'vocabulary'],
      tags: ['quran'],
      sectionType: 'module',
    ),
    LearnCategoryItem(
      id: 'quran-word-review',
      title: 'Word Review',
      iconKey: 'word_review',
      routeName: 'quranWordReview',
      searchKeywords: ['word review', 'flashcards'],
      tags: ['quran'],
      sectionType: 'module',
    ),
    LearnCategoryItem(
      id: 'quran-universe',
      title: 'Qur’an Universe',
      iconKey: 'quran_universe',
      routeName: 'quranUniverse',
      searchKeywords: ['quran universe', 'connections', 'themes', 'locations'],
      tags: ['quran', 'exploration'],
      sectionType: 'module',
    ),
    LearnCategoryItem(
      id: 'quran-topics',
      title: 'Qur’an Topics',
      iconKey: 'quran_universe',
      routeName: 'quranTopicExplorer',
      searchKeywords: ['topics', 'patience', 'mercy', 'justice', 'guidance'],
      tags: ['quran', 'knowledge graph'],
      sectionType: 'module',
    ),
    LearnCategoryItem(
      id: 'quran-notes',
      title: 'Quran Notes',
      iconKey: 'notes',
      routeName: 'quranNotes',
      searchKeywords: ['notes', 'reflection'],
      tags: ['quran'],
      sectionType: 'module',
    ),
    LearnCategoryItem(
      id: 'quran-names-of-allah',
      title: '99 Names of Allah',
      iconKey: 'allah_names',
      routeName: 'quranNamesOfAllah',
      searchKeywords: ['99 names', 'asma ul husna', 'allah names'],
      tags: ['quran', 'reflection'],
      sectionType: 'module',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final verses = ref.watch(quranLearningVersesProvider);
    final paths = ref.watch(quranLearningPathsProvider);
    final memorization = ref.watch(quranMemorizationProgressProvider);
    final dueReviews = ref.watch(quranMemorizationDueProvider);
    final memorizationCoverage = ref.watch(quranMemorizationCoverageProvider);
    final dailyVerse = ref.watch(quranDailyReflectionVerseProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.school_rounded,
      title: 'Qur’an Learning',
      subtitle:
          'Understanding, reflection, guided paths, memorization, and deeper Qur’an study in one calmer learning space.',
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
                'Keep your practical reading flow separate from study and reflection.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('learnQuranHub'),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Open Holy Qur’an'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.pushNamed('learnQuranArabic'),
                  icon: const Icon(Icons.translate_rounded),
                  label: const Text('Open Learn Qur’anic Arabic'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SegmentedPillControl<_QuranLearningTab>(
          items: _QuranLearningTab.values,
          selectedItem: _tab,
          labelBuilder: _tabLabel,
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 12),
        if (_tab == _QuranLearningTab.understand) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Understand',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Study explanation, related hadith, and concise lessons from selected verses.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...verses.map((verse) {
            final hadithEntries = verse.relatedHadith
                .map((id) => ref.watch(hadithEntryByIdProvider(id)))
                .whereType<HadithEntry>()
                .toList(growable: false);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text('Qur’an ${verse.surah}:${verse.ayah}'),
                  subtitle: Text(verse.translation),
                  children: [
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        verse.arabicText,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(verse.explanation),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Key Lessons',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...verse.lessons.map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $item'),
                        ),
                      ),
                    ),
                    if (hadithEntries.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Related Hadith',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hadithEntries
                            .map(
                              (item) => ActionChip(
                                label: Text(item.title),
                                onPressed: () => context.pushNamed(
                                  'hadithLessonDetail',
                                  pathParameters: {'lessonId': item.id},
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.tonalIcon(
                        onPressed: () => context.pushNamed(
                          'quranReader',
                          pathParameters: {'surahNumber': '${verse.surah}'},
                          queryParameters: {'ayah': '${verse.ayah}'},
                        ),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Open in Reader'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        if (_tab == _QuranLearningTab.reflect) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Reflection',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                QuranReferenceBlock(
                  surahNumber: dailyVerse.surah,
                  ayahStart: dailyVerse.ayah,
                  ayahEnd: dailyVerse.ayah,
                  dense: true,
                ),
                const SizedBox(height: 8),
                Text(dailyVerse.explanation),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('journalCreate'),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Write Reflection Journal'),
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
                  'Reflection Prompts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...dailyVerse.reflectionPrompts.map(
                  (prompt) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $prompt'),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    'quranReader',
                    pathParameters: {'surahNumber': '${dailyVerse.surah}'},
                    queryParameters: {'ayah': '${dailyVerse.ayah}'},
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Read Full Context'),
                ),
              ],
            ),
          ),
        ],
        if (_tab == _QuranLearningTab.paths) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guided Paths',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Follow thematic pathways for focused Qur’an learning.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...paths.map((path) {
            final completed = path.verseIds
                .where(
                  (id) => memorization[id]?.stage == MemorizationStage.mastered,
                )
                .length;
            final ratio = path.verseIds.isEmpty
                ? 0.0
                : (completed / path.verseIds.length).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _openPathSheet(context, path),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          path.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(path.description),
                        const SizedBox(height: 8),
                        Text(
                          '$completed / ${path.verseIds.length} mastered',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 7,
                            value: ratio,
                            backgroundColor: AppColors.surface.withValues(
                              alpha: 0.4,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onSurface.withValues(alpha: 0.72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
        if (_tab == _QuranLearningTab.memorize) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memorize',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Use repetition, phrase practice, hidden recall, and spaced review to strengthen memorization.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Coverage: ${(memorizationCoverage * 100).round()}% • Due today: ${dueReviews.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (dueReviews.isNotEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spaced Repetition Review',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...dueReviews.take(5).map((item) {
                    final verse = ref.watch(
                      quranLearningVerseByIdProvider(item.verseId),
                    );
                    if (verse == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.surface.withValues(alpha: 0.22),
                          border: Border.all(
                            color: AppColors.accentGoldSoft.withValues(
                              alpha: 0.28,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Qur’an ${verse.surah}:${verse.ayah}'),
                            const SizedBox(height: 4),
                            Text(
                              'Stage: ${_stageLabel(item.stage)} • Next: ${_dateLabel(item.nextReview)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton.tonal(
                                  onPressed: () => ref
                                      .read(
                                        quranMemorizationProgressProvider
                                            .notifier,
                                      )
                                      .markReviewed(
                                        item.verseId,
                                        success: true,
                                      ),
                                  child: const Text('Reviewed Well'),
                                ),
                                FilledButton.tonal(
                                  onPressed: () => ref
                                      .read(
                                        quranMemorizationProgressProvider
                                            .notifier,
                                      )
                                      .markReviewed(
                                        item.verseId,
                                        success: false,
                                        targetStage:
                                            MemorizationStage.repeating,
                                      ),
                                  child: const Text('Needs Repetition'),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => context.pushNamed(
                                    'quranReader',
                                    pathParameters: {
                                      'surahNumber': '${verse.surah}',
                                    },
                                    queryParameters: {'ayah': '${verse.ayah}'},
                                  ),
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text('Recite Verse'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          const SizedBox(height: 10),
          ...verses.map((verse) {
            final item = memorization[verse.id];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Qur’an ${verse.surah}:${verse.ayah}'),
                  subtitle: Text(
                    item == null
                        ? 'Not started'
                        : '${_stageLabel(item.stage)} • Next review ${_dateLabel(item.nextReview)}',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ref
                        .read(quranMemorizationProgressProvider.notifier)
                        .getOrCreate(verse.id);
                    context.pushNamed(
                      'quranReader',
                      pathParameters: {'surahNumber': '${verse.surah}'},
                      queryParameters: {'ayah': '${verse.ayah}'},
                    );
                  },
                ),
              ),
            );
          }),
        ],
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qur’an Tools',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              LearnCategoryGrid(
                items: _quranTools,
                onTap: (item) => context.pushNamed(
                  item.routeName,
                  pathParameters: item.pathParameters,
                  queryParameters: item.queryParameters,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _tabLabel(_QuranLearningTab tab) {
    switch (tab) {
      case _QuranLearningTab.understand:
        return 'Understand';
      case _QuranLearningTab.reflect:
        return 'Reflect';
      case _QuranLearningTab.paths:
        return 'Paths';
      case _QuranLearningTab.memorize:
        return 'Memorize';
    }
  }

  String _stageLabel(MemorizationStage stage) {
    switch (stage) {
      case MemorizationStage.newVerse:
        return 'New Verse';
      case MemorizationStage.repeating:
        return 'Repeating';
      case MemorizationStage.phrasePractice:
        return 'Phrase Practice';
      case MemorizationStage.hiddenRecall:
        return 'Hidden Recall';
      case MemorizationStage.mastered:
        return 'Mastered';
    }
  }

  String _dateLabel(DateTime date) {
    final value = DateTime(date.year, date.month, date.day);
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  Future<void> _openPathSheet(
    BuildContext context,
    QuranLearningPath path,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final verses = path.verseIds
            .map((id) => ref.read(quranLearningVerseByIdProvider(id)))
            .whereType<QuranLearningVerse>()
            .toList(growable: false);

        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Text(path.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(path.description),
              const SizedBox(height: 12),
              ...verses.map(
                (verse) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Qur’an ${verse.surah}:${verse.ayah}'),
                  subtitle: Text(verse.translation),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.pushNamed(
                      'quranReader',
                      pathParameters: {'surahNumber': '${verse.surah}'},
                      queryParameters: {'ayah': '${verse.ayah}'},
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
