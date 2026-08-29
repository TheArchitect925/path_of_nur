part of '../quran_reader_page.dart';

class QuranAyahCard extends StatefulWidget {
  const QuranAyahCard({
    super.key,
    required this.ayah,
    required this.isHighlighted,
    required this.isNowPlaying,
    required this.activeWordIndex,
    required this.isBookmarked,
    required this.isMarkedForMemorization,
    required this.notesCount,
    required this.onBookmark,
    required this.onAddNote,
    required this.showArabic,
    required this.showTranslation,
    required this.showTransliteration,
    required this.showWordByWord,
    required this.showActions,
    required this.hifzRevealMode,
    required this.arabicFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    required this.harakatColor,
    required this.resolvedExplanation,
    required this.actionRecommendation,
    required this.spiritualMomentBundle,
    required this.personalizedRecommendation,
    required this.contextualLinks,
    required this.themeTopics,
    required this.readerSearchQuery,
    required this.readerSearchMatchField,
    required this.readerSearchTranslationHighlights,
    required this.readerSearchTransliterationHighlights,
    required this.readerSearchArabicHighlights,
    required this.studyMode,
    this.activeTopicId,
    this.onTap,
    this.onPlayAyah,
    required this.onToggleMemorization,
    required this.onPlayWord,
    required this.onMistakeCheckpoint,
  });

  final QuranAyah ayah;
  final bool isHighlighted;
  final bool isNowPlaying;
  final int? activeWordIndex;
  final bool isBookmarked;
  final bool isMarkedForMemorization;
  final int notesCount;
  final VoidCallback onBookmark;
  final VoidCallback onAddNote;
  final bool showArabic;
  final bool showTranslation;
  final bool showTransliteration;
  final bool showWordByWord;
  final bool showActions;
  final HifzRevealMode hifzRevealMode;
  final double arabicFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final Color? harakatColor;
  final QuranAyahResolvedExplanation? resolvedExplanation;
  final QuranAyahActionRecommendation? actionRecommendation;
  final QuranSpiritualMomentBundle? spiritualMomentBundle;
  final QuranRecommendedAyah? personalizedRecommendation;
  final List<QuranRelatedKnowledgeLink> contextualLinks;
  final List<QuranTopic> themeTopics;
  final String readerSearchQuery;
  final QuranSearchMatchField? readerSearchMatchField;
  final List<String> readerSearchTranslationHighlights;
  final List<String> readerSearchTransliterationHighlights;
  final List<String> readerSearchArabicHighlights;
  final QuranReaderStudyMode studyMode;
  final String? activeTopicId;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAyah;
  final VoidCallback onToggleMemorization;
  final Future<void> Function(QuranWordGloss word) onPlayWord;
  final VoidCallback onMistakeCheckpoint;

  @override
  State<QuranAyahCard> createState() => _QuranAyahCardState();
}

class _QuranAyahCardState extends State<QuranAyahCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final arabicWordCount = widget.ayah.arabic
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    final visibleContextualLinks = _visibleContextualLinks(
      widget.contextualLinks,
      widget.studyMode,
    );
    final groupedContextualLinks = _groupKnowledgeLinksByCategory(
      visibleContextualLinks,
    );
    final visibleThemes = _visibleThemeTopics(
      widget.themeTopics,
      widget.studyMode,
      widget.activeTopicId,
    );
    final showThemesFirst =
        widget.studyMode == QuranReaderStudyMode.theme &&
        visibleThemes.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: AnimatedContainer(
          key: ValueKey(
            'quran-ayah-card-${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
          ),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: widget.isNowPlaying
                ? Border.all(
                    color: const Color(0xFF3E9C68).withValues(alpha: 0.90),
                    width: 1.6,
                  )
                : null,
            boxShadow: widget.isNowPlaying
                ? [
                    BoxShadow(
                      color: const Color(0xFFE0C37A).withValues(alpha: 0.30),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: PremiumCard(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.palette.accent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.ayah.ayahNumber.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                    if (widget.isHighlighted || widget.isNowPlaying)
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF7C5D3A),
                        size: 20,
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranBookmark,
                        onPressed: widget.onBookmark,
                        icon: Icon(
                          widget.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_outline_rounded,
                        ),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: widget.isMarkedForMemorization
                            ? l10n.quranMemorizationRemoveAction
                            : l10n.quranMemorizationMarkAction,
                        onPressed: widget.onToggleMemorization,
                        icon: Icon(
                          widget.isMarkedForMemorization
                              ? Icons.school_rounded
                              : Icons.school_outlined,
                        ),
                      ),
                    if (widget.showActions && widget.onPlayAyah != null)
                      IconButton(
                        key: ValueKey(
                          'quran-reader-play-ayah-${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
                        ),
                        tooltip: l10n.quranPlayAyahTooltip,
                        onPressed: widget.onPlayAyah,
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranHifzCheckpointTooltip,
                        onPressed: widget.onMistakeCheckpoint,
                        icon: const Icon(Icons.flag_outlined),
                      ),
                    if (widget.showActions)
                      IconButton(
                        tooltip: l10n.quranAddNote,
                        onPressed: widget.onAddNote,
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.sticky_note_2_outlined),
                            if (widget.notesCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C5D3A),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.notesCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (widget.showArabic) ...[
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final visibleArabic = _displayArabicForHifz(
                        widget.ayah.arabic,
                        widget.hifzRevealMode,
                      );
                      final style = QuranPresentationStyle.translucentTextStyle(
                        context,
                        AppTextStyles.quranVerse(
                          size: widget.arabicFontSize + 4,
                          color: const Color(0xFF1F1B17),
                        ).copyWith(
                          height: 1.9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      );
                      final canWordHighlight =
                          widget.hifzRevealMode == HifzRevealMode.full &&
                          widget.activeWordIndex != null;
                      final searchArabicHighlights = widget
                          .readerSearchArabicHighlights
                          .toSet();
                      final searchHighlightStyle = style.copyWith(
                        backgroundColor: const Color(
                          0xFFE8D69B,
                        ).withValues(alpha: 0.55),
                        color: const Color(0xFF2F8F5B),
                      );

                      return Text.rich(
                        canWordHighlight
                            ? _buildWordSyncedArabicSpan(
                                context,
                                visibleArabic,
                                style,
                                widget.activeWordIndex!,
                                widget.harakatColor,
                                searchHighlightWords: searchArabicHighlights,
                              )
                            : buildQuranTextWithColoredHarakatHighlights(
                                visibleArabic,
                                style,
                                highlightedWords: searchArabicHighlights,
                                highlightedWordStyle: searchHighlightStyle,
                                harakatColor:
                                    widget.harakatColor ??
                                    QuranPresentationStyle.translucentHarakatColor(
                                      context,
                                    ),
                              ),
                        textAlign: textAlignForContent(visibleArabic),
                        textDirection: textDirectionForContent(visibleArabic),
                        strutStyle: StrutStyle(
                          fontFamily: style.fontFamily,
                          fontSize: style.fontSize,
                          height: style.height,
                          forceStrutHeight: true,
                        ),
                      );
                    },
                  ),
                ],
                if (widget.showWordByWord) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: buildWordGlosses(widget.ayah.arabic)
                        .map(
                          (word) => InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => widget.onPlayWord(word),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFF1E7D8),
                                border: Border.all(
                                  color: const Color(0xFFD9C4A2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.arabic,
                                    textAlign: textAlignForContent(word.arabic),
                                    textDirection: textDirectionForContent(
                                      word.arabic,
                                    ),
                                    style: AppTextStyles.arabicLearning(
                                      size: 16,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    word.transliteration,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color:
                                          QuranPresentationStyle.quranSupportTextColor(
                                            context,
                                          ),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    l10n.quranReaderWordTranslationPrefix(
                                      word.gloss,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color:
                                          QuranPresentationStyle.quranSupportTextColor(
                                            context,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (widget.showTransliteration) ...[
                  SizedBox(height: widget.showWordByWord ? 12 : 16),
                  Text.rich(
                    _buildFollowTextSpan(
                      text: (widget.ayah.transliteration ?? '').isNotEmpty
                          ? widget.ayah.transliteration!
                          : l10n.quranReaderTransliterationUnavailable,
                      searchHighlightField:
                          QuranSearchMatchField.transliteration,
                      baseStyle: QuranPresentationStyle.quranSupportTextStyle(
                        context,
                        TextStyle(
                          fontFamily: AppFonts.latinSerif,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          fontSize: widget.transliterationFontSize,
                        ),
                        italic: true,
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                      searchHighlightTerms:
                          widget.readerSearchTransliterationHighlights,
                    ),
                  ),
                ],
                if (widget.showTranslation) ...[
                  const SizedBox(height: 10),
                  Text.rich(
                    _buildFollowTextSpan(
                      text: widget.ayah.translation,
                      searchHighlightField: QuranSearchMatchField.translation,
                      baseStyle: TextStyle(
                        fontFamily: AppFonts.latinSerif,
                        height:
                            widget.studyMode == QuranReaderStudyMode.reflection
                            ? 1.65
                            : 1.55,
                        fontSize: widget.translationFontSize,
                        fontWeight:
                            widget.studyMode == QuranReaderStudyMode.reflection
                            ? FontWeight.w500
                            : null,
                        color: QuranPresentationStyle.quranSupportTextColor(
                          context,
                        ),
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                      searchHighlightTerms:
                          widget.readerSearchTranslationHighlights,
                    ),
                  ),
                ],
                if (widget.resolvedExplanation != null) ...[
                  const SizedBox(height: 10),
                  QuranAyahExplanationSection(
                    explanation: widget.resolvedExplanation!,
                    style: QuranAyahExplanationSectionStyle.reader,
                    studyMode: widget.studyMode,
                    initiallyExpanded:
                        widget.studyMode == QuranReaderStudyMode.study ||
                        widget.studyMode == QuranReaderStudyMode.reflection ||
                        widget.studyMode == QuranReaderStudyMode.theme,
                  ),
                ],
                if (widget.resolvedExplanation != null &&
                    widget.actionRecommendation != null) ...[
                  const SizedBox(height: 10),
                  QuranAyahActionSection(
                    recommendation: widget.actionRecommendation!,
                    style: QuranAyahActionSectionStyle.reader,
                  ),
                ],
                if (widget.spiritualMomentBundle != null) ...[
                  const SizedBox(height: 10),
                  QuranSpiritualMomentCard(
                    bundle: widget.spiritualMomentBundle!,
                    surface: QuranSpiritualMomentSurface.reader,
                  ),
                ],
                if (widget.resolvedExplanation != null &&
                    widget.personalizedRecommendation != null) ...[
                  const SizedBox(height: 10),
                  QuranPersonalizedRecommendationCard(
                    bundle: QuranRecommendationBundle(
                      surface: QuranPersonalizationSurface.reader,
                      preferKids: false,
                      generatedDateKey: LocalStore.todayKey(DateTime.now()),
                      primary: widget.personalizedRecommendation!,
                      suggestedJourney:
                          widget.personalizedRecommendation!.suggestedJourney,
                    ),
                    surface: QuranPersonalizationSurface.reader,
                  ),
                ],
                if (showThemesFirst) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.quranThemeMapRelatedThemesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleThemes
                        .map(
                          (topic) => ActionChip(
                            avatar: widget.activeTopicId == topic.id
                                ? const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                  )
                                : null,
                            label: Text(
                              localizedQuranTopicTitle(l10n, topic.id),
                            ),
                            backgroundColor: widget.activeTopicId == topic.id
                                ? const Color(0xFFF1E1B8)
                                : null,
                            onPressed: () => context.pushNamed(
                              'quranTopicDetail',
                              pathParameters: {'topicId': topic.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (groupedContextualLinks.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.quranLearnMoreSectionTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...groupedContextualLinks.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quranRelatedKnowledgeCategoryLabel(l10n, entry.key),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      QuranPresentationStyle.translucentColor(
                                        context,
                                        const Color(0xFF6A5A4A),
                                      ),
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
                                          anchorLabel: l10n
                                              .quranReferenceViewerReferenceLabel(
                                                '${widget.ayah.surahNumber}:${widget.ayah.ayahNumber}',
                                              ),
                                        ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (!showThemesFirst && visibleThemes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.quranThemeMapRelatedThemesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: visibleThemes
                        .map(
                          (topic) => ActionChip(
                            avatar: widget.activeTopicId == topic.id
                                ? const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 16,
                                  )
                                : null,
                            label: Text(
                              localizedQuranTopicTitle(l10n, topic.id),
                            ),
                            backgroundColor: widget.activeTopicId == topic.id
                                ? const Color(0xFFF1E1B8)
                                : null,
                            onPressed: () => context.pushNamed(
                              'quranTopicDetail',
                              pathParameters: {'topicId': topic.id},
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Map<QuranRelatedKnowledgeCategory, List<QuranRelatedKnowledgeLink>>
_groupKnowledgeLinksByCategory(List<QuranRelatedKnowledgeLink> links) {
  final grouped =
      <QuranRelatedKnowledgeCategory, List<QuranRelatedKnowledgeLink>>{};
  for (final link in links) {
    grouped
        .putIfAbsent(link.category, () => <QuranRelatedKnowledgeLink>[])
        .add(link);
  }
  for (final entry in grouped.entries) {
    entry.value.sort((a, b) {
      final byStrength = a.connectionStrength.priorityValue.compareTo(
        b.connectionStrength.priorityValue,
      );
      if (byStrength != 0) return byStrength;
      return a.title.compareTo(b.title);
    });
  }
  return grouped;
}

String _displayArabicForHifz(String text, HifzRevealMode mode) {
  switch (mode) {
    case HifzRevealMode.full:
      return text;
    case HifzRevealMode.firstWordOnly:
      final words = text.split(RegExp(r'\s+'));
      if (words.isEmpty) return text;
      if (words.length == 1) return '${words.first} ...';
      return '${words.first} ${'•' * (words.length * 2)}';
    case HifzRevealMode.hidden:
      return '•' * text.length.clamp(20, 180).toInt();
  }
}

TextSpan _buildWordSyncedArabicSpan(
  BuildContext context,
  String arabic,
  TextStyle baseStyle,
  int activeWordIndex,
  Color? harakatColor, {
  Set<String> searchHighlightWords = const <String>{},
}) {
  final words = arabic
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return buildQuranTextWithColoredHarakat(
      arabic,
      baseStyle,
      harakatColor:
          harakatColor ??
          QuranPresentationStyle.translucentHarakatColor(context),
    );
  }

  final children = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == activeWordIndex;
    final isSearchHighlighted = searchHighlightWords.contains(words[i]);
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B).withValues(
              alpha:
                  (const Color(0xFF2F8F5B).a *
                          QuranPresentationStyle.translucencyFactor(context))
                      .clamp(0.0, 1.0),
            ),
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.80),
            shadows: [
              Shadow(
                color: const Color(0xFFC8A85A).withValues(alpha: 0.40),
                blurRadius: 7,
                offset: const Offset(0, 0.6),
              ),
            ],
          )
        : isSearchHighlighted
        ? baseStyle.copyWith(
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.55),
            color: const Color(0xFF2F8F5B),
          )
        : baseStyle;
    children.add(
      buildQuranTextWithColoredHarakat(
        words[i],
        style,
        harakatColor:
            harakatColor ??
            QuranPresentationStyle.translucentHarakatColor(context),
      ),
    );
    if (i != words.length - 1) {
      children.add(TextSpan(text: ' ', style: baseStyle));
    }
  }

  return TextSpan(style: baseStyle, children: children);
}

TextSpan _buildFollowTextSpan({
  required String text,
  required QuranSearchMatchField searchHighlightField,
  required TextStyle baseStyle,
  required int sourceWordCount,
  required int? activeSourceIndex,
  List<String> searchHighlightTerms = const <String>[],
}) {
  final words = text
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  final normalizedHighlightTerms = searchHighlightTerms
      .map(
        (term) =>
            _normalizeReaderHighlightWord(searchHighlightField, term.trim()),
      )
      .where((term) => term.isNotEmpty)
      .toSet();
  if (words.isEmpty) {
    return TextSpan(text: text, style: baseStyle);
  }
  if (activeSourceIndex == null || sourceWordCount <= 0 || words.length <= 1) {
    final spans = <InlineSpan>[];
    for (var i = 0; i < words.length; i += 1) {
      final normalizedWord = _normalizeReaderHighlightWord(
        searchHighlightField,
        words[i],
      );
      final isSearchHighlighted = normalizedHighlightTerms.contains(
        normalizedWord,
      );
      spans.add(
        TextSpan(
          text: words[i],
          style: isSearchHighlighted
              ? baseStyle.copyWith(
                  backgroundColor: const Color(
                    0xFFE8D69B,
                  ).withValues(alpha: 0.45),
                  color: const Color(0xFF2F8F5B),
                  fontWeight: FontWeight.w600,
                )
              : baseStyle,
        ),
      );
      if (i != words.length - 1) {
        spans.add(TextSpan(text: ' ', style: baseStyle));
      }
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  final mappedIndex = _mapActiveIndex(
    sourceIndex: activeSourceIndex,
    sourceCount: sourceWordCount,
    targetCount: words.length,
  );

  final spans = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == mappedIndex;
    final normalizedWord = _normalizeReaderHighlightWord(
      searchHighlightField,
      words[i],
    );
    final isSearchHighlighted = normalizedHighlightTerms.contains(
      normalizedWord,
    );
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B),
            fontWeight: FontWeight.w700,
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.35),
          )
        : isSearchHighlighted
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B),
            fontWeight: FontWeight.w600,
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.45),
          )
        : baseStyle.copyWith(
            color: (baseStyle.color ?? const Color(0xFF4A4036)).withValues(
              alpha: 0.42,
            ),
          );
    spans.add(TextSpan(text: words[i], style: style));
    if (i != words.length - 1) {
      spans.add(TextSpan(text: ' ', style: baseStyle));
    }
  }
  return TextSpan(style: baseStyle, children: spans);
}

String _normalizeReaderHighlightWord(
  QuranSearchMatchField field,
  String value,
) {
  switch (field) {
    case QuranSearchMatchField.translation:
    case QuranSearchMatchField.surah:
      return normalizeQuranSearchText(value);
    case QuranSearchMatchField.transliteration:
      return normalizeQuranTransliterationSearchText(value);
    case QuranSearchMatchField.arabic:
      return normalizeQuranArabicSearchText(value);
  }
}

int _mapActiveIndex({
  required int sourceIndex,
  required int sourceCount,
  required int targetCount,
}) {
  if (targetCount <= 1 || sourceCount <= 1) return 0;
  final normalized = sourceIndex.clamp(0, sourceCount - 1) / (sourceCount - 1);
  return (normalized * (targetCount - 1)).round().clamp(0, targetCount - 1);
}

class _KnowledgeLinkWrap extends StatelessWidget {
  const _KnowledgeLinkWrap({
    required this.title,
    required this.items,
    required this.anchorLabel,
    this.itemLimit = 5,
  });

  final String title;
  final List<QuranRelatedKnowledgeLink> items;
  final String anchorLabel;
  final int itemLimit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .take(itemLimit)
              .map(
                (item) => ActionChip(
                  label: Text(item.title),
                  onPressed: () => showQuranRelatedKnowledgeDetailSheet(
                    context,
                    link: item,
                    anchorLabel: anchorLabel,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

IconData _readerStudyModeIcon(QuranReaderStudyMode mode) {
  return switch (mode) {
    QuranReaderStudyMode.reading => Icons.chrome_reader_mode_rounded,
    QuranReaderStudyMode.reflection => Icons.self_improvement_rounded,
    QuranReaderStudyMode.study => Icons.school_rounded,
    QuranReaderStudyMode.memorization => Icons.repeat_rounded,
    QuranReaderStudyMode.theme => Icons.auto_awesome_rounded,
  };
}
