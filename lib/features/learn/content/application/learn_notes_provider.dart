import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journal/application/journal_provider.dart';
import '../../quran/application/quran_providers.dart';
import '../../quran/domain/quran_note.dart';
import '../domain/learn_note_category.dart';

class LearnNotesCategoryCount {
  const LearnNotesCategoryCount({required this.category, required this.count});

  final LearnNoteCategory category;
  final int count;
}

enum LearnNotesSourceType { quran, journal }

class LearnNotesBrowseItem {
  const LearnNotesBrowseItem({
    required this.id,
    required this.sourceType,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAtIso,
    required this.tags,
    this.surahNumber,
    this.ayahNumber,
    this.referenceLabel,
  });

  final String id;
  final LearnNotesSourceType sourceType;
  final LearnNoteCategory category;
  final String title;
  final String body;
  final String createdAtIso;
  final List<String> tags;
  final int? surahNumber;
  final int? ayahNumber;
  final String? referenceLabel;

  DateTime? get createdAt => DateTime.tryParse(createdAtIso);
}

class LearnNotesSummary {
  const LearnNotesSummary({
    required this.totalCount,
    required this.quranNotesCount,
    required this.journalEntriesCount,
    required this.categoryCounts,
  });

  final int totalCount;
  final int quranNotesCount;
  final int journalEntriesCount;
  final List<LearnNotesCategoryCount> categoryCounts;
}

LearnNoteCategory deriveQuranNoteCategory(QuranNote note) {
  if (note.categoryId != null && note.categoryId!.trim().isNotEmpty) {
    return LearnNoteCategoryX.fromId(note.categoryId!.trim());
  }
  return LearnNoteCategory.quran;
}

LearnNoteCategory deriveJournalEntryCategory(JournalEntry entry) {
  if ((entry.linkedQuranRef ?? '').trim().isNotEmpty) {
    return LearnNoteCategory.quran;
  }
  if ((entry.linkedHadithRef ?? '').trim().isNotEmpty) {
    return LearnNoteCategory.hadith;
  }
  return switch (entry.type) {
    JournalEntryType.reflection ||
    JournalEntryType.gratitude => LearnNoteCategory.reflection,
    JournalEntryType.learning => LearnNoteCategory.learning,
    JournalEntryType.observation ||
    JournalEntryType.memory => LearnNoteCategory.journal,
  };
}

String learnNotesDateKey(String createdAtIso) {
  final parsed = DateTime.tryParse(createdAtIso);
  if (parsed == null) return '';
  return LocalStore.todayKey(parsed);
}

final learnNotesBrowseItemsProvider = Provider<List<LearnNotesBrowseItem>>((
  ref,
) {
  final surahMap = ref.watch(quranSurahMapProvider);
  final quranNotes = ref.watch(quranNotesProvider);
  final journalState = ref.watch(journalProvider);

  final items = <LearnNotesBrowseItem>[
    ...quranNotes.map((note) {
      final surahName =
          surahMap[note.surahNumber]?.transliteratedName ??
          'Surah ${note.surahNumber}';
      return LearnNotesBrowseItem(
        id: note.id,
        sourceType: LearnNotesSourceType.quran,
        category: deriveQuranNoteCategory(note),
        title: '$surahName ${note.surahNumber}:${note.ayahNumber}',
        body: note.text,
        createdAtIso: note.createdAtIso,
        tags: note.tags,
        surahNumber: note.surahNumber,
        ayahNumber: note.ayahNumber,
        referenceLabel: '${note.surahNumber}:${note.ayahNumber}',
      );
    }),
    ...journalState.entries.map(
      (entry) => LearnNotesBrowseItem(
        id: entry.id,
        sourceType: LearnNotesSourceType.journal,
        category: deriveJournalEntryCategory(entry),
        title: entry.title.trim().isEmpty ? 'Journal entry' : entry.title,
        body: entry.body,
        createdAtIso: entry.createdAtIso,
        tags: entry.tags,
        referenceLabel: entry.linkedQuranRef ?? entry.linkedHadithRef,
      ),
    ),
  ];

  items.sort((a, b) {
    final aDate = a.createdAt;
    final bDate = b.createdAt;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  });
  return items;
});

final learnNotesSummaryProvider = Provider<LearnNotesSummary>((ref) {
  final items = ref.watch(learnNotesBrowseItemsProvider);
  final counts = <LearnNoteCategory, int>{};
  var quranCount = 0;
  var journalCount = 0;
  for (final item in items) {
    counts[item.category] = (counts[item.category] ?? 0) + 1;
    switch (item.sourceType) {
      case LearnNotesSourceType.quran:
        quranCount++;
      case LearnNotesSourceType.journal:
        journalCount++;
    }
  }

  final categoryCounts =
      counts.entries
          .map(
            (entry) => LearnNotesCategoryCount(
              category: entry.key,
              count: entry.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));

  return LearnNotesSummary(
    totalCount: items.length,
    quranNotesCount: quranCount,
    journalEntriesCount: journalCount,
    categoryCounts: categoryCounts,
  );
});
