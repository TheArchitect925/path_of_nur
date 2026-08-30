import 'package:flutter/material.dart';

import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_quote_block.dart';

/// The Learn section's page shell.
///
/// This is a thin wrapper over [AppPageScaffold]; it exists so Learn pages
/// share one set of header defaults. It used to route through
/// `SectionHubScaffold` for a floating shortcut dock, but no Learn page has
/// passed shortcut actions since the docks were retired, so that layer is gone.
///
/// [showDefaultQuote] is **off** by default. A decorative quote belongs on a
/// section's front door, not on every list, picker and detail page beneath it —
/// which is what the old default produced. Pages that want one either opt in
/// explicitly or pass a [quote] of their own.
class LearnHubPageScaffold extends StatelessWidget {
  const LearnHubPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.headerIcon,
    this.headerIconSize = 24,
    this.headerIconSpacing = 12,
    this.headerAlignment = AppPageHeaderAlignment.start,
    this.backgroundAssetPath,
    this.backgroundOverlayColor,
    this.quote,
    this.quoteHeader,
    this.showDefaultQuote = false,
    this.headerActions,
    this.floatingBottom,
    this.layoutConfig = PageLayoutConfig.standard,
    this.ownsBackground = true,
  });

  final String title;
  final String subtitle;
  final IconData? headerIcon;
  final double headerIconSize;
  final double headerIconSpacing;
  final AppPageHeaderAlignment headerAlignment;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final List<Widget> children;
  final QuranQuote? quote;
  final Widget? quoteHeader;
  final bool showDefaultQuote;
  final List<Widget>? headerActions;
  final Widget? floatingBottom;
  final PageLayoutConfig layoutConfig;
  final bool ownsBackground;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: headerIcon,
      headerIconSize: headerIconSize,
      headerIconSpacing: headerIconSpacing,
      headerAlignment: headerAlignment,
      title: title,
      subtitle: subtitle,
      quote: showDefaultQuote ? (quote ?? buildLearningCompactQuote()) : quote,
      quoteHeader: quoteHeader,
      quoteUseOuterChrome: false,
      headerActions: headerActions,
      backgroundAssetPath: backgroundAssetPath,
      backgroundOverlayColor: backgroundOverlayColor,
      layoutConfig: layoutConfig,
      ownsBackground: ownsBackground,
      floatingBottom: floatingBottom == null
          ? null
          : Align(alignment: Alignment.centerRight, child: floatingBottom!),
      children: [
        ...children,
        // Clears the floating control so the last row is never trapped behind
        // it. Matches the spacer SectionHubScaffold used to append.
        if (floatingBottom != null) const SizedBox(height: 108),
      ],
    );
  }
}
