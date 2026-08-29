import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/prophet_quiz.dart';
import '../prophets_daily_copy.dart';

class DailyProphetQuizCard extends StatelessWidget {
  const DailyProphetQuizCard({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.selectedIndex,
    required this.onSelectAnswer,
    required this.onReviewProphet,
    required this.onOpenFullQuiz,
    this.surfaceTreatment = AppSurfaceTreatment.standard,
    this.useHeroGlassShell = false,
  });

  final ProphetQuizQuestion question;
  final bool isAnswered;
  final int? selectedIndex;
  final ValueChanged<int> onSelectAnswer;
  final VoidCallback onReviewProphet;
  final VoidCallback onOpenFullQuiz;
  final AppSurfaceTreatment surfaceTreatment;
  final bool useHeroGlassShell;

  @override
  Widget build(BuildContext context) {
    final copy = ProphetsDailyCopy.of(context);
    final correctIndex = question.correctAnswerIndex;
    final isCorrect = isAnswered && selectedIndex == correctIndex;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              size: 18,
              color: Color(0xFF8A6A3C),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                copy.dailyQuizTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (isAnswered)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: const Color(0x332D8F58),
                  border: Border.all(color: const Color(0x552D8F58)),
                ),
                child: Text(
                  copy.complete,
                  style: const TextStyle(fontSize: 11.5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          question.questionText,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(question.options.length, (index) {
          final option = question.options[index];
          final selected = selectedIndex == index;
          final showCorrect = isAnswered && index == correctIndex;
          final showWrong = isAnswered && selected && !showCorrect;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isAnswered ? null : () => onSelectAnswer(index),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: showCorrect
                      ? const Color(0x332D8F58)
                      : showWrong
                      ? const Color(0x33A55050)
                      : context.palette.surface.withValues(alpha: 0.26),
                  border: Border.all(
                    color: showCorrect
                        ? const Color(0xFF2D8F58)
                        : showWrong
                        ? const Color(0xFFA55050)
                        : (selected
                              ? context.palette.accent.withValues(alpha: 0.65)
                              : context.palette.accentSoft.withValues(
                                  alpha: 0.34,
                                )),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(option)),
                    if (showCorrect)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF2D8F58),
                        size: 18,
                      ),
                    if (showWrong)
                      const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFA55050),
                        size: 18,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (isAnswered) ...[
          const SizedBox(height: 4),
          Text(
            isCorrect ? copy.todayQuestionComplete : copy.gentleCorrection,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isCorrect
                  ? const Color(0xFF2D8F58)
                  : const Color(0xFFA55050),
            ),
          ),
          const SizedBox(height: 4),
          Text(question.explanation),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onReviewProphet,
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(copy.reviewProphet),
              ),
              TextButton.icon(
                onPressed: onOpenFullQuiz,
                icon: const Icon(Icons.quiz_rounded),
                label: Text(copy.openFullQuiz),
              ),
            ],
          ),
        ],
      ],
    );
    if (useHeroGlassShell) {
      return AppHeroGlassShell(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        tintColor: const Color(0xFFE7C98C),
        surfaceAlphaOverride: 0.2,
        radius: 36,
        borderColor: const Color(0x42FFFFFF),
        highlightGradientColors: const [
          Color(0x24FFFFFF),
          Colors.transparent,
          Color(0x16E8C98F),
        ],
        child: content,
      );
    }
    return PremiumCard(surfaceTreatment: surfaceTreatment, child: content);
  }
}
