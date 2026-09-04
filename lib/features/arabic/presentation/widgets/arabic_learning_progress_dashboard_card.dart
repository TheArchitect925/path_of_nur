import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/arabic_learning_continuity_models.dart';
import '../../domain/arabic_learning_progress_models.dart';
import '../../../../core/theme/app_palette.dart';

enum ArabicLearningProgressDashboardVariant { kids, adult }

class ArabicLearningProgressDashboardCard extends StatelessWidget {
  const ArabicLearningProgressDashboardCard({
    super.key,
    required this.variant,
    required this.summary,
    required this.onPrimaryTap,
    this.onSecondaryTap,
    this.kidsHighlight,
  });

  final ArabicLearningProgressDashboardVariant variant;
  final ArabicLearningProgressSummary summary;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final String? kidsHighlight;

  bool get _isKids => variant == ArabicLearningProgressDashboardVariant.kids;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _isKids ? const Color(0xFFFFF4E8) : const Color(0xFFF7F4EE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isKids ? const Color(0xFFE7D8BE) : const Color(0xFFDDD5C8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isKids
                ? l10n.arabicLearningProgressKidsTitle
                : l10n.arabicLearningProgressAdultTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            _subtitle(l10n),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF66594C)),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: summary.overallProgress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: _chips(l10n)),
          if (_isKids && kidsHighlight != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.arabicLearningProgressKidsHighlight(kidsHighlight!),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
          if (summary.recentActivity != null) ...[
            const SizedBox(height: 12),
            Text(
              _recentLabel(l10n, summary.recentActivity!),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.palette.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            _nextStepLabel(l10n),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.palette.onSurface),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPrimaryTap,
                  icon: Icon(
                    summary.continuation.intent ==
                            ArabicLearningContinuationIntent.start
                        ? Icons.play_arrow_rounded
                        : Icons.play_circle_fill_rounded,
                  ),
                  label: Text(_primaryActionLabel(l10n)),
                ),
              ),
              if (summary.reviewSuggestion != null &&
                  onSecondaryTap != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSecondaryTap,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(_secondaryActionLabel(l10n)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _subtitle(AppLocalizations l10n) {
    if (!summary.hasStarted) {
      return _isKids
          ? l10n.arabicLearningProgressKidsStartSubtitle
          : l10n.arabicLearningProgressAdultStartSubtitle;
    }
    return _isKids
        ? l10n.arabicLearningProgressKidsSubtitle
        : l10n.arabicLearningProgressAdultSubtitle;
  }

  List<Widget> _chips(AppLocalizations l10n) {
    final chips = <Widget>[
      _DashboardChip(
        label: _isKids
            ? l10n.arabicLearningProgressKidsLettersValue(
                summary.engagedLetters,
              )
            : l10n.arabicLearningProgressAdultLettersValue(
                summary.engagedLetters,
                summary.totalLetters,
              ),
      ),
      _DashboardChip(
        label: _isKids
            ? l10n.arabicLearningProgressKidsWordsValue(summary.engagedWords)
            : l10n.arabicLearningProgressAdultWordsValue(summary.engagedWords),
      ),
      _DashboardChip(
        label: _isKids
            ? l10n.arabicLearningProgressKidsPhrasesValue(
                summary.engagedPhrases,
              )
            : l10n.arabicLearningProgressAdultPhrasesValue(
                summary.engagedPhrases,
              ),
      ),
    ];
    if (_isKids && summary.currentStreakDays != null) {
      chips.add(
        _DashboardChip(
          label: l10n.arabicLearningProgressKidsStreakValue(
            summary.currentStreakDays!,
          ),
        ),
      );
    }
    if (!_isKids &&
        summary.completedLessons != null &&
        summary.totalLessons != null) {
      chips.add(
        _DashboardChip(
          label: l10n.arabicLearningProgressAdultLessonsValue(
            summary.completedLessons!,
            summary.totalLessons!,
          ),
        ),
      );
    }
    return chips;
  }

  String _recentLabel(
    AppLocalizations l10n,
    ArabicLearningRecentActivity activity,
  ) {
    final value = activity.arabicText ?? activity.title;
    return _isKids
        ? l10n.arabicLearningProgressKidsRecentValue(value)
        : l10n.arabicLearningProgressAdultRecentValue(value);
  }

  String _nextStepLabel(AppLocalizations l10n) {
    final value =
        summary.continuation.primaryArabicText ??
        summary.continuation.primaryTitle ??
        '';
    return _isKids
        ? l10n.arabicLearningProgressKidsNextValue(value)
        : l10n.arabicLearningProgressAdultNextValue(value);
  }

  String _primaryActionLabel(AppLocalizations l10n) {
    if (summary.continuation.intent == ArabicLearningContinuationIntent.start) {
      return _isKids
          ? l10n.arabicLearningProgressKidsStartAction
          : l10n.arabicLearningProgressAdultStartAction;
    }
    return _isKids
        ? l10n.arabicLearningProgressKidsContinueAction
        : l10n.arabicLearningProgressAdultContinueAction;
  }

  String _secondaryActionLabel(AppLocalizations l10n) {
    return _isKids
        ? l10n.arabicLearningProgressKidsReviewAction
        : l10n.arabicLearningProgressAdultReviewAction;
  }
}

class _DashboardChip extends StatelessWidget {
  const _DashboardChip({required this.label});

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
