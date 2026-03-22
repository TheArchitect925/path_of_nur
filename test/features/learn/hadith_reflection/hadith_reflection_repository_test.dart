import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/application/hadith_reflection_repository.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/application/hadith_reflection_validation.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/domain/hadith_reflection_models.dart';

void main() {
  group('HadithReflectionRepository', () {
    const repository = HadithReflectionRepository();

    test('builds a valid catalog', () {
      final catalog = repository.buildCatalog();
      expect(catalog.puzzles.length, greaterThanOrEqualTo(20));
      expect(catalog.kidsPuzzles.length, greaterThanOrEqualTo(10));
      expect(catalog.adultPuzzles.length, greaterThanOrEqualTo(10));

      final report = HadithReflectionValidation.validateCatalog(catalog);
      expect(report.isValid, isTrue);
    });

    test('daily puzzle is stable for same date and mode', () {
      final catalog = repository.buildCatalog();
      final date = DateTime(2026, 3, 21);
      final first = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: HadithReflectionMode.adult,
      );
      final second = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: HadithReflectionMode.adult,
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
        mode: HadithReflectionMode.kids,
      );
      final adult = repository.dailyPuzzleForDate(
        catalog,
        date,
        mode: HadithReflectionMode.adult,
      );

      expect(kids.puzzle.mode, HadithReflectionMode.kids);
      expect(adult.puzzle.mode, HadithReflectionMode.adult);
    });
  });
}
