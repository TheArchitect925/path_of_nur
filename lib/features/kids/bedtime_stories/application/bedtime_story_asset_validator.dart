import '../domain/bedtime_story_models.dart';
import 'bedtime_story_media_resolver.dart';

class BedtimeStoryAssetValidationReport {
  const BedtimeStoryAssetValidationReport({
    required this.missingAudioStoryIds,
    required this.missingCoverStoryIds,
    required this.missingBackdropStoryIds,
  });

  final List<String> missingAudioStoryIds;
  final List<String> missingCoverStoryIds;
  final List<String> missingBackdropStoryIds;

  bool get isValid =>
      missingAudioStoryIds.isEmpty &&
      missingCoverStoryIds.isEmpty &&
      missingBackdropStoryIds.isEmpty;
}

class BedtimeStoryAssetValidator {
  static Future<BedtimeStoryAssetValidationReport> validateStories(
    Iterable<BedtimeStorySeed> stories,
  ) async {
    final missingAudio = <String>[];
    final missingCover = <String>[];
    final missingBackdrop = <String>[];

    for (final story in stories) {
      final media = await BedtimeStoryMediaResolver.resolveMedia(story);
      if (!media.audio.isAvailable) {
        missingAudio.add(story.id);
      }
      if (!media.cover.isAvailable) {
        missingCover.add(story.id);
      }
      if (!media.backdrop.isAvailable) {
        missingBackdrop.add(story.id);
      }
    }

    return BedtimeStoryAssetValidationReport(
      missingAudioStoryIds: missingAudio,
      missingCoverStoryIds: missingCover,
      missingBackdropStoryIds: missingBackdrop,
    );
  }
}

