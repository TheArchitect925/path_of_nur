import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../profile/application/profile_settings_provider.dart';
import '../models/salah_trainer_models.dart';

/// A side-view figure of the praying person, facing the qiblah on the left.
/// Postures are joint sets on a unit square, and a change morphs one into the
/// next so the learner sees the movement, not a cut.
class PrayerPostureAnimator extends ConsumerWidget {
  const PrayerPostureAnimator({
    super.key,
    required this.posture,
    this.size = 180,
    this.duration = const Duration(milliseconds: 420),
    this.color,
    this.showMat = true,
  });

  final PrayerPostureType posture;
  final double size;
  final Duration duration;

  /// Defaults to the theme accent.
  final Color? color;
  final bool showMat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(
      profileSettingsProvider.select((value) => value.reduceMotion),
    );
    final ink = color ?? context.palette.accent;
    return TweenAnimationBuilder<_Pose>(
      tween: _PoseTween(end: _Pose.of(posture)),
      duration: reduceMotion ? Duration.zero : duration,
      curve: Curves.easeInOutCubic,
      builder: (context, pose, _) {
        return CustomPaint(
          size: Size.square(size),
          painter: _PosePainter(pose: pose, color: ink, showMat: showMat),
        );
      },
    );
  }
}

class _PoseTween extends Tween<_Pose> {
  _PoseTween({required _Pose end}) : super(end: end);

  @override
  _Pose lerp(double t) => _Pose.lerp(begin ?? end!, end!, t);
}

/// Joints of the figure in unit coordinates (0..1, y down). "F" limbs are
/// nearer the viewer, "B" limbs sit behind and are drawn fainter.
class _Pose {
  const _Pose({
    required this.head,
    required this.neck,
    required this.hip,
    required this.kneeF,
    required this.kneeB,
    required this.footF,
    required this.footB,
    required this.elbowF,
    required this.handF,
    required this.elbowB,
    required this.handB,
    this.headTurn = 0,
  });

  final Offset head;
  final Offset neck;
  final Offset hip;
  final Offset kneeF;
  final Offset kneeB;
  final Offset footF;
  final Offset footB;
  final Offset elbowF;
  final Offset handF;
  final Offset elbowB;
  final Offset handB;

  /// -1 looks left, 1 looks right; marks the salam direction.
  final double headTurn;

  static _Pose lerp(_Pose a, _Pose b, double t) {
    return _Pose(
      head: Offset.lerp(a.head, b.head, t)!,
      neck: Offset.lerp(a.neck, b.neck, t)!,
      hip: Offset.lerp(a.hip, b.hip, t)!,
      kneeF: Offset.lerp(a.kneeF, b.kneeF, t)!,
      kneeB: Offset.lerp(a.kneeB, b.kneeB, t)!,
      footF: Offset.lerp(a.footF, b.footF, t)!,
      footB: Offset.lerp(a.footB, b.footB, t)!,
      elbowF: Offset.lerp(a.elbowF, b.elbowF, t)!,
      handF: Offset.lerp(a.handF, b.handF, t)!,
      elbowB: Offset.lerp(a.elbowB, b.elbowB, t)!,
      handB: Offset.lerp(a.handB, b.handB, t)!,
      headTurn: ui.lerpDouble(a.headTurn, b.headTurn, t)!,
    );
  }

  static const _standing = _Pose(
    head: Offset(0.50, 0.17),
    neck: Offset(0.50, 0.29),
    hip: Offset(0.50, 0.57),
    kneeF: Offset(0.47, 0.76),
    kneeB: Offset(0.53, 0.76),
    footF: Offset(0.44, 0.93),
    footB: Offset(0.56, 0.93),
    elbowF: Offset(0.40, 0.44),
    handF: Offset(0.49, 0.47),
    elbowB: Offset(0.60, 0.44),
    handB: Offset(0.51, 0.47),
  );

  static const _armsDown = _Pose(
    head: Offset(0.50, 0.17),
    neck: Offset(0.50, 0.29),
    hip: Offset(0.50, 0.57),
    kneeF: Offset(0.47, 0.76),
    kneeB: Offset(0.53, 0.76),
    footF: Offset(0.44, 0.93),
    footB: Offset(0.56, 0.93),
    elbowF: Offset(0.44, 0.45),
    handF: Offset(0.44, 0.60),
    elbowB: Offset(0.56, 0.45),
    handB: Offset(0.56, 0.60),
  );

  static const _bowing = _Pose(
    head: Offset(0.15, 0.46),
    neck: Offset(0.28, 0.46),
    hip: Offset(0.62, 0.52),
    kneeF: Offset(0.59, 0.74),
    kneeB: Offset(0.66, 0.74),
    footF: Offset(0.56, 0.93),
    footB: Offset(0.69, 0.93),
    elbowF: Offset(0.34, 0.60),
    handF: Offset(0.57, 0.71),
    elbowB: Offset(0.38, 0.62),
    handB: Offset(0.63, 0.72),
  );

  static const _prostrating = _Pose(
    head: Offset(0.21, 0.86),
    neck: Offset(0.33, 0.77),
    hip: Offset(0.60, 0.66),
    kneeF: Offset(0.61, 0.91),
    kneeB: Offset(0.66, 0.91),
    footF: Offset(0.84, 0.93),
    footB: Offset(0.89, 0.93),
    elbowF: Offset(0.22, 0.87),
    handF: Offset(0.10, 0.93),
    elbowB: Offset(0.28, 0.89),
    handB: Offset(0.16, 0.94),
  );

  static const _sitting = _Pose(
    head: Offset(0.48, 0.36),
    neck: Offset(0.48, 0.47),
    hip: Offset(0.57, 0.75),
    kneeF: Offset(0.35, 0.90),
    kneeB: Offset(0.40, 0.90),
    footF: Offset(0.70, 0.93),
    footB: Offset(0.75, 0.93),
    elbowF: Offset(0.45, 0.61),
    handF: Offset(0.38, 0.75),
    elbowB: Offset(0.52, 0.62),
    handB: Offset(0.45, 0.76),
  );

  static const _tashahhud = _Pose(
    head: Offset(0.46, 0.37),
    neck: Offset(0.47, 0.48),
    hip: Offset(0.57, 0.75),
    kneeF: Offset(0.35, 0.90),
    kneeB: Offset(0.40, 0.90),
    footF: Offset(0.70, 0.93),
    footB: Offset(0.75, 0.93),
    elbowF: Offset(0.44, 0.62),
    handF: Offset(0.35, 0.73),
    elbowB: Offset(0.52, 0.62),
    handB: Offset(0.45, 0.76),
  );

  static _Pose of(PrayerPostureType posture) {
    switch (posture) {
      case PrayerPostureType.qiyam:
        return _standing;
      case PrayerPostureType.qawmah:
        return _armsDown;
      case PrayerPostureType.ruku:
        return _bowing;
      case PrayerPostureType.sujud:
        return _prostrating;
      case PrayerPostureType.jalsah:
        return _sitting;
      case PrayerPostureType.tashahhud:
        return _tashahhud;
      case PrayerPostureType.salamRight:
        return _Pose(
          head: const Offset(0.51, 0.37),
          neck: _tashahhud.neck,
          hip: _tashahhud.hip,
          kneeF: _tashahhud.kneeF,
          kneeB: _tashahhud.kneeB,
          footF: _tashahhud.footF,
          footB: _tashahhud.footB,
          elbowF: _tashahhud.elbowF,
          handF: _tashahhud.handF,
          elbowB: _tashahhud.elbowB,
          handB: _tashahhud.handB,
          headTurn: 1,
        );
      case PrayerPostureType.salamLeft:
        return _Pose(
          head: const Offset(0.43, 0.37),
          neck: _tashahhud.neck,
          hip: _tashahhud.hip,
          kneeF: _tashahhud.kneeF,
          kneeB: _tashahhud.kneeB,
          footF: _tashahhud.footF,
          footB: _tashahhud.footB,
          elbowF: _tashahhud.elbowF,
          handF: _tashahhud.handF,
          elbowB: _tashahhud.elbowB,
          handB: _tashahhud.handB,
          headTurn: -1,
        );
    }
  }
}

class _PosePainter extends CustomPainter {
  const _PosePainter({
    required this.pose,
    required this.color,
    required this.showMat,
  });

  final _Pose pose;
  final Color color;
  final bool showMat;

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(Offset unit) =>
        Offset(unit.dx * size.width, unit.dy * size.height);
    final stroke = size.width * 0.072;
    final front = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final back = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = stroke * 0.9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (showMat) {
      final mat = Paint()
        ..color = color.withValues(alpha: 0.16)
        ..strokeWidth = size.height * 0.03
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(size.width * 0.06, size.height * 0.955),
        Offset(size.width * 0.94, size.height * 0.955),
        mat,
      );
    }

    void limb(Paint paint, List<Offset> joints) {
      final path = Path()..moveTo(at(joints.first).dx, at(joints.first).dy);
      for (final joint in joints.skip(1)) {
        path.lineTo(at(joint).dx, at(joint).dy);
      }
      canvas.drawPath(path, paint);
    }

    // Back limbs first so the front ones read on top.
    limb(back, [pose.hip, pose.kneeB, pose.footB]);
    limb(back, [pose.neck, pose.elbowB, pose.handB]);
    limb(front, [pose.neck, pose.hip]);
    limb(front, [pose.hip, pose.kneeF, pose.footF]);
    limb(front, [pose.neck, pose.elbowF, pose.handF]);

    final headRadius = size.width * 0.085;
    final head = at(pose.head);
    // Neck: from the head's edge toward the shoulders.
    final toNeck = (at(pose.neck) - head);
    if (toNeck.distance > headRadius) {
      final edge = head + toNeck / toNeck.distance * headRadius;
      canvas.drawLine(edge, at(pose.neck), front);
    }
    canvas.drawCircle(head, headRadius, Paint()..color = color);
    if (pose.headTurn.abs() > 0.05) {
      final glance = Paint()..color = Colors.white.withValues(alpha: 0.85);
      canvas.drawCircle(
        head + Offset(pose.headTurn * headRadius * 0.55, -headRadius * 0.1),
        headRadius * 0.16,
        glance,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PosePainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.color != color ||
        oldDelegate.showMat != showMat;
  }
}
