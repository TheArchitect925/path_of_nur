import 'arabic_learning_continuity_models.dart';

enum ArabicLearningSearchFilter {
  packs,
  letters,
  words,
  phrases,
  review,
  continueFlow,
  quranBridge,
}

enum ArabicLearningSearchItemType {
  lessonPack,
  letter,
  word,
  phrase,
  reviewTarget,
  continueTarget,
  quranBridgeSnippet,
}

class ArabicLearningSearchItem {
  const ArabicLearningSearchItem({
    required this.id,
    required this.audience,
    required this.type,
    required this.target,
    required this.title,
    required this.sortOrder,
    this.arabicText,
    this.transliteration,
    this.meaning,
    this.subtitle,
    this.keywords = const <String>[],
    this.isAvailable = true,
  });

  final String id;
  final ArabicLearningAudience audience;
  final ArabicLearningSearchItemType type;
  final ArabicLearningRouteTarget target;
  final String title;
  final String? arabicText;
  final String? transliteration;
  final String? meaning;
  final String? subtitle;
  final List<String> keywords;
  final int sortOrder;
  final bool isAvailable;

  ArabicLearningSearchFilter get primaryFilter {
    switch (type) {
      case ArabicLearningSearchItemType.lessonPack:
        return ArabicLearningSearchFilter.packs;
      case ArabicLearningSearchItemType.letter:
        return ArabicLearningSearchFilter.letters;
      case ArabicLearningSearchItemType.word:
        return ArabicLearningSearchFilter.words;
      case ArabicLearningSearchItemType.phrase:
        return ArabicLearningSearchFilter.phrases;
      case ArabicLearningSearchItemType.reviewTarget:
        return ArabicLearningSearchFilter.review;
      case ArabicLearningSearchItemType.continueTarget:
        return ArabicLearningSearchFilter.continueFlow;
      case ArabicLearningSearchItemType.quranBridgeSnippet:
        return ArabicLearningSearchFilter.quranBridge;
    }
  }
}

class ArabicLearningSearchQuery {
  ArabicLearningSearchQuery({
    required this.audience,
    required this.query,
    Set<ArabicLearningSearchFilter> filters =
        const <ArabicLearningSearchFilter>{},
  }) : filters = Set<ArabicLearningSearchFilter>.unmodifiable(filters);

  final ArabicLearningAudience audience;
  final String query;
  final Set<ArabicLearningSearchFilter> filters;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ArabicLearningSearchQuery &&
        other.audience == audience &&
        other.query == query &&
        _sameFilters(other.filters, filters);
  }

  @override
  int get hashCode => Object.hash(
    audience,
    query,
    Object.hashAll(
      filters.map((filter) => filter.name).toList(growable: false)..sort(),
    ),
  );

  static bool _sameFilters(
    Set<ArabicLearningSearchFilter> a,
    Set<ArabicLearningSearchFilter> b,
  ) {
    if (a.length != b.length) {
      return false;
    }
    for (final filter in a) {
      if (!b.contains(filter)) {
        return false;
      }
    }
    return true;
  }
}
