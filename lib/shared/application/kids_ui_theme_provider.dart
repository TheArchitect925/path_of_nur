import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/learn/journey/application/family_learning_provider.dart';
import '../../features/learn/journey/domain/learning_path_models.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../../features/profile/domain/profile_age_preferences.dart';

class KidsUiThemeState {
  const KidsUiThemeState({
    required this.enabled,
    required this.ageRange,
    required this.mode,
    required this.isChildProfile,
  });

  final bool enabled;
  final ProfileAgeRange ageRange;
  final KidsUiThemeMode mode;
  final bool isChildProfile;
}

final activeKidsUiThemeProvider = Provider<KidsUiThemeState>((ref) {
  final familyContext = ref.watch(activeFamilyLearningContextProvider);
  final childProfile = familyContext.activeChildProfile;
  if (childProfile != null) {
    final ageRange = _ageRangeFromLearningAgeGroup(childProfile.ageGroup);
    final mode = childProfile.kidsUiThemeMode;
    return KidsUiThemeState(
      enabled: resolveKidsUiThemeEnabled(ageRange: ageRange, mode: mode),
      ageRange: ageRange,
      mode: mode,
      isChildProfile: true,
    );
  }
  final settings = ref.watch(profileSettingsProvider);
  return KidsUiThemeState(
    enabled: settings.effectiveKidsUiThemeEnabled,
    ageRange: settings.ageRange,
    mode: settings.kidsUiThemeMode,
    isChildProfile: false,
  );
});

ProfileAgeRange _ageRangeFromLearningAgeGroup(LearningAgeGroup group) {
  switch (group) {
    case LearningAgeGroup.kids:
      return ProfileAgeRange.child;
    case LearningAgeGroup.teens:
      return ProfileAgeRange.teen;
    case LearningAgeGroup.adults:
      return ProfileAgeRange.adult;
  }
}
