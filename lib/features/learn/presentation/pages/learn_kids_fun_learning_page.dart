import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../../kids_dua_learning/application/kids_dua_creative_provider.dart';
import '../../../kids_dua_learning/application/kids_dua_story_repository.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_icons.dart';

class LearnKidsFunLearningPage extends ConsumerWidget {
  const LearnKidsFunLearningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final drawings = ref.watch(kidsDuaDrawingsProvider);
    final stories = ref.watch(kidsDuaStoriesProvider);

    return LearnHubPageScaffold(
      headerIcon: AppIcons.fun,
      title: l10n.learnHubSubcategoryKidsFunLearningTitle,
      subtitle: l10n.learnHubSubcategoryKidsFunLearningSubtitle,
      children: [
        SectionHubActionGrid(
          actions: [
            SectionHubAction(
              title: l10n.kidsStoryLibraryTitle,
              subtitle: l10n.kidsStoryLibrarySubtitle,
              icon: Icons.auto_stories_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsStoryLibrary'),
            ),
            SectionHubAction(
              title: l10n.kidsSeerahJourneysTitle,
              subtitle: l10n.kidsSeerahJourneysSubtitle,
              icon: Icons.route_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsSeerahJourneys'),
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
              title: l10n.kidsDuaStoriesTitle,
              subtitle: l10n.kidsDuaStoriesLandingSubtitle(stories.length),
              icon: Icons.menu_book_rounded,
              color: context.palette.surfaceSoft,
              accentColor: context.palette.cautionInk,
              onTap: () => context.pushNamed('kidsDuaStories'),
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
}
