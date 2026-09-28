import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_page_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Long pages carry a thin scroll indicator so the reader can see how much
/// of the page is left.
void main() {
  Future<void> pumpScaffold(
    WidgetTester tester, {
    ScrollController? controller,
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppPageScaffold(
            title: 'Long page',
            subtitle: 'Scrollable',
            scrollController: controller,
            children: [
              for (var i = 0; i < 40; i++)
                SizedBox(height: 80, child: Text('row $i')),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('page scaffold renders a scroll indicator', (tester) async {
    await pumpScaffold(tester);
    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('the indicator attaches to a page-supplied controller', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpScaffold(tester, controller: controller);

    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.controller, same(controller));
    expect(controller.hasClients, isTrue);
  });

  testWidgets('pages without a controller still scroll and show the track', (
    tester,
  ) async {
    await pumpScaffold(tester);
    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.controller, isNotNull);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    expect(scrollbar.controller!.offset, greaterThan(0));
  });
}
