import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../../shared/domain/learn_system_models.dart';
import '../data/learning_path_sequence_registry.dart';
import '../domain/learning_personalization_models.dart';

class LearningRecommendationEngine {
  const LearningRecommendationEngine();

  LearningPersonalizationSummary build({
    required LearningSignals signals,
    required List<GuidedLearningPath> visiblePaths,
  }) {
    final visiblePathsById = <String, GuidedLearningPath>{
      for (final path in visiblePaths) path.id: path,
    };
    final profile = _buildProfile(
      LearningPathRecommendationContext(
        signals: signals,
        visiblePathsById: visiblePathsById,
      ),
    );
    final primary = _buildPrimaryRecommendation(
      context: LearningPathRecommendationContext(
        signals: signals,
        visiblePathsById: visiblePathsById,
      ),
      profile: profile,
    );
    final secondary = _buildSecondarySuggestions(
      context: LearningPathRecommendationContext(
        signals: signals,
        visiblePathsById: visiblePathsById,
      ),
      profile: profile,
      primary: primary,
    );
    return LearningPersonalizationSummary(
      profile: profile,
      primaryRecommendation: primary,
      secondarySuggestions: secondary,
    );
  }

  UserLearningProfile _buildProfile(LearningPathRecommendationContext context) {
    final signals = context.signals;
    final scores = <LearningIntentSignal, int>{};

    void addScore(LearningIntentSignal intent, int score) {
      scores.update(intent, (value) => value + score, ifAbsent: () => score);
    }

    if (signals.isChildProfile) {
      addScore(LearningIntentSignal.kids, 80);
    }

    for (
      var index = 0;
      index < signals.recentLearnDomains.length && index < 6;
      index++
    ) {
      final weight = 18 - (index * 2);
      addScore(_intentForDomain(signals.recentLearnDomains[index]), weight);
    }

    if (signals.activePathId != null) {
      final activePath = context.visiblePathsById[signals.activePathId];
      if (activePath != null) {
        addScore(_intentForPath(activePath), 28);
      }
    }

    for (final pathId in signals.completedPathIds) {
      final path = context.visiblePathsById[pathId];
      if (path == null) continue;
      addScore(_intentForPath(path), 12);
    }

    if (signals.quranReadingCountLast7Days > 0 ||
        signals.quranReadingSecondsToday > 0 ||
        signals.quranHasPersonalizationSignals) {
      addScore(
        LearningIntentSignal.quran,
        18 +
            (signals.quranReadingCountLast7Days.clamp(0, 5) * 2) +
            (signals.quranReadingSecondsToday > 0 ? 6 : 0),
      );
    }

    if (signals.dhikrSessionsLast7Days > 0) {
      addScore(
        LearningIntentSignal.worship,
        14 + signals.dhikrSessionsLast7Days.clamp(0, 4) * 2,
      );
    }

    if (signals.salahActivityCount > 0) {
      addScore(
        LearningIntentSignal.worship,
        10 + signals.salahActivityCount.clamp(0, 4) * 2,
      );
    }

    if (signals.learnNotesCount > 0 || signals.learnSavedCount > 0) {
      addScore(LearningIntentSignal.character, 4);
      addScore(LearningIntentSignal.foundations, 4);
    }

    if (scores.isEmpty) {
      addScore(
        signals.isChildProfile
            ? LearningIntentSignal.kids
            : LearningIntentSignal.foundations,
        10,
      );
    }

    final sortedIntents = scores.entries.toList(growable: false)
      ..sort((a, b) => b.value.compareTo(a.value));
    final primaryIntent = sortedIntents.first.key;
    final secondaryIntents = sortedIntents
        .skip(1)
        .map((entry) => entry.key)
        .where((intent) => intent != primaryIntent)
        .take(2)
        .toList(growable: false);

    return UserLearningProfile(
      engagementState: _engagementState(signals),
      primaryIntent: primaryIntent,
      secondaryIntents: secondaryIntents,
      hasHistory: signals.hasHistory,
      isChildProfile: signals.isChildProfile,
      lastLearnActivityAt: signals.lastLearnActivityAt,
    );
  }

  PersonalizedLearnRecommendation _buildPrimaryRecommendation({
    required LearningPathRecommendationContext context,
    required UserLearningProfile profile,
  }) {
    final signals = context.signals;
    final visiblePathsById = context.visiblePathsById;

    if (signals.activePathId != null && signals.activeStepId != null) {
      final activePath = visiblePathsById[signals.activePathId];
      final nextStep = activePath?.steps
          .where((step) => step.id == signals.activeStepId)
          .firstOrNull;
      if (activePath != null && nextStep != null) {
        return PersonalizedLearnRecommendation(
          kind: LearningRecommendationKind.continueGuidedPathStep,
          reason: LearningRecommendationReason.activeGuidedPath,
          contextTag: LearningRecommendationContextTag.momentum,
          pathId: activePath.id,
          stepId: nextStep.id,
          routeTarget: LearningRecommendationRouteTarget(
            routeName: nextStep.routeTarget.routeName,
            pathParameters: nextStep.routeTarget.pathParameters,
            queryParameters: nextStep.routeTarget.queryParameters,
          ),
        );
      }
    }

    final latestCompletedPathId = _latestCompletedPathId(signals);
    final latestCompletedPath = latestCompletedPathId == null
        ? null
        : visiblePathsById[latestCompletedPathId];
    if (latestCompletedPath != null) {
      for (final nextPathId in _sequencedNextPathsFor(latestCompletedPath.id)) {
        if (signals.completedPathIds.contains(nextPathId)) continue;
        final nextPath = visiblePathsById[nextPathId];
        if (nextPath == null) continue;
        return _pathRecommendation(
          pathId: nextPath.id,
          reason: LearningRecommendationReason.sequencedAfterCompletion,
          contextTag: LearningRecommendationContextTag.momentum,
        );
      }
    }

    if (signals.isChildProfile &&
        visiblePathsById.containsKey('kids-starter')) {
      return _pathRecommendation(
        pathId: 'kids-starter',
        reason: LearningRecommendationReason.kidsProfile,
      );
    }

    if (signals.ramadanModeEnabled) {
      final ramadanPathId =
          signals.quranReadingCountLast7Days >= signals.dhikrSessionsLast7Days
          ? 'quran-beginner-starter'
          : 'daily-dhikr-starter';
      if (!signals.completedPathIds.contains(ramadanPathId) &&
          visiblePathsById.containsKey(ramadanPathId)) {
        return _pathRecommendation(
          pathId: ramadanPathId,
          reason: LearningRecommendationReason.ramadanRhythm,
          contextTag: LearningRecommendationContextTag.ramadan,
        );
      }
    }

    if (signals.isFriday &&
        signals.quranReadingCountLast7Days > 0 &&
        !signals.completedPathIds.contains('quran-beginner-starter') &&
        visiblePathsById.containsKey('quran-beginner-starter')) {
      return _pathRecommendation(
        pathId: 'quran-beginner-starter',
        reason: LearningRecommendationReason.fridayRhythm,
        contextTag: LearningRecommendationContextTag.friday,
      );
    }

    final resumablePathId = _mostRecentStartedIncompletePathId(signals);
    if (resumablePathId != null &&
        visiblePathsById.containsKey(resumablePathId)) {
      return PersonalizedLearnRecommendation(
        kind: LearningRecommendationKind.resumeGuidedPath,
        reason: profile.engagementState == LearningEngagementState.dormant
            ? LearningRecommendationReason.inactiveReentry
            : LearningRecommendationReason.keepMomentum,
        pathId: resumablePathId,
        routeTarget: LearningRecommendationRouteTarget(
          routeName: 'learnGuidedPathDetail',
          pathParameters: <String, String>{'pathId': resumablePathId},
        ),
      );
    }

    if (signals.quranReadingCountLast7Days >= 2 ||
        signals.quranReadingSecondsToday > 0 ||
        signals.quranHasPersonalizationSignals) {
      final quranPathId = _firstAvailablePathId(
        preferredPathIds: const <String>[
          'quran-beginner-starter',
          'character-starter',
        ],
        visiblePathsById: visiblePathsById,
        completedPathIds: signals.completedPathIds,
      );
      if (quranPathId != null) {
        return _pathRecommendation(
          pathId: quranPathId,
          reason: LearningRecommendationReason.quranMomentum,
        );
      }
    }

    if (signals.dhikrSessionsLast7Days >= 2) {
      final dhikrPathId = _firstAvailablePathId(
        preferredPathIds: const <String>[
          'daily-dhikr-starter',
          'salah-starter',
        ],
        visiblePathsById: visiblePathsById,
        completedPathIds: signals.completedPathIds,
      );
      if (dhikrPathId != null) {
        return _pathRecommendation(
          pathId: dhikrPathId,
          reason: LearningRecommendationReason.dhikrMomentum,
        );
      }
    }

    if (signals.salahActivityCount >= 2) {
      final salahPathId = _firstAvailablePathId(
        preferredPathIds: const <String>[
          'salah-starter',
          'daily-dhikr-starter',
        ],
        visiblePathsById: visiblePathsById,
        completedPathIds: signals.completedPathIds,
      );
      if (salahPathId != null) {
        return _pathRecommendation(
          pathId: salahPathId,
          reason: LearningRecommendationReason.salahMomentum,
        );
      }
    }

    if (!profile.hasHistory &&
        visiblePathsById.containsKey('foundations-starter')) {
      return _pathRecommendation(
        pathId: profile.isChildProfile ? 'kids-starter' : 'foundations-starter',
        reason: profile.isChildProfile
            ? LearningRecommendationReason.kidsProfile
            : LearningRecommendationReason.noHistory,
      );
    }

    if (profile.engagementState == LearningEngagementState.dormant) {
      final reentryPathId = _firstAvailablePathId(
        preferredPathIds: profile.isChildProfile
            ? const <String>['kids-starter']
            : const <String>['daily-dhikr-starter', 'foundations-starter'],
        visiblePathsById: visiblePathsById,
        completedPathIds: const <String>{},
      );
      if (reentryPathId != null) {
        return _pathRecommendation(
          pathId: reentryPathId,
          reason: LearningRecommendationReason.inactiveReentry,
        );
      }
    }

    final intentDrivenPathId = _firstAvailablePathId(
      preferredPathIds: _preferredPathIdsForIntents(profile),
      visiblePathsById: visiblePathsById,
      completedPathIds: signals.completedPathIds,
    );
    if (intentDrivenPathId != null) {
      return _pathRecommendation(
        pathId: intentDrivenPathId,
        reason: profile.engagementState == LearningEngagementState.active
            ? LearningRecommendationReason.keepMomentum
            : LearningRecommendationReason.safeFallback,
      );
    }

    final anyPath = visiblePathsById.keys.first;
    return _pathRecommendation(
      pathId: anyPath,
      reason: LearningRecommendationReason.safeFallback,
    );
  }

  List<PathSuggestion> _buildSecondarySuggestions({
    required LearningPathRecommendationContext context,
    required UserLearningProfile profile,
    required PersonalizedLearnRecommendation primary,
  }) {
    final signals = context.signals;
    final visiblePathsById = context.visiblePathsById;
    final suggestions = <PathSuggestion>[];
    final seenIds = <String>{if (primary.pathId != null) primary.pathId!};

    void addSuggestion(String? pathId, LearningRecommendationReason reason) {
      if (pathId == null || pathId.isEmpty) return;
      if (!visiblePathsById.containsKey(pathId)) return;
      if (!seenIds.add(pathId)) return;
      suggestions.add(PathSuggestion(pathId: pathId, reason: reason));
    }

    if (primary.pathId != null) {
      for (final sequencedPathId in _sequencedNextPathsFor(primary.pathId!)) {
        if (signals.completedPathIds.contains(sequencedPathId)) continue;
        addSuggestion(
          sequencedPathId,
          LearningRecommendationReason.sequencedAfterCompletion,
        );
      }
    }

    for (final pathId in _preferredPathIdsForIntents(profile)) {
      if (signals.completedPathIds.contains(pathId)) continue;
      addSuggestion(
        pathId,
        profile.engagementState == LearningEngagementState.active
            ? LearningRecommendationReason.keepMomentum
            : LearningRecommendationReason.safeFallback,
      );
      if (suggestions.length >= 2) break;
    }

    if (signals.quranReadingCountLast7Days > 0) {
      addSuggestion(
        'quran-beginner-starter',
        LearningRecommendationReason.quranMomentum,
      );
    }
    if (signals.dhikrSessionsLast7Days > 0) {
      addSuggestion(
        'daily-dhikr-starter',
        LearningRecommendationReason.dhikrMomentum,
      );
    }
    if (signals.salahActivityCount > 0) {
      addSuggestion(
        'salah-starter',
        LearningRecommendationReason.salahMomentum,
      );
    }

    return suggestions.take(2).toList(growable: false);
  }

  PersonalizedLearnRecommendation _pathRecommendation({
    required String pathId,
    required LearningRecommendationReason reason,
    LearningRecommendationContextTag? contextTag,
  }) {
    return PersonalizedLearnRecommendation(
      kind: LearningRecommendationKind.startGuidedPath,
      reason: reason,
      contextTag: contextTag,
      pathId: pathId,
      routeTarget: LearningRecommendationRouteTarget(
        routeName: 'learnGuidedPathDetail',
        pathParameters: <String, String>{'pathId': pathId},
      ),
    );
  }

  LearningEngagementState _engagementState(LearningSignals signals) {
    if (!signals.hasHistory) {
      return LearningEngagementState.newLearner;
    }
    final lastActivityAt = signals.lastLearnActivityAt;
    if (lastActivityAt == null) {
      return LearningEngagementState.returning;
    }
    final daysSinceActivity = signals.now.difference(lastActivityAt).inDays;
    if (daysSinceActivity <= 4) {
      return LearningEngagementState.active;
    }
    if (daysSinceActivity <= 21) {
      return LearningEngagementState.returning;
    }
    return LearningEngagementState.dormant;
  }

  LearningIntentSignal _intentForDomain(LearnUnifiedDomain domain) {
    switch (domain) {
      case LearnUnifiedDomain.quran:
        return LearningIntentSignal.quran;
      case LearnUnifiedDomain.hadith:
      case LearnUnifiedDomain.lifeLessons:
        return LearningIntentSignal.character;
      case LearnUnifiedDomain.prophets:
        return LearningIntentSignal.stories;
      case LearnUnifiedDomain.salah:
      case LearnUnifiedDomain.namesOfAllah:
        return LearningIntentSignal.worship;
      case LearnUnifiedDomain.quizzes:
        return LearningIntentSignal.games;
      case LearnUnifiedDomain.babyNames:
      case LearnUnifiedDomain.notes:
        return LearningIntentSignal.foundations;
    }
  }

  LearningIntentSignal _intentForPath(GuidedLearningPath path) {
    switch (path.id) {
      case 'quran-beginner-starter':
        return LearningIntentSignal.quran;
      case 'salah-starter':
      case 'daily-dhikr-starter':
        return LearningIntentSignal.worship;
      case 'character-starter':
        return LearningIntentSignal.character;
      case 'kids-starter':
        return LearningIntentSignal.kids;
      case 'foundations-starter':
        return LearningIntentSignal.foundations;
    }
    switch (path.bucketId) {
      case 'quran':
        return LearningIntentSignal.quran;
      case 'worship':
        return LearningIntentSignal.worship;
      case 'character':
        return LearningIntentSignal.character;
      case 'stories':
        return LearningIntentSignal.stories;
      case 'games':
        return LearningIntentSignal.games;
      case 'kids':
        return LearningIntentSignal.kids;
      case 'foundations':
        return LearningIntentSignal.foundations;
    }
    return LearningIntentSignal.general;
  }

  String? _latestCompletedPathId(LearningSignals signals) {
    String? latestPathId;
    DateTime? latestCompletedAt;
    for (final entry in signals.pathCompletedAtById.entries) {
      if (latestCompletedAt == null || entry.value.isAfter(latestCompletedAt)) {
        latestCompletedAt = entry.value;
        latestPathId = entry.key;
      }
    }
    return latestPathId;
  }

  String? _mostRecentStartedIncompletePathId(LearningSignals signals) {
    String? latestPathId;
    DateTime? latestUpdatedAt;
    for (final pathId in signals.startedPathIds) {
      if (pathId == signals.activePathId) continue;
      if (signals.completedPathIds.contains(pathId)) continue;
      final updatedAt = signals.pathLastUpdatedAtById[pathId];
      if (updatedAt == null) continue;
      if (latestUpdatedAt == null || updatedAt.isAfter(latestUpdatedAt)) {
        latestUpdatedAt = updatedAt;
        latestPathId = pathId;
      }
    }
    return latestPathId;
  }

  List<String> _sequencedNextPathsFor(String pathId) {
    for (final definition in kLearningPathSequenceDefinitions) {
      if (definition.pathId == pathId) {
        return definition.nextPathIds;
      }
    }
    return const <String>[];
  }

  List<String> _preferredPathIdsForIntents(UserLearningProfile profile) {
    final pathIds = <String>[];
    final intents = <LearningIntentSignal>[
      profile.primaryIntent,
      ...profile.secondaryIntents,
      LearningIntentSignal.general,
    ];
    for (final intent in intents) {
      for (final pathId in kLearningIntentDefaultPathIds[intent] ?? const []) {
        if (!pathIds.contains(pathId)) {
          pathIds.add(pathId);
        }
      }
    }
    return pathIds;
  }

  String? _firstAvailablePathId({
    required List<String> preferredPathIds,
    required Map<String, GuidedLearningPath> visiblePathsById,
    required Set<String> completedPathIds,
  }) {
    for (final pathId in preferredPathIds) {
      if (completedPathIds.contains(pathId)) continue;
      if (!visiblePathsById.containsKey(pathId)) continue;
      return pathId;
    }
    return null;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
