import '../domain/hadith_foundation_models.dart';
import 'hadith_narrator_repository.dart';

enum HadithSearchFilter { all, source, category, subcategory, grade }

enum HadithSearchResultGroup { text, source, topical, grade }

enum HadithSearchMatchField {
  title,
  excerpt,
  translation,
  arabic,
  transliteration,
  sourceCollection,
  reference,
  narrator,
  chapter,
  category,
  subcategory,
  grade,
}

extension HadithSearchFilterX on HadithSearchFilter {
  String get wireValue {
    switch (this) {
      case HadithSearchFilter.all:
        return 'all';
      case HadithSearchFilter.source:
        return 'source';
      case HadithSearchFilter.category:
        return 'category';
      case HadithSearchFilter.subcategory:
        return 'subcategory';
      case HadithSearchFilter.grade:
        return 'grade';
    }
  }

  static HadithSearchFilter fromWireValue(String? value) {
    switch (value) {
      case 'source':
        return HadithSearchFilter.source;
      case 'category':
        return HadithSearchFilter.category;
      case 'subcategory':
        return HadithSearchFilter.subcategory;
      case 'grade':
        return HadithSearchFilter.grade;
      default:
        return HadithSearchFilter.all;
    }
  }
}

class HadithSearchRequest {
  const HadithSearchRequest({
    required this.query,
    this.filter = HadithSearchFilter.all,
    this.maxResults = 80,
  });

  final String query;
  final HadithSearchFilter filter;
  final int maxResults;

  @override
  bool operator ==(Object other) {
    return other is HadithSearchRequest &&
        other.query == query &&
        other.filter == filter &&
        other.maxResults == maxResults;
  }

  @override
  int get hashCode => Object.hash(query, filter, maxResults);
}

class HadithSearchHighlightPart {
  const HadithSearchHighlightPart({
    required this.text,
    required this.isHighlighted,
  });

  final String text;
  final bool isHighlighted;
}

class HadithSearchResult {
  const HadithSearchResult({
    required this.entryId,
    required this.matchedField,
    required this.snippetText,
    required this.highlightTerms,
  });

  final String entryId;
  final HadithSearchMatchField matchedField;
  final String snippetText;
  final List<String> highlightTerms;
}

class HadithSearchResolvedResult {
  const HadithSearchResolvedResult({required this.entry, required this.result});

  final HadithEntry entry;
  final HadithSearchResult result;
}

class HadithSearchPresentationMetadata {
  const HadithSearchPresentationMetadata({
    required this.snippetText,
    required this.highlightTerms,
  });

  final String snippetText;
  final List<String> highlightTerms;
}

class HadithSearchIndexMetadata {
  const HadithSearchIndexMetadata({
    required this.narratorLabel,
    required this.narratorSearchText,
    required this.chapterLabel,
    required this.chapterSearchText,
  });

  final String? narratorLabel;
  final String narratorSearchText;
  final String? chapterLabel;
  final String chapterSearchText;
}

extension HadithSearchMatchFieldX on HadithSearchMatchField {
  HadithSearchResultGroup get group {
    switch (this) {
      case HadithSearchMatchField.title:
      case HadithSearchMatchField.excerpt:
      case HadithSearchMatchField.translation:
      case HadithSearchMatchField.arabic:
      case HadithSearchMatchField.transliteration:
        return HadithSearchResultGroup.text;
      case HadithSearchMatchField.sourceCollection:
      case HadithSearchMatchField.reference:
      case HadithSearchMatchField.narrator:
      case HadithSearchMatchField.chapter:
        return HadithSearchResultGroup.source;
      case HadithSearchMatchField.category:
      case HadithSearchMatchField.subcategory:
        return HadithSearchResultGroup.topical;
      case HadithSearchMatchField.grade:
        return HadithSearchResultGroup.grade;
    }
  }
}

List<HadithSearchResolvedResult> searchHadithEntries({
  required List<HadithEntry> entries,
  required HadithSearchRequest request,
}) {
  final trimmedQuery = request.query.trim();
  if (trimmedQuery.isEmpty) {
    return const <HadithSearchResolvedResult>[];
  }

  final results = <HadithSearchResolvedResult>[];
  for (final entry in entries) {
    final match = _searchEntry(
      entry: entry,
      query: trimmedQuery,
      filter: request.filter,
    );
    if (match == null) continue;
    results.add(HadithSearchResolvedResult(entry: entry, result: match));
  }

  results.sort((a, b) {
    final fieldCompare = a.result.matchedField.index.compareTo(
      b.result.matchedField.index,
    );
    if (fieldCompare != 0) return fieldCompare;
    return a.entry.title.compareTo(b.entry.title);
  });

  if (results.length <= request.maxResults) {
    return List<HadithSearchResolvedResult>.unmodifiable(results);
  }
  return List<HadithSearchResolvedResult>.unmodifiable(
    results.take(request.maxResults),
  );
}

HadithSearchIndexMetadata buildHadithSearchIndexMetadata(HadithEntry entry) {
  final narratorId = resolveHadithNarratorId(entry.narrator);
  final narratorProfile = narratorId == null
      ? null
      : hadithNarratorProfileForId(narratorId);
  final narratorLabel =
      resolveHadithNarratorDisplayName(entry.narrator) ??
      entry.normalizedNarratorName;
  final narratorSearchText = _joinUniqueSearchTerms(<String>[
    if ((narratorLabel ?? '').trim().isNotEmpty) narratorLabel!,
    ...?narratorProfile?.aliases,
    ...?narratorProfile?.matchAliases,
    if ((entry.normalizedNarratorName ?? '').trim().isNotEmpty)
      entry.normalizedNarratorName!,
  ]);

  final chapterLabel =
      entry.sourceMetadata.chapter?.title ?? entry.normalizedSourceChapterTitle;
  final chapterNumber = entry.normalizedSourceChapterNumber;
  final chapterSearchText = _joinUniqueSearchTerms(<String>[
    if ((chapterLabel ?? '').trim().isNotEmpty) chapterLabel!,
    if (chapterNumber != null) 'Chapter $chapterNumber',
    if (chapterNumber != null) 'Book $chapterNumber',
  ]);

  return HadithSearchIndexMetadata(
    narratorLabel: narratorLabel,
    narratorSearchText: narratorSearchText,
    chapterLabel: chapterLabel,
    chapterSearchText: chapterSearchText,
  );
}

HadithSearchResult? _searchEntry({
  required HadithEntry entry,
  required String query,
  required HadithSearchFilter filter,
}) {
  for (final candidate in _candidatesForFilter(entry, filter)) {
    if (!_matchesField(candidate.field, query, candidate.sourceText)) {
      continue;
    }
    final metadata = buildHadithSearchPresentationMetadata(
      field: candidate.field,
      query: query,
      sourceText: candidate.sourceText,
    );
    return HadithSearchResult(
      entryId: entry.id,
      matchedField: candidate.field,
      snippetText: metadata.snippetText,
      highlightTerms: metadata.highlightTerms,
    );
  }
  return null;
}

Iterable<_HadithSearchCandidate> _candidatesForFilter(
  HadithEntry entry,
  HadithSearchFilter filter,
) sync* {
  final metadata = buildHadithSearchIndexMetadata(entry);

  Iterable<_HadithSearchCandidate> buildAll() sync* {
    yield _HadithSearchCandidate(HadithSearchMatchField.title, entry.title);
    yield _HadithSearchCandidate(HadithSearchMatchField.excerpt, entry.excerpt);
    yield _HadithSearchCandidate(
      HadithSearchMatchField.translation,
      entry.translation,
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.arabic,
      entry.arabicMatn ?? '',
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.transliteration,
      entry.transliteratedText ?? '',
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.sourceCollection,
      entry.displaySourceCollectionTitle,
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.reference,
      entry.displaySourceReference ?? '',
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.narrator,
      metadata.narratorSearchText,
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.chapter,
      metadata.chapterSearchText,
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.category,
      entry.displayCategoryTitle ?? '',
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.subcategory,
      entry.displaySubcategoryTitle ?? '',
    );
    yield _HadithSearchCandidate(
      HadithSearchMatchField.grade,
      entry.standardizedGrade.displayLabel,
    );
  }

  switch (filter) {
    case HadithSearchFilter.all:
      yield* buildAll();
    case HadithSearchFilter.source:
      yield _HadithSearchCandidate(
        HadithSearchMatchField.sourceCollection,
        entry.displaySourceCollectionTitle,
      );
      yield _HadithSearchCandidate(
        HadithSearchMatchField.reference,
        entry.displaySourceReference ?? '',
      );
      yield _HadithSearchCandidate(
        HadithSearchMatchField.narrator,
        metadata.narratorSearchText,
      );
      yield _HadithSearchCandidate(
        HadithSearchMatchField.chapter,
        metadata.chapterSearchText,
      );
      yield _HadithSearchCandidate(
        HadithSearchMatchField.grade,
        entry.standardizedGrade.displayLabel,
      );
    case HadithSearchFilter.category:
      yield _HadithSearchCandidate(
        HadithSearchMatchField.category,
        entry.displayCategoryTitle ?? '',
      );
      yield _HadithSearchCandidate(
        HadithSearchMatchField.subcategory,
        entry.displaySubcategoryTitle ?? '',
      );
    case HadithSearchFilter.subcategory:
      yield _HadithSearchCandidate(
        HadithSearchMatchField.subcategory,
        entry.displaySubcategoryTitle ?? '',
      );
    case HadithSearchFilter.grade:
      yield _HadithSearchCandidate(
        HadithSearchMatchField.grade,
        entry.standardizedGrade.displayLabel,
      );
  }
}

HadithSearchPresentationMetadata buildHadithSearchPresentationMetadata({
  required HadithSearchMatchField field,
  required String query,
  required String sourceText,
  int maxWords = 16,
}) {
  final trimmedSource = sourceText.trim();
  if (trimmedSource.isEmpty) {
    return const HadithSearchPresentationMetadata(
      snippetText: '',
      highlightTerms: <String>[],
    );
  }

  final sourceWords = trimmedSource.split(RegExp(r'\s+'));
  if (sourceWords.length <= maxWords) {
    return HadithSearchPresentationMetadata(
      snippetText: trimmedSource,
      highlightTerms: buildHadithSearchHighlightTerms(
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

  return HadithSearchPresentationMetadata(
    snippetText: snippet,
    highlightTerms: buildHadithSearchHighlightTerms(
      field: field,
      query: query,
      sourceText: snippetWords.join(' '),
    ),
  );
}

List<HadithSearchHighlightPart> buildHadithSearchHighlightParts({
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
    return <HadithSearchHighlightPart>[
      HadithSearchHighlightPart(text: text, isHighlighted: false),
    ];
  }

  final lowerTerms = uniqueTerms.map((term) => term.toLowerCase()).toList();
  final lowerText = text.toLowerCase();
  final output = <HadithSearchHighlightPart>[];
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
        HadithSearchHighlightPart(text: matchedTerm, isHighlighted: true),
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
      HadithSearchHighlightPart(
        text: text.substring(cursor, end),
        isHighlighted: false,
      ),
    );
    cursor = end;
  }

  return output.where((part) => part.text.isNotEmpty).toList(growable: false);
}

List<String> buildHadithSearchHighlightTerms({
  required HadithSearchMatchField field,
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

  final exactHighlights = <String>[];
  for (var i = 0; i < sourceWords.length; i += 1) {
    final normalizedWord = sourceNormalizedWords[i];
    if (normalizedWord.isEmpty) continue;
    if (_isHighlightWordMatch(
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

String normalizeHadithSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r"[‘’']"), '')
      .replaceAll(RegExp(r'[^\p{L}\p{N}:\s-]', unicode: true), ' ')
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String normalizeHadithArabicSearchText(String value) {
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

String normalizeHadithTransliterationSearchText(String value) {
  var normalized = normalizeHadithSearchText(value)
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

List<String> tokenizeHadithSearchText(String value) {
  final normalized = normalizeHadithSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

List<String> tokenizeHadithArabicSearchText(String value) {
  final normalized = normalizeHadithArabicSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

List<String> tokenizeHadithTransliterationSearchText(String value) {
  final normalized = normalizeHadithTransliterationSearchText(value);
  if (normalized.isEmpty) return const <String>[];
  return normalized.split(' ');
}

class _HadithSearchCandidate {
  const _HadithSearchCandidate(this.field, this.sourceText);

  final HadithSearchMatchField field;
  final String sourceText;
}

(int, int)? _findBestWordRange({
  required HadithSearchMatchField field,
  required String query,
  required List<String> sourceWords,
}) {
  final normalizedQuery = _normalizeForField(field, query);
  final queryTokens = _tokenizeForField(field, query);
  if (normalizedQuery.isEmpty && queryTokens.isEmpty) return null;

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

bool _matchesField(
  HadithSearchMatchField field,
  String query,
  String sourceText,
) {
  final normalizedSource = _normalizeForField(field, sourceText);
  if (normalizedSource.isEmpty) return false;
  final normalizedQuery = _normalizeForField(field, query);
  final tokens = _tokenizeForField(field, query);
  if (normalizedQuery.isNotEmpty &&
      normalizedSource.contains(normalizedQuery)) {
    return true;
  }
  return tokens.any(
    (token) => token.isNotEmpty && normalizedSource.contains(token),
  );
}

String _normalizeForField(HadithSearchMatchField field, String value) {
  switch (field) {
    case HadithSearchMatchField.arabic:
      return normalizeHadithArabicSearchText(value);
    case HadithSearchMatchField.transliteration:
      return normalizeHadithTransliterationSearchText(value);
    case HadithSearchMatchField.title:
    case HadithSearchMatchField.excerpt:
    case HadithSearchMatchField.translation:
    case HadithSearchMatchField.sourceCollection:
    case HadithSearchMatchField.reference:
    case HadithSearchMatchField.narrator:
    case HadithSearchMatchField.chapter:
    case HadithSearchMatchField.category:
    case HadithSearchMatchField.subcategory:
    case HadithSearchMatchField.grade:
      if (_containsArabicLetters(value)) {
        final arabic = normalizeHadithArabicSearchText(value);
        if (arabic.isNotEmpty) return arabic;
      }
      return normalizeHadithSearchText(value);
  }
}

List<String> _tokenizeForField(HadithSearchMatchField field, String value) {
  switch (field) {
    case HadithSearchMatchField.arabic:
      return tokenizeHadithArabicSearchText(value);
    case HadithSearchMatchField.transliteration:
      return tokenizeHadithTransliterationSearchText(value);
    case HadithSearchMatchField.title:
    case HadithSearchMatchField.excerpt:
    case HadithSearchMatchField.translation:
    case HadithSearchMatchField.sourceCollection:
    case HadithSearchMatchField.reference:
    case HadithSearchMatchField.narrator:
    case HadithSearchMatchField.chapter:
    case HadithSearchMatchField.category:
    case HadithSearchMatchField.subcategory:
    case HadithSearchMatchField.grade:
      if (_containsArabicLetters(value)) {
        return tokenizeHadithArabicSearchText(value);
      }
      return tokenizeHadithSearchText(value);
  }
}

bool _isHighlightWordMatch({
  required HadithSearchMatchField field,
  required String normalizedWord,
  required String normalizedQuery,
  required List<String> queryTokens,
}) {
  switch (field) {
    case HadithSearchMatchField.arabic:
    case HadithSearchMatchField.transliteration:
      if (normalizedQuery.isNotEmpty && normalizedWord == normalizedQuery) {
        return true;
      }
      return queryTokens.contains(normalizedWord);
    case HadithSearchMatchField.title:
    case HadithSearchMatchField.excerpt:
    case HadithSearchMatchField.translation:
    case HadithSearchMatchField.sourceCollection:
    case HadithSearchMatchField.reference:
    case HadithSearchMatchField.narrator:
    case HadithSearchMatchField.chapter:
    case HadithSearchMatchField.category:
    case HadithSearchMatchField.subcategory:
    case HadithSearchMatchField.grade:
      if (normalizedQuery.isNotEmpty &&
          _isSafeGenericHighlightMatch(normalizedWord, normalizedQuery)) {
        return true;
      }
      return queryTokens.any(
        (token) => _isSafeGenericHighlightMatch(normalizedWord, token),
      );
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

bool _containsArabicLetters(String value) =>
    RegExp(r'[\u0600-\u06FF]').hasMatch(value);

String _joinUniqueSearchTerms(List<String> values) {
  final seen = <String>{};
  final deduped = <String>[];
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) continue;
    final normalized = normalizeHadithSearchText(trimmed);
    if (normalized.isEmpty || !seen.add(normalized)) continue;
    deduped.add(trimmed);
  }
  return deduped.join(' ');
}
