import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../application/quran_teaching_asset_resolver.dart';
import '../../domain/quran_teaching_models.dart';

class QuranTeachingAudioIconButton extends StatelessWidget {
  const QuranTeachingAudioIconButton({
    super.key,
    required this.audio,
    required this.availableIcon,
    this.unavailableIcon = Icons.music_note_rounded,
    this.label,
    this.onAvailablePressed,
  });

  final QuranAudioCue? audio;
  final IconData availableIcon;
  final IconData unavailableIcon;
  final String? label;
  final VoidCallback? onAvailablePressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: QuranTeachingAssetResolver.hasAudio(audio),
      builder: (context, snapshot) {
        final available = snapshot.data == true;
        if (label == null) {
          return IconButton(
            onPressed: available ? onAvailablePressed : null,
            tooltip: available ? 'Play audio' : 'Audio not added yet',
            icon: Icon(available ? availableIcon : unavailableIcon),
          );
        }
        return FilledButton.tonalIcon(
          onPressed: available ? onAvailablePressed : null,
          icon: Icon(available ? availableIcon : unavailableIcon),
          label: Text(label!),
        );
      },
    );
  }
}

class QuranTeachingVisualAssetTile extends StatelessWidget {
  const QuranTeachingVisualAssetTile({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.imageAssetPath,
    this.compact = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? imageAssetPath;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: QuranTeachingAssetResolver.resolveImagePath(imageAssetPath),
      builder: (context, snapshot) {
        final resolved = snapshot.data;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 12,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.surfaceSoft.withValues(alpha: 0.6),
            border: Border.all(color: AppColors.surfaceSoft),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (resolved != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    resolved,
                    width: compact ? 32 : 40,
                    height: compact ? 32 : 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _FallbackIcon(
                      icon: icon,
                      compact: compact,
                    ),
                  ),
                )
              else
                _FallbackIcon(icon: icon, compact: compact),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    if (!compact)
                      Text(
                        hint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceSubtle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({required this.icon, required this.compact});

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 32 : 40,
      height: compact ? 32 : 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.surfaceSoft,
      ),
      child: Icon(icon, size: compact ? 18 : 22),
    );
  }
}
