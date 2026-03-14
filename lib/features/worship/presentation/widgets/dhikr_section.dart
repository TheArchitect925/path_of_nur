import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/dhikr_controller.dart';
import '../../domain/dhikr_preset.dart';
import '../../domain/dhikr_session.dart';

class DhikrSection extends ConsumerWidget {
  const DhikrSection({super.key});

  static const _dailyDhikrGoal = 500;

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Dhikr Session'),
          content: const Text('This will clear your current count and start fresh.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      ref.read(dhikrControllerProvider.notifier).reset();
    }
  }

  void _setCustomTarget(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Custom Target'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter target count',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null && value > 0) {
                  ref
                      .read(dhikrControllerProvider.notifier)
                      .setTarget(value);
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dhikrControllerProvider);
    final notifier = ref.read(dhikrControllerProvider.notifier);
    final progress = (state.currentCount / state.target).clamp(0, 1).toDouble();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayCompleted = state.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .fold<int>(0, (sum, session) => sum + session.count);
    final todaySessions = state.recentSessions
        .where((session) => !session.finishedAt.isBefore(todayStart))
        .length;
    final todayTotal = todayCompleted + state.currentCount;
    final dailyProgress = (todayTotal / _dailyDhikrGoal).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Dhikr',
          subtitle: 'A calm active session. Count with intention, pause with awareness.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.selectedPreset.label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                state.selectedPreset.transliteration,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              Text(
                state.selectedPreset.translation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceSoft,
                minHeight: 8,
              ),
              const SizedBox(height: 10),
              Text(
                '${state.currentCount} / ${state.target}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  height: 1,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: notifier.increment,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.homeAccent.withValues(alpha: 0.22),
                      border: Border.all(
                        color: AppColors.homeAccent.withValues(alpha: 0.7),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tap\nTo Count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (state.hasTargetReached)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Beautiful — target reached. Finish this session when ready.',
                    style: TextStyle(color: AppColors.success),
                  ),
                ),
              Row(
                children: [
                  IconButton(
                    onPressed: notifier.undo,
                    icon: const Icon(Icons.undo_rounded),
                    tooltip: 'Undo one',
                  ),
                  const SizedBox(width: AppSpacing.s),
                  TextButton(
                    onPressed: () => _confirmReset(context, ref),
                    child: const Text('Reset'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: notifier.finishSession,
                    child: const Text('Finish Session'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionTitle(
          title: 'Choose Phrase',
          subtitle: 'Pick one dhikr phrase for the current session.',
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...DhikrPreset.defaults.map((preset) {
              final isSelected = preset.id == state.selectedPreset.id;
              return InkWell(
                onTap: () => notifier.selectPreset(preset),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentGold
                          : AppColors.accentGoldSoft.withValues(alpha: 0.45),
                    ),
                    color: isSelected
                        ? AppColors.accentGold.withValues(alpha: 0.16)
                        : AppColors.surfaceSoft.withValues(alpha: 0.35),
                  ),
                  child: Text(
                    preset.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onSurface
                          : AppColors.onSurfaceSubtle,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        const SectionTitle(
          title: 'Session Target',
          subtitle: 'Set target count for this current dhikr session.',
        ),
        Wrap(
          spacing: 8,
          children: [
            ...[33, 99, 100, 500].map(
              (value) => _TargetChip(
                value: value,
                isSelected: state.target == value,
                onTap: () => notifier.setTarget(value),
              ),
            ),
            _TargetChip(
              value: null,
              isSelected: false,
              label: 'Custom',
              onTap: () => _setCustomTarget(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Dhikr Goal',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: dailyProgress,
                backgroundColor: AppColors.surfaceSoft,
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              Text(
                '$todayTotal / $_dailyDhikrGoal',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Daily minimum across the day, separate from the current session target.',
                style: TextStyle(color: AppColors.onSurfaceSubtle),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              const Text(
                'Session vs Daily',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text('Current session: ${state.currentCount} / ${state.target}'),
              const SizedBox(height: 6),
              Text('Completed today: $todayCompleted'),
              const SizedBox(height: 6),
              Text('Daily total including current session: $todayTotal'),
              const SizedBox(height: 6),
              Text('Sessions completed today: $todaySessions'),
              const SizedBox(height: 6),
              Text('Favorite phrase: ${state.summary.favoritePhrase}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Recent Sessions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (state.recentSessions.isEmpty)
          PremiumCard(
            child: const Text(
              'No completed sessions yet. Keep the first one gentle.',
              style: TextStyle(color: AppColors.onSurfaceSubtle),
            ),
          )
        else
          ...state.recentSessions
              .map(
                (session) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RecentDhikrSessionCard(session: session),
                ),
              ),
      ],
    );
  }
}

class _TargetChip extends StatelessWidget {
  const _TargetChip({
    this.value,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  final int? value;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = label ?? value.toString();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? AppColors.accentGold.withValues(alpha: 0.18)
              : AppColors.surface.withValues(alpha: 0.45),
          border: Border.all(
            color: isSelected
                ? AppColors.accentGold
                : AppColors.accentGoldSoft.withValues(alpha: 0.45),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _RecentDhikrSessionCard extends StatelessWidget {
  const _RecentDhikrSessionCard({required this.session});

  final DhikrSession session;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.accentGoldSoft,
            child: Text(
              '${session.count}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.phraseLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.count} / ${session.target} • ${session.durationLabel}',
                  style: const TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${session.finishedAt.hour}:${session.finishedAt.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}
