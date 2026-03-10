class QuranWordGloss {
  const QuranWordGloss({
    required this.arabic,
    required this.gloss,
    required this.transliteration,
  });

  final String arabic;
  final String gloss;
  final String transliteration;
}

const Map<String, QuranWordGloss> _commonWordGlossary = {
  'الله': QuranWordGloss(
    arabic: 'الله',
    gloss: 'Allah (God)',
    transliteration: 'Allah',
  ),
  'رب': QuranWordGloss(arabic: 'رب', gloss: 'Lord', transliteration: 'Rabb'),
  'رحمن': QuranWordGloss(
    arabic: 'رحمن',
    gloss: 'The Most Merciful',
    transliteration: 'Ar-Rahman',
  ),
  'رحيم': QuranWordGloss(
    arabic: 'رحيم',
    gloss: 'The Especially Merciful',
    transliteration: 'Ar-Rahim',
  ),
  'كتاب': QuranWordGloss(
    arabic: 'كتاب',
    gloss: 'Book',
    transliteration: 'Kitab',
  ),
  'صلاة': QuranWordGloss(
    arabic: 'صلاة',
    gloss: 'Prayer',
    transliteration: 'Salah',
  ),
  'زكاة': QuranWordGloss(
    arabic: 'زكاة',
    gloss: 'Purifying charity',
    transliteration: 'Zakah',
  ),
  'صبر': QuranWordGloss(
    arabic: 'صبر',
    gloss: 'Patience',
    transliteration: 'Sabr',
  ),
  'شكر': QuranWordGloss(
    arabic: 'شكر',
    gloss: 'Gratitude',
    transliteration: 'Shukr',
  ),
  'نور': QuranWordGloss(arabic: 'نور', gloss: 'Light', transliteration: 'Nur'),
  'قلب': QuranWordGloss(arabic: 'قلب', gloss: 'Heart', transliteration: 'Qalb'),
  'جنة': QuranWordGloss(
    arabic: 'جنة',
    gloss: 'Garden / Paradise',
    transliteration: 'Jannah',
  ),
  'نار': QuranWordGloss(arabic: 'نار', gloss: 'Fire', transliteration: 'Nar'),
  'هدى': QuranWordGloss(
    arabic: 'هدى',
    gloss: 'Guidance',
    transliteration: 'Huda',
  ),
  'حق': QuranWordGloss(arabic: 'حق', gloss: 'Truth', transliteration: 'Haqq'),
  'آية': QuranWordGloss(
    arabic: 'آية',
    gloss: 'Sign / Verse',
    transliteration: 'Ayah',
  ),
};

List<QuranWordGloss> buildWordGlosses(String arabicAyahText) {
  final clean = arabicAyahText
      .replaceAll(RegExp(r'[ۖۗۚۛۜ۞۩]'), ' ')
      .replaceAll(RegExp(r'[0-9٠-٩]'), ' ')
      .replaceAll(RegExp('[.,;:!?(){}\\[\\]"\\\']'), ' ')
      .replaceAll('ـ', ' ')
      .trim();
  if (clean.isEmpty) return const [];

  final words = clean.split(RegExp(r'\s+'));
  final output = <QuranWordGloss>[];
  for (final original in words) {
    final normalized = original.replaceAll(RegExp(r'[^\u0600-\u06FF]'), '');
    if (normalized.isEmpty) continue;
    final known = _commonWordGlossary[normalized];
    if (known != null) {
      output.add(known);
      continue;
    }
    output.add(
      QuranWordGloss(
        arabic: normalized,
        gloss: 'Contextual Quranic word',
        transliteration: normalized,
      ),
    );
  }
  return output;
}
