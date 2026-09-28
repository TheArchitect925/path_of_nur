import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_cloud_share.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Qur'an shared with the Apple TV: each field goes to whichever device
/// changed it last. The Apple TV's half is TVQuranCloudShare.swift.
void main() {
  final earlier = DateTime.utc(2026, 9, 27, 10);
  final later = DateTime.utc(2026, 9, 27, 11);

  test('merging keeps the newer change of each field', () {
    final phone = QuranSharedState(
      place: '2:255',
      placeAt: later,
      reciter: 'husary',
      reciterAt: earlier,
    );
    final tv = QuranSharedState(
      place: '18:10',
      placeAt: earlier,
      reciter: 'sudais',
      reciterAt: later,
      bookmarks: const ['36:1'],
      bookmarksAt: earlier,
    );
    final merged = phone.merge(tv);
    expect(merged.place, '2:255');
    expect(merged.reciter, 'sudais');
    expect(merged.bookmarks, ['36:1']);
    expect(tv.merge(phone), merged, reason: 'the same either way round');
  });

  test('the document survives being written and read', () {
    final state = QuranSharedState(
      place: '1:1',
      placeAt: earlier,
      bookmarks: const ['2:255', '114:6'],
      bookmarksAt: later,
      reciter: 'alafasy',
      reciterAt: earlier,
      translation: 'en.sahih',
      translationAt: later,
    );
    expect(QuranSharedState.fromJsonString(state.toJsonString()), state);
    expect(
      QuranSharedState.fromJsonString('not json'),
      const QuranSharedState(),
    );
    expect(QuranSharedState.fromJsonString(null), const QuranSharedState());
  });

  // The Apple TV reads this document with its own Swift
  // (scripts/verify_tv_quran_library.sh), so the two halves agree on its
  // shape. REGENERATE_TV_QURAN=1 rewrites it.
  test('the reference document the Apple TV is held to', () {
    const path = 'tools/tv_quran_shared_reference.json';
    final reference = QuranSharedState(
      place: '36:12',
      placeAt: DateTime.utc(2026, 9, 27, 11, 30, 5, 250),
      bookmarks: const ['67:1', '2:255'],
      bookmarksAt: DateTime.utc(2026, 9, 27, 11),
      reciter: 'husary',
      reciterAt: DateTime.utc(2026, 9, 27, 10),
      translation: 'ur.urdu',
      translationAt: DateTime.utc(2026, 9, 27, 9),
    ).toJsonString();
    if (Platform.environment['REGENERATE_TV_QURAN'] == '1') {
      File(path).writeAsStringSync('$reference\n');
    }
    expect(File(path).readAsStringSync().trim(), reference);
  });

  test('a place is a surah and an ayah of the Qur’an', () {
    expect(parseQuranPlace('2:255'), (surahNumber: 2, ayahNumber: 255));
    expect(parseQuranPlace('115:1'), isNull);
    expect(parseQuranPlace('0:1'), isNull);
    expect(parseQuranPlace('abc'), isNull);
    expect(parseQuranPlace(null), isNull);
  });

  group('with the phone’s Qur’an', () {
    late ProviderContainer container;
    late String? remote;
    late QuranCloudShare share;
    var now = later;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      remote = null;
      now = later;
      final shareProvider = Provider<QuranCloudShare>(
        (ref) => QuranCloudShare(
          ref: ref,
          store: ref.watch(localStoreProvider),
          readRemote: () async => remote,
          writeRemote: (value) async {
            remote = value;
            return true;
          },
          now: () => now,
        ),
      );
      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      share = container.read(shareProvider);
    });

    tearDown(() {
      share.dispose();
      container.dispose();
    });

    test('what the Apple TV changed later is taken up', () async {
      share.seed(
        place: '2:45',
        placeAt: earlier,
        bookmarks: const [],
        bookmarksAt: null,
        reciter: 'alafasy',
        translation: 'en.sahih',
      );
      remote = QuranSharedState(
        place: '36:12',
        placeAt: later,
        bookmarks: const ['67:1', '2:255'],
        bookmarksAt: later,
        reciter: 'husary',
        reciterAt: later,
        translation: 'ur.urdu',
        translationAt: later,
      ).toJsonString();

      await share.sync();

      final progress = container.read(quranReadingProgressProvider);
      expect('${progress.surahNumber}:${progress.ayahNumber}', '36:12');
      expect(
        container
            .read(quranBookmarksProvider)
            .map((b) => '${b.surahNumber}:${b.ayahNumber}'),
        ['67:1', '2:255'],
      );
      expect(container.read(quranAudioSettingsProvider).reciterId, 'husary');
      expect(
        container.read(quranReaderSettingsProvider).translationCode,
        'ur.urdu',
      );
    });

    test(
      'a reciter or a translation the phone does not have is passed over',
      () async {
        share.seed(
          place: '1:1',
          placeAt: earlier,
          bookmarks: const [],
          bookmarksAt: null,
          reciter: 'alafasy',
          translation: 'en.sahih',
        );
        remote = QuranSharedState(
          reciter: 'sudais',
          reciterAt: later,
          translation: 'fr.hamidullah',
          translationAt: later,
        ).toJsonString();

        await share.sync();

        expect(container.read(quranAudioSettingsProvider).reciterId, 'alafasy');
        expect(
          container.read(quranReaderSettingsProvider).translationCode,
          'en.sahih',
        );
      },
    );

    test('what the phone changed is written for the Apple TV', () async {
      share.seed(
        place: '1:1',
        placeAt: earlier,
        bookmarks: const [],
        bookmarksAt: null,
        reciter: 'alafasy',
        translation: 'en.sahih',
      );
      now = later;
      share.recordLocal(place: '19:1', bookmarks: const ['19:1']);
      await share.sync();

      final written = QuranSharedState.fromJsonString(remote);
      expect(written.place, '19:1');
      expect(written.placeAt, later);
      expect(written.bookmarks, ['19:1']);
      expect(written.reciter, 'alafasy');
    });
  });
}
