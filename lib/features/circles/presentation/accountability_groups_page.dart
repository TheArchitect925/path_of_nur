import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class AccountabilityGroupsPage extends ConsumerWidget {
  const AccountabilityGroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groups = ref.watch(accountabilityGroupsProvider);
    final state = ref.watch(circlesProvider);
    final notifier = ref.read(circlesProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.groups_2_outlined,
      title: l10n.circlesAccountabilityTitle,
      subtitle: l10n.circlesAccountabilitySubtitle,
      children: [
        ...groups.map((group) {
          final joined = state.joinedAccountabilityGroupIds.contains(group.id);
          final streak = state.accountabilityCheckins[group.id] ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(group.description),
                  const SizedBox(height: 6),
                  Text(
                    '${group.focus} • ${group.defaultCadence} • ${group.memberCount}',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () =>
                              notifier.toggleAccountabilityGroup(group.id),
                          child: Text(
                            joined
                                ? l10n.circlesAccountabilityJoined
                                : l10n.circlesJoin,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: joined
                              ? () => notifier.checkInAccountabilityGroup(
                                  group.id,
                                )
                              : null,
                          child: Text(l10n.circlesAccountabilityCheckIn),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${l10n.circlesAccountabilityStreak}: $streak'),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
