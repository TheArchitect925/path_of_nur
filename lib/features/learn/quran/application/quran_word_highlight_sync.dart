import '../data/quran_word_timing_repository.dart';

int? resolveQuranWordHighlightIndex({
  required String arabicText,
  required Duration position,
  Duration? totalDuration,
  List<QuranWordTimingSegment> preciseSegments = const [],
}) {
  final words = _splitArabicWords(arabicText);
  if (words.isEmpty) return null;

  final elapsedMs = position.inMilliseconds < 0 ? 0 : position.inMilliseconds;

  if (preciseSegments.isNotEmpty) {
    var active = preciseSegments.first.wordIndex.clamp(0, words.length - 1);
    for (final segment in preciseSegments) {
      final segmentIndex = segment.wordIndex.clamp(0, words.length - 1);
      if (elapsedMs < segment.startMs) {
        return segmentIndex;
      }
      if (elapsedMs <= segment.endMs) {
        return segmentIndex;
      }
      active = segmentIndex;
    }
    return active;
  }

  final durationMs = totalDuration?.inMilliseconds ?? 0;
  if (durationMs <= 0) return 0;

  final clampedElapsedMs = elapsedMs.clamp(0, durationMs);
  final weights = words
      .map((word) => _approxWordWeight(word))
      .toList(growable: false);
  final weightSum = weights
      .fold<int>(0, (sum, value) => sum + value)
      .clamp(1, 1000000);
  final cumulative = <int>[];
  var accumulatedMs = 0;
  for (final weight in weights) {
    accumulatedMs += ((weight / weightSum) * durationMs).round();
    cumulative.add(accumulatedMs);
  }

  var index = 0;
  while (index < cumulative.length - 1 &&
      clampedElapsedMs > cumulative[index]) {
    index += 1;
  }
  return index;
}

List<String> _splitArabicWords(String text) {
  return text
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
}

int _approxWordWeight(String word) {
  final normalized = word
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      .replaceAll('ـ', '');
  return normalized.isEmpty ? 1 : normalized.length.clamp(1, 14);
}
