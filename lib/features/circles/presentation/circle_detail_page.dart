import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';
import '../../../core/theme/app_icons.dart';

class CircleDetailPage extends ConsumerWidget {
  const CircleDetailPage({super.key, required this.circleId});

  final String circleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    CircleItem? circle;
    for (final item in stagedCircles) {
      if (item.id == circleId) {
        circle = item;
        break;
      }
    }
    final state = ref.watch(circlesProvider);
    final notifier = ref.read(circlesProvider.notifier);
    final events = ref.watch(circleEventsByCircleProvider(circleId));

    if (circle == null) {
      return AppPageScaffold(
        title: l10n.circlesTitle,
        children: [PremiumCard(child: Text(l10n.circlesNotFound))],
      );
    }
    final resolvedCircle = circle;

    final joined = state.joinedIds.contains(resolvedCircle.id);
    final favorited = state.favoritedIds.contains(resolvedCircle.id);
    final saved = state.savedIds.contains(resolvedCircle.id);

    return AppPageScaffold(
      title: resolvedCircle.title,
      subtitle: resolvedCircle.category,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(resolvedCircle.description),
              const SizedBox(height: 8),
              Text(l10n.circlesMembers(resolvedCircle.memberCount)),
              const SizedBox(height: 4),
              Text('${l10n.circlesCityLabel}: ${resolvedCircle.city}'),
              Text('${l10n.circlesFocusLabel}: ${resolvedCircle.focus}'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: resolvedCircle.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => notifier.toggleJoin(resolvedCircle.id),
                      child: Text(
                        joined ? l10n.circlesLeave : l10n.circlesJoin,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => notifier.toggleFavorite(resolvedCircle.id),
                    icon: Icon(
                      favorited
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () => notifier.toggleSaved(resolvedCircle.id),
                    icon: Icon(
                      saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (resolvedCircle.mosqueBuddyFriendly)
                FilledButton.tonalIcon(
                  onPressed: () => notifier.toggleJoin(resolvedCircle.id),
                  icon: const Icon(AppIcons.mosque),
                  label: Text(
                    joined
                        ? l10n.circlesMosqueBuddyActive
                        : l10n.circlesMosqueBuddyFind,
                  ),
                ),
              if (resolvedCircle.mosqueBuddyFriendly) const SizedBox(height: 8),
              if (resolvedCircle.mosqueBuddyFriendly)
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed('mosqueBuddyPrefs'),
                  icon: const Icon(Icons.tune_rounded),
                  label: Text(l10n.circlesMosqueBuddyPrefsTitle),
                ),
              if (resolvedCircle.mosqueBuddyFriendly) const SizedBox(height: 8),
              Text(
                l10n.circlesGuidance,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () {
                  notifier.addReport(
                    targetType: 'circle',
                    targetId: resolvedCircle.id,
                    reason: 'policy',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.circlesReportSubmitted)),
                  );
                },
                icon: const Icon(Icons.outlined_flag_rounded),
                label: Text(l10n.circlesReport),
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
                l10n.circlesActivityPreviewTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...resolvedCircle.activity.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• ${item.author}: ${item.text}'),
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
                l10n.circlesEventsTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...resolvedCircle.events.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(item.title)),
                      Text(item.dateHint),
                    ],
                  ),
                ),
              ),
              if (events.isNotEmpty) const SizedBox(height: 8),
              ...events.map((event) {
                final attendance = ref.watch(
                  circleEventAttendanceProvider(event.id),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title),
                      if (event.createdByRole ==
                              CircleEventCreatorRole.mosqueModerator &&
                          event.status == CircleEventStatus.approved)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            l10n.circlesMosqueVerifiedBadge,
                            style: const TextStyle(
                              color: Color(0xFF2E6B43),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.circlesEventCapacity(
                          attendance.goingCount,
                          attendance.capacity,
                          attendance.interestedCount,
                        ),
                      ),
                      if (event.approvedByLabel != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            l10n.circlesEventApprovedAudit(
                              event.approvedByLabel!,
                              (event.approvedAtIso ?? '').split('T').first,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      if (attendance.waitlistActive)
                        Text(
                          l10n.circlesWaitlistActive,
                          style: const TextStyle(color: Color(0xFF8A5E1A)),
                        ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l10n.circlesRsvpGoing),
                            selected:
                                state.eventRsvpById[event.id] ==
                                CircleEventRsvpStatus.going,
                            onSelected: (_) => notifier.setEventRsvp(
                              event.id,
                              CircleEventRsvpStatus.going,
                            ),
                          ),
                          ChoiceChip(
                            label: Text(l10n.circlesReport),
                            selected: false,
                            onSelected: (_) {
                              notifier.addReport(
                                targetType: 'event',
                                targetId: event.id,
                                reason: 'policy',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.circlesReportSubmitted),
                                ),
                              );
                            },
                          ),
                          ChoiceChip(
                            label: Text(l10n.circlesRsvpInterested),
                            selected:
                                state.eventRsvpById[event.id] ==
                                CircleEventRsvpStatus.interested,
                            onSelected: (_) => notifier.setEventRsvp(
                              event.id,
                              CircleEventRsvpStatus.interested,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
