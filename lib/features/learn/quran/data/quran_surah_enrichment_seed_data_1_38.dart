import '../domain/quran_surah_summary_models.dart';

const List<QuranSurahEnrichmentSeed> seededQuranSurahEnrichments1To38 =
    <QuranSurahEnrichmentSeed>[
      QuranSurahEnrichmentSeed(
        surahNumber: 1,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.guidance,
          QuranSurahThemeTag.worship,
          QuranSurahThemeTag.mercy,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 1,
            ayahNumber: 5,
            endAyahNumber: 7,
            label: 'The central prayer for guidance',
            whyItMatters:
                'These verses gather worship, dependence, and the request to be kept on the straight path.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
        reflections: <QuranSurahReflectionPrompt>[
          QuranSurahReflectionPrompt(
            prompt: 'What guidance am I asking Allah for most sincerely right now?',
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 2,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.guidance,
          QuranSurahThemeTag.law,
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.tawhid,
          QuranSurahThemeTag.patience,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 2,
            ayahNumber: 2,
            label: 'Guidance for the God-conscious',
            whyItMatters:
                'The surah opens by describing the Quran as guidance for hearts that approach it with taqwa.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 2,
            ayahNumber: 183,
            label: 'The fasting verse',
            whyItMatters:
                'This verse ties fasting to taqwa and frames Ramadan as a training in disciplined worship.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 2,
            ayahNumber: 255,
            label: 'Ayat al-Kursi',
            whyItMatters:
                'A central verse of tawhid and divine majesty, often studied for its description of Allah\'s perfect knowledge and dominion.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.broadlyAcceptedClassicalUnderstanding,
          ),
          QuranSurahNotableAyah(
            surahNumber: 2,
            ayahNumber: 285,
            endAyahNumber: 286,
            label: 'A closing prayer of faith and reliance',
            whyItMatters:
                'The final verses gather belief, obedience, repentance, and humble supplication.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'adam', label: 'Adam'),
          QuranSurahNamedReference(id: 'ibrahim', label: 'Ibrahim'),
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'qiblah-change',
            label: 'Change of qiblah',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        reflections: <QuranSurahReflectionPrompt>[
          QuranSurahReflectionPrompt(
            prompt: 'Which commands of Allah am I following outwardly but still resisting inwardly?',
          ),
          QuranSurahReflectionPrompt(
            prompt: 'Where do I most need taqwa to shape my daily choices?',
          ),
        ],
        searchAliases: <String>['Ayat al-Kursi', 'fasting', 'taqwa'],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 3,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.revelation,
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.tawhid,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 3,
            ayahNumber: 8,
            label: 'A prayer for steadiness',
            whyItMatters:
                'This supplication asks Allah to keep hearts firm after guidance and to grant mercy.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 3,
            ayahNumber: 18,
            label: 'Witness to divine oneness',
            whyItMatters:
                'A foundational testimony to Allah\'s justice and unique right to worship.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 3,
            ayahNumber: 190,
            endAyahNumber: 191,
            label: 'Reflection on the signs of creation',
            whyItMatters:
                'These verses connect thinking deeply about creation with remembrance and humble prayer.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'maryam', label: 'Maryam'),
          QuranSurahNamedReference(id: 'isa', label: 'Isa'),
          QuranSurahNamedReference(id: 'zakariyya', label: 'Zakariyya'),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'uhud',
            label: 'Lessons after Uhud',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 4,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.justice,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.law,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 4,
            ayahNumber: 1,
            label: 'Human dignity from a single origin',
            whyItMatters:
                'The opening verse frames family rights and social obligations under taqwa and shared human origin.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 4,
            ayahNumber: 58,
            label: 'Return trusts and judge with justice',
            whyItMatters:
                'A foundational command for public trust, leadership, and fairness.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 4,
            ayahNumber: 135,
            label: 'Stand firmly for justice',
            whyItMatters:
                'This verse calls believers to uphold justice even when it is difficult or personally costly.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 5,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.law,
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.justice,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 5,
            ayahNumber: 3,
            label: 'Completion of religion',
            whyItMatters:
                'A key verse about the completion of divine favor and the perfection of Islam as a way of life.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 5,
            ayahNumber: 8,
            label: 'Justice even with people you dislike',
            whyItMatters:
                'This verse ties justice directly to taqwa and warns against letting resentment distort judgment.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 7,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.repentance,
          QuranSurahThemeTag.judgment,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 7,
            ayahNumber: 23,
            label: 'The repentance of Adam and Hawwa',
            whyItMatters:
                'A concise Quranic model of repentance after error and returning to Allah with humility.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 7,
            ayahNumber: 31,
            label: 'Take your adornment at every masjid',
            whyItMatters:
                'This verse balances dignified worship with the warning against excess.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 7,
            ayahNumber: 172,
            label: 'The primordial covenant',
            whyItMatters:
                'A deeply discussed verse about human testimony to the Lordship of Allah.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.broadlyAcceptedClassicalUnderstanding,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'adam', label: 'Adam'),
          QuranSurahNamedReference(id: 'nuh', label: 'Nuh'),
          QuranSurahNamedReference(id: 'hud', label: 'Hud'),
          QuranSurahNamedReference(id: 'salih', label: 'Salih'),
          QuranSurahNamedReference(id: 'shuayb', label: 'Shuayb'),
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 8,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.struggle,
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.guidance,
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'badr',
            label: 'Battle of Badr',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 8,
            ayahNumber: 24,
            label: 'Respond to what gives you life',
            whyItMatters:
                'This verse ties obedience to spiritual life and responsiveness to revelation.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 9,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.repentance,
          QuranSurahThemeTag.struggle,
          QuranSurahThemeTag.hypocrisy,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 9,
            ayahNumber: 40,
            label: 'Allah was with him in the cave',
            whyItMatters:
                'A memorable reminder of divine support during a moment of danger and migration.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
          QuranSurahNotableAyah(
            surahNumber: 9,
            ayahNumber: 103,
            label: 'Purifying wealth through giving',
            whyItMatters:
                'The verse highlights charity as a means of purification and growth.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 9,
            ayahNumber: 119,
            label: 'Be with the truthful',
            whyItMatters:
                'A concise command tying taqwa to truthful company and sincere commitment.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'tabuk',
            label: 'Expedition of Tabuk',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 11,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.justice,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 11,
            ayahNumber: 112,
            label: 'Remain upright as you were commanded',
            whyItMatters:
                'This verse is often remembered for the moral weight of istiqamah and steadiness.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.broadlyAcceptedClassicalUnderstanding,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'nuh', label: 'Nuh'),
          QuranSurahNamedReference(id: 'hud', label: 'Hud'),
          QuranSurahNamedReference(id: 'salih', label: 'Salih'),
          QuranSurahNamedReference(id: 'ibrahim', label: 'Ibrahim'),
          QuranSurahNamedReference(id: 'lut', label: 'Lut'),
          QuranSurahNamedReference(id: 'shuayb', label: 'Shuayb'),
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 12,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.guidance,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 12,
            ayahNumber: 23,
            label: 'Resisting temptation with taqwa',
            whyItMatters:
                'A striking moment of moral clarity and seeking refuge in Allah.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 12,
            ayahNumber: 87,
            label: 'Do not despair of Allah\'s relief',
            whyItMatters:
                'A verse of hope and trust repeated often in hardship.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 12,
            ayahNumber: 92,
            label: 'No blame upon you today',
            whyItMatters:
                'Yusuf\'s words highlight mercy and forgiveness at the moment of power.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'yusuf', label: 'Yusuf'),
          QuranSurahNamedReference(id: 'yaqub', label: 'Yaqub'),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'dreams-and-imprisonment',
            label: 'Dreams, imprisonment, and reunion',
          ),
        ],
        reflections: <QuranSurahReflectionPrompt>[
          QuranSurahReflectionPrompt(
            prompt: 'Where is Allah teaching me patience through a season I wish would end sooner?',
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 17,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.worship,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.revelation,
          QuranSurahThemeTag.guidance,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 17,
            ayahNumber: 23,
            endAyahNumber: 24,
            label: 'Kindness to parents',
            whyItMatters:
                'These verses are central Quranic guidance on gentleness, service, and prayer for one\'s parents.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 17,
            ayahNumber: 70,
            label: 'The honor given to the children of Adam',
            whyItMatters:
                'A key verse on human dignity and responsibility.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 17,
            ayahNumber: 82,
            label: 'Healing and mercy in the Quran',
            whyItMatters:
                'This verse describes the Quran as healing and mercy for believers.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(
            id: 'night-journey',
            label: 'The Night Journey',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 18,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.guidance,
          QuranSurahThemeTag.signsOfCreation,
          QuranSurahThemeTag.struggle,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 18,
            ayahNumber: 9,
            endAyahNumber: 26,
            label: 'The People of the Cave',
            whyItMatters:
                'A story of faith under pressure, divine protection, and patience in a time of trial.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
          QuranSurahNotableAyah(
            surahNumber: 18,
            ayahNumber: 60,
            endAyahNumber: 82,
            label: 'Musa and the righteous servant',
            whyItMatters:
                'These verses teach humility before divine wisdom and patience with what is not yet understood.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.broadlyAcceptedClassicalUnderstanding,
          ),
          QuranSurahNotableAyah(
            surahNumber: 18,
            ayahNumber: 83,
            endAyahNumber: 98,
            label: 'Dhul-Qarnayn and just power',
            whyItMatters:
                'A portrait of authority used with responsibility, gratitude, and service.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'people-of-the-cave', label: 'People of the Cave'),
          QuranSurahNamedReference(id: 'dhul-qarnayn', label: 'Dhul-Qarnayn'),
        ],
        virtues: <QuranSurahVirtueNote>[
          QuranSurahVirtueNote(
            title: 'A commonly taught Friday recitation',
            description:
                'Many Muslims read Surah Al-Kahf on Friday, based on well-known hadith reports about its special place on that day.',
          ),
        ],
        reflections: <QuranSurahReflectionPrompt>[
          QuranSurahReflectionPrompt(
            prompt: 'Which trial of faith, wealth, knowledge, or power needs more humility from me?',
          ),
        ],
        searchAliases: <String>['Friday', 'People of the Cave', 'Dhul-Qarnayn'],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 19,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.mercy,
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.resurrection,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 19,
            ayahNumber: 30,
            endAyahNumber: 36,
            label: 'The speech of Isa in the cradle',
            whyItMatters:
                'These verses affirm Isa\'s prophethood and servanthood to Allah.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 19,
            ayahNumber: 58,
            label: 'The prophets who fell in prostration',
            whyItMatters:
                'A moving verse linking revelation to tears, humility, and worship.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'zakariyya', label: 'Zakariyya'),
          QuranSurahNamedReference(id: 'yahya', label: 'Yahya'),
          QuranSurahNamedReference(id: 'isa', label: 'Isa'),
          QuranSurahNamedReference(id: 'ibrahim', label: 'Ibrahim'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 20,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.revelation,
          QuranSurahThemeTag.worship,
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.prophethood,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 20,
            ayahNumber: 14,
            label: 'Establish prayer for My remembrance',
            whyItMatters:
                'A key verse connecting salah to remembering Allah.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 20,
            ayahNumber: 25,
            endAyahNumber: 28,
            label: 'The prayer of Musa for openness and clarity',
            whyItMatters:
                'A beloved supplication for calm speech, ease, and expanded understanding.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 21,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.resurrection,
          QuranSurahThemeTag.tawhid,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 21,
            ayahNumber: 87,
            endAyahNumber: 88,
            label: 'The call of Yunus',
            whyItMatters:
                'These verses are often remembered for repentance, humility, and Allah\'s rescue.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 21,
            ayahNumber: 107,
            label: 'A mercy to the worlds',
            whyItMatters:
                'A central verse describing the sending of the Prophet Muhammad.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'ibrahim', label: 'Ibrahim'),
          QuranSurahNamedReference(id: 'lut', label: 'Lut'),
          QuranSurahNamedReference(id: 'nuh', label: 'Nuh'),
          QuranSurahNamedReference(id: 'dawud', label: 'Dawud'),
          QuranSurahNamedReference(id: 'sulayman', label: 'Sulayman'),
          QuranSurahNamedReference(id: 'ayyub', label: 'Ayyub'),
          QuranSurahNamedReference(id: 'yunus', label: 'Yunus'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 23,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.worship,
          QuranSurahThemeTag.resurrection,
          QuranSurahThemeTag.signsOfCreation,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 23,
            ayahNumber: 1,
            endAyahNumber: 11,
            label: 'The qualities of successful believers',
            whyItMatters:
                'The surah opens by naming lived qualities of iman, from prayer presence to guarding trusts.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 24,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.guidance,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 24,
            ayahNumber: 27,
            label: 'Do not enter homes without permission',
            whyItMatters:
                'A practical foundation for privacy, respect, and social etiquette.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 24,
            ayahNumber: 30,
            endAyahNumber: 31,
            label: 'Modesty for believing men and women',
            whyItMatters:
                'These verses tie modesty to guarding the heart, gaze, and conduct.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 24,
            ayahNumber: 35,
            label: 'The Verse of Light',
            whyItMatters:
                'A deeply reflected-upon verse on divine light, guidance, and illuminated hearts.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.broadlyAcceptedClassicalUnderstanding,
          ),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 27,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.gratitude,
          QuranSurahThemeTag.tawhid,
          QuranSurahThemeTag.prophethood,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 27,
            ayahNumber: 19,
            label: 'The gratitude prayer of Sulayman',
            whyItMatters:
                'A beautiful supplication joining gratitude, righteous action, and mercy.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
          QuranSurahNamedReference(id: 'sulayman', label: 'Sulayman'),
          QuranSurahNamedReference(id: 'salih', label: 'Salih'),
          QuranSurahNamedReference(id: 'lut', label: 'Lut'),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'queen-of-sheba', label: 'The Queen of Sheba'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 28,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.prophethood,
          QuranSurahThemeTag.justice,
          QuranSurahThemeTag.struggle,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 28,
            ayahNumber: 24,
            label: 'The dua of Musa in need',
            whyItMatters:
                'A short prayer remembered in moments of need, reliance, and hope for good.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 28,
            ayahNumber: 77,
            label: 'Seek the Hereafter without forgetting your share of the world',
            whyItMatters:
                'This verse teaches balance, generosity, and avoiding corruption.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'musa', label: 'Musa'),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'qarun', label: 'The story of Qarun'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 31,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.gratitude,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.worship,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 31,
            ayahNumber: 13,
            endAyahNumber: 19,
            label: 'The counsel of Luqman',
            whyItMatters:
                'A compact passage on tawhid, prayer, gratitude, humility, and family counsel.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'luqman-counsel', label: 'The counsel of Luqman'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 33,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.community,
          QuranSurahThemeTag.family,
          QuranSurahThemeTag.struggle,
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 33,
            ayahNumber: 21,
            label: 'The Messenger as a beautiful example',
            whyItMatters:
                'A key verse for learning steady conduct through the Prophetic example.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 33,
            ayahNumber: 35,
            label: 'A balanced list of believing qualities',
            whyItMatters:
                'This verse gathers devotion, truthfulness, patience, charity, fasting, and remembrance.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
          QuranSurahNotableAyah(
            surahNumber: 33,
            ayahNumber: 56,
            label: 'Sending blessings upon the Prophet',
            whyItMatters:
                'A central verse of salawat and reverence.',
            evidenceLevel: QuranSurahContentEvidenceLevel.quranExplicit,
          ),
        ],
        relatedEvents: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'trench', label: 'Battle of the Trench'),
        ],
      ),
      QuranSurahEnrichmentSeed(
        surahNumber: 38,
        themeTags: <QuranSurahThemeTag>[
          QuranSurahThemeTag.patience,
          QuranSurahThemeTag.justice,
          QuranSurahThemeTag.prophethood,
        ],
        relatedProphets: <QuranSurahNamedReference>[
          QuranSurahNamedReference(id: 'dawud', label: 'Dawud'),
          QuranSurahNamedReference(id: 'sulayman', label: 'Sulayman'),
          QuranSurahNamedReference(id: 'ayyub', label: 'Ayyub'),
        ],
        notableAyat: <QuranSurahNotableAyah>[
          QuranSurahNotableAyah(
            surahNumber: 38,
            ayahNumber: 41,
            endAyahNumber: 44,
            label: 'The patience of Ayyub',
            whyItMatters:
                'The passage highlights endurance in hardship and Allah\'s mercy after prolonged trial.',
            evidenceLevel:
                QuranSurahContentEvidenceLevel.widelyTaughtThematicSummary,
          ),
        ],
      ),
    ];
