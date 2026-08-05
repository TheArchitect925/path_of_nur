import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_rewards_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpRewards(WidgetTester tester) async {
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
          home: const Scaffold(body: KidsArabicRewardsPage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets('rewards page surfaces milestone and badge progress together', (
    tester,
  ) async {
    final container = await pumpRewards(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsArabicRewardsPage)),
    );
    final letterNotifier = container.read(kidsArabicProgressProvider.notifier);
    final wordNotifier = container.read(
      kidsArabicWordProgressProvider.notifier,
    );

    for (final id in const ['alif', 'ba', 'meem', 'noon']) {
      letterNotifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == id),
        traceResult: KidsArabicTraceResult.good,
      );
    }
    wordNotifier.completeWord('bab');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicLatestAchievementTitle),
      400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    expect(find.text(l10n.kidsArabicLatestAchievementTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicMilestonesSectionTitle),
      400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    expect(find.text(l10n.kidsArabicMilestoneFirstWordTitle), findsOneWidget);
    expect(find.text(l10n.kidsArabicMilestonesSectionTitle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicBadgesSectionTitle),
      300,
    );
    expect(find.text(l10n.kidsArabicBadgesSectionTitle), findsOneWidget);
  });
}
