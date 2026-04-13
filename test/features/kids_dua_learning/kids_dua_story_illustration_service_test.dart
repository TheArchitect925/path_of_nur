import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_story_illustration_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';

void main() {
  const service = KidsDuaStoryIllustrationService();

  test('returns exact asset when available', () {
    const scene = KidsDuaStoryScene(
      id: 'scene_1',
      storyId: 'story_1',
      order: 1,
      text: 'The room was quiet.',
      illustrationHint: 'cozy bedroom with moonlight',
      mood: 'calm',
      highlightPhrase: 'quiet',
    );

    expect(
      service.getSceneAsset(scene),
      'assets/images/kids_dua_stories/scene_bedroom_night_calm.webp',
    );
  });

  test('falls back from exact match to type plus mood', () {
    const visual = KidsDuaStorySceneVisual(
      illustrationType: KidsDuaStoryIllustrationType.emotional,
      timeOfDay: KidsDuaStoryTimeOfDay.night,
      mood: KidsDuaStoryVisualMood.sad,
    );

    expect(
      service.getSceneAssetForVisual(visual),
      'assets/images/kids_dua_stories/scene_emotional_day_sad.webp',
    );
  });

  test('falls back to type only and then default', () {
    const typeOnly = KidsDuaStorySceneVisual(
      illustrationType: KidsDuaStoryIllustrationType.learning,
      timeOfDay: KidsDuaStoryTimeOfDay.night,
      mood: KidsDuaStoryVisualMood.wonder,
    );
    const defaultVisual = KidsDuaStorySceneVisual(
      illustrationType: KidsDuaStoryIllustrationType.sky,
      timeOfDay: KidsDuaStoryTimeOfDay.evening,
      mood: KidsDuaStoryVisualMood.sad,
    );

    expect(
      service.getSceneAssetForVisual(typeOnly),
      'assets/images/kids_dua_stories/scene_learning_day_calm.webp',
    );
    expect(
      service.getSceneAssetForVisual(defaultVisual),
      'assets/images/kids_dua_stories/scene_sky_day_happy.webp',
    );
  });
}
