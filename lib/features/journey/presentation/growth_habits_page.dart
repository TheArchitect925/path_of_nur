import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthHabitsPage extends ConsumerWidget {
  const GrowthHabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(growthAllHabitsProvider);
    final state = ref.watch(growthControllerProvider);
    final selectedDate = ref.watch(growthSelectedDateProvider);
    final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);
    final reminderSettings = ref.watch(
      growthControllerProvider.select((state) => state.globalReminderSettings),
    );
    final builtIn = habits
        .where((h) => !h.isCustom && !h.archived && !h.id.startsWith('s_'))
        .toList();
    final seasonalHabits = habits
        .where((h) => !h.isCustom && h.id.startsWith('s_') && !h.archived)
        .where((habit) => isHabitDueOnDate(habit, selectedDate, state))
        .toList();
    final myHabits = habits
        .where((h) => h.isCustom && !h.archived && !h.paused)
        .toList();
    final pausedOrArchived = habits
        .where((h) => h.paused || h.archived)
        .toList();

    final templates = _quickTemplates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: const Text(
              'Growth Reminder Settings',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'Gentle reminders that support your path without pressure.',
            ),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.remindersEnabled,
                onChanged: (value) => ref
                    .read(growthControllerProvider.notifier)
                    .updateGlobalReminderSettings(remindersEnabled: value),
                title: const Text('Enable Growth reminders'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.pauseAllReminders,
                onChanged: reminderSettings.remindersEnabled
                    ? (value) => ref
                          .read(growthControllerProvider.notifier)
                          .updateGlobalReminderSettings(pauseAllReminders: value)
                    : null,
                title: const Text('Pause all reminders for now'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.gentleMode,
                onChanged: reminderSettings.remindersEnabled
                    ? (value) => ref
                          .read(growthControllerProvider.notifier)
                          .updateGlobalReminderSettings(gentleMode: value)
                    : null,
                title: const Text('Gentle reminder mode'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.quietDelivery,
                onChanged: reminderSettings.remindersEnabled
                    ? (value) => ref
                          .read(growthControllerProvider.notifier)
                          .updateGlobalReminderSettings(quietDelivery: value)
                    : null,
                title: const Text('Quiet delivery'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.respectDoNotDisturb,
                onChanged: reminderSettings.remindersEnabled
                    ? (value) => ref
                          .read(growthControllerProvider.notifier)
                          .updateGlobalReminderSettings(
                            respectDoNotDisturb: value,
                          )
                    : null,
                title: const Text('Respect system Do Not Disturb'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: reminderSettings.ramadanCompatibilityMode,
                onChanged: reminderSettings.remindersEnabled
                    ? (value) => ref
                          .read(growthControllerProvider.notifier)
                          .updateGlobalReminderSettings(
                            ramadanCompatibilityMode: value,
                          )
                    : null,
                title: const Text('Ramadan compatibility mode'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick Add Templates', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: templates
                    .map(
                      (template) => ActionChip(
                        label: Text(template.title),
                        onPressed: () => _showHabitEditorSheet(
                          context,
                          ref,
                          initial: _HabitEditorInitial.fromTemplate(template),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => _showHabitEditorSheet(context, ref),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Custom Habit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (seasonalHabits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HabitSection(
              title: 'Seasonal Journeys',
              subtitle: seasonalCards.isEmpty
                  ? 'Seasonal habits for blessed times.'
                  : seasonalCards.map((card) => '${card.icon} ${card.title}').join(' · '),
              habits: seasonalHabits,
              isCustomSection: false,
              onOpen: (habitId) => context.pushNamed(
                'growthHabitDetail',
                pathParameters: {'habitId': habitId},
              ),
              onAction: (habit, action) => _handleBuiltInAction(ref, habit, action),
            ),
          ),
        const SizedBox(height: 0),
        _HabitSection(
          title: 'Built-In Habits',
          subtitle: 'Guided habits curated in Path of Nūr.',
          habits: builtIn,
          isCustomSection: false,
          onOpen: (habitId) => context.pushNamed(
            'growthHabitDetail',
            pathParameters: {'habitId': habitId},
          ),
          onAction: (habit, action) => _handleBuiltInAction(ref, habit, action),
        ),
        const SizedBox(height: 12),
        _HabitSection(
          title: 'My Habits',
          subtitle: 'Your personal rhythms and custom intentions.',
          habits: myHabits,
          isCustomSection: true,
          onOpen: (habitId) => context.pushNamed(
            'growthHabitDetail',
            pathParameters: {'habitId': habitId},
          ),
          onAction: (habit, action) => _handleCustomAction(
            context,
            ref,
            habit,
            action,
          ),
        ),
        const SizedBox(height: 12),
        _HabitSection(
          title: 'Paused / Archived',
          subtitle: 'Habits resting for now. Return gently anytime.',
          habits: pausedOrArchived,
          isCustomSection: true,
          onOpen: (habitId) => context.pushNamed(
            'growthHabitDetail',
            pathParameters: {'habitId': habitId},
          ),
          onAction: (habit, action) => _handleCustomAction(
            context,
            ref,
            habit,
            action,
          ),
        ),
      ],
    );
  }

  void _handleBuiltInAction(WidgetRef ref, GrowthHabit habit, String action) {
    final controller = ref.read(growthControllerProvider.notifier);
    switch (action) {
      case 'toggle_active':
        controller.updateHabitOverride(habit.id, active: !habit.active);
        break;
      case 'toggle_paused':
        controller.updateHabitOverride(habit.id, paused: !habit.paused);
        break;
      case 'toggle_mute':
        controller.updateHabitOverride(habit.id, muted: !habit.muted);
        break;
      case 'toggle_hidden':
        controller.updateHabitOverride(habit.id, hidden: !habit.hidden);
        break;
      case 'toggle_show_today':
        controller.updateHabitOverride(habit.id, showInToday: !habit.showInToday);
        break;
      case 'toggle_entrust':
        controller.updateHabitOverride(
          habit.id,
          entrustToAllah: !habit.entrustToAllah,
        );
        break;
      case 'pin_focus':
        controller.setFocusHabit(habit.id);
        break;
      case 'toggle_reminder':
        controller.updateHabitOverride(
          habit.id,
          reminderEnabled: !habit.reminderEnabled,
        );
        break;
      case 'toggle_reminders_paused':
        controller.updateHabitOverride(
          habit.id,
          remindersPaused: !habit.remindersPaused,
        );
        break;
    }
  }

  Future<void> _handleCustomAction(
    BuildContext context,
    WidgetRef ref,
    GrowthHabit habit,
    String action,
  ) async {
    final controller = ref.read(growthControllerProvider.notifier);
    switch (action) {
      case 'edit':
        await _showHabitEditorSheet(
          context,
          ref,
          existingHabit: habit,
          initial: _HabitEditorInitial.fromHabit(habit),
        );
        break;
      case 'duplicate':
        controller.duplicateCustomHabit(habit.id);
        break;
      case 'delete':
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete habit?'),
            content: const Text('This removes the custom habit and its local progress log.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (shouldDelete == true) {
          controller.deleteCustomHabit(habit.id);
        }
        break;
      case 'toggle_active':
        controller.updateHabitOverride(habit.id, active: !habit.active);
        break;
      case 'toggle_paused':
        controller.updateHabitOverride(habit.id, paused: !habit.paused);
        break;
      case 'toggle_mute':
        controller.updateHabitOverride(habit.id, muted: !habit.muted);
        break;
      case 'toggle_hidden':
        controller.updateHabitOverride(habit.id, hidden: !habit.hidden);
        break;
      case 'toggle_archive':
        controller.updateHabitOverride(habit.id, archived: !habit.archived);
        break;
      case 'toggle_show_today':
        controller.updateHabitOverride(habit.id, showInToday: !habit.showInToday);
        break;
      case 'toggle_reminder':
        controller.updateHabitOverride(
          habit.id,
          reminderEnabled: !habit.reminderEnabled,
        );
        break;
      case 'toggle_reminders_paused':
        controller.updateHabitOverride(
          habit.id,
          remindersPaused: !habit.remindersPaused,
        );
        break;
      case 'toggle_private':
        controller.updateHabitOverride(
          habit.id,
          privateTracking: !habit.privateTracking,
        );
        break;
      case 'toggle_entrust':
        controller.updateHabitOverride(
          habit.id,
          entrustToAllah: !habit.entrustToAllah,
        );
        break;
      case 'pin_focus':
        controller.setFocusHabit(habit.id);
        break;
    }
  }

  Future<void> _showHabitEditorSheet(
    BuildContext context,
    WidgetRef ref, {
    GrowthHabit? existingHabit,
    _HabitEditorInitial? initial,
  }) async {
    final draft = initial ?? const _HabitEditorInitial();
    final titleCtrl = TextEditingController(text: draft.title);
    final subtitleCtrl = TextEditingController(text: draft.subtitle);
    final descriptionCtrl = TextEditingController(text: draft.description);
    final reflectionCtrl = TextEditingController(text: draft.reflectionPrompt);

    final allPaths = ref.read(growthPathsProvider);

    GrowthHabitCategory category = draft.category;
    GrowthHabitRecurrenceType recurrence = draft.recurrenceType;
    int frequencyTarget = draft.frequencyTarget;
    int customIntervalDays = draft.customIntervalDays;
    int difficulty = draft.difficulty;
    int reward = draft.lightReward;
    bool reminder = draft.reminderEnabled;
    bool entrustable = draft.entrustable;
    bool privateTracking = draft.privateTracking;
    bool allowPartial = draft.allowPartial;
    bool showInToday = draft.showInToday;
    bool active = draft.active;
    bool paused = draft.paused;
    bool archived = draft.archived;
    String? linkedPathId = draft.linkedPathId;
    final weekdays = <int>{...draft.weekdays};
    GrowthReminderMode reminderMode = draft.reminderMode;
    int reminderTimeMinutes = draft.reminderTimeMinutes;
    GrowthReminderPrayerAnchor? reminderPrayerAnchor = draft.reminderPrayerAnchor;
    int reminderOffsetMinutes = draft.reminderOffsetMinutes;
    GrowthReminderWindowType reminderWindowType =
        draft.reminderWindowType ?? GrowthReminderWindowType.evening;
    final reminderDays = <int>{...draft.reminderDays};
    bool quietDelivery = draft.quietDelivery;
    bool allowSnooze = draft.allowSnooze;
    bool remindersPaused = draft.remindersPaused;
    final reminderMessageCtrl = TextEditingController(
      text: draft.reminderMessageOverride,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        existingHabit == null
                            ? 'Create Custom Habit'
                            : 'Edit Custom Habit',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: subtitleCtrl,
                        decoration: const InputDecoration(labelText: 'Subtitle (optional)'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'Description / Notes'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<GrowthHabitCategory>(
                        initialValue: category,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: GrowthHabitCategory.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(growthCategoryLabel(e)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => category = value);
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: linkedPathId,
                        decoration: const InputDecoration(labelText: 'Linked path (optional)'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...allPaths.map(
                            (path) => DropdownMenuItem<String>(
                              value: path.id,
                              child: Text(path.title),
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(() => linkedPathId = value),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<GrowthHabitRecurrenceType>(
                        initialValue: recurrence,
                        decoration: const InputDecoration(labelText: 'Recurrence'),
                        items: const [
                          DropdownMenuItem(
                            value: GrowthHabitRecurrenceType.daily,
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: GrowthHabitRecurrenceType.customWeekdays,
                            child: Text('Selected weekdays'),
                          ),
                          DropdownMenuItem(
                            value: GrowthHabitRecurrenceType.weeklyTarget,
                            child: Text('X times per week'),
                          ),
                          DropdownMenuItem(
                            value: GrowthHabitRecurrenceType.customFrequency,
                            child: Text('Every X days'),
                          ),
                          DropdownMenuItem(
                            value: GrowthHabitRecurrenceType.occasional,
                            child: Text('Occasional / as able'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => recurrence = value);
                        },
                      ),
                      if (recurrence == GrowthHabitRecurrenceType.customWeekdays) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: List.generate(7, (i) {
                            final day = i + 1;
                            return FilterChip(
                              label: Text(_weekday(day)),
                              selected: weekdays.contains(day),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    weekdays.add(day);
                                  } else {
                                    weekdays.remove(day);
                                  }
                                });
                              },
                            );
                          }),
                        ),
                      ],
                      if (recurrence == GrowthHabitRecurrenceType.weeklyTarget) ...[
                        const SizedBox(height: 8),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Times per week',
                          ),
                          controller: TextEditingController(text: '$frequencyTarget'),
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null) frequencyTarget = parsed;
                          },
                        ),
                      ],
                      if (recurrence == GrowthHabitRecurrenceType.customFrequency ||
                          recurrence == GrowthHabitRecurrenceType.occasional) ...[
                        const SizedBox(height: 8),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Every X days',
                          ),
                          controller: TextEditingController(text: '$customIntervalDays'),
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null) customIntervalDays = parsed;
                          },
                        ),
                      ],
                      const SizedBox(height: 8),
                      TextField(
                        controller: reflectionCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Reflection prompt (optional)',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: difficulty,
                              decoration: const InputDecoration(labelText: 'Difficulty'),
                              items: const [1, 2, 3]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('$e'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => difficulty = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Light reward'),
                              controller: TextEditingController(text: '$reward'),
                              onChanged: (v) {
                                final parsed = int.tryParse(v);
                                if (parsed != null) reward = parsed;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: showInToday,
                        onChanged: (v) => setState(() => showInToday = v),
                        title: const Text('Show in Today when due'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: active,
                        onChanged: (v) => setState(() => active = v),
                        title: const Text('Active'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: paused,
                        onChanged: (v) => setState(() => paused = v),
                        title: const Text('Paused'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: archived,
                        onChanged: (v) => setState(() => archived = v),
                        title: const Text('Archived'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: reminder,
                        onChanged: (v) => setState(() => reminder = v),
                        title: const Text('Enable reminder'),
                      ),
                      if (reminder) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<GrowthReminderMode>(
                          initialValue: reminderMode,
                          decoration: const InputDecoration(labelText: 'Reminder type'),
                          items: const [
                            DropdownMenuItem(
                              value: GrowthReminderMode.fixedTime,
                              child: Text('Fixed time'),
                            ),
                            DropdownMenuItem(
                              value: GrowthReminderMode.prayerLinked,
                              child: Text('Prayer-linked'),
                            ),
                            DropdownMenuItem(
                              value: GrowthReminderMode.timeWindow,
                              child: Text('Time window'),
                            ),
                            DropdownMenuItem(
                              value: GrowthReminderMode.gentleSuggestion,
                              child: Text('Gentle suggestion'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => reminderMode = value);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        if (reminderMode == GrowthReminderMode.fixedTime)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.schedule_rounded),
                                  label: Text(_formatMinutes(reminderTimeMinutes)),
                                  onPressed: () async {
                                    final initial = TimeOfDay(
                                      hour: reminderTimeMinutes ~/ 60,
                                      minute: reminderTimeMinutes % 60,
                                    );
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: initial,
                                    );
                                    if (picked == null) return;
                                    setState(() {
                                      reminderTimeMinutes =
                                          (picked.hour * 60) + picked.minute;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (reminderMode == GrowthReminderMode.prayerLinked) ...[
                          DropdownButtonFormField<GrowthReminderPrayerAnchor>(
                            initialValue: reminderPrayerAnchor,
                            decoration: const InputDecoration(
                              labelText: 'Prayer anchor',
                            ),
                            items: GrowthReminderPrayerAnchor.values
                                .map(
                                  (anchor) => DropdownMenuItem(
                                    value: anchor,
                                    child: Text(_prayerAnchorLabel(anchor)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => reminderPrayerAnchor = value),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Offset minutes (before/after)',
                            ),
                            controller: TextEditingController(
                              text: '$reminderOffsetMinutes',
                            ),
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null) reminderOffsetMinutes = parsed;
                            },
                          ),
                        ],
                        if (reminderMode == GrowthReminderMode.timeWindow)
                          DropdownButtonFormField<GrowthReminderWindowType>(
                            initialValue: reminderWindowType,
                            decoration: const InputDecoration(
                              labelText: 'Reminder window',
                            ),
                            items: GrowthReminderWindowType.values
                                .map(
                                  (window) => DropdownMenuItem(
                                    value: window,
                                    child: Text(_windowLabel(window)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => reminderWindowType = value);
                              }
                            },
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          'Reminder days (optional)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: List.generate(7, (index) {
                            final day = index + 1;
                            return FilterChip(
                              label: Text(_weekday(day)),
                              selected: reminderDays.contains(day),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    reminderDays.add(day);
                                  } else {
                                    reminderDays.remove(day);
                                  }
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: reminderMessageCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Reminder message override (optional)',
                          ),
                        ),
                        const SizedBox(height: 4),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: quietDelivery,
                          onChanged: (value) => setState(() => quietDelivery = value),
                          title: const Text('Quiet delivery for this habit'),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: allowSnooze,
                          onChanged: (value) => setState(() => allowSnooze = value),
                          title: const Text('Allow snooze (future-ready)'),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: remindersPaused,
                          onChanged: (value) => setState(() => remindersPaused = value),
                          title: const Text('Pause reminders for now'),
                        ),
                      ],
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: allowPartial,
                        onChanged: (v) => setState(() => allowPartial = v),
                        title: const Text('Allow partial completion'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: entrustable,
                        onChanged: (v) => setState(() => entrustable = v),
                        title: const Text('Entrustable habit'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: privateTracking,
                        onChanged: (v) => setState(() => privateTracking = v),
                        title: const Text('Private tracking by default'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                final title = titleCtrl.text.trim();
                                if (title.isEmpty) return;
                                final subtitle = subtitleCtrl.text.trim().isEmpty
                                    ? 'Custom habit'
                                    : subtitleCtrl.text.trim();
                                final description = descriptionCtrl.text.trim().isEmpty
                                    ? 'Added by you for your personal growth path.'
                                    : descriptionCtrl.text.trim();
                                final weekdaysList = weekdays.isEmpty
                                    ? const [1, 2, 3, 4, 5, 6, 7]
                                    : (weekdays.toList()..sort());
                                final controller =
                                    ref.read(growthControllerProvider.notifier);

                                if (existingHabit == null) {
                                  controller.addCustomHabit(
                                    title: title,
                                    subtitle: subtitle,
                                    description: description,
                                    category: category,
                                    recurrenceType: recurrence,
                                    frequencyTarget: frequencyTarget,
                                    weekdays: weekdaysList,
                                    difficulty: difficulty,
                                    lightReward: reward,
                                    reminderEnabled: reminder,
                                    reflectionPrompt: reflectionCtrl.text.trim(),
                                    entrustable: entrustable,
                                    privateTracking: privateTracking,
                                    allowPartial: allowPartial,
                                    customIntervalDays: customIntervalDays,
                                    showInToday: showInToday,
                                    active: active,
                                    linkedPathId: linkedPathId,
                                    reminderConfig: reminder ? 'local' : null,
                                    reminderMode: reminderMode,
                                    reminderTimeMinutes: reminderTimeMinutes,
                                    reminderPrayerAnchor: reminderPrayerAnchor,
                                    reminderOffsetMinutes: reminderOffsetMinutes,
                                    reminderWindowType: reminderWindowType,
                                    reminderDays: reminderDays.toList()..sort(),
                                    reminderMessageOverride:
                                        reminderMessageCtrl.text.trim().isEmpty
                                        ? null
                                        : reminderMessageCtrl.text.trim(),
                                    quietDelivery: quietDelivery,
                                    allowSnooze: allowSnooze,
                                    remindersPaused: remindersPaused,
                                  );
                                } else {
                                  controller.updateCustomHabit(
                                    habitId: existingHabit.id,
                                    title: title,
                                    subtitle: subtitle,
                                    description: description,
                                    category: category,
                                    recurrenceType: recurrence,
                                    frequencyTarget: frequencyTarget,
                                    weekdays: weekdaysList,
                                    difficulty: difficulty,
                                    lightReward: reward,
                                    reminderEnabled: reminder,
                                    reflectionPrompt: reflectionCtrl.text.trim(),
                                    entrustable: entrustable,
                                    privateTracking: privateTracking,
                                    allowPartial: allowPartial,
                                    customIntervalDays: customIntervalDays,
                                    showInToday: showInToday,
                                    active: active,
                                    paused: paused,
                                    archived: archived,
                                    linkedPathId: linkedPathId,
                                    reminderConfig: reminder ? 'local' : null,
                                    reminderMode: reminderMode,
                                    reminderTimeMinutes: reminderTimeMinutes,
                                    reminderPrayerAnchor: reminderPrayerAnchor,
                                    reminderOffsetMinutes: reminderOffsetMinutes,
                                    reminderWindowType: reminderWindowType,
                                    reminderDays: reminderDays.toList()..sort(),
                                    reminderMessageOverride:
                                        reminderMessageCtrl.text.trim().isEmpty
                                        ? null
                                        : reminderMessageCtrl.text.trim(),
                                    quietDelivery: quietDelivery,
                                    allowSnooze: allowSnooze,
                                    remindersPaused: remindersPaused,
                                  );
                                }

                                Navigator.of(context).pop();
                              },
                              child: Text(existingHabit == null ? 'Create Habit' : 'Save Changes'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _weekday(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Sun';
    }
  }

  String _formatMinutes(int totalMinutes) {
    final minutes = totalMinutes.clamp(0, 1439);
    final hour24 = minutes ~/ 60;
    final minute = (minutes % 60).toString().padLeft(2, '0');
    final suffix = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:$minute $suffix';
  }

  String _prayerAnchorLabel(GrowthReminderPrayerAnchor anchor) {
    switch (anchor) {
      case GrowthReminderPrayerAnchor.fajr:
        return 'Fajr';
      case GrowthReminderPrayerAnchor.dhuhr:
        return 'Dhuhr';
      case GrowthReminderPrayerAnchor.asr:
        return 'Asr';
      case GrowthReminderPrayerAnchor.maghrib:
        return 'Maghrib';
      case GrowthReminderPrayerAnchor.isha:
        return 'Isha';
    }
  }

  String _windowLabel(GrowthReminderWindowType window) {
    switch (window) {
      case GrowthReminderWindowType.earlyMorning:
        return 'Early morning';
      case GrowthReminderWindowType.morning:
        return 'Morning';
      case GrowthReminderWindowType.midday:
        return 'Midday';
      case GrowthReminderWindowType.afternoon:
        return 'Afternoon';
      case GrowthReminderWindowType.evening:
        return 'Evening';
      case GrowthReminderWindowType.night:
        return 'Night';
      case GrowthReminderWindowType.beforeSleep:
        return 'Before sleep';
      case GrowthReminderWindowType.fridayMorning:
        return 'Friday morning';
      case GrowthReminderWindowType.fridayAfternoon:
        return 'Friday afternoon';
      case GrowthReminderWindowType.weekend:
        return 'Weekend';
    }
  }
}

class _HabitSection extends StatelessWidget {
  const _HabitSection({
    required this.title,
    required this.subtitle,
    required this.habits,
    required this.isCustomSection,
    required this.onOpen,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final List<GrowthHabit> habits;
  final bool isCustomSection;
  final ValueChanged<String> onOpen;
  final void Function(GrowthHabit habit, String action) onAction;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF6A5A4A))),
            const SizedBox(height: 8),
            const Text('No habits here yet.'),
          ],
        ),
      );
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF6A5A4A))),
          const SizedBox(height: 8),
          ...habits.map(
            (habit) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(habit.title),
              subtitle: Text(
                '${growthCategoryLabel(habit.category)} · ${growthRecurrenceLabel(habit)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Icon(
                habit.archived
                    ? Icons.archive_outlined
                    : habit.paused
                    ? Icons.pause_circle_outline
                    : habit.active
                    ? Icons.check_circle_outline
                    : Icons.pause_circle_outline,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) => onAction(habit, value),
                itemBuilder: (context) {
                  final common = <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      value: 'toggle_active',
                      child: Text(habit.active ? 'Set inactive' : 'Set active'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_paused',
                      child: Text(habit.paused ? 'Resume' : 'Pause'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_show_today',
                      child: Text(
                        habit.showInToday
                            ? 'Hide from Today'
                            : 'Show in Today when due',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle_mute',
                      child: Text(habit.muted ? 'Unmute' : 'Mute'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_hidden',
                      child: Text(habit.hidden ? 'Unhide' : 'Hide'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_entrust',
                      child: Text(
                        habit.entrustToAllah
                            ? 'Show deed in visible stats'
                            : 'Entrust deeds to Allah',
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'pin_focus',
                      child: Text('Pin as focus habit'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_reminder',
                      child: Text(
                        habit.reminderEnabled
                            ? 'Disable reminders'
                            : 'Enable reminders',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle_reminders_paused',
                      child: Text(
                        habit.remindersPaused
                            ? 'Resume reminders'
                            : 'Pause reminders',
                      ),
                    ),
                  ];

                  if (!isCustomSection || !habit.isCustom) {
                    return common;
                  }

                  return [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    ...common,
                    PopupMenuItem(
                      value: 'toggle_archive',
                      child: Text(habit.archived ? 'Unarchive' : 'Archive'),
                    ),
                    PopupMenuItem(
                      value: 'toggle_reminder',
                      child: Text(
                        habit.reminderEnabled
                            ? 'Disable reminders'
                            : 'Enable reminders',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle_private',
                      child: Text(
                        habit.privateTracking
                            ? 'Disable private tracking'
                            : 'Enable private tracking',
                      ),
                    ),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ];
                },
              ),
              onTap: () => onOpen(habit.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitEditorInitial {
  const _HabitEditorInitial({
    this.title = '',
    this.subtitle = '',
    this.description = '',
    this.category = GrowthHabitCategory.dailyWorship,
    this.recurrenceType = GrowthHabitRecurrenceType.daily,
    this.weekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.frequencyTarget = 7,
    this.customIntervalDays = 2,
    this.difficulty = 1,
    this.lightReward = 10,
    this.reflectionPrompt = '',
    this.reminderEnabled = false,
    this.entrustable = true,
    this.privateTracking = false,
    this.allowPartial = false,
    this.showInToday = true,
    this.active = true,
    this.paused = false,
    this.archived = false,
    this.linkedPathId,
    this.reminderMode = GrowthReminderMode.gentleSuggestion,
    this.reminderTimeMinutes = 1200,
    this.reminderPrayerAnchor,
    this.reminderOffsetMinutes = 0,
    this.reminderWindowType,
    this.reminderDays = const [],
    this.reminderMessageOverride = '',
    this.quietDelivery = false,
    this.allowSnooze = true,
    this.remindersPaused = false,
  });

  factory _HabitEditorInitial.fromHabit(GrowthHabit habit) {
    return _HabitEditorInitial(
      title: habit.title,
      subtitle: habit.subtitle,
      description: habit.description,
      category: habit.category,
      recurrenceType: habit.recurrenceType,
      weekdays: habit.weekdays,
      frequencyTarget: habit.frequencyTarget,
      customIntervalDays: habit.customIntervalDays,
      difficulty: habit.difficulty,
      lightReward: habit.lightReward,
      reflectionPrompt: habit.reflectionPrompt ?? '',
      reminderEnabled: habit.reminderEnabled,
      entrustable: habit.entrustable,
      privateTracking: habit.privateTracking,
      allowPartial: habit.allowPartial,
      showInToday: habit.showInToday,
      active: habit.active,
      paused: habit.paused,
      archived: habit.archived,
      linkedPathId: habit.linkedPathId,
      reminderMode: habit.reminderMode,
      reminderTimeMinutes: habit.reminderTimeMinutes,
      reminderPrayerAnchor: habit.reminderPrayerAnchor,
      reminderOffsetMinutes: habit.reminderOffsetMinutes,
      reminderWindowType: habit.reminderWindowType,
      reminderDays: habit.reminderDays,
      reminderMessageOverride: habit.reminderMessageOverride ?? '',
      quietDelivery: habit.quietDelivery,
      allowSnooze: habit.allowSnooze,
      remindersPaused: habit.remindersPaused,
    );
  }

  factory _HabitEditorInitial.fromTemplate(_HabitTemplate template) {
    return _HabitEditorInitial(
      title: template.title,
      subtitle: template.subtitle,
      description: template.description,
      category: template.category,
      recurrenceType: template.recurrenceType,
      frequencyTarget: template.frequencyTarget,
      customIntervalDays: template.customIntervalDays,
      weekdays: template.weekdays,
      reflectionPrompt: template.reflectionPrompt,
      lightReward: template.lightReward,
      reminderEnabled: template.reminderEnabled,
      reminderMode: template.reminderMode,
      reminderPrayerAnchor: template.reminderPrayerAnchor,
      reminderWindowType: template.reminderWindowType,
      reminderTimeMinutes: template.reminderTimeMinutes,
      showInToday: true,
      active: true,
    );
  }

  final String title;
  final String subtitle;
  final String description;
  final GrowthHabitCategory category;
  final GrowthHabitRecurrenceType recurrenceType;
  final List<int> weekdays;
  final int frequencyTarget;
  final int customIntervalDays;
  final int difficulty;
  final int lightReward;
  final String reflectionPrompt;
  final bool reminderEnabled;
  final bool entrustable;
  final bool privateTracking;
  final bool allowPartial;
  final bool showInToday;
  final bool active;
  final bool paused;
  final bool archived;
  final String? linkedPathId;
  final GrowthReminderMode reminderMode;
  final int reminderTimeMinutes;
  final GrowthReminderPrayerAnchor? reminderPrayerAnchor;
  final int reminderOffsetMinutes;
  final GrowthReminderWindowType? reminderWindowType;
  final List<int> reminderDays;
  final String reminderMessageOverride;
  final bool quietDelivery;
  final bool allowSnooze;
  final bool remindersPaused;
}

class _HabitTemplate {
  const _HabitTemplate({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.recurrenceType,
    required this.frequencyTarget,
    required this.customIntervalDays,
    required this.weekdays,
    required this.reflectionPrompt,
    this.lightReward = 10,
    this.reminderEnabled = false,
    this.reminderMode = GrowthReminderMode.gentleSuggestion,
    this.reminderPrayerAnchor,
    this.reminderWindowType,
    this.reminderTimeMinutes = 1200,
  });

  final String title;
  final String subtitle;
  final String description;
  final GrowthHabitCategory category;
  final GrowthHabitRecurrenceType recurrenceType;
  final int frequencyTarget;
  final int customIntervalDays;
  final List<int> weekdays;
  final String reflectionPrompt;
  final int lightReward;
  final bool reminderEnabled;
  final GrowthReminderMode reminderMode;
  final GrowthReminderPrayerAnchor? reminderPrayerAnchor;
  final GrowthReminderWindowType? reminderWindowType;
  final int reminderTimeMinutes;
}

const List<_HabitTemplate> _quickTemplates = [
  _HabitTemplate(
    title: 'Read Qur’an',
    subtitle: 'A daily portion, even small.',
    description: 'Read a small portion with reflection.',
    category: GrowthHabitCategory.knowledge,
    recurrenceType: GrowthHabitRecurrenceType.daily,
    frequencyTarget: 7,
    customIntervalDays: 1,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'What verse stayed with you today?',
    lightReward: 16,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.evening,
  ),
  _HabitTemplate(
    title: 'Salawat',
    subtitle: 'Daily salawat with presence.',
    description: 'Send salawat in calm moments through the day.',
    category: GrowthHabitCategory.sunnahPractices,
    recurrenceType: GrowthHabitRecurrenceType.daily,
    frequencyTarget: 7,
    customIntervalDays: 1,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'How did salawat affect your heart today?',
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.prayerLinked,
    reminderPrayerAnchor: GrowthReminderPrayerAnchor.maghrib,
  ),
  _HabitTemplate(
    title: 'Istighfar',
    subtitle: 'Return often with repentance.',
    description: 'Keep a gentle daily istighfar rhythm.',
    category: GrowthHabitCategory.reflectionGratitude,
    recurrenceType: GrowthHabitRecurrenceType.daily,
    frequencyTarget: 7,
    customIntervalDays: 1,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'Where did you return to Allah today?',
  ),
  _HabitTemplate(
    title: 'Gratitude journal',
    subtitle: 'Name one blessing each day.',
    description: 'Write one line of gratitude daily.',
    category: GrowthHabitCategory.reflectionGratitude,
    recurrenceType: GrowthHabitRecurrenceType.daily,
    frequencyTarget: 7,
    customIntervalDays: 1,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'What blessing did you notice today?',
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.beforeSleep,
  ),
  _HabitTemplate(
    title: 'Call parents weekly',
    subtitle: 'Strengthen family ties.',
    description: 'Call or visit parents with care and consistency.',
    category: GrowthHabitCategory.charityService,
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    frequencyTarget: 1,
    customIntervalDays: 7,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'How did family connection affect your day?',
    lightReward: 14,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.fridayAfternoon,
  ),
  _HabitTemplate(
    title: 'Daily walk',
    subtitle: 'Move with intention.',
    description: 'Take a short walk to support focus and discipline.',
    category: GrowthHabitCategory.healthDiscipline,
    recurrenceType: GrowthHabitRecurrenceType.daily,
    frequencyTarget: 7,
    customIntervalDays: 1,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'Did movement help you stay grounded today?',
    lightReward: 8,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.afternoon,
  ),
  _HabitTemplate(
    title: 'Charity reminder',
    subtitle: 'Give regularly, even small.',
    description: 'Set one weekly giving rhythm.',
    category: GrowthHabitCategory.charityService,
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    frequencyTarget: 1,
    customIntervalDays: 7,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    reflectionPrompt: 'How did giving soften your heart this week?',
    lightReward: 18,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.fixedTime,
    reminderTimeMinutes: 1170,
  ),
];
