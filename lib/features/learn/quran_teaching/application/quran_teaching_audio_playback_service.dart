import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../arabic/application/arabic_learning_audio_controller.dart';
import '../domain/quran_teaching_models.dart';
import 'quran_teaching_asset_resolver.dart';

class QuranTeachingAudioPlaybackService {
  QuranTeachingAudioPlaybackService([this._ref]);

  final Ref? _ref;

  Future<bool> playCue(QuranAudioCue cue) async {
    if (_ref == null) {
      return false;
    }
    final path = await QuranTeachingAssetResolver.resolveAudioPath(cue);
    return _ref
        .read(arabicLearningAudioControllerProvider.notifier)
        .playResolvedAudio(
          playbackId: 'teaching:${cue.id}',
          primaryAssetPath: path,
          alternateAssetPaths: cue.alternateAudioAssetPaths,
          fallbackText: cue.fallbackTextLabel,
        );
  }

  Future<void> stop() async {
    if (_ref == null) {
      return;
    }
    await _ref.read(arabicLearningAudioControllerProvider.notifier).stop();
  }

  Future<void> dispose() async {}
}

final quranTeachingAudioPlaybackServiceProvider =
    Provider<QuranTeachingAudioPlaybackService>((ref) {
      return QuranTeachingAudioPlaybackService(ref);
    });
