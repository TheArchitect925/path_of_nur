import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
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
    this.backgroundAssetPath,
    this.backgroundOverlayColor,
    this.quote,
    this.shortcutActions = const <LearnHubShortcutAction>[],
    this.headerActions,
  });

  final String title;
  final String subtitle;
  final IconData? headerIcon;
  final String? backgroundAssetPath;
  final Color? backgroundOverlayColor;
  final List<Widget> children;
  final QuranQuote? quote;
  final List<LearnHubShortcutAction> shortcutActions;
  final List<Widget>? headerActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionHubScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      quote: quote ?? buildLearningCompactQuote(),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: shortcutActions,
      headerActions: headerActions,
      backgroundAssetPath: backgroundAssetPath,
      backgroundOverlayColor: backgroundOverlayColor,
      children: children,
    );
  }
}
