import '../domain/contextual_linking_models.dart';

class ContextualLinkingService {
  const ContextualLinkingService({
    this.tagWeight = 5,
    this.entityWeight = 4,
    this.categoryWeight = 2,
    this.manualOverrideScore = 1000,
  });

  final int tagWeight;
  final int entityWeight;
  final int categoryWeight;
  final int manualOverrideScore;

  List<ContextualLinkResult> findRelated({
    required ContextualLinkNode current,
    required Iterable<ContextualLinkNode> candidates,
    Iterable<String> manualIncludeIds = const <String>[],
    int limit = 6,
  }) {
    final currentTags = _normalizeSet(current.tags);
    final currentCategories = _normalizeSet(current.categories);
    final currentEntities = _normalizeSet(current.entities);
    final manualIds = _normalizeSet(manualIncludeIds);
    final scored = <ContextualLinkResult>[];

    for (final candidate in candidates) {
      if (candidate.uniqueKey == current.uniqueKey) {
        continue;
      }

      final isManual = manualIds.contains(_normalize(candidate.id));
      final matchedTags = _sharedValues(currentTags, candidate.tags);
      final matchedCategories = _sharedValues(
        currentCategories,
        candidate.categories,
      );
      final matchedEntities = _sharedValues(currentEntities, candidate.entities);

      final score =
          (matchedTags.length * tagWeight) +
          (matchedEntities.length * entityWeight) +
          (matchedCategories.length * categoryWeight) +
          (isManual ? manualOverrideScore : 0);

      if (!isManual && score <= 0) {
        continue;
      }

      scored.add(
        ContextualLinkResult(
          node: candidate,
          score: score,
          isManualOverride: isManual,
          matchedTags: matchedTags,
          matchedCategories: matchedCategories,
          matchedEntities: matchedEntities,
        ),
      );
    }

    scored.sort((a, b) {
      final manualCompare = _boolPriority(
        b.isManualOverride,
      ).compareTo(_boolPriority(a.isManualOverride));
      if (manualCompare != 0) return manualCompare;

      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;

      final typeCompare = _typePriority(a.node.type).compareTo(
        _typePriority(b.node.type),
      );
      if (typeCompare != 0) return typeCompare;

      final titleCompare = a.node.title.compareTo(b.node.title);
      if (titleCompare != 0) return titleCompare;

      return a.node.id.compareTo(b.node.id);
    });

    final deduped = <ContextualLinkResult>[];
    final seenKeys = <String>{};
    for (final item in scored) {
      if (!seenKeys.add(item.node.uniqueKey)) continue;
      deduped.add(item);
      if (deduped.length >= limit) break;
    }
    return deduped;
  }

  int _boolPriority(bool value) => value ? 1 : 0;

  int _typePriority(ContextualContentType type) {
    switch (type) {
      case ContextualContentType.historicalEvent:
        return 0;
      case ContextualContentType.journey:
        return 1;
      case ContextualContentType.hadith:
        return 2;
      case ContextualContentType.learnContent:
        return 3;
    }
  }

  Set<String> _normalizeSet(Iterable<String> raw) {
    return raw
        .map(_normalize)
        .where((item) => item.isNotEmpty)
        .toSet();
  }

  List<String> _sharedValues(Set<String> source, Iterable<String> rawCandidates) {
    final matched = <String>{};
    for (final item in rawCandidates) {
      final normalized = _normalize(item);
      if (normalized.isEmpty || !source.contains(normalized)) continue;
      matched.add(normalized);
    }
    return matched.toList(growable: false)..sort();
  }

  String _normalize(String raw) {
    return raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
