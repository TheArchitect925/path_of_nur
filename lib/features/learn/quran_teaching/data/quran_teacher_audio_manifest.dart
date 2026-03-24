import '../../../arabic/data/arabic_audio_manifest.dart';
import '../../../arabic/data/arabic_beginner_content_catalog.dart';
import '../../../arabic/domain/arabic_audio_models.dart';

class QuranTeacherAudioAssetEntry {
  const QuranTeacherAudioAssetEntry({
    required this.id,
    required this.assetPath,
    required this.label,
    required this.category,
    this.alternatePaths = const <String>[],
    this.voicePackId = 'standard_adult',
    this.playbackVariant = 'normal',
    this.reciterId,
    this.durationMs,
    this.isOptional = true,
  });

  final String id;
  final String assetPath;
  final String label;
  final String category;
  final List<String> alternatePaths;
  final String voicePackId;
  final String playbackVariant;
  final String? reciterId;
  final int? durationMs;
  final bool isOptional;
}

QuranTeacherAudioAssetEntry _letterEntryFromSharedAudio(
  ArabicLetterAudioManifestEntry entry,
) {
  return QuranTeacherAudioAssetEntry(
    id: entry.legacyQuranTeachingSeedId,
    assetPath: entry.assetPath,
    label: entry.adultLabel,
    category: 'letters',
    alternatePaths: entry.alternateAssetPaths,
  );
}

QuranTeacherAudioAssetEntry _sharedWordAudioEntry(
  String sharedId,
  String label, {
  List<String> alternatePaths = const <String>[],
}) {
  final entry = arabicSharedBeginnerWordById(sharedId)!;
  return QuranTeacherAudioAssetEntry(
    id: entry.audioLookupId!,
    assetPath: entry.audioAssetPath!,
    label: label,
    category: 'words',
    alternatePaths: alternatePaths,
  );
}

QuranTeacherAudioAssetEntry _sharedPhraseAudioEntry(
  String sharedId,
  String label, {
  List<String> alternatePaths = const <String>[],
}) {
  final entry = arabicSharedMiniPhraseById(sharedId)!;
  return QuranTeacherAudioAssetEntry(
    id: entry.audioLookupId!,
    assetPath: entry.audioAssetPath!,
    label: label,
    category: 'phrases',
    alternatePaths: alternatePaths,
  );
}

final quranTeacherAudioManifest = <String, QuranTeacherAudioAssetEntry>{
  for (final entry in arabicLetterAudioManifestByCanonicalId.values)
    entry.legacyQuranTeachingSeedId: _letterEntryFromSharedAudio(entry),
  'harakat_ba_fatha': QuranTeacherAudioAssetEntry(
    id: 'harakat_ba_fatha',
    assetPath: 'assets/audio/quran_teacher/harakat/ba_fatha.mp3',
    label: 'Ba',
    category: 'harakat',
  ),
  'harakat_ba_kasra': QuranTeacherAudioAssetEntry(
    id: 'harakat_ba_kasra',
    assetPath: 'assets/audio/quran_teacher/harakat/ba_kasra.mp3',
    label: 'Bi',
    category: 'harakat',
  ),
  'harakat_ba_damma': QuranTeacherAudioAssetEntry(
    id: 'harakat_ba_damma',
    assetPath: 'assets/audio/quran_teacher/harakat/ba_damma.mp3',
    label: 'Bu',
    category: 'harakat',
  ),
  'harakat_ta_fatha': QuranTeacherAudioAssetEntry(
    id: 'harakat_ta_fatha',
    assetPath: 'assets/audio/quran_teacher/harakat/ta_fatha.mp3',
    label: 'Ta',
    category: 'harakat',
  ),
  'harakat_ta_kasra': QuranTeacherAudioAssetEntry(
    id: 'harakat_ta_kasra',
    assetPath: 'assets/audio/quran_teacher/harakat/ta_kasra.mp3',
    label: 'Ti',
    category: 'harakat',
  ),
  'harakat_ta_damma': QuranTeacherAudioAssetEntry(
    id: 'harakat_ta_damma',
    assetPath: 'assets/audio/quran_teacher/harakat/ta_damma.mp3',
    label: 'Tu',
    category: 'harakat',
  ),
  'harakat_meem_fatha': QuranTeacherAudioAssetEntry(
    id: 'harakat_meem_fatha',
    assetPath: 'assets/audio/quran_teacher/harakat/meem_fatha.mp3',
    label: 'Ma',
    category: 'harakat',
  ),
  'harakat_meem_kasra': QuranTeacherAudioAssetEntry(
    id: 'harakat_meem_kasra',
    assetPath: 'assets/audio/quran_teacher/harakat/meem_kasra.mp3',
    label: 'Mi',
    category: 'harakat',
  ),
  'harakat_meem_damma': QuranTeacherAudioAssetEntry(
    id: 'harakat_meem_damma',
    assetPath: 'assets/audio/quran_teacher/harakat/meem_damma.mp3',
    label: 'Mu',
    category: 'harakat',
  ),
  'word_rabb': _sharedWordAudioEntry('rabb', 'Rabb'),
  'word_min': QuranTeacherAudioAssetEntry(
    id: 'word_min',
    assetPath: 'assets/audio/quran_teacher/words/min.mp3',
    label: 'Min',
    category: 'words',
  ),
  'word_fee': QuranTeacherAudioAssetEntry(
    id: 'word_fee',
    assetPath: 'assets/audio/quran_teacher/words/fee.mp3',
    label: 'Fee',
    category: 'words',
    alternatePaths: <String>['assets/audio/quran_teacher/words/fi.mp3'],
  ),
  'word_ilm': QuranTeacherAudioAssetEntry(
    id: 'word_ilm',
    assetPath: 'assets/audio/quran_teacher/words/ilm.mp3',
    label: 'Ilm',
    category: 'words',
  ),
  'word_abd': QuranTeacherAudioAssetEntry(
    id: 'word_abd',
    assetPath: 'assets/audio/quran_teacher/words/abd.mp3',
    label: 'Abd',
    category: 'words',
  ),
  'word_allah': QuranTeacherAudioAssetEntry(
    id: 'word_allah',
    assetPath: 'assets/audio/quran_teacher/words/allah.mp3',
    label: 'Allah',
    category: 'words',
  ),
  'word_kitab': _sharedWordAudioEntry('kitab', 'Kitab'),
  'word_rahmah': QuranTeacherAudioAssetEntry(
    id: 'word_rahmah',
    assetPath: 'assets/audio/quran_teacher/words/rahmah.mp3',
    label: 'Rahmah',
    category: 'words',
  ),
  'word_huda': QuranTeacherAudioAssetEntry(
    id: 'word_huda',
    assetPath: 'assets/audio/quran_teacher/words/huda.mp3',
    label: 'Huda',
    category: 'words',
  ),
  'word_noor': _sharedWordAudioEntry(
    'noor',
    'Noor',
    alternatePaths: <String>['assets/audio/quran_teacher/words/nur.mp3'],
  ),
  'word_maa': QuranTeacherAudioAssetEntry(
    id: 'word_maa',
    assetPath: 'assets/audio/quran_teacher/words/maa.mp3',
    label: 'Maa',
    category: 'words',
  ),
  'word_shams': QuranTeacherAudioAssetEntry(
    id: 'word_shams',
    assetPath: 'assets/audio/quran_teacher/words/shams.mp3',
    label: 'Shams',
    category: 'words',
  ),
  'word_qamar': QuranTeacherAudioAssetEntry(
    id: 'word_qamar',
    assetPath: 'assets/audio/quran_teacher/words/qamar.mp3',
    label: 'Qamar',
    category: 'words',
  ),
  'phrase_bismillah': _sharedPhraseAudioEntry('bismillah', 'Bismillah'),
  'phrase_alhamdulillah': _sharedPhraseAudioEntry(
    'alhamdulillah',
    'Alhamdulillah',
  ),
  'phrase_rabb_al_alamin': _sharedPhraseAudioEntry(
    'rabbil-alamin',
    'Rabb al alamin',
    alternatePaths: <String>[
      'assets/audio/quran_teacher/phrases/rabbil_alamin.mp3',
    ],
  ),
  'phrase_maliki_yawm_id_deen': QuranTeacherAudioAssetEntry(
    id: 'phrase_maliki_yawm_id_deen',
    assetPath: 'assets/audio/quran_teacher/phrases/maliki_yawm_id_deen.mp3',
    label: 'Maliki yawm id deen',
    category: 'phrases',
  ),
  'phrase_iyyaka_nabud': _sharedPhraseAudioEntry(
    'iyyaka-nabudu',
    'Iyyaka nabud',
  ),
  'rule_shaddah_intro': QuranTeacherAudioAssetEntry(
    id: 'rule_shaddah_intro',
    assetPath: 'assets/audio/quran_teacher/rules/shaddah_intro.mp3',
    label: 'Shaddah intro',
    category: 'rules',
  ),
  'rule_sukun_intro': QuranTeacherAudioAssetEntry(
    id: 'rule_sukun_intro',
    assetPath: 'assets/audio/quran_teacher/rules/sukun_intro.mp3',
    label: 'Sukun intro',
    category: 'rules',
  ),
  'rule_tanween_damma': QuranTeacherAudioAssetEntry(
    id: 'rule_tanween_damma',
    assetPath: 'assets/audio/quran_teacher/rules/tanween_damma.mp3',
    label: 'Tanween damma',
    category: 'rules',
  ),
  'rule_sun_letter_ash_shams': QuranTeacherAudioAssetEntry(
    id: 'rule_sun_letter_ash_shams',
    assetPath:
        'assets/audio/quran_teacher/rules/sun_letter_example_ash_shams.mp3',
    label: 'Ash-shams',
    category: 'rules',
  ),
  'rule_moon_letter_al_qamar': QuranTeacherAudioAssetEntry(
    id: 'rule_moon_letter_al_qamar',
    assetPath:
        'assets/audio/quran_teacher/rules/moon_letter_example_al_qamar.mp3',
    label: 'Al-qamar',
    category: 'rules',
  ),
  'surah_001_ayah_001': QuranTeacherAudioAssetEntry(
    id: 'surah_001_ayah_001',
    assetPath: 'assets/audio/quran_teacher/surahs/surah_001_ayah_001.mp3',
    label: 'Surah 1 Ayah 1',
    category: 'surahs',
  ),
  'surah_001_ayah_002': QuranTeacherAudioAssetEntry(
    id: 'surah_001_ayah_002',
    assetPath: 'assets/audio/quran_teacher/surahs/surah_001_ayah_002.mp3',
    label: 'Surah 1 Ayah 2',
    category: 'surahs',
  ),
  'surah_112_ayah_001': QuranTeacherAudioAssetEntry(
    id: 'surah_112_ayah_001',
    assetPath: 'assets/audio/quran_teacher/surahs/surah_112_ayah_001.mp3',
    label: 'Surah 112 Ayah 1',
    category: 'surahs',
  ),
};
