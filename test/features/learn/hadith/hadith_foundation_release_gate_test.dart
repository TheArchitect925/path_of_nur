import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';

void main() {
  test(
    'canonical hadith dataset is launch-ready for verified text and source coverage',
    () {
      final missingVerifiedTranslation = seededHadithEntries
          .where((entry) => !entry.hasVerifiedTranslation)
          .map((entry) => entry.id)
          .toList(growable: false);
      final missingVerifiedArabic = seededHadithEntries
          .where((entry) => !entry.hasVerifiedArabicMatn)
          .map((entry) => entry.id)
          .toList(growable: false);
      final missingReference = seededHadithEntries
          .where(
            (entry) =>
                entry.displaySourceReference == null ||
                entry.displaySourceReference!.trim().isEmpty ||
                !entry.isSourceBacked,
          )
          .map((entry) => entry.id)
          .toList(growable: false);
      final unverifiedTransliterationText = seededHadithEntries
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
