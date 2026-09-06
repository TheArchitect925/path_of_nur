import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// Five Times a Day. Surah Ta-Ha 20:14 and an-Nisa 4:103; the river that
/// washes five times a day is in Sahih al-Bukhari 528. Ends in prayer times.
final BedtimeStorySeed fiveTimesADayBook = kidsPictureBook(
  id: 'book_first_steps_five_times_a_day_v1',
  storyFamilyId: 'first_steps_five_times_a_day',
  title: 'Five Times a Day',
  shortTitle: 'Five Times a Day',
  summary:
      'Safa\'s alarm, five prayers, and what happens when the whole world '
      'turns to Allah together.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.trustInAllah],
  refrain: 'Five times a day.',
  lesson:
      'Pray five times a day. It is how we talk to Allah and how He keeps '
      'us clean.',
  bedtimeClosing:
      'Now close your eyes. Tomorrow starts with Fajr, and Allah will be '
      'waiting. Good night.',
  quranQuote:
      'Indeed, I am Allah. There is no god but Me, so worship Me '
      'and establish prayer for My remembrance.',
  quranReference: 'Qur’an 20:14',
  quranQuoteRef: const QuranQuoteRef(surah: 20, ayah: 14),
  sourceNote:
      'Follows Ta-Ha 20:14 and an-Nisa 4:103; the river that washes five '
      'times a day is in Sahih al-Bukhari 528; sujud as the closest a '
      'servant comes to Allah is in Sahih Muslim 482.',
  tags: const ['first steps', 'salah', 'prayer', 'fajr'],
  sortOrder: 304,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/five_times_a_day_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_wudu_v1',
    'book_first_steps_the_call_v1',
  ],
  spreads: const [
    KidsBookSpread([
      'Before the sun comes up, Safa\'s alarm rings.',
      'Fajr. The first prayer of the day.',
    ], illustrationAsset: '$_scenes/steps_salah_dawn_window.webp'),
    KidsBookSpread(
      [
        'Muslims pray five times a day.',
        'Fajr, Dhuhr, Asr, Maghrib, Isha. Five times a day.',
      ],
      illustrationAsset: '$_scenes/pillars_mat.webp',
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Why? Because Allah asked us to.',
        '"Establish prayer to remember Me," Allah says.',
      ],
      illustrationAsset: '$_scenes/steps_salah_dawn_window.webp',
      quranRef: QuranQuoteRef(surah: 20, ayah: 14),
    ),
    KidsBookSpread([
      'Salah is talking to Allah.',
      'We stand, we bow, we put our foreheads on the ground.',
    ], illustrationAsset: '$_scenes/steps_salah_kids_standing.webp'),
    KidsBookSpread(
      [
        'Standing: Allahu Akbar. Allah is the greatest.',
        'Zayn stands very still.',
      ],
      illustrationAsset: '$_scenes/steps_salah_kids_standing.webp',
      arabicLine: 'ٱللَّٰهُ أَكْبَرُ',
    ),
    KidsBookSpread([
      'Sujud: the closest a person can be to Allah.',
      'Safa whispers her duʿā there.',
    ], illustrationAsset: '$_scenes/steps_salah_sujud.webp'),
    KidsBookSpread(
      [
        'Five times a day, the whole world stops and turns to Allah.',
        'Millions of people, all at once.',
      ],
      atlasScene: KidsBookAtlasScene.masjid,
      isRefrain: true,
    ),
    KidsBookSpread(
      [
        'Salah washes away small mistakes, like a river washes dust.',
        'Five times a day.',
      ],
      atlasScene: KidsBookAtlasScene.garden,
      isRefrain: true,
    ),
    KidsBookSpread([
      'When you hear the adhan, come and stand next to your family.',
      'Even one prayer is a start.',
    ], illustrationAsset: '$_scenes/steps_salah_kids_standing.webp'),
    KidsBookSpread(
      ['When is the next prayer?', 'Let\'s look.'],
      illustrationAsset: '$_scenes/steps_salah_dawn_window.webp',
      tryItRoute: '/worship/prayer',
    ),
  ],
);
