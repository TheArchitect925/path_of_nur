import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../application/quran_providers.dart';
import '../data/quran_word_glossary.dart';
import '../domain/quran_ayah.dart';

class QuranReaderPage extends ConsumerStatefulWidget {
  const QuranReaderPage({
    super.key,
    required this.surahNumber,
    this.initialAyah,
  });

  final int surahNumber;
  final int? initialAyah;

  @override
  ConsumerState<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends ConsumerState<QuranReaderPage> {
  bool _trackedOpen = false;
  late final FlutterTts _tts;
  bool _isLoopRunning = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setLanguage('ar');
    _tts.setSpeechRate(0.36);
    _tts.setVolume(1.0);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_trackedOpen) return;
    _trackedOpen = true;
    Future<void>.microtask(
      () => ref
          .read(quranReadingProgressProvider.notifier)
          .touchLocation(
            surahNumber: widget.surahNumber,
            ayahNumber: widget.initialAyah ?? 1,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final surah = ref.watch(quranSurahMapProvider)[widget.surahNumber];
    final ayahs = ref.watch(quranSurahAyahsProvider(widget.surahNumber));
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);
    final settings = ref.watch(quranReaderSettingsProvider);
    final audioSettings = ref.watch(quranAudioSettingsProvider);
    final hifzSettings = ref.watch(quranHifzSettingsProvider);
    final revisionPlan = ref.watch(quranDailyRevisionPlanProvider);
    final wordFavorites = ref.watch(quranWordFavoritesProvider);
    final reading = ref.watch(quranReadingProgressProvider);
    final effectiveAyah = widget.initialAyah ?? reading.ayahNumber;
    final related = ref.watch(
      learnCrossDomainRelatedProvider(
        learnKeyFromLesson(
          domain: LearnDomainType.quran,
          lessonId: '${widget.surahNumber}:$effectiveAyah',
        ),
      ),
    );

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: surah == null
          ? l10n.quranUnknownSurah
          : '${surah.transliteratedName} • ${surah.arabicName}',
      subtitle: surah == null
          ? l10n.quranReaderSubtitle
          : '${surah.englishName} • ${surah.revelationPlace} • ${surah.verseCount} ${l10n.quranAyahsLabel}',
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    l10n.quranTranslationLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: settings.translationCode,
                    underline: const SizedBox.shrink(),
                    items: quranTranslationCodes
                        .map(
                          (code) => DropdownMenuItem(
                            value: code,
                            child: Text(_translationLabelForCode(l10n, code)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      ref
                          .read(quranReaderSettingsProvider.notifier)
                          .setTranslationCode(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    selected: settings.showTranslation,
                    label: Text(l10n.quranShowTranslation),
                    onSelected: (value) {
                      ref
                          .read(quranReaderSettingsProvider.notifier)
                          .setShowTranslation(value);
                    },
                  ),
                  FilterChip(
                    selected: settings.showTransliteration,
                    label: Text(l10n.quranShowTransliteration),
                    onSelected: (value) {
                      ref
                          .read(quranReaderSettingsProvider.notifier)
                          .setShowTransliteration(value);
                    },
                  ),
                  FilterChip(
                    selected: settings.cleanReadingMode,
                    label: Text(l10n.quranCleanReadingMode),
                    onSelected: (value) {
                      ref
                          .read(quranReaderSettingsProvider.notifier)
                          .setCleanReadingMode(value);
                    },
                  ),
                  FilterChip(
                    selected: settings.showWordByWord,
                    label: Text(l10n.quranWordTranslationChip),
                    onSelected: (value) {
                      ref
                          .read(quranReaderSettingsProvider.notifier)
                          .setShowWordByWord(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ScaleControl(
                      label: l10n.quranArabicTextSize,
                      percent: settings.arabicScalePercent,
                      onChanged: (value) {
                        ref
                            .read(quranReaderSettingsProvider.notifier)
                            .setArabicScalePercent(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ScaleControl(
                      label: l10n.quranTranslationTextSize,
                      percent: settings.translationScalePercent,
                      onChanged: (value) {
                        ref
                            .read(quranReaderSettingsProvider.notifier)
                            .setTranslationScalePercent(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    l10n.quranAudioV2Title,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '${audioSettings.playbackSpeed.toStringAsFixed(2)}x',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A5A4A),
                    ),
                  ),
                ],
              ),
              Slider(
                min: 0.6,
                max: 1.2,
                divisions: 6,
                value: audioSettings.playbackSpeed,
                onChanged: (value) {
                  ref
                      .read(quranAudioSettingsProvider.notifier)
                      .setPlaybackSpeed(value);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: audioSettings.repeatStartAyah,
                      decoration: InputDecoration(
                        labelText: l10n.quranRepeatFromLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.quranNoneLabel),
                        ),
                        ...ayahs.map(
                          (a) => DropdownMenuItem<int?>(
                            value: a.ayahNumber,
                            child: Text(
                              l10n.quranAyahNumberLabel(a.ayahNumber),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setRepeatRange(
                              startAyah: value,
                              endAyah: audioSettings.repeatEndAyah,
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: audioSettings.repeatEndAyah,
                      decoration: InputDecoration(
                        labelText: l10n.quranRepeatToLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.quranNoneLabel),
                        ),
                        ...ayahs.map(
                          (a) => DropdownMenuItem<int?>(
                            value: a.ayahNumber,
                            child: Text(
                              l10n.quranAyahNumberLabel(a.ayahNumber),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setRepeatRange(
                              startAyah: audioSettings.repeatStartAyah,
                              endAyah: value,
                            );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: audioSettings.ayahLoopCount,
                      decoration: InputDecoration(
                        labelText: l10n.quranLoopCountLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}x'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(quranAudioSettingsProvider.notifier)
                            .setAyahLoopCount(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _isLoopRunning
                          ? null
                          : () => _playConfiguredLoop(ayahs),
                      icon: const Icon(Icons.repeat_rounded),
                      label: Text(l10n.quranPlayLoopLabel),
                    ),
                  ),
                ],
              ),
              if (audioSettings.repeatStartAyah == null ||
                  audioSettings.repeatEndAyah == null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.quranLoopRangeHint,
                  style: const TextStyle(
                    color: Color(0xFF6A5A4A),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    l10n.quranMemorizationTitle,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    value: hifzSettings.enabled,
                    onChanged: (value) {
                      ref
                          .read(quranHifzSettingsProvider.notifier)
                          .setEnabled(value);
                    },
                  ),
                ],
              ),
              if (hifzSettings.enabled) ...[
                const SizedBox(height: 6),
                SegmentedButton<HifzRevealMode>(
                  segments: [
                    ButtonSegment(
                      value: HifzRevealMode.full,
                      label: Text(l10n.quranHifzRevealModeFull),
                    ),
                    ButtonSegment(
                      value: HifzRevealMode.firstWordOnly,
                      label: Text(l10n.quranHifzRevealModeFirstWord),
                    ),
                    ButtonSegment(
                      value: HifzRevealMode.hidden,
                      label: Text(l10n.quranHifzRevealModeHidden),
                    ),
                  ],
                  selected: {hifzSettings.revealMode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(quranHifzSettingsProvider.notifier)
                        .setRevealMode(selection.first);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.quranDailyRevisionPlanLabel(revisionPlan.length),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A5A4A),
                  ),
                ),
                const SizedBox(height: 6),
                if (revisionPlan.isEmpty)
                  Text(
                    l10n.quranDailyRevisionEmpty,
                    style: const TextStyle(color: Color(0xFF6A5A4A)),
                  )
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: revisionPlan
                        .map(
                          (item) => ActionChip(
                            label: Text(
                              '${item.surahNumber}:${item.ayahNumber}',
                            ),
                            onPressed: () {
                              context.pushNamed(
                                'quranReader',
                                pathParameters: {
                                  'surahNumber': item.surahNumber.toString(),
                                },
                                queryParameters: {
                                  'ayah': item.ayahNumber.toString(),
                                },
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
              ],
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => context.pushNamed('quranWordReview'),
                icon: const Icon(Icons.style_outlined),
                label: Text(
                  l10n.quranOpenReviewDeckLabel(wordFavorites.length),
                ),
              ),
            ],
          ),
        ),
        if (related.isNotEmpty) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnContentReferencesTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: related
                      .map(
                        (item) => ActionChip(
                          label: Text(item.title),
                          onPressed: () => context.pushNamed(
                            item.routeName,
                            pathParameters: item.pathParameters,
                            queryParameters: item.queryParameters,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.lifeAddReflectionTitle),
                  subtitle: Text(l10n.lifeAddReflectionSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed('journalCreate'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (ayahs.isEmpty)
          PremiumCard(child: Text(l10n.quranSearchNoResults))
        else
          ...ayahs.map(
            (ayah) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AyahCard(
                ayah: ayah,
                isHighlighted: widget.initialAyah == ayah.ayahNumber,
                isBookmarked: bookmarks.any(
                  (bookmark) =>
                      bookmark.surahNumber == ayah.surahNumber &&
                      bookmark.ayahNumber == ayah.ayahNumber,
                ),
                notesCount: notes
                    .where(
                      (note) =>
                          note.surahNumber == ayah.surahNumber &&
                          note.ayahNumber == ayah.ayahNumber,
                    )
                    .length,
                onMarkRead: () {
                  ref
                      .read(quranReadingProgressProvider.notifier)
                      .setProgress(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.quranUpdatedContinueReading)),
                  );
                },
                onBookmark: () {
                  ref
                      .read(quranBookmarksProvider.notifier)
                      .toggleBookmark(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                },
                onAddNote: () => _showAddNoteDialog(context, ref, ayah),
                showTranslation: settings.showTranslation,
                showTransliteration: settings.showTransliteration,
                showWordByWord: settings.showWordByWord,
                showActions: !settings.cleanReadingMode,
                hifzRevealMode: hifzSettings.enabled
                    ? hifzSettings.revealMode
                    : HifzRevealMode.full,
                arabicFontSize: 24 * (settings.arabicScalePercent / 100.0),
                translationFontSize:
                    14 * (settings.translationScalePercent / 100.0),
                onPlayAyah: () => _playAyahAudio(ayah),
                onPlayWord: (word) => _onWordTap(context, ref, word),
                onMistakeCheckpoint: () {
                  ref
                      .read(quranHifzSettingsProvider.notifier)
                      .markMistakeCheckpoint(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                      );
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _playAyahAudio(QuranAyah ayah) async {
    final speed = ref.read(quranAudioSettingsProvider).playbackSpeed;
    await _tts.setLanguage('ar');
    await _tts.setSpeechRate((0.36 * speed).clamp(0.2, 0.7));
    await _tts.speak(ayah.arabic);
  }

  Future<void> _speakWord(String word) async {
    final speed = ref.read(quranAudioSettingsProvider).playbackSpeed;
    await _tts.setLanguage('ar');
    await _tts.setSpeechRate((0.36 * speed).clamp(0.2, 0.7));
    await _tts.speak(word);
  }

  Future<void> _onWordTap(
    BuildContext context,
    WidgetRef ref,
    QuranWordGloss word,
  ) async {
    final l10n = AppLocalizations.of(context);
    await _speakWord(word.arabic);
    final pinned = ref
        .read(quranWordFavoritesProvider.notifier)
        .isPinned(word.arabic);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.arabic,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.transliteration,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(word.gloss),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () {
                    ref
                        .read(quranWordFavoritesProvider.notifier)
                        .togglePin(
                          arabic: word.arabic,
                          gloss: word.gloss,
                          transliteration: word.transliteration,
                        );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  ),
                  label: Text(
                    pinned
                        ? l10n.quranUnpinWordLabel
                        : l10n.quranPinForReviewLabel,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _playConfiguredLoop(List<QuranAyah> ayahs) async {
    final audio = ref.read(quranAudioSettingsProvider);
    final start = audio.repeatStartAyah;
    final end = audio.repeatEndAyah;
    if (start == null || end == null || end < start) {
      return;
    }
    final range = ayahs
        .where((ayah) => ayah.ayahNumber >= start && ayah.ayahNumber <= end)
        .toList();
    if (range.isEmpty) return;
    setState(() => _isLoopRunning = true);
    try {
      for (var loop = 0; loop < audio.ayahLoopCount; loop += 1) {
        for (final ayah in range) {
          if (!mounted) return;
          await _playAyahAudio(ayah);
          await Future<void>.delayed(const Duration(milliseconds: 350));
        }
      }
    } finally {
      if (mounted) setState(() => _isLoopRunning = false);
    }
  }

  Future<void> _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    QuranAyah ayah,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final tagsController = TextEditingController();
    final folderController = TextEditingController(text: 'General');
    bool isHighlight = false;
    final highlightLabelController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(l10n.quranAddNote),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(hintText: l10n.quranNoteHint),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: folderController,
                    decoration: InputDecoration(
                      labelText: l10n.quranNotesFolderLabel,
                      hintText: l10n.quranNotesFolderHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      labelText: l10n.quranNotesTagsLabel,
                      hintText: l10n.quranNotesTagsHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: isHighlight,
                    title: Text(l10n.quranSaveAsHighlightLabel),
                    onChanged: (value) => setState(() => isHighlight = value),
                  ),
                  if (isHighlight)
                    TextField(
                      controller: highlightLabelController,
                      decoration: InputDecoration(
                        labelText: l10n.quranHighlightLabelInput,
                        hintText: l10n.quranHighlightHint,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.quranCancel),
              ),
              FilledButton(
                onPressed: () {
                  final tags = tagsController.text
                      .split(',')
                      .map((item) => item.trim().toLowerCase())
                      .where((item) => item.isNotEmpty)
                      .toSet()
                      .toList();
                  ref
                      .read(quranNotesProvider.notifier)
                      .addNote(
                        surahNumber: ayah.surahNumber,
                        ayahNumber: ayah.ayahNumber,
                        text: controller.text,
                        tags: tags,
                        folder: folderController.text,
                        isHighlight: isHighlight,
                        highlightLabel: highlightLabelController.text,
                      );
                  Navigator.of(context).pop();
                },
                child: Text(l10n.quranSave),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({
    required this.ayah,
    required this.isHighlighted,
    required this.isBookmarked,
    required this.notesCount,
    required this.onMarkRead,
    required this.onBookmark,
    required this.onAddNote,
    required this.showTranslation,
    required this.showTransliteration,
    required this.showWordByWord,
    required this.showActions,
    required this.hifzRevealMode,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.onPlayAyah,
    required this.onPlayWord,
    required this.onMistakeCheckpoint,
  });

  final QuranAyah ayah;
  final bool isHighlighted;
  final bool isBookmarked;
  final int notesCount;
  final VoidCallback onMarkRead;
  final VoidCallback onBookmark;
  final VoidCallback onAddNote;
  final bool showTranslation;
  final bool showTransliteration;
  final bool showWordByWord;
  final bool showActions;
  final HifzRevealMode hifzRevealMode;
  final double arabicFontSize;
  final double translationFontSize;
  final VoidCallback onPlayAyah;
  final Future<void> Function(QuranWordGloss word) onPlayWord;
  final VoidCallback onMistakeCheckpoint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumCard(
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
                  color: AppColors.accentGold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ayah.ayahNumber.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              if (isHighlighted)
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF7C5D3A),
                  size: 20,
                ),
              if (showActions)
                IconButton(
                  tooltip: l10n.quranBookmark,
                  onPressed: onBookmark,
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_outline_rounded,
                  ),
                ),
              if (showActions)
                IconButton(
                  tooltip: l10n.quranPlayAyahTooltip,
                  onPressed: onPlayAyah,
                  icon: const Icon(Icons.volume_up_rounded),
                ),
              if (showActions)
                IconButton(
                  tooltip: l10n.quranHifzCheckpointTooltip,
                  onPressed: onMistakeCheckpoint,
                  icon: const Icon(Icons.flag_outlined),
                ),
              if (showActions)
                IconButton(
                  tooltip: l10n.quranAddNote,
                  onPressed: onAddNote,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.sticky_note_2_outlined),
                      if (notesCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C5D3A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              notesCount.toString(),
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
          const SizedBox(height: 8),
          Text(
            _displayArabicForHifz(ayah.arabic, hifzRevealMode),
            textAlign: TextAlign.right,
            style: const TextStyle(
              height: 1.7,
              color: Color(0xFF1F1B17),
            ).copyWith(fontSize: arabicFontSize),
          ),
          if (showWordByWord) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: buildWordGlosses(ayah.arabic)
                  .map(
                    (word) => InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onPlayWord(word),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF1E7D8),
                          border: Border.all(color: const Color(0xFFD9C4A2)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word.arabic,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              word.gloss,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF6A5A4A),
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
          if (showTransliteration &&
              (ayah.transliteration ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              ayah.transliteration!,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF6A5A4A),
              ),
            ),
          ],
          if (showTranslation) ...[
            const SizedBox(height: 8),
            Text(
              ayah.translation,
              style: TextStyle(height: 1.5, fontSize: translationFontSize),
            ),
          ],
          if (showActions) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onMarkRead,
              icon: const Icon(Icons.playlist_add_check_rounded, size: 16),
              label: Text(l10n.quranSetContinueReading),
            ),
          ],
        ],
      ),
    );
  }
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

class _ScaleControl extends StatelessWidget {
  const _ScaleControl({
    required this.label,
    required this.percent,
    required this.onChanged,
  });

  final String label;
  final int percent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ($percent%)',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A5A4A),
          ),
        ),
        Slider(
          min: 85,
          max: 140,
          divisions: 11,
          value: percent.toDouble(),
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

String _translationLabelForCode(AppLocalizations l10n, String code) {
  switch (code) {
    case 'en.sahih':
      return l10n.quranTranslationSahih;
    case 'en.clear':
      return l10n.quranTranslationClearQuran;
    case 'ur.urdu':
      return l10n.quranTranslationUrdu;
    case 'bn.bengali':
      return l10n.quranTranslationBengali;
    case 'id.indonesian':
      return l10n.quranTranslationIndonesian;
    case 'tr.saheeh':
      return l10n.quranTranslationTurkish;
    case 'fa.dari':
      return l10n.quranTranslationDari;
    default:
      return code;
  }
}
