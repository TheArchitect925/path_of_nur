// ignore_for_file: use_null_aware_elements

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/diagnostics/app_telemetry.dart';
import '../domain/learn_analytics_models.dart';

final learnAnalyticsServiceProvider = Provider<LearnAnalyticsService>((ref) {
  return const LearnAnalyticsService();
});

class LearnAnalyticsService {
  const LearnAnalyticsService();

  void logLandingViewed({required String surface}) {
    _log('learn_landing_viewed', <String, Object?>{'surface': surface});
  }

  void logPrimaryCardOpened({
    required String cardId,
    required String sourceSurface,
    String? domain,
    LearnAnalyticsAudience? audience,
  }) {
    _log('learn_primary_card_opened', <String, Object?>{
      'cardId': cardId,
      'sourceSurface': sourceSurface,
      if (domain != null) 'domain': domain,
      if (audience != null) 'audience': audience.name,
    });
  }

  void logGuidedPathStarted({
    required String pathId,
    required String sourceSurface,
    LearnAnalyticsAudience? audience,
  }) {
    _log('guided_path_started', <String, Object?>{
      'pathId': pathId,
      'sourceSurface': sourceSurface,
      if (audience != null) 'audience': audience.name,
    });
  }

  void logGuidedPathResumed({
    required String pathId,
    required String sourceSurface,
    String? stepId,
  }) {
    _log('guided_path_resumed', <String, Object?>{
      'pathId': pathId,
      'sourceSurface': sourceSurface,
      if (stepId != null) 'stepId': stepId,
    });
  }

  void logGuidedPathStepOpened({
    required String pathId,
    required String stepId,
    required String sourceSurface,
  }) {
    _log('guided_path_step_opened', <String, Object?>{
      'pathId': pathId,
      'stepId': stepId,
      'sourceSurface': sourceSurface,
    });
  }

  void logGuidedPathStepCompleted({
    required String pathId,
    required String stepId,
    required String sourceSurface,
  }) {
    _log('guided_path_step_completed', <String, Object?>{
      'pathId': pathId,
      'stepId': stepId,
      'sourceSurface': sourceSurface,
    });
  }

  void logGuidedPathCompleted({
    required String pathId,
    required String sourceSurface,
  }) {
    _log('guided_path_completed', <String, Object?>{
      'pathId': pathId,
      'sourceSurface': sourceSurface,
    });
  }

  void logSearchOpened({required String surface}) {
    _log('search_opened', <String, Object?>{'surface': surface});
  }

  void logSearchQuerySubmitted({
    required String surface,
    required String query,
  }) {
    _log('search_query_submitted', <String, Object?>{
      'surface': surface,
      'queryKind': classifyQuery(query).name,
      'queryLength': query.trim().length,
    });
  }

  void logSearchResultOpened({
    required String surface,
    required String resultId,
    required String resultType,
    String? domain,
    String? routeName,
  }) {
    _log('search_result_opened', <String, Object?>{
      'surface': surface,
      'resultId': resultId,
      'resultType': resultType,
      if (domain != null) 'domain': domain,
      if (routeName != null) 'routeName': routeName,
    });
  }

  void logFilterApplied({
    required String surface,
    required String filterType,
    required String filterValue,
  }) {
    _log('filter_applied', <String, Object?>{
      'surface': surface,
      'filterType': filterType,
      'filterValue': filterValue,
    });
  }

  void logRelatedContentOpened({
    required String sourceId,
    required String targetId,
    required String sourceSurface,
  }) {
    _log('related_content_opened', <String, Object?>{
      'sourceId': sourceId,
      'targetId': targetId,
      'sourceSurface': sourceSurface,
    });
  }

  void logExploreSectionOpened({
    required String sectionId,
    required String sourceSurface,
  }) {
    _log('explore_section_opened', <String, Object?>{
      'sectionId': sectionId,
      'sourceSurface': sourceSurface,
    });
  }

  void logLegacyRouteOpened({
    required String routeKey,
    required String matchedLocation,
  }) {
    _log('legacy_route_opened', <String, Object?>{
      'routeKey': routeKey,
      'matchedLocation': matchedLocation,
    });
  }

  void logCompatibilityAliasHit({
    required String aliasPath,
    required String canonicalPath,
    required String routeFamily,
  }) {
    _log('compatibility_alias_hit', <String, Object?>{
      'aliasPath': aliasPath,
      'canonicalPath': canonicalPath,
      'routeFamily': routeFamily,
    });
  }

  void logRecommendedActionOpened({
    required String recommendationKind,
    String? pathId,
    required String sourceSurface,
  }) {
    _log('recommended_action_opened', <String, Object?>{
      'recommendationKind': recommendationKind,
      if (pathId != null) 'pathId': pathId,
      'sourceSurface': sourceSurface,
    });
  }

  void logRecommendedPathStarted({
    required String pathId,
    required String sourceSurface,
  }) {
    _log('recommended_path_started', <String, Object?>{
      'pathId': pathId,
      'sourceSurface': sourceSurface,
    });
  }

  LearnAnalyticsQueryKind classifyQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return LearnAnalyticsQueryKind.empty;
    }
    if (_containsAny(normalized, <String>['kid', 'kids', 'child', 'letters'])) {
      return LearnAnalyticsQueryKind.kids;
    }
    if (_containsAny(normalized, <String>['quran', 'surah', 'ayah'])) {
      return LearnAnalyticsQueryKind.quran;
    }
    if (_containsAny(normalized, <String>['pray', 'prayer', 'salah', 'wudu'])) {
      return LearnAnalyticsQueryKind.salah;
    }
    if (_containsAny(normalized, <String>[
      'dhikr',
      'adhkar',
      'dua',
      'remembrance',
    ])) {
      return LearnAnalyticsQueryKind.dhikr;
    }
    if (_containsAny(normalized, <String>[
      'story',
      'stories',
      'prophets',
      'seerah',
      'history',
    ])) {
      return LearnAnalyticsQueryKind.stories;
    }
    if (_containsAny(normalized, <String>[
      'character',
      'manners',
      'adab',
      'patience',
    ])) {
      return LearnAnalyticsQueryKind.character;
    }
    if (_containsAny(normalized, <String>[
      'quiz',
      'game',
      'trivia',
      'challenge',
    ])) {
      return LearnAnalyticsQueryKind.games;
    }
    if (_containsAny(normalized, <String>[
      'start',
      'basic',
      'basics',
      'foundation',
      'islam',
    ])) {
      return LearnAnalyticsQueryKind.foundations;
    }
    return LearnAnalyticsQueryKind.general;
  }

  static bool _containsAny(String query, List<String> candidates) {
    for (final candidate in candidates) {
      if (query.contains(candidate)) {
        return true;
      }
    }
    return false;
  }

  void _log(String name, Map<String, Object?> metadata) {
    AppTelemetry.logEvent(name, metadata: metadata);
  }
}
