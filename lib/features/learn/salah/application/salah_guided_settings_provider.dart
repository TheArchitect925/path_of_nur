import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../quran/application/quran_providers.dart';
import '../models/salah_trainer_models.dart';

const _storageKey = 'learn.salah.trainer.guidedSettings.v1';

class SalahGuidedSettingsNotifier extends StateNotifier<SalahGuidedSettings> {
  SalahGuidedSettingsNotifier(
    this._store, {
    required SalahGuidedSettings defaults,
  }) : super(
         SalahGuidedSettings.fromJson(
           _store.getJsonMap(_storageKey),
           defaults: defaults,
         ),
       );

  final LocalStore _store;

  void setPace(SalahTrainerPace pace) => _update(state.copyWith(pace: pace));

  void setTasbihRepeats(int repeats) {
    if (!SalahGuidedSettings.tasbihRepeatOptions.contains(repeats)) return;
    _update(state.copyWith(tasbihRepeats: repeats));
  }

  void setShowTransliteration(bool value) =>
      _update(state.copyWith(showTransliteration: value));

  void setShowTranslation(bool value) =>
      _update(state.copyWith(showTranslation: value));

  void setFocusMode(bool value) => _update(state.copyWith(focusMode: value));

  void _update(SalahGuidedSettings next) {
    state = next;
    _store.setJsonMap(_storageKey, next.toJson());
  }
}

final salahGuidedSettingsProvider =
    StateNotifierProvider<SalahGuidedSettingsNotifier, SalahGuidedSettings>((
      ref,
    ) {
      // First run inherits the reader's text preferences; after that the
      // trainer keeps its own.
      final reader = ref.read(quranReaderSettingsProvider);
      return SalahGuidedSettingsNotifier(
        ref.watch(localStoreProvider),
        defaults: SalahGuidedSettings(
          pace: SalahTrainerPace.steady,
          tasbihRepeats: 3,
          showTransliteration: reader.showTransliteration,
          showTranslation: reader.showTranslation,
          focusMode: false,
        ),
      );
    });
