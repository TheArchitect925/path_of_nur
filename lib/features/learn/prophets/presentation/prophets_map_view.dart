import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../domain/prophet_entry.dart';
import 'prophets_metadata_localization.dart';
import 'widgets/prophet_map_preview_sheet.dart';

class ProphetsMapView extends StatefulWidget {
  const ProphetsMapView({
    super.key,
    required this.prophets,
    required this.onOpenDetail,
    this.focusedProphetId,
  });

  final List<ProphetEntry> prophets;
  final ValueChanged<ProphetEntry> onOpenDetail;
  final String? focusedProphetId;

  @override
  State<ProphetsMapView> createState() => _ProphetsMapViewState();
}

class _ProphetsMapViewState extends State<ProphetsMapView> {
  static const double _mapWidth = 1080;
  static const double _mapHeight = 520;

  @override
  void didUpdateWidget(covariant ProphetsMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusedProphetId != oldWidget.focusedProphetId &&
        widget.focusedProphetId != null) {
      final focused = widget.prophets
          .where((p) => p.id == widget.focusedProphetId)
          .firstOrNull;
      if (focused != null && focused.hasMapLocation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _openPreview(focused);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final markers = widget.prophets.where((p) => p.hasMapLocation).toList();
    final unknown = widget.prophets.where((p) => !p.hasMapLocation).toList();

    return Column(
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: _mapWidth / _mapHeight,
              child: InteractiveViewer(
                minScale: 0.88,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(40),
                child: SizedBox(
                  width: _mapWidth,
                  height: _mapHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _CalmWorldPainter()),
                      ),
                      ...markers.map((prophet) {
                        final point = _latLonToPoint(
                          prophet.latitude!,
                          prophet.longitude!,
                        );
                        final focused = widget.focusedProphetId == prophet.id;
                        return Positioned(
                          left: point.dx - 9,
                          top: point.dy - 9,
                          child: _MapMarker(
                            prophet: prophet,
                            focused: focused,
                            onTap: () => _openPreview(prophet),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.prophetsMapLocationGuidanceTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.prophetsMapLocationGuidanceSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProphetLocationConfidence.values
                    .map(
                      (confidence) => _legendPill(
                        title: localizedProphetLocationConfidenceLabel(
                          l10n,
                          confidence,
                        ),
                        subtitle: localizedProphetLocationConfidenceGuidance(
                          l10n,
                          confidence,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        if (unknown.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.prophetsMapUnmappedTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unknown
                      .map(
                        (prophet) => ActionChip(
                          label: Text(prophet.honoredName),
                          onPressed: () => widget.onOpenDetail(prophet),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _legendPill({required String title, required String subtitle}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 290),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.surface.withValues(alpha: 0.32),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11.3, color: Color(0xFF7C6F62)),
          ),
        ],
      ),
    );
  }

  Offset _latLonToPoint(double latitude, double longitude) {
    final x = ((longitude + 180) / 360) * _mapWidth;
    final y = ((90 - latitude) / 180) * _mapHeight;
    return Offset(x.clamp(0, _mapWidth), y.clamp(0, _mapHeight));
  }

  void _openPreview(ProphetEntry prophet) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ProphetMapPreviewSheet(
          prophet: prophet,
          onOpenDetail: () {
            Navigator.of(context).pop();
            widget.onOpenDetail(prophet);
          },
        );
      },
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.prophet,
    required this.focused,
    required this.onTap,
  });

  final ProphetEntry prophet;
  final bool focused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.prophetsMapMarkerTooltip(
        prophet.honoredName,
        prophet.locationLabel ?? prophet.regionLabel,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: focused ? AppColors.accentGold : prophet.eraGroup.tint,
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: (focused ? AppColors.accentGold : prophet.eraGroup.tint)
                    .withValues(alpha: 0.45),
                blurRadius: focused ? 14 : 10,
                spreadRadius: focused ? 2 : 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalmWorldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1E2530).withValues(alpha: 0.92),
          const Color(0xFF283445).withValues(alpha: 0.90),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = const Color(0x55DCC9A7)
      ..strokeWidth = 1;
    for (int i = 1; i < 6; i++) {
      final y = size.height * i / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (int i = 1; i < 12; i++) {
      final x = size.width * i / 12;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

    final land = Paint()
      ..color = const Color(0xFF8E9C88).withValues(alpha: 0.42);
    final accent = Paint()..color = const Color(0x33E6D1AC);

    final continents = <Rect>[
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.22,
        size.width * 0.19,
        size.height * 0.36,
      ),
      Rect.fromLTWH(
        size.width * 0.29,
        size.height * 0.16,
        size.width * 0.22,
        size.height * 0.38,
      ),
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.20,
        size.width * 0.18,
        size.height * 0.28,
      ),
      Rect.fromLTWH(
        size.width * 0.66,
        size.height * 0.26,
        size.width * 0.24,
        size.height * 0.34,
      ),
    ];

    for (final rect in continents) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(120)),
        land,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width * 0.72,
            height: rect.height * 0.66,
          ),
          const Radius.circular(100),
        ),
        accent,
      );
    }

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [const Color(0x44E8D5B5), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.58, size.height * 0.46),
              radius: 160,
            ),
          );
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.46), 160, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
