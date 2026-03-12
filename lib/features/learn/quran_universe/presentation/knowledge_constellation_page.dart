import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../prophets/application/prophet_detail_repository.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../../prophets/presentation/prophet_detail_page.dart';
import '../data/seeded_quran_universe_data.dart';
import '../domain/quran_universe_links.dart';

class KnowledgeConstellationPage extends ConsumerStatefulWidget {
  const KnowledgeConstellationPage({super.key});

  @override
  ConsumerState<KnowledgeConstellationPage> createState() =>
      _KnowledgeConstellationPageState();
}

class _KnowledgeConstellationPageState
    extends ConsumerState<KnowledgeConstellationPage> {
  static const Size _canvasSize = Size(2200, 1600);
  static const Offset _center = Offset(1100, 800);

  late final List<QuranUniverseNode> _nodes = seededUniverseNodes
      .where(
        (node) =>
            node.type == QuranUniverseNodeType.quran ||
            node.type == QuranUniverseNodeType.hadith ||
            node.type == QuranUniverseNodeType.prophet ||
            node.type == QuranUniverseNodeType.theme,
      )
      .toList(growable: false);

  late final Map<String, QuranUniverseNode> _nodeById = {
    for (final node in _nodes) node.id: node,
  };

  late final Map<String, Offset> _positions = _buildNodePositions(_nodes);
  late final List<_ConstellationEdge> _edges = _buildEdges();
  String? _selectedNodeId;

  @override
  Widget build(BuildContext context) {
    final prophets = ref.watch(prophetsProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.hub_rounded,
      title: 'Knowledge Constellation',
      subtitle:
          'An interactive map linking Qur’an, Hadith, Prophets, and Themes.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Pinch to zoom, drag to pan, and tap any node to open its detail page.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _LegendChip(
                    label: 'Qur’an',
                    color: AppColors.accentGold,
                    borderColor: AppColors.accentGoldSoft,
                  ),
                  _LegendChip(
                    label: 'Hadith',
                    color: Color(0xFF7CA5D6),
                    borderColor: Color(0xFF98BCE5),
                  ),
                  _LegendChip(
                    label: 'Prophets',
                    color: Color(0xFF78B79A),
                    borderColor: Color(0xFF92C7AE),
                  ),
                  _LegendChip(
                    label: 'Themes',
                    color: Color(0xFFEFE9DD),
                    borderColor: Color(0xFFF6F1E8),
                    textColor: Color(0xFF473D32),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: SizedBox(
            height: 560,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(420),
                minScale: 0.45,
                maxScale: 2.8,
                child: SizedBox(
                  width: _canvasSize.width,
                  height: _canvasSize.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ConstellationEdgesPainter(
                            positions: _positions,
                            edges: _edges,
                            selectedNodeId: _selectedNodeId,
                          ),
                        ),
                      ),
                      ..._nodes.map(
                        (node) => _buildNode(
                          context: context,
                          node: node,
                          prophets: prophets,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNode({
    required BuildContext context,
    required QuranUniverseNode node,
    required List<ProphetEntry> prophets,
  }) {
    final position = _positions[node.id] ?? _center;
    final selected = _selectedNodeId == node.id;
    final style = _styleFor(node.type);

    return Positioned(
      left: position.dx - 42,
      top: position.dy - 32,
      child: GestureDetector(
        onTap: () async {
          setState(() => _selectedNodeId = node.id);
          await _openNode(node, prophets);
        },
        child: AnimatedScale(
          scale: selected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 140),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: style.fill,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: style.border.withValues(
                      alpha: selected ? 0.95 : 0.7,
                    ),
                    width: selected ? 2.1 : 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: style.fill.withValues(
                        alpha: selected ? 0.24 : 0.14,
                      ),
                      blurRadius: selected ? 14 : 9,
                      spreadRadius: selected ? 1.5 : 0.6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 96,
                child: Text(
                  node.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.84),
                    fontSize: 10.8,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openNode(
    QuranUniverseNode node,
    List<ProphetEntry> prophets,
  ) async {
    switch (node.type) {
      case QuranUniverseNodeType.quran:
        final verseId = _stripNodePrefix(node.id);
        final link = seededUniverseVerseLinks.firstWhereOrNull(
          (item) => item.id == verseId,
        );
        if (link == null) return;
        final query = <String, String>{};
        if (link.startAyah != null) {
          query['ayah'] = '${link.startAyah}';
        }
        context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': '${link.surahNumber}'},
          queryParameters: query,
        );
        return;
      case QuranUniverseNodeType.hadith:
        final hadithId = _stripNodePrefix(node.id);
        context.pushNamed(
          'hadithLessonDetail',
          pathParameters: {'lessonId': hadithId},
        );
        return;
      case QuranUniverseNodeType.prophet:
        final prophetId = _stripNodePrefix(node.id);
        final prophet = prophets.firstWhereOrNull(
          (item) => item.id == prophetId,
        );
        if (prophet == null) return;
        _openProphetDetail(prophet, prophets);
        return;
      case QuranUniverseNodeType.theme:
        context.pushNamed('quranUniverse', queryParameters: {'mode': 'theme'});
        return;
      case QuranUniverseNodeType.concept:
        return;
    }
  }

  void _openProphetDetail(
    ProphetEntry prophet,
    List<ProphetEntry> allProphets,
  ) {
    final detailRepo = ref.read(prophetDetailRepositoryProvider);
    final detail = detailRepo.forProphet(prophet);
    final index = allProphets.indexWhere((item) => item.id == prophet.id);
    final previous = index > 0 ? allProphets[index - 1] : null;
    final next = index >= 0 && index < allProphets.length - 1
        ? allProphets[index + 1]
        : null;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProphetDetailPage(
          prophet: prophet,
          content: detail,
          allProphets: allProphets,
          previousProphetLabel: previous?.name,
          nextProphetLabel: next?.name,
          onOpenPreviousProphet: previous == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  _openProphetDetail(previous, allProphets);
                },
          onOpenNextProphet: next == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  _openProphetDetail(next, allProphets);
                },
          onOpenRelatedProphet: (relatedId) {
            final related = allProphets.firstWhereOrNull(
              (p) => p.id == relatedId,
            );
            if (related == null) return;
            Navigator.of(context).pop();
            _openProphetDetail(related, allProphets);
          },
        ),
      ),
    );
  }

  List<_ConstellationEdge> _buildEdges() {
    final edges = <_ConstellationEdge>[];
    final seen = <String>{};
    for (final node in _nodes) {
      for (final connection in node.connections) {
        if (!_nodeById.containsKey(connection)) continue;
        final a = node.id;
        final b = connection;
        final key = a.compareTo(b) <= 0 ? '$a|$b' : '$b|$a';
        if (seen.contains(key)) continue;
        seen.add(key);
        edges.add(_ConstellationEdge(fromId: a, toId: b));
      }
    }
    return edges;
  }

  Map<String, Offset> _buildNodePositions(List<QuranUniverseNode> nodes) {
    final grouped = <QuranUniverseNodeType, List<QuranUniverseNode>>{};
    for (final node in nodes) {
      grouped.putIfAbsent(node.type, () => <QuranUniverseNode>[]).add(node);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.id.compareTo(b.id));
    }

    final result = <String, Offset>{};
    void placeRing(
      QuranUniverseNodeType type,
      double radius, {
      double angleOffset = 0,
    }) {
      final items = grouped[type] ?? const <QuranUniverseNode>[];
      if (items.isEmpty) return;
      final step = (2 * math.pi) / items.length;
      for (var i = 0; i < items.length; i += 1) {
        final theta = angleOffset + (i * step);
        final x = _center.dx + (math.cos(theta) * radius);
        final y = _center.dy + (math.sin(theta) * radius);
        result[items[i].id] = Offset(x, y);
      }
    }

    placeRing(QuranUniverseNodeType.theme, 180, angleOffset: 0.2);
    placeRing(QuranUniverseNodeType.prophet, 360, angleOffset: 0.4);
    placeRing(QuranUniverseNodeType.hadith, 540, angleOffset: -0.3);
    placeRing(QuranUniverseNodeType.quran, 700, angleOffset: 0.15);

    return result;
  }

  String _stripNodePrefix(String value) {
    final index = value.indexOf(':');
    if (index < 0 || index == value.length - 1) return value;
    return value.substring(index + 1);
  }

  _NodeStyle _styleFor(QuranUniverseNodeType type) {
    switch (type) {
      case QuranUniverseNodeType.quran:
        return const _NodeStyle(
          fill: AppColors.accentGold,
          border: AppColors.accentGoldSoft,
        );
      case QuranUniverseNodeType.hadith:
        return const _NodeStyle(
          fill: Color(0xFF7CA5D6),
          border: Color(0xFF98BCE5),
        );
      case QuranUniverseNodeType.prophet:
        return const _NodeStyle(
          fill: Color(0xFF78B79A),
          border: Color(0xFF92C7AE),
        );
      case QuranUniverseNodeType.theme:
        return const _NodeStyle(
          fill: Color(0xFFEFE9DD),
          border: Color(0xFFF6F1E8),
        );
      case QuranUniverseNodeType.concept:
        return const _NodeStyle(
          fill: AppColors.surface,
          border: AppColors.accentGoldSoft,
        );
    }
  }
}

class _NodeStyle {
  const _NodeStyle({required this.fill, required this.border});

  final Color fill;
  final Color border;
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.label,
    required this.color,
    required this.borderColor,
    this.textColor,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.25),
        border: Border.all(color: borderColor.withValues(alpha: 0.8)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor ?? AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ConstellationEdge {
  const _ConstellationEdge({required this.fromId, required this.toId});

  final String fromId;
  final String toId;
}

class _ConstellationEdgesPainter extends CustomPainter {
  const _ConstellationEdgesPainter({
    required this.positions,
    required this.edges,
    required this.selectedNodeId,
  });

  final Map<String, Offset> positions;
  final List<_ConstellationEdge> edges;
  final String? selectedNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = AppColors.onSurface.withValues(alpha: 0.12);

    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = AppColors.accentGold.withValues(alpha: 0.35);

    for (final edge in edges) {
      final a = positions[edge.fromId];
      final b = positions[edge.toId];
      if (a == null || b == null) continue;
      final isSelected =
          selectedNodeId != null &&
          (edge.fromId == selectedNodeId || edge.toId == selectedNodeId);
      canvas.drawLine(a, b, isSelected ? highlightPaint : basePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationEdgesPainter oldDelegate) {
    return oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.positions != positions ||
        oldDelegate.edges != edges;
  }
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T value) test) {
    for (final value in this) {
      if (test(value)) return value;
    }
    return null;
  }
}
