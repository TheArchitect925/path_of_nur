import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/nav_tabs.dart';
import '../../core/navigation/app_navigation_gesture_config.dart';
import '../../core/navigation/app_swipe_back_wrapper.dart';
import '../../core/reminders/quran_live_activity_service.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/application/quran_reader_playback_controller.dart';
import '../../features/learn/quran/presentation/quran_reader_playback_presentation.dart';
import '../../features/learn/quran/presentation/widgets/quran_expanded_player_sheet.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
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
            child: _buildGlobalQuranMiniPlayer(
              context: context,
              ref: ref,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: _buildBottomBar(context, activeTab),
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
    final isQuranFocusRoute =
        currentLocation.startsWith('/quran/focus-recitation');
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
    final statusLabel = buildQuranPlaybackStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    final showRetryAction = playbackState.hasRecoverableFailure;

    final targetSurah = playbackState.activeSurahNumber;
    final targetAyah =
        playbackState.activeAyahNumber ?? playbackState.storedSession?.ayahNumber;

    return Align(
      alignment: Alignment.center,
      child: QuranPlayerLauncherPill(
        label: nowPlayingLabel ?? l10n.shellQuranMiniPlayerTitle,
        subtitle: '${playbackState.reciterName} • $statusLabel',
        isPlaying: playbackState.isPlaying,
        showRetryAction: showRetryAction,
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
    final surface = appearance?.surface ?? AppColors.surface;
    final accent = appearance?.accent ?? AppColors.accentGold;
    final surfaceAlpha =
        appearance?.glassSurfaceAlpha ?? AppColors.glassSurfaceAlpha;
    final borderAlpha =
        appearance?.glassBorderAlpha ?? AppColors.glassBorderAlpha;

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
                    border: Border.all(
                      color: accent.withValues(alpha: borderAlpha),
                      width: 1.0,
                    ),
                    color: surface.withValues(alpha: surfaceAlpha),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
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
    const iconColor = Color(0xFF1A1A1A);
    const subtle = Color(0xFF4A4A4A);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
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
                  (appearance?.surfaceSoft ?? const Color(0xFFF4E2C8))
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
  late final QuranLiveActivityService _liveActivityService =
      ref.read(quranLiveActivityServiceProvider);
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
        playbackState.activeAyahNumber ?? playbackState.storedSession?.ayahNumber;
    if (!quranAudioEnabled ||
        !playbackState.hasPlayback ||
        surahNumber == null ||
        ayahNumber == null) {
      await _endLiveActivityIfNeeded();
      return;
    }

    final elapsedSeconds = playbackState.position.inSeconds.clamp(0, 86400);
    final totalSeconds =
        (playbackState.duration?.inSeconds ?? 0).clamp(0, 86400);
    final payloadSignature =
        '$surahNumber:$ayahNumber:${playbackState.reciterName}:${playbackState.isPlaying}:$elapsedSeconds:$totalSeconds';
    if (_lastPayloadSignature == payloadSignature) {
      return;
    }

    final surah =
        ref.read(quranSurahMapProvider)[surahNumber];
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
    required this.label,
    required this.subtitle,
    required this.isPlaying,
    required this.showRetryAction,
    required this.onOpenPlayer,
    required this.openTooltip,
  });

  final String label;
  final String subtitle;
  final bool isPlaying;
  final bool showRetryAction;
  final VoidCallback onOpenPlayer;
  final String openTooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1E5D3),
      elevation: 8,
      borderRadius: BorderRadius.circular(999),
      shadowColor: const Color(0xFF1D1A17).withValues(alpha: 0.16),
      child: InkWell(
        key: const ValueKey('quran-shell-player-pill'),
        borderRadius: BorderRadius.circular(999),
        onTap: onOpenPlayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D1A8),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Icon(
                  showRetryAction
                      ? Icons.refresh_rounded
                      : isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.play_arrow_rounded,
                  size: 20,
                  color: const Color(0xFF5B4837),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  key: const ValueKey('quran-shell-player-pill-content'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3A3026),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6A5A4A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: openTooltip,
                child: const Icon(
                  Icons.expand_less_rounded,
                  color: Color(0xFF5B4837),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
