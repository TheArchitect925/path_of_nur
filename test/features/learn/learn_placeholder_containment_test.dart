import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/journey/presentation/learning_journey_lesson_page.dart';
import 'package:path_of_nur/features/learn/presentation/widgets/learn_contained_state_localizations.dart';
import 'package:path_of_nur/features/learn/shared/application/learn_release_gate.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
  }

  test('arabic learning discovery includes live tajweed journey again', () {
    final visibleArabicJourneys =
        LearningJourneyRegistry.journeysForIsland('arabic-learning')
            .where(isProductionSafeLearningJourney)
            .map((journey) => journey.id)
            .toSet();

    expect(visibleArabicJourneys, contains('tajweed-basics'));
  });

  testWidgets(
    'tajweed routes are real while legacy guide routes stay contained',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      router.go('/learn/journey/tajweed-basics');
      await pumpRouteFrames(tester);
      expect(find.text('Tajweed Basics'), findsOneWidget);
      expect(find.text(l10n.learnContainedStateJourneySubtitle), findsNothing);

      router.go('/learn/journey/tajweed-basics/stage/tajweed-intro');
      await pumpRouteFrames(tester);
      expect(find.byType(LearningJourneyLessonPage), findsOneWidget);
      expect(find.text(l10n.learnContainedStateJourneySubtitle), findsNothing);
      expect(
        find.textContaining('Tajweed is the careful recitation of the Qur’an'),
        findsOneWidget,
      );

      router.go('/learn/guides');
      await pumpRouteFrames(tester);
      expect(find.text(l10n.homeSearchGuidanceHubTitle), findsOneWidget);
      expect(find.text(l10n.learnContainedStateGuidesSubtitle), findsOneWidget);

      router.go('/learn/guides/quran-lessons-mapping');
      await pumpRouteFrames(tester);
      expect(
        find.text(l10n.learnContainedStateQuranMappingTitle),
        findsOneWidget,
      );
      expect(
        find.text(l10n.learnContainedStateQuranMappingSubtitle),
        findsOneWidget,
      );
    },
  );
}
