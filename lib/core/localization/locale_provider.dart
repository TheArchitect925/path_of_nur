import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/persistence/local_store.dart';

const _localeStorageKey = 'profile.locale';
const releaseSupportedLocales = <Locale>[Locale('en'), Locale('de')];

Locale? resolveStoredAppLocale(LocalStore store) {
  final tag = store.getString(_localeStorageKey);
  if (tag == null || tag.isEmpty) return null;
  final locale = _localeFromTag(tag);
  return _resolveToSupportedLocale(locale);
}

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier(this._store) : super(null) {
    _load();
  }

  final LocalStore _store;

  void setLocale(Locale locale) {
    final supportedLocale = _resolveToSupportedLocale(locale);
    if (supportedLocale == null) {
      state = null;
      _store.remove(_localeStorageKey);
      return;
    }
    state = supportedLocale;
    _store.setString(_localeStorageKey, supportedLocale.toLanguageTag());
  }

  void clearLocale() {
    state = null;
    _store.remove(_localeStorageKey);
  }

  void _load() {
    final supportedLocale = resolveStoredAppLocale(_store);
    if (supportedLocale == null) {
      final tag = _store.getString(_localeStorageKey);
      if (tag != null && tag.isNotEmpty) {
        clearLocale();
      }
      return;
    }
    state = supportedLocale;
  }
}

Locale _localeFromTag(String tag) {
  final parts = tag.split('-');
  final language = parts.first.toLowerCase();
  final country = parts.length > 1 && parts[1].isNotEmpty
      ? parts[1].toUpperCase()
      : null;
  return Locale.fromSubtags(languageCode: language, countryCode: country);
}

bool isReleaseLocaleSupported(Locale locale) {
  for (final supported in releaseSupportedLocales) {
    if (_isLocaleMatch(locale, supported)) {
      return true;
    }
    if (locale.countryCode != null &&
        supported.countryCode == null &&
        locale.languageCode == supported.languageCode) {
      return true;
    }
  }
  return false;
}

Locale? _resolveToSupportedLocale(Locale locale) {
  for (final supported in releaseSupportedLocales) {
    if (_isLocaleMatch(locale, supported)) {
      return supported;
    }
    if (locale.countryCode != null &&
        supported.countryCode == null &&
        locale.languageCode == supported.languageCode) {
      return supported;
    }
  }
  return null;
}

bool _isLocaleMatch(Locale locale, Locale other) {
  if (locale.languageCode != other.languageCode) return false;
  if (locale.countryCode == null) return other.countryCode == null;
  if (other.countryCode == null) return false;
  return locale.countryCode == other.countryCode;
}

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale?>((
  ref,
) {
  final store = ref.watch(localStoreProvider);
  return AppLocaleNotifier(store);
});
