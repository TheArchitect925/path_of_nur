import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/prayer/prayer_preferences.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/motion/ambient_motion.dart';
import '../../../shared/motion/ink_reveal.dart';
import '../../../shared/motion/motion_preferences.dart';
import '../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../shared/widgets/global_background.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../garden/application/garden_scene_provider.dart';
import '../../home/application/home_module_prefs_provider.dart';
import '../../onboarding/application/onboarding_state_provider.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../application/startup_loading_controller.dart';

/// The dawn: the app's first screen.
///
/// The lantern kindles, the takbīr inks in right to left, the greeting
/// follows, and a light-line advances across the card on real checkpoints.
/// When the work is done the card lifts away and Home settles in beneath
/// it, under the same sky — the shell paints the same [GlobalBackground], so
/// nothing changes behind the card. Under Reduce Motion the card is simply
/// there, then Home is.
class AppLoadingScreen extends ConsumerStatefulWidget {
  const AppLoadingScreen({super.key});

  @override
  ConsumerState<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends ConsumerState<AppLoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _kindle = AnimationController(
    vsync: this,
    duration: AppMotion.kindle,
  );
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: AppMotion.startupExit,
  );

  late final Animation<double> _halo = _slice(0.0, 0.55, Curves.easeOut);
  late final Animation<double> _lantern = _slice(0.07, 0.5, Curves.easeOut);
  late final Animation<double> _takbir = _slice(0.25, 0.65);
  late final Animation<double> _greeting = _slice(0.45, 0.85);
  late final Animation<double> _translation = _slice(
    0.62,
    0.95,
    Curves.easeOut,
  );
  late final Animation<double> _welcome = _slice(0.70, 1.0, Curves.easeOut);
  late final Animation<double> _line = _slice(0.76, 1.0, Curves.easeOut);

  bool _leaving = false;

  Animation<double> _slice(
    double begin,
    double end, [
    Curve curve = AppMotion.settleCurve,
  ]) {
    return CurvedAnimation(
      parent: _kindle,
      curve: Interval(begin, end, curve: curve),
    );
  }

  // Night themes swap the warm daylight ink for ivory.
  bool get _night =>
      Theme.of(context).extension<AppAppearanceTheme>()?.isNightFamily == true;
  Color get _headlineColor =>
      _night ? const Color(0xFFF0E4C0) : const Color(0xFF26170B);
  Color get _primaryTextColor =>
      _night ? const Color(0xFFEFE8D7) : const Color(0xFF342114);
  Color get _secondaryTextColor =>
      _night ? const Color(0xFFC9C0AA) : const Color(0xFF5C4737);
  Color get _tertiaryTextColor =>
      _night ? const Color(0xFFA9A18C) : const Color(0xFF6F5846);

  @override
  void initState() {
    super.initState();
    ref.listenManual<StartupLoadingState>(startupLoadingControllerProvider, (
      previous,
      next,
    ) {
      final targetLocation = next.targetLocation;
      if (targetLocation == null || _leaving || !mounted) return;
      _leaving = true;
      _leave(targetLocation);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(effectiveReduceMotionProvider)) {
        _kindle.value = 1;
      } else {
        _kindle.forward();
      }
      ref
          .read(startupLoadingControllerProvider.notifier)
          .start(
            onboardingCompleted: ref.read(onboardingCompletedProvider),
            accountsSyncState: ref.read(accountsSyncControllerProvider),
            checkpoints: _checkpoints(),
          );
    });
  }

  /// Real work, one per stage of the light-line. Each only warms what Home
  /// reads first, so the hand-off paints in one frame.
  List<StartupCheckpoint> _checkpoints() {
    return [
      // Restoring: the profile, the account state and the Home layout.
      () async {
        ref.read(profileSettingsProvider);
        ref.read(accountsSyncControllerProvider);
        ref.read(homeModulePrefsProvider);
      },
      // Syncing: today's prayer schedule and the day's summary.
      () async {
        ref.read(prayerScheduleContextProvider);
        ref.read(homeDashboardSummaryProvider);
      },
      // Finalizing: the garden scene Home shows, composed before the card
      // lifts.
      () async {
        ref.read(activeGardenSceneSpecProvider);
      },
    ];
  }

  Future<void> _leave(String targetLocation) async {
    // The ceremony is only owed once it has begun: when the work was done
    // before the first frame drew anything (a warm restore, a test double),
    // the reader is simply taken in.
    final ceremony =
        !ref.read(effectiveReduceMotionProvider) && _kindle.value >= 0.05;
    if (ceremony) {
      // Let the kindle finish its line before the card lifts.
      if (_kindle.isAnimating) {
        await _kindle.forward();
      }
      if (!mounted) return;
      await _exit.forward();
    }
    if (!mounted) return;
    context.go(targetLocation);
  }

  @override
  void dispose() {
    _kindle.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(startupLoadingControllerProvider);
    final reduceMotion = ref.watch(effectiveReduceMotionProvider);
    final greeting = getIslamicGreeting(now: DateTime.now(), l10n: l10n);
    final statusLabel = resolveStartupStatusLabel(state.stage, l10n);
    final theme = Theme.of(context);
    const glow = Color(0xFFE7C98C);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkReveal(
          animation: _takbir,
          textDirection: TextDirection.rtl,
          child: Text(
            l10n.loadingHeadlineAllahAkbar,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri Quran',
              fontSize: 34,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: _primaryTextColor,
              shadows: const [
                Shadow(
                  color: Color(0x26FFF8EA),
                  blurRadius: 10,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: _Kindle(
            halo: _halo,
            lantern: _lantern,
            glow: glow,
            child: Image.asset(
              'assets/icons/home_lantern_cropped.webp',
              width: 100,
              height: 100,
            ),
          ),
        ),
        const SizedBox(height: 22),
        InkReveal(
          animation: _greeting,
          textDirection: TextDirection.rtl,
          child: Text(
            greeting.arabic,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri Quran',
              fontSize: 26,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: _primaryTextColor,
              shadows: const [
                Shadow(
                  color: Color(0x24FFF8EA),
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeRise(
          animation: _translation,
          child: Text(
            greeting.translation,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5,
              color: _secondaryTextColor,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeRise(
          animation: _welcome,
          child: Column(
            children: [
              Text(
                l10n.loadingWelcomeBack,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _headlineColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.loadingRestoringProgress,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _secondaryTextColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FadeRise(
          animation: _line,
          child: Column(
            children: [
              _LightLine(
                progress: startupLightLineProgress(state.stage),
                color: const Color(0xFFB9934B),
                reduceMotion: reduceMotion,
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: reduceMotion ? AppMotion.instant : AppMotion.standard,
                child: Text(
                  statusLabel,
                  key: ValueKey<String>(statusLabel),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _tertiaryTextColor,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final card = AppHeroGlassShell(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      tintColor: glow,
      surfaceAlphaOverride: 0.2,
      radius: 36,
      borderColor: const Color(0x42FFFFFF),
      highlightGradientColors: const [
        Color(0x24FFFFFF),
        Colors.transparent,
        Color(0x16E8C98F),
      ],
      child: SizedBox(
        width: double.infinity,
        // Leaving: the content fades while the glass lifts and closes.
        child: FadeTransition(opacity: ReverseAnimation(_exit), child: content),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The same sky the shell paints, so Home arrives under it.
          const GlobalBackground(moonFraction: kMoonFractionHome),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 64,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _Lift(exit: _exit, child: card),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The lantern kindling: its halo grows from nothing while the lantern
/// itself fades and rises, then the ambient breath takes over.
class _Kindle extends StatelessWidget {
  const _Kindle({
    required this.halo,
    required this.lantern,
    required this.glow,
    required this.child,
  });

  final Animation<double> halo;
  final Animation<double> lantern;
  final Color glow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 132,
      child: AnimatedBuilder(
        animation: Listenable.merge([halo, lantern]),
        child: BreathingGlow(color: glow, child: child),
        builder: (context, breathing) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 0.35 + 0.65 * halo.value,
                child: Opacity(
                  opacity: halo.value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFF9ED).withValues(alpha: 0.95),
                          glow.withValues(alpha: 0.22),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.48, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFD6B066,
                          ).withValues(alpha: 0.18),
                          blurRadius: 34,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const SizedBox.square(dimension: 132),
                  ),
                ),
              ),
              Opacity(
                opacity: lantern.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - lantern.value) * 6),
                  child: breathing,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The card leaving: it lifts and closes from the bottom up. Transform and
/// clip only — the glass itself never fades.
class _Lift extends StatelessWidget {
  const _Lift({required this.exit, required this.child});

  final Animation<double> exit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: exit,
      child: child,
      builder: (context, child) {
        final t = AppMotion.exitCurve.transform(exit.value);
        if (t <= 0) return child!;
        return Transform.translate(
          offset: Offset(0, -26 * t),
          child: ClipRect(
            clipper: _CollapseClipper(keep: 1 - t),
            child: child,
          ),
        );
      },
    );
  }
}

class _CollapseClipper extends CustomClipper<Rect> {
  const _CollapseClipper({required this.keep});

  final double keep;

  @override
  Rect getClip(Size size) {
    const bleed = 40.0;
    return Rect.fromLTWH(
      -bleed,
      -bleed,
      size.width + bleed * 2,
      (size.height + bleed) * keep.clamp(0.0, 1.0),
    );
  }

  @override
  bool shouldReclip(_CollapseClipper oldClipper) => oldClipper.keep != keep;
}

/// The light-line: a thin track that fills as the checkpoints complete.
class _LightLine extends StatelessWidget {
  const _LightLine({
    required this.progress,
    required this.color,
    required this.reduceMotion,
  });

  final double progress;
  final Color color;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${(progress * 100).round()}%',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const SizedBox.expand(),
                  ),
                  AnimatedContainer(
                    duration: reduceMotion
                        ? AppMotion.instant
                        : AppMotion.gentle,
                    curve: AppMotion.settleCurve,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.55),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
