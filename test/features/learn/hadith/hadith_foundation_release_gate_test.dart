import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/hadith/data/generated_hadith_foundation_data.dart';

void main() {
  test(
    'canonical hadith dataset is launch-ready for verified text and source coverage',
    () {
      final missingVerifiedTranslation = generatedHadithEntries
          .where((entry) => !entry.hasVerifiedTranslation)
          .map((entry) => entry.id)
          .toList(growable: false);
      final missingVerifiedArabic = generatedHadithEntries
          .where((entry) => !entry.hasVerifiedArabicMatn)
          .map((entry) => entry.id)
          .toList(growable: false);
      final missingReference = generatedHadithEntries
          .where(
            (entry) =>
                entry.displaySourceReference == null ||
                entry.displaySourceReference!.trim().isEmpty ||
                !entry.isSourceBacked,
          )
          .map((entry) => entry.id)
          .toList(growable: false);
      final unverifiedTransliterationText = generatedHadithEntries
          .where(
            (entry) =>
                !entry.hasVerifiedTransliteration && entry.hasTransliteration,
          )
          .map((entry) => entry.id)
          .toList(growable: false);

      expect(missingVerifiedTranslation, isEmpty);
      expect(missingVerifiedArabic, isEmpty);
      expect(missingReference, isEmpty);
      expect(unverifiedTransliterationText, isEmpty);
    },
  );
}
