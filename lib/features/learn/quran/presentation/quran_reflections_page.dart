import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_providers.dart';
import '../application/quran_learning_progression_provider.dart';
import '../application/quran_learning_share_service.dart';
import '../application/quran_reflections_provider.dart';
import '../domain/quran_reflection_entry.dart';
import 'widgets/quran_reflection_note_dialog.dart';

class QuranReflectionsPage extends ConsumerWidget {
  const QuranReflectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(quranReflectionsProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final notifier = ref.read(quranReflectionsProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.bookmark_added_outlined,
      title: l10n.quranReflectionsTitle,
      subtitle: l10n.quranReflectionsSubtitle,
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('learnNotesLanding'),
                icon: const Icon(Icons.sticky_note_2_outlined),
                label: Text(l10n.learnNotesSectionTitle),
              ),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed('journalTimeline'),
                icon: const Icon(Icons.auto_stories_outlined),
                label: Text(l10n.journalTitle),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranReflectionsEmptyTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranReflectionsEmptySubtitle),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('quranAyahInsightsBrowse'),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: Text(l10n.quranReflectionsBrowseAction),
                ),
              ],
            ),
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () => openQuranReferenceLocation(
                            context,
                            ref: item.ref,
                          ),
                          icon: const Icon(Icons.menu_book_rounded, size: 16),
                          label: Text(
                            '${surahMap[item.ref.surah]?.transliteratedName ?? l10n.quranUnknownSurah} ${item.ref.locationLabel.split(' ').last}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(_sourceLabel(l10n, item.sourceType)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.summary.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.summary),
                    ],
                    if (item.note?.trim().isNotEmpty ?? false) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.quranReflectionsPrivateNoteTitle,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item.note!),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () => context.pushNamed(
                            'quranReader',
                            pathParameters: {
                              'surahNumber': item.ref.surah.toString(),
                            },
                            queryParameters: {'ayah': item.ref.ayah.toString()},
                          ),
                          icon: const Icon(Icons.menu_book_rounded),
                          label: Text(l10n.quranReflectionsOpenAyahAction),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final includeNote =
                                await _showReflectionShareSheet(
                                  context,
                                  hasNote:
                                      item.note?.trim().isNotEmpty ?? false,
                                ) ??
                                false;
                            final text =
                                QuranLearningShareService.buildSavedReflectionShareText(
                                  entry: item,
                                  attribution:
                                      l10n.quranLearningShareAttribution,
                                  noteLabel: l10n
                                      .quranLearningShareReflectionNoteLabel,
                                  includeNoteExcerpt: includeNote,
                                );
                            QuranLearningShareService.shareText(text);
                          },
                          icon: const Icon(Icons.ios_share_rounded),
                          label: Text(l10n.quranLearningShareAction),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final note = await showQuranReflectionNoteDialog(
                              context,
                              title: item.note?.trim().isNotEmpty ?? false
                                  ? l10n.quranReflectionsEditNoteAction
                                  : l10n.quranReflectionsAddNoteAction,
                              initialNote: item.note,
                            );
                            if (note == null) return;
                            notifier.upsertNote(
                              ref: item.ref,
                              sourceType: item.sourceType,
                              title: item.title,
                              summary: item.summary,
                              sourceEnrichmentId: item.sourceEnrichmentId,
                              note: note,
                            );
                            if (note.trim().isNotEmpty) {
                              ref
                                  .read(
                                    quranLearningProgressStateProvider.notifier,
                                  )
                                  .rewardFirstReflectionNote(
                                    ref: item.ref,
                                    sourceEnrichmentId: item.sourceEnrichmentId,
                                    sourceSurface: 'saved_reflections',
                                  );
                            }
                          },
                          icon: const Icon(Icons.edit_note_rounded),
                          label: Text(
                            item.note?.trim().isNotEmpty ?? false
                                ? l10n.quranReflectionsEditNoteAction
                                : l10n.quranReflectionsAddNoteAction,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => notifier.removeById(item.id),
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: Text(l10n.quranReflectionsRemoveAction),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<bool?> _showReflectionShareSheet(
    BuildContext context, {
    required bool hasNote,
  }) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: Text(l10n.quranLearningShareReflectionAyahOnly),
              subtitle: Text(l10n.quranLearningShareReflectionAyahOnlySubtitle),
              onTap: () => Navigator.of(context).pop(false),
            ),
            if (hasNote)
              ListTile(
                leading: const Icon(Icons.short_text_rounded),
                title: Text(l10n.quranLearningShareReflectionExcerpt),
                subtitle: Text(
                  l10n.quranLearningShareReflectionExcerptSubtitle,
                ),
                onTap: () => Navigator.of(context).pop(true),
              ),
          ],
        ),
      ),
    );
  }

  String _sourceLabel(
    AppLocalizations l10n,
    QuranReflectionSourceType sourceType,
  ) {
    return switch (sourceType) {
      QuranReflectionSourceType.dailyAyah =>
        l10n.quranReflectionsSourceDailyAyah,
      QuranReflectionSourceType.ayahInsight =>
        l10n.quranReflectionsSourceAyahInsight,
      QuranReflectionSourceType.relatedAyah =>
        l10n.quranReflectionsSourceRelatedAyah,
      QuranReflectionSourceType.pathItem => l10n.quranReflectionsSourcePathItem,
    };
  }
}
