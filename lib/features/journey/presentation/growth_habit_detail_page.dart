import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final habit = ref.watch(growthHabitsByIdProvider)[widget.habitId];
    if (habit == null) {
      return AppPageScaffold(
        headerIcon: Icons.track_changes_rounded,
        title: l10n.growthHabitDetailPageTitle,
        subtitle: l10n.growthHabitUnavailableMessage,
        children: [
          PremiumCard(child: Text(l10n.growthHabitUnavailableMessage)),
        ],
      );
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
                  _Pill(
                    label:
                        stageContent?.title ??
                        l10n.growthStageValue('${habit.stage}'),
                  ),
                  _Pill(label: growthDifficultyLabel(habit.difficulty)),
                  _Pill(
                    label: l10n.growthHabitLightRewardValue(
                      '${habit.lightReward}',
                    ),
                  ),
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
                  l10n.growthHabitGentleReminderValue(
                    habitContent.reminderCopy,
                  ),
                  style: const TextStyle(color: Color(0xFF6A5A4A)),
                ),
              ],
              if (habit.reflectionPrompt != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.growthHabitReflectionPromptValue(
                    habit.reflectionPrompt!,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitTodayActionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
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
                    label: Text(l10n.growthHabitCompleteAction),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.snoozed,
                        ),
                    child: Text(l10n.growthHabitReturnLaterAction),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.deferred,
                        ),
                    child: Text(l10n.growthHabitCarryForwardAction),
                  ),
                  FilledButton.tonal(
                    onPressed: () => ref.read(growthControllerProvider.notifier).setHabitStatus(
                          date: selectedDate,
                          habitId: habit.id,
                          status: GrowthHabitStatus.skipped,
                        ),
                    child: Text(l10n.growthHabitPauseTodayAction),
                  ),
                ],
              ),
              if (habit.allowPartial) ...[
                const SizedBox(height: 10),
                Text(l10n.growthHabitPartialCompletionTitle),
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
                  child: Text(l10n.growthHabitSavePartialProgressAction),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.growthHabitCurrentStatusValue(
                  growthStatusLabel(log?.status),
                ),
              ),
              if (habit.allowPartial)
                Text(
                  l10n.growthHabitProgressValue(
                    '${((log?.progress ?? 0) * 100).round()}',
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitSettingsSectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.active,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, active: v),
                title: Text(l10n.growthHabitSettingActive),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.paused,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, paused: v),
                title: Text(l10n.growthHabitSettingPaused),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.showInToday,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, showInToday: v),
                title: Text(l10n.growthHabitSettingShowInTodayWhenDue),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.muted,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, muted: v),
                title: Text(l10n.growthHabitSettingMuteFromTodayView),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.hidden,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, hidden: v),
                title: Text(l10n.growthHabitSettingHideHabit),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.archived,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, archived: v),
                title: Text(l10n.growthHabitSettingArchiveHabit),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.reminderEnabled,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, reminderEnabled: v),
                title: Text(l10n.growthHabitSettingReminderEnabled),
              ),
              if (habit.entrustable)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: habit.entrustToAllah,
                  onChanged: (v) => ref
                      .read(growthControllerProvider.notifier)
                      .updateHabitOverride(habit.id, entrustToAllah: v),
                  title: Text(l10n.growthHabitSettingEntrustQuietTracking),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: habit.privateTracking,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .updateHabitOverride(habit.id, privateTracking: v),
                title: Text(l10n.growthHabitSettingPrivateTracking),
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
