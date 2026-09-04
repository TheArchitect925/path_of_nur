import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../domain/bedtime_routine_models.dart';
import '../../../../core/theme/app_palette.dart';

class BedtimeRoutineStepCard extends StatelessWidget {
  const BedtimeRoutineStepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.actionLabel,
    required this.onTap,
    this.icon = Icons.nightlight_round,
  });

  final String title;
  final String subtitle;
  final BedtimeRoutineStepProgress progress;
  final String actionLabel;
  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: progress.state == BedtimeRoutineCompletionState.completed
              ? const Color(0xFFD8C39B)
              : const Color(0xFFE9DED1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFFFF7EB),
            child: Icon(icon, color: const Color(0xFF8A6A45)),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.palette.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _StatusChip(
                      label: switch (progress.state) {
                        BedtimeRoutineCompletionState.completed =>
                          l10n.bedtimeCompanionStepCompleted,
                        BedtimeRoutineCompletionState.inProgress =>
                          l10n.bedtimeCompanionStepInProgress,
                        BedtimeRoutineCompletionState.skipped =>
                          l10n.bedtimeCompanionStepOptionalDone,
                        BedtimeRoutineCompletionState.notStarted =>
                          l10n.bedtimeCompanionStepNotStarted,
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.tonal(
                          onPressed: onTap,
                          child: Text(actionLabel),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE4D6C1)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
