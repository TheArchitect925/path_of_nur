import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../domain/arabic_learning_quick_resume_models.dart';

enum ArabicLearningQuickResumeSectionVariant { kids, adult }

class ArabicLearningQuickResumeSection extends StatelessWidget {
  const ArabicLearningQuickResumeSection({
    super.key,
    required this.variant,
    required this.summary,
    required this.onPrimaryTap,
    this.onReviewTap,
  });

  final ArabicLearningQuickResumeSectionVariant variant;
  final ArabicLearningQuickResumeSummary summary;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onReviewTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isKids = variant == ArabicLearningQuickResumeSectionVariant.kids;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isKids
                ? l10n.arabicQuickResumeKidsSectionTitle
                : l10n.arabicQuickResumeAdultSectionTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isKids
                ? l10n.arabicQuickResumeKidsSectionSubtitle
                : l10n.arabicQuickResumeAdultSectionSubtitle,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.42,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.primaryTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (summary.primarySubtitle case final subtitle?
                    when subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
                if (summary.primaryArabicText case final arabicText?
                    when arabicText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    arabicText,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: onPrimaryTap,
                icon: Icon(switch (summary.primaryAction) {
                  ArabicLearningQuickResumePrimaryAction.start =>
                    Icons.play_circle_rounded,
                  ArabicLearningQuickResumePrimaryAction.continueLearning =>
                    Icons.play_arrow_rounded,
                  ArabicLearningQuickResumePrimaryAction.review =>
                    Icons.refresh_rounded,
                }),
                label: Text(switch (summary.primaryAction) {
                  ArabicLearningQuickResumePrimaryAction.start =>
                    l10n.arabicQuickResumeStartAction,
                  ArabicLearningQuickResumePrimaryAction.continueLearning =>
                    l10n.arabicQuickResumeContinueAction,
                  ArabicLearningQuickResumePrimaryAction.review =>
                    l10n.arabicQuickResumeReviewAction,
                }),
              ),
              if (summary.hasReviewAction && onReviewTap != null)
                OutlinedButton.icon(
                  onPressed: onReviewTap,
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(l10n.arabicQuickResumeReviewAction),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
