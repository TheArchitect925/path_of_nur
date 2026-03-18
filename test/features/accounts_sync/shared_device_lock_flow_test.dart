import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'shared-device lock clears unlocked session and switching restores it',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        accountsSyncControllerProvider.notifier,
      );

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'shared-device',
        displayName: 'Shared Device',
      );
      await controller.createProfile(
        displayName: 'Amina',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'A',
      );

      final profileId = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      expect(
        container.read(accountsSyncControllerProvider).sessionUnlockedProfileId,
        profileId,
      );

      await controller.updateSharedDeviceMode(true);
      await controller.lockSharedDevice();

      expect(
        container.read(accountsSyncControllerProvider).sessionUnlockedProfileId,
        isNull,
      );

      final restored = await controller.switchProfile(
        profileId,
        bypassPin: true,
      );
      expect(restored, isTrue);
      expect(
        container.read(accountsSyncControllerProvider).sessionUnlockedProfileId,
        profileId,
      );
    },
  );

  test(
    'protected shared-device profile rejects wrong pin and accepts correct pin',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        accountsSyncControllerProvider.notifier,
      );

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'shared-device',
        displayName: 'Shared Device',
      );
      await controller.createProfile(
        displayName: 'Amina',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'A',
      );

      final profileId = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      await controller.setProfilePin(profileId, '1234');
      await controller.lockSharedDevice();

      final rejected = await controller.switchProfile(profileId, pin: '9999');
      expect(rejected, isFalse);
      expect(
        container.read(accountsSyncControllerProvider).sessionUnlockedProfileId,
        isNull,
      );

      final accepted = await controller.switchProfile(profileId, pin: '1234');
      expect(accepted, isTrue);
      expect(
        container.read(accountsSyncControllerProvider).sessionUnlockedProfileId,
        profileId,
      );
    },
  );
}
