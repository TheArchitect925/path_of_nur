import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_page_scaffold.dart';
import 'package:path_of_nur/shared/widgets/web_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The web build fills the browser window: a sidebar past 1000 px, and page
/// content centred at a readable width. Native builds keep the phone layout.
void main() {
  tearDown(() => WebLayout.debugForceWeb = false);

  group('WebLayout.sidePadding', () {
    test('native builds always keep the minimum', () {
      expect(WebLayout.sidePadding(1600), 16);
      expect(WebLayout.sidePadding(1600, minimum: 18), 18);
    });

    test('the web centres content no wider than the maximum', () {
      WebLayout.debugForceWeb = true;
      expect(WebLayout.sidePadding(390), 16);
      expect(WebLayout.sidePadding(1600), (1600 - 960) / 2);
      expect(
        WebLayout.sidePadding(1000, maxWidth: WebLayout.flowMaxWidth),
        (1000 - 720) / 2,
      );
    });
  });

  group('WebLayout.usesSidebar', () {
    Future<bool> usesSidebarAt(WidgetTester tester, double width) async {
      late bool result;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 900)),
          child: Builder(
            builder: (context) {
              result = WebLayout.usesSidebar(context);
              return const SizedBox();
            },
          ),
        ),
      );
      return result;
    }

    testWidgets('only a wide web window gets the sidebar', (tester) async {
      expect(await usesSidebarAt(tester, 1440), isFalse);
      WebLayout.debugForceWeb = true;
      expect(await usesSidebarAt(tester, 1440), isTrue);
      expect(await usesSidebarAt(tester, 999), isFalse);
      expect(await usesSidebarAt(tester, 390), isFalse);
    });
  });

  testWidgets('page content centres at a readable width on a wide web window', (
    tester,
  ) async {
    WebLayout.debugForceWeb = true;
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
          home: const AppPageScaffold(
            title: 'Wide page',
            children: [SizedBox(key: Key('row'), height: 80)],
          ),
        ),
      ),
    );
    await tester.pump();

    final row = tester.getRect(find.byKey(const Key('row')));
    expect(row.width, 960);
    expect(row.left, (1600 - 960) / 2);
  });
}
