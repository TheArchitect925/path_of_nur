import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_audio_service.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_guided_settings_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_sync_controller.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_trainer_provider.dart';
import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';

import '../../../test_helpers/app_test_harness.dart';

/// Answers every segment instantly, reporting a fixed length for bundled
/// clips and the spoken estimate for everything else.
class _FakeSalahAudioService implements SalahAudioService {
  _FakeSalahAudioService({this.assetDurationMs = 2500, this.hasAssets = true});

  final int assetDurationMs;
  final bool hasAssets;
  final List<String> played = <String>[];
  final List<SalahAudioSourceKind> sources = <SalahAudioSourceKind>[];
  Completer<void>? gate;
  int stops = 0;

  @override
  Future<PreparedRecitation> prepare(
    RecitationSegment segment, {
    bool slow = false,
  }) async {
    final bundled = hasAssets && segment.audioAssetPath != null;
    return PreparedRecitation(
      segment: segment,
      source: bundled ? SalahAudioSourceKind.asset : SalahAudioSourceKind.tts,
      durationMs: bundled
          ? assetDurationMs
          : RecitationTimingModel.estimateSpokenMs(segment.arabicText),
    );
  }

  @override
  Future<void> play(PreparedRecitation prepared) async {
    played.add(prepared.segment.id);
    sources.add(prepared.source);
    final pending = gate;
    if (pending != null) {
      await pending.future;
    }
  }

  @override
  Future<void> stop() async {
    stops += 1;
  }

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

  const fajr = (prayerId: SalahPrayerId.fajr, surahId: 'al_ikhlas');

  Future<
    ({
      ProviderContainer container,
      _FakeSalahAudioService audio,
      List<Duration> sleeps,
    })
  >
  harness({_FakeSalahAudioService? audio}) async {
    final fake = audio ?? _FakeSalahAudioService();
    final sleeps = <Duration>[];
    final container = await makeTestContainer(
      overrides: <Override>[
        journeySnapshotOverride(),
        salahAudioServiceProvider.overrideWithValue(fake),
        salahTrainerSleepProvider.overrideWithValue((duration) async {
          sleeps.add(duration);
        }),
      ],
    );
    addTearDown(container.dispose);
    return (container: container, audio: fake, sleeps: sleeps);
  }

  test(
    'playAll walks every step with takbirs, tasbih repeats and real clips',
    () async {
      final h = await harness();
      final sub = h.container.listen(
        guidedPrayerSyncControllerProvider(fajr),
        (_, _) {},
      );
      addTearDown(sub.close);
      final controller = h.container.read(
        guidedPrayerSyncControllerProvider(fajr).notifier,
      );

      await controller.playAll();

      final state = h.container.read(guidedPrayerSyncControllerProvider(fajr));
      expect(state.isPlaying, isFalse);
      expect(state.phase, GuidedStepPhase.completed);

      final played = h.audio.played;
      expect(played, isNot(contains('niyyah')), reason: 'reminders are silent');
      expect(
        played.where((id) => id == 'ruku').length,
        6,
        reason: 'three tasbih in each of two rakahs',
      );
      expect(played.where((id) => id == 'first_sujud').length, 6);
      expect(played.indexOf('takbir'), lessThan(played.indexOf('ruku')));
      expect(played, contains('al_fatihah_1'));
      expect(played, contains('al_fatihah_7'));
      expect(played, contains('al_ikhlas_4'));
      expect(played.last, 'taslim_left');

      final progress = h.container.read(salahTrainerProgressProvider);
      expect(progress.completedPrayerIds, contains('fajr'));
      expect(progress.sessionFor(SalahPrayerId.fajr), isNull);
    },
  );

  test('the word highlight is scaled to the clip the player reports', () async {
    final h = await harness(
      audio: _FakeSalahAudioService(assetDurationMs: 4321),
    );
    final sub = h.container.listen(
      guidedPrayerSyncControllerProvider(fajr),
      (_, _) {},
    );
    addTearDown(sub.close);
    final controller = h.container.read(
      guidedPrayerSyncControllerProvider(fajr).notifier,
    );
    final steps = h.container.read(salahGuidedStepsProvider(fajr));
    final fatihahIndex = steps.indexWhere(
      (item) => item.step.kind == SalahRecitationKind.fatihah,
    );

    controller.setCurrentStep(fatihahIndex);
    await controller.repeatCurrent();

    final state = h.container.read(guidedPrayerSyncControllerProvider(fajr));
    expect(state.activeTiming, isNotNull);
    expect(state.activeTiming!.totalDurationMs, 4321);
    expect(state.activeTiming!.wordTimings.last.endMs, 4321);
    expect(state.sourceKind, SalahAudioSourceKind.asset);
    expect(state.currentStepIndex, fatihahIndex, reason: 'repeat stays put');
    expect(state.isPlaying, isFalse);
  });

  test('without bundled clips the flow falls back to speech timing', () async {
    final h = await harness(audio: _FakeSalahAudioService(hasAssets: false));
    final sub = h.container.listen(
      guidedPrayerSyncControllerProvider(fajr),
      (_, _) {},
    );
    addTearDown(sub.close);
    final controller = h.container.read(
      guidedPrayerSyncControllerProvider(fajr).notifier,
    );
    final steps = h.container.read(salahGuidedStepsProvider(fajr));
    final rukuIndex = steps.indexWhere((item) => item.step.id == 'ruku');

    controller.setCurrentStep(rukuIndex);
    await controller.repeatCurrent();

    final state = h.container.read(guidedPrayerSyncControllerProvider(fajr));
    expect(state.sourceKind, SalahAudioSourceKind.tts);
    expect(
      state.activeTiming!.totalDurationMs,
      RecitationTimingModel.estimateSpokenMs(steps[rukuIndex].step.arabicText),
    );
  });

  test('the tasbih repeat setting changes how often ruku is recited', () async {
    final h = await harness();
    h.container.read(salahGuidedSettingsProvider.notifier).setTasbihRepeats(1);
    final sub = h.container.listen(
      guidedPrayerSyncControllerProvider(fajr),
      (_, _) {},
    );
    addTearDown(sub.close);
    final controller = h.container.read(
      guidedPrayerSyncControllerProvider(fajr).notifier,
    );

    await controller.playAll();

    expect(h.audio.played.where((id) => id == 'ruku').length, 2);
  });

  test('an unhurried pace rests longer in every posture', () async {
    Future<int> totalHoldMs(SalahTrainerPace pace) async {
      final h = await harness();
      h.container.read(salahGuidedSettingsProvider.notifier).setPace(pace);
      final sub = h.container.listen(
        guidedPrayerSyncControllerProvider(fajr),
        (_, _) {},
      );
      addTearDown(sub.close);
      await h.container
          .read(guidedPrayerSyncControllerProvider(fajr).notifier)
          .playAll();
      return h.sleeps.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
    }

    final steady = await totalHoldMs(SalahTrainerPace.steady);
    final unhurried = await totalHoldMs(SalahTrainerPace.unhurried);
    final brisk = await totalHoldMs(SalahTrainerPace.brisk);

    expect(unhurried, greaterThan(steady));
    expect(brisk, lessThan(steady));
  });

  test('moving between steps remembers where to resume', () async {
    final h = await harness();
    final sub = h.container.listen(
      guidedPrayerSyncControllerProvider(fajr),
      (_, _) {},
    );
    addTearDown(sub.close);
    final controller = h.container.read(
      guidedPrayerSyncControllerProvider(fajr).notifier,
    );

    controller.setCurrentStep(5);

    final session = h.container
        .read(salahTrainerProgressProvider)
        .sessionFor(SalahPrayerId.fajr);
    expect(session, isNotNull);
    expect(session!.stepIndex, 5);
    expect(session.surahId, 'al_ikhlas');
    expect(session.hasProgress, isTrue);

    controller.setCurrentStep(0);
    expect(
      h.container
          .read(salahTrainerProgressProvider)
          .sessionFor(SalahPrayerId.fajr),
      isNull,
      reason: 'the first step is nothing to resume',
    );
  });

  test('pause stops the flow without completing the prayer', () async {
    final audio = _FakeSalahAudioService()..gate = Completer<void>();
    final h = await harness(audio: audio);
    final sub = h.container.listen(
      guidedPrayerSyncControllerProvider(fajr),
      (_, _) {},
    );
    addTearDown(sub.close);
    final controller = h.container.read(
      guidedPrayerSyncControllerProvider(fajr).notifier,
    );

    final run = controller.playAll();
    // Let the flow reach the first audible segment and block on it.
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(
      h.container.read(guidedPrayerSyncControllerProvider(fajr)).isPlaying,
      isTrue,
    );

    await controller.pause();
    audio.gate!.complete();
    await run;

    final state = h.container.read(guidedPrayerSyncControllerProvider(fajr));
    expect(state.isPlaying, isFalse);
    expect(state.phase, GuidedStepPhase.idle);
    expect(audio.stops, greaterThan(0));
    expect(
      h.container.read(salahTrainerProgressProvider).completedPrayerIds,
      isNot(contains('fajr')),
    );
  });

  test(
    'surah practice reports the clip length for the ayah it plays',
    () async {
      final h = await harness(
        audio: _FakeSalahAudioService(assetDurationMs: 1999),
      );
      final sub = h.container.listen(
        surahPlaybackControllerProvider('al_ikhlas'),
        (_, _) {},
      );
      addTearDown(sub.close);
      final controller = h.container.read(
        surahPlaybackControllerProvider('al_ikhlas').notifier,
      );

      controller.setCurrentAyahIndex(2);
      await controller.playCurrentAyah();

      final state = h.container.read(
        surahPlaybackControllerProvider('al_ikhlas'),
      );
      expect(h.audio.played, ['al_ikhlas_3']);
      expect(state.activeTiming!.totalDurationMs, 1999);
      expect(state.isPlaying, isFalse);
    },
  );
}
