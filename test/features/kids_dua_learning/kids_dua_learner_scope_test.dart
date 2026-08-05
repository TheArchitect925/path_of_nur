import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_active_learner_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_learning_repository.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_my_day_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_learning_models.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Kids dua learner scoping', () {
    test('lesson progress stays isolated per learner', () async {
      final container = await makeTestContainer(
        overrides: [_journeySnapshotOverride()],
      );
      addTearDown(container.dispose);

      final controller = container.read(kidsDuaLearningProvider.notifier);

      controller.updateActiveLearner('child_a');
      controller.openLesson('before-sleep');
      controller.recordAudioListen('before-sleep');
      controller.recordSegmentRepeat(
        lessonId: 'before-sleep',
        segmentId: 'before-sleep_chunk_1',
      );
      controller.recordReadAlongComplete(
        'before-sleep',
        mode: KidsDuaRepeatMode.readAlong,
      );

      final childAProgress = controller.progressFor('before-sleep');
      expect(childAProgress.openCount, 1);
      expect(childAProgress.listenCount, 1);
      expect(childAProgress.segmentRepeatCount, 1);
      expect(childAProgress.readAlongCompletedAtIso, isNotNull);
      expect(childAProgress.lastLearningMode, KidsDuaRepeatMode.readAlong.name);

      controller.updateActiveLearner('child_b');
      final childBProgress = controller.progressFor('before-sleep');
      expect(childBProgress.openCount, 0);
      expect(childBProgress.listenCount, 0);
      expect(childBProgress.segmentRepeatCount, 0);

      controller.openLesson('after-waking-up');
      controller.updateActiveLearner('child_a');
      expect(controller.progressFor('before-sleep').openCount, 1);
      expect(controller.progressFor('after-waking-up').openCount, 0);
    });

    test('my day state stays isolated per learner', () async {
      final container = await makeTestContainer(
        overrides: [
          kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 21)),
          _journeySnapshotOverride(),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(kidsDuaMyDayProvider.notifier);

      controller.updateActiveLearner('child_a');
      controller.completeDuaForToday('before-sleep');
      expect(
        container.read(kidsDuaMyDayProvider).completedDuaIds,
        contains('before-sleep'),
      );

      controller.updateActiveLearner('child_b');
      expect(
        container.read(kidsDuaMyDayProvider).completedDuaIds,
        isNot(contains('before-sleep')),
      );

      controller.completeDuaForToday('after-waking-up');
      controller.updateActiveLearner('child_a');
      expect(
        container.read(kidsDuaMyDayProvider).completedDuaIds,
        contains('before-sleep'),
      );
      expect(
        container.read(kidsDuaMyDayProvider).completedDuaIds,
        isNot(contains('after-waking-up')),
      );
    });

    test('legacy kids dua progress migrates once into learner scope', () async {
      final legacyState = KidsDuaLearningState.initial().copyWith(
        progressByLessonId: <String, KidsDuaLessonProgress>{
          'before-sleep': const KidsDuaLessonProgress(
            lessonId: 'before-sleep',
            openCount: 2,
            timesPracticed: 1,
          ),
        },
      );
      final container = await makeTestContainer(
        seed: <String, Object>{
          legacyKidsDuaLearningStateKey: jsonEncode(legacyState.toJson()),
        },
      );
      addTearDown(container.dispose);

      container.read(kidsDuaLearningProvider);
      final prefs = container.read(sharedPreferencesProvider);

      expect(prefs.getString(legacyKidsDuaLearningStateKey), isNull);
      final scoped = prefs.getString(
        kidsDuaLearningStorageKeyForLearner(
          kidsDuaFallbackLearnerIdForProfile('device_local'),
        ),
      );
      expect(scoped, isNotNull);
      expect(
        KidsDuaLearningState.fromJson(
          jsonDecode(scoped!) as Map<String, dynamic>,
        ).progressByLessonId['before-sleep']?.openCount,
        2,
      );
    });

    test(
      'legacy fallback-scoped kids dua progress migrates to shared fallback learner id',
      () async {
        final legacyState = KidsDuaLearningState.initial().copyWith(
          progressByLessonId: <String, KidsDuaLessonProgress>{
            'before-eating': const KidsDuaLessonProgress(
              lessonId: 'before-eating',
              openCount: 1,
              timesPracticed: 0,
            ),
          },
        );
        final legacyLearnerId = legacyKidsDuaFallbackLearnerIdForProfile(
          'device_local',
        );
        final container = await makeTestContainer(
          seed: <String, Object>{
            kidsDuaLearningStorageKeyForLearner(legacyLearnerId): jsonEncode(
              legacyState.toJson(),
            ),
          },
        );
        addTearDown(container.dispose);

        container.read(kidsDuaLearningProvider);
        final prefs = container.read(sharedPreferencesProvider);
        final canonicalKey = kidsDuaLearningStorageKeyForLearner(
          kidsDuaFallbackLearnerIdForProfile('device_local'),
        );

        expect(prefs.getString(canonicalKey), isNotNull);
        expect(
          prefs.getString(kidsDuaLearningStorageKeyForLearner(legacyLearnerId)),
          isNull,
        );
        expect(
          KidsDuaLearningState.fromJson(
            jsonDecode(prefs.getString(canonicalKey)!) as Map<String, dynamic>,
          ).progressByLessonId['before-eating']?.openCount,
          1,
        );
      },
    );
  });

  group('Kids dua recommendations', () {
    test('bedtime dua is the default recommended learning item', () async {
      final container = await makeTestContainer(
        overrides: [
          kidsDuaActiveLearnerProvider.overrideWithValue(
            const KidsDuaActiveLearner(
              learnerId: 'child_a',
              displayName: 'Amina',
              ageGroup: LearningAgeGroup.kids,
              preferredLanguageTag: 'en',
              isChildProfile: true,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final item = container.read(kidsDuaRecommendedLearningItemProvider);
      expect(item?.duaId, 'before-sleep');
      expect(item?.bedtimeRelevance, isTrue);
      expect(item?.segments, isNotEmpty);
    });

    test(
      'recent unfinished dua is recommended ahead of bedtime fallback',
      () async {
        final container = await makeTestContainer(
          overrides: [_journeySnapshotOverride()],
        );
        addTearDown(container.dispose);

        container
            .read(kidsDuaLearningProvider.notifier)
            .openLesson('before-eating');

        final item = container.read(kidsDuaRecommendedLearningItemProvider);
        expect(item?.duaId, 'before-eating');
        expect(item?.segments, isNotEmpty);
        expect(item?.audioVariants.first.assetPath, contains('before_eating'));
      },
    );
  });
}

Override _journeySnapshotOverride() {
  final now = DateTime(2026, 3, 18);
  return journeyActivitySnapshotProvider.overrideWith((ref) {
    final journey = ref.watch(journeyProgressProvider);
    final todayKey = LocalStore.todayKey(now);
    final metrics =
        journey.dayMetricsByKey[todayKey] ?? const JourneyDayMetrics();
    return JourneyActivitySnapshot(
      now: now,
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
      learningStageCompletionsToday: metrics.learningStageCompletions,
      streakExemptionActive: false,
    );
  });
}
