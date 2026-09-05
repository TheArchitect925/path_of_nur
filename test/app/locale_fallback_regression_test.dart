import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/localization/locale_provider.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

/// gen-l10n sorts `AppLocalizations.supportedLocales` alphabetically, so its
/// first entry is Arabic. Any provider that falls back to `.first` when the
/// user has not picked a locale silently serves Arabic instead of English.
void main() {
  test('the app-wide fallback locale is English', () {
    expect(defaultAppLocale, const Locale('en'));
  });

  test('supportedLocales.first is Arabic, so it is never a safe fallback', () {
    // Pins the trap this guard exists for: if gen-l10n ever stops sorting the
    // list, this test tells you the guard below can be relaxed.
    expect(AppLocalizations.supportedLocales.first, const Locale('ar'));
    expect(defaultAppLocale, isNot(AppLocalizations.supportedLocales.first));
  });

  test('no source file falls back to supportedLocales.first for a locale', () {
    final offenders = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      // Collapse whitespace so the check survives dart format line wrapping.
      final flat = source.replaceAll(RegExp(r'\s+'), ' ');
      if (flat.contains(
        'appLocaleProvider) ?? '
        'AppLocalizations.supportedLocales.first',
      )) {
        offenders.add(file.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These files fall back to Arabic when no locale is saved. '
          'Use `defaultAppLocale` from core/localization/locale_provider.dart '
          'instead:\n${offenders.join('\n')}',
    );
  });
}
