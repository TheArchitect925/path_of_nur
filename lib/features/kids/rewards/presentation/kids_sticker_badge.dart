import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_palette.dart';
import '../domain/kids_sticker_models.dart';

/// A sticker as a child sees it: a rounded tile with the cover, the letter
/// or the icon on it. Used by the celebration, the book and the strip.
class KidsStickerBadge extends StatelessWidget {
  const KidsStickerBadge({super.key, required this.sticker, this.size = 72});

  final KidsSticker sticker;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = sticker.color ?? palette.accent;
    final radius = BorderRadius.circular(size * 0.28);
    Widget face;
    if (sticker.imageAsset != null) {
      face = Image.asset(
        sticker.imageAsset!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _IconFace(icon: AppIcons.stories, color: tint, size: size),
      );
    } else if (sticker.glyph != null) {
      face = Center(
        child: Text(
          sticker.glyph!,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppFonts.arabicLearning,
            fontSize: size * 0.52,
            fontWeight: FontWeight.w700,
            color: palette.onSurface,
            height: 1,
          ),
        ),
      );
    } else {
      face = _IconFace(
        icon: sticker.icon ?? AppIcons.fun,
        color: tint,
        size: size,
      );
    }
    return Semantics(
      label: sticker.title,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tint.withValues(alpha: 0.18),
          borderRadius: radius,
          border: Border.all(color: tint.withValues(alpha: 0.55), width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: face,
      ),
    );
  }
}

class _IconFace extends StatelessWidget {
  const _IconFace({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}
