import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../learn/quran_teaching/domain/quran_teaching_models.dart';
import '../data/arabic_audio_manifest.dart';
import '../data/arabic_beginner_content_catalog.dart';
import '../domain/arabic_learning_continuity_models.dart';

abstract class ArabicLearningAssetBundle {
  Future<Set<String>> assetKeys();
  Future<List<String>> availableAssets(Iterable<String> candidates);
  Future<String?> firstAvailableAsset(Iterable<String> candidates);
  Future<void> prewarmAssets(Iterable<String> assetPaths);
}

class ArabicLearningAssetManifest {
  static Future<Set<String>>? _assetKeysFuture;

  static Future<Set<String>> assetKeys() {
    _assetKeysFuture ??= _loadAssetKeys();
    return _assetKeysFuture!;
  }

  static Future<Set<String>> _loadAssetKeys() async {
    try {
      final raw = await rootBundle.loadString('AssetManifest.json');
      final decoded = json.decode(raw);
      if (decoded is! Map<String, dynamic>) {
        return <String>{};
      }
      return decoded.keys.toSet();
    } catch (_) {
      return <String>{};
    }
  }
}

class LiveArabicLearningAssetBundle implements ArabicLearningAssetBundle {
  final Set<String> _prewarmedAssets = <String>{};

  @override
  Future<Set<String>> assetKeys() => ArabicLearningAssetManifest.assetKeys();

  @override
  Future<List<String>> availableAssets(Iterable<String> candidates) async {
    final keys = await assetKeys();
    return candidates
        .where((path) => path.isNotEmpty && keys.contains(path))
        .toList(growable: false);
  }

  @override
  Future<String?> firstAvailableAsset(Iterable<String> candidates) async {
    final available = await availableAssets(candidates);
    return available.isEmpty ? null : available.first;
  }

  @override
  Future<void> prewarmAssets(Iterable<String> assetPaths) async {
    final available = await availableAssets(assetPaths);
    for (final path in available) {
      if (!_prewarmedAssets.add(path)) {
        continue;
      }
      try {
        await rootBundle.load(path);
      } catch (_) {
        _prewarmedAssets.remove(path);
      }
    }
  }
}

final arabicLearningAssetBundleProvider = Provider<ArabicLearningAssetBundle>((
  ref,
) {
  return LiveArabicLearningAssetBundle();
});

final arabicLearningOfflineWarmupProvider =
    Provider<ArabicLearningOfflineWarmup>((ref) {
      return ArabicLearningOfflineWarmup(
        bundle: ref.watch(arabicLearningAssetBundleProvider),
      );
    });

class ArabicLearningOfflineWarmup {
  ArabicLearningOfflineWarmup({required ArabicLearningAssetBundle bundle})
    : _bundle = bundle;

  final ArabicLearningAssetBundle _bundle;

  Future<void> prewarmAudienceStartBundle(
    ArabicLearningAudience audience,
  ) async {
    switch (audience) {
      case ArabicLearningAudience.kids:
        final noorAudio = arabicSharedBeginnerWordById('noor')?.audioAssetPath;
        final bismillahAudio = arabicSharedMiniPhraseById(
          'bismillah',
        )?.audioAssetPath;
        await _bundle.prewarmAssets(<String>[
          ...arabicLetterAudioCandidateAssetPaths('alif'),
          ...arabicLetterAudioCandidateAssetPaths('ba'),
          ...arabicLetterAudioCandidateAssetPaths('ta'),
          ...?singleAsset(noorAudio),
          ...?singleAsset(bismillahAudio),
        ]);
      case ArabicLearningAudience.adult:
        final rabbAudio = arabicSharedBeginnerWordById('rabb')?.audioAssetPath;
        final alhamdulillahAudio = arabicSharedMiniPhraseById(
          'alhamdulillah',
        )?.audioAssetPath;
        await _bundle.prewarmAssets(<String>[
          ...arabicLetterAudioCandidateAssetPaths('alif'),
          ...arabicLetterAudioCandidateAssetPaths('ba'),
          ...?singleAsset(rabbAudio),
          ...?singleAsset(alhamdulillahAudio),
        ]);
    }
  }

  Future<void> prewarmContinuationTarget({
    required ArabicLearningAudience audience,
    required ArabicLearningContinuationSummary continuation,
    QuranTeachingCatalog? adultCatalog,
  }) async {
    final assets = <String>{};

    switch (continuation.contentType) {
      case ArabicLearningContinuationContentType.letter:
        assets.addAll(
          arabicLetterAudioCandidateAssetPaths(continuation.primaryItemId),
        );
      case ArabicLearningContinuationContentType.word:
        final word = arabicSharedBeginnerWordById(continuation.primaryItemId);
        if (word?.audioAssetPath case final path?) {
          assets.add(path);
        }
      case ArabicLearningContinuationContentType.phrase:
        final phrase = arabicSharedMiniPhraseById(continuation.primaryItemId);
        if (phrase?.audioAssetPath case final path?) {
          assets.add(path);
        }
      case ArabicLearningContinuationContentType.lesson:
        if (adultCatalog != null &&
            continuation.primaryTarget.lessonId != null) {
          final lesson = adultCatalog.lessonById(
            continuation.primaryTarget.lessonId!,
          );
          if (lesson != null) {
            for (final step in lesson.steps) {
              if (step.audio?.assetPath case final path? when path.isNotEmpty) {
                assets.add(path);
              }
              assets.addAll(
                step.audio?.alternateAudioAssetPaths ?? const <String>[],
              );
              assets.addAll(arabicLetterAudioCandidateAssetPaths(step.id));
            }
          }
        }
      case ArabicLearningContinuationContentType.review:
        if (audience == ArabicLearningAudience.adult) {
          final phrase = arabicSharedMiniPhraseById('alhamdulillah');
          if (phrase?.audioAssetPath case final path?) {
            assets.add(path);
          }
        } else {
          assets.addAll(arabicLetterAudioCandidateAssetPaths('alif'));
        }
    }

    if (assets.isEmpty) {
      await prewarmAudienceStartBundle(audience);
      return;
    }

    await _bundle.prewarmAssets(assets);
  }
}

List<String>? singleAsset(String? path) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return <String>[path];
}
