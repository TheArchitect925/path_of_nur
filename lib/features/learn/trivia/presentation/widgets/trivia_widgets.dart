import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/trivia_models.dart';
import '../trivia_ui_localization.dart';

class TriviaStatTile extends StatelessWidget {
  const TriviaStatTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PremiumCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
            ),
            if (caption != null) ...[
              const SizedBox(height: 4),
              Text(caption!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class TriviaModeCard extends StatelessWidget {
  const TriviaModeCard({
    super.key,
    required this.mode,
    required this.onPressed,
    this.trailingLabel,
  });

  final TriviaMode mode;
  final VoidCallback onPressed;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mode.localizedLabel(l10n),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (trailingLabel != null) _pill(context, trailingLabel!),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mode.localizedSubtitle(l10n),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.triviaStartAction),
          ),
        ],
      ),
    );
  }
}

class TriviaCategoryCard extends StatelessWidget {
  const TriviaCategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.questionCount,
    required this.accuracyLabel,
    required this.onQuickStart,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int questionCount;
  final String accuracyLabel;
  final VoidCallback? onQuickStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final enabled = questionCount > 0 && onQuickStart != null;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _pill(
                context,
                l10n.triviaQuestionsCount(numberFormat.format(questionCount)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  accuracyLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              FilledButton.tonal(
                onPressed: enabled ? onQuickStart : null,
                child: Text(l10n.triviaQuickStartAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TriviaOptionCard extends StatelessWidget {
  const TriviaOptionCard({
    super.key,
    required this.label,
    required this.stateLabel,
    required this.onTap,
    this.selected = false,
    this.correct = false,
    this.incorrect = false,
    this.disabled = false,
  });

  final String label;
  final String stateLabel;
  final VoidCallback? onTap;
  final bool selected;
  final bool correct;
  final bool incorrect;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? AppColors.success
        : incorrect
        ? AppColors.caution
        : AppColors.surface;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: stateLabel,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: selected || correct || incorrect ? 0.95 : 0.8,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected || correct || incorrect
                  ? AppColors.accentGoldSoft
                  : AppColors.accentGold.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: selected || correct
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (correct)
                const Icon(Icons.check_circle_rounded)
              else if (incorrect)
                const Icon(Icons.cancel_rounded)
              else if (selected)
                const Icon(Icons.radio_button_checked_rounded)
              else
                const Icon(Icons.radio_button_off_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaEmptyStateCard extends StatelessWidget {
  const TriviaEmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          if (action != null) ...[const SizedBox(height: 10), action!],
        ],
      ),
    );
  }
}

class TriviaSectionHeader extends StatelessWidget {
  const TriviaSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
        ),
      ],
    );
  }
}

class TriviaKnowledgePathCard extends StatelessWidget {
  const TriviaKnowledgePathCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final String progressLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _pill(context, progressLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            color: AppColors.accentGoldSoft,
            backgroundColor: AppColors.surfaceSoft,
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: const Icon(Icons.route_rounded),
            label: Text(l10n.triviaOpenPathAction),
          ),
        ],
      ),
    );
  }
}

class TriviaKnowledgeStageTile extends StatelessWidget {
  const TriviaKnowledgeStageTile({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.state,
    required this.difficulty,
    required this.onPressed,
  });

  final int index;
  final String title;
  final String subtitle;
  final TriviaKnowledgeStageState state;
  final TriviaDifficulty difficulty;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final icon = switch (state) {
      TriviaKnowledgeStageState.completed => Icons.check_circle_rounded,
      TriviaKnowledgeStageState.unlocked => Icons.play_circle_outline_rounded,
      TriviaKnowledgeStageState.locked => Icons.lock_rounded,
    };
    final stateLabel = state.localizedLabel(l10n);
    return PremiumCard(
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill(context, stateLabel),
                    _pill(context, difficulty.localizedLabel(l10n)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: state == TriviaKnowledgeStageState.locked
                ? null
                : onPressed,
            tooltip: l10n.triviaOpenStageTooltip,
            icon: Icon(icon),
          ),
        ],
      ),
    );
  }
}

Widget _pill(BuildContext context, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.surfaceSoft.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}
