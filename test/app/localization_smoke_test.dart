import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generated localizations load for every supported locale', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(l10n.appTitle.trim(), isNotEmpty, reason: '$locale appTitle');
      expect(
        l10n.routerNotFoundTitle.trim(),
        isNotEmpty,
        reason: '$locale routerNotFoundTitle',
      );
    }
  });

  test('kids Arabic strings are localized for Arabic and German', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));
    final de = await AppLocalizations.delegate.load(const Locale('de'));

    expect(ar.kidsArabicHomeTitle.trim(), isNotEmpty);
    expect(de.kidsArabicHomeTitle.trim(), isNotEmpty);
    expect(ar.kidsArabicHomeTitle, isNot(en.kidsArabicHomeTitle));
    expect(de.kidsArabicHomeTitle, isNot(en.kidsArabicHomeTitle));
    expect(ar.kidsArabicPronunciationAction, isNot(en.kidsArabicPronunciationAction));
    expect(de.kidsArabicPronunciationAction, isNot(en.kidsArabicPronunciationAction));
  });
}
