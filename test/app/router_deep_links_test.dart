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
    expect(
      mapAppDeepLink(
        Uri.parse(
          'pathofnur://quran/surah/2?ayah=255&endAyah=257&autoplay=1&playback=selectionLoop',
        ),
      ),
      '/quran/surah/2?ayah=255&endAyah=257&autoplay=1&playback=selectionLoop',
    );
    expect(
      mapAppDeepLink(
        Uri.parse(
          'pathofnur://quran/read?ayah=40&journeyId=seerah-journey&stageId=seerah-hijrah',
        ),
      ),
      '/quran/surah/1?ayah=40&journeyId=seerah-journey&stageId=seerah-hijrah',
    );
  });

  test('unsupported deep links return null', () {
    expect(mapAppDeepLink(Uri.parse('https://example.com')), isNull);
    expect(mapAppDeepLink(Uri.parse('pathofnur://unknown/path')), isNull);
  });

  test('host-form links map like path-form links', () {
    // `pathofnur://learn/games` parses as host "learn" + path "/games"; it
    // used to fall through to "Route not found" while the triple-slash form
    // worked. Both shapes are handed out in the app, so both must resolve.
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://learn/games')),
      '/learn/games',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur:///learn/games')),
      '/learn/games',
    );
    expect(
      mapAppDeepLink(
        Uri.parse(
          'pathofnur://learn/quizzes/crossword/puzzle/kids_alif_allah?pack=kids_basics',
        ),
      ),
      '/learn/quizzes/crossword/puzzle/kids_alif_allah?pack=kids_basics',
    );
    expect(
      mapAppDeepLink(Uri.parse('pathofnur://journey/today')),
      '/journey/today',
    );
  });
}
