import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/domain/bismillah_playback_mode.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reader_atmosphere.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuranReaderSettingsNotifier', () {
    test('defaults product playback setting to disabled during recovery', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(quranAlwaysPrependBismillahProvider), isFalse);
      expect(alwaysPrependBismillahAtSurahStart, isFalse);
      expect(
        container.read(quranDefaultBismillahPlaybackModeProvider),
        defaultBismillahPlaybackMode,
      );
      expect(defaultBismillahPlaybackMode, BismillahPlaybackMode.disabled);
    });

    test('defaults word by word translation to disabled', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.showWordByWord, isFalse);
      expect(notifier.state.wordSyncHighlightBeta, isFalse);
    });

    test('respects previously saved word by word preference', () async {
      SharedPreferences.setMockInitialValues(const {
        'learn.quran.showWordByWord': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.showWordByWord, isTrue);
    });

    test('defaults follow mode to enabled', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.followPlayback, isTrue);
    });

    test('respects previously saved follow mode preference', () async {
      SharedPreferences.setMockInitialValues(const {
        'learn.quran.followPlayback': false,
      });
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.followPlayback, isFalse);
    });

    test('defaults Learn More to enabled', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.showLearnMore, isTrue);
    });

    test('respects previously saved Learn More preference', () async {
      SharedPreferences.setMockInitialValues(const {
        'learn.quran.showLearnMore': false,
      });
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(notifier.state.showLearnMore, isFalse);
    });

    test('defaults reader atmosphere to matching the app theme', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(
        notifier.state.readerAtmosphere,
        QuranReaderAtmosphere.followApp,
      );
    });

    test('persists and reloads the reader atmosphere', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      notifier.setReaderAtmosphere(QuranReaderAtmosphere.midnight);
      expect(
        notifier.state.readerAtmosphere,
        QuranReaderAtmosphere.midnight,
      );

      final reloaded = QuranReaderSettingsNotifier(LocalStore(prefs));
      expect(
        reloaded.state.readerAtmosphere,
        QuranReaderAtmosphere.midnight,
      );
    });

    test('falls back to follow-app for unknown stored atmosphere', () async {
      SharedPreferences.setMockInitialValues(const {
        'learn.quran.readerAtmosphere': 'lava_lamp',
      });
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = QuranReaderSettingsNotifier(store);

      expect(
        notifier.state.readerAtmosphere,
        QuranReaderAtmosphere.followApp,
      );
    });
  });
}
