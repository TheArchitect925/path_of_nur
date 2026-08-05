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
    'assets/images/quran_teacher/placeholders/soft_placeholder.png';

const quranTeacherVisualManifest = <String, QuranTeacherVisualAssetEntry>{
  'letter_alif_apple': QuranTeacherVisualAssetEntry(
    id: 'letter_alif_apple',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/alif_apple.png',
    label: 'Alif Apple',
    category: 'letters',
  ),
  'letter_ba_ball': QuranTeacherVisualAssetEntry(
    id: 'letter_ba_ball',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ba_ball.png',
    label: 'Ba Ball',
    category: 'letters',
  ),
  'letter_ta_tree': QuranTeacherVisualAssetEntry(
    id: 'letter_ta_tree',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/ta_tree.png',
    label: 'Ta Tree',
    category: 'letters',
  ),
  'letter_jeem_juice': QuranTeacherVisualAssetEntry(
    id: 'letter_jeem_juice',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/jeem_juice.png',
    label: 'Jeem Juice',
    category: 'letters',
  ),
  'letter_seen_sun': QuranTeacherVisualAssetEntry(
    id: 'letter_seen_sun',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/seen_sun.png',
    label: 'Seen Sun',
    category: 'letters',
  ),
  'letter_meem_moon': QuranTeacherVisualAssetEntry(
    id: 'letter_meem_moon',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/meem_moon.png',
    label: 'Meem Moon',
    category: 'letters',
  ),
  'letter_noon_nest': QuranTeacherVisualAssetEntry(
    id: 'letter_noon_nest',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/noon_nest.png',
    label: 'Noon Nest',
    category: 'letters',
  ),
  'letter_waw_water': QuranTeacherVisualAssetEntry(
    id: 'letter_waw_water',
    assetPath: 'assets/images/quran_teacher/visual_mode/letters/waw_water.png',
    label: 'Waw Water',
    category: 'letters',
  ),
  'word_maa_water': QuranTeacherVisualAssetEntry(
    id: 'word_maa_water',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/maa_water.png',
    label: 'Maa Water',
    category: 'words',
  ),
  'word_shams_sun': QuranTeacherVisualAssetEntry(
    id: 'word_shams_sun',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/shams_sun.png',
    label: 'Shams Sun',
    category: 'words',
  ),
  'word_qamar_moon': QuranTeacherVisualAssetEntry(
    id: 'word_qamar_moon',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/qamar_moon.png',
    label: 'Qamar Moon',
    category: 'words',
  ),
  'word_kitab_book': QuranTeacherVisualAssetEntry(
    id: 'word_kitab_book',
    assetPath: 'assets/images/quran_teacher/visual_mode/words/kitab_book.png',
    label: 'Kitab Book',
    category: 'words',
  ),
};
