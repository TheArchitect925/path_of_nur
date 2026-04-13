import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/hadith_foundation_models.dart';

class HadithReaderShareService {
  const HadithReaderShareService._();

  static Future<void> shareText(BuildContext context, String text) {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    return Share.share(text, sharePositionOrigin: origin);
  }

  static String buildReaderShareText({
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

  static String buildCompactShareText({
    required HadithEntry entry,
    required String formattedReference,
  }) {
    final summary = _compactSummary(entry);
    final metadata = <String>[
      entry.displaySourceCollectionTitle.trim(),
      if (formattedReference.trim().isNotEmpty) formattedReference.trim(),
      if (entry.standardizedGrade.displayLabel.trim().isNotEmpty)
        entry.standardizedGrade.displayLabel.trim(),
    ].where((item) => item.isNotEmpty).join(' • ');

    final lines = <String>[
      entry.title.trim(),
      if (summary.isNotEmpty) summary,
      if (metadata.isNotEmpty) metadata,
    ];
    return lines.join('\n\n');
  }

  static String _compactSummary(HadithEntry entry) {
    final excerpt = entry.excerpt.trim();
    if (excerpt.isNotEmpty) return excerpt;
    final translation = entry.translation.trim();
    if (translation.length <= 220) return translation;
    return '${translation.substring(0, 217).trimRight()}...';
  }
}
