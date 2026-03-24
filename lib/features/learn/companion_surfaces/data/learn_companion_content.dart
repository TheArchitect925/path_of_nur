import '../../../../l10n/app_localizations.dart';
import '../domain/learn_companion_models.dart';

List<LearnCompanionLinkItem> buildSeerahPeriodLinks(AppLocalizations l10n) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'makkah',
      title: l10n.learningJourneySeerahMakkahTitle,
      subtitle: l10n.learnSeerahCompanionMakkahSubtitle,
      description: l10n.learnSeerahCompanionMakkahDescription,
      whyItMatters: l10n.learnSeerahCompanionMakkahWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionMakkahNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'seerah-journey',
          'stageId': 'seerah-makkah-period',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'hijrah',
      title: l10n.learningJourneySeerahHijrahTitle,
      subtitle: l10n.learnSeerahCompanionHijrahSubtitle,
      description: l10n.learnSeerahCompanionHijrahDescription,
      whyItMatters: l10n.learnSeerahCompanionHijrahWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionHijrahNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'seerah-journey',
          'stageId': 'seerah-hijrah',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'madinah-society',
      title: l10n.learningJourneySeerahMadinahTitle,
      subtitle: l10n.learnSeerahCompanionMadinahSubtitle,
      description: l10n.learnSeerahCompanionMadinahDescription,
      whyItMatters: l10n.learnSeerahCompanionMadinahWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionMadinahNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'seerah-journey',
          'stageId': 'seerah-madinah-society',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'turning-points',
      title: l10n.learnSeerahCompanionTurningPointsTitle,
      subtitle: l10n.learnSeerahCompanionTurningPointsSubtitle,
      description: l10n.learnSeerahCompanionTurningPointsDescription,
      whyItMatters: l10n.learnSeerahCompanionTurningPointsWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionTurningPointsNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelHistory,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHistoryArchive',
        queryParameters: {'tab': 'timeline'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'final-sermon',
      title: l10n.learningJourneySeerahFinalSermonTitle,
      subtitle: l10n.learnSeerahCompanionFinalSermonSubtitle,
      description: l10n.learnSeerahCompanionFinalSermonDescription,
      whyItMatters: l10n.learnSeerahCompanionFinalSermonWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionFinalSermonNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'seerah-journey',
          'stageId': 'seerah-final-sermon',
        },
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildSeerahMomentLinks(AppLocalizations l10n) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'hudaybiyyah',
      title: l10n.learnSeerahCompanionHudaybiyyahTitle,
      subtitle: l10n.learnSeerahCompanionHudaybiyyahSubtitle,
      description: l10n.learnSeerahCompanionHudaybiyyahDescription,
      whyItMatters: l10n.learnSeerahCompanionHudaybiyyahWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionHudaybiyyahNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelHistory,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHistoryArchive',
        queryParameters: {'tab': 'timeline'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'conquest-of-makkah',
      title: l10n.learnSeerahCompanionConquestTitle,
      subtitle: l10n.learnSeerahCompanionConquestSubtitle,
      description: l10n.learnSeerahCompanionConquestDescription,
      whyItMatters: l10n.learnSeerahCompanionConquestWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionConquestNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelHistory,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHistoryArchive',
        queryParameters: {'tab': 'timeline'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'farewell-hajj',
      title: l10n.learnSeerahCompanionFarewellHajjTitle,
      subtitle: l10n.learnSeerahCompanionFarewellHajjSubtitle,
      description: l10n.learnSeerahCompanionFarewellHajjDescription,
      whyItMatters: l10n.learnSeerahCompanionFarewellHajjWhyItMatters,
      nextExploration: l10n.learnSeerahCompanionFarewellHajjNextExplore,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'seerah-journey',
          'stageId': 'seerah-final-sermon',
        },
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildSeerahCompanionSources(
  AppLocalizations l10n,
) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'prophets',
      title: l10n.learnCategoryStoriesOfProphetsTitle,
      subtitle: l10n.learnSeerahCompanionProphetsSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelProphets,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnProphetsHub',
        queryParameters: {'tab': 'stories'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'hadith',
      title: l10n.learnCategoryHadithTitle,
      subtitle: l10n.learnSeerahCompanionHadithSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelHadith,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
      ),
    ),
    LearnCompanionLinkItem(
      id: 'history',
      title: l10n.historyArchiveTitle,
      subtitle: l10n.learnSeerahCompanionHistorySourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelHistory,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHistoryArchive',
      ),
    ),
    LearnCompanionLinkItem(
      id: 'quran-learning',
      title: l10n.quranAyahInsightsDomainProphetsLessons,
      subtitle: l10n.learnSeerahCompanionQuranSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelQuran,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'prophets-lessons'},
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildSeerahExploreLinks(AppLocalizations l10n) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'journey',
      title: l10n.learningJourneySeerahJourneyTitle,
      subtitle: l10n.learningJourneySeerahJourneyDescription,
      description: l10n.learnSeerahCompanionExploreJourneyDescription,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyDetail',
        pathParameters: {'journeyId': 'seerah-journey'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'timeline',
      title: l10n.historyArchiveTitle,
      subtitle: l10n.learnSeerahCompanionExploreTimelineSubtitle,
      description: l10n.learnSeerahCompanionExploreTimelineDescription,
      sourceLabel: l10n.learnCompanionSourceLabelHistory,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHistoryArchive',
        queryParameters: {'tab': 'timeline'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'hadith-guidance',
      title: l10n.learnCategoryHadithTitle,
      subtitle: l10n.learnSeerahCompanionExploreHadithSubtitle,
      description: l10n.learnSeerahCompanionExploreHadithDescription,
      sourceLabel: l10n.learnCompanionSourceLabelHadith,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
      ),
    ),
    LearnCompanionLinkItem(
      id: 'quran-study',
      title: l10n.quranAyahInsightsDomainProphetsLessons,
      subtitle: l10n.learnSeerahCompanionExploreQuranSubtitle,
      description: l10n.learnSeerahCompanionExploreQuranDescription,
      sourceLabel: l10n.learnCompanionSourceLabelQuran,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'prophets-lessons'},
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildCharacterTraitLinks(AppLocalizations l10n) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'ikhlas',
      title: l10n.learningJourneyCharacterIkhlasStageTitle,
      subtitle: l10n.learningJourneyCharacterIkhlasStageSummary,
      description: l10n.learnCharacterCompanionIkhlasDescription,
      practicalExpression:
          l10n.learnCharacterCompanionIkhlasPracticalExpression,
      nextStep: l10n.learnCharacterCompanionIkhlasNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-ikhlas',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'sabr',
      title: l10n.learningJourneyCharacterSabrStageTitle,
      subtitle: l10n.learningJourneyCharacterSabrStageSummary,
      description: l10n.learnCharacterCompanionSabrDescription,
      practicalExpression: l10n.learnCharacterCompanionSabrPracticalExpression,
      nextStep: l10n.learnCharacterCompanionSabrNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-sabr',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'shukr',
      title: l10n.learningJourneyCharacterShukrStageTitle,
      subtitle: l10n.learningJourneyCharacterShukrStageSummary,
      description: l10n.learnCharacterCompanionShukrDescription,
      practicalExpression: l10n.learnCharacterCompanionShukrPracticalExpression,
      nextStep: l10n.learnCharacterCompanionShukrNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-shukr',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'humility',
      title: l10n.learningJourneyCharacterHumilityStageTitle,
      subtitle: l10n.learningJourneyCharacterHumilityStageSummary,
      description: l10n.learnCharacterCompanionHumilityDescription,
      practicalExpression:
          l10n.learnCharacterCompanionHumilityPracticalExpression,
      nextStep: l10n.learnCharacterCompanionHumilityNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-humility',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'forgiveness',
      title: l10n.learningJourneyCharacterForgivenessStageTitle,
      subtitle: l10n.learningJourneyCharacterForgivenessStageSummary,
      description: l10n.learnCharacterCompanionForgivenessDescription,
      practicalExpression:
          l10n.learnCharacterCompanionForgivenessPracticalExpression,
      nextStep: l10n.learnCharacterCompanionForgivenessNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-forgiveness',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'anger',
      title: l10n.learningJourneyCharacterAngerStageTitle,
      subtitle: l10n.learningJourneyCharacterAngerStageSummary,
      description: l10n.learnCharacterCompanionAngerDescription,
      practicalExpression: l10n.learnCharacterCompanionAngerPracticalExpression,
      nextStep: l10n.learnCharacterCompanionAngerNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-anger',
        },
      ),
    ),
    LearnCompanionLinkItem(
      id: 'kindness',
      title: l10n.learningJourneyCharacterKindnessStageTitle,
      subtitle: l10n.learningJourneyCharacterKindnessStageSummary,
      description: l10n.learnCharacterCompanionKindnessDescription,
      practicalExpression:
          l10n.learnCharacterCompanionKindnessPracticalExpression,
      nextStep: l10n.learnCharacterCompanionKindnessNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelJourney,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnJourneyStage',
        pathParameters: {
          'journeyId': 'beautiful-character',
          'stageId': 'character-kindness',
        },
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildCharacterScenarioLinks(
  AppLocalizations l10n,
) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'family',
      title: l10n.learnCharacterCompanionScenarioFamilyTitle,
      subtitle: l10n.learnCharacterCompanionScenarioFamilySubtitle,
      description: l10n.learnCharacterCompanionScenarioFamilyDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioFamilyPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioFamilyNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelDivineLife,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
        queryParameters: {'themeId': 'family'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'speech',
      title: l10n.learnCharacterCompanionScenarioSpeechTitle,
      subtitle: l10n.learnCharacterCompanionScenarioSpeechSubtitle,
      description: l10n.learnCharacterCompanionScenarioSpeechDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioSpeechPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioSpeechNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelQuran,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'character-adab'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'neighbors',
      title: l10n.learnCharacterCompanionScenarioNeighborsTitle,
      subtitle: l10n.learnCharacterCompanionScenarioNeighborsSubtitle,
      description: l10n.learnCharacterCompanionScenarioNeighborsDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioNeighborsPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioNeighborsNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelDivineLife,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
        queryParameters: {'themeId': 'community-relationships'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'consistency',
      title: l10n.learnCharacterCompanionScenarioConsistencyTitle,
      subtitle: l10n.learnCharacterCompanionScenarioConsistencySubtitle,
      description: l10n.learnCharacterCompanionScenarioConsistencyDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioConsistencyPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioConsistencyNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelQuran,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'guidance-daily-life'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'work-study-pressure',
      title: l10n.learnCharacterCompanionScenarioWorkStudyTitle,
      subtitle: l10n.learnCharacterCompanionScenarioWorkStudySubtitle,
      description: l10n.learnCharacterCompanionScenarioWorkStudyDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioWorkStudyPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioWorkStudyNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelDivineLife,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
        queryParameters: {'themeId': 'trust_allah'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'intentions',
      title: l10n.learnCharacterCompanionScenarioIntentionsTitle,
      subtitle: l10n.learnCharacterCompanionScenarioIntentionsSubtitle,
      description: l10n.learnCharacterCompanionScenarioIntentionsDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioIntentionsPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioIntentionsNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelHadith,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'hadithThemeDetail',
        pathParameters: {'themeId': 'worship-intention'},
      ),
    ),
    LearnCompanionLinkItem(
      id: 'anger-self-control',
      title: l10n.learnCharacterCompanionScenarioAngerTitle,
      subtitle: l10n.learnCharacterCompanionScenarioAngerSubtitle,
      description: l10n.learnCharacterCompanionScenarioAngerDescription,
      practicalExpression:
          l10n.learnCharacterCompanionScenarioAngerPracticalExpression,
      nextStep: l10n.learnCharacterCompanionScenarioAngerNextStep,
      sourceLabel: l10n.learnCompanionSourceLabelHadith,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'hadithThemeDetail',
        pathParameters: {'themeId': 'character-manners'},
      ),
    ),
  ];
}

List<LearnCompanionLinkItem> buildCharacterCompanionSources(
  AppLocalizations l10n,
) {
  return <LearnCompanionLinkItem>[
    LearnCompanionLinkItem(
      id: 'hadith',
      title: l10n.learnCategoryHadithTitle,
      subtitle: l10n.learnCharacterCompanionHadithSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelHadith,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
      ),
    ),
    LearnCompanionLinkItem(
      id: 'divine-life',
      title: l10n.learnCategoryDivineLifeLessonsTitle,
      subtitle: l10n.learnCharacterCompanionLifeSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelDivineLife,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
      ),
    ),
    LearnCompanionLinkItem(
      id: 'quran-insights',
      title: l10n.quranAyahInsightsDomainCharacterAdab,
      subtitle: l10n.learnCharacterCompanionQuranSourceSubtitle,
      sourceLabel: l10n.learnCompanionSourceLabelQuran,
      routeTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'character-adab'},
      ),
    ),
  ];
}

List<DailyWisdomEntry> buildDailyWisdomEntries(AppLocalizations l10n) {
  return <DailyWisdomEntry>[
    DailyWisdomEntry(
      id: 'mercy',
      title: l10n.learnDailyWisdomEntryMercyTitle,
      body: l10n.learnDailyWisdomEntryMercyBody,
      practicalStep: l10n.learnDailyWisdomEntryMercyStep,
      sourceType: DailyWisdomSourceType.prophets,
      themeLabel: l10n.learnDailyWisdomThemeMercy,
      sourceTitle: l10n.learningJourneySeerahJourneyTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceProphetsSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelSeerah,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnSeerahCompanion',
      ),
    ),
    DailyWisdomEntry(
      id: 'gratitude',
      title: l10n.learnDailyWisdomEntryGratitudeTitle,
      body: l10n.learnDailyWisdomEntryGratitudeBody,
      practicalStep: l10n.learnDailyWisdomEntryGratitudeStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeGratitude,
      sourceTitle: l10n.quranAyahInsightsDomainWorshipRemembrance,
      sourceSubtitle: l10n.learnDailyWisdomSourceQuranSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'worship-remembrance'},
      ),
    ),
    DailyWisdomEntry(
      id: 'patience',
      title: l10n.learnDailyWisdomEntryPatienceTitle,
      body: l10n.learnDailyWisdomEntryPatienceBody,
      practicalStep: l10n.learnDailyWisdomEntryPatienceStep,
      sourceType: DailyWisdomSourceType.hadith,
      themeLabel: l10n.learnDailyWisdomThemePatience,
      sourceTitle: l10n.learnCategoryHadithTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceHadithSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelHadith,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
        queryParameters: {'tab': 'daily'},
      ),
    ),
    DailyWisdomEntry(
      id: 'mercy-restraint',
      title: l10n.learnDailyWisdomEntryMercyRestraintTitle,
      body: l10n.learnDailyWisdomEntryMercyRestraintBody,
      practicalStep: l10n.learnDailyWisdomEntryMercyRestraintStep,
      sourceType: DailyWisdomSourceType.hadith,
      themeLabel: l10n.learnDailyWisdomThemeMercy,
      sourceTitle: l10n.learnCategoryHadithTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceHadithSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelHadith,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
        queryParameters: {'tab': 'daily'},
      ),
    ),
    DailyWisdomEntry(
      id: 'trust',
      title: l10n.learnDailyWisdomEntryTrustTitle,
      body: l10n.learnDailyWisdomEntryTrustBody,
      practicalStep: l10n.learnDailyWisdomEntryTrustStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeTrust,
      sourceTitle: l10n.learningJourneyBeautifulCharacterTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceCharacterSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelCharacter,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnCharacterCompanion',
      ),
    ),
    DailyWisdomEntry(
      id: 'intention',
      title: l10n.learnDailyWisdomEntryIntentionTitle,
      body: l10n.learnDailyWisdomEntryIntentionBody,
      practicalStep: l10n.learnDailyWisdomEntryIntentionStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeSincerity,
      sourceTitle: l10n.learningJourneyBeautifulCharacterTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceCharacterSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelCharacter,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnCharacterCompanion',
      ),
    ),
    DailyWisdomEntry(
      id: 'humility',
      title: l10n.learnDailyWisdomEntryHumilityTitle,
      body: l10n.learnDailyWisdomEntryHumilityBody,
      practicalStep: l10n.learnDailyWisdomEntryHumilityStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeHumility,
      sourceTitle: l10n.learningJourneyBeautifulCharacterTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceCharacterSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelCharacter,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnCharacterCompanion',
      ),
    ),
    DailyWisdomEntry(
      id: 'service',
      title: l10n.learnDailyWisdomEntryServiceTitle,
      body: l10n.learnDailyWisdomEntryServiceBody,
      practicalStep: l10n.learnDailyWisdomEntryServiceStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeService,
      sourceTitle: l10n.learnCategoryDivineLifeLessonsTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceLifeSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelDivineLife,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
        queryParameters: {'themeId': 'community-relationships'},
      ),
    ),
    DailyWisdomEntry(
      id: 'remembrance',
      title: l10n.learnDailyWisdomEntryRemembranceTitle,
      body: l10n.learnDailyWisdomEntryRemembranceBody,
      practicalStep: l10n.learnDailyWisdomEntryRemembranceStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeRemembrance,
      sourceTitle: l10n.quranAyahInsightsDomainWorshipRemembrance,
      sourceSubtitle: l10n.learnDailyWisdomSourceQuranSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'worship-remembrance'},
      ),
    ),
    DailyWisdomEntry(
      id: 'remembrance-settling',
      title: l10n.learnDailyWisdomEntryRemembranceSettlingTitle,
      body: l10n.learnDailyWisdomEntryRemembranceSettlingBody,
      practicalStep: l10n.learnDailyWisdomEntryRemembranceSettlingStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeRemembrance,
      sourceTitle: l10n.quranAyahInsightsDomainWorshipRemembrance,
      sourceSubtitle: l10n.learnDailyWisdomSourceQuranSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'worship-remembrance'},
      ),
    ),
    DailyWisdomEntry(
      id: 'hope',
      title: l10n.learnDailyWisdomEntryHopeTitle,
      body: l10n.learnDailyWisdomEntryHopeBody,
      practicalStep: l10n.learnDailyWisdomEntryHopeStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeHope,
      sourceTitle: l10n.quranAyahInsightsDomainAkhirahAccountability,
      sourceSubtitle: l10n.learnDailyWisdomSourceHopeSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'akhirah-accountability'},
      ),
    ),
    DailyWisdomEntry(
      id: 'hope-opening',
      title: l10n.learnDailyWisdomEntryHopeOpeningTitle,
      body: l10n.learnDailyWisdomEntryHopeOpeningBody,
      practicalStep: l10n.learnDailyWisdomEntryHopeOpeningStep,
      sourceType: DailyWisdomSourceType.prophets,
      themeLabel: l10n.learnDailyWisdomThemeHope,
      sourceTitle: l10n.learningJourneySeerahJourneyTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceProphetsSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelSeerah,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnSeerahCompanion',
        queryParameters: {'focus': 'turning-points'},
      ),
    ),
    DailyWisdomEntry(
      id: 'reflection',
      title: l10n.learnDailyWisdomEntryReflectionTitle,
      body: l10n.learnDailyWisdomEntryReflectionBody,
      practicalStep: l10n.learnDailyWisdomEntryReflectionStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeReflection,
      sourceTitle: l10n.quranReflectionsTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceReflectionSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranReflections',
      ),
    ),
    DailyWisdomEntry(
      id: 'forgiveness',
      title: l10n.learnDailyWisdomEntryForgivenessTitle,
      body: l10n.learnDailyWisdomEntryForgivenessBody,
      practicalStep: l10n.learnDailyWisdomEntryForgivenessStep,
      sourceType: DailyWisdomSourceType.hadith,
      themeLabel: l10n.learnDailyWisdomThemeForgiveness,
      sourceTitle: l10n.learnCategoryHadithTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceHadithSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelHadith,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnHadithLanding',
      ),
    ),
    DailyWisdomEntry(
      id: 'service-presence',
      title: l10n.learnDailyWisdomEntryServicePresenceTitle,
      body: l10n.learnDailyWisdomEntryServicePresenceBody,
      practicalStep: l10n.learnDailyWisdomEntryServicePresenceStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeService,
      sourceTitle: l10n.learnCategoryDivineLifeLessonsTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceLifeSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelDivineLife,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnLifeLanding',
        queryParameters: {'themeId': 'community-relationships'},
      ),
    ),
    DailyWisdomEntry(
      id: 'steadiness',
      title: l10n.learnDailyWisdomEntrySteadinessTitle,
      body: l10n.learnDailyWisdomEntrySteadinessBody,
      practicalStep: l10n.learnDailyWisdomEntrySteadinessStep,
      sourceType: DailyWisdomSourceType.quran,
      themeLabel: l10n.learnDailyWisdomThemeSteadiness,
      sourceTitle: l10n.quranAyahInsightsDomainGuidanceDailyLife,
      sourceSubtitle: l10n.learnDailyWisdomSourceQuranSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelQuran,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'quranAyahInsightsDomain',
        pathParameters: {'domainId': 'guidance-daily-life'},
      ),
    ),
    DailyWisdomEntry(
      id: 'truthful-speech',
      title: l10n.learnDailyWisdomEntrySpeechTitle,
      body: l10n.learnDailyWisdomEntrySpeechBody,
      practicalStep: l10n.learnDailyWisdomEntrySpeechStep,
      sourceType: DailyWisdomSourceType.life,
      themeLabel: l10n.learnDailyWisdomThemeSpeech,
      sourceTitle: l10n.learningJourneyBeautifulCharacterTitle,
      sourceSubtitle: l10n.learnDailyWisdomSourceCharacterSubtitle,
      ownerLabel: l10n.learnCompanionSourceLabelCharacter,
      sourceRouteTarget: const LearnCompanionRouteTarget(
        routeName: 'learnCharacterCompanion',
      ),
    ),
  ];
}

List<DailyWisdomEntry> orderDailyWisdomEntries(
  List<DailyWisdomEntry> entries,
  DateTime now, {
  String? focusedEntryId,
}) {
  if (entries.isEmpty) {
    return entries;
  }

  final dayIndex = DateTime(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime(2026, 1, 1)).inDays;
  final normalizedIndex = dayIndex % entries.length;
  final step = _dailyWisdomRotationStep(entries.length);

  final ordered = [
    for (var offset = 0; offset < entries.length; offset++)
      entries[(normalizedIndex + (offset * step)) % entries.length],
  ];

  final focusId = focusedEntryId?.trim();
  if (focusId == null || focusId.isEmpty) {
    return ordered;
  }

  final focusedIndex = ordered.indexWhere((entry) => entry.id == focusId);
  if (focusedIndex == -1) {
    return ordered;
  }

  return <DailyWisdomEntry>[
    ordered[focusedIndex],
    ...ordered.take(focusedIndex),
    ...ordered.skip(focusedIndex + 1),
  ];
}

int _dailyWisdomRotationStep(int length) {
  const candidates = <int>[5, 7, 3, 11, 2];
  for (final candidate in candidates) {
    if (candidate < length && _greatestCommonDivisor(candidate, length) == 1) {
      return candidate;
    }
  }
  return 1;
}

int _greatestCommonDivisor(int a, int b) {
  var x = a.abs();
  var y = b.abs();
  while (y != 0) {
    final temp = x % y;
    x = y;
    y = temp;
  }
  return x;
}
