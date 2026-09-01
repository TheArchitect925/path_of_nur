part of '../quran_reader_page.dart';

/// The tap-an-ayah study sheet from phase 7b: every action the old per-ayah
/// icon row carried (play, bookmark, memorize, mistake flag, note), plus the
/// meaning at three depths, a reflection bridge, word-by-word glosses, and
/// the related-knowledge links — so the scroll itself can stay text-only.
Future<void> showQuranAyahDetailsSheet({
  required BuildContext context,
  required QuranAyah ayah,
  required bool audioEnabled,
  required Future<void> Function() onPlayAyah,
  required Future<void> Function() onAddNote,
  required Future<void> Function(QuranWordGloss word) onPlayWord,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return _QuranAyahDetailsSheetBody(
            ayah: ayah,
            audioEnabled: audioEnabled,
            scrollController: scrollController,
            onPlayAyah: onPlayAyah,
            onAddNote: onAddNote,
            onPlayWord: onPlayWord,
          );
        },
      );
    },
  );
}

class _QuranAyahDetailsSheetBody extends ConsumerWidget {
  const _QuranAyahDetailsSheetBody({
    required this.ayah,
    required this.audioEnabled,
    required this.scrollController,
    required this.onPlayAyah,
    required this.onAddNote,
    required this.onPlayWord,
  });

  final QuranAyah ayah;
  final bool audioEnabled;
  final ScrollController scrollController;
  final Future<void> Function() onPlayAyah;
  final Future<void> Function() onAddNote;
  final Future<void> Function(QuranWordGloss word) onPlayWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final surah = ref.watch(
      quranSurahMapProvider.select((map) => map[ayah.surahNumber]),
    );
    final isBookmarked = ref.watch(
      quranBookmarksProvider.select(
        (bookmarks) => bookmarks.any(
          (bookmark) =>
              bookmark.surahNumber == ayah.surahNumber &&
              bookmark.ayahNumber == ayah.ayahNumber,
        ),
      ),
    );
    final notesCount = ref.watch(
      quranNotesProvider.select(
        (notes) => notes
            .where(
              (note) =>
                  note.surahNumber == ayah.surahNumber &&
                  note.ayahNumber == ayah.ayahNumber,
            )
            .length,
      ),
    );
    final isMarkedForMemorization =
        ref.watch(
          quranMemorizationEntryForAyahProvider((
            ayah.surahNumber,
            ayah.ayahNumber,
          )),
        ) !=
        null;
    final settings = ref.watch(quranReaderSettingsProvider);
    // The sheet always offers meaning, even for a reader whose page is
    // clean: `off` falls back to simple here instead of hiding the section.
    final sheetDetail = switch (settings.explanationDetailLevel) {
      QuranExplanationDetailLevel.off ||
      QuranExplanationDetailLevel.kids => QuranExplanationDetailLevel.simple,
      final level => level,
    };
    final explanation = ref.watch(
      quranResolvedAyahExplanationsForSurahProvider((
        ayah.surahNumber,
        sheetDetail,
        languageCode,
      )),
    )[ayah.ayahNumber];
    final actionRecommendation = ref.watch(
      quranAyahActionRecommendationsForSurahProvider((
        ayah.surahNumber,
        languageCode,
        false,
      )),
    )[ayah.ayahNumber];
    final contextualLinks = ref.watch(
      quranContextualKnowledgeLinksForVerseProvider((
        ayah.surahNumber,
        ayah.ayahNumber,
      )),
    );
    final themeTopics = ref.watch(
      quranThemesForVerseProvider((ayah.surahNumber, ayah.ayahNumber)),
    );
    final wordGlossary =
        ref.watch(quranWordGlossaryProvider).valueOrNull ??
        const <String, QuranWordGloss>{};
    final wordGlosses = buildWordGlosses(ayah.arabic, glossary: wordGlossary);
    final groupedLinks = _groupKnowledgeLinksByCategory(contextualLinks);
    final anchorLabel = l10n.quranReferenceViewerReferenceLabel(
      '${ayah.surahNumber}:${ayah.ayahNumber}',
    );
    final subtleColor = QuranPresentationStyle.quranSupportTextColor(context);

    return SafeArea(
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
            surah == null
                ? anchorLabel
                : '${surah.transliteratedName} • $anchorLabel',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            ayah.arabic,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlignForContent(ayah.arabic),
            textDirection: textDirectionForContent(ayah.arabic),
            style: AppTextStyles.quranVerse(size: 20),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (audioEnabled)
                Expanded(
                  child: FilledButton.tonalIcon(
                    key: ValueKey(
                      'quran-reader-play-ayah-${ayah.surahNumber}:${ayah.ayahNumber}',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      unawaited(onPlayAyah());
                    },
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: Text(l10n.quranPlayAyahTooltip),
                  ),
                ),
              if (audioEnabled) const SizedBox(width: 8),
              IconButton(
                key: const ValueKey('quran-ayah-sheet-bookmark'),
                tooltip: isBookmarked
                    ? l10n.quranRemoveBookmark
                    : l10n.quranBookmark,
                onPressed: () => ref
                    .read(quranBookmarksProvider.notifier)
                    .toggleBookmark(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    ),
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_outline_rounded,
                ),
              ),
              IconButton(
                key: const ValueKey('quran-ayah-sheet-memorize'),
                tooltip: isMarkedForMemorization
                    ? l10n.quranMemorizationRemoveAction
                    : l10n.quranMemorizationMarkAction,
                onPressed: () => ref
                    .read(quranMemorizationProgressProvider.notifier)
                    .toggleVerse(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    ),
                icon: Icon(
                  isMarkedForMemorization
                      ? Icons.school_rounded
                      : Icons.school_outlined,
                ),
              ),
              IconButton(
                key: const ValueKey('quran-ayah-sheet-mistake'),
                tooltip: l10n.quranHifzCheckpointTooltip,
                onPressed: () => ref
                    .read(quranHifzSettingsProvider.notifier)
                    .markMistakeCheckpoint(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    ),
                icon: const Icon(Icons.flag_outlined),
              ),
              IconButton(
                key: const ValueKey('quran-ayah-sheet-note'),
                tooltip: l10n.quranAddNote,
                onPressed: () => unawaited(onAddNote()),
                icon: Badge(
                  isLabelVisible: notesCount > 0,
                  label: Text(notesCount.toString()),
                  child: const Icon(Icons.sticky_note_2_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.quranAyahDetailsMeaningTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          SegmentedButton<QuranExplanationDetailLevel>(
            segments: [
              ButtonSegment(
                value: QuranExplanationDetailLevel.simple,
                label: Text(l10n.quranAyahExplanationDetailSimple),
              ),
              ButtonSegment(
                value: QuranExplanationDetailLevel.standard,
                label: Text(l10n.quranAyahExplanationDetailStandard),
              ),
              ButtonSegment(
                value: QuranExplanationDetailLevel.deep,
                label: Text(l10n.quranAyahExplanationDetailDeep),
              ),
            ],
            selected: {sheetDetail},
            showSelectedIcon: false,
            onSelectionChanged: (selection) => ref
                .read(quranReaderSettingsProvider.notifier)
                .setExplanationDetailLevel(selection.first),
          ),
          if (explanation != null) ...[
            const SizedBox(height: 10),
            QuranAyahExplanationSection(
              explanation: explanation,
              style: QuranAyahExplanationSectionStyle.reader,
              studyMode: QuranReaderStudyMode.study,
              initiallyExpanded: true,
            ),
          ],
          if (actionRecommendation != null) ...[
            const SizedBox(height: 10),
            QuranAyahActionSection(
              recommendation: actionRecommendation,
              style: QuranAyahActionSectionStyle.reader,
            ),
          ],
          const SizedBox(height: 6),
          CompactListTile(
            key: const ValueKey('quran-ayah-sheet-reflection'),
            title: l10n.lifeAddReflectionTitle,
            subtitle: l10n.lifeAddReflectionSubtitle,
            onTap: () {
              Navigator.of(context).pop();
              context.pushNamed('journalCreate');
            },
          ),
          if (wordGlosses.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.quranAyahDetailsWordByWordTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: wordGlosses
                  .map(
                    (word) => ActionChip(
                      avatar: const Icon(Icons.volume_up_rounded, size: 15),
                      label: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word.arabic,
                            textDirection: textDirectionForContent(word.arabic),
                            style: AppTextStyles.arabicLearning(
                              size: 15,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${word.transliteration} • ${word.gloss}',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: subtleColor,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => unawaited(onPlayWord(word)),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          if (themeTopics.isNotEmpty || groupedLinks.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.quranLearnMoreSectionTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            if (themeTopics.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: themeTopics
                    .map(
                      (topic) => ActionChip(
                        label: Text(localizedQuranTopicTitle(l10n, topic.id)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.pushNamed(
                            'quranTopicDetail',
                            pathParameters: {'topicId': topic.id},
                          );
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
            ...groupedLinks.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quranRelatedKnowledgeCategoryLabel(l10n, entry.key),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: subtleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value
                          .map(
                            (link) => ActionChip(
                              label: Text(link.title),
                              onPressed: () =>
                                  showQuranRelatedKnowledgeDetailSheet(
                                    context,
                                    link: link,
                                    anchorLabel: anchorLabel,
                                  ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
