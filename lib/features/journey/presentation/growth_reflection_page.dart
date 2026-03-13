import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final date = ref.watch(growthSelectedDateProvider);
    final todayReflections = ref.watch(growthReflectionsForSelectedDateProvider);
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
              const Text('Recent Changes', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (recentUnlocks.isEmpty)
                const Text('Reflection nourishes quiet growth over time.')
              else ...[
                Text(
                  'A recent unlock appeared through steady reflection and small steps.',
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
                ),
                const SizedBox(height: 6),
                Text(
                  recentUnlocks.first.reward.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  recentUnlocks.first.reward.subtitle,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
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
              const Text('Seasonal prompts', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (seasonalPrompts.isEmpty)
                const Text('No seasonal prompt today. Continue your path with sincerity.')
              else ...[
                Text(
                  '${seasonal.hijriDate.day} ${seasonal.hijriDate.monthName}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
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
              const Text('Reflection', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'This space is for honest review, gratitude, tawbah, and entrusting your efforts to Allah.',
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: privateMode,
                onChanged: (v) =>
                    ref.read(growthControllerProvider.notifier).setPrivateMode(v),
                title: const Text('Private mode (quiet growth visuals)'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Prompt suggestions', style: TextStyle(fontWeight: FontWeight.w700)),
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
                encouragement.gentleReminders[
                    (date.day + date.month) % encouragement.gentleReminders.length],
                style: const TextStyle(color: Color(0xFF6A5A4A), fontSize: 12.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prompt library',
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
              const Text('Daily reflection prompt'),
              const SizedBox(height: 8),
              TextField(
                controller: _promptCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What shaped your heart today?',
                ),
              ),
              const SizedBox(height: 8),
              const Text('Mood / state'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: GrowthMoodState.values
                    .map(
                      (mood) => ChoiceChip(
                        selected: _mood == mood,
                        label: Text(growthMoodLabel(mood)),
                        onSelected: (_) => setState(() => _mood = mood),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _linkedHabitId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Related habit (optional)',
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('None'),
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
              const Text('Gratitude'),
              const SizedBox(height: 6),
              TextField(
                controller: _gratitudeCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name one blessing from today',
                ),
              ),
              const SizedBox(height: 8),
              const Text('Tawbah / review of the day'),
              const SizedBox(height: 6),
              TextField(
                controller: _tawbahCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What do you seek forgiveness for?',
                ),
              ),
              const SizedBox(height: 8),
              const Text('Short notes'),
              const SizedBox(height: 6),
              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Keep this simple and sincere',
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _entrustToAllah,
                onChanged: (v) => setState(() => _entrustToAllah = v),
                title: const Text('Entrust deeds to Allah'),
                subtitle: const Text(
                  'When enabled, this entry is tracked quietly without celebratory emphasis.',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref.read(growthControllerProvider.notifier).addReflection(
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
                      child: const Text('Save Reflection'),
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
              const Text('End-of-day summary', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                '${endOfDay.completionPercent}% tended · ${endOfDay.completed} completed · ${endOfDay.partial} on your path · ${endOfDay.missed} to revisit gently',
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
              const Text('Today entries', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (todayReflections.isEmpty)
                const Text('Begin again today with a short reflection.')
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
                            Text('Mood: ${growthMoodLabel(entry.mood!)}'),
                          if (entry.prompt.isNotEmpty) Text('Prompt: ${entry.prompt}'),
                          if (entry.gratitude.isNotEmpty)
                            Text('Gratitude: ${entry.gratitude}'),
                          if (entry.tawbah.isNotEmpty) Text('Tawbah: ${entry.tawbah}'),
                          if (entry.note.isNotEmpty) Text('Note: ${entry.note}'),
                          if (entry.entrustToAllah)
                            const Text(
                              'Entrusted quietly to Allah',
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
              const Text('Gratitude history', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (gratitudeHistory.isEmpty)
                const Text('No gratitude history yet.')
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
              const Text('Recent reflections', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...history.take(5).map(
                (entry) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.prompt.isEmpty ? 'Reflection entry' : entry.prompt),
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
