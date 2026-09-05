import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_media_manifest.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';

/// K3: story narration is resolved by file name at runtime, so a misnamed
/// recording plays nothing and nobody notices. This keeps the import tool,
/// the media manifest and the audio folders in agreement.
void main() {
  final tool = File('tools/import_kids_narration.py').readAsStringSync();
  final stories = <BedtimeStorySeed>[
    ...kBedtimeProphetStories,
    ...kKidsIslamicStories,
  ];

  test('the import tool writes into the folders the app resolves', () {
    expect(tool, contains('"$bedtimeStoryAudioBundledAssetDirectory"'));
    expect(tool, contains('"$kidsStoryAudioBundledAssetDirectory"'));
    expect(tool, contains('LANGUAGE = "$bedtimeStoryDefaultLanguageCode"'));
    expect(tool, contains('VERSION = "$bedtimeStoryDefaultVersionTag"'));
  });

  test('every bundled recording belongs to a story', () {
    final slots = {
      for (final story in stories)
        bedtimeStoryAudioManifestEntryFor(story).assetPath,
    };
    for (final dir in [
      bedtimeStoryAudioBundledAssetDirectory,
      kidsStoryAudioBundledAssetDirectory,
    ]) {
      final folder = Directory(dir);
      if (!folder.existsSync()) continue;
      for (final file in folder.listSync().whereType<File>()) {
        if (!file.path.endsWith('.mp3')) continue;
        expect(slots, contains(file.path), reason: '${file.path} is a stray');
      }
    }
  });

  test('the manifest names one slot per story and never two the same', () {
    final paths = stories
        .map((story) => bedtimeStoryAudioManifestEntryFor(story).assetPath)
        .toList();
    expect(paths.toSet().length, paths.length);
    for (final path in paths) {
      expect(path, endsWith('_${bedtimeStoryDefaultLanguageCode}_v1.mp3'));
    }
  });
}
