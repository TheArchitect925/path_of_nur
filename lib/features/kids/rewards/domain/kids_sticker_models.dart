import 'package:flutter/widgets.dart';

/// Where a sticker came from. A child's book has four pages.
enum KidsStickerKind { story, letter, dua, special }

/// One sticker in the child's book. Exactly one of [imageAsset], [glyph] or
/// [icon] draws it: a story wears its cover, a letter its glyph, a duʿā and
/// the special milestones an icon.
class KidsSticker {
  const KidsSticker({
    required this.id,
    required this.kind,
    required this.title,
    this.subtitle,
    this.imageAsset,
    this.glyph,
    this.icon,
    this.color,
    this.earnedAtIso,
    this.labelKey,
  });

  final String id;
  final KidsStickerKind kind;

  /// The seed's own words for stories, letters and duʿās. Special stickers
  /// carry a [labelKey] instead and the presentation layer localises it.
  final String title;
  final String? subtitle;
  final String? labelKey;
  final String? imageAsset;
  final String? glyph;
  final IconData? icon;
  final Color? color;
  final String? earnedAtIso;
}

/// The one reward world: every sticker earned across stories, letters and
/// duʿās, and the one streak that counts a day whenever any of them was
/// finished.
class KidsRewardWorld {
  const KidsRewardWorld({
    required this.stickers,
    required this.streakDays,
    required this.completedToday,
  });

  static const empty = KidsRewardWorld(
    stickers: <KidsSticker>[],
    streakDays: 0,
    completedToday: false,
  );

  final List<KidsSticker> stickers;
  final int streakDays;
  final bool completedToday;

  int get stickerCount => stickers.length;

  List<KidsSticker> ofKind(KidsStickerKind kind) =>
      stickers.where((sticker) => sticker.kind == kind).toList(growable: false);
}

/// The streak from a list of completion moments: consecutive days ending
/// today, or ending yesterday when nothing has been finished yet today (so
/// the streak is still alive to be kept).
int kidsStreakDaysFrom(Iterable<DateTime> completionMoments, DateTime now) {
  final days = <DateTime>{
    for (final moment in completionMoments)
      DateTime(moment.year, moment.month, moment.day),
  };
  if (days.isEmpty) return 0;
  var cursor = DateTime(now.year, now.month, now.day);
  if (!days.contains(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
    if (!days.contains(cursor)) return 0;
  }
  var streak = 0;
  while (days.contains(cursor)) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}
