import '../../dua/data/dua_seed_data.dart';
import '../../dua/domain/dua_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../domain/learning_journey_lesson_models.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';
import 'learning_journey_registry.dart';
import 'learning_journey_localized_lesson_content.dart';

class LearningJourneyLessonContentRegistry {
  static final Map<String, LearningJourneyLessonContent> _lessons =
      <String, LearningJourneyLessonContent>{
        ..._quranPathLessons,
        ..._seerahLessons,
        ..._dhikrLessons,
        ..._aqeedahLessons,
        ..._fiqhLessons,
        ..._timelineLessons,
        ..._tajweedLessons,
        ..._dailyWisdomLessons,
        ..._storiesSignsLessons,
        ..._duaLessons,
      };

  static LearningJourneyLessonContent? lessonForStage(
    String stageId,
    AppLocalizations l10n, {
    LearningAgeGroup ageGroup = LearningAgeGroup.adults,
  }) {
    final lesson =
        LearningJourneyLocalizedLessonContentRegistry.lessonForStage(
          stageId,
          l10n,
        ) ??
        _lessons[stageId];
    if (lesson == null) return null;
    return _adaptLessonForAgeGroup(
      lesson,
      stageId: stageId,
      l10n: l10n,
      ageGroup: ageGroup,
    );
  }
}

LearningJourneyLessonContent _adaptLessonForAgeGroup(
  LearningJourneyLessonContent lesson, {
  required String stageId,
  required AppLocalizations l10n,
  required LearningAgeGroup ageGroup,
}) {
  if (ageGroup == LearningAgeGroup.adults) return lesson;
  final journeyId = LearningJourneyRegistry.stageById(stageId)?.journeyId;
  if (journeyId == null) return lesson;
  const supportedJourneys = <String>{
    'prophets-journey',
    'salah-foundations',
    'duas-daily-life',
    'daily-dhikr',
    'beautiful-character',
    'stories-signs',
  };
  if (!supportedJourneys.contains(journeyId)) return lesson;

  final trimmedSections = ageGroup == LearningAgeGroup.kids
      ? lesson.sections.take(1).toList(growable: false)
      : lesson.sections.take(2).toList(growable: false);
  final trimmedTakeaways = ageGroup == LearningAgeGroup.kids
      ? lesson.keyTakeaways.take(2).toList(growable: false)
      : lesson.keyTakeaways.take(3).toList(growable: false);

  return LearningJourneyLessonContent(
    stageId: lesson.stageId,
    title: lesson.title,
    introduction: ageGroup == LearningAgeGroup.kids
        ? l10n.learningAgeKidsLessonIntro(lesson.title)
        : l10n.learningAgeTeensLessonIntro(lesson.title),
    sections: trimmedSections,
    keyTakeaways: trimmedTakeaways,
    reflectionPrompt: lesson.reflectionPrompt,
    quranReferences: lesson.quranReferences,
    sourceReferences: lesson.sourceReferences,
    invocations: lesson.invocations,
    relatedTools: lesson.relatedTools,
    continueJourneyIds: lesson.continueJourneyIds,
    relatedJourneyIds: lesson.relatedJourneyIds,
    actionStep: ageGroup == LearningAgeGroup.kids
        ? l10n.learningAgeKidsActionStep
        : l10n.learningAgeTeensActionStep,
    reviewSuggestion: ageGroup == LearningAgeGroup.kids
        ? l10n.learningAgeKidsReviewSuggestion
        : l10n.learningAgeTeensReviewSuggestion,
    showDhikrCounterAction: lesson.showDhikrCounterAction,
  );
}

final Map<String, LearningJourneyLessonContent>
_seerahLessons = <String, LearningJourneyLessonContent>{
  'seerah-early-life': _lesson(
    stageId: 'seerah-early-life',
    title: 'Early Life of the Prophet ﷺ',
    introduction:
        'The Prophet Muhammad ﷺ was born in Makkah and grew up under Allah’s care through hardship, honesty, and trust.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'He ﷺ was born into the tribe of Quraysh, lost his father before birth, lost his mother in childhood, and was then cared for by his grandfather and uncle. Even before revelation, people in Makkah knew him for truthfulness and trustworthiness.',
      ),
      _section(
        title: 'Why this stage matters',
        body:
            'The early Seerah shows that Allah prepared His Messenger ﷺ through patience, dignity, and moral excellence before public prophethood.',
      ),
    ],
    keyTakeaways: const [
      'Hardship does not prevent Allah from honoring a person.',
      'Truthfulness and trust build a life that invites people to listen.',
      'Preparation often begins long before a public mission starts.',
    ],
    reflectionPrompt:
        'Which quality of the Prophet’s early life would strengthen your own character right now?',
    quranReferences: const ['Qur’an 93:6-8'],
    sourceReferences: const ['Trusted Seerah reports on the Makkan period'],
    relatedTools: const [_lessonProphetsTool, _lessonHadithHubTool],
  ),
  'seerah-first-revelation': _lesson(
    stageId: 'seerah-first-revelation',
    title: 'First Revelation',
    introduction:
        'The first revelation began in the cave of Hira and opened the mission of prophethood with a call to read in the name of Allah.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'The Prophet ﷺ used to seek quiet reflection in Hira. Jibril then came with the first revelation: "Read in the name of your Lord." The moment was weighty and life-changing, and it marked the beginning of revelation for all humanity.',
      ),
      _section(
        title: 'What changed',
        body:
            'From that point onward, the Prophet ﷺ carried revelation, taught tawheed, and called people with patience and certainty.',
      ),
    ],
    keyTakeaways: const [
      'Revelation began with knowledge, reading, and the Lordship of Allah.',
      'Major responsibilities can begin with fear and still become mercy.',
      'The Qur’an entered human history gradually and purposefully.',
    ],
    reflectionPrompt:
        'How would your learning change if you treated knowledge as an act done in the name of Allah?',
    quranReferences: const ['Qur’an 96:1-5'],
    sourceReferences: const ['Sahih al-Bukhari, Beginning of Revelation'],
    relatedTools: const [_lessonQuranReaderTool, _lessonHadithHubTool],
  ),
  'seerah-makkah-period': _lesson(
    stageId: 'seerah-makkah-period',
    title: 'Makkah Period',
    introduction:
        'The Makkan years were years of tawheed, patience, sacrifice, and steady calling under pressure.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'The Prophet ﷺ called people to worship Allah alone while facing mockery, pressure, and persecution. The early believers learned patience, sincerity, and loyalty in a difficult environment.',
      ),
      _section(
        title: 'What was being built',
        body:
            'Makkah built belief first: who Allah is, the reality of the Hereafter, and the seriousness of worship and truth.',
      ),
    ],
    keyTakeaways: const [
      'Strong belief is built before public strength arrives.',
      'Patience in truth is part of prophetic work.',
      'The Qur’an shaped hearts before society was reshaped.',
    ],
    reflectionPrompt:
        'When belief is tested, what helps you remain gentle and steady rather than reactive?',
    quranReferences: const ['Qur’an 74:1-7', 'Qur’an 73:1-10'],
    relatedTools: const [_lessonQuranReaderTool, _lessonProphetsTool],
  ),
  'seerah-hijrah': _lesson(
    stageId: 'seerah-hijrah',
    title: 'Hijrah',
    introduction:
        'Hijrah was not escape for comfort. It was a move for worship, safety, and the future of the Muslim community.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'When the hostility of Makkah reached a severe level, the Prophet ﷺ and the believers migrated to Madinah. The journey required planning, trust, secrecy, and complete reliance on Allah.',
      ),
      _section(
        title: 'A lesson in tawakkul',
        body:
            'Hijrah teaches that trust in Allah includes both deep faith and careful preparation.',
      ),
    ],
    keyTakeaways: const [
      'Tawakkul is trust plus responsible action.',
      'Sometimes leaving for Allah is part of faithfulness.',
      'Big transitions can become openings of mercy and stability.',
    ],
    reflectionPrompt:
        'What would it look like to combine planning and trust in one important decision in your life?',
    quranReferences: const ['Qur’an 9:40'],
    relatedTools: const [_lessonProphetsTool, _lessonLegacyLearnTool],
  ),
  'seerah-madinah-society': _lesson(
    stageId: 'seerah-madinah-society',
    title: 'Madinah Society',
    introduction:
        'In Madinah, the Prophet ﷺ did not only teach individuals. He helped form a community built on worship, justice, brotherhood, and responsibility.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'The Madinan period included the masjid, brotherhood between believers, agreements, teaching, family life, and leadership during both peace and conflict. Islam became a lived society, not only a private belief.',
      ),
      _section(
        title: 'What was established',
        body:
            'Community life in Islam joins worship, ethics, learning, and public responsibility.',
      ),
    ],
    keyTakeaways: const [
      'Islam builds people and community together.',
      'The masjid is a center of worship, learning, and service.',
      'Brotherhood and justice are part of faith, not optional extras.',
    ],
    reflectionPrompt:
        'How can your worship become more connected to service, relationships, and community life?',
    quranReferences: const ['Qur’an 49:10', 'Qur’an 3:103'],
    relatedTools: const [_lessonHadithHubTool, _lessonLegacyLearnTool],
  ),
  'seerah-leadership-character': _lesson(
    stageId: 'seerah-leadership-character',
    title: 'Leadership & Character',
    introduction:
        'The Prophet ﷺ led through mercy, truth, patience, courage, and concern for people.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'His leadership was never separated from character. He listened, forgave, consulted, showed courage when needed, and remained gentle with people while remaining firm on truth.',
      ),
      _section(
        title: 'What makes this leadership prophetic',
        body:
            'His leadership was an act of worship and mercy, not self-promotion.',
      ),
    ],
    keyTakeaways: const [
      'Mercy makes leadership stronger, not weaker.',
      'Character is part of da‘wah and trust-building.',
      'Consultation and patience are prophetic leadership habits.',
    ],
    reflectionPrompt:
        'Which prophetic quality would most improve the way you influence family, friends, or colleagues?',
    quranReferences: const ['Qur’an 3:159', 'Qur’an 33:21'],
    relatedTools: const [_lessonHadithHubTool, _lessonProphetsTool],
  ),
  'seerah-final-sermon': _lesson(
    stageId: 'seerah-final-sermon',
    title: 'Final Sermon',
    introduction:
        'The Farewell Sermon gathered major principles of dignity, justice, trust, and faithfulness near the end of the Prophet’s mission.',
    sections: [
      _section(
        title: 'Short narrative',
        body:
            'Near the end of his life, the Prophet ﷺ addressed the believers and emphasized the sanctity of life, wealth, and honor, the rights people owe one another, and holding firmly to divine guidance.',
      ),
      _section(
        title: 'A closing frame for the journey',
        body:
            'The Seerah ends with a complete message: worship Allah, honor people, and remain faithful to revelation.',
      ),
    ],
    keyTakeaways: const [
      'Human dignity and trust are sacred in Islam.',
      'The Prophetic mission joined worship with justice and responsibility.',
      'A believer holds firmly to revelation even after the Messenger ﷺ has passed on.',
    ],
    reflectionPrompt:
        'Which principle from the Prophet’s final public guidance feels most urgent for our time?',
    quranReferences: const ['Qur’an 5:3'],
    relatedTools: const [_lessonHadithHubTool, _lessonQuranReaderTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_dhikrLessons = <String, LearningJourneyLessonContent>{
  'dhikr-what-is': _lesson(
    stageId: 'dhikr-what-is',
    title: 'What Is Dhikr?',
    introduction:
        'Dhikr means remembering Allah with the heart, tongue, and life. It includes praise, gratitude, seeking forgiveness, and turning back to Him often.',
    sections: [
      _section(
        title: 'Simple explanation',
        body:
            'Dhikr is not only repetition. It is a way of keeping Allah present in your awareness through words that are true, humble, and full of meaning.',
      ),
      _section(
        title: 'How beginners should think about it',
        body:
            'Start with a few short remembrances that you understand and can repeat consistently. Small regular dhikr is better than heavy bursts that disappear.',
      ),
    ],
    keyTakeaways: const [
      'Dhikr softens the heart and keeps it connected to Allah.',
      'Short, regular remembrance is better than overload.',
      'Understanding the meaning helps dhikr become sincere and steady.',
    ],
    reflectionPrompt:
        'Which moment of your day would be easiest to turn into a steady dhikr habit?',
    quranReferences: const ['Qur’an 13:28', 'Qur’an 33:41'],
    sourceReferences: const ['Sahih Muslim, Book of Dhikr'],
    showDhikrCounterAction: true,
  ),
  'dhikr-morning-adhkar': _lesson(
    stageId: 'dhikr-morning-adhkar',
    title: 'Morning Adhkar',
    introduction:
        'Morning adhkar help you begin the day with dependence on Allah, gratitude, and spiritual protection.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Read your morning adhkar after Fajr or in the early part of the day. Keep the set small at first and be faithful to it.',
      ),
      _section(
        title: 'How to begin',
        body:
            'Start with one or two remembrances you can keep daily. Consistency matters more than trying to recite everything at once.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Morning opening remembrance',
        arabic:
            'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        transliteration:
            'Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur',
        meaning:
            'O Allah, by You we enter the morning, by You we enter the evening, by You we live, by You we die, and to You is the resurrection.',
        context: 'Read in the morning to begin the day with trust in Allah.',
        sourceReference: 'Sunan Abi Dawud and Jami at-Tirmidhi',
      ),
    ],
    keyTakeaways: const [
      'Morning adhkar frame the day around Allah rather than distraction.',
      'A short protected routine is better than an abandoned long list.',
      'Begin with one authentic dhikr and keep it steady.',
    ],
    reflectionPrompt:
        'What would change in your mornings if your first spiritual act was remembrance instead of hurry?',
    sourceReferences: const ['Sunan Abi Dawud and Jami at-Tirmidhi'],
    showDhikrCounterAction: true,
  ),
  'dhikr-evening-adhkar': _lesson(
    stageId: 'dhikr-evening-adhkar',
    title: 'Evening Adhkar',
    introduction:
        'Evening adhkar close the day with reliance on Allah, gratitude, and calm before night.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Read your evening adhkar after Asr or around sunset. Keep the habit gentle and repeatable.',
      ),
      _section(
        title: 'Why it helps',
        body:
            'Evening remembrance helps the heart leave the noise of the day and return to Allah before sleep.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Evening opening remembrance',
        arabic:
            'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
        transliteration:
            'Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilaykal-masir',
        meaning:
            'O Allah, by You we enter the evening, by You we enter the morning, by You we live, by You we die, and to You is the final return.',
        context: 'Read in the evening to close the day with remembrance.',
        sourceReference: 'Sunan Abi Dawud and Jami at-Tirmidhi',
      ),
    ],
    keyTakeaways: const [
      'Evening adhkar help the heart settle before night.',
      'Ending the day with dhikr is a form of spiritual protection.',
      'A short evening habit can be built gradually without pressure.',
    ],
    reflectionPrompt:
        'What often fills the end of your day, and how can remembrance reclaim a small part of it?',
    sourceReferences: const ['Sunan Abi Dawud and Jami at-Tirmidhi'],
    showDhikrCounterAction: true,
  ),
  'dhikr-after-salah': _lesson(
    stageId: 'dhikr-after-salah',
    title: 'After Salah Dhikr',
    introduction:
        'After each prayer, a simple set of adhkar helps protect the prayer and extend its effect into the rest of the day.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Read this after the salam. Keep it calm and attentive rather than rushed.',
      ),
      _section(
        title: 'Why this habit is powerful',
        body:
            'Because salah already gathers the heart, post-prayer dhikr is one of the easiest daily places to build consistency.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Post-prayer glorification',
        arabic:
            'سُبْحَانَ اللَّهِ ٣٣ • الْحَمْدُ لِلَّهِ ٣٣ • اللَّهُ أَكْبَرُ ٣٤',
        transliteration: 'Subhanallah 33, Alhamdulillah 33, Allahu Akbar 34',
        meaning:
            'Glory be to Allah, praise be to Allah, Allah is the Greatest.',
        context: 'A simple dhikr set read after salah.',
        sourceReference: 'Sahih Muslim',
      ),
    ],
    keyTakeaways: const [
      'After-salah dhikr is one of the easiest places to anchor remembrance.',
      'Short formulas can carry deep meaning when done with attention.',
      'Regular post-prayer dhikr strengthens spiritual rhythm across the day.',
    ],
    reflectionPrompt:
        'Which prayer is the easiest place for you to begin a stable after-salah dhikr habit?',
    sourceReferences: const ['Sahih Muslim'],
    relatedTools: const [_lessonSalahHubTool],
    showDhikrCounterAction: true,
  ),
  'dhikr-simple-routine': _lesson(
    stageId: 'dhikr-simple-routine',
    title: 'Simple Daily Routine',
    introduction:
        'A beginner dhikr routine should be small, clear, and sustainable.',
    sections: [
      _section(
        title: 'A workable beginner routine',
        body:
            'Choose three anchor moments: morning, after one prayer, and before sleep. Attach one short remembrance to each moment and keep it for a week before adding more.',
        bullets: [
          'Morning: one authentic morning dhikr',
          'After salah: 33/33/34 after one prayer',
          'Before sleep: one short nightly remembrance',
        ],
      ),
      _section(
        title: 'What to avoid',
        body:
            'Do not begin with a routine so large that it disappears after a few days. Stability matters more than quantity at the start.',
      ),
    ],
    keyTakeaways: const [
      'Tie dhikr to moments that already exist in your day.',
      'Build slowly enough that the habit survives real life.',
      'Consistency grows from clarity, not from pressure.',
    ],
    reflectionPrompt:
        'Which three daily moments could become your personal remembrance anchors this week?',
    quranReferences: const ['Qur’an 2:152'],
    showDhikrCounterAction: true,
  ),
  'dhikr-istighfar': _lesson(
    stageId: 'dhikr-istighfar',
    title: 'Istighfar',
    introduction:
        'Istighfar is seeking Allah’s forgiveness with humility, honesty, and hope.',
    sections: [
      _section(
        title: 'Simple explanation',
        body:
            'A believer returns often to Allah, not only after a major mistake. Istighfar cleans the heart, softens pride, and keeps the servant close to mercy.',
      ),
      _section(
        title: 'When to use',
        body:
            'Use istighfar after a sin, after heedlessness, after prayer, or whenever you feel dryness and need to return to Allah.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Simple istighfar',
        arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
        transliteration: 'Astaghfirullaha wa atubu ilayh',
        meaning: 'I seek Allah’s forgiveness and I turn to Him in repentance.',
        context: 'A short daily formula of repentance and return.',
        sourceReference: 'Sahih al-Bukhari and Sahih Muslim',
      ),
    ],
    keyTakeaways: const [
      'Istighfar is a daily need, not only an emergency act.',
      'Repentance combines honesty about mistakes with hope in mercy.',
      'Short sincere istighfar is better than empty repetition.',
    ],
    reflectionPrompt:
        'What would change if repentance became one of your daily habits instead of a rare response?',
    quranReferences: const ['Qur’an 11:3', 'Qur’an 71:10-12'],
    sourceReferences: const ['Sahih al-Bukhari and Sahih Muslim'],
    showDhikrCounterAction: true,
  ),
  'dhikr-salawat': _lesson(
    stageId: 'dhikr-salawat',
    title: 'Salawat',
    introduction:
        'Sending prayers upon the Prophet ﷺ is an act of love, gratitude, and obedience to Allah.',
    sections: [
      _section(
        title: 'Simple explanation',
        body:
            'Salawat keeps the heart connected to the Messenger ﷺ and reminds you that your path to Allah is shaped by following him with love and respect.',
      ),
      _section(
        title: 'When to use',
        body:
            'Use salawat daily, on Fridays, after hearing the Prophet’s name ﷺ, and whenever you want to renew love and connection.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Short salawat',
        arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
        transliteration: 'Allahumma salli ala Muhammad',
        meaning: 'O Allah, send prayers upon Muhammad.',
        context: 'A short form for daily remembrance and frequent salawat.',
        sourceReference: 'Qur’an 33:56; Sahih al-Bukhari and Sahih Muslim',
      ),
    ],
    keyTakeaways: const [
      'Salawat grows love for the Prophet ﷺ in daily life.',
      'A short form used often is better than a long form rarely used.',
      'This remembrance connects worship to gratitude for guidance.',
    ],
    reflectionPrompt:
        'How can you make salawat part of your day in a way that feels sincere and frequent?',
    quranReferences: const ['Qur’an 33:56'],
    sourceReferences: const ['Sahih al-Bukhari and Sahih Muslim'],
    showDhikrCounterAction: true,
  ),
};

final Map<String, LearningJourneyLessonContent>
_aqeedahLessons = <String, LearningJourneyLessonContent>{
  'faith-who-is-allah': _lesson(
    stageId: 'faith-who-is-allah',
    title: 'Who Is Allah?',
    introduction:
        'Allah is the Creator, Sustainer, and Lord of everything. He is perfect, unlike His creation, and every heart is in need of Him.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'Allah made you, sustains you, hears you, sees you, and knows you completely. He is not part of creation and nothing is equal to Him.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'When you need help, hope, forgiveness, guidance, or provision, your heart naturally seeks the One who truly controls all things.',
      ),
    ],
    keyTakeaways: const [
      'Allah is the Lord and Creator of everything.',
      'He is perfect and nothing resembles Him.',
      'Knowing Allah changes how you worship, trust, and repent.',
    ],
    reflectionPrompt:
        'When you make dua, how often do you pause to remember who you are actually turning to?',
    quranReferences: const ['Qur’an 112:1-4', 'Qur’an 2:255'],
  ),
  'faith-tawheed': _lesson(
    stageId: 'faith-tawheed',
    title: 'Tawheed',
    introduction:
        'Tawheed means singling out Allah alone in worship, dependence, hope, fear, and ultimate love.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'A Muslim prays to Allah alone, asks Him alone for ultimate help, and worships Him without partners.',
      ),
      _section(
        title: 'A common misunderstanding',
        body:
            'Tawheed is not only saying that Allah exists. It means living in a way that directs worship and reliance to Him alone.',
      ),
    ],
    keyTakeaways: const [
      'Tawheed is the center of Islam.',
      'Belief in one Lord must appear in worship and dua.',
      'A clean heart turns to Allah before anything else.',
    ],
    reflectionPrompt:
        'Where in your life do you most need to strengthen reliance on Allah alone?',
    quranReferences: const ['Qur’an 1:5', 'Qur’an 51:56'],
  ),
  'faith-names-of-allah-intro': _lesson(
    stageId: 'faith-names-of-allah-intro',
    title: 'Names of Allah',
    introduction:
        'Allah has beautiful names that help the believer know Him with reverence, hope, and love.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'The names of Allah teach you who He is. When you learn that He is Ar-Rahman, Al-Ghafur, and Al-Hakeem, your worship becomes more personal and more trusting.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'When you seek forgiveness, remember Allah is Al-Ghafur. When you feel weak, remember He is Al-Qawiyy. When life confuses you, remember He is Al-Hakeem.',
      ),
    ],
    keyTakeaways: const [
      'Allah’s names deepen worship and dua.',
      'Each name teaches a true quality of Allah.',
      'Learning the names should increase humility and trust, not speculation.',
    ],
    reflectionPrompt:
        'Which name of Allah do you most need to live with more consciously right now?',
    quranReferences: const ['Qur’an 7:180', 'Qur’an 59:22-24'],
    relatedTools: const [_lessonNamesOfAllahTool],
  ),
  'faith-angels': _lesson(
    stageId: 'faith-angels',
    title: 'Angels',
    introduction:
        'Angels are honored servants of Allah who obey Him completely and carry out the tasks He gives them.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'Muslims believe in the angels even though we do not see them. They are part of the unseen world and they never disobey Allah.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'Remembering the angels helps a believer take worship, speech, and accountability more seriously.',
      ),
    ],
    keyTakeaways: const [
      'Belief includes both the seen and the unseen.',
      'Angels obey Allah fully and faithfully.',
      'Belief in angels grows reverence and accountability.',
    ],
    reflectionPrompt:
        'How would your daily choices change if your sense of the unseen became more alive?',
    quranReferences: const ['Qur’an 2:285', 'Qur’an 35:1'],
  ),
  'faith-books': _lesson(
    stageId: 'faith-books',
    title: 'Books',
    introduction:
        'Allah sent revelation for guidance, mercy, and truth. Muslims believe in the revealed books and hold the Qur’an as the final preserved revelation.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'Allah did not leave people without guidance. He sent scriptures and messages to teach truth, worship, and right living.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'The Qur’an becomes more meaningful when you see it as part of the long chain of revelation sent by Allah to guide humanity.',
      ),
    ],
    keyTakeaways: const [
      'Revelation is a mercy from Allah.',
      'The Qur’an confirms truth and serves as the final guidance.',
      'Belief in the books deepens gratitude for the Qur’an.',
    ],
    reflectionPrompt:
        'How would you treat the Qur’an differently if you saw it as Allah’s direct guidance to you?',
    quranReferences: const ['Qur’an 2:2', 'Qur’an 4:136'],
    relatedTools: const [_lessonQuranReaderTool],
  ),
  'faith-prophets': _lesson(
    stageId: 'faith-prophets',
    title: 'Prophets',
    introduction:
        'Allah sent prophets to teach truth, model obedience, and call people back to worshipping Him alone.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'Prophets are the best of people, chosen by Allah to deliver His message. They teach by both words and example.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'When you read about patience in Nuh, trust in Ibrahim, or mercy in Muhammad ﷺ, belief becomes easier to live and imitate.',
      ),
    ],
    keyTakeaways: const [
      'Prophets carry revelation and model obedience.',
      'Their stories teach faith through real human examples.',
      'Love and respect for the Prophets is part of faith.',
    ],
    reflectionPrompt:
        'Which prophetic quality feels most necessary for your own growth right now?',
    quranReferences: const ['Qur’an 4:165', 'Qur’an 33:21'],
    relatedTools: const [_lessonProphetsTool],
  ),
  'faith-day-of-judgment': _lesson(
    stageId: 'faith-day-of-judgment',
    title: 'Day of Judgment',
    introduction:
        'Muslims believe that life has an end, people will be raised, and every soul will stand before Allah.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'The Day of Judgment means life is meaningful, deeds matter, and justice belongs fully to Allah even when the world feels unfair.',
      ),
      _section(
        title: 'Real-life example',
        body:
            'Belief in the Hereafter helps a believer choose honesty, patience, and repentance even when no one else is watching.',
      ),
    ],
    keyTakeaways: const [
      'The Hereafter gives moral seriousness to daily life.',
      'Allah’s judgment is perfect and completely just.',
      'Remembering the Last Day encourages repentance and responsibility.',
    ],
    reflectionPrompt:
        'What daily habit would change if you kept the meeting with Allah more present in your mind?',
    quranReferences: const ['Qur’an 99:6-8', 'Qur’an 101:6-11'],
  ),
  'faith-qadr': _lesson(
    stageId: 'faith-qadr',
    title: 'Qadr',
    introduction:
        'Qadr means Allah knows, writes, and wills all things with perfect wisdom, while people still make real choices and remain responsible.',
    sections: [
      _section(
        title: 'Very simple explanation',
        body:
            'Nothing escapes Allah’s knowledge or power. At the same time, you are still commanded to choose obedience, make effort, and repent when you fall short.',
      ),
      _section(
        title: 'A common misunderstanding',
        body:
            'Qadr is not an excuse for laziness or sin. A believer trusts Allah’s decree while still acting responsibly and asking for help.',
      ),
    ],
    keyTakeaways: const [
      'Allah’s decree is wise, even when you do not understand it.',
      'Trust in qadr brings patience and calm without removing effort.',
      'Belief in qadr should increase tawakkul, not passivity.',
    ],
    reflectionPrompt:
        'Where do you most need trust in Allah’s decree while still doing your part well?',
    quranReferences: const ['Qur’an 57:22-23', 'Qur’an 54:49'],
  ),
};

final Map<String, LearningJourneyLessonContent>
_duaLessons = <String, LearningJourneyLessonContent>{
  'duas-waking-up': _lesson(
    stageId: 'duas-waking-up',
    title: 'Waking Up',
    introduction:
        'Start the day by acknowledging that life, waking, and return all belong to Allah.',
    sections: [
      _section(
        title: 'When to use',
        body: 'Say this as one of your first remembrances after waking.',
      ),
    ],
    invocations: [_duaFromSeed('sunnah_upon_waking')],
    keyTakeaways: const [
      'The first words of the day can begin with gratitude.',
      'Waking up is a daily reminder of Allah’s power over life and death.',
    ],
    reflectionPrompt:
        'How would your mornings change if your first conscious act was gratitude to Allah?',
    sourceReferences: const ['Sahih al-Bukhari 6312'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-sleeping': _lesson(
    stageId: 'duas-sleeping',
    title: 'Sleeping',
    introduction:
        'Before sleep, a short dua places your rest and your life in the care of Allah.',
    sections: [
      _section(
        title: 'When to use',
        body: 'Say this when you lie down to sleep at night.',
      ),
    ],
    invocations: [_duaFromSeed('sunnah_before_sleep')],
    keyTakeaways: const [
      'Nightly duas train the heart to end the day with trust.',
      'A very short dua can still build a powerful habit.',
    ],
    reflectionPrompt:
        'What would it mean to surrender the end of your day to Allah more consciously?',
    sourceReferences: const ['Sahih al-Bukhari 6324'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-eating': _lesson(
    stageId: 'duas-eating',
    title: 'Eating',
    introduction:
        'Food becomes an act of gratitude when it begins with the name of Allah.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Say Bismillah before eating or drinking. If you forgot, use the second dua as soon as you remember.',
      ),
    ],
    invocations: [
      _duaFromSeed('sunnah_before_eating_bismillah'),
      _duaFromSeed('sunnah_if_forgot_bismillah'),
    ],
    keyTakeaways: const [
      'Everyday acts become worship when connected to Allah.',
      'Islam makes gratitude practical and repeatable.',
    ],
    reflectionPrompt:
        'Which ordinary habit in your day could become more worshipful with a simple remembered phrase?',
    sourceReferences: const ['Sunan Abi Dawud 3767'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-leaving-home': _lesson(
    stageId: 'duas-leaving-home',
    title: 'Leaving Home',
    introduction:
        'When you step outside, begin with Allah’s name and trust, not self-reliance.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Say this when you leave your home for school, work, errands, or travel.',
      ),
    ],
    invocations: [_duaFromSeed('sunnah_leaving_home')],
    keyTakeaways: const [
      'Daily movement is safer when tied to tawakkul.',
      'The believer begins outward action with inward trust.',
    ],
    reflectionPrompt:
        'How often do you begin your daily responsibilities with reliance on Allah instead of on your own strength alone?',
    sourceReferences: const ['Jami at-Tirmidhi 3426'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-entering-masjid': _lesson(
    stageId: 'duas-entering-masjid',
    title: 'Entering Masjid',
    introduction:
        'The masjid is entered with humility and a request for Allah’s mercy.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Say this when entering the masjid and prepare your heart for worship.',
      ),
    ],
    invocations: [_duaFromSeed('sunnah_entering_mosque')],
    keyTakeaways: const [
      'Masjid manners begin before prayer itself starts.',
      'This short dua reminds the heart that mercy is sought, not assumed.',
    ],
    reflectionPrompt:
        'What would entering the masjid feel like if you slowed down enough to ask consciously for Allah’s mercy?',
    sourceReferences: const ['Sahih Muslim 713a'],
    relatedTools: const [_lessonSalahHubTool, _lessonDuaHubTool],
  ),
  'duas-travel': _lesson(
    stageId: 'duas-travel',
    title: 'Travel',
    introduction:
        'Travel is one of the clearest moments to remember dependence on Allah and the certainty of return to Him.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Use this remembrance when setting out in a vehicle or beginning a journey.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Travel remembrance',
        arabic:
            'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ • وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
        transliteration:
            'Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin. Wa inna ila rabbina lamunqalibun',
        meaning:
            'Glory be to the One who subjected this for us, though we could not have controlled it by ourselves. And surely to our Lord we will return.',
        context: 'Read when setting out on a journey or mounting a ride.',
        sourceReference: 'Qur’an 43:13-14',
      ),
    ],
    keyTakeaways: const [
      'Travel reminds the believer of dependence on Allah.',
      'Even convenience and transport are gifts to be received with humility.',
    ],
    reflectionPrompt:
        'How often do movement and travel make you more mindful of your return to Allah?',
    quranReferences: const ['Qur’an 43:13-14'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-distress': _lesson(
    stageId: 'duas-distress',
    title: 'Distress',
    introduction:
        'In hardship, the believer speaks to Allah with honesty, dependence, and hope in mercy.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Use this dua during illness, emotional heaviness, pain, or any difficult pressure.',
      ),
    ],
    invocations: [_duaFromSeed('quran_021_083_harm_has_touched_me')],
    keyTakeaways: const [
      'Islam teaches truthful dua in hardship, not empty toughness.',
      'Even short duas can carry deep reliance and hope.',
    ],
    reflectionPrompt:
        'When you are under pressure, do you turn first to worry or first to Allah?',
    quranReferences: const ['Qur’an 21:83'],
    relatedTools: const [_lessonDuaHubTool],
  ),
  'duas-gratitude': _lesson(
    stageId: 'duas-gratitude',
    title: 'Gratitude',
    introduction:
        'Gratitude in Islam is not only saying thanks. It is asking Allah to help you use His blessings in a way He loves.',
    sections: [
      _section(
        title: 'When to use',
        body:
            'Use this dua when reflecting on blessings, family, provision, or opportunities to do good.',
      ),
    ],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Dua of gratitude',
        arabic:
            'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَى وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ',
        transliteration:
            'Rabbi awzini an ashkura nimataka allati an amta alayya wa ala walidayya wa an amala salihan tardahu wa adkhilni birahmatika fi ibadikas-salihin',
        meaning:
            'My Lord, inspire me to be thankful for Your favor which You bestowed upon me and upon my parents, and to do righteous deeds that please You, and admit me by Your mercy among Your righteous servants.',
        context:
            'A gratitude dua linked to blessings, parents, and righteous action.',
        sourceReference: 'Qur’an 27:19',
      ),
    ],
    keyTakeaways: const [
      'Gratitude includes righteous action, not only words.',
      'Thankfulness should increase humility and obedience.',
    ],
    reflectionPrompt:
        'Which blessing in your life needs to be answered with more action, not only more acknowledgment?',
    quranReferences: const ['Qur’an 27:19'],
    relatedTools: const [_lessonDuaHubTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_quranPathLessons = <String, LearningJourneyLessonContent>{
  'quran-open': _lesson(
    stageId: 'quran-open',
    title: 'Open the Qur’an',
    introduction:
        'Begin by seeing the Qur’an as a revealed book with structure, themes, and a living place in daily worship.',
    sections: [
      _section(
        title: 'How the Qur’an is arranged',
        body:
            'The Qur’an is organized into surahs and ayat. Some surahs are long, some are short, and each one invites steady reading rather than rushed coverage.',
        bullets: [
          'Start by recognizing surah names and numbers.',
          'Notice that the opening surah, Al-Fatihah, is short but central.',
          'Use simple navigation first before trying advanced tools.',
        ],
      ),
      _section(
        title: 'How to begin well',
        body:
            'A beginner does not need to master everything at once. Open the reader, follow a short passage, and return consistently with humility.',
      ),
    ],
    keyTakeaways: const [
      'The Qur’an is meant to be approached with steadiness and reverence.',
      'Navigation is a skill that makes later study easier.',
      'A small regular opening is better than irregular overload.',
    ],
    reflectionPrompt:
        'What would make your first regular meeting with the Qur’an feel sustainable this week?',
    quranReferences: const ['Qur’an 15:9', 'Qur’an 73:4'],
    relatedTools: const [
      _lessonQuranReaderTool,
      _lessonQuranSearchTool,
      _lessonQuranNotesTool,
    ],
  ),
  'quran-read': _lesson(
    stageId: 'quran-read',
    title: 'Read from the beginning',
    introduction:
        'Starting with Al-Fatihah grounds your reading in the surah you already recite in salah.',
    sections: [
      _section(
        title: 'Why begin here',
        body:
            'Al-Fatihah gathers praise, dependence, worship, and guidance into a short surah. It is the most repeated opening point for new reading.',
      ),
      _section(
        title: 'A simple reading habit',
        body:
            'Read slowly, notice where a verse begins and ends, and let the reading itself become the first goal before deeper analysis.',
        bullets: [
          'Read a small portion with attention.',
          'Return to the same passage if needed.',
          'Use notes or bookmarks only after the reading itself is clear.',
        ],
      ),
    ],
    keyTakeaways: const [
      'Al-Fatihah is both a reading start and a prayer foundation.',
      'Steady reading builds confidence faster than random browsing.',
      'Clarity begins with slow repetition.',
    ],
    reflectionPrompt:
        'How can you make your next short Qur’an reading more attentive than the last one?',
    quranReferences: const ['Qur’an 1:1-7'],
    relatedTools: const [_lessonQuranReaderTool, _lessonQuranNotesTool],
  ),
  'quran-themes': _lesson(
    stageId: 'quran-themes',
    title: 'Explore Qur’anic themes',
    introduction:
        'The Qur’an repeats major themes so hearts remember them: tawheed, mercy, guidance, accountability, and signs.',
    sections: [
      _section(
        title: 'How themes help',
        body:
            'Looking at themes helps you move from isolated verses toward broader understanding without needing a heavy academic approach.',
      ),
      _section(
        title: 'Themes to notice first',
        body:
            'Begin with worship, gratitude, patience, repentance, and signs in creation. These themes appear often and shape daily life.',
      ),
    ],
    keyTakeaways: const [
      'Themes help the Qur’an feel connected rather than fragmented.',
      'Repeated themes train the heart, not only the mind.',
      'Notes and bookmarks become more useful once themes are noticed.',
    ],
    reflectionPrompt:
        'Which Qur’anic theme do you most want to keep noticing this month?',
    quranReferences: const ['Qur’an 2:21', 'Qur’an 39:53'],
    relatedTools: const [
      _lessonQuranSearchTool,
      _lessonQuranNotesTool,
      _lessonQuranBookmarksTool,
    ],
  ),
  'fatihah-read': _lesson(
    stageId: 'fatihah-read',
    title: 'Read Al-Fatihah',
    introduction:
        'Al-Fatihah is the opening of the Qur’an and the opening of your daily salah.',
    sections: [
      _section(
        title: 'What Al-Fatihah contains',
        body:
            'It begins with praise of Allah, moves into worship and dependence, and ends with a sincere request for guidance.',
      ),
      _section(
        title: 'Why every believer should know it well',
        body:
            'Because you recite it constantly, understanding its flow can immediately deepen prayer.',
      ),
    ],
    keyTakeaways: const [
      'Al-Fatihah is central to both recitation and worship.',
      'Its seven ayat hold praise, devotion, and supplication together.',
      'Repeated reading prepares deeper reflection.',
    ],
    reflectionPrompt:
        'Which ayah of Al-Fatihah feels closest to your present need for guidance?',
    quranReferences: const ['Qur’an 1:1-7'],
    relatedTools: const [_lessonQuranReaderTool, _lessonSalahHubTool],
  ),
  'fatihah-recitation': _lesson(
    stageId: 'fatihah-recitation',
    title: 'Recite what you pray',
    introduction:
        'The goal is not only to know Al-Fatihah as text, but to carry it into your salah with attention.',
    sections: [
      _section(
        title: 'From reading to recitation',
        body:
            'Reading lets you see the verses clearly. Recitation asks you to slow down, pronounce carefully, and remember that you are standing before Allah.',
      ),
      _section(
        title: 'Recitation habits that help',
        body:
            'Pause between sections, keep the words dignified, and let the meaning of praise and guidance stay present while you recite.',
      ),
    ],
    keyTakeaways: const [
      'Prayer recitation should be careful, not rushed.',
      'Al-Fatihah becomes stronger through repeated attentive recitation.',
      'Meaning and sound support one another.',
    ],
    reflectionPrompt:
        'What small change would make your recitation of Al-Fatihah calmer in the next prayer?',
    quranReferences: const ['Qur’an 73:4'],
    relatedTools: const [_lessonSalahHubTool, _lessonQuranReaderTool],
  ),
  'fatihah-reflection': _lesson(
    stageId: 'fatihah-reflection',
    title: 'Reflect on its meanings',
    introduction:
        'Al-Fatihah teaches praise, dependence, worship, and the constant need for right guidance.',
    sections: [
      _section(
        title: 'A simplified meaning flow',
        body:
            'You begin by praising Allah as Lord of all worlds, then turn to Him as the Most Merciful, then affirm worship and dependence, and finally ask to be guided on the straight path.',
      ),
      _section(
        title: 'How to reflect without overcomplicating',
        body:
            'Ask what each ayah trains in your heart: gratitude, humility, hope, reliance, and fear of losing guidance.',
      ),
    ],
    keyTakeaways: const [
      'Al-Fatihah teaches both belief and prayer.',
      'Its meanings can be reflected on in simple language.',
      'Daily repetition makes it one of the best places to begin comprehension.',
    ],
    reflectionPrompt:
        'When you next say “Guide us to the straight path,” what guidance are you most in need of?',
    quranReferences: const ['Qur’an 1:1-7'],
    relatedTools: const [_lessonQuranNotesTool, _lessonQuranReaderTool],
  ),
  'short-surahs-explore': _lesson(
    stageId: 'short-surahs-explore',
    title: 'Find the short surahs',
    introduction:
        'Short surahs are a practical bridge between memorization, recitation, and meaning.',
    sections: [
      _section(
        title: 'Why start with them',
        body:
            'They are often recited in prayer, easier to revisit, and ideal for building an early sense of Qur’anic rhythm and themes.',
      ),
      _section(
        title: 'How to use this stage',
        body:
            'Locate the short surahs you already know or hear often, then return to them repeatedly instead of collecting too many at once.',
      ),
    ],
    keyTakeaways: const [
      'Short surahs are a beginner-friendly doorway into regular Qur’an study.',
      'Small surahs are easier to connect with prayer.',
      'Fewer surahs studied well are more useful than many left shallow.',
    ],
    reflectionPrompt:
        'Which short surah do you most want to know with more confidence and love?',
    quranReferences: const [
      'Qur’an 112:1-4',
      'Qur’an 113:1-5',
      'Qur’an 114:1-6',
    ],
    relatedTools: const [_lessonQuranReaderTool, _lessonQuranSearchTool],
  ),
  'short-surahs-prayer': _lesson(
    stageId: 'short-surahs-prayer',
    title: 'Use them in prayer practice',
    introduction:
        'Short surahs become more meaningful when you connect them to real prayer use instead of leaving them as isolated memorized text.',
    sections: [
      _section(
        title: 'How prayer reinforces learning',
        body:
            'When a surah returns in prayer, it moves from memory into worship. You begin to hear its message in the moments you need it most.',
      ),
      _section(
        title: 'A steady practice habit',
        body:
            'Choose one short surah and use it regularly for a few days, then review its meaning and repeated words.',
      ),
    ],
    keyTakeaways: const [
      'Prayer is one of the best places to stabilize short-surah learning.',
      'Repetition inside worship makes meaning easier to remember.',
      'One surah practiced steadily is enough for real growth.',
    ],
    reflectionPrompt:
        'Which short surah would you like to carry more consciously into your next salah?',
    quranReferences: const ['Qur’an 87:1-19'],
    relatedTools: const [_lessonSalahHubTool, _lessonQuranReaderTool],
  ),
  'short-surahs-meaning': _lesson(
    stageId: 'short-surahs-meaning',
    title: 'Understand their meanings',
    introduction:
        'Short surahs often carry concentrated themes: tawheed, protection, gratitude, warning, and hope.',
    sections: [
      _section(
        title: 'A simple way to study meaning',
        body:
            'Look for the main message first. Ask what the surah is calling you to believe, fear, hope for, or seek protection from.',
      ),
      _section(
        title: 'Recurring themes',
        body:
            'You will often meet Allah’s oneness, the Hereafter, gratitude, and the need for refuge in Him.',
      ),
    ],
    keyTakeaways: const [
      'Meaning can begin with one clear theme, not a heavy commentary.',
      'Short surahs repeat foundational truths often needed in daily life.',
      'Reflection after recitation helps memorized text become living guidance.',
    ],
    reflectionPrompt:
        'What theme from a short surah feels most needed in your present routine?',
    quranReferences: const [
      'Qur’an 112:1-4',
      'Qur’an 113:1-5',
      'Qur’an 114:1-6',
    ],
    relatedTools: const [_lessonQuranReaderTool, _lessonLegacyLearnTool],
  ),
  'recite-fatihah': _lesson(
    stageId: 'recite-fatihah',
    title: 'Start with Al-Fatihah and Allahu Akbar',
    introduction:
        'Begin with the opening words of salah: magnifying Allah, then entering Al-Fatihah with attention and trust.',
    sections: [
      _section(
        title: 'Phrase breakdown',
        body:
            'Allahu Akbar means Allah is greater than everything competing for your heart. Al-Fatihah then teaches praise, worship, and asking for guidance.',
      ),
      _section(
        title: 'When these words are used',
        body:
            'Allahu Akbar opens the prayer and marks many of its movements. Al-Fatihah is recited in every unit of salah.',
      ),
    ],
    keyTakeaways: const [
      'Allahu Akbar re-centers the heart before prayer begins.',
      'Al-Fatihah is the daily school of guidance for every Muslim.',
      'Understanding the opening of salah changes the rest of the prayer.',
    ],
    reflectionPrompt:
        'What distraction do you most need to place beneath “Allahu Akbar” before your next prayer?',
    quranReferences: const ['Qur’an 1:1-7'],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Allahu Akbar',
        arabic: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar',
        meaning: 'Allah is greater.',
        context:
            'Said throughout salah, especially at the opening and movement transitions.',
        sourceReference: 'Sahih Muslim',
      ),
    ],
    relatedTools: const [_lessonSalahHubTool, _lessonQuranReaderTool],
  ),
  'recite-short-surahs': _lesson(
    stageId: 'recite-short-surahs',
    title: 'SubhanAllah, Alhamdulillah, and common prayer phrases',
    introduction:
        'Many familiar phrases in prayer and dhikr are short, repeated, and full of meaning.',
    sections: [
      _section(
        title: 'Meaning and use',
        body:
            'SubhanAllah declares Allah free of every imperfection. Alhamdulillah is praise and gratitude. In salah you also hear phrases like Subhana Rabbiyal-Azim and Subhana Rabbiyal-Ala in bowing and prostration.',
      ),
      _section(
        title: 'Why these phrases matter',
        body:
            'They train the tongue and heart to praise Allah, glorify Him, and keep worship from becoming empty repetition.',
      ),
    ],
    keyTakeaways: const [
      'Short phrases can carry deep worship when their meanings are understood.',
      'Glorification and gratitude belong at the center of daily prayer.',
      'Common salah phrases are worth studying one by one.',
    ],
    reflectionPrompt:
        'Which short phrase in your salah do you want to say more consciously this week?',
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'SubhanAllah',
        arabic: 'سُبْحَانَ اللَّهِ',
        transliteration: 'SubhanAllah',
        meaning: 'Glory be to Allah; Allah is far above every imperfection.',
        context: 'Said in general dhikr and reflected in the tasbih of salah.',
        sourceReference: 'Sahih Muslim',
      ),
      LearningJourneyLessonInvocation(
        title: 'Alhamdulillah',
        arabic: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdulillah',
        meaning: 'All praise belongs to Allah.',
        context:
            'Said in gratitude, daily speech, and throughout recitation and dhikr.',
        sourceReference: 'Qur’an 1:2',
      ),
    ],
    relatedTools: const [_lessonSalahHubTool, _lessonQuranReaderTool],
  ),
  'recite-meaning': _lesson(
    stageId: 'recite-meaning',
    title: 'Astaghfirullah, La ilaha illa Allah, and simple dhikr meanings',
    introduction:
        'Some of the most repeated words in Muslim life are words of repentance and tawheed.',
    sections: [
      _section(
        title: 'Phrase breakdown',
        body:
            'Astaghfirullah means “I seek Allah’s forgiveness.” La ilaha illa Allah means “There is no god worthy of worship except Allah.” These phrases purify the heart through repentance and affirmation of faith.',
      ),
      _section(
        title: 'When they are used',
        body:
            'Astaghfirullah is said after mistakes, after prayer, and in daily repentance. La ilaha illa Allah is the foundation of faith and the greatest statement of tawheed.',
      ),
    ],
    keyTakeaways: const [
      'Repentance and tawheed are daily needs, not occasional ideas.',
      'Short dhikr becomes powerful when its meaning is remembered.',
      'Understanding simple phrases can deepen both worship and character.',
    ],
    reflectionPrompt:
        'Which of these phrases do you need most right now: forgiveness, gratitude, or renewed tawheed?',
    quranReferences: const ['Qur’an 47:19', 'Qur’an 3:135'],
    invocations: const [
      LearningJourneyLessonInvocation(
        title: 'Astaghfirullah',
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah',
        meaning: 'I seek Allah’s forgiveness.',
        context:
            'Said after mistakes, after salah, and whenever the heart needs to return.',
        sourceReference: 'Sahih Muslim',
      ),
      LearningJourneyLessonInvocation(
        title: 'La ilaha illa Allah',
        arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
        transliteration: 'La ilaha illa Allah',
        meaning: 'There is no god worthy of worship except Allah.',
        context:
            'The foundation of faith and one of the greatest forms of dhikr.',
        sourceReference: 'Qur’an 47:19',
      ),
    ],
    relatedTools: const [_lessonSalahHubTool],
    showDhikrCounterAction: true,
  ),
  'reading-basics-open': _lesson(
    stageId: 'reading-basics-open',
    title: 'Fatha, Kasra, and Damma',
    introduction:
        'Harakat are the first step from recognizing letters to actually sounding them out in reading.',
    sections: [
      _section(
        title: 'The three short vowels',
        body:
            'Fatha gives a light “a” sound, kasra gives a light “i” sound, and damma gives a light “u” sound. They are small marks, but they change how a letter is read.',
      ),
      _section(
        title: 'Visual and word examples',
        body:
            'Try simple patterns like بَ بِ بُ or رَ رِ رُ. Keep the eye on the mark first, then let the sound follow calmly.',
        bullets: [
          'Fatha: a short open sound.',
          'Kasra: a short lower front sound.',
          'Damma: a short rounded sound.',
        ],
      ),
    ],
    keyTakeaways: const [
      'Harakat tell you how a letter should sound.',
      'Seeing the mark before saying the sound helps beginners.',
      'Short repeated patterns build confidence quickly.',
    ],
    reflectionPrompt:
        'Which mark feels easiest to recognize already, and which needs slower practice?',
    relatedTools: const [_lessonQuranArabicTool, _lessonQuranStudyTool],
  ),
  'reading-basics-practice': _lesson(
    stageId: 'reading-basics-practice',
    title: 'Sukun, Shaddah, and joining letters',
    introduction:
        'Once the short vowels feel familiar, you start noticing stillness, doubling, and how letters connect into actual reading flow.',
    sections: [
      _section(
        title: 'Sukun and Shaddah',
        body:
            'Sukun shows that a letter is still and carries no vowel. Shaddah shows emphasis or doubling. Both marks are common in recitation and need patient listening.',
      ),
      _section(
        title: 'Joining letters',
        body:
            'Arabic letters can change shape when they connect. Focus on the reading sound first, then notice how the joined form looks in simple words.',
        bullets: [
          'Practice small joined pairs before full words.',
          'Listen, repeat, then read aloud slowly.',
          'Return to words you already know instead of chasing many new examples.',
        ],
      ),
    ],
    keyTakeaways: const [
      'Sukun teaches stillness and Shaddah teaches emphasis.',
      'Joined letters look different but still follow recognizable patterns.',
      'Listening and repetition matter as much as visual recognition.',
    ],
    reflectionPrompt:
        'Which feels harder right now: seeing joined letters or hearing doubled sounds clearly?',
    relatedTools: const [_lessonQuranArabicTool, _lessonQuranStudyTool],
  ),
  'reading-basics-checkpoint': _lesson(
    stageId: 'reading-basics-checkpoint',
    title: 'Practice checkpoint',
    introduction:
        'This checkpoint helps you review what the marks and joined forms are doing before you move into broader recitation.',
    sections: [
      _section(
        title: 'A simple self-check',
        body:
            'Can you identify the short vowels, notice a sukun or shaddah, and read a small joined word without panic? That is enough progress for this stage.',
      ),
      _section(
        title: 'How to practice next',
        body:
            'Review a few patterns daily, listen to one short audio example, and return to the Arabic practice tools with a smaller, calmer target.',
      ),
    ],
    keyTakeaways: const [
      'A checkpoint is for calm review, not pressure.',
      'Readiness means steady recognition, not perfection.',
      'Small daily review makes the next stage lighter.',
    ],
    reflectionPrompt:
        'What one pattern do you want to review every day until it feels natural?',
    relatedTools: const [_lessonQuranArabicTool, _lessonQuranStudyTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_fiqhLessons = <String, LearningJourneyLessonContent>{
  'fiqh-intro': _lesson(
    stageId: 'fiqh-intro',
    title: 'What fiqh is',
    introduction:
        'Fiqh is practical understanding of how a Muslim worships and lives in a way pleasing to Allah.',
    sections: [
      _section(
        title: 'A simple definition',
        body:
            'Fiqh is not a collection of arguments for argument’s sake. It helps believers act carefully in worship, transactions, food, family life, and daily decisions.',
      ),
      _section(
        title: 'Beginner adab',
        body:
            'Learn fiqh with humility. Start from clear essentials, avoid speculation, and ask reliable scholars when a matter is beyond your level.',
        bullets: [
          'Learn what you need for daily worship first.',
          'Avoid turning fiqh into online debate.',
          'Respect the difference between basics and advanced disagreement.',
        ],
      ),
    ],
    keyTakeaways: const [
      'Fiqh serves worship and daily obedience.',
      'A beginner should begin with clear essentials.',
      'Humility is part of learning practical rulings.',
    ],
    reflectionPrompt:
        'Which daily area of life do you most want practical clarity in right now?',
    quranReferences: const ['Qur’an 16:43', 'Qur’an 9:122'],
    relatedTools: const [_lessonWuduGuideTool, _lessonSalahHubTool],
  ),
  'fiqh-purity': _lesson(
    stageId: 'fiqh-purity',
    title: 'Purity and preparation',
    introduction:
        'Cleanliness and purity prepare the body and heart for worship.',
    sections: [
      _section(
        title: 'Why purity matters',
        body:
            'Purity is connected to prayer, Qur’an recitation, and general Muslim cleanliness. It teaches readiness, dignity, and attention to worship.',
      ),
      _section(
        title: 'Beginner basics',
        body:
            'Know the difference between ordinary cleanliness and ritual purity, and keep your first focus on learning wudu well and avoiding obvious impurities.',
      ),
    ],
    keyTakeaways: const [
      'Purity is one of the doors into prayer.',
      'Wudu is the first practical fiqh skill many people need.',
      'Cleanliness in Islam is both physical and spiritual discipline.',
    ],
    reflectionPrompt:
        'How can you make your preparation for prayer more careful and more peaceful?',
    quranReferences: const ['Qur’an 5:6', 'Qur’an 2:222'],
    relatedTools: const [_lessonWuduGuideTool, _lessonSalahHubTool],
  ),
  'fiqh-daily-life': _lesson(
    stageId: 'fiqh-daily-life',
    title: 'Fiqh in daily life',
    introduction:
        'Basic fiqh helps you handle ordinary life with conscience rather than confusion.',
    sections: [
      _section(
        title: 'Halal, haram, and caution',
        body:
            'A Muslim tries to seek what is clearly lawful, avoid what is clearly forbidden, and treat doubtful matters with care.',
      ),
      _section(
        title: 'Everyday examples',
        body:
            'Prayer time, food choices, fasting days, charity, and family responsibilities all benefit from simple first-principle understanding.',
      ),
    ],
    keyTakeaways: const [
      'Fiqh is meant to guide daily life, not only formal study.',
      'Clear essentials reduce anxiety and hesitation.',
      'Doubtful matters should invite care, not carelessness.',
    ],
    reflectionPrompt:
        'Which daily decision would feel lighter if you handled it with clearer Islamic principles?',
    quranReferences: const ['Qur’an 2:168', 'Qur’an 5:87-88'],
    relatedTools: const [_lessonSalahHubTool, _lessonDuaHubTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_timelineLessons = <String, LearningJourneyLessonContent>{
  'timeline-revelation': _lesson(
    stageId: 'timeline-revelation',
    title: 'From revelation to early community',
    introduction:
        'A light historical timeline begins with the earlier prophets and culminates in the revelation given to Prophet Muhammad ﷺ.',
    sections: [
      _section(
        title: 'Early prophets overview',
        body:
            'Allah sent prophets across history calling people to worship Him alone. Their stories prepare the heart to understand the final revelation.',
      ),
      _section(
        title: 'The Prophet Muhammad ﷺ era',
        body:
            'Revelation began in Makkah, the community was formed through patience and migration, and Madinah became the place where Islam was lived as a society.',
      ),
    ],
    keyTakeaways: const [
      'Islamic history begins with a long prophetic chain.',
      'The final revelation came into a real historical community.',
      'Timeline awareness gives context to Qur’an and Seerah.',
    ],
    reflectionPrompt:
        'How does remembering the long chain of prophets change the way you see the final message?',
    quranReferences: const ['Qur’an 2:136', 'Qur’an 33:40'],
    relatedTools: const [_lessonProphetsTool, _lessonQuranReaderTool],
  ),
  'timeline-khulafa': _lesson(
    stageId: 'timeline-khulafa',
    title: 'The rightly guided caliphs',
    introduction:
        'After the Prophet ﷺ passed away, leadership continued through the rightly guided caliphs.',
    sections: [
      _section(
        title: 'Why this era matters',
        body:
            'This period preserved unity, justice, service, consultation, and the carrying of Islam beyond its first city.',
      ),
      _section(
        title: 'Key events in simple view',
        body:
            'The era includes Abu Bakr’s firmness, Umar’s justice, Uthman’s service and compilation efforts, and Ali’s leadership during difficult trials.',
      ),
    ],
    keyTakeaways: const [
      'The khulafa era is part of early Islamic guidance and sacrifice.',
      'Leadership after the Prophet ﷺ came with both strength and trial.',
      'Historical sequence helps later events make more sense.',
    ],
    reflectionPrompt:
        'Which quality from the rightly guided caliphs feels most needed in leadership today?',
    sourceReferences: const [
      'Sahih al-Bukhari',
      'Classical early-history summaries',
    ],
    relatedTools: const [_lessonProphetsTool, _lessonLegacyLearnTool],
  ),
  'timeline-expansion': _lesson(
    stageId: 'timeline-expansion',
    title: 'Expansion and later eras',
    introduction:
        'After the earliest community, Islam spread across regions and produced long periods of scholarship, governance, and civilization.',
    sections: [
      _section(
        title: 'A broad historical arc',
        body:
            'Islam moved into new lands, languages, and cultures. Scholarship developed in tafsir, hadith, fiqh, language, and many supporting sciences.',
      ),
      _section(
        title: 'Golden age and modern context',
        body:
            'The Muslim world saw periods of strength and decline. A light modern frame helps users see that today’s Muslims inherit both a rich legacy and real responsibilities.',
      ),
    ],
    keyTakeaways: const [
      'Islamic history is broad and layered, not one single era.',
      'Scholarship and civilization grew over centuries.',
      'A light modern frame helps users approach history without romanticism or despair.',
    ],
    reflectionPrompt:
        'What does it mean to inherit a tradition that is both glorious and unfinished?',
    relatedTools: const [_lessonLegacyLearnTool, _lessonHadithHubTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_tajweedLessons = <String, LearningJourneyLessonContent>{
  'tajweed-intro': _lesson(
    stageId: 'tajweed-intro',
    title: 'What tajweed is',
    introduction:
        'Tajweed is the careful recitation of the Qur’an as it should be pronounced, with dignity and measured attention.',
    sections: [
      _section(
        title: 'A simple definition',
        body:
            'Tajweed means giving letters and words their due in pronunciation and recitation. It is not about showing off. It is about honoring Allah’s words.',
      ),
      _section(
        title: 'Why tajweed matters',
        body:
            'Good recitation protects meaning, increases beauty, and helps the tongue avoid careless mistakes.',
      ),
    ],
    keyTakeaways: const [
      'Tajweed is part of respecting the Qur’an.',
      'It begins with care, not complexity.',
      'A beginner can start with awareness before mastering details.',
    ],
    reflectionPrompt:
        'How can you recite more carefully without turning recitation into stress?',
    quranReferences: const ['Qur’an 73:4'],
    relatedTools: const [_lessonQuranArabicTool, _lessonQuranStudyTool],
    relatedJourneyIds: const ['reading-basics', 'journey-quran'],
  ),
  'tajweed-makharij': _lesson(
    stageId: 'tajweed-makharij',
    title: 'Sounds and articulation',
    introduction:
        'Basic pronunciation begins by noticing where sounds come from and how common mistakes happen.',
    sections: [
      _section(
        title: 'Basic pronunciation rules',
        body:
            'Some letters come from the throat, some from the tongue, some from the lips. Beginners do not need every technical term first, but they should notice that not all letters are produced from the same place.',
      ),
      _section(
        title: 'Common mistakes',
        body:
            'Rushing, flattening different letters into one sound, or ignoring emphasis can weaken recitation. Slow listening is part of correction.',
      ),
    ],
    keyTakeaways: const [
      'Different letters come from different articulation points.',
      'Careless speed creates many beginner mistakes.',
      'Listening and imitation are part of learning tajweed.',
    ],
    reflectionPrompt:
        'Which feels harder right now: hearing the difference or producing the difference?',
    relatedTools: const [_lessonQuranArabicTool, _lessonQuranReaderTool],
    relatedJourneyIds: const ['reading-basics', 'short-surahs'],
  ),
  'tajweed-application': _lesson(
    stageId: 'tajweed-application',
    title: 'Apply tajweed in recitation',
    introduction:
        'The goal is to take basic awareness back into real recitation, especially in the short surahs you revisit often.',
    sections: [
      _section(
        title: 'Listening comparison',
        body:
            'A useful beginner habit is to hear a careful recitation, then hear your own pace and notice where letters or pauses need more dignity.',
      ),
      _section(
        title: 'A first practice plan',
        body:
            'Choose one short surah, recite it slowly, and focus on one correction at a time instead of trying to perfect everything in one sitting.',
      ),
    ],
    keyTakeaways: const [
      'Application matters more than memorizing terminology alone.',
      'One surah practiced slowly is a strong tajweed beginning.',
      'Listening comparison is one of the safest beginner tools.',
    ],
    reflectionPrompt:
        'What one recitation habit would most improve your care with Allah’s words?',
    quranReferences: const ['Qur’an 75:16-18'],
    relatedTools: const [_lessonQuranReaderTool, _lessonQuranStudyTool],
    continueJourneyIds: const ['journey-quran'],
    relatedJourneyIds: const ['short-surahs', 'understanding-al-fatihah'],
  ),
};

final Map<String, LearningJourneyLessonContent>
_dailyWisdomLessons = <String, LearningJourneyLessonContent>{
  'wisdom-daily-quote': _lesson(
    stageId: 'wisdom-daily-quote',
    title: 'Daily wisdom prompt',
    introduction:
        'A daily wisdom habit works best when one small item carries enough meaning to reopen the heart each day.',
    sections: [
      _section(
        title: 'One item, not many',
        body:
            'A single verse, hadith, prophetic reminder, or reflective sign is often enough. The goal is clarity and consistency, not volume.',
      ),
      _section(
        title: 'What today’s item should do',
        body:
            'It should remind you of Allah, sharpen one lesson, and point toward one next step rather than becoming another scrollable feed.',
      ),
    ],
    keyTakeaways: const [
      'Daily wisdom should be light enough to revisit.',
      'One meaningful item is better than many forgotten ones.',
      'The best prompt points toward remembrance and action.',
    ],
    reflectionPrompt:
        'What kind of daily reminder actually changes the way you move through your day?',
    relatedTools: const [_lessonLegacyLearnTool, _lessonLearnNotesTool],
  ),
  'wisdom-short-lesson': _lesson(
    stageId: 'wisdom-short-lesson',
    title: 'Short daily lesson',
    introduction:
        'Daily wisdom becomes stronger when the app presents verse, hadith, prophetic, and reflection surfaces in one calmer rhythm.',
    sections: [
      _section(
        title: 'A unified flow',
        body:
            'The app already contains daily verse, hadith reflection, prophet-based learning, and signs in creation. A unified daily wisdom flow helps these feel like one system instead of separate widgets.',
      ),
      _section(
        title: 'How to use it',
        body:
            'Open the day’s item, read its short explanation, pause for one reflection, then follow one related tool only if you want to go deeper.',
      ),
    ],
    keyTakeaways: const [
      'Daily wisdom should unify existing short-form learning surfaces.',
      'Explanation should stay simple and calm.',
      'A daily item is an opening, not a demand for a long session.',
    ],
    reflectionPrompt:
        'Which kind of daily item usually opens your heart most quickly: verse, hadith, story, or reflection?',
    relatedTools: const [_lessonHadithHubTool, _lessonWorldLandingTool],
  ),
  'wisdom-practice': _lesson(
    stageId: 'wisdom-practice',
    title: 'Turn wisdom into practice',
    introduction:
        'Short learning becomes transformative when it leaves the page and enters one real act, habit, or dua.',
    sections: [
      _section(
        title: 'A practical next step',
        body:
            'After reading the day’s wisdom, ask: what should I remember, say, avoid, or begin today because of this?',
      ),
      _section(
        title: 'Keep the loop simple',
        body:
            'A short note, one practical action, and a quiet return later in the day are enough to make daily wisdom useful.',
      ),
    ],
    keyTakeaways: const [
      'Daily wisdom should end in a small practice, not only a thought.',
      'Reflection deepens when written or acted on.',
      'A light daily loop can keep the learning system alive between deeper journeys.',
    ],
    reflectionPrompt:
        'What is one small practice you can tie to today’s learning so it does not fade by evening?',
    relatedTools: const [_lessonLearnNotesTool, _lessonDuaHubTool],
  ),
};

final Map<String, LearningJourneyLessonContent>
_storiesSignsLessons = <String, LearningJourneyLessonContent>{
  'stories-world-landing': _lesson(
    stageId: 'stories-world-landing',
    title: 'Sky, stars, ocean, and mountains',
    introduction:
        'Creation invites reflection because it points beyond itself to the wisdom, power, and mercy of Allah.',
    sections: [
      _section(
        title: 'Sky and stars',
        body:
            'The sky, stars, and ordered heavens remind the heart that Allah created with precision and purpose, not randomness.',
      ),
      _section(
        title: 'Ocean and mountains',
        body:
            'The sea teaches power, provision, and vulnerability. Mountains suggest firmness, balance, and signs worth pondering rather than merely consuming visually.',
      ),
    ],
    keyTakeaways: const [
      'Creation points toward its Creator.',
      'The Qur’an repeatedly invites observation with humility.',
      'Reflection on the world should deepen worship, not distraction.',
    ],
    reflectionPrompt:
        'Which sign in creation most quickly brings your heart back to awe?',
    quranReferences: const ['Qur’an 3:190-191', 'Qur’an 16:14-15'],
    relatedTools: const [_lessonWorldLandingTool, _lessonWorldSignsTool],
  ),
  'stories-explore-creation': _lesson(
    stageId: 'stories-explore-creation',
    title: 'Animals and human creation',
    introduction:
        'The Qur’an points to both the wider world and the human self as signs worth reflecting on.',
    sections: [
      _section(
        title: 'Animals as signs',
        body:
            'Animals reflect provision, instinct, order, beauty, and dependence on Allah. The Qur’an repeatedly uses them to awaken gratitude and humility.',
      ),
      _section(
        title: 'Human creation',
        body:
            'Reflecting on human creation reminds a person of weakness, dignity, dependence, and accountability before Allah.',
      ),
    ],
    keyTakeaways: const [
      'Animals and human life both carry Qur’anic signs.',
      'Reflection should lead to gratitude and humility.',
      'The self is also part of creation to be pondered, not ignored.',
    ],
    reflectionPrompt:
        'When you think about your own creation, what quality of Allah comes most strongly to mind?',
    quranReferences: const ['Qur’an 51:20-21', 'Qur’an 24:45'],
    relatedTools: const [_lessonWorldLandingTool, _lessonWorldSignsTool],
  ),
  'stories-prophetic-signs': _lesson(
    stageId: 'stories-prophetic-signs',
    title: 'Day, night, and prophetic reflection',
    introduction:
        'Signs in creation and stories of the prophets meet in one place: both teach the heart to notice Allah more carefully.',
    sections: [
      _section(
        title: 'Day and night',
        body:
            'Alternation of day and night teaches rhythm, dependence, rest, effort, and the passing of time toward Allah.',
      ),
      _section(
        title: 'Stories as signs',
        body:
            'The prophets did not only tell people to look outward. Their lives also became signs of patience, tawheed, repentance, and reliance on Allah.',
      ),
    ],
    keyTakeaways: const [
      'Creation and revelation point to the same Lord.',
      'Day and night are daily signs, not background scenery.',
      'Prophetic stories teach how to respond to the signs around us.',
    ],
    reflectionPrompt:
        'Which sign do you overlook most often because it has become too familiar?',
    quranReferences: const ['Qur’an 10:6', 'Qur’an 12:111'],
    relatedTools: const [_lessonProphetsTool, _lessonWorldSignsTool],
  ),
};

LearningJourneyLessonContent _lesson({
  required String stageId,
  required String title,
  required String introduction,
  required List<LearningJourneyLessonSection> sections,
  required List<String> keyTakeaways,
  required String reflectionPrompt,
  List<String> quranReferences = const <String>[],
  List<String> sourceReferences = const <String>[],
  List<LearningJourneyLessonInvocation> invocations =
      const <LearningJourneyLessonInvocation>[],
  List<LearningJourneyToolLink> relatedTools =
      const <LearningJourneyToolLink>[],
  List<String> continueJourneyIds = const <String>[],
  List<String> relatedJourneyIds = const <String>[],
  bool showDhikrCounterAction = false,
}) {
  return LearningJourneyLessonContent(
    stageId: stageId,
    title: title,
    introduction: introduction,
    sections: sections,
    keyTakeaways: keyTakeaways,
    reflectionPrompt: reflectionPrompt,
    quranReferences: quranReferences,
    sourceReferences: sourceReferences,
    invocations: invocations,
    relatedTools: relatedTools,
    continueJourneyIds: continueJourneyIds,
    relatedJourneyIds: relatedJourneyIds,
    showDhikrCounterAction: showDhikrCounterAction,
  );
}

LearningJourneyLessonSection _section({
  required String title,
  required String body,
  List<String> bullets = const <String>[],
}) {
  return LearningJourneyLessonSection(
    title: title,
    body: body,
    bullets: bullets,
  );
}

LearningJourneyLessonInvocation _duaFromSeed(String id) {
  final item = duaSeedDataset.items.firstWhere((entry) => entry.id == id);
  return _invocationFromDua(item);
}

LearningJourneyLessonInvocation _invocationFromDua(DuaItem item) {
  return LearningJourneyLessonInvocation(
    title: item.title,
    arabic: item.arabic,
    transliteration: item.transliteration,
    meaning: item.translation,
    context: item.whenToSay,
    sourceReference: item.sourceRef,
  );
}

const _lessonDuaHubTool = LearningJourneyToolLink(
  title: 'Dua Hub',
  subtitle: 'Open the current verified dua hub.',
  routeName: 'learnDuaHub',
);

const _lessonLegacyLearnTool = LearningJourneyToolLink(
  title: 'Legacy Learning Material',
  subtitle: 'Open the current Learn ecosystem during migration.',
  routeName: 'learnLegacy',
);

const _lessonNamesOfAllahTool = LearningJourneyToolLink(
  title: 'Names of Allah',
  subtitle: 'Use the existing names page.',
  routeName: 'quranNamesOfAllah',
);

const _lessonProphetsTool = LearningJourneyToolLink(
  title: 'Prophets',
  subtitle: 'Open the current Prophets system.',
  routeName: 'learnProphetsHub',
);

const _lessonQuranReaderTool = LearningJourneyToolLink(
  title: 'Qur’an Reader',
  subtitle: 'Open a direct reading view.',
  routeName: 'quranReader',
  pathParameters: {'surahNumber': '1'},
);

const _lessonQuranSearchTool = LearningJourneyToolLink(
  title: 'Search',
  subtitle: 'Search ayat and phrases directly.',
  routeName: 'quranSearch',
);

const _lessonQuranBookmarksTool = LearningJourneyToolLink(
  title: 'Bookmarks',
  subtitle: 'Return to saved places you want to revisit.',
  routeName: 'quranBookmarks',
);

const _lessonQuranNotesTool = LearningJourneyToolLink(
  title: 'Qur’an Notes',
  subtitle: 'Keep reflections tied to verses and passages.',
  routeName: 'quranNotes',
);

const _lessonQuranStudyTool = LearningJourneyToolLink(
  title: 'Qur’an Study',
  subtitle: 'Open the study-focused Qur’an learning path.',
  routeName: 'quranLearningHub',
);

const _lessonQuranArabicTool = LearningJourneyToolLink(
  title: 'Qur’anic Arabic',
  subtitle: 'Open the dedicated Arabic learning path.',
  routeName: 'quranArabic',
);

const _lessonWuduGuideTool = LearningJourneyToolLink(
  title: 'Wudu Guide',
  subtitle: 'Open the full wudu guide.',
  routeName: 'learnWuduGuide',
);

const _lessonSalahHubTool = LearningJourneyToolLink(
  title: 'Salah Hub',
  subtitle: 'Open the current Salah learning hub.',
  routeName: 'learnSalahHub',
);

const _lessonHadithHubTool = LearningJourneyToolLink(
  title: 'Hadith Hub',
  subtitle: 'Open themes, collections, and paths.',
  routeName: 'learnHadithLanding',
);

const _lessonWorldLandingTool = LearningJourneyToolLink(
  title: 'World & Creation',
  subtitle: 'Open the main world-and-creation hub.',
  routeName: 'learnWorldLanding',
);

const _lessonWorldSignsTool = LearningJourneyToolLink(
  title: 'Signs Explorer',
  subtitle: 'Browse signs-based exploration content.',
  routeName: 'worldSignsExplorer',
);

const _lessonLearnNotesTool = LearningJourneyToolLink(
  title: 'Learn Notes',
  subtitle: 'Review saved notes and reflections.',
  routeName: 'learnNotesLanding',
);
