import 'package:flutter/material.dart';

import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import 'help_guide_content.dart';

class HelpGuideDetailPage extends StatelessWidget {
  const HelpGuideDetailPage({super.key, required this.guideId});

  final String guideId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final guide = findHelpGuideEntry(l10n, guideId);
    if (guide == null) {
      return AppPageScaffold(
        headerIcon: Icons.help_center_outlined,
        title: l10n.settingsHelpGuideTitle,
        subtitle: l10n.settingsHelpGuideSubtitle,
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsHelpGuideNotFoundTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.settingsHelpGuideNotFoundSubtitle),
              ],
            ),
          ),
        ],
      );
    }

    return AppPageScaffold(
      headerIcon: guide.icon,
      title: guide.title,
      subtitle: guide.description,
      children: [
        PremiumCard(
          child: Text(
            guide.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.settingsHelpGuideStepsTitle,
          subtitle: l10n.settingsHelpGuideStepsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              for (var index = 0; index < guide.steps.length; index++) ...[
                if (index > 0) const Divider(height: 24),
                _GuideStepRow(
                  index: index + 1,
                  text: guide.steps[index],
                  accentColor: guide.accentColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GuideStepRow extends StatelessWidget {
  const _GuideStepRow({
    required this.index,
    required this.text,
    required this.accentColor,
  });

  final int index;
  final String text;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final badgeStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: accentColor,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: badgeStyle.decoration(radius: 999, includeShadow: false),
          child: Text(
            '$index',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
