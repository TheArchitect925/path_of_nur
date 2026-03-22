import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';
import '../domain/bedtime_story_learning_models.dart';

class BedtimeStoryQuestionCard extends StatelessWidget {
  const BedtimeStoryQuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswerId,
    required this.locked,
    required this.onSelect,
  });

  final BedtimeStoryQuizQuestion question;
  final String? selectedAnswerId;
  final bool locked;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...question.answerOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerOptionTile(
                label: option.text,
                selected: option.id == selectedAnswerId,
                disabled: locked,
                onTap: () => onSelect(option.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOptionTile extends StatelessWidget {
  const _AnswerOptionTile({
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: selected ? const Color(0xFFFFF1D8) : const Color(0xCCFFF8EF),
          border: Border.all(
            color: selected ? const Color(0xFFE5C588) : const Color(0xFFE8DDD0),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
