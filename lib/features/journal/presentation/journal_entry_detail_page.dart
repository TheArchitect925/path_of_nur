import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_reference_link.dart';
import '../../../shared/widgets/quran_verse_content.dart';
import '../application/journal_provider.dart';

class JournalEntryDetailPage extends ConsumerStatefulWidget {
  const JournalEntryDetailPage({super.key, required this.entryId});

  final String entryId;

  @override
  ConsumerState<JournalEntryDetailPage> createState() =>
      _JournalEntryDetailPageState();
}

class _JournalEntryDetailPageState
    extends ConsumerState<JournalEntryDetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _topicController;
  late final TextEditingController _quranRefController;
  late final TextEditingController _hadithRefController;
  late final TextEditingController _tagsController;
  late final TextEditingController _photoController;
  JournalEntryType _selectedType = JournalEntryType.reflection;
  String? _lastEntryId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _topicController = TextEditingController();
    _quranRefController = TextEditingController();
    _hadithRefController = TextEditingController();
    _tagsController = TextEditingController();
    _photoController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _topicController.dispose();
    _quranRefController.dispose();
    _hadithRefController.dispose();
    _tagsController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(journalEntryByIdProvider(widget.entryId));
    if (entry == null) {
      return AppPageScaffold(
        headerIcon: Icons.auto_stories_outlined,
        title: l10n.journalDetailMissingTitle,
        subtitle: l10n.journalDetailMissingSubtitle,
        children: [PremiumCard(child: Text(l10n.journalDetailMissingBody))],
      );
    }

    _syncControllers(entry);
    final pageTitle = entry.title.trim().isEmpty
        ? l10n.journalUntitled
        : entry.title;

    return AppPageScaffold(
      headerIcon: Icons.menu_book_outlined,
      title: pageTitle,
      subtitle: l10n.journalDetailPageSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tinyChip(_typeLabel(l10n, entry.type)),
                  if (entry.favorite) _tinyChip(l10n.journalFilterFavorites),
                  _tinyChip(_formattedCreatedAt(context, entry.createdAtIso)),
                ],
              ),
              if ((entry.linkedTopic ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                _InfoRow(
                  label: l10n.journalLinkedTopicLabel,
                  value: entry.linkedTopic!,
                ),
              ],
              if ((entry.linkedHadithRef ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  label: l10n.journalLinkedHadithLabel,
                  value: entry.linkedHadithRef!,
                ),
              ],
              if ((entry.linkedQuranRef ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                _QuranReferenceSection(reference: entry.linkedQuranRef!),
              ],
              if ((entry.photoPath ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  label: l10n.journalPhotoReferenceField,
                  value: entry.photoPath!,
                ),
              ],
              if (entry.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.journalTagsLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: entry.tags
                      .map((tag) => _tinyChip('#$tag'))
                      .toList(growable: false),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_isEditing)
          _buildEditCard(context, l10n, entry)
        else
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.journalDetailEntryBodyTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(entry.body),
              ],
            ),
          ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(
                  _isEditing ? Icons.visibility_outlined : Icons.edit_outlined,
                ),
                label: Text(
                  _isEditing
                      ? l10n.journalDetailReviewAction
                      : l10n.journalDetailEditAction,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('learnNotesLanding'),
                icon: const Icon(Icons.sticky_note_2_outlined),
                label: Text(l10n.learnNotesSectionTitle),
              ),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('quranReflections'),
                icon: const Icon(Icons.bookmark_added_outlined),
                label: Text(l10n.quranReflectionsTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditCard(
    BuildContext context,
    AppLocalizations l10n,
    JournalEntry entry,
  ) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            initialValue: _selectedType,
            items: JournalEntryType.values
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(_typeLabel(l10n, item)),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
            decoration: InputDecoration(labelText: l10n.journalTypeField),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _topicController,
            decoration: InputDecoration(
              labelText: l10n.journalLinkedTopicLabel,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _quranRefController,
            decoration: InputDecoration(
              labelText: l10n.journalLinkedQuranLabel,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _hadithRefController,
            decoration: InputDecoration(
              labelText: l10n.journalLinkedHadithLabel,
            ),
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
            child: FilledButton.icon(
              onPressed: () {
                ref
                    .read(journalProvider.notifier)
                    .updateEntry(
                      entryId: entry.id,
                      title: _titleController.text,
                      body: _bodyController.text,
                      type: _selectedType,
                      linkedTopic: _topicController.text,
                      linkedQuranRef: _quranRefController.text,
                      linkedHadithRef: _hadithRefController.text,
                      photoPath: _photoController.text,
                      tags: _tagsController.text
                          .split(',')
                          .map((item) => item.trim())
                          .where((item) => item.isNotEmpty)
                          .toList(growable: false),
                    );
                setState(() => _isEditing = false);
                if (Scaffold.maybeOf(context) != null) {
                  final messenger = ScaffoldMessenger.maybeOf(context);
                  messenger?.showSnackBar(
                    SnackBar(content: Text(l10n.journalDetailSavedMessage)),
                  );
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.journalDetailSaveAction),
            ),
          ),
        ],
      ),
    );
  }

  void _syncControllers(JournalEntry entry) {
    if (_lastEntryId == entry.id) {
      return;
    }
    _lastEntryId = entry.id;
    _selectedType = entry.type;
    _titleController.text = entry.title;
    _bodyController.text = entry.body;
    _topicController.text = entry.linkedTopic ?? '';
    _quranRefController.text = entry.linkedQuranRef ?? '';
    _hadithRefController.text = entry.linkedHadithRef ?? '';
    _tagsController.text = entry.tags.join(', ');
    _photoController.text = entry.photoPath ?? '';
  }

  String _formattedCreatedAt(BuildContext context, String createdAtIso) {
    final parsed = DateTime.tryParse(createdAtIso);
    if (parsed == null) {
      return createdAtIso;
    }
    final localizations = MaterialLocalizations.of(context);
    final dateLabel = localizations.formatFullDate(parsed);
    final timeLabel = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(parsed),
      alwaysUse24HourFormat: false,
    );
    return '$dateLabel • $timeLabel';
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

  Widget _tinyChip(String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(value),
      ],
    );
  }
}

class _QuranReferenceSection extends StatelessWidget {
  const _QuranReferenceSection({required this.reference});

  final String reference;

  @override
  Widget build(BuildContext context) {
    final parsed = tryParseQuranQuoteRef(reference);
    if (parsed == null) {
      return _InfoRow(
        label: AppLocalizations.of(context).journalLinkedQuranLabel,
        value: reference,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).journalLinkedQuranLabel,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        QuranReferenceLinkTile.forRef(
          referenceLabel: parsed.locationLabel,
          ref: parsed,
          margin: EdgeInsets.zero,
        ),
      ],
    );
  }
}
