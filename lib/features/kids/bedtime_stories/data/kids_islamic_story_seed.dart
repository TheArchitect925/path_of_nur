import 'books/manners/bismillah_book.dart';
import 'books/manners/eid_book.dart';
import 'books/manners/helping_book.dart';
import 'books/manners/kindness_animals_book.dart';
import 'books/manners/masjid_book.dart';
import 'books/manners/patience_book.dart';
import 'books/manners/ramadan_book.dart';
import 'books/manners/sharing_book.dart';
import 'books/manners/sorry_book.dart';
import 'books/manners/truth_book.dart';
import '../domain/bedtime_story_models.dart';

/// The ten Good Manners books, in shelf order. Each keeps the id its quiz,
/// memory deck and narration slot were written for; the text is a picture
/// book on the K3 scenes with the cast (Safa, Zayn, Amina and the cat
/// Misk). One file per book under `books/manners/`.
final List<BedtimeStorySeed> kKidsIslamicStories = <BedtimeStorySeed>[
  bismillahBook,
  sharingBook,
  truthBook,
  helpingBook,
  kindnessAnimalsBook,
  masjidBook,
  ramadanKindnessBook,
  eidBook,
  patienceBook,
  sorryBook,
];
