import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/presentation/names_of_allah_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/widgets/display/index_rail.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpPage(WidgetTester tester) async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const NamesOfAllahPage(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders the names grid with a fast-scroll rail', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byType(GridView), findsNothing); // sliver grid, not GridView
    expect(find.byType(IndexRail), findsOneWidget);
    expect(find.text('Ar-Rahman'), findsOneWidget);
    expect(find.text('The Entirely Merciful'), findsOneWidget);
  });

  testWidgets('search filters the grid and hides the rail', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'Rahman');
    await tester.pump();

    expect(find.text('Ar-Rahman'), findsOneWidget);
    expect(find.text('Al-Malik'), findsNothing);
    expect(find.byType(IndexRail), findsNothing);
  });

  testWidgets('tapping a name opens the detail sheet', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Ar-Rahman'));
    await tester.pumpAndSettle();

    // Sheet shows the name again alongside the grid tile.
    expect(find.text('Ar-Rahman'), findsNWidgets(2));
  });
}
