import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/matching/application/matching_repository.dart';
import 'package:path_of_nur/features/learn/matching/application/matching_validation.dart';
import 'package:path_of_nur/features/learn/matching/domain/matching_models.dart';

void main() {
  group('MatchingRepository', () {
    const repository = MatchingRepository();

    test('builds a valid catalog', () {
      final catalog = repository.buildCatalog();
      expect(catalog.puzzles.length, greaterThanOrEqualTo(20));
      expect(catalog.kidsPuzzles.length, greaterThanOrEqualTo(10));
      expect(catalog.adultPuzzles.length, greaterThanOrEqualTo(10));

      final report = MatchingValidation.validateCatalog(catalog);
      expect(report.hasErrors, isFalse);
    });

    test('daily puzzle is stable for same date and mode', () {
      final catalog = repository.buildCatalog();
      final date = DateTime(2026, 3, 21);
      final first = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: MatchingMode.adult,
      );
      final second = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: MatchingMode.adult,
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
        mode: MatchingMode.kids,
      );
      final adult = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: MatchingMode.adult,
      );

      expect(kids.puzzle.mode, MatchingMode.kids);
      expect(adult.puzzle.mode, MatchingMode.adult);
    });
  });
}
