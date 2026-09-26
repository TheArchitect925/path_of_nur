import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_landing_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/motion/ink_reveal.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';
import 'package:path_of_nur/shared/widgets/section_hub_scaffold.dart';

import '../../../test_helpers/app_test_harness.dart';

/// The daily hadith card writes its title in and lets the source follow —
/// the same ink the day's ayah gets on Home.
void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<void> openHadithLanding(
    WidgetTester tester, {
    required bool reduceMotion,
  }) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
        effectiveReduceMotionProvider.overrideWithValue(reduceMotion),
      ],
    );
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    router.go('/learn/category/quran-hadith');
    await pumpRouteFrames(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(Navigator).first),
    );
    final label = find.text(l10n.learnCategoryHadithTitle).first;
    await tester.ensureVisible(label);
    await pumpRouteFrames(tester);
    await tester.tap(
      find
          .ancestor(of: label, matching: find.byType(SectionHubActionCard))
          .first,
    );
    await pumpRouteFrames(tester);
    expect(find.byType(HadithLandingPage), findsOneWidget);
    // The daily card sits below the browse group; the test viewport is short,
    // so scroll until it has been built.
    final dailyTitle = find.text(l10n.hadithTitleDailyReflection);
    final scrollable = find.byType(Scrollable).first;
    var attempts = 0;
    while (dailyTitle.evaluate().isEmpty && attempts < 30) {
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pump();
      attempts += 1;
    }
    await pumpRouteFrames(tester);
    expect(dailyTitle, findsOneWidget);
  }

  testWidgets(
    'the daily hadith card inks its title in and its source follows',
    (tester) async {
      await openHadithLanding(tester, reduceMotion: false);
      final page = find.byType(HadithLandingPage);
      expect(
        find.descendant(of: page, matching: find.byType(InkReveal)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: page, matching: find.byType(FadeRise)),
        findsOneWidget,
      );
      // The reveal is a clip while it runs and a full clip at rest; the source
      // line rises into place. Both finish within the page's own settle.
      await tester.pump(const Duration(seconds: 2));
    },
  );

  testWidgets('under Reduce Motion the card is simply there', (tester) async {
    await openHadithLanding(tester, reduceMotion: true);
    final reveal = find.descendant(
      of: find.byType(HadithLandingPage),
      matching: find.byType(InkReveal),
    );
    expect(reveal, findsOneWidget);
    expect(
      find.descendant(of: reveal, matching: find.byType(ClipRect)),
      findsNothing,
    );
  });
}
