import '../domain/kids_dua_learning_models.dart';
import '../domain/kids_dua_models.dart';

const String kidsDuaAudioBundledAssetDirectory =
    'assets/audio/kids_dua/en/path_of_nur';

String kidsDuaCanonicalAudioFileName(String duaId) {
  final normalized = duaId.replaceAll('-', '_');
  return '${normalized}_kids_dua_en_v1.mp3';
}

String kidsDuaAudioAssetPath(String fileName) {
  return '$kidsDuaAudioBundledAssetDirectory/$fileName';
}

KidsDuaAudioVariant kidsDuaAudioVariantFor(KidsDuaLessonContent lesson) {
  final fileName = kidsDuaCanonicalAudioFileName(lesson.id);
  return KidsDuaAudioVariant(
    variantId: '${lesson.id}_en_path_of_nur_v1',
    duaId: lesson.id,
    languageCode: 'en',
    narratorId: 'path_of_nur_kids_default',
    narratorDisplayName: 'Path of Nūr',
    voicePackId: 'kids_gentle_en',
    audioFileName: fileName,
    assetPath: lesson.audioAssetPath.isEmpty
        ? kidsDuaAudioAssetPath(fileName)
        : lesson.audioAssetPath,
    estimatedDurationSeconds: lesson.phraseChunks.length * 2,
    isBundledAsset: true,
    isDownloaded: false,
    isAvailable: false,
    versionTag: 'v1',
    sourceType: 'bundled_asset',
  );
}
