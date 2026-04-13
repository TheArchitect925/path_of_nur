import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';

typedef LearnHubShortcutAction = SectionShortcutAction;

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
    this.showDefaultQuote = true,
    this.shortcutActions = const <LearnHubShortcutAction>[],
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
  final List<LearnHubShortcutAction> shortcutActions;
  final List<Widget>? headerActions;
  final Widget? floatingBottom;
  final PageLayoutConfig layoutConfig;
  final bool ownsBackground;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionHubScaffold(
      headerIcon: headerIcon,
      headerIconSize: headerIconSize,
      headerIconSpacing: headerIconSpacing,
      headerAlignment: headerAlignment,
      title: title,
      subtitle: subtitle,
      quote: showDefaultQuote ? (quote ?? buildLearningCompactQuote()) : quote,
      quoteHeader: quoteHeader,
      quoteUseOuterChrome: false,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: shortcutActions,
      headerActions: headerActions,
      floatingBottom: floatingBottom,
      layoutConfig: layoutConfig,
      ownsBackground: ownsBackground,
      backgroundAssetPath: backgroundAssetPath,
      backgroundOverlayColor: backgroundOverlayColor,
      children: children,
    );
  }
}
