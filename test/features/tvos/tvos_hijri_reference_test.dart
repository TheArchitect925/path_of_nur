import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/utils/hijri_date_utils.dart';

/// The Apple TV names the Hijri date with a Swift port of the phone's
/// `toHijriDate`, and `scripts/verify_tv_prayer_times.sh` holds that port to
/// `tools/tv_hijri_reference.json`, day by day.
///
/// This test holds the reference itself to the phone. Run with
/// `REGENERATE_TV_HIJRI=1` to rewrite it.
void main() {
  const path = 'tools/tv_hijri_reference.json';

  test('the Apple TV Hijri reference is what the phone answers', () {
    final rendered = renderTvHijriReference();
    final file = File(path);
    if (Platform.environment['REGENERATE_TV_HIJRI'] == '1') {
      file.writeAsStringSync(rendered);
    }
    expect(file.existsSync(), isTrue, reason: '$path is missing');
    expect(
      file.readAsStringSync() == rendered,
      isTrue,
      reason:
          '$path is stale. Run REGENERATE_TV_HIJRI=1 flutter test '
          'test/features/tvos/tvos_hijri_reference_test.dart, then '
          'bash scripts/verify_tv_prayer_times.sh',
    );
  });
}

/// Every day from 2020 to 2040, as the phone names it in the Hijri year.
String renderTvHijriReference() {
  final first = DateTime.utc(2020);
  final last = DateTime.utc(2040, 12, 31);
  final buffer = StringBuffer('{\n')
    ..writeln(
      '  "source": "toHijriDate, lib/shared/utils/hijri_date_utils.dart",',
    )
    ..writeln('  "from": "2020-01-01",')
    ..writeln('  "days": [');
  for (
    var day = first;
    !day.isAfter(last);
    day = DateTime.utc(day.year, day.month, day.day + 1)
  ) {
    final hijri = toHijriDate(day);
    final isLast = day.isAtSameMomentAs(last);
    buffer.writeln(
      '    "${hijri.year}-${hijri.month}-${hijri.day}"${isLast ? '' : ','}',
    );
  }
  buffer
    ..writeln('  ]')
    ..writeln('}');
  return buffer.toString();
}
