import 'package:flutter/widgets.dart';

class ProphetsDailyCopy {
  const ProphetsDailyCopy._();

  static ProphetsDailyCopyData of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    switch (code) {
      case 'ar':
        return const ProphetsDailyCopyData(
          dailyQuizTitle: 'اختبار الأنبياء اليومي',
          learnMore: 'تعلّم أكثر',
          takeTodaysQuiz: 'سؤال اليوم',
          practiceLesson: 'طبّق هذا في النمو',
          returnTomorrow: 'عُد غدًا لتأمل جديد.',
          opened: 'تم الفتح',
          complete: 'اكتمل',
          todayQuestionComplete: 'اكتمل سؤال اليوم.',
          gentleCorrection: 'تصحيح لطيف لليوم.',
          reviewProphet: 'راجع النبي',
          openFullQuiz: 'افتح الاختبار الكامل',
          todayInRevelation: 'اليوم في الوحي',
          completed: 'مكتمل',
        );
      default:
        return const ProphetsDailyCopyData(
          dailyQuizTitle: 'Daily Prophet Quiz',
          learnMore: 'Learn More',
          takeTodaysQuiz: 'Take Today\'s Quiz',
          practiceLesson: 'Practice This in Growth',
          returnTomorrow: 'Return tomorrow for another insight.',
          opened: 'Opened',
          complete: 'Complete',
          todayQuestionComplete: 'Today\'s question complete.',
          gentleCorrection: 'A gentle correction for today.',
          reviewProphet: 'Review Prophet',
          openFullQuiz: 'Open Full Quiz',
          todayInRevelation: 'Today in Revelation',
          completed: 'Completed',
        );
    }
  }
}

class ProphetsDailyCopyData {
  const ProphetsDailyCopyData({
    required this.dailyQuizTitle,
    required this.learnMore,
    required this.takeTodaysQuiz,
    required this.practiceLesson,
    required this.returnTomorrow,
    required this.opened,
    required this.complete,
    required this.todayQuestionComplete,
    required this.gentleCorrection,
    required this.reviewProphet,
    required this.openFullQuiz,
    required this.todayInRevelation,
    required this.completed,
  });

  final String dailyQuizTitle;
  final String learnMore;
  final String takeTodaysQuiz;
  final String practiceLesson;
  final String returnTomorrow;
  final String opened;
  final String complete;
  final String todayQuestionComplete;
  final String gentleCorrection;
  final String reviewProphet;
  final String openFullQuiz;
  final String todayInRevelation;
  final String completed;
}
