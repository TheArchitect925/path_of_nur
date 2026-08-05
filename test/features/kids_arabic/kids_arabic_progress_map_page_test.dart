import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_mastery_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_progress_map_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpProgressMap(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
  }) async {
    final container = await makeTestContainer(overrides: overrides);
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/learn/kids/arabic/progress',
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/kids/arabic/progress',
          name: 'kidsArabicProgressMap',
          builder: (context, state) =>
              const Scaffold(body: KidsArabicProgressMapPage()),
        ),
        GoRoute(
          path: '/learn/kids/arabic/lesson/:letterId',
          name: 'kidsArabicLesson',
          builder: (context, state) => Scaffold(
            body: Text('Lesson ${state.pathParameters['letterId']}'),
          ),
        ),
        GoRoute(
          path: '/learn/kids/arabic/review',
          name: 'kidsArabicReview',
          builder: (context, state) => const Scaffold(body: Text('Review')),
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
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets(
    'progress map opens the next lesson from the recommendation card',
    (tester) async {
      await pumpProgressMap(tester);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(KidsArabicProgressMapPage)),
      );

      expect(find.text(l10n.kidsArabicMasteryMapTitle), findsOneWidget);
      final continueFinder = find.widgetWithText(
        FilledButton,
        l10n.kidsArabicMasteryContinueAction,
      );
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        continueFinder,
        250,
        scrollable: scrollable,
      );
      await tester.ensureVisible(continueFinder);
      await tester.pump();
      expect(continueFinder, findsOneWidget);

      await tester.tap(continueFinder);
      await tester.pumpAndSettle();

      expect(find.text('Lesson alif'), findsOneWidget);
    },
  );

  testWidgets('progress map state flips into review when a letter needs it', (
    tester,
  ) async {
    final container = await pumpProgressMap(tester);
    final notifier = container.read(kidsArabicProgressProvider.notifier);
    final alif = kidsArabicLetters.firstWhere((item) => item.id == 'alif');
    notifier.completeLesson(
      letter: alif,
      traceResult: KidsArabicTraceResult.completed,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final reviewCandidates = container.read(kidsArabicReviewCandidatesProvider);
    final recommendation = container.read(
      kidsArabicMasteryRecommendationProvider,
    );

    expect(reviewCandidates.map((letter) => letter.id), contains('alif'));
    expect(
      recommendation?.type,
      KidsArabicMasteryRecommendationType.reviewLetter,
    );
    expect(recommendation?.letter.id, 'alif');
  });
}
