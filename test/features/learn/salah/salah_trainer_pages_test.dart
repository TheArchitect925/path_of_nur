import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_audio_service.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_sync_controller.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_trainer_provider.dart';
import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';
import 'package:path_of_nur/features/learn/salah/presentation/salah_guided_prayer_page.dart';
import 'package:path_of_nur/features/learn/salah/presentation/salah_prayer_detail_page.dart';
import 'package:path_of_nur/features/learn/salah/presentation/salah_surah_detail_page.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

class _SilentAudio implements SalahAudioService {
  final List<String> played = <String>[];

  @override
  Future<PreparedRecitation> prepare(
    RecitationSegment segment, {
    bool slow = false,
  }) async {
    return PreparedRecitation(
      segment: segment,
      source: SalahAudioSourceKind.asset,
      durationMs: 1200,
    );
  }

  @override
  Future<void> play(PreparedRecitation prepared) async {
    played.add(prepared.segment.id);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Override journeySnapshotOverride() {
    return journeyActivitySnapshotProvider.overrideWith(
      (ref) => JourneyActivitySnapshot(
        now: DateTime(2026, 9, 4, 12),
        prayerCompletedToday: 0,
        prayerMissedToday: 0,
        fajrCompletedToday: false,
        prayerProgress: 0,
        dhikrSessionsToday: 0,
        dhikrCountToday: 0,
        dhikrProgress: 0,
        fastingStatus: FastingStatus.notFasting,
        quranEngagementsToday: 0,
        quranProgress: 0,
        reflectionEntriesToday: 0,
        reflectionProgress: 0,
        learningStageCompletionsToday: 0,
        streakExemptionActive: false,
      ),
    );
  }

  Future<ProviderContainer> makeContainer(_SilentAudio audio) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        journeySnapshotOverride(),
        salahAudioServiceProvider.overrideWithValue(audio),
        salahTrainerSleepProvider.overrideWithValue((_) async {}),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Widget app(ProviderContainer container, String initialLocation) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/salah/guided/:prayerId',
          name: 'learnSalahGuidedPrayer',
          builder: (context, state) => SalahGuidedPrayerPage(
            prayerId: SalahPrayerId.values.byName(
              state.pathParameters['prayerId']!,
            ),
          ),
        ),
        GoRoute(
          path: '/learn/salah/prayer/:prayerId',
          name: 'learnSalahPrayerDetail',
          builder: (context, state) => SalahPrayerDetailPage(
            prayerId: SalahPrayerId.values.byName(
              state.pathParameters['prayerId']!,
            ),
            focusSteps: state.uri.queryParameters['focus'] == 'steps',
          ),
        ),
        GoRoute(
          path: '/learn/salah/surah/:surahId',
          name: 'learnSalahSurahDetail',
          builder: (context, state) =>
              SalahSurahDetailPage(surahId: state.pathParameters['surahId']!),
        ),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('guided prayer plays through and offers the completion card', (
    tester,
  ) async {
    final audio = _SilentAudio();
    final container = await makeContainer(audio);
    await tester.pumpWidget(app(container, '/learn/salah/guided/fajr'));
    await settle(tester);

    expect(find.text('Niyyah reminder'), findsOneWidget);
    expect(find.text('Rakah 1'), findsWidgets);
    expect(find.text('Prayer complete'), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Play'));
    await settle(tester);
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);

    expect(find.text('Prayer complete'), findsOneWidget);
    expect(audio.played, contains('al_fatihah_1'));
    expect(audio.played.last, 'taslim_left');
    expect(
      container.read(salahTrainerProgressProvider).completedPrayerIds,
      contains('fajr'),
    );
  });

  testWidgets('stepping forward remembers the step for the resume card', (
    tester,
  ) async {
    final container = await makeContainer(_SilentAudio());
    await tester.pumpWidget(app(container, '/learn/salah/guided/fajr'));
    await settle(tester);

    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await settle(tester);
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await settle(tester);

    final session = container
        .read(salahTrainerProgressProvider)
        .sessionFor(SalahPrayerId.fajr);
    expect(session?.stepIndex, 2);

    // Reopen: the resume card names the saved step. Leaving the page in the
    // app lets the autoDispose controller go; the test harness keeps it
    // cached, so drop it explicitly to model a fresh visit.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    container.invalidate(guidedPrayerSyncControllerProvider);
    await tester.pumpWidget(app(container, '/learn/salah/guided/fajr'));
    await settle(tester);
    expect(find.text('Pick up where you left off'), findsOneWidget);
    expect(find.textContaining('step 3 of'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Resume'));
    await settle(tester);
    expect(find.text('Pick up where you left off'), findsNothing);
    expect(find.text('Opening supplication'), findsOneWidget);
  });

  testWidgets('prayer structure lists rakahs as expandable tiles', (
    tester,
  ) async {
    final container = await makeContainer(_SilentAudio());
    await tester.pumpWidget(app(container, '/learn/salah/prayer/dhuhr'));
    await settle(tester);

    await tester.scrollUntilVisible(
      find.text('Rakah by rakah'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(find.text('Rakah 1'), findsOneWidget);
    expect(find.text('Takbir al-Ihram'), findsOneWidget);
    expect(find.text('Takbir (rising)'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Rakah 3'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    await tester.tap(find.text('Rakah 3'));
    await settle(tester);
    expect(find.text('Takbir (rising)'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Rakah 4'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Rakah 4'), findsOneWidget);
  });

  testWidgets('surah practice page localizes its modes and plays an ayah', (
    tester,
  ) async {
    final audio = _SilentAudio();
    final container = await makeContainer(audio);
    await tester.pumpWidget(app(container, '/learn/salah/surah/al_ikhlas'));
    await settle(tester);

    expect(find.text('Learn Al-Ikhlas'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('From memory'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('From memory'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Play this ayah'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Play this ayah'));
    await settle(tester);
    expect(audio.played, ['al_ikhlas_1']);
    await tester.scrollUntilVisible(
      find.text('Now on ayah 1'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Now on ayah 1'), findsOneWidget);
  });
}
