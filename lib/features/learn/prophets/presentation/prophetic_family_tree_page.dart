import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../data/seeded_prophetic_lineage_data.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophet_lineage_node.dart';
import 'widgets/prophetic_family_group_card.dart';

class PropheticFamilyTreePage extends StatefulWidget {
  const PropheticFamilyTreePage({
    super.key,
    required this.prophets,
    required this.onOpenDetail,
    this.focusedProphetId,
  });

  final List<ProphetEntry> prophets;
  final ValueChanged<ProphetEntry> onOpenDetail;
  final String? focusedProphetId;

  @override
  State<PropheticFamilyTreePage> createState() =>
      _PropheticFamilyTreePageState();
}

class _PropheticFamilyTreePageState extends State<PropheticFamilyTreePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _featuredOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prophetsById = {for (final p in widget.prophets) p.id: p};
    final nodesById = {
      for (final node in seededPropheticLineageNodes) node.prophetId: node,
    };
    final childrenByParent = _childrenByParent();
    final query = _searchController.text.trim().toLowerCase();

    final groups = seededPropheticLineageGroups
        .where((group) {
          if (_featuredOnly && !group.isFeatured) return false;
          if (query.isEmpty) return true;
          return group.title.toLowerCase().contains(query) ||
              group.nodeIdsInDisplayOrder.any((id) {
                final node = nodesById[id];
                if (node == null) return false;
                return node.name.toLowerCase().contains(query) ||
                    node.honoredName.toLowerCase().contains(query) ||
                    node.arabicName.contains(_searchController.text.trim()) ||
                    node.eraTitle.toLowerCase().contains(query) ||
                    (node.regionLabel?.toLowerCase().contains(query) ?? false);
              });
        })
        .toList(growable: false);

    final visibleNodeIds = _visibleNodeIds(
      groups: groups,
      nodesById: nodesById,
      childrenByParent: childrenByParent,
      query: query,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.prophetsFamilyTreeTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.prophetsFamilyTreeSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.prophetsSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _filterChip(
                    label: l10n.prophetsFamilyTreeAllLines,
                    selected: !_featuredOnly,
                    onTap: () => setState(() => _featuredOnly = false),
                  ),
                  _filterChip(
                    label: l10n.prophetsFamilyTreeFeaturedLines,
                    selected: _featuredOnly,
                    onTap: () => setState(() => _featuredOnly = true),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.prophetsFamilyTreeLinkedNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.onSurfaceSubtle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Text(
            l10n.prophetsFamilyTreeScopeNote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...groups.map((group) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PropheticFamilyGroupCard(
              group: group,
              nodesById: nodesById,
              childrenByParent: childrenByParent,
              focusedProphetId: widget.focusedProphetId,
              visibleNodeIds: visibleNodeIds,
              onOpenProphetDetail: (id) {
                final prophet = prophetsById[id];
                if (prophet != null) {
                  widget.onOpenDetail(prophet);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Map<String, List<String>> _childrenByParent() {
    final map = <String, List<String>>{};
    for (final node in seededPropheticLineageNodes) {
      for (final parentId in node.parentIds) {
        map.putIfAbsent(parentId, () => <String>[]).add(node.prophetId);
      }
    }
    for (final children in map.values) {
      children.sort((a, b) {
        final left = seededPropheticLineageNodes
            .where((node) => node.prophetId == a)
            .first
            .sortOrder;
        final right = seededPropheticLineageNodes
            .where((node) => node.prophetId == b)
            .first
            .sortOrder;
        return left.compareTo(right);
      });
    }
    return map;
  }

  Set<String> _visibleNodeIds({
    required List<PropheticLineageGroup> groups,
    required Map<String, ProphetLineageNode> nodesById,
    required Map<String, List<String>> childrenByParent,
    required String query,
  }) {
    if (query.isEmpty) return <String>{};
    final visible = <String>{};
    for (final group in groups) {
      for (final id in group.nodeIdsInDisplayOrder) {
        final node = nodesById[id];
        if (node == null) continue;
        final match =
            node.name.toLowerCase().contains(query) ||
            node.honoredName.toLowerCase().contains(query) ||
            node.arabicName.contains(_searchController.text.trim()) ||
            node.eraTitle.toLowerCase().contains(query) ||
            (node.regionLabel?.toLowerCase().contains(query) ?? false);
        if (match) {
          visible.add(id);
          _includeAncestors(id, nodesById, visible);
          _includeDescendants(id, childrenByParent, visible);
        }
      }
    }
    return visible;
  }

  void _includeAncestors(
    String nodeId,
    Map<String, ProphetLineageNode> nodesById,
    Set<String> visible,
  ) {
    final node = nodesById[nodeId];
    if (node == null) return;
    for (final parentId in node.parentIds) {
      if (visible.add(parentId)) {
        _includeAncestors(parentId, nodesById, visible);
      }
    }
  }

  void _includeDescendants(
    String nodeId,
    Map<String, List<String>> childrenByParent,
    Set<String> visible,
  ) {
    for (final childId in (childrenByParent[nodeId] ?? const <String>[])) {
      if (visible.add(childId)) {
        _includeDescendants(childId, childrenByParent, visible);
      }
    }
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? context.palette.accent.withValues(alpha: 0.22)
              : context.palette.surface.withValues(alpha: 0.3),
          border: Border.all(
            color: selected
                ? context.palette.accent.withValues(alpha: 0.6)
                : context.palette.accentSoft.withValues(alpha: 0.32),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.3)),
      ),
    );
  }
}
