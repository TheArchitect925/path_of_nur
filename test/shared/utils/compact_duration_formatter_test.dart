import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/utils/compact_duration_formatter.dart';

void main() {
  group('formatCompactDuration', () {
    test('keeps sub-minute positive durations at one minute', () {
      expect(
        formatCompactDuration(
          const Duration(seconds: 59),
          localeName: 'en',
        ),
        '1m',
      );
    });

    test('formats mixed hour and minute durations compactly', () {
      expect(
        formatCompactDuration(
          const Duration(hours: 1, minutes: 5, seconds: 40),
          localeName: 'en',
        ),
        '1h05m',
      );
    });

    test('formats whole hours without trailing minutes', () {
      expect(
        formatCompactDuration(
          const Duration(hours: 2, seconds: 12),
          localeName: 'en',
        ),
        '2h',
      );
    });
  });
}
