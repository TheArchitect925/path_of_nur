import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_guided_passage_readiness_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpGuidedPage(
    WidgetTester tester, {
    required ArabicLearningAudience audience,
    String? initialPassageId,
  }) async {
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
          home: Scaffold(
            body: QuranGuidedPassageReadinessPage(
              audience: audience,
              initialPassageId: initialPassageId,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('guided passage page shows new progression stages', (
    tester,
  ) async {
    await pumpGuidedPage(tester, audience: ArabicLearningAudience.adult);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(QuranGuidedPassageReadinessPage)),
    );

    expect(find.text(l10n.quranGuidedPassagesAdultPageTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesProgressionTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesStageOneTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesStageTwoTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesStageThreeTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesOpeningTitle), findsOneWidget);
    expect(find.text(l10n.quranGuidedPassagesFullTitle), findsOneWidget);
  });

  testWidgets('guided passage page renders full Al-Fatihah passage support', (
    tester,
  ) async {
    await pumpGuidedPage(
      tester,
      audience: ArabicLearningAudience.adult,
      initialPassageId: 'fatihah_full_passage',
    );

    final l10n = AppLocalizations.of(
      tester.element(find.byType(QuranGuidedPassageReadinessPage)),
    );

    await tester.scrollUntilVisible(
      find.text(l10n.quranGuidedPassagesKnownSnippetsTitle),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(find.text(l10n.quranGuidedPassagesFullTitle), findsWidgets);
    expect(
      find.text(l10n.quranGuidedPassagesKnownSnippetsTitle),
      findsOneWidget,
    );
    expect(find.text(l10n.quranGuidedPassagesOpenReaderAction), findsOneWidget);
    expect(find.text('Ayah 7'), findsOneWidget);
  });
}
