import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';

/// A theme-true pill: a quiet badge, or a toggle when [onTap] is given.
class SalahPill extends StatelessWidget {
  const SalahPill({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = context.palette.accent;
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: selected ? accent.withValues(alpha: 0.16) : null,
    );
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );
    final child = Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: style
          .decoration(radius: 999)
          .copyWith(
            border: selected
                ? Border.all(color: accent.withValues(alpha: 0.7))
                : null,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 13 : 15),
            SizedBox(width: compact ? 4 : 6),
          ],
          // Long labels (a recitation style, a rakah summary) wrap inside
          // the pill instead of running past the line.
          Flexible(child: Text(label, style: textStyle, softWrap: true)),
        ],
      ),
    );
    if (onTap == null) return child;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: child,
      ),
    );
  }
}

/// A titled row of exclusive pill choices.
class SalahPillChoice<T> extends StatelessWidget {
  const SalahPillChoice({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              SalahPill(
                label: labelOf(value),
                selected: value == selected,
                onTap: () => onChanged(value),
              ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
      ],
    );
  }
}

/// "Pick up where you left off" for a guided prayer.
class SalahResumeCard extends StatelessWidget {
  const SalahResumeCard({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.onResume,
    required this.onStartOver,
  });

  final int stepNumber;
  final int totalSteps;
  final VoidCallback onResume;
  final VoidCallback onStartOver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: context.palette.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.salahTrainerResumeTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.salahTrainerResumeSubtitle(stepNumber, totalSteps)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: onResume,
                  child: Text(l10n.salahTrainerResumeAction),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onStartOver,
                  child: Text(l10n.salahTrainerStartOverAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shown when the guided flow has walked every step.
class SalahCompletionCard extends StatelessWidget {
  const SalahCompletionCard({
    super.key,
    required this.prayerTitle,
    required this.surahName,
    required this.onPracticeSurah,
    required this.onReviewStructure,
    required this.onPrayAgain,
  });

  final String prayerTitle;
  final String? surahName;
  final VoidCallback? onPracticeSurah;
  final VoidCallback onReviewStructure;
  final VoidCallback onPrayAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: context.palette.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.salahTrainerCompletedTitle,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.salahTrainerCompletedBody(prayerTitle),
            style: textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 12),
          if (surahName != null && onPracticeSurah != null) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: onPracticeSurah,
                child: Text(l10n.salahTrainerPracticeSurahAction(surahName!)),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReviewStructure,
                  child: Text(l10n.salahTrainerReviewStructureAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onPrayAgain,
                  child: Text(l10n.salahTrainerPrayAgainAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A bulleted line with a small dot, used for notes and essentials.
class SalahBulletRow extends StatelessWidget {
  const SalahBulletRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle_rounded,
              size: 6,
              color: context.palette.accent,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// A school's note on a step: a small labelled pill above the text.
class SalahMadhhabNote extends StatelessWidget {
  const SalahMadhhabNote({super.key, required this.label, required this.note});

  final String label;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalahPill(icon: Icons.school_rounded, label: label, compact: true),
        const SizedBox(height: 6),
        Text(
          note,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.palette.onSurfaceSubtle,
          ),
        ),
      ],
    );
  }
}
