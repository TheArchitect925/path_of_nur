part of '../quran_reader_page.dart';

class _ReaderSearchSheetResult {
  const _ReaderSearchSheetResult._({
    this.query,
    this.clearActiveSearch = false,
    this.updatedRecentSearches,
    this.selectedCurrentSurahResult,
    this.selectedWholeQuranResult,
    this.openFullSearch = false,
  });

  final String? query;
  final bool clearActiveSearch;
  final List<String>? updatedRecentSearches;
  final _ReaderSearchSheetAyahResult? selectedCurrentSurahResult;
  final QuranSearchResult? selectedWholeQuranResult;
  final bool openFullSearch;
}

enum _ReaderSearchScope { currentSurah, wholeQuran }

class _ReaderSearchSheetAyahResult {
  const _ReaderSearchSheetAyahResult({
    required this.ayahNumber,
    required this.title,
    required this.matchField,
    required this.snippetText,
    required this.highlightTerms,
  });

  final int ayahNumber;
  final String title;
  final QuranSearchMatchField matchField;
  final String snippetText;
  final List<String> highlightTerms;
}

class _ReaderSearchSheet extends StatefulWidget {
  const _ReaderSearchSheet({
    required this.surahNumber,
    required this.initialQuery,
    required this.initialRecentSearches,
    required this.suggestedSearches,
    required this.hasActiveReaderSearch,
    required this.ayahs,
    required this.repository,
    required this.translationCode,
  });

  final int surahNumber;
  final String initialQuery;
  final List<String> initialRecentSearches;
  final List<String> suggestedSearches;
  final bool hasActiveReaderSearch;
  final List<QuranAyah> ayahs;
  final QuranRepository repository;
  final String translationCode;

  @override
  State<_ReaderSearchSheet> createState() => _ReaderSearchSheetState();
}

class _ReaderSearchSheetState extends State<_ReaderSearchSheet> {
  late final TextEditingController _controller;
  late List<String> _recentSearches;
  _ReaderSearchScope _scope = _ReaderSearchScope.currentSurah;
  List<_ReaderSearchSheetAyahResult> _currentSurahResults =
      const <_ReaderSearchSheetAyahResult>[];
  List<QuranSearchResult> _wholeQuranResults = const <QuranSearchResult>[];
  Timer? _debounce;
  int _requestVersion = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _recentSearches = List<String>.from(widget.initialRecentSearches);
    _controller.addListener(_handleQueryChanged);
    _schedulePreviewRefresh(immediate: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_handleQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleQueryChanged() {
    _schedulePreviewRefresh();
  }

  void _schedulePreviewRefresh({bool immediate = false}) {
    _debounce?.cancel();
    final runVersion = ++_requestVersion;
    Future<void> execute() async {
      await Future<void>.delayed(Duration.zero);
      if (!mounted || runVersion != _requestVersion) {
        return;
      }
      final query = _controller.text.trim();
      final currentSurahResults =
          query.isEmpty || _scope != _ReaderSearchScope.currentSurah
          ? const <_ReaderSearchSheetAyahResult>[]
          : _buildCurrentSurahResults(
              query,
              buildReaderSurahSearchMatches(
                query: query,
                ayahs: widget.ayahs
                    .map(
                      (ayah) => (
                        ayahNumber: ayah.ayahNumber,
                        translation: ayah.translation,
                        transliteration: ayah.transliteration ?? '',
                        arabic: ayah.arabic,
                      ),
                    )
                    .toList(growable: false),
              ),
            );
      final wholeQuranResults =
          query.isEmpty || _scope != _ReaderSearchScope.wholeQuran
          ? const <QuranSearchResult>[]
          : _buildWholeQuranResults(query);
      if (!mounted || runVersion != _requestVersion) {
        return;
      }
      setState(() {
        _currentSurahResults = currentSurahResults
            .take(5)
            .toList(growable: false);
        _wholeQuranResults = wholeQuranResults.take(6).toList(growable: false);
      });
    }

    if (immediate) {
      unawaited(execute());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 120), () {
      unawaited(execute());
    });
  }

  List<String> _updatedRecentSearchesFor(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return _recentSearches;
    }
    return <String>[
      trimmedQuery,
      ..._recentSearches.where((item) => item != trimmedQuery),
    ].take(8).toList(growable: false);
  }

  void _handleSubmittedQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _controller.value = TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
    _schedulePreviewRefresh(immediate: true);
  }

  List<QuranSearchResult> _buildWholeQuranResults(String query) {
    final rows = widget.repository.search(
      query,
      translationCode: widget.translationCode,
      maxResults: 6,
    );
    final output = <QuranSearchResult>[];
    final seenKeys = <String>{};

    for (final row in rows) {
      final key =
          '${row.surah.number}:${row.ayahNumber ?? 0}:${row.matchField.wireValue}';
      if (!seenKeys.add(key)) continue;
      QuranAyah? ayah;
      if (row.ayahNumber != null) {
        final ayahs = widget.repository.getAyahsForSurah(
          row.surah.number,
          translationCode: widget.translationCode,
        );
        final ayahNumber = row.ayahNumber!;
        if (ayahNumber > 0 && ayahNumber <= ayahs.length) {
          final resolved = ayahs[ayahNumber - 1];
          ayah = QuranAyah(
            surahNumber: resolved.surahNumber,
            ayahNumber: resolved.ayahNumber,
            arabic: row.arabicText ?? resolved.arabic,
            translation: row.translationText ?? resolved.translation,
            transliteration:
                row.transliterationText ?? resolved.transliteration,
          );
        }
      }
      output.add(
        QuranSearchResult(
          surah: row.surah,
          ayah: ayah,
          matchText: row.matchText,
          matchField: row.matchField,
          snippetText: row.snippetText,
          highlightTerms: row.highlightTerms,
        ),
      );
    }

    return output;
  }

  List<_ReaderSearchSheetAyahResult> _buildCurrentSurahResults(
    String query,
    List<QuranReaderAyahSearchMatch> matches,
  ) {
    final surahName = widget.repository
        .getSurahs()[widget.surahNumber - 1]
        .transliteratedName;
    final ayahsByNumber = <int, QuranAyah>{
      for (final ayah in widget.ayahs) ayah.ayahNumber: ayah,
    };
    final output = <_ReaderSearchSheetAyahResult>[];

    for (final match in matches) {
      final ayah = ayahsByNumber[match.ayahNumber];
      if (ayah == null) continue;
      final field = _preferredPreviewField(match);
      final sourceText = switch (field) {
        QuranSearchMatchField.translation => ayah.translation,
        QuranSearchMatchField.transliteration => ayah.transliteration ?? '',
        QuranSearchMatchField.arabic => ayah.arabic,
        QuranSearchMatchField.surah => ayah.translation,
      };
      final metadata = buildQuranSearchPresentationMetadata(
        field: field,
        query: query,
        sourceText: sourceText,
      );
      output.add(
        _ReaderSearchSheetAyahResult(
          ayahNumber: match.ayahNumber,
          title: '$surahName ${match.ayahNumber}',
          matchField: field,
          snippetText: metadata.snippetText,
          highlightTerms: metadata.highlightTerms,
        ),
      );
    }

    return output;
  }

  QuranSearchMatchField _preferredPreviewField(
    QuranReaderAyahSearchMatch match,
  ) {
    for (final field in const <QuranSearchMatchField>[
      QuranSearchMatchField.translation,
      QuranSearchMatchField.transliteration,
      QuranSearchMatchField.arabic,
    ]) {
      if (match.matchesField(field)) {
        return field;
      }
    }
    return QuranSearchMatchField.translation;
  }

  String _matchTypeLabel(AppLocalizations l10n, QuranSearchMatchField field) {
    switch (field) {
      case QuranSearchMatchField.translation:
        return l10n.quranSearchMatchTranslation;
      case QuranSearchMatchField.transliteration:
        return l10n.quranSearchMatchTransliteration;
      case QuranSearchMatchField.arabic:
        return l10n.quranSearchMatchArabic;
      case QuranSearchMatchField.surah:
        return l10n.quranSearchMatchSurah;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final trimmedValue = _controller.text.trim();
    final bottomActionInset = math.max(
      16.0,
      MediaQuery.of(context).padding.bottom + 24,
    );
    return FractionallySizedBox(
      heightFactor: 0.68,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranReaderSearchSheetTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _scope == _ReaderSearchScope.currentSurah
                    ? l10n.quranReaderSearchScopeSubtitle
                    : l10n.quranReaderSearchWholeQuranSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6A5A4A),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.quranReaderSearchScopeCurrentSurah),
                    selected: _scope == _ReaderSearchScope.currentSurah,
                    onSelected: (_) {
                      if (_scope == _ReaderSearchScope.currentSurah) return;
                      setState(() {
                        _scope = _ReaderSearchScope.currentSurah;
                      });
                      _schedulePreviewRefresh(immediate: true);
                    },
                  ),
                  ChoiceChip(
                    label: Text(l10n.quranReaderSearchScopeWholeQuran),
                    selected: _scope == _ReaderSearchScope.wholeQuran,
                    onSelected: (_) {
                      if (_scope == _ReaderSearchScope.wholeQuran) return;
                      setState(() {
                        _scope = _ReaderSearchScope.wholeQuran;
                      });
                      _schedulePreviewRefresh(immediate: true);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: l10n.quranReaderSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: trimmedValue.isEmpty
                      ? null
                      : IconButton(
                          tooltip: l10n.quranReaderSearchClearAction,
                          onPressed: () => _controller.clear(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _handleSubmittedQuery,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    if (_recentSearches.isNotEmpty && trimmedValue.isEmpty) ...[
                      Text(
                        l10n.quranRecentSearches,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF6A5A4A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _recentSearches
                            .map(
                              (query) => ActionChip(
                                label: Text(query),
                                onPressed: () {
                                  _controller.value = TextEditingValue(
                                    text: query,
                                    selection: TextSelection.collapsed(
                                      offset: query.length,
                                    ),
                                  );
                                  _schedulePreviewRefresh(immediate: true);
                                },
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.suggestedSearches.isNotEmpty &&
                        trimmedValue.isEmpty) ...[
                      Text(
                        l10n.quranSuggestedSearches,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF6A5A4A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.suggestedSearches
                            .where(
                              (query) => !_recentSearches.any(
                                (recent) =>
                                    recent.toLowerCase() == query.toLowerCase(),
                              ),
                            )
                            .take(6)
                            .map(
                              (query) => ActionChip(
                                label: Text(query),
                                onPressed: () {
                                  _controller.value = TextEditingValue(
                                    text: query,
                                    selection: TextSelection.collapsed(
                                      offset: query.length,
                                    ),
                                  );
                                  _schedulePreviewRefresh(immediate: true);
                                },
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ],
                    if (trimmedValue.isNotEmpty &&
                        _scope == _ReaderSearchScope.currentSurah) ...[
                      Text(
                        l10n.quranSearchResultCountLabel(
                          _currentSurahResults.length,
                        ),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF6A5A4A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._currentSurahResults.map(
                        (result) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            result.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${_matchTypeLabel(l10n, result.matchField)} • ${result.snippetText}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            final query = trimmedValue;
                            Navigator.of(context).pop(
                              _ReaderSearchSheetResult._(
                                query: query,
                                selectedCurrentSurahResult: result,
                                updatedRecentSearches:
                                    _updatedRecentSearchesFor(query),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    if (trimmedValue.isNotEmpty &&
                        _scope == _ReaderSearchScope.wholeQuran) ...[
                      Text(
                        l10n.quranSearchResultCountLabel(
                          _wholeQuranResults.length,
                        ),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF6A5A4A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._wholeQuranResults.map(
                        (result) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            result.ayah == null
                                ? result.surah.transliteratedName
                                : '${result.surah.transliteratedName} ${result.ayah!.ayahNumber}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            result.snippetText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.of(context).pop(
                              _ReaderSearchSheetResult._(
                                query: trimmedValue,
                                selectedWholeQuranResult: result,
                                updatedRecentSearches:
                                    _updatedRecentSearchesFor(trimmedValue),
                              ),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.quranSearchMoreResultsAction),
                        trailing: const Icon(Icons.open_in_new_rounded),
                        onTap: () {
                          Navigator.of(context).pop(
                            _ReaderSearchSheetResult._(
                              query: trimmedValue,
                              openFullSearch: true,
                              updatedRecentSearches: _updatedRecentSearchesFor(
                                trimmedValue,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: bottomActionInset),
                child: Row(
                  children: [
                    if (_recentSearches.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _recentSearches = const <String>[];
                          });
                        },
                        child: Text(l10n.quranReaderSearchClearRecentAction),
                      ),
                    if (widget.hasActiveReaderSearch)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            _ReaderSearchSheetResult._(
                              clearActiveSearch: true,
                              updatedRecentSearches: _recentSearches,
                            ),
                          );
                        },
                        child: Text(l10n.quranReaderSearchClearAction),
                      ),
                    const Spacer(),
                    FilledButton.icon(
                      key: const ValueKey('quran-reader-search-run-button'),
                      onPressed: trimmedValue.isEmpty
                          ? null
                          : () => _handleSubmittedQuery(trimmedValue),
                      icon: const Icon(Icons.search_rounded),
                      label: Text(l10n.quranReaderSearchRunAction),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
