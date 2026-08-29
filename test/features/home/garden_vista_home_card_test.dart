import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_provider.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_motion_painter.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_vista_view.dart';
import 'package:path_of_nur/features/home/domain/home_modules.dart';
import 'package:path_of_nur/features/home/presentation/widgets/garden_vista_home_card.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/garden_fixtures.dart';

void main() {
  group('HomeModule.garden registration', () {
    test('ships in the default order so it appears for everyone', () {
      expect(kDefaultHomeModuleOrder, contains(HomeModule.garden));
      expect(HomeModule.fromStorageId('garden'), HomeModule.garden);
    });

    test('existing users get the new module appended, not dropped', () {
      // Prefs saved before the garden module existed.
      final prefs = HomeModulePrefs.fromJson(<String, dynamic>{
        'order': ['prayer_strip', 'today', 'duas_now'],
        'hidden': <String>[],
      });
      expect(prefs.order, contains(HomeModule.garden));
      expect(prefs.visible, contains(HomeModule.garden));
    });

    test('a hidden garden module stays hidden', () {
      final prefs = HomeModulePrefs.fromJson(<String, dynamic>{
        'order': ['prayer_strip', 'garden'],
        'hidden': ['garden'],
      });
      expect(prefs.isVisible(HomeModule.garden), isFalse);
      expect(prefs.visible, isNot(contains(HomeModule.garden)));
    });
  });

  Future<ProviderContainer> pumpCard(WidgetTester tester) async {
    final container = await makeGardenTestContainer();
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: SizedBox(width: 380, child: GardenVistaHomeCard())),
          ),
        ),
        GoRoute(
          path: '/journey/garden',
          name: 'gardenPage',
          builder: (context, state) =>
              const Scaffold(body: Text('garden-page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('renders the compact vista with a stage caption', (tester) async {
    await pumpCard(tester);
    expect(find.byType(GardenVistaView), findsOneWidget);
    final vista = tester.widget<GardenVistaView>(find.byType(GardenVistaView));
    expect(vista.crop, GardenVistaCrop.homeCard);
    expect(vista.enableMotion, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('never animates and never acknowledges growth', (tester) async {
    final container = await pumpCard(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.byWidgetPredicate((widget) =>
          widget is CustomPaint && widget.painter is GardenMotionPainter),
      findsNothing,
      reason: 'the Home card must not carry a ticker',
    );
    expect(
      container.read(gardenSceneMementoRepositoryProvider).read('learner_1'),
      isNull,
      reason: 'the bloom moment belongs to the Garden page, not Home',
    );
  });

  testWidgets('tapping the card opens the garden', (tester) async {
    await pumpCard(tester);
    await tester.tap(find.byType(GardenVistaHomeCard));
    await tester.pumpAndSettle();
    expect(find.text('garden-page'), findsOneWidget);
  });
}
