import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../presentation/widgets/learn_section_header.dart';
import '../data/wudu_content.dart';
import '../widgets/wudu_cards.dart';

class WuduGuidePage extends StatelessWidget {
  const WuduGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = buildWuduContent(l10n);

    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.wudhu,
      title: content.heroTitle,
      subtitle: content.heroSubtitle,
      children: [
        WuduHeroCard(
          title: content.heroTitle,
          subtitle: content.heroSubtitle,
          note: content.learningNote,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.pushNamed('learnWuduTrainer'),
            icon: const Icon(Icons.play_circle_fill_rounded),
            label: Text(l10n.wuduGuideStartTrainerAction),
          ),
        ),
        const SizedBox(height: 12),
        LearnSectionHeader(
          title: l10n.wuduGuideWhyTitle,
          subtitle: l10n.wuduGuideWhySubtitle,
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Text(
            content.whyWuduMatters,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ),
        const SizedBox(height: 12),
        WuduVerseCard(
          title: l10n.wuduGuideQuranBasisTitle,
          verse: content.quranVerse,
          reference: content.quranReference,
          referenceLabel: content.quranReferenceLabel,
          referenceSubtitle: content.quranReferenceSubtitle,
        ),
        const SizedBox(height: 14),
        LearnSectionHeader(
          title: content.stepsTitle,
          subtitle: content.stepsSubtitle,
        ),
        const SizedBox(height: 10),
        ...content.steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WuduStepCard(step: step),
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          height: 20,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        WuduDuaCard(dua: content.afterWuduDua),
        const SizedBox(height: 10),
        WuduCompletionCard(
          title: l10n.wuduGuideCompletionTitle,
          body: l10n.wuduGuideCompletionBody,
        ),
      ],
    );
  }
}
