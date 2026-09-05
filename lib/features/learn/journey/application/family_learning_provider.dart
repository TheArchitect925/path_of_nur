import '../../../kids/shared/domain/kids_age_band.dart';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/family_learning_models.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import '../../../profile/domain/profile_age_preferences.dart';
import 'learning_journey_progress_provider.dart';
import 'learning_path_provider.dart';

const _familyLearningStorageKey = 'accounts_sync.family_learning.v1';
const _familyLearningJourneyProgressKey = 'learn.journey.progress.v1';
const _familyLearningPathStateKey = 'learn.path.state.v1';
const _familyLearningLocaleKey = 'profile.locale';

class FamilyLearningNotifier extends StateNotifier<FamilyLearningStoreState> {
  FamilyLearningNotifier(this._ref, this._store)
    : super(FamilyLearningStoreState.initial()) {
    _load();
  }

  final Ref _ref;
  final LocalStore _store;

  void _load() {
    state = FamilyLearningStoreState.fromJson(
      _store.getJsonMap(_familyLearningStorageKey),
    );
  }

  Future<void> createChildProfile({
    required String displayName,
    required LearningAgeGroup ageGroup,
    required LearningPathLevel learningLevel,
    required String avatarReference,
    required KidsUiThemeMode kidsUiThemeMode,
    KidsAgeBand ageBand = KidsAgeBand.core,
    required ChildBrowsingMode browsingMode,
    required ChildLearningPermissions permissions,
  }) async {
    final activeProfile = _ref
        .read(accountsSyncControllerProvider)
        .activeProfile;
    final guardianProfileId = activeProfile?.profileId;
    if (guardianProfileId == null) {
      return;
    }
    final locale = _ref.read(appLocaleProvider);
    final assignedPath = LearningPathRegistry.pathForLevel(learningLevel);
    if (assignedPath == null) {
      return;
    }
    final childProfileId = await _ref
        .read(accountsSyncControllerProvider.notifier)
        .createProfile(
          displayName: displayName,
          kind: ProfileKind.child,
          experienceMode: ProfileExperienceMode.learningFocused,
          syncMode: ProfileSyncMode.localOnly,
          avatar: avatarReference,
          guardianManaged: true,
          activateAfterCreate: false,
        );
    final now = DateTime.now().toIso8601String();
    final nextGroups = {...state.groups};
    final groupId = 'family_$guardianProfileId';
    final existingGroup =
        nextGroups[groupId] ??
        FamilyLearningGroup(
          id: groupId,
          primaryGuardianProfileId: guardianProfileId,
          childProfileIds: const <String>[],
        );
    nextGroups[groupId] = existingGroup.copyWith(
      childProfileIds: <String>[
        ...existingGroup.childProfileIds.where((id) => id != childProfileId),
        childProfileId,
      ],
    );
    final nextChildren = {...state.childProfiles};
    nextChildren[childProfileId] = ChildLearningProfile(
      id: childProfileId,
      displayName: displayName,
      ageGroup: ageGroup,
      learningLevel: learningLevel,
      assignedPathId: assignedPath.id,
      preferredLanguageTag: locale?.toLanguageTag() ?? 'en',
      avatarReference: avatarReference,
      kidsUiThemeMode: kidsUiThemeMode,
      ageBand: ageBand,
      contentSafetyMode: browsingMode == ChildBrowsingMode.guidedOnly
          ? ChildContentSafetyMode.guided
          : ChildContentSafetyMode.guidedWithExplore,
      browsingMode: browsingMode,
      permissions: permissions,
      createdAt: now,
      updatedAt: now,
    );
    final nextLinks = [
      ...state.links.where(
        (item) =>
            !(item.guardianProfileId == guardianProfileId &&
                item.childProfileId == childProfileId),
      ),
      ParentChildLearningLink(
        guardianProfileId: guardianProfileId,
        childProfileId: childProfileId,
        role: ParentChildLearningRole.guardian,
        createdAt: now,
      ),
    ];
    state = state.copyWith(
      groups: nextGroups,
      childProfiles: nextChildren,
      links: nextLinks,
    );
    await _save();
    await _seedChildProfileSnapshot(nextChildren[childProfileId]!);
  }

  Future<void> updateChildProfile(ChildLearningProfile child) async {
    final current = state.childProfiles[child.id];
    if (current == null) {
      return;
    }
    final now = DateTime.now().toIso8601String();
    final nextChild = child.copyWith(updatedAt: now);
    state = state.copyWith(
      childProfiles: {...state.childProfiles, child.id: nextChild},
    );
    await _save();
    await _ref
        .read(accountsSyncControllerProvider.notifier)
        .updateProfilePresentation(
          child.id,
          displayName: nextChild.displayName,
          avatar: nextChild.avatarReference,
        );
    await _seedChildProfileSnapshot(nextChild);
  }

  Future<void> switchToProfile(String profileId) {
    return _ref
        .read(deviceSessionManagerProvider)
        .switchProfile(profileId, pin: '');
  }

  Future<void> _seedChildProfileSnapshot(ChildLearningProfile child) async {
    final path = LearningPathRegistry.pathForLevel(child.learningLevel);
    if (path == null) {
      return;
    }
    final snapshot = _ref
        .read(accountsSyncControllerProvider)
        .profileSnapshots[child.id];
    final existingPathState = UserLearningPathState.fromJson(
      _decodeSnapshotJsonMap(snapshot?[_familyLearningPathStateKey]),
    );
    final validPhaseId = _resolvePhaseId(
      existingPathState?.currentPhaseId,
      path,
    );
    final nextPathState = UserLearningPathState(
      selectedLevel: child.learningLevel,
      ageGroup: child.ageGroup,
      currentPhaseId: validPhaseId,
      completedPhaseIds:
          existingPathState?.completedPhaseIds ?? const <String>{},
      activeJourneyIds: existingPathState?.activeJourneyIds ?? const <String>{},
      secondaryExplorationIds:
          existingPathState?.secondaryExplorationIds ?? const <String>{},
      lastActivityTimestamp: existingPathState?.lastActivityTimestamp,
      completionRate: existingPathState?.completionRate ?? 0,
      averageSessionDepth: existingPathState?.averageSessionDepth ?? 0,
    );
    await _ref
        .read(accountsSyncControllerProvider.notifier)
        .mergeIntoProfileSnapshot(child.id, <String, dynamic>{
          _familyLearningPathStateKey: jsonEncode(nextPathState.toJson()),
          _familyLearningLocaleKey: child.preferredLanguageTag,
        });
  }

  String _resolvePhaseId(String? candidate, LearningPath path) {
    if (candidate != null &&
        path.phases.any((phase) => phase.id == candidate)) {
      return candidate;
    }
    return path.phases.first.id;
  }

  Future<void> _save() {
    return _store.setJsonMap(_familyLearningStorageKey, state.toJson());
  }
}

Map<String, dynamic>? _decodeSnapshotJsonMap(dynamic raw) {
  if (raw == null) {
    return null;
  }
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  if (raw is! String || raw.isEmpty) {
    return null;
  }
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  if (decoded is Map) {
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

LearningAgeGroup _defaultAgeGroupForProfile(ProfileRecord profile) {
  switch (profile.profileType) {
    case ProfileKind.child:
      return LearningAgeGroup.kids;
    case ProfileKind.youth:
      return LearningAgeGroup.teens;
    case ProfileKind.adult:
    case ProfileKind.guest:
      return LearningAgeGroup.adults;
  }
}

final familyLearningProvider =
    StateNotifierProvider<FamilyLearningNotifier, FamilyLearningStoreState>(
      (ref) => FamilyLearningNotifier(ref, ref.watch(localStoreProvider)),
    );

final activeFamilyLearningContextProvider =
    Provider<ActiveFamilyLearningContext>((ref) {
      final state = ref.watch(familyLearningProvider);
      final accounts = ref.watch(accountsSyncControllerProvider);
      final activeProfile = accounts.activeProfile;
      final activeProfileId = accounts.activeProfileId;
      final activeChildProfile = activeProfileId == null
          ? null
          : state.childProfiles[activeProfileId];
      String? activeGuardianProfileId;
      FamilyLearningGroup? group;
      if (activeChildProfile != null) {
        final link = state.links
            .where((item) => item.childProfileId == activeChildProfile.id)
            .firstOrNull;
        activeGuardianProfileId = link?.guardianProfileId;
      } else if (activeProfile != null &&
          activeProfile.profileType != ProfileKind.child &&
          activeProfile.profileType != ProfileKind.guest) {
        activeGuardianProfileId = activeProfile.profileId;
      }
      if (activeGuardianProfileId != null) {
        final groupId = 'family_$activeGuardianProfileId';
        group = state.groups[groupId];
      }
      final switchableProfileIds = <String>[];
      if (activeGuardianProfileId != null) {
        switchableProfileIds.add(activeGuardianProfileId);
      }
      switchableProfileIds.addAll(group?.childProfileIds ?? const <String>[]);
      return ActiveFamilyLearningContext(
        activeProfileId: activeProfileId,
        activeGuardianProfileId: activeGuardianProfileId,
        activeChildProfile: activeChildProfile,
        familyGroup: group,
        switchableProfileIds: switchableProfileIds.toSet().toList(
          growable: false,
        ),
        visibilityPolicy: _buildVisibilityPolicy(
          activeProfile: activeProfile,
          childProfile: activeChildProfile,
          accounts: accounts,
        ),
      );
    });

FamilyLearningVisibilityPolicy _buildVisibilityPolicy({
  required ProfileRecord? activeProfile,
  required ChildLearningProfile? childProfile,
  required AccountsSyncState accounts,
}) {
  final isChild =
      activeProfile?.profileType == ProfileKind.child || childProfile != null;
  if (!isChild) {
    return const FamilyLearningVisibilityPolicy(
      isChildProfile: false,
      isGuardianProfile: true,
      guidedOnly: false,
      showBrowseAll: true,
      showLegacyLearning: true,
      showAdvancedJourneys: true,
      showSecondaryExploration: true,
      showTrivia: true,
      showDiscovery: true,
    );
  }
  final effectiveAgeGroup =
      childProfile?.ageGroup ?? _defaultAgeGroupForProfile(activeProfile!);
  final defaultPermissions = ChildLearningPermissions.defaultsFor(
    effectiveAgeGroup,
  );
  final permissions = childProfile?.permissions ?? defaultPermissions;
  final guidedOnly =
      (childProfile?.browsingMode ?? ChildBrowsingMode.guidedOnly) ==
      ChildBrowsingMode.guidedOnly;
  final allowAdvanced =
      permissions.allowAdvancedJourneys &&
      !accounts.sharedDeviceSafety.hideAdvancedToolsFromChildProfiles;
  return FamilyLearningVisibilityPolicy(
    isChildProfile: true,
    isGuardianProfile: false,
    guidedOnly: guidedOnly,
    showBrowseAll: permissions.allowBrowseAll && !guidedOnly,
    showLegacyLearning: permissions.allowLegacyLearning && !guidedOnly,
    showAdvancedJourneys: allowAdvanced,
    showSecondaryExploration:
        permissions.allowSecondaryExploration && !guidedOnly,
    showTrivia: permissions.allowTrivia,
    showDiscovery: permissions.allowDiscovery,
  );
}

bool _isAdvancedJourney(String journeyId) {
  return const <String>{
    'fiqh-basics',
    'timeline-of-islam',
    'tajweed-basics',
    'reflection-mode',
  }.contains(journeyId);
}

bool _isDiscoveryJourney(String journeyId) {
  return const <String>{
    'stories-signs',
    'daily-wisdom',
    'trivia-knowledge-paths',
  }.contains(journeyId);
}

bool _isTriviaJourney(String journeyId) =>
    journeyId == 'trivia-knowledge-paths';

bool learningVisibilityAllowsJourney(
  FamilyLearningVisibilityPolicy policy,
  LearningJourney journey,
) {
  if (!policy.isChildProfile) {
    return true;
  }
  if (!policy.showAdvancedJourneys && _isAdvancedJourney(journey.id)) {
    return false;
  }
  if (!policy.showTrivia && _isTriviaJourney(journey.id)) {
    return false;
  }
  if (!policy.showDiscovery && _isDiscoveryJourney(journey.id)) {
    return false;
  }
  return true;
}

bool learningVisibilityAllowsIsland(
  FamilyLearningVisibilityPolicy policy,
  LearningJourneyIsland island,
) {
  if (!policy.isChildProfile) {
    return true;
  }
  if (policy.guidedOnly) {
    return false;
  }
  if (!policy.showDiscovery && island.id == 'discovery') {
    return false;
  }
  return true;
}

final familyLearningSwitcherProfilesProvider = Provider<List<ProfileRecord>>((
  ref,
) {
  final context = ref.watch(activeFamilyLearningContextProvider);
  final profiles = ref.watch(
    accountsSyncControllerProvider.select((state) => state.profiles),
  );
  final byId = {for (final item in profiles) item.profileId: item};
  return context.switchableProfileIds
      .map((id) => byId[id])
      .whereType<ProfileRecord>()
      .toList(growable: false);
});

final familyLearningChildProfilesForGuardianProvider =
    Provider<List<ChildLearningProfile>>((ref) {
      final state = ref.watch(familyLearningProvider);
      final context = ref.watch(activeFamilyLearningContextProvider);
      final guardianId = context.activeGuardianProfileId;
      if (guardianId == null) {
        return const <ChildLearningProfile>[];
      }
      final group = state.groups['family_$guardianId'];
      if (group == null) {
        return const <ChildLearningProfile>[];
      }
      return group.childProfileIds
          .map((id) => state.childProfiles[id])
          .whereType<ChildLearningProfile>()
          .toList(growable: false);
    });

ChildLearningProgressState _childProgressFromSnapshot({
  required String childProfileId,
  required Map<String, dynamic>? snapshot,
}) {
  final progress = LearningJourneyProgressState.fromJson(
    _decodeSnapshotJsonMap(snapshot?[_familyLearningJourneyProgressKey]),
  );
  final pathState = UserLearningPathState.fromJson(
    _decodeSnapshotJsonMap(snapshot?[_familyLearningPathStateKey]),
  );
  final completedJourneyIds = _completedJourneyIds(progress.completedStageIds);
  final path = pathState == null
      ? null
      : LearningPathRegistry.pathForLevel(pathState.selectedLevel);
  final totalJourneys = path == null
      ? 0
      : path.phases.fold<int>(0, (sum, phase) => sum + phase.journeyIds.length);
  final phaseId =
      pathState?.currentPhaseId ??
      (path?.phases.isNotEmpty == true ? path!.phases.first.id : null);
  final phase = path?.phases.where((item) => item.id == phaseId).firstOrNull;
  final recommendationJourneyIds = phase == null
      ? const <String>[]
      : phase.journeyIds
            .where((id) => !completedJourneyIds.contains(id))
            .take(3)
            .toList(growable: false);
  return ChildLearningProgressState(
    childProfileId: childProfileId,
    completedJourneyIds: completedJourneyIds,
    completedJourneyCount: completedJourneyIds.length,
    totalJourneyCount: totalJourneys,
    currentPathId: path?.id,
    currentPhaseId: phaseId,
    currentJourneyId: progress.lastOpenedJourneyId,
    currentStageId: progress.lastOpenedStageId,
    currentStreakDays: progress.currentStreakDays,
    todayCompleted:
        progress.activeDayKeys.contains(LocalStore.todayKey()) ||
        progress.todayLightOpenedDayKeys.contains(LocalStore.todayKey()),
    recommendationJourneyIds: recommendationJourneyIds,
    recentCompletedStageId: _recentCompletedStageId(progress),
    lastActivityAt:
        progress.completedStageDateKeys[_recentCompletedStageId(progress)],
  );
}

String? _recentCompletedStageId(LearningJourneyProgressState progress) {
  String? latestStageId;
  String? latestDate;
  progress.completedStageDateKeys.forEach((stageId, dateKey) {
    if (latestDate == null || dateKey.compareTo(latestDate!) > 0) {
      latestDate = dateKey;
      latestStageId = stageId;
    }
  });
  return latestStageId;
}

Set<String> _completedJourneyIds(Set<String> completedStageIds) {
  return LearningJourneyRegistry.journeys
      .where(
        (journey) =>
            journey.stageIds.isNotEmpty &&
            journey.stageIds.every(completedStageIds.contains),
      )
      .map((journey) => journey.id)
      .toSet();
}

final familyLearningChildProgressProvider =
    Provider.family<ChildLearningProgressState, String>((ref, childProfileId) {
      final accounts = ref.watch(accountsSyncControllerProvider);
      if (accounts.activeProfileId == childProfileId) {
        final progress = ref.watch(learningJourneyProgressProvider);
        final pathState = ref.watch(learningPathStateProvider);
        final completedJourneyIds = _completedJourneyIds(
          progress.completedStageIds,
        );
        final totalJourneys = pathState == null
            ? 0
            : pathState.path.phases.fold<int>(
                0,
                (sum, phase) => sum + phase.journeyIds.length,
              );
        return ChildLearningProgressState(
          childProfileId: childProfileId,
          completedJourneyIds: completedJourneyIds,
          completedJourneyCount: completedJourneyIds.length,
          totalJourneyCount: totalJourneys,
          currentPathId: pathState?.path.id,
          currentPhaseId: pathState?.currentPhase.id,
          currentJourneyId: progress.lastOpenedJourneyId,
          currentStageId: progress.lastOpenedStageId,
          currentStreakDays: progress.currentStreakDays,
          todayCompleted:
              progress.activeDayKeys.contains(LocalStore.todayKey()) ||
              progress.todayLightOpenedDayKeys.contains(LocalStore.todayKey()),
          recommendationJourneyIds:
              pathState?.activeJourneys
                  .map((item) => item.id)
                  .take(3)
                  .toList(growable: false) ??
              const <String>[],
          recentCompletedStageId: _recentCompletedStageId(progress),
          lastActivityAt: progress
              .completedStageDateKeys[_recentCompletedStageId(progress)],
        );
      }
      return _childProgressFromSnapshot(
        childProfileId: childProfileId,
        snapshot: accounts.profileSnapshots[childProfileId],
      );
    });

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
