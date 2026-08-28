import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_theme.dart';
import 'package:path_of_nur/core/theme/occasion_theme.dart';

void main() {
  group('resolveOccasionThemeMode', () {
    final friday = DateTime(2026, 8, 28); // a Friday
    final saturday = DateTime(2026, 8, 29);

    test('wears Jummah on Fridays when dress-up is enabled', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.midnight,
          dressUpFridays: true,
          now: friday,
        ),
        AppThemeMode.jummah,
      );
    });

    test('keeps the base theme on other days', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.midnight,
          dressUpFridays: true,
          now: saturday,
        ),
        AppThemeMode.midnight,
      );
    });

    test('never overrides when dress-up is off', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.noorGlass,
          dressUpFridays: false,
          now: friday,
        ),
        AppThemeMode.noorGlass,
      );
    });

    test('manual Jummah selection passes through untouched', () {
      expect(
        resolveOccasionThemeMode(
          baseMode: AppThemeMode.jummah,
          dressUpFridays: false,
          now: saturday,
        ),
        AppThemeMode.jummah,
      );
    });
  });
}
