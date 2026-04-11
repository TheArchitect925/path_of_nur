import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileSettingsNotifier', () {
    test('defaults colored glass to enabled', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = ProfileSettingsNotifier(store);

      expect(notifier.state.disableColoredGlass, isFalse);
    });

    test('persists disabled colored glass preference', () async {
      SharedPreferences.setMockInitialValues(const {
        'settings.profile': '{"disableColoredGlass":true}',
      });
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = ProfileSettingsNotifier(store);

      expect(notifier.state.disableColoredGlass, isTrue);

      notifier.setDisableColoredGlass(false);

      final reloaded = ProfileSettingsNotifier(store);
      expect(reloaded.state.disableColoredGlass, isFalse);
    });

    test('persists on this day reminder preference', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final store = LocalStore(prefs);
      final notifier = ProfileSettingsNotifier(store);

      expect(notifier.state.onThisDayReminders, isFalse);

      notifier.setOnThisDayReminders(true);

      final reloaded = ProfileSettingsNotifier(store);
      expect(reloaded.state.onThisDayReminders, isTrue);
    });
  });
}
