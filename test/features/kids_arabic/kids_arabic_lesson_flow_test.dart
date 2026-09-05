import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_audio_service.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_parent_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progress_provider.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_lesson_page.dart';
import 'package:path_of_nur/features/kids_arabic/widgets/kids_arabic_tracing_pad.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeKidsArabicAudioService extends KidsArabicAudioService {
  int speakCount = 0;

  @override
  Future<void> configure() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> speakLetter(dynamic letter) async {
    speakCount += 1;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpLessonApp(
    WidgetTester tester, {
    required String letterId,
    KidsArabicTraceMetrics initialMetrics = const KidsArabicTraceMetrics(
      strokeCount: 0,
      pointCount: 0,
    ),
    List<Override> overrides = const <Override>[],
    Duration settleDelay = const Duration(milliseconds: 800),
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 2800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(overrides: overrides);
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/learn/kids/arabic/lesson/$letterId',
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/kids/arabic',
          name: 'kidsArabicHome',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Letters home'))),
        ),
        GoRoute(
          path: '/learn/kids/arabic/lesson/:letterId',
          name: 'kidsArabicLesson',
          builder: (context, state) => Scaffold(
            body: KidsArabicLessonPage(
              letterId: state.pathParameters['letterId'] ?? '',
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(settleDelay);
    return container;
  }

  testWidgets('completion card appears after the delight timing delay', (
    tester,
  ) async {
    await pumpLessonApp(
      tester,
      letterId: 'alif',
      settleDelay: const Duration(milliseconds: 120),
      initialMetrics: const KidsArabicTraceMetrics(
        strokeCount: 2,
        pointCount: 36,
        guidedProgress: 0.84,
        alignmentScore: 0.72,
        completedGuideStrokes: 1,
        totalGuideStrokes: 1,
        minimumEffortMet: true,
        successPulse: true,
      ),
    );

    expect(find.text('Tracing complete'), findsNothing);

    await tester.pump(const Duration(milliseconds: 260));
    expect(find.text('Tracing complete'), findsOneWidget);
  });

  testWidgets('lesson page shows ready state and retry clears it', (
    tester,
  ) async {
    await pumpLessonApp(
      tester,
      letterId: 'alif',
      initialMetrics: const KidsArabicTraceMetrics(
        strokeCount: 2,
        pointCount: 36,
        guidedProgress: 0.84,
        alignmentScore: 0.72,
        completedGuideStrokes: 1,
        totalGuideStrokes: 1,
        minimumEffortMet: true,
        successPulse: true,
      ),
    );

    expect(find.text('Tracing complete'), findsOneWidget);
    expect(find.text('Try again'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Try again').first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Try again').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tracing complete'), findsNothing);
  });

  testWidgets('lesson page supports listen-and-repeat playback from the hero', (
    tester,
  ) async {
    final audio = _FakeKidsArabicAudioService();
    await pumpLessonApp(
      tester,
      letterId: 'alif',
      overrides: <Override>[
        kidsArabicAudioServiceProvider.overrideWithValue(audio),
      ],
      settleDelay: const Duration(milliseconds: 200),
    );

    expect(find.text('Listen and repeat'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Listen').first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Listen').first);
    await tester.pump();

    expect(audio.speakCount, 1);
    expect(find.text('Now say it softly with me.'), findsOneWidget);
  });

  testWidgets('lesson completion routes to next letter and persists progress', (
    tester,
  ) async {
    final container = await pumpLessonApp(
      tester,
      letterId: 'alif',
      initialMetrics: const KidsArabicTraceMetrics(
        strokeCount: 2,
        pointCount: 36,
        guidedProgress: 0.84,
        alignmentScore: 0.72,
        completedGuideStrokes: 1,
        totalGuideStrokes: 1,
        minimumEffortMet: true,
        successPulse: true,
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Continue'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    // The first completion of a letter earns a sticker (K4): the celebration
    // shows before the completion sheet and "Yay!" dismisses it.
    expect(find.text('You earned a sticker!'), findsOneWidget);
    await tester.tap(find.text('Yay!'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final state = container.read(kidsArabicProgressProvider);
    expect(state.completedLetterIds, contains('alif'));
    expect(state.totalLessonsDone, 1);

    expect(find.text('Next'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.byWidgetPredicate(
        (widget) => widget is KidsArabicLessonPage && widget.letterId == 'ba',
      ),
      findsOneWidget,
    );
  });

  testWidgets('completion audio plays once after a successful trace', (
    tester,
  ) async {
    final audio = _FakeKidsArabicAudioService();
    final container = await pumpLessonApp(
      tester,
      letterId: 'alif',
      overrides: <Override>[
        kidsArabicAudioServiceProvider.overrideWithValue(audio),
      ],
    );
    container
        .read(kidsArabicParentPreferencesProvider.notifier)
        .setAudioAutoplay(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    final baselineCount = audio.speakCount;
    final traceSurface = find
        .descendant(
          of: find.byType(KidsArabicTracingPad),
          matching: find.byType(GestureDetector),
        )
        .first;
    final paintRect = tester.getRect(traceSurface);
    final localPath = kidsArabicSampledVectorPathPoints(
      kidsArabicVectorTraceLetterFor(
        'alif',
      )!.strokes.first.pathBuilder(paintRect.size),
      sampleSpacing: 6,
    );
    final gesture = await tester.startGesture(
      paintRect.topLeft + localPath.first,
    );
    for (var pass = 0; pass < 2; pass += 1) {
      for (final point in localPath.skip(1)) {
        await gesture.moveTo(paintRect.topLeft + point);
        await tester.pump(const Duration(milliseconds: 16));
      }
    }
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 260));

    expect(audio.speakCount, baselineCount + 1);

    await tester.pump(const Duration(milliseconds: 700));
    expect(audio.speakCount, baselineCount + 1);
  });
}
