import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/reminders/quran_live_activity_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/persistence/local_store.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_text_span.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../application/quran_providers.dart';
import '../application/quran_reference_graph_provider.dart';
import '../data/quran_audio_repository.dart';
import '../data/quran_word_glossary.dart';
import '../data/quran_word_timing_repository.dart';
import '../domain/quran_ayah.dart';
import 'widgets/quran_reference_viewer.dart';

class QuranReaderPage extends ConsumerStatefulWidget {
  const QuranReaderPage({
    super.key,
    required this.surahNumber,
    this.initialAyah,
    this.endAyah,
    this.autoPlay = false,
  });

  final int surahNumber;
  final int? initialAyah;
  final int? endAyah;
  final bool autoPlay;

  @override
  ConsumerState<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends ConsumerState<QuranReaderPage>
    with WidgetsBindingObserver {
  static const _controlsExpandedKey = 'learn.quran.readerControlsExpanded';

  bool _trackedOpen = false;
  late final AudioPlayer _audioPlayer;
  bool _isLoopRunning = false;
  bool _readerControlsExpanded = false;
  bool _isDownloadingSurah = false;
  int _downloadedAyahs = 0;
  int _downloadTotalAyahs = 0;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _currentIndexSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  String? _currentlyPlayingAyahKey;
  bool _isSwitchingAyahSource = false;
  Timer? _wordHighlightTimer;
  int? _currentWordIndex;
  int _wordHighlightSyncRequestId = 0;
  bool _initialAyahAutoScrolled = false;
  int _lastSentLiveElapsedSecond = -1;
  bool _quranLiveActivitySupported = false;
  QuranAyah? _quranLiveActivityAyah;
  bool _isSurahPlaybackMode = false;
  bool _isPreparingSurahPlayback = false;
  bool _hasReachedEndOfSurahPlayback = false;
  int _lastPlaybackUiTick = -1;
  bool _didAutoPlayFromRoute = false;
  int _playerSessionVersion = 0;
  List<QuranAyah> _surahPlaybackAyahs = const [];
  late final ScrollController _scrollController;
  final Map<int, GlobalKey> _ayahItemKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = ref.read(quranSharedAudioPlayerProvider);
    _bootstrapQuranLiveActivity();
    _scrollController = ScrollController();
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {});
      if (_quranLiveActivityAyah != null) {
        unawaited(
          _updateQuranLiveActivity(
            ayah: _quranLiveActivityAyah!,
            force: true,
            isPlayingOverride: state.playing,
          ),
        );
      }
      if (_isSurahPlaybackMode) {
        if (!state.playing) {
          _saveCurrentRecitationSession();
          _stopWordHighlight();
        } else {
          final index = _audioPlayer.currentIndex;
          if (index != null &&
              index >= 0 &&
              index < _surahPlaybackAyahs.length &&
              _currentWordIndex == null) {
            unawaited(
              _syncWordHighlightForCurrentTrack(_surahPlaybackAyahs[index]),
            );
          }
        }
      }
      if (_isSurahPlaybackMode &&
          state.processingState == ProcessingState.completed) {
        _saveCurrentRecitationSession(preferTrackEnd: true);
        _stopWordHighlight();
        unawaited(_endQuranLiveActivityIfEnabled());
        unawaited(_audioPlayer.stop());
        setState(() {
          _isSurahPlaybackMode = false;
          _currentlyPlayingAyahKey = null;
          _hasReachedEndOfSurahPlayback = true;
        });
        return;
      }
      if (!_isLoopRunning &&
          !_isSwitchingAyahSource &&
          !_isSurahPlaybackMode &&
          !state.playing &&
          (state.processingState == ProcessingState.completed ||
              state.processingState == ProcessingState.idle)) {
        _stopWordHighlight();
        unawaited(_endQuranLiveActivityIfEnabled());
        setState(() => _currentlyPlayingAyahKey = null);
      }
    });
    _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (!mounted || !_isSurahPlaybackMode || index == null) return;
      if (index < 0 || index >= _surahPlaybackAyahs.length) return;
      final ayah = _surahPlaybackAyahs[index];
      setState(
        () =>
            _currentlyPlayingAyahKey = '${ayah.surahNumber}:${ayah.ayahNumber}',
      );
      _scrollToAyah(ayah.ayahNumber);
      _syncWordHighlightForCurrentTrack(ayah);
      _quranLiveActivityAyah = ayah;
      _lastSentLiveElapsedSecond = -1;
      unawaited(_updateQuranLiveActivity(ayah: ayah, force: true));
    });
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final uiTick = position.inMilliseconds ~/ 250;
      if (mounted && uiTick != _lastPlaybackUiTick) {
        _lastPlaybackUiTick = uiTick;
        setState(() {});
      }
      if (!_quranLiveActivitySupported) return;
      final ayah = _quranLiveActivityAyah;
      if (ayah == null) return;
      final seconds = position.inSeconds;
      if (seconds == _lastSentLiveElapsedSecond) return;
      _lastSentLiveElapsedSecond = seconds;
      unawaited(_updateQuranLiveActivity(ayah: ayah));
    });
    _durationSubscription = _audioPlayer.durationStream.listen((_) {
      if (!_quranLiveActivitySupported) return;
      final ayah = _quranLiveActivityAyah;
      if (ayah == null) return;
      unawaited(_updateQuranLiveActivity(ayah: ayah, force: true));
    });
    final store = ref.read(localStoreProvider);
    _readerControlsExpanded = store.getBool(_controlsExpandedKey) ?? true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _wordHighlightTimer?.cancel();
    _saveViewportReadingProgress();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!Platform.isIOS) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveViewportReadingProgress();
      final audioSettings = ref.read(quranAudioSettingsProvider);
      if (!audioSettings.backgroundPlaybackEnabled && _audioPlayer.playing) {
        unawaited(_audioPlayer.pause());
      }
    }
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
  void didUpdateWidget(covariant QuranReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber ||
        oldWidget.initialAyah != widget.initialAyah) {
      _initialAyahAutoScrolled = false;
      _didAutoPlayFromRoute = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final useArabicReciterLabels = languageCode.toLowerCase().startsWith('ar');
    final surah = ref.watch(quranSurahMapProvider)[widget.surahNumber];
    final ayahsAsync = ref.watch(quranSurahAyahsProvider(widget.surahNumber));
    final ayahs = ayahsAsync.valueOrNull ?? const <QuranAyah>[];
    final bookmarks = ref.watch(quranBookmarksProvider);
    final notes = ref.watch(quranNotesProvider);
    final recitationSession = ref.watch(quranRecitationSessionProvider);
    final settings = ref.watch(quranReaderSettingsProvider);
    final settingsNotifier = ref.read(quranReaderSettingsProvider.notifier);
    final audioSettings = ref.watch(quranAudioSettingsProvider);
    final audioSettingsNotifier = ref.read(quranAudioSettingsProvider.notifier);
    final audioRepository = ref.watch(quranAudioRepositoryProvider);
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
    final verseKnowledge = ref.watch(
      quranKnowledgeForVerseProvider((widget.surahNumber, effectiveAyah)),
    );
    final selectedReciter = audioRepository.reciterById(
      audioSettings.reciterId,
    );
    final isLiveWordSyncEnabled = settings.wordSyncHighlightBeta;
    final effectivePlaybackSpeed = _effectivePlaybackSpeed(
      configuredSpeed: audioSettings.playbackSpeed,
      lockToWordSync: isLiveWordSyncEnabled,
    );
    final availableAyahNumbers = ayahs.map((a) => a.ayahNumber).toSet();
    final selectedRepeatStart =
        availableAyahNumbers.contains(audioSettings.repeatStartAyah)
        ? audioSettings.repeatStartAyah
        : null;
    final selectedRepeatEnd =
        availableAyahNumbers.contains(audioSettings.repeatEndAyah)
        ? audioSettings.repeatEndAyah
        : null;
    final sessionForCurrentSurah =
        recitationSession != null &&
            recitationSession.surahNumber == widget.surahNumber
        ? recitationSession
        : null;
    _maybeAutoScrollToInitialAyah(ayahs);
    _maybeAutoPlayFromRoute(ayahs);

    return AppPageScaffold(
      scrollController: _scrollController,
      headerIcon: Icons.menu_book_rounded,
      headerActions: [
        IconButton(
          tooltip: 'Sources & licensing',
          onPressed: () => _showSourcesInfoSheet(context),
          icon: const Icon(Icons.info_outline_rounded),
          color: const Color(0xFF3A3026),
        ),
      ],
      title: surah == null
          ? l10n.quranUnknownSurah
          : '${surah.transliteratedName} • ${surah.arabicName}',
      subtitle: surah == null
          ? l10n.quranReaderSubtitle
          : '${surah.englishName} • ${surah.revelationPlace} • ${surah.verseCount} ${l10n.quranAyahsLabel}',
      floatingBottom: _shouldShowFloatingPlayer(ayahs)
          ? _buildFloatingSurahPlaybackControls(ayahs)
          : null,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final nextValue = !_readerControlsExpanded;
                    setState(() => _readerControlsExpanded = nextValue);
                    ref
                        .read(localStoreProvider)
                        .setBool(_controlsExpandedKey, nextValue);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: Color(0xFF6A5A4A),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Settings',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Text(
                          'Expand/Collapse',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A5A4A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _readerControlsExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_readerControlsExpanded) ...[
                  const SizedBox(height: 10),
                  const _SettingsSectionHeader(title: 'Text Settings'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: settings.translationCode,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Translation source',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    items: quranTranslationCodes
                        .map(
                          (code) => DropdownMenuItem(
                            value: code,
                            child: Text(
                              _translationLabelForCode(l10n, code),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      settingsNotifier.setTranslationCode(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Text Options',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.showTranslation,
                    title: Text(l10n.quranShowTranslation),
                    onChanged: settingsNotifier.setShowTranslation,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.showTransliteration,
                    title: Text(l10n.quranShowTransliteration),
                    onChanged: settingsNotifier.setShowTransliteration,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.cleanReadingMode,
                    title: Text(l10n.quranCleanReadingMode),
                    onChanged: settingsNotifier.setCleanReadingMode,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.showWordByWord,
                    title: Text(l10n.quranWordTranslationChip),
                    onChanged: settingsNotifier.setShowWordByWord,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.wordSyncHighlightBeta,
                    title: const Text('Live word sync highlight (Beta)'),
                    subtitle: const Text(
                      'Beta testing: timing and highlighting may be imperfect on some verses.',
                    ),
                    onChanged: _setWordSyncHighlightBeta,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.redDiacriticsEnabled,
                    title: const Text('Red diacritics (harakat)'),
                    subtitle: const Text(
                      'Color pesh, zabar, kasrah and other harakat in red.',
                    ),
                    onChanged: settingsNotifier.setRedDiacriticsEnabled,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ScaleControl(
                          label: l10n.quranArabicTextSize,
                          percent: settings.arabicScalePercent,
                          onChanged: settingsNotifier.setArabicScalePercent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ScaleControl(
                          label: l10n.quranTranslationTextSize,
                          percent: settings.translationScalePercent,
                          onChanged:
                              settingsNotifier.setTranslationScalePercent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ScaleControl(
                    label: 'Transliteration text size',
                    percent: settings.transliterationScalePercent,
                    onChanged: settingsNotifier.setTransliterationScalePercent,
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  const _SettingsSectionHeader(title: 'Audio Settings'),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: audioSettings.backgroundPlaybackEnabled,
                    title: const Text(
                      'Background playback + lock-screen controls',
                    ),
                    subtitle: const Text(
                      'Enables media controls on lock screen / notification and Dynamic Island (iOS).',
                    ),
                    onChanged: _setBackgroundPlaybackEnabled,
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedReciter.id,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Reciter',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    items: QuranAudioRepository.reciters
                        .map(
                          (reciter) => DropdownMenuItem<String>(
                            value: reciter.id,
                            child: Text(
                              useArabicReciterLabels
                                  ? reciter.arabicName
                                  : reciter.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      audioSettingsNotifier.setReciterId(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonalIcon(
                      onPressed: () => _playReciterSample(
                        context: context,
                        reciterId: audioSettings.reciterId,
                      ),
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: const Text('Sample'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<bool>(
                    future: audioRepository.isSurahDownloaded(
                      reciterId: audioSettings.reciterId,
                      surahNumber: widget.surahNumber,
                    ),
                    builder: (context, snapshot) {
                      final fullyDownloaded = snapshot.data ?? false;
                      return Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _isDownloadingSurah
                                  ? null
                                  : () => _downloadCurrentSurah(
                                      context: context,
                                      repository: audioRepository,
                                      reciterId: audioSettings.reciterId,
                                    ),
                              icon: const Icon(Icons.download_rounded),
                              label: Text(
                                _isDownloadingSurah
                                    ? 'Downloading $_downloadedAyahs/$_downloadTotalAyahs'
                                    : 'Download Surah',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: fullyDownloaded
                                  ? () => _clearCurrentSurahDownload(
                                      context: context,
                                      repository: audioRepository,
                                      reciterId: audioSettings.reciterId,
                                    )
                                  : null,
                              icon: const Icon(Icons.delete_outline_rounded),
                              label: const Text('Remove Download'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Audio is streamed from trusted reciters. Download only surahs you need to keep app size low.',
                      style: TextStyle(
                        color: Color(0xFF6A5A4A),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Audio Speed',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${effectivePlaybackSpeed.toStringAsFixed(2)}x',
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
                    value: effectivePlaybackSpeed,
                    onChanged: isLiveWordSyncEnabled
                        ? null
                        : (value) {
                            ref
                                .read(quranAudioSettingsProvider.notifier)
                                .setPlaybackSpeed(value);
                          },
                  ),
                  if (isLiveWordSyncEnabled)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Locked to 1.00x while Live word sync highlight is enabled.',
                        style: TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: selectedRepeatStart,
                          style: Theme.of(context).textTheme.bodyLarge,
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
                                  endAyah: selectedRepeatEnd,
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: selectedRepeatEnd,
                          style: Theme.of(context).textTheme.bodyLarge,
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
                                  startAyah: selectedRepeatStart,
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
                          style: Theme.of(context).textTheme.bodyLarge,
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
                  if (selectedRepeatStart == null ||
                      selectedRepeatEnd == null) ...[
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
                  const _SettingsSectionHeader(title: 'Memorization Settings'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        l10n.quranMemorizationTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700),
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
                                      'surahNumber': item.surahNumber
                                          .toString(),
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
              ],
            ),
          ),
        ),
        if (sessionForCurrentSurah != null && !_audioPlayer.playing) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Continue Recitation',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Resume from ayah ${sessionForCurrentSurah.ayahNumber} at ${_formatPosition(Duration(seconds: sessionForCurrentSurah.positionSeconds))}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A5A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: ayahs.isEmpty
                      ? null
                      : () => _resumeRecitationSession(
                          sessionForCurrentSurah,
                          ayahs,
                        ),
                  child: const Text('Resume'),
                ),
              ],
            ),
          ),
        ],
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
        if (verseKnowledge.references.isNotEmpty) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Related Knowledge Discovery',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: verseKnowledge.references
                      .map(
                        (reference) => QuranReferenceChip(
                          referenceId: reference.id,
                          leading: const Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                if (verseKnowledge.lifeLessons.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: 'Related Life Lessons',
                    items: verseKnowledge.lifeLessons,
                  ),
                ],
                if (verseKnowledge.hadithEntries.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: 'Related Hadith',
                    items: verseKnowledge.hadithEntries,
                  ),
                ],
                if (verseKnowledge.prophets.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: 'Related Prophets',
                    items: verseKnowledge.prophets,
                  ),
                ],
                if (verseKnowledge.journeys.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _KnowledgeLinkWrap(
                    title: 'Related Journeys',
                    items: verseKnowledge.journeys,
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (ayahsAsync.isLoading && ayahs.isEmpty)
          const PremiumCard(child: LinearProgressIndicator())
        else if (ayahsAsync.hasError && ayahs.isEmpty)
          PremiumCard(
            child: Text(
              'Unable to load full transliteration right now. Check connection and try again.',
            ),
          )
        else if (ayahs.isEmpty)
          PremiumCard(child: Text(l10n.quranSearchNoResults))
        else
          ...ayahs.map(
            (ayah) => Padding(
              key: _ayahKeyFor(ayah.ayahNumber),
              padding: const EdgeInsets.only(bottom: 12),
              child: _AyahCard(
                ayah: ayah,
                isHighlighted: _isAyahHighlighted(ayah.ayahNumber),
                isNowPlaying:
                    _audioPlayer.playing &&
                    _currentlyPlayingAyahKey ==
                        '${ayah.surahNumber}:${ayah.ayahNumber}',
                activeWordIndex:
                    _currentlyPlayingAyahKey ==
                            '${ayah.surahNumber}:${ayah.ayahNumber}' &&
                        settings.wordSyncHighlightBeta
                    ? _currentWordIndex
                    : null,
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
                transliterationFontSize:
                    15 * (settings.transliterationScalePercent / 100.0),
                harakatColor: settings.redDiacriticsEnabled
                    ? const Color(0xFFC22A2A)
                    : null,
                contextualLinks: _contextualLinksForAyah(ayah),
                onPlayAyah: () => _handleAyahPlay(ayah),
                onTap: () => _startSurahPlaybackFromAyah(ayahs, ayah),
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
        if (ayahs.isNotEmpty) const SizedBox(height: 96),
      ],
    );
  }

  bool _isAyahHighlighted(int ayahNumber) {
    final start = widget.initialAyah;
    if (start == null) return false;
    final end = widget.endAyah;
    if (end == null || end < start) {
      return ayahNumber == start;
    }
    return ayahNumber >= start && ayahNumber <= end;
  }

  List<_AyahContextLink> _contextualLinksForAyah(QuranAyah ayah) {
    final links = <_AyahContextLink>[];
    final translation = ayah.translation.toLowerCase();

    for (final matcher in _prophetMentionMatchers) {
      if (_containsAnyKeyword(translation, matcher.keywords)) {
        links.add(
          _AyahContextLink(
            title: 'Prophet ${matcher.displayName}',
            routeName: 'learnSectionHub',
            pathParameters: const {'sectionId': 'prophets'},
            queryParameters: {'tab': 'stories', 'prophet': matcher.prophetId},
          ),
        );
      }
    }

    for (final matcher in _learningTopicMatchers) {
      if (_containsAnyKeyword(translation, matcher.keywords)) {
        links.add(matcher.link);
      }
    }

    final deduped = <_AyahContextLink>[];
    final seenKeys = <String>{};
    for (final link in links) {
      final key =
          '${link.routeName}|${link.pathParameters}|${link.queryParameters}';
      if (!seenKeys.add(key)) continue;
      deduped.add(link);
    }
    return deduped.take(6).toList(growable: false);
  }

  bool _containsAnyKeyword(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }

  bool _shouldShowFloatingPlayer(List<QuranAyah> ayahs) {
    if (ayahs.isEmpty) return false;
    return _isPreparingSurahPlayback ||
        _isSurahPlaybackMode ||
        _isLoopRunning ||
        _currentlyPlayingAyahKey != null ||
        (_audioPlayer.playing && _audioPlayer.audioSource != null);
  }

  Widget _buildFloatingSurahPlaybackControls(List<QuranAyah> ayahs) {
    final hasPlayback =
        _audioPlayer.audioSource != null || _currentlyPlayingAyahKey != null;
    final isPlaying = hasPlayback && _audioPlayer.playing;
    final nowRecitingLabel = _nowRecitingLabel();
    final totalDuration = _surahPlaybackTotalDuration();
    final computedPosition = _surahPlaybackAbsolutePosition();
    final absolutePosition = computedPosition < Duration.zero
        ? Duration.zero
        : (computedPosition > totalDuration ? totalDuration : computedPosition);
    final maxMillis = totalDuration.inMilliseconds.toDouble();
    final currentMillis = absolutePosition.inMilliseconds
        .clamp(0, totalDuration.inMilliseconds)
        .toDouble();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PremiumCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _isPreparingSurahPlayback
                        ? null
                        : _closeSurahPlaybackPlayer,
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close player',
                  ),
                  IconButton.filledTonal(
                    onPressed: (_isPreparingSurahPlayback || !hasPlayback)
                        ? null
                        : () => _seekRelative(const Duration(seconds: -15)),
                    icon: const Icon(Icons.replay_10_rounded),
                    tooltip: 'Back 15 seconds',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isPreparingSurahPlayback
                          ? null
                          : () => _toggleCurrentPlayback(ayahs),
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                      ),
                      label: Text(
                        _isPreparingSurahPlayback
                            ? 'Preparing...'
                            : (isPlaying ? 'Pause' : 'Play'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    onPressed: (_isPreparingSurahPlayback || !hasPlayback)
                        ? null
                        : () => _seekRelative(const Duration(seconds: 15)),
                    icon: const Icon(Icons.forward_10_rounded),
                    tooltip: 'Forward 15 seconds',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Slider(
                min: 0,
                max: maxMillis > 0 ? maxMillis : 1,
                value: maxMillis > 0 ? currentMillis : 0,
                onChanged:
                    (_isPreparingSurahPlayback ||
                        !hasPlayback ||
                        maxMillis <= 0)
                    ? null
                    : (value) => _seekSurahAbsolute(
                        Duration(milliseconds: value.round()),
                      ),
              ),
              Row(
                children: [
                  Text(
                    _formatPosition(absolutePosition),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A5A4A),
                    ),
                  ),
                  const Spacer(),
                  if (hasPlayback && nowRecitingLabel != null)
                    Text(
                      nowRecitingLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  if (hasPlayback && nowRecitingLabel != null) const Spacer(),
                  Text(
                    _formatPosition(totalDuration),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A5A4A),
                    ),
                  ),
                ],
              ),
              if (_hasReachedEndOfSurahPlayback &&
                  widget.surahNumber < 114) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      final nextSurah = widget.surahNumber + 1;
                      context.pushReplacementNamed(
                        'quranReader',
                        pathParameters: {'surahNumber': nextSurah.toString()},
                        queryParameters: const {'autoplay': '1'},
                      );
                    },
                    icon: const Icon(Icons.skip_next_rounded),
                    label: Text('Next Surah (${widget.surahNumber + 1})'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String? _nowRecitingLabel() {
    final key = _currentlyPlayingAyahKey;
    if (key == null || key.isEmpty) return null;
    final parts = key.split(':');
    if (parts.length < 2) return null;
    final surah = int.tryParse(parts[0]);
    final ayah = int.tryParse(parts[1]);
    if (surah == null || ayah == null) return null;
    final surahArabicName = ref.read(quranSurahMapProvider)[surah]?.arabicName;
    if (surahArabicName == null || surahArabicName.isEmpty) {
      return 'Recitation Surah $surah • Verse $surah:$ayah';
    }
    return 'Recitation $surahArabicName • Verse $surah:$ayah';
  }

  void _maybeAutoPlayFromRoute(List<QuranAyah> ayahs) {
    if (!widget.autoPlay || _didAutoPlayFromRoute || ayahs.isEmpty) return;
    _didAutoPlayFromRoute = true;
    final targetAyahNumber = widget.initialAyah;
    final targetAyah = targetAyahNumber == null
        ? null
        : ayahs
              .where((ayah) => ayah.ayahNumber == targetAyahNumber)
              .firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (targetAyah != null) {
        unawaited(_handleAyahPlay(targetAyah));
        return;
      }
      unawaited(_startSurahPlayback(ayahs: ayahs, initialIndex: 0));
    });
  }

  void _maybeAutoScrollToInitialAyah(List<QuranAyah> ayahs) {
    final targetAyah = widget.initialAyah;
    if (_initialAyahAutoScrolled || targetAyah == null) return;
    if (!ayahs.any((ayah) => ayah.ayahNumber == targetAyah)) return;
    _initialAyahAutoScrolled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_scrollToAyah(targetAyah, retries: 10));
    });
  }

  Future<void> _handleAyahPlay(QuranAyah ayah) async {
    if (!mounted) return;
    final ayahKey = '${ayah.surahNumber}:${ayah.ayahNumber}';
    if (_currentlyPlayingAyahKey == ayahKey &&
        _audioPlayer.audioSource != null &&
        !_isSurahPlaybackMode) {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
        _stopWordHighlight();
      } else {
        unawaited(_audioPlayer.play());
      }
      return;
    }
    setState(() {
      _isSurahPlaybackMode = false;
      _surahPlaybackAyahs = const [];
      _currentlyPlayingAyahKey = ayahKey;
    });
    await _playAyahAudio(ayah, includeOpeningBismillah: true);
  }

  Future<void> _toggleCurrentPlayback(List<QuranAyah> ayahs) async {
    if (_isSurahPlaybackMode) {
      await _toggleSurahPlayback(ayahs);
      return;
    }
    if (_audioPlayer.audioSource == null) {
      await _toggleSurahPlayback(ayahs);
      return;
    }
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      _stopWordHighlight();
      return;
    }
    final currentAyah = _currentAyahFromPlaybackKey(ayahs);
    if (currentAyah != null) {
      await _playAyahAudio(currentAyah, includeOpeningBismillah: true);
      return;
    }
    unawaited(_audioPlayer.play());
  }

  Future<void> _bootstrapQuranLiveActivity() async {
    final service = QuranLiveActivityService();
    _quranLiveActivitySupported = await service.isSupported();
  }

  Future<void> _updateQuranLiveActivity({
    required QuranAyah ayah,
    bool force = false,
    bool? isPlayingOverride,
  }) async {
    if (!_quranLiveActivitySupported) return;
    final audioSettings = ref.read(quranAudioSettingsProvider);
    if (!audioSettings.backgroundPlaybackEnabled) return;
    if (!_audioPlayer.playing && isPlayingOverride != true && !force) return;
    final surah = ref.read(quranSurahMapProvider)[ayah.surahNumber];
    final reciter = ref
        .read(quranAudioRepositoryProvider)
        .reciterById(audioSettings.reciterId);
    final elapsed = _audioPlayer.position.inSeconds.clamp(0, 24 * 60 * 60);
    final total = (_audioPlayer.duration?.inSeconds ?? 0).clamp(
      0,
      24 * 60 * 60,
    );
    await QuranLiveActivityService().updatePlaybackCard(
      surahNumber: ayah.surahNumber,
      surahName: surah?.transliteratedName ?? 'Surah ${ayah.surahNumber}',
      surahArabicName: surah?.arabicName ?? '',
      ayahNumber: ayah.ayahNumber,
      reciterName: reciter.name,
      isPlaying: isPlayingOverride ?? _audioPlayer.playing,
      elapsedSeconds: elapsed,
      totalSeconds: total,
    );
  }

  Future<void> _endQuranLiveActivityIfEnabled() async {
    if (!_quranLiveActivitySupported) return;
    _quranLiveActivityAyah = null;
    await QuranLiveActivityService().endPlaybackCard();
  }

  GlobalKey _ayahKeyFor(int ayahNumber) {
    return _ayahItemKeys.putIfAbsent(ayahNumber, () => GlobalKey());
  }

  void _saveViewportReadingProgress() {
    final ayahNumber = _visibleAyahFromViewport();
    if (ayahNumber == null) return;
    ref
        .read(quranReadingProgressProvider.notifier)
        .touchLocation(surahNumber: widget.surahNumber, ayahNumber: ayahNumber);
  }

  int? _visibleAyahFromViewport() {
    if (_ayahItemKeys.isEmpty) return null;
    const targetY = 160.0;
    int? bestAyah;
    var bestDistance = double.infinity;

    for (final entry in _ayahItemKeys.entries) {
      final ayahNumber = entry.key;
      final context = entry.value.currentContext;
      if (context == null) continue;
      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      if (bottom < 0) continue;
      if (top <= targetY && bottom >= targetY) {
        return ayahNumber;
      }
      final distance = (top - targetY).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestAyah = ayahNumber;
      }
    }
    return bestAyah;
  }

  Future<void> _scrollToAyah(int ayahNumber, {int retries = 0}) async {
    final key = _ayahItemKeys[ayahNumber];
    final targetContext = key?.currentContext;
    if (targetContext == null) {
      if (retries > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        await _scrollToAyah(ayahNumber, retries: retries - 1);
      }
      return;
    }
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      alignment: 0.20,
    );
  }

  Future<void> _toggleSurahPlayback(List<QuranAyah> ayahs) async {
    if (_hasReachedEndOfSurahPlayback) {
      setState(() => _hasReachedEndOfSurahPlayback = false);
      await _startSurahPlayback(ayahs: ayahs, initialIndex: 0);
      return;
    }
    if (_isSurahPlaybackMode) {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
        _stopWordHighlight();
      } else {
        if (ayahs.isEmpty) return;
        final index = (_audioPlayer.currentIndex ?? 0).clamp(
          0,
          ayahs.length - 1,
        );
        await _startSurahPlayback(
          ayahs: ayahs,
          initialIndex: index,
          initialPosition: _audioPlayer.position,
        );
      }
      return;
    }
    if (ayahs.isEmpty) return;
    await _startSurahPlayback(ayahs: ayahs, initialIndex: 0);
  }

  Future<void> _startSurahPlaybackFromAyah(
    List<QuranAyah> ayahs,
    QuranAyah startAyah,
  ) async {
    if (ayahs.isEmpty || _isPreparingSurahPlayback) return;
    final targetIndex = ayahs.indexWhere(
      (item) =>
          item.surahNumber == startAyah.surahNumber &&
          item.ayahNumber == startAyah.ayahNumber,
    );
    if (targetIndex < 0) return;

    if (_isSurahPlaybackMode &&
        _surahPlaybackAyahs.length == ayahs.length &&
        _surahPlaybackAyahs.isNotEmpty &&
        _surahPlaybackAyahs.first.surahNumber == ayahs.first.surahNumber &&
        _audioPlayer.sequence.length == ayahs.length) {
      if (_audioPlayer.playing) {
        await _audioPlayer.seek(Duration.zero, index: targetIndex);
      } else {
        await _startSurahPlayback(ayahs: ayahs, initialIndex: targetIndex);
      }
      return;
    }

    await _startSurahPlayback(ayahs: ayahs, initialIndex: targetIndex);
  }

  QuranAyah? _currentAyahFromPlaybackKey(List<QuranAyah> ayahs) {
    final key = _currentlyPlayingAyahKey;
    if (key == null || key.isEmpty) return null;
    final parts = key.split(':');
    if (parts.length != 2) return null;
    final surah = int.tryParse(parts[0]);
    final ayah = int.tryParse(parts[1]);
    if (surah == null || ayah == null) return null;
    for (final item in ayahs) {
      if (item.surahNumber == surah && item.ayahNumber == ayah) {
        return item;
      }
    }
    return null;
  }

  Future<void> _startSurahPlayback({
    required List<QuranAyah> ayahs,
    required int initialIndex,
    Duration initialPosition = Duration.zero,
  }) async {
    if (ayahs.isEmpty) return;
    final sessionVersion = ++_playerSessionVersion;
    final safeInitialIndex = initialIndex.clamp(0, ayahs.length - 1);
    setState(() => _isPreparingSurahPlayback = true);
    try {
      final audioSettings = ref.read(quranAudioSettingsProvider);
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final audioRepository = ref.read(quranAudioRepositoryProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: audioSettings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      final selectedReciter = audioRepository.reciterById(
        audioSettings.reciterId,
      );
      _isSwitchingAyahSource = true;
      await _playOpeningBismillah(
        reciterId: audioSettings.reciterId,
        playbackSpeed: playbackSpeed,
        sessionVersion: sessionVersion,
      );
      if (sessionVersion != _playerSessionVersion) return;
      final sources = <AudioSource>[];
      for (final ayah in ayahs) {
        final source = await audioRepository.resolveAyahSource(
          reciterId: audioSettings.reciterId,
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
        );
        final tag = _mediaItemForAyah(
          ayah: ayah,
          reciterName: selectedReciter.name,
          includeTag: audioSettings.backgroundPlaybackEnabled,
        );
        if (source.startsWith('/')) {
          sources.add(AudioSource.file(source, tag: tag));
        } else {
          sources.add(AudioSource.uri(Uri.parse(source), tag: tag));
        }
      }
      if (sessionVersion != _playerSessionVersion) return;
      await _audioPlayer.stop();
      await _audioPlayer.setSpeed(playbackSpeed);
      await _audioPlayer.setAudioSources(
        sources,
        initialIndex: safeInitialIndex,
      );
      if (initialPosition > Duration.zero) {
        await _audioPlayer.seek(initialPosition, index: safeInitialIndex);
      }
      final first = ayahs[safeInitialIndex];
      if (mounted) {
        setState(() {
          _isSurahPlaybackMode = true;
          _surahPlaybackAyahs = ayahs;
          _currentlyPlayingAyahKey = '${first.surahNumber}:${first.ayahNumber}';
          _hasReachedEndOfSurahPlayback = false;
        });
      }
      _quranLiveActivityAyah = first;
      _lastSentLiveElapsedSecond = -1;
      _scrollToAyah(first.ayahNumber);
      _syncWordHighlightForCurrentTrack(first);
      await _updateQuranLiveActivity(ayah: first, force: true);
      if (sessionVersion != _playerSessionVersion) return;
      unawaited(_audioPlayer.play());
    } finally {
      _isSwitchingAyahSource = false;
      if (mounted) {
        setState(() => _isPreparingSurahPlayback = false);
      }
    }
  }

  void _closeSurahPlaybackPlayer() {
    _playerSessionVersion += 1;
    _stopWordHighlight();
    unawaited(_audioPlayer.stop());
    unawaited(_endQuranLiveActivityIfEnabled());
    if (!mounted) return;
    setState(() {
      _isSurahPlaybackMode = false;
      _isPreparingSurahPlayback = false;
      _isLoopRunning = false;
      _hasReachedEndOfSurahPlayback = false;
      _currentlyPlayingAyahKey = null;
      _surahPlaybackAyahs = const [];
      _currentWordIndex = null;
      _quranLiveActivityAyah = null;
    });
  }

  void _saveCurrentRecitationSession({bool preferTrackEnd = false}) {
    if (!_isSurahPlaybackMode || _surahPlaybackAyahs.isEmpty) return;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    if (currentIndex < 0 || currentIndex >= _surahPlaybackAyahs.length) return;
    final ayah = _surahPlaybackAyahs[currentIndex];
    final sourcePosition = preferTrackEnd
        ? (_audioPlayer.duration ?? _audioPlayer.position)
        : _audioPlayer.position;
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: ayah.surahNumber,
          ayahNumber: ayah.ayahNumber,
          positionSeconds: sourcePosition.inSeconds,
        );
  }

  Future<void> _resumeRecitationSession(
    QuranRecitationSession session,
    List<QuranAyah> ayahs,
  ) async {
    if (ayahs.isEmpty || _isPreparingSurahPlayback) return;
    final targetIndex = ayahs.indexWhere(
      (item) => item.ayahNumber == session.ayahNumber,
    );
    final safeIndex = targetIndex < 0 ? 0 : targetIndex;
    await _startSurahPlayback(
      ayahs: ayahs,
      initialIndex: safeIndex,
      initialPosition: safeIndex == 0 && targetIndex < 0
          ? Duration.zero
          : Duration(seconds: session.positionSeconds),
    );
  }

  Future<void> _seekRelative(Duration delta) async {
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    final trackDuration = _audioPlayer.duration ?? Duration.zero;
    final currentPosition = _audioPlayer.position;
    var target = currentPosition + delta;

    if (!_isSurahPlaybackMode) {
      if (target < Duration.zero) target = Duration.zero;
      if (trackDuration > Duration.zero && target > trackDuration) {
        target = trackDuration;
      }
      await _audioPlayer.seek(target);
      return;
    }

    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < _surahPlaybackAyahs.length - 1;

    if (target < Duration.zero && hasPrev) {
      final previousIndex = currentIndex - 1;
      await _audioPlayer.seek(Duration.zero, index: previousIndex);
      return;
    }

    if (trackDuration > Duration.zero && target > trackDuration && hasNext) {
      final nextIndex = currentIndex + 1;
      await _audioPlayer.seek(Duration.zero, index: nextIndex);
      return;
    }

    if (target < Duration.zero) target = Duration.zero;
    if (trackDuration > Duration.zero && target > trackDuration) {
      target = trackDuration;
    }
    await _audioPlayer.seek(target, index: currentIndex);
  }

  Duration _surahPlaybackTotalDuration() {
    if (!_isSurahPlaybackMode) {
      return _audioPlayer.duration ?? Duration.zero;
    }
    final sequence = _audioPlayer.sequence;
    if (sequence.isEmpty) return Duration.zero;
    var totalMs = 0;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    for (var i = 0; i < sequence.length; i += 1) {
      final duration =
          sequence[i].duration ??
          (i == currentIndex ? _audioPlayer.duration : null) ??
          Duration.zero;
      totalMs += duration.inMilliseconds;
    }
    return Duration(milliseconds: totalMs);
  }

  Duration _surahPlaybackAbsolutePosition() {
    if (!_isSurahPlaybackMode) {
      return _audioPlayer.position;
    }
    final sequence = _audioPlayer.sequence;
    final currentIndex = _audioPlayer.currentIndex ?? 0;
    if (sequence.isEmpty) return _audioPlayer.position;
    var elapsedMs = 0;
    for (var i = 0; i < currentIndex && i < sequence.length; i += 1) {
      elapsedMs += (sequence[i].duration ?? Duration.zero).inMilliseconds;
    }
    elapsedMs += _audioPlayer.position.inMilliseconds;
    return Duration(milliseconds: elapsedMs);
  }

  Future<void> _seekSurahAbsolute(Duration target) async {
    if (!_isSurahPlaybackMode) {
      await _audioPlayer.seek(target);
      return;
    }
    final sequence = _audioPlayer.sequence;
    if (sequence.isEmpty) return;
    var remainingMs = target.inMilliseconds;
    for (var i = 0; i < sequence.length; i += 1) {
      final itemDuration =
          sequence[i].duration ??
          (i == (_audioPlayer.currentIndex ?? 0)
              ? _audioPlayer.duration
              : null) ??
          Duration.zero;
      final itemMs = itemDuration.inMilliseconds;
      if (remainingMs <= itemMs || i == sequence.length - 1) {
        final positionMs = remainingMs.clamp(0, itemMs);
        await _audioPlayer.seek(Duration(milliseconds: positionMs), index: i);
        return;
      }
      remainingMs -= itemMs;
    }
  }

  String _formatPosition(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = value.inHours;
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _syncWordHighlightForCurrentTrack(QuranAyah ayah) async {
    final readerSettings = ref.read(quranReaderSettingsProvider);
    if (!readerSettings.wordSyncHighlightBeta) {
      _stopWordHighlight();
      return;
    }
    final requestId = ++_wordHighlightSyncRequestId;
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final repository = ref.read(quranWordTimingRepositoryProvider);
    try {
      final preciseSegments = await repository.getAyahWordTimings(
        reciterId: audioSettings.reciterId,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
      if (!mounted || requestId != _wordHighlightSyncRequestId) return;
      _startWordHighlight(
        ayah.arabic,
        _audioPlayer.duration,
        preciseSegments: preciseSegments,
      );
    } catch (_) {
      if (!mounted || requestId != _wordHighlightSyncRequestId) return;
      _startWordHighlight(ayah.arabic, _audioPlayer.duration);
    }
  }

  Future<void> _playAyahAudio(
    QuranAyah ayah, {
    bool includeOpeningBismillah = false,
    bool startNewSession = true,
  }) async {
    final sessionVersion = startNewSession
        ? ++_playerSessionVersion
        : _playerSessionVersion;
    final settings = ref.read(quranAudioSettingsProvider);
    final readerSettings = ref.read(quranReaderSettingsProvider);
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    Future<List<QuranWordTimingSegment>> preciseSegmentsFuture =
        Future<List<QuranWordTimingSegment>>.value(const []);
    if (readerSettings.wordSyncHighlightBeta) {
      final wordTimingRepository = ref.read(quranWordTimingRepositoryProvider);
      preciseSegmentsFuture = wordTimingRepository.getAyahWordTimings(
        reciterId: settings.reciterId,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
    }
    _isSwitchingAyahSource = true;
    try {
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: settings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      if (includeOpeningBismillah) {
        await _playOpeningBismillah(
          reciterId: settings.reciterId,
          playbackSpeed: playbackSpeed,
          sessionVersion: sessionVersion,
        );
      }
      if (sessionVersion != _playerSessionVersion) return;
      final source = await audioRepository.resolveAyahSource(
        reciterId: settings.reciterId,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
      final selectedReciter = audioRepository.reciterById(settings.reciterId);
      final tag = _mediaItemForAyah(
        ayah: ayah,
        reciterName: selectedReciter.name,
        includeTag: settings.backgroundPlaybackEnabled,
      );
      await _audioPlayer.stop();
      if (mounted) {
        setState(
          () => _currentlyPlayingAyahKey =
              '${ayah.surahNumber}:${ayah.ayahNumber}',
        );
      }
      _quranLiveActivityAyah = ayah;
      _lastSentLiveElapsedSecond = -1;
      await _audioPlayer.setSpeed(playbackSpeed);
      if (sessionVersion != _playerSessionVersion) return;
      final duration = source.startsWith('/')
          ? await _audioPlayer.setFilePath(source, tag: tag)
          : await _audioPlayer.setUrl(source, tag: tag);
      if (readerSettings.wordSyncHighlightBeta) {
        final preciseSegments = await preciseSegmentsFuture;
        _startWordHighlight(
          ayah.arabic,
          duration,
          preciseSegments: preciseSegments,
        );
      } else {
        _stopWordHighlight();
      }
      await _updateQuranLiveActivity(ayah: ayah, force: true);
      if (sessionVersion != _playerSessionVersion) return;
      unawaited(_audioPlayer.play());
    } finally {
      _isSwitchingAyahSource = false;
    }
  }

  Future<void> _playOpeningBismillah({
    required String reciterId,
    required double playbackSpeed,
    required int sessionVersion,
  }) async {
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    try {
      if (sessionVersion != _playerSessionVersion) return;
      final source = await audioRepository.resolveAyahSource(
        reciterId: reciterId,
        surahNumber: 1,
        ayahNumber: 1,
      );
      if (sessionVersion != _playerSessionVersion) return;
      await _audioPlayer.stop();
      await _audioPlayer.setSpeed(playbackSpeed);
      if (source.startsWith('/')) {
        await _audioPlayer.setFilePath(source);
      } else {
        await _audioPlayer.setUrl(source);
      }
      if (sessionVersion != _playerSessionVersion) return;
      await _audioPlayer.play();
      await _audioPlayer.processingStateStream.firstWhere(
        (state) =>
            state == ProcessingState.completed ||
            state == ProcessingState.idle ||
            sessionVersion != _playerSessionVersion,
      );
    } catch (_) {
      // Continue to main playback if bismillah pre-roll fails.
    }
  }

  Future<void> _playReciterSample({
    required BuildContext context,
    required String reciterId,
  }) async {
    try {
      final settings = ref.read(quranAudioSettingsProvider);
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final repository = ref.read(quranAudioRepositoryProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: settings.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      final sample = repository.sampleUri(reciterId).toString();
      final reciter = repository.reciterById(reciterId);
      await _audioPlayer.stop();
      _stopWordHighlight();
      if (mounted) {
        setState(() {
          _currentlyPlayingAyahKey = null;
          _currentWordIndex = null;
        });
      }
      _quranLiveActivityAyah = null;
      await _endQuranLiveActivityIfEnabled();
      await _audioPlayer.setSpeed(playbackSpeed);
      await _audioPlayer.setUrl(
        sample,
        tag: settings.backgroundPlaybackEnabled
            ? MediaItem(
                id: 'quran:sample:$reciterId',
                album: 'Path of Nur • Quran sample',
                title: 'Reciter sample',
                artist: reciter.name,
              )
            : null,
      );
      await _audioPlayer.play();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to play sample right now: $error')),
      );
    }
  }

  double _effectivePlaybackSpeed({
    required double configuredSpeed,
    required bool lockToWordSync,
  }) {
    return lockToWordSync ? 1.0 : configuredSpeed;
  }

  MediaItem? _mediaItemForAyah({
    required QuranAyah ayah,
    required String reciterName,
    required bool includeTag,
  }) {
    if (!includeTag) return null;
    final surah = ref.read(quranSurahMapProvider)[ayah.surahNumber];
    final surahLabel = surah?.transliteratedName ?? 'Surah ${ayah.surahNumber}';
    return MediaItem(
      id: 'quran:${ayah.surahNumber}:${ayah.ayahNumber}:$reciterName',
      album: 'Path of Nur • $surahLabel',
      title: '$surahLabel ${ayah.surahNumber}:${ayah.ayahNumber}',
      artist: reciterName,
    );
  }

  void _setWordSyncHighlightBeta(bool value) {
    ref
        .read(quranReaderSettingsProvider.notifier)
        .setWordSyncHighlightBeta(value);
    if (value) {
      ref.read(quranAudioSettingsProvider.notifier).setPlaybackSpeed(1.0);
    }
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final playbackSpeed = _effectivePlaybackSpeed(
      configuredSpeed: audioSettings.playbackSpeed,
      lockToWordSync: value,
    );
    unawaited(_audioPlayer.setSpeed(playbackSpeed));
  }

  void _setBackgroundPlaybackEnabled(bool value) {
    ref
        .read(quranAudioSettingsProvider.notifier)
        .setBackgroundPlaybackEnabled(value);
    if (!value) {
      unawaited(_endQuranLiveActivityIfEnabled());
    } else if (_quranLiveActivityAyah != null) {
      unawaited(
        _updateQuranLiveActivity(ayah: _quranLiveActivityAyah!, force: true),
      );
    }
    if (value) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final isForeground =
        lifecycle == null || lifecycle == AppLifecycleState.resumed;
    if (!isForeground && _audioPlayer.playing) {
      unawaited(_audioPlayer.pause());
    }
  }

  void _showSourcesInfoSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sources & Licensing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  _SourceLine(
                    title: 'Qur’an Arabic text (reader/search):',
                    value:
                        'package:quran (Flutter package), based on Quran data bundled in package.',
                  ),
                  _SourceLine(
                    title: 'Translations:',
                    value:
                        'package:quran translation set (e.g., Saheeh International, Clear Quran, Urdu, Bengali, Indonesian, Turkish, Dari).',
                  ),
                  _SourceLine(
                    title: 'Transliteration:',
                    value:
                        'AlQuran.cloud API (edition: en.transliteration) cached locally on device.',
                  ),
                  _SourceLine(
                    title: 'Audio recitations:',
                    value: 'EveryAyah CDN (Husary, Alafasy, Abdul Basit).',
                  ),
                  _SourceLine(
                    title: 'Word timing segments (live sync beta):',
                    value:
                        'Quran.com API v4 (api.quran.com), recitations by ayah with segments.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Attribution links',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  SelectableText('https://pub.dev/packages/quran'),
                  SelectableText('https://github.com/aqeelshamz/quran'),
                  SelectableText('https://alquran.cloud/api'),
                  SelectableText('https://everyayah.com/data/'),
                  SelectableText('https://api-docs.quran.com/'),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushNamed('attributionsLicenses');
                      },
                      icon: Icon(Icons.open_in_new_rounded),
                      label: Text('Open full Attributions & Licenses page'),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Note: verify production usage terms with each provider before public launch, especially audio redistribution rights.',
                    style: TextStyle(color: Color(0xFF6A5A4A), height: 1.35),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadCurrentSurah({
    required BuildContext context,
    required QuranAudioRepository repository,
    required String reciterId,
  }) async {
    setState(() {
      _isDownloadingSurah = true;
      _downloadedAyahs = 0;
      _downloadTotalAyahs = 0;
    });
    try {
      await repository.downloadSurah(
        reciterId: reciterId,
        surahNumber: widget.surahNumber,
        onProgress: (downloaded, total) {
          if (!mounted) return;
          setState(() {
            _downloadedAyahs = downloaded;
            _downloadTotalAyahs = total;
          });
        },
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Surah audio downloaded successfully.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingSurah = false;
        });
      }
    }
  }

  Future<void> _clearCurrentSurahDownload({
    required BuildContext context,
    required QuranAudioRepository repository,
    required String reciterId,
  }) async {
    await repository.clearSurahDownloads(
      reciterId: reciterId,
      surahNumber: widget.surahNumber,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloaded surah audio removed.')),
    );
    setState(() {});
  }

  Future<void> _onWordTap(
    BuildContext context,
    WidgetRef ref,
    QuranWordGloss word,
  ) async {
    final l10n = AppLocalizations.of(context);
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
                  style: AppTextStyles.quranVerse(
                    size: 36,
                    weight: FontWeight.w700,
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
    final sessionVersion = ++_playerSessionVersion;
    setState(() => _isLoopRunning = true);
    try {
      final readerSettings = ref.read(quranReaderSettingsProvider);
      final playbackSpeed = _effectivePlaybackSpeed(
        configuredSpeed: audio.playbackSpeed,
        lockToWordSync: readerSettings.wordSyncHighlightBeta,
      );
      await _playOpeningBismillah(
        reciterId: audio.reciterId,
        playbackSpeed: playbackSpeed,
        sessionVersion: sessionVersion,
      );
      if (sessionVersion != _playerSessionVersion) return;
      for (var loop = 0; loop < audio.ayahLoopCount; loop += 1) {
        if (sessionVersion != _playerSessionVersion) return;
        for (final ayah in range) {
          if (sessionVersion != _playerSessionVersion) return;
          if (!mounted) return;
          await _playAyahAudio(ayah, startNewSession: false);
          await Future<void>.delayed(const Duration(milliseconds: 350));
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoopRunning = false;
          _currentlyPlayingAyahKey = null;
          _currentWordIndex = null;
        });
      }
    }
  }

  void _startWordHighlight(
    String arabicText,
    Duration? totalDuration, {
    List<QuranWordTimingSegment> preciseSegments = const [],
  }) {
    _wordHighlightTimer?.cancel();
    final words = _splitArabicWords(arabicText);
    if (words.isEmpty) {
      _currentWordIndex = null;
      return;
    }
    if (preciseSegments.isNotEmpty) {
      final stopwatch = Stopwatch()..start();
      setState(() => _currentWordIndex = preciseSegments.first.wordIndex);
      _wordHighlightTimer = Timer.periodic(const Duration(milliseconds: 50), (
        _,
      ) {
        if (!mounted) return;
        final elapsed = stopwatch.elapsedMilliseconds;
        var active = preciseSegments.last.wordIndex;
        for (final segment in preciseSegments) {
          if (elapsed < segment.startMs) {
            active = segment.wordIndex;
            break;
          }
          if (elapsed >= segment.startMs && elapsed <= segment.endMs) {
            active = segment.wordIndex;
            break;
          }
        }
        if (_currentWordIndex != active) {
          setState(() => _currentWordIndex = active);
        }
      });
      return;
    }
    if (totalDuration == null || totalDuration.inMilliseconds <= 0) {
      setState(() => _currentWordIndex = 0);
      return;
    }

    final totalMs = totalDuration.inMilliseconds;
    final weights = words
        .map((word) => _approxWordWeight(word))
        .toList(growable: false);
    final weightSum = weights
        .fold<int>(0, (sum, value) => sum + value)
        .clamp(1, 1000000);
    final cumulative = <int>[];
    var acc = 0;
    for (final w in weights) {
      acc += ((w / weightSum) * totalMs).round();
      cumulative.add(acc);
    }
    final stopwatch = Stopwatch()..start();
    setState(() => _currentWordIndex = 0);
    _wordHighlightTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      if (!mounted) return;
      final elapsed = stopwatch.elapsedMilliseconds;
      var index = 0;
      while (index < cumulative.length - 1 && elapsed > cumulative[index]) {
        index += 1;
      }
      if (_currentWordIndex != index) {
        setState(() => _currentWordIndex = index);
      }
    });
  }

  void _stopWordHighlight() {
    _wordHighlightTimer?.cancel();
    _wordHighlightTimer = null;
    if (_currentWordIndex != null && mounted) {
      setState(() => _currentWordIndex = null);
    } else {
      _currentWordIndex = null;
    }
  }

  List<String> _splitArabicWords(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
  }

  int _approxWordWeight(String word) {
    final normalized = word
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        .replaceAll('ـ', '');
    return normalized.isEmpty ? 1 : normalized.length.clamp(1, 14);
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

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8DA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.35)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6A5A4A),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SourceLine extends StatelessWidget {
  const _SourceLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF4A4036), height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _AyahContextLink {
  const _AyahContextLink({
    required this.title,
    required this.routeName,
    required this.pathParameters,
    this.queryParameters = const <String, String>{},
  });

  final String title;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class _ProphetMentionMatcher {
  const _ProphetMentionMatcher({
    required this.prophetId,
    required this.displayName,
    required this.keywords,
  });

  final String prophetId;
  final String displayName;
  final List<String> keywords;
}

class _LearningTopicMatcher {
  const _LearningTopicMatcher({required this.keywords, required this.link});

  final List<String> keywords;
  final _AyahContextLink link;
}

const _prophetMentionMatchers = <_ProphetMentionMatcher>[
  _ProphetMentionMatcher(
    prophetId: 'adam',
    displayName: 'Adam',
    keywords: ['adam'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'nuh',
    displayName: 'Nuh',
    keywords: ['noah', 'nuh'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'ibrahim',
    displayName: 'Ibrahim',
    keywords: ['abraham', 'ibrahim'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'ismail',
    displayName: 'Ismail',
    keywords: ['ishmael', 'ismail'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'ishaq',
    displayName: 'Ishaq',
    keywords: ['isaac', 'ishaq'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'yaqub',
    displayName: 'Yaqub',
    keywords: ['jacob', 'yaqub'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'yusuf',
    displayName: 'Yusuf',
    keywords: ['joseph', 'yusuf'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'musa',
    displayName: 'Musa',
    keywords: ['moses', 'musa'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'harun',
    displayName: 'Harun',
    keywords: ['aaron', 'harun'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'dawud',
    displayName: 'Dawud',
    keywords: ['david', 'dawud'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'sulayman',
    displayName: 'Sulayman',
    keywords: ['solomon', 'sulayman'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'yunus',
    displayName: 'Yunus',
    keywords: ['jonah', 'yunus'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'ayyub',
    displayName: 'Ayyub',
    keywords: ['job', 'ayyub'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'zakariya',
    displayName: 'Zakariya',
    keywords: ['zechariah', 'zakariya'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'yahya',
    displayName: 'Yahya',
    keywords: ['john', 'yahya'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'isa',
    displayName: 'Isa',
    keywords: ['jesus', 'isa'],
  ),
  _ProphetMentionMatcher(
    prophetId: 'muhammad',
    displayName: 'Muhammad',
    keywords: ['muhammad', 'messenger'],
  ),
];

const _learningTopicMatchers = <_LearningTopicMatcher>[
  _LearningTopicMatcher(
    keywords: ['bee', 'bees'],
    link: _AyahContextLink(
      title: 'World: Bees',
      routeName: 'worldLessonDetail',
      pathParameters: {'lessonId': 'animals-bee-order-benefit'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['rain', 'water'],
    link: _AyahContextLink(
      title: 'World: Rain & Revival',
      routeName: 'worldLessonDetail',
      pathParameters: {'lessonId': 'water-rain-mercy-revival'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['mountain', 'mountains'],
    link: _AyahContextLink(
      title: 'World: Mountains',
      routeName: 'worldLessonDetail',
      pathParameters: {'lessonId': 'earth-mountains-stability-reflection'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['night', 'day'],
    link: _AyahContextLink(
      title: 'World: Night & Day',
      routeName: 'worldLessonDetail',
      pathParameters: {'lessonId': 'time-night-day-alternation'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['parent', 'parents', 'mother', 'father'],
    link: _AyahContextLink(
      title: 'Life: Honoring Parents',
      routeName: 'lifeLessonDetail',
      pathParameters: {'lessonId': 'family-parents-honor-care'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['spouse', 'spouses', 'marriage', 'wife', 'husband'],
    link: _AyahContextLink(
      title: 'Life: Marriage & Mercy',
      routeName: 'lifeLessonDetail',
      pathParameters: {'lessonId': 'family-marriage-mercy'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['grateful', 'gratitude', 'thankful', 'thanks'],
    link: _AyahContextLink(
      title: 'Life: Gratitude',
      routeName: 'lifeLessonDetail',
      pathParameters: {'lessonId': 'gratitude-daily-awareness'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['patient', 'patience', 'persevere'],
    link: _AyahContextLink(
      title: 'Hadith: Sabr with Purpose',
      routeName: 'hadithLessonDetail',
      pathParameters: {'lessonId': 'hardship-sabr-with-purpose'},
    ),
  ),
  _LearningTopicMatcher(
    keywords: ['neighbor', 'neighbour', 'neighbors', 'neighbours'],
    link: _AyahContextLink(
      title: 'Hadith: Rights of Neighbors',
      routeName: 'hadithLessonDetail',
      pathParameters: {'lessonId': 'mercy-rights-of-neighbors'},
    ),
  ),
];

class _AyahCard extends StatefulWidget {
  const _AyahCard({
    required this.ayah,
    required this.isHighlighted,
    required this.isNowPlaying,
    required this.activeWordIndex,
    required this.isBookmarked,
    required this.notesCount,
    required this.onBookmark,
    required this.onAddNote,
    required this.showTranslation,
    required this.showTransliteration,
    required this.showWordByWord,
    required this.showActions,
    required this.hifzRevealMode,
    required this.arabicFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    required this.harakatColor,
    required this.contextualLinks,
    required this.onTap,
    required this.onPlayAyah,
    required this.onPlayWord,
    required this.onMistakeCheckpoint,
  });

  final QuranAyah ayah;
  final bool isHighlighted;
  final bool isNowPlaying;
  final int? activeWordIndex;
  final bool isBookmarked;
  final int notesCount;
  final VoidCallback onBookmark;
  final VoidCallback onAddNote;
  final bool showTranslation;
  final bool showTransliteration;
  final bool showWordByWord;
  final bool showActions;
  final HifzRevealMode hifzRevealMode;
  final double arabicFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final Color? harakatColor;
  final List<_AyahContextLink> contextualLinks;
  final VoidCallback onTap;
  final VoidCallback onPlayAyah;
  final Future<void> Function(QuranWordGloss word) onPlayWord;
  final VoidCallback onMistakeCheckpoint;

  @override
  State<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<_AyahCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final arabicWordCount = widget.ayah.arabic
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: AnimatedContainer(
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
                        color: AppColors.accentGold.withValues(alpha: 0.25),
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
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    final visibleArabic = _displayArabicForHifz(
                      widget.ayah.arabic,
                      widget.hifzRevealMode,
                    );
                    final style =
                        AppTextStyles.quranVerse(
                          size: widget.arabicFontSize + 4,
                          color: const Color(0xFF1F1B17),
                        ).copyWith(
                          height: 1.9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        );
                    final canWordHighlight =
                        widget.hifzRevealMode == HifzRevealMode.full &&
                        widget.activeWordIndex != null;

                    return Text.rich(
                      canWordHighlight
                          ? _buildWordSyncedArabicSpan(
                              visibleArabic,
                              style,
                              widget.activeWordIndex!,
                              widget.harakatColor,
                            )
                          : buildQuranTextWithColoredHarakat(
                              visibleArabic,
                              style,
                              harakatColor: widget.harakatColor,
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
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF6A5A4A),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    'Translation: ${word.gloss}',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF5A4A3A),
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
                          : 'Transliteration not available for this ayah yet.',
                      baseStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF6A5A4A),
                        height: 1.6,
                        fontSize: widget.transliterationFontSize,
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                    ),
                  ),
                ],
                if (widget.showTranslation) ...[
                  const SizedBox(height: 8),
                  Text.rich(
                    _buildFollowTextSpan(
                      text: widget.ayah.translation,
                      baseStyle: TextStyle(
                        height: 1.5,
                        fontSize: widget.translationFontSize,
                        color: const Color(0xFF403429),
                      ),
                      sourceWordCount: arabicWordCount,
                      activeSourceIndex: widget.activeWordIndex,
                    ),
                  ),
                ],
                if (widget.contextualLinks.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Learn more',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.contextualLinks
                        .map(
                          (link) => ActionChip(
                            label: Text(link.title),
                            onPressed: () => context.pushNamed(
                              link.routeName,
                              pathParameters: link.pathParameters,
                              queryParameters: link.queryParameters,
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
  String arabic,
  TextStyle baseStyle,
  int activeWordIndex,
  Color? harakatColor,
) {
  final words = arabic
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return buildQuranTextWithColoredHarakat(
      arabic,
      baseStyle,
      harakatColor: harakatColor,
    );
  }

  final children = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == activeWordIndex;
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B),
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.80),
            shadows: [
              Shadow(
                color: const Color(0xFFC8A85A).withValues(alpha: 0.40),
                blurRadius: 7,
                offset: const Offset(0, 0.6),
              ),
            ],
          )
        : baseStyle;
    children.add(
      buildQuranTextWithColoredHarakat(
        words[i],
        style,
        harakatColor: harakatColor,
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
  required TextStyle baseStyle,
  required int sourceWordCount,
  required int? activeSourceIndex,
}) {
  final words = text
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty ||
      activeSourceIndex == null ||
      sourceWordCount <= 0 ||
      words.length <= 1) {
    return TextSpan(text: text, style: baseStyle);
  }

  final mappedIndex = _mapActiveIndex(
    sourceIndex: activeSourceIndex,
    sourceCount: sourceWordCount,
    targetCount: words.length,
  );

  final spans = <InlineSpan>[];
  for (var i = 0; i < words.length; i += 1) {
    final isActive = i == mappedIndex;
    final style = isActive
        ? baseStyle.copyWith(
            color: const Color(0xFF2F8F5B),
            fontWeight: FontWeight.w700,
            backgroundColor: const Color(0xFFE8D69B).withValues(alpha: 0.35),
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
  const _KnowledgeLinkWrap({required this.title, required this.items});

  final String title;
  final List<QuranRelatedKnowledgeLink> items;

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
              .take(5)
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
              .toList(growable: false),
        ),
      ],
    );
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
