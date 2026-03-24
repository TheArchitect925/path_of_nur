import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../data/quran_short_surah_readiness_data.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_short_surah_readiness_models.dart';
import 'quran_providers.dart';
import 'quran_readiness_bridge_provider.dart';

String quranShortSurahReadinessStorageKeyForAudience(
  ArabicLearningAudience audience, {
  String? learnerId,
}) {
  switch (audience) {
    case ArabicLearningAudience.kids:
      return 'learn.quran.readiness.shortSurahs.v1.kids.${learnerId ?? 'default'}';
    case ArabicLearningAudience.adult:
      return 'learn.quran.readiness.shortSurahs.v1.adult';
  }
}

final quranShortSurahReadinessSurahsProvider =
    Provider<List<QuranShortSurahReadinessSurah>>((ref) {
      final repository = ref.watch(quranRepositoryProvider);
      final settings = ref.watch(quranReaderSettingsProvider);
      final surahMap = ref.watch(quranSurahMapProvider);
      final bridgeSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);

      return quranShortSurahReadinessSeeds
          .map((seed) {
            final surah = surahMap[seed.surahNumber]!;
            final ayahs = repository
                .getAyahsForSurah(
                  seed.surahNumber,
                  translationCode: settings.translationCode,
                )
                .map(
                  (ayah) => QuranShortSurahReadinessAyah(
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
                .where((snippet) => snippet.ref.surah == seed.surahNumber)
                .toList(growable: false);
            final hints = familiarSnippets
                .expand((snippet) => snippet.hints)
                .toList(growable: false);

            return QuranShortSurahReadinessSurah(
              id: seed.id,
              order: seed.order,
              stage: seed.stage,
              surahNumber: seed.surahNumber,
              surahArabicName: surah.arabicName,
              surahTransliteratedName: surah.transliteratedName,
              ayahs: ayahs,
              familiarSnippets: familiarSnippets,
              hints: hints,
            );
          })
          .toList(growable: false)
        ..sort((a, b) => a.order.compareTo(b.order));
    });

final quranShortSurahReadinessStagesProvider =
    Provider<List<QuranShortSurahReadinessStage>>((ref) {
      final seen = <QuranShortSurahReadinessStage>{};
      final ordered = <QuranShortSurahReadinessStage>[];
      for (final surah in ref.watch(quranShortSurahReadinessSurahsProvider)) {
        if (seen.add(surah.stage)) {
          ordered.add(surah.stage);
        }
      }
      return ordered;
    });

final quranShortSurahReadinessProgressProvider =
    StateNotifierProvider.family<
      QuranShortSurahReadinessProgressNotifier,
      QuranShortSurahReadinessProgressState,
      ArabicLearningAudience
    >((ref, audience) {
      final notifier = QuranShortSurahReadinessProgressNotifier(ref, audience);
      if (audience == ArabicLearningAudience.kids) {
        ref.listen<String>(
          kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
          (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
        );
      }
      return notifier;
    });

final quranShortSurahReadinessSummaryProvider =
    Provider.family<QuranShortSurahReadinessSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      final surahs = ref.watch(quranShortSurahReadinessSurahsProvider);
      final progress = ref.watch(
        quranShortSurahReadinessProgressProvider(audience),
      );
      final routeName = audience == ArabicLearningAudience.kids
          ? 'kidsArabicShortSurahs'
          : 'quranArabicShortSurahs';
      final hasSnippetBridgeStarted = ref
          .watch(quranReadinessBridgeProgressProvider(audience))
          .openedSnippetIds
          .isNotEmpty;
      final openedCount = progress.openedSurahNumbers.length;
      final stageSummaries = ref
          .watch(quranShortSurahReadinessStagesProvider)
          .map((stage) {
            final stageSurahs = surahs
                .where((item) => item.stage == stage)
                .toList(growable: false);
            final opened = stageSurahs
                .where(
                  (item) =>
                      progress.openedSurahNumbers.contains(item.surahNumber),
                )
                .length;
            return QuranShortSurahReadinessStageSummary(
              stage: stage,
              openedCount: opened,
              totalCount: stageSurahs.length,
            );
          })
          .toList(growable: false);

      final firstUnopened = surahs.firstWhere(
        (item) => !progress.openedSurahNumbers.contains(item.surahNumber),
        orElse: () => surahs.first,
      );
      final lastSurah = progress.lastSurahNumber == null
          ? null
          : surahs
                .where((item) => item.surahNumber == progress.lastSurahNumber)
                .firstOrNull;

      if (openedCount == 0) {
        return QuranShortSurahReadinessSummary(
          audience: audience,
          intent: ArabicLearningContinuationIntent.start,
          surah: surahs.first,
          stageSummaries: stageSummaries,
          currentStage: surahs.first.stage,
          routeName: routeName,
          hasSnippetBridgeStarted: hasSnippetBridgeStarted,
          openedCount: openedCount,
          totalCount: surahs.length,
        );
      }

      if (openedCount >= surahs.length) {
        final reviewed = lastSurah ?? surahs.first;
        return QuranShortSurahReadinessSummary(
          audience: audience,
          intent: ArabicLearningContinuationIntent.review,
          surah: reviewed,
          stageSummaries: stageSummaries,
          currentStage: reviewed.stage,
          routeName: routeName,
          hasSnippetBridgeStarted: hasSnippetBridgeStarted,
          openedCount: openedCount,
          totalCount: surahs.length,
        );
      }

      return QuranShortSurahReadinessSummary(
        audience: audience,
        intent: ArabicLearningContinuationIntent.continueForward,
        surah: firstUnopened,
        stageSummaries: stageSummaries,
        currentStage: firstUnopened.stage,
        routeName: routeName,
        hasSnippetBridgeStarted: hasSnippetBridgeStarted,
        openedCount: openedCount,
        totalCount: surahs.length,
      );
    });

class QuranShortSurahReadinessProgressNotifier
    extends StateNotifier<QuranShortSurahReadinessProgressState> {
  QuranShortSurahReadinessProgressNotifier(Ref ref, this._audience)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = _resolveLearnerId(ref, _audience),
      super(
        QuranShortSurahReadinessProgressState.fromJson(
          ref
              .read(localStoreProvider)
              .getJsonMap(
                quranShortSurahReadinessStorageKeyForAudience(
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
    state = QuranShortSurahReadinessProgressState.fromJson(
      _store.getJsonMap(
        quranShortSurahReadinessStorageKeyForAudience(
          _audience,
          learnerId: learnerId,
        ),
      ),
    );
  }

  void markSurahOpened(int surahNumber) {
    final nextOpened = Set<int>.from(state.openedSurahNumbers)
      ..add(surahNumber);
    state = state.copyWith(
      lastSurahNumber: surahNumber,
      openedSurahNumbers: nextOpened,
      lastOpenedAt: DateTime.now(),
    );
    _store.setJsonMap(
      quranShortSurahReadinessStorageKeyForAudience(
        _audience,
        learnerId: _activeLearnerId,
      ),
      state.toJson(),
    );
  }
}
