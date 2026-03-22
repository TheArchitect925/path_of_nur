import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'shell and watch playback entry points no longer resume via raw player',
    () {
      final shell = File(
        'lib/shared/widgets/app_scaffold.dart',
      ).readAsStringSync();
      final watch = File(
        'lib/features/watch_companion/application/watch_quran_audio_contract.dart',
      ).readAsStringSync();

      expect(shell.contains('resumeCurrentPlayback()'), isTrue);
      expect(watch.contains('resumeCurrentPlayback()'), isTrue);
      expect(shell.contains('player.play()'), isFalse);
      expect(watch.contains('player.play()'), isFalse);
    },
  );

  test(
    'reader page no longer builds Qur’an playback queues directly in the UI layer',
    () {
      final reader = File(
        'lib/features/learn/quran/presentation/quran_reader_page.dart',
      ).readAsStringSync();

      expect(reader.contains('_audioPlayer.setAudioSources('), isFalse);
      expect(reader.contains('_audioPlayer.setFilePath('), isFalse);
      expect(reader.contains('_playerController.startPreparedPlayback('), isTrue);
    },
  );

  test('watch next previous and mobile resume use controller-owned surah entry paths', () {
    final watch = File(
      'lib/features/watch_companion/application/watch_quran_audio_contract.dart',
    ).readAsStringSync();
    final controller = File(
      'lib/features/learn/quran/application/quran_player_controller.dart',
    ).readAsStringSync();

    expect(watch.contains('playAdjacentSurah(1)'), isTrue);
    expect(watch.contains('playAdjacentSurah(-1)'), isTrue);
    expect(controller.contains('quranRecitationSessionProvider'), isTrue);
    expect(controller.contains('_restoreSessionFromStoredProgress'), isTrue);
  });

  test('reader ayah-entry path no longer uses raw seek for surah re-entry jumps', () {
    final reader = File(
      'lib/features/learn/quran/presentation/quran_reader_page.dart',
    ).readAsStringSync();

    expect(reader.contains('_audioPlayer.seek(Duration.zero, index: targetIndex);'), isFalse);
    expect(reader.contains('_startSurahPlayback('), isTrue);
  });
}
