import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/reminders/local_notification_service.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  final english = lookupAppLocalizations(const Locale('en'));
  final german = lookupAppLocalizations(const Locale('de'));

  test('the moonrise notification names the phase and how much is lit', () {
    // Toronto, the evening after the September 2026 full moon.
    final rise = DateTime.utc(2026, 9, 27, 23, 16);
    expect(
      moonReminderBody(english, when: rise, rising: true),
      'Full Moon · 98% lit. The moon is rising now.',
    );
    expect(
      moonReminderBody(german, when: rise, rising: true),
      'Vollmond · 98 % beleuchtet. Der Mond geht jetzt auf.',
    );
  });

  test('the moonset notification reads the phase at the set', () {
    final set = DateTime.utc(2026, 10, 3, 13, 25);
    expect(
      moonReminderBody(english, when: set, rising: false),
      'Last Quarter · 50% lit. The moon is setting now.',
    );
    expect(
      moonReminderBody(
        english,
        when: DateTime.utc(2026, 10, 14, 12),
        rising: false,
      ),
      'Waxing Crescent · 14% lit. The moon is setting now.',
    );
  });
}
