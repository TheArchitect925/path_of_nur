import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../../learn/journey/application/family_learning_provider.dart';
import '../../../learn/journey/domain/family_learning_models.dart';
import '../../../learn/journey/domain/learning_path_models.dart';
import '../domain/bedtime_family_models.dart';

const bedtimeFamilyModeStorageKey = 'kids.bedtime_stories.family_mode.v1';

String bedtimeFallbackLearnerIdForProfile(String profileId) =>
    'bedtime_fallback_$profileId';

String bedtimeStoryProgressStorageKeyForLearner(String learnerId) =>
    'kids.bedtime_stories.progress.v2.$learnerId';

String bedtimeStoryLearningProgressStorageKeyForLearner(String learnerId) =>
    'kids.bedtime_stories.learning_progress.v2.$learnerId';

String bedtimeStoryQueueStorageKeyForLearner(String learnerId) =>
    'kids.bedtime_stories.queue.v2.$learnerId';

final bedtimeFamilyModeProvider =
    StateNotifierProvider<BedtimeFamilyModeController, BedtimeFamilyModeState>((
      ref,
    ) {
      return BedtimeFamilyModeController(ref);
    });

final bedtimeAvailableLearnersProvider = Provider<List<BedtimeLearnerIdentity>>((
  ref,
) {
  final familyState = ref.watch(bedtimeFamilyModeProvider);
  final familyContext = ref.watch(activeFamilyLearningContextProvider);
  final accounts = ref.watch(accountsSyncControllerProvider);
  final childProfiles = _resolveRelevantChildren(ref);
  final items = <BedtimeLearnerIdentity>[];
  final guardianId = familyContext.activeGuardianProfileId;

  for (final child in childProfiles) {
    final preferences = familyState.preferencesByLearnerId[child.id] ??
        const BedtimeLearnerPreferences();
    items.add(
      BedtimeLearnerIdentity(
        learnerId: child.id,
        linkedChildProfileId: child.id,
        displayName: child.displayName,
        avatarReference: child.avatarReference,
        ageGroup: child.ageGroup,
        guardianProfileId: guardianId,
        isFallbackLearner: false,
        preferences: preferences,
        createdAtIso: child.createdAt,
        updatedAtIso: child.updatedAt,
        isArchived: familyState.archivedLearnerIds.contains(child.id),
        sortOrder: 0,
      ),
    );
  }

  final activeProfile = accounts.activeProfile;
  if (items.isEmpty && activeProfile?.profileId != null) {
    final fallbackId = bedtimeFallbackLearnerIdForProfile(activeProfile!.profileId);
    items.add(
      BedtimeLearnerIdentity(
        learnerId: fallbackId,
        displayName: activeProfile.displayName,
        avatarReference: activeProfile.avatar,
        ageGroup: familyContext.activeChildProfile?.ageGroup ?? LearningAgeGroup.kids,
        guardianProfileId: familyContext.activeGuardianProfileId ?? activeProfile.profileId,
        isFallbackLearner: true,
        preferences: familyState.preferencesByLearnerId[fallbackId] ??
            const BedtimeLearnerPreferences(),
        isArchived: familyState.archivedLearnerIds.contains(fallbackId),
      ),
    );
  }

  items.sort((a, b) {
    if (a.isArchived != b.isArchived) {
      return a.isArchived ? 1 : -1;
    }
    final nameCompare = a.effectiveDisplayName.toLowerCase().compareTo(
      b.effectiveDisplayName.toLowerCase(),
    );
    if (nameCompare != 0) {
      return nameCompare;
    }
    return a.learnerId.compareTo(b.learnerId);
  });
  return items;
});

final bedtimeArchivedLearnersProvider = Provider<List<BedtimeLearnerIdentity>>((
  ref,
) {
  return ref
      .watch(bedtimeAvailableLearnersProvider)
      .where((item) => item.isArchived)
      .toList(growable: false);
});

final bedtimeActiveLearnerProvider = Provider<BedtimeLearnerIdentity>((ref) {
  final familyState = ref.watch(bedtimeFamilyModeProvider);
  final familyContext = ref.watch(activeFamilyLearningContextProvider);
  final accounts = ref.watch(accountsSyncControllerProvider);
  final learners = ref.watch(bedtimeAvailableLearnersProvider);
  final activeProfile = accounts.activeProfile;
  final activeChild = familyContext.activeChildProfile;

  if (activeChild != null) {
    return learners.firstWhere(
      (item) => item.learnerId == activeChild.id,
      orElse: () => BedtimeLearnerIdentity(
        learnerId: activeChild.id,
        linkedChildProfileId: activeChild.id,
        displayName: activeChild.displayName,
        avatarReference: activeChild.avatarReference,
        ageGroup: activeChild.ageGroup,
        guardianProfileId: familyContext.activeGuardianProfileId,
        isFallbackLearner: false,
        preferences:
            familyState.preferencesByLearnerId[activeChild.id] ??
            const BedtimeLearnerPreferences(),
      ),
    );
  }

  final guardianId = familyContext.activeGuardianProfileId;
  if (guardianId != null && learners.isNotEmpty) {
    final session = familyState.activeLearnerSessionByGuardianId[guardianId];
    if (session != null) {
      final selected = learners.where((item) => !item.isArchived).firstWhere(
        (item) => item.learnerId == session.learnerId,
        orElse: () => const BedtimeLearnerIdentity(
          learnerId: '',
          displayName: '',
          avatarReference: '',
          ageGroup: LearningAgeGroup.kids,
          guardianProfileId: null,
          isFallbackLearner: true,
          preferences: BedtimeLearnerPreferences(),
        ),
      );
      if (selected.learnerId.isNotEmpty) {
        return selected;
      }
    }
    final firstAvailable = learners.where((item) => !item.isArchived).firstOrNull;
    if (firstAvailable != null) {
      return firstAvailable;
    }
  }

  final first = learners.firstOrNull;
  if (first != null) {
    return first;
  }

  final fallbackProfileId = activeProfile?.profileId ?? 'device_local';
  return BedtimeLearnerIdentity(
    learnerId: bedtimeFallbackLearnerIdForProfile(fallbackProfileId),
    displayName: activeProfile?.displayName ?? '',
    avatarReference: activeProfile?.avatar ?? '🌙',
    ageGroup: LearningAgeGroup.kids,
    guardianProfileId: familyContext.activeGuardianProfileId ?? activeProfile?.profileId,
    isFallbackLearner: true,
    preferences: const BedtimeLearnerPreferences(),
  );
});

final bedtimeCanManageFamilyModeProvider = Provider<bool>((ref) {
  final accounts = ref.watch(accountsSyncControllerProvider);
  final activeProfile = accounts.activeProfile;
  if (activeProfile == null) {
    return false;
  }
  return activeProfile.profileType != ProfileKind.child &&
      activeProfile.profileType != ProfileKind.guest;
});

class BedtimeFamilyModeController extends StateNotifier<BedtimeFamilyModeState> {
  BedtimeFamilyModeController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(
        BedtimeFamilyModeState.fromJson(
          _ref.read(localStoreProvider).getJsonMap(bedtimeFamilyModeStorageKey),
        ),
      );

  final Ref _ref;
  final LocalStore _store;

  Future<void> selectLearner(BedtimeLearnerIdentity learner) async {
    final guardianId =
        learner.guardianProfileId ??
        _ref.read(activeFamilyLearningContextProvider).activeGuardianProfileId;
    if (guardianId == null) {
      return;
    }
    final nextSessions = {
      ...state.activeLearnerSessionByGuardianId,
      guardianId: BedtimeActiveLearnerSession(
        learnerId: learner.learnerId,
        guardianProfileId: guardianId,
        selectedAtIso: DateTime.now().toIso8601String(),
      ),
    };
    state = state.copyWith(activeLearnerSessionByGuardianId: nextSessions);
    await _persist();
  }

  Future<void> updatePreferences({
    required String learnerId,
    required BedtimeLearnerPreferences preferences,
  }) async {
    state = state.copyWith(
      preferencesByLearnerId: {
        ...state.preferencesByLearnerId,
        learnerId: preferences,
      },
    );
    await _persist();
  }

  Future<void> archiveLearner(String learnerId) async {
    state = state.copyWith(
      archivedLearnerIds: {
        ...state.archivedLearnerIds,
        learnerId,
      },
    );
    await _persist();
  }

  Future<void> unarchiveLearner(String learnerId) async {
    final next = {...state.archivedLearnerIds}..remove(learnerId);
    state = state.copyWith(archivedLearnerIds: next);
    await _persist();
  }

  Future<void> _persist() {
    return _store.setJsonMap(bedtimeFamilyModeStorageKey, state.toJson());
  }
}

List<ChildLearningProfile> _resolveRelevantChildren(Ref ref) {
  final familyContext = ref.watch(activeFamilyLearningContextProvider);
  final familyState = ref.watch(familyLearningProvider);
  final childProfiles = <ChildLearningProfile>[];
  if (familyContext.familyGroup != null) {
    for (final childId in familyContext.familyGroup!.childProfileIds) {
      final child = familyState.childProfiles[childId];
      if (child != null) {
        childProfiles.add(child);
      }
    }
  }
  if (familyContext.activeChildProfile != null &&
      childProfiles.every((item) => item.id != familyContext.activeChildProfile!.id)) {
    childProfiles.add(familyContext.activeChildProfile!);
  }
  return childProfiles;
}
