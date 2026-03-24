import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_category_catalog.dart';
import 'package:path_of_nur/features/learn/presentation/learn_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/prophets/presentation/prophets_page.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<ProviderContainer> makeRoutingTestContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
  }

  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  testWidgets('learn browse alias forwards query params to canonical explore', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/learn/browse?q=allah&category=quran-hadith');
    await pumpRouteFrames(tester);

    expect(find.byType(LearnExploreAllKnowledgePage), findsOneWidget);
    expect(router.state.uri.path, '/learn/explore');
    expect(router.state.uri.queryParameters['q'], 'allah');
    expect(router.state.uri.queryParameters['category'], 'quran-hadith');
  });

  testWidgets(
    'learn prophets section alias forwards query params to canonical prophets route',
    (tester) async {
      final container = await makeRoutingTestContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/learn/section/prophets?tab=quiz');
      await pumpRouteFrames(tester);

      expect(find.byType(ProphetsPage), findsOneWidget);
      expect(router.state.uri.path, '/learn/prophets');
      expect(router.state.uri.queryParameters['tab'], 'quiz');
    },
  );

  testWidgets(
    'learn quran learning alias forwards query params to canonical quran learning route',
    (tester) async {
      final container = await makeRoutingTestContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/learn/hub/quran/learning?tab=reflect');
      await pumpRouteFrames(tester);

      expect(find.byType(LearnQuranHubPage), findsOneWidget);
      expect(router.state.uri.path, '/quran/learning');
      expect(router.state.uri.queryParameters['tab'], 'reflect');
    },
  );

  testWidgets('learn legacy route remains a stable compatibility surface', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/learn/legacy');
    await pumpRouteFrames(tester);

    expect(find.byType(LearnPage), findsOneWidget);
    expect(router.state.uri.path, '/learn/legacy');
  });

  test('active learn catalog items avoid compatibility-only route targets', () {
    const disallowedRouteNames = <String>{
      'learnLegacy',
      'learnJourneyBrowse',
      'learnQuranHub',
      'learnQuranLearning',
      'learnQuranArabic',
      'growthTrackingDashboard',
      'growthHabitAlias',
    };

    for (final item in LearnCategoryCatalog.activeItems) {
      expect(
        disallowedRouteNames.contains(item.routeName),
        isFalse,
        reason: '${item.id} should use canonical route ownership',
      );
    }
  });
}
