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

const quranTeacherAudioManifest = <String, QuranTeacherAudioAssetEntry>{
  'letter_alif': QuranTeacherAudioAssetEntry(
    id: 'letter_alif',
    assetPath: 'assets/audio/quran_teacher/letters/alif.mp3',
    label: 'Alif',
    category: 'letters',
  ),
  'letter_ba': QuranTeacherAudioAssetEntry(
    id: 'letter_ba',
    assetPath: 'assets/audio/quran_teacher/letters/ba.mp3',
    label: 'Ba',
    category: 'letters',
  ),
  'letter_ta': QuranTeacherAudioAssetEntry(
    id: 'letter_ta',
    assetPath: 'assets/audio/quran_teacher/letters/ta.mp3',
    label: 'Ta',
    category: 'letters',
  ),
  'letter_tha': QuranTeacherAudioAssetEntry(
    id: 'letter_tha',
    assetPath: 'assets/audio/quran_teacher/letters/tha.mp3',
    label: 'Tha',
    category: 'letters',
  ),
  'letter_jeem': QuranTeacherAudioAssetEntry(
    id: 'letter_jeem',
    assetPath: 'assets/audio/quran_teacher/letters/jeem.mp3',
    label: 'Jeem',
    category: 'letters',
  ),
  'letter_haa_soft': QuranTeacherAudioAssetEntry(
    id: 'letter_haa_soft',
    assetPath: 'assets/audio/quran_teacher/letters/haa_soft.mp3',
    label: 'Haa',
    category: 'letters',
    alternatePaths: <String>['assets/audio/quran_teacher/letters/haa.mp3'],
  ),
  'letter_khaa': QuranTeacherAudioAssetEntry(
    id: 'letter_khaa',
    assetPath: 'assets/audio/quran_teacher/letters/khaa.mp3',
    label: 'Khaa',
    category: 'letters',
  ),
  'letter_daal': QuranTeacherAudioAssetEntry(
    id: 'letter_daal',
    assetPath: 'assets/audio/quran_teacher/letters/daal.mp3',
    label: 'Daal',
    category: 'letters',
  ),
  'letter_dhaal': QuranTeacherAudioAssetEntry(
    id: 'letter_dhaal',
    assetPath: 'assets/audio/quran_teacher/letters/dhaal.mp3',
    label: 'Dhaal',
    category: 'letters',
  ),
  'letter_raa': QuranTeacherAudioAssetEntry(
    id: 'letter_raa',
    assetPath: 'assets/audio/quran_teacher/letters/raa.mp3',
    label: 'Raa',
    category: 'letters',
  ),
  'letter_zay': QuranTeacherAudioAssetEntry(
    id: 'letter_zay',
    assetPath: 'assets/audio/quran_teacher/letters/zay.mp3',
    label: 'Zay',
    category: 'letters',
  ),
  'letter_seen': QuranTeacherAudioAssetEntry(
    id: 'letter_seen',
    assetPath: 'assets/audio/quran_teacher/letters/seen.mp3',
    label: 'Seen',
    category: 'letters',
  ),
  'letter_sheen': QuranTeacherAudioAssetEntry(
    id: 'letter_sheen',
    assetPath: 'assets/audio/quran_teacher/letters/sheen.mp3',
    label: 'Sheen',
    category: 'letters',
  ),
  'letter_saad': QuranTeacherAudioAssetEntry(
    id: 'letter_saad',
    assetPath: 'assets/audio/quran_teacher/letters/saad.mp3',
    label: 'Saad',
    category: 'letters',
  ),
  'letter_daad': QuranTeacherAudioAssetEntry(
    id: 'letter_daad',
    assetPath: 'assets/audio/quran_teacher/letters/daad.mp3',
    label: 'Daad',
    category: 'letters',
  ),
  'letter_taa_heavy': QuranTeacherAudioAssetEntry(
    id: 'letter_taa_heavy',
    assetPath: 'assets/audio/quran_teacher/letters/taa_heavy.mp3',
    label: 'Taa',
    category: 'letters',
  ),
  'letter_zaa_heavy': QuranTeacherAudioAssetEntry(
    id: 'letter_zaa_heavy',
    assetPath: 'assets/audio/quran_teacher/letters/zaa_heavy.mp3',
    label: 'Zaa',
    category: 'letters',
  ),
  'letter_ayn': QuranTeacherAudioAssetEntry(
    id: 'letter_ayn',
    assetPath: 'assets/audio/quran_teacher/letters/ayn.mp3',
    label: 'Ayn',
    category: 'letters',
  ),
  'letter_ghayn': QuranTeacherAudioAssetEntry(
    id: 'letter_ghayn',
    assetPath: 'assets/audio/quran_teacher/letters/ghayn.mp3',
    label: 'Ghayn',
    category: 'letters',
  ),
  'letter_faa': QuranTeacherAudioAssetEntry(
    id: 'letter_faa',
    assetPath: 'assets/audio/quran_teacher/letters/faa.mp3',
    label: 'Faa',
    category: 'letters',
  ),
  'letter_qaaf': QuranTeacherAudioAssetEntry(
    id: 'letter_qaaf',
    assetPath: 'assets/audio/quran_teacher/letters/qaaf.mp3',
    label: 'Qaaf',
    category: 'letters',
  ),
  'letter_kaaf': QuranTeacherAudioAssetEntry(
    id: 'letter_kaaf',
    assetPath: 'assets/audio/quran_teacher/letters/kaaf.mp3',
    label: 'Kaaf',
    category: 'letters',
  ),
  'letter_laam': QuranTeacherAudioAssetEntry(
    id: 'letter_laam',
    assetPath: 'assets/audio/quran_teacher/letters/laam.mp3',
    label: 'Laam',
    category: 'letters',
  ),
  'letter_meem': QuranTeacherAudioAssetEntry(
    id: 'letter_meem',
    assetPath: 'assets/audio/quran_teacher/letters/meem.mp3',
    label: 'Meem',
    category: 'letters',
  ),
  'letter_noon': QuranTeacherAudioAssetEntry(
    id: 'letter_noon',
    assetPath: 'assets/audio/quran_teacher/letters/noon.mp3',
    label: 'Noon',
    category: 'letters',
  ),
  'letter_haa': QuranTeacherAudioAssetEntry(
    id: 'letter_haa',
    assetPath: 'assets/audio/quran_teacher/letters/haa.mp3',
    label: 'Haa',
    category: 'letters',
  ),
  'letter_waw': QuranTeacherAudioAssetEntry(
    id: 'letter_waw',
    assetPath: 'assets/audio/quran_teacher/letters/waw.mp3',
    label: 'Waw',
    category: 'letters',
  ),
  'letter_yaa': QuranTeacherAudioAssetEntry(
    id: 'letter_yaa',
    assetPath: 'assets/audio/quran_teacher/letters/yaa.mp3',
    label: 'Yaa',
    category: 'letters',
  ),
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
  'word_rabb': QuranTeacherAudioAssetEntry(
    id: 'word_rabb',
    assetPath: 'assets/audio/quran_teacher/words/rabb.mp3',
    label: 'Rabb',
    category: 'words',
  ),
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
  'word_noor': QuranTeacherAudioAssetEntry(
    id: 'word_noor',
    assetPath: 'assets/audio/quran_teacher/words/noor.mp3',
    label: 'Noor',
    category: 'words',
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
  'phrase_bismillah': QuranTeacherAudioAssetEntry(
    id: 'phrase_bismillah',
    assetPath: 'assets/audio/quran_teacher/phrases/bismillah.mp3',
    label: 'Bismillah',
    category: 'phrases',
  ),
  'phrase_alhamdulillah': QuranTeacherAudioAssetEntry(
    id: 'phrase_alhamdulillah',
    assetPath: 'assets/audio/quran_teacher/phrases/alhamdulillah.mp3',
    label: 'Alhamdulillah',
    category: 'phrases',
  ),
  'phrase_rabb_al_alamin': QuranTeacherAudioAssetEntry(
    id: 'phrase_rabb_al_alamin',
    assetPath: 'assets/audio/quran_teacher/phrases/rabb_al_alamin.mp3',
    label: 'Rabb al alamin',
    category: 'phrases',
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
  'phrase_iyyaka_nabud': QuranTeacherAudioAssetEntry(
    id: 'phrase_iyyaka_nabud',
    assetPath: 'assets/audio/quran_teacher/phrases/iyyaka_nabud.mp3',
    label: 'Iyyaka nabud',
    category: 'phrases',
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
    assetPath: 'assets/audio/quran_teacher/rules/sun_letter_example_ash_shams.mp3',
    label: 'Ash-shams',
    category: 'rules',
  ),
  'rule_moon_letter_al_qamar': QuranTeacherAudioAssetEntry(
    id: 'rule_moon_letter_al_qamar',
    assetPath: 'assets/audio/quran_teacher/rules/moon_letter_example_al_qamar.mp3',
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
