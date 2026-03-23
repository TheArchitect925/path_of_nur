import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import 'quran_ayah_enrichment_provider.dart';
import 'quran_providers.dart';

const _quranLearningPersonalizationKey = 'learn.quran.personalization.v1';

class QuranLearningPersonalizationState {
  const QuranLearningPersonalizationState({
    this.lastDomainId,
    this.lastPathId,
    this.lastPathEntryId,
    this.updatedAtIso,
  });

  final String? lastDomainId;
  final String? lastPathId;
  final String? lastPathEntryId;
  final String? updatedAtIso;

  bool get hasSignals =>
      (lastDomainId?.isNotEmpty ?? false) || (lastPathId?.isNotEmpty ?? false);

  QuranLearningPersonalizationState copyWith({
    String? lastDomainId,
    String? lastPathId,
    String? lastPathEntryId,
    String? updatedAtIso,
    bool clearLastDomainId = false,
    bool clearLastPath = false,
  }) {
    return QuranLearningPersonalizationState(
      lastDomainId: clearLastDomainId
          ? null
          : (lastDomainId ?? this.lastDomainId),
      lastPathId: clearLastPath ? null : (lastPathId ?? this.lastPathId),
      lastPathEntryId: clearLastPath
          ? null
          : (lastPathEntryId ?? this.lastPathEntryId),
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, dynamic> toJson() => {
    'lastDomainId': lastDomainId,
    'lastPathId': lastPathId,
    'lastPathEntryId': lastPathEntryId,
    'updatedAtIso': updatedAtIso,
  };

  static QuranLearningPersonalizationState fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const QuranLearningPersonalizationState();
    }
    return QuranLearningPersonalizationState(
      lastDomainId: json['lastDomainId']?.toString(),
      lastPathId: json['lastPathId']?.toString(),
      lastPathEntryId: json['lastPathEntryId']?.toString(),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }
}

class QuranLearningContinueAyah {
  const QuranLearningContinueAyah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.locationLabel,
    required this.surahName,
  });

  final int surahNumber;
  final int ayahNumber;
  final String locationLabel;
  final String surahName;
}

class QuranLearningPersonalizationSummary {
  const QuranLearningPersonalizationSummary({
    required this.hasSignals,
    required this.continueAyah,
    this.continuePath,
    this.continueDomain,
    this.nextPathEntry,
    this.suggestedDomain,
    this.suggestedPath,
    this.suggestedTag,
  });

  final bool hasSignals;
  final QuranLearningContinueAyah continueAyah;
  final QuranAyahInsightResolvedPath? continuePath;
  final QuranAyahEnrichmentBrowseCategory? continueDomain;
  final QuranAyahEnrichmentEntry? nextPathEntry;
  final QuranAyahEnrichmentBrowseCategory? suggestedDomain;
  final QuranAyahInsightResolvedPath? suggestedPath;
  final QuranAyahEnrichmentTag? suggestedTag;
}

class QuranLearningPersonalizationNotifier
    extends StateNotifier<QuranLearningPersonalizationState> {
  QuranLearningPersonalizationNotifier(this._store)
    : super(
        QuranLearningPersonalizationState.fromJson(
          _store.getJsonMap(_quranLearningPersonalizationKey),
        ),
      );

  final LocalStore _store;

  void markDomainOpened(String categoryId) {
    if (categoryId.trim().isEmpty) return;
    state = state.copyWith(
      lastDomainId: categoryId,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_quranLearningPersonalizationKey, state.toJson());
  }

  void markPathOpened({required String pathId, String? entryId}) {
    if (pathId.trim().isEmpty) return;
    state = state.copyWith(
      lastPathId: pathId,
      lastPathEntryId: entryId ?? state.lastPathEntryId,
      updatedAtIso: DateTime.now().toIso8601String(),
    );
    _store.setJsonMap(_quranLearningPersonalizationKey, state.toJson());
  }
}

final quranLearningPersonalizationStateProvider =
    StateNotifierProvider<
      QuranLearningPersonalizationNotifier,
      QuranLearningPersonalizationState
    >((ref) {
      return QuranLearningPersonalizationNotifier(
        ref.watch(localStoreProvider),
      );
    });

final quranLearningPersonalizationSummaryProvider =
    Provider<QuranLearningPersonalizationSummary>((ref) {
      final state = ref.watch(quranLearningPersonalizationStateProvider);
      final continueSummary = ref.watch(quranContinueReadingSummaryProvider);
      final recentReadings = ref.watch(quranRecentReadingsProvider);
      final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
      final categories = ref.watch(quranAyahEnrichmentBrowseCategoriesProvider);
      final resolvedPaths = ref.watch(quranAyahInsightResolvedPathsProvider);

      final continueAyah = QuranLearningContinueAyah(
        surahNumber: continueSummary.surahNumber,
        ayahNumber: continueSummary.ayahNumber,
        locationLabel: continueSummary.locationLabel,
        surahName: continueSummary.surahName,
      );

      QuranAyahInsightResolvedPath? continuePath;
      for (final path in resolvedPaths) {
        if (path.path.id == state.lastPathId) {
          continuePath = path;
          break;
        }
      }

      QuranAyahEnrichmentBrowseCategory? continueDomain;
      for (final category in categories) {
        if (category.id == state.lastDomainId) {
          continueDomain = category;
          break;
        }
      }

      QuranAyahEnrichmentEntry? nextPathEntry;
      if (continuePath != null && continuePath.entries.isNotEmpty) {
        var nextIndex = 0;
        if (state.lastPathEntryId != null) {
          final currentIndex = continuePath.entries.indexWhere(
            (entry) => entry.id == state.lastPathEntryId,
          );
          if (currentIndex >= 0 &&
              currentIndex + 1 < continuePath.entries.length) {
            nextIndex = currentIndex + 1;
          }
        }
        nextPathEntry = continuePath.entries[nextIndex];
      }

      final categoryScores = <String, int>{};
      final tagScores = <QuranAyahEnrichmentTag, int>{};

      for (var index = 0; index < recentReadings.length && index < 6; index++) {
        final reading = recentReadings[index];
        final weight = 12 - (index * 2);
        final matchingEntries = entries.where(
          (entry) =>
              entry.containsVerse(reading.surahNumber, reading.ayahNumber),
        );
        final seenCategoryIds = <String>{};
        final seenTags = <QuranAyahEnrichmentTag>{};

        for (final entry in matchingEntries) {
          final categoryId = _categoryIdForDomain(entry.domain);
          if (seenCategoryIds.add(categoryId)) {
            categoryScores.update(
              categoryId,
              (value) => value + weight,
              ifAbsent: () => weight,
            );
          }
          for (final tag in entry.tags) {
            if (!seenTags.add(tag)) continue;
            tagScores.update(
              tag,
              (value) => value + weight,
              ifAbsent: () => weight,
            );
          }
        }
      }

      if (continueDomain != null) {
        categoryScores.update(
          continueDomain.id,
          (value) => value + 18,
          ifAbsent: () => 18,
        );
      }

      if (continuePath != null) {
        final categoryId = _categoryIdForDomain(continuePath.path.domain);
        categoryScores.update(
          categoryId,
          (value) => value + 14,
          ifAbsent: () => 14,
        );
        for (final entry in continuePath.entries.take(3)) {
          for (final tag in entry.tags) {
            tagScores.update(tag, (value) => value + 5, ifAbsent: () => 5);
          }
        }
      }

      QuranAyahEnrichmentBrowseCategory? suggestedDomain;
      if (categoryScores.isNotEmpty) {
        final sorted = categoryScores.entries.toList(growable: false)
          ..sort((a, b) => b.value.compareTo(a.value));
        for (final candidate in sorted) {
          for (final category in categories) {
            if (category.id == candidate.key) {
              suggestedDomain = category;
              break;
            }
          }
          if (suggestedDomain != null) break;
        }
      }
      suggestedDomain ??= _findCategory(categories, 'worship-remembrance');

      QuranAyahEnrichmentTag? suggestedTag;
      if (tagScores.isNotEmpty) {
        final sortedTags = tagScores.entries.toList(growable: false)
          ..sort((a, b) => b.value.compareTo(a.value));
        suggestedTag = sortedTags.first.key;
      } else {
        suggestedTag = QuranAyahEnrichmentTag.worship;
      }

      QuranAyahInsightResolvedPath? suggestedPath;
      final suggestedDomainId = suggestedDomain?.id;
      if (suggestedDomainId != null) {
        for (final path in resolvedPaths) {
          final pathCategoryId = _categoryIdForDomain(path.path.domain);
          if (pathCategoryId == suggestedDomainId &&
              path.path.id != continuePath?.path.id) {
            suggestedPath = path;
            break;
          }
        }
      }
      suggestedPath ??= _findPath(resolvedPaths, 'worship-remembrance-starter');

      return QuranLearningPersonalizationSummary(
        hasSignals: state.hasSignals || recentReadings.isNotEmpty,
        continueAyah: continueAyah,
        continuePath: continuePath,
        continueDomain: continueDomain,
        nextPathEntry: nextPathEntry,
        suggestedDomain: suggestedDomain,
        suggestedPath: suggestedPath,
        suggestedTag: suggestedTag,
      );
    });

QuranAyahEnrichmentBrowseCategory? _findCategory(
  List<QuranAyahEnrichmentBrowseCategory> categories,
  String id,
) {
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
}

QuranAyahInsightResolvedPath? _findPath(
  List<QuranAyahInsightResolvedPath> paths,
  String id,
) {
  for (final path in paths) {
    if (path.path.id == id) return path;
  }
  return null;
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
    QuranAyahEnrichmentDomain.guidanceDailyLife => 'guidance-daily-life',
  };
}
