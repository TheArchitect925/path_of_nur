import '../../../../../learn/quran/domain/quran_content_refs.dart';
import '../../../domain/bedtime_story_models.dart';
import '../kids_picture_book.dart';

const String _scenes = 'assets/images/kids_books/scenes';

/// The Call from the Minaret. Surah al-Jumu'ah 62:9; repeating the adhan
/// after the caller is in Sahih al-Bukhari 611. Ends in the salah guide.
final BedtimeStorySeed theCallBook = kidsPictureBook(
  id: 'book_first_steps_the_call_v1',
  storyFamilyId: 'first_steps_the_call',
  title: 'The Call from the Minaret',
  shortTitle: 'The Call',
  summary:
      'Zayn hears a voice from the minaret, learns what it says, and who '
      'first called it.',
  category: BedtimeStoryCategory.foundations,
  collectionType: KidsIslamicStoryCollectionType.foundations,
  storyType: KidsIslamicStoryType.foundations,
  themes: const [KidsIslamicStoryTheme.masjid],
  refrain: 'Come to prayer.',
  lesson: 'When you hear the adhan, stop, repeat it quietly, and go to prayer.',
  bedtimeClosing:
      'Now close your eyes. Tomorrow the call will come, and you will know '
      'what it says. Good night.',
  quranQuote:
      'O you who have believed, when the call is made for prayer, hasten to '
      'the remembrance of Allah.',
  quranReference: 'Qur’an 62:9',
  quranQuoteRef: const QuranQuoteRef(surah: 62, ayah: 9),
  sourceNote:
      'Follows al-Jumu’ah 62:9; repeating the adhan after the caller is in '
      'Sahih al-Bukhari 611; Bilal as the first to call is in the seerah.',
  tags: const ['first steps', 'adhan', 'masjid', 'bilal'],
  sortOrder: 306,
  bedtimeEligible: false,
  coverAssetPath: 'assets/images/kids_books/covers/the_call_cover.webp',
  relatedStoryIds: const [
    'book_first_steps_five_times_a_day_v1',
    'story_companion_bilal_patience_v1',
  ],
  de: const KidsBookTranslation(
    title: 'Der Ruf vom Minarett',
    shortTitle: 'Der Ruf',
    summary:
        'Zayn hört eine Stimme vom Minarett, lernt, was sie sagt, und wer sie zuerst rief.',
    lesson:
        'Wenn du den Adhan hörst, halt an, sprich ihn leise nach und geh zum Gebet.',
    refrain: 'Kommt zum Gebet.',
    bedtimeClosing:
        'Jetzt mach die Augen zu. Morgen kommt der Ruf, und du weißt, was er sagt. Gute Nacht.',
    spreads: [
      [
        'Zayn spielte Ball, als er es hörte.',
        'Eine Stimme vom Minarett, hoch und klar.',
      ],
      [
        'Allahu Akbar! Allah ist der Größte.',
        'Das ist der Adhan, der Ruf zum Gebet.',
      ],
      [
        'Vor langer Zeit, in Medina, wählte der Prophet ﷺ einen Mann mit einer schönen Stimme.',
        'Sein Name war Bilal.',
      ],
      [
        'Bilal stieg hoch hinauf und rief: Allahu Akbar!',
        'Und die Menschen kamen zum Gebet.',
      ],
      [
        'Der Adhan sagt: Es gibt keinen Gott außer Allah.',
        'Muhammad ist Sein Gesandter. Kommt zum Gebet.',
      ],
      [
        'Kommt zum Erfolg!',
        'Allah ist der Größte. Es gibt keinen Gott außer Allah.',
      ],
      [
        'Wenn du den Adhan hörst, halt an und hör zu.',
        'Sprich die Worte leise nach.',
      ],
      [
        'Dann geh. Zayn ließ seinen Ball liegen und ging zur Moschee.',
        'Kommt zum Gebet.',
      ],
      [
        'Fünfmal am Tag, auf der ganzen Welt, geht der Ruf hinaus.',
        'Und auf der ganzen Welt kommen die Menschen.',
      ],
      [
        'Wenn du ihn das nächste Mal hörst: halt an, hör zu und geh.',
        'Kommt zum Gebet. Lernen wir, wie.',
      ],
    ],
  ),
  spreads: const [
    KidsBookSpread([
      'Zayn was playing ball when he heard it.',
      'A voice from the minaret, high and clear.',
    ], illustrationAsset: '$_scenes/steps_adhan_kids_listen.webp'),
    KidsBookSpread(
      [
        'Allahu Akbar! Allah is the greatest.',
        'This is the adhan, the call to prayer.',
      ],
      illustrationAsset: '$_scenes/steps_adhan_minaret.webp',
      arabicLine: 'ٱللَّٰهُ أَكْبَرُ',
    ),
    KidsBookSpread([
      'Long ago, in Madinah, the Prophet ﷺ chose a man with a beautiful voice.',
      'His name was Bilal.',
    ], illustrationAsset: '$_scenes/steps_adhan_minaret.webp'),
    KidsBookSpread([
      'Bilal climbed up high and called: Allahu Akbar!',
      'And the people came to prayer.',
    ], illustrationAsset: '$_scenes/steps_adhan_minaret.webp'),
    KidsBookSpread(
      [
        'The adhan says: there is no god but Allah.',
        'Muhammad is His Messenger. Come to prayer.',
      ],
      illustrationAsset: '$_scenes/steps_adhan_kids_listen.webp',
      isRefrain: true,
    ),
    KidsBookSpread([
      'Come to success!',
      'Allah is the greatest. There is no god but Allah.',
    ], atlasScene: KidsBookAtlasScene.masjid),
    KidsBookSpread([
      'When you hear the adhan, stop and listen.',
      'Say the words after the caller, quietly.',
    ], illustrationAsset: '$_scenes/steps_adhan_kids_listen.webp'),
    KidsBookSpread(
      [
        'Then go. Zayn left his ball and went to the masjid.',
        'Come to prayer.',
      ],
      illustrationAsset: '$_scenes/steps_adhan_walk.webp',
      isRefrain: true,
      quranRef: QuranQuoteRef(surah: 62, ayah: 9),
    ),
    KidsBookSpread([
      'Five times a day, all over the world, the call goes out.',
      'And all over the world, people come.',
    ], atlasScene: KidsBookAtlasScene.masjid),
    KidsBookSpread(
      [
        'Next time you hear it, stop, listen, and go.',
        'Come to prayer. Let\'s learn how.',
      ],
      illustrationAsset: '$_scenes/steps_adhan_walk.webp',
      isRefrain: true,
      tryItRoute: '/learn/salah',
    ),
  ],
);
