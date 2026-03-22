import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/ayah_completion/application/ayah_completion_repository.dart';
import 'package:path_of_nur/features/learn/ayah_completion/application/ayah_completion_validation.dart';
import 'package:path_of_nur/features/learn/ayah_completion/domain/ayah_completion_models.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';

void main() {
  group('AyahCompletionRepository', () {
    final repository = AyahCompletionRepository(
      quranRepository: QuranRepository(),
    );

    test('builds a valid catalog from canonical quran data', () {
      final catalog = repository.buildCatalog(translationCode: 'en.sahih');
      expect(catalog.puzzles.length, greaterThanOrEqualTo(20));
      expect(catalog.kidsPuzzles.length, greaterThanOrEqualTo(10));
      expect(catalog.adultPuzzles.length, greaterThanOrEqualTo(10));

      final report = AyahCompletionValidation.validateCatalog(catalog);
      expect(report.hasErrors, isFalse);
    });

    test('daily puzzle is stable for same date and mode', () {
      final catalog = repository.buildCatalog(translationCode: 'en.sahih');
      final date = DateTime(2026, 3, 21);
      final first = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: AyahCompletionMode.adult,
      );
      final second = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: AyahCompletionMode.adult,
      );
      expect(first.puzzle.id, second.puzzle.id);
      expect(first.weekdayTheme, second.weekdayTheme);
    });

    test('kids and adult daily pools can diverge', () {
      final catalog = repository.buildCatalog(translationCode: 'en.sahih');
      final date = DateTime(2026, 3, 24);
      final kids = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: AyahCompletionMode.kids,
      );
      final adult = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: AyahCompletionMode.adult,
      );
      expect(kids.puzzle.mode, AyahCompletionMode.kids);
      expect(adult.puzzle.mode, AyahCompletionMode.adult);
    });
  });
}
