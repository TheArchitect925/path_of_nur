import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_home_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpHome(WidgetTester tester) async {
    final container = await makeTestContainer(
      overrides: [
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
          home: const Scaffold(body: KidsArabicHomePage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets('home page shows practice and mastery entry cards', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.scrollUntilVisible(
      find.text('Open progress map'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('Open practice'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Practice & Review'), findsOneWidget);
    expect(find.text('Progress map'), findsOneWidget);
    expect(find.text('Open practice'), findsOneWidget);
  });

  testWidgets('home page shows practiced today state after mission completion', (
    tester,
  ) async {
    final container = await pumpHome(tester);
    final letter = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
    container
        .read(kidsArabicProgressProvider.notifier)
        .completeLesson(
          letter: letter,
          traceResult: KidsArabicTraceResult.good,
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.scrollUntilVisible(
      find.text('Practiced today'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Practiced today'), findsOneWidget);
    expect(
      find.text(
        'You practiced today already. You can still continue or review calmly whenever you want.',
      ),
      findsOneWidget,
    );
  });
}
