import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../application/kids_reward_world_provider.dart';

/// One row that says how the child is doing, everywhere a page used to
/// show its own currency: how many stickers, and the one streak.
class KidsRewardStrip extends ConsumerWidget {
  const KidsRewardStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final world = ref.watch(kidsRewardWorldProvider);
    return CompactListTile(
      leading: const HubLeadingIcon(AppIcons.fun),
      title: l10n.kidsStickerBookTitle,
      subtitle:
          '${l10n.kidsRewardStickersCountValue(world.stickerCount)} · '
          '${l10n.kidsRewardStreakValue(world.streakDays)}',
      onTap: () => context.pushNamed('kidsStickerBook'),
    );
  }
}
