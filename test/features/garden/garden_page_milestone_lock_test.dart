import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_service.dart';
import 'package:path_of_nur/features/garden/presentation/garden_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

/// Milestone art is the reward for reaching a milestone, so the strip on the
/// garden page must not preview the ones still out of reach.
void main() {
  testWidgets('locked milestones on the garden page hide their art', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: GardenPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final garden = container.read(activeGardenStateProvider);
    final lockedCount = garden.milestones.where((m) => !m.unlocked).length;
    final unlockedCount = garden.milestones.length - lockedCount;
    expect(
      lockedCount,
      greaterThan(0),
      reason: 'a new garden should still have milestones to earn',
    );

    // Scope to the milestone strip itself; the page carries other imagery.
    final strip = find.byWidgetPredicate(
      (widget) =>
          widget is ListView && widget.scrollDirection == Axis.horizontal,
    );
    expect(strip, findsOneWidget);

    // The strip builds lazily, so only on-screen tiles exist — each shows
    // either a lock or its artwork, never a dimmed preview.
    expect(
      find.descendant(of: strip, matching: find.byIcon(Icons.lock_rounded)),
      findsWidgets,
      reason: 'visible locked milestones show a lock instead of their art',
    );

    // Before this rule every built tile rendered its image regardless of
    // state; now artwork appears only for milestones actually earned.
    expect(
      find
          .descendant(of: strip, matching: find.byType(Image))
          .evaluate()
          .length,
      lessThanOrEqualTo(unlockedCount),
      reason: 'no locked milestone may render its artwork',
    );
  });
}
