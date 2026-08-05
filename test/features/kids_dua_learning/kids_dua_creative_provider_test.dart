import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_active_learner_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_creative_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_progress_provider.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('drawing save and delete updates local creative state', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'kids_dua_drawings_test',
    );
    final container = await makeTestContainer(
      overrides: [
        kidsDuaDrawingDirectoryProvider.overrideWith((ref) async => tempDir),
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 9)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(() async {
      container.dispose();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    final notifier = container.read(kidsDuaCreativeProvider.notifier);
    final drawing = await notifier.saveDrawing(
      duaId: 'before-eating',
      pngBytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
    );

    expect(container.read(kidsDuaDrawingsProvider), hasLength(1));
    expect(File(drawing.imagePath).existsSync(), isTrue);

    await notifier.deleteDrawing(drawing.id);

    expect(container.read(kidsDuaDrawingsProvider), isEmpty);
    expect(File(drawing.imagePath).existsSync(), isFalse);
  });

  test('parent dashboard derives progress, activity, and drawings', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'kids_dua_parent_test',
    );
    final container = await makeTestContainer(
      overrides: [
        kidsDuaDrawingDirectoryProvider.overrideWith((ref) async => tempDir),
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 9)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(() async {
      container.dispose();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    container
        .read(kidsDuaLearningProvider.notifier)
        .completeLesson('before-eating');
    await container
        .read(kidsDuaCreativeProvider.notifier)
        .saveDrawing(
          duaId: 'before-eating',
          pngBytes: Uint8List.fromList(<int>[1, 2, 3]),
        );

    final dashboard = container.read(kidsDuaParentDashboardProvider);

    expect(dashboard.totalDuasLearned, 1);
    expect(dashboard.streakDays, 1);
    expect(dashboard.drawings, hasLength(1));
    expect(dashboard.recentActivity, isNotEmpty);
  });

  test('creative drawings stay isolated per learner', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'kids_dua_creative_scope_test',
    );
    final container = await makeTestContainer(
      overrides: [
        kidsDuaDrawingDirectoryProvider.overrideWith((ref) async => tempDir),
        kidsDuaNowProvider.overrideWithValue(() => DateTime(2026, 3, 18, 10)),
        _journeySnapshotOverride(),
      ],
    );
    addTearDown(() async {
      container.dispose();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    final notifier = container.read(kidsDuaCreativeProvider.notifier);

    notifier.updateActiveLearner('child_a');
    await notifier.saveDrawing(
      duaId: 'before-eating',
      pngBytes: Uint8List.fromList(<int>[1, 2, 3]),
    );
    expect(container.read(kidsDuaDrawingsProvider), hasLength(1));

    notifier.updateActiveLearner('child_b');
    expect(container.read(kidsDuaDrawingsProvider), isEmpty);

    await notifier.saveDrawing(
      duaId: 'before-sleep',
      pngBytes: Uint8List.fromList(<int>[4, 5, 6]),
    );
    expect(container.read(kidsDuaDrawingsProvider), hasLength(1));

    notifier.updateActiveLearner('child_a');
    expect(
      container.read(kidsDuaDrawingsProvider).map((item) => item.duaId),
      contains('before-eating'),
    );
    expect(
      container.read(kidsDuaDrawingsProvider).map((item) => item.duaId),
      isNot(contains('before-sleep')),
    );
  });

  test(
    'legacy fallback-scoped creative state migrates to canonical fallback learner',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'kids_dua_creative_legacy_test',
      );
      final legacyLearnerId = legacyKidsDuaFallbackLearnerIdForProfile(
        'device_local',
      );
      final legacyState = const KidsDuaCreativeState(
        parentViewEnabled: true,
        drawings: <KidsDuaDrawing>[
          KidsDuaDrawing(
            id: 'drawing_1',
            duaId: 'before-sleep',
            imagePath: '/tmp/before_sleep.png',
            createdAt: '2026-03-18T10:00:00.000',
            lastEditedAt: '2026-03-18T10:00:00.000',
          ),
        ],
      );
      final container = await makeTestContainer(
        seed: <String, Object>{
          kidsDuaCreativeStorageKeyForLearner(legacyLearnerId): jsonEncode(
            legacyState.toJson(),
          ),
        },
        overrides: [
          kidsDuaDrawingDirectoryProvider.overrideWith((ref) async => tempDir),
        ],
      );
      addTearDown(() async {
        container.dispose();
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final state = container.read(kidsDuaCreativeProvider);
      final prefs = container.read(sharedPreferencesProvider);
      final canonicalKey = kidsDuaCreativeStorageKeyForLearner(
        kidsDuaFallbackLearnerIdForProfile('device_local'),
      );

      expect(state.parentViewEnabled, isTrue);
      expect(state.drawings, hasLength(1));
      expect(prefs.getString(canonicalKey), isNotNull);
      expect(
        prefs.getString(kidsDuaCreativeStorageKeyForLearner(legacyLearnerId)),
        isNull,
      );
    },
  );
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
