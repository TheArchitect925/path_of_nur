import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey/application/learning_path_provider.dart';
import '../domain/quran_reader_level.dart';
import 'quran_providers.dart';

/// Applies a reading-level preset across both notifiers it spans: the reader
/// display settings and the audio playback speed. Every entry point — the
/// level sheet and the one-time seed — funnels through here so the two can
/// never drift.
void applyQuranReaderLevel(Ref ref, QuranReaderLevel level) {
  ref.read(quranReaderSettingsProvider.notifier).applyReaderLevel(level);
  ref
      .read(quranAudioSettingsProvider.notifier)
      .setPlaybackSpeed(presetForQuranReaderLevel(level).playbackSpeed);
}

/// One-time seed from the Learn path level ("New to Islam" opens the reader
/// as a new reader). Runs on reader open; a no-op the moment a level exists
/// or any preset-controlled setting was hand-tuned before 7b shipped.
/// Returns the seeded level so the reader can mention it, or null when
/// nothing happened.
QuranReaderLevel? maybeSeedQuranReaderLevel(Ref ref) {
  final settingsNotifier = ref.read(quranReaderSettingsProvider.notifier);
  if (!settingsNotifier.canSeedReaderLevel) return null;
  final pathLevel = ref.read(learningPathSelectionProvider)?.selectedLevel;
  if (pathLevel == null) return null;
  final level = quranReaderLevelForLearningPath(pathLevel);
  applyQuranReaderLevel(ref, level);
  return level;
}

/// Riverpod front door for the two calls above, so widgets stay on
/// `WidgetRef.read(...)` without needing a Ref of their own.
final quranReaderLevelControllerProvider = Provider<QuranReaderLevelController>(
  (ref) => QuranReaderLevelController(ref),
);

class QuranReaderLevelController {
  const QuranReaderLevelController(this._ref);

  final Ref _ref;

  void apply(QuranReaderLevel level) => applyQuranReaderLevel(_ref, level);

  QuranReaderLevel? maybeSeed() => maybeSeedQuranReaderLevel(_ref);
}
