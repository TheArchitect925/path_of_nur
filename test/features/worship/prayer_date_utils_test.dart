import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/domain/prayer_calendar_mode.dart';
import 'package:path_of_nur/features/worship/presentation/prayer_date_utils.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(BuildContext, AppLocalizations)> pumpHarness(
    WidgetTester tester,
  ) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pump();

    return (capturedContext, AppLocalizations.of(capturedContext));
  }

  testWidgets('formatPrayerDateLabel returns relative labels around today', (
    tester,
  ) async {
    final (context, l10n) = await pumpHarness(tester);
    final anchor = DateTime(2026, 3, 21, 8);

    expect(
      formatPrayerDateLabel(
        context: context,
        l10n: l10n,
        selectedDate: DateTime(2026, 3, 21, 22),
        calendarMode: PrayerCalendarMode.gregorian,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        tomorrowLabel: 'Tomorrow',
        relativeTo: anchor,
      ),
      'Today',
    );
    expect(
      formatPrayerDateLabel(
        context: context,
        l10n: l10n,
        selectedDate: DateTime(2026, 3, 20, 6),
        calendarMode: PrayerCalendarMode.gregorian,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        tomorrowLabel: 'Tomorrow',
        relativeTo: anchor,
      ),
      'Yesterday',
    );
    expect(
      formatPrayerDateLabel(
        context: context,
        l10n: l10n,
        selectedDate: DateTime(2026, 3, 22, 6),
        calendarMode: PrayerCalendarMode.gregorian,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        tomorrowLabel: 'Tomorrow',
        relativeTo: anchor,
      ),
      'Tomorrow',
    );
  });

  testWidgets(
    'formatPrayerDateLabel uses calendar-specific formatting beyond relative days',
    (tester) async {
      final (context, l10n) = await pumpHarness(tester);
      final selected = DateTime(2026, 4, 5);

      final gregorian = formatPrayerDateLabel(
        context: context,
        l10n: l10n,
        selectedDate: selected,
        calendarMode: PrayerCalendarMode.gregorian,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        tomorrowLabel: 'Tomorrow',
        relativeTo: DateTime(2026, 3, 21, 8),
      );
      final islamic = formatPrayerDateLabel(
        context: context,
        l10n: l10n,
        selectedDate: selected,
        calendarMode: PrayerCalendarMode.islamic,
        todayLabel: 'Today',
        yesterdayLabel: 'Yesterday',
        tomorrowLabel: 'Tomorrow',
        relativeTo: DateTime(2026, 3, 21, 8),
      );

      expect(gregorian, contains('2026'));
      expect(islamic, contains('Shawwal'));
      expect(islamic, isNot(equals(gregorian)));
    },
  );
}
