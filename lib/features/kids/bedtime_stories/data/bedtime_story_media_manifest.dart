import '../domain/bedtime_story_models.dart';

const String bedtimeStoryAudioLegacyAssetDirectory =
    'assets/audio/bedtime_stories/prophets';
const String bedtimeStoryAudioBundledAssetDirectory =
    'assets/audio/bedtime_stories/prophets/en/path_of_nur';
const String kidsStoryAudioBundledAssetDirectory =
    'assets/audio/kids_stories/en/path_of_nur';

const String bedtimeStoryImageAssetDirectory =
    'assets/images/prophets/bedtime_stories';
const String bedtimeStoryImageCoverAssetDirectory =
    'assets/images/prophets/bedtime_stories/covers';
const String bedtimeStoryImageBackdropAssetDirectory =
    'assets/images/prophets/bedtime_stories/backdrops';
const String bedtimeStoryImageSceneAssetDirectory =
    'assets/images/prophets/bedtime_stories/scenes';
const String kidsStoryImageAssetDirectory = 'assets/images/kids_stories';
const String kidsStoryImageCoverAssetDirectory = 'assets/images/kids_stories/covers';
const String kidsStoryImageBackdropAssetDirectory =
    'assets/images/kids_stories/backdrops';
const String kidsStoryImageSceneAssetDirectory = 'assets/images/kids_stories/scenes';

const String bedtimeStoryDefaultLanguageCode = 'en';
const String bedtimeStoryDefaultNarratorId = 'path_of_nur_bedtime_narrator';
const String bedtimeStoryDefaultVersionTag = 'v1';

enum BedtimeStoryMediaAvailability { bundled, downloaded, missing }

enum BedtimeStoryIllustrationKind { cover, backdrop, scene }

class BedtimeStoryAudioManifestEntry {
  const BedtimeStoryAudioManifestEntry({
    required this.storyId,
    required this.storyFamilyId,
    required this.prophetId,
    required this.audioFileName,
    required this.assetPath,
    required this.alternateAssetPaths,
    required this.estimatedDurationSeconds,
    required this.languageCode,
    required this.narratorId,
    required this.narratorDisplayName,
    required this.versionTag,
    required this.isBundledAsset,
    required this.isDownloaded,
    required this.isAvailable,
    this.checksum,
    this.lastVerifiedAtIso,
  });

  final String storyId;
  final String storyFamilyId;
  final String prophetId;
  final String audioFileName;
  final String assetPath;
  final List<String> alternateAssetPaths;
  final int estimatedDurationSeconds;
  final String languageCode;
  final String narratorId;
  final String narratorDisplayName;
  final String versionTag;
  final bool isBundledAsset;
  final bool isDownloaded;
  final bool isAvailable;
  final String? checksum;
  final String? lastVerifiedAtIso;
}

class BedtimeStoryIllustrationManifestEntry {
  const BedtimeStoryIllustrationManifestEntry({
    required this.id,
    required this.storyId,
    required this.kind,
    required this.assetPath,
    required this.alternateAssetPaths,
    required this.isBundledAsset,
    required this.isAvailable,
  });

  final String id;
  final String storyId;
  final BedtimeStoryIllustrationKind kind;
  final String assetPath;
  final List<String> alternateAssetPaths;
  final bool isBundledAsset;
  final bool isAvailable;
}

String bedtimeStoryCanonicalAudioFileName(
  BedtimeStorySeed story, {
  String languageCode = bedtimeStoryDefaultLanguageCode,
  String versionTag = bedtimeStoryDefaultVersionTag,
}) {
  final baseId = story.id
      .replaceFirst('story_', '')
      .replaceFirst('_v1', '')
      .replaceAll('bedtime_', 'bedtime_');
  return '${baseId}_${languageCode}_$versionTag.mp3';
}

String bedtimeStoryAudioAssetPath(String fileName) {
  return '$bedtimeStoryAudioBundledAssetDirectory/$fileName';
}

String kidsStoryAudioAssetPath(String fileName) {
  return '$kidsStoryAudioBundledAssetDirectory/$fileName';
}

String bedtimeStoryLegacyAudioAssetPath(String fileName) {
  return '$bedtimeStoryAudioLegacyAssetDirectory/$fileName';
}

String bedtimeStoryCoverAssetPath(String fileName) {
  return '$bedtimeStoryImageCoverAssetDirectory/$fileName';
}

String bedtimeStoryLegacyCoverAssetPath(String fileName) {
  return '$bedtimeStoryImageAssetDirectory/$fileName';
}

String bedtimeStoryBackdropAssetPath(String fileName) {
  return '$bedtimeStoryImageBackdropAssetDirectory/$fileName';
}

String bedtimeStoryLegacyBackdropAssetPath(String fileName) {
  return '$bedtimeStoryImageAssetDirectory/$fileName';
}

BedtimeStoryAudioManifestEntry bedtimeStoryAudioManifestEntryFor(
  BedtimeStorySeed story,
) {
  final canonicalFileName = story.collectionType == KidsIslamicStoryCollectionType.prophets
      ? bedtimeStoryCanonicalAudioFileName(story)
      : (story.audioFileName.isNotEmpty
            ? story.audioFileName
            : bedtimeStoryCanonicalAudioFileName(story));
  final assetPath = story.collectionType == KidsIslamicStoryCollectionType.prophets
      ? bedtimeStoryAudioAssetPath(canonicalFileName)
      : kidsStoryAudioAssetPath(canonicalFileName);
  return BedtimeStoryAudioManifestEntry(
    storyId: story.id,
    storyFamilyId: story.effectiveStoryFamilyId,
    prophetId: story.prophetId,
    audioFileName: canonicalFileName,
    assetPath: assetPath,
    alternateAssetPaths: story.collectionType == KidsIslamicStoryCollectionType.prophets
        ? <String>[bedtimeStoryLegacyAudioAssetPath(story.audioFileName)]
        : const <String>[],
    estimatedDurationSeconds: story.estimatedDurationSeconds,
    languageCode: bedtimeStoryDefaultLanguageCode,
    narratorId: bedtimeStoryDefaultNarratorId,
    narratorDisplayName: story.narratorDisplayName,
    versionTag: bedtimeStoryDefaultVersionTag,
    isBundledAsset: true,
    isDownloaded: false,
    isAvailable: story.isAvailableOffline,
  );
}

List<BedtimeStoryIllustrationManifestEntry> bedtimeStoryIllustrationManifestFor(
  BedtimeStorySeed story,
) {
  final coverFileName = story.coverAssetPath.split('/').last;
  final backdropFileName = story.backdropAssetPath.split('/').last;
  return <BedtimeStoryIllustrationManifestEntry>[
    BedtimeStoryIllustrationManifestEntry(
      id: '${story.id}:cover',
      storyId: story.id,
      kind: BedtimeStoryIllustrationKind.cover,
      assetPath: story.collectionType == KidsIslamicStoryCollectionType.prophets
          ? bedtimeStoryCoverAssetPath(coverFileName)
          : story.coverAssetPath,
      alternateAssetPaths: story.collectionType == KidsIslamicStoryCollectionType.prophets
          ? <String>[bedtimeStoryLegacyCoverAssetPath(coverFileName)]
          : const <String>[],
      isBundledAsset: true,
      isAvailable: true,
    ),
    BedtimeStoryIllustrationManifestEntry(
      id: '${story.id}:backdrop',
      storyId: story.id,
      kind: BedtimeStoryIllustrationKind.backdrop,
      assetPath: story.collectionType == KidsIslamicStoryCollectionType.prophets
          ? bedtimeStoryBackdropAssetPath(backdropFileName)
          : story.backdropAssetPath,
      alternateAssetPaths: story.collectionType == KidsIslamicStoryCollectionType.prophets
          ? <String>[
              bedtimeStoryLegacyBackdropAssetPath(backdropFileName),
            ]
          : const <String>[],
      isBundledAsset: true,
      isAvailable: true,
    ),
    ...story.sceneIllustrations.map(
      (scene) => BedtimeStoryIllustrationManifestEntry(
        id: scene.id,
        storyId: story.id,
        kind: BedtimeStoryIllustrationKind.scene,
        assetPath: scene.imageAssetPath,
        alternateAssetPaths: const <String>[],
        isBundledAsset: true,
        isAvailable: true,
      ),
    ),
  ];
}
