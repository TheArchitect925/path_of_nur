import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/learn_unified_models.dart';

const _qualityKey = 'learn.unified.quality.v1';
const _trackKey = 'learn.unified.track.v1';
const _bundleKey = 'learn.unified.bundles.v1';

class LearnQualityState {
  const LearnQualityState({required this.byLessonKey});

  final Map<String, LearnCompletionQuality> byLessonKey;

  Map<String, dynamic> toJson() => {
    for (final entry in byLessonKey.entries) entry.key: entry.value.name,
  };

  static LearnQualityState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LearnQualityState(byLessonKey: {});
    final map = <String, LearnCompletionQuality>{};
    for (final entry in json.entries) {
      final raw = entry.value?.toString();
      final value = LearnCompletionQuality.values.firstWhere(
        (item) => item.name == raw,
        orElse: () => LearnCompletionQuality.notRead,
      );
      map[entry.key] = value;
    }
    return LearnQualityState(byLessonKey: map);
  }
}

class LearnQualityNotifier extends StateNotifier<LearnQualityState> {
  LearnQualityNotifier(this._store)
    : super(LearnQualityState.fromJson(_store.getJsonMap(_qualityKey)));

  final LocalStore _store;

  LearnCompletionQuality qualityFor({
    required LearnDomainType domain,
    required String lessonId,
  }) {
    return state.byLessonKey['${domain.name}:$lessonId'] ??
        LearnCompletionQuality.notRead;
  }

  void setQuality({
    required LearnDomainType domain,
    required String lessonId,
    required LearnCompletionQuality quality,
  }) {
    final key = '${domain.name}:$lessonId';
    final map = Map<String, LearnCompletionQuality>.from(state.byLessonKey)
      ..[key] = quality;
    state = LearnQualityState(byLessonKey: map);
    _store.setJsonMap(_qualityKey, state.toJson());
  }
}

class LearnTrackSelectionNotifier extends StateNotifier<LearnTrackType> {
  LearnTrackSelectionNotifier(this._store) : super(_loadTrack(_store));

  final LocalStore _store;

  static LearnTrackType _loadTrack(LocalStore store) {
    final raw = store.getString(_trackKey);
    return LearnTrackType.values.firstWhere(
      (item) => item.name == raw,
      orElse: () => LearnTrackType.beginner,
    );
  }

  void setTrack(LearnTrackType track) {
    state = track;
    _store.setString(_trackKey, track.name);
  }
}

class LearnBundleManagerNotifier
    extends StateNotifier<List<LearnContentBundle>> {
  LearnBundleManagerNotifier(this._store) : super(_seedBundles()) {
    _load();
  }

  final LocalStore _store;

  static List<LearnContentBundle> _seedBundles() {
    return const [
      LearnContentBundle(
        id: 'quran-core',
        title: 'Qur\'an Core',
        description: 'Reader, search, notes, and structured ayah metadata.',
        version: 1,
        installed: true,
        sizeLabel: '9 MB',
        futureRemoteCompatible: true,
      ),
      LearnContentBundle(
        id: 'life-curriculum',
        title: 'Life Curriculum',
        description: 'Themes, subcategories, and practical life lessons.',
        version: 1,
        installed: true,
        sizeLabel: '4 MB',
        futureRemoteCompatible: true,
      ),
      LearnContentBundle(
        id: 'world-curriculum',
        title: 'World Curriculum',
        description: 'Observation-based world lessons and reflection prompts.',
        version: 1,
        installed: true,
        sizeLabel: '4 MB',
        futureRemoteCompatible: true,
      ),
      LearnContentBundle(
        id: 'hadith-curriculum',
        title: 'Hadith Curriculum',
        description: 'Thematic hadith lessons and cross-domain links.',
        version: 1,
        installed: true,
        sizeLabel: '5 MB',
        futureRemoteCompatible: true,
      ),
      LearnContentBundle(
        id: 'seasonal-ramadan',
        title: 'Seasonal: Ramadan',
        description: 'Season-focused path hooks and suggested lessons.',
        version: 1,
        installed: false,
        sizeLabel: '2 MB',
        futureRemoteCompatible: true,
      ),
    ];
  }

  void toggleInstalled(String bundleId) {
    state = [
      for (final bundle in state)
        if (bundle.id == bundleId)
          bundle.copyWith(installed: !bundle.installed)
        else
          bundle,
    ];
    _save();
  }

  void _load() {
    final data = _store.getJsonList(_bundleKey);
    if (data == null) return;
    final installedById = <String, bool>{};
    for (final row in data) {
      if (row is! Map) continue;
      final id = row['id']?.toString();
      final installed = row['installed'] == true;
      if (id != null) installedById[id] = installed;
    }
    state = [
      for (final bundle in state)
        bundle.copyWith(
          installed: installedById[bundle.id] ?? bundle.installed,
        ),
    ];
  }

  void _save() {
    _store.setJsonList(_bundleKey, [
      for (final bundle in state)
        {
          'id': bundle.id,
          'installed': bundle.installed,
          'version': bundle.version,
        },
    ]);
  }
}

final learnQualityProvider =
    StateNotifierProvider<LearnQualityNotifier, LearnQualityState>(
      (ref) => LearnQualityNotifier(ref.watch(localStoreProvider)),
    );

final learnTrackProvider =
    StateNotifierProvider<LearnTrackSelectionNotifier, LearnTrackType>(
      (ref) => LearnTrackSelectionNotifier(ref.watch(localStoreProvider)),
    );

final learnBundlesProvider =
    StateNotifierProvider<LearnBundleManagerNotifier, List<LearnContentBundle>>(
      (ref) => LearnBundleManagerNotifier(ref.watch(localStoreProvider)),
    );

final learnTrackTitlesProvider = Provider<Map<LearnTrackType, String>>((ref) {
  return const {
    LearnTrackType.beginner: 'Beginner',
    LearnTrackType.family: 'Family',
    LearnTrackType.character: 'Character',
    LearnTrackType.ramadan: 'Ramadan',
    LearnTrackType.revert: 'Revert',
  };
});
