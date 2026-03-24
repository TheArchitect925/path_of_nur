import '../../../arabic/application/arabic_learning_asset_bundle.dart';
import '../../../arabic/data/arabic_audio_manifest.dart';
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
    return ArabicLearningAssetManifest.assetKeys();
  }

  static Future<String?> resolveAudioPath(QuranAudioCue? cue) async {
    if (cue == null) return null;
    final keys = await _assetKeys();
    final manifest = quranTeacherAudioManifest[cue.id];
    final sharedLetterManifest = arabicLetterAudioByAnyId(cue.id);
    final candidates = <String>[
      if (cue.assetPath != null) cue.assetPath!,
      ...cue.alternateAudioAssetPaths,
      if (sharedLetterManifest != null) sharedLetterManifest.assetPath,
      if (sharedLetterManifest != null)
        ...sharedLetterManifest.alternateAssetPaths,
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
    return arabicLetterAudioPrimaryAssetPath(id) ??
        quranTeacherAudioManifest[id]?.assetPath;
  }

  static String? fallbackVisualPathForId(String id) {
    return quranTeacherVisualManifest[id]?.assetPath;
  }
}
