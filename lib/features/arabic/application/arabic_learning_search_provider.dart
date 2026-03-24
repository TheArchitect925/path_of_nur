import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/arabic_content_authoring_models.dart';
import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_lesson_pack_models.dart';
import '../domain/arabic_learning_search_models.dart';
import 'arabic_content_authoring_provider.dart';
import 'arabic_learning_lesson_packs_provider.dart';
import 'arabic_learning_review_provider.dart';

final arabicLearningSearchIndexProvider =
    Provider.family<List<ArabicLearningSearchItem>, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsSearchIndex(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultSearchIndex(ref);
      }
    });

final arabicLearningSearchResultsProvider =
    Provider.family<List<ArabicLearningSearchItem>, ArabicLearningSearchQuery>((
      ref,
      search,
    ) {
      final items = ref.watch(arabicLearningSearchIndexProvider(search.audience));
      final normalizedQuery = _normalizeForSearch(search.query);

      final filtered = items.where((item) {
        if (search.filters.isNotEmpty &&
            !search.filters.contains(item.primaryFilter)) {
          return false;
        }
        if (normalizedQuery.isEmpty) {
          return true;
        }
        return _buildSearchBlob(item).contains(normalizedQuery);
      }).toList(growable: false);

      filtered.sort((a, b) {
        final scoreA = _matchScore(a, normalizedQuery);
        final scoreB = _matchScore(b, normalizedQuery);
        if (scoreA != scoreB) {
          return scoreB.compareTo(scoreA);
        }
        if (a.primaryFilter != b.primaryFilter) {
          return a.primaryFilter.index.compareTo(b.primaryFilter.index);
        }
        return a.sortOrder.compareTo(b.sortOrder);
      });

      return filtered;
    });

List<ArabicLearningSearchItem> _buildKidsSearchIndex(Ref ref) {
  final units = ref.watch(arabicContentUnitsProvider(ArabicLearningAudience.kids));
  final reviewSummary = ref.watch(
    arabicLearningReviewProvider(ArabicLearningAudience.kids),
  );
  final lessonPacks = ref.watch(
    arabicLearningLessonPacksProvider(ArabicLearningAudience.kids),
  );

  final items = <ArabicLearningSearchItem>[
    ..._lessonPackItems(lessonPacks, startOrder: 0),
    ..._searchItemsForUnits(
      units,
      allowedTypes: const <ArabicContentUnitType>{
        ArabicContentUnitType.letter,
        ArabicContentUnitType.word,
        ArabicContentUnitType.phrase,
        ArabicContentUnitType.quranBridgeSnippet,
      },
      audiencePrefix: 'kids',
    ),
    ..._reviewItemsFor(
      reviewSummary,
      startOrder: 400,
    ),
  ];

  return items;
}

List<ArabicLearningSearchItem> _buildAdultSearchIndex(Ref ref) {
  final units = ref.watch(arabicContentUnitsProvider(ArabicLearningAudience.adult));
  final reviewSummary = ref.watch(
    arabicLearningReviewProvider(ArabicLearningAudience.adult),
  );
  final lessonPacks = ref.watch(
    arabicLearningLessonPacksProvider(ArabicLearningAudience.adult),
  );

  final items = <ArabicLearningSearchItem>[
    ..._lessonPackItems(lessonPacks, startOrder: 0),
    ..._searchItemsForUnits(
      units,
      allowedTypes: const <ArabicContentUnitType>{
        ArabicContentUnitType.letter,
        ArabicContentUnitType.word,
        ArabicContentUnitType.phrase,
        ArabicContentUnitType.quranBridgeSnippet,
      },
      audiencePrefix: 'adult',
    ),
    ..._reviewItemsFor(
      reviewSummary,
      startOrder: 400,
    ),
  ];

  return items;
}

List<ArabicLearningSearchItem> _lessonPackItems(
  List<ArabicLearningLessonPack> packs, {
  required int startOrder,
}) {
  return packs
      .map(
        (pack) => ArabicLearningSearchItem(
          id: pack.id,
          audience: pack.audience,
          type: ArabicLearningSearchItemType.lessonPack,
          target: pack.primaryTarget,
          title: pack.id,
          arabicText: pack.previewArabic.isEmpty ? null : pack.previewArabic.join('  •  '),
          keywords: <String>[
            pack.id,
            pack.type.name,
            ...pack.itemIds,
            ...pack.searchKeywords,
          ],
          sortOrder: startOrder + pack.sortOrder,
        ),
      )
      .toList(growable: false);
}

List<ArabicLearningSearchItem> _searchItemsForUnits(
  List<ArabicContentUnit> units, {
  required Set<ArabicContentUnitType> allowedTypes,
  required String audiencePrefix,
}) {
  final items = <ArabicLearningSearchItem>[];
  for (final unit in units) {
    if (!allowedTypes.contains(unit.type)) {
      continue;
    }
    final mappedType = switch (unit.type) {
      ArabicContentUnitType.letter => ArabicLearningSearchItemType.letter,
      ArabicContentUnitType.word => ArabicLearningSearchItemType.word,
      ArabicContentUnitType.phrase => ArabicLearningSearchItemType.phrase,
      ArabicContentUnitType.quranBridgeSnippet =>
        ArabicLearningSearchItemType.quranBridgeSnippet,
      _ => null,
    };
    if (mappedType == null) {
      continue;
    }
    items.add(
      ArabicLearningSearchItem(
        id: '${audiencePrefix}_${unit.id.replaceAll(':', '_')}',
        audience: unit.audience,
        type: mappedType,
        target: unit.target,
        title: unit.title ?? unit.id,
        arabicText: unit.arabicText,
        transliteration: unit.transliteration,
        meaning: unit.summary,
        subtitle: unit.subtitle ?? unit.sourceReference,
        keywords: <String>[
          ...unit.keywords,
          ...unit.relatedLetterIds,
          ...unit.relatedWordIds,
          ...unit.relatedPhraseIds,
        ],
        sortOrder: unit.sortOrder,
        isAvailable: unit.isAvailable,
      ),
    );
  }
  return items;
}

List<ArabicLearningSearchItem> _reviewItemsFor(
  ArabicLearningReviewSummary summary, {
  required int startOrder,
}) {
  final suggestions = <ArabicLearningReviewSuggestion>[
    summary.primarySuggestion,
    ...summary.secondarySuggestions,
  ];
  final items = <ArabicLearningSearchItem>[];
  for (var index = 0; index < suggestions.length; index++) {
    final suggestion = suggestions[index];
    items.add(
      ArabicLearningSearchItem(
        id: '${summary.audience.name}_${suggestion.intent.name}_${suggestion.itemId}',
        audience: summary.audience,
        type: suggestion.intent == ArabicLearningContinuationIntent.review
            ? ArabicLearningSearchItemType.reviewTarget
            : ArabicLearningSearchItemType.continueTarget,
        target: suggestion.target,
        title: suggestion.title ?? suggestion.itemId,
        arabicText: suggestion.arabicText,
        subtitle: suggestion.subtitle,
        keywords: <String>[
          suggestion.intent.name,
          suggestion.contentType.name,
          suggestion.itemId,
          if (suggestion.title != null) suggestion.title!,
        ],
        sortOrder: startOrder + index,
      ),
    );
  }
  return items;
}

String _buildSearchBlob(ArabicLearningSearchItem item) {
  return _normalizeForSearch(
    [
      item.title,
      item.arabicText,
      item.transliteration,
      item.meaning,
      item.subtitle,
      ...item.keywords,
    ].whereType<String>().join(' '),
  );
}

int _matchScore(ArabicLearningSearchItem item, String normalizedQuery) {
  if (normalizedQuery.isEmpty) {
    return 0;
  }
  final fields = <String>[
    item.title,
    item.arabicText ?? '',
    item.transliteration ?? '',
    item.meaning ?? '',
    item.subtitle ?? '',
    ...item.keywords,
  ].map(_normalizeForSearch).toList(growable: false);
  for (final field in fields) {
    if (field.startsWith(normalizedQuery)) {
      return 3;
    }
  }
  for (final field in fields) {
    if (field.contains(normalizedQuery)) {
      return 2;
    }
  }
  return 0;
}

String _normalizeForSearch(String input) {
  final lower = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    if ((rune >= 0x064B && rune <= 0x065F) || rune == 0x0670) {
      continue;
    }
    if (RegExp(r'[\s\-_]').hasMatch(String.fromCharCode(rune))) {
      buffer.write(' ');
      continue;
    }
    buffer.writeCharCode(rune);
  }
  return buffer
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
