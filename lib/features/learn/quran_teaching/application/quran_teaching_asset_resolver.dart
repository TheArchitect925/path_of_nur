import 'dart:convert';

import 'package:flutter/services.dart';

import '../data/quran_teacher_audio_manifest.dart';
import '../data/quran_teacher_listen_only_manifest.dart';
import '../data/quran_teacher_visual_manifest.dart';
import '../domain/quran_teaching_models.dart';

class QuranTeachingAssetResolver {
  static Future<Set<String>>? _assetKeysFuture;

  static Future<Set<String>> _assetKeys() {
    _assetKeysFuture ??= _loadAssetKeys();
    return _assetKeysFuture!;
  }

  static Future<Set<String>> _loadAssetKeys() async {
    final raw = await rootBundle.loadString('AssetManifest.json');
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) return <String>{};
    return decoded.keys.toSet();
  }

  static Future<String?> resolveAudioPath(QuranAudioCue? cue) async {
    if (cue == null) return null;
    final keys = await _assetKeys();
    final manifest = quranTeacherAudioManifest[cue.id];
    final candidates = <String>[
      if (cue.assetPath != null) cue.assetPath!,
      ...cue.alternateAudioAssetPaths,
      if (manifest != null) manifest.assetPath,
      if (manifest != null) ...manifest.alternatePaths,
    ];
    for (final path in candidates) {
      if (keys.contains(path)) return path;
    }
    return null;
  }

  static Future<bool> hasAudio(QuranAudioCue? cue) async {
    return (await resolveAudioPath(cue)) != null;
  }

  static Future<String?> resolveImagePath(String? imageAssetPath) async {
    if (imageAssetPath == null || imageAssetPath.isEmpty) return null;
    final keys = await _assetKeys();
    if (keys.contains(imageAssetPath)) return imageAssetPath;
    if (keys.contains(quranTeacherPlaceholderImagePath)) {
      return quranTeacherPlaceholderImagePath;
    }
    return null;
  }

  static Future<int> availableAudioCount(
    Iterable<QuranTeachingAudioPracticeItem> items,
  ) async {
    var count = 0;
    for (final item in items) {
      if (await hasAudio(item.audio)) count += 1;
    }
    return count;
  }

  static QuranTeacherListenOnlyPackManifestEntry? listenOnlyPackMeta(
    String packId,
  ) {
    return quranTeacherListenOnlyManifest[packId];
  }

  static String? fallbackAudioPathForId(String id) {
    return quranTeacherAudioManifest[id]?.assetPath;
  }

  static String? fallbackVisualPathForId(String id) {
    return quranTeacherVisualManifest[id]?.assetPath;
  }
}
