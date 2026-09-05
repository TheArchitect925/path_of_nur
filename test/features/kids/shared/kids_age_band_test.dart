import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/bedtime_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/data/kids_islamic_story_seed.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/domain/bedtime_story_models.dart';
import 'package:path_of_nur/features/kids/shared/application/kids_age_band_provider.dart';
import 'package:path_of_nur/features/kids/shared/domain/kids_age_band.dart';
import 'package:path_of_nur/features/learn/journey/domain/family_learning_models.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/profile/domain/profile_age_preferences.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K6: one age vocabulary. The older story and duʿā tags map onto it, a
/// child profile stores it and reads it back, shelves put the child's own
/// band first, and an adult reads as the core band.
void main() {
  test('the older age tags map onto the three bands', () {
    expect(
      KidsAgeBand.fromBedtimeStoryAgeGroup(BedtimeStoryAgeGroup.kidsEarly),
      KidsAgeBand.early,
    );
    expect(
      KidsAgeBand.fromBedtimeStoryAgeGroup(BedtimeStoryAgeGroup.kids),
      KidsAgeBand.core,
    );
    expect(
      KidsAgeBand.fromBedtimeStoryAgeGroup(BedtimeStoryAgeGroup.kidsPlus),
      KidsAgeBand.plus,
    );
    expect(KidsAgeBand.fromDuaStoryAgeGroup('3_6'), KidsAgeBand.early);
    expect(KidsAgeBand.fromDuaStoryAgeGroup('6_8'), KidsAgeBand.core);
    expect(KidsAgeBand.fromDuaStoryAgeGroup('9_12'), KidsAgeBand.plus);
    expect(KidsAgeBand.fromStorageName('plus'), KidsAgeBand.plus);
    expect(KidsAgeBand.fromStorageName(null), KidsAgeBand.core);
    expect(KidsAgeBand.fromStorageName('nonsense'), KidsAgeBand.core);
  });

  test('a shelf puts the band’s own stories first and keeps the rest', () {
    final all = [...kBedtimeProphetStories, ...kKidsIslamicStories];
    expect(kidsStoriesOrderedForBand(all, KidsAgeBand.core), all);

    final forPlus = kidsStoriesOrderedForBand(all, KidsAgeBand.plus);
    expect(forPlus.length, all.length);
    expect(forPlus.toSet(), all.toSet());
    final firstNotPlus = forPlus.indexWhere(
      (story) => story.ageGroup != BedtimeStoryAgeGroup.kidsPlus,
    );
    final lastPlus = forPlus.lastIndexWhere(
      (story) => story.ageGroup == BedtimeStoryAgeGroup.kidsPlus,
    );
    expect(lastPlus, lessThan(firstNotPlus));

    final forEarly = kidsStoriesOrderedForBand(all, KidsAgeBand.early);
    expect(forEarly.first.ageGroup, BedtimeStoryAgeGroup.kidsEarly);
  });

  test('a child profile stores its band and reads it back', () {
    final child = ChildLearningProfile(
      id: 'c1',
      displayName: 'Maryam',
      ageGroup: LearningAgeGroup.kids,
      learningLevel: LearningPathLevel.beginner,
      assignedPathId: 'kids-starter',
      preferredLanguageTag: 'en',
      avatarReference: '',
      kidsUiThemeMode: KidsUiThemeMode.auto,
      contentSafetyMode: ChildContentSafetyMode.guided,
      browsingMode: ChildBrowsingMode.guidedOnly,
      permissions: ChildLearningPermissions.defaultsFor(LearningAgeGroup.kids),
      createdAt: '2026-09-05T00:00:00Z',
      updatedAt: '2026-09-05T00:00:00Z',
      ageBand: KidsAgeBand.early,
    );
    final json = child.toJson();
    expect(json['ageBand'], 'early');
    expect(ChildLearningProfile.fromJson(json).ageBand, KidsAgeBand.early);
    // Profiles saved before K6 carry no band and read as core.
    json.remove('ageBand');
    expect(ChildLearningProfile.fromJson(json).ageBand, KidsAgeBand.core);
  });

  test('an adult profile reads as the core band', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    expect(container.read(kidsAgeBandProvider), KidsAgeBand.core);
  });
}
