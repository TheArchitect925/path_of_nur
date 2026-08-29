import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_scaffold.dart';
import 'package:path_of_nur/shared/widgets/global_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home centres its greeting, so the moon sits left there. Every other
/// surface keeps left-aligned titles, so the moon stays right and clear of
/// them.
void main() {
  Future<void> pumpAt(WidgetTester tester, String location) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: location,
      routes: [
        for (final path in const ['/home', '/learn', '/journey/garden'])
          GoRoute(
            path: path,
            builder: (context, state) => AppShellScaffold(
              currentLocation: path,
              child: const Center(child: Text('body')),
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
    await tester.pump(const Duration(milliseconds: 150));
  }

  Offset moonOf(WidgetTester tester) =>
      tester.widget<GlobalBackground>(find.byType(GlobalBackground))
          .moonFraction;

  testWidgets('the moon sits left on Home', (tester) async {
    await pumpAt(tester, '/home');
    expect(moonOf(tester), kMoonFractionHome);
    expect(kMoonFractionHome.dx, lessThan(0.5));
  });

  testWidgets('other tabs keep the moon on the right', (tester) async {
    await pumpAt(tester, '/learn');
    expect(moonOf(tester), kMoonFractionDefault);
    expect(kMoonFractionDefault.dx, greaterThan(0.5));

    await pumpAt(tester, '/journey/garden');
    expect(moonOf(tester), kMoonFractionDefault);
  });

  test('the two positions sit on opposite sides at the same height', () {
    expect(kMoonFractionHome.dy, kMoonFractionDefault.dy);
    expect(kMoonFractionHome.dx, lessThan(kMoonFractionDefault.dx));
  });
  group('right-to-left layouts', () {
    test('the moon swaps sides so it stays clear of mirrored chrome', () {
      // Arabic mirrors the header: Home's controls move to the leading
      // edge, so the moon has to move to the other side with them.
      expect(
        resolveMoonFraction(kMoonFractionHome, TextDirection.rtl).dx,
        greaterThan(0.5),
      );
      expect(
        resolveMoonFraction(kMoonFractionDefault, TextDirection.rtl).dx,
        lessThan(0.5),
      );
    });

    test('left-to-right positions are untouched', () {
      expect(
        resolveMoonFraction(kMoonFractionHome, TextDirection.ltr),
        kMoonFractionHome,
      );
      expect(
        resolveMoonFraction(kMoonFractionDefault, TextDirection.ltr),
        kMoonFractionDefault,
      );
    });

    test('mirroring keeps the same height and is its own inverse', () {
      const original = kMoonFractionHome;
      final mirrored = resolveMoonFraction(original, TextDirection.rtl);
      expect(mirrored.dy, original.dy);
      expect(resolveMoonFraction(mirrored, TextDirection.rtl), original);
    });
  });

}
