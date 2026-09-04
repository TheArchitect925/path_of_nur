import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../../kids/bedtime_stories/application/bedtime_story_repository.dart';
import '../../../kids/bedtime_stories/domain/bedtime_story_models.dart';
import '../../../kids_dua_learning/application/kids_dua_creative_provider.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_palette.dart';

class LearnKidsGamesPage extends ConsumerWidget {
  const LearnKidsGamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final featuredStory = ref.watch(featuredKidsStoryProvider);
    final drawings = ref.watch(kidsDuaDrawingsProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.sports_esports_rounded,
      title: l10n.learnHubSubcategoryKidsGamesTitle,
      subtitle: l10n.learnHubSubcategoryKidsGamesSubtitle,
      children: [
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.kidsArabicPracticeTitle,
              subtitle: l10n.kidsArabicPracticeSubtitle,
              icon: Icons.refresh_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsArabicPractice'),
            ),
            SectionHubAction(
              title: l10n.kidsDuaPracticeTitle,
              subtitle: l10n.kidsDuaPracticeModeMatchSituation,
              icon: Icons.quiz_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsDuaPractice'),
            ),
            if (featuredStory != null)
              _storyAction(
                context,
                title: l10n.bedtimeStoryQuizTitle,
                subtitle: featuredStory.shortTitle,
                icon: Icons.extension_rounded,
                routeName: 'kidsStoryQuiz',
                story: featuredStory,
              ),
            if (featuredStory != null)
              _storyAction(
                context,
                title: l10n.bedtimeStoryMemoryTitle,
                subtitle: featuredStory.shortTitle,
                icon: Icons.grid_view_rounded,
                routeName: 'kidsStoryMemory',
                story: featuredStory,
              ),
            SectionHubAction(
              title: l10n.kidsArabicColoringPagesTitle,
              subtitle: l10n.kidsArabicColoringPagesSubtitle,
              icon: Icons.format_paint_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsArabicColoringPages'),
            ),
            SectionHubAction(
              title: l10n.kidsDuaDrawingsTitle,
              subtitle: l10n.kidsDuaDrawingsLandingSubtitle(drawings.length),
              icon: Icons.brush_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsDuaDrawings'),
            ),
          ],
        ),
      ],
    );
  }

  SectionHubAction _storyAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String routeName,
    required BedtimeStorySeed story,
  }) {
    return SectionHubAction(
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: context.palette.surfaceSoft,
      accentColor: context.palette.cautionInk,
      onTap: () =>
          context.pushNamed(routeName, pathParameters: {'storyId': story.id}),
    );
  }
}
