import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/accounts_sync/application/accounts_sync_controller.dart';
import '../../kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import '../../../features/learn/journey/application/family_learning_provider.dart';
import '../../../features/learn/journey/domain/learning_path_models.dart';

class KidsDuaActiveLearner {
  const KidsDuaActiveLearner({
    required this.learnerId,
    required this.displayName,
    required this.ageGroup,
    required this.preferredLanguageTag,
    required this.isChildProfile,
  });

  final String learnerId;
  final String displayName;
  final LearningAgeGroup ageGroup;
  final String preferredLanguageTag;
  final bool isChildProfile;
}

const legacyKidsDuaLearningStateKey = 'kids.dua.learning.v1';
const legacyKidsDuaMyDayStateKey = 'kids.dua.my_day.v1';
const legacyKidsDuaCreativeStateKey = 'kids.dua.creative.v1';

String legacyKidsDuaFallbackLearnerIdForProfile(String profileId) =>
    'kids_dua_fallback_$profileId';

String kidsDuaFallbackLearnerIdForProfile(String profileId) =>
    bedtimeFallbackLearnerIdForProfile(profileId);

String kidsDuaLearningStorageKeyForLearner(String learnerId) =>
    'kids.dua.learning.v2.$learnerId';

String kidsDuaMyDayStorageKeyForLearner(String learnerId) =>
    'kids.dua.my_day.v2.$learnerId';

String kidsDuaCreativeStorageKeyForLearner(String learnerId) =>
    'kids.dua.creative.v2.$learnerId';

String? legacyKidsDuaScopedLearnerIdForCurrent(String learnerId) {
  if (!learnerId.startsWith('bedtime_fallback_')) {
    return null;
  }
  return learnerId.replaceFirst('bedtime_fallback_', 'kids_dua_fallback_');
}

final kidsDuaActiveLearnerProvider = Provider<KidsDuaActiveLearner>((ref) {
  final familyContext = ref.watch(activeFamilyLearningContextProvider);
  final accounts = ref.watch(accountsSyncControllerProvider);
  final activeProfile = accounts.activeProfile;
  final activeChild = familyContext.activeChildProfile;

  if (activeChild != null) {
    return KidsDuaActiveLearner(
      learnerId: activeChild.id,
      displayName: activeChild.displayName,
      ageGroup: activeChild.ageGroup,
      preferredLanguageTag: activeChild.preferredLanguageTag,
      isChildProfile: true,
    );
  }

  final fallbackProfileId = activeProfile?.profileId ?? 'device_local';
  return KidsDuaActiveLearner(
    learnerId: kidsDuaFallbackLearnerIdForProfile(fallbackProfileId),
    displayName: activeProfile?.displayName ?? '',
    ageGroup: LearningAgeGroup.kids,
    preferredLanguageTag: 'en',
    isChildProfile: false,
  );
});
