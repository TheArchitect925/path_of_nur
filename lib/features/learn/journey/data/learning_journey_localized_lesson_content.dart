import '../../../../l10n/app_localizations.dart';
import '../domain/learning_journey_lesson_models.dart';
import '../domain/learning_journey_models.dart';

class LearningJourneyLocalizedLessonContentRegistry {
  static LearningJourneyLessonContent? lessonForStage(
    String stageId,
    AppLocalizations l10n,
  ) {
    switch (stageId) {
      case 'recite-fatihah':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReciteFatihahLessonTitle,
          introduction: l10n.learningJourneyStageReciteFatihahIntro,
          sections: [
            _section(
              title: l10n.learningJourneyStageReciteFatihahSection1Title,
              body: l10n.learningJourneyStageReciteFatihahSection1Body,
            ),
            _section(
              title: l10n.learningJourneyStageReciteFatihahSection2Title,
              body: l10n.learningJourneyStageReciteFatihahSection2Body,
              bullets: [
                l10n.learningJourneyStageReciteFatihahSection2Bullet1,
                l10n.learningJourneyStageReciteFatihahSection2Bullet2,
                l10n.learningJourneyStageReciteFatihahSection2Bullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReciteFatihahTakeaway1,
            l10n.learningJourneyStageReciteFatihahTakeaway2,
            l10n.learningJourneyStageReciteFatihahTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyStageReciteFatihahReflection,
          quranReferences: const ['Qur’an 1:1-7'],
          invocations: [
            _invocation(
              title: l10n.learningJourneyStageReciteFatihahInvocation1Title,
              arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
              transliteration: 'Alhamdu lillahi rabbil alamin',
              meaning: l10n.learningJourneyStageReciteFatihahInvocation1Meaning,
              context: l10n.learningJourneyStageReciteFatihahInvocation1Context,
              sourceReference: 'Qur’an 1:2',
            ),
          ],
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolQuranReaderTitle,
              subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
              routeName: 'quranReader',
              pathParameters: const {'surahNumber': '1'},
              queryParameters: const {'ayah': '1', 'endAyah': '7'},
            ),
            _tool(
              title: l10n.learningJourneyToolSalahHubTitle,
              subtitle: l10n.learningJourneyToolSalahHubSubtitle,
              routeName: 'learnSalahHub',
            ),
          ],
          continueJourneyIds: const ['understanding-al-fatihah'],
          relatedJourneyIds: const ['salah-foundations'],
          actionStep: l10n.learningJourneyReciteFatihahActionStep,
        );
      case 'recite-short-surahs':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReciteShortSurahsLessonTitle,
          introduction: l10n.learningJourneyStageReciteShortSurahsIntro,
          sections: [
            _section(
              title: l10n.learningJourneyStageReciteShortSurahsSection1Title,
              body: l10n.learningJourneyStageReciteShortSurahsSection1Body,
            ),
            _section(
              title: l10n.learningJourneyStageReciteShortSurahsSection2Title,
              body: l10n.learningJourneyStageReciteShortSurahsSection2Body,
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReciteShortSurahsTakeaway1,
            l10n.learningJourneyStageReciteShortSurahsTakeaway2,
            l10n.learningJourneyStageReciteShortSurahsTakeaway3,
          ],
          reflectionPrompt:
              l10n.learningJourneyStageReciteShortSurahsReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyStageReciteShortSurahsInvocation1Title,
              arabic: 'اللَّهُ أَكْبَرُ',
              transliteration: 'Allahu Akbar',
              meaning:
                  l10n.learningJourneyStageReciteShortSurahsInvocation1Meaning,
              context:
                  l10n.learningJourneyStageReciteShortSurahsInvocation1Context,
              sourceReference: 'Sahih Muslim',
            ),
            _invocation(
              title: l10n.learningJourneyStageReciteShortSurahsInvocation2Title,
              arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
              transliteration: 'Subhana Rabbiyal-Azim',
              meaning:
                  l10n.learningJourneyStageReciteShortSurahsInvocation2Meaning,
              context:
                  l10n.learningJourneyStageReciteShortSurahsInvocation2Context,
              sourceReference: 'Sunan Abi Dawud',
            ),
            _invocation(
              title: l10n.learningJourneyStageReciteShortSurahsInvocation3Title,
              arabic: 'سُبْحَانَ رَبِّيَ الأَعْلَى',
              transliteration: 'Subhana Rabbiyal-Ala',
              meaning:
                  l10n.learningJourneyStageReciteShortSurahsInvocation3Meaning,
              context:
                  l10n.learningJourneyStageReciteShortSurahsInvocation3Context,
              sourceReference: 'Sunan Abi Dawud',
            ),
          ],
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolSalahHubTitle,
              subtitle: l10n.learningJourneyToolSalahHubSubtitle,
              routeName: 'learnSalahHub',
            ),
            _tool(
              title: l10n.learningJourneyToolQuranReaderTitle,
              subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
              routeName: 'quranReader',
              pathParameters: const {'surahNumber': '112'},
            ),
          ],
          continueJourneyIds: const ['short-surahs'],
          relatedJourneyIds: const ['salah-foundations'],
          actionStep: l10n.learningJourneyReciteShortSurahsActionStep,
        );
      case 'recite-meaning':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReciteMeaningLessonTitle,
          introduction: l10n.learningJourneyStageReciteMeaningIntro,
          sections: [
            _section(
              title: l10n.learningJourneyStageReciteMeaningSection1Title,
              body: l10n.learningJourneyStageReciteMeaningSection1Body,
            ),
            _section(
              title: l10n.learningJourneyStageReciteMeaningSection2Title,
              body: l10n.learningJourneyStageReciteMeaningSection2Body,
              bullets: [
                l10n.learningJourneyStageReciteMeaningSection2Bullet1,
                l10n.learningJourneyStageReciteMeaningSection2Bullet2,
                l10n.learningJourneyStageReciteMeaningSection2Bullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReciteMeaningTakeaway1,
            l10n.learningJourneyStageReciteMeaningTakeaway2,
            l10n.learningJourneyStageReciteMeaningTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyStageReciteMeaningReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyStageReciteMeaningInvocation1Title,
              arabic: 'سُبْحَانَ اللَّهِ',
              transliteration: 'SubhanAllah',
              meaning: l10n.learningJourneyStageReciteMeaningInvocation1Meaning,
              context: l10n.learningJourneyStageReciteMeaningInvocation1Context,
              sourceReference: 'Sahih Muslim',
            ),
            _invocation(
              title: l10n.learningJourneyStageReciteMeaningInvocation2Title,
              arabic: 'الْحَمْدُ لِلَّهِ',
              transliteration: 'Alhamdulillah',
              meaning: l10n.learningJourneyStageReciteMeaningInvocation2Meaning,
              context: l10n.learningJourneyStageReciteMeaningInvocation2Context,
              sourceReference: 'Qur’an 1:2',
            ),
          ],
          quranReferences: const ['Qur’an 1:2', 'Qur’an 20:14'],
          showDhikrCounterAction: true,
          continueJourneyIds: const ['daily-dhikr'],
          relatedJourneyIds: const ['salah-foundations'],
          actionStep: l10n.learningJourneyReciteMeaningActionStep,
        );
      case 'reading-basics-open':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReadingBasicsOpenLessonTitle,
          introduction: l10n.learningJourneyStageReadingBasicsOpenIntro,
          sections: [
            _section(
              title: l10n.learningJourneyStageReadingBasicsOpenSection1Title,
              body: l10n.learningJourneyStageReadingBasicsOpenSection1Body,
              bullets: [
                l10n.learningJourneyStageReadingBasicsOpenSection1Bullet1,
                l10n.learningJourneyStageReadingBasicsOpenSection1Bullet2,
                l10n.learningJourneyStageReadingBasicsOpenSection1Bullet3,
              ],
            ),
            _section(
              title: l10n.learningJourneyStageReadingBasicsOpenSection2Title,
              body: l10n.learningJourneyStageReadingBasicsOpenSection2Body,
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReadingBasicsOpenTakeaway1,
            l10n.learningJourneyStageReadingBasicsOpenTakeaway2,
            l10n.learningJourneyStageReadingBasicsOpenTakeaway3,
          ],
          reflectionPrompt:
              l10n.learningJourneyStageReadingBasicsOpenReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolQuranArabicTitle,
              subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
              routeName: 'quranArabic',
            ),
          ],
          continueJourneyIds: const ['arabic-alphabet'],
          relatedJourneyIds: const ['understand-what-you-recite'],
        );
      case 'reading-basics-practice':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReadingBasicsPracticeLessonTitle,
          introduction: l10n.learningJourneyStageReadingBasicsPracticeIntro,
          sections: [
            _section(
              title:
                  l10n.learningJourneyStageReadingBasicsPracticeSection1Title,
              body: l10n.learningJourneyStageReadingBasicsPracticeSection1Body,
            ),
            _section(
              title:
                  l10n.learningJourneyStageReadingBasicsPracticeSection2Title,
              body: l10n.learningJourneyStageReadingBasicsPracticeSection2Body,
              bullets: [
                l10n.learningJourneyStageReadingBasicsPracticeSection2Bullet1,
                l10n.learningJourneyStageReadingBasicsPracticeSection2Bullet2,
                l10n.learningJourneyStageReadingBasicsPracticeSection2Bullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReadingBasicsPracticeTakeaway1,
            l10n.learningJourneyStageReadingBasicsPracticeTakeaway2,
            l10n.learningJourneyStageReadingBasicsPracticeTakeaway3,
          ],
          reflectionPrompt:
              l10n.learningJourneyStageReadingBasicsPracticeReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolQuranArabicTitle,
              subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
              routeName: 'quranArabic',
            ),
            _tool(
              title: l10n.learningJourneyToolQuranStudyTitle,
              subtitle: l10n.learningJourneyToolQuranStudySubtitle,
              routeName: 'quranLearningHub',
            ),
          ],
          continueJourneyIds: const ['understand-what-you-recite'],
          relatedJourneyIds: const ['journey-quran'],
        );
      case 'reading-basics-checkpoint':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyStageReadingBasicsCheckpointLessonTitle,
          introduction: l10n.learningJourneyStageReadingBasicsCheckpointIntro,
          sections: [
            _section(
              title:
                  l10n.learningJourneyStageReadingBasicsCheckpointSection1Title,
              body:
                  l10n.learningJourneyStageReadingBasicsCheckpointSection1Body,
              bullets: [
                l10n.learningJourneyStageReadingBasicsCheckpointSection1Bullet1,
                l10n.learningJourneyStageReadingBasicsCheckpointSection1Bullet2,
                l10n.learningJourneyStageReadingBasicsCheckpointSection1Bullet3,
              ],
            ),
            _section(
              title:
                  l10n.learningJourneyStageReadingBasicsCheckpointSection2Title,
              body:
                  l10n.learningJourneyStageReadingBasicsCheckpointSection2Body,
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyStageReadingBasicsCheckpointTakeaway1,
            l10n.learningJourneyStageReadingBasicsCheckpointTakeaway2,
            l10n.learningJourneyStageReadingBasicsCheckpointTakeaway3,
          ],
          reflectionPrompt:
              l10n.learningJourneyStageReadingBasicsCheckpointReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolQuranArabicTitle,
              subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
              routeName: 'quranArabic',
            ),
            _tool(
              title: l10n.learningJourneyToolQuranStudyTitle,
              subtitle: l10n.learningJourneyToolQuranStudySubtitle,
              routeName: 'quranLearningHub',
            ),
          ],
          continueJourneyIds: const ['understand-what-you-recite'],
          relatedJourneyIds: const ['journey-quran'],
          actionStep: l10n.learningJourneyReadingCheckpointActionStep,
        );
      case 'quran-open':
      case 'quran-read':
      case 'quran-themes':
      case 'quran-next-steps':
        return _quranJourneyLesson(stageId, l10n);
      case 'fatihah-read':
      case 'fatihah-recitation':
      case 'fatihah-reflection':
      case 'fatihah-completion':
        return _fatihahLesson(stageId, l10n);
      case 'short-surahs-ikhlas':
      case 'short-surahs-falaq':
      case 'short-surahs-nas':
      case 'short-surahs-kafirun':
      case 'short-surahs-kawthar':
      case 'short-surahs-completion':
        return _shortSurahsLesson(stageId, l10n);
      case 'alphabet-completion':
      case 'reading-basics-completion':
      case 'recite-completion':
        return _learningTransitionLesson(stageId, l10n);
      case 'seerah-early-life':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahEarlyLifeTitle,
          introduction: l10n.learningJourneySeerahEarlyLifeIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahEarlyLifeSection1Title,
              body: l10n.learningJourneySeerahEarlyLifeSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahEarlyLifeSection2Title,
              body: l10n.learningJourneySeerahEarlyLifeSection2Body,
              bullets: [
                l10n.learningJourneySeerahEarlyLifeBullet1,
                l10n.learningJourneySeerahEarlyLifeBullet2,
                l10n.learningJourneySeerahEarlyLifeBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahEarlyLifeTakeaway1,
            l10n.learningJourneySeerahEarlyLifeTakeaway2,
            l10n.learningJourneySeerahEarlyLifeTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahEarlyLifeReflection,
          quranReferences: const ['Qur’an 93:6-8'],
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolProphetsTitle,
              subtitle: l10n.learningJourneyToolProphetsSubtitle,
              routeName: 'learnProphetsHub',
              queryParameters: const {'tab': 'stories'},
            ),
          ],
          continueJourneyIds: const ['prophets-journey'],
          relatedJourneyIds: const ['beautiful-character'],
        );
      case 'seerah-first-revelation':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahFirstRevelationTitle,
          introduction: l10n.learningJourneySeerahFirstRevelationIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahFirstRevelationSection1Title,
              body: l10n.learningJourneySeerahFirstRevelationSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahFirstRevelationSection2Title,
              body: l10n.learningJourneySeerahFirstRevelationSection2Body,
              bullets: [
                l10n.learningJourneySeerahFirstRevelationBullet1,
                l10n.learningJourneySeerahFirstRevelationBullet2,
                l10n.learningJourneySeerahFirstRevelationBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahFirstRevelationTakeaway1,
            l10n.learningJourneySeerahFirstRevelationTakeaway2,
            l10n.learningJourneySeerahFirstRevelationTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahFirstRevelationReflection,
          quranReferences: const ['Qur’an 96:1-5'],
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolQuranReaderTitle,
              subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
              routeName: 'quranReader',
              pathParameters: const {'surahNumber': '96'},
              queryParameters: const {'ayah': '1', 'endAyah': '5'},
            ),
          ],
          continueJourneyIds: const ['journey-quran'],
          relatedJourneyIds: const ['hadith-essentials'],
        );
      case 'seerah-makkah-period':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahMakkahTitle,
          introduction: l10n.learningJourneySeerahMakkahIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahMakkahSection1Title,
              body: l10n.learningJourneySeerahMakkahSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahMakkahSection2Title,
              body: l10n.learningJourneySeerahMakkahSection2Body,
              bullets: [
                l10n.learningJourneySeerahMakkahBullet1,
                l10n.learningJourneySeerahMakkahBullet2,
                l10n.learningJourneySeerahMakkahBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahMakkahTakeaway1,
            l10n.learningJourneySeerahMakkahTakeaway2,
            l10n.learningJourneySeerahMakkahTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahMakkahReflection,
          quranReferences: const ['Qur’an 74:1-7', 'Qur’an 73:1-10'],
          continueJourneyIds: const ['daily-dhikr'],
          relatedJourneyIds: const ['beautiful-character'],
        );
      case 'seerah-hijrah':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahHijrahTitle,
          introduction: l10n.learningJourneySeerahHijrahIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahHijrahSection1Title,
              body: l10n.learningJourneySeerahHijrahSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahHijrahSection2Title,
              body: l10n.learningJourneySeerahHijrahSection2Body,
              bullets: [
                l10n.learningJourneySeerahHijrahBullet1,
                l10n.learningJourneySeerahHijrahBullet2,
                l10n.learningJourneySeerahHijrahBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahHijrahTakeaway1,
            l10n.learningJourneySeerahHijrahTakeaway2,
            l10n.learningJourneySeerahHijrahTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahHijrahReflection,
          quranReferences: const ['Qur’an 9:40'],
          continueJourneyIds: const ['foundations-of-faith'],
          relatedJourneyIds: const ['beautiful-character'],
        );
      case 'seerah-madinah-society':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahMadinahTitle,
          introduction: l10n.learningJourneySeerahMadinahIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahMadinahSection1Title,
              body: l10n.learningJourneySeerahMadinahSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahMadinahSection2Title,
              body: l10n.learningJourneySeerahMadinahSection2Body,
              bullets: [
                l10n.learningJourneySeerahMadinahBullet1,
                l10n.learningJourneySeerahMadinahBullet2,
                l10n.learningJourneySeerahMadinahBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahMadinahTakeaway1,
            l10n.learningJourneySeerahMadinahTakeaway2,
            l10n.learningJourneySeerahMadinahTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahMadinahReflection,
          quranReferences: const ['Qur’an 49:10', 'Qur’an 3:103'],
          continueJourneyIds: const ['beautiful-character'],
          relatedJourneyIds: const ['hadith-essentials'],
        );
      case 'seerah-leadership-character':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahLeadershipTitle,
          introduction: l10n.learningJourneySeerahLeadershipIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahLeadershipSection1Title,
              body: l10n.learningJourneySeerahLeadershipSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahLeadershipSection2Title,
              body: l10n.learningJourneySeerahLeadershipSection2Body,
              bullets: [
                l10n.learningJourneySeerahLeadershipBullet1,
                l10n.learningJourneySeerahLeadershipBullet2,
                l10n.learningJourneySeerahLeadershipBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahLeadershipTakeaway1,
            l10n.learningJourneySeerahLeadershipTakeaway2,
            l10n.learningJourneySeerahLeadershipTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahLeadershipReflection,
          quranReferences: const ['Qur’an 3:159', 'Qur’an 33:21'],
          continueJourneyIds: const ['beautiful-character'],
          relatedJourneyIds: const ['daily-wisdom', 'hadith-essentials'],
        );
      case 'seerah-final-sermon':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneySeerahFinalSermonTitle,
          introduction: l10n.learningJourneySeerahFinalSermonIntro,
          sections: [
            _section(
              title: l10n.learningJourneySeerahFinalSermonSection1Title,
              body: l10n.learningJourneySeerahFinalSermonSection1Body,
            ),
            _section(
              title: l10n.learningJourneySeerahFinalSermonSection2Title,
              body: l10n.learningJourneySeerahFinalSermonSection2Body,
              bullets: [
                l10n.learningJourneySeerahFinalSermonBullet1,
                l10n.learningJourneySeerahFinalSermonBullet2,
                l10n.learningJourneySeerahFinalSermonBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneySeerahFinalSermonTakeaway1,
            l10n.learningJourneySeerahFinalSermonTakeaway2,
            l10n.learningJourneySeerahFinalSermonTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneySeerahFinalSermonReflection,
          quranReferences: const ['Qur’an 5:3'],
          continueJourneyIds: const ['beautiful-character'],
          relatedJourneyIds: const ['hadith-essentials', 'daily-wisdom'],
        );
      case 'dhikr-what-is':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrWhatIsTitle,
          introduction: l10n.learningJourneyDhikrWhatIsIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrWhatIsSection1Title,
              body: l10n.learningJourneyDhikrWhatIsSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrWhatIsSection2Title,
              body: l10n.learningJourneyDhikrWhatIsSection2Body,
              bullets: [
                l10n.learningJourneyDhikrWhatIsBullet1,
                l10n.learningJourneyDhikrWhatIsBullet2,
                l10n.learningJourneyDhikrWhatIsBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrWhatIsTakeaway1,
            l10n.learningJourneyDhikrWhatIsTakeaway2,
            l10n.learningJourneyDhikrWhatIsTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrWhatIsReflection,
          quranReferences: const ['Qur’an 13:28', 'Qur’an 33:41'],
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['beautiful-character'],
          showDhikrCounterAction: true,
        );
      case 'dhikr-morning-adhkar':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrMorningTitle,
          introduction: l10n.learningJourneyDhikrMorningIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrMorningSection1Title,
              body: l10n.learningJourneyDhikrMorningSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrMorningSection2Title,
              body: l10n.learningJourneyDhikrMorningSection2Body,
              bullets: [
                l10n.learningJourneyDhikrMorningBullet1,
                l10n.learningJourneyDhikrMorningBullet2,
                l10n.learningJourneyDhikrMorningBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrMorningTakeaway1,
            l10n.learningJourneyDhikrMorningTakeaway2,
            l10n.learningJourneyDhikrMorningTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrMorningReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyDhikrMorningInvocationTitle,
              arabic:
                  'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
              transliteration:
                  'Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur',
              meaning: l10n.learningJourneyDhikrMorningInvocationMeaning,
              context: l10n.learningJourneyDhikrMorningInvocationContext,
              sourceReference: 'Sunan Abi Dawud',
            ),
          ],
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['daily-wisdom'],
          showDhikrCounterAction: true,
        );
      case 'dhikr-evening-adhkar':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrEveningTitle,
          introduction: l10n.learningJourneyDhikrEveningIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrEveningSection1Title,
              body: l10n.learningJourneyDhikrEveningSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrEveningSection2Title,
              body: l10n.learningJourneyDhikrEveningSection2Body,
              bullets: [
                l10n.learningJourneyDhikrEveningBullet1,
                l10n.learningJourneyDhikrEveningBullet2,
                l10n.learningJourneyDhikrEveningBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrEveningTakeaway1,
            l10n.learningJourneyDhikrEveningTakeaway2,
            l10n.learningJourneyDhikrEveningTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrEveningReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyDhikrEveningInvocationTitle,
              arabic:
                  'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
              transliteration:
                  'Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilaykal-masir',
              meaning: l10n.learningJourneyDhikrEveningInvocationMeaning,
              context: l10n.learningJourneyDhikrEveningInvocationContext,
              sourceReference: 'Sunan Abi Dawud',
            ),
          ],
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['daily-wisdom'],
          showDhikrCounterAction: true,
        );
      case 'dhikr-after-salah':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrAfterSalahTitle,
          introduction: l10n.learningJourneyDhikrAfterSalahIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrAfterSalahSection1Title,
              body: l10n.learningJourneyDhikrAfterSalahSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrAfterSalahSection2Title,
              body: l10n.learningJourneyDhikrAfterSalahSection2Body,
              bullets: [
                l10n.learningJourneyDhikrAfterSalahBullet1,
                l10n.learningJourneyDhikrAfterSalahBullet2,
                l10n.learningJourneyDhikrAfterSalahBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrAfterSalahTakeaway1,
            l10n.learningJourneyDhikrAfterSalahTakeaway2,
            l10n.learningJourneyDhikrAfterSalahTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrAfterSalahReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyDhikrAfterSalahInvocationTitle,
              arabic:
                  'سُبْحَانَ اللَّهِ ٣٣ • الْحَمْدُ لِلَّهِ ٣٣ • اللَّهُ أَكْبَرُ ٣٤',
              transliteration:
                  'Subhanallah 33, Alhamdulillah 33, Allahu Akbar 34',
              meaning: l10n.learningJourneyDhikrAfterSalahInvocationMeaning,
              context: l10n.learningJourneyDhikrAfterSalahInvocationContext,
              sourceReference: 'Sahih Muslim',
            ),
          ],
          showDhikrCounterAction: true,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolSalahHubTitle,
              subtitle: l10n.learningJourneyToolSalahHubSubtitle,
              routeName: 'learnSalahHub',
            ),
          ],
          continueJourneyIds: const ['salah-foundations'],
          relatedJourneyIds: const ['understand-what-you-recite'],
        );
      case 'dhikr-simple-routine':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrRoutineTitle,
          introduction: l10n.learningJourneyDhikrRoutineIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrRoutineSection1Title,
              body: l10n.learningJourneyDhikrRoutineSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrRoutineSection2Title,
              body: l10n.learningJourneyDhikrRoutineSection2Body,
              bullets: [
                l10n.learningJourneyDhikrRoutineBullet1,
                l10n.learningJourneyDhikrRoutineBullet2,
                l10n.learningJourneyDhikrRoutineBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrRoutineTakeaway1,
            l10n.learningJourneyDhikrRoutineTakeaway2,
            l10n.learningJourneyDhikrRoutineTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrRoutineReflection,
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['daily-wisdom', 'beautiful-character'],
          actionStep: l10n.learningJourneyDhikrRoutineActionStep,
          showDhikrCounterAction: true,
        );
      case 'dhikr-istighfar':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrIstighfarTitle,
          introduction: l10n.learningJourneyDhikrIstighfarIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrIstighfarSection1Title,
              body: l10n.learningJourneyDhikrIstighfarSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrIstighfarSection2Title,
              body: l10n.learningJourneyDhikrIstighfarSection2Body,
              bullets: [
                l10n.learningJourneyDhikrIstighfarBullet1,
                l10n.learningJourneyDhikrIstighfarBullet2,
                l10n.learningJourneyDhikrIstighfarBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrIstighfarTakeaway1,
            l10n.learningJourneyDhikrIstighfarTakeaway2,
            l10n.learningJourneyDhikrIstighfarTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrIstighfarReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyDhikrIstighfarInvocationTitle,
              arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
              transliteration: 'Astaghfirullaha wa atubu ilayh',
              meaning: l10n.learningJourneyDhikrIstighfarInvocationMeaning,
              context: l10n.learningJourneyDhikrIstighfarInvocationContext,
              sourceReference: 'Sahih al-Bukhari',
            ),
          ],
          quranReferences: const ['Qur’an 11:3', 'Qur’an 71:10-12'],
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['beautiful-character'],
          showDhikrCounterAction: true,
        );
      case 'dhikr-salawat':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyDhikrSalawatTitle,
          introduction: l10n.learningJourneyDhikrSalawatIntro,
          sections: [
            _section(
              title: l10n.learningJourneyDhikrSalawatSection1Title,
              body: l10n.learningJourneyDhikrSalawatSection1Body,
            ),
            _section(
              title: l10n.learningJourneyDhikrSalawatSection2Title,
              body: l10n.learningJourneyDhikrSalawatSection2Body,
              bullets: [
                l10n.learningJourneyDhikrSalawatBullet1,
                l10n.learningJourneyDhikrSalawatBullet2,
                l10n.learningJourneyDhikrSalawatBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyDhikrSalawatTakeaway1,
            l10n.learningJourneyDhikrSalawatTakeaway2,
            l10n.learningJourneyDhikrSalawatTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyDhikrSalawatReflection,
          invocations: [
            _invocation(
              title: l10n.learningJourneyDhikrSalawatInvocationTitle,
              arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
              transliteration: 'Allahumma salli ala Muhammad',
              meaning: l10n.learningJourneyDhikrSalawatInvocationMeaning,
              context: l10n.learningJourneyDhikrSalawatInvocationContext,
              sourceReference: 'Qur’an 33:56',
            ),
          ],
          quranReferences: const ['Qur’an 33:56'],
          continueJourneyIds: const ['duas-daily-life'],
          relatedJourneyIds: const ['seerah-journey', 'beautiful-character'],
          showDhikrCounterAction: true,
        );
      case 'faith-who-is-allah':
      case 'faith-tawheed':
      case 'faith-names-of-allah-intro':
      case 'faith-angels':
      case 'faith-books':
      case 'faith-prophets':
      case 'faith-day-of-judgment':
      case 'faith-qadr':
      case 'faith-completion':
        return _faithLesson(stageId, l10n);
      case 'fiqh-halal-haram':
      case 'fiqh-cleanliness':
      case 'fiqh-prayer-basics':
      case 'fiqh-fasting-basics':
      case 'fiqh-zakat-basics':
      case 'fiqh-daily-life':
      case 'fiqh-completion':
        return _fiqhLesson(stageId, l10n);
      case 'timeline-early-prophets':
      case 'timeline-prophet-era':
      case 'timeline-khulafa':
      case 'timeline-expansion':
      case 'timeline-golden-age':
      case 'timeline-modern-context':
      case 'timeline-completion':
        return _timelineLesson(stageId, l10n);
      case 'stories-sky-stars':
      case 'stories-ocean':
      case 'stories-mountains':
      case 'stories-animals':
      case 'stories-human-creation':
      case 'stories-day-night':
      case 'stories-completion':
        return _storiesLesson(stageId, l10n);
      case 'words-top':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWordsTopTitle,
          introduction: l10n.learningJourneyWordsTopIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWordsTopSection1Title,
              body: l10n.learningJourneyWordsTopSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWordsTopSection2Title,
              body: l10n.learningJourneyWordsTopSection2Body,
              bullets: [
                l10n.learningJourneyWordsTopBullet1,
                l10n.learningJourneyWordsTopBullet2,
                l10n.learningJourneyWordsTopBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWordsTopTakeaway1,
            l10n.learningJourneyWordsTopTakeaway2,
            l10n.learningJourneyWordsTopTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWordsTopReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolWordsTitle,
              subtitle: l10n.learningJourneyToolWordsSubtitle,
              routeName: 'quranTopWords',
            ),
          ],
          continueJourneyIds: const ['journey-quran'],
          relatedJourneyIds: const ['understand-what-you-recite'],
          reviewSuggestion: l10n.learningJourneyWordsTopReviewSuggestion,
        );
      case 'words-review':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWordsReviewTitle,
          introduction: l10n.learningJourneyWordsReviewIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWordsReviewSection1Title,
              body: l10n.learningJourneyWordsReviewSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWordsReviewSection2Title,
              body: l10n.learningJourneyWordsReviewSection2Body,
              bullets: [
                l10n.learningJourneyWordsReviewBullet1,
                l10n.learningJourneyWordsReviewBullet2,
                l10n.learningJourneyWordsReviewBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWordsReviewTakeaway1,
            l10n.learningJourneyWordsReviewTakeaway2,
            l10n.learningJourneyWordsReviewTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWordsReviewReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolWordReviewTitle,
              subtitle: l10n.learningJourneyToolWordReviewSubtitle,
              routeName: 'quranWordReview',
            ),
          ],
          continueJourneyIds: const ['understand-what-you-recite'],
          relatedJourneyIds: const ['journey-quran'],
          reviewSuggestion: l10n.learningJourneyWordsReviewSuggestion,
        );
      case 'words-patterns':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWordsPatternsTitle,
          introduction: l10n.learningJourneyWordsPatternsIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWordsPatternsSection1Title,
              body: l10n.learningJourneyWordsPatternsSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWordsPatternsSection2Title,
              body: l10n.learningJourneyWordsPatternsSection2Body,
              bullets: [
                l10n.learningJourneyWordsPatternsBullet1,
                l10n.learningJourneyWordsPatternsBullet2,
                l10n.learningJourneyWordsPatternsBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWordsPatternsTakeaway1,
            l10n.learningJourneyWordsPatternsTakeaway2,
            l10n.learningJourneyWordsPatternsTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWordsPatternsReflection,
          relatedTools: [
            _tool(
              title: l10n.learningJourneyToolWordsTitle,
              subtitle: l10n.learningJourneyToolWordsSubtitle,
              routeName: 'quranTopWords',
            ),
            _tool(
              title: l10n.learningJourneyToolWordReviewTitle,
              subtitle: l10n.learningJourneyToolWordReviewSubtitle,
              routeName: 'quranWordReview',
            ),
          ],
          continueJourneyIds: const [
            'journey-quran',
            'understand-what-you-recite',
          ],
          relatedJourneyIds: const ['salah-foundations'],
          actionStep: l10n.learningJourneyWordsPatternsActionStep,
          reviewSuggestion: l10n.learningJourneyWordsPatternsReviewSuggestion,
        );
      case 'wisdom-daily-quote':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWisdomDailyQuoteTitle,
          introduction: l10n.learningJourneyWisdomDailyQuoteIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWisdomDailyQuoteSection1Title,
              body: l10n.learningJourneyWisdomDailyQuoteSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWisdomDailyQuoteSection2Title,
              body: l10n.learningJourneyWisdomDailyQuoteSection2Body,
              bullets: [
                l10n.learningJourneyWisdomDailyQuoteBullet1,
                l10n.learningJourneyWisdomDailyQuoteBullet2,
                l10n.learningJourneyWisdomDailyQuoteBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWisdomDailyQuoteTakeaway1,
            l10n.learningJourneyWisdomDailyQuoteTakeaway2,
            l10n.learningJourneyWisdomDailyQuoteTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWisdomDailyQuoteReflection,
          continueJourneyIds: const ['journey-quran', 'hadith-essentials'],
          relatedJourneyIds: const [
            'seerah-journey',
            'beautiful-character',
            'daily-dhikr',
          ],
        );
      case 'wisdom-short-lesson':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWisdomShortLessonTitle,
          introduction: l10n.learningJourneyWisdomShortLessonIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWisdomShortLessonSection1Title,
              body: l10n.learningJourneyWisdomShortLessonSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWisdomShortLessonSection2Title,
              body: l10n.learningJourneyWisdomShortLessonSection2Body,
              bullets: [
                l10n.learningJourneyWisdomShortLessonBullet1,
                l10n.learningJourneyWisdomShortLessonBullet2,
                l10n.learningJourneyWisdomShortLessonBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWisdomShortLessonTakeaway1,
            l10n.learningJourneyWisdomShortLessonTakeaway2,
            l10n.learningJourneyWisdomShortLessonTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWisdomShortLessonReflection,
          continueJourneyIds: const ['beautiful-character'],
          relatedJourneyIds: const [
            'hadith-essentials',
            'journey-quran',
            'reflection-mode',
          ],
        );
      case 'wisdom-practice':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyWisdomPracticeTitle,
          introduction: l10n.learningJourneyWisdomPracticeIntro,
          sections: [
            _section(
              title: l10n.learningJourneyWisdomPracticeSection1Title,
              body: l10n.learningJourneyWisdomPracticeSection1Body,
            ),
            _section(
              title: l10n.learningJourneyWisdomPracticeSection2Title,
              body: l10n.learningJourneyWisdomPracticeSection2Body,
              bullets: [
                l10n.learningJourneyWisdomPracticeBullet1,
                l10n.learningJourneyWisdomPracticeBullet2,
                l10n.learningJourneyWisdomPracticeBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyWisdomPracticeTakeaway1,
            l10n.learningJourneyWisdomPracticeTakeaway2,
            l10n.learningJourneyWisdomPracticeTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyWisdomPracticeReflection,
          continueJourneyIds: const ['reflection-mode'],
          relatedJourneyIds: const [
            'beautiful-character',
            'daily-dhikr',
            'journey-quran',
          ],
          actionStep: l10n.learningJourneyWisdomPracticeActionStep,
        );
      case 'character-ikhlas':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterIkhlasTitle,
          introduction: l10n.learningJourneyCharacterIkhlasIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterIkhlasSection1Title,
              body: l10n.learningJourneyCharacterIkhlasSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterIkhlasSection2Title,
              body: l10n.learningJourneyCharacterIkhlasSection2Body,
              bullets: [
                l10n.learningJourneyCharacterIkhlasBullet1,
                l10n.learningJourneyCharacterIkhlasBullet2,
                l10n.learningJourneyCharacterIkhlasBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterIkhlasTakeaway1,
            l10n.learningJourneyCharacterIkhlasTakeaway2,
            l10n.learningJourneyCharacterIkhlasTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterIkhlasReflection,
          quranReferences: const ['Qur’an 98:5'],
          continueJourneyIds: const ['hadith-essentials'],
          relatedJourneyIds: const ['daily-wisdom', 'salah-foundations'],
          actionStep: l10n.learningJourneyCharacterIkhlasActionStep,
        );
      case 'character-sabr':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterSabrTitle,
          introduction: l10n.learningJourneyCharacterSabrIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterSabrSection1Title,
              body: l10n.learningJourneyCharacterSabrSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterSabrSection2Title,
              body: l10n.learningJourneyCharacterSabrSection2Body,
              bullets: [
                l10n.learningJourneyCharacterSabrBullet1,
                l10n.learningJourneyCharacterSabrBullet2,
                l10n.learningJourneyCharacterSabrBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterSabrTakeaway1,
            l10n.learningJourneyCharacterSabrTakeaway2,
            l10n.learningJourneyCharacterSabrTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterSabrReflection,
          quranReferences: const ['Qur’an 2:153'],
          continueJourneyIds: const ['daily-dhikr'],
          relatedJourneyIds: const ['seerah-journey', 'daily-wisdom'],
          actionStep: l10n.learningJourneyCharacterSabrActionStep,
        );
      case 'character-shukr':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterShukrTitle,
          introduction: l10n.learningJourneyCharacterShukrIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterShukrSection1Title,
              body: l10n.learningJourneyCharacterShukrSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterShukrSection2Title,
              body: l10n.learningJourneyCharacterShukrSection2Body,
              bullets: [
                l10n.learningJourneyCharacterShukrBullet1,
                l10n.learningJourneyCharacterShukrBullet2,
                l10n.learningJourneyCharacterShukrBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterShukrTakeaway1,
            l10n.learningJourneyCharacterShukrTakeaway2,
            l10n.learningJourneyCharacterShukrTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterShukrReflection,
          quranReferences: const ['Qur’an 14:7'],
          continueJourneyIds: const ['daily-dhikr'],
          relatedJourneyIds: const ['duas-daily-life', 'daily-wisdom'],
          actionStep: l10n.learningJourneyCharacterShukrActionStep,
        );
      case 'character-humility':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterHumilityTitle,
          introduction: l10n.learningJourneyCharacterHumilityIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterHumilitySection1Title,
              body: l10n.learningJourneyCharacterHumilitySection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterHumilitySection2Title,
              body: l10n.learningJourneyCharacterHumilitySection2Body,
              bullets: [
                l10n.learningJourneyCharacterHumilityBullet1,
                l10n.learningJourneyCharacterHumilityBullet2,
                l10n.learningJourneyCharacterHumilityBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterHumilityTakeaway1,
            l10n.learningJourneyCharacterHumilityTakeaway2,
            l10n.learningJourneyCharacterHumilityTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterHumilityReflection,
          quranReferences: const ['Qur’an 25:63'],
          continueJourneyIds: const ['seerah-journey'],
          relatedJourneyIds: const ['prophets-journey', 'daily-wisdom'],
          actionStep: l10n.learningJourneyCharacterHumilityActionStep,
        );
      case 'character-forgiveness':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterForgivenessTitle,
          introduction: l10n.learningJourneyCharacterForgivenessIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterForgivenessSection1Title,
              body: l10n.learningJourneyCharacterForgivenessSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterForgivenessSection2Title,
              body: l10n.learningJourneyCharacterForgivenessSection2Body,
              bullets: [
                l10n.learningJourneyCharacterForgivenessBullet1,
                l10n.learningJourneyCharacterForgivenessBullet2,
                l10n.learningJourneyCharacterForgivenessBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterForgivenessTakeaway1,
            l10n.learningJourneyCharacterForgivenessTakeaway2,
            l10n.learningJourneyCharacterForgivenessTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterForgivenessReflection,
          quranReferences: const ['Qur’an 24:22'],
          continueJourneyIds: const ['hadith-essentials'],
          relatedJourneyIds: const ['seerah-journey', 'daily-wisdom'],
          actionStep: l10n.learningJourneyCharacterForgivenessActionStep,
        );
      case 'character-anger':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterAngerTitle,
          introduction: l10n.learningJourneyCharacterAngerIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterAngerSection1Title,
              body: l10n.learningJourneyCharacterAngerSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterAngerSection2Title,
              body: l10n.learningJourneyCharacterAngerSection2Body,
              bullets: [
                l10n.learningJourneyCharacterAngerBullet1,
                l10n.learningJourneyCharacterAngerBullet2,
                l10n.learningJourneyCharacterAngerBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterAngerTakeaway1,
            l10n.learningJourneyCharacterAngerTakeaway2,
            l10n.learningJourneyCharacterAngerTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterAngerReflection,
          sourceReferences: const ['Sahih al-Bukhari'],
          continueJourneyIds: const ['daily-dhikr'],
          relatedJourneyIds: const ['hadith-essentials', 'beautiful-character'],
          actionStep: l10n.learningJourneyCharacterAngerActionStep,
        );
      case 'character-kindness':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterKindnessTitle,
          introduction: l10n.learningJourneyCharacterKindnessIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterKindnessSection1Title,
              body: l10n.learningJourneyCharacterKindnessSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterKindnessSection2Title,
              body: l10n.learningJourneyCharacterKindnessSection2Body,
              bullets: [
                l10n.learningJourneyCharacterKindnessBullet1,
                l10n.learningJourneyCharacterKindnessBullet2,
                l10n.learningJourneyCharacterKindnessBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterKindnessTakeaway1,
            l10n.learningJourneyCharacterKindnessTakeaway2,
            l10n.learningJourneyCharacterKindnessTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterKindnessReflection,
          quranReferences: const ['Qur’an 16:90'],
          continueJourneyIds: const ['daily-wisdom'],
          relatedJourneyIds: const ['seerah-journey', 'hadith-essentials'],
          actionStep: l10n.learningJourneyCharacterKindnessActionStep,
        );
      case 'character-completion':
        return _lesson(
          stageId: stageId,
          title: l10n.learningJourneyCharacterCompletionTitle,
          introduction: l10n.learningJourneyCharacterCompletionIntro,
          sections: [
            _section(
              title: l10n.learningJourneyCharacterCompletionSection1Title,
              body: l10n.learningJourneyCharacterCompletionSection1Body,
            ),
            _section(
              title: l10n.learningJourneyCharacterCompletionSection2Title,
              body: l10n.learningJourneyCharacterCompletionSection2Body,
              bullets: [
                l10n.learningJourneyCharacterCompletionBullet1,
                l10n.learningJourneyCharacterCompletionBullet2,
                l10n.learningJourneyCharacterCompletionBullet3,
              ],
            ),
          ],
          keyTakeaways: [
            l10n.learningJourneyCharacterCompletionTakeaway1,
            l10n.learningJourneyCharacterCompletionTakeaway2,
            l10n.learningJourneyCharacterCompletionTakeaway3,
          ],
          reflectionPrompt: l10n.learningJourneyCharacterCompletionReflection,
          continueJourneyIds: const ['daily-wisdom', 'reflection-mode'],
          relatedJourneyIds: const ['seerah-journey', 'hadith-essentials'],
          actionStep: l10n.learningJourneyCharacterCompletionActionStep,
        );
      case 'hadith-essential-collection':
      case 'hadith-themes':
      case 'hadith-review':
        return _hadithEssentialsLesson(stageId, l10n);
      case 'salah-hub':
      case 'salah-guided-fajr':
      case 'salah-detail-fajr':
      case 'salah-words-meaning':
      case 'salah-khushu-consistency':
      case 'salah-completion':
        return _salahFoundationsLesson(stageId, l10n);
      case 'wudu-guide':
      case 'wudu-trainer':
      case 'wudu-what-breaks':
      case 'wudu-common-mistakes':
      case 'wudu-completion':
        return _wuduJourneyLesson(stageId, l10n);
      case 'alphabet-open':
      case 'alphabet-repeat':
      case 'alphabet-review':
        return _arabicAlphabetLesson(stageId, l10n);
      case 'reading-basics-kasra':
      case 'reading-basics-damma':
      case 'reading-basics-sukun':
      case 'reading-basics-shaddah':
        return _readingBasicsExtendedLesson(stageId, l10n);
      case 'trivia-paths':
      case 'trivia-session':
      case 'trivia-review':
        return _triviaKnowledgeLesson(stageId, l10n);
      case 'ramadan-intention':
      case 'ramadan-why-fast':
      case 'ramadan-daily-rhythm':
      case 'ramadan-what-breaks-fast':
      case 'ramadan-laylat-al-qadr':
      case 'ramadan-reflection':
      case 'ramadan-common-mistakes':
        return _ramadanFoundationsLesson(stageId, l10n);
      case 'islam-what-is-islam':
      case 'islam-who-is-allah':
      case 'islam-five-pillars':
      case 'islam-first-steps':
      case 'islam-foundations-completion':
        return _islamFoundationsLesson(stageId, l10n);
      case 'daily-routines-start-day':
      case 'daily-routines-prayer-anchor':
      case 'daily-routines-quran-anchor':
      case 'daily-routines-evening-reset':
      case 'daily-routines-habit-building':
      case 'daily-routines-completion':
        return _dailyRoutinesLesson(stageId, l10n);
      default:
        return null;
    }
  }
}

LearningJourneyLessonContent _islamFoundationsLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'islam-what-is-islam':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageIslamWhatIsIslamTitle,
        intro: l10n.learningJourneyIslamWhatIsIslamIntro,
        section1Title: l10n.learningJourneyIslamSection1Title,
        section1Body: l10n.learningJourneyIslamWhatIsIslamSection1Body,
        section2Title: l10n.learningJourneyIslamSection2Title,
        section2Body: l10n.learningJourneyIslamWhatIsIslamSection2Body,
        takeaway1: l10n.learningJourneyIslamWhatIsIslamTakeaway1,
        takeaway2: l10n.learningJourneyIslamWhatIsIslamTakeaway2,
        takeaway3: l10n.learningJourneyIslamWhatIsIslamTakeaway3,
        reflection: l10n.learningJourneyIslamWhatIsIslamReflection,
        quranReferences: const ['Qur’an 51:56', 'Qur’an 2:208'],
        continueJourneyIds: const ['foundations-of-faith'],
      );
    case 'islam-who-is-allah':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageIslamWhoIsAllahTitle,
        intro: l10n.learningJourneyIslamWhoIsAllahIntro,
        section1Title: l10n.learningJourneyIslamSection1Title,
        section1Body: l10n.learningJourneyIslamWhoIsAllahSection1Body,
        section2Title: l10n.learningJourneyIslamSection2Title,
        section2Body: l10n.learningJourneyIslamWhoIsAllahSection2Body,
        takeaway1: l10n.learningJourneyIslamWhoIsAllahTakeaway1,
        takeaway2: l10n.learningJourneyIslamWhoIsAllahTakeaway2,
        takeaway3: l10n.learningJourneyIslamWhoIsAllahTakeaway3,
        reflection: l10n.learningJourneyIslamWhoIsAllahReflection,
        quranReferences: const ['Qur’an 112:1-4', 'Qur’an 2:255'],
        continueJourneyIds: const ['foundations-of-faith'],
      );
    case 'islam-five-pillars':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageIslamFivePillarsTitle,
        intro: l10n.learningJourneyIslamFivePillarsIntro,
        section1Title: l10n.learningJourneyIslamSection1Title,
        section1Body: l10n.learningJourneyIslamFivePillarsSection1Body,
        section2Title: l10n.learningJourneyIslamSection2Title,
        section2Body: l10n.learningJourneyIslamFivePillarsSection2Body,
        takeaway1: l10n.learningJourneyIslamFivePillarsTakeaway1,
        takeaway2: l10n.learningJourneyIslamFivePillarsTakeaway2,
        takeaway3: l10n.learningJourneyIslamFivePillarsTakeaway3,
        reflection: l10n.learningJourneyIslamFivePillarsReflection,
        quranReferences: const ['Qur’an 2:43', 'Qur’an 22:27', 'Qur’an 2:183'],
        continueJourneyIds: const ['salah-foundations', 'journey-of-wudu'],
      );
    case 'islam-first-steps':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageIslamFirstStepsTitle,
        intro: l10n.learningJourneyIslamFirstStepsIntro,
        section1Title: l10n.learningJourneyIslamSection1Title,
        section1Body: l10n.learningJourneyIslamFirstStepsSection1Body,
        section2Title: l10n.learningJourneyIslamSection2Title,
        section2Body: l10n.learningJourneyIslamFirstStepsSection2Body,
        takeaway1: l10n.learningJourneyIslamFirstStepsTakeaway1,
        takeaway2: l10n.learningJourneyIslamFirstStepsTakeaway2,
        takeaway3: l10n.learningJourneyIslamFirstStepsTakeaway3,
        reflection: l10n.learningJourneyIslamFirstStepsReflection,
        continueJourneyIds: const ['salah-foundations', 'duas-daily-life'],
        relatedJourneyIds: const ['beautiful-character'],
      );
    case 'islam-foundations-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageIslamCompletionTitle,
        intro: l10n.learningJourneyIslamCompletionIntro,
        section1Title: l10n.learningJourneyIslamCompletionSection1Title,
        section1Body: l10n.learningJourneyIslamCompletionSection1Body,
        section2Title: l10n.learningJourneyIslamCompletionSection2Title,
        section2Body: l10n.learningJourneyIslamCompletionSection2Body,
        takeaway1: l10n.learningJourneyIslamCompletionTakeaway1,
        takeaway2: l10n.learningJourneyIslamCompletionTakeaway2,
        takeaway3: l10n.learningJourneyIslamCompletionTakeaway3,
        reflection: l10n.learningJourneyIslamCompletionReflection,
        continueJourneyIds: const [
          'salah-foundations',
          'understanding-al-fatihah',
        ],
        relatedJourneyIds: const ['beautiful-character', 'prophets-journey'],
        actionStep: l10n.learningJourneyIslamCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported Islam foundations stage: $stageId');
  }
}

LearningJourneyLessonContent _dailyRoutinesLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'daily-routines-start-day':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesStartDayTitle,
        intro: l10n.learningJourneyDailyRoutinesStartDayIntro,
        section1Title: l10n.learningJourneyDailyRoutinesSection1Title,
        section1Body: l10n.learningJourneyDailyRoutinesStartDaySection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesSection2Title,
        section2Body: l10n.learningJourneyDailyRoutinesStartDaySection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesStartDayTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesStartDayTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesStartDayTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesStartDayReflection,
        quranReferences: const ['Qur’an 17:78', 'Qur’an 73:20'],
        continueJourneyIds: const ['daily-dhikr'],
      );
    case 'daily-routines-prayer-anchor':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesPrayerAnchorTitle,
        intro: l10n.learningJourneyDailyRoutinesPrayerAnchorIntro,
        section1Title: l10n.learningJourneyDailyRoutinesSection1Title,
        section1Body: l10n.learningJourneyDailyRoutinesPrayerAnchorSection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesSection2Title,
        section2Body: l10n.learningJourneyDailyRoutinesPrayerAnchorSection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesPrayerAnchorTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesPrayerAnchorTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesPrayerAnchorTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesPrayerAnchorReflection,
        quranReferences: const ['Qur’an 20:14', 'Qur’an 29:45'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
        continueJourneyIds: const ['salah-foundations'],
      );
    case 'daily-routines-quran-anchor':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesQuranAnchorTitle,
        intro: l10n.learningJourneyDailyRoutinesQuranAnchorIntro,
        section1Title: l10n.learningJourneyDailyRoutinesSection1Title,
        section1Body: l10n.learningJourneyDailyRoutinesQuranAnchorSection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesSection2Title,
        section2Body: l10n.learningJourneyDailyRoutinesQuranAnchorSection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesQuranAnchorTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesQuranAnchorTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesQuranAnchorTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesQuranAnchorReflection,
        quranReferences: const ['Qur’an 38:29', 'Qur’an 73:4'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranReaderTitle,
            subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
            routeName: 'quranReader',
            pathParameters: const {'surahNumber': '1'},
          ),
        ],
        continueJourneyIds: const ['journey-quran', 'understanding-al-fatihah'],
      );
    case 'daily-routines-evening-reset':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesEveningResetTitle,
        intro: l10n.learningJourneyDailyRoutinesEveningResetIntro,
        section1Title: l10n.learningJourneyDailyRoutinesSection1Title,
        section1Body: l10n.learningJourneyDailyRoutinesEveningResetSection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesSection2Title,
        section2Body: l10n.learningJourneyDailyRoutinesEveningResetSection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesEveningResetTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesEveningResetTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesEveningResetTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesEveningResetReflection,
        quranReferences: const ['Qur’an 33:41-42', 'Qur’an 24:58'],
        continueJourneyIds: const ['daily-dhikr', 'duas-daily-life'],
      );
    case 'daily-routines-habit-building':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesHabitBuildingTitle,
        intro: l10n.learningJourneyDailyRoutinesHabitBuildingIntro,
        section1Title: l10n.learningJourneyDailyRoutinesSection1Title,
        section1Body:
            l10n.learningJourneyDailyRoutinesHabitBuildingSection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesSection2Title,
        section2Body:
            l10n.learningJourneyDailyRoutinesHabitBuildingSection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesHabitBuildingTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesHabitBuildingTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesHabitBuildingTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesHabitBuildingReflection,
        continueJourneyIds: const ['daily-dhikr'],
        relatedJourneyIds: const ['beautiful-character'],
      );
    case 'daily-routines-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageDailyRoutinesCompletionTitle,
        intro: l10n.learningJourneyDailyRoutinesCompletionIntro,
        section1Title: l10n.learningJourneyDailyRoutinesCompletionSection1Title,
        section1Body: l10n.learningJourneyDailyRoutinesCompletionSection1Body,
        section2Title: l10n.learningJourneyDailyRoutinesCompletionSection2Title,
        section2Body: l10n.learningJourneyDailyRoutinesCompletionSection2Body,
        takeaway1: l10n.learningJourneyDailyRoutinesCompletionTakeaway1,
        takeaway2: l10n.learningJourneyDailyRoutinesCompletionTakeaway2,
        takeaway3: l10n.learningJourneyDailyRoutinesCompletionTakeaway3,
        reflection: l10n.learningJourneyDailyRoutinesCompletionReflection,
        continueJourneyIds: const [
          'ramadan-foundations',
          'beautiful-character',
        ],
        relatedJourneyIds: const ['journey-quran', 'daily-dhikr'],
        actionStep: l10n.learningJourneyDailyRoutinesCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported daily routines stage: $stageId');
  }
}

LearningJourneyLessonContent _faithLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'faith-who-is-allah':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithWhoIsAllahTitle,
        intro: l10n.learningJourneyFaithWhoIsAllahIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithWhoIsAllahSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithWhoIsAllahSection2Body,
        takeaway1: l10n.learningJourneyFaithWhoIsAllahTakeaway1,
        takeaway2: l10n.learningJourneyFaithWhoIsAllahTakeaway2,
        takeaway3: l10n.learningJourneyFaithWhoIsAllahTakeaway3,
        reflection: l10n.learningJourneyFaithWhoIsAllahReflection,
        quranReferences: const ['Qur’an 112:1-4', 'Qur’an 2:255'],
        continueJourneyIds: const ['journey-quran'],
      );
    case 'faith-tawheed':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithTawheedTitle,
        intro: l10n.learningJourneyFaithTawheedIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithTawheedSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithTawheedSection2Body,
        takeaway1: l10n.learningJourneyFaithTawheedTakeaway1,
        takeaway2: l10n.learningJourneyFaithTawheedTakeaway2,
        takeaway3: l10n.learningJourneyFaithTawheedTakeaway3,
        reflection: l10n.learningJourneyFaithTawheedReflection,
        quranReferences: const ['Qur’an 51:56', 'Qur’an 1:5'],
        continueJourneyIds: const ['journey-quran'],
      );
    case 'faith-names-of-allah-intro':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithNamesTitle,
        intro: l10n.learningJourneyFaithNamesIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithNamesSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithNamesSection2Body,
        takeaway1: l10n.learningJourneyFaithNamesTakeaway1,
        takeaway2: l10n.learningJourneyFaithNamesTakeaway2,
        takeaway3: l10n.learningJourneyFaithNamesTakeaway3,
        reflection: l10n.learningJourneyFaithNamesReflection,
        quranReferences: const ['Qur’an 7:180'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolNamesOfAllahTitle,
            subtitle: l10n.learningJourneyToolNamesOfAllahSubtitle,
            routeName: 'quranNamesOfAllah',
          ),
        ],
      );
    case 'faith-angels':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithAngelsTitle,
        intro: l10n.learningJourneyFaithAngelsIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithAngelsSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithAngelsSection2Body,
        takeaway1: l10n.learningJourneyFaithAngelsTakeaway1,
        takeaway2: l10n.learningJourneyFaithAngelsTakeaway2,
        takeaway3: l10n.learningJourneyFaithAngelsTakeaway3,
        reflection: l10n.learningJourneyFaithAngelsReflection,
        quranReferences: const ['Qur’an 66:6', 'Qur’an 35:1'],
      );
    case 'faith-books':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithBooksTitle,
        intro: l10n.learningJourneyFaithBooksIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithBooksSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithBooksSection2Body,
        takeaway1: l10n.learningJourneyFaithBooksTakeaway1,
        takeaway2: l10n.learningJourneyFaithBooksTakeaway2,
        takeaway3: l10n.learningJourneyFaithBooksTakeaway3,
        reflection: l10n.learningJourneyFaithBooksReflection,
        quranReferences: const ['Qur’an 2:2', 'Qur’an 4:136'],
        continueJourneyIds: const ['journey-quran'],
      );
    case 'faith-prophets':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithProphetsTitle,
        intro: l10n.learningJourneyFaithProphetsIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithProphetsSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithProphetsSection2Body,
        takeaway1: l10n.learningJourneyFaithProphetsTakeaway1,
        takeaway2: l10n.learningJourneyFaithProphetsTakeaway2,
        takeaway3: l10n.learningJourneyFaithProphetsTakeaway3,
        reflection: l10n.learningJourneyFaithProphetsReflection,
        quranReferences: const ['Qur’an 4:165', 'Qur’an 33:21'],
        continueJourneyIds: const ['prophets-journey'],
        relatedJourneyIds: const ['seerah-journey', 'beautiful-character'],
      );
    case 'faith-day-of-judgment':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithJudgmentTitle,
        intro: l10n.learningJourneyFaithJudgmentIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithJudgmentSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithJudgmentSection2Body,
        takeaway1: l10n.learningJourneyFaithJudgmentTakeaway1,
        takeaway2: l10n.learningJourneyFaithJudgmentTakeaway2,
        takeaway3: l10n.learningJourneyFaithJudgmentTakeaway3,
        reflection: l10n.learningJourneyFaithJudgmentReflection,
        quranReferences: const ['Qur’an 99:6-8', 'Qur’an 101:6-11'],
      );
    case 'faith-qadr':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyFaithQadrTitle,
        intro: l10n.learningJourneyFaithQadrIntro,
        section1Title: l10n.learningJourneyFaithSection1Title,
        section1Body: l10n.learningJourneyFaithQadrSection1Body,
        section2Title: l10n.learningJourneyFaithSection2Title,
        section2Body: l10n.learningJourneyFaithQadrSection2Body,
        takeaway1: l10n.learningJourneyFaithQadrTakeaway1,
        takeaway2: l10n.learningJourneyFaithQadrTakeaway2,
        takeaway3: l10n.learningJourneyFaithQadrTakeaway3,
        reflection: l10n.learningJourneyFaithQadrReflection,
        quranReferences: const ['Qur’an 57:22-23', 'Qur’an 54:49'],
      );
    case 'faith-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFaithCompletionTitle,
        intro: l10n.learningJourneyFaithCompletionIntro,
        section1Title: l10n.learningJourneyFaithCompletionSection1Title,
        section1Body: l10n.learningJourneyFaithCompletionSection1Body,
        section2Title: l10n.learningJourneyFaithCompletionSection2Title,
        section2Body: l10n.learningJourneyFaithCompletionSection2Body,
        takeaway1: l10n.learningJourneyFaithCompletionTakeaway1,
        takeaway2: l10n.learningJourneyFaithCompletionTakeaway2,
        takeaway3: l10n.learningJourneyFaithCompletionTakeaway3,
        reflection: l10n.learningJourneyFaithCompletionReflection,
        continueJourneyIds: const ['journey-quran', 'beautiful-character'],
        relatedJourneyIds: const ['timeline-of-islam'],
        actionStep: l10n.learningJourneyFaithCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported faith stage: $stageId');
  }
}

LearningJourneyLessonContent _fiqhLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'fiqh-halal-haram':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhHalalTitle,
        intro: l10n.learningJourneyFiqhHalalIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhHalalSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhHalalSection2Body,
        takeaway1: l10n.learningJourneyFiqhHalalTakeaway1,
        takeaway2: l10n.learningJourneyFiqhHalalTakeaway2,
        takeaway3: l10n.learningJourneyFiqhHalalTakeaway3,
        reflection: l10n.learningJourneyFiqhHalalReflection,
      );
    case 'fiqh-cleanliness':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhCleanlinessTitle,
        intro: l10n.learningJourneyFiqhCleanlinessIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhCleanlinessSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhCleanlinessSection2Body,
        takeaway1: l10n.learningJourneyFiqhCleanlinessTakeaway1,
        takeaway2: l10n.learningJourneyFiqhCleanlinessTakeaway2,
        takeaway3: l10n.learningJourneyFiqhCleanlinessTakeaway3,
        reflection: l10n.learningJourneyFiqhCleanlinessReflection,
        continueJourneyIds: const ['journey-of-wudu'],
      );
    case 'fiqh-prayer-basics':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhPrayerTitle,
        intro: l10n.learningJourneyFiqhPrayerIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhPrayerSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhPrayerSection2Body,
        takeaway1: l10n.learningJourneyFiqhPrayerTakeaway1,
        takeaway2: l10n.learningJourneyFiqhPrayerTakeaway2,
        takeaway3: l10n.learningJourneyFiqhPrayerTakeaway3,
        reflection: l10n.learningJourneyFiqhPrayerReflection,
        continueJourneyIds: const ['salah-foundations'],
      );
    case 'fiqh-fasting-basics':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhFastingTitle,
        intro: l10n.learningJourneyFiqhFastingIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhFastingSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhFastingSection2Body,
        takeaway1: l10n.learningJourneyFiqhFastingTakeaway1,
        takeaway2: l10n.learningJourneyFiqhFastingTakeaway2,
        takeaway3: l10n.learningJourneyFiqhFastingTakeaway3,
        reflection: l10n.learningJourneyFiqhFastingReflection,
        continueJourneyIds: const ['ramadan-foundations'],
      );
    case 'fiqh-zakat-basics':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhZakatTitle,
        intro: l10n.learningJourneyFiqhZakatIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhZakatSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhZakatSection2Body,
        takeaway1: l10n.learningJourneyFiqhZakatTakeaway1,
        takeaway2: l10n.learningJourneyFiqhZakatTakeaway2,
        takeaway3: l10n.learningJourneyFiqhZakatTakeaway3,
        reflection: l10n.learningJourneyFiqhZakatReflection,
      );
    case 'fiqh-daily-life':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhDailyLifeTitle,
        intro: l10n.learningJourneyFiqhDailyLifeIntro,
        section1Title: l10n.learningJourneyFiqhSection1Title,
        section1Body: l10n.learningJourneyFiqhDailyLifeSection1Body,
        section2Title: l10n.learningJourneyFiqhSection2Title,
        section2Body: l10n.learningJourneyFiqhDailyLifeSection2Body,
        takeaway1: l10n.learningJourneyFiqhDailyLifeTakeaway1,
        takeaway2: l10n.learningJourneyFiqhDailyLifeTakeaway2,
        takeaway3: l10n.learningJourneyFiqhDailyLifeTakeaway3,
        reflection: l10n.learningJourneyFiqhDailyLifeReflection,
      );
    case 'fiqh-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFiqhCompletionTitle,
        intro: l10n.learningJourneyFiqhCompletionIntro,
        section1Title: l10n.learningJourneyFiqhCompletionSection1Title,
        section1Body: l10n.learningJourneyFiqhCompletionSection1Body,
        section2Title: l10n.learningJourneyFiqhCompletionSection2Title,
        section2Body: l10n.learningJourneyFiqhCompletionSection2Body,
        takeaway1: l10n.learningJourneyFiqhCompletionTakeaway1,
        takeaway2: l10n.learningJourneyFiqhCompletionTakeaway2,
        takeaway3: l10n.learningJourneyFiqhCompletionTakeaway3,
        reflection: l10n.learningJourneyFiqhCompletionReflection,
        continueJourneyIds: const ['salah-foundations', 'ramadan-foundations'],
        relatedJourneyIds: const ['journey-of-wudu'],
        actionStep: l10n.learningJourneyFiqhCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported fiqh stage: $stageId');
  }
}

LearningJourneyLessonContent _timelineLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'timeline-early-prophets':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineEarlyProphetsTitle,
        intro: l10n.learningJourneyTimelineEarlyProphetsIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineEarlyProphetsSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineEarlyProphetsSection2Body,
        takeaway1: l10n.learningJourneyTimelineEarlyProphetsTakeaway1,
        takeaway2: l10n.learningJourneyTimelineEarlyProphetsTakeaway2,
        takeaway3: l10n.learningJourneyTimelineEarlyProphetsTakeaway3,
        reflection: l10n.learningJourneyTimelineEarlyProphetsReflection,
        continueJourneyIds: const ['prophets-journey'],
      );
    case 'timeline-prophet-era':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineProphetEraTitle,
        intro: l10n.learningJourneyTimelineProphetEraIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineProphetEraSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineProphetEraSection2Body,
        takeaway1: l10n.learningJourneyTimelineProphetEraTakeaway1,
        takeaway2: l10n.learningJourneyTimelineProphetEraTakeaway2,
        takeaway3: l10n.learningJourneyTimelineProphetEraTakeaway3,
        reflection: l10n.learningJourneyTimelineProphetEraReflection,
        continueJourneyIds: const ['seerah-journey'],
      );
    case 'timeline-khulafa':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineKhulafaTitle,
        intro: l10n.learningJourneyTimelineKhulafaIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineKhulafaSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineKhulafaSection2Body,
        takeaway1: l10n.learningJourneyTimelineKhulafaTakeaway1,
        takeaway2: l10n.learningJourneyTimelineKhulafaTakeaway2,
        takeaway3: l10n.learningJourneyTimelineKhulafaTakeaway3,
        reflection: l10n.learningJourneyTimelineKhulafaReflection,
      );
    case 'timeline-expansion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineExpansionTitle,
        intro: l10n.learningJourneyTimelineExpansionIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineExpansionSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineExpansionSection2Body,
        takeaway1: l10n.learningJourneyTimelineExpansionTakeaway1,
        takeaway2: l10n.learningJourneyTimelineExpansionTakeaway2,
        takeaway3: l10n.learningJourneyTimelineExpansionTakeaway3,
        reflection: l10n.learningJourneyTimelineExpansionReflection,
      );
    case 'timeline-golden-age':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineGoldenAgeTitle,
        intro: l10n.learningJourneyTimelineGoldenAgeIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineGoldenAgeSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineGoldenAgeSection2Body,
        takeaway1: l10n.learningJourneyTimelineGoldenAgeTakeaway1,
        takeaway2: l10n.learningJourneyTimelineGoldenAgeTakeaway2,
        takeaway3: l10n.learningJourneyTimelineGoldenAgeTakeaway3,
        reflection: l10n.learningJourneyTimelineGoldenAgeReflection,
      );
    case 'timeline-modern-context':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineModernTitle,
        intro: l10n.learningJourneyTimelineModernIntro,
        section1Title: l10n.learningJourneyTimelineSection1Title,
        section1Body: l10n.learningJourneyTimelineModernSection1Body,
        section2Title: l10n.learningJourneyTimelineSection2Title,
        section2Body: l10n.learningJourneyTimelineModernSection2Body,
        takeaway1: l10n.learningJourneyTimelineModernTakeaway1,
        takeaway2: l10n.learningJourneyTimelineModernTakeaway2,
        takeaway3: l10n.learningJourneyTimelineModernTakeaway3,
        reflection: l10n.learningJourneyTimelineModernReflection,
      );
    case 'timeline-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTimelineCompletionTitle,
        intro: l10n.learningJourneyTimelineCompletionIntro,
        section1Title: l10n.learningJourneyTimelineCompletionSection1Title,
        section1Body: l10n.learningJourneyTimelineCompletionSection1Body,
        section2Title: l10n.learningJourneyTimelineCompletionSection2Title,
        section2Body: l10n.learningJourneyTimelineCompletionSection2Body,
        takeaway1: l10n.learningJourneyTimelineCompletionTakeaway1,
        takeaway2: l10n.learningJourneyTimelineCompletionTakeaway2,
        takeaway3: l10n.learningJourneyTimelineCompletionTakeaway3,
        reflection: l10n.learningJourneyTimelineCompletionReflection,
        continueJourneyIds: const ['seerah-journey', 'prophets-journey'],
        relatedJourneyIds: const ['journey-quran'],
        actionStep: l10n.learningJourneyTimelineCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported timeline stage: $stageId');
  }
}

LearningJourneyLessonContent _storiesLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'stories-sky-stars':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesSkyTitle,
        intro: l10n.learningJourneyStoriesSkyIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesSkySection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesSkySection2Body,
        takeaway1: l10n.learningJourneyStoriesSkyTakeaway1,
        takeaway2: l10n.learningJourneyStoriesSkyTakeaway2,
        takeaway3: l10n.learningJourneyStoriesSkyTakeaway3,
        reflection: l10n.learningJourneyStoriesSkyReflection,
        quranReferences: const ['Qur’an 67:3-4', 'Qur’an 16:12'],
      );
    case 'stories-ocean':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesOceanTitle,
        intro: l10n.learningJourneyStoriesOceanIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesOceanSection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesOceanSection2Body,
        takeaway1: l10n.learningJourneyStoriesOceanTakeaway1,
        takeaway2: l10n.learningJourneyStoriesOceanTakeaway2,
        takeaway3: l10n.learningJourneyStoriesOceanTakeaway3,
        reflection: l10n.learningJourneyStoriesOceanReflection,
        quranReferences: const ['Qur’an 16:14', 'Qur’an 31:31'],
      );
    case 'stories-mountains':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesMountainsTitle,
        intro: l10n.learningJourneyStoriesMountainsIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesMountainsSection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesMountainsSection2Body,
        takeaway1: l10n.learningJourneyStoriesMountainsTakeaway1,
        takeaway2: l10n.learningJourneyStoriesMountainsTakeaway2,
        takeaway3: l10n.learningJourneyStoriesMountainsTakeaway3,
        reflection: l10n.learningJourneyStoriesMountainsReflection,
        quranReferences: const ['Qur’an 78:6-7', 'Qur’an 21:31'],
      );
    case 'stories-animals':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesAnimalsTitle,
        intro: l10n.learningJourneyStoriesAnimalsIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesAnimalsSection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesAnimalsSection2Body,
        takeaway1: l10n.learningJourneyStoriesAnimalsTakeaway1,
        takeaway2: l10n.learningJourneyStoriesAnimalsTakeaway2,
        takeaway3: l10n.learningJourneyStoriesAnimalsTakeaway3,
        reflection: l10n.learningJourneyStoriesAnimalsReflection,
        quranReferences: const ['Qur’an 16:5-8', 'Qur’an 24:41'],
      );
    case 'stories-human-creation':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesHumanCreationTitle,
        intro: l10n.learningJourneyStoriesHumanCreationIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesHumanCreationSection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesHumanCreationSection2Body,
        takeaway1: l10n.learningJourneyStoriesHumanCreationTakeaway1,
        takeaway2: l10n.learningJourneyStoriesHumanCreationTakeaway2,
        takeaway3: l10n.learningJourneyStoriesHumanCreationTakeaway3,
        reflection: l10n.learningJourneyStoriesHumanCreationReflection,
        quranReferences: const ['Qur’an 23:12-14', 'Qur’an 51:21'],
      );
    case 'stories-day-night':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesDayNightTitle,
        intro: l10n.learningJourneyStoriesDayNightIntro,
        section1Title: l10n.learningJourneyStoriesSection1Title,
        section1Body: l10n.learningJourneyStoriesDayNightSection1Body,
        section2Title: l10n.learningJourneyStoriesSection2Title,
        section2Body: l10n.learningJourneyStoriesDayNightSection2Body,
        takeaway1: l10n.learningJourneyStoriesDayNightTakeaway1,
        takeaway2: l10n.learningJourneyStoriesDayNightTakeaway2,
        takeaway3: l10n.learningJourneyStoriesDayNightTakeaway3,
        reflection: l10n.learningJourneyStoriesDayNightReflection,
        quranReferences: const ['Qur’an 25:62', 'Qur’an 3:190'],
      );
    case 'stories-completion':
      return _compactLesson(
        stageId: stageId,
        title: l10n.learningJourneyStageStoriesCompletionTitle,
        intro: l10n.learningJourneyStoriesCompletionIntro,
        section1Title: l10n.learningJourneyStoriesCompletionSection1Title,
        section1Body: l10n.learningJourneyStoriesCompletionSection1Body,
        section2Title: l10n.learningJourneyStoriesCompletionSection2Title,
        section2Body: l10n.learningJourneyStoriesCompletionSection2Body,
        takeaway1: l10n.learningJourneyStoriesCompletionTakeaway1,
        takeaway2: l10n.learningJourneyStoriesCompletionTakeaway2,
        takeaway3: l10n.learningJourneyStoriesCompletionTakeaway3,
        reflection: l10n.learningJourneyStoriesCompletionReflection,
        continueJourneyIds: const ['journey-quran', 'reflection-mode'],
        relatedJourneyIds: const ['prophets-journey'],
        actionStep: l10n.learningJourneyStoriesCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported stories stage: $stageId');
  }
}

LearningJourneyLessonContent _hadithEssentialsLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'hadith-essential-collection':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageHadithEssentialCollectionTitle,
        introduction: l10n.learningJourneyHadithEssentialCollectionLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyHadithEssentialCollectionSection1Title,
            body: l10n.learningJourneyHadithEssentialCollectionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyHadithEssentialCollectionSection2Title,
            body: l10n.learningJourneyHadithEssentialCollectionSection2Body,
            bullets: [
              l10n.learningJourneyHadithEssentialCollectionBullet1,
              l10n.learningJourneyHadithEssentialCollectionBullet2,
              l10n.learningJourneyHadithEssentialCollectionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyHadithEssentialCollectionTakeaway1,
          l10n.learningJourneyHadithEssentialCollectionTakeaway2,
          l10n.learningJourneyHadithEssentialCollectionTakeaway3,
        ],
        reflectionPrompt:
            l10n.learningJourneyHadithEssentialCollectionReflection,
        quranReferences: const ['Qur’an 59:7', 'Qur’an 33:21'],
        sourceReferences: const ['Sahih Muslim, Introduction'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolEssentialHadithTitle,
            subtitle: l10n.learningJourneyToolEssentialHadithSubtitle,
            routeName: 'learnHadithImportant',
          ),
          _tool(
            title: l10n.learningJourneyToolHadithHubTitle,
            subtitle: l10n.learningJourneyToolHadithHubSubtitle,
            routeName: 'learnHadithLanding',
          ),
        ],
        continueJourneyIds: const ['beautiful-character'],
        relatedJourneyIds: const ['daily-wisdom'],
        actionStep: l10n.learningJourneyHadithEssentialCollectionActionStep,
      );
    case 'hadith-themes':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageHadithThemesTitle,
        introduction: l10n.learningJourneyHadithThemesLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyHadithThemesSection1Title,
            body: l10n.learningJourneyHadithThemesSection1Body,
          ),
          _section(
            title: l10n.learningJourneyHadithThemesSection2Title,
            body: l10n.learningJourneyHadithThemesSection2Body,
            bullets: [
              l10n.learningJourneyHadithThemesBullet1,
              l10n.learningJourneyHadithThemesBullet2,
              l10n.learningJourneyHadithThemesBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyHadithThemesTakeaway1,
          l10n.learningJourneyHadithThemesTakeaway2,
          l10n.learningJourneyHadithThemesTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyHadithThemesReflection,
        sourceReferences: const ['Imam al-Nawawi, Forty Hadith'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolHadithHubTitle,
            subtitle: l10n.learningJourneyToolHadithHubSubtitle,
            routeName: 'learnHadithLanding',
          ),
          _tool(
            title: l10n.learningJourneyToolEssentialHadithTitle,
            subtitle: l10n.learningJourneyToolEssentialHadithSubtitle,
            routeName: 'learnHadithImportant',
          ),
        ],
        continueJourneyIds: const ['beautiful-character'],
        relatedJourneyIds: const ['daily-wisdom'],
        reviewSuggestion: l10n.learningJourneyHadithThemesReviewSuggestion,
      );
    case 'hadith-review':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageHadithReviewTitle,
        introduction: l10n.learningJourneyHadithReviewLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyHadithReviewSection1Title,
            body: l10n.learningJourneyHadithReviewSection1Body,
          ),
          _section(
            title: l10n.learningJourneyHadithReviewSection2Title,
            body: l10n.learningJourneyHadithReviewSection2Body,
            bullets: [
              l10n.learningJourneyHadithReviewBullet1,
              l10n.learningJourneyHadithReviewBullet2,
              l10n.learningJourneyHadithReviewBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyHadithReviewTakeaway1,
          l10n.learningJourneyHadithReviewTakeaway2,
          l10n.learningJourneyHadithReviewTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyHadithReviewReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolHadithReviewTitle,
            subtitle: l10n.learningJourneyToolHadithReviewSubtitle,
            routeName: 'hadithReviewQuiz',
          ),
          _tool(
            title: l10n.learningJourneyToolHadithHubTitle,
            subtitle: l10n.learningJourneyToolHadithHubSubtitle,
            routeName: 'learnHadithLanding',
          ),
        ],
        continueJourneyIds: const ['daily-wisdom'],
        relatedJourneyIds: const ['beautiful-character'],
        actionStep: l10n.learningJourneyHadithReviewActionStep,
      );
    default:
      throw ArgumentError('Unsupported Hadith stage: $stageId');
  }
}

LearningJourneyLessonContent _quranJourneyLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'quran-open':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageQuranOpenTitle,
        introduction: l10n.learningJourneyQuranOpenIntro,
        sections: [
          _section(
            title: l10n.learningJourneyQuranOpenSection1Title,
            body: l10n.learningJourneyQuranOpenSection1Body,
          ),
          _section(
            title: l10n.learningJourneyQuranOpenSection2Title,
            body: l10n.learningJourneyQuranOpenSection2Body,
            bullets: [
              l10n.learningJourneyQuranOpenBullet1,
              l10n.learningJourneyQuranOpenBullet2,
              l10n.learningJourneyQuranOpenBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyQuranOpenTakeaway1,
          l10n.learningJourneyQuranOpenTakeaway2,
          l10n.learningJourneyQuranOpenTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyQuranOpenReflection,
        quranReferences: const ['Qur’an 2:2', 'Qur’an 17:9'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranReaderTitle,
            subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
            routeName: 'quranReader',
            pathParameters: const {'surahNumber': '1'},
          ),
          _tool(
            title: l10n.learningJourneyToolSearchTitle,
            subtitle: l10n.learningJourneyQuranToolSearchSubtitle,
            routeName: 'quranSearch',
          ),
        ],
        continueJourneyIds: const ['understanding-al-fatihah'],
      );
    case 'quran-read':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageQuranReadTitle,
        introduction: l10n.learningJourneyQuranReadIntro,
        sections: [
          _section(
            title: l10n.learningJourneyQuranReadSection1Title,
            body: l10n.learningJourneyQuranReadSection1Body,
          ),
          _section(
            title: l10n.learningJourneyQuranReadSection2Title,
            body: l10n.learningJourneyQuranReadSection2Body,
            bullets: [
              l10n.learningJourneyQuranReadBullet1,
              l10n.learningJourneyQuranReadBullet2,
              l10n.learningJourneyQuranReadBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyQuranReadTakeaway1,
          l10n.learningJourneyQuranReadTakeaway2,
          l10n.learningJourneyQuranReadTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyQuranReadReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranReaderTitle,
            subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
            routeName: 'quranReader',
            pathParameters: const {'surahNumber': '1'},
          ),
          _tool(
            title: l10n.learningJourneyToolBookmarksTitle,
            subtitle: l10n.learningJourneyQuranBookmarksSupportSubtitle,
            routeName: 'quranBookmarks',
          ),
        ],
        continueJourneyIds: const ['understanding-al-fatihah'],
        relatedJourneyIds: const ['short-surahs'],
      );
    case 'quran-themes':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageQuranThemesTitle,
        introduction: l10n.learningJourneyQuranThemesIntro,
        sections: [
          _section(
            title: l10n.learningJourneyQuranThemesSection1Title,
            body: l10n.learningJourneyQuranThemesSection1Body,
          ),
          _section(
            title: l10n.learningJourneyQuranThemesSection2Title,
            body: l10n.learningJourneyQuranThemesSection2Body,
            bullets: [
              l10n.learningJourneyQuranThemesBullet1,
              l10n.learningJourneyQuranThemesBullet2,
              l10n.learningJourneyQuranThemesBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyQuranThemesTakeaway1,
          l10n.learningJourneyQuranThemesTakeaway2,
          l10n.learningJourneyQuranThemesTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyQuranThemesReflection,
        relatedTools: [
          _tool(
            title: l10n.quranExplorerTitle,
            subtitle: l10n.quranExplorerSubtitle,
            routeName: 'quranExplorer',
          ),
          _tool(
            title: l10n.learningJourneyToolNotesTitle,
            subtitle: l10n.learningJourneyQuranNotesSupportSubtitle,
            routeName: 'quranNotes',
          ),
        ],
        continueJourneyIds: const ['short-surahs'],
        relatedJourneyIds: const ['understand-what-you-recite'],
      );
    case 'quran-next-steps':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageQuranNextStepsTitle,
        introduction: l10n.learningJourneyQuranNextStepsIntro,
        sections: [
          _section(
            title: l10n.learningJourneyQuranNextStepsSection1Title,
            body: l10n.learningJourneyQuranNextStepsSection1Body,
          ),
          _section(
            title: l10n.learningJourneyQuranNextStepsSection2Title,
            body: l10n.learningJourneyQuranNextStepsSection2Body,
            bullets: [
              l10n.learningJourneyQuranNextStepsBullet1,
              l10n.learningJourneyQuranNextStepsBullet2,
              l10n.learningJourneyQuranNextStepsBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyQuranNextStepsTakeaway1,
          l10n.learningJourneyQuranNextStepsTakeaway2,
          l10n.learningJourneyQuranNextStepsTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyQuranNextStepsReflection,
        continueJourneyIds: const ['understanding-al-fatihah', 'short-surahs'],
        relatedJourneyIds: const ['understand-what-you-recite'],
        actionStep: l10n.learningJourneyQuranNextStepsActionStep,
      );
    default:
      throw ArgumentError('Unsupported Qur’an stage: $stageId');
  }
}

LearningJourneyLessonContent _fatihahLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'fatihah-read':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFatihahReadTitle,
        introduction: l10n.learningJourneyFatihahReadIntro,
        sections: [
          _section(
            title: l10n.learningJourneyFatihahReadSection1Title,
            body: l10n.learningJourneyFatihahReadSection1Body,
          ),
          _section(
            title: l10n.learningJourneyFatihahReadSection2Title,
            body: l10n.learningJourneyFatihahReadSection2Body,
            bullets: [
              l10n.learningJourneyFatihahReadBullet1,
              l10n.learningJourneyFatihahReadBullet2,
              l10n.learningJourneyFatihahReadBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyFatihahReadTakeaway1,
          l10n.learningJourneyFatihahReadTakeaway2,
          l10n.learningJourneyFatihahReadTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyFatihahReadReflection,
        quranReferences: const ['Qur’an 1:1-2'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranReaderTitle,
            subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
            routeName: 'quranReader',
            pathParameters: const {'surahNumber': '1'},
            queryParameters: const {'ayah': '1', 'endAyah': '2'},
          ),
        ],
      );
    case 'fatihah-recitation':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFatihahRecitationTitle,
        introduction: l10n.learningJourneyFatihahRecitationIntro,
        sections: [
          _section(
            title: l10n.learningJourneyFatihahRecitationSection1Title,
            body: l10n.learningJourneyFatihahRecitationSection1Body,
          ),
          _section(
            title: l10n.learningJourneyFatihahRecitationSection2Title,
            body: l10n.learningJourneyFatihahRecitationSection2Body,
            bullets: [
              l10n.learningJourneyFatihahRecitationBullet1,
              l10n.learningJourneyFatihahRecitationBullet2,
              l10n.learningJourneyFatihahRecitationBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyFatihahRecitationTakeaway1,
          l10n.learningJourneyFatihahRecitationTakeaway2,
          l10n.learningJourneyFatihahRecitationTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyFatihahRecitationReflection,
        quranReferences: const ['Qur’an 1:3-5'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
        continueJourneyIds: const ['understand-what-you-recite'],
      );
    case 'fatihah-reflection':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFatihahReflectionTitle,
        introduction: l10n.learningJourneyFatihahReflectionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyFatihahReflectionSection1Title,
            body: l10n.learningJourneyFatihahReflectionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyFatihahReflectionSection2Title,
            body: l10n.learningJourneyFatihahReflectionSection2Body,
            bullets: [
              l10n.learningJourneyFatihahReflectionBullet1,
              l10n.learningJourneyFatihahReflectionBullet2,
              l10n.learningJourneyFatihahReflectionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyFatihahReflectionTakeaway1,
          l10n.learningJourneyFatihahReflectionTakeaway2,
          l10n.learningJourneyFatihahReflectionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyFatihahReflectionReflection,
        quranReferences: const ['Qur’an 1:6-7'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolNotesTitle,
            subtitle: l10n.learningJourneyQuranNotesSupportSubtitle,
            routeName: 'quranNotes',
          ),
        ],
      );
    case 'fatihah-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageFatihahCompletionTitle,
        introduction: l10n.learningJourneyFatihahCompletionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyFatihahCompletionSection1Title,
            body: l10n.learningJourneyFatihahCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyFatihahCompletionSection2Title,
            body: l10n.learningJourneyFatihahCompletionSection2Body,
            bullets: [
              l10n.learningJourneyFatihahCompletionBullet1,
              l10n.learningJourneyFatihahCompletionBullet2,
              l10n.learningJourneyFatihahCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyFatihahCompletionTakeaway1,
          l10n.learningJourneyFatihahCompletionTakeaway2,
          l10n.learningJourneyFatihahCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyFatihahCompletionReflection,
        continueJourneyIds: const [
          'short-surahs',
          'understand-what-you-recite',
        ],
        relatedJourneyIds: const ['salah-foundations'],
        actionStep: l10n.learningJourneyFatihahCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported Fatihah stage: $stageId');
  }
}

LearningJourneyLessonContent _shortSurahsLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'short-surahs-ikhlas':
      return _surahLesson(
        l10n: l10n,
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahIkhlasTitle,
        introduction: l10n.learningJourneyShortSurahIkhlasIntro,
        contextTitle: l10n.learningJourneyShortSurahContextTitle,
        contextBody: l10n.learningJourneyShortSurahIkhlasContext,
        themesTitle: l10n.learningJourneyShortSurahThemesTitle,
        themesBody: l10n.learningJourneyShortSurahIkhlasThemes,
        takeaway1: l10n.learningJourneyShortSurahIkhlasTakeaway1,
        takeaway2: l10n.learningJourneyShortSurahIkhlasTakeaway2,
        takeaway3: l10n.learningJourneyShortSurahIkhlasTakeaway3,
        reflection: l10n.learningJourneyShortSurahIkhlasReflection,
        surahNumber: '112',
      );
    case 'short-surahs-falaq':
      return _surahLesson(
        l10n: l10n,
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahFalaqTitle,
        introduction: l10n.learningJourneyShortSurahFalaqIntro,
        contextTitle: l10n.learningJourneyShortSurahContextTitle,
        contextBody: l10n.learningJourneyShortSurahFalaqContext,
        themesTitle: l10n.learningJourneyShortSurahThemesTitle,
        themesBody: l10n.learningJourneyShortSurahFalaqThemes,
        takeaway1: l10n.learningJourneyShortSurahFalaqTakeaway1,
        takeaway2: l10n.learningJourneyShortSurahFalaqTakeaway2,
        takeaway3: l10n.learningJourneyShortSurahFalaqTakeaway3,
        reflection: l10n.learningJourneyShortSurahFalaqReflection,
        surahNumber: '113',
      );
    case 'short-surahs-nas':
      return _surahLesson(
        l10n: l10n,
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahNasTitle,
        introduction: l10n.learningJourneyShortSurahNasIntro,
        contextTitle: l10n.learningJourneyShortSurahContextTitle,
        contextBody: l10n.learningJourneyShortSurahNasContext,
        themesTitle: l10n.learningJourneyShortSurahThemesTitle,
        themesBody: l10n.learningJourneyShortSurahNasThemes,
        takeaway1: l10n.learningJourneyShortSurahNasTakeaway1,
        takeaway2: l10n.learningJourneyShortSurahNasTakeaway2,
        takeaway3: l10n.learningJourneyShortSurahNasTakeaway3,
        reflection: l10n.learningJourneyShortSurahNasReflection,
        surahNumber: '114',
      );
    case 'short-surahs-kafirun':
      return _surahLesson(
        l10n: l10n,
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahKafirunTitle,
        introduction: l10n.learningJourneyShortSurahKafirunIntro,
        contextTitle: l10n.learningJourneyShortSurahContextTitle,
        contextBody: l10n.learningJourneyShortSurahKafirunContext,
        themesTitle: l10n.learningJourneyShortSurahThemesTitle,
        themesBody: l10n.learningJourneyShortSurahKafirunThemes,
        takeaway1: l10n.learningJourneyShortSurahKafirunTakeaway1,
        takeaway2: l10n.learningJourneyShortSurahKafirunTakeaway2,
        takeaway3: l10n.learningJourneyShortSurahKafirunTakeaway3,
        reflection: l10n.learningJourneyShortSurahKafirunReflection,
        surahNumber: '109',
      );
    case 'short-surahs-kawthar':
      return _surahLesson(
        l10n: l10n,
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahKawtharTitle,
        introduction: l10n.learningJourneyShortSurahKawtharIntro,
        contextTitle: l10n.learningJourneyShortSurahContextTitle,
        contextBody: l10n.learningJourneyShortSurahKawtharContext,
        themesTitle: l10n.learningJourneyShortSurahThemesTitle,
        themesBody: l10n.learningJourneyShortSurahKawtharThemes,
        takeaway1: l10n.learningJourneyShortSurahKawtharTakeaway1,
        takeaway2: l10n.learningJourneyShortSurahKawtharTakeaway2,
        takeaway3: l10n.learningJourneyShortSurahKawtharTakeaway3,
        reflection: l10n.learningJourneyShortSurahKawtharReflection,
        surahNumber: '108',
      );
    case 'short-surahs-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageShortSurahCompletionTitle,
        introduction: l10n.learningJourneyShortSurahCompletionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyShortSurahCompletionSection1Title,
            body: l10n.learningJourneyShortSurahCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyShortSurahCompletionSection2Title,
            body: l10n.learningJourneyShortSurahCompletionSection2Body,
            bullets: [
              l10n.learningJourneyShortSurahCompletionBullet1,
              l10n.learningJourneyShortSurahCompletionBullet2,
              l10n.learningJourneyShortSurahCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyShortSurahCompletionTakeaway1,
          l10n.learningJourneyShortSurahCompletionTakeaway2,
          l10n.learningJourneyShortSurahCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyShortSurahCompletionReflection,
        continueJourneyIds: const ['understand-what-you-recite'],
        relatedJourneyIds: const ['salah-foundations'],
        actionStep: l10n.learningJourneyShortSurahCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported short surah stage: $stageId');
  }
}

LearningJourneyLessonContent _learningTransitionLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'alphabet-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageAlphabetCompletionTitle,
        introduction: l10n.learningJourneyAlphabetCompletionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyAlphabetCompletionSection1Title,
            body: l10n.learningJourneyAlphabetCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyAlphabetCompletionSection2Title,
            body: l10n.learningJourneyAlphabetCompletionSection2Body,
            bullets: [
              l10n.learningJourneyAlphabetCompletionBullet1,
              l10n.learningJourneyAlphabetCompletionBullet2,
              l10n.learningJourneyAlphabetCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyAlphabetCompletionTakeaway1,
          l10n.learningJourneyAlphabetCompletionTakeaway2,
          l10n.learningJourneyAlphabetCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyAlphabetCompletionReflection,
        continueJourneyIds: const ['reading-basics'],
        relatedJourneyIds: const ['understand-what-you-recite'],
        actionStep: l10n.learningJourneyAlphabetCompletionActionStep,
      );
    case 'reading-basics-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReadingCompletionTitle,
        introduction: l10n.learningJourneyReadingCompletionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReadingCompletionSection1Title,
            body: l10n.learningJourneyReadingCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReadingCompletionSection2Title,
            body: l10n.learningJourneyReadingCompletionSection2Body,
            bullets: [
              l10n.learningJourneyReadingCompletionBullet1,
              l10n.learningJourneyReadingCompletionBullet2,
              l10n.learningJourneyReadingCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReadingCompletionTakeaway1,
          l10n.learningJourneyReadingCompletionTakeaway2,
          l10n.learningJourneyReadingCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReadingCompletionReflection,
        continueJourneyIds: const [
          'understand-what-you-recite',
          'journey-quran',
        ],
        actionStep: l10n.learningJourneyReadingCompletionActionStep,
      );
    case 'recite-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReciteCompletionTitle,
        introduction: l10n.learningJourneyReciteCompletionIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReciteCompletionSection1Title,
            body: l10n.learningJourneyReciteCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReciteCompletionSection2Title,
            body: l10n.learningJourneyReciteCompletionSection2Body,
            bullets: [
              l10n.learningJourneyReciteCompletionBullet1,
              l10n.learningJourneyReciteCompletionBullet2,
              l10n.learningJourneyReciteCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReciteCompletionTakeaway1,
          l10n.learningJourneyReciteCompletionTakeaway2,
          l10n.learningJourneyReciteCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReciteCompletionReflection,
        continueJourneyIds: const ['salah-foundations', 'daily-dhikr'],
        relatedJourneyIds: const ['journey-quran'],
        actionStep: l10n.learningJourneyReciteCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported transition stage: $stageId');
  }
}

LearningJourneyLessonContent _salahFoundationsLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'salah-hub':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahWhyTitle,
        introduction: l10n.learningJourneySalahWhyLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahWhySection1Title,
            body: l10n.learningJourneySalahWhySection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahWhySection2Title,
            body: l10n.learningJourneySalahWhySection2Body,
            bullets: [
              l10n.learningJourneySalahWhyBullet1,
              l10n.learningJourneySalahWhyBullet2,
              l10n.learningJourneySalahWhyBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahWhyTakeaway1,
          l10n.learningJourneySalahWhyTakeaway2,
          l10n.learningJourneySalahWhyTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahWhyReflection,
        quranReferences: const ['Qur’an 20:14', 'Qur’an 29:45'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
        continueJourneyIds: const ['journey-of-wudu'],
      );
    case 'salah-guided-fajr':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahPrepareTitle,
        introduction: l10n.learningJourneySalahPrepareLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahPrepareSection1Title,
            body: l10n.learningJourneySalahPrepareSection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahPrepareSection2Title,
            body: l10n.learningJourneySalahPrepareSection2Body,
            bullets: [
              l10n.learningJourneySalahPrepareBullet1,
              l10n.learningJourneySalahPrepareBullet2,
              l10n.learningJourneySalahPrepareBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahPrepareTakeaway1,
          l10n.learningJourneySalahPrepareTakeaway2,
          l10n.learningJourneySalahPrepareTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahPrepareReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolWuduGuideTitle,
            subtitle: l10n.learningJourneyToolWuduGuideSubtitle,
            routeName: 'learnWuduGuide',
          ),
          _tool(
            title: l10n.learningJourneyToolGuidedPrayerTitle,
            subtitle: l10n.learningJourneyToolGuidedPrayerSubtitle,
            routeName: 'learnSalahGuidedPrayer',
            pathParameters: const {'prayerId': 'fajr'},
          ),
        ],
        continueJourneyIds: const ['journey-of-wudu'],
        relatedJourneyIds: const ['understand-what-you-recite'],
      );
    case 'salah-detail-fajr':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahMovementsTitle,
        introduction: l10n.learningJourneySalahMovementsLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahMovementsSection1Title,
            body: l10n.learningJourneySalahMovementsSection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahMovementsSection2Title,
            body: l10n.learningJourneySalahMovementsSection2Body,
            bullets: [
              l10n.learningJourneySalahMovementsBullet1,
              l10n.learningJourneySalahMovementsBullet2,
              l10n.learningJourneySalahMovementsBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahMovementsTakeaway1,
          l10n.learningJourneySalahMovementsTakeaway2,
          l10n.learningJourneySalahMovementsTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahMovementsReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolGuidedPrayerTitle,
            subtitle: l10n.learningJourneyToolGuidedPrayerSubtitle,
            routeName: 'learnSalahGuidedPrayer',
            pathParameters: const {'prayerId': 'fajr'},
          ),
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
      );
    case 'salah-words-meaning':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahWordsMeaningTitle,
        introduction: l10n.learningJourneySalahWordsMeaningLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahWordsMeaningSection1Title,
            body: l10n.learningJourneySalahWordsMeaningSection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahWordsMeaningSection2Title,
            body: l10n.learningJourneySalahWordsMeaningSection2Body,
            bullets: [
              l10n.learningJourneySalahWordsMeaningBullet1,
              l10n.learningJourneySalahWordsMeaningBullet2,
              l10n.learningJourneySalahWordsMeaningBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahWordsMeaningTakeaway1,
          l10n.learningJourneySalahWordsMeaningTakeaway2,
          l10n.learningJourneySalahWordsMeaningTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahWordsMeaningReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
          _tool(
            title: l10n.learningJourneyToolQuranReaderTitle,
            subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
            routeName: 'quranReader',
            pathParameters: const {'surahNumber': '1'},
            queryParameters: const {'ayah': '1', 'endAyah': '7'},
          ),
        ],
        continueJourneyIds: const ['understand-what-you-recite'],
      );
    case 'salah-khushu-consistency':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahConsistencyTitle,
        introduction: l10n.learningJourneySalahConsistencyLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahConsistencySection1Title,
            body: l10n.learningJourneySalahConsistencySection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahConsistencySection2Title,
            body: l10n.learningJourneySalahConsistencySection2Body,
            bullets: [
              l10n.learningJourneySalahConsistencyBullet1,
              l10n.learningJourneySalahConsistencyBullet2,
              l10n.learningJourneySalahConsistencyBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahConsistencyTakeaway1,
          l10n.learningJourneySalahConsistencyTakeaway2,
          l10n.learningJourneySalahConsistencyTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahConsistencyReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
        continueJourneyIds: const ['daily-dhikr'],
        relatedJourneyIds: const ['understand-what-you-recite'],
        actionStep: l10n.learningJourneySalahConsistencyActionStep,
      );
    case 'salah-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageSalahCompletionTitle,
        introduction: l10n.learningJourneySalahCompletionLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneySalahCompletionSection1Title,
            body: l10n.learningJourneySalahCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneySalahCompletionSection2Title,
            body: l10n.learningJourneySalahCompletionSection2Body,
            bullets: [
              l10n.learningJourneySalahCompletionBullet1,
              l10n.learningJourneySalahCompletionBullet2,
              l10n.learningJourneySalahCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneySalahCompletionTakeaway1,
          l10n.learningJourneySalahCompletionTakeaway2,
          l10n.learningJourneySalahCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneySalahCompletionReflection,
        continueJourneyIds: const ['daily-dhikr', 'understand-what-you-recite'],
        relatedJourneyIds: const ['journey-of-wudu'],
        actionStep: l10n.learningJourneySalahCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported Salah stage: $stageId');
  }
}

LearningJourneyLessonContent _wuduJourneyLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'wudu-guide':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageWuduWhyTitle,
        introduction: l10n.learningJourneyWuduWhyLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyWuduWhySection1Title,
            body: l10n.learningJourneyWuduWhySection1Body,
          ),
          _section(
            title: l10n.learningJourneyWuduWhySection2Title,
            body: l10n.learningJourneyWuduWhySection2Body,
            bullets: [
              l10n.learningJourneyWuduWhyBullet1,
              l10n.learningJourneyWuduWhyBullet2,
              l10n.learningJourneyWuduWhyBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyWuduWhyTakeaway1,
          l10n.learningJourneyWuduWhyTakeaway2,
          l10n.learningJourneyWuduWhyTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyWuduWhyReflection,
        quranReferences: const ['Qur’an 5:6'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolWuduGuideTitle,
            subtitle: l10n.learningJourneyToolWuduGuideSubtitle,
            routeName: 'learnWuduGuide',
          ),
        ],
        continueJourneyIds: const ['salah-foundations'],
      );
    case 'wudu-trainer':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageWuduPracticeTitle,
        introduction: l10n.learningJourneyWuduPracticeLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyWuduPracticeSection1Title,
            body: l10n.learningJourneyWuduPracticeSection1Body,
          ),
          _section(
            title: l10n.learningJourneyWuduPracticeSection2Title,
            body: l10n.learningJourneyWuduPracticeSection2Body,
            bullets: [
              l10n.learningJourneyWuduPracticeBullet1,
              l10n.learningJourneyWuduPracticeBullet2,
              l10n.learningJourneyWuduPracticeBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyWuduPracticeTakeaway1,
          l10n.learningJourneyWuduPracticeTakeaway2,
          l10n.learningJourneyWuduPracticeTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyWuduPracticeReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolWuduTrainerTitle,
            subtitle: l10n.learningJourneyToolWuduTrainerSubtitle,
            routeName: 'learnWuduTrainer',
          ),
          _tool(
            title: l10n.learningJourneyToolWuduGuideTitle,
            subtitle: l10n.learningJourneyToolWuduGuideSubtitle,
            routeName: 'learnWuduGuide',
          ),
        ],
      );
    case 'wudu-what-breaks':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageWuduBreaksTitle,
        introduction: l10n.learningJourneyWuduBreaksLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyWuduBreaksSection1Title,
            body: l10n.learningJourneyWuduBreaksSection1Body,
          ),
          _section(
            title: l10n.learningJourneyWuduBreaksSection2Title,
            body: l10n.learningJourneyWuduBreaksSection2Body,
            bullets: [
              l10n.learningJourneyWuduBreaksBullet1,
              l10n.learningJourneyWuduBreaksBullet2,
              l10n.learningJourneyWuduBreaksBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyWuduBreaksTakeaway1,
          l10n.learningJourneyWuduBreaksTakeaway2,
          l10n.learningJourneyWuduBreaksTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyWuduBreaksReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolWuduGuideTitle,
            subtitle: l10n.learningJourneyToolWuduGuideSubtitle,
            routeName: 'learnWuduGuide',
          ),
        ],
        continueJourneyIds: const ['salah-foundations'],
      );
    case 'wudu-common-mistakes':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageWuduMistakesTitle,
        introduction: l10n.learningJourneyWuduMistakesLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyWuduMistakesSection1Title,
            body: l10n.learningJourneyWuduMistakesSection1Body,
          ),
          _section(
            title: l10n.learningJourneyWuduMistakesSection2Title,
            body: l10n.learningJourneyWuduMistakesSection2Body,
            bullets: [
              l10n.learningJourneyWuduMistakesBullet1,
              l10n.learningJourneyWuduMistakesBullet2,
              l10n.learningJourneyWuduMistakesBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyWuduMistakesTakeaway1,
          l10n.learningJourneyWuduMistakesTakeaway2,
          l10n.learningJourneyWuduMistakesTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyWuduMistakesReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolWuduTrainerTitle,
            subtitle: l10n.learningJourneyToolWuduTrainerSubtitle,
            routeName: 'learnWuduTrainer',
          ),
          _tool(
            title: l10n.learningJourneyToolSalahHubTitle,
            subtitle: l10n.learningJourneyToolSalahHubSubtitle,
            routeName: 'learnSalahHub',
          ),
        ],
        continueJourneyIds: const ['salah-foundations'],
        actionStep: l10n.learningJourneyWuduMistakesActionStep,
      );
    case 'wudu-completion':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageWuduCompletionTitle,
        introduction: l10n.learningJourneyWuduCompletionLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyWuduCompletionSection1Title,
            body: l10n.learningJourneyWuduCompletionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyWuduCompletionSection2Title,
            body: l10n.learningJourneyWuduCompletionSection2Body,
            bullets: [
              l10n.learningJourneyWuduCompletionBullet1,
              l10n.learningJourneyWuduCompletionBullet2,
              l10n.learningJourneyWuduCompletionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyWuduCompletionTakeaway1,
          l10n.learningJourneyWuduCompletionTakeaway2,
          l10n.learningJourneyWuduCompletionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyWuduCompletionReflection,
        continueJourneyIds: const ['salah-foundations', 'daily-dhikr'],
        relatedJourneyIds: const ['duas-daily-life'],
        actionStep: l10n.learningJourneyWuduCompletionActionStep,
      );
    default:
      throw ArgumentError('Unsupported Wudu stage: $stageId');
  }
}

LearningJourneyLessonContent _arabicAlphabetLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'alphabet-open':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageAlphabetOpenTitle,
        introduction: l10n.learningJourneyAlphabetOpenLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyAlphabetOpenSection1Title,
            body: l10n.learningJourneyAlphabetOpenSection1Body,
          ),
          _section(
            title: l10n.learningJourneyAlphabetOpenSection2Title,
            body: l10n.learningJourneyAlphabetOpenSection2Body,
            bullets: [
              l10n.learningJourneyAlphabetOpenBullet1,
              l10n.learningJourneyAlphabetOpenBullet2,
              l10n.learningJourneyAlphabetOpenBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyAlphabetOpenTakeaway1,
          l10n.learningJourneyAlphabetOpenTakeaway2,
          l10n.learningJourneyAlphabetOpenTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyAlphabetOpenReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
        continueJourneyIds: const ['reading-basics'],
      );
    case 'alphabet-repeat':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageAlphabetRepeatTitle,
        introduction: l10n.learningJourneyAlphabetRepeatLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyAlphabetRepeatSection1Title,
            body: l10n.learningJourneyAlphabetRepeatSection1Body,
          ),
          _section(
            title: l10n.learningJourneyAlphabetRepeatSection2Title,
            body: l10n.learningJourneyAlphabetRepeatSection2Body,
            bullets: [
              l10n.learningJourneyAlphabetRepeatBullet1,
              l10n.learningJourneyAlphabetRepeatBullet2,
              l10n.learningJourneyAlphabetRepeatBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyAlphabetRepeatTakeaway1,
          l10n.learningJourneyAlphabetRepeatTakeaway2,
          l10n.learningJourneyAlphabetRepeatTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyAlphabetRepeatReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
        continueJourneyIds: const ['reading-basics'],
      );
    case 'alphabet-review':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageAlphabetReviewTitle,
        introduction: l10n.learningJourneyAlphabetReviewLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyAlphabetReviewSection1Title,
            body: l10n.learningJourneyAlphabetReviewSection1Body,
          ),
          _section(
            title: l10n.learningJourneyAlphabetReviewSection2Title,
            body: l10n.learningJourneyAlphabetReviewSection2Body,
            bullets: [
              l10n.learningJourneyAlphabetReviewBullet1,
              l10n.learningJourneyAlphabetReviewBullet2,
              l10n.learningJourneyAlphabetReviewBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyAlphabetReviewTakeaway1,
          l10n.learningJourneyAlphabetReviewTakeaway2,
          l10n.learningJourneyAlphabetReviewTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyAlphabetReviewReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
          _tool(
            title: l10n.learningJourneyToolQuranStudyTitle,
            subtitle: l10n.learningJourneyToolQuranStudySubtitle,
            routeName: 'quranLearningHub',
          ),
        ],
        continueJourneyIds: const ['reading-basics'],
        actionStep: l10n.learningJourneyAlphabetReviewActionStep,
      );
    default:
      throw ArgumentError('Unsupported alphabet stage: $stageId');
  }
}

LearningJourneyLessonContent _readingBasicsExtendedLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'reading-basics-kasra':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReadingKasrahTitle,
        introduction: l10n.learningJourneyReadingKasrahLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReadingKasrahSection1Title,
            body: l10n.learningJourneyReadingKasrahSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReadingKasrahSection2Title,
            body: l10n.learningJourneyReadingKasrahSection2Body,
            bullets: [
              l10n.learningJourneyReadingKasrahBullet1,
              l10n.learningJourneyReadingKasrahBullet2,
              l10n.learningJourneyReadingKasrahBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReadingKasrahTakeaway1,
          l10n.learningJourneyReadingKasrahTakeaway2,
          l10n.learningJourneyReadingKasrahTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReadingKasrahReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
      );
    case 'reading-basics-damma':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReadingDammahTitle,
        introduction: l10n.learningJourneyReadingDammahLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReadingDammahSection1Title,
            body: l10n.learningJourneyReadingDammahSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReadingDammahSection2Title,
            body: l10n.learningJourneyReadingDammahSection2Body,
            bullets: [
              l10n.learningJourneyReadingDammahBullet1,
              l10n.learningJourneyReadingDammahBullet2,
              l10n.learningJourneyReadingDammahBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReadingDammahTakeaway1,
          l10n.learningJourneyReadingDammahTakeaway2,
          l10n.learningJourneyReadingDammahTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReadingDammahReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
      );
    case 'reading-basics-sukun':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReadingSukunTitle,
        introduction: l10n.learningJourneyReadingSukunLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReadingSukunSection1Title,
            body: l10n.learningJourneyReadingSukunSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReadingSukunSection2Title,
            body: l10n.learningJourneyReadingSukunSection2Body,
            bullets: [
              l10n.learningJourneyReadingSukunBullet1,
              l10n.learningJourneyReadingSukunBullet2,
              l10n.learningJourneyReadingSukunBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReadingSukunTakeaway1,
          l10n.learningJourneyReadingSukunTakeaway2,
          l10n.learningJourneyReadingSukunTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReadingSukunReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
      );
    case 'reading-basics-shaddah':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageReadingShaddahTitle,
        introduction: l10n.learningJourneyReadingShaddahLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyReadingShaddahSection1Title,
            body: l10n.learningJourneyReadingShaddahSection1Body,
          ),
          _section(
            title: l10n.learningJourneyReadingShaddahSection2Title,
            body: l10n.learningJourneyReadingShaddahSection2Body,
            bullets: [
              l10n.learningJourneyReadingShaddahBullet1,
              l10n.learningJourneyReadingShaddahBullet2,
              l10n.learningJourneyReadingShaddahBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyReadingShaddahTakeaway1,
          l10n.learningJourneyReadingShaddahTakeaway2,
          l10n.learningJourneyReadingShaddahTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyReadingShaddahReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolQuranArabicTitle,
            subtitle: l10n.learningJourneyToolQuranArabicSubtitle,
            routeName: 'quranArabic',
          ),
        ],
        continueJourneyIds: const ['understand-what-you-recite'],
      );
    default:
      throw ArgumentError('Unsupported reading stage: $stageId');
  }
}

LearningJourneyLessonContent _triviaKnowledgeLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'trivia-paths':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTriviaPathsTitle,
        introduction: l10n.learningJourneyTriviaPathsLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyTriviaPathsSection1Title,
            body: l10n.learningJourneyTriviaPathsSection1Body,
          ),
          _section(
            title: l10n.learningJourneyTriviaPathsSection2Title,
            body: l10n.learningJourneyTriviaPathsSection2Body,
            bullets: [
              l10n.learningJourneyTriviaPathsBullet1,
              l10n.learningJourneyTriviaPathsBullet2,
              l10n.learningJourneyTriviaPathsBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyTriviaPathsTakeaway1,
          l10n.learningJourneyTriviaPathsTakeaway2,
          l10n.learningJourneyTriviaPathsTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyTriviaPathsReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolTriviaPathsTitle,
            subtitle: l10n.learningJourneyToolTriviaPathsSubtitle,
            routeName: 'learnTriviaKnowledgePaths',
          ),
        ],
        relatedJourneyIds: const ['prophets-journey', 'stories-signs'],
      );
    case 'trivia-session':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTriviaSessionTitle,
        introduction: l10n.learningJourneyTriviaSessionLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyTriviaSessionSection1Title,
            body: l10n.learningJourneyTriviaSessionSection1Body,
          ),
          _section(
            title: l10n.learningJourneyTriviaSessionSection2Title,
            body: l10n.learningJourneyTriviaSessionSection2Body,
            bullets: [
              l10n.learningJourneyTriviaSessionBullet1,
              l10n.learningJourneyTriviaSessionBullet2,
              l10n.learningJourneyTriviaSessionBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyTriviaSessionTakeaway1,
          l10n.learningJourneyTriviaSessionTakeaway2,
          l10n.learningJourneyTriviaSessionTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyTriviaSessionReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolTriviaPathsTitle,
            subtitle: l10n.learningJourneyToolTriviaPathsSubtitle,
            routeName: 'learnTriviaKnowledgePaths',
          ),
        ],
        relatedJourneyIds: const ['journey-quran', 'hadith-essentials'],
      );
    case 'trivia-review':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageTriviaReviewTitle,
        introduction: l10n.learningJourneyTriviaReviewLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyTriviaReviewSection1Title,
            body: l10n.learningJourneyTriviaReviewSection1Body,
          ),
          _section(
            title: l10n.learningJourneyTriviaReviewSection2Title,
            body: l10n.learningJourneyTriviaReviewSection2Body,
            bullets: [
              l10n.learningJourneyTriviaReviewBullet1,
              l10n.learningJourneyTriviaReviewBullet2,
              l10n.learningJourneyTriviaReviewBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyTriviaReviewTakeaway1,
          l10n.learningJourneyTriviaReviewTakeaway2,
          l10n.learningJourneyTriviaReviewTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyTriviaReviewReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolTriviaReviewTitle,
            subtitle: l10n.learningJourneyToolTriviaReviewSubtitle,
            routeName: 'learnTriviaReview',
          ),
        ],
        continueJourneyIds: const ['journey-quran'],
        relatedJourneyIds: const ['prophets-journey', 'stories-signs'],
      );
    default:
      throw ArgumentError('Unsupported trivia stage: $stageId');
  }
}

LearningJourneyLessonContent _ramadanFoundationsLesson(
  String stageId,
  AppLocalizations l10n,
) {
  switch (stageId) {
    case 'ramadan-intention':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanWhatIsTitle,
        introduction: l10n.learningJourneyRamadanWhatIsLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanWhatIsSection1Title,
            body: l10n.learningJourneyRamadanWhatIsSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanWhatIsSection2Title,
            body: l10n.learningJourneyRamadanWhatIsSection2Body,
            bullets: [
              l10n.learningJourneyRamadanWhatIsBullet1,
              l10n.learningJourneyRamadanWhatIsBullet2,
              l10n.learningJourneyRamadanWhatIsBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanWhatIsTakeaway1,
          l10n.learningJourneyRamadanWhatIsTakeaway2,
          l10n.learningJourneyRamadanWhatIsTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanWhatIsReflection,
        quranReferences: const ['Qur’an 2:185'],
        continueJourneyIds: const ['daily-dhikr'],
      );
    case 'ramadan-why-fast':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanWhyFastTitle,
        introduction: l10n.learningJourneyRamadanWhyFastLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanWhyFastSection1Title,
            body: l10n.learningJourneyRamadanWhyFastSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanWhyFastSection2Title,
            body: l10n.learningJourneyRamadanWhyFastSection2Body,
            bullets: [
              l10n.learningJourneyRamadanWhyFastBullet1,
              l10n.learningJourneyRamadanWhyFastBullet2,
              l10n.learningJourneyRamadanWhyFastBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanWhyFastTakeaway1,
          l10n.learningJourneyRamadanWhyFastTakeaway2,
          l10n.learningJourneyRamadanWhyFastTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanWhyFastReflection,
        quranReferences: const ['Qur’an 2:183'],
        continueJourneyIds: const ['daily-dhikr'],
      );
    case 'ramadan-daily-rhythm':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanSuhoorIftarTitle,
        introduction: l10n.learningJourneyRamadanSuhoorIftarLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanSuhoorIftarSection1Title,
            body: l10n.learningJourneyRamadanSuhoorIftarSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanSuhoorIftarSection2Title,
            body: l10n.learningJourneyRamadanSuhoorIftarSection2Body,
            bullets: [
              l10n.learningJourneyRamadanSuhoorIftarBullet1,
              l10n.learningJourneyRamadanSuhoorIftarBullet2,
              l10n.learningJourneyRamadanSuhoorIftarBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanSuhoorIftarTakeaway1,
          l10n.learningJourneyRamadanSuhoorIftarTakeaway2,
          l10n.learningJourneyRamadanSuhoorIftarTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanSuhoorIftarReflection,
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolDuaHubTitle,
            subtitle: l10n.learningJourneyToolDuaHubSubtitle,
            routeName: 'learnDuaHub',
          ),
        ],
        continueJourneyIds: const ['duas-daily-life'],
      );
    case 'ramadan-what-breaks-fast':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanBreaksFastTitle,
        introduction: l10n.learningJourneyRamadanBreaksFastLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanBreaksFastSection1Title,
            body: l10n.learningJourneyRamadanBreaksFastSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanBreaksFastSection2Title,
            body: l10n.learningJourneyRamadanBreaksFastSection2Body,
            bullets: [
              l10n.learningJourneyRamadanBreaksFastBullet1,
              l10n.learningJourneyRamadanBreaksFastBullet2,
              l10n.learningJourneyRamadanBreaksFastBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanBreaksFastTakeaway1,
          l10n.learningJourneyRamadanBreaksFastTakeaway2,
          l10n.learningJourneyRamadanBreaksFastTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanBreaksFastReflection,
        sourceReferences: const ['Sahih al-Bukhari, Book of Fasting'],
      );
    case 'ramadan-laylat-al-qadr':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanLaylatTitle,
        introduction: l10n.learningJourneyRamadanLaylatLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanLaylatSection1Title,
            body: l10n.learningJourneyRamadanLaylatSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanLaylatSection2Title,
            body: l10n.learningJourneyRamadanLaylatSection2Body,
            bullets: [
              l10n.learningJourneyRamadanLaylatBullet1,
              l10n.learningJourneyRamadanLaylatBullet2,
              l10n.learningJourneyRamadanLaylatBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanLaylatTakeaway1,
          l10n.learningJourneyRamadanLaylatTakeaway2,
          l10n.learningJourneyRamadanLaylatTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanLaylatReflection,
        quranReferences: const ['Qur’an 97:1-5'],
        relatedTools: [
          _tool(
            title: l10n.learningJourneyToolDuaHubTitle,
            subtitle: l10n.learningJourneyToolDuaHubSubtitle,
            routeName: 'learnDuaHub',
          ),
        ],
      );
    case 'ramadan-reflection':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanSpiritualGoalsTitle,
        introduction: l10n.learningJourneyRamadanSpiritualGoalsLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanSpiritualGoalsSection1Title,
            body: l10n.learningJourneyRamadanSpiritualGoalsSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanSpiritualGoalsSection2Title,
            body: l10n.learningJourneyRamadanSpiritualGoalsSection2Body,
            bullets: [
              l10n.learningJourneyRamadanSpiritualGoalsBullet1,
              l10n.learningJourneyRamadanSpiritualGoalsBullet2,
              l10n.learningJourneyRamadanSpiritualGoalsBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanSpiritualGoalsTakeaway1,
          l10n.learningJourneyRamadanSpiritualGoalsTakeaway2,
          l10n.learningJourneyRamadanSpiritualGoalsTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanSpiritualGoalsReflection,
        continueJourneyIds: const ['daily-dhikr'],
        relatedJourneyIds: const ['duas-daily-life'],
        showDhikrCounterAction: true,
      );
    case 'ramadan-common-mistakes':
      return _lesson(
        stageId: stageId,
        title: l10n.learningJourneyStageRamadanMistakesTitle,
        introduction: l10n.learningJourneyRamadanMistakesLessonIntro,
        sections: [
          _section(
            title: l10n.learningJourneyRamadanMistakesSection1Title,
            body: l10n.learningJourneyRamadanMistakesSection1Body,
          ),
          _section(
            title: l10n.learningJourneyRamadanMistakesSection2Title,
            body: l10n.learningJourneyRamadanMistakesSection2Body,
            bullets: [
              l10n.learningJourneyRamadanMistakesBullet1,
              l10n.learningJourneyRamadanMistakesBullet2,
              l10n.learningJourneyRamadanMistakesBullet3,
            ],
          ),
        ],
        keyTakeaways: [
          l10n.learningJourneyRamadanMistakesTakeaway1,
          l10n.learningJourneyRamadanMistakesTakeaway2,
          l10n.learningJourneyRamadanMistakesTakeaway3,
        ],
        reflectionPrompt: l10n.learningJourneyRamadanMistakesReflection,
        continueJourneyIds: const ['daily-dhikr'],
        relatedJourneyIds: const ['duas-daily-life'],
        actionStep: l10n.learningJourneyRamadanMistakesActionStep,
      );
    default:
      throw ArgumentError('Unsupported Ramadan stage: $stageId');
  }
}

LearningJourneyLessonContent _surahLesson({
  required AppLocalizations l10n,
  required String stageId,
  required String title,
  required String introduction,
  required String contextTitle,
  required String contextBody,
  required String themesTitle,
  required String themesBody,
  required String takeaway1,
  required String takeaway2,
  required String takeaway3,
  required String reflection,
  required String surahNumber,
}) {
  return _lesson(
    stageId: stageId,
    title: title,
    introduction: introduction,
    sections: [
      _section(title: contextTitle, body: contextBody),
      _section(title: themesTitle, body: themesBody),
    ],
    keyTakeaways: [takeaway1, takeaway2, takeaway3],
    reflectionPrompt: reflection,
    relatedTools: [
      _tool(
        title: l10n.learningJourneyToolQuranReaderTitle,
        subtitle: l10n.learningJourneyToolQuranReaderSubtitle,
        routeName: 'quranReader',
        pathParameters: {'surahNumber': surahNumber},
      ),
      _tool(
        title: l10n.learningJourneyToolSalahHubTitle,
        subtitle: l10n.learningJourneyToolSalahHubSubtitle,
        routeName: 'learnSalahHub',
      ),
    ],
  );
}

LearningJourneyLessonContent _compactLesson({
  required String stageId,
  required String title,
  required String intro,
  required String section1Title,
  required String section1Body,
  required String section2Title,
  required String section2Body,
  required String takeaway1,
  required String takeaway2,
  required String takeaway3,
  required String reflection,
  List<String> quranReferences = const <String>[],
  List<String> sourceReferences = const <String>[],
  List<LearningJourneyLessonInvocation> invocations =
      const <LearningJourneyLessonInvocation>[],
  List<LearningJourneyToolLink> relatedTools =
      const <LearningJourneyToolLink>[],
  List<String> continueJourneyIds = const <String>[],
  List<String> relatedJourneyIds = const <String>[],
  String? actionStep,
  String? reviewSuggestion,
  bool showDhikrCounterAction = false,
}) {
  return _lesson(
    stageId: stageId,
    title: title,
    introduction: intro,
    sections: [
      _section(title: section1Title, body: section1Body),
      _section(title: section2Title, body: section2Body),
    ],
    keyTakeaways: [takeaway1, takeaway2, takeaway3],
    reflectionPrompt: reflection,
    quranReferences: quranReferences,
    sourceReferences: sourceReferences,
    invocations: invocations,
    relatedTools: relatedTools,
    continueJourneyIds: continueJourneyIds,
    relatedJourneyIds: relatedJourneyIds,
    actionStep: actionStep,
    reviewSuggestion: reviewSuggestion,
    showDhikrCounterAction: showDhikrCounterAction,
  );
}

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
  String? actionStep,
  String? reviewSuggestion,
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
    actionStep: actionStep,
    reviewSuggestion: reviewSuggestion,
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

LearningJourneyLessonInvocation _invocation({
  required String title,
  required String arabic,
  required String transliteration,
  required String meaning,
  required String context,
  required String sourceReference,
}) {
  return LearningJourneyLessonInvocation(
    title: title,
    arabic: arabic,
    transliteration: transliteration,
    meaning: meaning,
    context: context,
    sourceReference: sourceReference,
  );
}

LearningJourneyToolLink _tool({
  required String title,
  required String subtitle,
  required String routeName,
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, String> queryParameters = const <String, String>{},
}) {
  return LearningJourneyToolLink(
    title: title,
    subtitle: subtitle,
    routeName: routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
  );
}
