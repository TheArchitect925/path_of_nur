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
      case 'islamic-guidance-hub':
        return l10n.homeSearchGuidanceHubTitle;
      default:
        return title;
    }
  }

  String? localizedBadgeLabel(AppLocalizations l10n) {
    if (badgeLabel == null || badgeLabel!.trim().isEmpty) return null;
    if (badgeLabel == 'New') return l10n.learnCommonNewBadge;
    return badgeLabel;
  }
}
