import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/routes/router_deep_links.dart';

void main() {
  test('growth deep links map to canonical journey routes', () {
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/today')),
      '/journey/growth/today',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/reflection')),
      '/journey/growth/reflection',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/journey')),
      '/journey/growth/journey',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/habits')),
      '/journey/growth/habits',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/habit/h_morning_adhkar')),
      '/journey/habit/h_morning_adhkar',
    );
  });

  test('quran deep links map to canonical quran routes', () {
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://quran/read')),
      '/quran/surah/1',
    );
  });

  test('unsupported deep links return null', () {
    expect(mapAppDeepLink(Uri.parse('https://example.com')), isNull);
    expect(mapAppDeepLink(Uri.parse('pathofnur://unknown/path')), isNull);
  });
}
