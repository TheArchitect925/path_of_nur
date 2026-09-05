import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/books/kids_picture_book.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/books/kids_picture_books.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/kids_story_pages.dart';
import 'package:path_of_nur/features/kids/seerah/data/companion_story_seed.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';

/// C0: the picture-book contract. A book keeps the rules a child's book
/// needs, and the pager turns one spread into one page. The rules ratchet
/// the content, not the code: a book that breaks them fails here before a
/// child sees it.
void main() {
  final everyStory = <BedtimeStorySeed>[
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
    ...kKidsSeerahCompanionStories,
    ...kKidsPictureBooks,
  ];
  final books = [
    ...everyStory.where((story) => story.isPictureBook),
    _fixtureBook(),
  ];

  test('the atlas scenes every spread may borrow are real files', () {
    for (final scene in KidsBookAtlasScene.values) {
      expect(
        File(scene.assetPath).existsSync(),
        isTrue,
        reason: '${scene.name} points at a missing file: ${scene.assetPath}',
      );
    }
  });

  test('story ids stay unique across every list', () {
    final ids = everyStory.map((story) => story.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  group('every picture book', () {
    test('is a run of short spreads', () {
      for (final book in books) {
        expect(
          book.spreads.length,
          inInclusiveRange(kKidsBookMinSpreads, kKidsBookMaxSpreads),
          reason: '${book.id} has ${book.spreads.length} spreads',
        );
        for (var i = 0; i < book.spreads.length; i++) {
          final spread = book.spreads[i];
          expect(
            spread.lines.length,
            inInclusiveRange(1, kKidsBookSpreadMaxLines),
            reason:
                '${book.id} spread ${i + 1} has ${spread.lines.length} lines',
          );
          expect(
            spread.wordCount,
            lessThanOrEqualTo(kKidsBookSpreadMaxWords),
            reason:
                '${book.id} spread ${i + 1} is ${spread.wordCount} words: '
                '"${spread.text}"',
          );
          for (final line in spread.lines) {
            expect(line.trim(), isNotEmpty, reason: '${book.id} blank line');
            expect(
              line.trimRight().endsWith('…') ||
                  line.trimRight().endsWith('...'),
              isFalse,
              reason: '${book.id} spread ${i + 1} trails off: "$line"',
            );
            expect(
              line.toLowerCase().contains('good night'),
              isFalse,
              reason:
                  '${book.id} bakes bedtime into the story; use bedtimeClosing',
            );
          }
        }
      }
    });

    test('has a refrain that comes back', () {
      for (final book in books) {
        final refrains = book.spreads.where((s) => s.isRefrain).length;
        expect(
          refrains,
          greaterThanOrEqualTo(kKidsBookRefrainMinCount),
          reason: '${book.id} marks $refrains refrain spreads',
        );
      }
    });

    test('says what it is and where it comes from', () {
      for (final book in books) {
        expect(book.summary.trim(), isNotEmpty, reason: '${book.id} summary');
        expect(book.lesson.trim(), isNotEmpty, reason: '${book.id} lesson');
        expect(
          book.bedtimeClosing.trim(),
          isNotEmpty,
          reason: '${book.id} has no bedtime closing',
        );
        expect(
          book.hasQuranReference || book.hasHadithReference,
          isTrue,
          reason: '${book.id} rests on no ayah and no hadith',
        );
        expect(
          book.title.contains('Bedtime Story'),
          isFalse,
          reason: '${book.id} is titled like a narration track',
        );
      }
    });

    test('reads aloud exactly its spreads, in order', () {
      for (final book in books) {
        expect(book.ttsText, kidsBookReadAloudText(book.spreads));
      }
    });

    test('shows a real picture on every page', () {
      for (final book in books) {
        expect(
          File(book.coverAssetPath).existsSync(),
          isTrue,
          reason: '${book.id} cover missing: ${book.coverAssetPath}',
        );
        final pages = kidsStoryPagesFor(book);
        expect(pages.length, book.spreads.length, reason: book.id);
        for (final page in pages) {
          expect(page.spread, same(book.spreads[page.index]));
          expect(page.lines, book.spreads[page.index].lines);
          expect(
            page.illustrationAsset,
            isNotNull,
            reason: '${book.id} page ${page.index} has no picture',
          );
          expect(
            File(page.illustrationAsset!).existsSync(),
            isTrue,
            reason:
                '${book.id} page ${page.index} picture missing: '
                '${page.illustrationAsset}',
          );
        }
      }
    });
  });

  group('a book built from spreads', () {
    final book = _fixtureBook();

    test('borrows atlas art until its own picture is drawn', () {
      final pages = kidsStoryPagesFor(book);
      // Spread 1 has no scene: the cover opens the book.
      expect(pages[0].illustrationAsset, book.coverAssetPath);
      // Spread 2 borrows the night sky from the atlas.
      expect(pages[1].illustrationAsset, KidsBookAtlasScene.nightSky.assetPath);
      // Spread 3 has its own picture.
      expect(pages[2].illustrationAsset, _ownScene);
      // A later spread with nothing shows the backdrop, never a blank.
      expect(pages[3].illustrationAsset, book.backdropAssetPath);
    });

    test('lists only its own pictures in the scene manifest', () {
      expect(book.sceneIllustrations.length, 1);
      expect(book.sceneIllustrations.single.imageAssetPath, _ownScene);
      expect(book.sceneIllustrations.single.sortOrder, 3);
    });

    test('times itself by its words and pictures', () {
      final words = book.spreads.fold<int>(0, (n, s) => n + s.wordCount);
      expect(book.estimatedDurationSeconds, (words / 2).round() + 8 * 3);
      expect(book.isMultipart, isFalse);
      expect(book.backdropAssetPath, book.coverAssetPath);
    });
  });
}

const _cover = 'assets/images/prophets/bedtime_stories/covers/yunus_cover.webp';
const _ownScene =
    'assets/images/kids_stories/scenes/bismillah_before_eating_scene_1.webp';

BedtimeStorySeed _fixtureBook() {
  return kidsPictureBook(
    id: 'story_fixture_book_v1',
    title: 'The Little Lamp',
    shortTitle: 'The Little Lamp',
    summary: 'A fixture book that keeps every rule of the format.',
    category: BedtimeStoryCategory.foundations,
    collectionType: KidsIslamicStoryCollectionType.foundations,
    storyType: KidsIslamicStoryType.foundations,
    lesson: 'Allah always hears.',
    bedtimeClosing: 'Now close your eyes. Allah hears you in your bed too.',
    coverAssetPath: _cover,
    sortOrder: 9999,
    quranQuote: 'And your Lord says, "Call upon Me; I will respond to you."',
    quranReference: 'Qur’an 40:60',
    quranQuoteRef: const QuranQuoteRef(surah: 40, ayah: 60),
    spreads: const [
      KidsBookSpread(['Safa could not sleep.', 'The room was dark.']),
      KidsBookSpread([
        'She looked out of the window.',
        'The stars were out.',
      ], atlasScene: KidsBookAtlasScene.nightSky),
      KidsBookSpread(
        ['"Allah always hears," said Mama.'],
        illustrationAsset: _ownScene,
        isRefrain: true,
      ),
      KidsBookSpread(['Safa whispered a duʿā.', 'Nobody else could hear it.']),
      KidsBookSpread(
        ['But Allah could.', 'Allah always hears.'],
        isRefrain: true,
        atlasScene: KidsBookAtlasScene.bedroom,
      ),
      KidsBookSpread([
        'She pulled the blanket up.',
        'The dark did not feel so dark.',
      ], atlasScene: KidsBookAtlasScene.bedroom),
      KidsBookSpread([
        'In the morning the sun came up.',
        'Safa said Alhamdulillah.',
      ], atlasScene: KidsBookAtlasScene.daySky),
      KidsBookSpread(
        ['When it is dark, call on Allah.', 'Allah always hears.'],
        isRefrain: true,
        atlasScene: KidsBookAtlasScene.home,
      ),
    ],
  );
}
