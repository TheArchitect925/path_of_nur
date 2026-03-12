import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthHabitDetailPage extends ConsumerStatefulWidget {
  const GrowthHabitDetailPage({
    super.key,
    required this.habitId,
  });

  final String habitId;

  @override
  ConsumerState<GrowthHabitDetailPage> createState() =>
      _GrowthHabitDetailPageState();
}

class _GrowthHabitDetailPageState extends ConsumerState<GrowthHabitDetailPage> {
  double _partialValue = 0.5;

  @override
  Widget build(BuildContext context) {
    final habit = ref.watch(growthHabitsByIdProvider)[widget.habitId];
    if (habit == null) {
      return const Scaffold(body: Center(child: Text('This habit is not available right now.')));
    }

    final selectedDate = ref.watch(growthSelectedDateProvider);
    final log = ref.watch(growthLogsForSelectedDateProvider)[habit.id];
    final habitContent = ref.watch(growthHabitContentByIdProvider)[habit.id];
    final stageContent = ref.watch(growthStageContentByNumberProvider)[habit.stage];

    return AppPageScaffold(
      headerIcon: Icons.track_changes_rounded,
      title: habit.title,
      subtitle: habit.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(habit.description),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(label: growthCategoryLabel(habit.category)),
                  _Pill(label: stageContent?.title ?? 'Stage ${habit.stage}'),
                  _Pill(label: growthDifficultyLabel(habit.difficulty)),
                  _Pill(label: 'Light +${habit.lightReward}'),
                  _Pill(
                    label: habitContent?.suggestedRecurrence ??
                        growthRecurrenceLabel(habit),
                  ),
                ],
              ),
              if (stageContent != null) ...[
                const SizedBox(height: 8),
                Text(
                  stageContent.subtitle,
                  style: const TextStyle(color: Color(0xFF6A5A4A)),
                ),
              ],
              if (habitContent != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Gentle reminder: ${habitContent.reminderCopy}',
                  style: const TextStyle(color: Color(0xFF6A5A4A)),
                ),
              ],
              if (habit.reflectionPrompt != null) ...[
                const SizedBox(height: 10),
                Text('Reflection prompt: ${habit.reflectionPrompt!}'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Today Actions', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.completed,
                        ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Complete'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.snoozed,
                        ),
                    child: const Text('Return later'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.deferred,
                        ),
                    child: const Text('Carry forward'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.skipped,
                        ),
                    child: const Text('Pause today'),
                  ),
                ],
              ),
              if (habit.allowPartial) ...[
                const SizedBox(height: 10),
                const Text('Partial completion'),
                Slider(
                  value: _partialValue,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: '${(_partialValue * 100).round()}%',
                  onChanged: (v) => setState(() => _partialValue = v),
                ),
                FilledButton.tonal(
                  onPressed: () => ref.read(growthControllerProvider.notifier).setHabitProgress(
                        date: selectedDate,
                        habitId: habit.id,
                        progress: _partialValue,
                        entrusted: habit.entrustToAllah || habit.privateTracking,
                      ),
                  child: const Text('Save partial progress'),
                ),
              ],
              const SizedBox(height: 8),
              Text('Current status: ${growthStatusLabel(log?.status)}'),
              if (habit.allowPartial)
                Text('Progress: ${((log?.progress ?? 0) * 100).round()}%'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Habit Settings', style: TextStyle(fontWeight: FontWeight.w700)),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.active,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, active: v),
                title: const Text('Active'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.paused,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, paused: v),
                title: const Text('Paused'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.showInToday,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, showInToday: v),
                title: const Text('Show in Today when due'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.muted,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, muted: v),
                title: const Text('Mute from Today view'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.hidden,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, hidden: v),
                title: const Text('Hide habit'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.archived,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, archived: v),
                title: const Text('Archive habit'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.reminderEnabled,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, reminderEnabled: v),
                title: const Text('Reminder enabled (ready for scheduler wiring)'),
              ),
              if (habit.entrustable)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: habit.entrustToAllah,
                  onChanged: (v) => ref
                      .read(growthControllerProvider.notifier)
                      .updateHabitOverride(habit.id, entrustToAllah: v),
                  title: const Text('Entrust deeds to Allah (quiet tracking)'),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.privateTracking,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, privateTracking: v),
                title: const Text('Private tracking by default'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEE3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
