import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/content/contextual_quran_quotes.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import 'dhikr/dhikr_landing_page.dart';
import 'widgets/fasting_section.dart';
import 'widgets/prayer_section.dart';

class WorshipPrayerPage extends StatelessWidget {
  const WorshipPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _WorshipSectionScaffold(
      headerIcon: IslamicIcons.prayer,
      title: l10n.worshipPrayerHubTitle,
      subtitle: l10n.worshipPrayerHubSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipPrayer),
      child: const PrayerSection(),
    );
  }
}

/// The dhikr route. The hub itself lives in [DhikrLandingPage]; this shell
/// keeps the route name every entry point already links to.
class WorshipDhikrPage extends StatelessWidget {
  const WorshipDhikrPage({super.key});

  @override
  Widget build(BuildContext context) => const DhikrLandingPage();
}

class WorshipFastingPage extends StatelessWidget {
  const WorshipFastingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _WorshipSectionScaffold(
      headerIcon: Icons.fastfood_outlined,
      title: l10n.fastingSectionTitle,
      subtitle: l10n.fastingSectionSubtitle,
      quote: buildContextualQuranQuote(ContextualQuranQuoteKey.worshipFasting),
      child: const FastingSection(),
    );
  }
}

class _WorshipSectionScaffold extends StatelessWidget {
  const _WorshipSectionScaffold({
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.child,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final QuranQuote quote;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionHubScaffold(
      ownsBackground: false,
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        QuranQuoteBlock(
          quote: quote,
          onTap: () => openQuranQuoteLocation(context, quote),
        ),
        child,
      ],
    );
  }
}
