import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/persistence/local_store.dart';

const _localeStorageKey = 'profile.locale';

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier(this._store) : super(null) {
    _load();
  }

  final LocalStore _store;

  void setLocale(Locale locale) {
    state = locale;
    _store.setString(_localeStorageKey, locale.toLanguageTag());
  }

  void clearLocale() {
    state = null;
    _store.remove(_localeStorageKey);
  }

  void _load() {
    final tag = _store.getString(_localeStorageKey);
    if (tag == null || tag.isEmpty) return;
    state = Locale.fromSubtags(
      languageCode: _languageCode(tag),
      countryCode: _countryCode(tag),
    );
  }

  String _languageCode(String tag) {
    final parts = tag.split('-');
    return parts.first;
  }

  String? _countryCode(String tag) {
    final parts = tag.split('-');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return parts[1];
    }
    return null;
  }
}

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale?>((ref) {
  final store = ref.watch(localStoreProvider);
  return AppLocaleNotifier(store);
});
