import 'package:share_plus/share_plus.dart';

import '../domain/hadith_foundation_models.dart';

class HadithReaderShareService {
  const HadithReaderShareService._();

  static Future<void> shareText(String text) {
    return Share.share(text);
  }

  static String buildShareText({
    required HadithEntry entry,
    required String sourceLabel,
    required String referenceLabel,
    required String formattedReference,
    required String gradeLabel,
    required String narratorLabel,
    required String translationLabel,
  }) {
    final lines = <String>[
      entry.title.trim(),
      if (entry.hasArabicMatn) entry.arabicMatn!.trim(),
      '$translationLabel: ${entry.translation.trim()}',
      '$sourceLabel: ${entry.displaySourceCollectionTitle}',
      if (formattedReference.trim().isNotEmpty)
        '$referenceLabel: ${formattedReference.trim()}',
      if (entry.standardizedGrade.displayLabel.trim().isNotEmpty)
        '$gradeLabel: ${entry.standardizedGrade.displayLabel.trim()}',
      if ((entry.normalizedNarratorName ?? '').trim().isNotEmpty)
        '$narratorLabel: ${entry.normalizedNarratorName!.trim()}',
    ];

    return lines.join('\n\n');
  }
}
