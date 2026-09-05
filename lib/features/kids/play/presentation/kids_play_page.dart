import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../kids_dua_learning/application/kids_dua_creative_provider.dart';
import '../../../learn/shared/learn_art_assets.dart';
import '../../bedtime_stories/application/bedtime_story_repository.dart';
import '../../shared/presentation/kids_page_scaffold.dart';

/// The Play door: practice games, the featured story's quiz and memory
/// cards, colouring and drawing. Replaces the "Kids Games" and "Fun
/// Learning" link lists, which pointed at the same six places.
class KidsPlayPage extends ConsumerWidget {
  const KidsPlayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final drawings = ref.watch(kidsDuaDrawingsProvider);
    final featuredStory = ref.watch(featuredKidsStoryProvider);

    return KidsPageScaffold(
      headerIcon: AppIcons.games,
      title: l10n.kidsDoorPlayTitle,
      subtitle: l10n.kidsPlaySubtitle,
      heroAsset:
          kidsSubcategoryArtAsset('kids-games') ??
          'assets/images/learn_art/kids_games.webp',
      heroTitle: l10n.kidsDoorPlayTitle,
      heroSubtitle: l10n.kidsDoorPlaySubtitle,
      children: [
        HubListGroup(
          title: l10n.kidsPlayGamesSectionTitle,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.letters),
              title: l10n.kidsArabicPracticeTitle,
              subtitle: l10n.kidsArabicPracticeSubtitle,
              onTap: () => context.pushNamed('kidsArabicPractice'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.dua),
              title: l10n.kidsDuaPracticeTitle,
              subtitle: l10n.kidsDuaPracticeModeMatchSituation,
              onTap: () => context.pushNamed('kidsDuaPractice'),
            ),
            if (featuredStory != null) ...[
              CompactListTile(
                leading: const HubLeadingIcon(AppIcons.quiz),
                title: l10n.bedtimeStoryQuizTitle,
                subtitle: featuredStory.shortTitle,
                onTap: () => context.pushNamed(
                  'kidsStoryQuiz',
                  pathParameters: {'storyId': featuredStory.id},
                ),
              ),
              CompactListTile(
                leading: const HubLeadingIcon(AppIcons.games),
                title: l10n.bedtimeStoryMemoryTitle,
                subtitle: featuredStory.shortTitle,
                onTap: () => context.pushNamed(
                  'kidsStoryMemory',
                  pathParameters: {'storyId': featuredStory.id},
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        HubListGroup(
          title: l10n.kidsPlayMakeSectionTitle,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.fun),
              title: l10n.kidsArabicColoringPagesTitle,
              subtitle: l10n.kidsArabicColoringPagesSubtitle,
              onTap: () => context.pushNamed('kidsArabicColoringPages'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.dua),
              title: l10n.kidsDuaDrawingsTitle,
              subtitle: l10n.kidsDuaDrawingsLandingSubtitle(drawings.length),
              onTap: () => context.pushNamed('kidsDuaDrawings'),
            ),
          ],
        ),
      ],
    );
  }
}
