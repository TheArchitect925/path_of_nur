import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import 'global_background.dart';
import 'quran_navigation.dart';
import 'quran_quote_block.dart';

class PageLayoutConfig {
  final bool extendBehindBottomNav;

  const PageLayoutConfig({this.extendBehindBottomNav = false});

  static const standard = PageLayoutConfig();
  static const immersive = PageLayoutConfig(extendBehindBottomNav: true);
}

class AppPageScaffold extends ConsumerWidget {
  static const double _homeMatchedBottomContentPadding = 136;
  static const double _homeMatchedFloatingBottomOffset = 92;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.quote,
    this.quoteHeader,
    this.quotePool,
    this.headerIcon,
    this.onQuoteTap,
    this.scrollController,
    this.headerActions,
    this.floatingBottom,
    this.backgroundAssetPath,
    this.backgroundOverlayColor,
    this.backgroundAtmosphere = AppBackgroundAtmosphere.standard,
    this.layoutConfig = PageLayoutConfig.standard,
    this.ownsBackground = true,
    required this.children,
    this.bodySlivers,
  });

  final String title;
  final String subtitle;
  final QuranQuote? quote;
  final Widget? quoteHeader;
  final List<QuranQuote>? quotePool;
  final IconData? headerIcon;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final ScrollController? scrollController;
  final List<Widget>? headerActions;
  final Widget? floatingBottom;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final AppBackgroundAtmosphere backgroundAtmosphere;
  final PageLayoutConfig layoutConfig;
  final bool ownsBackground;
  final List<Widget> children;
  final List<Widget>? bodySlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ?? const Color(0xFF3A3026);
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ?? const Color(0xFF5D4F44);
    final resolvedQuote =
        quote ?? (quotePool == null ? null : quoteFromPoolForToday(quotePool!));
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final pageTransitionStyle = ref.watch(
      profileSettingsProvider.select((value) => value.pageTransitionStyle),
    );
    final bottomInset = layoutConfig.extendBehindBottomNav
        ? 0.0
        : _homeMatchedBottomContentPadding;
    final headerContent = <Widget>[
      if (canPop || headerIcon != null)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canPop)
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const BackButtonIcon(),
                color: foreground,
              ),
            if (canPop && headerIcon != null) const SizedBox(width: 4),
            if (headerIcon != null) Icon(headerIcon, color: foreground, size: 24),
            if (headerIcon != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
                  ),
                ],
              ),
            ),
            if (headerActions != null) ...[
              const SizedBox(width: 8),
              ...headerActions!,
            ],
          ],
        )
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: foreground),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
            ),
          ],
        ),
      const SizedBox(height: 12),
      if (quoteHeader != null) ...[
        const SizedBox(height: 12),
        _AnimatedQuoteHeader(
          reduceMotion: reduceMotion,
          style: pageTransitionStyle,
          child: quoteHeader!,
        ),
      ] else if (resolvedQuote != null) ...[
        const SizedBox(height: 12),
        _AnimatedQuoteHeader(
          reduceMotion: reduceMotion,
          style: pageTransitionStyle,
          child: QuranQuoteBlock(
            quote: resolvedQuote,
            onTap: () {
              if (onQuoteTap != null) {
                onQuoteTap!(resolvedQuote);
                return;
              }
              openQuranQuoteLocation(context, resolvedQuote);
            },
          ),
        ),
      ],
      const SizedBox(height: 20),
    ];
    final hasCustomSlivers = bodySlivers != null;
    return _AnimatedPageEntrance(
      reduceMotion: reduceMotion,
      style: pageTransitionStyle,
      child: Stack(
        children: [
          if (ownsBackground)
            layoutConfig.extendBehindBottomNav
                ? GlobalBackground(
                    assetPath: backgroundAssetPath,
                    overlayColor: backgroundOverlayColor,
                    atmosphere: backgroundAtmosphere,
                  )
                : ClipRect(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: Stack(
                        children: [
                          GlobalBackground(
                            assetPath: backgroundAssetPath,
                            overlayColor: backgroundOverlayColor,
                            atmosphere: backgroundAtmosphere,
                          ),
                        ],
                      ),
                    ),
                  ),
          SafeArea(
            child: hasCustomSlivers
                ? CustomScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                        sliver: SliverList.list(
                          children: [
                            ...headerContent,
                            ...children,
                          ],
                        ),
                      ),
                      ...bodySlivers!,
                      if (bottomInset > 0)
                        SliverToBoxAdapter(
                          child: SizedBox(height: bottomInset),
                        ),
                    ],
                  )
                : ListView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16, 18, 16, bottomInset),
                    children: [
                      ...headerContent,
                      ...children,
                    ],
                  ),
          ),
          if (floatingBottom != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: _homeMatchedFloatingBottomOffset,
              child: floatingBottom!,
            ),
        ],
      ),
    );
  }
}

class _AnimatedQuoteHeader extends StatefulWidget {
  const _AnimatedQuoteHeader({
    required this.child,
    required this.reduceMotion,
    required this.style,
  });

  final Widget child;
  final bool reduceMotion;
  final AppPageTransitionStyle style;

  @override
  State<_AnimatedQuoteHeader> createState() => _AnimatedQuoteHeaderState();
}

class _AnimatedPageEntrance extends StatefulWidget {
  const _AnimatedPageEntrance({
    required this.child,
    required this.reduceMotion,
    required this.style,
  });

  final Widget child;
  final bool reduceMotion;
  final AppPageTransitionStyle style;

  @override
  State<_AnimatedPageEntrance> createState() => _AnimatedPageEntranceState();
}

class _AnimatedPageEntranceState extends State<_AnimatedPageEntrance> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reduceMotion) return widget.child;
    if (widget.style == AppPageTransitionStyle.noAnimation) {
      return widget.child;
    }
    if (widget.style == AppPageTransitionStyle.gentleFade) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      );
    }
    return AnimatedSlide(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.012),
      child: widget.child,
    );
  }
}

class _AnimatedQuoteHeaderState extends State<_AnimatedQuoteHeader> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reduceMotion) return widget.child;
    if (widget.style == AppPageTransitionStyle.noAnimation) {
      return widget.child;
    }
    if (widget.style == AppPageTransitionStyle.gentleFade) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      );
    }
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.024),
      child: widget.child,
    );
  }
}
