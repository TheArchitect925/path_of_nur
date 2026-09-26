// ignore_for_file: depend_on_referenced_packages
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_motion.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/startup/application/startup_loading_controller.dart';

void main() {
  test('the light-line advances as each checkpoint completes, in order', () {
    fakeAsync((async) {
      final controller = StartupLoadingController();
      final log = <String>[];
      controller.start(
        onboardingCompleted: true,
        accountsSyncState: AccountsSyncState.initial(),
        checkpoints: [
          () async => log.add('restore'),
          () async => log.add('sync'),
          () async => log.add('finalize'),
        ],
      );
      async.flushMicrotasks();
      expect(controller.state.stage, StartupLoadingStage.initializing);
      expect(log, ['restore']);

      async.elapse(AppMotion.checkpointMinimum);
      expect(controller.state.stage, StartupLoadingStage.restoring);
      expect(log, ['restore', 'sync']);

      async.elapse(AppMotion.checkpointMinimum);
      expect(controller.state.stage, StartupLoadingStage.syncing);

      async.elapse(AppMotion.checkpointMinimum);
      expect(controller.state.stage, StartupLoadingStage.finalizing);
      expect(log, ['restore', 'sync', 'finalize']);

      // The card holds until the kindle has had its minimum.
      expect(controller.state.targetLocation, isNull);
      async.elapse(AppMotion.startupMinimum);
      expect(controller.state.stage, StartupLoadingStage.complete);
      expect(controller.state.targetLocation, '/home');
      controller.dispose();
    });
  });

  test('a failing checkpoint never holds the reader', () {
    fakeAsync((async) {
      final controller = StartupLoadingController();
      controller.start(
        onboardingCompleted: true,
        accountsSyncState: AccountsSyncState.initial(),
        checkpoints: [() async => throw StateError('no network')],
      );
      async.elapse(AppMotion.startupMinimum + const Duration(seconds: 1));
      expect(controller.state.stage, StartupLoadingStage.complete);
      controller.dispose();
    });
  });

  test('a slow checkpoint is capped at the ceiling', () {
    fakeAsync((async) {
      final controller = StartupLoadingController();
      controller.start(
        onboardingCompleted: true,
        accountsSyncState: AccountsSyncState.initial(),
        checkpoints: [() => Future<void>.delayed(const Duration(minutes: 1))],
      );
      async.elapse(AppMotion.checkpointCeiling + AppMotion.startupMinimum);
      expect(controller.state.stage, StartupLoadingStage.complete);
      controller.dispose();
    });
  });

  test('light-line progress climbs with the stages', () {
    final values = StartupLoadingStage.values
        .map(startupLightLineProgress)
        .toList();
    for (var i = 1; i < values.length; i++) {
      expect(values[i], greaterThan(values[i - 1]));
    }
    expect(values.last, 1);
  });
}
