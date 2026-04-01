import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/analytics/application/learn_analytics_service.dart';
import 'package:path_of_nur/features/learn/analytics/application/learn_analytics_summary_provider.dart';
import 'package:path_of_nur/features/learn/analytics/domain/learn_analytics_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer({
    List<String> events = const <String>[],
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'diagnostics.analytics_log_v1': events,
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  String buildEvent(
    String name, {
    required DateTime at,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    return jsonEncode(<String, Object?>{
      'name': name,
      'atIso': at.toIso8601String(),
      'metadata': metadata,
    });
  }

  test('query classification stays explainable and intent-based', () {
    const service = LearnAnalyticsService();

    expect(service.classifyQuery('how to pray'), LearnAnalyticsQueryKind.salah);
    expect(
      service.classifyQuery('kids arabic letters'),
      LearnAnalyticsQueryKind.kids,
    );
    expect(service.classifyQuery('start quran'), LearnAnalyticsQueryKind.quran);
    expect(
      service.classifyQuery('daily dhikr reminders'),
      LearnAnalyticsQueryKind.dhikr,
    );
    expect(service.classifyQuery(''), LearnAnalyticsQueryKind.empty);
  });

  test('summary provider aggregates key learn analytics counts', () async {
    final now = DateTime.now().toUtc();
    final container = await makeContainer(
      events: <String>[
        buildEvent(
          'guided_path_started',
          at: now,
          metadata: <String, Object?>{'pathId': 'foundations-starter'},
        ),
        buildEvent(
          'guided_path_step_completed',
          at: now.subtract(const Duration(minutes: 1)),
          metadata: <String, Object?>{
            'pathId': 'foundations-starter',
            'stepId': 'foundations-intro',
          },
        ),
        buildEvent(
          'guided_path_completed',
          at: now.subtract(const Duration(minutes: 2)),
          metadata: <String, Object?>{'pathId': 'foundations-starter'},
        ),
        buildEvent(
          'search_query_submitted',
          at: now.subtract(const Duration(minutes: 3)),
          metadata: <String, Object?>{'queryKind': 'salah'},
        ),
        buildEvent(
          'search_result_opened',
          at: now.subtract(const Duration(minutes: 4)),
          metadata: <String, Object?>{'resultType': 'path'},
        ),
        buildEvent(
          'recommended_action_opened',
          at: now.subtract(const Duration(minutes: 5)),
        ),
        buildEvent(
          'recommended_path_started',
          at: now.subtract(const Duration(minutes: 6)),
          metadata: <String, Object?>{'pathId': 'salah-starter'},
        ),
        buildEvent(
          'explore_section_opened',
          at: now.subtract(const Duration(minutes: 7)),
          metadata: <String, Object?>{'sectionId': 'guided_paths'},
        ),
      ],
    );

    final summary = container.read(learnAnalyticsSummaryProvider);

    expect(summary.totalEvents, 8);
    expect(summary.pathStartsById['foundations-starter'], 1);
    expect(summary.pathStepCompletionsByPathId['foundations-starter'], 1);
    expect(summary.pathCompletionsById['foundations-starter'], 1);
    expect(summary.searchQueriesByKind['salah'], 1);
    expect(summary.searchResultOpensByType['path'], 1);
    expect(summary.recommendedActionOpens, 1);
    expect(summary.recommendedPathStarts, 1);
    expect(summary.exploreSectionOpensBySection['guided_paths'], 1);
  });

  test(
    'retirement signals only mark routes safe when recent usage is absent',
    () async {
      final now = DateTime.now().toUtc();
      final container = await makeContainer(
        events: <String>[
          buildEvent(
            'legacy_route_opened',
            at: now.subtract(const Duration(days: 2)),
            metadata: <String, Object?>{'routeKey': '/learn/legacy'},
          ),
          buildEvent(
            'compatibility_alias_hit',
            at: now.subtract(const Duration(days: 3)),
            metadata: <String, Object?>{'aliasPath': '/learn/hub/salah'},
          ),
          buildEvent(
            'legacy_route_opened',
            at: now.subtract(const Duration(days: 40)),
            metadata: <String, Object?>{'routeKey': '/learn/journey-home'},
          ),
        ],
      );

      final signals = container.read(learnRetirementCandidateSignalsProvider);
      final legacy = signals.firstWhere(
        (signal) => signal.routeKey == '/learn/legacy',
      );
      final salahAlias = signals.firstWhere(
        (signal) => signal.routeKey == '/learn/hub/salah',
      );
      final oldJourneyHome = signals.firstWhere(
        (signal) => signal.routeKey == '/learn/journey-home',
      );

      expect(legacy.directLegacyOpensLast30Days, 1);
      expect(legacy.safeToReviewForRetirement, isFalse);
      expect(salahAlias.aliasHitsLast30Days, 1);
      expect(salahAlias.safeToReviewForRetirement, isFalse);
      expect(oldJourneyHome.directLegacyOpensLast30Days, 0);
      expect(oldJourneyHome.safeToReviewForRetirement, isTrue);
    },
  );
}
