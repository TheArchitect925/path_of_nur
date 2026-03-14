import 'package:flutter/material.dart';

import '../domain/trivia_models.dart';

const List<TriviaKnowledgePath> triviaKnowledgePaths = [
  TriviaKnowledgePath(
    id: 'foundations_of_islam',
    title: 'Foundations of Islam',
    description:
        'A gentle introduction to revelation, worship, prayer, fasting, and daily remembrance.',
    icon: Icons.foundation_rounded,
    stages: [
      TriviaKnowledgeStage(
        id: 'what_is_islam',
        title: 'What Is Islam?',
        learningText:
            'Islam is a path of worship, guidance, and surrender to Allah. Foundational knowledge starts with knowing the Book, the Messenger, and the acts of worship that shape daily life.',
        reference: 'Qur’an 2:2',
        questionIds: ['quran_easy_001', 'dua_easy_001', 'ramadan_easy_001'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'revelation_and_guidance',
        title: 'Revelation and Guidance',
        learningText:
            'The Qur’an was revealed as guidance. Learning how revelation began helps a believer understand why the Qur’an holds such a central place.',
        reference: 'Qur’an 2:185',
        questionIds: ['quran_easy_002', 'quran_easy_004', 'quran_easy_008'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'the_prophets',
        title: 'The Prophets',
        learningText:
            'Allah sent prophets to teach tawhid, call people to worship Him, and guide them with wisdom and patience.',
        reference: 'Qur’an 16:36',
        questionIds: ['prophets_easy_001', 'prophets_easy_003', 'prophets_easy_010'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'prayer_and_worship',
        title: 'Prayer and Worship',
        learningText:
            'Salah shapes the day and keeps the heart connected to Allah. It is among the clearest daily expressions of worship.',
        reference: 'Qur’an 20:14',
        questionIds: ['salah_easy_001', 'salah_easy_003', 'salah_easy_007'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'fasting_and_dua',
        title: 'Fasting and Du‘a',
        learningText:
            'Ramadan and supplication train the heart in taqwa, humility, gratitude, and dependence upon Allah.',
        reference: 'Qur’an 2:183',
        questionIds: ['ramadan_easy_009', 'ramadan_easy_011', 'dua_easy_005'],
        difficulty: TriviaDifficulty.medium,
      ),
    ],
  ),
  TriviaKnowledgePath(
    id: 'prophets_journey',
    title: 'The Prophets Journey',
    description:
        'Move through major prophets, their peoples, trials, and the lessons their stories teach.',
    icon: Icons.groups_rounded,
    stages: [
      TriviaKnowledgeStage(
        id: 'first_prophets',
        title: 'The First Prophets',
        learningText:
            'The stories of the earliest prophets establish the beginning of humanity’s test and the call to worship Allah alone.',
        reference: 'Qur’an 2:30-39',
        questionIds: ['prophets_easy_001', 'prophets_easy_002', 'prophets_easy_004'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'nuh_hud_salih',
        title: 'Nuh, Hud, and Salih',
        learningText:
            'These prophets called their peoples back to tawhid and warned them against arrogance and rejection.',
        questionIds: ['prophets_easy_006', 'prophets_easy_008', 'prophets_int_018'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'ibrahim_family',
        title: 'Ibrahim and His Family',
        learningText:
            'Ibrahim, peace be upon him, and his family model surrender, trust, and devotion across generations.',
        questionIds: ['prophets_easy_011', 'prophets_easy_014', 'prophets_int_026'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'musa_and_harun',
        title: 'Musa and Harun',
        learningText:
            'The story of Musa and Harun shows da‘wah, courage before tyranny, and reliance on Allah in a time of great trial.',
        questionIds: ['prophets_easy_024', 'prophets_easy_026', 'prophets_int_037'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'dawud_to_yunus',
        title: 'Kings, Wisdom, and Trial',
        learningText:
            'Dawud, Sulayman, Ayyub, and Yunus each teach different forms of gratitude, patience, repentance, and justice.',
        questionIds: ['prophets_easy_031', 'prophets_easy_035', 'prophets_int_050'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'isa_and_final_messenger',
        title: 'Isa and the Final Messenger',
        learningText:
            'The chain of prophethood leads to Prophet Muhammad ﷺ, whose mission completed and confirmed the message.',
        reference: 'Qur’an 33:40',
        questionIds: ['prophets_easy_041', 'prophets_int_061', 'prophets_hard_084'],
        difficulty: TriviaDifficulty.hard,
      ),
    ],
  ),
  TriviaKnowledgePath(
    id: 'understanding_the_quran',
    title: 'Understanding the Qur’an',
    description:
        'Learn the Qur’an’s structure, revelation, themes, and the place it holds in daily Muslim life.',
    icon: Icons.menu_book_rounded,
    stages: [
      TriviaKnowledgeStage(
        id: 'what_is_the_quran',
        title: 'What Is the Qur’an?',
        learningText:
            'The Qur’an is the revealed Book of Allah, a source of guidance, mercy, and remembrance for believers.',
        reference: 'Qur’an 2:2',
        questionIds: ['quran_easy_001', 'quran_easy_003', 'quran_easy_006'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'revelation_begins',
        title: 'How Revelation Began',
        learningText:
            'The Qur’an was revealed through Jibril and began in the blessed Night of Decree.',
        reference: 'Qur’an 97:1-5',
        questionIds: ['quran_easy_009', 'quran_easy_010', 'quran_int_046'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'structure_and_terms',
        title: 'Structure and Terms',
        learningText:
            'Terms like surah, ayah, juz, and Makki or Madani help readers understand the organization of the Qur’an.',
        questionIds: ['quran_easy_014', 'quran_easy_019', 'quran_int_057'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'famous_surahs',
        title: 'Famous Surahs',
        learningText:
            'Knowing the opening, longest, shortest, and widely loved surahs builds confidence and orientation in the Qur’an.',
        questionIds: ['quran_easy_024', 'quran_easy_029', 'quran_int_070'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'living_with_the_quran',
        title: 'Living With the Qur’an',
        learningText:
            'The Qur’an is not only recited; it is reflected upon, memorized, and lived as guidance in daily life.',
        reference: 'Qur’an 54:17',
        questionIds: ['quran_int_078', 'quran_int_081', 'quran_hard_091'],
        difficulty: TriviaDifficulty.hard,
      ),
    ],
  ),
  TriviaKnowledgePath(
    id: 'learning_salah',
    title: 'Learning Salah',
    description:
        'Build a steady understanding of prayer through preparation, structure, congregational practice, and spiritual focus.',
    icon: Icons.self_improvement_rounded,
    stages: [
      TriviaKnowledgeStage(
        id: 'five_daily_prayers',
        title: 'The Five Daily Prayers',
        learningText:
            'Salah is spread across the day, anchoring a believer in remembrance and worship.',
        reference: 'Qur’an 20:14',
        questionIds: ['salah_easy_001', 'salah_easy_002', 'salah_easy_005'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'conditions_of_prayer',
        title: 'Conditions of Prayer',
        learningText:
            'Prayer depends on preparation, including purity, facing the qiblah, and praying in the proper time.',
        questionIds: ['salah_easy_011', 'salah_easy_012', 'salah_easy_015'],
        difficulty: TriviaDifficulty.easy,
      ),
      TriviaKnowledgeStage(
        id: 'inside_a_rakah',
        title: 'Inside a Rak‘ah',
        learningText:
            'Knowing the order of standing, bowing, prostration, and sitting builds confidence in the structure of salah.',
        questionIds: ['salah_easy_019', 'salah_easy_021', 'salah_int_051'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'congregation_and_jummah',
        title: 'Congregation and Jumu‘ah',
        learningText:
            'Prayer in congregation builds unity, discipline, and shared remembrance, and Friday prayer holds a special place.',
        questionIds: ['salah_int_058', 'salah_int_063', 'salah_int_067'],
        difficulty: TriviaDifficulty.medium,
      ),
      TriviaKnowledgeStage(
        id: 'sunnah_and_khushu',
        title: 'Sunnah Prayer and Khushu',
        learningText:
            'Beyond obligation, sunnah prayers and inner focus deepen one’s relationship with salah.',
        questionIds: ['salah_int_071', 'salah_int_076', 'salah_hard_090'],
        difficulty: TriviaDifficulty.hard,
      ),
    ],
  ),
];
