import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../profile/application/profile_settings_provider.dart';
import '../domain/kids_sticker_models.dart';
import 'kids_sticker_badge.dart';

/// The chime that plays when a sticker is earned. Tests get the silent one.
abstract class KidsCelebrationSound {
  Future<void> play();
}

class NoopKidsCelebrationSound implements KidsCelebrationSound {
  const NoopKidsCelebrationSound();

  @override
  Future<void> play() async {}
}

class AssetKidsCelebrationSound implements KidsCelebrationSound {
  static const _asset = 'assets/audio/effects/kids_sticker_chime.wav';
  AudioPlayer? _player;

  @override
  Future<void> play() async {
    try {
      final player = _player ??= AudioPlayer();
      await player.setAsset(_asset);
      await player.seek(Duration.zero);
      unawaited(player.play());
    } catch (_) {
      // A celebration without a chime is still a celebration.
    }
  }
}

final kidsCelebrationSoundProvider = Provider<KidsCelebrationSound>(
  (ref) => AssetKidsCelebrationSound(),
);

/// The moment a child finishes something: a tap on the wrist, a chime, two
/// seconds of confetti and the sticker they just earned, big. Honours
/// Reduce Motion by dropping the confetti and the bounce.
Future<void> showKidsCelebration(
  BuildContext context,
  WidgetRef ref, {
  required KidsSticker sticker,
}) async {
  final reduceMotion = ref.read(
    profileSettingsProvider.select((value) => value.reduceMotion),
  );
  unawaited(HapticFeedback.mediumImpact());
  unawaited(ref.read(kidsCelebrationSoundProvider).play());
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black26,
    transitionDuration: reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _CelebrationOverlay(sticker: sticker, reduceMotion: reduceMotion);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      if (reduceMotion) return child;
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _CelebrationOverlay extends StatefulWidget {
  const _CelebrationOverlay({
    required this.sticker,
    required this.reduceMotion,
  });

  final KidsSticker sticker;
  final bool reduceMotion;

  @override
  State<_CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<_CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  static const _confettiDuration = Duration(milliseconds: 2000);
  static const _autoDismissAfter = Duration(milliseconds: 2800);

  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: _confettiDuration,
  );
  late final List<_ConfettiPiece> _pieces = _ConfettiPiece.burst(
    math.Random(widget.sticker.id.hashCode),
  );
  Timer? _autoDismiss;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion) {
      _confetti.forward();
      Future<void>.delayed(
        const Duration(milliseconds: 140),
        () => HapticFeedback.lightImpact(),
      );
    }
    _autoDismiss = Timer(_autoDismissAfter, _close);
  }

  @override
  void dispose() {
    _autoDismiss?.cancel();
    _confetti.dispose();
    super.dispose();
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final card = PremiumCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KidsStickerBadge(sticker: widget.sticker, size: 132),
          const SizedBox(height: 16),
          Text(
            l10n.kidsCelebrationTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            widget.sticker.title,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _close,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(l10n.kidsCelebrationDismissAction),
          ),
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _close,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!widget.reduceMotion)
            AnimatedBuilder(
              animation: _confetti,
              builder: (context, _) => CustomPaint(
                painter: _ConfettiPainter(
                  pieces: _pieces,
                  progress: _confetti.value,
                  colors: [
                    palette.accent,
                    palette.accentSoft,
                    palette.success,
                    palette.caution,
                  ],
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: widget.reduceMotion
                  ? card
                  : TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.6, end: 1),
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: card,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPiece {
  const _ConfettiPiece({
    required this.angle,
    required this.speed,
    required this.spin,
    required this.colorIndex,
    required this.size,
  });

  final double angle;
  final double speed;
  final double spin;
  final int colorIndex;
  final double size;

  static List<_ConfettiPiece> burst(math.Random random) {
    return [
      for (var i = 0; i < 64; i++)
        _ConfettiPiece(
          angle: -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi * 1.4,
          speed: 0.45 + random.nextDouble() * 0.75,
          spin: (random.nextDouble() - 0.5) * 10,
          colorIndex: random.nextInt(4),
          size: 6 + random.nextDouble() * 8,
        ),
    ];
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.pieces,
    required this.progress,
    required this.colors,
  });

  final List<_ConfettiPiece> pieces;
  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final origin = Offset(size.width / 2, size.height * 0.42);
    final fade = progress < 0.7 ? 1.0 : (1 - (progress - 0.7) / 0.3);
    final t = progress;
    for (final piece in pieces) {
      final distance = piece.speed * t * size.height * 0.9;
      final gravity = 0.55 * t * t * size.height;
      final position = Offset(
        origin.dx + math.cos(piece.angle) * distance,
        origin.dy + math.sin(piece.angle) * distance + gravity,
      );
      final paint = Paint()
        ..color = colors[piece.colorIndex].withValues(alpha: fade.clamp(0, 1));
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(piece.spin * t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size,
            height: piece.size * 0.6,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
