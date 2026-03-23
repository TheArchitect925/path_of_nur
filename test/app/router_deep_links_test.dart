import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/routes/router_deep_links.dart';

void main() {
  test('worship deep links map to specific worship subpages', () {
    expect(mapAppDeepLink(Uri.parse('pathofnur://prayer')), '/worship/prayer');
    expect(mapAppDeepLink(Uri.parse('pathofnur://dhikr')), '/worship/dhikr');
  });

  test('growth deep links map to canonical journey routes', () {
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/today')),
      '/journey/today',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/reflection')),
      '/journey/reflection',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/journey')),
      '/journey/progress',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/habits')),
      '/journey/habits',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://growth/habit/h_morning_adhkar')),
      '/journey/habit/h_morning_adhkar',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://tracking')),
      '/journey/statistics',
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
