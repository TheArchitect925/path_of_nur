import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../domain/prophet_entry.dart';
import 'prophets_metadata_localization.dart';

class ProphetsTimelineView extends StatefulWidget {
  const ProphetsTimelineView({
    super.key,
    required this.prophets,
    required this.onOpenDetail,
    this.focusedProphetId,
  });

  final List<ProphetEntry> prophets;
  final ValueChanged<ProphetEntry> onOpenDetail;
  final String? focusedProphetId;

  @override
  State<ProphetsTimelineView> createState() => _ProphetsTimelineViewState();
}

class _ProphetsTimelineViewState extends State<ProphetsTimelineView> {
  final Map<String, GlobalKey> _keys = <String, GlobalKey>{};

  @override
  void didUpdateWidget(covariant ProphetsTimelineView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusedProphetId != oldWidget.focusedProphetId &&
        widget.focusedProphetId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _keys[widget.focusedProphetId!];
        final ctx = key?.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 280),
            alignment: 0.1,
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grouped = <ProphetEraGroup, List<ProphetEntry>>{};
    for (final prophet in widget.prophets) {
      grouped.putIfAbsent(prophet.eraGroup, () => <ProphetEntry>[]);
      grouped[prophet.eraGroup]!.add(prophet);
    }

    return Column(
      children: ProphetEraGroup.values
          .where((era) => grouped[era]?.isNotEmpty == true)
          .map((era) {
            final list = grouped[era]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedProphetEraTitle(l10n, era),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localizedProphetEraSubtitle(l10n, era),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(list.length, (index) {
                      final prophet = list[index];
                      final key = _keys.putIfAbsent(
                        prophet.id,
                        () => GlobalKey(),
                      );
                      final focused = widget.focusedProphetId == prophet.id;
                      return _TimelineNodeCard(
                        key: key,
                        prophet: prophet,
                        isFirst: index == 0,
                        isLast: index == list.length - 1,
                        focused: focused,
                        onTap: () => widget.onOpenDetail(prophet),
                      );
                    }),
                  ],
                ),
              ),
            );
          })
          .toList(),
    );
  }
}

class _TimelineNodeCard extends StatelessWidget {
  const _TimelineNodeCard({
    super.key,
    required this.prophet,
    required this.isFirst,
    required this.isLast,
    required this.focused,
    required this.onTap,
  });

  final ProphetEntry prophet;
  final bool isFirst;
  final bool isLast;
  final bool focused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lineColor = context.palette.accent.withValues(alpha: 0.36);
    final nodeColor = focused ? context.palette.accent : prophet.eraGroup.tint;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  Container(
                    width: 2,
                    height: isFirst ? 0 : 18,
                    color: isFirst ? Colors.transparent : lineColor,
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: nodeColor,
                      boxShadow: focused
                          ? [
                              BoxShadow(
                                color: context.palette.accent.withValues(
                                  alpha: 0.42,
                                ),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: isLast ? 0 : 78,
                    color: isLast ? Colors.transparent : lineColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: focused
                      ? context.palette.accent.withValues(alpha: 0.12)
                      : context.palette.surface.withValues(alpha: 0.25),
                  border: Border.all(
                    color: focused
                        ? context.palette.accent.withValues(alpha: 0.55)
                        : context.palette.accentSoft.withValues(alpha: 0.28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${prophet.timelineOrder}. ${prophet.honoredName}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      prophet.honoredArabicName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.onSurfaceSubtle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.prophetsTimelineMeta(
                        localizedProphetEraTitle(l10n, prophet.eraGroup),
                        prophet.regionLabel,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prophet.shortSummary,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.onSurfaceSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
