import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../../shared/persistence/local_store.dart';
import '../data/learn_content_catalog.dart';
import '../domain/learn_topic_category.dart';

class LearnTopicProgress {
  const LearnTopicProgress({
    required this.topicId,
    required this.category,
    required this.started,
    required this.completed,
    required this.saved,
    required this.favorite,
    required this.reflectionProgress,
    required this.lastOpenedIso,
    required this.resumedCount,
  });

  final String topicId;
  final LearnTopicCategory category;
  final bool started;
  final bool completed;
  final bool saved;
  final bool favorite;
  final double reflectionProgress;
  final String? lastOpenedIso;
  final int resumedCount;

  LearnTopicProgress copyWith({
    bool? started,
    bool? completed,
    bool? saved,
    bool? favorite,
    double? reflectionProgress,
    String? lastOpenedIso,
    int? resumedCount,
  }) {
    return LearnTopicProgress(
      topicId: topicId,
      category: category,
      started: started ?? this.started,
      completed: completed ?? this.completed,
      saved: saved ?? this.saved,
      favorite: favorite ?? this.favorite,
      reflectionProgress: reflectionProgress ?? this.reflectionProgress,
      lastOpenedIso: lastOpenedIso ?? this.lastOpenedIso,
      resumedCount: resumedCount ?? this.resumedCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'topicId': topicId,
    'category': category.name,
    'started': started,
    'completed': completed,
    'saved': saved,
    'favorite': favorite,
    'reflectionProgress': reflectionProgress,
    'lastOpenedIso': lastOpenedIso,
    'resumedCount': resumedCount,
  };

  static LearnTopicProgress? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final topicId = raw['topicId']?.toString();
    final categoryName = raw['category']?.toString();
    if (topicId == null || categoryName == null) return null;

    LearnTopicCategory? category;
    for (final item in LearnTopicCategory.values) {
      if (item.name == categoryName) {
        category = item;
        break;
      }
    }
    if (category == null) return null;

    final reflection = raw['reflectionProgress'];
    return LearnTopicProgress(
      topicId: topicId,
      category: category,
      started: raw['started'] == true,
      completed: raw['completed'] == true,
      saved: raw['saved'] == true,
      favorite: raw['favorite'] == true,
      reflectionProgress: reflection is num
          ? reflection.toDouble().clamp(0.0, 1.0)
          : 0.0,
      lastOpenedIso: raw['lastOpenedIso']?.toString(),
      resumedCount: (raw['resumedCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class LearnProgressState {
  const LearnProgressState({required this.byTopicId});

  final Map<String, LearnTopicProgress> byTopicId;

  LearnProgressState copyWith({Map<String, LearnTopicProgress>? byTopicId}) {
    return LearnProgressState(byTopicId: byTopicId ?? this.byTopicId);
  }

  Map<String, dynamic> toJson() => {
    'items': byTopicId.map((key, value) => MapEntry(key, value.toJson())),
  };

  static LearnProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LearnProgressState(byTopicId: {});
    final raw = json['items'];
    final out = <String, LearnTopicProgress>{};
    if (raw is Map) {
      for (final entry in raw.entries) {
        final parsed = LearnTopicProgress.fromJson(entry.value);
        if (parsed != null) {
          out[entry.key.toString()] = parsed;
        }
      }
    }
    return LearnProgressState(byTopicId: out);
  }
}

class LearnProgressSummary {
  const LearnProgressSummary({
    required this.startedCount,
    required this.completedCount,
    required this.savedCount,
    required this.favoriteCount,
    required this.lastResumedTopicId,
    required this.avgReflectionProgress,
  });

  final int startedCount;
  final int completedCount;
  final int savedCount;
  final int favoriteCount;
  final String? lastResumedTopicId;
  final double avgReflectionProgress;
}

class LearnProgressNotifier extends StateNotifier<LearnProgressState> {
  LearnProgressNotifier(this._store, this._dropController)
    : super(LearnProgressState.fromJson(_store.getJsonMap(_storageKey)));

  static const _storageKey = 'learn.progress.v1';
  final LocalStore _store;
  final JourneyDropController _dropController;

  LearnTopicProgress forTopic(LearnTopicCategory category, String topicId) {
    return state.byTopicId[topicId] ??
        LearnTopicProgress(
          topicId: topicId,
          category: category,
          started: false,
          completed: false,
          saved: false,
          favorite: false,
          reflectionProgress: 0,
          lastOpenedIso: null,
          resumedCount: 0,
        );
  }

  void touchTopic(LearnTopicCategory category, String topicId) {
    final current = forTopic(category, topicId);
    final resumed = current.started
        ? current.resumedCount + 1
        : current.resumedCount;
    _set(
      current.copyWith(
        started: true,
        lastOpenedIso: DateTime.now().toIso8601String(),
        resumedCount: resumed,
      ),
    );
  }

  void setCompleted(LearnTopicCategory category, String topicId, bool value) {
    final current = forTopic(category, topicId);
    _set(
      current.copyWith(
        started: true,
        completed: value,
        reflectionProgress: value ? 1.0 : current.reflectionProgress,
      ),
    );
    if (value && !current.completed) {
      _dropController.awardLearningDrop(
        sourceRef: 'learning:$topicId',
        occurredAt: DateTime.now(),
        metadata: <String, Object?>{
          'timestamp': DateTime.now().toIso8601String(),
          'category': category.name,
        },
      );
    }
  }

  void toggleSaved(LearnTopicCategory category, String topicId) {
    final current = forTopic(category, topicId);
    _set(current.copyWith(saved: !current.saved));
  }

  void toggleFavorite(LearnTopicCategory category, String topicId) {
    final current = forTopic(category, topicId);
    _set(current.copyWith(favorite: !current.favorite));
  }

  void updateReflectionProgress(
    LearnTopicCategory category,
    String topicId,
    double progress,
  ) {
    final current = forTopic(category, topicId);
    _set(
      current.copyWith(
        started: true,
        reflectionProgress: progress.clamp(0.0, 1.0),
      ),
    );
  }

  void _set(LearnTopicProgress next) {
    final map = Map<String, LearnTopicProgress>.from(state.byTopicId)
      ..[next.topicId] = next;
    state = state.copyWith(byTopicId: map);
    _store.setJsonMap(_storageKey, state.toJson());
  }
}

final learnProgressProvider =
    StateNotifierProvider<LearnProgressNotifier, LearnProgressState>(
      (ref) => LearnProgressNotifier(
        ref.watch(localStoreProvider),
        ref.read(journeyDropSummaryProvider.notifier),
      ),
    );

final learnProgressSummaryProvider = Provider<LearnProgressSummary>((ref) {
  final state = ref.watch(learnProgressProvider);

  var started = 0;
  var completed = 0;
  var saved = 0;
  var favorite = 0;
  var totalProgress = 0.0;
  String? resumedTopic;
  DateTime? resumedTime;

  for (final item in state.byTopicId.values) {
    if (item.started) started += 1;
    if (item.completed) completed += 1;
    if (item.saved) saved += 1;
    if (item.favorite) favorite += 1;
    totalProgress += item.reflectionProgress;
    final opened = DateTime.tryParse(item.lastOpenedIso ?? '');
    if (opened != null &&
        (resumedTime == null || opened.isAfter(resumedTime))) {
      resumedTime = opened;
      resumedTopic = item.topicId;
    }
  }

  final avg = state.byTopicId.isEmpty
      ? 0.0
      : (totalProgress / state.byTopicId.length).clamp(0.0, 1.0);

  return LearnProgressSummary(
    startedCount: started,
    completedCount: completed,
    savedCount: saved,
    favoriteCount: favorite,
    lastResumedTopicId: resumedTopic,
    avgReflectionProgress: avg,
  );
});

final learnRecommendedTopicProvider = Provider<String?>((ref) {
  final progress = ref.watch(learnProgressSummaryProvider);
  final topics = allLearnTopicIds;
  if (topics.isEmpty) return null;
  if (progress.lastResumedTopicId != null) return progress.lastResumedTopicId;

  final map = ref.watch(learnProgressProvider).byTopicId;
  for (final id in topics) {
    final item = map[id];
    if (item == null || !item.completed) return id;
  }
  return topics.first;
});
