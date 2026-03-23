import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_home_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_lesson_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_review_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_rewards_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpLocalizedPage(
    WidgetTester tester, {
    required Locale locale,
    required Widget child,
  }) async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: locale,
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
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('kids Arabic home page loads in English, Arabic, and German', (
    tester,
  ) async {
    for (final locale in const [Locale('en'), Locale('ar'), Locale('de')]) {
      await pumpLocalizedPage(
        tester,
        locale: locale,
        child: const KidsArabicHomePage(),
      );
      expect(find.byType(KidsArabicHomePage), findsOneWidget);
    }
  });

  testWidgets('kids Arabic lesson and review pages load in English, Arabic, and German', (
    tester,
  ) async {
    for (final locale in const [Locale('en'), Locale('ar'), Locale('de')]) {
      await pumpLocalizedPage(
        tester,
        locale: locale,
        child: const KidsArabicLessonPage(letterId: 'alif'),
      );
      expect(find.byType(KidsArabicLessonPage), findsOneWidget);

      await pumpLocalizedPage(
        tester,
        locale: locale,
        child: const KidsArabicReviewPage(),
      );
      expect(find.byType(KidsArabicReviewPage), findsOneWidget);
    }
  });

  testWidgets('kids Arabic rewards and parent dashboard pages load in English, Arabic, and German', (
    tester,
  ) async {
    for (final locale in const [Locale('en'), Locale('ar'), Locale('de')]) {
      await pumpLocalizedPage(
        tester,
        locale: locale,
        child: const KidsArabicRewardsPage(),
      );
      expect(find.byType(KidsArabicRewardsPage), findsOneWidget);

      await pumpLocalizedPage(
        tester,
        locale: locale,
        child: const KidsArabicParentDashboardPage(),
      );
      expect(find.byType(KidsArabicParentDashboardPage), findsOneWidget);
    }
  });
}
