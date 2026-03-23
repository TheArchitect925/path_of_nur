import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/content/application/learn_notes_provider.dart';
import 'package:path_of_nur/features/learn/content/domain/learn_note_category.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_note_enrichment.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeNotesContainer({
  Map<String, Object> seed = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'app.onboardingCompleted': true,
    ...seed,
  });
  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase.inMemory();
  return ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(database),
    ],
  );
}

void main() {
  test('buildQuranNoteTags adds quran metadata without duplicates', () {
    final tags = buildQuranNoteTags(
      surahName: 'Al-Fatihah',
      surahNumber: 1,
      ayahNumber: 2,
      extraTags: const <String>['Quran', 'al-fatihah', 'Reflection'],
    );

    expect(tags, <String>['Quran', 'Al-Fatihah', '1:2', 'Reflection']);
  });

  test(
    'new quran notes default to quran folder and remain single records',
    () async {
      final container = await makeNotesContainer();
      addTearDown(container.dispose);

      container
          .read(quranNotesProvider.notifier)
          .addNote(
            surahNumber: 2,
            ayahNumber: 255,
            text: 'Ayat al-Kursi reflection',
            tags: buildQuranNoteTags(
              surahName: 'Al-Baqarah',
              surahNumber: 2,
              ayahNumber: 255,
              extraTags: const <String>['Quran', '2:255'],
            ),
            folder: '',
          );

      final notes = container.read(quranNotesProvider);
      expect(notes, hasLength(1));
      expect(notes.first.folder, quranNotesDefaultFolder);
      expect(notes.first.categoryId, LearnNoteCategory.quran.id);
      expect(notes.first.tags, <String>['Quran', 'Al-Baqarah', '2:255']);
    },
  );

  test(
    'legacy quran notes without category stay readable and derive quran safely',
    () async {
      final container = await makeNotesContainer(
        seed: <String, Object>{
          'learn.quran.notes': jsonEncode([
            {
              'id': 'legacy-1',
              'surahNumber': 1,
              'ayahNumber': 1,
              'text': 'Legacy note',
              'createdAtIso': '2026-03-22T12:00:00.000',
              'tags': ['Al-Fatihah'],
              'folder': 'General',
            },
          ]),
        },
      );
      addTearDown(container.dispose);

      final notes = container.read(quranNotesProvider);
      final items = container.read(learnNotesBrowseItemsProvider);

      expect(notes, hasLength(1));
      expect(notes.first.categoryId, isNull);
      expect(deriveQuranNoteCategory(notes.first), LearnNoteCategory.quran);
      expect(items, hasLength(1));
      expect(items.first.category, LearnNoteCategory.quran);
    },
  );
}
