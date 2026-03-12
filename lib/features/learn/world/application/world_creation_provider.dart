import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../data/world_creation_data.dart';
import '../domain/world_creation_models.dart';

const _worldCreationStoreKey = 'learn.world.creation.progress.v1';

class WorldCreationProgressNotifier
    extends StateNotifier<WorldCreationProgressState> {
  WorldCreationProgressNotifier(this._store, this._ref)
    : super(
        WorldCreationProgressState.fromJson(
          _store.getJsonMap(_worldCreationStoreKey),
        ),
      );

  final LocalStore _store;
  final Ref _ref;

  void openLesson(String lessonId) {
    final recent = List<String>.from(state.recentLessonIds)
      ..remove(lessonId)
      ..insert(0, lessonId);
    if (recent.length > 18) {
      recent.removeRange(18, recent.length);
    }
    state = state.copyWith(recentLessonIds: recent);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markStarted('world_creation:lesson:$lessonId');
  }

  void toggleSavedLesson(String lessonId) {
    final next = Set<String>.from(state.savedLessonIds);
    if (!next.remove(lessonId)) next.add(lessonId);
    state = state.copyWith(savedLessonIds: next);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .toggleSaved('world_creation:lesson:$lessonId');
  }

  void markLessonCompleted(String lessonId) {
    final completed = Set<String>.from(state.completedLessonIds)..add(lessonId);
    state = state.copyWith(completedLessonIds: completed);
    _persist();

    final progress = _ref.read(learnUnifiedProgressProvider.notifier);
    progress.markCompleted('world_creation:lesson:$lessonId');
    progress.markPracticed('world_creation:lesson:$lessonId');
  }

  void completeChallenge(String challengeId) {
    final completed = Set<String>.from(state.completedChallengeIds)
      ..add(challengeId);
    state = state.copyWith(completedChallengeIds: completed);
    _persist();

    final progress = _ref.read(learnUnifiedProgressProvider.notifier);
    progress.markCompleted('world_creation:challenge:$challengeId');
    progress.markReflected('world_creation:challenge:$challengeId');
  }

  void addObservation({
    required WorldCreationCategoryId category,
    required String verseReference,
    required String verseTextSnapshot,
    required String reflection,
    String? imagePath,
    String? locationName,
    List<String> tags = const <String>[],
    String? challengeId,
  }) {
    final trimmedReflection = reflection.trim();
    if (trimmedReflection.isEmpty) return;

    final observation = CreationObservation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      imagePath: imagePath?.trim().isEmpty == true ? null : imagePath?.trim(),
      category: category,
      verseReference: verseReference.trim(),
      verseTextSnapshot: verseTextSnapshot.trim(),
      userReflection: trimmedReflection,
      createdAtIso: DateTime.now().toIso8601String(),
      optionalLocationName: locationName?.trim().isEmpty == true
          ? null
          : locationName?.trim(),
      tags: tags,
      challengeId: challengeId,
      isFavorite: false,
    );

    state = state.copyWith(observations: [observation, ...state.observations]);
    _persist();

    final progress = _ref.read(learnUnifiedProgressProvider.notifier);
    progress.markReflected('world_creation:observation:${observation.id}');
    progress.setNote(
      'world_creation:observation:${observation.id}',
      trimmedReflection,
    );
  }

  void toggleObservationFavorite(String id) {
    final next = [
      for (final item in state.observations)
        if (item.id == id)
          item.copyWith(isFavorite: !item.isFavorite)
        else
          item,
    ];
    state = state.copyWith(observations: next);
    _persist();
  }

  void deleteObservation(String id) {
    final next = state.observations.where((item) => item.id != id).toList();
    state = state.copyWith(observations: next);
    _persist();
  }

  void markGuidedModeSession() {
    state = state.copyWith(guidedModeSessions: state.guidedModeSessions + 1);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markReflected('world_creation:guided_mode');
  }

  void markNightModeSession() {
    state = state.copyWith(nightModeSessions: state.nightModeSessions + 1);
    _persist();
    _ref
        .read(learnUnifiedProgressProvider.notifier)
        .markReflected('world_creation:night_mode');
  }

  void _persist() {
    _store.setJsonMap(_worldCreationStoreKey, state.toJson());
  }
}

final worldCreationProgressProvider =
    StateNotifierProvider<
      WorldCreationProgressNotifier,
      WorldCreationProgressState
    >(
      (ref) =>
          WorldCreationProgressNotifier(ref.watch(localStoreProvider), ref),
    );

final worldCreationCategoriesProvider = Provider<List<WorldCreationCategory>>((
  ref,
) {
  return worldCreationCategories;
});

final worldCreationLessonsProvider = Provider<List<WorldCreationLesson>>((ref) {
  return worldCreationLessons;
});

final worldCreationChallengesProvider = Provider<List<ObservationChallenge>>((
  ref,
) {
  return worldObservationChallenges;
});

final worldCreationScientistsProvider = Provider<List<ScientistProfile>>((ref) {
  return worldScientistProfiles;
});

final worldCreationLessonsForCategoryProvider =
    Provider.family<List<WorldCreationLesson>, WorldCreationCategoryId>((
      ref,
      categoryId,
    ) {
      return worldCreationLessonsForCategory(categoryId);
    });

final worldCreationProgressByCategoryProvider =
    Provider.family<double, WorldCreationCategoryId>((ref, categoryId) {
      final category = worldCreationCategoryById(categoryId);
      if (category == null || category.lessonIds.isEmpty) return 0;
      final completed = ref
          .watch(worldCreationProgressProvider)
          .completedLessonIds;
      var done = 0;
      for (final id in category.lessonIds) {
        if (completed.contains(id)) done += 1;
      }
      return (done / category.lessonIds.length).clamp(0.0, 1.0);
    });

final worldCreationRecentLessonsProvider = Provider<List<WorldCreationLesson>>((
  ref,
) {
  final recentIds = ref.watch(worldCreationProgressProvider).recentLessonIds;
  return recentIds
      .map(worldCreationLessonById)
      .whereType<WorldCreationLesson>()
      .toList(growable: false);
});

final worldDailySignProvider = Provider<WorldDailySign>((ref) {
  final now = DateTime.now();
  final seed = now.year * 372 + now.month * 31 + now.day;
  final featured = worldCreationLessons
      .where((lesson) => lesson.featured)
      .toList(growable: false);
  final pool = featured.isEmpty ? worldCreationLessons : featured;
  final lesson = pool[seed % pool.length];
  final verse = lesson.quranVerses.first;
  return WorldDailySign(
    lessonId: lesson.id,
    verse: verse,
    reflection: lesson.reflection,
    prompt: lesson.observationPrompt,
  );
});

final worldCreationSeasonalChallengesProvider =
    Provider<Map<String, List<ObservationChallenge>>>((ref) {
      final grouped = <String, List<ObservationChallenge>>{};
      for (final challenge in ref.watch(worldCreationChallengesProvider)) {
        grouped
            .putIfAbsent(challenge.seasonalTag, () => <ObservationChallenge>[])
            .add(challenge);
      }
      return grouped;
    });

final worldCreationAchievementsProvider = Provider<List<String>>((ref) {
  final state = ref.watch(worldCreationProgressProvider);
  final badges = <String>[];
  if (state.completedChallengeIds.length >= 3) badges.add('Sky Watcher');
  if (state.completedChallengeIds.length >= 6) badges.add('Nature Reflector');
  if (state.completedLessonIds.length >= 8) badges.add('Student of Creation');
  if (state.observations.length >= 5) badges.add('Seeker of Signs');
  if (state.nightModeSessions >= 3) badges.add('Night Observer');
  if (state.guidedModeSessions >= 4) badges.add('Cosmic Observer');
  return badges;
});

final worldCreationExploreDomainsProvider = Provider<List<(String, String)>>((
  ref,
) {
  return const [
    ('Universe', 'universeSpace'),
    ('Earth', 'earthNature'),
    ('Water', 'oceansWater'),
    ('Life', 'animalsLiving'),
    ('Time', 'timeCycles'),
    ('Weather', 'weatherPhenomena'),
  ];
});

final worldCreationSearchQueryProvider = StateProvider.autoDispose<String>((
  ref,
) {
  return '';
});

final worldCreationSearchResultsProvider =
    Provider.autoDispose<
      ({
        List<WorldCreationLesson> lessons,
        List<ObservationChallenge> challenges,
        List<ScientistProfile> scientists,
      })
    >((ref) {
      final query = ref
          .watch(worldCreationSearchQueryProvider)
          .trim()
          .toLowerCase();
      if (query.isEmpty) {
        return (
          lessons: const <WorldCreationLesson>[],
          challenges: const <ObservationChallenge>[],
          scientists: const <ScientistProfile>[],
        );
      }

      final lessons = worldCreationLessons
          .where((lesson) {
            final haystack = [
              lesson.title,
              lesson.summary,
              lesson.quranObservation,
              ...lesson.tags,
            ].join(' ').toLowerCase();
            return haystack.contains(query);
          })
          .toList(growable: false);

      final challenges = worldObservationChallenges
          .where((challenge) {
            final haystack = [
              challenge.title,
              challenge.prompt,
              challenge.reflectionPrompt,
            ].join(' ').toLowerCase();
            return haystack.contains(query);
          })
          .toList(growable: false);

      final scientists = worldScientistProfiles
          .where((profile) {
            final haystack = [
              profile.name,
              profile.discipline,
              profile.summary,
              ...profile.relatedTopics,
            ].join(' ').toLowerCase();
            return haystack.contains(query);
          })
          .toList(growable: false);

      return (lessons: lessons, challenges: challenges, scientists: scientists);
    });
