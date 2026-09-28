import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/companion_surfaces_ui_state.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../data/learn_companion_content.dart';
import '../domain/learn_companion_models.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../shared/widgets/section_title.dart';

class DailyWisdomCompanionPage extends ConsumerStatefulWidget {
  const DailyWisdomCompanionPage({super.key, this.initialFocus});

  final String? initialFocus;

  @override
  ConsumerState<DailyWisdomCompanionPage> createState() =>
      _DailyWisdomCompanionPageState();
}

class _DailyWisdomCompanionPageState
    extends ConsumerState<DailyWisdomCompanionPage> {
  String? _selectedFocusId;
  String? _lastRecordedEntryId;

  @override
  void initState() {
    super.initState();
    _selectedFocusId = _normalizeFocus(widget.initialFocus);
  }

  @override
  void didUpdateWidget(covariant DailyWisdomCompanionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final updatedFocus = _normalizeFocus(widget.initialFocus);
    if (updatedFocus != _selectedFocusId) {
      setState(() {
        _selectedFocusId = updatedFocus;
      });
    }
  }

  String? _normalizeFocus(String? focusId) {
    final normalized = focusId?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    final entries = buildDailyWisdomEntries(l10n);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final uiState = ref.watch(companionSurfacesUiControllerProvider);
    final focusId = _selectedFocusId;
    final orderedEntries = orderDailyWisdomEntries(
      entries,
      now,
      focusedEntryId: focusId,
    );
    final featuredEntry = orderedEntries.first;
    final recentEntries = _orderByCurrentRhythm(
      _lookupEntries(
        uiState.recentDailyWisdomEntryIds,
        entries,
        excludeIds: {featuredEntry.id},
      ),
      orderedEntries,
    );
    final savedEntries = _orderByCurrentRhythm(
      _lookupEntries(
        uiState.savedDailyWisdomEntryIds.toList(growable: false),
        entries,
        excludeIds: {featuredEntry.id},
      ),
      orderedEntries,
    );
    final fallbackRecentEntries = _fallbackRecentEntries(
      orderedEntries,
      featuredEntry.id,
    );

    if (_lastRecordedEntryId != featuredEntry.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(companionSurfacesUiControllerProvider.notifier)
            .recordDailyWisdomViewed(featuredEntry.id);
        _lastRecordedEntryId = featuredEntry.id;
      });
    }

    return LearnHubPageScaffold(
      headerIcon: AppIcons.daily,
      title: l10n.learningJourneyDailyWisdomTitle,
      subtitle: l10n.learningJourneyDailyWisdomSubtitle,
      children: [
        PremiumCard(
          child: Text(
            l10n.learningJourneyDailyWisdomDescription,
            style: bodyStyle,
          ),
        ),
        if (focusId != null && focusId == featuredEntry.id) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SourceChip(label: featuredEntry.ownerLabel),
                    _SourceChip(label: featuredEntry.themeLabel),
                  ],
                ),
                const SizedBox(height: 6),
                Text(featuredEntry.sourceSubtitle, style: bodyStyle),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        SectionTitle(
          title: l10n.learnDailyWisdomTodayTitle,
          subtitle: l10n.learnDailyWisdomTodaySubtitle,
        ),
        const SizedBox(height: 10),
        Semantics(
          container: true,
          label: featuredEntry.title,
          hint: featuredEntry.body,
          child: PremiumCard(
            key: Key('dailyWisdomFeatured-${featuredEntry.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _SourceChip(label: featuredEntry.ownerLabel),
                    Tooltip(
                      message:
                          uiState.savedDailyWisdomEntryIds.contains(
                            featuredEntry.id,
                          )
                          ? l10n.learnDailyWisdomSavedAction
                          : l10n.learnDailyWisdomSaveAction,
                      child: TextButton.icon(
                        onPressed: () => ref
                            .read(
                              companionSurfacesUiControllerProvider.notifier,
                            )
                            .toggleSavedDailyWisdom(featuredEntry.id),
                        icon: Icon(
                          uiState.savedDailyWisdomEntryIds.contains(
                                featuredEntry.id,
                              )
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                        label: Text(
                          uiState.savedDailyWisdomEntryIds.contains(
                                featuredEntry.id,
                              )
                              ? l10n.learnDailyWisdomSavedAction
                              : l10n.learnDailyWisdomSaveAction,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  featuredEntry.themeLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  featuredEntry.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(featuredEntry.body, style: bodyStyle),
                const SizedBox(height: 16),
                Text(
                  l10n.learnDailyWisdomCarryTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(featuredEntry.practicalStep, style: bodyStyle),
                const SizedBox(height: 16),
                Tooltip(
                  message: l10n.learningJourneyTodayLightOpenAction,
                  child: FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      featuredEntry.sourceRouteTarget.routeName,
                      pathParameters:
                          featuredEntry.sourceRouteTarget.pathParameters,
                      queryParameters:
                          featuredEntry.sourceRouteTarget.queryParameters,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(l10n.learningJourneyTodayLightOpenAction),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (savedEntries.isNotEmpty) ...[
          const SizedBox(height: 20),
          SectionTitle(
            title: l10n.learnDailyWisdomSavedTitle,
            subtitle: l10n.learnDailyWisdomSavedSubtitle,
          ),
          const SizedBox(height: 10),
          ...savedEntries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _WisdomEntryCard(
                entry: entry,
                onTap: () => context.pushNamed(
                  entry.sourceRouteTarget.routeName,
                  pathParameters: entry.sourceRouteTarget.pathParameters,
                  queryParameters: entry.sourceRouteTarget.queryParameters,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        SectionTitle(
          title: l10n.learnCompanionSourcesTitle,
          subtitle: l10n.learnDailyWisdomSourceSectionSubtitle,
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SourceChip(label: featuredEntry.ownerLabel),
                const SizedBox(height: 10),
                Text(
                  featuredEntry.sourceTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(featuredEntry.sourceSubtitle, style: bodyStyle),
            ),
            onTap: () => context.pushNamed(
              featuredEntry.sourceRouteTarget.routeName,
              pathParameters: featuredEntry.sourceRouteTarget.pathParameters,
              queryParameters: featuredEntry.sourceRouteTarget.queryParameters,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(
          title: l10n.learnDailyWisdomRecentTitle,
          subtitle: l10n.learnDailyWisdomRecentSubtitle,
        ),
        const SizedBox(height: 10),
        ...(recentEntries.isNotEmpty ? recentEntries : fallbackRecentEntries)
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WisdomEntryCard(
                  entry: entry,
                  onTap: () => context.pushNamed(
                    entry.sourceRouteTarget.routeName,
                    pathParameters: entry.sourceRouteTarget.pathParameters,
                    queryParameters: entry.sourceRouteTarget.queryParameters,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  List<DailyWisdomEntry> _lookupEntries(
    List<String> ids,
    List<DailyWisdomEntry> entries, {
    Set<String> excludeIds = const <String>{},
  }) {
    final entryById = {for (final entry in entries) entry.id: entry};
    return [
      for (final id in ids)
        if (!excludeIds.contains(id) && entryById.containsKey(id))
          entryById[id]!,
    ];
  }

  List<DailyWisdomEntry> _orderByCurrentRhythm(
    List<DailyWisdomEntry> entries,
    List<DailyWisdomEntry> orderedEntries,
  ) {
    final orderIndex = <String, int>{
      for (var index = 0; index < orderedEntries.length; index++)
        orderedEntries[index].id: index,
    };
    final sorted = [...entries];
    sorted.sort(
      (a, b) => (orderIndex[a.id] ?? orderedEntries.length).compareTo(
        orderIndex[b.id] ?? orderedEntries.length,
      ),
    );
    return sorted;
  }

  List<DailyWisdomEntry> _fallbackRecentEntries(
    List<DailyWisdomEntry> orderedEntries,
    String featuredId,
  ) {
    final selected = <DailyWisdomEntry>[];
    final seenOwners = <String>{};
    final seenThemes = <String>{};

    for (final entry in orderedEntries) {
      if (entry.id == featuredId) {
        continue;
      }
      final introducesNewOwner = !seenOwners.contains(entry.ownerLabel);
      final introducesNewTheme = !seenThemes.contains(entry.themeLabel);
      if (introducesNewOwner || introducesNewTheme || selected.length < 2) {
        selected.add(entry);
        seenOwners.add(entry.ownerLabel);
        seenThemes.add(entry.themeLabel);
      }
      if (selected.length == 4) {
        return selected;
      }
    }

    for (final entry in orderedEntries) {
      if (entry.id == featuredId ||
          selected.any((item) => item.id == entry.id)) {
        continue;
      }
      selected.add(entry);
      if (selected.length == 4) {
        break;
      }
    }

    return selected;
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(visualDensity: VisualDensity.comfortable, label: Text(label));
  }
}

class _WisdomEntryCard extends StatelessWidget {
  const _WisdomEntryCard({required this.entry, required this.onTap});

  final DailyWisdomEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: entry.title,
      hint: entry.body,
      child: PremiumCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 8,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SourceChip(label: entry.ownerLabel),
                  _SourceChip(label: entry.themeLabel),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                entry.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${entry.body}\n${entry.practicalStep}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
