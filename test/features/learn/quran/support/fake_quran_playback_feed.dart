import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';

class FakeQuranPlaybackFeed implements QuranPlaybackFeed {
  final _playerStateController = StreamController<PlayerState>.broadcast();
  final _currentIndexController = StreamController<int?>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration?>.broadcast();

  bool _playing = false;
  bool _hasPlaybackSource = false;
  int? _currentIndex;
  Duration _position = Duration.zero;
  Duration? _duration;
  ProcessingState _processingState = ProcessingState.idle;

  @override
  bool get playing => _playing;

  @override
  bool get hasPlaybackSource => _hasPlaybackSource;

  @override
  int? get currentIndex => _currentIndex;

  @override
  Duration get position => _position;

  @override
  Duration? get duration => _duration;

  @override
  ProcessingState get processingState => _processingState;

  @override
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  @override
  Stream<int?> get currentIndexStream => _currentIndexController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration?> get durationStream => _durationController.stream;

  void update({
    bool? playing,
    bool? hasPlaybackSource,
    int? currentIndex,
    bool clearCurrentIndex = false,
    Duration? position,
    Duration? duration,
    ProcessingState? processingState,
  }) {
    if (playing != null) _playing = playing;
    if (hasPlaybackSource != null) _hasPlaybackSource = hasPlaybackSource;
    if (clearCurrentIndex) _currentIndex = null;
    if (currentIndex != null) _currentIndex = currentIndex;
    if (position != null) _position = position;
    if (duration != null) _duration = duration;
    if (processingState != null) _processingState = processingState;
  }

  void emitPlayerState() {
    _playerStateController.add(PlayerState(false, _processingState));
    _playerStateController.add(PlayerState(_playing, _processingState));
  }

  void emitIndex() => _currentIndexController.add(_currentIndex);

  void emitPosition() => _positionController.add(_position);

  void emitDuration() => _durationController.add(_duration);

  Future<void> dispose() async {
    await _playerStateController.close();
    await _currentIndexController.close();
    await _positionController.close();
    await _durationController.close();
  }
}
