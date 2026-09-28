import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads a line of a story aloud.
///
/// No story ships with recorded narration yet, so a child who cannot read
/// alone would otherwise get nothing. The app's engine uses the platform's
/// own voices through flutter_tts; recordings replace it line by line as
/// they arrive (K3). Tests and unsupported platforms get the silent engine.
abstract class KidsReadAloudEngine {
  /// Whether a voice is available. Cheap after the first call.
  Future<bool> prepare();

  /// Speaks [text] and completes when the utterance ends or is stopped.
  Future<void> speak(String text, {required String languageCode});

  Future<void> stop();
}

class NoopKidsReadAloudEngine implements KidsReadAloudEngine {
  const NoopKidsReadAloudEngine();

  @override
  Future<bool> prepare() async => false;

  @override
  Future<void> speak(String text, {required String languageCode}) async {}

  @override
  Future<void> stop() async {}
}

/// The platform voice. Slower and a touch higher than the default, which is
/// how a grown-up reads to a small child.
class FlutterTtsReadAloudEngine implements KidsReadAloudEngine {
  FlutterTts? _tts;
  String? _language;
  bool? _available;

  Future<FlutterTts?> _instance() async {
    if (_tts != null) return _tts;
    if (_available == false) return null;
    try {
      final tts = FlutterTts();
      await tts.awaitSpeakCompletion(true);
      await tts.setSpeechRate(0.42);
      await tts.setPitch(1.05);
      _tts = tts;
      _available = true;
      return tts;
    } catch (_) {
      _available = false;
      return null;
    }
  }

  @override
  Future<bool> prepare() async => (await _instance()) != null;

  @override
  Future<void> speak(String text, {required String languageCode}) async {
    final tts = await _instance();
    if (tts == null) return;
    try {
      if (_language != languageCode) {
        await tts.setLanguage(languageCode);
        _language = languageCode;
      }
      await tts.speak(text);
    } catch (_) {
      // A missing voice is not a reason to stop the story.
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts?.stop();
    } catch (_) {}
  }
}

/// One line the reader can speak, with a stable id so the page can show
/// which line is being read.
class KidsReadAloudLine {
  const KidsReadAloudLine({required this.id, required this.text});

  final String id;
  final String text;
}

class KidsReadAloudState {
  const KidsReadAloudState({this.available, this.speakingId});

  /// Null until [KidsReadAloudController.prepare] has run.
  final bool? available;

  /// The id of the line being spoken, or null when quiet.
  final String? speakingId;

  bool get isSpeaking => speakingId != null;

  KidsReadAloudState copyWith({
    bool? available,
    String? speakingId,
    bool clearSpeaking = false,
  }) {
    return KidsReadAloudState(
      available: available ?? this.available,
      speakingId: clearSpeaking ? null : (speakingId ?? this.speakingId),
    );
  }
}

class KidsReadAloudController extends StateNotifier<KidsReadAloudState> {
  KidsReadAloudController(this._engine) : super(const KidsReadAloudState());

  final KidsReadAloudEngine _engine;

  /// Bumped by every new request so an older sequence stops touching state
  /// once a newer one, or a stop, has taken over.
  int _generation = 0;

  Future<bool> prepare() async {
    final available = await _engine.prepare();
    if (mounted) state = state.copyWith(available: available);
    return available;
  }

  Future<void> speak(
    KidsReadAloudLine line, {
    String languageCode = kidsStoryLanguageCode,
  }) {
    return speakSequence([line], languageCode: languageCode);
  }

  Future<void> speakSequence(
    List<KidsReadAloudLine> lines, {
    String languageCode = kidsStoryLanguageCode,
  }) async {
    final generation = ++_generation;
    await _engine.stop();
    for (final line in lines) {
      if (generation != _generation || !mounted) return;
      state = state.copyWith(speakingId: line.id);
      await _engine.speak(line.text, languageCode: languageCode);
    }
    if (generation == _generation && mounted) {
      state = state.copyWith(clearSpeaking: true);
    }
  }

  Future<void> stop() async {
    _generation++;
    await _engine.stop();
    if (mounted) state = state.copyWith(clearSpeaking: true);
  }

  @override
  void dispose() {
    _generation++;
    unawaited(_engine.stop());
    super.dispose();
  }
}

/// Story and duʿā-story text is English in the seeds today; K6 moves the
/// content into a localizable form and this becomes the story's own locale.
const String kidsStoryLanguageCode = 'en-US';

final kidsReadAloudEngineProvider = Provider<KidsReadAloudEngine>((ref) {
  if (kIsWeb) return const NoopKidsReadAloudEngine();
  return FlutterTtsReadAloudEngine();
});

/// Auto-disposed so leaving a reader page stops the voice.
final kidsReadAloudControllerProvider =
    StateNotifierProvider.autoDispose<
      KidsReadAloudController,
      KidsReadAloudState
    >((ref) => KidsReadAloudController(ref.watch(kidsReadAloudEngineProvider)));
