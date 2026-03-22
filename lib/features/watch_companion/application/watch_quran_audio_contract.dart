import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../shared/persistence/local_store.dart';
import '../../learn/quran/application/quran_player_controller.dart';
import '../../learn/quran/application/quran_providers.dart';
import 'watch_sync_diagnostics.dart';

const _watchQuranOutputKey = 'watch.quran.output.v1';

enum QuranPlaybackSourceType { phone, watch }

enum QuranPlaybackCommand {
  play,
  pause,
  next,
  previous,
  seekForward15,
  seekBack15,
  switchOutputPhone,
  switchOutputWatch,
  resumeLast,
}

class QuranPlaybackSnapshot {
  const QuranPlaybackSnapshot({
    required this.playbackSessionId,
    required this.sourceType,
    required this.isPlaying,
    required this.surahId,
    required this.surahName,
    required this.reciterId,
    required this.reciterName,
    required this.currentAyah,
    required this.positionSeconds,
    required this.durationSeconds,
    required this.isBuffering,
    required this.lastUpdatedAt,
  });

  final String playbackSessionId;
  final QuranPlaybackSourceType sourceType;
  final bool isPlaying;
  final int? surahId;
  final String surahName;
  final String reciterId;
  final String reciterName;
  final int? currentAyah;
  final int positionSeconds;
  final int? durationSeconds;
  final bool isBuffering;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'playbackSessionId': playbackSessionId,
    'sourceType': sourceType.name,
    'isPlaying': isPlaying,
    'surahId': surahId,
    'surahName': surahName,
    'reciterId': reciterId,
    'reciterName': reciterName,
    'currentAyah': currentAyah,
    'positionSeconds': positionSeconds,
    'durationSeconds': durationSeconds,
    'isBuffering': isBuffering,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
  };
}

class WatchAudioAvailabilitySnapshot {
  const WatchAudioAvailabilitySnapshot({
    required this.watchPlaybackAvailable,
    required this.downloadedSurahIds,
    required this.recentPlayableItems,
    required this.lastSyncedAt,
  });

  final bool watchPlaybackAvailable;
  final List<int> downloadedSurahIds;
  final List<String> recentPlayableItems;
  final DateTime lastSyncedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'watchPlaybackAvailable': watchPlaybackAvailable,
    'downloadedSurahIds': downloadedSurahIds,
    'recentPlayableItems': recentPlayableItems,
    'lastSyncedAt': lastSyncedAt.toIso8601String(),
  };
}

class WatchQuranPlaybackSnapshotBuilder {
  const WatchQuranPlaybackSnapshotBuilder(this.ref);

  final Ref ref;

  QuranPlaybackSnapshot build() {
    final player = ref.read(quranSharedAudioPlayerProvider);
    final session = ref.read(quranRecitationSessionProvider);
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    final surahMap = ref.read(quranSurahMapProvider);
    final store = ref.read(localStoreProvider);
    final sourceType = switch (store.getString(_watchQuranOutputKey)) {
      'watch' => QuranPlaybackSourceType.watch,
      _ => QuranPlaybackSourceType.phone,
    };
    final surahId = session?.surahNumber;
    final surahName = surahId == null
        ? 'Resume Last Recitation'
        : (surahMap[surahId]?.transliteratedName ?? 'Surah $surahId');
    final reciter = audioRepository.reciterById(audioSettings.reciterId);
    final snapshot = QuranPlaybackSnapshot(
      playbackSessionId: session == null
          ? 'quran-idle'
          : 'quran:${session.surahNumber}:${audioSettings.reciterId}:${session.updatedAtIso}',
      sourceType: sourceType,
      isPlaying: player.playing,
      surahId: surahId,
      surahName: surahName,
      reciterId: reciter.id,
      reciterName: reciter.name,
      currentAyah: session?.ayahNumber,
      positionSeconds: player.position.inSeconds > 0
          ? player.position.inSeconds
          : (session?.positionSeconds ?? 0),
      durationSeconds: player.duration?.inSeconds,
      isBuffering:
          player.processingState == ProcessingState.loading ||
          player.processingState == ProcessingState.buffering,
      lastUpdatedAt: DateTime.now(),
    );
    WatchSyncDiagnostics.log('quran_snapshot_generated', <String, Object?>{
      'surahId': snapshot.surahId,
      'sourceType': snapshot.sourceType.name,
      'isPlaying': snapshot.isPlaying,
    });
    return snapshot;
  }
}

class WatchQuranAudioAvailabilityBuilder {
  const WatchQuranAudioAvailabilityBuilder(this.ref);

  final Ref ref;

  Future<WatchAudioAvailabilitySnapshot> build() async {
    final audioRepository = ref.read(quranAudioRepositoryProvider);
    final audioSettings = ref.read(quranAudioSettingsProvider);
    final recentReadings = ref.read(quranRecentReadingsProvider);
    final session = ref.read(quranRecitationSessionProvider);
    final candidates = <int>{
      if (session != null) session.surahNumber,
      ...recentReadings.take(4).map((item) => item.surahNumber),
    }.toList()..sort();
    final downloaded = <int>[];
    for (final surahId in candidates) {
      if (await audioRepository.isSurahDownloaded(
        reciterId: audioSettings.reciterId,
        surahNumber: surahId,
      )) {
        downloaded.add(surahId);
      }
    }
    final result = WatchAudioAvailabilitySnapshot(
      watchPlaybackAvailable: downloaded.isNotEmpty,
      downloadedSurahIds: downloaded,
      recentPlayableItems: downloaded.map((id) => 'Surah $id').toList(),
      lastSyncedAt: DateTime.now(),
    );
    WatchSyncDiagnostics.log('quran_availability_generated', <String, Object?>{
      'watchPlaybackAvailable': result.watchPlaybackAvailable,
      'downloadedCount': downloaded.length,
    });
    return result;
  }
}

class WatchQuranPlaybackCommandService {
  const WatchQuranPlaybackCommandService(this.ref);

  final Ref ref;

  Future<QuranPlaybackSnapshot> send(QuranPlaybackCommand command) async {
    final player = ref.read(quranSharedAudioPlayerProvider);
    final controller = ref.read(quranPlayerControllerProvider);
    final store = ref.read(localStoreProvider);
    switch (command) {
      case QuranPlaybackCommand.play:
      case QuranPlaybackCommand.resumeLast:
        await controller.resumeCurrentPlayback();
        break;
      case QuranPlaybackCommand.pause:
        await controller.pause();
        break;
      case QuranPlaybackCommand.next:
        if (player.hasNext) {
          await player.seekToNext();
        } else if (await controller.playAdjacentSurah(1)) {
          break;
        } else {
          await player.seek(Duration.zero);
        }
        break;
      case QuranPlaybackCommand.previous:
        if (player.hasPrevious) {
          await player.seekToPrevious();
        } else if (player.position > const Duration(seconds: 3)) {
          await player.seek(Duration.zero);
        } else if (await controller.playAdjacentSurah(-1)) {
          break;
        } else {
          await player.seek(Duration.zero);
        }
        break;
      case QuranPlaybackCommand.seekForward15:
        final next = player.position + const Duration(seconds: 15);
        await player.seek(next);
        break;
      case QuranPlaybackCommand.seekBack15:
        final next = player.position - const Duration(seconds: 15);
        await player.seek(next < Duration.zero ? Duration.zero : next);
        break;
      case QuranPlaybackCommand.switchOutputPhone:
        store.setString(_watchQuranOutputKey, 'phone');
        await player.pause();
        break;
      case QuranPlaybackCommand.switchOutputWatch:
        store.setString(_watchQuranOutputKey, 'watch');
        await player.pause();
        break;
    }
    WatchSyncDiagnostics.log('quran_command_applied', <String, Object?>{
      'command': command.name,
    });
    return WatchQuranPlaybackSnapshotBuilder(ref).build();
  }
}

class AppleWatchQuranBridgeAdapter {
  const AppleWatchQuranBridgeAdapter(this.ref);

  final Ref ref;

  Future<Map<String, dynamic>> buildPlaybackPayload() async =>
      WatchQuranPlaybackSnapshotBuilder(ref).build().toJson();

  Future<Map<String, dynamic>> buildAvailabilityPayload() async =>
      (await WatchQuranAudioAvailabilityBuilder(ref).build()).toJson();

  Future<Map<String, dynamic>> applyCommand(String rawCommand) async {
    final command = QuranPlaybackCommand.values.firstWhere(
      (item) => item.name == rawCommand,
      orElse: () => QuranPlaybackCommand.resumeLast,
    );
    return (await WatchQuranPlaybackCommandService(ref).send(command)).toJson();
  }
}

class WearOsQuranBridgeAdapter {
  const WearOsQuranBridgeAdapter(this.ref);

  final Ref ref;

  Future<Map<String, dynamic>> buildPlaybackPayload() async =>
      WatchQuranPlaybackSnapshotBuilder(ref).build().toJson();

  Future<Map<String, dynamic>> buildAvailabilityPayload() async =>
      (await WatchQuranAudioAvailabilityBuilder(ref).build()).toJson();

  Future<Map<String, dynamic>> applyCommand(String rawCommand) async {
    final command = QuranPlaybackCommand.values.firstWhere(
      (item) => item.name == rawCommand,
      orElse: () => QuranPlaybackCommand.resumeLast,
    );
    return (await WatchQuranPlaybackCommandService(ref).send(command)).toJson();
  }
}

final watchQuranPlaybackSnapshotBuilderProvider =
    Provider<WatchQuranPlaybackSnapshotBuilder>(
      WatchQuranPlaybackSnapshotBuilder.new,
    );

final watchQuranAudioAvailabilityBuilderProvider =
    Provider<WatchQuranAudioAvailabilityBuilder>(
      WatchQuranAudioAvailabilityBuilder.new,
    );

final watchQuranPlaybackCommandServiceProvider =
    Provider<WatchQuranPlaybackCommandService>(
      WatchQuranPlaybackCommandService.new,
    );

final appleWatchQuranBridgeAdapterProvider =
    Provider<AppleWatchQuranBridgeAdapter>(AppleWatchQuranBridgeAdapter.new);

final wearOsQuranBridgeAdapterProvider = Provider<WearOsQuranBridgeAdapter>(
  WearOsQuranBridgeAdapter.new,
);
