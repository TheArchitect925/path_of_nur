import '../data/quran_word_timing_repository.dart';

int? resolveQuranWordHighlightIndex({
  required String arabicText,
  required Duration position,
  Duration? totalDuration,
  List<QuranWordTimingSegment> preciseSegments = const [],
  int? previousWordIndex,
}) {
  final words = _splitArabicWords(arabicText);
  if (words.isEmpty) return null;

  final elapsedMs = position.inMilliseconds < 0 ? 0 : position.inMilliseconds;

  if (preciseSegments.isNotEmpty) {
    return _resolvePreciseHighlightIndex(
      elapsedMs: elapsedMs,
      wordCount: words.length,
      preciseSegments: preciseSegments,
      previousWordIndex: previousWordIndex,
    );
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
  final transitionPoints = <int>[];
  var accumulatedMs = 0.0;
  for (final weight in weights) {
    accumulatedMs += (weight / weightSum) * durationMs;
    transitionPoints.add(accumulatedMs.round());
  }

  var index = 0;
  while (index < transitionPoints.length - 1 &&
      clampedElapsedMs > transitionPoints[index]) {
    index += 1;
  }
  if (previousWordIndex != null &&
      index == previousWordIndex + 1 &&
      previousWordIndex >= 0 &&
      previousWordIndex < transitionPoints.length &&
      clampedElapsedMs <
          transitionPoints[previousWordIndex] + _transitionHysteresisMs) {
    return previousWordIndex;
  }
  return index;
}

const _transitionHysteresisMs = 90;

int _resolvePreciseHighlightIndex({
  required int elapsedMs,
  required int wordCount,
  required List<QuranWordTimingSegment> preciseSegments,
  required int? previousWordIndex,
}) {
  final normalized =
      preciseSegments
          .map(
            (segment) => QuranWordTimingSegment(
              wordIndex: segment.wordIndex.clamp(0, wordCount - 1),
              startMs: segment.startMs < 0 ? 0 : segment.startMs,
              endMs: segment.endMs < segment.startMs
                  ? segment.startMs
                  : segment.endMs,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) => a.startMs.compareTo(b.startMs));

  var resolvedIndex = normalized.first.wordIndex;
  for (var i = 0; i < normalized.length; i += 1) {
    final segment = normalized[i];
    final nextSegment = i + 1 < normalized.length ? normalized[i + 1] : null;
    if (elapsedMs < segment.startMs) {
      resolvedIndex = segment.wordIndex;
      break;
    }
    if (elapsedMs <= segment.endMs) {
      resolvedIndex = segment.wordIndex;
      break;
    }
    if (nextSegment == null || elapsedMs < nextSegment.startMs) {
      resolvedIndex = segment.wordIndex;
      break;
    }
    resolvedIndex = nextSegment.wordIndex;
  }

  if (previousWordIndex == null) {
    return resolvedIndex;
  }

  for (var i = 0; i < normalized.length; i += 1) {
    final segment = normalized[i];
    if (segment.wordIndex != resolvedIndex) {
      continue;
    }
    if (resolvedIndex == previousWordIndex + 1 &&
        elapsedMs < segment.startMs + _transitionHysteresisMs) {
      return previousWordIndex;
    }
    if (resolvedIndex == previousWordIndex - 1 &&
        elapsedMs > segment.endMs - _transitionHysteresisMs) {
      return previousWordIndex;
    }
    return resolvedIndex;
  }

  return resolvedIndex;
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
