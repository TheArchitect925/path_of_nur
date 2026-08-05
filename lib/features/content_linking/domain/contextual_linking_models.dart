enum ContextualContentType { historicalEvent, journey, hadith, learnContent }

class ContextualLinkNode {
  const ContextualLinkNode({
    required this.id,
    required this.uniqueKey,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.tags,
    required this.categories,
    required this.entities,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final String uniqueKey;
  final ContextualContentType type;
  final String title;
  final String subtitle;
  final String summary;
  final List<String> tags;
  final List<String> categories;
  final List<String> entities;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class ContextualLinkResult {
  const ContextualLinkResult({
    required this.node,
    required this.score,
    required this.isManualOverride,
    required this.matchedTags,
    required this.matchedCategories,
    required this.matchedEntities,
  });

  final ContextualLinkNode node;
  final int score;
  final bool isManualOverride;
  final List<String> matchedTags;
  final List<String> matchedCategories;
  final List<String> matchedEntities;
}
