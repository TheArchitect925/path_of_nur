import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/arabic_learning_audio_controller.dart';
import '../../domain/arabic_learning_audio_models.dart';

enum ArabicLearningPlaybackToggleVariant { kids, adult }

class ArabicLearningPlaybackSpeedToggle extends ConsumerWidget {
  const ArabicLearningPlaybackSpeedToggle({
    super.key,
    this.variant = ArabicLearningPlaybackToggleVariant.adult,
  });

  final ArabicLearningPlaybackToggleVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(arabicLearningAudioControllerProvider);
    final isKids = variant == ArabicLearningPlaybackToggleVariant.kids;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: isKids ? const Color(0xFF6A5A45) : null,
    );

    return Material(
      type: MaterialType.transparency,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(l10n.arabicLearningPlaybackModeLabel, style: labelStyle),
          ChoiceChip(
            label: Text(l10n.arabicLearningPlaybackModeNormal),
            selected: state.playbackSpeed == ArabicLearningPlaybackSpeed.normal,
            onSelected: (_) {
              ref
                  .read(arabicLearningAudioControllerProvider.notifier)
                  .setPlaybackSpeed(ArabicLearningPlaybackSpeed.normal);
            },
          ),
          ChoiceChip(
            label: Text(l10n.arabicLearningPlaybackModeSlow),
            selected: state.playbackSpeed == ArabicLearningPlaybackSpeed.slow,
            onSelected: (_) {
              ref
                  .read(arabicLearningAudioControllerProvider.notifier)
                  .setPlaybackSpeed(ArabicLearningPlaybackSpeed.slow);
            },
          ),
        ],
      ),
    );
  }
}
