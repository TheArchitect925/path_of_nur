import '../../../../l10n/app_localizations.dart';
import '../domain/trivia_models.dart';

String localizedTriviaQuestionTypeLabel(
  AppLocalizations l10n,
  TriviaQuestionType type,
) {
  return switch (type) {
    TriviaQuestionType.multipleChoice => l10n.triviaQuestionTypeMultipleChoice,
    TriviaQuestionType.trueFalse => l10n.triviaQuestionTypeTrueFalse,
  };
}

String localizedTriviaModeLabel(AppLocalizations l10n, TriviaMode mode) {
  return switch (mode) {
    TriviaMode.quickChallenge => l10n.triviaModeQuickChallenge,
    TriviaMode.deepDive => l10n.triviaModeDeepDive,
    TriviaMode.dailyQuiz => l10n.triviaModeDailyQuiz,
    TriviaMode.survival => l10n.triviaModeSurvival,
    TriviaMode.reviewMistakes => l10n.triviaModeReviewMistakes,
  };
}

String localizedTriviaModeSubtitle(AppLocalizations l10n, TriviaMode mode) {
  return switch (mode) {
    TriviaMode.quickChallenge => l10n.triviaModeQuickChallengeSubtitle,
    TriviaMode.deepDive => l10n.triviaModeDeepDiveSubtitle,
    TriviaMode.dailyQuiz => l10n.triviaModeDailyQuizSubtitle,
    TriviaMode.survival => l10n.triviaModeSurvivalSubtitle,
    TriviaMode.reviewMistakes => l10n.triviaModeReviewMistakesSubtitle,
  };
}

String localizedTriviaMasteryLabel(
  AppLocalizations l10n,
  TriviaReviewMasteryState state,
) {
  return switch (state) {
    TriviaReviewMasteryState.newItem => l10n.triviaMasteryNew,
    TriviaReviewMasteryState.learning => l10n.triviaMasteryLearning,
    TriviaReviewMasteryState.improving => l10n.triviaMasteryImproving,
    TriviaReviewMasteryState.mastered => l10n.triviaMasteryMastered,
  };
}

String localizedTriviaCategoryTitle(
  AppLocalizations l10n,
  TriviaCategory category,
) {
  return switch (category.id) {
    'quran' => l10n.triviaCategoryQuranTitle,
    'prophets' => l10n.triviaCategoryProphetsTitle,
    'hadith' => l10n.triviaCategoryHadithTitle,
    'history' => l10n.triviaCategoryHistoryTitle,
    'general' => l10n.triviaCategoryGeneralTitle,
    'ramadan' => l10n.triviaCategoryRamadanTitle,
    'salah' => l10n.triviaCategorySalahTitle,
    'dua' => l10n.triviaCategoryDuaTitle,
    'seerah' => l10n.triviaCategorySeerahTitle,
    'women_in_islam' => l10n.triviaCategoryWomenInIslamTitle,
    'akhlaq' => l10n.triviaCategoryAkhlaqTitle,
    _ => category.title,
  };
}

String localizedTriviaCategorySubtitle(
  AppLocalizations l10n,
  TriviaCategory category,
) {
  return switch (category.id) {
    'quran' => l10n.triviaCategoryQuranSubtitle,
    'prophets' => l10n.triviaCategoryProphetsSubtitle,
    'hadith' => l10n.triviaCategoryHadithSubtitle,
    'history' => l10n.triviaCategoryHistorySubtitle,
    'general' => l10n.triviaCategoryGeneralSubtitle,
    'ramadan' => l10n.triviaCategoryRamadanSubtitle,
    'salah' => l10n.triviaCategorySalahSubtitle,
    'dua' => l10n.triviaCategoryDuaSubtitle,
    'seerah' => l10n.triviaCategorySeerahSubtitle,
    'women_in_islam' => l10n.triviaCategoryWomenInIslamSubtitle,
    'akhlaq' => l10n.triviaCategoryAkhlaqSubtitle,
    _ => category.subtitle,
  };
}

String localizedTriviaKnowledgePathTitle(
  AppLocalizations l10n,
  TriviaKnowledgePath path,
) {
  return switch (path.id) {
    'foundations_of_islam' => l10n.triviaKnowledgePathFoundationsTitle,
    'prophets_journey' => l10n.triviaKnowledgePathProphetsTitle,
    'understanding_the_quran' => l10n.triviaKnowledgePathQuranTitle,
    'learning_salah' => l10n.triviaKnowledgePathSalahTitle,
    _ => path.title,
  };
}

String localizedTriviaKnowledgePathDescription(
  AppLocalizations l10n,
  TriviaKnowledgePath path,
) {
  return switch (path.id) {
    'foundations_of_islam' => l10n.triviaKnowledgePathFoundationsDescription,
    'prophets_journey' => l10n.triviaKnowledgePathProphetsDescription,
    'understanding_the_quran' => l10n.triviaKnowledgePathQuranDescription,
    'learning_salah' => l10n.triviaKnowledgePathSalahDescription,
    _ => path.description,
  };
}

String localizedTriviaKnowledgeStageTitle(
  AppLocalizations l10n,
  TriviaKnowledgePath path,
  TriviaKnowledgeStage stage,
) {
  return switch ('${path.id}:${stage.id}') {
    'foundations_of_islam:what_is_islam' =>
      l10n.triviaKnowledgeStageFoundationsWhatIsIslam,
    'foundations_of_islam:revelation_and_guidance' =>
      l10n.triviaKnowledgeStageFoundationsRevelation,
    'foundations_of_islam:the_prophets' =>
      l10n.triviaKnowledgeStageFoundationsProphets,
    'foundations_of_islam:prayer_and_worship' =>
      l10n.triviaKnowledgeStageFoundationsPrayer,
    'foundations_of_islam:fasting_and_dua' =>
      l10n.triviaKnowledgeStageFoundationsFastingDua,
    'prophets_journey:first_prophets' => l10n.triviaKnowledgeStageProphetsFirst,
    'prophets_journey:nuh_hud_salih' =>
      l10n.triviaKnowledgeStageProphetsNuhHudSalih,
    'prophets_journey:ibrahim_family' =>
      l10n.triviaKnowledgeStageProphetsIbrahimFamily,
    'prophets_journey:musa_and_harun' =>
      l10n.triviaKnowledgeStageProphetsMusaHarun,
    'prophets_journey:dawud_to_yunus' =>
      l10n.triviaKnowledgeStageProphetsKingsWisdomTrial,
    'prophets_journey:isa_and_final_messenger' =>
      l10n.triviaKnowledgeStageProphetsIsaFinalMessenger,
    'understanding_the_quran:what_is_the_quran' =>
      l10n.triviaKnowledgeStageQuranWhatIs,
    'understanding_the_quran:revelation_begins' =>
      l10n.triviaKnowledgeStageQuranRevelationBegins,
    'understanding_the_quran:structure_and_terms' =>
      l10n.triviaKnowledgeStageQuranStructureTerms,
    'understanding_the_quran:famous_surahs' =>
      l10n.triviaKnowledgeStageQuranFamousSurahs,
    'understanding_the_quran:living_with_the_quran' =>
      l10n.triviaKnowledgeStageQuranLivingWithIt,
    'learning_salah:five_daily_prayers' =>
      l10n.triviaKnowledgeStageSalahFiveDailyPrayers,
    'learning_salah:conditions_of_prayer' =>
      l10n.triviaKnowledgeStageSalahConditions,
    'learning_salah:inside_a_rakah' =>
      l10n.triviaKnowledgeStageSalahInsideRakah,
    'learning_salah:congregation_and_jummah' =>
      l10n.triviaKnowledgeStageSalahCongregationJumuah,
    'learning_salah:sunnah_and_khushu' =>
      l10n.triviaKnowledgeStageSalahSunnahKhushu,
    _ => stage.title,
  };
}
