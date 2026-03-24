import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progression.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_starter_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';

void main() {
  test('full Kids Arabic alphabet now has vector tracing coverage', () {
    expect(
      arabicAlphabetLetterIds.every(kidsArabicSupportsVectorTracing),
      isTrue,
    );
    expect(
      kidsArabicVectorTraceLetters.keys.toSet(),
      equals(arabicAlphabetLetterIds.toSet()),
    );
  });

  test('guide-backed fallback data still exists for all 28 letters', () {
    expect(
      arabicAlphabetLetterIds.every(
        (letterId) => kidsArabicTracingGuideFor(letterId) != null,
      ),
      isTrue,
    );
  });

  test('every vector letter has an ordered next-step path except the last', () {
    for (
      var index = 0;
      index < kidsArabicProgressionOrderIds.length;
      index += 1
    ) {
      final id = kidsArabicProgressionOrderIds[index];
      expect(kidsArabicSupportsVectorTracing(id), isTrue);
      final next = nextKidsArabicLetter(id);
      if (index == kidsArabicProgressionOrderIds.length - 1) {
        expect(next, isNull);
      } else {
        expect(next, isNotNull);
        expect(next!.id, kidsArabicProgressionOrderIds[index + 1]);
      }
    }
  });
}
