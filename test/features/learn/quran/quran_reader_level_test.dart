import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_path_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_level_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reader_level.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('applying a level round-trips every bundled setting', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(quranReaderLevelControllerProvider);

    for (final level in QuranReaderLevel.values) {
      controller.apply(level);
      final preset = presetForQuranReaderLevel(level);
      final settings = container.read(quranReaderSettingsProvider);
      final audio = container.read(quranAudioSettingsProvider);

      expect(settings.readerLevel, level);
      expect(settings.arabicScalePercent, preset.arabicScalePercent);
      expect(settings.showTransliteration, preset.showTransliteration);
      expect(settings.showTranslation, preset.showTranslation);
      expect(settings.showWordByWord, preset.showWordByWord);
      expect(settings.followPlayback, preset.followPlayback);
      expect(settings.wordSyncHighlightBeta, preset.wordSyncHighlightBeta);
      expect(settings.cleanReadingMode, preset.cleanReadingMode);
      expect(settings.explanationDetailLevel, preset.explanationDetailLevel);
      expect(audio.playbackSpeed, preset.playbackSpeed);
    }
  });

  test('the applied level survives a cold start', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    container
        .read(quranReaderLevelControllerProvider)
        .apply(QuranReaderLevel.fluent);
    final store = container.read(localStoreProvider);

    // A fresh notifier over the same store is a restart.
    final rehydrated = QuranReaderSettingsNotifier(store);
    addTearDown(rehydrated.dispose);
    expect(rehydrated.state.readerLevel, QuranReaderLevel.fluent);
    expect(rehydrated.state.cleanReadingMode, isTrue);
    expect(rehydrated.state.showTranslation, isFalse);
  });

  test('a fresh install seeds from the Learn path level', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.beginner);

    final seeded = container
        .read(quranReaderLevelControllerProvider)
        .maybeSeed();

    expect(seeded, QuranReaderLevel.newReader);
    final settings = container.read(quranReaderSettingsProvider);
    expect(settings.readerLevel, QuranReaderLevel.newReader);
    expect(settings.arabicScalePercent, 130);
    expect(settings.explanationDetailLevel, QuranExplanationDetailLevel.simple);
    expect(container.read(quranAudioSettingsProvider).playbackSpeed, 0.7);
  });

  test('seeding refuses to stomp hand-tuned settings', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.beginner);
    // The user shaped the reader before presets existed.
    container
        .read(quranReaderSettingsProvider.notifier)
        .setCleanReadingMode(true);

    final seeded = container
        .read(quranReaderLevelControllerProvider)
        .maybeSeed();

    expect(seeded, isNull);
    final settings = container.read(quranReaderSettingsProvider);
    expect(settings.readerLevel, isNull);
    expect(settings.cleanReadingMode, isTrue);
  });

  test('seeding is a no-op once a level exists', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.beginner);
    final controller = container.read(quranReaderLevelControllerProvider);
    controller.apply(QuranReaderLevel.fluent);

    expect(controller.maybeSeed(), isNull);
    expect(
      container.read(quranReaderSettingsProvider).readerLevel,
      QuranReaderLevel.fluent,
    );
  });

  test('individual tweaks after a preset stick and stay persisted', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final controller = container.read(quranReaderLevelControllerProvider);
    controller.apply(QuranReaderLevel.newReader);
    container
        .read(quranReaderSettingsProvider.notifier)
        .setShowTransliteration(false);

    final settings = container.read(quranReaderSettingsProvider);
    expect(settings.showTransliteration, isFalse);
    // Preset label remains — presets are defaults, not locked modes.
    expect(settings.readerLevel, QuranReaderLevel.newReader);
  });
}
