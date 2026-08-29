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

enum AppPageHeaderAlignment { start, center }

class AppPageScaffold extends ConsumerStatefulWidget {
  static const double _homeMatchedBottomContentPadding = 136;
  static const double _homeMatchedFloatingBottomOffset = 92;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.quote,
    this.quoteHeader,
    this.quotePool,
    this.quoteUseOuterChrome = true,
    this.headerIcon,
    this.headerIconSize = 24,
    this.headerIconSpacing = 12,
    this.headerAlignment = AppPageHeaderAlignment.start,
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
  final bool quoteUseOuterChrome;
  final IconData? headerIcon;
  final double headerIconSize;
  final double headerIconSpacing;
  final AppPageHeaderAlignment headerAlignment;
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
  ConsumerState<AppPageScaffold> createState() => _AppPageScaffoldState();
}

class _AppPageScaffoldState extends ConsumerState<AppPageScaffold> {
  // Pages that bring their own controller keep it; the rest get one here so
  // the scroll indicator always has something to attach to.
  ScrollController? _fallbackController;

  ScrollController get _effectiveController =>
      widget.scrollController ?? (_fallbackController ??= ScrollController());

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground =
        appearance?.backgroundForeground ?? const Color(0xFF3A3026);
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ?? const Color(0xFF5D4F44);
    final resolvedQuote =
        widget.quote ??
        (widget.quotePool == null
            ? null
            : quoteFromPoolForToday(widget.quotePool!));
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final pageTransitionStyle = ref.watch(
      profileSettingsProvider.select((value) => value.pageTransitionStyle),
    );
    final bottomInset = widget.layoutConfig.extendBehindBottomNav
        ? 0.0
        : AppPageScaffold._homeMatchedBottomContentPadding;
    final headerCrossAxisAlignment =
        widget.headerAlignment == AppPageHeaderAlignment.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final headerContent = <Widget>[
      if (canPop || widget.headerIcon != null)
        Row(
          crossAxisAlignment: headerCrossAxisAlignment,
          children: [
            if (canPop)
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const BackButtonIcon(),
                color: foreground,
              ),
            if (canPop && widget.headerIcon != null) const SizedBox(width: 4),
            if (widget.headerIcon != null)
              Icon(
                widget.headerIcon,
                color: foreground,
                size: widget.headerIconSize,
              ),
            if (widget.headerIcon != null)
              SizedBox(width: widget.headerIconSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
                  ),
                ],
              ),
            ),
            if (widget.headerActions != null) ...[
              const SizedBox(width: 8),
              ...widget.headerActions!,
            ],
          ],
        )
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: foreground),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
            ),
          ],
        ),
      const SizedBox(height: 12),
      if (widget.quoteHeader != null) ...[
        const SizedBox(height: 12),
        _AnimatedQuoteHeader(
          reduceMotion: reduceMotion,
          style: pageTransitionStyle,
          child: widget.quoteHeader!,
        ),
      ] else if (resolvedQuote != null) ...[
        const SizedBox(height: 12),
        _AnimatedQuoteHeader(
          reduceMotion: reduceMotion,
          style: pageTransitionStyle,
          child: QuranQuoteBlock(
            quote: resolvedQuote,
            useOuterChrome: widget.quoteUseOuterChrome,
            onTap: () {
              if (widget.onQuoteTap != null) {
                widget.onQuoteTap!(resolvedQuote);
                return;
              }
              openQuranQuoteLocation(context, resolvedQuote);
            },
          ),
        ),
      ],
      const SizedBox(height: 20),
    ];
    final hasCustomSlivers = widget.bodySlivers != null;
    return _AnimatedPageEntrance(
      reduceMotion: reduceMotion,
      style: pageTransitionStyle,
      child: Stack(
        children: [
          if (widget.ownsBackground)
            widget.layoutConfig.extendBehindBottomNav
                ? GlobalBackground(
                    assetPath: widget.backgroundAssetPath,
                    overlayColor: widget.backgroundOverlayColor,
                    atmosphere: widget.backgroundAtmosphere,
                  )
                : ClipRect(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: Stack(
                        children: [
                          GlobalBackground(
                            assetPath: widget.backgroundAssetPath,
                            overlayColor: widget.backgroundOverlayColor,
                            atmosphere: widget.backgroundAtmosphere,
                          ),
                        ],
                      ),
                    ),
                  ),
          SafeArea(
            // A thin scroll indicator so long pages show how much is left.
            child: Scrollbar(
              controller: _effectiveController,
              thickness: 3,
              radius: const Radius.circular(999),
              child: hasCustomSlivers
                  ? CustomScrollView(
                      controller: _effectiveController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                          sliver: SliverList.list(
                            children: [...headerContent, ...widget.children],
                          ),
                        ),
                        ...widget.bodySlivers!,
                        if (bottomInset > 0)
                          SliverToBoxAdapter(
                            child: SizedBox(height: bottomInset),
                          ),
                      ],
                    )
                  : ListView(
                      controller: _effectiveController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16, 18, 16, bottomInset),
                      children: [...headerContent, ...widget.children],
                    ),
            ),
          ),
          if (widget.floatingBottom != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: AppPageScaffold._homeMatchedFloatingBottomOffset,
              child: widget.floatingBottom!,
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
