import 'package:flutter/material.dart';

import '../domain/hadith_foundation_models.dart';

const _faithThemeId = 'faith_intention';
const _prayerThemeId = 'prayer';
const _characterThemeId = 'character_manners';
const _mercyThemeId = 'mercy_compassion';
const _knowledgeThemeId = 'knowledge';
const _duaThemeId = 'dua_remembrance';
const _familyThemeId = 'family';
const _justiceThemeId = 'justice_trust';
const _repentanceThemeId = 'repentance';
const _patienceThemeId = 'patience_gratitude';
const _deathHereafterThemeId = 'death_hereafter';

const essentialCollectionId = 'essential_40';

const List<HadithEntry> seededHadithEntries = [
  HadithEntry(
    id: 'intentions_core',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'Actions Are by Intentions',
    excerpt:
        'Actions are judged by intentions, and each person will have what they intended.',
    hadithText:
        'The Messenger of Allah ﷺ said: Actions are by intentions, and every person shall have what they intended.',
    arabicText:
        'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '1',
    source: 'Sahih al-Bukhari 1',
    grading: 'Sahih',
    narrator: 'Umar ibn al-Khattab (ra)',
    tags: ['Intention', 'Sincerity', 'Worship'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Bayyinah',
        surahNumber: 98,
        verseRange: '5',
        label: 'Sincere worship for Allah alone.',
      ),
      QuranConnection(
        surahName: 'Al-Mulk',
        surahNumber: 67,
        verseRange: '2',
        label: 'Actions are tested for quality and sincerity.',
      ),
    ],
    meaning:
        'This hadith places inner sincerity at the center of every outward act.',
    lessons: [
      'Purify intention before starting any deed.',
      'Hidden motives can change the spiritual weight of an action.',
    ],
    reflectionPrompts: [
      'Why am I doing this act today?',
      'How can I renew intention quietly before worship?',
    ],
    practiceAction:
        'Before prayer or study, pause for ten seconds and renew your intention.',
    relatedHadithIds: [
      'religion_sincerity',
      'lawful_unlawful_clear',
      'leave_what_not_concern',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'religion_sincerity',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId],
    title: 'Religion Is Sincere Counsel',
    excerpt:
        'Religion is sincerity to Allah, His Book, His Messenger, and the believers.',
    hadithText:
        'The Prophet ﷺ said: Religion is sincerity. We asked, to whom? He said: to Allah, His Book, His Messenger, the leaders of the Muslims, and their common people.',
    arabicText:
        'الدِّينُ النَّصِيحَةُ. قُلْنَا: لِمَنْ؟ قَالَ: لِلَّهِ وَلِكِتَابِهِ وَلِرَسُولِهِ وَلِأَئِمَّةِ الْمُسْلِمِينَ وَعَامَّتِهِمْ',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '55',
    source: 'Sahih Muslim 55',
    grading: 'Sahih',
    narrator: 'Tamim al-Dari (ra)',
    tags: ['Sincerity', 'Community', 'Faith'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '13',
        label: 'Honor is tied to taqwa, not status.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '225',
        label: 'Allah knows what hearts intend.',
      ),
    ],
    meaning:
        'Faith is not performance; it is honest loyalty to truth and responsibility.',
    lessons: [
      'Sincerity includes speech, advice, and conduct.',
      'Faith is lived through trustworthiness with people.',
    ],
    reflectionPrompts: [
      'Is my concern for others sincere or performative?',
      'Where can I bring more honesty into daily interactions?',
    ],
    practiceAction:
        'Offer one sincere private dua and one sincere piece of advice today.',
    relatedHadithIds: [
      'intentions_core',
      'love_for_brother',
      'speak_good_or_silent_faith',
    ],
  ),
  HadithEntry(
    id: 'lawful_unlawful_clear',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'The Lawful Is Clear and the Unlawful Is Clear',
    excerpt:
        'Between the clear lawful and clear unlawful are doubtful matters many people do not recognize.',
    hadithText:
        'The Messenger of Allah ﷺ said: The lawful is clear and the unlawful is clear, and between them are doubtful matters unknown to many people. Whoever avoids doubtful matters protects his religion and honor.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 52 / Muslim 1599',
    source: 'Sahih al-Bukhari 52 / Sahih Muslim 1599',
    grading: 'Muttafaqun Alayh',
    narrator: 'Al-Nu\'man ibn Bashir (ra)',
    tags: ['Halal', 'Haram', 'God-consciousness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '168',
        label: 'Consume what is lawful and wholesome.',
      ),
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '100',
        label: 'The pure and impure are not equal.',
      ),
    ],
    meaning:
        'Strong faith includes caution around doubtful matters, not only avoiding what is clearly forbidden.',
    lessons: [
      'Protecting faith includes setting boundaries before falling into wrong.',
      'Scrupulousness preserves both religion and dignity.',
      'Not every permissible-looking matter is spiritually healthy.',
    ],
    reflectionPrompts: [
      'Which doubtful habits should I step away from?',
      'Do I seek convenience or clarity in moral decisions?',
      'How do I protect my heart before mistakes happen?',
    ],
    practiceAction:
        'Identify one doubtful practice and replace it with a cleaner alternative this week.',
    relatedHadithIds: ['intentions_core', 'leave_what_not_concern'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'leave_what_not_concern',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'Leaving What Does Not Concern You',
    excerpt:
        'Part of the excellence of a person’s Islam is leaving what does not concern him.',
    hadithText:
        'The Prophet ﷺ said: Part of the excellence of a person’s Islam is leaving what does not concern him.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2317',
    source: 'Jami\' al-Tirmidhi 2317',
    grading: 'Hasan',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Focus', 'Ihsan', 'Self-discipline'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '3',
        label: 'Believers turn away from idle talk.',
      ),
      QuranConnection(
        surahName: 'Qaf',
        surahNumber: 50,
        verseRange: '18',
        label: 'Speech is recorded and accountable.',
      ),
    ],
    meaning:
        'A refined believer protects attention, words, and time from what brings no benefit.',
    lessons: [
      'Spiritual maturity includes disciplined focus.',
      'Many sins begin with unnecessary curiosity and speech.',
      'Ihsan appears in how we use daily attention.',
    ],
    reflectionPrompts: [
      'What currently consumes my attention without benefit?',
      'Where can I reduce unnecessary commentary?',
      'What would focused Islam look like in my day?',
    ],
    practiceAction:
        'Remove one recurring distraction today and redirect that time to dhikr or useful learning.',
    relatedHadithIds: ['lawful_unlawful_clear', 'speak_good_or_silent_faith'],
  ),
  HadithEntry(
    id: 'love_for_brother',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'Love for Your Brother What You Love for Yourself',
    excerpt:
        'Faith is not complete until a believer loves for others what he loves for himself.',
    hadithText:
        'The Messenger of Allah ﷺ said: None of you truly believes until he loves for his brother what he loves for himself.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 13 / Muslim 45',
    source: 'Sahih al-Bukhari 13 / Sahih Muslim 45',
    grading: 'Muttafaqun Alayh',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Brotherhood', 'Faith', 'Sincerity'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hashr',
        surahNumber: 59,
        verseRange: '9',
        label: 'Believers prefer others even when in need.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '10',
        label: 'Believers are brothers.',
      ),
    ],
    meaning:
        'True faith transforms personal desire into goodwill and care for others.',
    lessons: [
      'Iman is relational, not only private.',
      'Envy and sincere faith cannot live comfortably together.',
      'Wishing good for others purifies the heart.',
    ],
    reflectionPrompts: [
      'Who can I sincerely wish well for today?',
      'Where does comparison weaken my heart?',
      'How can I celebrate another believer’s good?',
    ],
    practiceAction:
        'Make dua for someone else’s success in a matter you also want for yourself.',
    relatedHadithIds: ['religion_sincerity', 'hearts_and_deeds'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'hearts_and_deeds',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'hadith_heart'],
    title: 'Allah Looks at Hearts and Deeds',
    excerpt:
        'Allah does not look at appearances or wealth, but at hearts and deeds.',
    hadithText:
        'The Prophet ﷺ said: Allah does not look at your bodies nor your appearances, but He looks at your hearts and your deeds.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2564',
    source: 'Sahih Muslim 2564',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Heart', 'Sincerity', 'Character'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '13',
        label: 'Nobility is by taqwa, not outward form.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '225',
        label: 'Allah takes account of what hearts earn.',
      ),
    ],
    meaning:
        'Outward image does not define worth before Allah; inner sincerity and righteous action do.',
    lessons: [
      'Inner reform is central to spiritual growth.',
      'Appearance-focused faith is fragile.',
      'Actions and hearts are judged together.',
    ],
    reflectionPrompts: [
      'What inner intention needs repair right now?',
      'Where do I focus too much on appearance?',
      'What deed can I purify quietly for Allah?',
    ],
    practiceAction:
        'Do one hidden good deed today that no one else knows about.',
    relatedHadithIds: ['intentions_core', 'religion_sincerity'],
  ),
  HadithEntry(
    id: 'strong_believer',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'The Strong Believer',
    excerpt:
        'The strong believer is better and more beloved to Allah than the weak believer, though both contain good.',
    hadithText:
        'The Messenger of Allah ﷺ said: The strong believer is better and more beloved to Allah than the weak believer, though in both there is good. Be eager for what benefits you, seek help from Allah, and do not give up.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2664',
    source: 'Sahih Muslim 2664',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Strength', 'Reliance', 'Growth'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Anfal',
        surahNumber: 8,
        verseRange: '60',
        label: 'Prepare strength as much as possible.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Resolve, then rely on Allah.',
      ),
    ],
    meaning:
        'Faith seeks beneficial strength of heart, mind, and action while staying dependent on Allah.',
    lessons: [
      'Islam encourages proactive effort, not passivity.',
      'Strength includes resilience, discipline, and beneficial action.',
      'Reliance on Allah and effort belong together.',
    ],
    reflectionPrompts: [
      'Which area of beneficial strength needs growth in me?',
      'Do I stop at intention without action?',
      'How can I combine effort with tawakkul this week?',
    ],
    practiceAction:
        'Choose one beneficial goal today, take a clear step, and ask Allah for help.',
    relatedHadithIds: ['intentions_core', 'hearts_and_deeds'],
  ),
  HadithEntry(
    id: 'speak_good_or_silent_faith',
    themeId: _faithThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'Speak Good or Remain Silent',
    excerpt:
        'Whoever believes in Allah and the Last Day should speak good or remain silent.',
    hadithText:
        'The Messenger of Allah ﷺ said: Whoever believes in Allah and the Last Day, let him speak good or remain silent.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6018 / Muslim 47',
    source: 'Sahih al-Bukhari 6018 / Muslim 47',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Speech', 'Faith', 'Adab'],
    quranConnections: [
      QuranConnection(
        surahName: 'Qaf',
        surahNumber: 50,
        verseRange: '18',
        label: 'Every utterance is recorded.',
      ),
      QuranConnection(
        surahName: 'Al-Isra',
        surahNumber: 17,
        verseRange: '53',
        label: 'Speak in the best manner.',
      ),
    ],
    meaning:
        'Faith is measured through speech discipline: speak truth and benefit, or choose restraint.',
    lessons: [
      'Speech can either increase faith or harm it.',
      'Silence is sometimes the wiser form of remembrance.',
      'Belief in the Last Day should shape daily words.',
    ],
    reflectionPrompts: [
      'Which words today were unnecessary?',
      'How can I make my speech more truthful and gentle?',
      'When is silence the better response?',
    ],
    practiceAction:
        'In one conversation today, intentionally replace reactive words with calm and useful speech.',
    relatedHadithIds: ['leave_what_not_concern', 'religion_sincerity'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'islam_built_on_five_prayer',
    themeId: _prayerThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set', 'prayer_devotion'],
    title: 'Islam Is Built on Five',
    excerpt:
        'Salah is one of the five foundational pillars upon which Islam is built.',
    hadithText:
        'The Messenger of Allah ﷺ said: Islam is built on five: testimony that there is no god but Allah and that Muhammad is the Messenger of Allah, establishing prayer, giving zakah, fasting Ramadan, and Hajj for whoever is able.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 8 / Muslim 16',
    source: 'Sahih al-Bukhari 8 / Sahih Muslim 16',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Pillars', 'Salah', 'Foundations'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '43',
        label: 'Establish prayer and bow with those who bow.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '103',
        label: 'Prayer is prescribed at fixed times.',
      ),
    ],
    meaning:
        'Prayer is not a minor add-on in Islam; it is a central pillar that structures a believer’s life.',
    lessons: [
      'Salah anchors the daily rhythm of faith.',
      'Foundations must be protected before optional additions.',
      'Commitment to prayer protects the rest of religious life.',
    ],
    reflectionPrompts: [
      'How central is salah in my daily schedule?',
      'Do I treat prayer as a pillar or an occasional act?',
      'What change would help me guard prayer times better?',
    ],
    practiceAction:
        'Set one fixed preparation step before each fard prayer today (adhan reminder, early wudu, or calm transition).',
    relatedHadithIds: ['pray_as_you_have_seen_me', 'first_account_prayer'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'covenant_is_prayer',
    themeId: _prayerThemeId,
    collectionIds: [essentialCollectionId, 'prayer_devotion'],
    title: 'The Covenant Between Us and Them Is Prayer',
    excerpt:
        'Prayer is a defining covenant and boundary marker of Islamic commitment.',
    hadithText:
        'The Prophet ﷺ said: The covenant that stands between us and them is prayer; whoever abandons it has fallen into disbelief.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2621',
    source: 'Jami\' al-Tirmidhi 2621',
    grading: 'Sahih',
    narrator: 'Buraydah ibn al-Hasib (ra)',
    tags: ['Covenant', 'Prayer', 'Commitment'],
    quranConnections: [
      QuranConnection(
        surahName: 'At-Tawbah',
        surahNumber: 9,
        verseRange: '11',
        label: 'Establishing prayer marks covenantal belonging.',
      ),
      QuranConnection(
        surahName: 'Al-Muddaththir',
        surahNumber: 74,
        verseRange: '42-43',
        label: 'Neglect of prayer is a grave spiritual loss.',
      ),
    ],
    meaning:
        'The hadith emphasizes the seriousness of guarding prayer as a lived sign of faith and covenant.',
    lessons: [
      'Prayer is a boundary of identity, not only devotion.',
      'Neglecting prayer harms the heart over time.',
      'Seriousness in salah reflects seriousness in faith.',
    ],
    reflectionPrompts: [
      'Where has inconsistency in prayer entered my routine?',
      'What practical step will protect my prayers this week?',
      'How can I rebuild reverence for salah?',
    ],
    practiceAction:
        'Choose one currently weak prayer time and protect it fully for the next 7 days.',
    relatedHadithIds: ['islam_built_on_five_prayer', 'first_account_prayer'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'first_account_prayer',
    themeId: _prayerThemeId,
    collectionIds: [essentialCollectionId, 'prayer_devotion'],
    title:
        'The First Matter a Servant Will Be Brought to Account for Is Prayer',
    excerpt: 'Prayer will be the first deed examined on the Day of Judgment.',
    hadithText:
        'The Messenger of Allah ﷺ said: The first matter the servant will be brought to account for on the Day of Resurrection is prayer. If it is sound, the rest of his deeds are sound; if it is deficient, the rest of his deeds are deficient.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '413',
    source: 'Jami\' al-Tirmidhi 413',
    grading: 'Hasan',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Accountability', 'Prayer', 'Akhirah'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '1-2',
        label: 'Success begins with humble devotion in prayer.',
      ),
      QuranConnection(
        surahName: 'Al-Ma\'un',
        surahNumber: 107,
        verseRange: '4-5',
        label: 'Warning for neglectful prayer.',
      ),
    ],
    meaning:
        'Prayer is the primary barometer of a believer’s relationship with Allah and influences the state of other deeds.',
    lessons: [
      'Guarding prayer is guarding one’s hereafter record.',
      'Quality of salah matters, not just completion.',
      'Repairing prayer can repair the wider spiritual life.',
    ],
    reflectionPrompts: [
      'What is one weakness in my current salah quality?',
      'Do I rush prayer in a way that empties presence?',
      'How can I prepare for prayer before takbir?',
    ],
    practiceAction:
        'Before one prayer today, sit quietly for one minute to enter with intention and presence.',
    relatedHadithIds: ['islam_built_on_five_prayer', 'closest_in_sujud'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'pray_as_you_have_seen_me',
    themeId: _prayerThemeId,
    collectionIds: [essentialCollectionId, 'daily_sunnah', 'prayer_devotion'],
    title: 'Pray as You Have Seen Me Pray',
    excerpt:
        'The prophetic method of prayer is the model for the believer’s salah.',
    hadithText: 'The Prophet ﷺ said: Pray as you have seen me pray.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '631',
    source: 'Sahih al-Bukhari 631',
    grading: 'Sahih',
    narrator: 'Malik ibn al-Huwayrith (ra)',
    tags: ['Sunnah', 'Method', 'Prayer'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '21',
        label: 'The Messenger is the best practical example.',
      ),
      QuranConnection(
        surahName: 'Al-Hashr',
        surahNumber: 59,
        verseRange: '7',
        label: 'Take what the Messenger gives you.',
      ),
    ],
    meaning:
        'Prayer is learned through prophetic practice, not personal improvisation.',
    lessons: [
      'Following Sunnah increases correctness and spiritual depth.',
      'Learning prayer details is part of honoring worship.',
      'Small prophetic practices elevate consistency.',
    ],
    reflectionPrompts: [
      'Which part of my prayer needs sunnah-based improvement?',
      'How often do I learn about prayer beyond basics?',
      'What one prophetic prayer practice can I adopt this week?',
    ],
    practiceAction:
        'Review one verified prayer sunnah today and apply it in the next salah.',
    relatedHadithIds: ['islam_built_on_five_prayer', 'wudu_then_prayer'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'conversation_with_lord',
    themeId: _prayerThemeId,
    collectionIds: ['prayer_devotion', 'hadith_heart'],
    title: 'When One of You Stands in Prayer, He Is Conversing with His Lord',
    excerpt:
        'When a believer stands in prayer, he stands in intimate worship before Allah.',
    hadithText:
        'The Prophet ﷺ said: When one of you stands in prayer, he is conversing with his Lord.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '405',
    source: 'Sahih al-Bukhari 405',
    grading: 'Sahih',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Khushu', 'Presence', 'Prayer'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '1-2',
        label: 'Believers are humble and present in prayer.',
      ),
      QuranConnection(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '14',
        label: 'Establish prayer for My remembrance.',
      ),
    ],
    meaning:
        'Prayer is a living meeting with Allah, not a mechanical sequence of movements.',
    lessons: [
      'Khushu grows when prayer is treated as intimate conversation.',
      'Mindful recitation deepens spiritual benefit.',
      'Presence in salah can heal scattered hearts.',
    ],
    reflectionPrompts: [
      'Do I enter prayer with awareness of Who I am standing before?',
      'What distracts my heart most in salah?',
      'How can I increase calm presence in recitation?',
    ],
    practiceAction:
        'In your next prayer, slow down recitation and consciously reflect on one verse.',
    relatedHadithIds: ['closest_in_sujud', 'pray_as_you_have_seen_me'],
  ),
  HadithEntry(
    id: 'closest_in_sujud',
    themeId: _prayerThemeId,
    collectionIds: ['prayer_devotion', 'hadith_heart'],
    title: 'The Closest a Servant Is to His Lord Is While in Prostration',
    excerpt:
        'Sujud is one of the closest moments between a servant and Allah, so increase supplication in it.',
    hadithText:
        'The Messenger of Allah ﷺ said: The closest a servant comes to his Lord is when he is prostrating, so increase your supplication.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '482',
    source: 'Sahih Muslim 482',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Sujud', 'Du\'a', 'Nearness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-\'Alaq',
        surahNumber: 96,
        verseRange: '19',
        label: 'Prostrate and draw near.',
      ),
      QuranConnection(
        surahName: 'Al-Isra',
        surahNumber: 17,
        verseRange: '109',
        label: 'Prostration expresses humility and devotion.',
      ),
    ],
    meaning:
        'Sujud is both humility and intimacy; it is a prime time for sincere dua.',
    lessons: [
      'Nearness to Allah is sought through humility, not ego.',
      'Sujud is a spiritual opening for focused supplication.',
      'Physical humility can soften the inner self.',
    ],
    reflectionPrompts: [
      'What do I ask Allah for most in sujud?',
      'Do I rush through prostration?',
      'How can sujud become more sincere and present?',
    ],
    practiceAction:
        'In one sujud today, make a heartfelt personal dua and remain a few extra moments.',
    relatedHadithIds: ['conversation_with_lord', 'first_account_prayer'],
  ),
  HadithEntry(
    id: 'wudu_then_prayer',
    themeId: _prayerThemeId,
    collectionIds: ['daily_sunnah', 'prayer_devotion', essentialCollectionId],
    title: 'Whoever Makes Wudu Well, Then Prays...',
    excerpt:
        'Complete wudu and sincere prayer become a means of forgiveness for past sins.',
    hadithText:
        'The Prophet ﷺ taught that whoever performs wudu well and then prays with presence and humility, his previous sins are forgiven.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 160 / Muslim 226',
    source: 'Sahih al-Bukhari 160 / Sahih Muslim 226',
    grading: 'Muttafaqun Alayh',
    narrator: 'Uthman ibn Affan (ra)',
    tags: ['Wudu', 'Purification', 'Forgiveness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '6',
        label: 'Command and method of purification before prayer.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '222',
        label: 'Allah loves those who purify themselves.',
      ),
    ],
    meaning:
        'Outer purification prepares inner presence, and sincere salah becomes a path of renewal.',
    lessons: [
      'Careful wudu sets the tone for mindful prayer.',
      'Allah opens forgiveness through repeated acts of worship.',
      'Preparation quality affects prayer quality.',
    ],
    reflectionPrompts: [
      'How attentive am I during wudu?',
      'Do I treat purification as routine or spiritual preparation?',
      'What helps me bring humility into prayer after wudu?',
    ],
    practiceAction:
        'Perform wudu slowly once today and pray immediately after with focused intention.',
    relatedHadithIds: [
      'pray_as_you_have_seen_me',
      'islam_built_on_five_prayer',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'congregation_superior',
    themeId: _prayerThemeId,
    collectionIds: ['daily_sunnah', 'prayer_devotion', essentialCollectionId],
    title: 'Prayer in Congregation Is Superior...',
    excerpt:
        'Congregational prayer carries multiplied reward over praying alone.',
    hadithText:
        'The Messenger of Allah ﷺ said: Prayer in congregation is superior to prayer alone by twenty-seven degrees.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 645 / Muslim 650',
    source: 'Sahih al-Bukhari 645 / Sahih Muslim 650',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Jama\'ah', 'Community', 'Reward'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '43',
        label: 'Establish prayer with those who bow.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '102',
        label: 'Congregational prayer is upheld even in hardship.',
      ),
    ],
    meaning:
        'Congregational prayer strengthens both personal devotion and communal unity.',
    lessons: [
      'Prayer is both individual worship and communal bond.',
      'Regular jama\'ah builds discipline and belonging.',
      'Shared worship increases consistency and reward.',
    ],
    reflectionPrompts: [
      'How often do I prioritize congregational prayer when possible?',
      'What blocks me from joining jama\'ah more consistently?',
      'How does praying with others affect my motivation?',
    ],
    practiceAction:
        'Join at least one congregational prayer this week with intentional presence.',
    relatedHadithIds: ['islam_built_on_five_prayer', 'covenant_is_prayer'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'kind_speech',
    themeId: _characterThemeId,
    collectionIds: ['daily_sunnah', essentialCollectionId],
    title: 'Speak Good or Remain Silent',
    excerpt:
        'Whoever believes in Allah and the Last Day should speak good or remain silent.',
    hadithText:
        'The Messenger of Allah ﷺ said: Whoever believes in Allah and the Last Day, let him speak good or remain silent.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6018 / Muslim 47',
    source: 'Sahih al-Bukhari 6018 / Muslim 47',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Speech', 'Character', 'Adab'],
    quranConnections: [
      QuranConnection(
        surahName: 'Qaf',
        surahNumber: 50,
        verseRange: '18',
        label: 'Every word is witnessed and recorded.',
      ),
    ],
    meaning:
        'Speech is worship territory; restraint can be a form of obedience.',
    lessons: [
      'Words can heal or wound.',
      'Silence can protect faith and relationships.',
    ],
    reflectionPrompts: [
      'Which conversation today needed more wisdom?',
      'What type of speech do I need to reduce?',
    ],
    practiceAction:
        'Before responding in one difficult moment, take a short pause.',
    relatedHadithIds: [
      'truthfulness_to_righteousness',
      'anger_control_strength',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'sent_to_perfect_character',
    themeId: _characterThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'I Was Sent to Perfect Noble Character',
    excerpt:
        'The Prophet ﷺ described his mission as completing and perfecting noble character.',
    hadithText:
        'The Messenger of Allah ﷺ said: I was only sent to perfect noble character.',
    sourceCollection: 'Musnad Ahmad',
    sourceReference: '8952',
    source: 'Musnad Ahmad 8952',
    grading: 'Sahih (authenticated by later scholars)',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Character', 'Mission', 'Adab'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Qalam',
        surahNumber: 68,
        verseRange: '4',
        label: 'The Prophet ﷺ is upon magnificent character.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '21',
        label: 'The Messenger ﷺ is the best example.',
      ),
    ],
    meaning:
        'Character is not secondary in Islam; it is central to the Prophetic mission and to lived faith.',
    lessons: [
      'Good character is a core expression of religion.',
      'Spiritual growth must appear in behavior, not only knowledge.',
      'Following the Sunnah includes refining conduct.',
    ],
    reflectionPrompts: [
      'Which part of my character needs the most refinement right now?',
      'How is my faith visible in daily behavior?',
      'What prophetic quality can I intentionally practice this week?',
    ],
    practiceAction:
        'Choose one character trait (patience, gentleness, honesty) and practice it intentionally in three interactions today.',
    relatedHadithIds: [
      'best_character_among_you',
      'truthfulness_to_righteousness',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'best_character_among_you',
    themeId: _characterThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'The Best of You Are Those with the Best Character',
    excerpt:
        'Excellence among believers is measured by noble character and treatment of others.',
    hadithText:
        'The Prophet ﷺ said: The best among you are those who have the best character.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '3559',
    source: 'Sahih al-Bukhari 3559',
    grading: 'Sahih',
    narrator: 'Abdullah ibn Amr (ra)',
    tags: ['Character', 'Excellence', 'Community'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice, excellence, and good conduct.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Gentleness and mercy are central to leadership.',
      ),
    ],
    meaning:
        'The hadith places moral excellence at the center of true human and spiritual excellence.',
    lessons: [
      'Character determines the real quality of faith.',
      'Good manners are a form of worship.',
      'High status with Allah is linked to how we treat people.',
    ],
    reflectionPrompts: [
      'How would people closest to me describe my character?',
      'Which behavior weakens my moral consistency?',
      'What does “best character” look like in my home and work?',
    ],
    practiceAction:
        'Practice one deliberate act of gentleness in a difficult interaction today.',
    relatedHadithIds: ['sent_to_perfect_character', 'smiling_is_charity'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'not_insulting_or_cursing',
    themeId: _characterThemeId,
    collectionIds: ['character_builder', 'daily_sunnah'],
    title: 'A Believer Is Not One Who Insults or Curses',
    excerpt: 'Faithful character avoids insult, cursing, and indecent speech.',
    hadithText:
        'The Messenger of Allah ﷺ said: A believer is not one who insults, curses, uses obscene language, or speaks indecently.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1977',
    source: 'Jami\' al-Tirmidhi 1977',
    grading: 'Hasan',
    narrator: 'Abdullah ibn Mas\'ud (ra)',
    tags: ['Speech', 'Dignity', 'Self-control'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '11',
        label: 'Do not mock, insult, or call one another by offensive names.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '12',
        label: 'Avoid suspicion, spying, and backbiting.',
      ),
    ],
    meaning:
        'Belief is reflected in disciplined language and dignified treatment of others, even in disagreement.',
    lessons: [
      'Verbal harm is a serious moral issue in Islam.',
      'Self-control in speech protects hearts and relationships.',
      'Refined language is part of prophetic manners.',
    ],
    reflectionPrompts: [
      'Do I use words that belittle others when upset?',
      'Which speech habit most needs repentance and reform?',
      'How can I disagree without disrespect?',
    ],
    practiceAction:
        'Avoid all insulting or sarcastic comments today, especially in moments of frustration.',
    relatedHadithIds: ['kind_speech', 'anger_control_strength'],
  ),
  HadithEntry(
    id: 'merciful_shown_mercy_character',
    themeId: _characterThemeId,
    collectionIds: ['character_builder', 'hadith_heart', essentialCollectionId],
    title: 'The Merciful Are Shown Mercy by the Most Merciful',
    excerpt: 'Showing mercy to people invites Allah’s mercy upon the believer.',
    hadithText:
        'The Prophet ﷺ said: The merciful are shown mercy by the Most Merciful. Show mercy to those on earth, and the One above the heavens will show mercy to you.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1924',
    source: 'Jami\' al-Tirmidhi 1924',
    grading: 'Hasan Sahih',
    narrator: 'Abdullah ibn Amr (ra)',
    tags: ['Mercy', 'Compassion', 'Character'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '107',
        label: 'The Prophet ﷺ was sent as mercy to the worlds.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Mercy and gentleness soften hearts.',
      ),
    ],
    meaning:
        'Mercy toward people is both a prophetic ethic and a means of receiving divine mercy.',
    lessons: [
      'Compassion is strength, not weakness.',
      'Mercy begins with those nearest to us.',
      'How we treat creation is linked to spiritual state.',
    ],
    reflectionPrompts: [
      'Where in my life do I need to replace harshness with mercy?',
      'How does mercy appear in my tone and choices?',
      'Who needs gentleness from me right now?',
    ],
    practiceAction:
        'Do one intentional act of compassion today for someone you usually overlook.',
    relatedHadithIds: ['best_character_among_you', 'smiling_is_charity'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'anger_control_strength',
    themeId: _characterThemeId,
    collectionIds: ['character_builder', 'daily_sunnah'],
    title: 'The Strong Person Controls His Anger',
    excerpt:
        'True strength is not overpowering others, but mastering oneself at the time of anger.',
    hadithText:
        'The Prophet ﷺ said: The strong one is not the one who overcomes people by force, but the strong one is the one who controls himself while angry.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6114 / Muslim 2609',
    source: 'Sahih al-Bukhari 6114 / Sahih Muslim 2609',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Anger', 'Self-control', 'Strength'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '134',
        label: 'The righteous restrain anger and pardon people.',
      ),
      QuranConnection(
        surahName: 'Fussilat',
        surahNumber: 41,
        verseRange: '34',
        label: 'Repel evil with what is better.',
      ),
    ],
    meaning:
        'Inner self-control during anger is a higher form of strength than outward dominance.',
    lessons: [
      'Uncontrolled anger damages faith and relationships.',
      'Spiritual maturity appears in emotional discipline.',
      'Calm restraint can transform conflict.',
    ],
    reflectionPrompts: [
      'What patterns trigger my anger most quickly?',
      'How do I behave when I feel provoked?',
      'What step can help me pause before reacting?',
    ],
    practiceAction:
        'When anger rises today, pause, seek refuge in Allah, and delay your response by a few moments.',
    relatedHadithIds: ['not_insulting_or_cursing', 'kind_speech'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'smiling_is_charity',
    themeId: _characterThemeId,
    collectionIds: ['daily_sunnah', 'character_builder', 'beginner_set'],
    title: 'Smiling at Your Brother Is Charity',
    excerpt:
        'A sincere smile is counted as charity and part of prophetic social character.',
    hadithText:
        'The Messenger of Allah ﷺ said: Your smile to your brother is charity.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1956',
    source: 'Jami\' al-Tirmidhi 1956',
    grading: 'Hasan',
    narrator: 'Abu Dharr (ra)',
    tags: ['Kindness', 'Charity', 'Social Ethics'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Excellence includes small daily acts of goodness.',
      ),
      QuranConnection(
        surahName: 'Fussilat',
        surahNumber: 41,
        verseRange: '34',
        label: 'Good conduct can transform relationships.',
      ),
    ],
    meaning:
        'Small, sincere acts of kindness are spiritually meaningful and socially healing.',
    lessons: [
      'Good character is built through small repeated actions.',
      'Charity is broader than financial giving.',
      'Warmth and kindness can soften hearts.',
    ],
    reflectionPrompts: [
      'How often do I bring warmth into daily interactions?',
      'Do I underestimate small deeds of goodness?',
      'Who can benefit from a gentle presence from me today?',
    ],
    practiceAction:
        'Offer a sincere smile and kind greeting to at least three people today.',
    relatedHadithIds: [
      'best_character_among_you',
      'merciful_shown_mercy_character',
    ],
  ),
  HadithEntry(
    id: 'truthfulness_to_righteousness',
    themeId: _characterThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'Truthfulness Leads to Righteousness',
    excerpt:
        'Consistent truthfulness leads to righteousness and ultimately to Paradise.',
    hadithText:
        'The Prophet ﷺ said: Truthfulness leads to righteousness, and righteousness leads to Paradise. A person keeps speaking the truth until he is recorded with Allah as truthful.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6094 / Muslim 2607',
    source: 'Sahih al-Bukhari 6094 / Sahih Muslim 2607',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abdullah ibn Mas\'ud (ra)',
    tags: ['Truthfulness', 'Integrity', 'Righteousness'],
    quranConnections: [
      QuranConnection(
        surahName: 'At-Tawbah',
        surahNumber: 9,
        verseRange: '119',
        label: 'O believers, be with the truthful.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '70',
        label: 'Speak words that are right and sound.',
      ),
    ],
    meaning:
        'Truthfulness is not occasional speech etiquette; it is a path that forms character and destiny.',
    lessons: [
      'Truth builds spiritual and moral consistency.',
      'Small lies weaken the heart over time.',
      'Integrity in speech is a gateway to righteousness.',
    ],
    reflectionPrompts: [
      'Where am I tempted to be less than fully truthful?',
      'How can I practice honesty with wisdom and kindness?',
      'What does truthful living look like in private life?',
    ],
    practiceAction:
        'Commit to complete truthfulness today in speech, promises, and reporting facts.',
    relatedHadithIds: ['sent_to_perfect_character', 'kind_speech'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'mercy_creation',
    themeId: _mercyThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'The Merciful Are Shown Mercy by the Most Merciful',
    excerpt:
        'Those who show mercy to creation are shown mercy by the Most Merciful.',
    hadithText:
        'The Prophet ﷺ said: The merciful are shown mercy by the Most Merciful. Show mercy to those on earth, and the One above the heavens will show mercy to you.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1924',
    source: 'Sunan al-Tirmidhi 1924',
    grading: 'Hasan Sahih',
    narrator: 'Abdullah ibn Amr (ra)',
    tags: ['Mercy', 'Compassion', 'Character'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '107',
        label: 'The Prophet ﷺ sent as mercy.',
      ),
    ],
    meaning:
        'Mercy in daily dealings opens doors of divine mercy for the servant.',
    lessons: [
      'Compassion is a prophetic trait.',
      'Mercy begins with people nearest to us.',
    ],
    reflectionPrompts: [
      'Where can I replace hardness with mercy this week?',
      'How does mercy appear in speech and tone?',
    ],
    practiceAction:
        'Do one intentional act of gentleness today with family or colleagues.',
    relatedHadithIds: ['no_mercy_no_mercy', 'gentleness_all_matters'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'no_mercy_no_mercy',
    themeId: _mercyThemeId,
    collectionIds: ['heart_softening', 'character_builder'],
    title: 'Whoever Does Not Show Mercy Will Not Be Shown Mercy',
    excerpt:
        'A heart that refuses mercy to others closes itself from receiving mercy.',
    hadithText:
        'The Messenger of Allah ﷺ said: Whoever does not show mercy will not be shown mercy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 7376 / Muslim 2318',
    source: 'Sahih al-Bukhari 7376 / Sahih Muslim 2318',
    grading: 'Muttafaqun Alayh',
    narrator: 'Jarir ibn Abdullah (ra)',
    tags: ['Mercy', 'Compassion', 'Heart'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '156',
        label: 'Allah\'s mercy encompasses all things.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Mercy and gentleness are prophetic conduct.',
      ),
    ],
    meaning:
        'The hadith teaches reciprocity: mercy shown to others invites mercy from Allah.',
    lessons: [
      'Mercy is a spiritual obligation, not optional softness.',
      'Hardness toward others harms one\'s own heart.',
      'Compassion reflects sincerity of faith.',
    ],
    reflectionPrompts: [
      'Where have I become emotionally hard toward others?',
      'How can I respond with mercy instead of reaction?',
      'What blocks me from showing compassion consistently?',
    ],
    practiceAction:
        'Show one unexpected act of mercy today to someone difficult for you.',
    relatedHadithIds: ['mercy_creation', 'relieve_believer_hardship'],
  ),
  HadithEntry(
    id: 'gentleness_all_matters',
    themeId: _mercyThemeId,
    collectionIds: ['daily_sunnah', 'character_builder', 'heart_softening'],
    title: 'Allah Is Gentle and Loves Gentleness in All Matters',
    excerpt:
        'Allah loves gentleness, and gentleness beautifies actions and relationships.',
    hadithText:
        'The Prophet ﷺ said: Allah is gentle and loves gentleness in all matters.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6024 / Muslim 2165',
    source: 'Sahih al-Bukhari 6024 / Sahih Muslim 2165',
    grading: 'Muttafaqun Alayh',
    narrator: 'Aishah (ra)',
    tags: ['Gentleness', 'Mercy', 'Character'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'By Allah\'s mercy, you were gentle with them.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands excellence and right conduct.',
      ),
    ],
    meaning:
        'Gentleness is not weakness; it is a prophetic mode of strength and wisdom.',
    lessons: [
      'Gentleness increases acceptance and healing.',
      'Harshness often destroys what it tries to fix.',
      'Mercy in tone can transform outcomes.',
    ],
    reflectionPrompts: [
      'How do I speak when stressed or rushed?',
      'Where does gentleness need to replace harshness in my life?',
      'What would prophetic gentleness look like in conflict?',
    ],
    practiceAction:
        'In one tense interaction today, lower your tone and choose gentle wording.',
    relatedHadithIds: ['mercy_creation', 'shortened_prayer_child_cry'],
  ),
  HadithEntry(
    id: 'woman_cruelty_cat',
    themeId: _mercyThemeId,
    collectionIds: ['heart_softening'],
    title: 'A Woman Punished for Cruelty to a Cat',
    excerpt:
        'Cruelty to animals is a moral failure with serious spiritual consequence.',
    hadithText:
        'The Messenger ﷺ informed about a woman who was punished because she confined a cat until it died; she neither fed it nor let it find food.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 3318 / Muslim 2242',
    source: 'Sahih al-Bukhari 3318 / Sahih Muslim 2242',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Animals', 'Mercy', 'Responsibility'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-An\'am',
        surahNumber: 6,
        verseRange: '38',
        label: 'Creatures are communities like you.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Justice and excellence include treatment of all creation.',
      ),
    ],
    meaning:
        'Mercy in Islam includes vulnerable creatures; harm to them is morally serious.',
    lessons: [
      'Compassion extends beyond human beings.',
      'Power over the weak carries accountability.',
      'Neglect can be a form of cruelty.',
    ],
    reflectionPrompts: [
      'How do I treat creatures and the environment around me?',
      'Do I overlook harm because it seems small?',
      'Where can I be more responsible toward the vulnerable?',
    ],
    practiceAction:
        'Do one act of care for an animal, plant, or shared environment today.',
    relatedHadithIds: ['man_forgiven_water_dog', 'mercy_creation'],
  ),
  HadithEntry(
    id: 'man_forgiven_water_dog',
    themeId: _mercyThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'A Man Forgiven for Giving Water to a Dog',
    excerpt:
        'A small sincere act of mercy can become a means of Allah\'s forgiveness.',
    hadithText:
        'The Prophet ﷺ told of a man who saw a thirsty dog, gave it water, and Allah forgave him for that act.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 3321 / Muslim 2244',
    source: 'Sahih al-Bukhari 3321 / Sahih Muslim 2244',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Mercy', 'Forgiveness', 'Small Deeds'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zalzalah',
        surahNumber: 99,
        verseRange: '7',
        label: 'Even the smallest good deed is seen.',
      ),
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '156',
        label: 'Allah\'s mercy is vast and encompassing.',
      ),
    ],
    meaning: 'No sincere act of compassion is insignificant before Allah.',
    lessons: [
      'Small deeds can carry immense spiritual weight.',
      'Mercy opens doors to forgiveness.',
      'Believers should never underestimate simple good.',
    ],
    reflectionPrompts: [
      'Which small acts of compassion am I neglecting?',
      'Do I underestimate simple opportunities for mercy?',
      'How can I make kindness more immediate in daily life?',
    ],
    practiceAction:
        'Do one small act of help today without waiting for recognition.',
    relatedHadithIds: ['woman_cruelty_cat', 'relieve_believer_hardship'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'stood_for_funeral_procession',
    themeId: _mercyThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'The Prophet ﷺ Stood for a Funeral Procession',
    excerpt:
        'The Prophet ﷺ honored human dignity by standing for a passing funeral procession.',
    hadithText:
        'When a funeral passed by, the Prophet ﷺ stood. When told it was a Jewish funeral, he replied: Is it not a human soul?',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 1312 / Muslim 961',
    source: 'Sahih al-Bukhari 1312 / Sahih Muslim 961',
    grading: 'Muttafaqun Alayh',
    narrator: 'Jabir ibn Abdullah (ra)',
    tags: ['Dignity', 'Respect', 'Mercy'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Isra',
        surahNumber: 17,
        verseRange: '70',
        label: 'Allah has honored the children of Adam.',
      ),
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '32',
        label: 'The sanctity of life and human dignity.',
      ),
    ],
    meaning:
        'Mercy includes honoring human dignity and responding with respect, even across difference.',
    lessons: [
      'Islam teaches dignity and respect for all human life.',
      'Compassion includes social conduct and public manners.',
      'Prophetic mercy crosses social boundaries.',
    ],
    reflectionPrompts: [
      'Do I preserve dignity in how I view those different from me?',
      'How can respect become more visible in my behavior?',
      'Where can I replace dismissiveness with human concern?',
    ],
    practiceAction:
        'Show deliberate respect today to someone outside your usual social circle.',
    relatedHadithIds: ['gentleness_all_matters', 'relieve_believer_hardship'],
  ),
  HadithEntry(
    id: 'shortened_prayer_child_cry',
    themeId: _mercyThemeId,
    collectionIds: ['daily_sunnah', 'prayer_devotion'],
    title: 'The Prophet ﷺ Shortened Prayer When a Child Cried',
    excerpt:
        'The Prophet ﷺ adjusted prayer out of mercy for mothers and families.',
    hadithText:
        'The Prophet ﷺ said that he would begin prayer intending to lengthen it, then hear a child cry and shorten it, knowing the distress of the child\'s mother.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '707',
    source: 'Sahih al-Bukhari 707',
    grading: 'Sahih',
    narrator: 'Abu Qatadah (ra)',
    tags: ['Prayer', 'Mercy', 'Family'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Mercy and gentleness guide leadership.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '185',
        label: 'Allah intends ease, not hardship.',
      ),
    ],
    meaning:
        'Prophetic devotion was never detached from people\'s real needs; mercy shaped even acts of worship.',
    lessons: [
      'Mercy should guide religious leadership and practice.',
      'Sunnah balances devotion with sensitivity.',
      'Considering others\' hardship is part of piety.',
    ],
    reflectionPrompts: [
      'Do I make religion easier or harder for people around me?',
      'How can I be more considerate in communal settings?',
      'Where do I need more empathy in leadership or family roles?',
    ],
    practiceAction:
        'In one shared setting today, make a considerate adjustment for someone\'s need.',
    relatedHadithIds: ['conversation_with_lord', 'gentleness_all_matters'],
  ),
  HadithEntry(
    id: 'relieve_believer_hardship',
    themeId: _mercyThemeId,
    collectionIds: ['daily_sunnah', 'character_builder', essentialCollectionId],
    title: 'Whoever Relieves a Believer\'s Hardship',
    excerpt:
        'Relieving others\' hardship is met by Allah relieving one\'s hardship in this life and the next.',
    hadithText:
        'The Messenger of Allah ﷺ said: Whoever relieves a believer of a hardship from the hardships of this world, Allah will relieve him of a hardship from the hardships of the Day of Resurrection.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2699',
    source: 'Sahih Muslim 2699',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Service', 'Compassion', 'Community'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Balad',
        surahNumber: 90,
        verseRange: '17',
        label: 'Be among those who encourage patience and mercy.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice and goodness.',
      ),
    ],
    meaning:
        'Compassion is practical: removing burdens from others is a path to Allah\'s help.',
    lessons: [
      'Mercy is demonstrated through concrete assistance.',
      'Serving others invites divine aid.',
      'Community strength grows through mutual support.',
    ],
    reflectionPrompts: [
      'Whose burden can I help reduce this week?',
      'Do I notice hardship around me or overlook it?',
      'How can service become a regular worship habit?',
    ],
    practiceAction:
        'Help one person today with a specific burden: time, listening, transport, or practical support.',
    relatedHadithIds: ['no_mercy_no_mercy', 'man_forgiven_water_dog'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'seek_knowledge',
    themeId: _knowledgeThemeId,
    collectionIds: ['beginner_set', essentialCollectionId],
    title: 'Whoever Travels a Path Seeking Knowledge',
    excerpt:
        'Whoever travels a path to seek knowledge, Allah eases for him a path to Paradise.',
    hadithText:
        'The Messenger ﷺ said: Whoever follows a path in pursuit of knowledge, Allah will make easy for him a path to Paradise.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2699',
    source: 'Sahih Muslim 2699',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Knowledge', 'Journey', 'Growth'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '114',
        label: 'My Lord, increase me in knowledge.',
      ),
      QuranConnection(
        surahName: 'Al-Mujadila',
        surahNumber: 58,
        verseRange: '11',
        label: 'Allah raises those who were given knowledge.',
      ),
    ],
    meaning:
        'Seeking knowledge is itself worship and opens a path of guidance, discipline, and reward.',
    lessons: [
      'Knowledge-seeking requires movement, commitment, and consistency.',
      'Learning done for Allah transforms the path of life.',
      'The student of knowledge is spiritually honored.',
    ],
    reflectionPrompts: [
      'What path of beneficial learning am I actively walking?',
      'Is my search for knowledge disciplined or occasional?',
      'How can I make learning more consistent this week?',
    ],
    practiceAction:
        'Dedicate one focused session today to Islamic study and write one actionable takeaway.',
    relatedHadithIds: ['knowledge_obligation', 'learn_teach_quran'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'knowledge_obligation',
    themeId: _knowledgeThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'Seeking Knowledge Is an Obligation upon Every Muslim',
    excerpt:
        'Seeking beneficial religious knowledge is a duty on every Muslim.',
    hadithText:
        'The Prophet ﷺ said: Seeking knowledge is an obligation upon every Muslim.',
    sourceCollection: 'Sunan Ibn Majah',
    sourceReference: '224',
    source: 'Sunan Ibn Majah 224',
    grading: 'Hasan (widely cited)',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Obligation', 'Knowledge', 'Responsibility'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Alaq',
        surahNumber: 96,
        verseRange: '1-5',
        label: 'The first revelation begins with reading and learning.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '43',
        label: 'Ask people of knowledge when you do not know.',
      ),
    ],
    meaning:
        'Islam calls every believer to seek the knowledge needed for sound worship and upright life.',
    lessons: [
      'Ignorance is not a virtue when guidance is accessible.',
      'Learning is a continuous duty, not a one-time stage.',
      'Every Muslim needs foundational knowledge for practice.',
    ],
    reflectionPrompts: [
      'Which essential Islamic knowledge do I still need to strengthen?',
      'Do I treat learning as optional or necessary?',
      'What is one foundational topic I should prioritize now?',
    ],
    practiceAction:
        'Choose one core topic (prayer, purification, creed, character) and begin a structured study plan this week.',
    relatedHadithIds: ['seek_knowledge', 'learn_teach_quran'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'scholars_inheritors_prophets',
    themeId: _knowledgeThemeId,
    collectionIds: ['character_builder', 'beginner_set'],
    title: 'The Scholars Are the Inheritors of the Prophets',
    excerpt:
        'The prophets leave behind knowledge, and those who inherit it inherit a great share.',
    hadithText:
        'The Messenger ﷺ said: The scholars are the inheritors of the prophets. The prophets do not leave behind dinar or dirham, but they leave knowledge; whoever takes it has taken an abundant share.',
    sourceCollection: 'Sunan Abi Dawud / Jami\' al-Tirmidhi',
    sourceReference: 'Abu Dawud 3641 / Tirmidhi 2682',
    source: 'Sunan Abi Dawud 3641 / Jami\' al-Tirmidhi 2682',
    grading: 'Hasan',
    narrator: 'Abu al-Darda (ra)',
    tags: ['Scholars', 'Legacy', 'Knowledge'],
    quranConnections: [
      QuranConnection(
        surahName: 'Fatir',
        surahNumber: 35,
        verseRange: '28',
        label: 'Those who truly fear Allah most are the knowledgeable.',
      ),
      QuranConnection(
        surahName: 'Al-Mujadila',
        surahNumber: 58,
        verseRange: '11',
        label: 'Allah elevates people of knowledge.',
      ),
    ],
    meaning:
        'Sacred knowledge is the prophetic inheritance, and preserving it is service to the ummah.',
    lessons: [
      'Knowledge is a trust passed through generations.',
      'Scholarly effort preserves prophetic guidance.',
      'Respecting knowledge means respecting its carriers and methods.',
    ],
    reflectionPrompts: [
      'How do I benefit from reliable scholars and teachers?',
      'Do I seek knowledge from trustworthy sources?',
      'How can I honor the prophetic legacy through learning?',
    ],
    practiceAction:
        'Listen to one trusted lesson from a qualified teacher and record one point to apply.',
    relatedHadithIds: ['seek_knowledge', 'superiority_learned_worshipper'],
  ),
  HadithEntry(
    id: 'knowledge_path_paradise_easy',
    themeId: _knowledgeThemeId,
    collectionIds: ['beginner_set', 'daily_sunnah'],
    title: 'Knowledge Makes the Path to Paradise Easy',
    excerpt:
        'Beneficial learning opens a clearer and easier path toward Paradise.',
    hadithText:
        'The Prophet ﷺ said: Whoever follows a path seeking knowledge, Allah makes easy for him a path to Paradise.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2699',
    source: 'Sahih Muslim 2699',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Paradise', 'Knowledge', 'Hope'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '9',
        label: 'Are those who know equal to those who do not know?',
      ),
      QuranConnection(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '114',
        label: 'Seek increase in knowledge.',
      ),
    ],
    meaning:
        'Learning for Allah lights the road ahead and supports steadfastness toward eternal success.',
    lessons: [
      'Knowledge strengthens hope and clarity.',
      'Progress to Paradise is supported by understanding and practice.',
      'Learning and worship are inseparable.',
    ],
    reflectionPrompts: [
      'How is knowledge shaping my long-term spiritual path?',
      'Am I learning only information, or learning to transform?',
      'Which lesson recently made worship easier for me?',
    ],
    practiceAction:
        'Review one previously learned ruling or lesson and apply it intentionally today.',
    relatedHadithIds: ['seek_knowledge', 'knowledge_obligation'],
  ),
  HadithEntry(
    id: 'conceals_knowledge',
    themeId: _knowledgeThemeId,
    collectionIds: ['character_builder'],
    title: 'Whoever Conceals Knowledge',
    excerpt:
        'Concealing beneficial knowledge when needed is a serious moral violation.',
    hadithText:
        'The Messenger ﷺ said: Whoever is asked about knowledge and conceals it will be bridled with a bridle of fire on the Day of Resurrection.',
    sourceCollection: 'Sunan Abi Dawud / Jami\' al-Tirmidhi',
    sourceReference: 'Abu Dawud 3658 / Tirmidhi 2649',
    source: 'Sunan Abi Dawud 3658 / Jami\' al-Tirmidhi 2649',
    grading: 'Hasan',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Responsibility', 'Teaching', 'Accountability'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '159',
        label: 'Warning against concealing clear guidance.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '43',
        label: 'People are directed to ask those who know.',
      ),
    ],
    meaning:
        'Knowledge carries responsibility; withholding needed guidance can harm others and oneself.',
    lessons: [
      'Knowledge is a trust, not a personal possession.',
      'Teaching with sincerity is an act of service.',
      'Silence is not always neutral when guidance is needed.',
    ],
    reflectionPrompts: [
      'Do I share beneficial knowledge when appropriate?',
      'Where do fear or ego stop me from helping others learn?',
      'How can I teach responsibly within my limits?',
    ],
    practiceAction:
        'Share one verified beneficial Islamic reminder today with sincerity and clarity.',
    relatedHadithIds: ['scholars_inheritors_prophets', 'learn_teach_quran'],
  ),
  HadithEntry(
    id: 'superiority_learned_worshipper',
    themeId: _knowledgeThemeId,
    collectionIds: ['beginner_set', 'character_builder'],
    title: 'Superiority of the Learned over the Worshipper',
    excerpt:
        'The one grounded in knowledge has a rank above one who worships without depth.',
    hadithText:
        'The Prophet ﷺ said: The superiority of the learned person over the worshipper is like my superiority over the least of you.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2685',
    source: 'Jami\' al-Tirmidhi 2685',
    grading: 'Hasan Sahih',
    narrator: 'Abu Umamah al-Bahili (ra)',
    tags: ['Virtue of Knowledge', 'Worship', 'Insight'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '9',
        label: 'Knowledge distinguishes spiritual rank.',
      ),
      QuranConnection(
        surahName: 'Al-Mujadila',
        surahNumber: 58,
        verseRange: '11',
        label: 'People of knowledge are elevated.',
      ),
    ],
    meaning:
        'Worship guided by knowledge is deeper, safer, and more beneficial than worship built on ignorance.',
    lessons: [
      'Knowledge protects worship from error.',
      'Learning is not opposite to devotion; it perfects it.',
      'A believer should seek both understanding and practice.',
    ],
    reflectionPrompts: [
      'Is my worship guided by reliable knowledge?',
      'Where am I practicing without understanding?',
      'What one topic would improve my worship quality?',
    ],
    practiceAction:
        'Before your next major act of worship, review one reliable ruling related to it.',
    relatedHadithIds: ['seek_knowledge', 'knowledge_path_paradise_easy'],
  ),
  HadithEntry(
    id: 'wisdom_lost_property',
    themeId: _knowledgeThemeId,
    collectionIds: ['daily_sunnah', 'beginner_set'],
    title: 'Wisdom Is the Lost Property of the Believer',
    excerpt:
        'A believer seeks wisdom wherever it is found and uses it in obedience to Allah.',
    hadithText:
        'The Prophet ﷺ said: Wisdom is the lost property of the believer; wherever he finds it, he is most deserving of it.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2687',
    source: 'Jami\' al-Tirmidhi 2687',
    grading: 'Hasan Gharib (discussed by scholars)',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Wisdom', 'Insight', 'Discernment'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '269',
        label: 'Whoever is given wisdom has been given much good.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '125',
        label: 'Call to Allah with wisdom and good counsel.',
      ),
    ],
    meaning:
        'The believer remains teachable, seeking beneficial insight while keeping it aligned with revelation.',
    lessons: [
      'Wisdom is sought actively, not passively.',
      'Beneficial insight can appear in many lawful contexts.',
      'Discernment is required to apply knowledge correctly.',
    ],
    reflectionPrompts: [
      'Do I remain open to beneficial wisdom and correction?',
      'How do I distinguish true wisdom from mere opinion?',
      'Where do I need more wisdom in applying what I know?',
    ],
    practiceAction:
        'Identify one wise principle from Qur\'an/Sunnah study and apply it in a real decision today.',
    relatedHadithIds: ['seek_knowledge', 'superiority_learned_worshipper'],
  ),
  HadithEntry(
    id: 'learn_teach_quran',
    themeId: _knowledgeThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set', 'prayer_devotion'],
    title: 'The Best among You Learn and Teach the Qur’an',
    excerpt:
        'The most excellent believers learn the Qur’an and pass it on with sincerity.',
    hadithText:
        'The Messenger ﷺ said: The best among you are those who learn the Qur’an and teach it.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '5027',
    source: 'Sahih al-Bukhari 5027',
    grading: 'Sahih',
    narrator: 'Uthman ibn Affan (ra)',
    tags: ['Qur\'an', 'Teaching', 'Excellence'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '114',
        label: 'Seek increase in beneficial knowledge.',
      ),
      QuranConnection(
        surahName: 'Al-Furqan',
        surahNumber: 25,
        verseRange: '30',
        label: 'Do not abandon the Qur\'an; remain attached to it.',
      ),
    ],
    meaning:
        'Learning and teaching Qur\'an is among the highest forms of beneficial knowledge and service.',
    lessons: [
      'The best knowledge is that which connects directly to revelation.',
      'Teaching others multiplies reward and benefit.',
      'Qur\'an learning should shape both recitation and character.',
    ],
    reflectionPrompts: [
      'What is my current relationship with learning Qur\'an?',
      'How can I share Qur\'anic learning with others appropriately?',
      'Which small Qur\'an learning habit can I sustain this month?',
    ],
    practiceAction:
        'Review one short surah today and teach one reflection from it to a family member or friend.',
    relatedHadithIds: ['knowledge_obligation', 'seek_knowledge'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'dua_worship',
    themeId: _duaThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'Du’a Is Worship',
    excerpt: 'Supplication is the heart of a servant’s turning to Allah.',
    hadithText: 'The Prophet ﷺ said: Du’a is worship.',
    englishText:
        'The Prophet ﷺ taught that duʿā itself is worship, not only a request list.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2969',
    source: 'Sunan al-Tirmidhi 2969',
    grading: 'Hasan Sahih',
    narrator: 'Al-Nu\'man ibn Bashir (ra)',
    tags: ['Du’a', 'Remembrance', 'Dependence on Allah'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ghafir',
        surahNumber: 40,
        verseRange: '60',
        label: 'Call upon Me; I will respond to you.',
      ),
    ],
    meaning:
        'Supplication is not a side act; it is central to servitude and reliance.',
    lessons: [
      'Du’a keeps the heart connected in ease and hardship.',
      'Consistency in remembrance softens the heart.',
      'Calling upon Allah is itself a form of devotion.',
    ],
    reflectionPrompts: [
      'When do I make my most sincere du’a?',
      'How can I increase remembrance during the day?',
      'Do I treat duʿā as worship or only as emergency response?',
    ],
    practiceAction: 'Set one fixed quiet dua moment today after salah.',
    relatedHadithIds: [
      'increase_dua_in_prostration',
      'allah_remembers_those_who_remember_him',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'example_remembers_allah',
    themeId: _duaThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening', 'beginner_set'],
    title: 'The Example of the One Who Remembers Allah',
    excerpt:
        'The one who remembers Allah is like the living; the one who neglects remembrance is like the dead.',
    hadithText:
        'The Prophet ﷺ said: The example of the one who remembers his Lord and the one who does not remember his Lord is like the living and the dead.',
    englishText:
        'Dhikr gives life to the heart; neglect of remembrance leaves it spiritually dry.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '6407',
    source: 'Sahih al-Bukhari 6407',
    grading: 'Sahih',
    narrator: 'Abu Musa al-Ash\'ari (ra)',
    tags: ['Dhikr', 'Heart', 'Spiritual Life'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ar-Ra\'d',
        surahNumber: 13,
        verseRange: '28',
        label: 'Hearts find rest in the remembrance of Allah.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '152',
        label: 'Remember Me and I will remember you.',
      ),
    ],
    meaning:
        'Remembrance is nourishment for the soul; without it the heart becomes spiritually weak.',
    lessons: [
      'Dhikr revives inner awareness.',
      'Spiritual health depends on regular remembrance.',
      'A living heart is attached to Allah through frequent dhikr.',
    ],
    reflectionPrompts: [
      'How alive does my heart feel in daily worship?',
      'What times of day can become dhikr anchors for me?',
      'Which distractions most pull me away from remembrance?',
    ],
    practiceAction:
        'Add one short dhikr session today after a prayer and keep it consistent.',
    relatedHadithIds: ['dua_worship', 'two_phrases_light_on_tongue'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'increase_dua_in_prostration',
    themeId: _duaThemeId,
    collectionIds: ['prayer_devotion', 'heart_softening'],
    title: 'Increase Du’a in Prostration',
    excerpt:
        'The servant is nearest to Allah in sujud, so increase supplication there.',
    hadithText:
        'The Messenger ﷺ said: The closest a servant is to his Lord is while he is prostrating, so increase supplication.',
    englishText:
        'Sujud is a privileged moment for heartfelt duʿā and nearness to Allah.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '482',
    source: 'Sahih Muslim 482',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Du’a', 'Sujud', 'Nearness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-\'Alaq',
        surahNumber: 96,
        verseRange: '19',
        label: 'Prostrate and draw near.',
      ),
      QuranConnection(
        surahName: 'Ghafir',
        surahNumber: 40,
        verseRange: '60',
        label: 'Call upon Me; I will respond.',
      ),
    ],
    meaning:
        'Prostration combines humility and intimacy, making it one of the best times for sincere duʿā.',
    lessons: [
      'Sujud is a moment of powerful spiritual connection.',
      'Depth in prayer includes personal supplication.',
      'Closeness to Allah grows with humility.',
    ],
    reflectionPrompts: [
      'Do I make meaningful duʿā in sujud or rush through it?',
      'What concern should I bring to Allah in prostration today?',
      'How can sujud become more heartfelt?',
    ],
    practiceAction:
        'In one sujud today, remain longer and make one focused personal duʿā.',
    relatedHadithIds: ['dua_worship', 'gatherings_dhikr_surrounded_angels'],
  ),
  HadithEntry(
    id: 'two_phrases_light_on_tongue',
    themeId: _duaThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'Two Phrases Light on the Tongue',
    excerpt: 'Two short phrases are beloved to Allah and heavy on the scale.',
    hadithText:
        'The Prophet ﷺ said: Two phrases are light on the tongue, heavy on the scale, and beloved to the Most Merciful: SubhanAllahi wa bihamdihi, SubhanAllahil-\'Azim.',
    englishText: 'Simple, consistent dhikr can carry immense spiritual weight.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6406 / Muslim 2694',
    source: 'Sahih al-Bukhari 6406 / Sahih Muslim 2694',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Dhikr', 'Scale', 'Virtue'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '41',
        label: 'Remember Allah with abundant remembrance.',
      ),
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '205',
        label: 'Remember your Lord humbly and inwardly.',
      ),
    ],
    meaning:
        'Short adhkar done sincerely can transform a day and elevate one\'s scale greatly.',
    lessons: [
      'Length is not required for meaningful remembrance.',
      'Consistent small dhikr builds a strong spiritual routine.',
      'Beloved speech to Allah should be frequent on the tongue.',
    ],
    reflectionPrompts: [
      'Which short adhkar can I keep daily without fail?',
      'Do I underestimate small acts of dhikr?',
      'How can I remember Allah during ordinary tasks?',
    ],
    practiceAction:
        'Repeat these two phrases 50 times today with calm attention.',
    relatedHadithIds: [
      'subhanallahi_wabihamdihi_hundred_times',
      'example_remembers_allah',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'subhanallahi_wabihamdihi_hundred_times',
    themeId: _duaThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'Saying SubhanAllahi wa bihamdihi One Hundred Times',
    excerpt:
        'Whoever says this dhikr one hundred times receives immense forgiveness.',
    hadithText:
        'The Prophet ﷺ said: Whoever says “SubhanAllahi wa bihamdihi” one hundred times in a day, his sins are forgiven even if they were like the foam of the sea.',
    englishText:
        'Regular tasbih and praise are a means of cleansing sins by Allah\'s mercy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6405 / Muslim 2691',
    source: 'Sahih al-Bukhari 6405 / Sahih Muslim 2691',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Tasbih', 'Forgiveness', 'Daily Dhikr'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '152',
        label: 'Remember Allah and be grateful.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '41',
        label: 'Remember Allah frequently.',
      ),
    ],
    meaning:
        'Frequent praise of Allah opens the door to forgiveness and spiritual purification.',
    lessons: [
      'Dhikr is a practical path to cleansing sins.',
      'Consistency in remembrance matters more than occasional intensity.',
      'Gratitude and glorification should fill daily routine.',
    ],
    reflectionPrompts: [
      'What prevents me from maintaining daily adhkar?',
      'How can I attach this dhikr to a daily routine point?',
      'Do I seek forgiveness through remembrance regularly?',
    ],
    practiceAction:
        'Complete 100 repetitions of “SubhanAllahi wa bihamdihi” today and track it.',
    relatedHadithIds: ['two_phrases_light_on_tongue', 'dua_worship'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'allah_remembers_those_who_remember_him',
    themeId: _duaThemeId,
    collectionIds: ['heart_softening', 'hadith_qudsi'],
    title: 'Allah Remembers Those Who Remember Him',
    excerpt:
        'In a sacred narration, Allah promises nearness and remembrance to those who remember Him.',
    hadithText:
        'Allah says in a sacred narration: I am as My servant thinks of Me, and I am with him when he remembers Me. If he remembers Me within himself, I remember him within Myself...',
    englishText:
        'Remembering Allah invites divine nearness, remembrance, and mercy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 7405 / Muslim 2675',
    source: 'Sahih al-Bukhari 7405 / Sahih Muslim 2675',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Hadith Qudsi', 'Dhikr', 'Nearness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '152',
        label: 'Remember Me; I will remember you.',
      ),
      QuranConnection(
        surahName: 'Ar-Ra\'d',
        surahNumber: 13,
        verseRange: '28',
        label: 'Hearts find calm in Allah\'s remembrance.',
      ),
    ],
    meaning:
        'Dhikr is not one-sided; Allah responds to His servant with nearness and care.',
    lessons: [
      'Remembering Allah builds intimate spiritual connection.',
      'Good expectations of Allah strengthen hope.',
      'Small private dhikr is deeply valued.',
    ],
    reflectionPrompts: [
      'How present is Allah\'s remembrance in my private moments?',
      'Do I carry hope in Allah while making duʿā?',
      'What regular dhikr can become my heart\'s anchor?',
    ],
    practiceAction:
        'Set aside two quiet minutes today for private dhikr with full attention.',
    relatedHadithIds: [
      'example_remembers_allah',
      'gatherings_dhikr_surrounded_angels',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'la_ilaha_illa_allah_sincerely',
    themeId: _duaThemeId,
    collectionIds: ['beginner_set', 'heart_softening'],
    title: 'Saying La ilaha illa Allah Sincerely',
    excerpt:
        'Whoever sincerely says “La ilaha illa Allah” seeking Allah’s Face is saved by His mercy.',
    hadithText:
        'The Prophet ﷺ said: Allah has forbidden the Fire for the one who says “La ilaha illa Allah,” seeking thereby the Face of Allah.',
    englishText:
        'Sincere tawhid from the heart is a path to salvation and divine mercy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 425 / Muslim 33',
    source: 'Sahih al-Bukhari 425 / Sahih Muslim 33',
    grading: 'Muttafaqun Alayh',
    narrator: 'Itban ibn Malik (ra)',
    tags: ['Tawhid', 'Dhikr', 'Sincerity'],
    quranConnections: [
      QuranConnection(
        surahName: 'Muhammad',
        surahNumber: 47,
        verseRange: '19',
        label: 'Know that there is no deity except Allah.',
      ),
      QuranConnection(
        surahName: 'Al-Bayyinah',
        surahNumber: 98,
        verseRange: '5',
        label: 'Worship Allah with sincere devotion.',
      ),
    ],
    meaning:
        'The shahadah is not only spoken formula; its saving power lies in sincere belief and truthful living.',
    lessons: [
      'Sincerity gives meaning to declarations of faith.',
      'Dhikr and creed are deeply connected.',
      'Tawhid is lived through worship and obedience.',
    ],
    reflectionPrompts: [
      'How does my daily life reflect the shahadah?',
      'Do I renew sincerity when I recite “La ilaha illa Allah”?',
      'What distracts my heart from pure tawhid?',
    ],
    practiceAction:
        'Recite “La ilaha illa Allah” with focused sincerity today and reflect on one behavior it should improve.',
    relatedHadithIds: ['dua_worship', 'allah_remembers_those_who_remember_him'],
  ),
  HadithEntry(
    id: 'gatherings_dhikr_surrounded_angels',
    themeId: _duaThemeId,
    collectionIds: ['heart_softening', 'daily_sunnah'],
    title: 'Gatherings of Remembrance Surrounded by Angels',
    excerpt:
        'People who gather to remember Allah are surrounded by angels, mercy, and tranquility.',
    hadithText:
        'The Messenger ﷺ said: No people gather in a house of Allah reciting and studying His Book except tranquility descends upon them, mercy envelops them, angels surround them, and Allah mentions them among those with Him.',
    englishText:
        'Circles of Qur\'an and dhikr are gatherings of mercy and divine mention.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2699',
    source: 'Sahih Muslim 2699',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Gathering', 'Dhikr', 'Angels'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '41',
        label: 'Remember Allah with abundant remembrance.',
      ),
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '205',
        label: 'Remember your Lord with humility and awe.',
      ),
    ],
    meaning:
        'Collective remembrance creates environments of mercy, calm, and spiritual elevation.',
    lessons: [
      'Righteous gatherings shape the heart positively.',
      'Community worship brings unique blessings.',
      'Learning circles are both intellectual and spiritual nourishment.',
    ],
    reflectionPrompts: [
      'How often do I attend or host gatherings of remembrance?',
      'What kind of gatherings shape my heart most?',
      'How can I increase beneficial circles in my week?',
    ],
    practiceAction:
        'Attend or initiate one short circle of Qur\'an or dhikr this week.',
    relatedHadithIds: [
      'allah_remembers_those_who_remember_him',
      'example_remembers_allah',
    ],
  ),
  HadithEntry(
    id: 'family_best_to_family',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'beginner_set'],
    title: 'The Best of You Are Those Best to Their Families',
    excerpt:
        'The best among believers are those who show excellence in family life.',
    hadithText:
        'The Prophet ﷺ said: The best of you are those best to their families, and I am the best of you to my family.',
    englishText:
        'The best of you are those who are best to their families, and I am the best among you to my family.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '3895',
    source: 'Sunan al-Tirmidhi 3895',
    grading: 'Hasan Sahih',
    narrator: 'Aishah (ra)',
    tags: ['Family', 'Character', 'Mercy'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '19',
        label: 'Live with them in kindness.',
      ),
      QuranConnection(
        surahName: 'Ar-Rum',
        surahNumber: 30,
        verseRange: '21',
        label: 'Marriage is built on tranquility, love, and mercy.',
      ),
    ],
    meaning:
        'Spiritual excellence appears most clearly in private family conduct.',
    lessons: [
      'True character is proven at home.',
      'Kindness in family life is worship.',
      'Family leadership is measured by mercy and service.',
    ],
    reflectionPrompts: [
      'How can I improve my tone at home?',
      'Which family relationship needs intentional repair?',
      'What does prophetic kindness look like in my household?',
    ],
    practiceAction:
        'Offer one gentle word or service to a family member today.',
    relatedHadithIds: [
      'prophet_helped_family_home',
      'best_believer_character_family',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'paradise_feet_mothers',
    themeId: _familyThemeId,
    collectionIds: ['heart_softening', 'beginner_set'],
    title: 'Paradise Lies at the Feet of Mothers',
    excerpt:
        'Honoring and serving one’s mother is among the greatest roads to Paradise.',
    hadithText:
        'A narration from the Prophet ﷺ teaches: Paradise lies at the feet of mothers.',
    englishText:
        'Serving, honoring, and being dutiful to one\'s mother is a great means to Paradise.',
    sourceCollection: 'Sunan al-Nasa\'i',
    sourceReference: '3104',
    source: 'Sunan al-Nasa\'i 3104',
    grading: 'Hasan',
    narrator: 'Mu\'awiyah ibn Jahimah (ra)',
    tags: ['Mother', 'Birr al-Walidayn', 'Paradise'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Isra',
        surahNumber: 17,
        verseRange: '23',
        label: 'Show excellence and humility to parents.',
      ),
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '14',
        label: 'Be grateful and dutiful to your mother and father.',
      ),
    ],
    meaning:
        'Great nearness to Allah is found in humble service and compassion toward one’s mother.',
    lessons: [
      'Family devotion is central to faith.',
      'Respect for parents is a lifelong responsibility.',
      'Serving parents can outweigh many optional acts.',
    ],
    reflectionPrompts: [
      'How can I serve my mother or parental figures more sincerely?',
      'Do my words and tone reflect gratitude to parents?',
      'What unfinished duty toward parents should I repair?',
    ],
    practiceAction:
        'Do one concrete act of service for your mother or parents today.',
    relatedHadithIds: ['family_best_to_family', 'charity_toward_family'],
  ),
  HadithEntry(
    id: 'mercy_young_respect_elders',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'character_builder'],
    title: 'Show Mercy to the Young and Respect the Elders',
    excerpt:
        'Prophetic community ethics combine gentleness with the young and honor for elders.',
    hadithText:
        'The Prophet ﷺ said: He is not one of us who does not show mercy to our young and recognize the honor of our elders.',
    englishText:
        'A complete Muslim character includes compassion for children and respect for elders.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1921',
    source: 'Jami\' al-Tirmidhi 1921',
    grading: 'Hasan Sahih',
    narrator: 'Abdullah ibn Amr (ra)',
    tags: ['Mercy', 'Respect', 'Community'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '10',
        label: 'Believers are brothers; preserve mercy among them.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice, excellence, and good conduct.',
      ),
    ],
    meaning:
        'Mercy and respect are not optional social manners; they are signs of prophetic belonging.',
    lessons: [
      'Communities thrive through intergenerational honor.',
      'Children need mercy; elders need dignity.',
      'Faith appears in everyday social behavior.',
    ],
    reflectionPrompts: [
      'How do I treat children in moments of stress?',
      'Do I give elders the respect due to them?',
      'What relationship needs more mercy or honor from me?',
    ],
    practiceAction:
        'Show patience to one child and deliberate respect to one elder today.',
    relatedHadithIds: ['family_best_to_family', 'honor_your_neighbor'],
  ),
  HadithEntry(
    id: 'prophet_helped_family_home',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'character_builder'],
    title: 'The Prophet Helped His Family at Home',
    excerpt:
        'The Prophet ﷺ served his family in daily tasks and modeled humble responsibility at home.',
    hadithText:
        'Aishah (ra) said that the Prophet ﷺ used to serve his family in household matters, then go out for prayer when the time came.',
    englishText:
        'The Sunnah includes practical service in the home, not distance from household responsibilities.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '676',
    source: 'Sahih al-Bukhari 676',
    grading: 'Sahih',
    narrator: 'Aishah (ra)',
    tags: ['Service', 'Humility', 'Home'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '21',
        label: 'The Messenger ﷺ is the best example in all life roles.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '19',
        label: 'Live with spouses in kindness and fairness.',
      ),
    ],
    meaning:
        'Family leadership in Islam includes humble service, not entitlement.',
    lessons: [
      'Helping at home is a prophetic practice.',
      'Humility strengthens marriage and family bonds.',
      'Spiritual maturity includes practical responsibility.',
    ],
    reflectionPrompts: [
      'Do I serve my household with sincerity?',
      'Where can I reduce entitlement at home?',
      'What home responsibility can I take on more consistently?',
    ],
    practiceAction:
        'Take initiative for one recurring household task today without being asked.',
    relatedHadithIds: [
      'family_best_to_family',
      'best_believer_character_family',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'best_believer_character_family',
    themeId: _familyThemeId,
    collectionIds: ['character_builder', 'beginner_set'],
    title: 'The Believer with the Best Character',
    excerpt:
        'The most complete believers in faith are those with best character, especially toward family.',
    hadithText:
        'The Prophet ﷺ said: The most complete of believers in faith are those best in character, and the best among you are those best to their women.',
    englishText:
        'Faith reaches completion through excellent character and kind treatment of one’s spouse.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1162',
    source: 'Jami\' al-Tirmidhi 1162',
    grading: 'Hasan Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Marriage', 'Character', 'Faith'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ar-Rum',
        surahNumber: 30,
        verseRange: '21',
        label: 'Marriage is meant to carry mercy and tranquility.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '19',
        label: 'Live with spouses in kindness.',
      ),
    ],
    meaning:
        'Family relationships are one of the clearest tests of faith quality and character.',
    lessons: [
      'Character and faith are inseparable.',
      'Marital kindness is central to Islamic ethics.',
      'Private conduct reveals spiritual truthfulness.',
    ],
    reflectionPrompts: [
      'How do I speak to family when stressed?',
      'Does my private behavior reflect my public faith?',
      'What one relationship needs softer character from me?',
    ],
    practiceAction:
        'Choose one way today to improve emotional safety in your home through speech and patience.',
    relatedHadithIds: [
      'family_best_to_family',
      'raising_children_good_manners',
    ],
  ),
  HadithEntry(
    id: 'raising_children_good_manners',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'beginner_set'],
    title: 'Raising Children with Good Manners',
    excerpt:
        'No parental gift is better than teaching children good manners and character.',
    hadithText:
        'The Prophet ﷺ said: No father gives his child anything better than good manners.',
    englishText:
        'The greatest inheritance for children is righteous character and adab.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1952',
    source: 'Jami\' al-Tirmidhi 1952',
    grading: 'Hasan (reported with supporting narrations)',
    narrator: 'Ayyub ibn Musa (from his father, from his grandfather)',
    tags: ['Parenting', 'Adab', 'Children'],
    quranConnections: [
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '13-19',
        label: 'Luqman’s counsel models character-focused parenting.',
      ),
      QuranConnection(
        surahName: 'At-Tahrim',
        surahNumber: 66,
        verseRange: '6',
        label: 'Protect yourselves and your families.',
      ),
    ],
    meaning:
        'Parenting in Islam is not only provision and discipline, but nurturing noble character.',
    lessons: [
      'Adab training is a core parental duty.',
      'Children learn by modeling, not only instruction.',
      'Early character formation has lifelong impact.',
    ],
    reflectionPrompts: [
      'What character traits am I actively teaching my children?',
      'Do my actions model the manners I ask from them?',
      'What family routine can strengthen adab at home?',
    ],
    practiceAction:
        'Teach one concrete etiquette today and model it together as a family.',
    relatedHadithIds: [
      'mercy_young_respect_elders',
      'prophet_helped_family_home',
    ],
  ),
  HadithEntry(
    id: 'honor_your_neighbor',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'character_builder'],
    title: 'Honor Your Neighbor',
    excerpt:
        'Belief in Allah and the Last Day includes honoring and caring for neighbors.',
    hadithText:
        'The Prophet ﷺ said: Whoever believes in Allah and the Last Day, let him honor his neighbor.',
    englishText:
        'Respecting neighbors is a direct sign of faith and social responsibility.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6019 / Muslim 47',
    source: 'Sahih al-Bukhari 6019 / Sahih Muslim 47',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Neighbor', 'Community', 'Faith'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '36',
        label: 'Show goodness to the near and distant neighbor.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '10',
        label: 'Believers are brothers; preserve social bonds.',
      ),
    ],
    meaning:
        'Faith extends beyond the home into everyday neighborly ethics and support.',
    lessons: [
      'Good neighborliness is an act of worship.',
      'Community health depends on mutual respect.',
      'Small neighborly acts carry spiritual value.',
    ],
    reflectionPrompts: [
      'How present am I in caring for neighbors?',
      'Do my actions make life easier or harder for people nearby?',
      'What one step can improve my neighborhood conduct?',
    ],
    practiceAction:
        'Do one intentional kindness for a neighbor this week: greeting, help, or thoughtful support.',
    relatedHadithIds: ['charity_toward_family', 'mercy_young_respect_elders'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'charity_toward_family',
    themeId: _familyThemeId,
    collectionIds: ['daily_sunnah', 'beginner_set', essentialCollectionId],
    title: 'Charity toward Family',
    excerpt:
        'Giving to relatives carries the reward of charity and maintaining family ties.',
    hadithText:
        'The Messenger ﷺ said: Charity given to the poor is one charity, and charity given to a relative is two: charity and maintaining ties of kinship.',
    englishText:
        'Supporting family in need brings double reward: sadaqah and kinship care.',
    sourceCollection: 'Jami\' al-Tirmidhi / Sunan al-Nasa\'i / Ibn Majah',
    sourceReference: 'Tirmidhi 658',
    source: 'Jami\' al-Tirmidhi 658',
    grading: 'Hasan',
    narrator: 'Salman ibn Amir (ra)',
    tags: ['Charity', 'Family Ties', 'Kinship'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '215',
        label: 'Spend on parents, relatives, and those in need.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '36',
        label: 'Show excellence to relatives and those around you.',
      ),
    ],
    meaning:
        'Family support is both financial worship and relational responsibility in Islam.',
    lessons: [
      'Charity begins with those nearest when there is need.',
      'Kinship care is a major spiritual value.',
      'Giving can heal both hardship and relationships.',
    ],
    reflectionPrompts: [
      'Which relative may need support from me right now?',
      'How can I combine generosity with family reconciliation?',
      'Do I overlook family need while giving elsewhere?',
    ],
    practiceAction:
        'Give one act of support to a relative today: money, food, time, or practical help.',
    relatedHadithIds: ['family_best_to_family', 'honor_your_neighbor'],
  ),
  HadithEntry(
    id: 'trust_honesty',
    themeId: _justiceThemeId,
    collectionIds: [essentialCollectionId, 'daily_sunnah'],
    title: 'Return the Trust',
    excerpt: 'Fulfill trusts and avoid betrayal in every responsibility.',
    hadithText:
        'The Messenger ﷺ instructed believers to return trusts to their owners and not betray those who betray them.',
    englishText:
        'Return trusts to those entitled to them, and do not betray trust.',
    sourceCollection: 'Sunan Abi Dawud',
    sourceReference: '3534',
    source: 'Sunan Abi Dawud 3534',
    grading: 'Hasan',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Trust', 'Justice', 'Integrity'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '58',
        label: 'Render trusts to whom they are due.',
      ),
      QuranConnection(
        surahName: 'Al-Anfal',
        surahNumber: 8,
        verseRange: '27',
        label: 'Do not betray Allah, the Messenger, and your trusts.',
      ),
    ],
    meaning:
        'Faith requires public and private integrity in rights, duties, and dealings.',
    lessons: [
      'Trust is a sacred responsibility.',
      'Justice begins in everyday commitments.',
      'Betrayal harms both society and soul.',
    ],
    reflectionPrompts: [
      'Where am I entrusted by others?',
      'How can I strengthen reliability in commitments?',
      'Do I treat small trusts as seriously as large ones?',
    ],
    practiceAction: 'Review one trust or promise and fulfill it today.',
    relatedHadithIds: ['signs_hypocrisy', 'each_shepherd'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'signs_hypocrisy',
    themeId: _justiceThemeId,
    collectionIds: [essentialCollectionId, 'character_builder'],
    title: 'Signs of Hypocrisy',
    excerpt:
        'Lying, breaking promises, and betraying trust are from signs of hypocrisy.',
    hadithText:
        'The Prophet ﷺ said: The signs of a hypocrite are three: when he speaks, he lies; when he promises, he breaks it; and when trusted, he betrays.',
    englishText:
        'Dishonesty in speech, promises, and trust are marks of hypocrisy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 33 / Muslim 59',
    source: 'Sahih al-Bukhari 33 / Sahih Muslim 59',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Hypocrisy', 'Truthfulness', 'Trust'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '8-10',
        label: 'Hypocrisy corrupts the inner state.',
      ),
      QuranConnection(
        surahName: 'Al-Anfal',
        surahNumber: 8,
        verseRange: '27',
        label: 'Do not betray trusts knowingly.',
      ),
    ],
    meaning:
        'Character failures in truth and trust are spiritually dangerous and must be corrected early.',
    lessons: [
      'Faith is measured in reliability, not slogans.',
      'Promises are moral obligations.',
      'Trust breaches damage both people and iman.',
    ],
    reflectionPrompts: [
      'Do my words and commitments match consistently?',
      'Where am I careless with promises?',
      'How can I repair trust where it was broken?',
    ],
    practiceAction:
        'Identify one pending promise and fulfill it today without delay.',
    relatedHadithIds: ['trust_honesty', 'whoever_cheats_not_among_us'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'honest_merchants',
    themeId: _justiceThemeId,
    collectionIds: ['daily_sunnah', 'character_builder'],
    title: 'Honest Merchants',
    excerpt:
        'Truthful and trustworthy traders are raised with prophets, truthful, and martyrs.',
    hadithText:
        'The Prophet ﷺ said: The truthful and trustworthy merchant will be with the prophets, the truthful, and the martyrs.',
    englishText:
        'Ethical trade is elevated worship when built on honesty and trust.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '1209',
    source: 'Jami\' al-Tirmidhi 1209',
    grading: 'Hasan',
    narrator: 'Abu Sa\'id al-Khudri (ra)',
    tags: ['Trade', 'Honesty', 'Trustworthiness'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mutaffifin',
        surahNumber: 83,
        verseRange: '1-3',
        label: 'Warning against cheating in measure and weight.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice and excellence.',
      ),
    ],
    meaning:
        'Economic dealings are part of deen; honesty in trade is a high station of worship.',
    lessons: [
      'Business ethics are spiritual ethics.',
      'Honest earnings carry barakah.',
      'Trustworthiness elevates worldly work.',
    ],
    reflectionPrompts: [
      'Am I fully transparent in financial dealings?',
      'Where can I increase honesty in transactions?',
      'Do I see work ethics as part of worship?',
    ],
    practiceAction:
        'Review one transaction today and ensure full fairness and clarity.',
    relatedHadithIds: ['whoever_cheats_not_among_us', 'trust_honesty'],
  ),
  HadithEntry(
    id: 'each_shepherd',
    themeId: _justiceThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'Each of You Is a Shepherd',
    excerpt:
        'Every person has responsibility and accountability over those in their care.',
    hadithText:
        'The Messenger ﷺ said: Each of you is a shepherd and each of you is responsible for his flock.',
    englishText:
        'Leadership and care are trusts; every role carries accountability before Allah.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 893 / Muslim 1829',
    source: 'Sahih al-Bukhari 893 / Sahih Muslim 1829',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Responsibility', 'Leadership', 'Accountability'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '135',
        label: 'Stand firmly for justice, even against self-interest.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '72',
        label: 'The trust (amanah) is a weighty responsibility.',
      ),
    ],
    meaning:
        'Justice begins in personal spheres: family, work, institutions, and public duty.',
    lessons: [
      'Every role is an amanah.',
      'Accountability is unavoidable.',
      'Leadership is service, not privilege.',
    ],
    reflectionPrompts: [
      'Who is under my care and affected by my choices?',
      'Do I lead with fairness or convenience?',
      'Where do I need to improve accountability?',
    ],
    practiceAction:
        'Take one justice-oriented action today for someone under your responsibility.',
    relatedHadithIds: ['trust_honesty', 'just_on_pulpits_of_light'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'help_brother_oppressor_oppressed',
    themeId: _justiceThemeId,
    collectionIds: ['daily_sunnah', 'character_builder'],
    title: 'Help Your Brother Whether Oppressor or Oppressed',
    excerpt:
        'Help the oppressed directly and help the oppressor by stopping injustice.',
    hadithText:
        'The Prophet ﷺ said: Help your brother whether he is an oppressor or oppressed. They asked: We know helping the oppressed, but how do we help the oppressor? He said: By restraining him from oppression.',
    englishText:
        'Preventing injustice is itself a form of helping one who commits it.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '2444',
    source: 'Sahih al-Bukhari 2444',
    grading: 'Sahih',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Justice', 'Oppression', 'Reform'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '8',
        label: 'Be just; do not let hostility make you unjust.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '9',
        label: 'Reconcile with justice when conflict occurs.',
      ),
    ],
    meaning:
        'Justice requires active intervention: support victims and prevent wrongdoing at its source.',
    lessons: [
      'Silence before injustice is harmful.',
      'Stopping harm is mercy and justice together.',
      'True brotherhood includes moral correction.',
    ],
    reflectionPrompts: [
      'How do I respond when I witness unfairness?',
      'Do I confuse loyalty with enabling wrongdoing?',
      'Where can I stand for fairness more clearly?',
    ],
    practiceAction:
        'Intervene constructively in one unfair situation today with wisdom and calm.',
    relatedHadithIds: [
      'whoever_cheats_not_among_us',
      'allah_helps_servant_helps_brother',
    ],
  ),
  HadithEntry(
    id: 'whoever_cheats_not_among_us',
    themeId: _justiceThemeId,
    collectionIds: [essentialCollectionId, 'daily_sunnah'],
    title: 'Whoever Cheats Us Is Not among Us',
    excerpt:
        'Cheating and deception violate the trust and ethics of the Muslim community.',
    hadithText: 'The Messenger ﷺ said: Whoever cheats us is not among us.',
    englishText:
        'Deception in dealings, representation, or conduct is contrary to prophetic ethics.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '101',
    source: 'Sahih Muslim 101',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Honesty', 'Deception', 'Ethics'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mutaffifin',
        surahNumber: 83,
        verseRange: '1-3',
        label: 'Warning against cheating and fraud.',
      ),
      QuranConnection(
        surahName: 'Al-Anfal',
        surahNumber: 8,
        verseRange: '27',
        label: 'Do not betray your trusts knowingly.',
      ),
    ],
    meaning:
        'Integrity is non-negotiable in Islam; deception undermines faith, trust, and social justice.',
    lessons: [
      'Cheating is a spiritual and social harm.',
      'Trust is preserved through honesty in details.',
      'Public credibility depends on private integrity.',
    ],
    reflectionPrompts: [
      'Are there subtle forms of deception in my habits?',
      'Do I present things accurately in work and communication?',
      'How can I build deeper honesty in all dealings?',
    ],
    practiceAction:
        'Audit one area today (work, study, business) and remove any deceptive shortcut.',
    relatedHadithIds: ['honest_merchants', 'signs_hypocrisy'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'just_on_pulpits_of_light',
    themeId: _justiceThemeId,
    collectionIds: ['character_builder', 'heart_softening'],
    title: 'The Just Will Be on Pulpits of Light',
    excerpt:
        'Those who judge and act with justice are granted immense honor before Allah.',
    hadithText:
        'The Prophet ﷺ said: The just will be on pulpits of light before Allah — those who are just in their rulings, families, and responsibilities.',
    englishText:
        'Justice in leadership, family, and decision-making raises a person to great rank in the Hereafter.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '1827',
    source: 'Sahih Muslim 1827',
    grading: 'Sahih',
    narrator: 'Abdullah ibn Amr (ra)',
    tags: ['Justice', 'Leadership', 'Akhirah'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '135',
        label: 'Stand firm in justice for Allah.',
      ),
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '8',
        label: 'Be persistently just.',
      ),
    ],
    meaning:
        'Justice is among the highest acts of worship, especially for those with authority or influence.',
    lessons: [
      'Justice is rewarded with unique honor in the Hereafter.',
      'Fairness must apply in public and private roles.',
      'Authority increases moral responsibility.',
    ],
    reflectionPrompts: [
      'Do I judge fairly when personal feelings are involved?',
      'Where do I need to correct bias in decisions?',
      'How can I embody justice in family and work roles?',
    ],
    practiceAction:
        'Make one decision today with explicit fairness, even if inconvenient for yourself.',
    relatedHadithIds: ['each_shepherd', 'help_brother_oppressor_oppressed'],
  ),
  HadithEntry(
    id: 'allah_helps_servant_helps_brother',
    themeId: _justiceThemeId,
    collectionIds: ['daily_sunnah', essentialCollectionId],
    title: 'Allah Helps the Servant Who Helps His Brother',
    excerpt:
        'Divine aid accompanies the believer who actively supports others.',
    hadithText:
        'The Messenger ﷺ said: Allah continues to aid the servant as long as the servant aids his brother.',
    englishText: 'Support for others invites support from Allah in return.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2699',
    source: 'Sahih Muslim 2699',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Support', 'Brotherhood', 'Divine Aid'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '2',
        label: 'Cooperate in righteousness and God-consciousness.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '10',
        label: 'Believers are brothers; maintain solidarity.',
      ),
    ],
    meaning:
        'Helping people is not only social virtue; it is a means of receiving Allah\'s assistance.',
    lessons: [
      'Service creates reciprocal barakah.',
      'Justice includes supporting people in need.',
      'Community welfare is a shared faith responsibility.',
    ],
    reflectionPrompts: [
      'Who around me needs practical support now?',
      'Do I wait to be asked before helping?',
      'How can I make support for others a weekly habit?',
    ],
    practiceAction:
        'Provide one concrete form of help today to someone carrying a burden.',
    relatedHadithIds: ['help_brother_oppressor_oppressed', 'trust_honesty'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'repentance_joy',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'Allah Rejoices at the Repentance of His Servant',
    excerpt:
        'Allah is more joyful at His servant’s repentance than one who finds lost provision after despair.',
    hadithText:
        'The Prophet ﷺ taught that Allah rejoices at the repentance of His servant more than one who, after despair, finds what was lost in the desert.',
    englishText:
        'Allah is more pleased with the repentance of His servant than a person who finds his lost mount in a barren desert after losing hope.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2747',
    source: 'Sahih Muslim 2747',
    grading: 'Sahih',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Repentance', 'Hope', 'Mercy'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '53',
        label: 'Do not despair of Allah’s mercy.',
      ),
      QuranConnection(
        surahName: 'Al-Furqan',
        surahNumber: 25,
        verseRange: '70',
        label: 'Allah replaces sins with good for sincere repentance.',
      ),
    ],
    meaning:
        'Repentance is an honored return, not humiliation; Allah loves the one who turns back sincerely.',
    lessons: [
      'No one is too far to return.',
      'Hope should accompany accountability.',
      'Divine mercy remains open while life remains.',
    ],
    reflectionPrompts: [
      'Which habit should I return from with sincerity?',
      'How can I make daily tawbah more consistent?',
      'Where do I need to replace despair with hope in Allah?',
    ],
    practiceAction:
        'End the day with a short repentance dua and renewal of intent.',
    relatedHadithIds: [
      'every_son_of_adam_sins',
      'allah_accepts_repentance_night_day',
      'forgives_if_servant_acknowledges_sin',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'every_son_of_adam_sins',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening', 'beginner_set'],
    title: 'Every Son of Adam Sins',
    excerpt:
        'Human beings fall into sin, but the best among them are those who repent often.',
    hadithText:
        'The Prophet ﷺ said: Every son of Adam sins, and the best of those who sin are those who repent.',
    englishText:
        'All children of Adam make mistakes, and the best of those who make mistakes are those who keep repenting.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2499',
    source: 'Jami\' al-Tirmidhi 2499',
    grading: 'Hasan',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Repentance', 'Human Weakness', 'Hope'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '110',
        label: 'Whoever seeks forgiveness finds Allah Forgiving and Merciful.',
      ),
      QuranConnection(
        surahName: 'At-Tahrim',
        surahNumber: 66,
        verseRange: '8',
        label: 'Turn to Allah in sincere repentance.',
      ),
    ],
    meaning:
        'Sin does not remove a believer from hope; the path forward is honest, repeated repentance.',
    lessons: [
      'Mistakes are part of human life, not a reason to quit.',
      'The best response to sin is returning quickly to Allah.',
      'Consistency in tawbah purifies the heart.',
    ],
    reflectionPrompts: [
      'Do I return quickly after mistakes or delay repentance?',
      'What recurring sin needs a serious plan of change?',
      'How can I normalize daily tawbah in my life?',
    ],
    practiceAction:
        'Make sincere istighfar after each prayer today and ask Allah for firmness.',
    relatedHadithIds: ['repentance_joy', 'repentance_until_soul_throat'],
  ),
  HadithEntry(
    id: 'allah_accepts_repentance_night_day',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'Allah Stretches His Hand to Accept Repentance',
    excerpt:
        'Allah keeps the door of repentance open day and night for those who return.',
    hadithText:
        'The Messenger ﷺ said: Allah stretches out His Hand at night to accept the repentance of the one who sinned by day, and stretches out His Hand by day to accept the repentance of the one who sinned by night.',
    englishText:
        'Allah keeps accepting repentance by night and by day until the major final signs begin.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2759',
    source: 'Sahih Muslim 2759',
    grading: 'Sahih',
    narrator: 'Abu Musa al-Ash\'ari (ra)',
    tags: ['Repentance', 'Divine Mercy', 'Hope'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '53',
        label: 'Do not despair of Allah\'s mercy.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '110',
        label: 'Seeking forgiveness leads to mercy.',
      ),
    ],
    meaning:
        'Allah continuously invites His servants back; repentance should never be postponed.',
    lessons: [
      'The door of tawbah is open now.',
      'Delay is spiritually dangerous when return is possible today.',
      'Mercy from Allah is greater than personal despair.',
    ],
    reflectionPrompts: [
      'What am I delaying in repentance?',
      'Do I believe Allah still invites me to return?',
      'What step can I take today to turn back sincerely?',
    ],
    practiceAction:
        'Make a private repentance moment tonight and list one concrete change to begin tomorrow.',
    relatedHadithIds: ['repentance_joy', 'repentance_until_sun_from_west'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'repentance_until_sun_from_west',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening'],
    title: 'Repentance Is Accepted until the Sun Rises from the West',
    excerpt:
        'The gate of repentance remains open until major final signs appear.',
    hadithText:
        'The Prophet ﷺ said that Allah accepts repentance from His servant so long as the sun has not risen from the west.',
    englishText:
        'Repentance remains accepted until the final cosmic sign when the sun rises from the west.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2703',
    source: 'Sahih Muslim 2703',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Repentance', 'Akhirah', 'Urgency'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-An\'am',
        surahNumber: 6,
        verseRange: '158',
        label: 'Faith after final signs will not benefit those who delayed.',
      ),
      QuranConnection(
        surahName: 'At-Tahrim',
        surahNumber: 66,
        verseRange: '8',
        label: 'Turn to Allah with sincere repentance.',
      ),
    ],
    meaning:
        'Repentance has an appointed window; wisdom is to return before delay becomes loss.',
    lessons: [
      'Spiritual urgency is part of sincerity.',
      'Tomorrow is never guaranteed.',
      'Delaying tawbah hardens the heart.',
    ],
    reflectionPrompts: [
      'What makes me postpone repentance?',
      'If today were my last opportunity, what would I repair first?',
      'How can I respond to reminders without delay?',
    ],
    practiceAction:
        'Turn one postponed repentance intention into action within the next 24 hours.',
    relatedHadithIds: [
      'allah_accepts_repentance_night_day',
      'repentance_until_soul_throat',
    ],
  ),
  HadithEntry(
    id: 'prophet_sought_forgiveness_daily',
    themeId: _repentanceThemeId,
    collectionIds: ['daily_sunnah', essentialCollectionId],
    title: 'The Prophet Sought Forgiveness Many Times Daily',
    excerpt:
        'The Prophet ﷺ made abundant istighfar every day, modeling humility and constant return.',
    hadithText:
        'The Messenger ﷺ said: By Allah, I seek Allah\'s forgiveness and repent to Him more than seventy times in a day.',
    englishText:
        'The Prophet ﷺ regularly sought forgiveness many times each day, teaching constant spiritual renewal.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '6307',
    source: 'Sahih al-Bukhari 6307',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Istighfar', 'Sunnah', 'Consistency'],
    quranConnections: [
      QuranConnection(
        surahName: 'Muhammad',
        surahNumber: 47,
        verseRange: '19',
        label: 'Seek forgiveness for your sin and for believers.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '110',
        label: 'Seeking forgiveness opens divine mercy.',
      ),
    ],
    meaning:
        'If the Prophet ﷺ made frequent istighfar, believers need it even more as a daily practice.',
    lessons: [
      'Repentance is a continuous practice, not only after major sins.',
      'Istighfar softens and purifies the heart.',
      'Humility grows through regular return to Allah.',
    ],
    reflectionPrompts: [
      'How consistent is my daily istighfar?',
      'Do I treat repentance as occasional or ongoing?',
      'What time of day can become my stable istighfar routine?',
    ],
    practiceAction:
        'Set a daily target for istighfar and complete it at a fixed time today.',
    relatedHadithIds: [
      'every_son_of_adam_sins',
      'seeking_forgiveness_brings_relief',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'forgives_if_servant_acknowledges_sin',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening', 'hadith_qudsi'],
    title: 'Allah Forgives a Servant Who Acknowledges His Sin',
    excerpt:
        'When a servant confesses his sin and seeks forgiveness, Allah forgives and receives him.',
    hadithText:
        'In a sacred narration, Allah says about His servant who sins then says: My Lord, I have sinned, so forgive me — and Allah forgives him as long as he keeps returning sincerely.',
    englishText:
        'A servant repeatedly returning in repentance and acknowledging his sin finds Allah Forgiving and Merciful.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 7507 / Muslim 2758',
    source: 'Sahih al-Bukhari 7507 / Sahih Muslim 2758',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Hadith Qudsi', 'Forgiveness', 'Hope'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '110',
        label: 'Whoever seeks forgiveness finds Allah Forgiving and Merciful.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '222',
        label: 'Allah loves those who constantly repent.',
      ),
    ],
    meaning:
        'Repeated sincere return is beloved to Allah; failure is not final when repentance is real.',
    lessons: [
      'Acknowledging sin is a mark of sincerity.',
      'Allah\'s forgiveness is vast for those who keep returning.',
      'Shame should lead to tawbah, not despair.',
    ],
    reflectionPrompts: [
      'Do I excuse my sins or acknowledge them honestly?',
      'How do I return after repeated mistakes?',
      'What does sincere repentance look like for me today?',
    ],
    practiceAction:
        'After one known mistake today, immediately turn to Allah with honest istighfar and a corrective step.',
    relatedHadithIds: ['repentance_joy', 'every_son_of_adam_sins'],
  ),
  HadithEntry(
    id: 'repentance_until_soul_throat',
    themeId: _repentanceThemeId,
    collectionIds: ['heart_softening'],
    title: 'Repentance Is Accepted until the Soul Reaches the Throat',
    excerpt:
        'Allah accepts repentance from the servant so long as death has not reached final certainty.',
    hadithText:
        'The Prophet ﷺ said: Allah accepts the repentance of the servant so long as the soul has not reached the throat.',
    englishText:
        'Repentance remains accepted until the final moments before death.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '3537',
    source: 'Jami\' al-Tirmidhi 3537',
    grading: 'Hasan',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Repentance', 'Death', 'Urgency'],
    quranConnections: [
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '18',
        label: 'Repentance delayed until death is not true return.',
      ),
      QuranConnection(
        surahName: 'At-Tahrim',
        surahNumber: 66,
        verseRange: '8',
        label: 'Sincere repentance must be made in time.',
      ),
    ],
    meaning:
        'Repentance should be made while life and choice remain; delaying to the end is spiritual loss.',
    lessons: [
      'Timely repentance protects the soul.',
      'Life is short; return should be immediate.',
      'Sincerity is shown by action before final moments.',
    ],
    reflectionPrompts: [
      'What repentance am I postponing dangerously?',
      'How often do I remember the fragility of life?',
      'What can I repair today before it is too late?',
    ],
    practiceAction:
        'Make one sincere tawbah today from a specific sin and pair it with a concrete behavioral change.',
    relatedHadithIds: [
      'repentance_until_sun_from_west',
      'every_son_of_adam_sins',
    ],
  ),
  HadithEntry(
    id: 'seeking_forgiveness_brings_relief',
    themeId: _repentanceThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'Seeking Forgiveness Brings Relief',
    excerpt:
        'Consistent istighfar becomes a means of relief, provision, and openings from Allah.',
    hadithText:
        'The Prophet ﷺ said: Whoever constantly seeks forgiveness, Allah will appoint for him a way out from every distress, relief from every worry, and provision from where he does not expect.',
    englishText:
        'Regular istighfar opens doors of relief and provision by Allah’s mercy.',
    sourceCollection: 'Sunan Abi Dawud',
    sourceReference: '1518',
    source: 'Sunan Abi Dawud 1518',
    grading: 'Hasan',
    narrator: 'Abdullah ibn Abbas (ra)',
    tags: ['Istighfar', 'Relief', 'Provision'],
    quranConnections: [
      QuranConnection(
        surahName: 'Nuh',
        surahNumber: 71,
        verseRange: '10-12',
        label: 'Seek forgiveness; Allah sends provision and support.',
      ),
      QuranConnection(
        surahName: 'At-Talaq',
        surahNumber: 65,
        verseRange: '2-3',
        label: 'Allah grants a way out and provision from unexpected places.',
      ),
    ],
    meaning:
        'Istighfar is both spiritual cleansing and a means for life openings through Allah\'s mercy.',
    lessons: [
      'Repentance affects both heart and daily life.',
      'Regular istighfar builds humility and hope.',
      'Allah grants unexpected openings to those who return sincerely.',
    ],
    reflectionPrompts: [
      'How often do I turn to istighfar when worried?',
      'Do I trust Allah to open relief through repentance?',
      'What prevents me from consistent daily istighfar?',
    ],
    practiceAction:
        'Set two daily moments for istighfar (morning and evening) and keep them today.',
    relatedHadithIds: [
      'prophet_sought_forgiveness_daily',
      'allah_accepts_repentance_night_day',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'patience_gratitude_balance',
    themeId: _patienceThemeId,
    collectionIds: ['heart_softening', 'beginner_set'],
    title: 'How Wonderful Is the Affair of the Believer',
    excerpt:
        'The believer responds to ease with gratitude and to hardship with patience.',
    hadithText:
        'The Prophet ﷺ said: Wondrous is the affair of the believer. If ease comes, he is grateful; if hardship comes, he is patient, and that is good for him.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2999',
    source: 'Sahih Muslim 2999',
    grading: 'Sahih',
    narrator: 'Suhaib (ra)',
    tags: ['Patience', 'Gratitude', 'Resilience'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ibrahim',
        surahNumber: 14,
        verseRange: '7',
        label: 'Gratitude brings increase in blessings.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '153',
        label: 'Seek help through patience and prayer.',
      ),
    ],
    meaning:
        'Faith trains the heart to remain balanced through changing circumstances.',
    lessons: [
      'Gratitude and patience are twin paths of worship.',
      'Spiritual steadiness grows through perspective.',
    ],
    reflectionPrompts: [
      'How do I respond differently in ease versus difficulty?',
      'What would grateful patience look like today?',
      'Which blessing should I consciously thank Allah for right now?',
    ],
    practiceAction:
        'Write one gratitude line and one patience intention before sleep.',
    relatedHadithIds: ['patience_first_strike', 'look_at_those_below'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'patience_first_strike',
    themeId: _patienceThemeId,
    collectionIds: ['heart_softening', 'daily_sunnah'],
    title: 'Patience Is at the First Strike of Calamity',
    excerpt:
        'The truest patience appears at the first shock of difficulty, not only after time passes.',
    hadithText:
        'The Prophet ﷺ said: Patience is at the first strike of calamity.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 1283 / Muslim 926',
    source: 'Sahih al-Bukhari 1283 / Sahih Muslim 926',
    grading: 'Muttafaqun Alayh',
    narrator: 'Anas ibn Malik (ra)',
    tags: ['Patience', 'Calamity', 'Restraint'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '155-156',
        label: 'Believers respond to trial with surrender to Allah.',
      ),
      QuranConnection(
        surahName: 'Ash-Sharh',
        surahNumber: 94,
        verseRange: '5-6',
        label: 'With hardship comes ease.',
      ),
    ],
    meaning:
        'Immediate restraint and trust when hardship arrives is a high form of patient faith.',
    lessons: [
      'First reactions reveal spiritual training.',
      'Patience includes guarding speech and behavior in pain.',
      'Sabr is active trust, not emotional numbness.',
    ],
    reflectionPrompts: [
      'How do I react in the first moments of stress?',
      'What phrase or dua helps me steady myself?',
      'Where can I replace panic with trust?',
    ],
    practiceAction:
        'When upset today, pause before speaking and repeat a brief dhikr of trust.',
    relatedHadithIds: ['patience_gratitude_balance', 'whoever_remains_patient'],
  ),
  HadithEntry(
    id: 'whoever_remains_patient',
    themeId: _patienceThemeId,
    collectionIds: ['heart_softening', 'beginner_set'],
    title: 'Whoever Remains Patient, Allah Will Make Him Patient',
    excerpt:
        'When a believer chooses patience sincerely, Allah strengthens him with patience.',
    hadithText:
        'The Messenger ﷺ said: Whoever seeks to remain patient, Allah will grant him patience.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 1469 / Muslim 1053',
    source: 'Sahih al-Bukhari 1469 / Sahih Muslim 1053',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Sa\'id al-Khudri (ra)',
    tags: ['Patience', 'Reliance', 'Growth'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '10',
        label: 'The patient are rewarded without measure.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '153',
        label: 'Allah is with the patient.',
      ),
    ],
    meaning:
        'Patience is both a choice and a divine gift; effort and dependence on Allah work together.',
    lessons: [
      'Sabr can be cultivated through intention and practice.',
      'Divine help accompanies sincere striving.',
      'Emotional endurance grows through repeated reliance on Allah.',
    ],
    reflectionPrompts: [
      'Where do I need more patience right now?',
      'Do I ask Allah for patience as often as I ask for relief?',
      'What habit can help me build steady endurance?',
    ],
    practiceAction:
        'Make a specific dua for patience in one ongoing challenge today.',
    relatedHadithIds: ['patience_greatest_gift', 'patience_first_strike'],
  ),
  HadithEntry(
    id: 'strong_believer_patience',
    themeId: _patienceThemeId,
    collectionIds: [essentialCollectionId, 'beginner_set'],
    title: 'The Strong Believer Is Better and More Beloved to Allah',
    excerpt:
        'The believer is called to beneficial strength with effort, hope, and reliance on Allah.',
    hadithText:
        'The Messenger ﷺ said: The strong believer is better and more beloved to Allah than the weak believer, though in both there is good. Be eager for what benefits you, seek help from Allah, and do not give up.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2664',
    source: 'Sahih Muslim 2664',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Strength', 'Resilience', 'Tawakkul'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Resolve, then rely on Allah.',
      ),
      QuranConnection(
        surahName: 'Ash-Sharh',
        surahNumber: 94,
        verseRange: '5-6',
        label: 'Relief accompanies hardship.',
      ),
    ],
    meaning:
        'Islam encourages resilient, hopeful action while staying dependent on Allah.',
    lessons: [
      'Strength includes emotional and spiritual endurance.',
      'Faith rejects helplessness and despair.',
      'Resilience grows through purposeful effort and trust.',
    ],
    reflectionPrompts: [
      'Which type of strength do I need to build most?',
      'Do I give up too quickly in beneficial efforts?',
      'How can I pair effort with tawakkul this week?',
    ],
    practiceAction:
        'Choose one beneficial goal and take one concrete step today without postponing.',
    relatedHadithIds: ['whoever_remains_patient', 'hardship_expiates_sins'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'look_at_those_below',
    themeId: _patienceThemeId,
    collectionIds: ['daily_sunnah', 'heart_softening'],
    title: 'Look at Those Below You',
    excerpt:
        'In worldly matters, looking at those with less helps preserve gratitude and prevents envy.',
    hadithText:
        'The Prophet ﷺ said: Look to those below you, and do not look to those above you, for that is more likely to keep you from belittling Allah\'s favor upon you.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6490 / Muslim 2963',
    source: 'Sahih al-Bukhari 6490 / Sahih Muslim 2963',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Gratitude', 'Contentment', 'Perspective'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ibrahim',
        surahNumber: 14,
        verseRange: '7',
        label: 'Gratitude increases blessings.',
      ),
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '12',
        label: 'Be grateful to Allah.',
      ),
    ],
    meaning:
        'Correct perspective protects gratitude and reduces comparison-driven dissatisfaction.',
    lessons: [
      'Comparison can erase awareness of blessings.',
      'Gratitude requires conscious perspective.',
      'Contentment grows by seeing Allah\'s favors clearly.',
    ],
    reflectionPrompts: [
      'Where does comparison steal my gratitude?',
      'Which blessings have I become used to and forgotten?',
      'How can I train my heart for contentment?',
    ],
    practiceAction:
        'List three overlooked blessings today and thank Allah for each by name.',
    relatedHadithIds: [
      'patience_gratitude_balance',
      'prophet_gratitude_prayer_night',
    ],
  ),
  HadithEntry(
    id: 'prophet_gratitude_prayer_night',
    themeId: _patienceThemeId,
    collectionIds: ['prayer_devotion', 'heart_softening'],
    title: 'The Prophet Prayed until His Feet Swelled out of Gratitude',
    excerpt:
        'The Prophet ﷺ increased worship in gratitude, even though he was forgiven.',
    hadithText:
        'When asked why he stood long in prayer until his feet swelled, the Prophet ﷺ said: Should I not be a grateful servant?',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 1130 / Muslim 2819',
    source: 'Sahih al-Bukhari 1130 / Sahih Muslim 2819',
    grading: 'Muttafaqun Alayh',
    narrator: 'Aishah (ra)',
    tags: ['Gratitude', 'Worship', 'Night Prayer'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ibrahim',
        surahNumber: 14,
        verseRange: '7',
        label: 'Gratitude brings increase.',
      ),
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '12',
        label: 'Be grateful to Allah.',
      ),
    ],
    meaning:
        'True gratitude appears in worship and obedience, not only in words.',
    lessons: [
      'Shukr is shown through action and devotion.',
      'Even in ease, believers intensify gratitude.',
      'The Prophet ﷺ modeled gratitude as worship.',
    ],
    reflectionPrompts: [
      'How is gratitude visible in my worship?',
      'Do I thank Allah only with words or also with deeds?',
      'What act of worship can become my gratitude habit?',
    ],
    practiceAction:
        'Pray two extra rak\'ahs today as a private act of gratitude.',
    relatedHadithIds: ['look_at_those_below', 'patience_gratitude_balance'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'hardship_expiates_sins',
    themeId: _patienceThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'Hardship Expiates Sins',
    excerpt:
        'No pain or hardship afflicts a believer except that Allah removes sins through it.',
    hadithText:
        'The Prophet ﷺ said: No fatigue, illness, anxiety, sorrow, harm, or distress afflicts a Muslim, even the prick of a thorn, except that Allah expiates some of his sins because of it.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 5641-5642 / Muslim 2573',
    source: 'Sahih al-Bukhari 5641-5642 / Sahih Muslim 2573',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Sa\'id al-Khudri / Abu Hurayrah (ra)',
    tags: ['Hardship', 'Expiation', 'Hope'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ash-Sharh',
        surahNumber: 94,
        verseRange: '5-6',
        label: 'With hardship comes ease.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '155',
        label: 'Believers are tested and guided through trial.',
      ),
    ],
    meaning:
        'Hardship can become purification when met with faith, patience, and trust.',
    lessons: [
      'Pain is not always punishment; it can be purification.',
      'Believers should carry hardship with hopeful patience.',
      'Even small struggles are spiritually meaningful.',
    ],
    reflectionPrompts: [
      'How can I hold hardship with hope instead of despair?',
      'What trial in my life needs reframing through faith?',
      'How can I stay connected to Allah during stress?',
    ],
    practiceAction:
        'When hardship appears today, respond with a short dua and intentional patience before reacting.',
    relatedHadithIds: ['patience_first_strike', 'patience_greatest_gift'],
    isEssential: true,
  ),
  HadithEntry(
    id: 'patience_greatest_gift',
    themeId: _patienceThemeId,
    collectionIds: ['heart_softening', 'beginner_set'],
    title: 'Patience Is One of the Greatest Gifts',
    excerpt: 'No one is given a gift better and more expansive than patience.',
    hadithText:
        'The Messenger ﷺ said: No one has been given a gift better and more expansive than patience.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 1469 / Muslim 1053',
    source: 'Sahih al-Bukhari 1469 / Sahih Muslim 1053',
    grading: 'Muttafaqun Alayh',
    narrator: 'Abu Sa\'id al-Khudri (ra)',
    tags: ['Patience', 'Gift', 'Character'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '10',
        label: 'The patient receive immeasurable reward.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '153',
        label: 'Allah is with the patient.',
      ),
    ],
    meaning:
        'Patience is among the greatest resources Allah grants for surviving and growing through life.',
    lessons: [
      'Sabr is a priceless spiritual provision.',
      'Patience sustains worship, relationships, and resilience.',
      'Long-term faith requires patient endurance.',
    ],
    reflectionPrompts: [
      'Do I value patience as a gift or treat it as a burden?',
      'Where is Allah inviting me to grow through patience?',
      'What would patient strength look like this week?',
    ],
    practiceAction:
        'Choose one repeated annoyance and respond to it patiently all day as deliberate worship.',
    relatedHadithIds: ['whoever_remains_patient', 'hardship_expiates_sins'],
  ),
  HadithEntry(
    id: 'remember_destroyer_of_pleasures',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening'],
    title: 'Remember Often the Destroyer of Pleasures',
    excerpt:
        'Remember death frequently, for it cuts attachment to fleeting pleasures.',
    hadithText:
        'The Prophet ﷺ said: Remember often the destroyer of pleasures — death.',
    englishText:
        'Frequent remembrance of death reorders priorities and softens attachment to dunya.',
    sourceCollection: 'Jami\' al-Tirmidhi / Sunan al-Nasa\'i / Ibn Majah',
    sourceReference: 'Tirmidhi 2307',
    source: 'Jami\' al-Tirmidhi 2307',
    grading: 'Hasan',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Death', 'Awareness', 'Detachment'],
    quranConnections: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '185',
        label: 'Every soul shall taste death.',
      ),
      QuranConnection(
        surahName: 'Al-Hadid',
        surahNumber: 57,
        verseRange: '20',
        label: 'Worldly life is temporary enjoyment.',
      ),
    ],
    meaning:
        'Remembering death does not cause despair; it restores perspective and sincerity.',
    lessons: [
      'Mortality awareness purifies priorities.',
      'Dunya is temporary; accountability is lasting.',
      'Remembering death can revive purposeful living.',
    ],
    reflectionPrompts: [
      'What would I change if I remembered death more often?',
      'Which attachments distract me from the hereafter?',
      'How can I live more intentionally this week?',
    ],
    practiceAction:
        'Take one quiet moment today to reflect on your life purpose and make one hereafter-focused intention.',
    relatedHadithIds: [
      'be_in_world_as_traveler',
      'grave_first_stage_hereafter',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'be_in_world_as_traveler',
    themeId: _deathHereafterThemeId,
    collectionIds: ['beginner_set', 'heart_softening'],
    title: 'Be in This World as a Traveler',
    excerpt:
        'Live in this world with the mindset of a traveler, not permanent ownership.',
    hadithText:
        'The Messenger ﷺ said to Ibn Umar: Be in this world as though you were a stranger or a traveler.',
    englishText:
        'The believer uses dunya responsibly while keeping the heart attached to the hereafter.',
    sourceCollection: 'Sahih al-Bukhari',
    sourceReference: '6416',
    source: 'Sahih al-Bukhari 6416',
    grading: 'Sahih',
    narrator: 'Abdullah ibn Umar (ra)',
    tags: ['Dunya', 'Traveler', 'Hereafter'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hadid',
        surahNumber: 57,
        verseRange: '20',
        label: 'Worldly life is brief compared to the hereafter.',
      ),
      QuranConnection(
        surahName: 'Al-Qasas',
        surahNumber: 28,
        verseRange: '77',
        label: 'Seek the hereafter while using your share of this world.',
      ),
    ],
    meaning:
        'Believers engage the world responsibly but do not let it become the final destination of the heart.',
    lessons: [
      'Detachment means balance, not neglect of duty.',
      'Long-term success is measured by the hereafter.',
      'Simplicity can protect sincerity.',
    ],
    reflectionPrompts: [
      'Where am I living as if dunya is permanent?',
      'What habits can make my life more hereafter-oriented?',
      'How can I use worldly means for eternal goals?',
    ],
    practiceAction:
        'Declutter one attachment today (time, spending, distraction) and redirect it to a lasting good.',
    relatedHadithIds: [
      'remember_destroyer_of_pleasures',
      'intelligent_prepares_after_death',
    ],
  ),
  HadithEntry(
    id: 'intelligent_prepares_after_death',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening'],
    title: 'The Intelligent Person Prepares for What Comes after Death',
    excerpt:
        'True intelligence is self-accountability and preparation for life after death.',
    hadithText:
        'The Prophet ﷺ said: The intelligent one is the one who takes himself to account and works for what comes after death.',
    englishText:
        'Real wisdom is disciplined self-evaluation and preparation for the next life.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2459',
    source: 'Jami\' al-Tirmidhi 2459',
    grading: 'Hasan',
    narrator: 'Shaddad ibn Aws (ra)',
    tags: ['Accountability', 'Preparation', 'Wisdom'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hashr',
        surahNumber: 59,
        verseRange: '18',
        label: 'Let every soul consider what it has sent forward.',
      ),
      QuranConnection(
        surahName: 'Al-Qiyamah',
        surahNumber: 75,
        verseRange: '36',
        label: 'Humans are not left without accountability.',
      ),
    ],
    meaning:
        'Spiritual maturity requires honest self-audit and practical preparation for meeting Allah.',
    lessons: [
      'Self-accountability is a prophetic discipline.',
      'Intentions must become actions before death.',
      'Preparation beats regret.',
    ],
    reflectionPrompts: [
      'What would my current priorities say about my hereafter preparation?',
      'Where do I need more honest self-accounting?',
      'What one act should I begin now before delay?',
    ],
    practiceAction:
        'Do a short end-of-day self-audit tonight and write one repentance and one action commitment.',
    relatedHadithIds: [
      'accountability_day_of_judgment',
      'grave_first_stage_hereafter',
    ],
  ),
  HadithEntry(
    id: 'accountability_day_of_judgment',
    themeId: _deathHereafterThemeId,
    collectionIds: [essentialCollectionId, 'heart_softening'],
    title: 'Accountability on the Day of Judgment',
    excerpt:
        'Every deed, small or great, will be brought to account before Allah.',
    hadithText:
        'The Prophet ﷺ taught that the servant’s feet will not move on the Day of Judgment until he is asked about his life, youth, wealth, and knowledge.',
    englishText:
        'Life, time, wealth, and knowledge are trusts that will be questioned in the hereafter.',
    sourceCollection: 'Jami\' al-Tirmidhi',
    sourceReference: '2417',
    source: 'Jami\' al-Tirmidhi 2417',
    grading: 'Hasan Sahih',
    narrator: 'Abu Barzah al-Aslami (ra)',
    tags: ['Judgment', 'Accountability', 'Akhirah'],
    quranConnections: [
      QuranConnection(
        surahName: 'Az-Zalzalah',
        surahNumber: 99,
        verseRange: '7-8',
        label: 'Even atom-weight deeds will be seen.',
      ),
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '115',
        label: 'Humans were not created without purpose.',
      ),
    ],
    meaning:
        'Accountability is comprehensive and just; every trust in life has a corresponding question in the hereafter.',
    lessons: [
      'Time and youth are sacred trusts.',
      'Knowledge demands action.',
      'Small deeds matter deeply.',
    ],
    reflectionPrompts: [
      'How am I using my time and energy now?',
      'What trust of wealth or knowledge needs correction?',
      'Which daily action would I be content to present before Allah?',
    ],
    practiceAction:
        'Review one part of your schedule today and replace a wasteful slot with a beneficial deed.',
    relatedHadithIds: [
      'intelligent_prepares_after_death',
      'remember_destroyer_of_pleasures',
    ],
    isEssential: true,
  ),
  HadithEntry(
    id: 'visit_graves_reflection',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening', 'daily_sunnah'],
    title: 'Visit Graves for Reflection',
    excerpt:
        'Grave visitation softens hearts and reminds believers of the hereafter.',
    hadithText:
        'The Prophet ﷺ said: I had forbidden you from visiting graves; now visit them, for they remind you of the hereafter.',
    englishText:
        'Visiting graves with proper manners revives remembrance of death and accountability.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '977',
    source: 'Sahih Muslim 977',
    grading: 'Sahih',
    narrator: 'Buraydah (ra)',
    tags: ['Graves', 'Reminder', 'Hereafter'],
    quranConnections: [
      QuranConnection(
        surahName: 'At-Takathur',
        surahNumber: 102,
        verseRange: '1-2',
        label: 'Worldly competition ends at the graves.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '185',
        label: 'Every soul tastes death.',
      ),
    ],
    meaning:
        'Healthy remembrance of death awakens sincerity and reduces heedlessness.',
    lessons: [
      'Reflection on death can reform daily conduct.',
      'The grave is a teacher of perspective.',
      'Hereafter awareness should produce humility.',
    ],
    reflectionPrompts: [
      'How often do I remember the temporary nature of life?',
      'What changes when I reflect on death seriously?',
      'Which heedless habit needs to end?',
    ],
    practiceAction:
        'Read a short dua for the deceased today and reflect for a few minutes on your own accountability.',
    relatedHadithIds: [
      'remember_destroyer_of_pleasures',
      'grave_first_stage_hereafter',
    ],
  ),
  HadithEntry(
    id: 'dunya_prison_believer',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening'],
    title: 'The Dunya Is a Prison for the Believer',
    excerpt:
        'Relative to the freedom of Paradise, worldly life is constrained for the believer.',
    hadithText:
        'The Prophet ﷺ said: The world is a prison for the believer and a paradise for the disbeliever.',
    englishText:
        'A believer does not measure life only by immediate comfort, but by eternal outcome.',
    sourceCollection: 'Sahih Muslim',
    sourceReference: '2956',
    source: 'Sahih Muslim 2956',
    grading: 'Sahih',
    narrator: 'Abu Hurayrah (ra)',
    tags: ['Dunya', 'Detachment', 'Perspective'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Hadid',
        surahNumber: 57,
        verseRange: '20',
        label: 'Dunya is temporary play compared to the hereafter.',
      ),
      QuranConnection(
        surahName: 'Al-A\'la',
        surahNumber: 87,
        verseRange: '16-17',
        label: 'The hereafter is better and more lasting.',
      ),
    ],
    meaning:
        'Worldly limitations are understood within a larger eternal hope, not as ultimate loss.',
    lessons: [
      'Temporary hardship can carry eternal reward.',
      'Comfort is not the only measure of success.',
      'Perspective protects faith during difficulty.',
    ],
    reflectionPrompts: [
      'Do I judge life only by immediate ease?',
      'How can I keep eternal perspective in difficult moments?',
      'What worldly attachment most weakens my hereafter focus?',
    ],
    practiceAction:
        'Reframe one current hardship today as a chance for patient reward and write the lesson it can produce.',
    relatedHadithIds: ['be_in_world_as_traveler', 'whoever_loves_meet_allah'],
  ),
  HadithEntry(
    id: 'whoever_loves_meet_allah',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening'],
    title: 'Whoever Loves to Meet Allah',
    excerpt:
        'Whoever loves meeting Allah with faith and hope, Allah loves meeting him.',
    hadithText:
        'The Messenger ﷺ said: Whoever loves to meet Allah, Allah loves to meet him; and whoever dislikes meeting Allah, Allah dislikes meeting him.',
    englishText:
        'A believer’s hopeful readiness at life’s end is met by divine welcome and mercy.',
    sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
    sourceReference: 'Bukhari 6507 / Muslim 2683',
    source: 'Sahih al-Bukhari 6507 / Sahih Muslim 2683',
    grading: 'Muttafaqun Alayh',
    narrator: 'Ubadah ibn al-Samit / Aishah (ra)',
    tags: ['Meeting Allah', 'Hope', 'End of Life'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Kahf',
        surahNumber: 18,
        verseRange: '110',
        label: 'Whoever hopes to meet his Lord should do righteous deeds.',
      ),
      QuranConnection(
        surahName: 'Al-Fajr',
        surahNumber: 89,
        verseRange: '27-30',
        label: 'The tranquil soul is invited to return to its Lord.',
      ),
    ],
    meaning:
        'Preparing for death with faith, repentance, and hope creates a beautiful meeting with Allah.',
    lessons: [
      'End-of-life hope is built through daily obedience.',
      'Fear and hope should remain balanced.',
      'Meeting Allah is the ultimate destination of believers.',
    ],
    reflectionPrompts: [
      'Am I living in a way that prepares me to meet Allah with hope?',
      'What unresolved matter should I repair now?',
      'How can I increase righteous deeds this week?',
    ],
    practiceAction:
        'Make one sincere repentance and one good deed today with the intention of preparing to meet Allah.',
    relatedHadithIds: [
      'remember_destroyer_of_pleasures',
      'grave_first_stage_hereafter',
    ],
  ),
  HadithEntry(
    id: 'grave_first_stage_hereafter',
    themeId: _deathHereafterThemeId,
    collectionIds: ['heart_softening', essentialCollectionId],
    title: 'The Grave Is the First Stage of the Hereafter',
    excerpt:
        'The grave marks the first station after death and sets the tone for what follows.',
    hadithText:
        'The Prophet ﷺ said: The grave is the first stage of the hereafter; if one is saved from it, what follows is easier, and if not, what follows is harder.',
    englishText:
        'Awareness of the grave should inspire sincere repentance and preparation before death.',
    sourceCollection: 'Jami\' al-Tirmidhi / Ibn Majah',
    sourceReference: 'Tirmidhi 2308',
    source: 'Jami\' al-Tirmidhi 2308',
    grading: 'Hasan',
    narrator: 'Uthman ibn Affan (ra)',
    tags: ['Grave', 'Hereafter', 'Preparation'],
    quranConnections: [
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '99-100',
        label: 'After death comes barzakh until resurrection.',
      ),
      QuranConnection(
        surahName: 'Al-Qiyamah',
        surahNumber: 75,
        verseRange: '36',
        label: 'Human beings are not left without purpose or return.',
      ),
    ],
    meaning:
        'The grave is not an abstract idea but a real beginning of afterlife accountability.',
    lessons: [
      'Preparation should start before death, not at its arrival.',
      'Barzakh awareness encourages sincere reform.',
      'Hereafter-oriented living gives urgency to good deeds.',
    ],
    reflectionPrompts: [
      'What would I regret if my life ended soon?',
      'Which deed can I begin now to prepare for the grave?',
      'How can I reduce heedlessness in daily routine?',
    ],
    practiceAction:
        'Set one recurring weekly act (charity, Quran, or service) as ongoing preparation for the hereafter.',
    relatedHadithIds: [
      'visit_graves_reflection',
      'intelligent_prepares_after_death',
    ],
    isEssential: true,
  ),
];

const List<HadithTheme> seededHadithThemes = [
  HadithTheme(
    id: _faithThemeId,
    title: 'Faith & Intention',
    subtitle:
        'Purify the heart, the motive, and the purpose behind every action',
    description:
        'This theme explores sincerity, belief, honesty of purpose, and the inner state that gives actions their true value before Allah.',
    icon: Icons.favorite_border_rounded,
    hadithIds: [
      'intentions_core',
      'religion_sincerity',
      'lawful_unlawful_clear',
      'leave_what_not_concern',
      'love_for_brother',
      'hearts_and_deeds',
      'strong_believer',
      'speak_good_or_silent_faith',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Bayyinah',
        surahNumber: 98,
        verseRange: '5',
        label: 'Sincere devotion to Allah alone.',
      ),
      QuranConnection(
        surahName: 'Al-Mulk',
        surahNumber: 67,
        verseRange: '2',
        label: 'Life is a test of best action.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '225',
        label: 'Allah knows what hearts intend and earn.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '13',
        label: 'True honor is by taqwa and sincerity.',
      ),
    ],
    isFeatured: true,
  ),
  HadithTheme(
    id: _prayerThemeId,
    title: 'Prayer',
    subtitle:
        'Guard your salah, deepen your khushuʿ, and return to Allah throughout the day',
    description:
        'This theme explores the place of prayer in a believer’s life through hadith on sincerity, discipline, purification, congregation, humility, and consistency.',
    icon: Icons.access_time_rounded,
    hadithIds: [
      'islam_built_on_five_prayer',
      'covenant_is_prayer',
      'first_account_prayer',
      'pray_as_you_have_seen_me',
      'conversation_with_lord',
      'closest_in_sujud',
      'wudu_then_prayer',
      'congregation_superior',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '43',
        label: 'Establish prayer and bow with those who bow.',
      ),
      QuranConnection(
        surahName: 'Al-Ankabut',
        surahNumber: 29,
        verseRange: '45',
        label: 'Prayer restrains immorality and wrongdoing.',
      ),
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '1-2',
        label: 'Success belongs to believers humble in prayer.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '103',
        label: 'Prayer is prescribed at fixed times.',
      ),
      QuranConnection(
        surahName: 'Al-A\'la',
        surahNumber: 87,
        verseRange: '14-15',
        label: 'Purification, remembrance, and prayer are linked.',
      ),
    ],
    isFeatured: true,
  ),
  HadithTheme(
    id: _characterThemeId,
    title: 'Character & Manners',
    subtitle:
        'Cultivate honesty, humility, patience, kindness, and dignity in daily life.',
    description:
        'This theme explores how faith shapes behavior through the teachings of the Prophet ﷺ. It focuses on mercy, truthfulness, humility, speech discipline, and ethical conduct.',
    icon: Icons.record_voice_over_rounded,
    hadithIds: [
      'sent_to_perfect_character',
      'best_character_among_you',
      'not_insulting_or_cursing',
      'kind_speech',
      'merciful_shown_mercy_character',
      'anger_control_strength',
      'smiling_is_charity',
      'truthfulness_to_righteousness',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Qalam',
        surahNumber: 68,
        verseRange: '4',
        label: 'The Prophet ﷺ is upon magnificent character.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice, excellence, and ethical conduct.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '11-12',
        label: 'Avoid mockery, insult, suspicion, and backbiting.',
      ),
      QuranConnection(
        surahName: 'Fussilat',
        surahNumber: 41,
        verseRange: '34',
        label: 'Repel harm with what is better.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Mercy and gentleness are prophetic qualities.',
      ),
    ],
    isFeatured: true,
  ),
  HadithTheme(
    id: _mercyThemeId,
    title: 'Mercy & Compassion',
    subtitle:
        'Reflect the mercy of Allah through kindness, forgiveness, and empathy.',
    description:
        'This theme explores how the Prophet ﷺ demonstrated mercy toward people, animals, and communities. It highlights compassion as a central trait of believers.',
    icon: Icons.volunteer_activism_rounded,
    hadithIds: [
      'mercy_creation',
      'no_mercy_no_mercy',
      'gentleness_all_matters',
      'woman_cruelty_cat',
      'man_forgiven_water_dog',
      'stood_for_funeral_procession',
      'shortened_prayer_child_cry',
      'relieve_believer_hardship',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Anbiya',
        surahNumber: 21,
        verseRange: '107',
        label: 'The Prophet ﷺ was sent as mercy to the worlds.',
      ),
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '156',
        label: 'Allah\'s mercy encompasses all things.',
      ),
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '159',
        label: 'Mercy and gentleness shape prophetic conduct.',
      ),
      QuranConnection(
        surahName: 'Al-Balad',
        surahNumber: 90,
        verseRange: '17',
        label: 'Encourage patience and mercy.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice and excellence.',
      ),
    ],
  ),
  HadithTheme(
    id: _knowledgeThemeId,
    title: 'Knowledge',
    subtitle: 'Seek understanding that guides the heart, mind, and actions.',
    description:
        'This theme explores the pursuit of beneficial knowledge through the teachings of the Prophet ﷺ. It highlights learning as a path to wisdom, humility, and deeper faith.',
    icon: Icons.menu_book_rounded,
    hadithIds: [
      'knowledge_obligation',
      'seek_knowledge',
      'scholars_inheritors_prophets',
      'knowledge_path_paradise_easy',
      'conceals_knowledge',
      'superiority_learned_worshipper',
      'wisdom_lost_property',
      'learn_teach_quran',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '9',
        label: 'Are those who know equal to those who do not know?',
      ),
      QuranConnection(
        surahName: 'Ta-Ha',
        surahNumber: 20,
        verseRange: '114',
        label: 'My Lord, increase me in knowledge.',
      ),
      QuranConnection(
        surahName: 'Al-Mujadila',
        surahNumber: 58,
        verseRange: '11',
        label: 'Allah raises those given knowledge in rank.',
      ),
      QuranConnection(
        surahName: 'Al-Alaq',
        surahNumber: 96,
        verseRange: '1-5',
        label: 'The first revelation centers on reading and learning.',
      ),
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '43',
        label: 'Ask people of knowledge when you do not know.',
      ),
    ],
  ),
  HadithTheme(
    id: _duaThemeId,
    title: 'Duʿā & Remembrance',
    subtitle:
        'Keep your heart connected to Allah through supplication and remembrance.',
    description:
        'This theme explores the teachings of the Prophet ﷺ about remembering Allah, making duʿā, and keeping the heart spiritually awake throughout daily life.',
    icon: Icons.spa_outlined,
    hadithIds: [
      'example_remembers_allah',
      'dua_worship',
      'increase_dua_in_prostration',
      'two_phrases_light_on_tongue',
      'subhanallahi_wabihamdihi_hundred_times',
      'allah_remembers_those_who_remember_him',
      'la_ilaha_illa_allah_sincerely',
      'gatherings_dhikr_surrounded_angels',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '152',
        label: 'Remember Me and I will remember you.',
      ),
      QuranConnection(
        surahName: 'Ar-Ra\'d',
        surahNumber: 13,
        verseRange: '28',
        label: 'Hearts find tranquility in Allah\'s remembrance.',
      ),
      QuranConnection(
        surahName: 'Ghafir',
        surahNumber: 40,
        verseRange: '60',
        label: 'Call upon Me; I will respond to you.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '41',
        label: 'Remember Allah with abundant remembrance.',
      ),
      QuranConnection(
        surahName: 'Al-A\'raf',
        surahNumber: 7,
        verseRange: '205',
        label: 'Remember your Lord humbly and inwardly.',
      ),
    ],
  ),
  HadithTheme(
    id: _familyThemeId,
    title: 'Family & Relationships',
    subtitle:
        'Build homes and communities through kindness, respect, and responsibility.',
    description:
        'This theme explores the teachings of the Prophet ﷺ about family life, parenting, marriage, and relationships with neighbors and relatives.',
    icon: Icons.family_restroom_rounded,
    hadithIds: [
      'family_best_to_family',
      'paradise_feet_mothers',
      'mercy_young_respect_elders',
      'prophet_helped_family_home',
      'best_believer_character_family',
      'raising_children_good_manners',
      'honor_your_neighbor',
      'charity_toward_family',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Ar-Rum',
        surahNumber: 30,
        verseRange: '21',
        label: 'Marriage is founded on tranquility, love, and mercy.',
      ),
      QuranConnection(
        surahName: 'Al-Isra',
        surahNumber: 17,
        verseRange: '23',
        label: 'Show excellence and humility to parents.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '19',
        label: 'Live with spouses in kindness.',
      ),
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '14',
        label: 'Give thanks and show dutifulness to parents.',
      ),
      QuranConnection(
        surahName: 'Al-Hujurat',
        surahNumber: 49,
        verseRange: '10',
        label: 'Believers are brothers; reconcile and preserve bonds.',
      ),
    ],
  ),
  HadithTheme(
    id: _justiceThemeId,
    title: 'Justice & Trust',
    subtitle: 'Uphold fairness, honesty, and responsibility in all dealings.',
    description:
        'This theme explores the teachings of the Prophet ﷺ about justice, trustworthiness, and ethical conduct in personal and public life.',
    icon: Icons.balance_rounded,
    hadithIds: [
      'signs_hypocrisy',
      'honest_merchants',
      'each_shepherd',
      'help_brother_oppressor_oppressed',
      'whoever_cheats_not_among_us',
      'just_on_pulpits_of_light',
      'trust_honesty',
      'allah_helps_servant_helps_brother',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'An-Nahl',
        surahNumber: 16,
        verseRange: '90',
        label: 'Allah commands justice and excellence.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '135',
        label: 'Stand firmly for justice, even against self-interest.',
      ),
      QuranConnection(
        surahName: 'Al-Anfal',
        surahNumber: 8,
        verseRange: '27',
        label: 'Do not betray trusts knowingly.',
      ),
      QuranConnection(
        surahName: 'Al-Ma\'idah',
        surahNumber: 5,
        verseRange: '8',
        label: 'Be persistently just for Allah.',
      ),
      QuranConnection(
        surahName: 'Al-Ahzab',
        surahNumber: 33,
        verseRange: '72',
        label: 'The trust (amanah) is a weighty responsibility.',
      ),
    ],
  ),
  HadithTheme(
    id: _repentanceThemeId,
    title: 'Repentance & Forgiveness',
    subtitle: 'Return to Allah with humility, hope, and renewal.',
    description:
        'This theme explores how believers seek forgiveness and rebuild their relationship with Allah through sincere repentance.',
    icon: Icons.restart_alt_rounded,
    hadithIds: [
      'repentance_joy',
      'every_son_of_adam_sins',
      'allah_accepts_repentance_night_day',
      'repentance_until_sun_from_west',
      'prophet_sought_forgiveness_daily',
      'forgives_if_servant_acknowledges_sin',
      'repentance_until_soul_throat',
      'seeking_forgiveness_brings_relief',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '53',
        label: 'Do not despair of mercy.',
      ),
      QuranConnection(
        surahName: 'At-Tahrim',
        surahNumber: 66,
        verseRange: '8',
        label: 'Turn to Allah with sincere repentance.',
      ),
      QuranConnection(
        surahName: 'Al-Furqan',
        surahNumber: 25,
        verseRange: '70',
        label: 'Allah replaces sins with good for those who repent.',
      ),
      QuranConnection(
        surahName: 'An-Nisa',
        surahNumber: 4,
        verseRange: '110',
        label: 'Seeking forgiveness opens divine mercy.',
      ),
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '222',
        label: 'Allah loves those who constantly repent.',
      ),
    ],
  ),
  HadithTheme(
    id: _patienceThemeId,
    title: 'Patience & Gratitude',
    subtitle: 'Remain steadfast in hardship and thankful in ease.',
    description:
        'This theme explores how believers navigate life’s challenges and blessings through patience and gratitude following the guidance of the Prophet ﷺ.',
    icon: Icons.terrain_rounded,
    hadithIds: [
      'patience_gratitude_balance',
      'patience_first_strike',
      'whoever_remains_patient',
      'strong_believer_patience',
      'look_at_those_below',
      'prophet_gratitude_prayer_night',
      'hardship_expiates_sins',
      'patience_greatest_gift',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Al-Baqarah',
        surahNumber: 2,
        verseRange: '153',
        label: 'Seek help through patience and prayer.',
      ),
      QuranConnection(
        surahName: 'Ibrahim',
        surahNumber: 14,
        verseRange: '7',
        label: 'If you are grateful, I will surely increase you.',
      ),
      QuranConnection(
        surahName: 'Ash-Sharh',
        surahNumber: 94,
        verseRange: '5-6',
        label: 'With hardship comes ease.',
      ),
      QuranConnection(
        surahName: 'Az-Zumar',
        surahNumber: 39,
        verseRange: '10',
        label: 'The patient are rewarded without measure.',
      ),
      QuranConnection(
        surahName: 'Luqman',
        surahNumber: 31,
        verseRange: '12',
        label: 'Be grateful to Allah.',
      ),
    ],
  ),
  HadithTheme(
    id: _deathHereafterThemeId,
    title: 'Death & the Hereafter',
    subtitle: 'Reflect on life’s purpose and prepare for what lies beyond.',
    description:
        'This theme explores the teachings of the Prophet ﷺ about mortality, accountability, and the journey to the hereafter.',
    icon: Icons.hourglass_bottom_rounded,
    hadithIds: [
      'remember_destroyer_of_pleasures',
      'be_in_world_as_traveler',
      'intelligent_prepares_after_death',
      'accountability_day_of_judgment',
      'visit_graves_reflection',
      'dunya_prison_believer',
      'whoever_loves_meet_allah',
      'grave_first_stage_hereafter',
    ],
    quranAnchors: [
      QuranConnection(
        surahName: 'Ali \'Imran',
        surahNumber: 3,
        verseRange: '185',
        label: 'Every soul shall taste death.',
      ),
      QuranConnection(
        surahName: 'Al-Hadid',
        surahNumber: 57,
        verseRange: '20',
        label: 'Worldly life is temporary and fleeting.',
      ),
      QuranConnection(
        surahName: 'Az-Zalzalah',
        surahNumber: 99,
        verseRange: '7-8',
        label: 'Every deed, even tiny, will be seen.',
      ),
      QuranConnection(
        surahName: 'Al-Qiyamah',
        surahNumber: 75,
        verseRange: '36',
        label: 'Humankind is not left without purpose.',
      ),
      QuranConnection(
        surahName: 'Al-Mu\'minun',
        surahNumber: 23,
        verseRange: '115',
        label: 'You were not created without meaning and return.',
      ),
    ],
  ),
];

const List<HadithCollection> seededHadithCollections = [
  HadithCollection(
    id: essentialCollectionId,
    title: '40 Essential Hadith',
    subtitle: 'A core starting path for foundational study.',
    description:
        'Begin with concise, foundational teachings that shape belief, worship, and character.',
    hadithIds: [
      'intentions_core',
      'islam_built_on_five_prayer',
      'kind_speech',
      'repentance_joy',
      'trust_honesty',
    ],
  ),
  HadithCollection(
    id: 'beginner_set',
    title: 'Beginner Set',
    subtitle: 'Gentle entry point for new learners.',
    description:
        'Simple, high-impact hadith for first steps in learning and practice.',
    hadithIds: [
      'intentions_core',
      'seek_knowledge',
      'family_best_to_family',
      'islam_built_on_five_prayer',
      'patience_gratitude_balance',
    ],
  ),
  HadithCollection(
    id: 'hadith_heart',
    title: 'Hadith on the Heart',
    subtitle: 'Texts that soften the heart and increase sincerity.',
    description:
        'A reflective reading set around repentance, mercy, and inner accountability.',
    hadithIds: [
      'repentance_joy',
      'mercy_creation',
      'patience_gratitude_balance',
    ],
  ),
  HadithCollection(
    id: 'daily_sunnah',
    title: 'Daily Life Sunnah',
    subtitle: 'Practical guidance for everyday conduct.',
    description: 'Applied Sunnah in speech, family, worship, and trust.',
    hadithIds: ['kind_speech', 'family_best_to_family', 'wudu_then_prayer'],
  ),
  HadithCollection(
    id: 'hadith_qudsi',
    title: 'Hadith Qudsi',
    subtitle: 'Selected sacred narrations for reflection.',
    description: 'A starter shell for sacred narrations and devotional study.',
    hadithIds: ['repentance_joy', 'dua_worship'],
  ),
  HadithCollection(
    id: 'character_builder',
    title: 'Character Builder',
    subtitle: 'A curated set for adab, truthfulness, and trust.',
    description:
        'Focused character training through concise prophetic teachings.',
    hadithIds: ['kind_speech', 'trust_honesty', 'family_best_to_family'],
  ),
  HadithCollection(
    id: 'prayer_devotion',
    title: 'Prayer & Devotion',
    subtitle: 'Salah, du’a, remembrance, and sincerity.',
    description:
        'A worship-focused collection for consistency and heart presence.',
    hadithIds: [
      'islam_built_on_five_prayer',
      'pray_as_you_have_seen_me',
      'closest_in_sujud',
      'congregation_superior',
      'dua_worship',
      'intentions_core',
    ],
  ),
];
