import '../../domain/bedtime_story_models.dart';
import 'first_steps/angels_book.dart';
import 'first_steps/five_pillars_book.dart';
import 'first_steps/five_times_a_day_book.dart';
import 'first_steps/hajj_book.dart';
import 'first_steps/jannah_book.dart';
import 'first_steps/our_prophet_book.dart';
import 'first_steps/quran_book.dart';
import 'first_steps/ramadan_book.dart';
import 'first_steps/shahada_book.dart';
import 'first_steps/sharing_book.dart';
import 'first_steps/the_call_book.dart';
import 'first_steps/what_we_believe_book.dart';
import 'first_steps/who_is_allah_book.dart';
import 'first_steps/wudu_book.dart';
import 'quran_stories/ant_hoopoe_book.dart';
import 'quran_stories/cow_book.dart';
import 'quran_stories/elephant_book.dart';
import 'quran_stories/luqman_book.dart';
import 'quran_stories/maryam_book.dart';
import 'quran_stories/qarun_book.dart';
import 'quran_stories/sleepers_book.dart';
import 'quran_stories/two_gardens_book.dart';

/// The picture books that are not rewrites of an older seed: First Steps
/// and Stories from the Qur'an. A rewritten prophet, companion or manners
/// book replaces its entry in the older list instead, so its id, quizzes
/// and progress carry over. One file per book under `books/`.
///
/// First Steps reads in learning order: who Allah is, the words we say,
/// what we believe, the five pillars one by one, then the Qur'an, the
/// angels, our Prophet ﷺ, and Jannah. Stories from the Qur'an follow.
final List<BedtimeStorySeed> kKidsPictureBooks = <BedtimeStorySeed>[
  whoIsAllahBook,
  shahadaBook,
  whatWeBelieveBook,
  fivePillarsBook,
  fiveTimesADayBook,
  wuduBook,
  theCallBook,
  sharingBook,
  ramadanBook,
  hajjBook,
  quranBook,
  angelsBook,
  ourProphetBook,
  jannahBook,
  sleepersBook,
  elephantBook,
  luqmanBook,
  maryamBook,
  twoGardensBook,
  qarunBook,
  cowBook,
  antHoopoeBook,
];
