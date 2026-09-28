import '../../bedtime_stories/domain/bedtime_story_models.dart';

/// The one age vocabulary for the kids area.
///
/// Five vocabularies described a child's age and none of them changed what a
/// child got. This is the one that does: it sets the type scale, decides
/// which stories come first, and (from K6 on) how much a page explains.
enum KidsAgeBand {
  /// 3–5: pre-readers. Biggest type, pictures first, a voice on every line.
  early,

  /// 6–8: early readers. The default.
  core,

  /// 9–12: fluent readers. Denser pages, longer stories first.
  plus;

  /// How much larger (or smaller) text reads for this band on top of the
  /// kids theme's own scale.
  double get textScale => switch (this) {
    KidsAgeBand.early => 1.12,
    KidsAgeBand.core => 1.0,
    KidsAgeBand.plus => 0.94,
  };

  static KidsAgeBand fromBedtimeStoryAgeGroup(BedtimeStoryAgeGroup group) {
    return switch (group) {
      BedtimeStoryAgeGroup.kidsEarly => KidsAgeBand.early,
      BedtimeStoryAgeGroup.kids => KidsAgeBand.core,
      BedtimeStoryAgeGroup.kidsPlus => KidsAgeBand.plus,
    };
  }

  /// The duʿā stories tag themselves with strings like '3_6'.
  static KidsAgeBand fromDuaStoryAgeGroup(String ageGroup) {
    final start = int.tryParse(ageGroup.split('_').first) ?? 6;
    if (start <= 3) return KidsAgeBand.early;
    if (start >= 9) return KidsAgeBand.plus;
    return KidsAgeBand.core;
  }

  static KidsAgeBand fromStorageName(String? name) {
    for (final band in KidsAgeBand.values) {
      if (band.name == name) return band;
    }
    return KidsAgeBand.core;
  }

  /// Whether a story written for [group] is a natural fit for this band.
  /// A core reader takes everything; the ends of the range prefer their own.
  bool fitsStory(BedtimeStoryAgeGroup group) {
    final storyBand = fromBedtimeStoryAgeGroup(group);
    return switch (this) {
      KidsAgeBand.core => true,
      KidsAgeBand.early => storyBand != KidsAgeBand.plus,
      KidsAgeBand.plus => storyBand != KidsAgeBand.early,
    };
  }
}

/// Stories a band reads first, then the rest, each part in its given order.
List<BedtimeStorySeed> kidsStoriesOrderedForBand(
  List<BedtimeStorySeed> stories,
  KidsAgeBand band,
) {
  if (band == KidsAgeBand.core) return stories;
  final own = <BedtimeStorySeed>[];
  final rest = <BedtimeStorySeed>[];
  for (final story in stories) {
    final storyBand = KidsAgeBand.fromBedtimeStoryAgeGroup(story.ageGroup);
    (storyBand == band ? own : rest).add(story);
  }
  return [...own, ...rest];
}
