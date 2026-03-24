import '../domain/arabic_audio_models.dart';
import 'arabic_alphabet_catalog.dart';

const _alternateLetterAudioAssetPathsByCanonicalId = <String, List<String>>{
  'ha': <String>['assets/audio/quran_teacher/letters/haa.mp3'],
};

final arabicLetterAudioManifestByCanonicalId =
    <String, ArabicLetterAudioManifestEntry>{
      for (final letter in arabicAlphabetCatalog)
        letter.id: ArabicLetterAudioManifestEntry(
          canonicalLetterId: letter.id,
          legacyQuranTeachingSeedId: letter.quranTeachingSeedId,
          assetPath: letter.quranTeachingAudioAssetPath,
          spokenTextAr: letter.nameAr,
          kidsLabel: letter.kidsNameEn,
          adultLabel: letter.adultNameEn,
          alternateAssetPaths:
              _alternateLetterAudioAssetPathsByCanonicalId[letter.id] ??
              const <String>[],
        ),
    };

final arabicLetterAudioManifestByLegacySeedId =
    <String, ArabicLetterAudioManifestEntry>{
      for (final entry in arabicLetterAudioManifestByCanonicalId.values)
        entry.legacyQuranTeachingSeedId: entry,
    };

ArabicLetterAudioManifestEntry? arabicLetterAudioByCanonicalId(String id) {
  return arabicLetterAudioManifestByCanonicalId[id];
}

ArabicLetterAudioManifestEntry? arabicLetterAudioByLegacySeedId(String id) {
  return arabicLetterAudioManifestByLegacySeedId[id];
}

ArabicLetterAudioManifestEntry? arabicLetterAudioByAnyId(String id) {
  return arabicLetterAudioByCanonicalId(id) ??
      arabicLetterAudioByLegacySeedId(id);
}

List<String> arabicLetterAudioCandidateAssetPaths(String id) {
  final entry = arabicLetterAudioByAnyId(id);
  if (entry == null) return const <String>[];
  return <String>[entry.assetPath, ...entry.alternateAssetPaths];
}

String? arabicLetterAudioPrimaryAssetPath(String id) {
  return arabicLetterAudioByAnyId(id)?.assetPath;
}
