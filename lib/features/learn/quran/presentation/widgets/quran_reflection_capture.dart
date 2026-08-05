import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../application/quran_reflections_provider.dart';
import '../../domain/quran_content_refs.dart';
import '../../domain/quran_reflection_entry.dart';
import 'quran_reflection_note_dialog.dart';

Future<void> captureQuranReflection(
  BuildContext context,
  WidgetRef ref, {
  required QuranReflectionSourceType sourceType,
  required String title,
  required String summary,
  required String sourceId,
  required String sourceLabel,
  QuranQuoteRef? quoteRef,
  String? sourceEnrichmentId,
  int? surahNumber,
  String? themeId,
  String? pathwayId,
  String? pathwayStopId,
  String? promptLabel,
  String? routeName,
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, String> queryParameters = const <String, String>{},
  String? helperText,
}) async {
  final l10n = AppLocalizations.of(context);
  final existing = ref
      .read(quranReflectionsProvider.notifier)
      .findEntry(
        ref: quoteRef,
        sourceEnrichmentId: sourceEnrichmentId,
        sourceType: sourceType,
        sourceId: sourceId,
      );

  final result = await showQuranReflectionComposerDialog(
    context,
    title: existing == null
        ? l10n.quranReflectionsSaveReflectionAction
        : l10n.quranReflectionsEditReflectionAction,
    helperText: helperText ?? l10n.quranReflectionsComposerHelper,
    saveLabel: existing == null
        ? l10n.quranReflectionsSaveReflectionAction
        : l10n.quranReflectionsUpdateReflectionAction,
    sourceContextLabel: sourceLabel,
    initialNote: existing?.note,
    initialFavorite: existing?.isFavorite ?? false,
  );
  if (result == null) {
    return;
  }

  ref
      .read(quranReflectionsProvider.notifier)
      .upsertNote(
        ref: quoteRef,
        sourceType: sourceType,
        title: title,
        summary: summary,
        sourceEnrichmentId: sourceEnrichmentId,
        sourceId: sourceId,
        sourceLabel: sourceLabel,
        surahNumber: surahNumber,
        themeId: themeId,
        pathwayId: pathwayId,
        pathwayStopId: pathwayStopId,
        promptLabel: promptLabel,
        routeName: routeName,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        isFavorite: result.isFavorite,
        note: result.note,
      );
}
