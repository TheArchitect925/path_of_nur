import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';

const _hadithShowArabicKey = 'learn.hadith.showArabic';
const _hadithShowTransliterationKey = 'learn.hadith.showTransliteration';
const _hadithShowTranslationKey = 'learn.hadith.showTranslation';

class HadithReaderSettings {
  const HadithReaderSettings({
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
  });

  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;

  HadithReaderSettings copyWith({
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
  }) {
    return HadithReaderSettings(
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

class HadithReaderSettingsController
    extends StateNotifier<HadithReaderSettings> {
  HadithReaderSettingsController(this._store)
    : super(
        HadithReaderSettings(
          showArabic: _store.getBool(_hadithShowArabicKey) ?? true,
          showTransliteration:
              _store.getBool(_hadithShowTransliterationKey) ?? true,
          showTranslation: _store.getBool(_hadithShowTranslationKey) ?? true,
        ),
      );

  final LocalStore _store;

  void setShowArabic(bool value) {
    state = state.copyWith(showArabic: value);
    _store.setBool(_hadithShowArabicKey, value);
  }

  void setShowTransliteration(bool value) {
    state = state.copyWith(showTransliteration: value);
    _store.setBool(_hadithShowTransliterationKey, value);
  }

  void setShowTranslation(bool value) {
    state = state.copyWith(showTranslation: value);
    _store.setBool(_hadithShowTranslationKey, value);
  }
}

final hadithReaderSettingsProvider =
    StateNotifierProvider<HadithReaderSettingsController, HadithReaderSettings>(
      (ref) {
        return HadithReaderSettingsController(ref.watch(localStoreProvider));
      },
    );
