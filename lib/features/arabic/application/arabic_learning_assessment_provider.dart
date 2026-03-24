import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../kids_arabic/application/kids_arabic_phrases_provider.dart';
import '../../kids_arabic/application/kids_arabic_progress_provider.dart';
import '../../kids_arabic/application/kids_arabic_words_provider.dart';
import '../../kids_arabic/domain/kids_arabic_phrase_models.dart';
import '../../kids_arabic/domain/kids_arabic_word_models.dart';
import '../../learn/quran/application/quran_readiness_bridge_provider.dart';
import '../../learn/quran/domain/quran_readiness_bridge_models.dart';
import '../../learn/quran_teaching/application/quran_teaching_controller.dart';
import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../data/arabic_alphabet_catalog.dart';
import '../data/arabic_beginner_content_catalog.dart';
import '../domain/arabic_alphabet_models.dart';
import '../domain/arabic_learning_assessment_models.dart';
import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_progress_models.dart';
import '../domain/arabic_beginner_content_models.dart';
import 'arabic_learning_continuity_provider.dart';
import 'arabic_learning_progress_provider.dart';
import 'arabic_learning_review_provider.dart';
import 'arabic_learning_route_target_helpers.dart';

final arabicLearningMiniAssessmentSessionProvider =
    Provider.family<ArabicLearningAssessmentSession, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      switch (audience) {
        case ArabicLearningAudience.kids:
          return _buildKidsSession(ref);
        case ArabicLearningAudience.adult:
          return _buildAdultSession(ref);
      }
    });

ArabicLearningAssessmentSession _buildKidsSession(Ref ref) {
  final continuation = ref.watch(
    arabicLearningContinuationProvider(ArabicLearningAudience.kids),
  );
  final review = ref.watch(arabicLearningReviewProvider(ArabicLearningAudience.kids));
  final progress = ref.watch(
    arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids),
  );
  final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
  final wordStatuses = ref.watch(kidsArabicWordStatusesProvider);
  final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
  final phraseProgress = ref.watch(kidsArabicMiniPhraseProgressProvider);

  final unlockedLetters = arabicAlphabetCatalog
      .where((letter) => unlockedLetterIds.contains(letter.id))
      .toList(growable: false);
  final letterPool = unlockedLetters.length >= 3
      ? unlockedLetters
      : arabicAlphabetCatalog.take(4).toList(growable: false);
  final wordPool = wordStatuses
      .where((status) => status.unlocked)
      .map((status) => status.word)
      .toList(growable: false);
  final phrasePool = phrases.toList(growable: false);
  final seedPools = <ArabicLearningContinuationContentType, List<_AssessmentSeed>>{
    ArabicLearningContinuationContentType.letter: letterPool
        .map(_kidsLetterSeed)
        .toList(growable: false),
    ArabicLearningContinuationContentType.word: wordPool
        .map(_kidsWordSeed)
        .toList(growable: false),
    ArabicLearningContinuationContentType.phrase: phrasePool
        .map(_kidsPhraseSeed)
        .toList(growable: false),
  };

  final prioritized = <_AssessmentSeed>[];
  final seen = <String>{};

  void addSeed(_AssessmentSeed? seed) {
    if (seed == null) {
      return;
    }
    final key = '${seed.contentType.name}:${seed.itemId}';
    if (!seen.add(key)) {
      return;
    }
    prioritized.add(seed);
  }

  final suggestionOrder = <ArabicLearningReviewSuggestion>[
    review.primarySuggestion,
    ...review.secondarySuggestions,
  ];
  for (final suggestion in suggestionOrder) {
    addSeed(
      _kidsSeedFromSuggestion(
        suggestion,
        letters: letterPool,
        words: wordPool,
        phrases: phrasePool,
      ),
    );
  }

  addSeed(
    _kidsSeedFromRecentActivity(
      progress.recentActivity,
      letters: letterPool,
      words: wordPool,
      phrases: phrasePool,
    ),
  );

  addSeed(
    _kidsSeedFromContinuation(
      continuation,
      letters: letterPool,
      words: wordPool,
      phrases: phrasePool,
    ),
  );

  for (final letter in letterPool.take(2)) {
    addSeed(_kidsLetterSeed(letter));
  }
  for (final word in wordPool.take(1)) {
    addSeed(_kidsWordSeed(word));
  }
  if (phrasePool.isNotEmpty) {
    final phraseId = phraseProgress.lastPhraseId;
    final preferredPhrase = phraseId == null
        ? phrasePool.first
        : phrasePool.firstWhere(
            (phrase) => phrase.id == phraseId,
            orElse: () => phrasePool.first,
          );
    addSeed(_kidsPhraseSeed(preferredPhrase));
  }

  final maxQuestions = progress.hasStarted ? 3 : 1;
  final questions = _buildQuestions(
    prioritized.take(maxQuestions).toList(growable: false),
    seedPools,
  );

  return ArabicLearningAssessmentSession(
    audience: ArabicLearningAudience.kids,
    questions: questions,
    continueTarget: continuation.primaryTarget,
    reviewSuggestion: progress.reviewSuggestion,
  );
}

ArabicLearningAssessmentSession _buildAdultSession(Ref ref) {
  final continuation = ref.watch(
    arabicLearningContinuationProvider(ArabicLearningAudience.adult),
  );
  final review = ref.watch(
    arabicLearningReviewProvider(ArabicLearningAudience.adult),
  );
  final progress = ref.watch(
    arabicLearningProgressSummaryProvider(ArabicLearningAudience.adult),
  );
  final catalog = ref.watch(quranTeachingCatalogProvider);
  final words = ref.watch(quranTeachingBeginnerWordsProvider);
  final readinessSnippets = ref.watch(quranReadinessBridgeSnippetsProvider);

  final phrasePool = arabicSharedMiniPhrases
      .where((phrase) => adultPhraseRouteTarget(phrase.id) != null)
      .toList(growable: false);
  final seedPools = <ArabicLearningContinuationContentType, List<_AssessmentSeed>>{
    ArabicLearningContinuationContentType.letter: arabicAlphabetCatalog
        .map((letter) => _adultLetterSeed(letter, catalog))
        .toList(growable: false),
    ArabicLearningContinuationContentType.word: words
        .map(_adultWordSeed)
        .toList(growable: false),
    ArabicLearningContinuationContentType.phrase: phrasePool
        .map(_adultPhraseSeed)
        .toList(growable: false),
  };

  final prioritized = <_AssessmentSeed>[];
  final seen = <String>{};

  void addSeed(_AssessmentSeed? seed) {
    if (seed == null) {
      return;
    }
    final key = '${seed.contentType.name}:${seed.itemId}';
    if (!seen.add(key)) {
      return;
    }
    prioritized.add(seed);
  }

  final suggestionOrder = <ArabicLearningReviewSuggestion>[
    review.primarySuggestion,
    ...review.secondarySuggestions,
  ];
  for (final suggestion in suggestionOrder) {
    addSeed(
      _adultSeedFromSuggestion(
        suggestion,
        catalog: catalog,
        words: words,
        phrases: phrasePool,
      ),
    );
  }

  addSeed(
    _adultSeedFromRecentActivity(
      progress.recentActivity,
      catalog: catalog,
      words: words,
      phrases: phrasePool,
      readinessSnippets: readinessSnippets,
    ),
  );

  addSeed(
    _adultSeedFromContinuation(
      continuation,
      catalog: catalog,
      words: words,
      phrases: phrasePool,
    ),
  );

  for (final letter in arabicAlphabetCatalog.take(2)) {
    addSeed(_adultLetterSeed(letter, catalog));
  }
  for (final word in words.take(1)) {
    addSeed(_adultWordSeed(word));
  }
  for (final phrase in phrasePool.take(1)) {
    addSeed(_adultPhraseSeed(phrase));
  }

  final maxQuestions = progress.hasStarted ? 3 : 1;
  final questions = _buildQuestions(
    prioritized.take(maxQuestions).toList(growable: false),
    seedPools,
  );

  return ArabicLearningAssessmentSession(
    audience: ArabicLearningAudience.adult,
    questions: questions,
    continueTarget: continuation.primaryTarget,
    reviewSuggestion: progress.reviewSuggestion,
  );
}

List<ArabicLearningAssessmentQuestion> _buildQuestions(
  List<_AssessmentSeed> seeds,
  Map<ArabicLearningContinuationContentType, List<_AssessmentSeed>> seedPools,
) {
  final questions = <ArabicLearningAssessmentQuestion>[];
  for (var index = 0; index < seeds.length; index++) {
    final seed = seeds[index];
    final sameTypePool = seedPools[seed.contentType] ?? const <_AssessmentSeed>[];
    final distractors = _distractorsFor(seed, sameTypePool);
    final options = <ArabicLearningAssessmentOption>[
      seed.option,
      ...distractors.map((item) => item.option),
    ];
    final rotatedOptions = _rotateOptions(options, index % options.length);
    var questionType = index.isEven
        ? ArabicLearningAssessmentQuestionType.seeChoose
        : ArabicLearningAssessmentQuestionType.hearChoose;
    if (questionType == ArabicLearningAssessmentQuestionType.hearChoose &&
        seed.audioFallbackText == null &&
        seed.audioAssetPath == null &&
        seed.audioAlternateAssetPaths.isEmpty) {
      questionType = ArabicLearningAssessmentQuestionType.seeChoose;
    }
    questions.add(
      ArabicLearningAssessmentQuestion(
        questionId: '${seed.contentType.name}_${seed.itemId}_$index',
        itemId: seed.itemId,
        contentType: seed.contentType,
        type: questionType,
        correctOptionId: seed.option.id,
        followUpTarget: seed.target,
        title: seed.option.title,
        arabicPrompt: seed.option.arabicText,
        transliteration: seed.option.transliteration,
        meaning: seed.option.meaning,
        audioPlaybackId: seed.audioPlaybackId,
        audioAssetPath: seed.audioAssetPath,
        audioAlternateAssetPaths: seed.audioAlternateAssetPaths,
        audioFallbackText: seed.audioFallbackText,
        options: rotatedOptions,
      ),
    );
  }
  return questions;
}

List<_AssessmentSeed> _distractorsFor(
  _AssessmentSeed seed,
  List<_AssessmentSeed> sameTypePool,
) {
  if (sameTypePool.length <= 1) {
    return const <_AssessmentSeed>[];
  }
  final ordered = sameTypePool.where((item) => item.itemId != seed.itemId).toList(
        growable: false,
      );
  if (ordered.isEmpty) {
    return const <_AssessmentSeed>[];
  }
  final maxDistractors = ordered.length >= 3 ? 3 : 2;
  return ordered.take(maxDistractors).toList(growable: false);
}

List<ArabicLearningAssessmentOption> _rotateOptions(
  List<ArabicLearningAssessmentOption> options,
  int shift,
) {
  if (options.length <= 1 || shift == 0) {
    return options;
  }
  return <ArabicLearningAssessmentOption>[
    ...options.skip(shift),
    ...options.take(shift),
  ];
}

_AssessmentSeed? _kidsSeedFromSuggestion(
  ArabicLearningReviewSuggestion suggestion, {
  required List<ArabicAlphabetLetter> letters,
  required List<KidsArabicBeginnerWord> words,
  required List<KidsArabicMiniPhrase> phrases,
}) {
  switch (suggestion.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = letters.where((item) => item.id == suggestion.itemId).firstOrNull;
      return letter == null ? null : _kidsLetterSeed(letter);
    case ArabicLearningContinuationContentType.word:
      final word = words.where((item) => item.id == suggestion.itemId).firstOrNull;
      return word == null ? null : _kidsWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final phrase = phrases.where((item) => item.id == suggestion.itemId).firstOrNull;
      return phrase == null ? null : _kidsPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

_AssessmentSeed? _kidsSeedFromRecentActivity(
  ArabicLearningRecentActivity? activity, {
  required List<ArabicAlphabetLetter> letters,
  required List<KidsArabicBeginnerWord> words,
  required List<KidsArabicMiniPhrase> phrases,
}) {
  if (activity == null) {
    return null;
  }
  switch (activity.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = letters.where((item) => item.id == activity.itemId).firstOrNull;
      return letter == null ? null : _kidsLetterSeed(letter);
    case ArabicLearningContinuationContentType.word:
      final word = words.where((item) => item.id == activity.itemId).firstOrNull;
      return word == null ? null : _kidsWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final phrase = phrases.where((item) => item.id == activity.itemId).firstOrNull;
      return phrase == null ? null : _kidsPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

_AssessmentSeed? _kidsSeedFromContinuation(
  ArabicLearningContinuationSummary continuation, {
  required List<ArabicAlphabetLetter> letters,
  required List<KidsArabicBeginnerWord> words,
  required List<KidsArabicMiniPhrase> phrases,
}) {
  switch (continuation.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = letters
          .where((item) => item.id == continuation.primaryItemId)
          .firstOrNull;
      return letter == null ? null : _kidsLetterSeed(letter);
    case ArabicLearningContinuationContentType.word:
      final word = words
          .where((item) => item.id == continuation.primaryItemId)
          .firstOrNull;
      return word == null ? null : _kidsWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final phrase = phrases
          .where((item) => item.id == continuation.primaryItemId)
          .firstOrNull;
      return phrase == null ? null : _kidsPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

_AssessmentSeed _kidsLetterSeed(ArabicAlphabetLetter letter) {
  return _AssessmentSeed(
    itemId: letter.id,
    contentType: ArabicLearningContinuationContentType.letter,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.letter,
      canonicalItemId: letter.id,
      routeName: 'kidsArabicLesson',
      pathParameters: <String, String>{'letterId': letter.id},
    ),
    option: ArabicLearningAssessmentOption(
      id: letter.id,
      title: letter.kidsNameEn,
      arabicText: letter.glyph,
      transliteration: letter.kidsTransliteration,
      meaning: letter.soundHint,
    ),
    audioPlaybackId: 'letter:${letter.id}',
    audioAssetPath: letter.quranTeachingAudioAssetPath,
    audioFallbackText: letter.glyph,
  );
}

_AssessmentSeed _kidsWordSeed(KidsArabicBeginnerWord word) {
  final sharedWord = arabicSharedBeginnerWordById(word.id);
  return _AssessmentSeed(
    itemId: word.id,
    contentType: ArabicLearningContinuationContentType.word,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.word,
      canonicalItemId: word.id,
      routeName: 'kidsArabicWordLesson',
      pathParameters: <String, String>{'wordId': word.id},
    ),
    option: ArabicLearningAssessmentOption(
      id: word.id,
      title: word.transliteration,
      arabicText: word.wordAr,
      transliteration: word.transliteration,
      meaning: sharedWord?.simpleMeaning,
    ),
    audioPlaybackId: 'word:${word.id}',
    audioAssetPath: sharedWord?.audioAssetPath,
    audioFallbackText: word.wordAr,
  );
}

_AssessmentSeed _kidsPhraseSeed(KidsArabicMiniPhrase phrase) {
  final sharedPhrase = arabicSharedMiniPhraseById(phrase.id);
  return _AssessmentSeed(
    itemId: phrase.id,
    contentType: ArabicLearningContinuationContentType.phrase,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.goNamed,
      contentType: ArabicLearningContinuationContentType.phrase,
      canonicalItemId: phrase.id,
      routeName: 'kidsArabicMiniPhrases',
      queryParameters: <String, String>{'phrase': phrase.id},
    ),
    option: ArabicLearningAssessmentOption(
      id: phrase.id,
      title: phrase.transliteration,
      arabicText: phrase.phraseAr,
      transliteration: phrase.transliteration,
      meaning: sharedPhrase?.simpleMeaning,
    ),
    audioPlaybackId: 'phrase:${phrase.id}',
    audioAssetPath: sharedPhrase?.audioAssetPath,
    audioFallbackText: phrase.phraseAr,
  );
}

_AssessmentSeed? _adultSeedFromSuggestion(
  ArabicLearningReviewSuggestion suggestion, {
  required QuranTeachingCatalog catalog,
  required List<QuranWordEntry> words,
  required List<ArabicBeginnerPhraseEntry> phrases,
}) {
  switch (suggestion.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = arabicAlphabetLetterById(suggestion.itemId);
      return letter == null ? null : _adultLetterSeed(letter, catalog);
    case ArabicLearningContinuationContentType.word:
      final word = words
          .where(
            (item) => (item.sharedBeginnerWordId ?? item.id) == suggestion.itemId,
          )
          .firstOrNull;
      return word == null ? null : _adultWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final phrase = phrases.where((item) => item.id == suggestion.itemId).firstOrNull;
      return phrase == null ? null : _adultPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
      final lesson = catalog.lessonById(suggestion.itemId);
      final firstLetter = lesson == null ? null : _firstLetterForLesson(lesson);
      return firstLetter == null ? null : _adultLetterSeed(firstLetter, catalog);
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

_AssessmentSeed? _adultSeedFromRecentActivity(
  ArabicLearningRecentActivity? activity, {
  required QuranTeachingCatalog catalog,
  required List<QuranWordEntry> words,
  required List<ArabicBeginnerPhraseEntry> phrases,
  required List<QuranReadinessBridgeSnippet> readinessSnippets,
}) {
  if (activity == null) {
    return null;
  }
  switch (activity.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = arabicAlphabetLetterById(activity.itemId);
      return letter == null ? null : _adultLetterSeed(letter, catalog);
    case ArabicLearningContinuationContentType.word:
      final word = words
          .where((item) => (item.sharedBeginnerWordId ?? item.id) == activity.itemId)
          .firstOrNull;
      return word == null ? null : _adultWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final snippet = readinessSnippets
          .where((item) => item.id == activity.itemId)
          .firstOrNull;
      if (snippet != null) {
        final phrase = snippet.sharedPhrase;
        if (phrase != null && adultPhraseRouteTarget(phrase.id) != null) {
          return _adultPhraseSeed(phrase);
        }
      }
      final phrase = phrases.where((item) => item.id == activity.itemId).firstOrNull;
      return phrase == null ? null : _adultPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
      final lesson = catalog.lessonById(activity.itemId);
      final letter = lesson == null ? null : _firstLetterForLesson(lesson);
      return letter == null ? null : _adultLetterSeed(letter, catalog);
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

_AssessmentSeed? _adultSeedFromContinuation(
  ArabicLearningContinuationSummary continuation, {
  required QuranTeachingCatalog catalog,
  required List<QuranWordEntry> words,
  required List<ArabicBeginnerPhraseEntry> phrases,
}) {
  switch (continuation.contentType) {
    case ArabicLearningContinuationContentType.letter:
      final letter = arabicAlphabetLetterById(continuation.primaryItemId);
      return letter == null ? null : _adultLetterSeed(letter, catalog);
    case ArabicLearningContinuationContentType.word:
      final word = words
          .where(
            (item) => (item.sharedBeginnerWordId ?? item.id) == continuation.primaryItemId,
          )
          .firstOrNull;
      return word == null ? null : _adultWordSeed(word);
    case ArabicLearningContinuationContentType.phrase:
      final phrase = phrases
          .where((item) => item.id == continuation.primaryItemId)
          .firstOrNull;
      return phrase == null ? null : _adultPhraseSeed(phrase);
    case ArabicLearningContinuationContentType.lesson:
      final lesson = catalog.lessonById(continuation.primaryItemId);
      final letter = lesson == null ? null : _firstLetterForLesson(lesson);
      return letter == null ? null : _adultLetterSeed(letter, catalog);
    case ArabicLearningContinuationContentType.review:
      return null;
  }
}

ArabicAlphabetLetter? _firstLetterForLesson(QuranTeachingLesson lesson) {
  for (final step in lesson.steps) {
    final letter = arabicAlphabetCatalog
        .where((item) => item.quranTeachingSeedId == step.id)
        .firstOrNull;
    if (letter != null) {
      return letter;
    }
  }
  return null;
}

_AssessmentSeed _adultLetterSeed(
  ArabicAlphabetLetter letter,
  QuranTeachingCatalog catalog,
) {
  return _AssessmentSeed(
    itemId: letter.id,
    contentType: ArabicLearningContinuationContentType.letter,
    target: adultLetterRouteTarget(letter, catalog),
    option: ArabicLearningAssessmentOption(
      id: letter.id,
      title: letter.adultNameEn,
      arabicText: letter.glyph,
      transliteration: letter.adultTransliteration,
      meaning: letter.soundHint,
    ),
    audioPlaybackId: 'letter:${letter.id}',
    audioAssetPath: letter.quranTeachingAudioAssetPath,
    audioFallbackText: letter.glyph,
  );
}

_AssessmentSeed _adultWordSeed(QuranWordEntry word) {
  return _AssessmentSeed(
    itemId: word.sharedBeginnerWordId ?? word.id,
    contentType: ArabicLearningContinuationContentType.word,
    target: ArabicLearningRouteTarget(
      kind: ArabicLearningRouteTargetKind.adultBeginnerWords,
      contentType: ArabicLearningContinuationContentType.word,
      canonicalItemId: word.sharedBeginnerWordId ?? word.id,
      wordId: word.sharedBeginnerWordId ?? word.id,
    ),
    option: ArabicLearningAssessmentOption(
      id: word.sharedBeginnerWordId ?? word.id,
      title: word.transliteration,
      arabicText: word.arabic,
      transliteration: word.transliteration,
      meaning: word.meaning,
    ),
    audioPlaybackId: 'word:${word.sharedBeginnerWordId ?? word.id}',
    audioAssetPath: word.audio?.assetPath,
    audioAlternateAssetPaths: word.audio?.alternateAudioAssetPaths ?? const <String>[],
    audioFallbackText: word.audio?.fallbackTextLabel ?? word.arabic,
  );
}

_AssessmentSeed _adultPhraseSeed(ArabicBeginnerPhraseEntry phrase) {
  return _AssessmentSeed(
    itemId: phrase.id,
    contentType: ArabicLearningContinuationContentType.phrase,
    target: adultPhraseRouteTarget(phrase.id)!,
    option: ArabicLearningAssessmentOption(
      id: phrase.id,
      title: phrase.transliteration,
      arabicText: phrase.arabicText,
      transliteration: phrase.transliteration,
      meaning: phrase.simpleMeaning,
    ),
    audioPlaybackId: 'phrase:${phrase.id}',
    audioAssetPath: phrase.audioAssetPath,
    audioFallbackText: phrase.arabicText,
  );
}

class _AssessmentSeed {
  const _AssessmentSeed({
    required this.itemId,
    required this.contentType,
    required this.target,
    required this.option,
    this.audioPlaybackId,
    this.audioAssetPath,
    this.audioAlternateAssetPaths = const <String>[],
    this.audioFallbackText,
  });

  final String itemId;
  final ArabicLearningContinuationContentType contentType;
  final ArabicLearningRouteTarget target;
  final ArabicLearningAssessmentOption option;
  final String? audioPlaybackId;
  final String? audioAssetPath;
  final List<String> audioAlternateAssetPaths;
  final String? audioFallbackText;
}
