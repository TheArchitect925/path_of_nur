import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import 'global_background.dart';
import 'quran_navigation.dart';
import 'quran_quote_block.dart';

class AppPageScaffold extends ConsumerWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.quote,
    this.quotePool,
    this.headerIcon,
    this.onQuoteTap,
    this.scrollController,
    this.headerActions,
    this.floatingBottom,
    this.backgroundAssetPath,
    this.backgroundOverlayColor,
    required this.children,
  });

  final String title;
  final String subtitle;
  final QuranQuote? quote;
  final List<QuranQuote>? quotePool;
  final IconData? headerIcon;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final ScrollController? scrollController;
  final List<Widget>? headerActions;
  final Widget? floatingBottom;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground = appearance?.onSurface ?? const Color(0xFF3A3026);
    final resolvedQuote =
        quote ?? (quotePool == null ? null : quoteFromPoolForToday(quotePool!));
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    return _AnimatedPageEntrance(
      reduceMotion: reduceMotion,
      child: Stack(
        children: [
          GlobalBackground(
            assetPath: backgroundAssetPath,
            overlayColor: backgroundOverlayColor,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  if (canPop || headerIcon != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (canPop)
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                            icon: const Icon(Icons.chevron_left),
                            color: foreground,
                          ),
                        if (canPop && headerIcon != null)
                          const SizedBox(width: 4),
                        if (headerIcon != null)
                          Icon(headerIcon, color: foreground, size: 24),
                        if (headerIcon != null) const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  if (resolvedQuote != null) ...[
                    const SizedBox(height: 12),
                    _AnimatedQuoteHeader(
                      reduceMotion: reduceMotion,
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
                  ...children,
                ],
              ),
            ),
          ),
          if (floatingBottom != null)
            Positioned(left: 16, right: 16, bottom: 92, child: floatingBottom!),
        ],
      ),
    );
  }
}

class _AnimatedQuoteHeader extends StatefulWidget {
  const _AnimatedQuoteHeader({required this.child, required this.reduceMotion});

  final Widget child;
  final bool reduceMotion;

  @override
  State<_AnimatedQuoteHeader> createState() => _AnimatedQuoteHeaderState();
}

class _AnimatedPageEntrance extends StatefulWidget {
  const _AnimatedPageEntrance({
    required this.child,
    required this.reduceMotion,
  });

  final Widget child;
  final bool reduceMotion;

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
    return AnimatedSlide(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.018),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
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
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
