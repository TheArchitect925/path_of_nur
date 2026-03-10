import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';

const _onboardingCompletedKey = 'app.onboardingCompleted';

class OnboardingStateNotifier extends StateNotifier<bool> {
  OnboardingStateNotifier(this._store) : super(false) {
    _load();
  }

  final LocalStore _store;

  void complete() {
    state = true;
    _store.setBool(_onboardingCompletedKey, true);
  }

  void _load() {
    final saved = _store.getBool(_onboardingCompletedKey);
    if (saved != null) {
      state = saved;
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
