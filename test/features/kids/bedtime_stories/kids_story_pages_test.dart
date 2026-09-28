import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/books/kids_picture_books.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/kids_story_pages.dart';

/// K2: every story is a picture book. The splitter must give each of the
/// seeded stories a run of short pages that, read in order, is exactly the
/// story's text.
void main() {
  final stories = [
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
    ...kKidsPictureBooks,
  ];

  test('every seeded story splits into several short pages', () {
    for (final story in stories) {
      final pages = kidsStoryPagesFor(story);
      expect(
        pages.length,
        greaterThanOrEqualTo(2),
        reason: '${story.id} should be more than one page',
      );
      for (final page in pages) {
        expect(page.lines, isNotEmpty, reason: '${story.id} has an empty page');
        // A single line is never cut, so only multi-line pages are bounded.
        if (page.lines.length > 1) {
          expect(
            page.wordCount,
            lessThanOrEqualTo(kKidsStoryPageMaxWords),
            reason: '${story.id} page ${page.index} is too long to be a page',
          );
        }
      }
    }
  });

  test('the pages carry every line of the story, once, in order', () {
    for (final story in stories) {
      final expected = story.ttsText
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      final actual = [
        for (final page in kidsStoryPagesFor(story)) ...page.lines,
      ];
      expect(actual, expected, reason: '${story.id} lost or reordered a line');
    }
  });

  test('pages are numbered from zero and every page has art to show', () {
    for (final story in stories) {
      final pages = kidsStoryPagesFor(story);
      for (var i = 0; i < pages.length; i++) {
        expect(pages[i].index, i);
        expect(
          pages[i].illustrationAsset,
          isNotNull,
          reason: '${story.id} page $i has no picture',
        );
      }
    }
  });

  test('a beat stays on one page unless it is longer than a page', () {
    // Every seeded story is a picture book now, so the beat splitter is
    // exercised on a prose fixture: two one-line beats that fit together,
    // then a three-line beat about the quiet moment that must not be split.
    const story = BedtimeStorySeed(
      id: 'story_fixture_prose_v1',
      title: 'A Prose Fixture',
      shortTitle: 'Prose',
      category: BedtimeStoryCategory.characterAdab,
      ageGroup: BedtimeStoryAgeGroup.kids,
      audioFileName: 'fixture.mp3',
      ttsText: '''
Maryam knocked over the blue cup.

Water slipped across the table.

For one quiet moment,
she thought about saying,
"I did not do it."

But her heart felt heavy.
''',
      lesson: 'Truth brings peace.',
      estimatedDurationSeconds: 30,
      isFeatured: false,
      isMultipart: false,
      partNumber: 1,
      totalParts: 1,
      tags: <String>[],
      sortOrder: 1,
      coverAssetPath: 'assets/images/kids_stories/covers/patience_cover.webp',
      backdropAssetPath: '',
      narratorDisplayName: 'Fixture',
      isLocked: false,
      unlockXp: 0,
      oceanDropsReward: 0,
      xpReward: 0,
      isDownloadedByDefault: false,
      isAvailableOffline: false,
      recommendedForTonight: false,
      relatedStoryIds: <String>[],
    );
    final pages = kidsStoryPagesFor(story);
    final quietMoment = pages.firstWhere(
      (page) => page.lines.any((line) => line.startsWith('For one quiet')),
    );
    final start = quietMoment.lines.indexWhere(
      (line) => line.startsWith('For one quiet'),
    );
    expect(quietMoment.lines.sublist(start, start + 3), [
      'For one quiet moment,',
      'she thought about saying,',
      '"I did not do it."',
    ]);
  });
}
