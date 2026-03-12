import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import 'onboarding_preferences_provider.dart';

const _onboardingCompletedKey = 'app.onboardingCompleted';
const _onboardingCompletedLegacyKey = 'hasCompletedOnboarding';

class OnboardingStateNotifier extends StateNotifier<bool> {
  OnboardingStateNotifier(this._store) : super(false) {
    _load();
  }

  final LocalStore _store;

  void complete() {
    state = true;
    _store.setBool(_onboardingCompletedKey, true);
    _store.setBool(_onboardingCompletedLegacyKey, true);
  }

  void reset() {
    state = false;
    _store.setBool(_onboardingCompletedKey, false);
    _store.setBool(_onboardingCompletedLegacyKey, false);
    _store.remove(onboardingPreferencesStoreKey);
  }

  void _load() {
    final saved = _store.getBool(_onboardingCompletedKey);
    final legacySaved = _store.getBool(_onboardingCompletedLegacyKey);
    if (saved != null || legacySaved != null) {
      state = saved ?? legacySaved ?? false;
      if (saved == null && legacySaved != null) {
        _store.setBool(_onboardingCompletedKey, legacySaved);
      }
      return;
    }

    final hasExistingData =
        _store.getJsonMap('profile.user') != null ||
        _store.getJsonMap('settings.profile') != null ||
        _store.getJsonMap('settings.prayer') != null;
    state = hasExistingData;
    if (hasExistingData) {
      _store.setBool(_onboardingCompletedKey, true);
    }
  }
}

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingStateNotifier, bool>(
      (ref) => OnboardingStateNotifier(ref.watch(localStoreProvider)),
    );
