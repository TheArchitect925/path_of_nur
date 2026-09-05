/// One picture per letter of the alphabet, shared by the Qur'an teacher's
/// visual mode and the kids Letters lessons.
///
/// The word starts with the letter's sound in English where English has
/// that sound (ba, ball) and is a familiar Arabic word where it does not
/// (kha, khayma). The pictures are drawn by tooling/art_src/kids_art
/// (the `qt` pack) into assets/images/quran_teacher/visual_mode/letters/.
class ArabicLetterPicture {
  const ArabicLetterPicture({
    required this.letterId,
    required this.word,
    required this.label,
    this.arabicWord,
    this.fileStem,
  });

  /// The canonical letter id from the alphabet catalog.
  final String letterId;

  /// The file stem after the letter, and the word a child says.
  final String word;

  /// The teacher's manifest label, e.g. "Ba Ball".
  final String label;

  /// The Arabic word when the picture word is one; null for English words.
  final String? arabicWord;

  /// The file name when it does not follow `<letterId>_<word>` (jeem_juice).
  final String? fileStem;

  String get _stem => fileStem ?? '${letterId}_$word';

  String get assetPath =>
      'assets/images/quran_teacher/visual_mode/letters/$_stem.webp';

  /// "ball", or "khayma (tent)".
  String get spokenWord => arabicWord == null ? word : '$arabicWord ($word)';

  /// The teacher manifest key.
  String get manifestId => 'letter_$_stem';
}

const List<ArabicLetterPicture> arabicLetterPictures = [
  ArabicLetterPicture(letterId: 'alif', word: 'apple', label: 'Alif Apple'),
  ArabicLetterPicture(letterId: 'ba', word: 'ball', label: 'Ba Ball'),
  ArabicLetterPicture(letterId: 'ta', word: 'tree', label: 'Ta Tree'),
  ArabicLetterPicture(letterId: 'tha', word: 'thread', label: 'Tha Thread'),
  ArabicLetterPicture(
    letterId: 'jim',
    word: 'juice',
    label: 'Jeem Juice',
    fileStem: 'jeem_juice',
  ),
  ArabicLetterPicture(
    letterId: 'ha',
    word: 'horse',
    label: 'Ha Hisan',
    arabicWord: 'hisan',
  ),
  ArabicLetterPicture(
    letterId: 'kha',
    word: 'tent',
    label: 'Kha Khayma',
    arabicWord: 'khayma',
  ),
  ArabicLetterPicture(letterId: 'dal', word: 'duck', label: 'Dal Duck'),
  ArabicLetterPicture(
    letterId: 'dhal',
    word: 'corn',
    label: 'Dhal Dhurra',
    arabicWord: 'dhurra',
  ),
  ArabicLetterPicture(letterId: 'ra', word: 'rabbit', label: 'Ra Rabbit'),
  ArabicLetterPicture(letterId: 'zay', word: 'zebra', label: 'Zay Zebra'),
  ArabicLetterPicture(letterId: 'seen', word: 'sun', label: 'Seen Sun'),
  ArabicLetterPicture(letterId: 'sheen', word: 'ship', label: 'Sheen Ship'),
  ArabicLetterPicture(
    letterId: 'sad',
    word: 'falcon',
    label: 'Sad Saqr',
    arabicWord: 'saqr',
  ),
  ArabicLetterPicture(
    letterId: 'dad',
    word: 'frog',
    label: 'Dad Dafda',
    arabicWord: 'dafda',
  ),
  ArabicLetterPicture(
    letterId: 'taa',
    word: 'drum',
    label: 'Taa Tabl',
    arabicWord: 'tabl',
  ),
  ArabicLetterPicture(
    letterId: 'zaa',
    word: 'envelope',
    label: 'Zaa Zarf',
    arabicWord: 'zarf',
  ),
  ArabicLetterPicture(
    letterId: 'ain',
    word: 'grapes',
    label: 'Ain Inab',
    arabicWord: 'inab',
  ),
  ArabicLetterPicture(
    letterId: 'ghain',
    word: 'cloud',
    label: 'Ghain Ghaym',
    arabicWord: 'ghaym',
  ),
  ArabicLetterPicture(letterId: 'fa', word: 'fish', label: 'Fa Fish'),
  ArabicLetterPicture(
    letterId: 'qaf',
    word: 'pen',
    label: 'Qaf Qalam',
    arabicWord: 'qalam',
  ),
  ArabicLetterPicture(letterId: 'kaf', word: 'kite', label: 'Kaf Kite'),
  ArabicLetterPicture(letterId: 'lam', word: 'lemon', label: 'Lam Lemon'),
  ArabicLetterPicture(letterId: 'meem', word: 'moon', label: 'Meem Moon'),
  ArabicLetterPicture(letterId: 'noon', word: 'nest', label: 'Noon Nest'),
  ArabicLetterPicture(
    letterId: 'ha2',
    word: 'gift',
    label: 'Haa Hadiya',
    arabicWord: 'hadiya',
  ),
  ArabicLetterPicture(letterId: 'waw', word: 'water', label: 'Waw Water'),
  ArabicLetterPicture(letterId: 'ya', word: 'yoyo', label: 'Ya Yoyo'),
];

final Map<String, ArabicLetterPicture> _byLetterId = {
  for (final picture in arabicLetterPictures) picture.letterId: picture,
};

ArabicLetterPicture? arabicLetterPictureFor(String letterId) =>
    _byLetterId[letterId];
