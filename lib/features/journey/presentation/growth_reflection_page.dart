import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthReflectionPage extends ConsumerStatefulWidget {
  const GrowthReflectionPage({super.key});

  @override
  ConsumerState<GrowthReflectionPage> createState() =>
      _GrowthReflectionPageState();
}

class _GrowthReflectionPageState extends ConsumerState<GrowthReflectionPage> {
  final _promptCtrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();
  final _tawbahCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _entrustToAllah = false;
  GrowthMoodState? _mood;
  String? _linkedHabitId;

  @override
  void dispose() {
    _promptCtrl.dispose();
    _gratitudeCtrl.dispose();
    _tawbahCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = ref.watch(growthSelectedDateProvider);
    final todayReflections = ref.watch(
      growthReflectionsForSelectedDateProvider,
    );
    final privateMode = ref.watch(growthControllerProvider).privateMode;
    final prompts = ref.watch(growthReflectionPromptSuggestionsProvider);
    final seasonalPrompts = ref.watch(growthSeasonalReflectionPromptsProvider);
    final seasonal = ref.watch(growthSeasonalContextProvider);
    final recentUnlocks = ref.watch(growthRecentUnlocksProvider);
    final promptGroups = ref.watch(growthReflectionPromptGroupsProvider);
    final history = ref.watch(growthReflectionHistoryProvider);
    final gratitudeHistory = ref.watch(growthGratitudeHistoryProvider);
    final habits = ref.watch(growthDueHabitsForSelectedDateProvider);
    final endOfDay = ref.watch(growthEndOfDaySummaryProvider);
    final encouragement = ref.watch(growthEncouragementCopyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthReflectionRecentChangesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (recentUnlocks.isEmpty)
                Text(l10n.growthReflectionRecentChangesEmpty)
              else ...[
                Text(
                  l10n.growthReflectionRecentUnlockNote,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6A5A4A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recentUnlocks.first.reward.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  recentUnlocks.first.reward.subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6A5A4A),
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
                l10n.growthReflectionSeasonalPromptsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (seasonalPrompts.isEmpty)
                Text(l10n.growthReflectionNoSeasonalPrompt)
              else ...[
                Text(
                  '${seasonal.hijriDate.day} ${seasonal.hijriDate.monthName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A5A4A),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: seasonalPrompts
                      .take(3)
                      .map(
                        (prompt) => ActionChip(
                          label: Text(prompt),
                          onPressed: () => _promptCtrl.text = prompt,
                        ),
                      )
                      .toList(),
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
                l10n.growthTabReflection,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.growthReflectionIntro),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: privateMode,
                onChanged: (v) => ref
                    .read(growthControllerProvider.notifier)
                    .setPrivateMode(v),
                title: Text(l10n.growthReflectionPrivateModeTitle),
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
                l10n.growthReflectionPromptSuggestionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prompts
                    .map(
                      (prompt) => ActionChip(
                        label: Text(prompt, overflow: TextOverflow.ellipsis),
                        onPressed: () => _promptCtrl.text = prompt,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Text(
                encouragement.gentleReminders[(date.day + date.month) %
                    encouragement.gentleReminders.length],
                style: const TextStyle(
                  color: Color(0xFF6A5A4A),
                  fontSize: 12.5,
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
                l10n.growthReflectionPromptLibraryTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...promptGroups.map(
                (group) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: group.prompts
                            .take(3)
                            .map(
                              (prompt) => ActionChip(
                                label: Text(prompt),
                                onPressed: () => _promptCtrl.text = prompt,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
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
              Text(l10n.growthReflectionDailyPromptTitle),
              const SizedBox(height: 8),
              TextField(
                controller: _promptCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: l10n.growthReflectionDailyPromptHint,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.growthReflectionMoodTitle),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: GrowthMoodState.values
                    .map(
                      (mood) => ChoiceChip(
                        selected: _mood == mood,
                        label: Text(growthMoodLocalizedLabel(mood, l10n)),
                        onSelected: (_) => setState(() => _mood = mood),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _linkedHabitId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: l10n.growthReflectionRelatedHabitLabel,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.growthReflectionNoneOption),
                  ),
                  ...habits.map(
                    (habit) => DropdownMenuItem(
                      value: habit.id,
                      child: Text(habit.title),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _linkedHabitId = value),
              ),
              const SizedBox(height: 8),
              Text(l10n.growthReflectionGratitudeTitle),
              const SizedBox(height: 6),
              TextField(
                controller: _gratitudeCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: l10n.growthReflectionGratitudeHint,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.growthReflectionTawbahTitle),
              const SizedBox(height: 6),
              TextField(
                controller: _tawbahCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: l10n.growthReflectionTawbahHint,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.growthReflectionShortNotesTitle),
              const SizedBox(height: 6),
              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: l10n.growthReflectionShortNotesHint,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _entrustToAllah,
                onChanged: (v) => setState(() => _entrustToAllah = v),
                title: Text(l10n.growthReflectionEntrustToAllahTitle),
                subtitle: Text(l10n.growthReflectionEntrustToAllahSubtitle),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(growthControllerProvider.notifier)
                            .addReflection(
                              date: date,
                              prompt: _promptCtrl.text.trim(),
                              gratitude: _gratitudeCtrl.text.trim(),
                              tawbah: _tawbahCtrl.text.trim(),
                              note: _noteCtrl.text.trim(),
                              entrustToAllah: _entrustToAllah,
                              mood: _mood,
                              linkedHabitId: _linkedHabitId,
                            );
                        _promptCtrl.clear();
                        _gratitudeCtrl.clear();
                        _tawbahCtrl.clear();
                        _noteCtrl.clear();
                        setState(() {
                          _entrustToAllah = false;
                          _mood = null;
                          _linkedHabitId = null;
                        });
                      },
                      child: Text(l10n.growthReflectionSaveAction),
                    ),
                  ),
                ],
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
                l10n.growthTodayEndOfDayTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.growthTodayEndOfDaySummary(
                  '${endOfDay.completionPercent}',
                  '${endOfDay.completed}',
                  '${endOfDay.partial}',
                  '${endOfDay.missed}',
                ),
              ),
              const SizedBox(height: 4),
              Text(endOfDay.tone),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthReflectionTodayEntriesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (todayReflections.isEmpty)
                Text(l10n.growthReflectionBeginAgain)
              else
                ...todayReflections.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF6EFE4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.mood != null)
                            Text(
                              l10n.growthReflectionMoodValue(
                                growthMoodLocalizedLabel(entry.mood!, l10n),
                              ),
                            ),
                          if (entry.prompt.isNotEmpty)
                            Text(
                              l10n.growthReflectionPromptValue(entry.prompt),
                            ),
                          if (entry.gratitude.isNotEmpty)
                            Text(
                              l10n.growthReflectionGratitudeValue(
                                entry.gratitude,
                              ),
                            ),
                          if (entry.tawbah.isNotEmpty)
                            Text(
                              l10n.growthReflectionTawbahValue(entry.tawbah),
                            ),
                          if (entry.note.isNotEmpty)
                            Text(l10n.growthReflectionNoteValue(entry.note)),
                          if (entry.entrustToAllah)
                            Text(
                              l10n.growthReflectionEntrustedQuietly,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
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
                l10n.growthReflectionGratitudeHistoryTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (gratitudeHistory.isEmpty)
                Text(l10n.growthReflectionNoGratitudeHistory)
              else
                ...gratitudeHistory.take(6).map((text) => Text('• $text')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthReflectionRecentReflectionsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...history
                  .take(5)
                  .map(
                    (entry) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        entry.prompt.isEmpty
                            ? l10n.growthReflectionEntryFallbackTitle
                            : entry.prompt,
                      ),
                      subtitle: Text(
                        entry.gratitude.isEmpty ? entry.note : entry.gratitude,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
