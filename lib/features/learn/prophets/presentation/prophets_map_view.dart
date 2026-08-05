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
          _openPreview(_MapLocationGroup(prophets: [focused]));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final markers = widget.prophets.where((p) => p.hasMapLocation).toList();
    final locationGroups = _groupLocations(markers);
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
                      ...locationGroups.map((group) {
                        final point = _latLonToPoint(
                          group.latitude,
                          group.longitude,
                        );
                        final focused = group.prophets.any(
                          (prophet) => prophet.id == widget.focusedProphetId,
                        );
                        return Positioned(
                          left: point.dx - 34,
                          top: point.dy - 50,
                          child: _MapMarker(
                            group: group,
                            focused: focused,
                            onTap: () => _openPreview(group),
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

  List<_MapLocationGroup> _groupLocations(List<ProphetEntry> prophets) {
    final groups = <String, List<ProphetEntry>>{};
    for (final prophet in prophets) {
      final key =
          '${prophet.latitude!.toStringAsFixed(4)}:${prophet.longitude!.toStringAsFixed(4)}:${prophet.locationLabel ?? prophet.regionLabel}';
      groups.putIfAbsent(key, () => <ProphetEntry>[]).add(prophet);
    }
    return groups.values
        .map(
          (entries) => _MapLocationGroup(
            prophets: [...entries]
              ..sort((a, b) => a.timelineOrder - b.timelineOrder),
          ),
        )
        .toList(growable: false);
  }

  void _openPreview(_MapLocationGroup group) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ProphetMapPreviewSheet(
          prophets: group.prophets,
          locationLabel: group.locationLabel,
          onOpenDetail: (prophet) {
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
    required this.group,
    required this.focused,
    required this.onTap,
  });

  final _MapLocationGroup group;
  final bool focused;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lead = group.prophets.first;
    final color = focused ? AppColors.accentGold : lead.eraGroup.tint;
    final label = group.prophets.length == 1
        ? lead.honoredName
        : group.locationLabel;
    final showLabel = focused || group.prophets.length > 1;
    return Tooltip(
      message: l10n.prophetsMapMarkerTooltip(label, group.locationLabel),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            if (showLabel)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xCC10202A),
                  border: Border.all(color: color.withValues(alpha: 0.55)),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            if (showLabel) const SizedBox(height: 6),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                      color: AppColors.accentGoldSoft,
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.28),
                        blurRadius: focused ? 10 : 7,
                        spreadRadius: focused ? 1 : 0,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -7,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border(
                        right: BorderSide(
                          color: AppColors.accentGoldSoft,
                          width: 1.1,
                        ),
                        bottom: BorderSide(
                          color: AppColors.accentGoldSoft,
                          width: 1.1,
                        ),
                      ),
                    ),
                    transform: Matrix4.rotationZ(0.78),
                  ),
                ),
                if (group.prophets.length > 1)
                  Positioned(
                    right: -9,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: color.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        '${group.prophets.length}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
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
      ..color = const Color(0xFF8E9C88).withValues(alpha: 0.46)
      ..style = PaintingStyle.fill;
    final coast = Paint()
      ..color = const Color(0x66E6D1AC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final focusBand = Paint()
      ..color = const Color(0x22E8D5B5)
      ..style = PaintingStyle.fill;

    final propheticBelt = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.16,
        size.width * 0.22,
        size.height * 0.34,
      ),
      const Radius.circular(36),
    );
    canvas.drawRRect(propheticBelt, focusBand);

    final africa = Path()
      ..moveTo(size.width * 0.43, size.height * 0.21)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.31,
        size.width * 0.41,
        size.height * 0.49,
      )
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.64,
        size.width * 0.50,
        size.height * 0.70,
      )
      ..quadraticBezierTo(
        size.width * 0.57,
        size.height * 0.59,
        size.width * 0.56,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.54,
        size.height * 0.28,
        size.width * 0.48,
        size.height * 0.21,
      )
      ..close();

    final arabia = Path()
      ..moveTo(size.width * 0.55, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.60,
        size.height * 0.33,
        size.width * 0.61,
        size.height * 0.44,
      )
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.54,
        size.width * 0.54,
        size.height * 0.50,
      )
      ..quadraticBezierTo(
        size.width * 0.52,
        size.height * 0.39,
        size.width * 0.55,
        size.height * 0.30,
      )
      ..close();

    final levantAndMesopotamia = Path()
      ..moveTo(size.width * 0.55, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * 0.60,
        size.height * 0.20,
        size.width * 0.64,
        size.height * 0.24,
      )
      ..quadraticBezierTo(
        size.width * 0.67,
        size.height * 0.30,
        size.width * 0.66,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.61,
        size.height * 0.37,
        size.width * 0.58,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.31,
        size.width * 0.55,
        size.height * 0.22,
      )
      ..close();

    final europe = Path()
      ..moveTo(size.width * 0.48, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.53,
        size.height * 0.12,
        size.width * 0.58,
        size.height * 0.15,
      )
      ..quadraticBezierTo(
        size.width * 0.56,
        size.height * 0.20,
        size.width * 0.50,
        size.height * 0.20,
      )
      ..close();

    for (final shape in [africa, arabia, levantAndMesopotamia, europe]) {
      canvas.drawPath(shape, land);
      canvas.drawPath(shape, coast);
    }
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

class _MapLocationGroup {
  const _MapLocationGroup({required this.prophets});

  final List<ProphetEntry> prophets;

  double get latitude => prophets.first.latitude!;
  double get longitude => prophets.first.longitude!;
  String get locationLabel =>
      prophets.first.locationLabel ?? prophets.first.regionLabel;
}
