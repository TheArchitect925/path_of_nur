import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_media_manifest.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';

void main() {
  test('audio manifest uses canonical bundled path with legacy fallback', () {
    final story = kBedtimeProphetStories.firstWhere(
      (item) => item.id == 'story_prophet_adam_bedtime_v1',
    );
    final entry = bedtimeStoryAudioManifestEntryFor(story);

    expect(
      entry.assetPath,
      'assets/audio/bedtime_stories/prophets/en/path_of_nur/prophet_adam_bedtime_en_v1.mp3',
    );
    expect(
      entry.alternateAssetPaths,
      contains('assets/audio/bedtime_stories/prophets/prophet_adam_bedtime_v1.mp3'),
    );
    expect(entry.languageCode, 'en');
    expect(entry.versionTag, 'v1');
  });

  test('illustration manifest uses canonical cover and backdrop folders', () {
    final story = kBedtimeProphetStories.firstWhere(
      (item) => item.id == 'story_prophet_musa_bedtime_v1',
    );
    final entries = bedtimeStoryIllustrationManifestFor(story);

    expect(entries.length, 2);
    expect(entries.first.assetPath, contains('/covers/'));
    expect(entries.last.assetPath, contains('/backdrops/'));
  });
}
