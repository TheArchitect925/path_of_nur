import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final content = wuduContent;

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
            label: const Text('Start Wudu Trainer'),
          ),
        ),
        const SizedBox(height: 12),
        const LearnSectionHeader(
          title: 'Why Wudu matters',
          subtitle:
              'Purification before prayer is both spiritual preparation and physical cleanliness.',
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
          verse: content.quranVerse,
          reference: content.quranReference,
        ),
        const SizedBox(height: 14),
        const LearnSectionHeader(
          title: 'Step-by-step guide',
          subtitle: 'Expand each step to review the sequence clearly.',
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
        const LearnSectionHeader(
          title: 'Common mistakes / reminders',
          subtitle:
              'Required essentials, sunnah details, and practical checks.',
        ),
        const SizedBox(height: 10),
        WuduReminderCard(
          requiredEssentials: content.requiredEssentials,
          sunnahEnhancements: content.sunnahEnhancements,
          reminders: content.reminders,
        ),
        const SizedBox(height: 10),
        Divider(
          height: 20,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        WuduDuaCard(dua: content.afterWuduDua),
        const SizedBox(height: 10),
        const WuduCompletionCard(),
      ],
    );
  }
}
