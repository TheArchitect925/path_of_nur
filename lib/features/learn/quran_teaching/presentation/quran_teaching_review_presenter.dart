import '../domain/quran_teaching_models.dart';
import '../domain/quran_teaching_review_models.dart';

enum QuranTeachingReviewInteractionType {
  selfCheck,
  trueFalse,
  buildWord,
  multipleChoice,
}

class QuranTeachingReviewPresenter {
  const QuranTeachingReviewPresenter._();

  static QuranTeachingReviewInteractionType interactionTypeForRecord(
    QuranTeachingReviewRecord record,
  ) {
    if (record.buildOrder.isNotEmpty) {
      return QuranTeachingReviewInteractionType.buildWord;
    }
    if (record.options.isEmpty && record.correctOptionIds.isEmpty) {
      return QuranTeachingReviewInteractionType.selfCheck;
    }
    if (record.options.length == 2 &&
        record.options.every(
          (option) =>
              option.label.toLowerCase() == 'true' ||
              option.label.toLowerCase() == 'false',
        )) {
      return QuranTeachingReviewInteractionType.trueFalse;
    }
    return QuranTeachingReviewInteractionType.multipleChoice;
  }

  static bool isSelfCheck(QuranTeachingReviewRecord record) {
    return interactionTypeForRecord(record) ==
        QuranTeachingReviewInteractionType.selfCheck;
  }

  static bool isCorrectRecordAnswer({
    required QuranTeachingReviewRecord record,
    required String? selectedOptionId,
    required bool? selectedTrueFalse,
    required List<String> selectedTokens,
  }) {
    switch (interactionTypeForRecord(record)) {
      case QuranTeachingReviewInteractionType.selfCheck:
        return false;
      case QuranTeachingReviewInteractionType.trueFalse:
        return selectedTrueFalse == record.truthAnswer;
      case QuranTeachingReviewInteractionType.buildWord:
        return selectedTokens.join('|') == record.buildOrder.join('|');
      case QuranTeachingReviewInteractionType.multipleChoice:
        return record.correctOptionIds.contains(selectedOptionId);
    }
  }

  static bool isCorrectMistakeAnswer({
    required QuranTeachingMistakeItem item,
    required String? selectedOptionId,
    required bool? selectedTrueFalse,
    required List<String> selectedTokens,
  }) {
    switch (item.quizType) {
      case QuranTeachingQuizType.trueFalse:
        return selectedTrueFalse == item.truthAnswer;
      case QuranTeachingQuizType.tapInOrderBuildWord:
        return selectedTokens.join('|') == item.buildOrder.join('|');
      default:
        return item.correctOptionIds.contains(selectedOptionId);
    }
  }
}
