import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/learn_analytics_models.dart';

const _analyticsKey = 'diagnostics.analytics_log_v1';

final learnAnalyticsEventsProvider = Provider<List<LearnAnalyticsEventRecord>>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final rawEntries = prefs.getStringList(_analyticsKey) ?? const <String>[];
  final events = <LearnAnalyticsEventRecord>[];
  for (final raw in rawEntries) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) continue;
      final name = decoded['name']?.toString();
      final atIso = decoded['atIso']?.toString();
      final metadataRaw = decoded['metadata'];
      final at = atIso == null ? null : DateTime.tryParse(atIso);
      if (name == null || at == null) continue;
      final metadata = metadataRaw is Map
          ? metadataRaw.map((key, value) => MapEntry(key.toString(), value))
          : const <String, Object?>{};
      events.add(
        LearnAnalyticsEventRecord(name: name, at: at, metadata: metadata),
      );
    } catch (_) {
      continue;
    }
  }
  return events;
});

final learnAnalyticsSummaryProvider = Provider<LearnAnalyticsSummary>((ref) {
  final events = ref.watch(learnAnalyticsEventsProvider);
  final pathStartsById = <String, int>{};
  final pathCompletionsById = <String, int>{};
  final pathStepCompletionsByPathId = <String, int>{};
  final legacyRouteHitsByRoute = <String, int>{};
  final aliasHitsByRoute = <String, int>{};
  final searchQueriesByKind = <String, int>{};
  final searchResultOpensByType = <String, int>{};
  final exploreSectionOpensBySection = <String, int>{};
  var recommendedActionOpens = 0;
  var recommendedPathStarts = 0;

  for (final event in events) {
    switch (event.name) {
      case 'guided_path_started':
        _increment(pathStartsById, event.metadata['pathId']?.toString());
      case 'guided_path_completed':
        _increment(pathCompletionsById, event.metadata['pathId']?.toString());
      case 'guided_path_step_completed':
        _increment(
          pathStepCompletionsByPathId,
          event.metadata['pathId']?.toString(),
        );
      case 'legacy_route_opened':
        _increment(
          legacyRouteHitsByRoute,
          event.metadata['routeKey']?.toString(),
        );
      case 'compatibility_alias_hit':
        _increment(aliasHitsByRoute, event.metadata['aliasPath']?.toString());
      case 'search_query_submitted':
        _increment(
          searchQueriesByKind,
          event.metadata['queryKind']?.toString(),
        );
      case 'search_result_opened':
        _increment(
          searchResultOpensByType,
          event.metadata['resultType']?.toString(),
        );
      case 'explore_section_opened':
        _increment(
          exploreSectionOpensBySection,
          event.metadata['sectionId']?.toString(),
        );
      case 'recommended_action_opened':
        recommendedActionOpens += 1;
      case 'recommended_path_started':
        recommendedPathStarts += 1;
    }
  }

  return LearnAnalyticsSummary(
    totalEvents: events.length,
    pathStartsById: pathStartsById,
    pathCompletionsById: pathCompletionsById,
    pathStepCompletionsByPathId: pathStepCompletionsByPathId,
    legacyRouteHitsByRoute: legacyRouteHitsByRoute,
    aliasHitsByRoute: aliasHitsByRoute,
    searchQueriesByKind: searchQueriesByKind,
    searchResultOpensByType: searchResultOpensByType,
    recommendedActionOpens: recommendedActionOpens,
    recommendedPathStarts: recommendedPathStarts,
    exploreSectionOpensBySection: exploreSectionOpensBySection,
  );
});

final learnRetirementCandidateSignalsProvider =
    Provider<List<LearnRetirementCandidateSignal>>((ref) {
      final events = ref.watch(learnAnalyticsEventsProvider);
      final since = DateTime.now().subtract(const Duration(days: 30));
      final legacyOpens = <String, int>{};
      final aliasHits = <String, int>{};

      for (final event in events) {
        if (event.at.isBefore(since)) continue;
        if (event.name == 'legacy_route_opened') {
          _increment(legacyOpens, event.metadata['routeKey']?.toString());
        }
        if (event.name == 'compatibility_alias_hit') {
          _increment(aliasHits, event.metadata['aliasPath']?.toString());
        }
      }

      final routeKeys = <String>{
        ...legacyOpens.keys,
        ...aliasHits.keys,
        '/learn/legacy',
        '/learn/journey-home',
        '/learn/learning-journey',
        '/learn/browse',
        '/learn/hub/salah',
        '/learn/section/salah',
        '/learn/hub/trivia',
      };

      return routeKeys
          .map(
            (routeKey) => LearnRetirementCandidateSignal(
              routeKey: routeKey,
              aliasHitsLast30Days: aliasHits[routeKey] ?? 0,
              directLegacyOpensLast30Days: legacyOpens[routeKey] ?? 0,
              safeToReviewForRetirement:
                  (aliasHits[routeKey] ?? 0) == 0 &&
                  (legacyOpens[routeKey] ?? 0) == 0,
            ),
          )
          .toList(growable: false);
    });

void _increment(Map<String, int> map, String? key) {
  if (key == null || key.isEmpty) return;
  map[key] = (map[key] ?? 0) + 1;
}
