import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../../../journey/xp/application/journey_xp_providers.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_content_refs.dart';
import 'quran_ayah_enrichment_provider.dart';
import 'quran_learning_personalization_provider.dart';
import 'quran_providers.dart';

const _quranLearningProgressionKey = 'learn.quran.learning_progression.v1';

class QuranLearningProgressState {
  const QuranLearningProgressState({
    required this.completedEntryIds,
    required this.completedPathIds,
    required this.firstReflectionRewardAwarded,
  });

  final Set<String> completedEntryIds;
  final Set<String> completedPathIds;
  final bool firstReflectionRewardAwarded;

  QuranLearningProgressState copyWith({
    Set<String>? completedEntryIds,
    Set<String>? completedPathIds,
    bool? firstReflectionRewardAwarded,
  }) {
    return QuranLearningProgressState(
      completedEntryIds: completedEntryIds ?? this.completedEntryIds,
      completedPathIds: completedPathIds ?? this.completedPathIds,
      firstReflectionRewardAwarded:
          firstReflectionRewardAwarded ?? this.firstReflectionRewardAwarded,
    );
  }

  Map<String, dynamic> toJson() => {
    'completedEntryIds': completedEntryIds.toList(growable: false),
    'completedPathIds': completedPathIds.toList(growable: false),
    'firstReflectionRewardAwarded': firstReflectionRewardAwarded,
  };

  static QuranLearningProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranLearningProgressState(
        completedEntryIds: <String>{},
        completedPathIds: <String>{},
        firstReflectionRewardAwarded: false,
      );
    }
    return QuranLearningProgressState(
      completedEntryIds: _asStringSet(json['completedEntryIds']),
      completedPathIds: _asStringSet(json['completedPathIds']),
      firstReflectionRewardAwarded:
          json['firstReflectionRewardAwarded'] as bool? ?? false,
    );
  }
}

class QuranAyahInsightPathProgressSummary {
  const QuranAyahInsightPathProgressSummary({
    required this.completedCount,
    required this.totalCount,
    required this.isCompleted,
  });

  final int completedCount;
  final int totalCount;
  final bool isCompleted;
}

class QuranLearningProgressionController
    extends StateNotifier<QuranLearningProgressState> {
  QuranLearningProgressionController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(
        QuranLearningProgressState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(_quranLearningProgressionKey),
        ),
      );

  final Ref _ref;
  final LocalStore _store;

  static const int insightCompletionXp = 8;
  static const int pathCompletionXp = 12;
  static const int firstReflectionXp = 5;

  void _persist() {
    _store.setJsonMap(_quranLearningProgressionKey, state.toJson());
  }

  bool completeEntry({
    required QuranAyahEnrichmentEntry entry,
    String? sourcePathId,
    String sourceSurface = 'ayah_insight',
    bool awardEntryReward = true,
    DateTime? now,
  }) {
    final occurredAt = now ?? DateTime.now();
    final alreadyCompleted = state.completedEntryIds.contains(entry.id);

    _ref
        .read(quranLearningPersonalizationStateProvider.notifier)
        .markDomainOpened(_categoryIdForDomain(entry.domain));
    if (sourcePathId != null) {
      _ref
          .read(quranLearningPersonalizationStateProvider.notifier)
          .markPathOpened(pathId: sourcePathId, entryId: entry.id);
    }
    _ref
        .read(quranReadingProgressProvider.notifier)
        .touchLocation(
          surahNumber: entry.ref.surah,
          ayahNumber: entry.ref.ayah,
        );

    if (alreadyCompleted) {
      return false;
    }

    final updatedCompletedEntryIds = Set<String>.from(state.completedEntryIds)
      ..add(entry.id);
    final updatedCompletedPathIds = Set<String>.from(state.completedPathIds);

    if (awardEntryReward) {
      final sourceRef = 'quran_learning_entry:${entry.id}';
      _ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: sourceRef,
            sourceModule: 'quran',
            occurredAt: occurredAt,
            xp: insightCompletionXp,
            metadata: <String, Object?>{
              'entryId': entry.id,
              'domain': entry.domain.name,
              'surface': sourceSurface,
              'surah': entry.ref.surah,
              'ayah': entry.ref.ayah,
              ...?sourcePathId == null ? null : {'pathId': sourcePathId},
            },
          );
      _ref
          .read(journeyDropSummaryProvider.notifier)
          .awardLearningDrop(
            sourceRef: sourceRef,
            occurredAt: occurredAt,
            metadata: <String, Object?>{
              'entryId': entry.id,
              'domain': entry.domain.name,
              'surface': sourceSurface,
              ...?sourcePathId == null ? null : {'pathId': sourcePathId},
            },
          );
    }

    final resolvedPaths = _ref.read(quranAyahInsightResolvedPathsProvider);
    for (final path in resolvedPaths) {
      if (!path.entries.any((candidate) => candidate.id == entry.id)) continue;
      final allStepsCompleted = path.entries.every(
        (candidate) => updatedCompletedEntryIds.contains(candidate.id),
      );
      if (!allStepsCompleted ||
          updatedCompletedPathIds.contains(path.path.id)) {
        continue;
      }
      updatedCompletedPathIds.add(path.path.id);
      final sourceRef = 'quran_learning_path:${path.path.id}:completed';
      _ref
          .read(journeyXpSummaryProvider.notifier)
          .awardLearningXp(
            sourceRef: sourceRef,
            sourceModule: 'quran',
            occurredAt: occurredAt,
            xp: pathCompletionXp,
            metadata: <String, Object?>{
              'pathId': path.path.id,
              'domain': path.path.domain.name,
              'completedViaEntryId': entry.id,
            },
          );
      _ref
          .read(journeyDropSummaryProvider.notifier)
          .awardLearningDrop(
            sourceRef: sourceRef,
            occurredAt: occurredAt,
            metadata: <String, Object?>{
              'pathId': path.path.id,
              'domain': path.path.domain.name,
              'completedViaEntryId': entry.id,
            },
          );
    }

    state = state.copyWith(
      completedEntryIds: updatedCompletedEntryIds,
      completedPathIds: updatedCompletedPathIds,
    );
    _persist();
    return true;
  }

  bool rewardFirstReflectionNote({
    required QuranQuoteRef ref,
    String? sourceEnrichmentId,
    String sourceSurface = 'reflection_note',
    DateTime? now,
  }) {
    if (state.firstReflectionRewardAwarded) return false;
    final occurredAt = now ?? DateTime.now();
    final sourceRef = 'quran_learning_reflection:first_note';

    _ref
        .read(journeyXpSummaryProvider.notifier)
        .awardLearningXp(
          sourceRef: sourceRef,
          sourceModule: 'quran',
          occurredAt: occurredAt,
          xp: firstReflectionXp,
          metadata: <String, Object?>{
            'surface': sourceSurface,
            'surah': ref.surah,
            'ayah': ref.ayah,
            ...?sourceEnrichmentId == null
                ? null
                : {'entryId': sourceEnrichmentId},
          },
        );
    _ref
        .read(journeyDropSummaryProvider.notifier)
        .awardLearningDrop(
          sourceRef: sourceRef,
          occurredAt: occurredAt,
          metadata: <String, Object?>{
            'surface': sourceSurface,
            'surah': ref.surah,
            'ayah': ref.ayah,
            ...?sourceEnrichmentId == null
                ? null
                : {'entryId': sourceEnrichmentId},
          },
        );

    state = state.copyWith(firstReflectionRewardAwarded: true);
    _persist();
    return true;
  }
}

final quranLearningProgressStateProvider =
    StateNotifierProvider<
      QuranLearningProgressionController,
      QuranLearningProgressState
    >((ref) => QuranLearningProgressionController(ref));

final quranLearningEntryCompletedProvider = Provider.family<bool, String>((
  ref,
  entryId,
) {
  return ref.watch(
    quranLearningProgressStateProvider.select(
      (state) => state.completedEntryIds.contains(entryId),
    ),
  );
});

final quranAyahInsightPathProgressProvider =
    Provider.family<QuranAyahInsightPathProgressSummary?, String>((
      ref,
      pathId,
    ) {
      final path = ref.watch(quranAyahInsightPathProvider(pathId));
      if (path == null) return null;
      final completedEntryIds = ref.watch(
        quranLearningProgressStateProvider.select(
          (state) => state.completedEntryIds,
        ),
      );
      final completedCount = path.entries
          .where((entry) => completedEntryIds.contains(entry.id))
          .length;
      return QuranAyahInsightPathProgressSummary(
        completedCount: completedCount,
        totalCount: path.entries.length,
        isCompleted: completedCount == path.entries.length,
      );
    });

Set<String> _asStringSet(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toSet();
  }
  return <String>{};
}

String _categoryIdForDomain(QuranAyahEnrichmentDomain domain) {
  return switch (domain) {
    QuranAyahEnrichmentDomain.signsInCreation ||
    QuranAyahEnrichmentDomain.worldNature => 'signs-in-creation',
    QuranAyahEnrichmentDomain.worshipRemembrance => 'worship-remembrance',
    QuranAyahEnrichmentDomain.characterAdab => 'character-adab',
    QuranAyahEnrichmentDomain.tawhidBelief => 'tawhid-belief',
    QuranAyahEnrichmentDomain.akhirahAccountability => 'akhirah-accountability',
    QuranAyahEnrichmentDomain.prophetsLessons => 'prophets-lessons',
    QuranAyahEnrichmentDomain.guidanceDailyLife => 'guidance-reflection',
  };
}
