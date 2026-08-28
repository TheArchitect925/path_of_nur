import 'package:flutter/widgets.dart';

class AppFonts {
  const AppFonts._();

  static const String quranArabic = 'Amiri Quran';
  static const String arabicLearning = 'Noto Naskh Arabic';
  static const String uiArabic = 'Noto Sans Arabic';
  static const String uiUrdu = 'Noto Sans Arabic';

  /// Serif for headings, Qur'an-adjacent quotes, and translation prose.
  /// Bundled so iOS and Android render identical headings (previously the
  /// platform-dependent 'serif' alias).
  static const String latinSerif = 'Lora';

  /// Sans for body copy, labels, and UI chrome in Latin-script locales.
  static const String latinSans = 'Figtree';

  static bool usesRtlUiFont(Locale? locale) {
    final code = locale?.languageCode.toLowerCase();
    return code == 'ar' || code == 'ur';
  }

  static String? uiFontFamilyForLocale(Locale? locale) {
    final code = locale?.languageCode.toLowerCase();
    switch (code) {
      case 'ar':
        return uiArabic;
      case 'ur':
        return uiUrdu;
      default:
        return null;
    }
  }
}
