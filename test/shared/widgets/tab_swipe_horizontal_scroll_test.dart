import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Swiping a horizontal row inside a tab — the Home "right now" duas, chip
/// rows, carousels — must scroll that row and leave the tab alone. The
/// shell's swipe detector reads raw pointer events, so it needs to notice a
/// horizontal scroll and stand down.
void main() {
  Future<GoRouter> pumpShell(
    WidgetTester tester, {
    required Widget body,
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              AppShellScaffold(currentLocation: '/home', child: body),
        ),
        GoRoute(
          path: '/journey',
          builder: (context, state) => const AppShellScaffold(
            currentLocation: '/journey',
            child: Center(child: Text('Growth')),
          ),
        ),
        GoRoute(
          path: '/learn',
          builder: (context, state) => const AppShellScaffold(
            currentLocation: '/learn',
            child: Center(child: Text('Learn')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    return router;
  }

  testWidgets('swiping a horizontal row scrolls it without changing tab', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final router = await pumpShell(
      tester,
      body: Center(
        child: SizedBox(
          height: 120,
          child: ListView(
            key: const ValueKey('dua-row'),
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < 12; i++)
                SizedBox(width: 200, child: Text('dua $i')),
            ],
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const ValueKey('dua-row')),
      const Offset(-240, 0),
    );
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(0), reason: 'the row scrolled');
    expect(
      router.state.uri.path,
      '/home',
      reason: 'the tab must not change while a row is being scrolled',
    );
  });

  testWidgets('swiping ordinary page content still changes tab', (
    tester,
  ) async {
    final router = await pumpShell(
      tester,
      body: const Center(child: Text('Home body')),
    );

    await tester.drag(find.text('Home body'), const Offset(-240, 0));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, isNot('/home'));
  });
}
