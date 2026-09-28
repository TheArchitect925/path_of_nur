import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/widgets/display/expandable_tile.dart';

import '../../test_helpers/garden_fixtures.dart';

/// The Today module is wrapped in an ExpandableTile on Home. These cover the
/// wrapper contract (header shown, opens expanded, collapses on tap) without
/// pulling in the full Quran reflection stack.
void main() {
  Future<void> pumpTile(
    WidgetTester tester, {
    required bool initiallyExpanded,
  }) async {
    final container = await makeGardenTestContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return ExpandableTile(
                  leading: const Icon(Icons.auto_stories_rounded, size: 20),
                  title: Text(l10n.homeTodayContentTitle),
                  subtitle: Text(l10n.homeTodayContentSubtitle),
                  initiallyExpanded: initiallyExpanded,
                  child: const Text('ayah-body'),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens expanded so the day\'s ayah is not hidden by default', (
    tester,
  ) async {
    await pumpTile(tester, initiallyExpanded: true);
    expect(find.text('ayah-body'), findsOneWidget);
  });

  testWidgets('tapping the header collapses and re-expands it', (tester) async {
    await pumpTile(tester, initiallyExpanded: true);

    await tester.tap(find.byType(ExpandableTile));
    await tester.pumpAndSettle();
    expect(
      find.text('ayah-body'),
      findsNothing,
      reason: 'the reader asked to tuck it away',
    );

    await tester.tap(find.byType(ExpandableTile));
    await tester.pumpAndSettle();
    expect(find.text('ayah-body'), findsOneWidget);
  });

  testWidgets('the tile always shows its own Today header', (tester) async {
    await pumpTile(tester, initiallyExpanded: false);
    final context = tester.element(find.byType(ExpandableTile));
    final l10n = AppLocalizations.of(context);
    expect(
      find.text(l10n.homeTodayContentTitle),
      findsOneWidget,
      reason:
          'the header stays visible while collapsed, and HomeTodayCard '
          'suppresses its own SectionTitle to avoid printing it twice',
    );
  });
}
