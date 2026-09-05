import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../kids/shared/presentation/kids_page_scaffold.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_repository.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class KidsDuaDrawingPage extends ConsumerStatefulWidget {
  const KidsDuaDrawingPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<KidsDuaDrawingPage> createState() => _KidsDuaDrawingPageState();
}

class _KidsDuaDrawingPageState extends ConsumerState<KidsDuaDrawingPage> {
  final _boundaryKey = GlobalKey();
  final List<_Stroke> _strokes = <_Stroke>[];
  final List<_Stroke> _redo = <_Stroke>[];
  Color _selectedColor = const Color(0xFF2E2A25);
  double _selectedWidth = 8;
  bool _eraseMode = false;
  bool _saving = false;

  // The crayons. These are content, not chrome: a child's palette stays the
  // same on every theme.
  static const _palette = <Color>[
    Color(0xFF2E2A25),
    Color(0xFF8A6A45),
    Color(0xFF4E7A39),
    Color(0xFF446A8F),
    Color(0xFFD96C4E),
    Color(0xFFB7923C),
    Color(0xFF7C5A92),
    Color(0xFFDB8FA8),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lesson = ref.watch(kidsDuaLessonByIdProvider(widget.lessonId));
    if (lesson == null) {
      return AppPageScaffold(
        title: l10n.kidsDuaDrawTitle,
        children: [PremiumCard(child: Text(l10n.routerNotFoundTitle))],
      );
    }

    return KidsPageScaffold(
      title: lesson.title,
      subtitle: l10n.kidsDuaDrawHint,
      floatingBottom: PremiumCard(
        density: PremiumCardDensity.compact,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _strokes.isNotEmpty
                    ? () => setState(() {
                        final last = _strokes.removeLast();
                        _redo.add(last);
                      })
                    : null,
                child: Text(l10n.kidsDuaDrawUndoAction),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _strokes.isEmpty || _saving
                    ? null
                    : () => _saveDrawing(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(
                  _saving
                      ? l10n.kidsDuaDrawSavingAction
                      : l10n.kidsDuaDrawSaveAction,
                ),
              ),
            ),
          ],
        ),
      ),
      children: [
        _Toolbar(
          selectedColor: _selectedColor,
          selectedWidth: _selectedWidth,
          eraseMode: _eraseMode,
          onColorSelected: (color) {
            setState(() {
              _selectedColor = color;
              _eraseMode = false;
            });
          },
          onWidthSelected: (width) => setState(() => _selectedWidth = width),
          onEraseToggled: () => setState(() => _eraseMode = !_eraseMode),
          onClear: () => setState(() {
            _strokes.clear();
            _redo.clear();
          }),
          palette: _palette,
        ),
        const SizedBox(height: 12),
        RepaintBoundary(
          key: _boundaryKey,
          child: GestureDetector(
            onPanStart: (details) => _startStroke(details.localPosition),
            onPanUpdate: (details) => _appendPoint(details.localPosition),
            onPanEnd: (_) => _endStroke(),
            child: Container(
              height: 440,
              decoration: BoxDecoration(
                // Paper is white on every theme; the drawing is saved as
                // seen.
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.palette.border),
              ),
              child: CustomPaint(
                painter: _DrawingPainter(_strokes),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  void _startStroke(Offset point) {
    setState(() {
      _redo.clear();
      _strokes.add(
        _Stroke(
          color: _eraseMode ? Colors.white : _selectedColor,
          width: _selectedWidth,
          points: <Offset>[point],
        ),
      );
    });
  }

  void _appendPoint(Offset point) {
    if (_strokes.isEmpty) return;
    setState(() {
      final current = _strokes.removeLast();
      _strokes.add(
        current.copyWith(points: <Offset>[...current.points, point]),
      );
    });
  }

  void _endStroke() {}

  Future<void> _saveDrawing(BuildContext context) async {
    final navigator = Navigator.of(context);
    setState(() => _saving = true);
    try {
      final boundary =
          _boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List() ?? Uint8List(0);
      await ref
          .read(kidsDuaCreativeProvider.notifier)
          .saveDrawing(duaId: widget.lessonId, pngBytes: bytes);
      if (!mounted) return;
      navigator.pop();
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.selectedColor,
    required this.selectedWidth,
    required this.eraseMode,
    required this.onColorSelected,
    required this.onWidthSelected,
    required this.onEraseToggled,
    required this.onClear,
    required this.palette,
  });

  final Color selectedColor;
  final double selectedWidth;
  final bool eraseMode;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<double> onWidthSelected;
  final VoidCallback onEraseToggled;
  final VoidCallback onClear;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      density: PremiumCardDensity.compact,
      child: Column(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: palette
                .map(
                  (color) => Semantics(
                    button: true,
                    selected: selectedColor == color && !eraseMode,
                    child: GestureDetector(
                      onTap: () => onColorSelected(color),
                      child: Container(
                        // 44 pt: a crayon a small finger can pick.
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color && !eraseMode
                                ? context.palette.onSurface
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          // The brush sizes take the whole row: in the kids type scale the
          // three labels do not fit beside the tool buttons.
          SegmentedButton<double>(
            segments: <ButtonSegment<double>>[
              ButtonSegment<double>(
                value: 4,
                label: Text(l10n.kidsDuaDrawBrushSmall),
              ),
              ButtonSegment<double>(
                value: 8,
                label: Text(l10n.kidsDuaDrawBrushMedium),
              ),
              ButtonSegment<double>(
                value: 14,
                label: Text(l10n.kidsDuaDrawBrushLarge),
              ),
            ],
            selected: <double>{selectedWidth},
            onSelectionChanged: (value) => onWidthSelected(value.first),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onEraseToggled,
                  icon: Icon(
                    eraseMode
                        ? Icons.auto_fix_off_rounded
                        : Icons.cleaning_services_rounded,
                  ),
                  label: Text(l10n.kidsDuaDrawEraseAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: Text(l10n.kidsDuaDrawClearAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  const _DrawingPainter(this.strokes);

  final List<_Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.width;
      for (var i = 0; i < stroke.points.length - 1; i += 1) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
      if (stroke.points.length == 1) {
        canvas.drawPoints(ui.PointMode.points, stroke.points, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

class _Stroke {
  const _Stroke({
    required this.color,
    required this.width,
    required this.points,
  });

  final Color color;
  final double width;
  final List<Offset> points;

  _Stroke copyWith({Color? color, double? width, List<Offset>? points}) {
    return _Stroke(
      color: color ?? this.color,
      width: width ?? this.width,
      points: points ?? this.points,
    );
  }
}
