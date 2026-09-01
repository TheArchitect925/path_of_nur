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
    gloss: 'الله (God)',
    transliteration: 'الله',
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

/// The hand-written entries above, re-keyed by [normalizeQuranWordForGlossary]
/// so they match the Uthmani script the reader actually renders. They override
/// the curated dataset where both know a word — their glosses carry more care.
final Map<String, QuranWordGloss> curatedGlossaryOverrides = {
  for (final entry in _commonWordGlossary.entries)
    normalizeQuranWordForGlossary(entry.key): entry.value,
};

final RegExp _glossaryDiacriticsRegex = RegExp(
  r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]',
);

/// Folds an Uthmani-script token down to the plain form glossaries key on.
/// The dagger-alef carriers come first — the Uthmani spellings of words like
/// الصلوة and الحيوة write a waw or ya where plain script writes alef, so the
/// carrier must fold to alef before the diacritics (dagger alef included)
/// are stripped away.
String normalizeQuranWordForGlossary(String token) {
  return token
      .trim()
      .replaceAll('وٰ', 'ا')
      .replaceAll('ىٰ', 'ا')
      .replaceAll(_glossaryDiacriticsRegex, '')
      .replaceAll('ٱ', 'ا')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}

/// Attached particles worth peeling off when a whole token misses: the
/// definite article and the one-letter conjunctions/prepositions that write
/// onto the next word. Longest first so والله tries الله before لله.
const List<String> _glossaryAttachedPrefixes = [
  'وال',
  'فال',
  'بال',
  'كال',
  'لل',
  'ال',
  'و',
  'ف',
  'ب',
  'ك',
  'ل',
];

QuranWordGloss? _lookupGloss(
  String normalized,
  Map<String, QuranWordGloss> glossary,
) {
  final exact = glossary[normalized];
  if (exact != null) return exact;
  // ل + ال contracts to لل with the article's alef elided (لِلَّهِ, لِلرَّحْمَٰنِ).
  // Restoring the alef re-finds fused-article lexemes like الله.
  if (normalized.startsWith('لل')) {
    final restored = glossary['ا$normalized'];
    if (restored != null) return restored;
  }
  for (final prefix in _glossaryAttachedPrefixes) {
    if (!normalized.startsWith(prefix)) continue;
    final stem = normalized.substring(prefix.length);
    if (stem.length < 2) continue;
    final match = glossary[stem];
    if (match != null) return match;
  }
  return null;
}

/// Splits an ayah into words and glosses the ones the glossary knows.
/// Unknown words are dropped rather than padded with filler — a chip that
/// says nothing teaches nothing. Each returned gloss keeps the word as it
/// appears in the ayah so the learner can match chip to text.
List<QuranWordGloss> buildWordGlosses(
  String arabicAyahText, {
  Map<String, QuranWordGloss> glossary = const {},
}) {
  final clean = arabicAyahText
      .replaceAll(RegExp(r'[\u06D6-\u06DC\u06DE\u06E9]'), ' ')
      .replaceAll(RegExp(r'[0-9٠-٩]'), ' ')
      .replaceAll(RegExp('[.,;:!?(){}\\[\\]"\\\']'), ' ')
      .replaceAll('ـ', ' ')
      .trim();
  if (clean.isEmpty) return const [];

  final effectiveGlossary = glossary.isEmpty
      ? curatedGlossaryOverrides
      : glossary;
  final words = clean.split(RegExp(r'\s+'));
  final output = <QuranWordGloss>[];
  for (final original in words) {
    final displayWord = original.replaceAll(RegExp(r'[^\u0600-\u06FF]'), '');
    if (displayWord.isEmpty) continue;
    final normalized = normalizeQuranWordForGlossary(displayWord);
    if (normalized.isEmpty) continue;
    final known = _lookupGloss(normalized, effectiveGlossary);
    if (known == null) continue;
    output.add(
      QuranWordGloss(
        arabic: displayWord,
        gloss: known.gloss,
        transliteration: known.transliteration,
      ),
    );
  }
  return output;
}
