import '../domain/bedtime_story_models.dart';
import 'books/prophets/adam_book.dart';
import 'books/prophets/dawud_book.dart';
import 'books/prophets/ibrahim_book.dart';
import 'books/prophets/isa_book.dart';
import 'books/prophets/ismail_book.dart';
import 'books/prophets/muhammad_books.dart';
import 'books/prophets/musa_book.dart';
import 'books/prophets/nuh_book.dart';
import 'books/prophets/sulayman_book.dart';
import 'books/prophets/yunus_book.dart';
import 'books/prophets/yusuf_book.dart';

/// The Prophets shelf: every prophet a picture book, one file each under
/// `books/prophets/`, in the order of the chain from Adam to Muhammad ﷺ.
/// The ids are the ones the first bedtime narration scripts had, so quizzes,
/// memory decks, progress and related-story links carry over.
final List<BedtimeStorySeed> kBedtimeProphetStories = [
  adamBook,
  nuhBook,
  ibrahimBook,
  ismailBook,
  yusufBook,
  musaBook,
  yunusBook,
  dawudBook,
  isaBook,
  sulaymanBook,
  muhammadBook1,
  muhammadBook2,
  muhammadBook3,
  muhammadBook4,
];
