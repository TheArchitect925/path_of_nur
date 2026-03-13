import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'global_background.dart';
import 'quran_navigation.dart';
import 'quran_quote_block.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.quote,
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
  final IconData? headerIcon;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final ScrollController? scrollController;
  final List<Widget>? headerActions;
  final Widget? floatingBottom;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final foreground = appearance?.onSurface ?? const Color(0xFF3A3026);
    return Stack(
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
                if (quote != null) ...[
                  const SizedBox(height: 12),
                  QuranQuoteBlock(
                    quote: quote!,
                    onTap: () {
                      if (onQuoteTap != null) {
                        onQuoteTap!(quote!);
                        return;
                      }
                      openQuranQuoteLocation(context, quote!);
                    },
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
    );
  }
}
