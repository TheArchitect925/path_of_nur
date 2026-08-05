import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/accounts_sync/application/accounts_sync_services.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('backup validation builds preview for valid payload', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final repository = container.read(backupRepositoryProvider);

    final payload = jsonEncode(<String, dynamic>{
      'schemaVersion': 2,
      'metadata': <String, dynamic>{
        'schemaVersion': 2,
        'appVersion': '1.2.3',
        'buildNumber': '23',
        'sourceType': 'manualExport',
        'exportedAtIso': '2026-03-24T12:00:00Z',
        'currentProfileOnly': true,
        'encrypted': false,
        'provider': 'google',
        'accountLabel': 'Test User',
        'deviceLabel': 'Test Device',
      },
      'accounts': <Map<String, dynamic>>[
        <String, dynamic>{
          'accountId': 'acct_1',
          'provider': 'google',
          'identifier': 'a@example.com',
          'displayName': 'Test User',
          'createdAtIso': '2026-03-24T12:00:00Z',
          'lastLoginAtIso': '2026-03-24T12:00:00Z',
          'connectedDeviceCount': 1,
          'syncMode': 'manualBackupOnly',
        },
      ],
      'profiles': <Map<String, dynamic>>[
        <String, dynamic>{'profileId': 'profile_1', 'displayName': 'Amina'},
      ],
      'profileSnapshots': <String, dynamic>{'profile_1': <String, dynamic>{}},
      'structuredDataByProfile': <String, dynamic>{
        'profile_1': <String, dynamic>{},
      },
    });

    final result = await repository.validateImportPayload(
      payload: payload,
      encrypted: false,
    );

    expect(result.isValid, isTrue);
    expect(result.preview?.profileCount, 1);
    expect(result.preview?.metadata.appVersion, '1.2.3');
    expect(result.preview?.profileNames, contains('Amina'));
  });

  test('backup validation rejects malformed payload', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final repository = container.read(backupRepositoryProvider);

    final result = await repository.validateImportPayload(
      payload: '{bad',
      encrypted: false,
    );

    expect(result.isValid, isFalse);
    expect(result.errorCode, 'invalid_payload');
  });
}
