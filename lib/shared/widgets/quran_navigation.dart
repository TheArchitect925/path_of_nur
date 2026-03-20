import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'quran_quote_block.dart';

void openQuranAt(
  BuildContext context, {
  required int surahNumber,
  required int ayahNumber,
  int? endAyahNumber,
  bool autoplay = false,
}) {
  openQuranReaderLocation(
    context,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    endAyahNumber: endAyahNumber,
    autoplay: autoplay,
  );
}

void openQuranReaderLocation(
  BuildContext context, {
  required int surahNumber,
  int? ayahNumber,
  int? endAyahNumber,
  bool autoplay = false,
}) {
  final queryParameters = <String, String>{};
  if (ayahNumber != null && ayahNumber > 0) {
    queryParameters['ayah'] = ayahNumber.toString();
  }
  if (endAyahNumber != null &&
      endAyahNumber > 0 &&
      endAyahNumber >= (ayahNumber ?? endAyahNumber)) {
    queryParameters['endAyah'] = endAyahNumber.toString();
  }
  if (autoplay) {
    queryParameters['autoplay'] = '1';
  }

  context.pushNamed(
    'quranReader',
    pathParameters: {'surahNumber': surahNumber.toString()},
    queryParameters: queryParameters,
  );
}

void openQuranReferenceLocation(
  BuildContext context, {
  required QuranQuoteRef ref,
  bool autoplay = false,
}) {
  openQuranAt(
    context,
    surahNumber: ref.surah,
    ayahNumber: ref.ayah,
    endAyahNumber: ref.ayahEnd,
    autoplay: autoplay,
  );
}

void openQuranReferenceRange(
  BuildContext context, {
  required int surahNumber,
  String? verseRange,
  int? fallbackStartAyah,
  bool autoplay = false,
}) {
  final parsedRange = parseQuranAyahRange(verseRange);
  final effectiveStartAyah = fallbackStartAyah ?? parsedRange.startAyah;
  openQuranReaderLocation(
    context,
    surahNumber: surahNumber,
    ayahNumber: effectiveStartAyah,
    endAyahNumber: parsedRange.endAyah,
    autoplay: autoplay,
  );
}

({int? startAyah, int? endAyah}) parseQuranAyahRange(String? raw) {
  final normalized = (raw ?? '')
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .trim();
  if (normalized.isEmpty) {
    return (startAyah: null, endAyah: null);
  }

  final firstChunk = normalized.split(',').first.trim();
  if (firstChunk.isEmpty) {
    return (startAyah: null, endAyah: null);
  }

  if (firstChunk.contains(':')) {
    final ayahPart = firstChunk.split(':').last.trim();
    return parseQuranAyahRange(ayahPart);
  }

  if (!firstChunk.contains('-')) {
    final singleAyah = int.tryParse(firstChunk);
    return (startAyah: singleAyah, endAyah: singleAyah);
  }

  final parts = firstChunk.split('-');
  final startAyah = int.tryParse(parts.first.trim());
  final endAyah = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;
  return (startAyah: startAyah, endAyah: endAyah ?? startAyah);
}

void openQuranQuoteLocation(BuildContext context, QuranQuote quote) {
  openQuranReferenceLocation(
    context,
    ref: quote.ref,
    autoplay: true,
  );
}
