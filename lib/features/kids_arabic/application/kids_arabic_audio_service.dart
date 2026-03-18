import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../domain/kids_arabic_models.dart';

class KidsArabicAudioService {
  KidsArabicAudioService() : _tts = FlutterTts();

  final FlutterTts _tts;

  Future<void> configure() async {
    await _tts.setLanguage('ar');
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.35);
  }

  Future<void> speakLetter(KidsArabicLetter letter) async {
    await _tts.stop();
    await _tts.speak(letter.nameAr);
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}

final kidsArabicAudioServiceProvider = Provider<KidsArabicAudioService>((ref) {
  final service = KidsArabicAudioService();
  unawaited(service.configure());
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});
