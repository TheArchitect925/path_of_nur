import '../../bedtime_stories/data/books/friends/abu_bakr_book.dart';
import '../../bedtime_stories/data/books/friends/ali_book.dart';
import '../../bedtime_stories/data/books/friends/anas_book.dart';
import '../../bedtime_stories/data/books/friends/bilal_book.dart';
import '../../bedtime_stories/data/books/friends/fatimah_book.dart';
import '../../bedtime_stories/data/books/friends/khadijah_book.dart';
import '../../bedtime_stories/data/books/friends/thirsty_dog_book.dart';
import '../../bedtime_stories/data/books/friends/three_in_cave_book.dart';
import '../../bedtime_stories/domain/bedtime_story_models.dart';

/// Friends of the Prophet ﷺ: the Companions shelf. Five companions in the
/// order the seerah meets them, then two stories the Prophet ﷺ told. The
/// first three keep their legacy ids because the seerah journey and the
/// First Steps books point at them. One file per book under
/// `bedtime_stories/data/books/friends/`.
final List<BedtimeStorySeed> kKidsSeerahCompanionStories = <BedtimeStorySeed>[
  khadijahBook,
  abuBakrBook,
  bilalBook,
  aliBook,
  fatimahBook,
  anasBook,
  thirstyDogBook,
  threeInCaveBook,
];
