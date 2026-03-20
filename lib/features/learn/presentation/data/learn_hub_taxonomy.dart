import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../models/learn_hub_models.dart';

class LearnHubTaxonomy {
  const LearnHubTaxonomy._();

  static const List<LearnHubCategoryId> orderedCategories = [
    LearnHubCategoryId.foundations,
    LearnHubCategoryId.quranHadith,
    LearnHubCategoryId.prophetsStories,
    LearnHubCategoryId.worshipPractice,
    LearnHubCategoryId.characterAdab,
    LearnHubCategoryId.arabicLanguage,
    LearnHubCategoryId.kidsLearning,
    LearnHubCategoryId.quizzesChallenges,
    LearnHubCategoryId.faq,
    LearnHubCategoryId.notes,
    LearnHubCategoryId.toolsExplore,
  ];

  static LearnHubCategoryStyle styleFor(LearnHubCategoryId id) {
    switch (id) {
      case LearnHubCategoryId.foundations:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFDDEFEA),
          accentColor: Color(0xFF16605A),
          icon: IslamicIcons.allahText,
        );
      case LearnHubCategoryId.quranHadith:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFE1F1E4),
          accentColor: Color(0xFF2B7A4B),
          icon: IslamicIcons.quran,
        );
      case LearnHubCategoryId.prophetsStories:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFF5E8CB),
          accentColor: Color(0xFF9A6A15),
          icon: IslamicIcons.lantern,
        );
      case LearnHubCategoryId.worshipPractice:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFE1ECF8),
          accentColor: Color(0xFF2E63A8),
          icon: IslamicIcons.prayer,
        );
      case LearnHubCategoryId.characterAdab:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFF6E3E6),
          accentColor: Color(0xFF9C4A5C),
          icon: IslamicIcons.tasbih,
        );
      case LearnHubCategoryId.arabicLanguage:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFEAE5F8),
          accentColor: Color(0xFF6847A5),
          icon: Icons.translate_rounded,
        );
      case LearnHubCategoryId.kidsLearning:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFF9E6D8),
          accentColor: Color(0xFFBF6F1F),
          icon: Icons.child_care_rounded,
        );
      case LearnHubCategoryId.quizzesChallenges:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFF8E4C8),
          accentColor: Color(0xFFB86A12),
          icon: Icons.emoji_events_rounded,
        );
      case LearnHubCategoryId.faq:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFE4E8F4),
          accentColor: Color(0xFF495C8C),
          icon: Icons.help_outline_rounded,
        );
      case LearnHubCategoryId.notes:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFF0E5D4),
          accentColor: Color(0xFF8A6A42),
          icon: Icons.sticky_note_2_outlined,
        );
      case LearnHubCategoryId.toolsExplore:
        return const LearnHubCategoryStyle(
          baseColor: Color(0xFFE0EEF0),
          accentColor: Color(0xFF2E7380),
          icon: Icons.travel_explore_rounded,
        );
    }
  }

  static String categorySlug(LearnHubCategoryId id) {
    switch (id) {
      case LearnHubCategoryId.foundations:
        return 'foundations';
      case LearnHubCategoryId.quranHadith:
        return 'quran-hadith';
      case LearnHubCategoryId.prophetsStories:
        return 'prophets-stories';
      case LearnHubCategoryId.worshipPractice:
        return 'worship-practice';
      case LearnHubCategoryId.characterAdab:
        return 'character-adab';
      case LearnHubCategoryId.arabicLanguage:
        return 'arabic-language';
      case LearnHubCategoryId.kidsLearning:
        return 'kids-learning';
      case LearnHubCategoryId.quizzesChallenges:
        return 'quizzes-challenges';
      case LearnHubCategoryId.faq:
        return 'faq';
      case LearnHubCategoryId.notes:
        return 'notes';
      case LearnHubCategoryId.toolsExplore:
        return 'tools-explore';
    }
  }

  static LearnHubCategoryId? categoryFromSlug(String value) {
    for (final category in orderedCategories) {
      if (categorySlug(category) == value) {
        return category;
      }
    }
    return null;
  }

  static String categoryTitle(AppLocalizations l10n, LearnHubCategoryId id) {
    switch (id) {
      case LearnHubCategoryId.foundations:
        return l10n.learnHubCategoryFoundationsTitle;
      case LearnHubCategoryId.quranHadith:
        return l10n.learnHubCategoryQuranHadithTitle;
      case LearnHubCategoryId.prophetsStories:
        return l10n.learnHubCategoryProphetsStoriesTitle;
      case LearnHubCategoryId.worshipPractice:
        return l10n.learnHubCategoryWorshipPracticeTitle;
      case LearnHubCategoryId.characterAdab:
        return l10n.learnHubCategoryCharacterAdabTitle;
      case LearnHubCategoryId.arabicLanguage:
        return l10n.learnHubCategoryArabicLanguageTitle;
      case LearnHubCategoryId.kidsLearning:
        return l10n.learnHubCategoryKidsLearningTitle;
      case LearnHubCategoryId.quizzesChallenges:
        return l10n.learnHubCategoryQuizzesChallengesTitle;
      case LearnHubCategoryId.faq:
        return l10n.learnHubCategoryFaqTitle;
      case LearnHubCategoryId.notes:
        return l10n.learnHubCategoryNotesTitle;
      case LearnHubCategoryId.toolsExplore:
        return l10n.learnHubCategoryToolsExploreTitle;
    }
  }

  static String categorySubtitle(AppLocalizations l10n, LearnHubCategoryId id) {
    switch (id) {
      case LearnHubCategoryId.foundations:
        return l10n.learnHubCategoryFoundationsSubtitle;
      case LearnHubCategoryId.quranHadith:
        return l10n.learnHubCategoryQuranHadithSubtitle;
      case LearnHubCategoryId.prophetsStories:
        return l10n.learnHubCategoryProphetsStoriesSubtitle;
      case LearnHubCategoryId.worshipPractice:
        return l10n.learnHubCategoryWorshipPracticeSubtitle;
      case LearnHubCategoryId.characterAdab:
        return l10n.learnHubCategoryCharacterAdabSubtitle;
      case LearnHubCategoryId.arabicLanguage:
        return l10n.learnHubCategoryArabicLanguageSubtitle;
      case LearnHubCategoryId.kidsLearning:
        return l10n.learnHubCategoryKidsLearningSubtitle;
      case LearnHubCategoryId.quizzesChallenges:
        return l10n.learnHubCategoryQuizzesChallengesSubtitle;
      case LearnHubCategoryId.faq:
        return l10n.learnHubCategoryFaqSubtitle;
      case LearnHubCategoryId.notes:
        return l10n.learnHubCategoryNotesSubtitle;
      case LearnHubCategoryId.toolsExplore:
        return l10n.learnHubCategoryToolsExploreSubtitle;
    }
  }

  static List<LearnHubSubcategoryDescriptor> subcategories(
    AppLocalizations l10n,
  ) {
    return [
      LearnHubSubcategoryDescriptor(
        id: 'who-is-allah',
        title: l10n.learnHubSubcategoryWhoIsAllahTitle,
        subtitle: l10n.learnHubSubcategoryWhoIsAllahSubtitle,
        categoryId: LearnHubCategoryId.foundations,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnJourneyStage',
          pathParameters: {
            'journeyId': 'foundations-of-faith',
            'stageId': 'faith-who-is-allah',
          },
        ),
        searchKeywords: const ['allah', 'belief', 'faith'],
      ),
      LearnHubSubcategoryDescriptor(
        id: 'core-knowledge',
        title: l10n.learnHubSubcategoryCoreKnowledgeTitle,
        subtitle: l10n.learnHubSubcategoryCoreKnowledgeSubtitle,
        categoryId: LearnHubCategoryId.foundations,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnJourneyIsland',
          pathParameters: {'islandId': 'core-knowledge'},
        ),
        searchKeywords: const ['core knowledge', 'foundations', 'essentials'],
      ),
      LearnHubSubcategoryDescriptor(
        id: 'understanding-islam',
        title: l10n.learnHubSubcategoryUnderstandingIslamTitle,
        subtitle: l10n.learnHubSubcategoryUnderstandingIslamSubtitle,
        categoryId: LearnHubCategoryId.foundations,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnJourneyIsland',
          pathParameters: {'islandId': 'understanding-islam'},
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'quran-learning',
        title: l10n.learnCategoryQuranLearningTitle,
        subtitle: l10n.learnHubSubcategoryQuranLearningSubtitle,
        categoryId: LearnHubCategoryId.quranHadith,
        routeTarget: const LearnHubRouteTarget(routeName: 'quranLearningHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'hadith',
        title: l10n.learnCategoryHadithTitle,
        subtitle: l10n.learnHubSubcategoryHadithSubtitle,
        categoryId: LearnHubCategoryId.quranHadith,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnHadithLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'divine-life-lessons',
        title: l10n.learnCategoryDivineLifeLessonsTitle,
        subtitle: l10n.learnHubSubcategoryDivineLifeLessonsSubtitle,
        categoryId: LearnHubCategoryId.quranHadith,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnLifeLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'world-creation',
        title: l10n.learnCategoryWorldCreationTitle,
        subtitle: l10n.learnHubSubcategoryWorldCreationSubtitle,
        categoryId: LearnHubCategoryId.quranHadith,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnWorldLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'knowledge-constellation',
        title: l10n.learningJourneyBrowseKnowledgeConstellationTitle,
        subtitle: l10n.learnHubSubcategoryKnowledgeConstellationSubtitle,
        categoryId: LearnHubCategoryId.quranHadith,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'knowledgeConstellation',
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'prophets',
        title: l10n.learnCategoryStoriesOfProphetsTitle,
        subtitle: l10n.learnHubSubcategoryProphetsSubtitle,
        categoryId: LearnHubCategoryId.prophetsStories,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnProphetsHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'discovery',
        title: l10n.learningJourneyIslandDiscoveryTitle,
        subtitle: l10n.learnHubSubcategoryDiscoverySubtitle,
        categoryId: LearnHubCategoryId.prophetsStories,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnJourneyIsland',
          pathParameters: {'islandId': 'discovery'},
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'worship-learning',
        title: l10n.learningSectionLandingWorshipTitle,
        subtitle: l10n.learnHubSubcategoryWorshipLearningSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnSalahHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'practice-worship',
        title: l10n.learningJourneyIslandPracticeWorshipTitle,
        subtitle: l10n.learnHubSubcategoryPracticeWorshipSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnJourneyIsland',
          pathParameters: {'islandId': 'practice-worship'},
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'salah-trainer',
        title: l10n.learnCategorySalahTrainerTitle,
        subtitle: l10n.learnHubSubcategorySalahTrainerSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnSalahHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'duas',
        title: l10n.learnCategoryDuasTitle,
        subtitle: l10n.learnHubSubcategoryDuaSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnDuaHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'guidance-hub',
        title: l10n.homeSearchGuidanceHubTitle,
        subtitle: l10n.learnHubSubcategoryGuidanceHubSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(routeName: 'islamicGuides'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'islamic-trivia',
        title: l10n.learnCategoryIslamicTriviaTitle,
        subtitle: l10n.learnHubSubcategoryIslamicTriviaSubtitle,
        categoryId: LearnHubCategoryId.worshipPractice,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnIslamicTrivia',
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'character-adab',
        title: l10n.learnHubSubcategoryCharacterAdabTitle,
        subtitle: l10n.learnHubSubcategoryCharacterAdabSubtitle,
        categoryId: LearnHubCategoryId.characterAdab,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnLifeLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'arabic-learning',
        title: l10n.learnHubSubcategoryArabicLearningTitle,
        subtitle: l10n.learnHubSubcategoryArabicLearningSubtitle,
        categoryId: LearnHubCategoryId.arabicLanguage,
        routeTarget: const LearnHubRouteTarget(routeName: 'quranArabic'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'kids-learning',
        title: l10n.learnHubSubcategoryKidsLearningTitle,
        subtitle: l10n.learnHubSubcategoryKidsLearningSubtitle,
        categoryId: LearnHubCategoryId.kidsLearning,
        routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'kids-arabic',
        title: l10n.learnHubSubcategoryKidsArabicTitle,
        subtitle: l10n.learnHubSubcategoryKidsArabicSubtitle,
        categoryId: LearnHubCategoryId.kidsLearning,
        routeTarget: const LearnHubRouteTarget(routeName: 'kidsArabicHome'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'kids-stories',
        title: l10n.learnHubSubcategoryKidsStoriesTitle,
        subtitle: l10n.learnHubSubcategoryKidsStoriesSubtitle,
        categoryId: LearnHubCategoryId.kidsLearning,
        routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaStories'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'kids-salah',
        title: l10n.learnHubSubcategoryKidsSalahTitle,
        subtitle: l10n.learnHubSubcategoryKidsSalahSubtitle,
        categoryId: LearnHubCategoryId.kidsLearning,
        routeTarget: const LearnHubRouteTarget(routeName: 'kidsDuaMyDay'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'quizzes',
        title: l10n.learnCategoryQuizzesTitle,
        subtitle: l10n.learnHubSubcategoryQuizzesSubtitle,
        categoryId: LearnHubCategoryId.quizzesChallenges,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnQuizzesHub'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'challenges',
        title: l10n.learnHubSubcategoryChallengesTitle,
        subtitle: l10n.learnHubSubcategoryChallengesSubtitle,
        categoryId: LearnHubCategoryId.quizzesChallenges,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnIslamicTrivia',
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'faq',
        title: l10n.learnHubCategoryFaqTitle,
        subtitle: l10n.learnHubSubcategoryFaqSubtitle,
        categoryId: LearnHubCategoryId.faq,
        routeTarget: const LearnHubRouteTarget(routeName: 'faqLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'notes',
        title: l10n.learnCategoryNotesTitle,
        subtitle: l10n.learnHubSubcategoryNotesSubtitle,
        categoryId: LearnHubCategoryId.notes,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnNotesLanding'),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'explore-all',
        title: l10n.learnHubExploreAllAction,
        subtitle: l10n.learnHubSubcategoryExploreAllSubtitle,
        categoryId: LearnHubCategoryId.toolsExplore,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnExploreAllKnowledge',
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'search-tools',
        title: l10n.learnHubSubcategorySearchToolsTitle,
        subtitle: l10n.learnHubSubcategorySearchToolsSubtitle,
        categoryId: LearnHubCategoryId.toolsExplore,
        routeTarget: const LearnHubRouteTarget(
          routeName: 'learnExploreAllKnowledge',
        ),
      ),
      LearnHubSubcategoryDescriptor(
        id: 'journey-tools',
        title: l10n.learnHubSubcategoryJourneyToolsTitle,
        subtitle: l10n.learnHubSubcategoryJourneyToolsSubtitle,
        categoryId: LearnHubCategoryId.toolsExplore,
        routeTarget: const LearnHubRouteTarget(routeName: 'learnJourneyHome'),
      ),
    ];
  }

  static LearnHubSubcategoryDescriptor? subcategoryById(
    AppLocalizations l10n,
    String id,
  ) {
    for (final subcategory in subcategories(l10n)) {
      if (subcategory.id == id) {
        return subcategory;
      }
    }
    return null;
  }

  static bool isJourneyRouteTarget(LearnHubRouteTarget routeTarget) {
    switch (routeTarget.routeName) {
      case 'learnJourneyHome':
      case 'learnJourneyIsland':
      case 'learnJourneyDetail':
      case 'learnJourneyStage':
        return true;
      default:
        return false;
    }
  }

  static bool subcategoryUsesJourneyRoute(
    AppLocalizations l10n,
    String? subcategoryId,
  ) {
    if (subcategoryId == null || subcategoryId.isEmpty) {
      return false;
    }
    final subcategory = subcategoryById(l10n, subcategoryId);
    if (subcategory == null) {
      return false;
    }
    return isJourneyRouteTarget(subcategory.routeTarget);
  }
}
