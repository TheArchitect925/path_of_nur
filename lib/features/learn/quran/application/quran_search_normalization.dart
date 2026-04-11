List<String> tokenizeQuranSearchText(String value) {
  final normalized = normalizeQuranSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

List<String> tokenizeQuranTransliterationSearchText(String value) {
  final normalized = normalizeQuranTransliterationSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

List<String> tokenizeQuranArabicSearchText(String value) {
  final normalized = normalizeQuranArabicSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

String normalizeQuranSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r"[‘’']"), '')
      .replaceAll(RegExp(r'[^\p{L}\p{N}:\s-]', unicode: true), ' ')
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String normalizeQuranTransliterationSearchText(String value) {
  var normalized = normalizeQuranSearchText(value)
      .replaceAll('ph', 'f')
      .replaceAll('ou', 'u')
      .replaceAll('oo', 'u')
      .replaceAll('ee', 'i')
      .replaceAll('ei', 'i')
      .replaceAll('aa', 'a')
      .replaceAll('e', 'i')
      .replaceAll('o', 'u');
  normalized = normalized.replaceAll(RegExp(r'([aiu])\1+'), r'$1');
  return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
}

Set<String> buildQuranTransliterationSearchForms(String value) {
  final normalized = normalizeQuranTransliterationSearchText(value);
  if (normalized.isEmpty) {
    return const <String>{};
  }
  final tokens = normalized
      .split(' ')
      .where((token) => token.isNotEmpty)
      .toList(growable: false);
  if (tokens.isEmpty) {
    return const <String>{};
  }

  final forms = <String>{tokens.join(' '), tokens.join()};

  final withoutStandaloneArticles = tokens
      .where((token) => !_transliterationArticleTokens.contains(token))
      .toList(growable: false);
  if (withoutStandaloneArticles.isNotEmpty &&
      withoutStandaloneArticles.length != tokens.length) {
    forms
      ..add(withoutStandaloneArticles.join(' '))
      ..add(withoutStandaloneArticles.join());
  }

  final strippedLeadingArticle = _stripLeadingArticlePrefix(tokens.first);
  if (strippedLeadingArticle != null) {
    final updatedTokens = <String>[strippedLeadingArticle, ...tokens.skip(1)];
    forms
      ..add(updatedTokens.join(' '))
      ..add(updatedTokens.join());
  }

  return forms.where((form) => form.trim().isNotEmpty).toSet();
}

String normalizeQuranArabicSearchText(String value) {
  return value
      .replaceAll('\u0670', 'ا')
      .replaceAll(RegExp(r'[\u064B-\u065F\u06D6-\u06ED]'), '')
      .replaceAll('ـ', '')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ٱ', 'ا')
      .replaceAll('ء', '')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll(RegExp(r'[^\u0621-\u063A\u0641-\u064A0-9:\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String combineQuranSearchFields(Iterable<String> values) {
  return values.where((value) => value.trim().isNotEmpty).join(' ');
}

String? _stripLeadingArticlePrefix(String token) {
  for (final prefix in _transliterationLeadingPrefixes) {
    if (token.startsWith(prefix) && token.length > prefix.length + 2) {
      return token.substring(prefix.length);
    }
  }
  return null;
}

const Set<String> _transliterationArticleTokens = <String>{
  'al',
  'ar',
  'as',
  'ash',
  'ad',
  'at',
  'an',
  'az',
  'aw',
  'au',
};

const List<String> _transliterationLeadingPrefixes = <String>[
  'ash',
  'ath',
  'adh',
  'az',
  'as',
  'ar',
  'al',
  'ad',
  'at',
  'an',
];
