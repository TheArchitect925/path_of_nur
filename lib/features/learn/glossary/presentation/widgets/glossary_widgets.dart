import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/application/special_mode_provider.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../data/glossary_catalog.dart';
import '../../domain/glossary_models.dart';

Future<void> showGlossaryEntrySheet(
  BuildContext context, {
  GlossaryEntryId? entryId,
  String? term,
}) {
  final entry = GlossaryCatalog.findLocalizedEntry(
    context,
    id: entryId,
    term: term,
  );
  if (entry == null) {
    return Future<void>.value();
  }
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _GlossaryEntrySheet(entry: entry, showOpenGlossaryAction: true),
  );
}

class GlossaryInlineTerm extends StatelessWidget {
  const GlossaryInlineTerm({
    super.key,
    this.entryId,
    this.term,
    this.label,
    this.style,
    this.triggerMode = GlossaryTriggerMode.both,
  });

  final GlossaryEntryId? entryId;
  final String? term;
  final String? label;
  final TextStyle? style;
  final GlossaryTriggerMode triggerMode;

  @override
  Widget build(BuildContext context) {
    final resolved = GlossaryCatalog.findLocalizedEntry(
      context,
      id: entryId,
      term: term,
    );
    final textTheme = Theme.of(context).textTheme;
    final glossaryLabel = label ?? resolved?.term ?? term ?? '';
    final interactive = resolved != null;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: interactive && _allowsTap(triggerMode)
          ? () => showGlossaryEntrySheet(context, entryId: resolved.id)
          : null,
      onLongPress: interactive && _allowsLongPress(triggerMode)
          ? () => showGlossaryEntrySheet(context, entryId: resolved.id)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Text(
          glossaryLabel,
          style:
              style ??
              textTheme.bodyMedium?.copyWith(
                fontWeight: interactive ? FontWeight.w600 : FontWeight.w500,
                decoration: interactive ? TextDecoration.underline : null,
              ),
        ),
      ),
    );
  }
}

class GlossaryTermChip extends StatelessWidget {
  const GlossaryTermChip({super.key, required this.entryId});

  final GlossaryEntryId entryId;

  @override
  Widget build(BuildContext context) {
    final entry = GlossaryCatalog.findLocalizedEntry(context, id: entryId);
    if (entry == null) {
      return const SizedBox.shrink();
    }
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => showGlossaryEntrySheet(context, entryId: entryId),
      onLongPress: () => showGlossaryEntrySheet(context, entryId: entryId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: style.decoration(radius: 999),
        child: Text(entry.term),
      ),
    );
  }
}

class _GlossaryEntrySheet extends StatelessWidget {
  const _GlossaryEntrySheet({
    required this.entry,
    this.showOpenGlossaryAction = false,
  });

  final LocalizedGlossaryEntry entry;
  final bool showOpenGlossaryAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isKidsMode = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(specialModeProvider).isKids;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.term,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (entry.transliteration != null &&
                entry.transliteration!.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(entry.transliteration!, style: textTheme.titleSmall),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    localizedGlossaryCategoryLabel(context, entry.category),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PremiumCard(
              surfaceVariant: AppSurfaceVariant.panel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.learnGlossaryQuickMeaningTitle,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.shortDefinitionFor(isKidsMode),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PremiumCard(
              surfaceVariant: AppSurfaceVariant.panel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.learnGlossaryExpandedMeaningTitle,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.expandedExplanationFor(isKidsMode),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (showOpenGlossaryAction) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pushNamed('learnGlossary');
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l10n.learnGlossaryOpenAction),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

bool _allowsTap(GlossaryTriggerMode mode) {
  return mode == GlossaryTriggerMode.tap || mode == GlossaryTriggerMode.both;
}

bool _allowsLongPress(GlossaryTriggerMode mode) {
  return mode == GlossaryTriggerMode.longPress ||
      mode == GlossaryTriggerMode.both;
}
