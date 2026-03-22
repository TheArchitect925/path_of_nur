import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/word_search/application/word_search_repository.dart';
import 'package:path_of_nur/features/learn/word_search/application/word_search_validation.dart';
import 'package:path_of_nur/features/learn/word_search/domain/word_search_models.dart';

void main() {
  group('WordSearchRepository', () {
    const repository = WordSearchRepository();

    test('builds a valid catalog', () {
      final catalog = repository.buildCatalog();
      expect(catalog.puzzles.length, greaterThanOrEqualTo(20));
      expect(catalog.kidsPuzzles.length, greaterThanOrEqualTo(10));
      expect(catalog.adultPuzzles.length, greaterThanOrEqualTo(10));

      final report = WordSearchValidation.validateCatalog(catalog);
      expect(report.hasErrors, isFalse);
    });

    test('daily puzzle is stable for same date and mode', () {
      final catalog = repository.buildCatalog();
      final date = DateTime(2026, 3, 21);
      final first = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: WordSearchMode.adult,
      );
      final second = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: WordSearchMode.adult,
      );
      expect(first.puzzle.id, second.puzzle.id);
      expect(first.weekdayTheme, second.weekdayTheme);
    });

    test('kids and adult daily pools can diverge', () {
      final catalog = repository.buildCatalog();
      final date = DateTime(2026, 3, 24);
      final kids = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: WordSearchMode.kids,
      );
      final adult = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: WordSearchMode.adult,
      );
      expect(kids.puzzle.mode, WordSearchMode.kids);
      expect(adult.puzzle.mode, WordSearchMode.adult);
    });
  });
}
