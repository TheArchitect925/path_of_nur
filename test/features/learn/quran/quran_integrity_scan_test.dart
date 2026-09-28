import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('quote and banner presentation files do not hardcode Quran Arabic', () {
    const files = <String>[
      'lib/shared/widgets/quran_quote_block.dart',
      'lib/shared/content/learning_quote.dart',
      'lib/features/worship/presentation/worship_page.dart',
      'lib/features/worship/presentation/worship_section_pages.dart',
      'lib/features/salah/presentation/salah_page.dart',
      'lib/features/learn/prophets/presentation/prophet_detail_page.dart',
      'lib/features/learn/presentation/pages/quran_app_hub_page.dart',
      // quran_verse_page.dart was an orphan route with no callers and was
      // deleted in calm-navigation Phase 7a.
    ];
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');

    for (final path in files) {
      final content = File(path).readAsStringSync();
      expect(
        arabicRegex.hasMatch(content),
        isFalse,
        reason: '$path still contains hardcoded Arabic content.',
      );
    }
  });

  test('Quran navigation no longer passes raw verse strings in routes', () {
    final navigation = File(
      'lib/shared/widgets/quran_navigation.dart',
    ).readAsStringSync();
    final routes = File(
      'lib/app/routes/core_support_routes.dart',
    ).readAsStringSync();

    expect(navigation.contains("'arabic':"), isFalse);
    expect(navigation.contains("'transliteration':"), isFalse);
    expect(navigation.contains("'translation':"), isFalse);

    expect(routes.contains("params['arabic']"), isFalse);
    expect(routes.contains("params['transliteration']"), isFalse);
    expect(routes.contains("params['translation']"), isFalse);
  });
}
