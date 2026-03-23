import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

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
