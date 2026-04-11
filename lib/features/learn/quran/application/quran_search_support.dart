import 'package:flutter/foundation.dart';

import 'quran_search_normalization.dart';

enum QuranSearchFieldFilter { all, translation, transliteration, arabic, surah }

enum QuranSearchMatchField { translation, transliteration, arabic, surah }

enum QuranSearchType { all, text, theme, topic, surah }

extension QuranSearchMatchFieldX on QuranSearchMatchField {
  String get wireValue {
    switch (this) {
      case QuranSearchMatchField.translation:
        return 'translation';
      case QuranSearchMatchField.transliteration:
        return 'transliteration';
      case QuranSearchMatchField.arabic:
        return 'arabic';
      case QuranSearchMatchField.surah:
        return 'surah';
    }
  }

  static QuranSearchMatchField? fromWireValue(String? value) {
    switch (value) {
      case 'translation':
        return QuranSearchMatchField.translation;
      case 'transliteration':
        return QuranSearchMatchField.transliteration;
      case 'arabic':
        return QuranSearchMatchField.arabic;
      case 'surah':
        return QuranSearchMatchField.surah;
      default:
        return null;
    }
  }
}

extension QuranSearchFieldFilterX on QuranSearchFieldFilter {
  String get wireValue {
    switch (this) {
      case QuranSearchFieldFilter.all:
        return 'all';
      case QuranSearchFieldFilter.translation:
        return 'translation';
      case QuranSearchFieldFilter.transliteration:
        return 'transliteration';
      case QuranSearchFieldFilter.arabic:
        return 'arabic';
      case QuranSearchFieldFilter.surah:
        return 'surah';
    }
  }

  static QuranSearchFieldFilter fromWireValue(String? value) {
    switch (value) {
      case 'translation':
        return QuranSearchFieldFilter.translation;
      case 'transliteration':
        return QuranSearchFieldFilter.transliteration;
      case 'arabic':
        return QuranSearchFieldFilter.arabic;
      case 'surah':
        return QuranSearchFieldFilter.surah;
      default:
        return QuranSearchFieldFilter.all;
    }
  }

  bool allowsMatchField(QuranSearchMatchField field) {
    if (this == QuranSearchFieldFilter.all) return true;
    switch (field) {
      case QuranSearchMatchField.translation:
        return this == QuranSearchFieldFilter.translation;
      case QuranSearchMatchField.transliteration:
        return this == QuranSearchFieldFilter.transliteration;
      case QuranSearchMatchField.arabic:
        return this == QuranSearchFieldFilter.arabic;
      case QuranSearchMatchField.surah:
        return this == QuranSearchFieldFilter.surah;
    }
  }
}

extension QuranSearchTypeX on QuranSearchType {
  String get wireValue {
    switch (this) {
      case QuranSearchType.all:
        return 'all';
      case QuranSearchType.text:
        return 'text';
      case QuranSearchType.theme:
        return 'theme';
      case QuranSearchType.topic:
        return 'topic';
      case QuranSearchType.surah:
        return 'surah';
    }
  }

  static QuranSearchType fromWireValue(String? value) {
    switch (value) {
      case 'text':
        return QuranSearchType.text;
      case 'theme':
        return QuranSearchType.theme;
      case 'topic':
        return QuranSearchType.topic;
      case 'surah':
        return QuranSearchType.surah;
      default:
        return QuranSearchType.all;
    }
  }
}

class QuranSearchPresentationMetadata {
  const QuranSearchPresentationMetadata({
    required this.field,
    required this.snippetText,
    required this.highlightTerms,
  });

  final QuranSearchMatchField field;
  final String snippetText;
  final List<String> highlightTerms;
}

class QuranSearchHighlightPart {
  const QuranSearchHighlightPart({
    required this.text,
    required this.isHighlighted,
  });

  final String text;
  final bool isHighlighted;
}

class QuranReaderAyahSearchMatch {
  const QuranReaderAyahSearchMatch({
    required this.ayahNumber,
    required this.matchedFields,
    required this.highlightTermsByField,
  });

  final int ayahNumber;
  final Set<QuranSearchMatchField> matchedFields;
  final Map<QuranSearchMatchField, List<String>> highlightTermsByField;

  bool matchesField(QuranSearchMatchField field) =>
      matchedFields.contains(field);

  List<String> highlightTermsFor(QuranSearchMatchField field) =>
      highlightTermsByField[field] ?? const <String>[];
}

class QuranSearchDisplayHighlight {
  const QuranSearchDisplayHighlight({required this.field, required this.terms});

  final QuranSearchMatchField field;
  final List<String> terms;
}

typedef QuranReaderSearchableAyah = ({
  int ayahNumber,
  String translation,
  String transliteration,
  String arabic,
});

QuranSearchPresentationMetadata buildQuranSearchPresentationMetadata({
  required QuranSearchMatchField field,
  required String query,
  required String sourceText,
  int maxWords = 12,
}) {
  final trimmedSource = sourceText.trim();
  if (trimmedSource.isEmpty) {
    return QuranSearchPresentationMetadata(
      field: field,
      snippetText: '',
      highlightTerms: const <String>[],
    );
  }

  final sourceWords = trimmedSource.split(RegExp(r'\s+'));
  if (sourceWords.length <= maxWords) {
    return QuranSearchPresentationMetadata(
      field: field,
      snippetText: trimmedSource,
      highlightTerms: buildExactQuranSearchHighlightTerms(
        field: field,
        query: query,
        sourceText: trimmedSource,
      ),
    );
  }

  final matchRange = _findBestWordRange(
    field: field,
    query: query,
    sourceWords: sourceWords,
  );
  final targetStart = matchRange?.$1 ?? 0;
  final targetEnd = matchRange?.$2 ?? targetStart;
  final targetCenter = ((targetStart + targetEnd) / 2).floor();

  var snippetStart = targetCenter - (maxWords ~/ 2);
  if (snippetStart < 0) snippetStart = 0;
  var snippetEnd = snippetStart + maxWords;
  if (snippetEnd > sourceWords.length) {
    snippetEnd = sourceWords.length;
    snippetStart = (snippetEnd - maxWords).clamp(0, sourceWords.length);
  }

  final snippetWords = sourceWords.sublist(snippetStart, snippetEnd);
  final snippet = [
    if (snippetStart > 0) '…',
    snippetWords.join(' '),
    if (snippetEnd < sourceWords.length) '…',
  ].join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  return QuranSearchPresentationMetadata(
    field: field,
    snippetText: snippet,
    highlightTerms: buildExactQuranSearchHighlightTerms(
      field: field,
      query: query,
      sourceText: snippetWords.join(' '),
    ),
  );
}

List<QuranSearchHighlightPart> buildQuranSearchHighlightParts({
  required String text,
  required List<String> highlightTerms,
}) {
  final uniqueTerms =
      highlightTerms
          .map((term) => term.trim())
          .where((term) => term.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort((a, b) => b.length.compareTo(a.length));
  if (text.isEmpty || uniqueTerms.isEmpty) {
    return <QuranSearchHighlightPart>[
      QuranSearchHighlightPart(text: text, isHighlighted: false),
    ];
  }

  final lowerTerms = uniqueTerms.map((term) => term.toLowerCase()).toList();
  final lowerText = text.toLowerCase();
  final output = <QuranSearchHighlightPart>[];
  var cursor = 0;

  while (cursor < text.length) {
    int? matchedIndex;
    String? matchedTerm;

    for (var i = 0; i < lowerTerms.length; i += 1) {
      final candidate = lowerTerms[i];
      if (candidate.isEmpty) continue;
      if (lowerText.startsWith(candidate, cursor)) {
        matchedIndex = i;
        matchedTerm = uniqueTerms[i];
        break;
      }
    }

    if (matchedIndex != null && matchedTerm != null) {
      output.add(
        QuranSearchHighlightPart(text: matchedTerm, isHighlighted: true),
      );
      cursor += matchedTerm.length;
      continue;
    }

    final nextMatchStart = lowerTerms
        .map((candidate) => lowerText.indexOf(candidate, cursor))
        .where((index) => index >= 0)
        .fold<int?>(null, (best, index) {
          if (best == null || index < best) return index;
          return best;
        });

    final end = nextMatchStart ?? text.length;
    output.add(
      QuranSearchHighlightPart(
        text: text.substring(cursor, end),
        isHighlighted: false,
      ),
    );
    cursor = end;
  }

  return output.where((part) => part.text.isNotEmpty).toList(growable: false);
}

(int, int)? _findBestWordRange({
  required QuranSearchMatchField field,
  required String query,
  required List<String> sourceWords,
}) {
  final normalizedQuery = _normalizeForField(field, query);
  final queryTokens = _tokenizeForField(field, query);
  if (normalizedQuery.isEmpty && queryTokens.isEmpty) return null;

  if (queryTokens.length > 1) {
    var bestScore = 0;
    (int, int)? bestRange;
    for (var start = 0; start < sourceWords.length; start += 1) {
      final maxEnd = (start + queryTokens.length + 4).clamp(
        start + 1,
        sourceWords.length,
      );
      for (var end = start; end < maxEnd; end += 1) {
        final windowWords = sourceWords.sublist(start, end + 1);
        final windowTokens = windowWords
            .map((word) => _normalizeForField(field, word))
            .where((token) => token.isNotEmpty)
            .toList(growable: false);
        final score = queryTokens.where(windowTokens.contains).length;
        if (score > bestScore) {
          bestScore = score;
          bestRange = (start, end);
          if (score == queryTokens.length) {
            return bestRange;
          }
        }
      }
    }
    if (bestRange != null) return bestRange;
  }

  for (var start = 0; start < sourceWords.length; start += 1) {
    final normalizedWord = _normalizeForField(field, sourceWords[start]);
    if (normalizedWord.isEmpty) continue;
    if (normalizedQuery.isNotEmpty &&
        normalizedWord.contains(normalizedQuery)) {
      return (start, start);
    }
    if (queryTokens.any(
      (token) =>
          normalizedWord.contains(token) || token.contains(normalizedWord),
    )) {
      return (start, start);
    }
  }

  return null;
}

List<String> buildExactQuranSearchHighlightTerms({
  required QuranSearchMatchField field,
  required String query,
  required String sourceText,
}) {
  final normalizedQuery = _normalizeForField(field, query);
  final queryTokens = _tokenizeForField(field, query);
  final sourceWords = sourceText
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (sourceWords.isEmpty || (normalizedQuery.isEmpty && queryTokens.isEmpty)) {
    return const <String>[];
  }

  final sourceNormalizedWords = sourceWords
      .map((word) => _normalizeForField(field, word))
      .toList(growable: false);

  if (queryTokens.length > 1) {
    for (
      var start = 0;
      start <= sourceWords.length - queryTokens.length;
      start += 1
    ) {
      final window = sourceNormalizedWords.sublist(
        start,
        start + queryTokens.length,
      );
      if (listEquals(window, queryTokens)) {
        return sourceWords.sublist(start, start + queryTokens.length);
      }
    }
  }

  final exactHighlights = <String>[];
  for (var i = 0; i < sourceWords.length; i += 1) {
    final normalizedWord = sourceNormalizedWords[i];
    if (normalizedWord.isEmpty) continue;
    if (_isExactHighlightWordMatch(
      field: field,
      normalizedWord: normalizedWord,
      normalizedQuery: normalizedQuery,
      queryTokens: queryTokens,
    )) {
      exactHighlights.add(sourceWords[i]);
    }
  }

  return exactHighlights.toSet().toList(growable: false);
}

bool _isExactHighlightWordMatch({
  required QuranSearchMatchField field,
  required String normalizedWord,
  required String normalizedQuery,
  required List<String> queryTokens,
}) {
  switch (field) {
    case QuranSearchMatchField.translation:
    case QuranSearchMatchField.surah:
      if (normalizedQuery.isNotEmpty &&
          _isSafeGenericHighlightMatch(normalizedWord, normalizedQuery)) {
        return true;
      }
      return queryTokens.any(
        (token) => _isSafeGenericHighlightMatch(normalizedWord, token),
      );
    case QuranSearchMatchField.transliteration:
      final queryForms = buildQuranTransliterationSearchForms(normalizedQuery);
      if (queryForms.contains(normalizedWord)) {
        return true;
      }
      return queryTokens.contains(normalizedWord);
    case QuranSearchMatchField.arabic:
      if (normalizedQuery.isNotEmpty && normalizedWord == normalizedQuery) {
        return true;
      }
      return queryTokens.contains(normalizedWord);
  }
}

bool _isSafeGenericHighlightMatch(
  String normalizedWord,
  String normalizedQuery,
) {
  if (normalizedWord == normalizedQuery) {
    return true;
  }
  return normalizedWord == '${normalizedQuery}s' ||
      normalizedWord == '${normalizedQuery}es';
}

String _normalizeForField(QuranSearchMatchField field, String value) {
  switch (field) {
    case QuranSearchMatchField.translation:
    case QuranSearchMatchField.surah:
      final arabic = normalizeQuranArabicSearchText(value);
      final generic = normalizeQuranSearchText(value);
      if (_containsArabicLetters(value) && arabic.isNotEmpty) {
        return arabic;
      }
      return generic;
    case QuranSearchMatchField.transliteration:
      return normalizeQuranTransliterationSearchText(value);
    case QuranSearchMatchField.arabic:
      return normalizeQuranArabicSearchText(value);
  }
}

List<String> _tokenizeForField(QuranSearchMatchField field, String value) {
  switch (field) {
    case QuranSearchMatchField.translation:
    case QuranSearchMatchField.surah:
      if (_containsArabicLetters(value)) {
        return tokenizeQuranArabicSearchText(value);
      }
      return tokenizeQuranSearchText(value);
    case QuranSearchMatchField.transliteration:
      return tokenizeQuranTransliterationSearchText(value);
    case QuranSearchMatchField.arabic:
      return tokenizeQuranArabicSearchText(value);
  }
}

bool _containsArabicLetters(String value) =>
    RegExp(r'[\u0600-\u06FF]').hasMatch(value);

List<QuranReaderAyahSearchMatch> buildReaderSurahSearchMatches({
  required String query,
  required Iterable<QuranReaderSearchableAyah> ayahs,
  QuranSearchMatchField? preferredField,
}) {
  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) {
    return const <QuranReaderAyahSearchMatch>[];
  }

  final matches = <QuranReaderAyahSearchMatch>[];
  for (final ayah in ayahs) {
    final matchedFields = <QuranSearchMatchField>{};
    final highlightTermsByField = <QuranSearchMatchField, List<String>>{};

    void inspectField(QuranSearchMatchField field, String sourceText) {
      if (sourceText.trim().isEmpty ||
          !_matchesField(field, trimmedQuery, sourceText)) {
        return;
      }
      matchedFields.add(field);
      highlightTermsByField[field] = buildExactQuranSearchHighlightTerms(
        field: field,
        query: trimmedQuery,
        sourceText: sourceText,
      );
    }

    if (preferredField != null) {
      switch (preferredField) {
        case QuranSearchMatchField.translation:
          inspectField(preferredField, ayah.translation);
        case QuranSearchMatchField.transliteration:
          inspectField(preferredField, ayah.transliteration);
        case QuranSearchMatchField.arabic:
          inspectField(preferredField, ayah.arabic);
        case QuranSearchMatchField.surah:
          break;
      }
    } else {
      inspectField(QuranSearchMatchField.translation, ayah.translation);
      inspectField(QuranSearchMatchField.transliteration, ayah.transliteration);
      inspectField(QuranSearchMatchField.arabic, ayah.arabic);
    }

    if (matchedFields.isEmpty) {
      continue;
    }

    matches.add(
      QuranReaderAyahSearchMatch(
        ayahNumber: ayah.ayahNumber,
        matchedFields: matchedFields,
        highlightTermsByField: highlightTermsByField,
      ),
    );
  }

  return matches;
}

bool _matchesField(
  QuranSearchMatchField field,
  String query,
  String sourceText,
) {
  switch (field) {
    case QuranSearchMatchField.translation:
    case QuranSearchMatchField.surah:
      return _matchesGenericField(field, query, sourceText);
    case QuranSearchMatchField.transliteration:
      return _matchesTransliterationField(query, sourceText);
    case QuranSearchMatchField.arabic:
      return _matchesArabicField(query, sourceText);
  }
}

bool _matchesGenericField(
  QuranSearchMatchField field,
  String query,
  String sourceText,
) {
  final normalizedQuery = _normalizeForField(field, query);
  if (normalizedQuery.isEmpty) return false;
  final normalizedSource = _normalizeForField(field, sourceText);
  if (normalizedSource.contains(normalizedQuery)) {
    return true;
  }
  final queryTokens = _tokenizeForField(field, query);
  if (queryTokens.isEmpty) return false;
  final sourceTokens = _tokenizeForField(field, sourceText).toSet();
  return queryTokens.every(sourceTokens.contains);
}

bool _matchesArabicField(String query, String sourceText) {
  final normalizedQuery = normalizeQuranArabicSearchText(query);
  if (normalizedQuery.isEmpty) return false;
  final normalizedSource = normalizeQuranArabicSearchText(sourceText);
  if (normalizedSource.contains(normalizedQuery)) {
    return true;
  }
  final queryTokens = tokenizeQuranArabicSearchText(query);
  if (queryTokens.isEmpty) return false;
  final sourceTokens = tokenizeQuranArabicSearchText(sourceText).toSet();
  return queryTokens.every(sourceTokens.contains);
}

bool _matchesTransliterationField(String query, String sourceText) {
  final queryForms = buildQuranTransliterationSearchForms(query);
  if (queryForms.isEmpty) return false;
  final sourceForms = buildQuranTransliterationSearchForms(sourceText);
  if (sourceForms.isEmpty) return false;
  if (queryForms.any(sourceForms.contains)) {
    return true;
  }
  final sourceNormalized = normalizeQuranTransliterationSearchText(sourceText);
  return queryForms.any(sourceNormalized.contains);
}
