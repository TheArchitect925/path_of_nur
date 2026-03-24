import '../../../l10n/app_localizations.dart';
import 'models/learn_category_item.dart';

extension LearnCategoryItemLocalization on LearnCategoryItem {
  String localizedTitle(AppLocalizations l10n) {
    switch (id) {
      case 'quran':
        return l10n.learnCategoryHolyQuranTitle;
      case 'quran-learning':
        return l10n.learnCategoryQuranLearningTitle;
      case 'quranic-arabic':
        return l10n.learnCategoryQuranicArabicTitle;
      case 'islamic-trivia':
        return l10n.learnCategoryIslamicTriviaTitle;
      case 'hadith':
        return l10n.learnCategoryHadithTitle;
      case 'life-lessons-quran':
        return l10n.learnCategoryDivineLifeLessonsTitle;
      case 'world-through-quran':
        return l10n.learnCategoryWorldCreationTitle;
      case 'knowledge-constellation':
        return l10n.learningJourneyBrowseKnowledgeConstellationTitle;
      case 'prophets':
        return l10n.learnCategoryStoriesOfProphetsTitle;
      case 'seerah-companion':
        return l10n.learningJourneySeerahJourneyTitle;
      case 'glossary':
        return l10n.learnGlossaryTitle;
      case 'baby-names':
        return l10n.learnCategoryBabyNamesTitle;
      case 'allah-names':
        return l10n.quranNamesOfAllahTitle;
      case 'quizzes':
        return l10n.learnCategoryQuizzesTitle;
      case 'duas':
        return l10n.learnCategoryDuasTitle;
      case 'salah':
        return l10n.learnCategorySalahTrainerTitle;
      case 'notes':
        return l10n.learnCategoryNotesTitle;
      case 'character-companion':
        return l10n.learnHubSubcategoryCharacterAdabTitle;
      case 'daily-wisdom-companion':
        return l10n.learningJourneyDailyWisdomTitle;
      case 'islamic-guidance-hub':
        return l10n.homeSearchGuidanceHubTitle;
      default:
        return title;
    }
  }

  String? localizedDescription(AppLocalizations l10n) {
    if (description != null && description!.trim().isNotEmpty) {
      return description;
    }

    switch (id) {
      case 'seerah-companion':
        return l10n.learningJourneySeerahJourneySubtitle;
      case 'character-companion':
        return l10n.learnHubSubcategoryCharacterAdabSubtitle;
      case 'daily-wisdom-companion':
        return l10n.learningJourneyDailyWisdomSubtitle;
      case 'glossary':
        return l10n.learnGlossaryCardSubtitle;
      default:
        return null;
    }
  }

  String? localizedBadgeLabel(AppLocalizations l10n) {
    if (badgeLabel == null || badgeLabel!.trim().isEmpty) return null;
    if (badgeLabel == 'New') return l10n.learnCommonNewBadge;
    return badgeLabel;
  }
}
