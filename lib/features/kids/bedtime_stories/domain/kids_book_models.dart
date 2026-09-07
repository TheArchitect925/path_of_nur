import '../../../learn/quran/domain/quran_content_refs.dart';

/// A page of a picture book as the seed describes it: one picture over one
/// to three short lines. The reader shows spreads one per page (see
/// `kidsStoryPagesFor`); [text] is what the voice reads.
///
/// The rules a book keeps, checked by `kids_books_content_test.dart`:
/// [kKidsBookMinSpreads] to [kKidsBookMaxSpreads] spreads, at most
/// [kKidsBookSpreadMaxWords] words a spread, one refrain that comes back at
/// least [kKidsBookRefrainMinCount] times, no line trailing off in "…", and
/// no "Good night" in the text, because bedtime is a mode the reader adds
/// from [BedtimeStorySeed.bedtimeClosing].
class KidsBookSpread {
  const KidsBookSpread(
    this.lines, {
    this.illustrationAsset,
    this.atlasScene,
    this.isRefrain = false,
    this.highlightPhrase,
    this.arabicLine,
    this.quranRef,
    this.tryItRoute,
  });

  /// One to three lines, together no more than [kKidsBookSpreadMaxWords].
  final List<String> lines;

  /// This spread's own picture, once it is drawn.
  final String? illustrationAsset;

  /// The shared scene the spread borrows until then. A spread with neither
  /// falls back to the book's cover (first spread) or backdrop.
  final KidsBookAtlasScene? atlasScene;

  /// The line a child can say before they can read: it returns at least
  /// three times in a book.
  final bool isRefrain;

  /// A phrase the reader may set apart (a duʿā, a name of Allah).
  final String? highlightPhrase;

  /// Arabic shown under the lines, for a duʿā or an ayah the book quotes.
  final String? arabicLine;

  /// The ayah this spread rests on, shown as a small tappable caption.
  final QuranQuoteRef? quranRef;

  /// A location the last spread of a First Steps book opens, so the book
  /// ends in a real tool: say the shahada, see the next prayer, do wuḍūʾ.
  final String? tryItRoute;

  String get text => lines.join('\n');

  int get wordCount => lines.fold(0, (count, line) => count + _words(line));

  bool get hasOwnPicture => (illustrationAsset ?? '').isNotEmpty;

  /// The same spread with another language's lines: picture, refrain flag,
  /// Arabic, ayah and Try it stay as the English spread set them.
  KidsBookSpread withLines(List<String> lines) => KidsBookSpread(
    lines,
    illustrationAsset: illustrationAsset,
    atlasScene: atlasScene,
    isRefrain: isRefrain,
    highlightPhrase: highlightPhrase,
    arabicLine: arabicLine,
    quranRef: quranRef,
    tryItRoute: tryItRoute,
  );
}

/// One language's text for a picture book (C6): everything a child reads
/// or hears, spread for spread. Pictures, refs and Arabic live on the
/// English spreads; [spreads] carries only the lines, in the same order and
/// number, so `kids_books_content_test.dart` can hold the two together.
/// A translation may run a little longer than the English: up to
/// [kKidsBookTranslatedSpreadMaxWords] words a spread.
class KidsBookTranslation {
  const KidsBookTranslation({
    required this.title,
    required this.shortTitle,
    required this.summary,
    required this.lesson,
    required this.refrain,
    required this.bedtimeClosing,
    required this.spreads,
  });

  final String title;
  final String shortTitle;
  final String summary;
  final String lesson;
  final String refrain;
  final String bedtimeClosing;

  /// The lines of every spread, English order.
  final List<List<String>> spreads;
}

/// German (and any later language) runs longer than English; a translated
/// spread may carry this many words.
const int kKidsBookTranslatedSpreadMaxWords = 24;

/// The text the voice reads and the older tools index: the spreads in
/// order, one blank line between them, so the beat splitter would page it
/// the same way if it ever had to.
String kidsBookReadAloudText(List<KidsBookSpread> spreads) =>
    spreads.map((spread) => spread.text).join('\n\n');

/// A parent reads a picture book at about two words a second and pauses
/// on every picture.
int kidsBookDurationSeconds(List<KidsBookSpread> spreads) {
  final words = spreads.fold<int>(0, (count, s) => count + s.wordCount);
  return (words / 2).round() + spreads.length * 3;
}

/// A spread never carries more words than this.
const int kKidsBookSpreadMaxWords = 20;

/// Nor more lines.
const int kKidsBookSpreadMaxLines = 3;

/// A book is a run of spreads this long. Eight is the short book a prophet
/// with a line or two in the Qur'an gets; fourteen is a full story.
const int kKidsBookMinSpreads = 8;
const int kKidsBookMaxSpreads = 14;

/// How often the refrain returns.
const int kKidsBookRefrainMinCount = 3;

/// Shared scenes any spread can borrow while its own picture is not drawn
/// yet, the way the duʿā picture stories share their twelve mood scenes.
/// The atlas grows with the picture-book art tier.
enum KidsBookAtlasScene {
  nightSky('assets/images/kids_dua_stories/scene_sky_night_wonder.webp'),
  daySky('assets/images/kids_dua_stories/scene_sky_day_happy.webp'),
  home('assets/images/kids_dua_stories/scene_home_day_neutral.webp'),
  homeEvening('assets/images/kids_dua_stories/scene_home_evening_calm.webp'),
  table('assets/images/kids_dua_stories/scene_table_day_happy.webp'),
  bedroom('assets/images/kids_dua_stories/scene_bedroom_night_calm.webp'),
  learning('assets/images/kids_dua_stories/scene_learning_day_calm.webp'),
  // Drawn for the picture books (tooling/art_src/kids_books).
  sea('assets/images/kids_books/atlas/sea_day.webp'),
  seaNight('assets/images/kids_books/atlas/sea_night.webp'),
  desertRoad('assets/images/kids_books/atlas/desert_road_dusk.webp'),
  cityMorning('assets/images/kids_books/atlas/city_morning.webp'),
  cityNight('assets/images/kids_books/atlas/city_night.webp'),
  garden('assets/images/kids_books/atlas/garden_day.webp'),
  masjid('assets/images/kids_books/atlas/masjid_day.webp');

  const KidsBookAtlasScene(this.assetPath);

  final String assetPath;
}

int _words(String line) {
  final trimmed = line.trim();
  return trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
}

/// The refrain as it is matched inside a line: without its closing
/// punctuation, so "Allah always hears." is found in "Allah always hears,"
/// said Mama' as well as in 'But Allah always hears.'
String kidsBookRefrainCore(String refrain) =>
    refrain.trim().replaceAll(RegExp(r'[.!?,;:]+$'), '');
