import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_controller.dart';
import 'package:path_of_nur/features/accounts_sync/domain/accounts_sync_models.dart';
import 'package:path_of_nur/features/accounts_sync/application/sync_foundation.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/features/worship/data/dhikr_repository.dart';
import 'package:path_of_nur/features/worship/data/prayer_log_repository.dart';
import 'package:path_of_nur/features/worship/domain/daily_prayer_record.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/features/worship/domain/prayer_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'profile switching restores isolated local snapshots without leakage',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        accountsSyncControllerProvider.notifier,
      );
      final store = container.read(localStoreProvider);

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'local-device',
        displayName: 'Owner',
      );
      await controller.createProfile(
        displayName: 'Profile A',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'A',
      );
      final profileA = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      await store.setJsonMap('settings.profile', <String, dynamic>{
        'theme': 'amber',
      });
      await store.setJsonMap(
        'worship.prayer.${LocalStore.todayKey()}',
        <String, dynamic>{
          'fajr': <String, dynamic>{'status': 'completed'},
        },
      );

      await controller.createProfile(
        displayName: 'Profile B',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'B',
      );
      final profileB = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      await store.setJsonMap('settings.profile', <String, dynamic>{
        'theme': 'teal',
      });
      await store.setJsonMap(
        'worship.prayer.${LocalStore.todayKey()}',
        <String, dynamic>{
          'fajr': <String, dynamic>{'status': 'pending'},
        },
      );

      await controller.switchProfile(profileA);
      expect(store.getJsonMap('settings.profile')?['theme'], 'amber');
      expect(
        store.getJsonMap(
          'worship.prayer.${LocalStore.todayKey()}',
        )?['fajr']?['status'],
        'completed',
      );

      await controller.switchProfile(profileB);
      expect(store.getJsonMap('settings.profile')?['theme'], 'teal');
      expect(
        store.getJsonMap(
          'worship.prayer.${LocalStore.todayKey()}',
        )?['fajr']?['status'],
        'pending',
      );
    },
  );

  test(
    'backup payload contains expected top-level sections and imports safely',
    () async {
      final source = await makeTestContainer();
      addTearDown(source.dispose);
      final controller = source.read(accountsSyncControllerProvider.notifier);
      final store = source.read(localStoreProvider);

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'local-source',
        displayName: 'Source',
      );
      await controller.createProfile(
        displayName: 'Traveler',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'T',
      );
      await store.setJsonMap('settings.profile', <String, dynamic>{
        'language': 'en',
      });

      final payload = await controller.buildBackupPayload(
        currentProfileOnly: true,
        encrypt: false,
        appVersion: '1.2.3',
        buildNumber: '23',
      );
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      expect(decoded['schemaVersion'], 2);
      expect(
        (decoded['metadata'] as Map<String, dynamic>)['appVersion'],
        '1.2.3',
      );
      expect(
        decoded.keys,
        containsAll(<String>[
          'exportedAt',
          'metadata',
          'accounts',
          'profiles',
          'profileSnapshots',
          'syncStatus',
        ]),
      );
      expect((decoded['profiles'] as List).length, 1);

      final target = await makeTestContainer();
      addTearDown(target.dispose);
      await target
          .read(accountsSyncControllerProvider.notifier)
          .importBackup(
            payload: payload,
            encrypted: false,
            createNewProfiles: true,
            replaceExisting: true,
          );
      final imported = target.read(accountsSyncControllerProvider);
      expect(imported.profiles, hasLength(1));
      expect(imported.profiles.first.displayName, 'Traveler');
      expect(
        imported.profileSnapshots[imported.profiles.first.profileId],
        isNotEmpty,
      );
    },
  );

  test('invalid backup payload fails safely without mutating state', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'local-safe',
      displayName: 'Safe',
    );
    final before = container.read(accountsSyncControllerProvider);

    await expectLater(
      () => controller.importBackup(
        payload: '{not valid json',
        encrypted: false,
        createNewProfiles: false,
        replaceExisting: false,
      ),
      throwsFormatException,
    );
    final after = container.read(accountsSyncControllerProvider);
    expect(after.accounts.length, before.accounts.length);
    expect(after.profiles.length, before.profiles.length);
  });

  test(
    'disconnecting authenticated account keeps local progress intact',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        accountsSyncControllerProvider.notifier,
      );
      final store = container.read(localStoreProvider);

      await controller.connectAuthenticatedAccount(
        const AccountIdentity(
          provider: AccountsAuthProvider.google,
          identifier: 'user-1',
          displayName: 'Signed In User',
          email: 'signed-in@example.com',
        ),
      );
      await controller.createProfile(
        displayName: 'Owner',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.manualBackupOnly,
        avatar: 'O',
      );
      await store.setJsonMap('settings.profile', <String, dynamic>{
        'theme': 'emerald',
      });

      expect(
        container.read(authStateProvider).status,
        AuthStatus.authenticated,
      );

      await controller.disconnectAuthenticatedAccount();

      expect(
        container.read(authStateProvider).status,
        AuthStatus.unauthenticated,
      );
      expect(
        container.read(accountsSyncControllerProvider).profiles,
        isNotEmpty,
      );
      expect(store.getJsonMap('settings.profile')?['theme'], 'emerald');
    },
  );

  test('future schema import is rejected safely', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    final payload = jsonEncode(<String, dynamic>{
      'schemaVersion': 99,
      'accounts': const <Map<String, dynamic>>[],
      'profiles': const <Map<String, dynamic>>[],
      'profileSnapshots': const <String, dynamic>{},
      'structuredDataByProfile': const <String, dynamic>{},
    });

    await expectLater(
      () => controller.importBackup(
        payload: payload,
        encrypted: false,
        createNewProfiles: true,
        replaceExisting: false,
      ),
      throwsFormatException,
    );
  });

  test('sync report details are preserved for diagnostics surfaces', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(accountsSyncControllerProvider.notifier);

    await controller.addAccount(
      provider: AccountProviderType.localOnly,
      identifier: 'owner',
      displayName: 'Owner',
      syncMode: ProfileSyncMode.iCloud,
    );
    await controller.createProfile(
      displayName: 'Synced',
      kind: ProfileKind.adult,
      experienceMode: ProfileExperienceMode.full,
      syncMode: ProfileSyncMode.iCloud,
      avatar: 'S',
    );

    await controller.applySyncReport(
      const SyncRunReport(
        succeeded: false,
        online: false,
        pendingCount: 3,
        uploadedCount: 0,
        appliedInboundCount: 0,
        completedAtIso: '2026-03-14T15:00:00Z',
        recentEvents: <String>['iCloud is unavailable or not signed in'],
        errorMessage: 'iCloud is unavailable or not signed in',
        transportLabel: 'iCloud',
        transportAvailable: false,
        resultSummary: 'iCloud is unavailable or not signed in',
        statusCode: 'icloud_unavailable',
      ),
      reloadScope: false,
    );

    final sync = container.read(accountsSyncControllerProvider).syncStatus;
    expect(sync.transportLabel, syncTransportKeyICloud);
    expect(sync.transportAvailable, isFalse);
    expect(sync.lastResultSummary, 'sync_error_icloud_unavailable');
    expect(sync.lastErrorSummary, 'sync_error_icloud_unavailable');
  });

  test(
    'default sync snapshot uses locale-neutral transport and result codes',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final sync = container.read(accountsSyncControllerProvider).syncStatus;
      expect(sync.transportLabel, syncTransportKeyLocalStorage);
      expect(sync.lastResultSummary, 'sync_result_local_only_mode_active');
    },
  );

  test(
    'structured backup restores prayer, dhikr, and ocean state without cross-profile leakage',
    () async {
      final source = await makeTestContainer();
      addTearDown(source.dispose);
      final controller = source.read(accountsSyncControllerProvider.notifier);

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'structured-source',
        displayName: 'Source',
      );
      await controller.createProfile(
        displayName: 'Profile A',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.pathOfNurCloud,
        avatar: 'A',
      );
      final profileA = source
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      source
          .read(prayerLogRepositoryProvider)
          .saveDailyRecords('2026-03-14', <DailyPrayerRecord>[
            for (final prayer in PrayerName.values)
              DailyPrayerRecord(
                prayer: prayer,
                status: prayer == PrayerName.fajr
                    ? PrayerStatus.completed
                    : PrayerStatus.pending,
                completedAtIso: prayer == PrayerName.fajr
                    ? '2026-03-14T05:45:00Z'
                    : null,
              ),
          ]);
      source
          .read(dhikrRepositoryProvider)
          .saveState(
            selectedPresetId: 'subhanallah',
            target: 33,
            currentCount: 11,
          );
      source
          .read(oceanDropServiceProvider)
          .awardDrop(
            actionType: oceanActionPrayerCompleted,
            sourceModule: oceanSourcePrayer,
            referenceId: 'fajr',
            metadata: const <String, dynamic>{
              'timestamp': '2026-03-14T05:45:00Z',
            },
          );

      await controller.createProfile(
        displayName: 'Profile B',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.localOnly,
        avatar: 'B',
      );
      source
          .read(prayerLogRepositoryProvider)
          .saveDailyRecords('2026-03-14', <DailyPrayerRecord>[
            for (final prayer in PrayerName.values)
              DailyPrayerRecord(
                prayer: prayer,
                status: prayer == PrayerName.asr
                    ? PrayerStatus.completed
                    : PrayerStatus.pending,
                completedAtIso: prayer == PrayerName.asr
                    ? '2026-03-14T16:30:00Z'
                    : null,
              ),
          ]);

      await controller.switchProfile(profileA);
      final payload = await controller.buildBackupPayload(
        currentProfileOnly: true,
        encrypt: false,
      );

      final target = await makeTestContainer();
      addTearDown(target.dispose);
      await target
          .read(accountsSyncControllerProvider.notifier)
          .importBackup(
            payload: payload,
            encrypted: false,
            createNewProfiles: true,
            replaceExisting: true,
          );
      final importedState = target.read(accountsSyncControllerProvider);
      final importedProfile = importedState.profiles.single;
      await target
          .read(accountsSyncControllerProvider.notifier)
          .switchProfile(importedProfile.profileId, bypassPin: true);
      final importedPrayer = target
          .read(prayerLogRepositoryProvider)
          .readDayEntries('2026-03-14')[PrayerName.fajr];
      final importedDhikr = target.read(dhikrRepositoryProvider).load();
      final importedOcean = target.read(oceanDropsProvider);
      final pendingOutbox = target
          .read(syncOutboxRepositoryProvider)
          .pendingCount(importedProfile.profileId);

      expect(importedProfile.displayName, 'Profile A');
      expect(importedPrayer?.status, PrayerStatus.completed);
      expect(importedDhikr.currentCount, 11);
      expect(importedOcean.totalLocalDrops, 1);
      expect(pendingOutbox, 0);
    },
  );

  test(
    'profile switching keeps structured prayer, dhikr, and ocean state isolated',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final controller = container.read(
        accountsSyncControllerProvider.notifier,
      );

      await controller.addAccount(
        provider: AccountProviderType.localOnly,
        identifier: 'family-device',
        displayName: 'Family',
      );
      await controller.createProfile(
        displayName: 'Profile A',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.pathOfNurCloud,
        avatar: 'A',
      );
      final profileA = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;
      container
          .read(prayerLogRepositoryProvider)
          .saveDailyRecords('2026-03-14', <DailyPrayerRecord>[
            for (final prayer in PrayerName.values)
              DailyPrayerRecord(
                prayer: prayer,
                status: prayer == PrayerName.maghrib
                    ? PrayerStatus.completed
                    : PrayerStatus.pending,
                completedAtIso: prayer == PrayerName.maghrib
                    ? '2026-03-14T18:45:00Z'
                    : null,
              ),
          ]);
      container
          .read(dhikrRepositoryProvider)
          .saveState(
            selectedPresetId: 'alhamdulillah',
            target: 33,
            currentCount: 21,
          );
      container
          .read(oceanDropServiceProvider)
          .awardDrop(
            actionType: oceanActionPrayerCompleted,
            sourceModule: oceanSourcePrayer,
            referenceId: 'maghrib',
            metadata: const <String, dynamic>{
              'timestamp': '2026-03-14T18:45:00Z',
            },
          );
      await controller.recordPendingChange('Profile A pending');

      await controller.createProfile(
        displayName: 'Profile B',
        kind: ProfileKind.adult,
        experienceMode: ProfileExperienceMode.full,
        syncMode: ProfileSyncMode.pathOfNurCloud,
        avatar: 'B',
      );
      final profileB = container
          .read(accountsSyncControllerProvider)
          .activeProfileId!;

      expect(
        container
            .read(prayerLogRepositoryProvider)
            .readDayEntries('2026-03-14')[PrayerName.maghrib],
        isNull,
      );
      expect(container.read(dhikrRepositoryProvider).load().currentCount, 0);
      expect(container.read(oceanDropsProvider).stats.dropsToday, 0);
      expect(
        container.read(syncOutboxRepositoryProvider).pendingCount(profileB),
        0,
      );

      await controller.switchProfile(profileA);

      expect(
        container
            .read(prayerLogRepositoryProvider)
            .readDayEntries('2026-03-14')[PrayerName.maghrib]
            ?.status,
        PrayerStatus.completed,
      );
      expect(container.read(dhikrRepositoryProvider).load().currentCount, 21);
      expect(container.read(oceanDropsProvider).totalLocalDrops, 1);
      expect(
        container.read(syncOutboxRepositoryProvider).pendingCount(profileA),
        greaterThan(0),
      );
    },
  );
}
