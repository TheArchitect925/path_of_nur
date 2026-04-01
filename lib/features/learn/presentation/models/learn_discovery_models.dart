import 'learn_hub_models.dart';

enum LearnDiscoveryAudience { general, beginner, kids }

enum LearnDiscoveryDifficulty { startHere, growing, deeper }

enum LearnDiscoveryContentType {
  path,
  lesson,
  story,
  practice,
  reflection,
  quiz,
  tool,
  note,
  faq,
  journey,
  hub,
}

enum LearnDiscoveryBucket {
  bestMatch,
  guidedPaths,
  lessonsAndPages,
  kids,
  related,
  startHere,
  practiceAndTools,
}

class LearnDiscoveryIndexEntry {
  const LearnDiscoveryIndexEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.categoryId,
    required this.contentType,
    required this.routeTarget,
    required this.audience,
    required this.difficulty,
    required this.searchTerms,
    this.relatedPathIds = const <String>[],
    this.relatedEntryIds = const <String>[],
    this.startHere = false,
    this.beginnerSafe = false,
    this.badgeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String summary;
  final LearnHubCategoryId categoryId;
  final LearnDiscoveryContentType contentType;
  final LearnHubRouteTarget routeTarget;
  final LearnDiscoveryAudience audience;
  final LearnDiscoveryDifficulty difficulty;
  final List<String> searchTerms;
  final List<String> relatedPathIds;
  final List<String> relatedEntryIds;
  final bool startHere;
  final bool beginnerSafe;
  final String? badgeLabel;
}

class LearnDiscoverySearchResult {
  const LearnDiscoverySearchResult({
    required this.entry,
    required this.score,
    required this.matchedTerms,
  });

  final LearnDiscoveryIndexEntry entry;
  final int score;
  final Set<String> matchedTerms;
}

class LearnDiscoveryBucketSection {
  const LearnDiscoveryBucketSection({
    required this.bucket,
    required this.results,
  });

  final LearnDiscoveryBucket bucket;
  final List<LearnDiscoverySearchResult> results;
}
