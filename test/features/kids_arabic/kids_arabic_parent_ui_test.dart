import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_parent_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_home_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpPage(WidgetTester tester, Widget child) async {
    final container = await makeTestContainer(
      overrides: [
        kidsArabicNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 9)),
        dailyNowProvider.overrideWith((ref) async* {
          yield DateTime(2026, 3, 18, 9);
        }),
      ],
    );
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
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets('child home reflects parent focus guidance', (tester) async {
    final container = await pumpPage(tester, const KidsArabicHomePage());
    final notifier = container.read(
      kidsArabicParentPreferencesProvider.notifier,
    );
    notifier.setAllowParentAssignedFocus(true);
    notifier.assignFocusLetter('alif', validLetterIds: {'alif'});
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Today’s focus'), findsOneWidget);
  });

  testWidgets('parent dashboard shows parent controls entry', (tester) async {
    final container = await pumpPage(
      tester,
      const KidsArabicParentDashboardPage(),
    );
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(
          letter: container
              .read(kidsArabicLettersProvider)
              .firstWhere((item) => item.id == 'alif'),
          traceResult: KidsArabicTraceResult.good,
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Arabic learning is moving gently'), findsOneWidget);
  });
}
