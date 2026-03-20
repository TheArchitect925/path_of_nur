import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/journal_provider.dart';

class JournalCreatePage extends ConsumerStatefulWidget {
  const JournalCreatePage({super.key});

  @override
  ConsumerState<JournalCreatePage> createState() => _JournalCreatePageState();
}

class _JournalCreatePageState extends ConsumerState<JournalCreatePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _photoController = TextEditingController();
  final _topicController = TextEditingController();
  final _quranRefController = TextEditingController();
  final _hadithRefController = TextEditingController();
  final _tagsController = TextEditingController();
  JournalEntryType _type = JournalEntryType.reflection;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _photoController.dispose();
    _topicController.dispose();
    _quranRefController.dispose();
    _hadithRefController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    return AppPageScaffold(
      headerIcon: Icons.edit_note,
      title: l10n.journalCreateTitle,
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.journalCreate,
        kidsMode: isKidsMode,
      ),
      children: [
        PremiumCard(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.journalTitleField),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bodyController,
                minLines: 4,
                maxLines: 8,
                decoration: InputDecoration(labelText: l10n.journalBodyField),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<JournalEntryType>(
                initialValue: _type,
                style: Theme.of(context).textTheme.bodyLarge,
                items: JournalEntryType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_typeLabel(l10n, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
                decoration: InputDecoration(labelText: l10n.journalTypeField),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _topicController,
                decoration: InputDecoration(labelText: l10n.journalLinkedTopicLabel),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _quranRefController,
                decoration: InputDecoration(labelText: l10n.journalLinkedQuranLabel),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _hadithRefController,
                decoration: InputDecoration(labelText: l10n.journalLinkedHadithLabel),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: l10n.journalTagsLabel,
                  helperText: l10n.journalTagsHelper,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _photoController,
                decoration: InputDecoration(
                  labelText: l10n.journalPhotoReferenceField,
                  helperText: l10n.journalPhotoReferenceHelper,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final tags = _tagsController.text
                        .split(',')
                        .map((item) => item.trim())
                        .where((item) => item.isNotEmpty)
                        .toList();
                    ref.read(journalProvider.notifier).addEntry(
                          title: _titleController.text,
                          body: _bodyController.text,
                          type: _type,
                          linkedTopic: _topicController.text.trim().isEmpty
                              ? null
                              : _topicController.text.trim(),
                          linkedQuranRef: _quranRefController.text.trim().isEmpty
                              ? null
                              : _quranRefController.text.trim(),
                          linkedHadithRef: _hadithRefController.text.trim().isEmpty
                              ? null
                              : _hadithRefController.text.trim(),
                          photoPath: _photoController.text.trim().isEmpty
                              ? null
                              : _photoController.text.trim(),
                          tags: tags,
                        );
                    Navigator.of(context).maybePop();
                  },
                  child: Text(l10n.quranSave),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _typeLabel(AppLocalizations l10n, JournalEntryType type) {
    switch (type) {
      case JournalEntryType.reflection:
        return l10n.journalTypeReflection;
      case JournalEntryType.gratitude:
        return l10n.journalTypeGratitude;
      case JournalEntryType.observation:
        return l10n.journalTypeObservation;
      case JournalEntryType.learning:
        return l10n.journalTypeLearning;
      case JournalEntryType.memory:
        return l10n.journalTypeMemory;
    }
  }
}
