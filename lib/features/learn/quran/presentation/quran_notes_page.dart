import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../application/quran_providers.dart';
import '../domain/quran_note.dart';

class QuranNotesPage extends ConsumerWidget {
  const QuranNotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notes = ref.watch(quranFilteredNotesProvider);
    final filter = ref.watch(quranNotesFilterProvider);
    final folders = ref.watch(quranNotesFoldersProvider);
    final tags = ref.watch(quranNotesTagsProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final notifier = ref.read(quranNotesProvider.notifier);
    final filterNotifier = ref.read(quranNotesFilterProvider.notifier);

    final grouped = <String, List<QuranNote>>{};
    for (final note in notes) {
      final parsed = DateTime.tryParse(note.createdAtIso);
      final key = parsed == null
          ? l10n.quranUnknownDateLabel
          : '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => <QuranNote>[]).add(note);
    }
    final groupKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return AppPageScaffold(
      headerIcon: Icons.sticky_note_2_outlined,
      title: l10n.quranNotesTitle,
      subtitle: l10n.quranNotesSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranNotesFoldersTagsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: filter.folder,
                      decoration: InputDecoration(
                        labelText: l10n.quranNotesFolderLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: folders
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        filterNotifier.setFolder(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: filter.tag,
                      decoration: InputDecoration(
                        labelText: l10n.quranNotesTagLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: tags
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        filterNotifier.setTag(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (notes.isEmpty)
          PremiumCard(child: Text(l10n.quranNotesEmpty))
        else
          ...groupKeys.map((key) {
            final dayNotes = grouped[key] ?? const <QuranNote>[];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  ),
                  ...dayNotes.map((note) {
                    final surah = surahMap[note.surahNumber];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${surah?.transliteratedName ?? l10n.quranUnknownSurah} ${note.surahNumber}:${note.ayahNumber}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => notifier.removeById(note.id),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                  tooltip: l10n.quranDeleteNote,
                                ),
                              ],
                            ),
                            if (note.isHighlight)
                              Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Chip(
                                  label: Text(l10n.quranHighlightLabel),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            if (note.highlightLabel != null &&
                                note.highlightLabel!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  note.highlightLabel!,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF6A5A4A),
                                  ),
                                ),
                              ),
                            Text(
                              note.text,
                              style: const TextStyle(height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(note.folder),
                                ),
                                ...note.tags.map(
                                  (tag) => Chip(
                                    visualDensity: VisualDensity.compact,
                                    label: Text('#$tag'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => context.pushNamed(
                                'quranReader',
                                pathParameters: {
                                  'surahNumber': note.surahNumber.toString(),
                                },
                                queryParameters: {
                                  'ayah': note.ayahNumber.toString(),
                                },
                              ),
                              icon: const Icon(Icons.open_in_new, size: 16),
                              label: Text(l10n.quranOpenInReader),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
      ],
    );
  }
}
