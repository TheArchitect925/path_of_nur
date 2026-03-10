import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class CommunityModerationPage extends ConsumerWidget {
  const CommunityModerationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(circlesProvider);
    final notifier = ref.read(circlesProvider.notifier);
    final trustLevel = ref.watch(communityTrustLevelProvider);
    final pending = ref.watch(pendingCircleEventsProvider);
    final reportCounts = ref.watch(reportCountByEventProvider);
    final canModerate = trustLevel == CommunityTrustLevel.steward;

    return AppPageScaffold(
      headerIcon: Icons.gavel_outlined,
      title: l10n.circlesModerationTitle,
      subtitle: l10n.circlesModerationSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesTrustLevelTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '${_trustLabel(l10n, trustLevel)} • ${state.trustScore}/100',
              ),
              const SizedBox(height: 6),
              Text(
                canModerate
                    ? l10n.circlesModerationAccessReady
                    : l10n.circlesModerationAccessLimited,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesPendingEventsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (pending.isEmpty)
                Text(l10n.circlesPendingEventsEmpty)
              else
                ...pending.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${event.location} • ${event.dateIso.substring(0, 10)}',
                        ),
                        if ((reportCounts[event.id] ?? 0) > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.circlesEventReportCount(
                              reportCounts[event.id] ?? 0,
                            ),
                            style: const TextStyle(color: Color(0xFF8A5E1A)),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.tonal(
                              onPressed: canModerate
                                  ? () => notifier.approveEvent(event.id)
                                  : null,
                              child: Text(l10n.circlesApproveEvent),
                            ),
                            FilledButton.tonal(
                              onPressed: canModerate
                                  ? () => notifier.rejectEvent(event.id)
                                  : null,
                              child: Text(l10n.circlesRejectEvent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesPolicyTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.circlesPolicyBody),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesReportLogTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (state.reports.isEmpty)
                Text(l10n.circlesReportLogEmpty)
              else
                ...state.reports
                    .take(8)
                    .map(
                      (report) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• ${report.targetType}:${report.targetId} — ${report.reason}',
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  String _trustLabel(AppLocalizations l10n, CommunityTrustLevel level) {
    switch (level) {
      case CommunityTrustLevel.newMember:
        return l10n.circlesTrustLevelLow;
      case CommunityTrustLevel.trusted:
        return l10n.circlesTrustLevelMedium;
      case CommunityTrustLevel.steward:
        return l10n.circlesTrustLevelHigh;
    }
  }
}
