import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/growth_seasonal.dart';
import 'package:path_of_nur/shared/utils/hijri_date_utils.dart';
import 'package:path_of_nur/shared/utils/umm_al_qura_table.dart';

/// The phone names the Hijri day by the Umm al-Qura calendar, which it
/// carries as a table copied from the system's own calendar
/// (`bash scripts/verify_hijri_table.sh --write`). The same script writes
/// what that calendar answers, and this holds the phone's reading of the
/// table to it.
void main() {
  final reference =
      jsonDecode(
            File('tools/hijri_umm_al_qura_reference.json').readAsStringSync(),
          )
          as Map<String, dynamic>;

  String named(DateTime date) {
    final hijri = toHijriDate(date);
    return '${hijri.year}-${hijri.month}-${hijri.day}';
  }

  DateTime onDay(int epochDay) => DateTime.fromMillisecondsSinceEpoch(
    epochDay * Duration.millisecondsPerDay,
    isUtc: true,
  );

  test('every day from 2020 to 2040 is named as the calendar names it', () {
    final from = DateTime.parse('${reference['from']}T00:00:00Z');
    final days = (reference['days'] as List).cast<String>();
    expect(days, hasLength(7671));
    final wrong = <String>[];
    for (var index = 0; index < days.length; index++) {
      final date = DateTime.utc(from.year, from.month, from.day + index);
      if (named(date) != days[index]) {
        wrong.add('$date is ${named(date)}, the calendar says ${days[index]}');
      }
    }
    expect(wrong, isEmpty);
  });

  test('every month of the table begins on the day the calendar says', () {
    final firstYear = reference['firstYear'] as int;
    final starts = (reference['monthStarts'] as List).cast<int>();
    expect(firstYear, ummAlQuraFirstYear);
    expect(starts, hasLength(ummAlQuraMonths.length * 12));
    final wrong = <String>[];
    for (var index = 0; index < starts.length; index++) {
      final year = firstYear + index ~/ 12;
      final month = index % 12 + 1;
      final first = named(onDay(starts[index]));
      if (first != '$year-$month-1') {
        wrong.add('$month/$year begins on a day named $first');
      }
      // The day before is the last of the month before, its 29th or 30th.
      if (index > 0) {
        final before = toHijriDate(onDay(starts[index] - 1));
        final monthBefore = month == 1 ? 12 : month - 1;
        if (before.month != monthBefore || before.day < 29) {
          wrong.add(
            'the day before $month/$year is '
            '${before.year}-${before.month}-${before.day}',
          );
        }
      }
    }
    expect(wrong, isEmpty);
  });

  test('days the world knows', () {
    // As announced for Saudi Arabia, which the calendar follows.
    expect(named(DateTime(2024, 7, 7)), '1446-1-1');
    expect(named(DateTime(2025, 3, 1)), '1446-9-1');
    expect(named(DateTime(2025, 3, 30)), '1446-10-1');
    expect(named(DateTime(2025, 6, 6)), '1446-12-10');
    expect(named(DateTime(2026, 2, 18)), '1447-9-1');
    expect(named(DateTime(2026, 9, 27)), '1448-4-16');
  });

  test('the hour of the day does not move the date', () {
    expect(named(DateTime(2026, 2, 18, 0, 0)), '1447-9-1');
    expect(named(DateTime(2026, 2, 18, 23, 59, 59)), '1447-9-1');
    expect(named(DateTime.utc(2026, 2, 18, 23, 59, 59)), '1447-9-1');
  });

  test('outside the table the date is the civil calendar\'s', () {
    final first = onDay(ummAlQuraFirstDay);
    expect(named(first), '$ummAlQuraFirstYear-1-1');
    final before = first.subtract(const Duration(days: 1));
    final civil = civilHijriDate(before);
    expect(named(before), '${civil.year}-${civil.month}-${civil.day}');

    // A day of the first century, which no table reaches.
    final old = DateTime(700, 6, 1);
    final oldCivil = civilHijriDate(old);
    expect(named(old), '${oldCivil.year}-${oldCivil.month}-${oldCivil.day}');

    // And one long after the table ends.
    final late = DateTime(2300);
    final lateCivil = civilHijriDate(late);
    expect(
      named(late),
      '${lateCivil.year}-${lateCivil.month}-${lateCivil.day}',
    );
  });

  test('the civil calendar is the arithmetic it was', () {
    // What the phone said of these days before it carried the table.
    final was = civilHijriDate(DateTime(2026, 9, 27));
    expect('${was.year}-${was.month}-${was.day}', '1448-4-14');
  });

  test('the journey names the day as the rest of the app does', () {
    for (final date in [
      DateTime(2025, 3, 1),
      DateTime(2026, 2, 18),
      DateTime(2026, 9, 27),
      DateTime(2031, 12, 5),
    ]) {
      final journey = growthToHijriDate(date);
      expect('${journey.year}-${journey.month}-${journey.day}', named(date));
    }
  });
}
