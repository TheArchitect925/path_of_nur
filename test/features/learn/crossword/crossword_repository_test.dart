import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/crossword/application/crossword_repository.dart';
import 'package:path_of_nur/features/learn/crossword/application/crossword_validation.dart';
import 'package:path_of_nur/features/learn/crossword/domain/crossword_models.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/prophets/data/seeded_prophets_data.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_core_word.dart';

void main() {
  group('CrosswordRepository', () {
    const repository = CrosswordRepository();

    test('builds the seeded catalog with kids and adult puzzles', () {
      final catalog = repository.buildCatalog(
        prophets: seededProphets,
        hadithEntries: seededHadithEntries,
        quranWords: const <QuranCoreWord>[
          QuranCoreWord(
            rank: 1,
            arabic: 'نور',
            transliteration: 'NOOR',
            meaning: 'light',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 2,
            arabic: 'صبر',
            transliteration: 'SABR',
            meaning: 'patience',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 3,
            arabic: 'رحمة',
            transliteration: 'RAHMAH',
            meaning: 'mercy',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 4,
            arabic: 'هدى',
            transliteration: 'HUDA',
            meaning: 'guidance',
            occurrences: 1,
          ),
        ],
      );

      expect(catalog.kidsPuzzles, hasLength(12));
      expect(catalog.adultPuzzles, hasLength(17));
      expect(catalog.entriesById.containsKey('kids_alif'), isTrue);
      expect(catalog.entriesById.containsKey('prophet_adam'), isTrue);
      expect(catalog.entriesById.containsKey('word_jummah'), isTrue);
      expect(catalog.templates, isNotEmpty);
      expect(catalog.packsById.containsKey('quran_reflection'), isTrue);
      expect(
        catalog.puzzlesById['assembled_quran_reflection']?.isAssembled,
        isTrue,
      );
    });

    test('selects a stable weekday themed daily puzzle', () {
      final catalog = repository.buildCatalog(
        prophets: seededProphets,
        hadithEntries: seededHadithEntries,
        quranWords: const <QuranCoreWord>[
          QuranCoreWord(
            rank: 1,
            arabic: 'صبر',
            transliteration: 'SABR',
            meaning: 'patience',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 2,
            arabic: 'رحمة',
            transliteration: 'RAHMAH',
            meaning: 'mercy',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 3,
            arabic: 'هدى',
            transliteration: 'HUDA',
            meaning: 'guidance',
            occurrences: 1,
          ),
        ],
      );

      final monday = repository.dailyPuzzleForDate(
        catalog,
        DateTime(2026, 3, 23),
      );
      final thursday = repository.dailyPuzzleForDate(
        catalog,
        DateTime(2026, 3, 26),
      );
      final friday = repository.dailyPuzzleForDate(
        catalog,
        DateTime(2026, 3, 27),
      );
      final fridayRepeat = repository.dailyPuzzleForDate(
        catalog,
        DateTime(2026, 3, 27, 18, 45),
      );

      expect(monday.weekdayTheme, 'quran');
      expect(
        monday.puzzle.category == 'quran' ||
            monday.puzzle.tags.contains('quran'),
        isTrue,
      );
      expect(thursday.weekdayTheme, 'duas');
      expect(
        thursday.puzzle.category == 'duas' ||
            thursday.puzzle.tags.contains('duas'),
        isTrue,
      );
      expect(friday.weekdayTheme, 'jummah');
      expect(
        friday.puzzle.dailyThemes.contains('jummah') ||
            friday.puzzle.tags.contains('jummah'),
        isTrue,
      );
      expect(fridayRepeat.dateKey, friday.dateKey);
      expect(fridayRepeat.puzzle.id, friday.puzzle.id);
    });

    test('builds pack metadata with stable progress-friendly ids', () {
      final catalog = repository.buildCatalog(
        prophets: seededProphets,
        hadithEntries: seededHadithEntries,
        quranWords: const <QuranCoreWord>[
          QuranCoreWord(
            rank: 1,
            arabic: 'صبر',
            transliteration: 'SABR',
            meaning: 'patience',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 2,
            arabic: 'رحمة',
            transliteration: 'RAHMAH',
            meaning: 'mercy',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 3,
            arabic: 'هدى',
            transliteration: 'HUDA',
            meaning: 'guidance',
            occurrences: 1,
          ),
        ],
      );

      final quranPack = catalog.packsById['quran_reflection'];

      expect(quranPack, isNotNull);
      expect(quranPack!.puzzleIds, isNotEmpty);
      expect(
        quranPack.puzzleIds.contains('assembled_quran_reflection'),
        isTrue,
      );
    });

    test('validates the generated catalog without blocking issues', () {
      final catalog = repository.buildCatalog(
        prophets: seededProphets,
        hadithEntries: seededHadithEntries,
        quranWords: const <QuranCoreWord>[
          QuranCoreWord(
            rank: 1,
            arabic: 'صبر',
            transliteration: 'SABR',
            meaning: 'patience',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 2,
            arabic: 'رحمة',
            transliteration: 'RAHMAH',
            meaning: 'mercy',
            occurrences: 1,
          ),
          QuranCoreWord(
            rank: 3,
            arabic: 'هدى',
            transliteration: 'HUDA',
            meaning: 'guidance',
            occurrences: 1,
          ),
        ],
      );

      final report = CrosswordValidation.validateCatalog(catalog);

      expect(report.isValid, isTrue);
    });

    test('reuses the same daily puzzle after it has been started', () {
      final catalog = repository.buildCatalog(
        prophets: seededProphets,
        hadithEntries: seededHadithEntries,
        quranWords: const <QuranCoreWord>[
          QuranCoreWord(
            rank: 1,
            arabic: 'صبر',
            transliteration: 'SABR',
            meaning: 'patience',
            occurrences: 1,
          ),
        ],
      );
      const state = CrosswordProgressState(
        progressByPuzzleId: {},
        dailyProgressByDateKey: {
          '2026-03-27': CrosswordDailyProgress(
            dateKey: '2026-03-27',
            puzzleId: 'adult_jummah_khutbah',
            weekdayTheme: 'jummah',
            startedAtIso: '2026-03-27T09:00:00.000',
          ),
        },
      );

      final daily = repository.dailyPuzzleForDate(
        catalog,
        DateTime(2026, 3, 27, 18),
        progressState: state,
      );

      expect(daily.puzzle.id, 'adult_jummah_khutbah');
      expect(daily.weekdayTheme, 'jummah');
    });

    test(
      'avoids a very recent daily repeat when another themed puzzle exists',
      () {
        final catalog = repository.buildCatalog(
          prophets: seededProphets,
          hadithEntries: seededHadithEntries,
          quranWords: const <QuranCoreWord>[
            QuranCoreWord(
              rank: 1,
              arabic: 'صبر',
              transliteration: 'SABR',
              meaning: 'patience',
              occurrences: 1,
            ),
            QuranCoreWord(
              rank: 2,
              arabic: 'هدى',
              transliteration: 'HUDA',
              meaning: 'guidance',
              occurrences: 1,
            ),
          ],
        );
        const state = CrosswordProgressState(
          progressByPuzzleId: {},
          dailyProgressByDateKey: {
            '2026-03-20': CrosswordDailyProgress(
              dateKey: '2026-03-20',
              puzzleId: 'adult_jummah_khutbah',
              weekdayTheme: 'jummah',
              completedAtIso: '2026-03-20T09:00:00.000',
            ),
          },
        );

        final daily = repository.dailyPuzzleForDate(
          catalog,
          DateTime(2026, 3, 27),
          progressState: state,
        );

        expect(daily.weekdayTheme, 'jummah');
        expect(daily.puzzle.id, isNot('adult_jummah_khutbah'));
      },
    );
  });
}
