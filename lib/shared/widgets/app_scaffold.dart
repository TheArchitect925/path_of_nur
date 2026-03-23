import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/nav_tabs.dart';
import '../../core/navigation/app_navigation_gesture_config.dart';
import '../../core/navigation/app_swipe_back_wrapper.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/application/quran_player_controller.dart';
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
    final quranPlayer = ref.watch(quranSharedAudioPlayerProvider);
    final quranPlayerController = ref.watch(quranPlayerControllerProvider);

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
          Positioned(
            left: 0,
            right: 0,
            bottom: 92,
            child: _buildGlobalQuranPlaybackFab(
              context: context,
              player: quranPlayer,
              controller: quranPlayerController,
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

  Widget _buildGlobalQuranPlaybackFab({
    required BuildContext context,
    required AudioPlayer player,
    required QuranPlayerController controller,
  }) {
    final l10n = AppLocalizations.of(context);
    final isQuranReaderRoute =
        currentLocation.startsWith('/quran/surah/') ||
        currentLocation.startsWith('/learn/quran/surah/');
    if (isQuranReaderRoute) return const SizedBox.shrink();

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      initialData: player.playerState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? player.playerState;
        final hasActiveAudio =
            player.audioSource != null &&
            state.processingState != ProcessingState.idle;
        if (!hasActiveAudio) return const SizedBox.shrink();

        final isPlaying = state.playing;
        return Center(
          child: Tooltip(
            message: isPlaying
                ? l10n.shellQuranPlaybackPauseTooltip
                : l10n.shellQuranPlaybackResumeTooltip,
            child: Semantics(
              button: true,
              label: isPlaying
                  ? l10n.shellQuranPlaybackPauseTooltip
                  : l10n.shellQuranPlaybackResumeTooltip,
              child: Material(
                color: const Color(0xFFE8D7B8),
                elevation: 6,
                shadowColor: const Color(0xFF1D1A17).withValues(alpha: 0.22),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (isPlaying) {
                      unawaited(controller.pause());
                    } else {
                      unawaited(controller.resumeCurrentPlayback());
                    }
                  },
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      size: 32,
                      color: const Color(0xFF3A3026),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
