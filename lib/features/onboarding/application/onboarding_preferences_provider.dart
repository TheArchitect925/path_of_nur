import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/onboarding_preferences.dart';

const onboardingPreferencesStoreKey = 'app.onboardingProfile.v1';

class OnboardingPreferencesNotifier
    extends StateNotifier<OnboardingPreferences?> {
  OnboardingPreferencesNotifier(this._store) : super(null) {
    _load();
  }

  final LocalStore _store;

  void save(OnboardingPreferences preferences) {
    state = preferences;
    _store.setJsonMap(onboardingPreferencesStoreKey, preferences.toJson());
  }

  void clear() {
    state = null;
    _store.remove(onboardingPreferencesStoreKey);
  }

  void _load() {
    final raw = _store.getJsonMap(onboardingPreferencesStoreKey);
    state = OnboardingPreferences.fromJson(raw);
  }
}

final onboardingPreferencesProvider =
    StateNotifierProvider<
      OnboardingPreferencesNotifier,
      OnboardingPreferences?
    >((ref) {
      return OnboardingPreferencesNotifier(ref.watch(localStoreProvider));
    });
