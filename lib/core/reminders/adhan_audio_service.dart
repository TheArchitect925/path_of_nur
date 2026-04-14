import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'adhan_options.dart';

@immutable
class ResolvedAdhanOption {
  const ResolvedAdhanOption({required this.option, required this.didFallback});

  final AdhanOption option;
  final bool didFallback;
}

class AdhanRepository {
  const AdhanRepository();

  List<AdhanOption> regularOptions() =>
      AdhanRegistry.optionsFor(AdhanOptionCategory.regular);

  List<AdhanOption> fajrOptions() =>
      AdhanRegistry.optionsFor(AdhanOptionCategory.fajr);

  AdhanOption? optionById(String id) => AdhanRegistry.byId(id);

  ResolvedAdhanOption resolveRegular(AdhanSettings settings) {
    final selected = optionById(settings.selectedRegularAdhanId);
    if (selected != null &&
        selected.supportsCategory(AdhanOptionCategory.regular)) {
      return ResolvedAdhanOption(option: selected, didFallback: false);
    }
    return ResolvedAdhanOption(
      option: AdhanRegistry.defaultFor(AdhanOptionCategory.regular),
      didFallback: true,
    );
  }

  ResolvedAdhanOption resolveFajr(AdhanSettings settings) {
    return ResolvedAdhanOption(
      option: AdhanRegistry.defaultFor(AdhanOptionCategory.fajr),
      didFallback: settings.selectedFajrAdhanId != AdhanRegistry.defaultFajrId,
    );
  }

  ResolvedAdhanOption resolveForPrayer({
    required String? prayerId,
    required AdhanSettings settings,
  }) {
    return prayerId == 'fajr'
        ? resolveFajr(settings)
        : resolveRegular(settings);
  }
}

final adhanRepositoryProvider = Provider<AdhanRepository>((ref) {
  return const AdhanRepository();
});

@immutable
class AdhanPreviewState {
  const AdhanPreviewState({
    this.playingOptionId,
    this.isPlaying = false,
    this.isBuffering = false,
  });

  final String? playingOptionId;
  final bool isPlaying;
  final bool isBuffering;

  AdhanPreviewState copyWith({
    String? playingOptionId,
    bool? isPlaying,
    bool? isBuffering,
    bool clearPlayingOptionId = false,
  }) {
    return AdhanPreviewState(
      playingOptionId: clearPlayingOptionId
          ? null
          : playingOptionId ?? this.playingOptionId,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
    );
  }
}

class AdhanPreviewController extends AutoDisposeNotifier<AdhanPreviewState> {
  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  AdhanPreviewState build() {
    _player = AudioPlayer();
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      final isBuffering =
          playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering;
      final isPlaying = playerState.playing;
      if (playerState.processingState == ProcessingState.completed) {
        state = const AdhanPreviewState();
        unawaited(_player.stop());
        return;
      }
      state = state.copyWith(isPlaying: isPlaying, isBuffering: isBuffering);
      if (!isPlaying &&
          !isBuffering &&
          playerState.processingState == ProcessingState.idle) {
        state = state.copyWith(clearPlayingOptionId: true, isPlaying: false);
      }
    });
    ref.onDispose(() async {
      await _playerStateSubscription?.cancel();
      await _player.dispose();
    });
    return const AdhanPreviewState();
  }

  Future<void> playOption({
    required AdhanOption option,
    required AdhanSettings settings,
  }) async {
    if (state.playingOptionId == option.id &&
        (state.isPlaying || state.isBuffering)) {
      await stop();
      return;
    }

    await _player.stop();
    state = AdhanPreviewState(
      playingOptionId: option.id,
      isPlaying: false,
      isBuffering: true,
    );

    try {
      await _player.setAsset(option.assetPath);
      await _player.setVolume(settings.useAppVolume ? 1.0 : settings.volume);
      await _player.play();
    } catch (error, stackTrace) {
      debugPrint('adhan_preview: failed to play ${option.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
      final repository = ref.read(adhanRepositoryProvider);
      final fallback = option.category == AdhanOptionCategory.fajr
          ? repository.resolveFajr(settings)
          : repository.resolveRegular(settings);
      if (fallback.option.id != option.id) {
        try {
          await _player.setAsset(fallback.option.assetPath);
          await _player.setVolume(
            settings.useAppVolume ? 1.0 : settings.volume,
          );
          state = state.copyWith(playingOptionId: fallback.option.id);
          await _player.play();
          return;
        } catch (fallbackError, fallbackStackTrace) {
          debugPrint(
            'adhan_preview: fallback failed for ${fallback.option.id}: $fallbackError',
          );
          debugPrintStack(stackTrace: fallbackStackTrace);
        }
      }
      state = const AdhanPreviewState();
    }
  }

  Future<void> playRegular(AdhanSettings settings) async {
    final option = ref
        .read(adhanRepositoryProvider)
        .resolveRegular(settings)
        .option;
    await playOption(option: option, settings: settings);
  }

  Future<void> playFajr(AdhanSettings settings) async {
    final option = ref
        .read(adhanRepositoryProvider)
        .resolveFajr(settings)
        .option;
    await playOption(option: option, settings: settings);
  }

  Future<void> stop() async {
    await _player.stop();
    state = const AdhanPreviewState();
  }
}

final adhanPreviewControllerProvider =
    AutoDisposeNotifierProvider<AdhanPreviewController, AdhanPreviewState>(
      AdhanPreviewController.new,
    );
