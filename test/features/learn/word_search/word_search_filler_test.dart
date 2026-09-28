import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/word_search/application/word_search_repository.dart';
import 'package:path_of_nur/features/learn/word_search/domain/word_search_models.dart';

void main() {
  group('word search filler letters', () {
    const repository = WordSearchRepository();

    Set<String> placementCells(WordSearchPuzzle puzzle) {
      final cells = <String>{};
      for (final placement in puzzle.placements) {
        final rowStep = (placement.endRow - placement.startRow).sign;
        final colStep = (placement.endCol - placement.startCol).sign;
        for (var i = 0; i < placement.word.length; i += 1) {
          cells.add(
            '${placement.startRow + rowStep * i}:${placement.startCol + colStep * i}',
          );
        }
      }
      return cells;
    }

    test('filler is not the answers laid out in order', () {
      // The old filler copied the target words' letters into the empty cells
      // one after another, so a board with RAHMAH, HUDA, TAQWA and KITAB read
      // "RAHMAHUDAR / TAQWAAHMAH / KITABTAQWA" and was full of decoys.
      final catalog = repository.buildCatalog();
      final puzzle = catalog.puzzlesById['ws_adult_08']!;
      final placed = placementCells(puzzle);
      final answerLetters = puzzle.targetWords.join().split('').toSet();

      final fillerLetters = <String>[];
      for (var row = 0; row < puzzle.gridSize; row += 1) {
        for (var col = 0; col < puzzle.gridSize; col += 1) {
          if (placed.contains('$row:$col')) continue;
          fillerLetters.add(puzzle.letterGrid[row][col]);
        }
      }

      expect(fillerLetters, isNotEmpty);
      // A seeded draw from the whole alphabet reaches letters no target uses.
      expect(
        fillerLetters.any((letter) => !answerLetters.contains(letter)),
        isTrue,
      );
      // And it does not reproduce a target word wholesale in the filler run.
      final run = fillerLetters.join();
      for (final word in puzzle.targetWords) {
        expect(run.contains(word), isFalse, reason: '$word leaked into filler');
      }
    });

    test('a board is identical every time it is built', () {
      final first = repository.buildCatalog().puzzlesById['ws_adult_08']!;
      final second = repository.buildCatalog().puzzlesById['ws_adult_08']!;
      expect(first.letterGrid, second.letterGrid);
    });

    test('every placement still spells its word', () {
      final catalog = repository.buildCatalog();
      for (final puzzle in catalog.puzzles) {
        for (final placement in puzzle.placements) {
          final rowStep = (placement.endRow - placement.startRow).sign;
          final colStep = (placement.endCol - placement.startCol).sign;
          final spelled = StringBuffer();
          for (var i = 0; i < placement.word.length; i += 1) {
            spelled.write(
              puzzle.letterGrid[placement.startRow +
                  rowStep * i][placement.startCol + colStep * i],
            );
          }
          expect(spelled.toString(), placement.word, reason: puzzle.id);
        }
      }
    });
  });
}
