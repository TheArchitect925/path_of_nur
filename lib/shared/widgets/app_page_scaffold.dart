import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/nav_tabs.dart';
import '../../core/theme/app_backgrounds.dart';
import '../../core/theme/app_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import 'display/hub_list_group.dart';
import 'global_background.dart';
import 'quran_navigation.dart';
import 'quran_quote_block.dart';

class PageLayoutConfig {
  final bool extendBehindBottomNav;

  const PageLayoutConfig({this.extendBehindBottomNav = false});

  static const standard = PageLayoutConfig();
  static const immersive = PageLayoutConfig(extendBehindBottomNav: true);
}

/// The one page header.
///
/// Anatomy (header redesign, decision A1):
///
/// * A page that can go back gets a **navigation row** first — the back
///   button on the left, any [headerActions] on the right — and then the
///   title block, full width from the page margin. The icon that used to sit
///   between the arrow and the title is gone: it repeated the row that opened
///   the page and pushed the title a hundred pixels in.
/// * A tab root or a deep-linked page has no navigation row; the title block
///   is the first line and the actions sit on it, aligned to the title, never
///   to the middle of a long subtitle.
/// * [headerIcon] renders as the same 38 px accent chip the hub rows use
///   ([HubLeadingIcon]), so a landing's header and the row that leads to it
///   share one language. Only landings pass it; the header conformance test
///   keeps pushed pages icon-free.
/// * [subtitle] is optional. A page with nothing to say under its title says
///   nothing; status text belongs in the body, not the subtitle slot.
///
/// A page opened by a deep link replaces the navigation stack, so it cannot
/// pop. When such a page is not a tab root, the navigation row still shows a
/// back button that returns to the page's own tab, so the header never
/// strands the reader.
class AppPageScaffold extends ConsumerStatefulWidget {
  static const double _homeMatchedBottomContentPadding = 136;
  static const double _homeMatchedFloatingBottomOffset = 92;

  const AppPageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.quote,
    this.quoteHeader,
    this.quotePool,
    this.quoteUseOuterChrome = true,
    this.headerIcon,
    this.onTitleTap,
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
  final String? subtitle;
  final QuranQuote? quote;
  final Widget? quoteHeader;
  final List<QuranQuote>? quotePool;
  final bool quoteUseOuterChrome;

  /// Landing pages only: drawn as the accent chip beside the title.
  final IconData? headerIcon;

  /// When set, the title block becomes tappable (e.g. the Qur'an reader's
  /// surah title opening its go-to picker).
  final VoidCallback? onTitleTap;
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

  /// The tab to return to when the page cannot pop but is not a tab root —
  /// the deep-link case. Null when the page is a root, or when there is no
  /// router at all (widget tests build the scaffold bare).
  NavTab? _deepLinkReturnTab(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router == null) return null;
    final location = router.routerDelegate.currentConfiguration.uri.path;
    for (final tab in NavTab.values) {
      if (location == tab.path) return null;
    }
    for (final tab in NavTab.values) {
      if (location.startsWith('${tab.path}/')) return tab;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final returnTab = canPop ? null : _deepLinkReturnTab(context);
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
    final subtitle = widget.subtitle;
    final hasSubtitle = subtitle != null && subtitle.trim().isNotEmpty;
    final hasActions =
        widget.headerActions != null && widget.headerActions!.isNotEmpty;
    final hasNavRow = canPop || returnTab != null;

    // Every icon button in the header — back, home, the page's own actions —
    // takes the header foreground, so the header reads as one object rather
    // than three tones (H3 in the audit).
    final headerIconButtonTheme = IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: foreground,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(40, 40),
        padding: const EdgeInsets.all(8),
      ),
    );

    Widget backButton() {
      return IconButton(
        key: const ValueKey('app-page-back'),
        onPressed: () {
          if (canPop) {
            Navigator.of(context).maybePop();
          } else if (returnTab != null) {
            context.go(returnTab.path);
          }
        },
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const BackButtonIcon(),
      );
    }

    Widget actionsRow() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.headerActions!,
      );
    }

    final titleBlock = _MaybeTappable(
      onTap: widget.onTitleTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: foreground),
          ),
          if (hasSubtitle) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: subtleForeground),
            ),
          ],
        ],
      ),
    );

    final headerContent = <Widget>[
      IconButtonTheme(
        data: headerIconButtonTheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasNavRow) ...[
              // Navigation row: back on the left, actions on the right. The
              // back button sits 8 px outside the text margin so its glyph
              // lines up with the title below it.
              Padding(
                padding: const EdgeInsets.only(left: 0, bottom: 6),
                child: Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(-8, 0),
                      child: backButton(),
                    ),
                    const Spacer(),
                    if (hasActions) actionsRow(),
                  ],
                ),
              ),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.headerIcon != null) ...[
                  Padding(
                    // Centres the 38 px chip on the 30 px title line.
                    padding: const EdgeInsets.only(top: 0),
                    child: HubLeadingIcon(widget.headerIcon!),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(child: titleBlock),
                if (hasActions && !hasNavRow) ...[
                  const SizedBox(width: 8),
                  // Root pages keep their actions on the title line. The
                  // button is 40 px against a 30 px title line, so it is
                  // nudged up to share the title's optical centre.
                  Transform.translate(
                    offset: const Offset(8, -5),
                    child: actionsRow(),
                  ),
                ],
              ],
            ),
          ],
        ),
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

class _MaybeTappable extends StatelessWidget {
  const _MaybeTappable({required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child;
    // Self-sufficient Material: the page header renders above any Scaffold
    // material, so the ink needs its own surface to paint on.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: const ValueKey('app-page-title-tap'),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
