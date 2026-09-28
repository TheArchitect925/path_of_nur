import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/kids_hadith_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/kids_quran_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpPage(WidgetTester tester, Widget child) async {
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
          home: child,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('kids quran page loads the simplified surah browser', (
    tester,
  ) async {
    await pumpPage(tester, const KidsQuranPage());

    expect(find.text('Qur’an for Kids'), findsOneWidget);
    expect(find.text('Start with any surah'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Al Fatiha • The Opening'),
      400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    await tester.pump();
    expect(find.text('Al Fatiha • The Opening'), findsOneWidget);
    expect(find.text('Open surah'), findsWidgets);
  });

  testWidgets('kids hadith page loads curated hadith and story entry point', (
    tester,
  ) async {
    await pumpPage(tester, const KidsHadithPage());
    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsHadithPage)),
    );

    expect(find.text(l10n.kidsHadithPageTitleText), findsOneWidget);
    expect(find.text('Small hadith, big lessons'), findsOneWidget);
    expect(find.text('Hadith stories'), findsOneWidget);
    expect(find.text('Actions Are by Intentions'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Smiling at Your Brother Is Charity'),
      400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    await tester.pump();
    expect(find.text('Actions Are by Intentions'), findsNothing);
    expect(find.text('Smiling at Your Brother Is Charity'), findsOneWidget);
  });

  testWidgets('kids hadith stories page loads hadith-backed stories only', (
    tester,
  ) async {
    await pumpPage(tester, const KidsHadithStoriesPage());
    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsHadithStoriesPage)),
    );

    expect(find.text(l10n.kidsHadithStoriesPageTitleText), findsOneWidget);
    expect(find.text('Bismillah Before Eating'), findsOneWidget);
    expect(find.text('Sharing With Others'), findsNothing);
    expect(
      find.textContaining(l10n.kidsHadithStoriesSourceLabelText),
      findsNWidgets(2),
    );
  });
}
