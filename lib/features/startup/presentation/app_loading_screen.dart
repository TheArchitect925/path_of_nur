import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_backgrounds.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../shared/widgets/night_sky.dart';
import '../../accounts_sync/application/accounts_sync_controller.dart';
import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/drops/domain/garden_asset_paths.dart';
import '../../journey/drops/domain/garden_milestones.dart';
import '../../onboarding/application/onboarding_state_provider.dart';
import '../application/startup_loading_controller.dart';

class AppLoadingScreen extends ConsumerStatefulWidget {
  const AppLoadingScreen({super.key});

  @override
  ConsumerState<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends ConsumerState<AppLoadingScreen> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(startupLoadingControllerProvider.notifier)
          .start(
            onboardingCompleted: ref.read(onboardingCompletedProvider),
            accountsSyncState: ref.read(accountsSyncControllerProvider),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(startupLoadingControllerProvider);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final background = AppBackgroundTheme.resolve(
      appearance: appearance,
      disableGlassTransparency: appearance?.disableGlassTransparency ?? false,
    );
    final unlockedMilestones = ref.watch(unlockedGardenMilestonesProvider);
    final gardenBackgroundAsset = gardenImageAssetPath(
      unlockedMilestones.isNotEmpty
          ? unlockedMilestones.last.imageAsset
          : gardenMilestones.first.imageAsset,
    );
    final greeting = getIslamicGreeting(now: DateTime.now(), l10n: l10n);
    final statusLabel = resolveStartupStatusLabel(state.stage, l10n);

    ref.listen<StartupLoadingState>(startupLoadingControllerProvider, (
      previous,
      next,
    ) {
      final targetLocation = next.targetLocation;
      if (targetLocation == null || !mounted) return;
      context.go(targetLocation);
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(gradient: background.baseGradient),
          ),
          // Night themes load under their own sky instead of the garden art:
          // Midnight gets the stars and true-phase moon, Candlelight keeps
          // its glow (carried by the background spec gradients).
          if (appearance?.isNightFamily != true)
            Image.asset(
              gardenBackgroundAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            )
          else if (appearance?.mode == AppThemeMode.midnight)
            CustomPaint(painter: MidnightSkyPainter(now: DateTime.now())),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: background.wallpaperTintGradient,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: background.foregroundGlowGradient,
            ),
          ),
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
                        child: AppHeroGlassShell(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 30,
                          ),
                          tintColor: const Color(0xFFE7C98C),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
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
                                const SizedBox(height: 18),
                                Center(
                                  child: _StartupLogoHalo(
                                    child: Image.asset(
                                      'assets/icons/home_lantern_cropped.webp',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Text(
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
                                const SizedBox(height: 6),
                                Text(
                                  greeting.translation,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontSize: 12.5,
                                        color: _secondaryTextColor,
                                        height: 1.35,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  l10n.loadingWelcomeBack,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: _headlineColor,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.loadingRestoringProgress,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: _secondaryTextColor,
                                        height: 1.4,
                                      ),
                                ),
                                const SizedBox(height: 24),
                                const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFB9934B),
                                    ),
                                    backgroundColor: Color(0x1FB9934B),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 240),
                                  child: Text(
                                    statusLabel,
                                    key: ValueKey<String>(statusLabel),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: _tertiaryTextColor,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

class _StartupLogoHalo extends StatelessWidget {
  const _StartupLogoHalo({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFFFF9ED).withValues(alpha: 0.95),
            const Color(0xFFE7C98C).withValues(alpha: 0.22),
            Colors.transparent,
          ],
          stops: const [0.0, 0.48, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD6B066).withValues(alpha: 0.18),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
