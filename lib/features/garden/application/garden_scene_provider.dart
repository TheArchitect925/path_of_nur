import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../../shared/persistence/structured_data_scope.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../kids/bedtime_stories/application/bedtime_active_learner_service.dart';
import '../domain/garden_scene_models.dart';
import 'garden_scene_composer.dart';
import 'garden_service.dart';

final gardenSceneComposerProvider = Provider<GardenSceneComposer>((ref) {
  return const GardenSceneComposer();
});

/// Persists the last scene composition each learner acknowledged, so the
/// composer can diff "what appeared since last visit". Scope-keyed like the
/// ocean drops store so shared-device profiles never share celebrations.
class GardenSceneMementoRepository {
  const GardenSceneMementoRepository({
    required LocalStore store,
    required String scopeId,
  }) : _store = store,
       _scopeId = scopeId;

  final LocalStore _store;
  final String _scopeId;

  String keyForLearner(String learnerId) =>
      'garden.scene.lastSeen.v1.$_scopeId.$learnerId';

  GardenSceneMemento? read(String learnerId) {
    final json = _store.getJsonMap(keyForLearner(learnerId));
    if (json == null) {
      return null;
    }
    return GardenSceneMemento.fromJson(json);
  }

  Future<void> write(String learnerId, GardenSceneMemento memento) {
    return _store.setJsonMap(keyForLearner(learnerId), memento.toJson());
  }
}

final gardenSceneMementoRepositoryProvider =
    Provider<GardenSceneMementoRepository>((ref) {
      ref.watch(profileScopeVersionProvider);
      return GardenSceneMementoRepository(
        store: ref.watch(localStoreProvider),
        scopeId: ref.watch(structuredDataScopeProvider),
      );
    });

/// Bumped after every memento write so scene specs recompute and their
/// newly-appeared flags clear once the moment has been acknowledged.
final gardenSceneSeenVersionProvider = StateProvider<int>((ref) => 0);

final gardenSceneSpecProvider = Provider.family<GardenSceneSpec, String>((
  ref,
  learnerId,
) {
  ref.watch(gardenSceneSeenVersionProvider);
  final garden = ref.watch(gardenStateProvider(learnerId));
  final memento = ref
      .watch(gardenSceneMementoRepositoryProvider)
      .read(learnerId);
  return ref
      .watch(gardenSceneComposerProvider)
      .compose(garden: garden, lastSeen: memento);
});

final activeGardenSceneSpecProvider = Provider<GardenSceneSpec>((ref) {
  final learner = ref.watch(bedtimeActiveLearnerProvider);
  return ref.watch(gardenSceneSpecProvider(learner.learnerId));
});

/// Acknowledgement lifecycle. The vista calls [ensureBaseline] on first
/// build (silent — no celebration on a first visit, profile switch, or
/// restore) and [markSceneSeen] after the calm new-growth moment completes.
class GardenSceneSeenController {
  const GardenSceneSeenController(this._ref);

  final Ref _ref;

  Future<void> markSceneSeen(GardenSceneSpec spec, {DateTime? now}) async {
    final repository = _ref.read(gardenSceneMementoRepositoryProvider);
    await repository.write(
      spec.learnerId,
      GardenSceneMemento.fromSpec(
        spec,
        savedAtIso: (now ?? DateTime.now()).toIso8601String(),
      ),
    );
    _ref.read(gardenSceneSeenVersionProvider.notifier).state++;
  }

  /// Writes the memento only when none exists yet for this learner.
  Future<void> ensureBaseline(GardenSceneSpec spec, {DateTime? now}) async {
    final repository = _ref.read(gardenSceneMementoRepositoryProvider);
    if (repository.read(spec.learnerId) == null) {
      await markSceneSeen(spec, now: now);
    }
  }
}

final gardenSceneSeenControllerProvider = Provider<GardenSceneSeenController>((
  ref,
) {
  return GardenSceneSeenController(ref);
});
