import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../domain/arabic_alphabet_models.dart';
import '../domain/arabic_learning_continuity_models.dart';

ArabicLearningRouteTarget adultLetterRouteTarget(
  ArabicAlphabetLetter letter,
  QuranTeachingCatalog catalog,
) {
  final lesson = catalog.lessons.firstWhere(
    (item) =>
        item.id.startsWith('alphabet_letters_') &&
        item.steps.any((step) => step.id == letter.quranTeachingSeedId),
    orElse: () => catalog.lessonById('alphabet_letters_1')!,
  );
  return ArabicLearningRouteTarget(
    kind: ArabicLearningRouteTargetKind.adultLesson,
    contentType: ArabicLearningContinuationContentType.letter,
    canonicalItemId: letter.id,
    lessonId: lesson.id,
    moduleId: lesson.moduleId,
  );
}

ArabicLearningRouteTarget? adultPhraseRouteTarget(String phraseId) {
  const mappedSnippetIds = <String, String>{
    'bismillah': 'bismillah_bridge',
    'alhamdulillah': 'alhamdulillah_bridge',
    'rabbil-alamin': 'rabbil_alamin_bridge',
    'iyyaka-nabudu': 'iyyaka_nabudu_bridge',
  };
  final snippetId = mappedSnippetIds[phraseId];
  if (snippetId == null) {
    return null;
  }
  return ArabicLearningRouteTarget(
    kind: ArabicLearningRouteTargetKind.goNamed,
    contentType: ArabicLearningContinuationContentType.phrase,
    canonicalItemId: phraseId,
    routeName: 'quranArabicReadiness',
    queryParameters: <String, String>{'snippet': snippetId},
  );
}

String? arabicLearningRouteLocationForTarget(ArabicLearningRouteTarget target) {
  switch (target.kind) {
    case ArabicLearningRouteTargetKind.goNamed:
      return _locationForNamedTarget(target);
    case ArabicLearningRouteTargetKind.adultLesson:
      final moduleId = target.moduleId;
      final lessonId = target.lessonId;
      if (moduleId == null || lessonId == null) {
        return null;
      }
      return '/quran/arabic/module/$moduleId/lesson/$lessonId';
    case ArabicLearningRouteTargetKind.adultModule:
      final moduleId = target.moduleId;
      if (moduleId == null) {
        return null;
      }
      return '/quran/arabic/module/$moduleId';
    case ArabicLearningRouteTargetKind.adultBeginnerWords:
      return _withQuery('/quran/arabic/words', <String, String>{
        if (target.wordId != null) 'word': target.wordId!,
      });
    case ArabicLearningRouteTargetKind.adultDailyReview:
      return '/quran/arabic/review';
  }
}

String? _locationForNamedTarget(ArabicLearningRouteTarget target) {
  final routeName = target.routeName;
  if (routeName == null || routeName.isEmpty) {
    return null;
  }
  switch (routeName) {
    case 'kidsArabicHome':
      return '/learn/kids/arabic';
    case 'kidsArabicLesson':
      final letterId = target.pathParameters['letterId'];
      return letterId == null ? null : '/learn/kids/arabic/lesson/$letterId';
    case 'kidsArabicWordsHome':
      return '/learn/kids/arabic/words';
    case 'kidsArabicWordLesson':
      final wordId = target.pathParameters['wordId'];
      return wordId == null ? null : '/learn/kids/arabic/words/$wordId';
    case 'kidsArabicReadingMode':
      return _withQuery(
        '/learn/kids/arabic/words/reading',
        target.queryParameters,
      );
    case 'kidsArabicMiniPhrases':
      return _withQuery('/learn/kids/arabic/phrases', target.queryParameters);
    case 'kidsArabicReview':
      return '/learn/kids/arabic/review';
    case 'kidsArabicProgressMap':
      return '/learn/kids/arabic/progress';
    case 'kidsArabicQuranReadiness':
      return _withQuery(
        '/learn/kids/arabic/quran-readiness',
        target.queryParameters,
      );
    case 'kidsArabicShortSurahs':
      return _withQuery(
        '/learn/kids/arabic/short-surahs',
        target.queryParameters,
      );
    case 'kidsArabicGuidedPassages':
      return _withQuery(
        '/learn/kids/arabic/guided-passages',
        target.queryParameters,
      );
    case 'kidsArabicMiniAssessment':
      return '/learn/kids/arabic/practice/quick';
    case 'quranArabic':
      return '/quran/arabic';
    case 'quranArabicReadiness':
      return _withQuery('/quran/arabic/readiness', target.queryParameters);
    case 'quranArabicShortSurahs':
      return _withQuery('/quran/arabic/short-surahs', target.queryParameters);
    case 'quranArabicGuidedPassages':
      return _withQuery(
        '/quran/arabic/guided-passages',
        target.queryParameters,
      );
    case 'quranArabicMiniAssessment':
      return '/quran/arabic/practice';
  }
  return null;
}

String _withQuery(String path, Map<String, String> queryParameters) {
  if (queryParameters.isEmpty) {
    return path;
  }
  return Uri(path: path, queryParameters: queryParameters).toString();
}
