import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_beginner_words_data.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_word_lesson_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_words_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeKidsArabicAudioService extends KidsArabicAudioService {
  final List<String> spokenTexts = <String>[];

  @override
  Future<void> configure() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> speakText(String text) async {
    spokenTexts.add(text);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpWordsApp(
    WidgetTester tester, {
    String initialLocation = '/learn/kids/arabic/words',
    KidsArabicTraceMetrics initialMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    ),
    List<Override> overrides = const <Override>[],
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(overrides: overrides);
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/kids/arabic/words',
          name: 'kidsArabicWordsHome',
          builder: (context, state) =>
              const Scaffold(body: KidsArabicWordsPage()),
        ),
        GoRoute(
          path: '/learn/kids/arabic/words/:wordId',
          name: 'kidsArabicWordLesson',
          builder: (context, state) => Scaffold(
            body: KidsArabicWordLessonPage(
              wordId: state.pathParameters['wordId'] ?? '',
              initialMetrics: initialMetrics,
            ),
          ),
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

  testWidgets('beginner words page renders joining awareness and word cards', (
    tester,
  ) async {
    final container = await pumpWordsApp(tester);
    final notifier = container.read(kidsArabicProgressProvider.notifier);
    for (final id in const ['alif', 'ba']) {
      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == id),
        traceResult: KidsArabicTraceResult.good,
      );
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsArabicWordsPage)),
    );

    expect(find.text(l10n.kidsArabicWordsTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicWordsJoiningTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.kidsArabicWordsJoiningTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('baab'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('baab'), findsOneWidget);
    expect(find.text(l10n.kidsArabicWordBabMeaning), findsOneWidget);
  });

  testWidgets('unlocked word cards support tap-to-hear audio', (tester) async {
    final audio = _FakeKidsArabicAudioService();
    final container = await pumpWordsApp(
      tester,
      overrides: <Override>[
        kidsArabicAudioServiceProvider.overrideWithValue(audio),
      ],
    );
    final notifier = container.read(kidsArabicProgressProvider.notifier);
    for (final id in const ['alif', 'ba']) {
      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == id),
        traceResult: KidsArabicTraceResult.good,
      );
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsArabicWordsPage)),
    );

    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicWordsListenAction).first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(l10n.kidsArabicWordsListenAction).first);
    await tester.pump();

    expect(audio.spokenTexts, contains('باب'));
  });

  testWidgets('word lesson completes and routes to the next word', (
    tester,
  ) async {
    final container = await pumpWordsApp(
      tester,
      initialLocation: '/learn/kids/arabic/words/bab',
      initialMetrics: const KidsArabicTraceMetrics(
        strokeCount: 3,
        pointCount: 52,
        guidedProgress: 0.82,
        alignmentScore: 0.71,
        completedGuideStrokes: 3,
        totalGuideStrokes: 3,
        minimumEffortMet: true,
        successPulse: true,
      ),
    );
    final notifier = container.read(kidsArabicProgressProvider.notifier);
    for (final id in const ['alif', 'ba', 'noon']) {
      notifier.completeLesson(
        letter: kidsArabicLetters.firstWhere((item) => item.id == id),
        traceResult: KidsArabicTraceResult.good,
      );
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final l10n = AppLocalizations.of(
      tester.element(find.byType(KidsArabicWordLessonPage)),
    );

    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicWordTraceTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.kidsArabicWordTraceTitle), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.kidsArabicWordsContinueAction),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.kidsArabicWordsContinueAction), findsOneWidget);

    await tester.tap(find.text(l10n.kidsArabicWordsContinueAction));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(l10n.kidsArabicWordCompleteTitle('باب')), findsOneWidget);

    await tester.tap(
      find.text(
        l10n.kidsArabicWordNextAction(
          kidsArabicBeginnerWordById('noor')!.wordAr,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is KidsArabicWordLessonPage && widget.wordId == 'noor',
      ),
      findsOneWidget,
    );
  });
}
