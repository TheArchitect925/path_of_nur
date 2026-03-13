import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/salah_trainer_models.dart';

class SalahAudioService {
  SalahAudioService() : _player = AudioPlayer(), _tts = FlutterTts();

  final AudioPlayer _player;
  final FlutterTts _tts;

  Future<void> configure() async {
    await _tts.setLanguage('ar');
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> playStep(PrayerStepModel step, {bool slow = false}) async {
    await stop();
    if (step.audioAssetPath != null && step.audioAssetPath!.isNotEmpty) {
      await _player.setAsset(step.audioAssetPath!);
      await _player.setSpeed(slow ? 0.75 : 1.0);
      await _player.play();
      await _player.playerStateStream.firstWhere(
        (state) =>
            state.processingState == ProcessingState.completed ||
            !state.playing,
      );
      return;
    }

    final ttsText = step.ttsText?.trim().isNotEmpty == true
        ? step.ttsText!.trim()
        : step.arabicText;
    if (ttsText.isEmpty) return;
    await _tts.setSpeechRate(slow ? 0.28 : 0.42);
    await _tts.speak(ttsText);
  }

  Future<void> playAyah(SurahVerseModel verse, {bool slow = false}) async {
    await stop();
    if (verse.audio.localAudioAssetPath != null &&
        verse.audio.localAudioAssetPath!.isNotEmpty) {
      await _player.setAsset(verse.audio.localAudioAssetPath!);
      await _player.setSpeed(slow ? 0.75 : 1.0);
      await _player.play();
      await _player.playerStateStream.firstWhere(
        (state) =>
            state.processingState == ProcessingState.completed ||
            !state.playing,
      );
      return;
    }
    await _tts.setSpeechRate(slow ? 0.28 : 0.42);
    await _tts.speak(verse.arabicText);
  }

  Future<void> stop() async {
    await _player.stop();
    await _tts.stop();
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}

final salahAudioServiceProvider = Provider<SalahAudioService>((ref) {
  final service = SalahAudioService();
  unawaited(service.configure());
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});
