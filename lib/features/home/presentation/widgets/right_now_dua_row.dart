import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../learn/dua/application/contextual_dua_provider.dart';

/// Horizontal row of duas matched to the present moment (time of day,
/// weekday, prayer window) via the orchestration metadata on the dua seed
/// dataset. Renders nothing while loading or when no dua qualifies.
class RightNowDuaRow extends ConsumerWidget {
  const RightNowDuaRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final suggestions =
        ref.watch(contextualDuaSuggestionsProvider).valueOrNull ??
        const <ContextualDuaSuggestion>[];
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        SectionTitle(
          title: l10n.homeRightNowTitle,
          subtitle: l10n.homeRightNowSubtitle,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final suggestion in suggestions) ...[
                  _RightNowDuaTile(suggestion: suggestion),
                  if (suggestion != suggestions.last)
                    const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _RightNowDuaTile extends StatelessWidget {
  const _RightNowDuaTile({required this.suggestion});

  final ContextualDuaSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final item = suggestion.item;
    return SizedBox(
      width: 240,
      child: PremiumCard(
        density: PremiumCardDensity.compact,
        onTap: () => context.pushNamed(
          'learnDuaDetail',
          pathParameters: {'duaId': item.id},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (item.whenToSay.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.whenToSay,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
