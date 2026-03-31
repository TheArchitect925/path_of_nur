import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class QuranReflectionComposerResult {
  const QuranReflectionComposerResult({
    required this.note,
    required this.isFavorite,
  });

  final String note;
  final bool isFavorite;
}

Future<String?> showQuranReflectionNoteDialog(
  BuildContext context, {
  required String title,
  String? initialNote,
}) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: initialNote ?? '');

  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: 5,
        maxLength: 280,
        decoration: InputDecoration(
          labelText: l10n.quranReflectionsNoteFieldLabel,
          hintText: l10n.quranReflectionsNoteFieldHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.quranCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: Text(l10n.quranReflectionsSaveNoteAction),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

Future<QuranReflectionComposerResult?> showQuranReflectionComposerDialog(
  BuildContext context, {
  required String title,
  required String helperText,
  required String saveLabel,
  String? sourceContextLabel,
  String? initialNote,
  bool initialFavorite = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: initialNote ?? '');
  var isFavorite = initialFavorite;

  final result = await showDialog<QuranReflectionComposerResult>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sourceContextLabel?.trim().isNotEmpty ?? false) ...[
              Text(
                sourceContextLabel!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              helperText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 6,
              minLines: 4,
              maxLength: 600,
              decoration: InputDecoration(
                labelText: l10n.quranReflectionsNoteFieldLabel,
                hintText: l10n.quranReflectionsNoteFieldHint,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: isFavorite,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) =>
                  setState(() => isFavorite = value ?? false),
              title: Text(
                isFavorite
                    ? l10n.quranReflectionsRemoveFavoriteAction
                    : l10n.quranReflectionsMarkFavoriteAction,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.quranCancel),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = controller.text.trim();
              if (trimmed.isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                QuranReflectionComposerResult(
                  note: trimmed,
                  isFavorite: isFavorite,
                ),
              );
            },
            child: Text(saveLabel),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}
