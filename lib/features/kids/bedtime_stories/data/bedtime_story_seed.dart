import '../domain/bedtime_story_models.dart';
import 'books/prophets/adam_book.dart';
import 'books/prophets/ayyub_book.dart';
import 'books/prophets/dawud_book.dart';
import 'books/prophets/dhul_kifl_book.dart';
import 'books/prophets/harun_book.dart';
import 'books/prophets/hud_book.dart';
import 'books/prophets/ibrahim_book.dart';
import 'books/prophets/idris_book.dart';
import 'books/prophets/ilyas_alyasa_book.dart';
import 'books/prophets/isa_book.dart';
import 'books/prophets/ishaq_yaqub_book.dart';
import 'books/prophets/ismail_book.dart';
import 'books/prophets/lut_book.dart';
import 'books/prophets/muhammad_books.dart';
import 'books/prophets/musa_book.dart';
import 'books/prophets/nuh_book.dart';
import 'books/prophets/salih_book.dart';
import 'books/prophets/shuayb_book.dart';
import 'books/prophets/sulayman_book.dart';
import 'books/prophets/yunus_book.dart';
import 'books/prophets/yusuf_book.dart';
import 'books/prophets/zakariya_yahya_book.dart';

/// The Prophets shelf: every prophet the Qur'an names by name, one picture
/// book each (three share a book with the prophet the Qur'an names beside
/// them), in the order of the chain from Adam to Muhammad ﷺ. The older ids
/// are the ones the first bedtime narration scripts had, so quizzes, memory
/// decks, progress and related-story links carry over.
final List<BedtimeStorySeed> kBedtimeProphetStories = [
  adamBook,
  idrisBook,
  nuhBook,
  hudBook,
  salihBook,
  ibrahimBook,
  lutBook,
  ismailBook,
  ishaqYaqubBook,
  yusufBook,
  shuaybBook,
  ayyubBook,
  dhulKiflBook,
  musaBook,
  harunBook,
  dawudBook,
  sulaymanBook,
  ilyasAlyasaBook,
  yunusBook,
  zakariyaYahyaBook,
  isaBook,
  muhammadBook1,
  muhammadBook2,
  muhammadBook3,
  muhammadBook4,
];
