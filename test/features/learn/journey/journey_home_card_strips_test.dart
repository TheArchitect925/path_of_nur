import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_path_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/learn/journey/presentation/widgets/learning_journey_widgets.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

/// The journey home lays its cards out in horizontal strips. Those strips
/// used fixed heights, so the cards overflowed the moment they grew (the
/// island art did exactly that). They now size to their tallest card.
void main() {
  Future<void> pumpFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('journey card strips lay out without overflowing', (
    tester,
  ) async {
    // Phone width (what makes the cards tall) with a viewport tall enough
    // that every strip actually builds.
    await tester.binding.setSurfaceSize(const Size(390, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);

    // Put a journey outside the chosen path into secondary exploration so
    // the "Also exploring" strip renders.
    final selection = container.read(learningPathSelectionProvider.notifier);
    selection.setLevel(LearningPathLevel.beginner);
    selection.recordJourneyInteraction('tajweed-basics');

    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/learn/journey-home');
    await pumpFrames(tester);

    expect(find.byType(LearningJourneyCard), findsWidgets);
    expect(
      tester.takeException(),
      isNull,
      reason: 'no strip may overflow its cards',
    );

    // Larger text is where a fixed height would bite first.
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: buildRouterTestApp(container),
      ),
    );
    await pumpFrames(tester);
    expect(
      tester.takeException(),
      isNull,
      reason: 'strips must still fit when text is scaled up',
    );
  });
}
