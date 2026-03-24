import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/content/presentation/learn_content_detail_page.dart';
import 'package:path_of_nur/features/learn/journey/presentation/learning_journey_detail_page.dart';
import 'package:path_of_nur/features/learn/journey/presentation/learning_journey_stage_page.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_category_catalog.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

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

  testWidgets('normalized hidden metadata routes still resolve safely', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final becomingMuslim = LearnCategoryCatalog.byId('becoming-muslim')!;
    router.goNamed(
      becomingMuslim.routeName,
      pathParameters: becomingMuslim.pathParameters,
      queryParameters: becomingMuslim.queryParameters,
    );
    await pumpRouteFrames(tester);
    expect(find.byType(LearnContentDetailPage), findsOneWidget);

    final aqeedah = LearnCategoryCatalog.byId('aqeedah-essentials')!;
    router.goNamed(
      aqeedah.routeName,
      pathParameters: aqeedah.pathParameters,
      queryParameters: aqeedah.queryParameters,
    );
    await pumpRouteFrames(tester);
    expect(find.byType(LearningJourneyDetailPage), findsOneWidget);

    final pillars = LearnCategoryCatalog.byId('five-pillars')!;
    router.goNamed(
      pillars.routeName,
      pathParameters: pillars.pathParameters,
      queryParameters: pillars.queryParameters,
    );
    await pumpRouteFrames(tester);
    expect(find.byType(LearningJourneyStagePage), findsOneWidget);
  });

  test('hidden catalog items with canonical owners now target route-specific destinations', () {
    expect(
      LearnCategoryCatalog.byId('becoming-muslim'),
      isNotNull,
    );
    expect(
      LearnCategoryCatalog.byId('becoming-muslim')!.routeName,
      'learnContentDetail',
    );
    expect(
      LearnCategoryCatalog.byId('becoming-muslim')!.pathParameters,
      {'category': 'life', 'topicId': 'new-muslim-path'},
    );

    expect(
      LearnCategoryCatalog.byId('aqeedah-essentials')!.routeName,
      'learnJourneyDetail',
    );
    expect(
      LearnCategoryCatalog.byId('aqeedah-essentials')!.pathParameters,
      {'journeyId': 'foundations-of-faith'},
    );

    expect(
      LearnCategoryCatalog.byId('five-pillars')!.routeName,
      'learnJourneyStage',
    );
    expect(
      LearnCategoryCatalog.byId('five-pillars')!.pathParameters,
      {'journeyId': 'islam-foundations', 'stageId': 'islam-five-pillars'},
    );

    expect(
      LearnCategoryCatalog.byId('ramadhan-fasting')!.routeName,
      'learnJourneyDetail',
    );
    expect(
      LearnCategoryCatalog.byId('ramadhan-fasting')!.pathParameters,
      {'journeyId': 'ramadan-foundations'},
    );

    expect(
      LearnCategoryCatalog.byId('zakah-sadaqah')!.routeName,
      'learnJourneyStage',
    );
    expect(
      LearnCategoryCatalog.byId('zakah-sadaqah')!.pathParameters,
      {'journeyId': 'fiqh-basics', 'stageId': 'fiqh-zakat-basics'},
    );

    expect(
      LearnCategoryCatalog.byId('hajj')!.routeName,
      'learnContentDetail',
    );
    expect(
      LearnCategoryCatalog.byId('hajj')!.pathParameters,
      {'category': 'life', 'topicId': 'hajj-full-journey'},
    );

    expect(
      LearnCategoryCatalog.byId('umrah')!.routeName,
      'learnContentDetail',
    );
    expect(
      LearnCategoryCatalog.byId('umrah')!.pathParameters,
      {'category': 'life', 'topicId': 'umrah-full-journey'},
    );

    expect(
      LearnCategoryCatalog.byId('fiqh-basic')!.routeName,
      'learnJourneyDetail',
    );
    expect(
      LearnCategoryCatalog.byId('fiqh-basic')!.pathParameters,
      {'journeyId': 'fiqh-basics'},
    );
  });

  test('ambiguous hidden catalog items stay on learnLegacy', () {
    const retainedLegacyIds = <String>['jummah', 'eid', 'funeral'];

    for (final id in retainedLegacyIds) {
      expect(LearnCategoryCatalog.byId(id), isNotNull);
      expect(LearnCategoryCatalog.byId(id)!.routeName, 'learnLegacy');
    }
  });

  test('hidden learn metadata stays out of active discovery', () {
    const hiddenIds = <String>{
      'becoming-muslim',
      'guidance-new-muslims',
      'aqeedah-essentials',
      'five-pillars',
      'ramadhan-fasting',
      'zakah-sadaqah',
      'jummah',
      'hajj',
      'umrah',
      'eid',
      'funeral',
      'fiqh-basic',
    };

    final activeIds = LearnCategoryCatalog.activeItems
        .map((item) => item.id)
        .toSet();

    expect(activeIds.intersection(hiddenIds), isEmpty);
  });
}
