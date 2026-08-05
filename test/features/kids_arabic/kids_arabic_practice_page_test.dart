import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_words_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_beginner_words_data.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_practice_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpPracticeApp(WidgetTester tester) async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/learn/kids/arabic/practice',
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/kids/arabic/practice',
          name: 'kidsArabicPractice',
          builder: (context, state) =>
              const Scaffold(body: KidsArabicPracticePage()),
        ),
        GoRoute(
          path: '/learn/kids/arabic/lesson/:letterId',
          name: 'kidsArabicLesson',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text('lesson:${state.pathParameters['letterId'] ?? ''}'),
            ),
          ),
        ),
        GoRoute(
          path: '/learn/kids/arabic/words/:wordId',
          name: 'kidsArabicWordLesson',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text('word:${state.pathParameters['wordId'] ?? ''}'),
            ),
          ),
        ),
        GoRoute(
          path: '/learn/kids/arabic/words/reading',
          name: 'kidsArabicReadingMode',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text('reading:${state.uri.queryParameters['word'] ?? ''}'),
            ),
          ),
        ),
        GoRoute(
          path: '/learn/kids/arabic/review',
          name: 'kidsArabicReview',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('review'))),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    return container;
  }

  testWidgets(
    'practice page opens lesson and word destinations from surfaced items',
    (tester) async {
      final container = await pumpPracticeApp(tester);
      final letterNotifier = container.read(
        kidsArabicProgressProvider.notifier,
      );
      final wordNotifier = container.read(
        kidsArabicWordProgressProvider.notifier,
      );

      for (final id in const ['alif', 'ba', 'noon']) {
        letterNotifier.completeLesson(
          letter: kidsArabicLetters.firstWhere((item) => item.id == id),
          traceResult: KidsArabicTraceResult.good,
        );
      }
      wordNotifier.completeWord('bab');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicPracticePage)),
      );
      final noorAr = kidsArabicBeginnerWordById('noor')!.wordAr;

      expect(find.text(l10n.kidsArabicPracticeTitle), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicPracticeContinueWordTitle(noorAr)),
        300,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      expect(
        find.text(l10n.kidsArabicPracticeContinueWordTitle(noorAr)),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicPracticeReviewWordsTitle),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.text(l10n.kidsArabicPracticeReviewWordsTitle),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text(l10n.kidsArabicPracticeContinueWordTitle(noorAr)),
        -300,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      final continueButton = tester.widget<TextButton>(
        find
            .widgetWithText(TextButton, l10n.kidsArabicPracticeContinueAction)
            .last,
      );
      continueButton.onPressed!.call();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('word:noor'), findsOneWidget);
    },
  );
}
