import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/domain/bismillah_playback_mode.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuranReaderSettingsNotifier', () {
    test('defaults product playback setting to always prepend Bismillah', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(quranAlwaysPrependBismillahProvider), isTrue);
      expect(alwaysPrependBismillahAtSurahStart, isTrue);
      expect(
        container.read(quranDefaultBismillahPlaybackModeProvider),
        defaultBismillahPlaybackMode,
      );
      expect(defaultBismillahPlaybackMode, BismillahPlaybackMode.alwaysPrepend);
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
  });
}
