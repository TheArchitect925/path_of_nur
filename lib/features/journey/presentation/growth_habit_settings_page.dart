import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'widgets/growth_ui_helpers.dart';

class GrowthHabitSettingsPage extends ConsumerWidget {
  const GrowthHabitSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final habits = ref.watch(growthAllHabitsProvider);
    final categories = ref.watch(growthCustomHabitCategoriesProvider);
    final categoriesById = ref.watch(growthCustomHabitCategoriesByIdProvider);

    return AppPageScaffold(
      title: l10n.growthHabitSettingsTitle,
      subtitle: l10n.growthHabitSettingsSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitSettingsCustomCategoriesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (categories.isEmpty)
                Text(
                  l10n.growthHabitSettingsNoCustomCategories,
                  style: const TextStyle(color: Color(0xFF6A5A4A)),
                )
              else
                ...categories.map(
                  (category) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(category.title),
                    subtitle: Text(category.description),
                    trailing: IconButton(
                      onPressed: () => ref
                          .read(growthControllerProvider.notifier)
                          .deleteCustomHabitCategory(category.id),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => _showAddCategoryDialog(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.growthHabitSettingsAddCategory),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitSettingsCustomHabitsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => _showAddHabitDialog(context, ref),
                icon: const Icon(Icons.playlist_add_rounded),
                label: Text(l10n.growthHabitSettingsAddHabit),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.growthHabitSettingsManageHabitsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...habits.map(
                (habit) => Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: habit.active && !habit.hidden && !habit.archived,
                      title: Text(habit.title),
                      subtitle: Text(
                        habit.customCategoryId?.isNotEmpty == true
                            ? categoriesById[habit.customCategoryId!]?.title ??
                                  habit.subtitle
                            : growthCategoryLocalizedLabel(
                                habit.category,
                                l10n,
                              ),
                      ),
                      onChanged: (enabled) {
                        ref
                            .read(growthControllerProvider.notifier)
                            .updateHabitOverride(
                              habit.id,
                              active: enabled,
                              hidden: !enabled,
                              archived: false,
                            );
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: habit.showInToday && !habit.hidden,
                      title: Text(l10n.growthHabitSettingsTrackWhenEnabled),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        ref
                            .read(growthControllerProvider.notifier)
                            .updateHabitOverride(
                              habit.id,
                              showInToday: value ?? false,
                              hidden: value == true ? false : true,
                              active: value ?? false,
                            );
                      },
                    ),
                    const Divider(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _showAddCategoryDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.growthHabitSettingsAddCategory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.growthHabitSettingsCategoryNameLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: l10n.growthHabitSettingsCategoryDescriptionLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.growthHabitSettingsCancelAction),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              ref
                  .read(growthControllerProvider.notifier)
                  .addCustomHabitCategory(
                    title: title,
                    description: descriptionController.text.trim(),
                  );
              Navigator.of(dialogContext).pop();
            },
            child: Text(l10n.growthHabitSettingsSaveAction),
          ),
        ],
      );
    },
  );
}

Future<void> _showAddHabitDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();
  GrowthHabitCategory category = GrowthHabitCategory.dailyWorship;
  String? customCategoryId;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final customCategories = ref.watch(
            growthCustomHabitCategoriesProvider,
          );
          return AlertDialog(
            title: Text(l10n.growthHabitSettingsAddHabit),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: l10n.growthHabitSettingsHabitNameLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: subtitleController,
                    decoration: InputDecoration(
                      labelText: l10n.growthHabitSettingsHabitSubtitleLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.growthHabitSettingsHabitDescriptionLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GrowthHabitCategory>(
                    initialValue: category,
                    decoration: InputDecoration(
                      labelText: l10n.growthHabitSettingsBaseCategoryLabel,
                    ),
                    items: GrowthHabitCategory.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              growthCategoryLocalizedLabel(item, l10n),
                            ),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => category = value);
                    },
                  ),
                  if (customCategories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: customCategoryId,
                      decoration: InputDecoration(
                        labelText:
                            l10n.growthHabitSettingsOptionalCustomCategory,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.growthHabitSettingsNoCustomCategory),
                        ),
                        ...customCategories.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.id,
                            child: Text(item.title),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => customCategoryId = value);
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.growthHabitSettingsCancelAction),
              ),
              FilledButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;
                  ref
                      .read(growthControllerProvider.notifier)
                      .addCustomHabit(
                        title: title,
                        subtitle: subtitleController.text.trim().isEmpty
                            ? l10n.growthHabitSettingsCustomHabitFallbackSubtitle
                            : subtitleController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? title
                            : descriptionController.text.trim(),
                        category: category,
                        customCategoryId: customCategoryId,
                        recurrenceType: GrowthHabitRecurrenceType.daily,
                        frequencyTarget: 7,
                        weekdays: const [],
                        difficulty: 1,
                        lightReward: 8,
                        reminderEnabled: false,
                        reflectionPrompt: '',
                        entrustable: false,
                        privateTracking: false,
                        allowPartial: false,
                        customIntervalDays: 1,
                        showInToday: true,
                        active: true,
                      );
                  Navigator.of(dialogContext).pop();
                },
                child: Text(l10n.growthHabitSettingsSaveAction),
              ),
            ],
          );
        },
      );
    },
  );
}
