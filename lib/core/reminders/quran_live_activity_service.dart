import 'dart:io';

import 'package:flutter/services.dart';

class QuranLiveActivityService {
  static const MethodChannel _channel = MethodChannel(
    'path_of_nur/live_activities',
  );

  Future<bool> isSupported() async {
    if (!Platform.isIOS) return false;
    try {
      final value = await _channel.invokeMethod<bool>('isSupported');
      return value ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> updatePlaybackCard({
    required int surahNumber,
    required String surahName,
    required String surahArabicName,
    required int ayahNumber,
    required String reciterName,
    required bool isPlaying,
    required int elapsedSeconds,
    required int totalSeconds,
  }) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('updateQuranPlayback', {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahArabicName': surahArabicName,
        'ayahNumber': ayahNumber,
        'reciterName': reciterName,
        'isPlaying': isPlaying,
        'elapsedSeconds': elapsedSeconds,
        'totalSeconds': totalSeconds,
      });
    } catch (_) {
      // Ignore ActivityKit errors to avoid breaking playback UX.
    }
  }

  Future<void> endPlaybackCard() async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('endQuranPlayback');
    } catch (_) {
      // Ignore ActivityKit errors to avoid breaking playback UX.
    }
  }
}
