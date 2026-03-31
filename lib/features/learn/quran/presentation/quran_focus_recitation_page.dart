import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../../../../shared/widgets/quran_text_span.dart';
import '../application/quran_focus_recitation_mode.dart';
import '../application/quran_player_controller.dart';
import '../application/quran_providers.dart';
import '../application/quran_reader_playback_controller.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_audio_resilience_models.dart';
import 'quran_reader_playback_presentation.dart';

class QuranFocusRecitationPage extends ConsumerStatefulWidget {
  const QuranFocusRecitationPage({
    super.key,
    this.initialSurahNumber,
    this.initialAyahNumber,
  });

  final int? initialSurahNumber;
  final int? initialAyahNumber;

  @override
  ConsumerState<QuranFocusRecitationPage> createState() =>
      _QuranFocusRecitationPageState();
}

class _QuranFocusRecitationPageState
    extends ConsumerState<QuranFocusRecitationPage> {
  bool _wakeLockEnabled = false;
  late final QuranFocusRecitationSessionController _focusSessionNotifier;
  late final QuranFocusRecitationSleepTimerController _sleepTimerNotifier;
  late final QuranFocusRecitationWakeLock _wakeLockService;

  @override
  void initState() {
    super.initState();
    _focusSessionNotifier = ref.read(quranFocusRecitationSessionProvider.notifier);
    _sleepTimerNotifier = ref.read(quranFocusRecitationSleepTimerProvider.notifier);
    _wakeLockService = ref.read(quranFocusRecitationWakeLockProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        _syncWakeLock(
          ref.read(quranReaderSettingsProvider).focusRecitationKeepScreenAwake,
        ),
      );
    });
  }

  @override
  void dispose() {
    _sleepTimerNotifier.clear();
    unawaited(_focusSessionNotifier.clearForExit());
    unawaited(_syncWakeLock(false));
    super.dispose();
  }

  Future<void> _syncWakeLock(bool enabled) async {
    if (_wakeLockEnabled == enabled) {
      return;
    }
    _wakeLockEnabled = enabled;
    await _wakeLockService.setEnabled(enabled);
  }

  Future<void> _showFocusRecitationSettings({
    required BuildContext context,
    required int? activeSurahNumber,
    required int? activeAyahNumber,
  }) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, child) {
            final settings = ref.watch(quranReaderSettingsProvider);
            final session = ref.watch(quranFocusRecitationSessionProvider);
            final sleepTimer = ref.watch(quranFocusRecitationSleepTimerProvider);
            final settingsNotifier = ref.read(
              quranReaderSettingsProvider.notifier,
            );
            final sessionNotifier = ref.read(
              quranFocusRecitationSessionProvider.notifier,
            );
            final sleepTimerNotifier = ref.read(
              quranFocusRecitationSleepTimerProvider.notifier,
            );

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Material(
                  color: AppColors.surface,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quranFocusRecitationDisplaySettingsTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('quran-focus-toggle-translation'),
                          contentPadding: EdgeInsets.zero,
                          value: settings.focusRecitationShowTranslation,
                          title: Text(l10n.quranShowTranslation),
                          onChanged:
                              settingsNotifier.setFocusRecitationShowTranslation,
                        ),
                        SwitchListTile.adaptive(
                          key: const ValueKey(
                            'quran-focus-toggle-transliteration',
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: settings.focusRecitationShowTransliteration,
                          title: Text(l10n.quranShowTransliteration),
                          onChanged: settingsNotifier
                              .setFocusRecitationShowTransliteration,
                        ),
                        SwitchListTile.adaptive(
                          key: const ValueKey(
                            'quran-focus-toggle-keep-screen-awake',
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: settings.focusRecitationKeepScreenAwake,
                          title: Text(
                            l10n.quranFocusRecitationKeepScreenAwakeAction,
                          ),
                          onChanged:
                              settingsNotifier.setFocusRecitationKeepScreenAwake,
                        ),
                        SwitchListTile.adaptive(
                          key: const ValueKey(
                            'quran-focus-toggle-repeat-current-ayah',
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: session.repeatCurrentAyah,
                          title: Text(
                            l10n.quranFocusRecitationRepeatCurrentAyahAction,
                          ),
                          onChanged: (value) {
                            unawaited(
                              sessionNotifier.setRepeatCurrentAyah(value),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.quranFocusRecitationSleepTimerAction,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final minutes in const [5, 10, 15, 30])
                              ChoiceChip(
                                key: ValueKey(
                                  'quran-focus-sleep-timer-$minutes',
                                ),
                                selected:
                                    sleepTimer.isActive &&
                                    sleepTimer.durationSeconds ==
                                        minutes * Duration.secondsPerMinute,
                                label: Text(
                                  l10n.quranFocusRecitationSleepTimerMinutesLabel(
                                    minutes,
                                  ),
                                ),
                                onSelected: (_) {
                                  sleepTimerNotifier.setDurationMinutes(minutes);
                                },
                              ),
                            if (sleepTimer.isActive)
                              ActionChip(
                                key: const ValueKey(
                                  'quran-focus-cancel-sleep-timer',
                                ),
                                label: Text(
                                  l10n
                                      .quranFocusRecitationSleepTimerCancelAction,
                                ),
                                onPressed: sleepTimerNotifier.clear,
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ListTile(
                          key: const ValueKey(
                            'quran-focus-open-memorization-review',
                          ),
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.repeat_rounded),
                          title: Text(l10n.quranMemorizationReviewTitle),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            final router = GoRouter.of(context);
                            router.pushNamed('quranMemorizationReview');
                          },
                        ),
                        if (activeSurahNumber != null)
                          ListTile(
                            key: const ValueKey('quran-focus-open-reader'),
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.menu_book_rounded),
                            title: Text(l10n.shellQuranMiniPlayerOpenReaderAction),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              final router = GoRouter.of(context);
                              router.pushNamed(
                                'quranReader',
                                pathParameters: <String, String>{
                                  'surahNumber': activeSurahNumber.toString(),
                                },
                                queryParameters: activeAyahNumber == null
                                    ? const <String, String>{}
                                    : <String, String>{
                                        'ayah': activeAyahNumber.toString(),
                                      },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen<QuranReaderSettings>(
      quranReaderSettingsProvider.select((value) => value),
      (previous, next) {
        if (previous?.focusRecitationKeepScreenAwake !=
            next.focusRecitationKeepScreenAwake) {
          unawaited(_syncWakeLock(next.focusRecitationKeepScreenAwake));
        }
      },
    );

    final playbackState = ref.watch(quranGlobalPlaybackStateProvider);
    final settings = ref.watch(quranReaderSettingsProvider);
    final focusSession = ref.watch(quranFocusRecitationSessionProvider);
    final sleepTimer = ref.watch(quranFocusRecitationSleepTimerProvider);
    final controller = ref.read(quranPlayerControllerProvider);
    final surahNumber =
        playbackState.activeSurahNumber ??
        playbackState.storedSession?.surahNumber ??
        widget.initialSurahNumber;
    final ayahNumber =
        playbackState.activeAyahNumber ??
        playbackState.storedSession?.ayahNumber ??
        widget.initialAyahNumber;
    final surah = surahNumber == null
        ? null
        : ref.watch(quranSurahMapProvider)[surahNumber];
    final ayahsAsync = surahNumber == null
        ? const AsyncValue<List<QuranAyah>>.data(<QuranAyah>[])
        : ref.watch(quranSurahAyahsProvider(surahNumber));
    final ayah = _resolveAyah(ayahsAsync.valueOrNull, ayahNumber);
    final sourceStatusLabel = buildQuranPlaybackSourceStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    final isPreparing =
        playbackState.isLoading ||
        playbackState.isBuffering ||
        playbackState.sourceResolutionState ==
            QuranPlaybackSourceResolutionState.preparingTransition;

    return Scaffold(
      key: const ValueKey('quran-focus-recitation-page'),
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFF8F2E8),
              Color(0xFFEDE3D6),
            ],
          ),
        ),
        child: SafeArea(
          child: ayah == null || surah == null
              ? _FocusRecitationEmptyState(
                  l10n: l10n,
                  onExit: () => Navigator.of(context).maybePop(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: _FocusRecitationHeader(
                        l10n: l10n,
                        surahNumber: surah.number,
                        surahName: surah.transliteratedName,
                        surahArabicName: surah.arabicName,
                        ayahNumber: ayah.ayahNumber,
                        reciterName: playbackState.reciterName,
                        repeatCurrentAyah: focusSession.repeatCurrentAyah,
                        activeSleepTimerLabel: sleepTimer.isActive
                            ? l10n.quranFocusRecitationSleepTimerActiveLabel(
                                _formatDurationLabel(
                                  sleepTimer.remainingDuration,
                                ),
                              )
                            : null,
                        onExit: () => Navigator.of(context).maybePop(),
                        onOpenSettings: () => _showFocusRecitationSettings(
                          context: context,
                          activeSurahNumber: surah.number,
                          activeAyahNumber: ayah.ayahNumber,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final slide = Tween<Offset>(
                              begin: const Offset(0, 0.015),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                          child: _FocusRecitationAyahView(
                            key: ValueKey<String>(
                              '${ayah.surahNumber}:${ayah.ayahNumber}:'
                              '${settings.focusRecitationShowTranslation}:'
                              '${settings.focusRecitationShowTransliteration}',
                            ),
                            ayah: ayah,
                            showTranslation:
                                settings.focusRecitationShowTranslation,
                            showTransliteration:
                                settings.focusRecitationShowTransliteration,
                            arabicScale: settings.arabicScalePercent / 100.0,
                            translationScale:
                                settings.translationScalePercent / 100.0,
                            transliterationScale:
                                settings.transliterationScalePercent / 100.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: _FocusRecitationControls(
                        l10n: l10n,
                        sourceStatusLabel: sourceStatusLabel,
                        isPreparing: isPreparing,
                        isPlaying: playbackState.isPlaying,
                        canPlay: playbackState.canPlay,
                        canPause: playbackState.canPause,
                        canGoPreviousAyah: playbackState.canGoPreviousAyah,
                        canGoNextAyah: playbackState.canGoNextAyah,
                        showRetryAction: playbackState.hasRecoverableFailure,
                        onPreviousAyah: playbackState.canGoPreviousAyah
                            ? () => unawaited(controller.playRelativeAyah(-1))
                            : null,
                        onTogglePlayback: () {
                          if (playbackState.hasRecoverableFailure) {
                            unawaited(controller.retryCurrentPlayback());
                          } else if (playbackState.canPause) {
                            unawaited(controller.pause());
                          } else if (playbackState.canPlay) {
                            unawaited(controller.resumeCurrentPlayback());
                          }
                        },
                        onNextAyah: playbackState.canGoNextAyah
                            ? () => unawaited(controller.playRelativeAyah(1))
                            : null,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

QuranAyah? _resolveAyah(List<QuranAyah>? ayahs, int? ayahNumber) {
  if (ayahs == null || ayahNumber == null) {
    return null;
  }
  for (final ayah in ayahs) {
    if (ayah.ayahNumber == ayahNumber) {
      return ayah;
    }
  }
  return null;
}

String _formatDurationLabel(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class _FocusRecitationHeader extends StatelessWidget {
  const _FocusRecitationHeader({
    required this.l10n,
    required this.surahNumber,
    required this.surahName,
    required this.surahArabicName,
    required this.ayahNumber,
    required this.reciterName,
    required this.repeatCurrentAyah,
    required this.activeSleepTimerLabel,
    required this.onExit,
    required this.onOpenSettings,
  });

  final AppLocalizations l10n;
  final int surahNumber;
  final String surahName;
  final String surahArabicName;
  final int ayahNumber;
  final String reciterName;
  final bool repeatCurrentAyah;
  final String? activeSleepTimerLabel;
  final VoidCallback onExit;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: const ValueKey('quran-focus-exit'),
          tooltip: l10n.accessibilityClosePlayer,
          onPressed: onExit,
          icon: const Icon(Icons.close_rounded),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                surahName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$surahArabicName • ${l10n.quranReferenceViewerReferenceLabel('$surahNumber:$ayahNumber')}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reciterName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              if (repeatCurrentAyah || activeSleepTimerLabel != null) ...[
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (repeatCurrentAyah)
                      _FocusStatusChip(
                        key: const ValueKey('quran-focus-repeat-chip'),
                        label: l10n.quranFocusRecitationRepeatCurrentAyahAction,
                        icon: Icons.repeat_one_rounded,
                      ),
                    if (activeSleepTimerLabel != null)
                      _FocusStatusChip(
                        key: const ValueKey('quran-focus-sleep-timer-chip'),
                        label: activeSleepTimerLabel!,
                        icon: Icons.bedtime_rounded,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        IconButton(
          key: const ValueKey('quran-focus-settings'),
          tooltip: l10n.quranFocusRecitationDisplaySettingsTitle,
          onPressed: onOpenSettings,
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}

class _FocusStatusChip extends StatelessWidget {
  const _FocusStatusChip({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFFCCB79D).withValues(alpha: 0.8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6A5A4A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF6A5A4A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusRecitationAyahView extends StatelessWidget {
  const _FocusRecitationAyahView({
    super.key,
    required this.ayah,
    required this.showTranslation,
    required this.showTransliteration,
    required this.arabicScale,
    required this.translationScale,
    required this.transliterationScale,
  });

  final QuranAyah ayah;
  final bool showTranslation;
  final bool showTransliteration;
  final double arabicScale;
  final double translationScale;
  final double transliterationScale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = math.min(constraints.maxWidth, 720.0);
        final arabicLength = ayah.arabic.runes.length;
        final secondaryVisible = showTranslation || showTransliteration;
        final arabicBaseSize = arabicLength > 190
            ? 28.0
            : arabicLength > 120
                ? 31.0
                : 36.0;
        final arabicStyle = QuranPresentationStyle.translucentTextStyle(
          context,
          AppTextStyles.quranVerse(size: arabicBaseSize * arabicScale).copyWith(
            height: arabicLength > 150 ? 1.72 : 1.85,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.28,
          ),
        );
        final translationStyle = QuranPresentationStyle.quranSupportTextStyle(
          context,
          Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18 * translationScale,
                height: 1.5,
              ) ??
              TextStyle(fontSize: 18 * translationScale, height: 1.5),
        );
        final transliterationStyle =
            QuranPresentationStyle.quranSupportTextStyle(
              context,
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18 * transliterationScale,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ) ??
                  TextStyle(
                    fontSize: 18 * transliterationScale,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
              italic: true,
            );

        return Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            key: const ValueKey('quran-focus-recitation-scroll'),
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: math.max(0, (constraints.maxWidth - maxContentWidth) / 2),
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
                maxWidth: maxContentWidth,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      key: const ValueKey('quran-focus-arabic'),
                      buildQuranTextWithColoredHarakat(
                        ayah.arabic,
                        arabicStyle,
                        harakatColor:
                            QuranPresentationStyle.translucentHarakatColor(
                              context,
                            ),
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    if (showTransliteration &&
                        (ayah.transliteration ?? '').trim().isNotEmpty) ...[
                      SizedBox(height: secondaryVisible ? 22 : 18),
                      Text(
                        ayah.transliteration!.trim(),
                        key: const ValueKey('quran-focus-transliteration'),
                        textAlign: TextAlign.center,
                        style: transliterationStyle,
                      ),
                    ],
                    if (showTranslation) ...[
                      SizedBox(
                        height: showTransliteration && secondaryVisible ? 18 : 20,
                      ),
                      Text(
                        ayah.translation,
                        key: const ValueKey('quran-focus-translation'),
                        textAlign: TextAlign.center,
                        style: translationStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FocusRecitationControls extends StatelessWidget {
  const _FocusRecitationControls({
    required this.l10n,
    required this.sourceStatusLabel,
    required this.isPreparing,
    required this.isPlaying,
    required this.canPlay,
    required this.canPause,
    required this.canGoPreviousAyah,
    required this.canGoNextAyah,
    required this.showRetryAction,
    required this.onPreviousAyah,
    required this.onTogglePlayback,
    required this.onNextAyah,
  });

  final AppLocalizations l10n;
  final String? sourceStatusLabel;
  final bool isPreparing;
  final bool isPlaying;
  final bool canPlay;
  final bool canPause;
  final bool canGoPreviousAyah;
  final bool canGoNextAyah;
  final bool showRetryAction;
  final VoidCallback? onPreviousAyah;
  final VoidCallback onTogglePlayback;
  final VoidCallback? onNextAyah;

  @override
  Widget build(BuildContext context) {
    final surfaceStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: const Color(0xFFDABE8D),
      surfaceAlphaOverride: 0.62,
    );
    final contentColors = AppSurfaceTheme.contentColors(context);
    final primaryIcon = showRetryAction
        ? Icons.refresh_rounded
        : isPreparing
            ? Icons.hourglass_top_rounded
            : isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded;
    final primaryEnabled = showRetryAction || canPause || canPlay;
    return DecoratedBox(
      decoration: surfaceStyle.decoration(
        radius: 28,
        includeShadow: true,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          children: [
            if (sourceStatusLabel != null && sourceStatusLabel!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  sourceStatusLabel!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: contentColors.subtleForeground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  key: const ValueKey('quran-focus-previous-ayah'),
                  onPressed: canGoPreviousAyah ? onPreviousAyah : null,
                  style: IconButton.styleFrom(
                    backgroundColor: surfaceStyle.iconBackgroundColor,
                    foregroundColor: contentColors.foreground,
                  ),
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                const SizedBox(width: 18),
                IconButton.filled(
                  key: const ValueKey('quran-focus-play-pause'),
                  onPressed: primaryEnabled ? onTogglePlayback : null,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(76, 76),
                    backgroundColor: const Color(0xFF4A3C2F).withValues(
                      alpha: 0.94,
                    ),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  icon: Icon(primaryIcon, size: 38),
                ),
                const SizedBox(width: 18),
                IconButton.filledTonal(
                  key: const ValueKey('quran-focus-next-ayah'),
                  onPressed: canGoNextAyah ? onNextAyah : null,
                  style: IconButton.styleFrom(
                    backgroundColor: surfaceStyle.iconBackgroundColor,
                    foregroundColor: contentColors.foreground,
                  ),
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusRecitationEmptyState extends StatelessWidget {
  const _FocusRecitationEmptyState({
    required this.l10n,
    required this.onExit,
  });

  final AppLocalizations l10n;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.quranFocusRecitationTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.quranFocusRecitationEmptyBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              key: const ValueKey('quran-focus-exit-empty'),
              onPressed: onExit,
              child: Text(l10n.accessibilityClosePlayer),
            ),
          ],
        ),
      ),
    );
  }
}
