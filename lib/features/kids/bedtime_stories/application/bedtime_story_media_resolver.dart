import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bedtime_story_media_manifest.dart';
import '../domain/bedtime_story_models.dart';

class BedtimeStoryResolvedAudio {
  const BedtimeStoryResolvedAudio({
    required this.entry,
    required this.resolvedAssetPath,
    required this.availability,
    required this.playbackSource,
  });

  final BedtimeStoryAudioManifestEntry entry;
  final String? resolvedAssetPath;
  final BedtimeStoryMediaAvailability availability;
  final BedtimeStoryPlaybackSource playbackSource;

  bool get isAvailable => resolvedAssetPath != null;
}

class BedtimeStoryResolvedIllustration {
  const BedtimeStoryResolvedIllustration({
    required this.entry,
    required this.resolvedAssetPath,
  });

  final BedtimeStoryIllustrationManifestEntry entry;
  final String? resolvedAssetPath;

  bool get isAvailable => resolvedAssetPath != null;
}

class BedtimeStoryResolvedMedia {
  const BedtimeStoryResolvedMedia({
    required this.storyId,
    required this.audio,
    required this.cover,
    required this.backdrop,
    required this.scenes,
  });

  final String storyId;
  final BedtimeStoryResolvedAudio audio;
  final BedtimeStoryResolvedIllustration cover;
  final BedtimeStoryResolvedIllustration backdrop;
  final List<BedtimeStoryResolvedIllustration> scenes;

  bool get hasAudio => audio.isAvailable;
  bool get hasCover => cover.isAvailable;
  bool get hasBackdrop => backdrop.isAvailable;
  bool get hasAnyArtwork => hasCover || hasBackdrop;
}

final bedtimeStoryResolvedMediaProvider =
    FutureProvider.family<BedtimeStoryResolvedMedia, BedtimeStorySeed>((
      ref,
      story,
    ) async {
      return BedtimeStoryMediaResolver.resolveMedia(story);
    });

final bedtimeStoryAudioManifestEntryProvider =
    Provider.family<BedtimeStoryAudioManifestEntry, BedtimeStorySeed>((
      ref,
      story,
    ) {
      return bedtimeStoryAudioManifestEntryFor(story);
    });

class BedtimeStoryMediaResolver {
  static Future<Set<String>>? _assetKeysFuture;

  static Future<Set<String>> _assetKeys() {
    _assetKeysFuture ??= _loadAssetKeys();
    return _assetKeysFuture!;
  }

  static Future<Set<String>> _loadAssetKeys() async {
    final raw = await rootBundle.loadString('AssetManifest.json');
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String>{};
    }
    return decoded.keys.toSet();
  }

  static Future<BedtimeStoryResolvedMedia> resolveMedia(
    BedtimeStorySeed story,
  ) async {
    final audio = await resolveAudio(story);
    final illustrations = await resolveIllustrations(story);
    BedtimeStoryResolvedIllustration? cover;
    BedtimeStoryResolvedIllustration? backdrop;
    final scenes = <BedtimeStoryResolvedIllustration>[];
    for (final item in illustrations) {
      switch (item.entry.kind) {
        case BedtimeStoryIllustrationKind.cover:
          cover = item;
        case BedtimeStoryIllustrationKind.backdrop:
          backdrop = item;
        case BedtimeStoryIllustrationKind.scene:
          scenes.add(item);
      }
    }

    return BedtimeStoryResolvedMedia(
      storyId: story.id,
      audio: audio,
      cover:
          cover ??
          BedtimeStoryResolvedIllustration(
            entry: bedtimeStoryIllustrationManifestFor(story).firstWhere(
              (entry) => entry.kind == BedtimeStoryIllustrationKind.cover,
            ),
            resolvedAssetPath: null,
          ),
      backdrop:
          backdrop ??
          BedtimeStoryResolvedIllustration(
            entry: bedtimeStoryIllustrationManifestFor(story).firstWhere(
              (entry) => entry.kind == BedtimeStoryIllustrationKind.backdrop,
            ),
            resolvedAssetPath: null,
          ),
      scenes: scenes,
    );
  }

  static Future<BedtimeStoryResolvedAudio> resolveAudio(
    BedtimeStorySeed story,
  ) async {
    final entry = bedtimeStoryAudioManifestEntryFor(story);
    final keys = await _assetKeys();
    final candidates = <String>[entry.assetPath, ...entry.alternateAssetPaths];
    for (final path in candidates) {
      if (keys.contains(path)) {
        return BedtimeStoryResolvedAudio(
          entry: entry,
          resolvedAssetPath: path,
          availability: BedtimeStoryMediaAvailability.bundled,
          playbackSource: BedtimeStoryPlaybackSource.asset,
        );
      }
    }
    return BedtimeStoryResolvedAudio(
      entry: entry,
      resolvedAssetPath: null,
      availability: BedtimeStoryMediaAvailability.missing,
      playbackSource: BedtimeStoryPlaybackSource.missingAsset,
    );
  }

  static Future<List<BedtimeStoryResolvedIllustration>> resolveIllustrations(
    BedtimeStorySeed story,
  ) async {
    final keys = await _assetKeys();
    return bedtimeStoryIllustrationManifestFor(story)
        .map((entry) {
          final candidates = <String>[
            entry.assetPath,
            ...entry.alternateAssetPaths,
          ];
          for (final path in candidates) {
            if (keys.contains(path)) {
              return BedtimeStoryResolvedIllustration(
                entry: entry,
                resolvedAssetPath: path,
              );
            }
          }
          return BedtimeStoryResolvedIllustration(
            entry: entry,
            resolvedAssetPath: null,
          );
        })
        .toList(growable: false);
  }
}
