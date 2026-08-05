import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../arabic/data/arabic_beginner_content_catalog.dart';
import '../../../arabic/domain/arabic_beginner_content_models.dart';
import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../quran_teaching/application/quran_teaching_controller.dart';
import '../data/quran_readiness_bridge_data.dart';
import '../domain/quran_readiness_bridge_models.dart';
import 'quran_providers.dart';

String quranReadinessBridgeStorageKeyForAudience(
  ArabicLearningAudience audience, {
  String? learnerId,
}) {
  switch (audience) {
    case ArabicLearningAudience.kids:
      return 'learn.quran.readiness.bridge.v1.kids.${learnerId ?? 'default'}';
    case ArabicLearningAudience.adult:
      return 'learn.quran.readiness.bridge.v1.adult';
  }
}

final quranReadinessBridgeSnippetsProvider =
    Provider<List<QuranReadinessBridgeSnippet>>((ref) {
      final repository = ref.watch(quranRepositoryProvider);
      final settings = ref.watch(quranReaderSettingsProvider);
      final surahs = repository.getSurahs();

      return quranReadinessBridgeSeeds
          .map((seed) {
            final phrase = seed.sharedPhraseId == null
                ? null
                : arabicSharedMiniPhraseById(seed.sharedPhraseId!);
            final ayah = repository
                .getAyahsForSurah(
                  seed.ref.surah,
                  translationCode: settings.translationCode,
                )
                .firstWhere((item) => item.ayahNumber == seed.ref.ayah);
            final surahName = surahs
                .firstWhere((item) => item.number == seed.ref.surah)
                .transliteratedName;
            final snippetArabic =
                _extractSnippetFromAyah(
                  ayahArabic: ayah.arabic,
                  phraseArabic: seed.snippetArabic,
                ) ??
                seed.snippetArabic;
            final familiarWords = seed.familiarWordIds
                .map((id) => arabicSharedBeginnerWordById(id))
                .whereType<ArabicBeginnerWordEntry>()
                .toList(growable: false);

            return QuranReadinessBridgeSnippet(
              id: seed.id,
              order: seed.order,
              level: seed.level,
              ref: seed.ref,
              snippetArabic: snippetArabic,
              ayahArabic: ayah.arabic,
              ayahTranslation: ayah.translation,
              transliteration: seed.transliteration,
              simpleMeaning: seed.simpleMeaning,
              audioAssetPath: seed.audioAssetPath ?? phrase?.audioAssetPath,
              familiarWords: familiarWords,
              surahName: surahName,
              hints: seed.hints
                  .map(
                    (hint) => QuranReadinessPronunciationHint(
                      id: hint.id,
                      type: hint.type,
                      focusArabic: hint.focusArabic,
                      adultTarget: hint.adultTarget,
                      kidsTarget: hint.kidsTarget,
                    ),
                  )
                  .toList(growable: false),
              sharedPhrase: phrase,
            );
          })
          .toList(growable: false)
        ..sort((a, b) => a.order.compareTo(b.order));
    });

final quranReadinessBridgeLevelsProvider =
    Provider<List<QuranReadinessBridgeLevel>>((ref) {
      final seen = <QuranReadinessBridgeLevel>{};
      final ordered = <QuranReadinessBridgeLevel>[];
      for (final snippet in ref.watch(quranReadinessBridgeSnippetsProvider)) {
        if (seen.add(snippet.level)) {
          ordered.add(snippet.level);
        }
      }
      return ordered;
    });

final quranReadinessBridgeProgressProvider =
    StateNotifierProvider.family<
      QuranReadinessBridgeProgressNotifier,
      QuranReadinessBridgeProgressState,
      ArabicLearningAudience
    >((ref, audience) {
      final notifier = QuranReadinessBridgeProgressNotifier(ref, audience);
      if (audience == ArabicLearningAudience.kids) {
        ref.listen<String>(
          kidsArabicActiveLearnerProvider.select((value) => value.learnerId),
          (_, nextLearnerId) => notifier.updateActiveLearner(nextLearnerId),
        );
      }
      return notifier;
    });

final quranReadinessBridgeSummaryProvider =
    Provider.family<QuranReadinessBridgeSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      final snippets = ref.watch(quranReadinessBridgeSnippetsProvider);
      final progress = ref.watch(
        quranReadinessBridgeProgressProvider(audience),
      );
      final routeName = audience == ArabicLearningAudience.kids
          ? 'kidsArabicQuranReadiness'
          : 'quranArabicReadiness';
      final openedCount = progress.openedSnippetIds.length;
      final levelSummaries = ref
          .watch(quranReadinessBridgeLevelsProvider)
          .map((level) {
            final levelSnippets = snippets
                .where((item) => item.level == level)
                .toList(growable: false);
            final opened = levelSnippets
                .where((item) => progress.openedSnippetIds.contains(item.id))
                .length;
            return QuranReadinessBridgeLevelSummary(
              level: level,
              openedCount: opened,
              totalCount: levelSnippets.length,
            );
          })
          .toList(growable: false);

      final hasArabicFoundationStarted = switch (audience) {
        ArabicLearningAudience.kids =>
          ref.watch(kidsArabicProgressProvider).totalLessonsDone > 0 ||
              ref.watch(kidsArabicWordProgressProvider).totalWordLessonsDone >
                  0 ||
              ref
                  .watch(kidsArabicMiniPhraseProgressProvider)
                  .heardPhraseIds
                  .isNotEmpty,
        ArabicLearningAudience.adult =>
          ref
                  .watch(quranTeachingProgressProvider)
                  .startedLessonIds
                  .isNotEmpty ||
              ref
                  .watch(quranTeachingProgressProvider)
                  .completedLessonIds
                  .isNotEmpty ||
              ref
                      .watch(quranTeachingBeginnerWordsProgressProvider)
                      .lastWordId !=
                  null,
      };

      final firstUnopened = snippets.firstWhere(
        (item) => !progress.openedSnippetIds.contains(item.id),
        orElse: () => snippets.first,
      );
      final lastSnippet = progress.lastSnippetId == null
          ? null
          : snippets
                .where((item) => item.id == progress.lastSnippetId)
                .firstOrNull;

      if (openedCount == 0) {
        return QuranReadinessBridgeSummary(
          audience: audience,
          intent: ArabicLearningContinuationIntent.start,
          snippet: snippets.first,
          levelSummaries: levelSummaries,
          currentLevel: snippets.first.level,
          routeName: routeName,
          hasArabicFoundationStarted: hasArabicFoundationStarted,
          openedCount: 0,
          totalCount: snippets.length,
        );
      }

      if (openedCount >= snippets.length) {
        return QuranReadinessBridgeSummary(
          audience: audience,
          intent: ArabicLearningContinuationIntent.review,
          snippet: lastSnippet ?? snippets.first,
          levelSummaries: levelSummaries,
          currentLevel: (lastSnippet ?? snippets.first).level,
          routeName: routeName,
          hasArabicFoundationStarted: hasArabicFoundationStarted,
          openedCount: openedCount,
          totalCount: snippets.length,
        );
      }

      return QuranReadinessBridgeSummary(
        audience: audience,
        intent: ArabicLearningContinuationIntent.continueForward,
        snippet: firstUnopened,
        levelSummaries: levelSummaries,
        currentLevel: firstUnopened.level,
        routeName: routeName,
        hasArabicFoundationStarted: hasArabicFoundationStarted,
        openedCount: openedCount,
        totalCount: snippets.length,
      );
    });

class QuranReadinessBridgeProgressNotifier
    extends StateNotifier<QuranReadinessBridgeProgressState> {
  QuranReadinessBridgeProgressNotifier(Ref ref, this._audience)
    : _store = ref.read(localStoreProvider),
      _activeLearnerId = _resolveLearnerId(ref, _audience),
      super(
        QuranReadinessBridgeProgressState.fromJson(
          ref
              .read(localStoreProvider)
              .getJsonMap(
                quranReadinessBridgeStorageKeyForAudience(
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
    state = QuranReadinessBridgeProgressState.fromJson(
      _store.getJsonMap(
        quranReadinessBridgeStorageKeyForAudience(
          _audience,
          learnerId: learnerId,
        ),
      ),
    );
  }

  void markSnippetOpened(String snippetId) {
    final nextOpened = Set<String>.from(state.openedSnippetIds)..add(snippetId);
    state = state.copyWith(
      lastSnippetId: snippetId,
      openedSnippetIds: nextOpened,
      lastOpenedAt: DateTime.now(),
    );
    _store.setJsonMap(
      quranReadinessBridgeStorageKeyForAudience(
        _audience,
        learnerId: _activeLearnerId,
      ),
      state.toJson(),
    );
  }
}

String? _extractSnippetFromAyah({
  required String ayahArabic,
  required String phraseArabic,
}) {
  final ayahWords = ayahArabic.trim().split(RegExp(r'\s+'));
  final phraseWords = phraseArabic.trim().split(RegExp(r'\s+'));
  if (phraseWords.isEmpty || ayahWords.length < phraseWords.length) {
    return null;
  }

  for (var start = 0; start <= ayahWords.length - phraseWords.length; start++) {
    var allMatch = true;
    for (var offset = 0; offset < phraseWords.length; offset++) {
      if (_normalizeArabicWord(ayahWords[start + offset]) !=
          _normalizeArabicWord(phraseWords[offset])) {
        allMatch = false;
        break;
      }
    }
    if (allMatch) {
      return ayahWords.sublist(start, start + phraseWords.length).join(' ');
    }
  }
  return null;
}

String _normalizeArabicWord(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if ((rune >= 0x064B && rune <= 0x065F) || rune == 0x0670) {
      continue;
    }
    buffer.writeCharCode(rune);
  }
  return buffer.toString();
}
