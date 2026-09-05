import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class CirclesJoinedPage extends ConsumerWidget {
  const CirclesJoinedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final joined = ref.watch(joinedCirclesProvider);
    final saved = ref.watch(favoritedCirclesProvider);
    final accountability = ref.watch(joinedAccountabilityGroupsProvider);

    return AppPageScaffold(
      title: l10n.circlesJoinedPageTitle,
      subtitle: l10n.circlesJoinedPageSubtitle,
      children: [
        PremiumCard(child: Text(l10n.circlesJoinedCount(joined.length))),
        const SizedBox(height: 12),
        if (joined.isEmpty)
          PremiumCard(child: Text(l10n.circlesJoinedEmpty))
        else
          ...joined.map(
            (circle) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(circle.title),
                  subtitle: Text('${circle.description}\n${circle.city}'),
                  isThreeLine: true,
                  onTap: () => context.pushNamed(
                    'circleDetail',
                    pathParameters: {'circleId': circle.id},
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesSavedTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text('${saved.length}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesAccountabilityTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text('${accountability.length}'),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('accountabilityGroups'),
                child: Text(l10n.circlesOpen),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
