import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/editorial_content_versions_provider.dart';
import '../domain/editorial_content_version_models.dart';

class EditorialContentEditorPage extends ConsumerStatefulWidget {
  const EditorialContentEditorPage({
    super.key,
    required this.contentType,
    required this.contentId,
  });

  final EditorialContentType contentType;
  final String contentId;

  @override
  ConsumerState<EditorialContentEditorPage> createState() =>
      _EditorialContentEditorPageState();
}

class _EditorialContentEditorPageState
    extends ConsumerState<EditorialContentEditorPage> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};
  bool _initialized = false;
  bool _isSaving = false;
  String? _selectedQuranReviewStatus;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentSnapshot = ref.watch(
      editorialCurrentContentSnapshotProvider((
        widget.contentType,
        widget.contentId,
      )),
    );
    final versions = ref.watch(
      editorialContentVersionsForItemProvider((
        widget.contentType,
        widget.contentId,
      )),
    );
    if (currentSnapshot == null) {
      return AppPageScaffold(
        title: l10n.editorialDashboardContentEditorTitle,
        children: [
          PremiumCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l10n.editorialDashboardEmptySubtitle),
            ),
          ),
        ],
      );
    }
    _initializeControllersIfNeeded(currentSnapshot);
    final fieldDefinitions = _fieldDefinitionsFor(widget.contentType, l10n);

    return AppPageScaffold(
      title: l10n.editorialDashboardContentEditorTitle,
      subtitle: _contentTypeLabel(l10n, widget.contentType),
      children: [
        PremiumCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editorialDashboardContentIdLabel(widget.contentId),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ...fieldDefinitions.map((field) {
                  final controller = _controllers[field.key]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: controller,
                      minLines: field.minLines,
                      maxLines: field.maxLines,
                      decoration: InputDecoration(
                        labelText: field.label,
                        helperText: field.helper,
                      ),
                    ),
                  );
                }),
                if (widget.contentType == EditorialContentType.quranExplanation)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedQuranReviewStatus,
                    decoration: InputDecoration(
                      labelText:
                          l10n.editorialDashboardContentFieldReviewStatus,
                    ),
                    items: _quranReviewStatusNames
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      setState(() => _selectedQuranReviewStatus = value);
                    },
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () => _previewAndSave(context, currentSnapshot),
                      icon: const Icon(Icons.save_rounded),
                      label: Text(l10n.editorialDashboardSaveVersionAction),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : () => _resetToCurrent(currentSnapshot),
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(l10n.editorialDashboardResetFormAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.editorialDashboardVersionHistoryTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(l10n.editorialDashboardVersionHistorySubtitle),
                const SizedBox(height: 12),
                if (versions.isEmpty)
                  Text(l10n.editorialDashboardNoVersionsYet)
                else
                  ...versions.map(
                    (version) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.editorialDashboardVersionLabel(
                                  version.versionNumber,
                                ),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(version.changeSummary),
                              const SizedBox(height: 4),
                              Text(
                                version.updatedAtIso,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _showComparisonDialog(
                                      context,
                                      version.contentSnapshot,
                                      currentSnapshot,
                                    ),
                                    icon: const Icon(
                                      Icons.compare_arrows_rounded,
                                    ),
                                    label: Text(
                                      l10n.editorialDashboardCompareVersionAction,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: _isSaving
                                        ? null
                                        : () => _confirmRollback(
                                            context,
                                            version,
                                          ),
                                    icon: const Icon(Icons.history_rounded),
                                    label: Text(
                                      l10n.editorialDashboardRollbackAction,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _initializeControllersIfNeeded(Map<String, dynamic> snapshot) {
    if (_initialized) return;
    final definitions = _fieldDefinitionsFor(
      widget.contentType,
      AppLocalizations.of(context),
    );
    for (final field in definitions) {
      final value = snapshot[field.key];
      final text = field.isList
          ? _stringList(value).join('\n')
          : value?.toString() ?? '';
      _controllers[field.key] = TextEditingController(text: text);
    }
    if (widget.contentType == EditorialContentType.quranExplanation) {
      _selectedQuranReviewStatus = snapshot['reviewStatus']?.toString();
    }
    _initialized = true;
  }

  void _resetToCurrent(Map<String, dynamic> snapshot) {
    for (final entry in _controllers.entries) {
      final definition = _fieldDefinitionsFor(
        widget.contentType,
        AppLocalizations.of(context),
      ).where((field) => field.key == entry.key).first;
      final value = snapshot[entry.key];
      entry.value.text = definition.isList
          ? _stringList(value).join('\n')
          : value?.toString() ?? '';
    }
    if (widget.contentType == EditorialContentType.quranExplanation) {
      setState(() {
        _selectedQuranReviewStatus = snapshot['reviewStatus']?.toString();
      });
    }
  }

  Future<void> _previewAndSave(
    BuildContext context,
    Map<String, dynamic> currentSnapshot,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nextSnapshot = _buildSnapshot();
    final errors = _validateSnapshot(nextSnapshot, l10n);
    if (errors.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errors.join('\n'))));
      return;
    }
    final changes = _buildChanges(currentSnapshot, nextSnapshot, l10n);
    if (changes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.editorialDashboardNoChangesDetected)),
      );
      return;
    }
    final summaryController = TextEditingController();
    final confirmed = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editorialDashboardPreviewSaveTitle),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...changes.map(
                    (change) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            change.label,
                            style: Theme.of(dialogContext).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.editorialDashboardBeforeLabel}: ${change.before}',
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${l10n.editorialDashboardAfterLabel}: ${change.after}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: summaryController,
                    decoration: InputDecoration(
                      labelText: l10n.editorialDashboardChangeSummaryFieldLabel,
                      helperText:
                          l10n.editorialDashboardChangeSummaryFieldHelper,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.editorialDashboardCancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(summaryController.text.trim()),
              child: Text(l10n.editorialDashboardSaveVersionAction),
            ),
          ],
        );
      },
    );
    summaryController.dispose();
    if (confirmed == null || confirmed.trim().isEmpty) {
      return;
    }
    setState(() => _isSaving = true);
    await ref
        .read(editorialContentVersionsProvider.notifier)
        .saveEdit(
          type: widget.contentType,
          contentId: widget.contentId,
          snapshot: nextSnapshot,
          changeSummary: confirmed,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.editorialDashboardVersionSavedMessage)),
    );
  }

  Future<void> _confirmRollback(
    BuildContext context,
    ContentVersion version,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final summaryController = TextEditingController(
      text: l10n.editorialDashboardRollbackDefaultSummary(
        version.versionNumber,
      ),
    );
    final confirmed = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editorialDashboardRollbackConfirmTitle),
          content: TextField(
            controller: summaryController,
            decoration: InputDecoration(
              labelText: l10n.editorialDashboardChangeSummaryFieldLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.editorialDashboardCancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(summaryController.text.trim()),
              child: Text(l10n.editorialDashboardRollbackAction),
            ),
          ],
        );
      },
    );
    summaryController.dispose();
    if (confirmed == null || confirmed.trim().isEmpty) return;
    setState(() => _isSaving = true);
    await ref
        .read(editorialContentVersionsProvider.notifier)
        .rollbackToVersion(
          type: widget.contentType,
          contentId: widget.contentId,
          targetVersionNumber: version.versionNumber,
          changeSummary: confirmed,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.editorialDashboardRollbackSuccessMessage)),
    );
  }

  Future<void> _showComparisonDialog(
    BuildContext context,
    Map<String, dynamic> older,
    Map<String, dynamic> current,
  ) async {
    final l10n = AppLocalizations.of(context);
    final changes = _buildChanges(older, current, l10n);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editorialDashboardCompareVersionAction),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: changes.isEmpty
                    ? [Text(l10n.editorialDashboardNoChangesDetected)]
                    : changes
                          .map(
                            (change) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    change.label,
                                    style: Theme.of(
                                      dialogContext,
                                    ).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${l10n.editorialDashboardBeforeLabel}: ${change.before}',
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${l10n.editorialDashboardAfterLabel}: ${change.after}',
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(growable: false),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.editorialDashboardCloseAction),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> _buildSnapshot() {
    final snapshot = <String, dynamic>{'id': widget.contentId};
    for (final field in _fieldDefinitionsFor(
      widget.contentType,
      AppLocalizations.of(context),
    )) {
      final text = _controllers[field.key]!.text.trim();
      snapshot[field.key] = field.isList
          ? text
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList(growable: false)
          : text;
    }
    if (widget.contentType == EditorialContentType.quranExplanation) {
      snapshot['reviewStatus'] =
          _selectedQuranReviewStatus ?? _quranReviewStatusNames.first;
    }
    return snapshot;
  }

  List<String> _validateSnapshot(
    Map<String, dynamic> snapshot,
    AppLocalizations l10n,
  ) {
    final errors = <String>[];
    for (final field in _fieldDefinitionsFor(widget.contentType, l10n)) {
      if (!field.required) continue;
      if (field.isList) {
        if (_stringList(snapshot[field.key]).isEmpty) {
          errors.add(l10n.editorialDashboardFieldRequired(field.label));
        }
      } else {
        final value = snapshot[field.key]?.toString().trim() ?? '';
        if (value.isEmpty) {
          errors.add(l10n.editorialDashboardFieldRequired(field.label));
        }
      }
    }
    if (widget.contentType == EditorialContentType.quranExplanation) {
      final simple = snapshot['simpleSummary']?.toString().trim() ?? '';
      final standard = snapshot['standardExplanation']?.toString().trim() ?? '';
      final kids = snapshot['kidsExplanation']?.toString().trim() ?? '';
      if (simple.isEmpty || standard.isEmpty || kids.isEmpty) {
        errors.add(l10n.editorialDashboardQuranExplanationValidation);
      }
    }
    return errors;
  }

  List<_FieldChange> _buildChanges(
    Map<String, dynamic> before,
    Map<String, dynamic> after,
    AppLocalizations l10n,
  ) {
    final changes = <_FieldChange>[];
    for (final field in _fieldDefinitionsFor(widget.contentType, l10n)) {
      final beforeValue = field.isList
          ? _stringList(before[field.key]).join(' | ')
          : before[field.key]?.toString() ?? '';
      final afterValue = field.isList
          ? _stringList(after[field.key]).join(' | ')
          : after[field.key]?.toString() ?? '';
      if (beforeValue.trim() == afterValue.trim()) continue;
      changes.add(
        _FieldChange(
          label: field.label,
          before: beforeValue,
          after: afterValue,
        ),
      );
    }
    if (widget.contentType == EditorialContentType.quranExplanation) {
      final beforeStatus = before['reviewStatus']?.toString() ?? '';
      final afterStatus = after['reviewStatus']?.toString() ?? '';
      if (beforeStatus != afterStatus) {
        changes.add(
          _FieldChange(
            label: l10n.editorialDashboardContentFieldReviewStatus,
            before: beforeStatus,
            after: afterStatus,
          ),
        );
      }
    }
    return changes;
  }
}

class _FieldDefinition {
  const _FieldDefinition({
    required this.key,
    required this.label,
    required this.helper,
    this.required = false,
    this.isList = false,
    this.minLines = 1,
    this.maxLines = 3,
  });

  final String key;
  final String label;
  final String helper;
  final bool required;
  final bool isList;
  final int minLines;
  final int maxLines;
}

class _FieldChange {
  const _FieldChange({
    required this.label,
    required this.before,
    required this.after,
  });

  final String label;
  final String before;
  final String after;
}

const List<String> _quranReviewStatusNames = <String>[
  'draft',
  'reviewed',
  'verified',
  'kidsReviewed',
  'needsExpansion',
];

List<_FieldDefinition> _fieldDefinitionsFor(
  EditorialContentType type,
  AppLocalizations l10n,
) {
  return switch (type) {
    EditorialContentType.quranExplanation => <_FieldDefinition>[
      _FieldDefinition(
        key: 'simpleSummary',
        label: l10n.editorialDashboardContentFieldSimpleSummary,
        helper: l10n.editorialDashboardContentFieldSimpleSummaryHelper,
        required: true,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'standardExplanation',
        label: l10n.editorialDashboardContentFieldStandardExplanation,
        helper: l10n.editorialDashboardContentFieldStandardExplanationHelper,
        required: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'kidsExplanation',
        label: l10n.editorialDashboardContentFieldKidsExplanation,
        helper: l10n.editorialDashboardContentFieldKidsExplanationHelper,
        required: true,
        minLines: 2,
        maxLines: 4,
      ),
      _FieldDefinition(
        key: 'deepExplanation',
        label: l10n.editorialDashboardContentFieldDeepExplanation,
        helper: l10n.editorialDashboardContentFieldDeepExplanationHelper,
        minLines: 3,
        maxLines: 6,
      ),
      _FieldDefinition(
        key: 'keyLessons',
        label: l10n.editorialDashboardContentFieldKeyLessons,
        helper: l10n.editorialDashboardContentFieldKeyLessonsHelper,
        required: true,
        isList: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'reflectionPrompt',
        label: l10n.editorialDashboardContentFieldReflectionPrompt,
        helper: l10n.editorialDashboardContentFieldReflectionPromptHelper,
        minLines: 2,
        maxLines: 3,
      ),
    ],
    EditorialContentType.hadithEntry => <_FieldDefinition>[
      _FieldDefinition(
        key: 'title',
        label: l10n.editorialDashboardContentFieldTitle,
        helper: l10n.editorialDashboardContentFieldTitleHelper,
        required: true,
      ),
      _FieldDefinition(
        key: 'excerpt',
        label: l10n.editorialDashboardContentFieldExcerpt,
        helper: l10n.editorialDashboardContentFieldExcerptHelper,
        required: true,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'meaning',
        label: l10n.editorialDashboardContentFieldMeaning,
        helper: l10n.editorialDashboardContentFieldMeaningHelper,
        required: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'lessons',
        label: l10n.editorialDashboardContentFieldLessons,
        helper: l10n.editorialDashboardContentFieldLessonsHelper,
        required: true,
        isList: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'reflectionPrompts',
        label: l10n.editorialDashboardContentFieldReflectionPrompts,
        helper: l10n.editorialDashboardContentFieldReflectionPromptsHelper,
        required: true,
        isList: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'practiceAction',
        label: l10n.editorialDashboardContentFieldPracticeAction,
        helper: l10n.editorialDashboardContentFieldPracticeActionHelper,
        required: true,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'tags',
        label: l10n.editorialDashboardContentFieldTags,
        helper: l10n.editorialDashboardContentFieldTagsHelper,
        isList: true,
        minLines: 2,
        maxLines: 4,
      ),
    ],
    EditorialContentType.bedtimeStory => <_FieldDefinition>[
      _FieldDefinition(
        key: 'title',
        label: l10n.editorialDashboardContentFieldTitle,
        helper: l10n.editorialDashboardContentFieldTitleHelper,
        required: true,
      ),
      _FieldDefinition(
        key: 'shortTitle',
        label: l10n.editorialDashboardContentFieldShortTitle,
        helper: l10n.editorialDashboardContentFieldShortTitleHelper,
        required: true,
      ),
      _FieldDefinition(
        key: 'summary',
        label: l10n.editorialDashboardContentFieldSummary,
        helper: l10n.editorialDashboardContentFieldSummaryHelper,
        required: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'lesson',
        label: l10n.editorialDashboardContentFieldLesson,
        helper: l10n.editorialDashboardContentFieldLessonHelper,
        required: true,
        minLines: 2,
        maxLines: 4,
      ),
      _FieldDefinition(
        key: 'sourceNote',
        label: l10n.editorialDashboardContentFieldSourceNote,
        helper: l10n.editorialDashboardContentFieldSourceNoteHelper,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'tags',
        label: l10n.editorialDashboardContentFieldTags,
        helper: l10n.editorialDashboardContentFieldTagsHelper,
        isList: true,
        minLines: 2,
        maxLines: 4,
      ),
    ],
    EditorialContentType.kidsDuaLesson => <_FieldDefinition>[
      _FieldDefinition(
        key: 'title',
        label: l10n.editorialDashboardContentFieldTitle,
        helper: l10n.editorialDashboardContentFieldTitleHelper,
        required: true,
      ),
      _FieldDefinition(
        key: 'transliteration',
        label: l10n.editorialDashboardContentFieldTransliteration,
        helper: l10n.editorialDashboardContentFieldTransliterationHelper,
        required: true,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'meaning',
        label: l10n.editorialDashboardContentFieldMeaning,
        helper: l10n.editorialDashboardContentFieldMeaningHelper,
        required: true,
        minLines: 2,
        maxLines: 4,
      ),
      _FieldDefinition(
        key: 'miniLesson',
        label: l10n.editorialDashboardContentFieldMiniLesson,
        helper: l10n.editorialDashboardContentFieldMiniLessonHelper,
        required: true,
        minLines: 3,
        maxLines: 5,
      ),
      _FieldDefinition(
        key: 'whenToSay',
        label: l10n.editorialDashboardContentFieldWhenToSay,
        helper: l10n.editorialDashboardContentFieldWhenToSayHelper,
        required: true,
        minLines: 2,
        maxLines: 3,
      ),
      _FieldDefinition(
        key: 'practicePrompt',
        label: l10n.editorialDashboardContentFieldPracticePrompt,
        helper: l10n.editorialDashboardContentFieldPracticePromptHelper,
        minLines: 2,
        maxLines: 3,
      ),
    ],
  };
}

List<String> _stringList(Object? value) {
  final raw = value as List?;
  if (raw == null) return const <String>[];
  return raw
      .map((entry) => entry.toString().trim())
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
}

String _contentTypeLabel(AppLocalizations l10n, EditorialContentType type) {
  return switch (type) {
    EditorialContentType.quranExplanation =>
      l10n.editorialDashboardContentTypeQuranExplanation,
    EditorialContentType.hadithEntry =>
      l10n.editorialDashboardContentTypeHadithEntry,
    EditorialContentType.bedtimeStory =>
      l10n.editorialDashboardContentTypeBedtimeStory,
    EditorialContentType.kidsDuaLesson =>
      l10n.editorialDashboardContentTypeKidsDuaLesson,
  };
}
