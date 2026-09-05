import 'bedtime_story_models.dart';

/// One page of a story as a child turns it: a picture and a few short lines.
class KidsStoryPage {
  const KidsStoryPage({
    required this.index,
    required this.lines,
    required this.illustrationAsset,
  });

  final int index;
  final List<String> lines;
  final String? illustrationAsset;

  int get wordCount => lines.fold(0, (count, line) => count + _words(line));
}

/// A page never carries more than this many words; a bedtime line is four
/// or five, so a page is three or four lines.
const int kKidsStoryPageMaxWords = 40;
const int _pageTargetWords = 16;
const int _pageMaxLines = 4;

/// Splits a story's read-along text into pages.
///
/// The seeds are written in short lines grouped by blank lines into beats
/// ("Long, long ago..." / "Before there were cities..."). A beat stays on
/// one page; a page takes beats until it reaches a comfortable length. Every
/// line of the text appears exactly once, in order.
List<KidsStoryPage> kidsStoryPagesFor(BedtimeStorySeed story) {
  final beats = story.ttsText
      .trim()
      .split(RegExp(r'\n\s*\n'))
      .map(
        (beat) => beat
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList(growable: false),
      )
      .where((beat) => beat.isNotEmpty)
      .toList(growable: false);

  final pages = <List<String>>[];
  var current = <String>[];
  int wordsOf(List<String> lines) =>
      lines.fold(0, (count, line) => count + _words(line));

  for (final beat in beats) {
    for (final chunk in _chunksWithinLimit(beat)) {
      final currentWords = wordsOf(current);
      final fits =
          current.isEmpty ||
          (currentWords < _pageTargetWords &&
              currentWords + wordsOf(chunk) <= kKidsStoryPageMaxWords &&
              current.length + chunk.length <= _pageMaxLines);
      if (!fits) {
        pages.add(current);
        current = <String>[];
      }
      current.addAll(chunk);
    }
  }
  if (current.isNotEmpty) pages.add(current);

  final art = _illustrationsFor(story, pages.length);
  return [
    for (var i = 0; i < pages.length; i++)
      KidsStoryPage(index: i, lines: pages[i], illustrationAsset: art[i]),
  ];
}

/// A beat longer than a page is split at its line breaks; a single line is
/// never cut.
List<List<String>> _chunksWithinLimit(List<String> beat) {
  final chunks = <List<String>>[];
  var chunk = <String>[];
  var chunkWords = 0;
  for (final line in beat) {
    final lineWords = _words(line);
    if (chunk.isNotEmpty && chunkWords + lineWords > kKidsStoryPageMaxWords) {
      chunks.add(chunk);
      chunk = <String>[];
      chunkWords = 0;
    }
    chunk.add(line);
    chunkWords += lineWords;
  }
  if (chunk.isNotEmpty) chunks.add(chunk);
  return chunks;
}

/// Scene art spread evenly across the pages when a story has it; otherwise
/// the cover opens the book and the backdrop carries the rest.
List<String?> _illustrationsFor(BedtimeStorySeed story, int pageCount) {
  final scenes = [...story.sceneIllustrations]
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  if (scenes.isNotEmpty) {
    return [
      for (var i = 0; i < pageCount; i++)
        scenes[(i * scenes.length) ~/ pageCount].imageAssetPath,
    ];
  }
  final cover = story.coverAssetPath.isEmpty ? null : story.coverAssetPath;
  final backdrop = story.backdropAssetPath.isEmpty
      ? cover
      : story.backdropAssetPath;
  return [for (var i = 0; i < pageCount; i++) i == 0 ? cover : backdrop];
}

int _words(String line) =>
    line.trim().isEmpty ? 0 : line.trim().split(RegExp(r'\s+')).length;
