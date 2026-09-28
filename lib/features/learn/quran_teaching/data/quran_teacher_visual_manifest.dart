class QuranTeacherVisualAssetEntry {
  const QuranTeacherVisualAssetEntry({
    required this.id,
    required this.assetPath,
    required this.label,
    required this.category,
    this.isOptional = true,
  });

  final String id;
  final String assetPath;
  final String label;
  final String category;
  final bool isOptional;
}

const quranTeacherPlaceholderImagePath =
    'assets/images/quran_teacher/placeholders/soft_placeholder.webp';

const quranTeacherVisualManifest = <String, QuranTeacherVisualAssetEntry>{
  'letter_alif_apple': QuranTeacherVisualAssetEntry(
    id: 'letter_alif_apple',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/alif_apple.webp',
    label: 'Alif Apple',
    category: 'letters',
  ),
  'letter_ba_ball': QuranTeacherVisualAssetEntry(
    id: 'letter_ba_ball',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.webp',
    label: 'Ba Ball',
    category: 'letters',
  ),
  'letter_ta_tree': QuranTeacherVisualAssetEntry(
    id: 'letter_ta_tree',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.webp',
    label: 'Ta Tree',
    category: 'letters',
  ),
  'letter_jeem_juice': QuranTeacherVisualAssetEntry(
    id: 'letter_jeem_juice',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/jeem_juice.webp',
    label: 'Jeem Juice',
    category: 'letters',
  ),
  'letter_seen_sun': QuranTeacherVisualAssetEntry(
    id: 'letter_seen_sun',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.webp',
    label: 'Seen Sun',
    category: 'letters',
  ),
  'letter_meem_moon': QuranTeacherVisualAssetEntry(
    id: 'letter_meem_moon',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.webp',
    label: 'Meem Moon',
    category: 'letters',
  ),
  'letter_noon_nest': QuranTeacherVisualAssetEntry(
    id: 'letter_noon_nest',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.webp',
    label: 'Noon Nest',
    category: 'letters',
  ),
  'letter_waw_water': QuranTeacherVisualAssetEntry(
    id: 'letter_waw_water',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/waw_water.webp',
    label: 'Waw Water',
    category: 'letters',
  ),
  'letter_tha_thread': QuranTeacherVisualAssetEntry(
    id: 'letter_tha_thread',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/tha_thread.webp',
    label: 'Tha Thread',
    category: 'letters',
  ),
  'letter_ha_horse': QuranTeacherVisualAssetEntry(
    id: 'letter_ha_horse',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ha_horse.webp',
    label: 'Ha Hisan',
    category: 'letters',
  ),
  'letter_kha_tent': QuranTeacherVisualAssetEntry(
    id: 'letter_kha_tent',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/kha_tent.webp',
    label: 'Kha Khayma',
    category: 'letters',
  ),
  'letter_dal_duck': QuranTeacherVisualAssetEntry(
    id: 'letter_dal_duck',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/dal_duck.webp',
    label: 'Dal Duck',
    category: 'letters',
  ),
  'letter_dhal_corn': QuranTeacherVisualAssetEntry(
    id: 'letter_dhal_corn',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/dhal_corn.webp',
    label: 'Dhal Dhurra',
    category: 'letters',
  ),
  'letter_ra_rabbit': QuranTeacherVisualAssetEntry(
    id: 'letter_ra_rabbit',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ra_rabbit.webp',
    label: 'Ra Rabbit',
    category: 'letters',
  ),
  'letter_zay_zebra': QuranTeacherVisualAssetEntry(
    id: 'letter_zay_zebra',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/zay_zebra.webp',
    label: 'Zay Zebra',
    category: 'letters',
  ),
  'letter_sheen_ship': QuranTeacherVisualAssetEntry(
    id: 'letter_sheen_ship',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/sheen_ship.webp',
    label: 'Sheen Ship',
    category: 'letters',
  ),
  'letter_sad_falcon': QuranTeacherVisualAssetEntry(
    id: 'letter_sad_falcon',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/sad_falcon.webp',
    label: 'Sad Saqr',
    category: 'letters',
  ),
  'letter_dad_frog': QuranTeacherVisualAssetEntry(
    id: 'letter_dad_frog',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/dad_frog.webp',
    label: 'Dad Dafda',
    category: 'letters',
  ),
  'letter_taa_drum': QuranTeacherVisualAssetEntry(
    id: 'letter_taa_drum',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/taa_drum.webp',
    label: 'Taa Tabl',
    category: 'letters',
  ),
  'letter_zaa_envelope': QuranTeacherVisualAssetEntry(
    id: 'letter_zaa_envelope',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/zaa_envelope.webp',
    label: 'Zaa Zarf',
    category: 'letters',
  ),
  'letter_ain_grapes': QuranTeacherVisualAssetEntry(
    id: 'letter_ain_grapes',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/ain_grapes.webp',
    label: 'Ain Inab',
    category: 'letters',
  ),
  'letter_ghain_cloud': QuranTeacherVisualAssetEntry(
    id: 'letter_ghain_cloud',
    assetPath:
        'assets/images/quran_teacher/visual_mode/letters/ghain_cloud.webp',
    label: 'Ghain Ghaym',
    category: 'letters',
  ),
  'letter_fa_fish': QuranTeacherVisualAssetEntry(
    id: 'letter_fa_fish',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/fa_fish.webp',
    label: 'Fa Fish',
    category: 'letters',
  ),
  'letter_qaf_pen': QuranTeacherVisualAssetEntry(
    id: 'letter_qaf_pen',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/qaf_pen.webp',
    label: 'Qaf Qalam',
    category: 'letters',
  ),
  'letter_kaf_kite': QuranTeacherVisualAssetEntry(
    id: 'letter_kaf_kite',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/kaf_kite.webp',
    label: 'Kaf Kite',
    category: 'letters',
  ),
  'letter_lam_lemon': QuranTeacherVisualAssetEntry(
    id: 'letter_lam_lemon',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/lam_lemon.webp',
    label: 'Lam Lemon',
    category: 'letters',
  ),
  'letter_ya_yoyo': QuranTeacherVisualAssetEntry(
    id: 'letter_ya_yoyo',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ya_yoyo.webp',
    label: 'Ya Yoyo',
    category: 'letters',
  ),
  'letter_ha2_gift': QuranTeacherVisualAssetEntry(
    id: 'letter_ha2_gift',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ha2_gift.webp',
    label: 'Haa Hadiya',
    category: 'letters',
  ),
  'word_maa_water': QuranTeacherVisualAssetEntry(
    id: 'word_maa_water',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/maa_water.webp',
    label: 'Maa Water',
    category: 'words',
  ),
  'word_shams_sun': QuranTeacherVisualAssetEntry(
    id: 'word_shams_sun',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/shams_sun.webp',
    label: 'Shams Sun',
    category: 'words',
  ),
  'word_qamar_moon': QuranTeacherVisualAssetEntry(
    id: 'word_qamar_moon',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/qamar_moon.webp',
    label: 'Qamar Moon',
    category: 'words',
  ),
  'word_kitab_book': QuranTeacherVisualAssetEntry(
    id: 'word_kitab_book',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/kitab_book.webp',
    label: 'Kitab Book',
    category: 'words',
  ),
};
