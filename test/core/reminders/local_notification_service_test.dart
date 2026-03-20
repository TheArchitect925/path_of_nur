import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/reminders/local_notification_service.dart';

void main() {
  test('prayer reminder payload encodes and decodes prayer metadata', () {
    final payload = ReminderNotificationPayload.prayer(
      route: '/worship?prayerId=dhuhr',
      prayerId: 'dhuhr',
      logicalDate: '2026-03-18',
      reminderKind: 'at_time',
      watchRoute: 'pathofnurwatch://prayer?prayerId=dhuhr',
    );

    final decoded = ReminderNotificationPayload.decode(payload.encode());

    expect(decoded, isNotNull);
    expect(decoded!.route, '/worship?prayerId=dhuhr');
    expect(decoded.prayerId, 'dhuhr');
    expect(decoded.logicalDate, '2026-03-18');
    expect(decoded.watchRoute, 'pathofnurwatch://prayer?prayerId=dhuhr');
    expect(decoded.isPrayerReminder, isTrue);
  });

  test('route-only payload decodes legacy plain route strings', () {
    final decoded = ReminderNotificationPayload.decode('/journey/growth/today');

    expect(decoded, isNotNull);
    expect(decoded!.route, '/journey/growth/today');
    expect(decoded.prayerId, isNull);
    expect(decoded.logicalDate, isNull);
    expect(decoded.isPrayerReminder, isFalse);
  });
}
