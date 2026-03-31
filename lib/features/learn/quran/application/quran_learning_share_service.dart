import 'package:share_plus/share_plus.dart';

import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_reflection_entry.dart';
import '../domain/quran_surah_insight_models.dart';

class QuranLearningShareService {
  const QuranLearningShareService._();

  static Future<void> shareText(String text) {
    return Share.share(text);
  }

  static String buildAyahInsightShareText({
    required QuranQuoteRef ref,
    required String title,
    required String summary,
    required String attribution,
    String? reflectionLabel,
    String? reflectionPrompt,
  }) {
    final lines = <String>[ref.locationLabel, title.trim()];
    final cleanedSummary = summary.trim();
    if (cleanedSummary.isNotEmpty) {
      lines.add(cleanedSummary);
    }
    final cleanedPrompt = reflectionPrompt?.trim() ?? '';
    if (cleanedPrompt.isNotEmpty) {
      lines.add('${reflectionLabel?.trim() ?? ''}: $cleanedPrompt'.trim());
    }
    lines.add(attribution.trim());
    return lines.join('\n\n');
  }

  static String buildRelatedAyahShareText({
    required QuranQuoteRef ref,
    required String label,
    required String attribution,
    String? reason,
  }) {
    final lines = <String>[ref.locationLabel, label.trim()];
    final cleanedReason = reason?.trim() ?? '';
    if (cleanedReason.isNotEmpty) {
      lines.add(cleanedReason);
    }
    lines.add(attribution.trim());
    return lines.join('\n\n');
  }

  static String buildSavedReflectionShareText({
    required QuranReflectionEntry entry,
    required String attribution,
    String? noteLabel,
    bool includeNoteExcerpt = false,
  }) {
    final lines = <String>[
      if ((entry.ref?.locationLabel ?? '').isNotEmpty) entry.ref!.locationLabel,
      entry.title.trim(),
    ];
    final cleanedSummary = entry.summary.trim();
    if (cleanedSummary.isNotEmpty) {
      lines.add(cleanedSummary);
    }
    if (includeNoteExcerpt) {
      final excerpt = _noteExcerpt(entry.note);
      if (excerpt.isNotEmpty) {
        lines.add('${noteLabel?.trim() ?? ''}: $excerpt'.trim());
      }
    }
    lines.add(attribution.trim());
    return lines.join('\n\n');
  }

  static String buildSurahInsightShareText({
    required QuranResolvedSurahInsight insight,
    required String description,
    required List<String> themes,
    required List<String> lessons,
    required String attribution,
    String? themesLabel,
    String? lessonsLabel,
  }) {
    final lines = <String>[
      '${insight.surah.transliteratedName} (${insight.surah.englishName})',
      description.trim(),
    ];
    if (themes.isNotEmpty) {
      lines.add(
        '${themesLabel?.trim() ?? ''}: ${themes.take(3).join(' • ')}'.trim(),
      );
    }
    if (lessons.isNotEmpty) {
      lines.add(
        '${lessonsLabel?.trim() ?? ''}: ${lessons.take(2).join(' • ')}'.trim(),
      );
    }
    lines.add(attribution.trim());
    return lines.join('\n\n');
  }

  static String _noteExcerpt(String? note) {
    final cleaned = (note ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return '';
    if (cleaned.length <= 180) return cleaned;
    return '${cleaned.substring(0, 177)}...';
  }
}

String firstReflectionPromptForEntry(QuranAyahEnrichmentEntry entry) {
  if (entry.reflectionPrompts.isEmpty) return '';
  return entry.reflectionPrompts.first.trim();
}
