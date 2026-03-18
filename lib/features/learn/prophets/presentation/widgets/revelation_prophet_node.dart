import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';

class RevelationProphetNode extends StatelessWidget {
  const RevelationProphetNode({
    super.key,
    required this.name,
    required this.arabicName,
    required this.summary,
    required this.regionLabel,
    required this.keyLesson,
    required this.coreCall,
    required this.referenceLabel,
    required this.completed,
    required this.current,
    required this.isFirst,
    required this.isLast,
    required this.onOpenDetail,
    required this.onContinue,
  });

  final String name;
  final String arabicName;
  final String summary;
  final String regionLabel;
  final String keyLesson;
  final String coreCall;
  final String referenceLabel;
  final bool completed;
  final bool current;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onOpenDetail;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lineColor = AppColors.accentGoldSoft.withValues(alpha: 0.48);
    final nodeColor = completed
        ? const Color(0xFF2D8F58)
        : current
        ? AppColors.accentGold
        : const Color(0xFF85796B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 26,
          child: Column(
            children: [
              Container(
                width: 2,
                height: isFirst ? 0 : 18,
                color: isFirst ? Colors.transparent : lineColor,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: nodeColor,
                  boxShadow: current
                      ? [
                          BoxShadow(
                            color: nodeColor.withValues(alpha: 0.45),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              Container(
                width: 2,
                height: isLast ? 0 : 112,
                color: isLast ? Colors.transparent : lineColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    arabicName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(summary),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip(l10n.prophetsLessonChip(keyLesson)),
                      _chip(l10n.prophetsCoreCallChip(coreCall)),
                      _chip(l10n.prophetsRegionChip(regionLabel)),
                      if (referenceLabel.isNotEmpty) _chip(referenceLabel),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: onOpenDetail,
                        icon: const Icon(Icons.menu_book_rounded),
                        label: Text(l10n.prophetsOpenDetailAction),
                      ),
                      OutlinedButton(
                        onPressed: onContinue,
                        child: Text(l10n.prophetsJourneyContinueAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.28),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
    );
  }
}
