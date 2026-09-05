import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../learn/shared/learn_art_assets.dart';
import '../../shared/presentation/kids_page_scaffold.dart';
import '../application/kids_reward_world_provider.dart';
import '../domain/kids_sticker_models.dart';
import 'kids_invitation_card.dart';
import 'kids_sticker_badge.dart';
import 'kids_sticker_titles.dart';

/// The sticker book: every story, letter and duʿā the child has finished,
/// and the milestones on top, on four pages. The one place a child looks
/// to see how far they have come.
class KidsStickerBookPage extends ConsumerWidget {
  const KidsStickerBookPage({super.key});

  static const _sections = <KidsStickerKind>[
    KidsStickerKind.story,
    KidsStickerKind.letter,
    KidsStickerKind.dua,
    KidsStickerKind.special,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final world = ref.watch(kidsRewardWorldProvider);
    return KidsPageScaffold(
      headerIcon: AppIcons.fun,
      title: l10n.kidsStickerBookTitle,
      subtitle: l10n.kidsStickerBookSubtitle,
      heroAsset:
          kidsSubcategoryArtAsset('kids-fun-learning') ??
          'assets/images/learn_art/kids_fun_learning.webp',
      heroTitle: l10n.kidsRewardStickersCountValue(world.stickerCount),
      heroSubtitle: l10n.kidsRewardStreakValue(world.streakDays),
      children: [
        if (world.stickers.isEmpty)
          // The hero already says "No stickers yet"; the card says what to do.
          KidsInvitationCard(
            title: l10n.kidsInvitationFirstStoryTitle,
            subtitle: l10n.kidsStickerBookEmptySubtitle,
            fallbackIcon: AppIcons.stories,
            onTap: () => context.pushNamed('kidsStoryLibrary'),
          )
        else
          for (final kind in _sections)
            if (world.ofKind(kind).isNotEmpty) ...[
              SectionTitle(title: _sectionTitle(l10n, kind)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 14,
                children: [
                  for (final sticker in world.ofKind(kind))
                    _StickerTile(sticker: sticker),
                ],
              ),
              const SizedBox(height: 18),
            ],
      ],
    );
  }

  String _sectionTitle(AppLocalizations l10n, KidsStickerKind kind) {
    switch (kind) {
      case KidsStickerKind.story:
        return l10n.kidsDoorStoriesTitle;
      case KidsStickerKind.letter:
        return l10n.kidsDoorLettersTitle;
      case KidsStickerKind.dua:
        return l10n.kidsDoorDuasTitle;
      case KidsStickerKind.special:
        return l10n.kidsStickerBookSpecialSection;
    }
  }
}

class _StickerTile extends StatelessWidget {
  const _StickerTile({required this.sticker});

  final KidsSticker sticker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          KidsStickerBadge(sticker: sticker, size: 80),
          const SizedBox(height: 6),
          Text(
            kidsStickerTitle(l10n, sticker),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
