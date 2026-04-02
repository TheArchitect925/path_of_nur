import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/nav_tabs.dart';
import '../../core/navigation/app_navigation_gesture_config.dart';
import '../../core/navigation/app_swipe_back_wrapper.dart';
import '../../core/reminders/quran_live_activity_service.dart';
import '../../features/learn/quran/application/quran_player_controller.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/application/quran_reader_playback_controller.dart';
import '../../features/learn/quran/presentation/quran_reader_playback_presentation.dart';
import '../../features/learn/quran/presentation/widgets/quran_expanded_player_sheet.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import '../state/shell_state.dart';
import 'global_background.dart';

class AppShellScaffold extends ConsumerWidget {
  const AppShellScaffold({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  final String currentLocation;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = navTabFromLocation(currentLocation);
    final previousLocation = ref.watch(shellCurrentLocationProvider);
    final focusRecitationOpen = ref.watch(quranFocusRecitationOpenProvider);
    final isQuranFocusRoute = currentLocation.startsWith(
      '/quran/focus-recitation',
    );

    if (previousLocation != currentLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ref.read(shellCurrentLocationProvider.notifier).state = currentLocation;
        if (activeTab == NavTab.home) {
          ref.read(homeVerseVersionProvider.notifier).state++;
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const GlobalBackground(),
          AppSwipeBackWrapper(
            enabled: AppNavigationGestureConfig.isEnabledForLocation(
              currentLocation,
            ),
            child: child,
          ),
          _QuranPhoneLiveActivityBridge(currentLocation: currentLocation),
          Positioned(
            left: 16,
            right: 16,
            bottom: 82,
            child: _buildGlobalQuranMiniPlayer(context: context, ref: ref),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: focusRecitationOpen || isQuranFocusRoute
                ? const SizedBox.shrink()
                : _buildBottomBar(context, activeTab),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalQuranMiniPlayer({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final quranAudioEnabled = ref.watch(quranAudioFunctionEnabledProvider);
    if (!quranAudioEnabled) return const SizedBox.shrink();
    final expandedPlayerOpen = ref.watch(quranExpandedPlayerOpenProvider);
    final focusRecitationOpen = ref.watch(quranFocusRecitationOpenProvider);
    if (expandedPlayerOpen || focusRecitationOpen) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final isQuranReaderRoute =
        currentLocation.startsWith('/quran/surah/') ||
        currentLocation.startsWith('/learn/quran/surah/');
    final isQuranFocusRoute = currentLocation.startsWith(
      '/quran/focus-recitation',
    );
    if (isQuranReaderRoute || isQuranFocusRoute) {
      return const SizedBox.shrink();
    }
    final playbackState = ref.watch(quranGlobalPlaybackStateProvider);
    if (!playbackState.hasPlayback || playbackState.activeSurahNumber == null) {
      return const SizedBox.shrink();
    }
    final nowPlayingLabel = buildQuranReaderNowPlayingLabel(
      l10n: l10n,
      playbackState: playbackState,
      surahMap: ref.read(quranSurahMapProvider),
    );
    final sourceStatusLabel = buildQuranPlaybackSourceStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    final showRetryAction = playbackState.hasRecoverableFailure;
    final controller = ref.read(quranPlayerControllerProvider);

    final targetSurah = playbackState.activeSurahNumber;
    final targetAyah =
        playbackState.activeAyahNumber ??
        playbackState.storedSession?.ayahNumber;
    final totalMillis = playbackState.duration?.inMilliseconds ?? 0;
    final currentMillis = playbackState.position.inMilliseconds.clamp(
      0,
      totalMillis > 0 ? totalMillis : 0,
    );
    final progressValue = totalMillis > 0 ? currentMillis / totalMillis : 0.0;
    final compactLabel = showRetryAction
        ? (sourceStatusLabel ?? l10n.shellQuranMiniPlayerTitle)
        : nowPlayingLabel;

    return Align(
      alignment: Alignment.center,
      child: QuranPlayerLauncherPill(
        label: compactLabel,
        isPlaying: playbackState.isPlaying,
        showRetryAction: showRetryAction,
        progressValue: progressValue,
        onTogglePlayback: showRetryAction
            ? () => unawaited(controller.retryCurrentPlayback())
            : playbackState.canPause
            ? () => unawaited(controller.pause())
            : playbackState.canPlay
            ? () => unawaited(controller.resumeCurrentPlayback())
            : null,
        onOpenPlayer: () {
          if (targetSurah == null) return;
          unawaited(
            showQuranExpandedPlayerSheet(
              context,
              surahNumber: targetSurah,
              ayahNumber: targetAyah,
            ),
          );
        },
        openTooltip: l10n.quranPlaybackOpenPlayerAction,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, NavTab activeTab) {
    final allTabs = NavTab.values;
    const barRadius = 999.0;
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final navStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.navigationBar,
      tintColor: appearance?.accent,
      baseColor: appearance?.surfaceSoft,
    );
    final layeredCoreColor =
        Color.lerp(navStyle.backgroundColor, Colors.white, 0.10) ??
        navStyle.backgroundColor;
    final layeredBorderColor =
        Color.lerp(navStyle.borderColor, Colors.white, 0.18) ??
        navStyle.borderColor;
    final topRimColor = (appearance?.sanctuaryEdgeLight ?? Colors.white)
        .withValues(alpha: appearance?.isDark ?? false ? 0.14 : 0.22);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          height: 78,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(barRadius),
                    border: Border.all(color: navStyle.borderColor, width: 1.0),
                    gradient: navStyle.gradient,
                    color: navStyle.backgroundColor,
                    boxShadow: navStyle.boxShadows,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(barRadius),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2,
                          right: 2,
                          top: 2,
                          bottom: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(barRadius),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  layeredCoreColor.withValues(alpha: 0.72),
                                  layeredCoreColor.withValues(alpha: 0.28),
                                ],
                              ),
                              border: Border.all(
                                color: layeredBorderColor.withValues(
                                  alpha: 0.74,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 6,
                          child: IgnorePointer(
                            child: Container(
                              height: 1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    topRimColor,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: allTabs
                        .map(
                          (tab) => Expanded(
                            child: _tabButton(context, tab, activeTab == tab),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(BuildContext context, NavTab tab, bool active) {
    const bool isHome = false;
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final iconColor = appearance?.navLabelActive ?? const Color(0xFF1A1A1A);
    final subtle = appearance?.navLabelInactive ?? const Color(0xFF4A4A4A);
    final localeUiFont = AppFonts.uiFontFamilyForLocale(
      Localizations.localeOf(context),
    );
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: active ? iconColor : subtle,
      fontSize: 12.7,
      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
      letterSpacing: 0.2,
      fontFamily: localeUiFont,
      shadows: active
          ? [
              Shadow(
                color: (appearance?.accent ?? const Color(0xFFE5C683))
                    .withValues(alpha: 0.18),
                blurRadius: 6,
                offset: const Offset(0, 0),
              ),
            ]
          : null,
    );

    final label = _tabLabel(context, tab);
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: active,
        label: label,
        child: InkWell(
          onTap: () => context.go(tab.path),
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 74,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: _navIcon(
                      context,
                      tab.icon,
                      isHome: isHome,
                      active: active,
                      iconColor: active ? iconColor : subtle,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(
    BuildContext context,
    IconData icon, {
    required bool isHome,
    required bool active,
    required Color iconColor,
  }) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final double size = 24;
    final shadow = [
      Shadow(
        color:
            (appearance?.isDark == true
                    ? Colors.black
                    : const Color(0xFF1E150D))
                .withValues(alpha: active ? 0.32 : 0.14),
        blurRadius: active ? 12 : 5,
        offset: const Offset(0, 1.2),
      ),
      Shadow(
        color: (appearance?.accent ?? const Color(0xFFE5C683)).withValues(
          alpha: active ? 0.30 : 0.08,
        ),
        blurRadius: active ? 14 : 5,
        offset: const Offset(0, 0),
      ),
    ];

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active
            ? RadialGradient(
                colors: [
                  (appearance?.navActiveFill ?? const Color(0xFFF4E2C8))
                      .withValues(
                        alpha: appearance?.isDark == true ? 0.5 : 0.90,
                      ),
                  (appearance?.accent ?? const Color(0xFFE8CFAB)).withValues(
                    alpha: appearance?.isDark == true ? 0.35 : 0.90,
                  ),
                  (appearance?.accentSoft ?? const Color(0xFFD7AE74))
                      .withValues(
                        alpha: appearance?.isDark == true ? 0.25 : 0.90,
                      ),
                ],
              )
            : null,
        border: active
            ? Border.all(
                color: (appearance?.accent ?? const Color(0xFFE4C690))
                    .withValues(
                      alpha: appearance?.isDark == true ? 0.42 : 0.68,
                    ),
                width: 1.1,
              )
            : null,
      ),
      child: Icon(icon, size: size, color: iconColor, shadows: shadow),
    );
  }

  String _tabLabel(BuildContext context, NavTab tab) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case NavTab.worship:
        return l10n.worshipTitle;
      case NavTab.learn:
        return l10n.learnTitle;
      case NavTab.home:
        return l10n.homeTitle;
      case NavTab.journey:
        return l10n.journeyTitle;
      case NavTab.quran:
        return l10n.quranTitle;
    }
  }
}

class _QuranPhoneLiveActivityBridge extends ConsumerStatefulWidget {
  const _QuranPhoneLiveActivityBridge({required this.currentLocation});

  final String currentLocation;

  @override
  ConsumerState<_QuranPhoneLiveActivityBridge> createState() =>
      _QuranPhoneLiveActivityBridgeState();
}

class _QuranPhoneLiveActivityBridgeState
    extends ConsumerState<_QuranPhoneLiveActivityBridge> {
  ProviderSubscription<QuranReaderPlaybackState>? _playbackSubscription;
  late final QuranLiveActivityService _liveActivityService = ref.read(
    quranLiveActivityServiceProvider,
  );
  bool _isSupported = false;
  bool _hasActiveLiveActivity = false;
  String? _lastPayloadSignature;

  bool get _isReaderRoute =>
      widget.currentLocation.startsWith('/quran/surah/') ||
      widget.currentLocation.startsWith('/learn/quran/surah/');

  @override
  void initState() {
    super.initState();
    _playbackSubscription = ref.listenManual<QuranReaderPlaybackState>(
      quranGlobalPlaybackStateProvider,
      (_, next) => unawaited(_syncLiveActivity(next)),
      fireImmediately: false,
    );
    unawaited(_bootstrap());
  }

  @override
  void didUpdateWidget(covariant _QuranPhoneLiveActivityBridge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocation != widget.currentLocation) {
      unawaited(_syncLiveActivity(ref.read(quranGlobalPlaybackStateProvider)));
    }
  }

  @override
  void dispose() {
    _playbackSubscription?.close();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final supported = await _liveActivityService.isSupported();
    if (!mounted) {
      return;
    }
    _isSupported = supported;
    if (supported) {
      await _syncLiveActivity(ref.read(quranGlobalPlaybackStateProvider));
    }
  }

  Future<void> _syncLiveActivity(QuranReaderPlaybackState playbackState) async {
    if (!_isSupported || _isReaderRoute) {
      return;
    }
    final quranAudioEnabled = ref.read(quranAudioFunctionEnabledProvider);
    final surahNumber = playbackState.activeSurahNumber;
    final ayahNumber =
        playbackState.activeAyahNumber ??
        playbackState.storedSession?.ayahNumber;
    if (!quranAudioEnabled ||
        !playbackState.hasPlayback ||
        surahNumber == null ||
        ayahNumber == null) {
      await _endLiveActivityIfNeeded();
      return;
    }

    final elapsedSeconds = playbackState.position.inSeconds.clamp(0, 86400);
    final totalSeconds = (playbackState.duration?.inSeconds ?? 0).clamp(
      0,
      86400,
    );
    final payloadSignature =
        '$surahNumber:$ayahNumber:${playbackState.reciterName}:${playbackState.isPlaying}:$elapsedSeconds:$totalSeconds';
    if (_lastPayloadSignature == payloadSignature) {
      return;
    }

    final surah = ref.read(quranSurahMapProvider)[surahNumber];
    await _liveActivityService.updatePlaybackCard(
      surahNumber: surahNumber,
      surahName: surah?.transliteratedName ?? 'Surah $surahNumber',
      surahArabicName: surah?.arabicName ?? '',
      ayahNumber: ayahNumber,
      reciterName: playbackState.reciterName,
      isPlaying: playbackState.isPlaying,
      elapsedSeconds: elapsedSeconds,
      totalSeconds: totalSeconds,
    );
    _hasActiveLiveActivity = true;
    _lastPayloadSignature = payloadSignature;
  }

  Future<void> _endLiveActivityIfNeeded() async {
    if (!_hasActiveLiveActivity) {
      _lastPayloadSignature = null;
      return;
    }
    await _liveActivityService.endPlaybackCard();
    _hasActiveLiveActivity = false;
    _lastPayloadSignature = null;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class QuranPlayerLauncherPill extends StatelessWidget {
  const QuranPlayerLauncherPill({
    super.key,
    this.label,
    required this.isPlaying,
    required this.showRetryAction,
    required this.progressValue,
    required this.onTogglePlayback,
    required this.onOpenPlayer,
    required this.openTooltip,
  });

  final String? label;
  final bool isPlaying;
  final bool showRetryAction;
  final double progressValue;
  final VoidCallback? onTogglePlayback;
  final VoidCallback onOpenPlayer;
  final String openTooltip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final contentColors = AppSurfaceTheme.contentColors(context);
    final pillStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: appearance?.accent,
      baseColor: appearance?.surfaceSoft,
    );
    final clampedProgress = progressValue.clamp(0.0, 1.0);
    final playbackTooltip = showRetryAction
        ? l10n.quranPlaybackRetryAction
        : (isPlaying ? l10n.accessibilityPause : l10n.accessibilityPlay);

    return Material(
      color: pillStyle.backgroundColor,
      elevation: 7,
      borderRadius: BorderRadius.circular(20),
      shadowColor: pillStyle.shadowColor,
      child: Container(
        key: const ValueKey('quran-shell-player-pill'),
        constraints: const BoxConstraints(minHeight: 52, maxWidth: 560),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: pillStyle.gradient,
          border: Border.all(color: pillStyle.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: playbackTooltip,
              child: IconButton(
                key: const ValueKey('quran-shell-player-play-pause'),
                onPressed: onTogglePlayback,
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: appearance?.navActiveFill,
                  foregroundColor:
                      appearance?.navLabelActive ?? contentColors.foreground,
                ),
                icon: Icon(
                  showRetryAction
                      ? Icons.refresh_rounded
                      : isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                key: const ValueKey('quran-shell-player-pill-content'),
                borderRadius: BorderRadius.circular(14),
                onTap: onOpenPlayer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null && label!.trim().isNotEmpty) ...[
                        Text(
                          label!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: contentColors.subtleForeground,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          key: const ValueKey('quran-shell-player-progress'),
                          value: clampedProgress,
                          minHeight: 3,
                          backgroundColor: appearance?.chipUnselectedFill,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            appearance?.accentSoft ?? const Color(0xFF8C6948),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: openTooltip,
              child: IconButton(
                key: const ValueKey('quran-shell-player-expand'),
                onPressed: onOpenPlayer,
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                color: appearance?.navLabelActive ?? contentColors.foreground,
                icon: const Icon(Icons.open_in_full_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
