import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../domain/learning_journey_models.dart';
import 'learning_journey_lesson_content.dart';

// Source-of-truth note for learning text:
// Registry data owns structure, IDs, and progression.
// UI-facing copy should resolve through this helper layer whenever localized
// strings are available. Lesson bodies should resolve through
// [LearningJourneyLocalizedLessonContentRegistry] or
// [LearningJourneyLessonContentRegistry] first, then fall back to registry defaults
// as a controlled fallback.

String localizedJourneyTitle(BuildContext context, LearningJourney journey) {
  final l10n = AppLocalizations.of(context);
  return switch (journey.id) {
    'islam-foundations' => l10n.learningJourneyIslamFoundationsTitle,
    'daily-routines' => l10n.learningJourneyDailyRoutinesTitle,
    'foundations-of-faith' => l10n.learningJourneyFaithFoundationsTitle,
    'fiqh-basics' => l10n.learningJourneyFiqhBasicsTitle,
    'timeline-of-islam' => l10n.learningJourneyTimelineTitle,
    'daily-wisdom' => l10n.learningJourneyDailyWisdomTitle,
    'stories-signs' => l10n.learningJourneyStoriesSignsTitle,
    'journey-quran' => l10n.learningJourneyQuranJourneyTitle,
    'understanding-al-fatihah' => l10n.learningJourneyFatihahTitle,
    'short-surahs' => l10n.learningJourneyShortSurahsTitle,
    'prophets-journey' => l10n.learningJourneyProphetsJourneyTitle,
    'seerah-journey' => l10n.learningJourneySeerahJourneyTitle,
    'hadith-essentials' => l10n.learningJourneyHadithEssentialsTitle,
    'salah-foundations' => l10n.learningJourneySalahFoundationsTitle,
    'duas-daily-life' => l10n.learningJourneyDuasDailyLifeTitle,
    'daily-dhikr' => l10n.learningJourneyDailyDhikrTitle,
    'journey-of-wudu' => l10n.learningJourneyWuduJourneyTitle,
    'ramadan-foundations' => l10n.learningJourneyRamadanFoundationsTitle,
    'arabic-alphabet' => l10n.learningJourneyArabicAlphabetTitle,
    'reading-basics' => l10n.learningJourneyReadingBasicsTitle,
    'trivia-knowledge-paths' => l10n.learningJourneyTriviaPathsTitle,
    'beautiful-character' => l10n.learningJourneyBeautifulCharacterTitle,
    _ => journey.title,
  };
}

String localizedJourneySubtitle(BuildContext context, LearningJourney journey) {
  final l10n = AppLocalizations.of(context);
  return switch (journey.id) {
    'islam-foundations' => l10n.learningJourneyIslamFoundationsSubtitle,
    'daily-routines' => l10n.learningJourneyDailyRoutinesSubtitle,
    'foundations-of-faith' => l10n.learningJourneyFaithFoundationsSubtitle,
    'fiqh-basics' => l10n.learningJourneyFiqhBasicsSubtitle,
    'timeline-of-islam' => l10n.learningJourneyTimelineSubtitle,
    'daily-wisdom' => l10n.learningJourneyDailyWisdomSubtitle,
    'stories-signs' => l10n.learningJourneyStoriesSignsSubtitle,
    'journey-quran' => l10n.learningJourneyQuranJourneySubtitle,
    'understanding-al-fatihah' => l10n.learningJourneyFatihahSubtitle,
    'short-surahs' => l10n.learningJourneyShortSurahsSubtitle,
    'prophets-journey' => l10n.learningJourneyProphetsJourneySubtitle,
    'seerah-journey' => l10n.learningJourneySeerahJourneySubtitle,
    'hadith-essentials' => l10n.learningJourneyHadithEssentialsSubtitle,
    'salah-foundations' => l10n.learningJourneySalahFoundationsSubtitle,
    'duas-daily-life' => l10n.learningJourneyDuasDailyLifeSubtitle,
    'daily-dhikr' => l10n.learningJourneyDailyDhikrSubtitle,
    'journey-of-wudu' => l10n.learningJourneyWuduJourneySubtitle,
    'ramadan-foundations' => l10n.learningJourneyRamadanFoundationsSubtitle,
    'arabic-alphabet' => l10n.learningJourneyArabicAlphabetSubtitle,
    'reading-basics' => l10n.learningJourneyReadingBasicsSubtitle,
    'trivia-knowledge-paths' => l10n.learningJourneyTriviaPathsSubtitle,
    'beautiful-character' => l10n.learningJourneyBeautifulCharacterSubtitle,
    _ => journey.subtitle,
  };
}

String localizedJourneyDescription(
  BuildContext context,
  LearningJourney journey,
) {
  final l10n = AppLocalizations.of(context);
  return switch (journey.id) {
    'islam-foundations' => l10n.learningJourneyIslamFoundationsDescription,
    'daily-routines' => l10n.learningJourneyDailyRoutinesDescription,
    'foundations-of-faith' => l10n.learningJourneyFaithFoundationsDescription,
    'fiqh-basics' => l10n.learningJourneyFiqhBasicsDescription,
    'timeline-of-islam' => l10n.learningJourneyTimelineDescription,
    'daily-wisdom' => l10n.learningJourneyDailyWisdomDescription,
    'stories-signs' => l10n.learningJourneyStoriesSignsDescription,
    'journey-quran' => l10n.learningJourneyQuranJourneyDescription,
    'understanding-al-fatihah' => l10n.learningJourneyFatihahDescription,
    'short-surahs' => l10n.learningJourneyShortSurahsDescription,
    'prophets-journey' => l10n.learningJourneyProphetsJourneyDescription,
    'seerah-journey' => l10n.learningJourneySeerahJourneyDescription,
    'hadith-essentials' => l10n.learningJourneyHadithEssentialsDescription,
    'salah-foundations' => l10n.learningJourneySalahFoundationsDescription,
    'duas-daily-life' => l10n.learningJourneyDuasDailyLifeDescription,
    'daily-dhikr' => l10n.learningJourneyDailyDhikrDescription,
    'journey-of-wudu' => l10n.learningJourneyWuduJourneyDescription,
    'ramadan-foundations' => l10n.learningJourneyRamadanFoundationsDescription,
    'arabic-alphabet' => l10n.learningJourneyArabicAlphabetDescription,
    'reading-basics' => l10n.learningJourneyReadingBasicsDescription,
    'trivia-knowledge-paths' => l10n.learningJourneyTriviaPathsDescription,
    'beautiful-character' => l10n.learningJourneyBeautifulCharacterDescription,
    _ => journey.description,
  };
}

String localizedJourneyMappingNotes(
  BuildContext context,
  LearningJourney journey,
) {
  return journey.mappingNotes ?? '';
}

List<String> localizedJourneyLearningOutcomes(
  BuildContext context,
  LearningJourney journey,
) {
  final l10n = AppLocalizations.of(context);
  return switch (journey.id) {
    'islam-foundations' => <String>[
      l10n.learningJourneyIslamFoundationsOutcome1,
      l10n.learningJourneyIslamFoundationsOutcome2,
      l10n.learningJourneyIslamFoundationsOutcome3,
    ],
    'daily-routines' => <String>[
      l10n.learningJourneyDailyRoutinesOutcome1,
      l10n.learningJourneyDailyRoutinesOutcome2,
      l10n.learningJourneyDailyRoutinesOutcome3,
    ],
    'foundations-of-faith' => <String>[
      l10n.learningJourneyFaithFoundationsOutcome1,
      l10n.learningJourneyFaithFoundationsOutcome2,
      l10n.learningJourneyFaithFoundationsOutcome3,
    ],
    'fiqh-basics' => <String>[
      l10n.learningJourneyFiqhBasicsOutcome1,
      l10n.learningJourneyFiqhBasicsOutcome2,
      l10n.learningJourneyFiqhBasicsOutcome3,
    ],
    'timeline-of-islam' => <String>[
      l10n.learningJourneyTimelineOutcome1,
      l10n.learningJourneyTimelineOutcome2,
      l10n.learningJourneyTimelineOutcome3,
    ],
    'daily-wisdom' => <String>[
      l10n.learningJourneyDailyWisdomOutcome1,
      l10n.learningJourneyDailyWisdomOutcome2,
      l10n.learningJourneyDailyWisdomOutcome3,
    ],
    'stories-signs' => <String>[
      l10n.learningJourneyStoriesSignsOutcome1,
      l10n.learningJourneyStoriesSignsOutcome2,
      l10n.learningJourneyStoriesSignsOutcome3,
    ],
    'journey-quran' => <String>[
      l10n.learningJourneyQuranJourneyOutcome1,
      l10n.learningJourneyQuranJourneyOutcome2,
      l10n.learningJourneyQuranJourneyOutcome3,
    ],
    'understanding-al-fatihah' => <String>[
      l10n.learningJourneyFatihahOutcome1,
      l10n.learningJourneyFatihahOutcome2,
      l10n.learningJourneyFatihahOutcome3,
    ],
    'short-surahs' => <String>[
      l10n.learningJourneyShortSurahsOutcome1,
      l10n.learningJourneyShortSurahsOutcome2,
      l10n.learningJourneyShortSurahsOutcome3,
    ],
    'hadith-essentials' => <String>[
      l10n.learningJourneyHadithEssentialsOutcome1,
      l10n.learningJourneyHadithEssentialsOutcome2,
      l10n.learningJourneyHadithEssentialsOutcome3,
    ],
    'salah-foundations' => <String>[
      l10n.learningJourneySalahFoundationsOutcome1,
      l10n.learningJourneySalahFoundationsOutcome2,
      l10n.learningJourneySalahFoundationsOutcome3,
    ],
    'journey-of-wudu' => <String>[
      l10n.learningJourneyWuduJourneyOutcome1,
      l10n.learningJourneyWuduJourneyOutcome2,
      l10n.learningJourneyWuduJourneyOutcome3,
    ],
    'ramadan-foundations' => <String>[
      l10n.learningJourneyRamadanFoundationsOutcome1,
      l10n.learningJourneyRamadanFoundationsOutcome2,
      l10n.learningJourneyRamadanFoundationsOutcome3,
    ],
    'arabic-alphabet' => <String>[
      l10n.learningJourneyArabicAlphabetOutcome1,
      l10n.learningJourneyArabicAlphabetOutcome2,
      l10n.learningJourneyArabicAlphabetOutcome3,
    ],
    'reading-basics' => <String>[
      l10n.learningJourneyReadingBasicsOutcome1,
      l10n.learningJourneyReadingBasicsOutcome2,
      l10n.learningJourneyReadingBasicsOutcome3,
    ],
    'trivia-knowledge-paths' => <String>[
      l10n.learningJourneyTriviaPathsOutcome1,
      l10n.learningJourneyTriviaPathsOutcome2,
      l10n.learningJourneyTriviaPathsOutcome3,
    ],
    'beautiful-character' => <String>[
      l10n.learningJourneyBeautifulCharacterOutcome1,
      l10n.learningJourneyBeautifulCharacterOutcome2,
      l10n.learningJourneyBeautifulCharacterOutcome3,
    ],
    _ => journey.learningOutcomes,
  };
}

String? localizedJourneyWhyThisMatters(
  BuildContext context,
  LearningJourney journey,
) {
  final l10n = AppLocalizations.of(context);
  return switch (journey.id) {
    'islam-foundations' => l10n.learningJourneyIslamFoundationsWhyThisMatters,
    'daily-routines' => l10n.learningJourneyDailyRoutinesWhyThisMatters,
    'foundations-of-faith' =>
      l10n.learningJourneyFaithFoundationsWhyThisMatters,
    'fiqh-basics' => l10n.learningJourneyFiqhBasicsWhyThisMatters,
    'timeline-of-islam' => l10n.learningJourneyTimelineWhyThisMatters,
    'daily-wisdom' => l10n.learningJourneyDailyWisdomWhyThisMatters,
    'stories-signs' => l10n.learningJourneyStoriesSignsWhyThisMatters,
    'journey-quran' => l10n.learningJourneyQuranJourneyWhyThisMatters,
    'understanding-al-fatihah' => l10n.learningJourneyFatihahWhyThisMatters,
    'short-surahs' => l10n.learningJourneyShortSurahsWhyThisMatters,
    'hadith-essentials' => l10n.learningJourneyHadithEssentialsWhyThisMatters,
    'salah-foundations' => l10n.learningJourneySalahFoundationsWhyThisMatters,
    'journey-of-wudu' => l10n.learningJourneyWuduJourneyWhyThisMatters,
    'ramadan-foundations' =>
      l10n.learningJourneyRamadanFoundationsWhyThisMatters,
    'arabic-alphabet' => l10n.learningJourneyArabicAlphabetWhyThisMatters,
    'reading-basics' => l10n.learningJourneyReadingBasicsWhyThisMatters,
    'trivia-knowledge-paths' => l10n.learningJourneyTriviaPathsWhyThisMatters,
    'beautiful-character' =>
      l10n.learningJourneyBeautifulCharacterWhyThisMatters,
    _ => journey.whyThisMatters,
  };
}

String localizedStageNotes(BuildContext context, LearningJourneyStage stage) {
  final l10n = AppLocalizations.of(context);
  final lesson = LearningJourneyLessonContentRegistry.lessonForStage(
    stage.id,
    l10n,
  );
  if (lesson != null) {
    if (lesson.introduction.isNotEmpty) {
      return lesson.introduction;
    }
  }
  return stage.notes ?? '';
}

List<String> localizedStagePlannedIncludes(
  BuildContext context,
  LearningJourneyStage stage,
) {
  final l10n = AppLocalizations.of(context);
  final lesson = LearningJourneyLessonContentRegistry.lessonForStage(
    stage.id,
    l10n,
  );
  if (lesson != null && lesson.keyTakeaways.isNotEmpty) {
    return lesson.keyTakeaways;
  }
  return stage.plannedIncludes;
}

String localizedIslandTitle(
  BuildContext context,
  LearningJourneyIsland island,
) {
  final l10n = AppLocalizations.of(context);
  return switch (island.id) {
    'core-knowledge' => l10n.learningJourneyIslandCoreKnowledgeTitle,
    'practice-worship' => l10n.learningJourneyIslandPracticeWorshipTitle,
    'understanding-islam' => l10n.learningJourneyIslandUnderstandingIslamTitle,
    'arabic-learning' => l10n.learningJourneyIslandArabicLearningTitle,
    'discovery' => l10n.learningJourneyIslandDiscoveryTitle,
    'kids-learning' => l10n.learningJourneyIslandKidsLearningTitle,
    'browse-all' => l10n.learningJourneyIslandBrowseAllTitle,
    'tools-other' => l10n.learningJourneyIslandToolsOtherTitle,
    'legacy-learning' => l10n.learningJourneyIslandLegacyLearningTitle,
    _ => island.title,
  };
}

String localizedIslandSubtitle(
  BuildContext context,
  LearningJourneyIsland island,
) {
  final l10n = AppLocalizations.of(context);
  return switch (island.id) {
    'core-knowledge' => l10n.learningJourneyIslandCoreKnowledgeSubtitle,
    'practice-worship' => l10n.learningJourneyIslandPracticeWorshipSubtitle,
    'understanding-islam' =>
      l10n.learningJourneyIslandUnderstandingIslamSubtitle,
    'arabic-learning' => l10n.learningJourneyIslandArabicLearningSubtitle,
    'discovery' => l10n.learningJourneyIslandDiscoverySubtitle,
    'kids-learning' => l10n.learningJourneyIslandKidsLearningSubtitle,
    'browse-all' => l10n.learningJourneyIslandBrowseAllSubtitle,
    'tools-other' => l10n.learningJourneyIslandToolsOtherSubtitle,
    'legacy-learning' => l10n.learningJourneyIslandLegacyLearningSubtitle,
    _ => island.subtitle,
  };
}

String localizedIslandDescription(
  BuildContext context,
  LearningJourneyIsland island,
) {
  final l10n = AppLocalizations.of(context);
  return switch (island.id) {
    'core-knowledge' => l10n.learningJourneyIslandCoreKnowledgeDescription,
    'practice-worship' => l10n.learningJourneyIslandPracticeWorshipDescription,
    'understanding-islam' =>
      l10n.learningJourneyIslandUnderstandingIslamDescription,
    'arabic-learning' => l10n.learningJourneyIslandArabicLearningDescription,
    'discovery' => l10n.learningJourneyIslandDiscoveryDescription,
    'kids-learning' => l10n.learningJourneyIslandKidsLearningDescription,
    'browse-all' => l10n.learningJourneyIslandBrowseAllDescription,
    'tools-other' => l10n.learningJourneyIslandToolsOtherDescription,
    'legacy-learning' => l10n.learningJourneyIslandLegacyLearningDescription,
    _ => island.description,
  };
}

String localizedStageTitle(BuildContext context, LearningJourneyStage stage) {
  final l10n = AppLocalizations.of(context);
  return switch (stage.id) {
    'islam-what-is-islam' => l10n.learningJourneyStageIslamWhatIsIslamTitle,
    'islam-who-is-allah' => l10n.learningJourneyStageIslamWhoIsAllahTitle,
    'islam-five-pillars' => l10n.learningJourneyStageIslamFivePillarsTitle,
    'islam-first-steps' => l10n.learningJourneyStageIslamFirstStepsTitle,
    'islam-foundations-completion' =>
      l10n.learningJourneyStageIslamCompletionTitle,
    'daily-routines-start-day' =>
      l10n.learningJourneyStageDailyRoutinesStartDayTitle,
    'daily-routines-prayer-anchor' =>
      l10n.learningJourneyStageDailyRoutinesPrayerAnchorTitle,
    'daily-routines-quran-anchor' =>
      l10n.learningJourneyStageDailyRoutinesQuranAnchorTitle,
    'daily-routines-evening-reset' =>
      l10n.learningJourneyStageDailyRoutinesEveningResetTitle,
    'daily-routines-habit-building' =>
      l10n.learningJourneyStageDailyRoutinesHabitBuildingTitle,
    'daily-routines-completion' =>
      l10n.learningJourneyStageDailyRoutinesCompletionTitle,
    'faith-completion' => l10n.learningJourneyStageFaithCompletionTitle,
    'fiqh-halal-haram' => l10n.learningJourneyStageFiqhHalalTitle,
    'fiqh-cleanliness' => l10n.learningJourneyStageFiqhCleanlinessTitle,
    'fiqh-prayer-basics' => l10n.learningJourneyStageFiqhPrayerTitle,
    'fiqh-fasting-basics' => l10n.learningJourneyStageFiqhFastingTitle,
    'fiqh-zakat-basics' => l10n.learningJourneyStageFiqhZakatTitle,
    'fiqh-daily-life' => l10n.learningJourneyStageFiqhDailyLifeTitle,
    'fiqh-completion' => l10n.learningJourneyStageFiqhCompletionTitle,
    'timeline-early-prophets' =>
      l10n.learningJourneyStageTimelineEarlyProphetsTitle,
    'timeline-prophet-era' => l10n.learningJourneyStageTimelineProphetEraTitle,
    'timeline-khulafa' => l10n.learningJourneyStageTimelineKhulafaTitle,
    'timeline-expansion' => l10n.learningJourneyStageTimelineExpansionTitle,
    'timeline-golden-age' => l10n.learningJourneyStageTimelineGoldenAgeTitle,
    'timeline-modern-context' => l10n.learningJourneyStageTimelineModernTitle,
    'timeline-completion' => l10n.learningJourneyStageTimelineCompletionTitle,
    'stories-sky-stars' => l10n.learningJourneyStageStoriesSkyTitle,
    'stories-ocean' => l10n.learningJourneyStageStoriesOceanTitle,
    'stories-mountains' => l10n.learningJourneyStageStoriesMountainsTitle,
    'stories-animals' => l10n.learningJourneyStageStoriesAnimalsTitle,
    'stories-human-creation' =>
      l10n.learningJourneyStageStoriesHumanCreationTitle,
    'stories-day-night' => l10n.learningJourneyStageStoriesDayNightTitle,
    'stories-completion' => l10n.learningJourneyStageStoriesCompletionTitle,
    'quran-open' => l10n.learningJourneyStageQuranOpenTitle,
    'quran-read' => l10n.learningJourneyStageQuranReadTitle,
    'quran-themes' => l10n.learningJourneyStageQuranThemesTitle,
    'quran-next-steps' => l10n.learningJourneyStageQuranNextStepsTitle,
    'fatihah-read' => l10n.learningJourneyStageFatihahReadTitle,
    'fatihah-recitation' => l10n.learningJourneyStageFatihahRecitationTitle,
    'fatihah-reflection' => l10n.learningJourneyStageFatihahReflectionTitle,
    'fatihah-completion' => l10n.learningJourneyStageFatihahCompletionTitle,
    'short-surahs-ikhlas' => l10n.learningJourneyStageShortSurahIkhlasTitle,
    'short-surahs-falaq' => l10n.learningJourneyStageShortSurahFalaqTitle,
    'short-surahs-nas' => l10n.learningJourneyStageShortSurahNasTitle,
    'short-surahs-kafirun' => l10n.learningJourneyStageShortSurahKafirunTitle,
    'short-surahs-kawthar' => l10n.learningJourneyStageShortSurahKawtharTitle,
    'short-surahs-completion' =>
      l10n.learningJourneyStageShortSurahCompletionTitle,
    'alphabet-completion' => l10n.learningJourneyStageAlphabetCompletionTitle,
    'reading-basics-completion' =>
      l10n.learningJourneyStageReadingCompletionTitle,
    'recite-completion' => l10n.learningJourneyStageReciteCompletionTitle,
    'hadith-essential-collection' =>
      l10n.learningJourneyStageHadithEssentialCollectionTitle,
    'hadith-themes' => l10n.learningJourneyStageHadithThemesTitle,
    'hadith-review' => l10n.learningJourneyStageHadithReviewTitle,
    'salah-hub' => l10n.learningJourneyStageSalahWhyTitle,
    'salah-guided-fajr' => l10n.learningJourneyStageSalahPrepareTitle,
    'salah-detail-fajr' => l10n.learningJourneyStageSalahMovementsTitle,
    'salah-words-meaning' => l10n.learningJourneyStageSalahWordsMeaningTitle,
    'salah-khushu-consistency' =>
      l10n.learningJourneyStageSalahConsistencyTitle,
    'salah-completion' => l10n.learningJourneyStageSalahCompletionTitle,
    'wudu-guide' => l10n.learningJourneyStageWuduWhyTitle,
    'wudu-trainer' => l10n.learningJourneyStageWuduPracticeTitle,
    'wudu-what-breaks' => l10n.learningJourneyStageWuduBreaksTitle,
    'wudu-common-mistakes' => l10n.learningJourneyStageWuduMistakesTitle,
    'wudu-completion' => l10n.learningJourneyStageWuduCompletionTitle,
    'ramadan-intention' => l10n.learningJourneyStageRamadanWhatIsTitle,
    'ramadan-why-fast' => l10n.learningJourneyStageRamadanWhyFastTitle,
    'ramadan-daily-rhythm' => l10n.learningJourneyStageRamadanSuhoorIftarTitle,
    'ramadan-what-breaks-fast' =>
      l10n.learningJourneyStageRamadanBreaksFastTitle,
    'ramadan-laylat-al-qadr' => l10n.learningJourneyStageRamadanLaylatTitle,
    'ramadan-reflection' => l10n.learningJourneyStageRamadanSpiritualGoalsTitle,
    'ramadan-common-mistakes' => l10n.learningJourneyStageRamadanMistakesTitle,
    'alphabet-open' => l10n.learningJourneyStageAlphabetOpenTitle,
    'alphabet-repeat' => l10n.learningJourneyStageAlphabetRepeatTitle,
    'alphabet-review' => l10n.learningJourneyStageAlphabetReviewTitle,
    'reading-basics-open' => l10n.learningJourneyStageReadingFathahTitle,
    'reading-basics-kasra' => l10n.learningJourneyStageReadingKasrahTitle,
    'reading-basics-damma' => l10n.learningJourneyStageReadingDammahTitle,
    'reading-basics-sukun' => l10n.learningJourneyStageReadingSukunTitle,
    'reading-basics-shaddah' => l10n.learningJourneyStageReadingShaddahTitle,
    'reading-basics-practice' =>
      l10n.learningJourneyStageReadingJoiningLettersTitle,
    'reading-basics-checkpoint' =>
      l10n.learningJourneyStageReadingCheckpointTitle,
    'trivia-paths' => l10n.learningJourneyStageTriviaPathsTitle,
    'trivia-session' => l10n.learningJourneyStageTriviaSessionTitle,
    'trivia-review' => l10n.learningJourneyStageTriviaReviewTitle,
    'character-ikhlas' => l10n.learningJourneyCharacterIkhlasStageTitle,
    'character-sabr' => l10n.learningJourneyCharacterSabrStageTitle,
    'character-shukr' => l10n.learningJourneyCharacterShukrStageTitle,
    'character-humility' => l10n.learningJourneyCharacterHumilityStageTitle,
    'character-forgiveness' =>
      l10n.learningJourneyCharacterForgivenessStageTitle,
    'character-anger' => l10n.learningJourneyCharacterAngerStageTitle,
    'character-kindness' => l10n.learningJourneyCharacterKindnessStageTitle,
    'character-completion' => l10n.learningJourneyCharacterCompletionStageTitle,
    _ => stage.title,
  };
}

String localizedStageSummary(BuildContext context, LearningJourneyStage stage) {
  final l10n = AppLocalizations.of(context);
  return switch (stage.id) {
    'islam-what-is-islam' => l10n.learningJourneyStageIslamWhatIsIslamSummary,
    'islam-who-is-allah' => l10n.learningJourneyStageIslamWhoIsAllahSummary,
    'islam-five-pillars' => l10n.learningJourneyStageIslamFivePillarsSummary,
    'islam-first-steps' => l10n.learningJourneyStageIslamFirstStepsSummary,
    'islam-foundations-completion' =>
      l10n.learningJourneyStageIslamCompletionSummary,
    'daily-routines-start-day' =>
      l10n.learningJourneyStageDailyRoutinesStartDaySummary,
    'daily-routines-prayer-anchor' =>
      l10n.learningJourneyStageDailyRoutinesPrayerAnchorSummary,
    'daily-routines-quran-anchor' =>
      l10n.learningJourneyStageDailyRoutinesQuranAnchorSummary,
    'daily-routines-evening-reset' =>
      l10n.learningJourneyStageDailyRoutinesEveningResetSummary,
    'daily-routines-habit-building' =>
      l10n.learningJourneyStageDailyRoutinesHabitBuildingSummary,
    'daily-routines-completion' =>
      l10n.learningJourneyStageDailyRoutinesCompletionSummary,
    'faith-completion' => l10n.learningJourneyStageFaithCompletionSummary,
    'fiqh-halal-haram' => l10n.learningJourneyStageFiqhHalalSummary,
    'fiqh-cleanliness' => l10n.learningJourneyStageFiqhCleanlinessSummary,
    'fiqh-prayer-basics' => l10n.learningJourneyStageFiqhPrayerSummary,
    'fiqh-fasting-basics' => l10n.learningJourneyStageFiqhFastingSummary,
    'fiqh-zakat-basics' => l10n.learningJourneyStageFiqhZakatSummary,
    'fiqh-daily-life' => l10n.learningJourneyStageFiqhDailyLifeSummary,
    'fiqh-completion' => l10n.learningJourneyStageFiqhCompletionSummary,
    'timeline-early-prophets' =>
      l10n.learningJourneyStageTimelineEarlyProphetsSummary,
    'timeline-prophet-era' =>
      l10n.learningJourneyStageTimelineProphetEraSummary,
    'timeline-khulafa' => l10n.learningJourneyStageTimelineKhulafaSummary,
    'timeline-expansion' => l10n.learningJourneyStageTimelineExpansionSummary,
    'timeline-golden-age' => l10n.learningJourneyStageTimelineGoldenAgeSummary,
    'timeline-modern-context' => l10n.learningJourneyStageTimelineModernSummary,
    'timeline-completion' => l10n.learningJourneyStageTimelineCompletionSummary,
    'stories-sky-stars' => l10n.learningJourneyStageStoriesSkySummary,
    'stories-ocean' => l10n.learningJourneyStageStoriesOceanSummary,
    'stories-mountains' => l10n.learningJourneyStageStoriesMountainsSummary,
    'stories-animals' => l10n.learningJourneyStageStoriesAnimalsSummary,
    'stories-human-creation' =>
      l10n.learningJourneyStageStoriesHumanCreationSummary,
    'stories-day-night' => l10n.learningJourneyStageStoriesDayNightSummary,
    'stories-completion' => l10n.learningJourneyStageStoriesCompletionSummary,
    'quran-open' => l10n.learningJourneyStageQuranOpenSummary,
    'quran-read' => l10n.learningJourneyStageQuranReadSummary,
    'quran-themes' => l10n.learningJourneyStageQuranThemesSummary,
    'quran-next-steps' => l10n.learningJourneyStageQuranNextStepsSummary,
    'fatihah-read' => l10n.learningJourneyStageFatihahReadSummary,
    'fatihah-recitation' => l10n.learningJourneyStageFatihahRecitationSummary,
    'fatihah-reflection' => l10n.learningJourneyStageFatihahReflectionSummary,
    'fatihah-completion' => l10n.learningJourneyStageFatihahCompletionSummary,
    'short-surahs-ikhlas' => l10n.learningJourneyStageShortSurahIkhlasSummary,
    'short-surahs-falaq' => l10n.learningJourneyStageShortSurahFalaqSummary,
    'short-surahs-nas' => l10n.learningJourneyStageShortSurahNasSummary,
    'short-surahs-kafirun' => l10n.learningJourneyStageShortSurahKafirunSummary,
    'short-surahs-kawthar' => l10n.learningJourneyStageShortSurahKawtharSummary,
    'short-surahs-completion' =>
      l10n.learningJourneyStageShortSurahCompletionSummary,
    'alphabet-completion' => l10n.learningJourneyStageAlphabetCompletionSummary,
    'reading-basics-completion' =>
      l10n.learningJourneyStageReadingCompletionSummary,
    'recite-completion' => l10n.learningJourneyStageReciteCompletionSummary,
    'hadith-essential-collection' =>
      l10n.learningJourneyStageHadithEssentialCollectionSummary,
    'hadith-themes' => l10n.learningJourneyStageHadithThemesSummary,
    'hadith-review' => l10n.learningJourneyStageHadithReviewSummary,
    'salah-hub' => l10n.learningJourneyStageSalahWhySummary,
    'salah-guided-fajr' => l10n.learningJourneyStageSalahPrepareSummary,
    'salah-detail-fajr' => l10n.learningJourneyStageSalahMovementsSummary,
    'salah-words-meaning' => l10n.learningJourneyStageSalahWordsMeaningSummary,
    'salah-khushu-consistency' =>
      l10n.learningJourneyStageSalahConsistencySummary,
    'salah-completion' => l10n.learningJourneyStageSalahCompletionSummary,
    'wudu-guide' => l10n.learningJourneyStageWuduWhySummary,
    'wudu-trainer' => l10n.learningJourneyStageWuduPracticeSummary,
    'wudu-what-breaks' => l10n.learningJourneyStageWuduBreaksSummary,
    'wudu-common-mistakes' => l10n.learningJourneyStageWuduMistakesSummary,
    'wudu-completion' => l10n.learningJourneyStageWuduCompletionSummary,
    'ramadan-intention' => l10n.learningJourneyStageRamadanWhatIsSummary,
    'ramadan-why-fast' => l10n.learningJourneyStageRamadanWhyFastSummary,
    'ramadan-daily-rhythm' =>
      l10n.learningJourneyStageRamadanSuhoorIftarSummary,
    'ramadan-what-breaks-fast' =>
      l10n.learningJourneyStageRamadanBreaksFastSummary,
    'ramadan-laylat-al-qadr' => l10n.learningJourneyStageRamadanLaylatSummary,
    'ramadan-reflection' =>
      l10n.learningJourneyStageRamadanSpiritualGoalsSummary,
    'ramadan-common-mistakes' =>
      l10n.learningJourneyStageRamadanMistakesSummary,
    'alphabet-open' => l10n.learningJourneyStageAlphabetOpenSummary,
    'alphabet-repeat' => l10n.learningJourneyStageAlphabetRepeatSummary,
    'alphabet-review' => l10n.learningJourneyStageAlphabetReviewSummary,
    'reading-basics-open' => l10n.learningJourneyStageReadingFathahSummary,
    'reading-basics-kasra' => l10n.learningJourneyStageReadingKasrahSummary,
    'reading-basics-damma' => l10n.learningJourneyStageReadingDammahSummary,
    'reading-basics-sukun' => l10n.learningJourneyStageReadingSukunSummary,
    'reading-basics-shaddah' => l10n.learningJourneyStageReadingShaddahSummary,
    'reading-basics-practice' =>
      l10n.learningJourneyStageReadingJoiningLettersSummary,
    'reading-basics-checkpoint' =>
      l10n.learningJourneyStageReadingCheckpointSummary,
    'trivia-paths' => l10n.learningJourneyStageTriviaPathsSummary,
    'trivia-session' => l10n.learningJourneyStageTriviaSessionSummary,
    'trivia-review' => l10n.learningJourneyStageTriviaReviewSummary,
    'character-ikhlas' => l10n.learningJourneyCharacterIkhlasStageSummary,
    'character-sabr' => l10n.learningJourneyCharacterSabrStageSummary,
    'character-shukr' => l10n.learningJourneyCharacterShukrStageSummary,
    'character-humility' => l10n.learningJourneyCharacterHumilityStageSummary,
    'character-forgiveness' =>
      l10n.learningJourneyCharacterForgivenessStageSummary,
    'character-anger' => l10n.learningJourneyCharacterAngerStageSummary,
    'character-kindness' => l10n.learningJourneyCharacterKindnessStageSummary,
    'character-completion' =>
      l10n.learningJourneyCharacterCompletionStageSummary,
    _ => stage.summary,
  };
}
