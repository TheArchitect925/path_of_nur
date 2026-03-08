class HomeVerse {
  const HomeVerse({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.surah,
    this.verse,
    this.locationLabel,
  });

  final String arabic;
  final String transliteration;
  final String translation;
  final int? surah;
  final int? verse;
  final String? locationLabel;

  String get locationText {
    if (locationLabel != null && locationLabel!.isNotEmpty) {
      return locationLabel!;
    }
    if (surah != null && verse != null) {
      return 'Qur’an $surah:$verse';
    }
    return 'Qur’an home collection';
  }
}

const List<HomeVerse> homeQuranVerses = [
  HomeVerse(
    arabic: 'وَٱلْفَجْرِ',
    transliteration: 'Waal-fajr',
    translation: 'By the dawn.',
  ),
  HomeVerse(
    arabic: 'إِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
    transliteration: 'Inna ma al-‘usri yusra',
    translation: 'With hardship, ease comes.',
  ),
  HomeVerse(
    arabic: 'وَٱلَّذِينَ جَٰهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا',
    transliteration: 'Walladhiyna jahadu fīnā lanahdiyannahum subulanā',
    translation: 'Those who strive in Our way, We guide to Our paths.',
  ),
  HomeVerse(
    arabic: 'فَاذْكُرُونِيٓ أَذْكُرْكُمْ',
    transliteration: 'Fadhkurooni adhkurkum',
    translation: 'Remember Me and I will remember you.',
  ),
  HomeVerse(
    arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَٱلصَّلَوٰةِ',
    transliteration: 'Wastaeenoo bissabr was-salaah',
    translation: 'Seek help through patience and prayer.',
  ),
  HomeVerse(
    arabic: 'إِنَّ ٱللَّهَ غَفُورٌ رَّحِيمٌ',
    transliteration: 'Inna Allāha ghafūrun raheem',
    translation: 'Allah is Forgiving and Merciful.',
  ),
  HomeVerse(
    arabic: 'وَمَا تُقَدِّمُوا لِأَنفُسِكُمْ مِنْ خَيْرٍ',
    transliteration: 'Wama tuqaddimoo li-anfusikum min khairin',
    translation: 'Whatever good you send ahead for yourselves, you will find it with Allah.',
  ),
  HomeVerse(
    arabic: 'قُلْ هُوَ ٱللَّهُ أَحَدٌ',
    transliteration: 'Qul huwa Allahu ahad',
    translation: 'Say: He is Allah, One.',
  ),
  HomeVerse(
    arabic: 'وَنَزَّلْنَا عَلَيْكَ ٱلْقُرْءَانَ تَعْلِيماً',
    transliteration: 'Wanzalna ‘alayka al-Qur’āna ta‘liyan',
    translation: 'We have sent down to you the Qur’an for instruction.',
  ),
  HomeVerse(
    arabic: 'وَصَلِّ عَلَيْهِمْ',
    transliteration: 'Wa-salli ‘alayhī',
    translation: 'Send blessings upon him.',
  ),
  HomeVerse(
    arabic: 'وَٱلصُّبْحِ إِذَا ٱسْتَغْفَرَ',
    transliteration: 'Was-subhi idhā istaghfara',
    translation: 'By the morning, when one seeks forgiveness.',
  ),
  HomeVerse(
    arabic: 'لَا تَحْزَنْ إِنَّ ٱللَّهَ مَعَنَا',
    transliteration: 'La tahzani inna Allāha ma‘anā',
    translation: 'Do not grieve; surely Allah is with us.',
  ),
  HomeVerse(
    arabic: 'قُلْ لِعِبَادِيْ الَّذِينَ ءَامَنُوا',
    transliteration: 'Qul li‘ibādiya allaḏīna āmanū',
    translation: 'Say to My believing servants.',
  ),
  HomeVerse(
    arabic: 'وَمَا بِٱللَّهِ مِنْ دَابَّةٍ',
    transliteration: 'Wama billahi min dābbah',
    translation: 'There is not a creature on earth but Allah holds it in care.',
  ),
  HomeVerse(
    arabic: 'إِيَّاكَ نَعْبُدُ',
    transliteration: 'Iyyāka na‘budu',
    translation: 'You alone we worship.',
  ),
  HomeVerse(
    arabic: 'إِيَّاكَ نَسْتَعِينُ',
    transliteration: 'Wa iyyāka nasta‘īn',
    translation: 'You alone we ask for help.',
  ),
  HomeVerse(
    arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
    transliteration: 'Bismillāh ar-Raḥmān ar-Raḥīm',
    translation: 'In the name of Allah, the Most Gracious, the Most Merciful.',
  ),
  HomeVerse(
    arabic: 'وَالْعَصْرِ',
    transliteration: 'Wal ‘aṣr',
    translation: 'By the declining day.',
  ),
  HomeVerse(
    arabic: 'إِنَّمَا ٱلْمُؤْمِنُونَ إِخْوَةٌ',
    transliteration: 'Innamal-mu’minūna ikhwah',
    translation: 'The believers are but brothers.',
  ),
  HomeVerse(
    arabic: 'وَتَوَكَّلْ عَلَى ٱللَّهِ',
    transliteration: 'Wa tawakkal ‘ala Allah',
    translation: 'And place your trust in Allah.',
  ),
  HomeVerse(
    arabic: 'فَإِنَّ مَعِيَ ٱلْعِبَادُ',
    transliteration: 'Fa inna ma‘iya al-‘ibād',
    translation: 'Indeed with Me are My servants.',
  ),
  HomeVerse(
    arabic: 'لَيْسَ عَلَيْكُمْ جُنَاحٌ',
    transliteration: 'Laysa ‘alaykum junāh',
    translation: 'There is no blame upon you.',
  ),
  HomeVerse(
    arabic: 'وَقُلْ رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Wa qul rabbi zidni ‘ilman',
    translation: 'Say: My Lord, increase me in knowledge.',
  ),
  HomeVerse(
    arabic: 'فَذَكِّرْ فَإِنَّ ٱلذِّكْرَىٰ',
    transliteration: 'Fadhakkir fa inna adh-dhikrā',
    translation: 'So remind, for the reminder benefits believers.',
  ),
  HomeVerse(
    arabic: 'إِنَّ ٱلَّذِينَ ءَامَنُوا وَعَمِلُوا ٱلصَّالِحَٰتِ',
    transliteration: 'Innal-ladhīna āmanū wa ‘amilū aṣ-ṣāliḥāt',
    translation: 'Those who believe and do righteous deeds.',
  ),
  HomeVerse(
    arabic: 'لِكُلِّ نَفْسٍ ذَآئِقَةُ ٱلْمَوْتِ',
    transliteration: 'Likulli nafsin dhā’iqatu al-mawt',
    translation: 'Every soul will taste death.',
  ),
  HomeVerse(
    arabic: 'وَلَا تَقْنَطُوا مِن رَّحْمَةِ ٱللَّهِ',
    transliteration: 'Wa lā taqnathū min raḥmati Allāh',
    translation: 'Do not despair of Allah’s mercy.',
  ),
  HomeVerse(
    arabic: 'وَأَعِدُّوا لَهُمْ مَا ٱسْتَطَعْتُمْ',
    transliteration: 'Wa a‘iddu lahum mā istata‘tum',
    translation: 'Prepare against them whatever you are able.',
  ),
  HomeVerse(
    arabic: 'وَاللَّهُ بِكُلِّ شَيْءٍ عَلِيمٌ',
    transliteration: 'Wallahu bikulli shay’in ‘alīm',
    translation: 'Allah is all-knowing of everything.',
  ),
  HomeVerse(
    arabic: 'إِلَّا مَنْ تَوَلّاهُ ٱلرَّحْمَٰنُ',
    transliteration: 'Illā man tawallāhu ar-Raḥmān',
    translation: 'Except those whom the Most Merciful has taken care of.',
  ),
  HomeVerse(
    arabic: 'وَٱللَّهُ نُورُ ٱلسَّمَٰوَاتِ وَٱلْأَرْضِ',
    transliteration: 'Wallāhu nūru as-samāwāti wal-arḍ',
    translation: 'Allah is the Light of the heavens and the earth.',
  ),
  HomeVerse(
    arabic: 'رَبِّ ٱشْرَحْ لِي صَدْرِي',
    transliteration: 'Rabbi-shraḥ lī ṣadrī',
    translation: 'My Lord, expand my chest.',
  ),
  HomeVerse(
    arabic: 'فَذَلِكَ عَظِيمٌ',
    transliteration: 'Fadhālika ‘aẓīm',
    translation: 'And that is most mighty.',
  ),
  HomeVerse(
    arabic: 'إِنَّا لِلَّهِ وَإِنَّآ إِلَيْهِ رَاجِعُونَ',
    transliteration: 'Innā lillāhi wa innā ilayhi rāji‘ūn',
    translation: 'We belong to Allah and to Him we return.',
  ),
  HomeVerse(
    arabic: 'وَيَغْفِرْ لَكُمْ',
    transliteration: 'Wa yaghfir lakum',
    translation: 'And He may forgive you.',
  ),
  HomeVerse(
    arabic: 'ٱقْتَرَبَتِ ٱلسَّاعَةُ',
    transliteration: 'Iqtarábati as-sā‘ah',
    translation: 'The Hour has drawn near.',
  ),
  HomeVerse(
    arabic: 'وَٱسْتَفْتِحُوۤا قُلُوبَكُمْ',
    transliteration: 'Wa-ftahu qulubakum',
    translation: 'Open your hearts in humility.',
  ),
  HomeVerse(
    arabic: 'قُلْ لِعِبَادِي لِيَصْلَحْ لَهُمْ',
    transliteration: 'Qul li‘ibādī liyaṣlaḥ līhim',
    translation: 'Say to My servants: Let your own good be complete.',
  ),
  HomeVerse(
    arabic: 'وَذَرُوا ٱلْبَأْسَ',
    transliteration: 'Wa dharu al-ba’sa',
    translation: 'Abandon despair, fear is not from faith.',
  ),
  HomeVerse(
    arabic: 'وَٱلْقُلُوبُ يَوْمًا',
    transliteration: 'Wal-qulūbu yawman',
    translation: 'And the hearts on that day...',
  ),
  HomeVerse(
    arabic: 'إِنْ تُعْطُوا مِنْ خَيْرٍ فَقَالَ',
    transliteration: 'In tu‘ṭū min khairin fa-qāla',
    translation: 'If you are given good, say: this is from Allah.',
  ),
  HomeVerse(
    arabic: 'وَمَا عِندَ ٱللَّهِ خَيْرٌ وَأَبْقَىٰ',
    transliteration: 'Wa mā ‘inda Allāhi khayrun wa abqā',
    translation: 'What is with Allah is better and everlasting.',
  ),
  HomeVerse(
    arabic: 'رَبِّ ٱغْفِرْ لِي وَارْحَمْنِي',
    transliteration: 'Rabbi-ghfir lī warḥamnī',
    translation: 'My Lord, forgive me and have mercy on me.',
  ),
  HomeVerse(
    arabic: 'لَا تَقْرَبُوا ٱلزِّنَآةَ',
    transliteration: 'Lā taqrabū az-zinā',
    translation: 'Do not approach indecency.',
  ),
  HomeVerse(
    arabic: 'إِذَا حَضَرَ ٱلْقِسْطَ',
    transliteration: 'Idhā ḥaḍara al-qisṭ',
    translation: 'When justice is established.',
  ),
  HomeVerse(
    arabic: 'قُلْ لَا أَبْرَأُ نَفْسِي',
    transliteration: 'Qul la a-brā’u nafsī',
    translation: 'Say: I do not claim to be pure from myself.',
  ),
  HomeVerse(
    arabic: 'فَإِنَّ مَعِيَ ٱلْعُسْرِ',
    transliteration: 'Fa-inna ma‘ī al-‘usr',
    translation: 'Indeed, with me is hardship.',
  ),
  HomeVerse(
    arabic: 'وَقُلْ حِطَّةً',
    transliteration: 'Wa qul ḥiṭṭatan',
    translation: 'Say: A pure path has come.',
  ),
  HomeVerse(
    arabic: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَالَمِينَ',
    transliteration: 'Al-ḥamdu lillāhi rabbil-‘ālamīn',
    translation: 'Praise belongs to Allah, Lord of all worlds.',
  ),
  HomeVerse(
    arabic: 'لَا إِكْرَاهَ فِي ٱلدِّينِ',
    transliteration: 'Lā ikrāha fid-dīn',
    translation: 'There is no compulsion in religion.',
  ),
  HomeVerse(
    arabic: 'وَرَبُّكَ يَعْلَمُ',
    transliteration: 'Wa rabbuka ya‘lam',
    translation: 'Your Lord knows best.',
  ),
  HomeVerse(
    arabic: 'إِنَّ ٱلْأَوَّلِينَ وَٱلْأَخِرِينَ',
    transliteration: 'Inna al-awwalīna wal-ākhirīn',
    translation: 'Indeed the first and the last.',
  ),
  HomeVerse(
    arabic: 'قُلْ هُوَ ٱلْحَيُّ ٱلْقَيُّومُ',
    transliteration: 'Qul huwa al-ḥayyul-qayyūm',
    translation: 'Say: He is the Ever-Living, the Sustainer.',
  ),
  HomeVerse(
    arabic: 'مَا لَكُمْ لَا تَتَفَكَّرُونَ',
    transliteration: 'Mā lakum lā tatafakkarūn',
    translation: 'What is wrong with you that you do not think?',
  ),
  HomeVerse(
    arabic: 'وَٱلَّذِينَ صَبَرُوا فَإِنَّ ٱللَّهَ',
    transliteration: 'Walladhīna ṣabarū fa-inna Allāh',
    translation: 'And those who are patient, Allah is with them.',
  ),
  HomeVerse(
    arabic: 'وَٱسْتَغْفِرُوا رَبَّكُمْ',
    transliteration: 'Wastaghfirū rabbakum',
    translation: 'Seek forgiveness from your Lord.',
  ),
  HomeVerse(
    arabic: 'كُلُّ نَفْسٍ ذَائِقَةُ ٱلْمَوْتِ',
    transliteration: 'Kullu nafsin dhā’iqatun al-mawt',
    translation: 'Every soul shall taste death.',
  ),
  HomeVerse(
    arabic: 'وَٱلْعَصْرِ إِنَّ ٱلْإِنسَانَ لَفِي خُسْرٍ',
    transliteration: 'Wal-‘asri inna al-insāna lafī khusr',
    translation: 'By time, surely mankind is in loss.',
  ),
  HomeVerse(
    arabic: 'رَبَّنَا ٱغْفِرْ لَنَا ذُنُوبَنَا',
    transliteration: 'Rabbana-ghfir lanā dhunūbanā',
    translation: 'Our Lord, forgive our sins.',
  ),
  HomeVerse(
    arabic: 'وَٱلَّذِينَ ءَامَنُوا أَشَدُّ حُبًّا',
    transliteration: 'Walladhīna āmanū ashaddu ḥubban',
    translation: 'Those who believe are the strongest in love.',
  ),
  HomeVerse(
    arabic: 'وَٱسْتَغْفِرِ ٱللَّهَ',
    transliteration: 'Wastaghfir Allāh',
    translation: 'Seek Allah’s forgiveness.',
  ),
];
