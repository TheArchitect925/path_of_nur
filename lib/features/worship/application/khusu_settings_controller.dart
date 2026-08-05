import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/khusu_settings.dart';

class KhusuSettingsController extends StateNotifier<KhusuSettings> {
  KhusuSettingsController() : super(KhusuSettings.defaults);

  void setReduceVisualDistractions(bool value) {
    state = state.copyWith(reduceVisualDistractions: value);
  }

  void setMinimalInterface(bool value) {
    state = state.copyWith(minimalInterface: value);
  }

  void setGentleReminders(bool value) {
    state = state.copyWith(gentleReminders: value);
  }

  void setAmbientMode(bool value) {
    state = state.copyWith(ambientMode: value);
  }
}

final khusuSettingsControllerProvider =
    StateNotifierProvider<KhusuSettingsController, KhusuSettings>(
      (ref) => KhusuSettingsController(),
    );
