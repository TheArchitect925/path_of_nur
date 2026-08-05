import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/spiritual_growth_provider.dart';
import 'spiritual_growth_ui_helpers.dart';

class SpiritualGrowthReflectionPage extends ConsumerStatefulWidget {
  const SpiritualGrowthReflectionPage({super.key});

  @override
  ConsumerState<SpiritualGrowthReflectionPage> createState() =>
      _SpiritualGrowthReflectionPageState();
}

class _SpiritualGrowthReflectionPageState
    extends ConsumerState<SpiritualGrowthReflectionPage> {
  final _noteController = TextEditingController();
  String? _selectedResponseId;
  String? _selectedMoodTag;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
    final prompt = ref.watch(spiritualGrowthSuggestedReflectionPromptProvider);
    final intention = ref.watch(spiritualGrowthActiveIntentionProvider);
    final actions = ref.watch(spiritualGrowthTodayActionStatusesProvider);
    final reflectionEntry = ref.watch(
      spiritualGrowthControllerProvider.select(
        (value) => value.reflectionEntryFor(todayKey),
      ),
    );

    return AppPageScaffold(
      title: l10n.spiritualGrowthReflectionTitle,
      subtitle: l10n.spiritualGrowthReflectionPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.spiritualGrowthTodayIntentionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(spiritualGrowthTitleFromKey(l10n, intention.titleKey)),
              const SizedBox(height: 4),
              Text(
                spiritualGrowthSubtitleFromKey(l10n, intention.descriptionKey),
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
                spiritualGrowthTitleFromKey(l10n, prompt.titleKey),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(spiritualGrowthSubtitleFromKey(l10n, prompt.descriptionKey)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prompt.responseOptions
                    .map(
                      (option) => ChoiceChip(
                        selected: _selectedResponseId == option.id,
                        label: Text(
                          spiritualGrowthResponseLabel(l10n, option.labelKey),
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedResponseId = option.id),
                      ),
                    )
                    .toList(growable: false),
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
                l10n.spiritualGrowthMoodTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moodOptions(l10n).entries
                    .map(
                      (entry) => ChoiceChip(
                        selected: _selectedMoodTag == entry.key,
                        label: Text(entry.value),
                        onSelected: (_) =>
                            setState(() => _selectedMoodTag = entry.key),
                      ),
                    )
                    .toList(growable: false),
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
                l10n.spiritualGrowthCompletedActionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: actions
                    .where((item) => item.isCompleted)
                    .map(
                      (item) => Chip(
                        label: Text(
                          spiritualGrowthTitleFromKey(
                            l10n,
                            item.action.titleKey,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
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
                l10n.spiritualGrowthOptionalNoteTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.spiritualGrowthOptionalNoteHint,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: reflectionEntry?.isCompleted == true
                    ? null
                    : () {
                        if (_selectedResponseId == null) return;
                        ref
                            .read(spiritualGrowthControllerProvider.notifier)
                            .submitReflection(
                              date: DateTime.parse(todayKey),
                              promptId: prompt.id,
                              responseId: _selectedResponseId!,
                              completedActionIds: actions
                                  .where((item) => item.isCompleted)
                                  .map((item) => item.action.id)
                                  .toList(growable: false),
                              moodTag: _selectedMoodTag,
                              note: _noteController.text,
                            );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.spiritualGrowthReflectionSavedSnack,
                            ),
                          ),
                        );
                      },
                child: Text(l10n.spiritualGrowthSaveReflectionAction),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, String> _moodOptions(AppLocalizations l10n) {
    return <String, String>{
      'calm': l10n.growthMoodCalm,
      'grateful': l10n.growthMoodGrateful,
      'hopeful': l10n.growthMoodHopeful,
      'tired': l10n.growthMoodTired,
      'heavy': l10n.growthMoodHeavy,
    };
  }
}
