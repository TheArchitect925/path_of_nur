// ignore_for_file: depend_on_referenced_packages

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/startup/application/startup_loading_controller.dart';

void main() {
  test(
    'startup loading controller can restart after onboarding completion',
    () {
      fakeAsync((async) {
        final controller = StartupLoadingController();

        controller.start(
          onboardingCompleted: false,
          accountsSyncState: AccountsSyncState.initial(),
        );

        async.elapse(const Duration(milliseconds: 1300));

        expect(controller.state.stage, StartupLoadingStage.complete);
        expect(controller.state.targetLocation, '/onboarding');

        controller.start(
          onboardingCompleted: true,
          accountsSyncState: AccountsSyncState.initial(),
        );

        expect(controller.state.stage, StartupLoadingStage.initializing);
        expect(controller.state.targetLocation, isNull);

        async.elapse(const Duration(milliseconds: 1300));

        expect(controller.state.stage, StartupLoadingStage.complete);
        expect(controller.state.targetLocation, '/home');

        controller.dispose();
      });
    },
  );
}
