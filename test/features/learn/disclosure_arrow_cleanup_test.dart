import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/widgets/learn_cards.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  testWidgets('LearnActionCard is arrowless by default and stays tappable', (
    tester,
  ) async {
    var tapped = false;
    final container = await makeTestContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: LearnActionCard(
              title: 'Read Qur’an',
              subtitle: 'Open the explorer',
              icon: Icons.menu_book_rounded,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.chevron_right), findsNothing);

    await tester.tap(find.text('Read Qur’an'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('Surah explorer rows render without disclosure arrows', (
    tester,
  ) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/learn/quran/explorer');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranSurahExplorerPage), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.byType(InkWell), findsWidgets);
  });
}
