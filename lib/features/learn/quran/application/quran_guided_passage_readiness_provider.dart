import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../data/quran_guided_passage_readiness_data.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_guided_passage_readiness_models.dart';
import '../domain/quran_readiness_bridge_models.dart';
import 'quran_providers.dart';
import 'quran_readiness_bridge_provider.dart';
import 'quran_short_surah_readiness_provider.dart';

String quranGuidedPassageReadinessStorageKeyForAudience(
  ArabicLearningAudience audience, {
  String? learnerId,
}) {
  switch (audience) {
    case ArabicLearningAudience.kids:
      return 'learn.quran.readiness.guidedPassages.v1.kids.${learnerId ?? 'default'}';
    case ArabicLearningAudience.adult:
      return 'learn.quran.readiness.guidedPassages.v1.adult';
  }
}

final quranGuidedPassageReadinessPassagesProvider =
    Provider<List<QuranGuidedPassageReadinessPassage>>((ref) {
      final repository = ref.watch(quranRepositoryProvider);
      final settings = ref.watch(quranReaderSettingsProvider);
      final surahMap = ref.watch(quranSurahMapProvider);
      final bridgeSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);

      return quranGuidedPassageReadinessSeeds
          .map((seed) {
            final surah = surahMap[seed.ref.surah]!;
            final ayahEnd = seed.ref.ayahEnd ?? seed.ref.ayah;
            final ayahs = repository
                .getAyahsForSurah(
                  seed.ref.surah,
                  translationCode: settings.translationCode,
                )
                .where(
                  (ayah) =>
                      ayah.ayahNumber >= seed.ref.ayah &&
                      ayah.ayahNumber <= ayahEnd,
                )
                .map(
                  (ayah) => QuranGuidedPassageReadinessAyah(
                    ref: QuranQuoteRef(
                      surah: ayah.surahNumber,
                      ayah: ayah.ayahNumber,
                    ),
                    arabic: ayah.arabic,
                    translation: ayah.translation,
                  ),
                )
                .toList(growable: false);
            final familiarSnippets = bridgeSnippets
                .where(
                  (snippet) =>
                      snippet.ref.surah == seed.ref.surah &&
                      snippet.ref.ayah >= seed.ref.ayah &&
                      snippet.ref.ayah <= ayahEnd,
                )
                .toList(growable: false);
            final hintMap = <String, QuranReadinessPronunciationHint>{};
            for (final hint in familiarSnippets.expand(
              (snippet) => snippet.hints,
            )) {
              hintMap.putIfAbsent(hint.id, () => hint);
            }

            return QuranGuidedPassageReadinessPassage(
              id: seed.id,
              order: seed.order,
              stage: seed.stage,
              ref: seed.ref,
              surahArabicName: surah.arabicName,
              surahTransliteratedName: surah.transliteratedName,
              ayahs: ayahs,
              familiarSnippets: familiarSnippets,
              hints: hintMap.values.toList(growable: false),
            );
          })
          .toList(growable: false)
        ..sort((a, b) => a.order.compareTo(b.order));
    });

final quranGuidedPassageReadinessStagesProvider =
    Provider<List<QuranGuidedPassageReadinessStage>>((ref) {
      final seen = <QuranGuidedPassageReadinessStage>{};
      final ordered = <QuranGuidedPassageReadinessStage>[];
      for (final passage in ref.watch(
        quranGuidedPassageReadinessPassagesProvider,
      )) {
        if (seen.add(passage.stage)) {
          ordered.add(passage.stage);
        }
      }
      return ordered;
    });

final quranGuidedPassageReadinessProgressProvider =
    StateNotifierProvider.family<
      QuranGuidedPassageReadinessProgressNotifier,
      QuranGuidedPassageReadinessProgressState,
      ArabicLearningAudience
    >((ref, audience) {
      final notifier = QuranGuidedPassageReadinessProgressNotifier(
        ref,
        audience,
      );
      if (audience == ArabicLearningAudience.kids) {
        ref.listen<String>(
          kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
          (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
        );
      }
      return notifier;
    });

final quranGuidedPassageReadinessSummaryProvider =
    Provider.family<QuranGuidedPassageReadinessSummary, ArabicLearningAudience>(
      (ref, audience) {
        final passages = ref.watch(quranGuidedPassageReadinessPassagesProvider);
        final progress = ref.watch(
          quranGuidedPassageReadinessProgressProvider(audience),
        );
        final routeName = audience == ArabicLearningAudience.kids
            ? 'kidsArabicGuidedPassages'
            : 'quranArabicGuidedPassages';
        final hasShortSurahStageStarted = ref
            .watch(quranShortSurahReadinessProgressProvider(audience))
            .openedSurahNumbers
            .isNotEmpty;
        final openedCount = progress.openedPassageIds.length;
        final stageSummaries = ref
            .watch(quranGuidedPassageReadinessStagesProvider)
            .map((stage) {
              final stagePassages = passages
                  .where((item) => item.stage == stage)
                  .toList(growable: false);
              final opened = stagePassages
                  .where((item) => progress.openedPassageIds.contains(item.id))
                  .length;
              return QuranGuidedPassageReadinessStageSummary(
                stage: stage,
                openedCount: opened,
                totalCount: stagePassages.length,
              );
            })
            .toList(growable: false);
        final firstUnopened = passages.firstWhere(
          (item) => !progress.openedPassageIds.contains(item.id),
          orElse: () => passages.first,
        );
        final lastPassage = progress.lastPassageId == null
            ? null
            : passages
                  .where((item) => item.id == progress.lastPassageId)
                  .firstOrNull;

        if (openedCount == 0) {
          return QuranGuidedPassageReadinessSummary(
            audience: audience,
            intent: ArabicLearningContinuationIntent.start,
            passage: passages.first,
            stageSummaries: stageSummaries,
            currentStage: passages.first.stage,
            routeName: routeName,
            hasShortSurahStageStarted: hasShortSurahStageStarted,
            openedCount: openedCount,
            totalCount: passages.length,
          );
        }

        if (openedCount >= passages.length) {
          final reviewed = lastPassage ?? passages.first;
          return QuranGuidedPassageReadinessSummary(
            audience: audience,
            intent: ArabicLearningContinuationIntent.review,
            passage: reviewed,
            stageSummaries: stageSummaries,
            currentStage: reviewed.stage,
            routeName: routeName,
            hasShortSurahStageStarted: hasShortSurahStageStarted,
            openedCount: openedCount,
            totalCount: passages.length,
          );
        }

        return QuranGuidedPassageReadinessSummary(
          audience: audience,
          intent: ArabicLearningContinuationIntent.continueForward,
          passage: firstUnopened,
          stageSummaries: stageSummaries,
          currentStage: firstUnopened.stage,
          routeName: routeName,
          hasShortSurahStageStarted: hasShortSurahStageStarted,
          openedCount: openedCount,
          totalCount: passages.length,
        );
      },
    );

class QuranGuidedPassageReadinessProgressNotifier
    extends StateNotifier<QuranGuidedPassageReadinessProgressState> {
  QuranGuidedPassageReadinessProgressNotifier(Ref ref, this._audience)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = _resolveLearnerId(ref, _audience),
      super(
        QuranGuidedPassageReadinessProgressState.fromJson(
          ref
              .read(localStoreProvider)
              .getJsonMap(
                quranGuidedPassageReadinessStorageKeyForAudience(
                  _audience,
                  learnerId: _resolveLearnerId(ref, _audience),
                ),
              ),
        ),
      );

  final LocalStore _store;
  final ArabicLearningAudience _audience;
  String? _activeLearnerId;

  static String? _resolveLearnerId(Ref ref, ArabicLearningAudience audience) {
    if (audience != ArabicLearningAudience.kids) {
      return null;
    }
    return ref.read(kidsArabicActiveLearnerProvider).learnerId;
  }

  void updateActiveLearner(String learnerId) {
    if (_audience != ArabicLearningAudience.kids ||
        _activeLearnerId == learnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    state = QuranGuidedPassageReadinessProgressState.fromJson(
      _store.getJsonMap(
        quranGuidedPassageReadinessStorageKeyForAudience(
          _audience,
          learnerId: learnerId,
        ),
      ),
    );
  }

  void markPassageOpened(String passageId) {
    final nextOpened = Set<String>.from(state.openedPassageIds)..add(passageId);
    state = state.copyWith(
      lastPassageId: passageId,
      openedPassageIds: nextOpened,
      lastOpenedAt: DateTime.now(),
    );
    _store.setJsonMap(
      quranGuidedPassageReadinessStorageKeyForAudience(
        _audience,
        learnerId: _activeLearnerId,
      ),
      state.toJson(),
    );
  }
}
