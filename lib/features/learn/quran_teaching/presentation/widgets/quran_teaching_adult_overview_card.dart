import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../domain/quran_teaching_adult_overview_models.dart';

class QuranTeachingAdultOverviewCard extends StatelessWidget {
  const QuranTeachingAdultOverviewCard({
    super.key,
    required this.summary,
    required this.onPrimaryTap,
    this.onReviewTap,
    this.onBrowseLettersTap,
    this.onBrowseWordsTap,
  });

  final QuranTeachingAdultOverviewSummary summary;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onReviewTap;
  final VoidCallback? onBrowseLettersTap;
  final VoidCallback? onBrowseWordsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = summary.progress;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDD5C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranTeachingAdultOverviewTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            switch (summary.state) {
              QuranTeachingAdultOverviewState.firstTime =>
                l10n.quranTeachingAdultOverviewStartBody,
              QuranTeachingAdultOverviewState.inProgress =>
                l10n.quranTeachingAdultOverviewProgressBody,
              QuranTeachingAdultOverviewState.completed =>
                l10n.quranTeachingAdultOverviewCompletedBody,
            },
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF66594C)),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: progress.overallProgress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _OverviewChip(
                label: l10n.arabicLearningProgressAdultLettersValue(
                  progress.engagedLetters,
                  progress.totalLetters,
                ),
              ),
              _OverviewChip(
                label: l10n.arabicLearningProgressAdultWordsValue(
                  progress.engagedWords,
                ),
              ),
              _OverviewChip(
                label: l10n.arabicLearningProgressAdultPhrasesValue(
                  progress.engagedPhrases,
                ),
              ),
              if (progress.completedLessons != null &&
                  progress.totalLessons != null)
                _OverviewChip(
                  label: l10n.arabicLearningProgressAdultLessonsValue(
                    progress.completedLessons!,
                    progress.totalLessons!,
                  ),
                ),
            ],
          ),
          if (progress.completedLessons != null &&
              progress.completedLessons! > 0) ...[
            const SizedBox(height: 12),
            Text(
              l10n.quranTeachingAdultOverviewMilestoneValue(
                progress.completedLessons!,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6A5A46),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (progress.recentActivity != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.quranTeachingAdultOverviewLastStudiedValue(
                progress.recentActivity!.arabicText ??
                    progress.recentActivity!.title,
              ),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF53483E)),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            l10n.quranTeachingAdultOverviewNextStepValue(
              progress.continuation.primaryArabicText ??
                  progress.continuation.primaryTitle ??
                  '',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF53483E)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPrimaryTap,
                  icon: Icon(
                    summary.state == QuranTeachingAdultOverviewState.firstTime
                        ? Icons.play_arrow_rounded
                        : Icons.play_circle_fill_rounded,
                  ),
                  label: Text(_primaryActionLabel(l10n)),
                ),
              ),
              if (summary.reviewTarget != null && onReviewTap != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReviewTap,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.arabicLearningProgressAdultReviewAction),
                  ),
                ),
              ],
            ],
          ),
          if (onBrowseLettersTap != null || onBrowseWordsTap != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onBrowseLettersTap != null)
                  TextButton(
                    onPressed: onBrowseLettersTap,
                    child: Text(l10n.quranTeachingAlphabetOverviewBrowseAction),
                  ),
                if (onBrowseWordsTap != null)
                  TextButton(
                    onPressed: onBrowseWordsTap,
                    child: Text(l10n.quranTeachingBeginnerWordsOpenAction),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _primaryActionLabel(AppLocalizations l10n) {
    switch (summary.state) {
      case QuranTeachingAdultOverviewState.firstTime:
        return l10n.arabicLearningProgressAdultStartAction;
      case QuranTeachingAdultOverviewState.inProgress:
        return l10n.arabicLearningProgressAdultContinueAction;
      case QuranTeachingAdultOverviewState.completed:
        return summary.primaryTarget.contentType ==
                    ArabicLearningContinuationContentType.review ||
                summary.primaryTarget.kind ==
                    ArabicLearningRouteTargetKind.adultDailyReview
            ? l10n.quranTeachingAdultOverviewReviewPrimaryAction
            : l10n.arabicLearningProgressAdultContinueAction;
    }
  }
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5D8C7)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
