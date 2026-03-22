import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../bedtime_stories/application/bedtime_active_learner_service.dart';
import '../domain/kids_activity_models.dart';

String kidsActivityLogStorageKeyForLearner(String learnerId) =>
    'kids.activity_log.v1.$learnerId';

final kidsActivityLogProvider =
    StateNotifierProvider<KidsActivityLogController, KidsActivityLogState>((
      ref,
    ) {
      final controller = KidsActivityLogController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (_, nextLearnerId) => controller.updateActiveLearner(nextLearnerId),
      );
      return controller;
    });

class KidsActivityLogController extends StateNotifier<KidsActivityLogState> {
  KidsActivityLogController(Ref ref)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        KidsActivityLogState.fromJson(
          ref.read(localStoreProvider).getJsonMap(
            kidsActivityLogStorageKeyForLearner(
              ref.read(bedtimeActiveLearnerProvider).learnerId,
            ),
          ),
        ),
      );

  static const int _maxEntries = 240;

  final LocalStore _store;
  String _activeLearnerId;

  void updateActiveLearner(String learnerId) {
    if (_activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = KidsActivityLogState.fromJson(
      _store.getJsonMap(kidsActivityLogStorageKeyForLearner(learnerId)),
    );
  }

  void log({
    required KidsActivityType type,
    required KidsActivityDomain domain,
    required String sourceRef,
    String? contentId,
    String? titleSnapshot,
    String? subtitleSnapshot,
    Map<String, Object?> metadata = const <String, Object?>{},
    DateTime? occurredAt,
    Duration dedupeWindow = Duration.zero,
  }) {
    final now = occurredAt ?? DateTime.now();
    if (_isDuplicate(
      sourceRef: sourceRef,
      type: type,
      domain: domain,
      contentId: contentId,
      occurredAt: now,
      dedupeWindow: dedupeWindow,
    )) {
      return;
    }

    final entry = KidsActivityEntry(
      id:
          '${now.microsecondsSinceEpoch}_${type.name}_${contentId ?? sourceRef}',
      learnerId: _activeLearnerId,
      occurredAtIso: now.toIso8601String(),
      type: type,
      domain: domain,
      sourceRef: sourceRef,
      contentId: contentId,
      titleSnapshot: titleSnapshot,
      subtitleSnapshot: subtitleSnapshot,
      metadata: <String, Object?>{
        ...metadata,
        'learnerId': _activeLearnerId,
      },
    );

    final nextEntries = <KidsActivityEntry>[
      entry,
      ...state.entries.where((item) => item.id != entry.id),
    ];
    if (nextEntries.length > _maxEntries) {
      nextEntries.removeRange(_maxEntries, nextEntries.length);
    }
    state = state.copyWith(entries: nextEntries);
    _persist();
  }

  List<KidsActivityEntry> recentActivities({
    int limit = 12,
    Set<KidsActivityDomain>? domains,
    Set<KidsActivityType>? types,
  }) {
    return state.entries
        .where((item) => domains == null || domains.contains(item.domain))
        .where((item) => types == null || types.contains(item.type))
        .take(limit)
        .toList(growable: false);
  }

  KidsActivityEntry? mostRecentActivity({
    Set<KidsActivityDomain>? domains,
    Set<KidsActivityType>? types,
  }) {
    final recent = recentActivities(limit: 1, domains: domains, types: types);
    return recent.isEmpty ? null : recent.first;
  }

  KidsActivityEntry? lastActivityForContent({
    required KidsActivityDomain domain,
    required String contentId,
    Set<KidsActivityType>? types,
  }) {
    for (final entry in state.entries) {
      if (entry.domain != domain || entry.contentId != contentId) {
        continue;
      }
      if (types != null && !types.contains(entry.type)) {
        continue;
      }
      return entry;
    }
    return null;
  }

  bool _isDuplicate({
    required String sourceRef,
    required KidsActivityType type,
    required KidsActivityDomain domain,
    required String? contentId,
    required DateTime occurredAt,
    required Duration dedupeWindow,
  }) {
    if (dedupeWindow <= Duration.zero) {
      return false;
    }
    for (final entry in state.entries) {
      if (entry.sourceRef != sourceRef &&
          !(entry.type == type &&
              entry.domain == domain &&
              entry.contentId == contentId)) {
        continue;
      }
      final previousTime = DateTime.tryParse(entry.occurredAtIso);
      if (previousTime == null) {
        continue;
      }
      if (occurredAt.difference(previousTime).abs() <= dedupeWindow) {
        return true;
      }
      break;
    }
    return false;
  }

  void _persist() {
    _store.setJsonMap(
      kidsActivityLogStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }
}
