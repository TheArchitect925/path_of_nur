import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/kids_dua_models.dart';

final kidsDuaStoryIllustrationServiceProvider =
    Provider<KidsDuaStoryIllustrationService>(
      (ref) => const KidsDuaStoryIllustrationService(),
    );

class KidsDuaStoryIllustrationService {
  const KidsDuaStoryIllustrationService();

  static const String _basePath = 'assets/images/kids_dua_stories';

  static const Set<String> _availableAssets = <String>{
    '$_basePath/scene_bedroom_night_calm.png',
    '$_basePath/scene_bedroom_morning_happy.png',
    '$_basePath/scene_table_day_happy.png',
    '$_basePath/scene_table_day_neutral.png',
    '$_basePath/scene_sky_night_wonder.png',
    '$_basePath/scene_sky_day_happy.png',
    '$_basePath/scene_home_day_neutral.png',
    '$_basePath/scene_home_evening_calm.png',
    '$_basePath/scene_learning_day_calm.png',
    '$_basePath/scene_emotional_day_sad.png',
    '$_basePath/scene_emotional_day_calm.png',
    '$_basePath/scene_default_day_neutral.png',
  };

  String getSceneAsset(KidsDuaStoryScene scene) {
    return getSceneAssetForVisual(scene.resolvedVisual);
  }

  String getSceneAssetForVisual(KidsDuaStorySceneVisual visual) {
    final type = visual.illustrationType.assetName;
    final time = visual.timeOfDay.assetName;
    final mood = visual.mood.assetName;

    final exact = _assetPath(type, time, mood);
    if (_availableAssets.contains(exact)) {
      return exact;
    }

    final typeAndMood =
        _availableAssets
            .where(
              (path) =>
                  path.contains('/scene_${type}_') &&
                  path.endsWith('_$mood.png'),
            )
            .toList(growable: false)
          ..sort();
    if (typeAndMood.isNotEmpty) {
      return typeAndMood.first;
    }

    final typeOnly =
        _availableAssets
            .where((path) => path.contains('/scene_${type}_'))
            .toList(growable: false)
          ..sort();
    if (typeOnly.isNotEmpty) {
      return typeOnly.first;
    }

    return '$_basePath/scene_default_day_neutral.png';
  }

  IconData fallbackIconForVisual(KidsDuaStorySceneVisual visual) {
    switch (visual.illustrationType) {
      case KidsDuaStoryIllustrationType.bedroom:
        return Icons.bedtime_rounded;
      case KidsDuaStoryIllustrationType.table:
        return Icons.restaurant_rounded;
      case KidsDuaStoryIllustrationType.sky:
        return Icons.wb_twilight_rounded;
      case KidsDuaStoryIllustrationType.home:
        return Icons.home_rounded;
      case KidsDuaStoryIllustrationType.learning:
        return Icons.menu_book_rounded;
      case KidsDuaStoryIllustrationType.emotional:
        return Icons.favorite_border_rounded;
    }
  }

  String _assetPath(String type, String time, String mood) {
    return '$_basePath/scene_${type}_${time}_$mood.png';
  }
}

extension on KidsDuaStoryIllustrationType {
  String get assetName {
    switch (this) {
      case KidsDuaStoryIllustrationType.bedroom:
        return 'bedroom';
      case KidsDuaStoryIllustrationType.table:
        return 'table';
      case KidsDuaStoryIllustrationType.sky:
        return 'sky';
      case KidsDuaStoryIllustrationType.home:
        return 'home';
      case KidsDuaStoryIllustrationType.learning:
        return 'learning';
      case KidsDuaStoryIllustrationType.emotional:
        return 'emotional';
    }
  }
}

extension on KidsDuaStoryTimeOfDay {
  String get assetName {
    switch (this) {
      case KidsDuaStoryTimeOfDay.morning:
        return 'morning';
      case KidsDuaStoryTimeOfDay.day:
        return 'day';
      case KidsDuaStoryTimeOfDay.evening:
        return 'evening';
      case KidsDuaStoryTimeOfDay.night:
        return 'night';
    }
  }
}

extension on KidsDuaStoryVisualMood {
  String get assetName {
    switch (this) {
      case KidsDuaStoryVisualMood.calm:
        return 'calm';
      case KidsDuaStoryVisualMood.happy:
        return 'happy';
      case KidsDuaStoryVisualMood.sad:
        return 'sad';
      case KidsDuaStoryVisualMood.wonder:
        return 'wonder';
      case KidsDuaStoryVisualMood.neutral:
        return 'neutral';
    }
  }
}
