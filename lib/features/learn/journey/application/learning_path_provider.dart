import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../onboarding/application/onboarding_preferences_provider.dart';
import '../../../onboarding/domain/onboarding_preferences.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import 'learning_journey_progress_provider.dart';

const _learningPathStateKey = 'learn.path.state.v1';

// Path state stays intentionally lightweight.
// Journey progress remains the source of truth for completion, while this store
// only keeps user-level guidance, adaptive hints, and manual path selection.

class LearningPathSelectionNotifier extends StateNotifier<UserLearningPathState?> {
  LearningPathSelectionNotifier(this._ref, this._store) : super(null) {
    _load();
  }

  final Ref _ref;
  final LocalStore _store;

  void _load() {
    final saved = UserLearningPathState.fromJson(
      _store.getJsonMap(_learningPathStateKey),
    );
    if (saved != null) {
      state = saved;
      return;
    }
    final onboarding = _ref.read(onboardingPreferencesProvider);
    final inferredLevel = onboarding == null
        ? null
        : _mapExperienceToLevel(onboarding.islamExperience);
    final inferredAgeGroup = onboarding == null
        ? LearningAgeGroup.adults
        : _mapLearningAgeGroup(onboarding.learningAgeGroup);
    if (inferredLevel == null) return;
    state = UserLearningPathState(
      selectedLevel: inferredLevel,
      ageGroup: inferredAgeGroup,
      currentPhaseId:
          LearningPathRegistry.pathForLevel(inferredLevel)?.phases.first.id ?? '',
      completedPhaseIds: const <String>{},
      activeJourneyIds: const <String>{},
    );
    _save();
  }

  void syncFromOnboardingProfile(
    OnboardingIslamExperience experience,
    OnboardingLearningAgeGroup ageGroup,
  ) {
    final level = _mapExperienceToLevel(experience);
    setLevel(level, ageGroup: _mapLearningAgeGroup(ageGroup));
  }

  void setLevel(
    LearningPathLevel level, {
    LearningAgeGroup? ageGroup,
  }) {
    final path = LearningPathRegistry.pathForLevel(level);
    if (path == null) return;
    final current = state;
    state = UserLearningPathState(
      selectedLevel: level,
      ageGroup: ageGroup ?? current?.ageGroup ?? LearningAgeGroup.adults,
      currentPhaseId: path.phases.first.id,
      completedPhaseIds: const <String>{},
      activeJourneyIds: const <String>{},
      secondaryExplorationIds: current?.secondaryExplorationIds ?? const <String>{},
      lastActivityTimestamp: DateTime.now().toIso8601String(),
      completionRate: current?.completionRate ?? 0,
      averageSessionDepth: current?.averageSessionDepth ?? 0,
    );
    _save();
  }

  void recordJourneyInteraction(String journeyId) {
    final current = state;
    if (current == null) return;
    final path = LearningPathRegistry.pathForLevel(current.selectedLevel);
    final inPrimaryPath = path?.phases.any(
      (phase) => phase.journeyIds.contains(journeyId),
    );
    final secondary = Set<String>.from(current.secondaryExplorationIds);
    if (inPrimaryPath == false) {
      secondary.remove(journeyId);
      secondary.add(journeyId);
      while (secondary.length > 4) {
        secondary.remove(secondary.first);
      }
    }
    state = UserLearningPathState(
      selectedLevel: current.selectedLevel,
      ageGroup: current.ageGroup,
      currentPhaseId: current.currentPhaseId,
      completedPhaseIds: current.completedPhaseIds,
      activeJourneyIds: current.activeJourneyIds,
      secondaryExplorationIds: secondary,
      lastActivityTimestamp: DateTime.now().toIso8601String(),
      completionRate: current.completionRate,
      averageSessionDepth: current.averageSessionDepth,
    );
    _save();
  }

  void syncProgressSignals() {
    final current = state;
    if (current == null) return;
    final progress = _ref.read(learningJourneyProgressProvider);
    final startedJourneys = progress.startedJourneyIds
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .toList(growable: false);
    final startedStageCount = startedJourneys.fold<int>(
      0,
      (sum, item) => sum + item.stageIds.length,
    );
    final completionRate = startedStageCount == 0
        ? 0.0
        : (progress.completedStageIds.length / startedStageCount).clamp(0.0, 1.0);
    final averageSessionDepth = startedJourneys.isEmpty
        ? 0.0
        : progress.completedStageIds.length / startedJourneys.length;
    state = UserLearningPathState(
      selectedLevel: current.selectedLevel,
      ageGroup: current.ageGroup,
      currentPhaseId: current.currentPhaseId,
      completedPhaseIds: current.completedPhaseIds,
      activeJourneyIds: current.activeJourneyIds,
      secondaryExplorationIds: current.secondaryExplorationIds,
      lastActivityTimestamp: DateTime.now().toIso8601String(),
      completionRate: completionRate,
      averageSessionDepth: averageSessionDepth,
    );
    _save();
  }

  void _save() {
    final current = state;
    if (current == null) return;
    _store.setJsonMap(_learningPathStateKey, current.toJson());
  }
}

final learningPathSelectionProvider =
    StateNotifierProvider<LearningPathSelectionNotifier, UserLearningPathState?>(
      (ref) => LearningPathSelectionNotifier(
        ref,
        ref.watch(localStoreProvider),
      ),
    );

class LearningPathResolvedState {
  const LearningPathResolvedState({
    required this.persistedState,
    required this.path,
    required this.ageGroup,
    required this.currentPhase,
    required this.completedPhaseIds,
    required this.completedJourneyIds,
    required this.currentPhaseJourneys,
    required this.activeJourneys,
    required this.phaseIndex,
    required this.secondaryJourneys,
    required this.completionRate,
    required this.averageSessionDepth,
    required this.lastActivityTimestamp,
  });

  final UserLearningPathState persistedState;
  final LearningPath path;
  final LearningAgeGroup ageGroup;
  final LearningPathPhase currentPhase;
  final Set<String> completedPhaseIds;
  final Set<String> completedJourneyIds;
  final List<LearningJourney> currentPhaseJourneys;
  final List<LearningJourney> activeJourneys;
  final int phaseIndex;
  final List<LearningJourney> secondaryJourneys;
  final double completionRate;
  final double averageSessionDepth;
  final String? lastActivityTimestamp;

  bool get isPathComplete =>
      completedPhaseIds.length >= path.phases.length && activeJourneys.isEmpty;

  int get totalPhases => path.phases.length;

  double get phaseProgress {
    if (currentPhaseJourneys.isEmpty) return 0.0;
    final completed = currentPhaseJourneys
        .where((journey) => completedJourneyIds.contains(journey.id))
        .length;
    return (completed / currentPhaseJourneys.length).clamp(0.0, 1.0);
  }

  LearningJourney? get primaryJourney =>
      activeJourneys.firstOrNull ?? currentPhaseJourneys.firstOrNull;

  bool containsJourney(String journeyId) {
    return path.phases.any((phase) => phase.journeyIds.contains(journeyId));
  }

  LearningPathPhase? phaseForJourney(String journeyId) {
    return path.phases.where((phase) => phase.journeyIds.contains(journeyId)).firstOrNull;
  }
}

final learningPathStateProvider = Provider<LearningPathResolvedState?>((ref) {
  final selected = ref.watch(learningPathSelectionProvider);
  if (selected == null) return null;
  final path = LearningPathRegistry.pathForLevel(selected.selectedLevel);
  if (path == null || path.phases.isEmpty) return null;
  final progress = ref.watch(learningJourneyProgressProvider);
  final completedJourneyIds = _completedJourneyIds(progress.completedStageIds);
  final completedPhases = <String>{};
  LearningPathPhase currentPhase = path.phases.first;

  for (final phase in path.phases) {
    final phaseComplete = phase.journeyIds.isNotEmpty &&
        phase.journeyIds.every(completedJourneyIds.contains);
    if (phaseComplete) {
      completedPhases.add(phase.id);
      continue;
    }
    currentPhase = phase;
    break;
  }

  if (completedPhases.length == path.phases.length) {
    currentPhase = path.phases.last;
  }

  final currentPhaseJourneys = currentPhase.journeyIds
      .map(LearningJourneyRegistry.journeyById)
      .whereType<LearningJourney>()
      .toList(growable: false);
  final activeJourneys = currentPhaseJourneys
      .where((journey) => !completedJourneyIds.contains(journey.id))
      .toList(growable: false);

  return LearningPathResolvedState(
    persistedState: UserLearningPathState(
      selectedLevel: selected.selectedLevel,
      ageGroup: selected.ageGroup,
      currentPhaseId: currentPhase.id,
      completedPhaseIds: completedPhases,
      activeJourneyIds: activeJourneys.map((item) => item.id).toSet(),
      secondaryExplorationIds: selected.secondaryExplorationIds,
      lastActivityTimestamp: selected.lastActivityTimestamp,
      completionRate: selected.completionRate,
      averageSessionDepth: selected.averageSessionDepth,
    ),
    path: path,
    ageGroup: selected.ageGroup,
    currentPhase: currentPhase,
    completedPhaseIds: completedPhases,
    completedJourneyIds: completedJourneyIds,
    currentPhaseJourneys: currentPhaseJourneys,
    activeJourneys: activeJourneys,
    phaseIndex: path.phases.indexWhere((phase) => phase.id == currentPhase.id),
    secondaryJourneys: selected.secondaryExplorationIds
        .map(LearningJourneyRegistry.journeyById)
        .whereType<LearningJourney>()
        .where((journey) => !path.phases.any((phase) => phase.journeyIds.contains(journey.id)))
        .toList(growable: false),
    completionRate: selected.completionRate,
    averageSessionDepth: selected.averageSessionDepth,
    lastActivityTimestamp: selected.lastActivityTimestamp,
  );
});

class LearningPathAdaptiveGuidance {
  const LearningPathAdaptiveGuidance({
    required this.recommendedJourneys,
    required this.secondaryJourneys,
    required this.personalizedTodayJourney,
    required this.shouldEaseLoad,
    required this.shouldSurfaceDepth,
    required this.fallbackJourneys,
    this.completedPhase,
    this.nextPhase,
    this.nextLevelPath,
  });

  final List<LearningJourney> recommendedJourneys;
  final List<LearningJourney> secondaryJourneys;
  final LearningJourney? personalizedTodayJourney;
  final bool shouldEaseLoad;
  final bool shouldSurfaceDepth;
  final List<LearningJourney> fallbackJourneys;
  final LearningPathPhase? completedPhase;
  final LearningPathPhase? nextPhase;
  final LearningPath? nextLevelPath;
}

final learningPathAdaptiveGuidanceProvider =
    Provider<LearningPathAdaptiveGuidance?>((ref) {
      final pathState = ref.watch(learningPathStateProvider);
      if (pathState == null) return null;
      final progress = ref.watch(learningJourneyProgressProvider);
      final currentJourney = progress.lastOpenedJourneyId == null
          ? null
          : LearningJourneyRegistry.journeyById(progress.lastOpenedJourneyId!);
      final shouldSurfaceDepth =
          pathState.completionRate >= 0.6 ||
          pathState.averageSessionDepth >= 1.75 ||
          progress.currentStreakDays >= 4;
      final shouldEaseLoad =
          pathState.completionRate <= 0.25 &&
          progress.startedJourneyIds.length >= 2 &&
          progress.currentStreakDays <= 1;

      final recommendationIds = <String>[];
      for (final journey in pathState.activeJourneys) {
        recommendationIds.add(journey.id);
      }

      if (currentJourney != null) {
        for (final id in _complementaryJourneyIds(currentJourney.id)) {
          if (!pathState.completedJourneyIds.contains(id)) {
            recommendationIds.add(id);
          }
        }
      }

      if (shouldSurfaceDepth) {
        final nextPhase = pathState.phaseIndex + 1 < pathState.path.phases.length
            ? pathState.path.phases[pathState.phaseIndex + 1]
            : null;
        if (nextPhase != null) {
          recommendationIds.addAll(nextPhase.journeyIds.take(2));
        }
      }

      if (shouldEaseLoad) {
        recommendationIds
          ..clear()
          ..addAll(_reinforcementJourneyIds(pathState));
      }
      final agePreferredIds = _agePreferredJourneyIds(pathState.ageGroup);
      recommendationIds.sort((a, b) {
        final rankA = agePreferredIds.contains(a) ? 0 : 1;
        final rankB = agePreferredIds.contains(b) ? 0 : 1;
        if (rankA != rankB) return rankA.compareTo(rankB);
        return a.compareTo(b);
      });

      final recommendations = recommendationIds
          .where((id) => !pathState.completedJourneyIds.contains(id))
          .toSet()
          .map(LearningJourneyRegistry.journeyById)
          .whereType<LearningJourney>()
          .take(4)
          .toList(growable: false);
      final fallbackJourneys = _adaptiveFallbackJourneys(pathState);

      final personalizedTodayJourney = _selectPersonalizedTodayJourney(
        pathState: pathState,
        progress: progress,
      );
      final completedPhase = pathState.phaseIndex > 0
          ? pathState.path.phases[pathState.phaseIndex - 1]
          : null;
      final nextPhase = pathState.phaseIndex + 1 < pathState.path.phases.length
          ? pathState.path.phases[pathState.phaseIndex + 1]
          : null;

      return LearningPathAdaptiveGuidance(
        recommendedJourneys: recommendations,
        secondaryJourneys: pathState.secondaryJourneys,
        personalizedTodayJourney: personalizedTodayJourney,
        shouldEaseLoad: shouldEaseLoad,
        shouldSurfaceDepth: shouldSurfaceDepth,
        fallbackJourneys: fallbackJourneys,
        completedPhase: completedPhase,
        nextPhase: nextPhase,
        nextLevelPath: pathState.isPathComplete
            ? LearningPathRegistry.pathForLevel(_nextLevel(pathState.path.level))
            : null,
      );
    });

LearningPathLevel _mapExperienceToLevel(
  OnboardingIslamExperience experience,
) {
  switch (experience) {
    case OnboardingIslamExperience.exploring:
    case OnboardingIslamExperience.newToIslam:
      return LearningPathLevel.beginner;
    case OnboardingIslamExperience.bornStillLearning:
      return LearningPathLevel.practicing;
    case OnboardingIslamExperience.practicingRegularly:
      return LearningPathLevel.seeker;
    case OnboardingIslamExperience.advanced:
      return LearningPathLevel.advanced;
  }
}

LearningAgeGroup _mapLearningAgeGroup(
  OnboardingLearningAgeGroup ageGroup,
) {
  switch (ageGroup) {
    case OnboardingLearningAgeGroup.kids:
      return LearningAgeGroup.kids;
    case OnboardingLearningAgeGroup.teens:
      return LearningAgeGroup.teens;
    case OnboardingLearningAgeGroup.adults:
      return LearningAgeGroup.adults;
  }
}

Set<String> _completedJourneyIds(Set<String> completedStageIds) {
  final completedJourneys = <String>{};
  for (final journey in LearningJourneyRegistry.journeys) {
    if (journey.stageIds.isNotEmpty &&
        journey.stageIds.every(completedStageIds.contains)) {
      completedJourneys.add(journey.id);
    }
  }
  return completedJourneys;
}

List<String> _complementaryJourneyIds(String journeyId) {
  switch (journeyId) {
    case 'salah-foundations':
      return const ['journey-of-wudu', 'understand-what-you-recite', 'daily-dhikr'];
    case 'journey-of-wudu':
      return const ['salah-foundations', 'duas-daily-life'];
    case 'journey-quran':
      return const ['understanding-al-fatihah', 'short-surahs', '100-quranic-words'];
    case 'understanding-al-fatihah':
      return const ['salah-foundations', 'short-surahs'];
    case 'reading-basics':
      return const ['100-quranic-words', 'understand-what-you-recite'];
    case 'hadith-essentials':
      return const ['beautiful-character', 'daily-wisdom'];
    case 'daily-dhikr':
      return const ['duas-daily-life', 'daily-routines'];
    default:
      return const ['journey-quran', 'beautiful-character'];
  }
}

List<String> _reinforcementJourneyIds(LearningPathResolvedState pathState) {
  if (pathState.ageGroup == LearningAgeGroup.kids) {
    return const [
      'prophets-journey',
      'salah-foundations',
      'duas-daily-life',
      'beautiful-character',
      'stories-signs',
    ];
  }
  if (pathState.ageGroup == LearningAgeGroup.teens) {
    return const [
      'beautiful-character',
      'seerah-journey',
      'hadith-essentials',
      'daily-wisdom',
      'salah-foundations',
    ];
  }
  if (pathState.path.level == LearningPathLevel.beginner) {
    return const [
      'islam-foundations',
      'salah-foundations',
      'understanding-al-fatihah',
      'beautiful-character',
    ];
  }
  if (pathState.path.level == LearningPathLevel.practicing) {
    return const [
      'daily-routines',
      'daily-dhikr',
      'journey-quran',
      'duas-daily-life',
    ];
  }
  return pathState.currentPhaseJourneys.map((item) => item.id).toList(growable: false);
}

LearningJourney? _selectPersonalizedTodayJourney({
  required LearningPathResolvedState pathState,
  required LearningJourneyProgressState progress,
}) {
  final agePreferredIds = _agePreferredJourneyIds(pathState.ageGroup);
  final currentJourney = progress.lastOpenedJourneyId == null
      ? null
      : LearningJourneyRegistry.journeyById(progress.lastOpenedJourneyId!);
  if (currentJourney != null &&
      pathState.path.phases.any((phase) => phase.journeyIds.contains(currentJourney.id))) {
    return currentJourney;
  }
  final agePreferredActive = pathState.activeJourneys
      .where((journey) => agePreferredIds.contains(journey.id))
      .toList(growable: false);
  if (agePreferredActive.isNotEmpty) {
    final seed = DateTime.now().weekday + DateTime.now().day;
    return agePreferredActive[seed % agePreferredActive.length];
  }
  if (pathState.activeJourneys.isNotEmpty) {
    final seed = DateTime.now().weekday + DateTime.now().day;
    return pathState.activeJourneys[seed % pathState.activeJourneys.length];
  }
  return pathState.currentPhaseJourneys.firstOrNull ??
      pathState.secondaryJourneys.firstOrNull;
}

List<LearningJourney> _adaptiveFallbackJourneys(
  LearningPathResolvedState pathState,
) {
  final fallbackIds = switch (pathState.ageGroup) {
    LearningAgeGroup.kids => const <String>[
      'prophets-journey',
      'beautiful-character',
      'stories-signs',
      'duas-daily-life',
      'salah-foundations',
    ],
    LearningAgeGroup.teens => const <String>[
      'beautiful-character',
      'seerah-journey',
      'daily-wisdom',
      'hadith-essentials',
      'journey-quran',
    ],
    LearningAgeGroup.adults => const <String>[
      'beautiful-character',
      'daily-wisdom',
      'stories-signs',
      'journey-quran',
      'duas-daily-life',
    ],
  };
  return fallbackIds
      .map(LearningJourneyRegistry.journeyById)
      .whereType<LearningJourney>()
      .where((journey) => !pathState.completedJourneyIds.contains(journey.id))
      .toList(growable: false);
}

Set<String> _agePreferredJourneyIds(LearningAgeGroup ageGroup) {
  switch (ageGroup) {
    case LearningAgeGroup.kids:
      return const <String>{
        'prophets-journey',
        'salah-foundations',
        'duas-daily-life',
        'daily-dhikr',
        'beautiful-character',
        'stories-signs',
      };
    case LearningAgeGroup.teens:
      return const <String>{
        'beautiful-character',
        'seerah-journey',
        'hadith-essentials',
        'daily-wisdom',
        'salah-foundations',
        'journey-quran',
      };
    case LearningAgeGroup.adults:
      return const <String>{};
  }
}

LearningPathLevel _nextLevel(LearningPathLevel level) {
  switch (level) {
    case LearningPathLevel.beginner:
      return LearningPathLevel.practicing;
    case LearningPathLevel.practicing:
      return LearningPathLevel.seeker;
    case LearningPathLevel.seeker:
      return LearningPathLevel.advanced;
    case LearningPathLevel.advanced:
      return LearningPathLevel.advanced;
  }
}
