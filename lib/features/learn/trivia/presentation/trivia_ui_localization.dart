import '../../../../l10n/app_localizations.dart';
import '../domain/trivia_models.dart';

extension TriviaModeLocalization on TriviaMode {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TriviaMode.quickChallenge:
        return l10n.triviaModeQuickChallenge;
      case TriviaMode.deepDive:
        return l10n.triviaModeDeepDive;
      case TriviaMode.dailyQuiz:
        return l10n.triviaModeDailyQuiz;
      case TriviaMode.survival:
        return l10n.triviaModeSurvival;
      case TriviaMode.reviewMistakes:
        return l10n.triviaModeReviewMistakes;
    }
  }

  String localizedSubtitle(AppLocalizations l10n) {
    switch (this) {
      case TriviaMode.quickChallenge:
        return l10n.triviaModeQuickChallengeSubtitle;
      case TriviaMode.deepDive:
        return l10n.triviaModeDeepDiveSubtitle;
      case TriviaMode.dailyQuiz:
        return l10n.triviaModeDailyQuizSubtitle;
      case TriviaMode.survival:
        return l10n.triviaModeSurvivalSubtitle;
      case TriviaMode.reviewMistakes:
        return l10n.triviaModeReviewMistakesSubtitle;
    }
  }
}

extension TriviaDifficultyLocalization on TriviaDifficulty {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TriviaDifficulty.easy:
        return l10n.triviaDifficultyEasy;
      case TriviaDifficulty.medium:
        return l10n.triviaDifficultyMedium;
      case TriviaDifficulty.hard:
        return l10n.triviaDifficultyHard;
    }
  }
}

extension TriviaKnowledgeStageStateLocalization on TriviaKnowledgeStageState {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TriviaKnowledgeStageState.completed:
        return l10n.triviaStageStateCompleted;
      case TriviaKnowledgeStageState.unlocked:
        return l10n.triviaStageStateUnlocked;
      case TriviaKnowledgeStageState.locked:
        return l10n.triviaStageStateLocked;
    }
  }
}

extension TriviaReviewMasteryStateLocalization on TriviaReviewMasteryState {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TriviaReviewMasteryState.newItem:
        return l10n.triviaMasteryNew;
      case TriviaReviewMasteryState.learning:
        return l10n.triviaMasteryLearning;
      case TriviaReviewMasteryState.improving:
        return l10n.triviaMasteryImproving;
      case TriviaReviewMasteryState.mastered:
        return l10n.triviaMasteryMastered;
    }
  }
}
