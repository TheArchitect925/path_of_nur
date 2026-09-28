import '../../../kids/shared/domain/kids_age_band.dart';
import 'learning_path_models.dart';
import '../../../profile/domain/profile_age_preferences.dart';

enum ChildContentSafetyMode { guided, guidedWithExplore }

enum ChildBrowsingMode { guidedOnly, guidedPlusExplore }

enum ParentChildLearningRole { guardian }

class FamilyLearningGroup {
  const FamilyLearningGroup({
    required this.id,
    required this.primaryGuardianProfileId,
    required this.childProfileIds,
  });

  final String id;
  final String primaryGuardianProfileId;
  final List<String> childProfileIds;

  FamilyLearningGroup copyWith({List<String>? childProfileIds}) {
    return FamilyLearningGroup(
      id: id,
      primaryGuardianProfileId: primaryGuardianProfileId,
      childProfileIds: childProfileIds ?? this.childProfileIds,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'primaryGuardianProfileId': primaryGuardianProfileId,
    'childProfileIds': childProfileIds,
  };

  factory FamilyLearningGroup.fromJson(Map<String, dynamic> json) {
    return FamilyLearningGroup(
      id: json['id']?.toString() ?? '',
      primaryGuardianProfileId:
          json['primaryGuardianProfileId']?.toString() ?? '',
      childProfileIds: ((json['childProfileIds'] as List?) ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(growable: false),
    );
  }
}

class ChildLearningPermissions {
  const ChildLearningPermissions({
    required this.allowBrowseAll,
    required this.allowLegacyLearning,
    required this.allowAdvancedJourneys,
    required this.allowSecondaryExploration,
    required this.allowTrivia,
    required this.allowDiscovery,
    this.dailyGoal,
  });

  final bool allowBrowseAll;
  final bool allowLegacyLearning;
  final bool allowAdvancedJourneys;
  final bool allowSecondaryExploration;
  final bool allowTrivia;
  final bool allowDiscovery;
  final int? dailyGoal;

  factory ChildLearningPermissions.defaultsFor(LearningAgeGroup ageGroup) {
    switch (ageGroup) {
      case LearningAgeGroup.kids:
        return const ChildLearningPermissions(
          allowBrowseAll: false,
          allowLegacyLearning: false,
          allowAdvancedJourneys: false,
          allowSecondaryExploration: false,
          allowTrivia: true,
          allowDiscovery: true,
          dailyGoal: 1,
        );
      case LearningAgeGroup.teens:
        return const ChildLearningPermissions(
          allowBrowseAll: false,
          allowLegacyLearning: false,
          allowAdvancedJourneys: false,
          allowSecondaryExploration: true,
          allowTrivia: true,
          allowDiscovery: true,
          dailyGoal: 1,
        );
      case LearningAgeGroup.adults:
        return const ChildLearningPermissions(
          allowBrowseAll: true,
          allowLegacyLearning: false,
          allowAdvancedJourneys: true,
          allowSecondaryExploration: true,
          allowTrivia: true,
          allowDiscovery: true,
          dailyGoal: 1,
        );
    }
  }

  ChildLearningPermissions copyWith({
    bool? allowBrowseAll,
    bool? allowLegacyLearning,
    bool? allowAdvancedJourneys,
    bool? allowSecondaryExploration,
    bool? allowTrivia,
    bool? allowDiscovery,
    int? dailyGoal,
  }) {
    return ChildLearningPermissions(
      allowBrowseAll: allowBrowseAll ?? this.allowBrowseAll,
      allowLegacyLearning: allowLegacyLearning ?? this.allowLegacyLearning,
      allowAdvancedJourneys:
          allowAdvancedJourneys ?? this.allowAdvancedJourneys,
      allowSecondaryExploration:
          allowSecondaryExploration ?? this.allowSecondaryExploration,
      allowTrivia: allowTrivia ?? this.allowTrivia,
      allowDiscovery: allowDiscovery ?? this.allowDiscovery,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'allowBrowseAll': allowBrowseAll,
    'allowLegacyLearning': allowLegacyLearning,
    'allowAdvancedJourneys': allowAdvancedJourneys,
    'allowSecondaryExploration': allowSecondaryExploration,
    'allowTrivia': allowTrivia,
    'allowDiscovery': allowDiscovery,
    'dailyGoal': dailyGoal,
  };

  factory ChildLearningPermissions.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChildLearningPermissions.defaultsFor(LearningAgeGroup.kids);
    }
    return ChildLearningPermissions(
      allowBrowseAll: json['allowBrowseAll'] as bool? ?? false,
      allowLegacyLearning: json['allowLegacyLearning'] as bool? ?? false,
      allowAdvancedJourneys: json['allowAdvancedJourneys'] as bool? ?? false,
      allowSecondaryExploration:
          json['allowSecondaryExploration'] as bool? ?? false,
      allowTrivia: json['allowTrivia'] as bool? ?? true,
      allowDiscovery: json['allowDiscovery'] as bool? ?? true,
      dailyGoal: (json['dailyGoal'] as num?)?.toInt(),
    );
  }
}

class ChildLearningProfile {
  const ChildLearningProfile({
    required this.id,
    required this.displayName,
    required this.ageGroup,
    required this.learningLevel,
    required this.assignedPathId,
    required this.preferredLanguageTag,
    required this.avatarReference,
    required this.kidsUiThemeMode,
    this.ageBand = KidsAgeBand.core,
    required this.contentSafetyMode,
    required this.browsingMode,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String displayName;
  final LearningAgeGroup ageGroup;
  final LearningPathLevel learningLevel;
  final String assignedPathId;
  final String preferredLanguageTag;
  final String avatarReference;
  final KidsUiThemeMode kidsUiThemeMode;

  /// One of three bands a parent picks; see [KidsAgeBand].
  final KidsAgeBand ageBand;
  final ChildContentSafetyMode contentSafetyMode;
  final ChildBrowsingMode browsingMode;
  final ChildLearningPermissions permissions;
  final String createdAt;
  final String updatedAt;

  ChildLearningProfile copyWith({
    String? displayName,
    LearningAgeGroup? ageGroup,
    LearningPathLevel? learningLevel,
    String? assignedPathId,
    String? preferredLanguageTag,
    String? avatarReference,
    KidsUiThemeMode? kidsUiThemeMode,
    KidsAgeBand? ageBand,
    ChildContentSafetyMode? contentSafetyMode,
    ChildBrowsingMode? browsingMode,
    ChildLearningPermissions? permissions,
    String? updatedAt,
  }) {
    return ChildLearningProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      ageGroup: ageGroup ?? this.ageGroup,
      learningLevel: learningLevel ?? this.learningLevel,
      assignedPathId: assignedPathId ?? this.assignedPathId,
      preferredLanguageTag: preferredLanguageTag ?? this.preferredLanguageTag,
      avatarReference: avatarReference ?? this.avatarReference,
      kidsUiThemeMode: kidsUiThemeMode ?? this.kidsUiThemeMode,
      ageBand: ageBand ?? this.ageBand,
      contentSafetyMode: contentSafetyMode ?? this.contentSafetyMode,
      browsingMode: browsingMode ?? this.browsingMode,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get guidedOnly => browsingMode == ChildBrowsingMode.guidedOnly;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'displayName': displayName,
    'ageGroup': ageGroup.name,
    'learningLevel': learningLevel.name,
    'assignedPathId': assignedPathId,
    'preferredLanguageTag': preferredLanguageTag,
    'avatarReference': avatarReference,
    'kidsUiThemeMode': kidsUiThemeMode.name,
    'ageBand': ageBand.name,
    'contentSafetyMode': contentSafetyMode.name,
    'browsingMode': browsingMode.name,
    'permissions': permissions.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory ChildLearningProfile.fromJson(Map<String, dynamic> json) {
    return ChildLearningProfile(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      ageGroup: LearningAgeGroup.values.byName(
        json['ageGroup']?.toString() ?? LearningAgeGroup.kids.name,
      ),
      learningLevel: LearningPathLevel.values.byName(
        json['learningLevel']?.toString() ?? LearningPathLevel.beginner.name,
      ),
      assignedPathId: json['assignedPathId']?.toString() ?? '',
      preferredLanguageTag: json['preferredLanguageTag']?.toString() ?? 'en',
      avatarReference: json['avatarReference']?.toString() ?? '🌙',
      kidsUiThemeMode: KidsUiThemeMode.values.byName(
        json['kidsUiThemeMode']?.toString() ?? KidsUiThemeMode.auto.name,
      ),
      ageBand: KidsAgeBand.fromStorageName(json['ageBand']?.toString()),
      contentSafetyMode: ChildContentSafetyMode.values.byName(
        json['contentSafetyMode']?.toString() ??
            ChildContentSafetyMode.guided.name,
      ),
      browsingMode: ChildBrowsingMode.values.byName(
        json['browsingMode']?.toString() ?? ChildBrowsingMode.guidedOnly.name,
      ),
      permissions: ChildLearningPermissions.fromJson(
        (json['permissions'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      ),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class ParentChildLearningLink {
  const ParentChildLearningLink({
    required this.guardianProfileId,
    required this.childProfileId,
    required this.role,
    required this.createdAt,
  });

  final String guardianProfileId;
  final String childProfileId;
  final ParentChildLearningRole role;
  final String createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'guardianProfileId': guardianProfileId,
    'childProfileId': childProfileId,
    'role': role.name,
    'createdAt': createdAt,
  };

  factory ParentChildLearningLink.fromJson(Map<String, dynamic> json) {
    return ParentChildLearningLink(
      guardianProfileId: json['guardianProfileId']?.toString() ?? '',
      childProfileId: json['childProfileId']?.toString() ?? '',
      role: ParentChildLearningRole.values.byName(
        json['role']?.toString() ?? ParentChildLearningRole.guardian.name,
      ),
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class ChildLearningProgressState {
  const ChildLearningProgressState({
    required this.childProfileId,
    required this.completedJourneyIds,
    required this.completedJourneyCount,
    required this.totalJourneyCount,
    required this.currentPathId,
    required this.currentPhaseId,
    required this.currentJourneyId,
    required this.currentStageId,
    required this.currentStreakDays,
    required this.todayCompleted,
    required this.recommendationJourneyIds,
    this.recentCompletedStageId,
    this.lastActivityAt,
  });

  final String childProfileId;
  final Set<String> completedJourneyIds;
  final int completedJourneyCount;
  final int totalJourneyCount;
  final String? currentPathId;
  final String? currentPhaseId;
  final String? currentJourneyId;
  final String? currentStageId;
  final int currentStreakDays;
  final bool todayCompleted;
  final List<String> recommendationJourneyIds;
  final String? recentCompletedStageId;
  final String? lastActivityAt;

  double get progressValue =>
      totalJourneyCount == 0 ? 0 : completedJourneyCount / totalJourneyCount;
}

class FamilyLearningStoreState {
  const FamilyLearningStoreState({
    required this.groups,
    required this.childProfiles,
    required this.links,
  });

  final Map<String, FamilyLearningGroup> groups;
  final Map<String, ChildLearningProfile> childProfiles;
  final List<ParentChildLearningLink> links;

  factory FamilyLearningStoreState.initial() {
    return const FamilyLearningStoreState(
      groups: <String, FamilyLearningGroup>{},
      childProfiles: <String, ChildLearningProfile>{},
      links: <ParentChildLearningLink>[],
    );
  }

  FamilyLearningStoreState copyWith({
    Map<String, FamilyLearningGroup>? groups,
    Map<String, ChildLearningProfile>? childProfiles,
    List<ParentChildLearningLink>? links,
  }) {
    return FamilyLearningStoreState(
      groups: groups ?? this.groups,
      childProfiles: childProfiles ?? this.childProfiles,
      links: links ?? this.links,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'groups': groups.map((key, value) => MapEntry(key, value.toJson())),
    'childProfiles': childProfiles.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'links': links.map((item) => item.toJson()).toList(growable: false),
  };

  factory FamilyLearningStoreState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FamilyLearningStoreState.initial();
    }
    return FamilyLearningStoreState(
      groups: ((json['groups'] as Map?) ?? const <String, dynamic>{}).map(
        (key, value) => MapEntry(
          key.toString(),
          FamilyLearningGroup.fromJson(
            (value as Map).map((k, v) => MapEntry(k.toString(), v)),
          ),
        ),
      ),
      childProfiles:
          ((json['childProfiles'] as Map?) ?? const <String, dynamic>{}).map(
            (key, value) => MapEntry(
              key.toString(),
              ChildLearningProfile.fromJson(
                (value as Map).map((k, v) => MapEntry(k.toString(), v)),
              ),
            ),
          ),
      links: ((json['links'] as List?) ?? const <dynamic>[])
          .map(
            (item) => ParentChildLearningLink.fromJson(
              (item as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class FamilyLearningVisibilityPolicy {
  const FamilyLearningVisibilityPolicy({
    required this.isChildProfile,
    required this.isGuardianProfile,
    required this.guidedOnly,
    required this.showBrowseAll,
    required this.showLegacyLearning,
    required this.showAdvancedJourneys,
    required this.showSecondaryExploration,
    required this.showTrivia,
    required this.showDiscovery,
  });

  final bool isChildProfile;
  final bool isGuardianProfile;
  final bool guidedOnly;
  final bool showBrowseAll;
  final bool showLegacyLearning;
  final bool showAdvancedJourneys;
  final bool showSecondaryExploration;
  final bool showTrivia;
  final bool showDiscovery;

  bool get simplifyHome => isChildProfile;
}

class ActiveFamilyLearningContext {
  const ActiveFamilyLearningContext({
    required this.activeProfileId,
    required this.activeGuardianProfileId,
    required this.activeChildProfile,
    required this.familyGroup,
    required this.switchableProfileIds,
    required this.visibilityPolicy,
  });

  final String? activeProfileId;
  final String? activeGuardianProfileId;
  final ChildLearningProfile? activeChildProfile;
  final FamilyLearningGroup? familyGroup;
  final List<String> switchableProfileIds;
  final FamilyLearningVisibilityPolicy visibilityPolicy;

  bool get isChildProfile => activeChildProfile != null;
}
