import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/prophet_lineage_node.dart';
import 'prophetic_family_connector_painter.dart';

class PropheticFamilyGroupCard extends StatefulWidget {
  const PropheticFamilyGroupCard({
    super.key,
    required this.group,
    required this.nodesById,
    required this.childrenByParent,
    required this.onOpenProphetDetail,
    required this.focusedProphetId,
    required this.visibleNodeIds,
  });

  final PropheticLineageGroup group;
  final Map<String, ProphetLineageNode> nodesById;
  final Map<String, List<String>> childrenByParent;
  final ValueChanged<String> onOpenProphetDetail;
  final String? focusedProphetId;
  final Set<String> visibleNodeIds;

  @override
  State<PropheticFamilyGroupCard> createState() =>
      _PropheticFamilyGroupCardState();
}

class _PropheticFamilyGroupCardState extends State<PropheticFamilyGroupCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded =
        widget.focusedProphetId != null &&
        widget.group.nodeIdsInDisplayOrder.contains(widget.focusedProphetId);
  }

  @override
  void didUpdateWidget(covariant PropheticFamilyGroupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasFocus =
        widget.focusedProphetId != null &&
        widget.group.nodeIdsInDisplayOrder.contains(widget.focusedProphetId);
    if (hasFocus && !_expanded) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleRoot = _visibleFor(widget.group.rootProphetId);
    if (!visibleRoot) return const SizedBox.shrink();

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.group.lineageLabel != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.group.lineageLabel!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.group.summary),
          if (_expanded) ...[
            const SizedBox(height: 12),
            _buildNode(
              context,
              nodeId: widget.group.rootProphetId,
              depth: 0,
              drawVerticalAbove: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNode(
    BuildContext context, {
    required String nodeId,
    required int depth,
    required bool drawVerticalAbove,
  }) {
    final node = widget.nodesById[nodeId];
    if (node == null) return const SizedBox.shrink();
    if (!_visibleFor(nodeId)) return const SizedBox.shrink();

    final children = (widget.childrenByParent[nodeId] ?? const <String>[])
        .where(_visibleFor)
        .toList(growable: false);
    final focused = node.prophetId == widget.focusedProphetId;

    return Padding(
      padding: EdgeInsets.only(left: depth * 14.0, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (depth > 0)
                SizedBox(
                  width: 16,
                  height: 62,
                  child: CustomPaint(
                    painter: PropheticFamilyConnectorPainter(
                      color: AppColors.accentGoldSoft.withValues(alpha: 0.45),
                      drawVertical: drawVerticalAbove,
                    ),
                  ),
                ),
              Expanded(
                child: _LineageNodeCard(
                  node: node,
                  focused: focused,
                  onTap: () => widget.onOpenProphetDetail(node.prophetId),
                ),
              ),
            ],
          ),
          if (children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(children.length, (index) {
                  return _buildNode(
                    context,
                    nodeId: children[index],
                    depth: depth + 1,
                    drawVerticalAbove: index != children.length - 1,
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  bool _visibleFor(String nodeId) {
    return widget.visibleNodeIds.isEmpty ||
        widget.visibleNodeIds.contains(nodeId);
  }
}

class _LineageNodeCard extends StatefulWidget {
  const _LineageNodeCard({
    required this.node,
    required this.focused,
    required this.onTap,
  });

  final ProphetLineageNode node;
  final bool focused;
  final VoidCallback onTap;

  @override
  State<_LineageNodeCard> createState() => _LineageNodeCardState();
}

class _LineageNodeCardState extends State<_LineageNodeCard> {
  bool _didAutoScroll = false;

  @override
  void initState() {
    super.initState();
    if (widget.focused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          alignment: 0.14,
        );
      });
      _didAutoScroll = true;
    }
  }

  @override
  void didUpdateWidget(covariant _LineageNodeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focused && !_didAutoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          alignment: 0.14,
        );
      });
      _didAutoScroll = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.focused
        ? AppColors.accentGold
        : AppColors.accentGoldSoft.withValues(alpha: 0.33);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: widget.focused
            ? [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.2),
                  blurRadius: 14,
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.node.honoredName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.node.honoredArabicName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                      if (widget.node.lineageLabel != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.node.lineageLabel!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _chip(widget.node.eraTitle),
                          if (widget.node.regionLabel != null)
                            _chip(widget.node.regionLabel!),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.open_in_new_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.26),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.1)),
    );
  }
}
