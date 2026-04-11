import '../domain/dua_models.dart';

final duaSeedDataset = DuaDataset(
  version: '0.5',
  app: 'Path of Nur',
  datasetName: 'Dua Master Dataset Scaffold',
  notes: <String>[
    'This file is designed for app integration and progressive completion.',
    'Core entries are populated and marked core_verified.',
    'Qur\'anic dua entries now include an expanded source-backed completion batch.',
    'Daily-life adhkar now include a source-backed completion batch.',
    'Prayer-and-worship duas now include a source-backed completion batch.',
    'Situational and travel duas now include a source-backed completion batch.',
    'Home, family, and special-days duas now include a source-backed completion batch.',
    'Forgiveness-and-growth duas now include a source-backed completion batch.',
    'Primary and secondary dua taxonomy now supports cleaner multi-context discovery without duplicating canonical entries.',
    'Contextual orchestration metadata now prepares duas for future smart surfacing without changing current UI behavior.',
    'Release trust tiers now distinguish strong, general, review, and excluded dua content for safer default surfacing.',
    'Run a final scholarly QA pass before public release.',
  ],
  totalItems: 182,
  completeItems: 182,
  stubItems: 0,
  categoryLabels: <String, String>{
    'daily_life': 'Daily Life',
    'prayer_and_worship': 'Salah & Ibadah',
    'home_and_family': 'Home & Family',
    'travel_and_movement': 'Travel & Movement',
    'situational': 'Life Situations',
    'special_days': 'Special Days',
    'forgiveness_and_growth': 'Forgiveness & Growth',
  },
  primaryCategoryLabels: _duaPrimaryCategoryLabels,
  items: _applyDuaReleaseTrust(
    _applyDuaOrchestrationMetadata(
      _applyDuaTaxonomy(const <DuaItem>[
        DuaItem(
          id: 'quran_002_201_good_world_hereafter',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Good in This World and the Hereafter',
          arabic:
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          transliteration:
              'Rabbana atina fid-dunya hasanah wa fil-akhirati hasanah wa qina \'adhaban-nar',
          translation:
              'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
          whenToSay: 'General supplication at any time.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:201',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'core', 'general', 'protection'],
          audioKey: 'quran_002_201_good_world_hereafter.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_002_250_pour_patience',
          category: 'situational',
          subcategory: 'hardship',
          title: 'Pour Upon Us Patience',
          arabic:
              'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
          transliteration:
              'Rabbana afrigh \'alayna sabran wa thabbit aqdamana wansurna \'alal-qawmil-kafirin',
          translation:
              'Our Lord, pour upon us patience, make our steps firm, and help us against the disbelieving people.',
          whenToSay: 'During hardship, pressure, fear, or struggle.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:250',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'patience', 'hardship'],
          audioKey: 'quran_002_250_pour_patience.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_002_286_forgive_us_mercy',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive Us and Have Mercy on Us',
          arabic:
              'رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
          transliteration:
              'Rabbana la tu\'akhidhna in nasina aw akhta\'na. Rabbana wa la tahmil \'alayna isran kama hamaltahu \'alalladhina min qablina. Rabbana wa la tuhammilna ma la taqata lana bih. Wa\'fu \'anna waghfir lana warhamna. Anta mawlana fansurna \'alal-qawmil-kafirin',
          translation:
              'Our Lord, do not take us to task if we forget or make mistakes... pardon us, forgive us, and have mercy on us. You are our Protector, so help us against the disbelieving people.',
          whenToSay:
              'General supplication, especially for forgiveness and relief.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:286',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'forgiveness', 'mercy', 'general'],
          audioKey: 'quran_002_286_forgive_us_mercy.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_003_008_no_deviation',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Do Not Let Our Hearts Deviate',
          arabic:
              'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً ۚ إِنَّكَ أَنْتَ الْوَهَّابُ',
          transliteration:
              'Rabbana la tuzigh qulubana ba\'da idh hadaytana wa hab lana min ladunka rahmah innaka antal-Wahhab',
          translation:
              'Our Lord, do not let our hearts deviate after You have guided us, and grant us mercy from Yourself. Surely You are the Bestower.',
          whenToSay: 'When asking for steadfastness and guidance.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:8',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'guidance', 'steadfastness'],
          audioKey: 'quran_003_008_no_deviation.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_003_016_forgive_our_sins',
          category: 'forgiveness_and_growth',
          subcategory: 'repentance',
          title: 'Forgive Our Sins',
          arabic:
              'رَبَّنَا إِنَّنَا آمَنَّا فَاغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ النَّارِ',
          transliteration:
              'Rabbana innana amanna faghfir lana dhunubana wa qina \'adhaban-nar',
          translation:
              'Our Lord, indeed we have believed, so forgive us our sins and protect us from the punishment of the Fire.',
          whenToSay: 'General repentance and renewal of faith.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:16',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'forgiveness', 'faith'],
          audioKey: 'quran_003_016_forgive_our_sins.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_003_038_pious_offspring',
          category: 'home_and_family',
          subcategory: 'children',
          title: 'Grant Me Good Offspring',
          arabic:
              'رَبِّ هَبْ لِي مِنْ لَدُنْكَ ذُرِّيَّةً طَيِّبَةً ۖ إِنَّكَ سَمِيعُ الدُّعَاءِ',
          transliteration:
              'Rabbi hab li min ladunka dhurriyyatan tayyibah innaka sami\'ud-du\'a\'',
          translation:
              'My Lord, grant me from Yourself good offspring. Surely You hear supplication.',
          whenToSay: 'When asking for righteous children.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:38',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'children', 'family'],
          audioKey: 'quran_003_038_pious_offspring.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_007_023_we_wronged_ourselves',
          category: 'forgiveness_and_growth',
          subcategory: 'repentance',
          title: 'We Have Wronged Ourselves',
          arabic:
              'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
          transliteration:
              'Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakunanna minal-khasirin',
          translation:
              'Our Lord, we have wronged ourselves, and if You do not forgive us and have mercy on us, we will surely be among the losers.',
          whenToSay: 'In repentance after sin and heedlessness.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 7:23',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'repentance', 'forgiveness'],
          audioKey: 'quran_007_023_we_wronged_ourselves.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_014_040_establish_prayer',
          category: 'prayer_and_worship',
          subcategory: 'salah',
          title: 'Make Me One Who Establishes Salah',
          arabic:
              'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي ۚ رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
          transliteration:
              'Rabbi-j\'alni muqimas-salati wa min dhurriyyati rabbana wa taqabbal du\'a\'',
          translation:
              'My Lord, make me one who establishes prayer, and from my descendants as well. Our Lord, accept my supplication.',
          whenToSay: 'For consistency in salah and righteous children.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 14:40',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'salah', 'family'],
          audioKey: 'quran_014_040_establish_prayer.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_014_041_forgive_me_parents_believers',
          category: 'home_and_family',
          subcategory: 'parents',
          title: 'Forgive Me, My Parents, and the Believers',
          arabic:
              'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
          transliteration:
              'Rabbanaghfir li wa liwalidayya wa lilmu\'minina yawma yaqumul-hisab',
          translation:
              'Our Lord, forgive me, my parents, and the believers on the Day the reckoning is established.',
          whenToSay: 'For oneself, parents, and the believers.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 14:41',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'parents', 'forgiveness', 'ummah'],
          audioKey: 'quran_014_041_forgive_me_parents_believers.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_017_024_mercy_for_parents',
          category: 'home_and_family',
          subcategory: 'parents',
          title: 'Mercy for My Parents',
          arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
          transliteration: 'Rabbi irhamhuma kama rabbayani saghira',
          translation:
              'My Lord, have mercy on them as they raised me when I was small.',
          whenToSay: 'For one\'s parents.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 17:24',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'parents', 'family'],
          audioKey: 'quran_017_024_mercy_for_parents.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_018_010_set_our_affair_rightly',
          category: 'forgiveness_and_growth',
          subcategory: 'guidance',
          title: 'Set Our Affair Rightly',
          arabic:
              'رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
          transliteration:
              'Rabbana atina min ladunka rahmah wa hayyi\' lana min amrina rashada',
          translation:
              'Our Lord, grant us mercy from Yourself and prepare for us right guidance in our affair.',
          whenToSay: 'When seeking clarity or direction.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 18:10',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'guidance', 'mercy'],
          audioKey: 'quran_018_010_set_our_affair_rightly.mp3',
          isCore: false,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_020_114_increase_knowledge',
          category: 'forgiveness_and_growth',
          subcategory: 'knowledge',
          title: 'Increase Me in Knowledge',
          arabic: 'رَبِّ زِدْنِي عِلْمًا',
          transliteration: 'Rabbi zidni \'ilma',
          translation: 'My Lord, increase me in knowledge.',
          whenToSay: 'Before study, learning, or reading Qur\'an.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 20:114',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'knowledge', 'learning'],
          audioKey: 'quran_020_114_increase_knowledge.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_021_083_harm_has_touched_me',
          category: 'situational',
          subcategory: 'illness',
          title: 'Harm Has Touched Me',
          arabic:
              'رَبِّ إِنِّي مَسَّنِيَ الضُّرُّ وَأَنْتَ أَرْحَمُ الرَّاحِمِينَ',
          transliteration:
              'Rabbi inni massaniyad-durru wa anta arhamur-rahimin',
          translation:
              'My Lord, harm has touched me, and You are the Most Merciful of those who show mercy.',
          whenToSay: 'During illness, pain, distress, or exhaustion.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 21:83',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'illness', 'mercy'],
          audioKey: 'quran_021_083_harm_has_touched_me.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_023_118_forgive_and_have_mercy',
          category: 'forgiveness_and_growth',
          subcategory: 'repentance',
          title: 'Forgive and Have Mercy',
          arabic: 'رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ',
          transliteration: 'Rabbighfir warham wa anta khayrur-rahimin',
          translation:
              'My Lord, forgive and have mercy, and You are the best of the merciful.',
          whenToSay: 'Short repentance and mercy supplication.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 23:118',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'forgiveness', 'mercy'],
          audioKey: 'quran_023_118_forgive_and_have_mercy.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_025_074_spouses_children_comfort',
          category: 'home_and_family',
          subcategory: 'family',
          title: 'Grant Us Spouses and Children as Comfort',
          arabic:
              'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
          transliteration:
              'Rabbana hab lana min azwajina wa dhurriyyatina qurrata a\'yunin waj\'alna lilmuttaqina imama',
          translation:
              'Our Lord, grant us from our spouses and offspring comfort to our eyes and make us leaders for the righteous.',
          whenToSay: 'For a righteous family and good home life.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 25:74',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'family', 'spouse', 'children'],
          audioKey: 'quran_025_074_spouses_children_comfort.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_028_024_need_of_good',
          category: 'situational',
          subcategory: 'need',
          title: 'I Am in Need of Whatever Good You Send',
          arabic: 'رَبِّ إِنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
          transliteration: 'Rabbi inni lima anzalta ilayya min khayrin faqir',
          translation:
              'My Lord, truly I am in need of whatever good You send down to me.',
          whenToSay: 'When in need of help, work, provision, or relief.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 28:24',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'need', 'rizq', 'help'],
          audioKey: 'quran_028_024_need_of_good.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'quran_066_008_perfect_our_light',
          category: 'forgiveness_and_growth',
          subcategory: 'akhirah',
          title: 'Perfect for Us Our Light',
          arabic:
              'رَبَّنَا أَتْمِمْ لَنَا نُورَنَا وَاغْفِرْ لَنَا ۖ إِنَّكَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              'Rabbana atmim lana nurana waghfir lana innaka \'ala kulli shay\'in qadir',
          translation:
              'Our Lord, perfect for us our light and forgive us. Surely You are over all things capable.',
          whenToSay: 'For forgiveness, light, and a good ending.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 66:8',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'light', 'forgiveness', 'akhirah'],
          audioKey: 'quran_066_008_perfect_our_light.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_before_eating_bismillah',
          category: 'daily_life',
          subcategory: 'food',
          title: 'Before Eating',
          arabic: 'بِسْمِ اللَّهِ',
          transliteration: 'Bismillah',
          translation: 'In the name of Allah.',
          whenToSay: 'Before starting food or drink.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 3767',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'food', 'beginner'],
          audioKey: 'sunnah_before_eating_bismillah.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_if_forgot_bismillah',
          category: 'daily_life',
          subcategory: 'food',
          title: 'If You Forgot at the Start of Eating',
          arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
          transliteration: 'Bismillahi awwalahu wa akhirahu',
          translation: 'In the name of Allah, at its beginning and at its end.',
          whenToSay:
              'If you forgot to say Bismillah before eating and remember during the meal.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 3767',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'food'],
          audioKey: 'sunnah_if_forgot_bismillah.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_waking',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Upon Waking',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          transliteration:
              'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur',
          translation:
              'All praise is for Allah who gave us life after causing us to die, and to Him is the resurrection.',
          whenToSay: 'Immediately after waking up.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6312',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'sleep', 'morning'],
          audioKey: 'sunnah_upon_waking.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_before_sleep',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Before Sleeping',
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amutu wa ahya',
          translation: 'In Your name, O Allah, I die and I live.',
          whenToSay: 'Before sleeping.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6324',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'sleep', 'night'],
          audioKey: 'sunnah_before_sleep.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_leaving_home',
          category: 'travel_and_movement',
          subcategory: 'leaving_home',
          title: 'Leaving the House',
          arabic:
              'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          transliteration:
              'Bismillah tawakkaltu \'alallah wa la hawla wa la quwwata illa billah',
          translation:
              'In the name of Allah, I place my trust in Allah. There is no power and no strength except with Allah.',
          whenToSay: 'When stepping out of the house.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3426',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'home', 'daily'],
          audioKey: 'sunnah_leaving_home.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_entering_home',
          category: 'home_and_family',
          subcategory: 'home',
          title: 'Entering the Home',
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمَخْرَجِ، بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
          transliteration:
              'Allahumma inni as\'aluka khayral-mawliji wa khayral-makhraji bismillahi walajna wa bismillahi kharajna wa \'alallahi rabbina tawakkalna',
          translation:
              'O Allah, I ask You for the best entrance and the best exit. In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we rely.',
          whenToSay: 'When entering the home.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5096',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['home', 'family', 'daily'],
          audioKey: 'sunnah_entering_home.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_entering_mosque',
          category: 'prayer_and_worship',
          subcategory: 'masjid',
          title: 'Entering the Masjid',
          arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          transliteration: 'Allahummaftah li abwaba rahmatik',
          translation: 'O Allah, open for me the doors of Your mercy.',
          whenToSay: 'When entering the masjid.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 713a',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['masjid', 'prayer', 'daily'],
          audioKey: 'sunnah_entering_mosque.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_leaving_mosque',
          category: 'prayer_and_worship',
          subcategory: 'masjid',
          title: 'Leaving the Masjid',
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
          transliteration: 'Allahumma inni as\'aluka min fadlik',
          translation: 'O Allah, I ask You from Your bounty.',
          whenToSay: 'When leaving the masjid.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 713a',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['masjid', 'prayer', 'daily'],
          audioKey: 'sunnah_leaving_mosque.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_after_adhan',
          category: 'prayer_and_worship',
          subcategory: 'adhan',
          title: 'After the Adhan',
          arabic:
              'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ',
          transliteration:
              'Allahumma rabba hadhihid-da\'watit-tammah was-salatil-qa\'imah ati Muhammadanil-wasilata wal-fadilah wab\'athhu maqaman mahmudan alladhi wa\'adtah',
          translation:
              'O Allah, Lord of this perfect call and established prayer, grant Muhammad the station of الوسيلة and virtue, and raise him to the praised station You promised him.',
          whenToSay: 'After repeating the adhan.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 614',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['adhan', 'prayer', 'sunnah'],
          audioKey: 'sunnah_after_adhan.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_laylatul_qadr',
          category: 'special_days',
          subcategory: 'ramadan',
          title: 'Dua for Laylat al-Qadr',
          arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
          transliteration:
              'Allahumma innaka \'afuwwun tuhibbul-\'afwa fa\'fu \'anni',
          translation:
              'O Allah, You are Pardoning and You love pardon, so pardon me.',
          whenToSay:
              'Especially in the last ten nights of Ramadan and on Laylat al-Qadr.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Ibn Majah 3850 / Riyad as-Salihin 1195',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['ramadan', 'laylatul_qadr', 'forgiveness'],
          audioKey: 'sunnah_laylatul_qadr.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_perfect_words_protection',
          category: 'situational',
          subcategory: 'protection',
          title: 'Protection with the Perfect Words of Allah',
          arabic:
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          transliteration:
              'A\'udhu bikalimatillahit-tammati min sharri ma khalaq',
          translation:
              'I seek refuge in the perfect words of Allah from the evil of what He created.',
          whenToSay: 'For protection in general and when entering a place.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2708',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['protection', 'fear', 'travel'],
          audioKey: 'sunnah_perfect_words_protection.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_001_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Upon Entering the Morning',
          arabic:
              'اَللّٰهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ وَإِلَيْكَ النُّشُوْرُ.',
          transliteration:
              'Allahumma bika asbahna wa bika amsayna wa bika nahya wa bika namutu wa ilaykan-nushur.',
          translation:
              'O Allah, by You we have entered the morning and by You we enter upon the evening. By You, we live and we die, and to You is the resurrection.',
          whenToSay: 'At the beginning of the morning.',
          sourceType: 'sunnah',
          sourceRef: 'Al-Adab al-Mufrad 1199',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['morning', 'daily', 'reliance'],
          audioKey: 'sunnah_upon_entering_morning.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_002_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Fulfil Your Obligation to Thank Allah',
          arabic:
              'اَللّٰهُمَّ مَا أَصْبَحَ بِيْ مِنْ نِّعْمَةٍ أَوْ بِأَحَدٍ مِّنْ خَلْقِكَ ، فَمِنْكَ وَحْدَكَ لَا شَرِيْكَ لَكَ ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          transliteration:
              'Allahumma ma asbaha bi min ni\'matin aw bi ahadim-min khalqika, fa minka wahdaka la sharika lak, fa lakal-hamdu wa lakash-shukr.',
          translation:
              'O Allah, all the favours that I or anyone from Your creation has received in the morning are from You alone. You have no partner. To You alone belong all praise and all thanks.',
          whenToSay: 'In the morning to thank Allah for the day\'s blessings.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5073',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['morning', 'gratitude', 'daily'],
          audioKey: 'sunnah_morning_gratitude.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_003_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Ask Allah to Bless Your Day',
          arabic:
              'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ ، اَللّٰهُمَّ إِنِّيْ أَسْأَلُكَ خَيْرَ هٰذَا الْيَوْمِ ، فَتْحَهُ وَنَصْرَهُ وَنُوْرَهُ وَبَرَكَتَهُ وَهُدَاهُ ، وَأَعُوْذُ بِكَ مِنْ شَرِّ مَا فِيْهِ وَشَرِّ مَا بَعْدَهُ.',
          transliteration:
              'Asbahna wa asbahal-mulku lillahi Rabbil-\'alamin. Allahumma inni as\'aluka khayra hadhal-yawm, fathahu wa nasrahu wa nurahu wa barakatahu wa hudah, wa a\'udhu bika min sharri ma fihi wa sharri ma ba\'dah.',
          translation:
              'We have entered the morning and at this very time the whole kingdom belongs to Allah, Lord of the Worlds. O Allah, I ask You for the goodness of this day: its victory, its help, its light, its blessings, and its guidance. I seek Your protection from the evil that is in it and from the evil that follows it.',
          whenToSay: 'At the start of the morning.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5084',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['morning', 'blessing', 'protection'],
          audioKey: 'sunnah_ask_allah_to_bless_your_day.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_004_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Ask Allah for Good Health and Protection',
          arabic:
              'اَللّٰهُمَّ عَافِنِيْ فِيْ بَدَنِيْ ، اَللّٰهُمَّ عَافِنِيْ فِيْ سَمْعِيْ ، اَللّٰهُمَّ عَافِنِيْ فِيْ بَصَرِيْ ، لَا إِلٰهَ إِلَّا أَنْتَ ، اَللّٰهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ ، وَأَعُوْذُ بِكَ مِنْ عَذَابِ الْقَبْرِ ، لَا إِلٰهَ إِلَّا أَنْتَ.',
          transliteration:
              'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'i, Allahumma \'afini fi basari, la ilaha illa Ant. Allahumma inni a\'udhu bika minal-kufri wal-faqr, wa a\'udhu bika min \'adhabil-qabr, la ilaha illa Ant.',
          translation:
              'O Allah, grant me well-being in my body. O Allah, grant me well-being in my hearing. O Allah, grant me well-being in my sight. There is no god worthy of worship except You. O Allah, I seek Your protection from disbelief and poverty, and I seek Your protection from the punishment of the grave. There is no god worthy of worship except You.',
          whenToSay: 'Three times in the morning.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5090',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['morning', 'health', 'protection'],
          audioKey: 'sunnah_good_health_and_protection.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_005_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Protect Yourself From All Harm',
          arabic:
              'بِسْمِ اللّٰهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ.',
          transliteration:
              'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\', wa Huwas-Sami\'ul-\'Alim.',
          translation:
              'In the Name of Allah, with whose Name nothing can harm in the earth nor in the sky. He is the All-Hearing and All-Knowing.',
          whenToSay: 'Three times in the morning.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3388',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['morning', 'protection', 'safety'],
          audioKey: 'sunnah_protect_yourself_from_all_harm.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_006_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Upon Entering the Evening',
          arabic:
              'اَللّٰهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ وَإِلَيْكَ الْمَصِيْرُ.',
          transliteration:
              'Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namutu wa ilaykal-masir.',
          translation:
              'O Allah, by You we have entered the evening and by You we enter upon the morning. By You, we live and we die, and to You is the return.',
          whenToSay: 'At the beginning of the evening.',
          sourceType: 'sunnah',
          sourceRef: 'Al-Adab al-Mufrad 1199',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evening', 'daily', 'reliance'],
          audioKey: 'sunnah_upon_entering_evening.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_007_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Fulfil Your Obligation to Thank Allah',
          arabic:
              'اَللّٰهُمَّ مَا أَمْسَىٰ بِيْ مِنْ نِّعْمَةٍ أَوْ بِأَحَدٍ مِّنْ خَلْقِكَ ، فَمِنْكَ وَحْدَكَ لَا شَرِيْكَ لَكَ ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
          transliteration:
              'Allahumma ma amsa bi min ni\'matin aw bi ahadin min khalqika, fa minka wahdaka la sharika lak, fa lakal-hamdu wa lakash-shukr.',
          translation:
              'O Allah, all the favours that I or anyone from Your creation has received in the evening are from You alone. You have no partner. To You alone belong all praise and all thanks.',
          whenToSay:
              'In the evening to thank Allah for the night\'s blessings.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5073',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evening', 'gratitude', 'daily'],
          audioKey: 'sunnah_evening_gratitude.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_008_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Ask Allah to Bless Your Evening',
          arabic:
              'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ ، اَللّٰهُمَّ إِنِّيْ أَسْأَلُكَ خَيْرَ هٰذِهِ اللَّيْلَةِ ، فَتْحَهَا وَنَصْرَهَا وَنُوْرَهَا وَبَرَكَتَهَا وَهُدَاهَا ، وَأَعُوْذُ بِكَ مِنْ شَرِّ مَا فِيْهَا وَشَرِّ مَا بَعْدَهَا.',
          transliteration:
              'Amsayna wa amsal-mulku lillahi Rabbil-\'alamin. Allahumma inni as\'aluka khayra hadhihil-laylah, fathaha wa nasraha wa nuraha wa barakataha wa hudaha, wa a\'udhu bika min sharri ma fiha wa sharri ma ba\'daha.',
          translation:
              'We have entered the evening and at this very time the whole kingdom belongs to Allah, Lord of the Worlds. O Allah, I ask You for the goodness of this night: its victory, its help, its light, its blessings, and its guidance. I seek Your protection from the evil that is in it and from the evil that follows it.',
          whenToSay: 'At the start of the evening.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5084',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evening', 'blessing', 'protection'],
          audioKey: 'sunnah_ask_allah_to_bless_your_evening.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_009_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Ask Allah for Good Health and Protection',
          arabic:
              'اَللّٰهُمَّ عَافِنِيْ فِيْ بَدَنِيْ ، اَللّٰهُمَّ عَافِنِيْ فِيْ سَمْعِيْ ، اَللّٰهُمَّ عَافِنِيْ فِيْ بَصَرِيْ ، لَا إِلٰهَ إِلَّا أَنْتَ ، اَللّٰهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ ، وَأَعُوْذُ بِكَ مِنْ عَذَابِ الْقَبْرِ ، لَا إِلٰهَ إِلَّا أَنْتَ.',
          transliteration:
              'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'i, Allahumma \'afini fi basari, la ilaha illa Ant. Allahumma inni a\'udhu bika minal-kufri wal-faqr, wa a\'udhu bika min \'adhabil-qabr, la ilaha illa Ant.',
          translation:
              'O Allah, grant me well-being in my body. O Allah, grant me well-being in my hearing. O Allah, grant me well-being in my sight. There is no god worthy of worship except You. O Allah, I seek Your protection from disbelief and poverty, and I seek Your protection from the punishment of the grave. There is no god worthy of worship except You.',
          whenToSay: 'Three times in the evening.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 5090',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evening', 'health', 'protection'],
          audioKey: 'sunnah_evening_good_health_and_protection.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_010_daily_life_morning_evening',
          category: 'daily_life',
          subcategory: 'morning_evening',
          title: 'Protect Yourself From All Harm',
          arabic:
              'بِسْمِ اللّٰهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ.',
          transliteration:
              'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\', wa Huwas-Sami\'ul-\'Alim.',
          translation:
              'In the Name of Allah, with whose Name nothing can harm in the earth nor in the sky. He is the All-Hearing and All-Knowing.',
          whenToSay: 'Three times in the evening.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3388',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evening', 'protection', 'safety'],
          audioKey: 'sunnah_evening_protect_yourself_from_all_harm.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_011_daily_life_sleep',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Before Sleep: Ayat al-Kursi',
          arabic:
              'ٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌۭ وَلَا نَوْمٌۭ ۚ لَّهُۥ مَا فِى ٱلسَّمَـٰوَٰتِ وَمَا فِى ٱلْأَرْضِ ۗ مَن ذَا ٱلَّذِى يَشْفَعُ عِندَهُۥٓ إِلَّا بِإِذْنِهِۦ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَىْءٍۢ مِّنْ عِلْمِهِۦٓ إِلَّا بِمَا شَآءَ ۚ وَسِعَ كُرْسِيُّهُ ٱلسَّمَـٰوَٰتِ وَٱلْأَرْضَ ۖ وَلَا يَـُٔودُهُۥ حِفْظُهُمَا ۚ وَهُوَ ٱلْعَلِىُّ ٱلْعَظِيمُ',
          transliteration:
              'Allahu la ilaha illa Huwal-Hayyul-Qayyum. La ta\'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa\'u \'indahu illa bi-idhnih. Ya\'lamu ma bayna aydihim wa ma khalfahum, wa la yuhituna bi shay\'im-min \'ilmihi illa bima sha\'. Wasi\'a kursiyyuhus-samawati wal-ard, wa la ya\'uduhu hifzuhuma, wa Huwal-\'Aliyyul-\'Azim.',
          translation:
              'Allah, there is no god worthy of worship but He, the Ever-Living, the Sustainer of all. Neither drowsiness overtakes Him nor sleep. To Him alone belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except with His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation does not tire Him. And He is the Most High, the Magnificent.',
          whenToSay: 'Before sleeping for protection through the night.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:255; Sahih al-Bukhari 2311',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['sleep', 'quran', 'protection'],
          audioKey: 'quran_002_255_before_sleep_ayat_al_kursi.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_com_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_012_daily_life_sleep',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Before Sleep: Last Two Verses of al-Baqarah',
          arabic:
              'ءَامَنَ ٱلرَّسُولُ بِمَآ أُنزِلَ إِلَيْهِ مِن رَّبِّهِۦ وَٱلْمُؤْمِنُونَ ۚ كُلٌّ ءَامَنَ بِٱللَّهِ وَمَلَـٰٓئِكَتِهِۦ وَكُتُبِهِۦ وَرُسُلِهِۦ لَا نُفَرِّقُ بَيْنَ أَحَدٍۢ مِّن رُّسُلِهِۦ ۚ وَقَالُوا۟ سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ ٱلْمَصِيرُ ۝ لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا ٱكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَآ إِن نَّسِينَآ أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَآ إِصْرًۭا كَمَا حَمَلْتَهُۥ عَلَى ٱلَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِۦ ۖ وَٱعْفُ عَنَّا وَٱغْفِرْ لَنَا وَٱرْحَمْنَآ ۚ أَنتَ مَوْلَىٰنَا فَٱنصُرْنَا عَلَى ٱلْقَوْمِ ٱلْكَـٰفِرِينَ',
          transliteration:
              'Amanar-rasulu bima unzila ilayhi mir-Rabbihi wal-mu\'minun. Kullun amana billahi wa mala\'ikatihi wa kutubihi wa rusulih, la nufarriqu bayna ahadim-mir-rusulih, wa qalu sami\'na wa ata\'na, ghufranaka Rabbana wa ilaykal-masir. La yukallifullahu nafsan illa wus\'aha, laha ma kasabat wa \'alayha maktasabat. Rabbana la tu\'akhidhna in nasina aw akhta\'na. Rabbana wa la tahmil \'alayna isran kama hamaltahu \'alal-ladhina min qablina. Rabbana wa la tuhammilna ma la taqata lana bih. Wa\'fu \'anna, waghfir lana, warhamna. Anta Mawlana fansurna \'alal-qawmil-kafirin.',
          translation:
              'The Messenger has believed in what was revealed to him from his Lord, and so have the believers. All of them have believed in Allah, His angels, His books, and His messengers, saying, "We make no distinction between any of His messengers." And they say, "We hear and we obey. We seek Your forgiveness, our Lord, and to You is the final destination." Allah does not charge a soul except with what is within its capacity. It will have what good it has gained, and it will bear what evil it has earned. "Our Lord, do not impose blame upon us if we have forgotten or erred. Our Lord, do not lay upon us a burden like that which You laid upon those before us. Our Lord, do not burden us with that which we have no ability to bear. Pardon us, forgive us, and have mercy upon us. You are our Protector, so give us victory over the disbelieving people."',
          whenToSay: 'Before sleeping; these two verses suffice for the night.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:285-286; Sahih al-Bukhari 5009',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['sleep', 'quran', 'protection'],
          audioKey: 'quran_002_285_286_before_sleep.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_com_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_013_daily_life_sleep',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Before Sleep: Three Quls',
          arabic:
              'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ هُوَ اللّٰهُ أَحَدٌ ، اَللّٰهُ الصَّمَدُ ، لَمْ يَلِدْ وَلَمْ يُوْلَدْ ، وَلَمْ يَكُنْ لَّهُ كُفُوًا أَحَدٌ.\n\nبِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ أَعُوْذُ بِرَبِّ الْفَلَقِ ، مِنْ شَرِّ مَا خَلَقَ ، وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ، وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ، وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ.\n\nبِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ. قُلْ أَعُوْذُ بِرَبِّ النَّاسِ ، مَلِكِ النَّاسِ ، إِلٰهِ النَّاسِ ، مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ، اَلَّذِيْ يُوَسْوِسُ فِيْ صُدُوْرِ النَّاسِ ، مِنَ الْجِنَّةِ وَالنَّاسِ.',
          transliteration:
              'Bismillahir-Rahmanir-Rahim. Qul Huwallahu Ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakul-lahu kufuwan ahad.\n\nBismillahir-Rahmanir-Rahim. Qul a\'udhu bi Rabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil-\'uqad. Wa min sharri hasidin idha hasad.\n\nBismillahir-Rahmanir-Rahim. Qul a\'udhu bi Rabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswasil-khannas. Alladhi yuwaswisu fi sudurin-nas. Minal-jinnati wan-nas.',
          translation:
              'In the name of Allah, the Most Merciful, the Very Merciful. Say: He is Allah, the One, the Self-Sufficient Master, Who has not given birth and was not born, and to Whom no one is equal. In the name of Allah, the Most Merciful, the Very Merciful. Say: I seek protection in the Lord of the daybreak, from the evil of what He has created, from the evil of the darkening night when it settles, from the evil of those who blow on knots, and from the evil of an envier when he envies. In the name of Allah, the Most Merciful, the Very Merciful. Say: I seek protection in the Lord of mankind, the King of mankind, the God of mankind, from the evil of the whisperer who withdraws, who whispers in the hearts of mankind, whether from jinn or people.',
          whenToSay:
              'Three times before sleeping, blowing into the hands and wiping over the body.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 112-114; Sahih al-Bukhari 5017',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['sleep', 'quran', 'protection'],
          audioKey: 'quran_three_quls_before_sleep.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_com_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_014_daily_life_sleep',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Waking at Night',
          arabic:
              'لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ ، لَهُ الْمُلْكُ ، وَلَهُ الْحَمْدُ ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيْرٌ ، اَلْحَمْدُ لِلّٰهِ ، وَسُبْحَانَ اللّٰهِ ، وَلَا إِلٰهَ إِلَّا اللّٰهُ ، وَاللّٰهُ أَكْبَرُ ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ ، اَللّٰهُمَّ اغْفِرْ لِيْ.',
          transliteration:
              'La ilaha illal-lahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa Huwa \'ala kulli shay\'in Qadir. Alhamdu lillah, wa subhanallah, wa la ilaha illallah, wallahu akbar, wa la hawla wa la quwwata illa billah. Allahummaghfir li.',
          translation:
              'There is no god worthy of worship but Allah alone, with no partner. To Him belongs all sovereignty and all praise, and He is over all things powerful. All praise is for Allah. Allah is free from imperfection. There is no god worthy of worship but Allah. Allah is the Greatest. There is no power and no strength except through Allah. O Allah, forgive me.',
          whenToSay:
              'When waking during the night before making dua or praying.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 1154',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['sleep', 'night', 'forgiveness'],
          audioKey: 'sunnah_waking_at_night.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_015_daily_life_food',
          category: 'daily_life',
          subcategory: 'food',
          title: 'After Eating (Long Form)',
          arabic:
              'اَلْحَمْدُ لِلّٰهِ حَمْدًا كَثِيْرًا طَيِّبًا مُبَارَكًا فِيْهِ ، غَيْرَ مَكْفِيٍّ وَلَا مُوَدَّعٍ ، وَلَا مُسْتَغْنًى عَنْهُ رَبَّنَا.',
          transliteration:
              'Alhamdu lillahi hamdan kathiran tayyibam-mubarakan fih, ghayra makfiyyin wa la muwadda\'in wa la mustaghnan \'anhu Rabbana.',
          translation:
              'Allah be praised with an abundant, beautiful, blessed praise, a never-ending praise, a praise which we will never bid farewell to and an indispensable praise, our Lord.',
          whenToSay: 'After finishing food.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 5458; Jami\' at-Tirmidhi 3456',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['food', 'gratitude', 'daily'],
          audioKey: 'sunnah_after_eating_long_form.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_016_daily_life_food',
          category: 'daily_life',
          subcategory: 'food',
          title: 'After Drinking Milk',
          arabic: 'اَللّٰهُمَّ بَارِكْ لَنَا فِيْهِ وَزِدْنَا مِنْهُ.',
          transliteration: 'Allahumma barik lana fihi wa zidna minh.',
          translation: 'O Allah, bless us in it and give us more of it.',
          whenToSay: 'After drinking milk.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3455',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['food', 'drink', 'daily'],
          audioKey: 'sunnah_after_drinking_milk.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_017_daily_life_food',
          category: 'daily_life',
          subcategory: 'food',
          title: 'Guest\'s Dua for the Host',
          arabic:
              'اَللّٰهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِيْ وَاسْقِ مَنْ سَقَانِي.',
          transliteration: 'Allahumma at\'im man at\'amani, wasqi man saqani.',
          translation:
              'O Allah, feed the one who has fed me and give drink to the one who has given me to drink.',
          whenToSay: 'As a guest after being fed or given drink.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2055',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['food', 'guest', 'host'],
          audioKey: 'sunnah_guest_dua_for_host.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_018_daily_life_clothing',
          category: 'daily_life',
          subcategory: 'clothing',
          title: 'Wearing New Clothes',
          arabic:
              'اَللّٰهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيْهِ ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا صُنِعَ لَهُ ، وَأَعُوذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا صُنِعَ لَهُ.',
          transliteration:
              'Allahumma lakal-hamdu Anta kasawtanihi, as\'aluka min khayrihi wa khayri ma suni\'a lahu, wa a\'udhu bika min sharrihi wa sharri ma suni\'a lahu.',
          translation:
              'O Allah, all praise is for You alone. You have clothed me with it. I ask You for its good and the good of that for which it was made, and I seek Your protection from its evil and the evil of that for which it was made.',
          whenToSay: 'When wearing new clothes.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 1767',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['clothing', 'daily', 'protection'],
          audioKey: 'sunnah_wearing_new_clothes.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_019_daily_life_clothing',
          category: 'daily_life',
          subcategory: 'clothing',
          title: 'Before Removing Clothes',
          arabic: 'بِسْمِ اللّٰهِ',
          transliteration: 'Bismillah.',
          translation: 'In the Name of Allah.',
          whenToSay: 'Before removing clothing.',
          sourceType: 'sunnah',
          sourceRef: 'al-Mu\'jam al-Awsat 7066',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['clothing', 'daily', 'modesty'],
          audioKey: 'sunnah_before_removing_clothes.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_020_daily_life_toilet',
          category: 'daily_life',
          subcategory: 'toilet',
          title: 'Entering the Washroom',
          arabic:
              'بِسْمِ اللّٰهِ ، اَللّٰهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ.',
          transliteration:
              'Bismillah, Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith.',
          translation:
              'In the Name of Allah. O Allah, I seek Your protection from the male and female devils.',
          whenToSay: 'Before entering the washroom.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 142; Sahih Muslim 375',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['toilet', 'daily', 'protection'],
          audioKey: 'sunnah_entering_washroom.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_021_daily_life_toilet',
          category: 'daily_life',
          subcategory: 'toilet',
          title: 'Leaving the Washroom',
          arabic: 'غُفْرَانَكَ.',
          transliteration: 'Ghufranak.',
          translation: 'I seek Your forgiveness.',
          whenToSay: 'After leaving the washroom.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 30',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['toilet', 'daily', 'forgiveness'],
          audioKey: 'sunnah_leaving_washroom.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_022_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'General Praise of Allah',
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: 'SubhanAllahi wa bihamdihi',
          translation:
              'Allah is free from imperfection and all praise is due to Him.',
          whenToSay: 'Throughout the day as general remembrance and praise.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6405; Sahih Muslim 2691',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'praise', 'dhikr'],
          audioKey: 'sunnah_general_praise_of_allah.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_023_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Tahlil',
          arabic:
              'لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيْرٌ',
          transliteration:
              'La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd wa Huwa \'ala kulli shay\'in Qadir.',
          translation:
              'There is no god worthy of worship except Allah alone. He has no partner. To Him belong all sovereignty and all praise, and He is over all things powerful.',
          whenToSay:
              'Frequently through the day, especially as abundant daily dhikr.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 3293',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'tawhid', 'dhikr'],
          audioKey: 'sunnah_tahlil.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_024_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Tasbih',
          arabic: 'سُبْحَانَ اللَّهِ',
          transliteration: 'SubhanAllah',
          translation: 'Allah is free from imperfection.',
          whenToSay: 'Throughout the day as simple remembrance.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2137',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'tasbih', 'dhikr'],
          audioKey: 'sunnah_tasbih.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_025_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Tahmid',
          arabic: 'الْحَمْدُ لِلّٰهِ',
          transliteration: 'Alhamdulillah',
          translation: 'All praise is for Allah.',
          whenToSay: 'Throughout the day as simple praise and gratitude.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2137',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'gratitude', 'dhikr'],
          audioKey: 'sunnah_tahmid.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_026_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Takbir',
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest.',
          whenToSay:
              'Throughout the day as simple remembrance and magnification of Allah.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2137',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'takbir', 'dhikr'],
          audioKey: 'sunnah_takbir.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_027_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Hawqala',
          arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ',
          transliteration: 'La hawla wa la quwwata illa billah',
          translation:
              'There is no power and no strength except through Allah.',
          whenToSay:
              'Throughout the day, especially when needing help and reliance on Allah.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari and Sahih Muslim',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'reliance', 'dhikr'],
          audioKey: 'sunnah_hawqala.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_028_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Seeking Forgiveness 100 Times',
          arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
          transliteration: 'Astaghfirullaha wa atubu ilayh',
          translation:
              'I seek Allah\'s forgiveness and I turn to Him in repentance.',
          whenToSay: 'Frequently through the day; abundant daily istighfar.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari and Sahih Muslim',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'forgiveness', 'istighfar'],
          audioKey: 'sunnah_seeking_forgiveness_100_times.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_029_daily_life_daily',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Salawat upon the Prophet',
          arabic:
              'اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ.',
          transliteration:
              'Allahumma salli \'ala Muhammad wa \'ala ali Muhammad.',
          translation:
              'O Allah, honour and have mercy upon Muhammad and his household.',
          whenToSay:
              'Daily, especially on Fridays and whenever sending blessings upon the Prophet.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan an-Nasa\'i 1291',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'salawat', 'prophet'],
          audioKey: 'sunnah_salawat_upon_the_prophet.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_030_prayer_and_worship_salah',
          category: 'prayer_and_worship',
          subcategory: 'salah',
          title: 'Opening Supplication in Salah 1',
          arabic:
              'اَللّٰهُمَّ بَاعِدْ بَيْنِيْ وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ ، اَللّٰهُمَّ نَقِّنِيْ مِنْ خَطَايَايَ كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ ، اَللّٰهُمَّ اغْسِلْنِيْ مِنْ خَطَايَايَ بِالثَّلْجِ وَالْمَاءِ وَالْبَرَدِ.',
          transliteration:
              'Allahumma ba\'id bayni wa bayna khatayaya kama ba\'adta baynal-mashriqi wal-maghrib. Allahumma naqqini min khatayaya kama yunaqqath-thawbul-abyadu minad-danas. Allahummaghsilni min khatayaya bith-thalji wal-ma\'i wal-barad.',
          translation:
              'O Allah, distance me from my sins as You have distanced the East from the West. O Allah, purify me from my sins as a white garment is cleansed from dirt. O Allah, wash away my sins with snow, water, and hail.',
          whenToSay:
              'After the opening takbir and before reciting Surah al-Fatihah in salah.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 744; Sahih Muslim 598',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['salah', 'opening', 'forgiveness'],
          audioKey: 'sunnah_opening_supplication_in_salah_1.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_031_prayer_and_worship_salah',
          category: 'prayer_and_worship',
          subcategory: 'salah',
          title: 'Opening Supplication in Salah 2',
          arabic:
              'سُبْحَانَ اللّٰهِ رَبِّ الْعَالَمِيْنَ ، سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ.',
          transliteration:
              'Subhanallahi Rabbil-\'alamin, subhanallahi wa bihamdih.',
          translation:
              'Allah is free from imperfection, the Lord of all the worlds. Allah is free from imperfection, and all praise is due to Him.',
          whenToSay:
              'An opening supplication for salah, especially in voluntary and night prayers.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan an-Nasa\'i 1618',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['salah', 'opening', 'night_prayer'],
          audioKey: 'sunnah_opening_supplication_in_salah_2.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_032_prayer_and_worship_sujud',
          category: 'prayer_and_worship',
          subcategory: 'sujud',
          title: 'Between the Two Sujud',
          arabic: 'رَبِّ اغْفِرْ لِيْ ، رَبِّ اغْفِرْ لِيْ.',
          transliteration: 'Rabbighfir li, Rabbighfir li.',
          translation: 'My Lord, forgive me. My Lord, forgive me.',
          whenToSay: 'While sitting between the two prostrations in salah.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 874',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['salah', 'sujud', 'forgiveness'],
          audioKey: 'sunnah_between_the_two_sujud.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_033_prayer_and_worship_sujud',
          category: 'prayer_and_worship',
          subcategory: 'sujud',
          title: 'In Sujud',
          arabic:
              'اَللّٰهُمَّ اغْفِرْ لِيْ ذَنْبِيْ كُلَّهُ ، دِقَّهُ وَجِلَّهُ ، وَأَوَّلَهُ وَآخِرَهُ ، وَعَلَانِيَتَهُ وَسِرَّهُ.',
          transliteration:
              'Allahummaghfir li dhanbi kullahu, diqqahu wa jillahu, wa awwalahu wa akhirahu, wa \'alaniyatahu wa sirrahu.',
          translation:
              'O Allah, forgive me all my sins, the small and the great, the first and the last, the open and the hidden.',
          whenToSay:
              'In prostration during salah, when one is closest to Allah in supplication.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 483',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['salah', 'sujud', 'forgiveness', 'repentance'],
          audioKey: 'sunnah_in_sujud.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_034_prayer_and_worship_after_salah',
          category: 'prayer_and_worship',
          subcategory: 'after_salah',
          title: 'After Salah Tasbih',
          arabic:
              '(x33) سُبْحَانَ اللّٰهِ. (x33) اَلْحَمْدُ لِلّٰهِ. (x33) اَللّٰهُ أَكْبَرُ. لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيْرٌ.',
          transliteration:
              'Subhanallah (x33), Alhamdulillah (x33), Allahu Akbar (x33), La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadir.',
          translation:
              'Allah is free from imperfection, all praise is for Allah, and Allah is the Greatest. There is no god but Allah alone, without partner. To Him belong dominion and praise, and He is over all things capable.',
          whenToSay: 'After the obligatory prayers.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 597; Sahih Muslim 596',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['after_salah', 'tasbih', 'dhikr'],
          audioKey: 'sunnah_after_salah_tasbih.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_035_prayer_and_worship_after_salah',
          category: 'prayer_and_worship',
          subcategory: 'after_salah',
          title: 'After Salah Seeking Forgiveness',
          arabic:
              'أَسْتَغْفِرُ اللّٰهَ ، أَسْتَغْفِرُ اللّٰهَ ، أَسْتَغْفِرُ اللّٰهَ. اَللّٰهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
          transliteration:
              'Astaghfirullah, Astaghfirullah, Astaghfirullah. Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram.',
          translation:
              'I seek Allah\'s forgiveness, I seek Allah\'s forgiveness, I seek Allah\'s forgiveness. O Allah, You are Peace and from You is peace. Blessed are You, O Possessor of majesty and honour.',
          whenToSay: 'Immediately after completing salah.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 591',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['after_salah', 'forgiveness', 'dhikr'],
          audioKey: 'sunnah_after_salah_seeking_forgiveness.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_036_prayer_and_worship_wudu',
          category: 'prayer_and_worship',
          subcategory: 'wudu',
          title: 'Before Wudu',
          arabic: 'بِسْمِ اللهِ',
          transliteration: 'Bismillah.',
          translation: 'In the name of Allah.',
          whenToSay: 'At the start of wudu.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud; Sunan Ibn Majah; Musnad Ahmad',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['wudu', 'purification', 'beginner'],
          audioKey: 'sunnah_before_wudu.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_037_prayer_and_worship_wudu',
          category: 'prayer_and_worship',
          subcategory: 'wudu',
          title: 'After Wudu',
          arabic:
              'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ. اَللّٰهُمَّ اجْعَلْنِيْ مِنَ التَّوَّابِيْنَ وَاجْعَلْنِيْ مِنَ الْمُتَطَهِّرِيْنَ.',
          transliteration:
              'Ashhadu an la ilaha illallahu wahdahu la sharika lah, wa ashhadu anna Muhammadan \'abduhu wa rasuluh. Allahummaj\'alni minat-tawwabina waj\'alni minal-mutatahhirin.',
          translation:
              'I bear witness that there is no god but Allah alone without partner, and I bear witness that Muhammad is His servant and Messenger. O Allah, make me among those who constantly repent and among those who are purified.',
          whenToSay: 'After completing wudu.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 234; Jami\' at-Tirmidhi 55',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['wudu', 'purification', 'repentance'],
          audioKey: 'sunnah_after_wudu.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_038_prayer_and_worship_quran',
          category: 'prayer_and_worship',
          subcategory: 'quran',
          title: 'Before Reading Qur\'an',
          arabic: 'أَعُوذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          transliteration: 'A\'udhu billahi minash-shaytanir-rajim.',
          translation: 'I seek refuge in Allah from the accursed Shaytan.',
          whenToSay:
              'Before beginning recitation of the Qur\'an, especially aloud.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 16:98',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'recitation', 'protection'],
          audioKey: 'quran_before_reading_quran.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_039_prayer_and_worship_quran',
          category: 'prayer_and_worship',
          subcategory: 'quran',
          title: 'Closing Dhikr after a Qur\'an Reading Gathering',
          arabic:
              'سُبْحَانَكَ اللّٰهُمَّ وَبِحَمْدِكَ ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا أَنْتَ ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ.',
          transliteration:
              'Subhanaka Allahumma wa bihamdik, ashhadu an la ilaha illa ant, astaghfiruka wa atubu ilayk.',
          translation:
              'How perfect You are, O Allah, and all praise is Yours. I bear witness that there is no god but You. I seek Your forgiveness and I repent to You.',
          whenToSay:
              'As a general closing dhikr after a sitting of Qur\'an recitation or study. There is no fixed marfu\' dua established specifically for khatm al-Qur\'an.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 4859; Jami\' at-Tirmidhi 3433',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'closing', 'forgiveness', 'gathering'],
          audioKey: 'sunnah_closing_dhikr_after_quran_reading_gathering.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_040_prayer_and_worship_adhan',
          category: 'prayer_and_worship',
          subcategory: 'adhan',
          title: 'During Adhan: Repeat the Mu\'adhdhin',
          arabic:
              'يُقَالُ مِثْلُ مَا يَقُولُ الْمُؤَذِّنُ ، إِلَّا فِيْ حَيَّ عَلَى الصَّلَاةِ وَحَيَّ عَلَى الْفَلَاحِ ، فَيُقَالُ: لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ.',
          transliteration:
              'Yuqalu mithlu ma yaqulul-mu\'adhdhin, illa fi hayya \'alas-salahi wa hayya \'alal-falah, fayuqalu: La hawla wa la quwwata illa billah.',
          translation:
              'Repeat what the mu\'adhdhin says. When he says, “Come to prayer” and “Come to success,” say: “There is no power and no strength except through Allah.”',
          whenToSay: 'While the adhan is being called.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 611; Sahih Muslim 385',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['adhan', 'response', 'prayer'],
          audioKey: 'sunnah_during_adhan_repeat_the_muadhdhin.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_041_prayer_and_worship_friday',
          category: 'prayer_and_worship',
          subcategory: 'friday',
          title: 'On Friday: Send Blessings upon the Prophet',
          arabic:
              'اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ اٰلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ. اَللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَّعَلَىٰ اٰلِ مُحَمَّدٍ ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ اٰلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ.',
          transliteration:
              'Allahumma salli \'ala Muhammadin wa \'ala ali Muhammad, kama sallayta \'ala Ibrahima wa \'ala ali Ibrahim, innaka Hamidun Majid. Allahumma barik \'ala Muhammadin wa \'ala ali Muhammad, kama barakta \'ala Ibrahima wa \'ala ali Ibrahim, innaka Hamidun Majid.',
          translation:
              'O Allah, send blessings upon Muhammad and the family of Muhammad as You sent blessings upon Ibrahim and the family of Ibrahim; surely You are Praiseworthy, Glorious. O Allah, bless Muhammad and the family of Muhammad as You blessed Ibrahim and the family of Ibrahim; surely You are Praiseworthy, Glorious.',
          whenToSay:
              'Frequently on Friday and the night before it. This replaces a non-fixed Jumu\'ah topic placeholder with a source-backed Friday practice.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 3370; Sunan Abi Dawud 1047',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['friday', 'salawat', 'prophet'],
          audioKey: 'sunnah_on_friday_send_blessings_upon_the_prophet.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_042_prayer_and_worship_istikhara',
          category: 'prayer_and_worship',
          subcategory: 'istikhara',
          title: 'Istikhara Full Dua',
          arabic:
              'اَللّٰهُمَّ إِنِّيْ أَسْتَخِيْرُكَ بِعِلْمِكَ ، وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ ، وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيْمِ ، فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ ، وَتَعْلَمُ وَلَا أَعْلَمُ ، وَأَنْتَ عَلَّامُ الْغُيُوْبِ. اَللّٰهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ (وَيُسَمِّي حَاجَتَه) خَيْرٌ لِّيْ فِيْ دِيْنِيْ وَمَعَاشِيْ وَعَاقِبَةِ أَمْرِيْ ، فَاقْدُرْهُ لِيْ وَيَسِّرْهُ لِيْ ثُمَّ بَارِكْ لِيْ فِيْهِ ، وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ (وَيُسَمِّي حَاجَتَه) شَرٌّ لِّيْ فِيْ دِيْنِيْ وَمَعَاشِيْ وَعَاقِبَةِ أَمْرِيْ ، فَاصْرِفْهُ عَنِّيْ وَاصْرِفْنِيْ عَنْهُ وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِيْ بِهِ.',
          transliteration:
              'Allahumma inni astakhiruka bi\'ilmik, wa astaqdiruka biqudratik, wa as\'aluka min fadlikal-\'azim, fa innaka taqdiru wa la aqdir, wa ta\'lamu wa la a\'lam, wa anta \'allamul-ghuyub. Allahumma in kunta ta\'lamu anna hadhal-amra (wa yusammi hajatuh) khayrun li fi dini wa ma\'ashi wa \'aqibati amri faqdurhu li wa yassirhu li thumma barik li fih. Wa in kunta ta\'lamu anna hadhal-amra (wa yusammi hajatuh) sharrun li fi dini wa ma\'ashi wa \'aqibati amri fasrifhu \'anni wasrifni \'anhu waqdur liyal-khayra haythu kana thumma ardini bih.',
          translation:
              'O Allah, I seek the better choice from You by Your knowledge, and I seek ability from You by Your power, and I ask You from Your immense bounty. You are fully capable while I am not, You know and I do not know, and You are the Knower of the unseen. O Allah, if You know this matter to be good for me in my religion, my livelihood, and the outcome of my affair, then decree it for me, make it easy for me, and bless it for me. And if You know this matter to be bad for me in my religion, my livelihood, and the outcome of my affair, then turn it away from me and turn me away from it, and decree for me the good wherever it may be, then make me pleased with it.',
          whenToSay:
              'After praying two rak\'ahs of voluntary prayer when seeking Allah\'s guidance in a decision.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6382',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['istikhara', 'guidance', 'decision'],
          audioKey: 'sunnah_istikhara_full_dua.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_life_with_allah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_043_prayer_and_worship_masjid',
          category: 'prayer_and_worship',
          subcategory: 'hajj_umrah',
          title: 'At the Ka\'bah: Good in This Life and the Next',
          arabic:
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          transliteration:
              'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina \'adhaban-nar.',
          translation:
              'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
          whenToSay:
              'When making dua around the Ka\'bah, especially between the Yemeni Corner and the Black Stone. This replaces a weakly fixed “seeing the Ka\'bah” placeholder with a stronger attested supplication.',
          sourceType: 'quran_sunnah',
          sourceRef: 'Qur\'an 2:201; Sunan Abi Dawud 1892',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['hajj', 'umrah', 'kaabah', 'akhirah'],
          audioKey: 'quran_at_the_kaabah_good_in_this_life_and_the_next.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_044_prayer_and_worship_hajj_umrah',
          category: 'prayer_and_worship',
          subcategory: 'hajj_umrah',
          title: 'Talbiyah',
          arabic:
              'لَبَّيْكَ اللّٰهُمَّ لَبَّيْكَ ، لَبَّيْكَ لَا شَرِيْكَ لَكَ لَبَّيْكَ ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ ، لَا شَرِيْكَ لَكَ.',
          transliteration:
              'Labbayka Allahumma labbayk, labbayka la sharika laka labbayk, innal-hamda wan-ni\'mata laka wal-mulk, la sharika lak.',
          translation:
              'Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Surely all praise, blessing, and dominion belong to You. You have no partner.',
          whenToSay:
              'From entering ihram through the rites of Hajj or Umrah until the talbiyah is stopped.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 1549; Sahih Muslim 1184',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['hajj', 'umrah', 'talbiyah', 'ihram'],
          audioKey: 'sunnah_talbiyah.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_045_prayer_and_worship_hajj_umrah',
          category: 'prayer_and_worship',
          subcategory: 'hajj_umrah',
          title: 'At Safa and Marwah',
          arabic:
              'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ. أَبْدَأُ بِمَا بَدَأَ اللَّهُ بِهِ. لَا إِلٰهَ إِلَّا اللَّهُ ، اللَّهُ أَكْبَرُ. لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ. لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ ، أَنْجَزَ وَعْدَهُ ، وَنَصَرَ عَبْدَهُ ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ.',
          transliteration:
              'Innas-Safa wal-Marwata min sha\'a\'irillah. Abda\'u bima bada\'allahu bih. La ilaha illallah, Allahu Akbar. La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadir. La ilaha illallahu wahdah, anjaza wa\'dah, wa nasara \'abdah, wa hazamal-ahzaba wahdah.',
          translation:
              'Surely Safa and Marwah are among the symbols of Allah. I begin with what Allah began with. There is no god but Allah, and Allah is the Greatest. There is no god but Allah alone without partner; to Him belong dominion and praise, and He is over all things capable. There is no god but Allah alone; He fulfilled His promise, helped His servant, and defeated the confederates alone.',
          whenToSay:
              'At Safa and Marwah during sa\'y, then one makes personal dua between repetitions.',
          sourceType: 'quran_sunnah',
          sourceRef: 'Qur\'an 2:158; Sahih Muslim 1218',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['hajj', 'umrah', 'safa', 'marwah'],
          audioKey: 'sunnah_at_safa_and_marwah.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_046_prayer_and_worship_hajj_umrah',
          category: 'prayer_and_worship',
          subcategory: 'hajj_umrah',
          title: 'At Arafah',
          arabic:
              'لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ.',
          transliteration:
              'La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa \'ala kulli shay\'in qadir.',
          translation:
              'There is no god but Allah alone without partner. To Him belong dominion and praise, and He is over all things capable.',
          whenToSay:
              'Frequently on the Day of \'Arafah, along with abundant personal dua.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3585',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['hajj', 'arafah', 'tawhid', 'dhikr'],
          audioKey: 'sunnah_at_arafah.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_047_prayer_and_worship_hajj_umrah',
          category: 'prayer_and_worship',
          subcategory: 'hajj_umrah',
          title: 'Stoning the Jamarat',
          arabic: 'اَللّٰهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar.',
          translation: 'Allah is the Greatest.',
          whenToSay: 'With each pebble while stoning the Jamarat during Hajj.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 1751',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['hajj', 'jamarat', 'takbir'],
          audioKey: 'sunnah_stoning_the_jamarat.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_048_home_and_family_family',
          category: 'home_and_family',
          subcategory: 'family',
          title: 'For One\'s Spouse',
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَخَيْرَ مَا جَبَلْتَهَا عَلَيْهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا، وَشَرِّ مَا جَبَلْتَهَا عَلَيْهِ',
          transliteration:
              'Allahumma inni as\'aluka khayraha, wa khayra ma jabaltaha \'alayh, wa a\'udhu bika min sharriha, wa sharri ma jabaltaha \'alayh.',
          translation:
              'O Allah, I ask You for her goodness and the goodness upon which You created her, and I seek refuge in You from her evil and the evil upon which You created her.',
          whenToSay:
              'When beginning married life and asking Allah for goodness, mercy, and protection in the relationship.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 191; Abu Dawud 2/248; Ibn Majah 1/617.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['spouse', 'marriage', 'family', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_049_home_and_family_family',
          category: 'home_and_family',
          subcategory: 'family',
          title: 'For One\'s Children',
          arabic:
              'أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ، مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
          transliteration:
              'U\'idhukuma bikalimati Allahi at-tammati, min kulli shaytanin wa hammah, wa min kulli \'aynin lammah.',
          translation:
              'I seek protection for you in the perfect words of Allah from every devil and harmful creature, and from every envious, blameworthy eye.',
          whenToSay:
              'When making dua for one\'s children and asking Allah to protect them.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 146; Al-Bukhari 4/119.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['children', 'family', 'protection', 'evil_eye'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_050_home_and_family_family',
          category: 'home_and_family',
          subcategory: 'family',
          title: 'For a Newborn Child',
          arabic:
              'بَارَكَ اللَّهُ لَكَ فِي الْمَوْهُوبِ لَكَ، وَشَكَرْتَ الْوَاهِبَ، وَبَلَغَ أَشُدَّهُ، وَرُزِقْتَ بِرَّهُ',
          transliteration:
              'Barakallahu laka fi al-mawhubi lak, wa shakarta al-Wahib, wa balagha ashuddah, wa ruziqta birrah.',
          translation:
              'May Allah bless you with the child gifted to you, make you thankful to the Giver, let the child reach full strength, and grant you its righteousness.',
          whenToSay:
              'When congratulating parents on the birth of a newborn child.',
          sourceType: 'Athar / du\'a tradition',
          sourceRef:
              'Hisn al-Muslim 145; cited from an-Nawawi\'s al-Adhkar and Sahih al-Adhkar.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['newborn', 'family', 'children', 'barakah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_051_home_and_family_family',
          category: 'home_and_family',
          subcategory: 'family',
          title: 'Reply to Newborn Congratulations',
          arabic:
              'بَارَكَ اللَّهُ لَكَ وَبَارَكَ عَلَيْكَ، وَجَزَاكَ اللَّهُ خَيْرًا، وَرَزَقَكَ اللَّهُ مِثْلَهُ، وَأَجْزَلَ ثَوَابَكَ',
          transliteration:
              'Barakallahu laka wa baraka \'alayk, wa jazakallahu khayran, wa razaqakallahu mithlah, wa ajzala thawabak.',
          translation:
              'May Allah bless you and shower His blessings upon you, reward you well, grant you the like of it, and greatly multiply your reward.',
          whenToSay:
              'As the reply of the new parent after being congratulated on a newborn child.',
          sourceType: 'Athar / du\'a tradition',
          sourceRef:
              'Hisn al-Muslim 145; cited from an-Nawawi\'s al-Adhkar and Sahih al-Adhkar.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['newborn', 'family', 'reply', 'barakah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_052_home_and_family_marriage',
          category: 'home_and_family',
          subcategory: 'marriage',
          title: 'Before Marital Relations',
          arabic:
              'بِسْمِ اللهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا',
          transliteration:
              'Bismillah. Allahumma jannibna ash-Shaytan, wa jannib ash-Shaytana ma razaqtana.',
          translation:
              'In the name of Allah. O Allah, keep Satan away from us and keep Satan away from what You provide us.',
          whenToSay: 'Before marital relations.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 192; Al-Bukhari 6/141; Muslim 2/1028.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['marriage', 'family', 'children', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_053_home_and_family_home',
          category: 'home_and_family',
          subcategory: 'home',
          title: 'Securing the Home at Night with Allah\'s Name',
          arabic:
              'إِذَا كَانَ جُنْحُ اللَّيْلِ فَكُفُّوا صِبْيَانَكُمْ، وَأَغْلِقُوا الأَبْوَابَ وَاذْكُرُوا اسْمَ اللَّهِ، وَأَوْكُوا قِرَبَكُمْ وَاذْكُرُوا اسْمَ اللَّهِ، وَخَمِّرُوا آنِيَتَكُمْ وَاذْكُرُوا اسْمَ اللَّهِ، وَأَطْفِئُوا مَصَابِيحَكُمْ',
          transliteration:
              'Idha kana junhu al-layl fakuffu sibyanakum, wa aghliqu al-abwab wa udhkuru isma Allah, wa awku qirabakum wa udhkuru isma Allah, wa khammiru aniyatakum wa udhkuru isma Allah, wa atfi\'u masabihakum.',
          translation:
              'When night falls, keep your children in, close the doors and mention Allah’s name, tie your water-skins and mention Allah’s name, cover your vessels and mention Allah’s name, and put out your lamps.',
          whenToSay:
              'At night when securing the home and household with the remembrance of Allah.',
          sourceType: 'Hadith guidance',
          sourceRef:
              'Hisn al-Muslim 267; Al-Bukhari with al-Fath 10/88; Muslim 3/1595.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['home', 'family', 'night', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_054_home_and_family_parents',
          category: 'home_and_family',
          subcategory: 'parents',
          title: 'For Living Parents',
          arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
          transliteration: 'Rabbi irhamhuma kama rabbayani saghira.',
          translation:
              'My Lord, have mercy on them as they raised me when I was small.',
          whenToSay:
              'For one\'s living parents and in gratitude for their care.',
          sourceType: 'Qur\'an',
          sourceRef: 'Qur\'an 17:24.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['parents', 'family', 'mercy', 'quran'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_055_home_and_family_parents',
          category: 'home_and_family',
          subcategory: 'parents',
          title: 'For Deceased Parents',
          arabic:
              'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
          transliteration:
              'Rabbanaghfir li wa liwalidayya wa lilmu\'minina yawma yaqumul-hisab.',
          translation:
              'Our Lord, forgive me, my parents, and the believers on the Day the reckoning is established.',
          whenToSay:
              'For deceased parents, oneself, and the believers, especially in acts of remembrance.',
          sourceType: 'Qur\'an',
          sourceRef: 'Qur\'an 14:41.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['parents', 'forgiveness', 'family', 'quran'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_056_home_and_family_relatives',
          category: 'home_and_family',
          subcategory: 'relatives',
          title: 'For Family Reconciliation',
          arabic:
              'رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالإِيمَانِ وَلَا تَجْعَلْ فِي قُلُوبِنَا غِلًّا لِلَّذِينَ آمَنُوا رَبَّنَا إِنَّكَ رَءُوفٌ رَحِيمٌ',
          transliteration:
              'Rabbana ighfir lana wa li-ikhwanina alladhina sabaquna bil-iman wa la taj\'al fi qulubina ghillan lilladhina amanu Rabbana innaka Ra\'ufun Rahim.',
          translation:
              'Our Lord, forgive us and our brothers who preceded us in faith, and do not place in our hearts any resentment toward those who believe. Our Lord, indeed You are Kind and Merciful.',
          whenToSay:
              'When asking Allah to remove resentment, mend relationships, and soften hearts within the family and community.',
          sourceType: 'Qur\'an',
          sourceRef: 'Qur\'an 59:10.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['family', 'reconciliation', 'hearts', 'quran'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_057_home_and_family_guests',
          category: 'home_and_family',
          subcategory: 'guests',
          title: 'For One Who Has Fed You',
          arabic: 'اللّهُـمَّ أَطْعِمْ مَن أَطْعَمَني، وَاسْقِ مَن سَقَاني',
          transliteration: 'Allahumma at\'im man at\'amani, wasqi man saqani.',
          translation:
              'O Allah, feed the one who has fed me and give drink to the one who has given me drink.',
          whenToSay: 'For a host or anyone who has served you food or drink.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 183; Muslim 3/126.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['guest', 'host', 'food', 'gratitude'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_058_home_and_family_guests',
          category: 'home_and_family',
          subcategory: 'guests',
          title: 'Dua of the Guest for the Host',
          arabic:
              'اللّهُـمَّ بارِكْ لَهُمْ فيما رَزَقْـتَهُم، وَاغْفِـرْ لَهُـمْ وَارْحَمْهُمْ',
          transliteration:
              'Allahumma barik lahum fima razaqtahum, waghfir lahum warhamhum.',
          translation:
              'O Allah, bless them in what You have provided them, forgive them, and have mercy on them.',
          whenToSay:
              'As a guest praying for the host after eating or being hosted.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 182; Muslim 3/1615.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['guest', 'host', 'food', 'mercy'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_059_travel_and_movement_vehicle',
          category: 'travel_and_movement',
          subcategory: 'vehicle',
          title: 'Mounting a Vehicle',
          arabic:
              'بِسْـمِ اللهِ\nوَالْحَمْـدُ لله،\n﴿سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ * وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ﴾\nالحَمْـدُ لله، الحَمْـدُ لله، الحَمْـدُ لله،\nاللهُ أكْـبَر، اللهُ أكْـبَر، اللهُ أكْـبَر،\nسُـبْحانَكَ اللّهُـمَّ إِنّي ظَلَـمْتُ نَفْسي فَاغْـفِرْ لي، فَإِنَّهُ لا يَغْفِـرُ الذُّنوبَ إِلاّ أَنْـت',
          transliteration:
              'Bismillah. Wal-hamdu lillah. Subhana alladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun. Al-hamdu lillah, al-hamdu lillah, al-hamdu lillah. Allahu Akbar, Allahu Akbar, Allahu Akbar. Subhanaka Allahumma inni zalamtu nafsi faghfir li, fa innahu la yaghfiru adh-dhunuba illa Ant.',
          translation:
              'With the Name of Allah. Praise is to Allah. Glory is to Him Who has provided this for us though we could never have had it by our efforts. Surely, unto our Lord, we are returning. Praise is to Allah, three times. Allah is the Greatest, three times. Glory is to You, O Allah. I have wronged my own soul, so forgive me, for none forgives sins except You.',
          whenToSay:
              'When mounting a ride, vehicle, or means of transport and setting out.',
          sourceType: 'Hadith / Qur\'an citation',
          sourceRef:
              'Hisn al-Muslim 206; Abu Dawud 3/34; At-Tirmidhi 5/501; includes Qur\'an 43:13-14.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'vehicle', 'journey', 'forgiveness'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_060_travel_and_movement_vehicle',
          category: 'travel_and_movement',
          subcategory: 'vehicle',
          title: 'Travel Takbir and Tasbih',
          arabic: 'إِذَا صَعَدْنَا كَبَّرْنَا، وَإِذَا نَزَلْنَا سَبَّحْنَا',
          transliteration: 'Idha sa\'adna kabbarna, wa idha nazalna sabbahna.',
          translation:
              'When we climbed, we would say Allahu Akbar, and when we descended, we would say Subhanallah.',
          whenToSay:
              'During travel when going up elevated ground or descending.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 214; Al-Bukhari.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'journey', 'dhikr', 'movement'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_061_travel_and_movement_journey',
          category: 'travel_and_movement',
          subcategory: 'journey',
          title: 'General Travel Dua',
          arabic:
              'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ،\n﴿سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ * وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ﴾\nاللَّهُمَّ إِنّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا البِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى،\nاللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ،\nاللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ، وَالْخَليفَةُ فِي الْأَهْلِ،\nاللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ، وَكَآبَةِ الْمَنْظَرِ، وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ',
          transliteration:
              'Allahu Akbar, Allahu Akbar, Allahu Akbar. Subhana alladhi sakhkhara lana hadha wa ma kunna lahu muqrinin. Wa inna ila Rabbina lamunqalibun. Allahumma inna nas\'aluka fi safarina hadha al-birra wat-taqwa, wa mina al-\'amali ma tarda. Allahumma hawwin \'alayna safarana hadha watwi \'anna bu\'dah. Allahumma Anta as-sahibu fi as-safar, wa al-khalifatu fi al-ahl. Allahumma inni a\'udhu bika min wa\'tha\' as-safar, wa ka\'abat al-manzar, wa su\' il-munqalabi fi al-mali wa al-ahl.',
          translation:
              'Allah is the Greatest, three times. Glory is to Him Who has provided this for us though we could never have had it by our efforts. Surely, unto our Lord we are returning. O Allah, we ask You on this journey for righteousness, God-consciousness, and deeds that please You. O Allah, make this journey easy for us and fold up its distance for us. O Allah, You are the Companion in travel and the Guardian over our family. O Allah, I seek refuge in You from the hardships of travel, from distressing sights, and from an unhappy return in wealth and family.',
          whenToSay: 'At the start of a journey after mounting the ride.',
          sourceType: 'Hadith / Qur\'an citation',
          sourceRef:
              'Hisn al-Muslim 207; Muslim 2/978; includes Qur\'an 43:13-14.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'journey', 'protection', 'family'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_062_travel_and_movement_journey',
          category: 'travel_and_movement',
          subcategory: 'journey',
          title: 'Returning from Travel',
          arabic:
              'يُكَبِّرُ عَلَى كُلِّ شَرَفٍ ثَلاَثَ تَكْبِيرَاتٍ ثُمَّ يَقُولُ:\nلاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ،\nآيِبُونَ، تَائِبُونَ، عَابِدُونَ، لِرَبِّنا حَامِدُونَ،\nصَدَقَ اللَّهُ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزابَ وَحْدَهُ',
          transliteration:
              'Yukabbiru \'ala kulli sharafin thalatha takbirat thumma yaqul: La ilaha illa Allah wahdahu la sharika lah, lahu al-mulk, wa lahu al-hamd, wa Huwa \'ala kulli shay\'in Qadir. A\'ibuna, ta\'ibuna, \'abiduna, li Rabbina hamidun. Sadaqa Allahu wa\'dah, wa nasara \'abdah, wa hazama al-ahzaba wahdah.',
          translation:
              'From each elevated point, say Allahu Akbar three times, then recite: None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise, and He is over all things capable. We return repentant, worshipping, and praising our Lord. Allah fulfilled His promise, helped His servant, and alone defeated the confederates.',
          whenToSay:
              'When returning from travel, Hajj, or a major journey, especially from elevated ground.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 217; Al-Bukhari 7/163; Muslim 2/980.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'return', 'gratitude', 'tawbah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_063_travel_and_movement_weather',
          category: 'travel_and_movement',
          subcategory: 'weather',
          title: 'Strong Wind',
          arabic:
              'اللّهُـمَّ إِنَّـي أَسْـأَلُـكَ خَيْـرَها، وَخَيْـرَ ما فيهـا، وَخَيْـرَ ما اُرْسِلَـتْ بِه،\nوَأَعـوذُ بِكَ مِنْ شَـرِّها، وَشَـرِّ ما فيهـا، وَشَـرِّ ما اُرْسِلَـتْ بِه',
          transliteration:
              'Allahumma inni as\'aluka khayraha, wa khayra ma fiha, wa khayra ma ursilat bih, wa a\'udhu bika min sharriha, wa sharri ma fiha, wa sharri ma ursilat bih.',
          translation:
              'O Allah, I ask You for its good, the good within it, and the good it was sent with. I seek refuge in You from its evil, the evil within it, and the evil it was sent with.',
          whenToSay: 'When strong winds blow or storm winds arise.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 167; Muslim 2/616; Al-Bukhari 4/76.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['weather', 'wind', 'protection', 'travel'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_064_travel_and_movement_weather',
          category: 'travel_and_movement',
          subcategory: 'weather',
          title: 'Thunder',
          arabic:
              'سُبْـحانَ الّذي يُسَبِّـحُ الـرَّعْدُ بِحَمْـدِهِ، وَالملائِكـةُ مِنْ خيـفَته',
          transliteration:
              'Subhana alladhi yusabbihu ar-ra\'du bi hamdihi wa al-mala\'ikatu min khifatih.',
          translation:
              'Glory is to Him Whom thunder glorifies with praise, and the angels glorify out of fear of Him.',
          whenToSay: 'When hearing thunder.',
          sourceType: 'Athar',
          sourceRef:
              'Hisn al-Muslim 168; Al-Muwatta\' 2/992; statement of Ibn al-Zubayr graded authentic as an athar by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['weather', 'thunder', 'dhikr', 'remembrance'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_athar',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_065_travel_and_movement_weather',
          category: 'travel_and_movement',
          subcategory: 'weather',
          title: 'Rain Begins',
          arabic: 'اللّهُمَّ صَيِّـباً نافِـعاً',
          transliteration: 'Allahumma sayyiban nafi\'a.',
          translation: 'O Allah, bring beneficial rain.',
          whenToSay: 'When rain begins to fall.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 172; Al-Bukhari.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['weather', 'rain', 'mercy', 'gratitude'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_066_travel_and_movement_weather',
          category: 'travel_and_movement',
          subcategory: 'weather',
          title: 'After Rain',
          arabic: 'مُطِـرْنا بِفَضْـلِ اللهِ وَرَحْمَـتِه',
          transliteration: 'Mutirna bifadlillahi wa rahmatih.',
          translation:
              'We have been given rain by the grace and mercy of Allah.',
          whenToSay: 'After rainfall as a statement of gratitude.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 173; Al-Bukhari 1/205; Muslim 1/83.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['weather', 'rain', 'gratitude', 'dhikr'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_067_travel_and_movement_weather',
          category: 'travel_and_movement',
          subcategory: 'weather',
          title: 'When It Rains Too Much',
          arabic:
              'اللّهُمَّ حَوالَيْنا وَلا عَلَيْـنا، اللّهُمَّ عَلى الآكـامِ وَالظِّـراب، وَبُطـونِ الأوْدِية، وَمَنـابِتِ الشَّجـر',
          transliteration:
              'Allahumma hawalayna wa la \'alayna. Allahumma \'ala al-akami wa az-zirab, wa butuni al-awdiyati, wa manabit ash-shajar.',
          translation:
              'O Allah, let it fall around us and not upon us. O Allah, let it fall on the hills, the highlands, the valleys, and the places where trees grow.',
          whenToSay: 'When rainfall becomes excessive or harmful.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 174; Al-Bukhari 1/224; Muslim 1/614.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['weather', 'rain', 'hardship', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_068_travel_and_movement_location',
          category: 'travel_and_movement',
          subcategory: 'location',
          title: 'Entering a Marketplace',
          arabic:
              'لا إلهَ إلاّ اللّه وحدَهُ لا شريكَ لهُ، لهُ المُلْـكُ ولهُ الحَمْـد، يُحْيـي وَيُميـتُ وَهُوَ حَيٌّ لا يَمـوت، بِيَـدِهِ الْخَـيْرُ وَهوَ على كلّ شيءٍ قدير',
          transliteration:
              'La ilaha illallah wahdahu la sharika lah, lahu al-mulku wa lahu al-hamd, yuhyi wa yumit, wa huwa hayyun la yamut, biyadihi al-khayr, wa huwa \'ala kulli shay\'in Qadir.',
          translation:
              'None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise. He gives life and causes death, and He is Living and does not die. In His Hand is all good, and He is over all things capable.',
          whenToSay: 'When entering a marketplace or commercial setting.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 209; At-Tirmidhi 5/291; Al-Hakim 1/538; graded good by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['market', 'dhikr', 'tawhid', 'daily_life'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_069_travel_and_movement_location',
          category: 'travel_and_movement',
          subcategory: 'location',
          title: 'Entering a New Town',
          arabic:
              'أللّـهُمَّ رَبَّ السَّـمواتِ السّـبْعِ وَما أَظْلَلَـن، وَرَبَّ الأَراضيـنَ السّـبْعِ وَما أقْلَلْـن، وَرَبَّ الشَّيـاطينِ وَما أَضْلَلْـن، وَرَبَّ الرِّياحِ وَما ذَرَيْـن، أَسْـأَلُـكَ خَيْـرَ هذهِ الْقَـرْيَةِ وَخَيْـرَ أَهْلِـها، وَخَيْـرَ ما فيها، وَأَعـوذُ بِكَ مِنْ شَـرِّها وَشَـرِّ أَهْلِـها، وَشَـرِّ ما فيها',
          transliteration:
              'Allahumma Rabba as-samawati as-sab\'i wa ma azlaln, wa Rabba al-aradina as-sab\'i wa ma aqlaln, wa Rabb ash-shayatini wa ma adlaln, wa Rabba ar-riyahi wa ma dharayn. As\'aluka khayra hadhihi al-qaryah, wa khayra ahliha, wa khayra ma fiha, wa a\'udhu bika min sharriha, wa sharri ahliha, wa sharri ma fiha.',
          translation:
              'O Allah, Lord of the seven heavens and all they shade, Lord of the seven earths and all they carry, Lord of the devils and all they mislead, and Lord of the winds and all they scatter. I ask You for the good of this town, the good of its people, and the good in it. I seek refuge in You from its evil, the evil of its people, and the evil in it.',
          whenToSay: 'When entering a town, village, or unfamiliar place.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 208; Al-Hakim 2/100; Ibn as-Sunni 524; chain judged good/authentic by later scholars.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'location', 'town', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_070_travel_and_movement_location',
          category: 'travel_and_movement',
          subcategory: 'location',
          title: 'Stopping at a Place',
          arabic:
              'أَعـوذُ بِكَلِـماتِ اللّهِ التّـامّاتِ مِنْ شَـرِّ ما خَلَـق',
          transliteration:
              'A\'udhu bikalimati Allahi at-tammati min sharri ma khalaq.',
          translation:
              'I seek refuge in the Perfect Words of Allah from the evil of what He has created.',
          whenToSay:
              'When stopping, lodging, or settling in a place during travel or otherwise.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 216; Muslim 4/2080.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['travel', 'location', 'protection', 'lodging'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_071_situational_anxiety',
          category: 'situational',
          subcategory: 'anxiety',
          title: 'Worry and Sadness',
          arabic:
              'اللّهُـمَّ إِنِّي عَبْـدُكَ ابْنُ عَبْـدِكَ ابْنُ أَمَتِـكَ نَاصِيَتِي بِيَـدِكَ مَاضٍ فِيَّ حُكْمُكَ عَدْلٌ فِيَّ قَضَاؤكَ أَسْأَلُـكَ بِكُلِّ اسْمٍ هُوَ لَكَ سَمَّـيْتَ بِهِ نَفْسَكَ أِوْ أَنْزَلْتَـهُ فِي كِتَابِكَ أَوْ عَلَّمْـتَهُ أَحَداً مِنْ خَلْقِـكَ أَوِ اسْتَـأْثَرْتَ بِهِ فِي عِلْمِ الغَيْـبِ عِنْـدَكَ أَنْ تَجْـعَلَ القُرْآنَ رَبِيـعَ قَلْبِـي وَنُورَ صَـدْرِي وَجَلَاءَ حُـزْنِي وَذَهَابَ هَمِّـي',
          transliteration:
              'Allahumma inni \'abduk, ibnu \'abdik, ibnu amatika, nasiyati biyadik, madin fiyya hukmuk, \'adlun fiyya qada\'uk, as\'aluka bikulli ismin huwa lak, sammayta bihi nafsak, aw anzaltahu fi kitabik, aw \'allamtahu ahadan min khalqik, aw ista\'tharta bihi fi \'ilm al-ghaybi \'indak, an taj\'ala al-Qur\'ana rabi\'a qalbi, wa nura sadri, wa jala\'a huzni, wa dhahaba hammi.',
          translation:
              'O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your Hand. Your judgment over me is certain and Your decree about me is just. I ask You by every Name belonging to You, by which You named Yourself, revealed in Your Book, taught to any of Your creation, or kept with Yourself in the knowledge of the unseen, to make the Qur\'an the spring of my heart, the light of my chest, the banisher of my sadness, and the reliever of my distress.',
          whenToSay:
              'In times of worry, sadness, emotional heaviness, or distress.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 120; Ahmad 1/391; authenticated by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['anxiety', 'sadness', 'distress', 'quran'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_072_situational_debt',
          category: 'situational',
          subcategory: 'debt',
          title: 'Relief from Debt',
          arabic:
              'اللّهُـمَّ إِنِّي أَعْوذُ بِكَ مِنَ الهَـمِّ وَالْحُـزْنِ، والعًجْـزِ والكَسَلِ، والبُخْـلِ والجُـبْنِ، وضَلْـعِ الـدَّيْنِ وغَلَبَـةِ الرِّجال',
          transliteration:
              'Allahumma inni a\'udhu bika mina al-hammi wa al-huzn, wa al-\'ajzi wa al-kasal, wa al-bukhli wa al-jubn, wa dala\'i ad-dayn, wa ghalabati ar-rijal.',
          translation:
              'O Allah, I seek refuge in You from worry and grief, from weakness and laziness, from miserliness and cowardice, from being overwhelmed by debt, and from being overpowered by people.',
          whenToSay: 'When burdened by debt, pressure, or overwhelming worry.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 121; Al-Bukhari 7/158.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['debt', 'worry', 'pressure', 'hardship'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_073_situational_fear',
          category: 'situational',
          subcategory: 'fear',
          title: 'When Frightened',
          arabic: 'اللهُ اللهُ رَبِّي لا أُشْـرِكُ بِهِ شَيْـئاً',
          transliteration: 'Allahu Allahu Rabbi la ushriku bihi shay\'a.',
          translation:
              'Allah, Allah is my Lord. I do not associate anything with Him.',
          whenToSay: 'When suddenly frightened or shaken.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 125; Abu Dawud 2/87; authenticated by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['fear', 'fright', 'tawhid', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_074_situational_anger',
          category: 'situational',
          subcategory: 'anger',
          title: 'When Angry',
          arabic: 'أَعـوذُ بِاللهِ مِنَ الشَّيْـطانِ الرَّجيـم',
          transliteration: 'A\'udhu billahi min ash-shaytan ar-rajim.',
          translation: 'I seek refuge in Allah from Satan the outcast.',
          whenToSay: 'When anger rises and you need to calm yourself.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 193; Al-Bukhari 7/99; Muslim 4/2015.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['anger', 'self_control', 'shaytan', 'protection'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_075_situational_calamity',
          category: 'situational',
          subcategory: 'calamity',
          title: 'At the Time of a Calamity',
          arabic:
              'إِنّا للهِ وَإِنَا إِلَـيْهِ راجِعـون، اللهُـمِّ اْجُـرْني في مُصـيبَتي، وَاخْلُـفْ لي خَيْـراً مِنْـها',
          transliteration:
              'Inna lillahi wa inna ilayhi raji\'un, Allahumma\'jurni fi musibati wa akhluf li khayran minha.',
          translation:
              'Indeed we belong to Allah and to Him we return. O Allah, reward me in my affliction and replace it for me with something better.',
          whenToSay: 'At the time of a calamity, loss, or painful trial.',
          sourceType: 'Hadith / Qur\'anic phrase',
          sourceRef:
              'Hisn al-Muslim 154; Muslim 2/632; opening phrase from Qur\'an 2:156.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['calamity', 'loss', 'sabr', 'trial'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_076_situational_grief',
          category: 'situational',
          subcategory: 'grief',
          title: 'At Death or Loss',
          arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ',
          transliteration: 'Inna lillahi wa inna ilayhi raji\'un.',
          translation:
              'Indeed we belong to Allah, and indeed to Him we return.',
          whenToSay: 'When hearing of death, loss, or any painful affliction.',
          sourceType: 'Qur\'an / Sunnah usage',
          sourceRef:
              'Qur\'an 2:156; also recited in Hisn al-Muslim 154 / Muslim 2/632.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['grief', 'death', 'loss', 'sabr'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_077_situational_illness',
          category: 'situational',
          subcategory: 'illness',
          title: 'Visiting the Sick',
          arabic:
              'أَسْـأَلُ اللهَ العَـظيـم، رَبَّ العَـرْشِ العَـظيـم أَنْ يَشْفـيك',
          transliteration:
              'As\'alullaha al-\'Azima Rabba al-\'Arsh al-\'Azimi an yashfiyak.',
          translation:
              'I ask Allah the Magnificent, Lord of the Magnificent Throne, to heal you.',
          whenToSay:
              'When visiting someone who is ill; traditionally recited seven times.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 148; At-Tirmidhi; Abu Dawud; also Riyad as-Salihin 906.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['illness', 'visiting_sick', 'healing', 'care'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_078_situational_illness',
          category: 'situational',
          subcategory: 'illness',
          title: 'For Pain in the Body',
          arabic:
              'ضَعْ يَدَكَ عَلَى الَّذِي تَألَّمَ مِنْ جَسَدِكَ وَقُلْ: "بِسْمِ اللَّهِ" ثَلاَثاً، وَقُلْ سَبْعَ مَرَّاتٍ: "أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ"',
          transliteration:
              'Da\' yadaka \'ala alladhi ta\'allama min jasadika wa qul: Bismillah, thalathan. Wa qul sab\'a marrat: A\'udhu billahi wa qudratihi min sharri ma ajidu wa uhadhir.',
          translation:
              'Place your hand on the part of your body in pain and say Bismillah three times. Then say seven times: I seek refuge in Allah and in His power from the evil of what I feel and what I fear.',
          whenToSay: 'When you feel pain in any part of the body.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 243; Muslim 4/1728.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['illness', 'pain', 'healing', 'ruqyah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_079_situational_illness',
          category: 'situational',
          subcategory: 'illness',
          title: 'Ruqyah for Illness',
          arabic:
              'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَأْسَ، وَاشْفِ، أَنْتَ الشَّافِي، لاَ شِفَاءَ إِلاَّ شِفَاؤُكَ، شِفَاءً لاَ يُغَادِرُ سَقَماً',
          transliteration:
              'Allahumma Rabba an-nas, adhhib al-ba\'s, washfi, Anta ash-Shafi, la shifa\'a illa shifa\'uk, shifa\'an la yughadiru saqaman.',
          translation:
              'O Allah, Lord of mankind, remove the harm and heal. You are the Healer. There is no healing except Your healing, a healing that leaves no sickness behind.',
          whenToSay:
              'As ruqyah for illness when making dua for yourself or another sick person.',
          sourceType: 'Hadith',
          sourceRef:
              'Riyad as-Salihin 902; Al-Bukhari and Muslim. Also parallel meaning in Riyad as-Salihin 903.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['illness', 'ruqyah', 'healing', 'dua_for_others'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_080_situational_oppression',
          category: 'situational',
          subcategory: 'oppression',
          title: 'Against Oppression',
          arabic:
              'اللّهُـمَّ إِنا نَجْـعَلُكَ في نُحـورِهِـم، وَنَعـوذُ بِكَ مِنْ شُرورِهـمْ',
          transliteration:
              'Allahumma inna naj\'aluka fi nuhurihim, wa na\'udhu bika min shururihim.',
          translation:
              'O Allah, we place You before them and seek refuge in You from their evil.',
          whenToSay: 'When facing oppression, threat, or hostile people.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 126; Abu Dawud 2/89; authenticated by al-Hakim and agreed to by adh-Dhahabi.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['oppression', 'enemy', 'protection', 'fear'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_081_situational_need',
          category: 'situational',
          subcategory: 'need',
          title: 'Entrusting All Affairs to Allah',
          arabic:
              'اللّهُـمَّ رَحْمَتَـكَ أَرْجـو فَلا تَكِلـني إِلى نَفْـسي طَـرْفَةَ عَـيْن، وَأَصْلِـحْ لي شَأْنـي كُلَّـه لَا إِلَهَ إِلَّا أنْـت',
          transliteration:
              'Allahumma rahmataka arju fala takilni ila nafsi tarfata \'ayn, wa aslih li sha\'ni kullah, la ilaha illa Ant.',
          translation:
              'O Allah, I hope for Your mercy. Do not leave me to myself for even the blink of an eye. Set right all of my affairs. There is none worthy of worship but You.',
          whenToSay:
              'When feeling needy, overwhelmed, dependent, or unable to manage your affairs.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 123; Abu Dawud 4/324; Ahmad 5/42; graded good by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['need', 'dependence', 'mercy', 'reliance'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_082_situational_confusion',
          category: 'situational',
          subcategory: 'confusion',
          title: 'When Troubled by Doubt or Confusion',
          arabic: 'أَعُوذُ بِاللَّهِ\nآمَنْتُ بِاللَّهِ وَرُسُلِهِ',
          transliteration: 'A\'udhu billah.\nAmantu billahi wa Rusulih.',
          translation:
              'I seek refuge in Allah.\nI believe in Allah and His Messengers.',
          whenToSay:
              'When plagued by disturbing doubts or confusing whispers, then stop following the doubtful thought.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 133-134; Al-Bukhari; Muslim 1/119-120.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['confusion', 'doubt', 'waswas', 'faith'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_083_situational_distress',
          category: 'situational',
          subcategory: 'distress',
          title: 'Yunus Dua',
          arabic:
              'لَا إِلَهَ إِلَّا أنْـت سُـبْحانَكَ إِنِّي كُنْـتُ مِنَ الظّـالِميـن',
          transliteration:
              'La ilaha illa Anta subhanaka inni kuntu min az-zalimin.',
          translation:
              'There is none worthy of worship but You. Glory is to You. Indeed, I was among the wrongdoers.',
          whenToSay: 'In distress, hardship, repentance, and desperate need.',
          sourceType: 'Hadith / Qur\'anic dua',
          sourceRef:
              'Hisn al-Muslim 124; At-Tirmidhi 5/529; Qur\'an 21:87 wording.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['distress', 'repentance', 'yunus', 'relief'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_084_situational_sin',
          category: 'situational',
          subcategory: 'sin',
          title: 'Repentance and Seeking Forgiveness',
          arabic:
              'أَسْتَغْفِرُ اللَّهَ الْعَظيمَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ القَيّوُمُ وَأَتُوبُ إِلَيهِ',
          transliteration:
              'Astaghfirullaha al-\'Azim alladhi la ilaha illa huwa al-Hayy al-Qayyum wa atubu ilayh.',
          translation:
              'I seek the forgiveness of Allah the Magnificent, besides Whom there is none worthy of worship, the Ever-Living, the Sustainer, and I repent to Him.',
          whenToSay:
              'For repentance after sin and in a state of seeking forgiveness.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 250; Abu Dawud 2/85; At-Tirmidhi 5/569; authenticated by al-Hakim and al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['repentance', 'forgiveness', 'sin', 'istighfar'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_085_situational_trial',
          category: 'situational',
          subcategory: 'trial',
          title: 'Relief in Severe Distress',
          arabic:
              'لَا إلَهَ إِلَّا اللَّهُ الْعَظـيمُ الْحَلِـيمْ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ العَـرْشِ العَظِيـمِ، لَا إِلَـهَ إِلَّا اللَّهْ رَبُّ السَّمَـوّاتِ ورّبُّ الأَرْضِ ورَبُّ العَرْشِ الكَـريم',
          transliteration:
              'La ilaha illallah al-\'Azimul-Halim, la ilaha illallah Rabbu al-\'Arsh al-\'Azim, la ilaha illallah Rabbu as-samawati wa Rabbu al-ard wa Rabbu al-\'Arsh al-Karim.',
          translation:
              'There is none worthy of worship but Allah, the Magnificent, the Forbearing. There is none worthy of worship but Allah, Lord of the Magnificent Throne. There is none worthy of worship but Allah, Lord of the heavens, Lord of the earth, and Lord of the Noble Throne.',
          whenToSay: 'In severe distress, trial, and overwhelming hardship.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 122; Al-Bukhari 8/154; Muslim 4/2092.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['trial', 'distress', 'hardship', 'tawhid'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_086_situational_envy',
          category: 'situational',
          subcategory: 'envy',
          title: 'Protection from Envy',
          arabic:
              'بِسْمِ اللهِ أَرْقِيكَ، مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، وَمِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنِ حَاسِدٍ، اللهُ يَشْفِيكَ، بِسْمِ اللهِ أَرْقِيكَ',
          transliteration:
              'Bismillahi arqika, min kulli shay\'in yu\'dhika, wa min sharri kulli nafsin aw \'ayni hasidin, Allahu yashfika, bismillahi arqika.',
          translation:
              'In the Name of Allah, I perform ruqyah for you from everything harming you, and from the evil of every soul or envious eye. May Allah heal you. In the Name of Allah, I perform ruqyah for you.',
          whenToSay:
              'As ruqyah for harm connected to envy, the evil eye, or unseen harm.',
          sourceType: 'Hadith',
          sourceRef: 'Riyad as-Salihin 908; Muslim.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['envy', 'evil_eye', 'ruqyah', 'healing'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_087_situational_evil_eye',
          category: 'situational',
          subcategory: 'evil_eye',
          title: 'When You Fear Giving the Evil Eye',
          arabic:
              'إِذَا رَأَى أَحَدُكُم مِنْ أَخِيهِ، أَوْ مِنْ نَفْسِهِ، أَوْ مِنْ مَالِهِ مَا يُعْجِبُهُ فَلْيَدْعُ لَهُ بِالْبَرَكَةِ فَإِنَّ الْعَيْنَ حَقٌّ',
          transliteration:
              'Idha ra\'a ahadukum min akhihi, aw min nafsihi, aw min malihi ma yu\'jibuhu falyad\'u lahu bil-barakah fa inna al-\'ayna haqq.',
          translation:
              'If one of you sees something in his brother, himself, or his wealth that impresses him, then let him ask for blessing for it, for the evil eye is true.',
          whenToSay:
              'When you admire something and fear harming it with the evil eye; ask Allah to bless it.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 244; Ahmad 4/447; Ibn Majah; Malik; authenticated by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['evil_eye', 'barakah', 'protection', 'adab'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_088_situational_fear',
          category: 'situational',
          subcategory: 'fear',
          title: 'When Feeling Unsafe',
          arabic: 'اللَّهُمَّ اكْفِنِيهِم بمَا شِئْت',
          transliteration: 'Allahummakfinihim bima shi\'t.',
          translation: 'O Allah, suffice me against them however You will.',
          whenToSay:
              'When you feel unsafe, threatened, or afraid of harmful people.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 132; Muslim 4/2300.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['fear', 'unsafe', 'protection', 'security'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_089_situational_need',
          category: 'situational',
          subcategory: 'need',
          title: 'Asking for Beneficial Sustenance',
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً، وَرِزْقاً طَيِّباً، وَعَمَلاً مُتَقَبَّلاً',
          transliteration:
              'Allahumma inni as\'aluka \'ilman nafi\'a, wa rizqan tayyiban, wa \'amalan mutaqabbalan.',
          translation:
              'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
          whenToSay:
              'In the morning and whenever asking Allah for beneficial livelihood and accepted effort.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 95; Ibn Majah 925; Ibn as-Sunni 54; chain graded good.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['rizq', 'knowledge', 'deeds', 'morning'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_090_situational_rizq',
          category: 'situational',
          subcategory: 'rizq',
          title: 'For Lawful Provision',
          arabic:
              'اللّهُـمَّ اكْفِـني بِحَلالِـكَ عَنْ حَـرامِـك، وَأَغْنِـني بِفَضْـلِكَ عَمَّـنْ سِـواك',
          transliteration:
              'Allahummak-fini bihalalika \'an haramik, wa aghnini bifadlika \'amman siwak.',
          translation:
              'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and enrich me by Your bounty from need of anyone besides You.',
          whenToSay:
              'When asking Allah for halal provision and freedom from dependence on others.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 136; At-Tirmidhi 5/560; authenticated by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['rizq', 'halal', 'provision', 'independence'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_091_special_days_ramadan',
          category: 'special_days',
          subcategory: 'ramadan',
          title: 'At Iftar',
          arabic:
              'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ العُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ',
          transliteration:
              'Dhahaba al-zama’u wabtallati al-‘urooqu wa thabata al-ajru in sha’ Allah',
          translation:
              'The thirst is gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
          whenToSay:
              'When breaking the fast at sunset after the fasting day has ended.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 2357',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['ramadan', 'fasting', 'iftar', 'sunnah'],
          audioKey: 'iftar_dhikr.mp3',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_092_special_days_ramadan',
          category: 'special_days',
          subcategory: 'ramadan',
          title: 'Before Fajr on a Fast Day',
          arabic: '',
          transliteration: '',
          translation:
              'There is no fixed authenticated spoken dua established here. Form the intention for the fast in your heart before Fajr.',
          whenToSay:
              'Before Fajr when beginning a fast. The intention is held in the heart, not tied to a required spoken formula.',
          sourceType: 'sunnah',
          sourceRef:
              'Sahih al-Bukhari 1; Sahih Muslim 1907 (actions are by intentions)',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['ramadan', 'fasting', 'intention', 'fajr'],
          audioKey: '',
          isCore: true,
          verificationStatus: 'core_verified',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_093_special_days_ramadan',
          category: 'special_days',
          subcategory: 'ramadan',
          title: 'Last Ten Nights: Ask for Pardon',
          arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
          transliteration:
              'Allahumma innaka \'afuwwun tuhibbul-\'afwa fa\'fu \'anni',
          translation:
              'O Allah, You are Pardoning and You love pardon, so pardon me.',
          whenToSay:
              'Especially in the last ten nights of Ramadan and as Ramadan draws to a close.',
          sourceType: 'Hadith',
          sourceRef: 'Sunan Ibn Majah 3850; Riyad as-Salihin 1195.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>[
            'ramadan',
            'last_ten_nights',
            'forgiveness',
            'laylatul_qadr',
          ],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_094_special_days_eid',
          category: 'special_days',
          subcategory: 'eid',
          title: 'Eid Greeting',
          arabic: 'تَقَبَّلَ اللَّهُ مِنَّا وَمِنْكُمْ',
          transliteration: 'Taqabbal Allahu minna wa minkum.',
          translation: 'May Allah accept from us and from you.',
          whenToSay:
              'As a greeting and dua when meeting others on Eid after the prayer and throughout the day.',
          sourceType: 'Companion practice',
          sourceRef:
              'Companion-era Eid greeting reported from Jubayr ibn Nufayr; see scholarly summaries of the narration and its acceptance among the early Muslims.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['eid', 'greeting', 'dua', 'community'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_secondary',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_095_special_days_eid',
          category: 'special_days',
          subcategory: 'eid',
          title: 'Takbirat of Eid',
          arabic:
              'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، لَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، وَلِلَّهِ الْحَمْدُ',
          transliteration:
              'Allahu Akbar, Allahu Akbar, la ilaha illa Allah, wa Allahu Akbar, Allahu Akbar, wa lillahi al-hamd.',
          translation:
              'Allah is the Greatest, Allah is the Greatest. There is none worthy of worship but Allah. Allah is the Greatest, Allah is the Greatest, and all praise belongs to Allah.',
          whenToSay:
              'On Eid and during the Eid season as part of the takbir widely practiced by the early Muslims.',
          sourceType: 'Early Muslim practice',
          sourceRef:
              'Widely used takbir formula preserved in early scholarly practice; see IslamQA 36627 on established Eid and Dhul-Hijjah forms.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['eid', 'takbir', 'dhikr', 'special_days'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_secondary',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_096_special_days_arafah',
          category: 'special_days',
          subcategory: 'arafah',
          title: 'Dua of the Day of Arafah',
          arabic:
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          transliteration:
              'La ilaha illallahu wahdahu la sharika lah, lahu al-mulku wa lahu al-hamd, wa huwa \'ala kulli shay\'in qadir.',
          translation:
              'There is none worthy of worship but Allah alone, with no partner. His is the dominion and His is the praise, and He is over all things capable.',
          whenToSay:
              'Frequently on the Day of Arafah, together with abundant personal dua.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 237; At-Tirmidhi; graded good by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['arafah', 'tawhid', 'dhikr', 'dhul_hijjah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_097_special_days_dhul_hijjah',
          category: 'special_days',
          subcategory: 'dhul_hijjah',
          title: 'Takbir in the First Ten Days of Dhul-Hijjah',
          arabic:
              'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، لَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، وَلِلَّهِ الْحَمْدُ',
          transliteration:
              'Allahu Akbar, Allahu Akbar, la ilaha illa Allah, wa Allahu Akbar, Allahu Akbar, wa lillahi al-hamd.',
          translation:
              'Allah is the Greatest, Allah is the Greatest. There is none worthy of worship but Allah. Allah is the Greatest, Allah is the Greatest, and all praise belongs to Allah.',
          whenToSay:
              'Throughout the first ten days of Dhul-Hijjah and the days of Tashriq as unrestricted takbir.',
          sourceType: 'Early Muslim practice',
          sourceRef:
              'Established Dhul-Hijjah takbir forms summarized by scholars; see IslamQA 36627 on unrestricted and restricted takbir formulas.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['dhul_hijjah', 'takbir', 'dhikr', 'special_days'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_secondary',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_098_special_days_new_moon',
          category: 'special_days',
          subcategory: 'new_moon',
          title: 'Seeing the New Moon',
          arabic:
              'اللهُ أَكْـبَر، اللّهُمَّ أَهِلَّـهُ عَلَيْـنا بِالأمْـنِ وَالإيمـان، وَالسَّلامَـةِ وَالإسْلام، وَالتَّـوْفيـقِ لِما تُحِـبُّ رَبَّنـا وَتَـرْضـى، رَبُّنـا وَرَبُّكَ الله',
          transliteration:
              'Allahu Akbar. Allahumma ahillahu \'alayna bil-amni wal-iman, was-salamati wal-Islam, wat-tawfiqi lima tuhibbu Rabbana wa tarda, Rabbuna wa Rabbuk Allah.',
          translation:
              'Allah is the Greatest. O Allah, bring it over us with security and faith, with safety and Islam, and with success in what You love and are pleased with. Our Lord and your Lord is Allah.',
          whenToSay: 'Upon sighting the new moon.',
          sourceType: 'Hadith',
          sourceRef: 'Hisn al-Muslim 175; At-Tirmidhi 5/504; Ad-Darimi 1/336.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['new_moon', 'dhikr', 'faith', 'special_days'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_099_special_days_rain',
          category: 'special_days',
          subcategory: 'rain',
          title: 'Salah for Rain',
          arabic:
              'اللّهُمَّ اسْقِـنا غَيْـثاً مُغيـثاً مَريئاً مُريـعاً، نافِعـاً غَيْـرَ ضار، عاجِـلاً غَـيْرَ آجِل',
          transliteration:
              'Allahumma isqina ghaythan mughithan mari\'an muri\'an, nafi\'an ghayra darr, \'ajilan ghayra ajil.',
          translation:
              'O Allah, send us abundant rain, relieving, wholesome, nourishing, beneficial and not harmful, swift and not delayed.',
          whenToSay:
              'When asking Allah for rain, including during the prayer for rain and times of drought.',
          sourceType: 'Hadith',
          sourceRef:
              'Hisn al-Muslim 169; Abu Dawud 1/303; authenticated by al-Albani.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['rain', 'istisqa', 'special_days', 'mercy'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_100_special_days_eclipse',
          category: 'special_days',
          subcategory: 'eclipse',
          title: 'During an Eclipse',
          arabic: '',
          transliteration: '',
          translation:
              'There is no single fixed short spoken dua established here. During an eclipse, turn to Allah with prayer, takbir, dua, charity, and seeking forgiveness until it passes.',
          whenToSay:
              'When a solar or lunar eclipse occurs. Pray the eclipse prayer and increase remembrance, dua, and istighfar.',
          sourceType: 'Hadith guidance',
          sourceRef:
              'Sahih Muslim 901a, 914, and 915; the Prophet instructed prayer, takbir, dua, charity, and seeking forgiveness during an eclipse.',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['eclipse', 'prayer', 'dua', 'istighfar'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_101_forgiveness_and_growth_istighfar',
          category: 'forgiveness_and_growth',
          subcategory: 'istighfar',
          title: 'Forgive Me and Accept My Repentance',
          arabic:
              'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
          transliteration:
              'Rabbighfir li wa tub \'alayya innaka anta al-Tawwab al-Rahim.',
          translation:
              'My Lord, forgive me and accept my repentance. Indeed, You are the Accepter of repentance, the Merciful.',
          whenToSay:
              'Frequently in a sitting and throughout the day when seeking repentance and mercy.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 1516; Jami\' at-Tirmidhi 3434',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['istighfar', 'repentance', 'forgiveness', 'mercy'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_102_forgiveness_and_growth_istighfar',
          category: 'forgiveness_and_growth',
          subcategory: 'istighfar',
          title: 'Sayyid al-Istighfar Full',
          arabic:
              'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
          transliteration:
              'Allahumma anta Rabbi la ilaha illa ant, khalaqtani wa ana \'abduk, wa ana \'ala \'ahdika wa wa\'dika mastata\'t, a\'udhu bika min sharri ma sana\'t, abu\'u laka bini\'matika \'alayya, wa abu\'u bidhanbi faghfir li, fa innahu la yaghfiru al-dhunuba illa ant.',
          translation:
              'O Allah, You are my Lord. There is no god worthy of worship except You. You created me and I am Your servant, and I remain upon Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge before You Your favor upon me, and I acknowledge my sin, so forgive me, for none forgives sins except You.',
          whenToSay:
              'In the morning and evening as the chief supplication for seeking forgiveness.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6306',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['istighfar', 'repentance', 'morning', 'evening'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_103_forgiveness_and_growth_gratitude',
          category: 'forgiveness_and_growth',
          subcategory: 'gratitude',
          title: 'Comprehensive Gratitude Dua',
          arabic:
              'اللَّهُمَّ أَعِنِّي عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          transliteration:
              'Allahumma a\'inni \'ala dhikrika wa shukrika wa husni \'ibadatika.',
          translation:
              'O Allah, help me to remember You, thank You, and worship You beautifully.',
          whenToSay:
              'After salah and whenever asking Allah for gratitude, remembrance, and better worship.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 1522; Sunan an-Nasa\'i 1303',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['gratitude', 'dhikr', 'worship', 'salah'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_104_forgiveness_and_growth_guidance',
          category: 'forgiveness_and_growth',
          subcategory: 'guidance',
          title: 'Guidance and Uprightness',
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَىٰ وَالتُّقَىٰ وَالْعَفَافَ وَالْغِنَىٰ',
          transliteration:
              'Allahumma inni as\'aluka al-huda wa al-tuqa wa al-\'afafa wa al-ghina.',
          translation:
              'O Allah, I ask You for guidance, God-consciousness, chastity, and self-sufficiency.',
          whenToSay:
              'As a general dua for uprightness, taqwa, and inward and outward steadiness.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 2721',
          difficulty: DuaDifficulty.beginner,
          tags: <String>[
            'guidance',
            'taqwa',
            'uprightness',
            'self_sufficiency',
          ],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_105_forgiveness_and_growth_light',
          category: 'forgiveness_and_growth',
          subcategory: 'light',
          title: 'Light in Heart, Hearing, and Sight',
          arabic:
              'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي لِسَانِي نُورًا، وَفِي سَمْعِي نُورًا، وَفِي بَصَرِي نُورًا، وَمِنْ فَوْقِي نُورًا، وَمِنْ تَحْتِي نُورًا، وَعَنْ يَمِينِي نُورًا، وَعَنْ شِمَالِي نُورًا، وَمِنْ أَمَامِي نُورًا، وَمِنْ خَلْفِي نُورًا، وَاجْعَلْ لِي نُورًا',
          transliteration:
              'Allahummaj\'al fi qalbi nuran, wa fi lisani nuran, wa fi sam\'i nuran, wa fi basari nuran, wa min fawqi nuran, wa min tahti nuran, wa \'an yamini nuran, wa \'an shimali nuran, wa min amami nuran, wa min khalfi nuran, waj\'al li nuran.',
          translation:
              'O Allah, place light in my heart, light on my tongue, light in my hearing, and light in my sight. Place light above me, light below me, light on my right, light on my left, light in front of me, light behind me, and grant me light.',
          whenToSay:
              'In night prayer, before going out, and generally when asking Allah for inner and outer light.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 763',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['light', 'heart', 'guidance', 'clarity'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_106_forgiveness_and_growth_faith',
          category: 'forgiveness_and_growth',
          subcategory: 'faith',
          title: 'Firmness upon the Religion',
          arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَىٰ دِينِكَ',
          transliteration: 'Ya Muqallibal-qulub, thabbit qalbi \'ala dinik.',
          translation:
              'O Turner of the hearts, keep my heart firm upon Your religion.',
          whenToSay:
              'Often, especially when asking Allah for steadfastness in faith.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 2140',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['faith', 'steadfastness', 'hearts', 'religion'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_107_forgiveness_and_growth_character',
          category: 'forgiveness_and_growth',
          subcategory: 'character',
          title: 'Good Character',
          arabic:
              'اللَّهُمَّ اهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ، لَا يَهْدِي لِأَحْسَنِهَا إِلَّا أَنْتَ، وَاصْرِفْ عَنِّي سَيِّئَهَا، لَا يَصْرِفُ عَنِّي سَيِّئَهَا إِلَّا أَنْتَ',
          transliteration:
              'Allahumma ihdini li-ahsani al-akhlaq, la yahdi li-ahsaniha illa ant, wasrif \'anni sayyi\'aha, la yasrifu \'anni sayyi\'aha illa ant.',
          translation:
              'O Allah, guide me to the best character, for none guides to the best of it except You. Turn away bad character from me, for none can turn it away from me except You.',
          whenToSay:
              'When asking Allah to beautify character and turn away blameworthy conduct.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih Muslim 771',
          difficulty: DuaDifficulty.beginner,
          tags: <String>[
            'character',
            'akhlaq',
            'guidance',
            'self_purification',
          ],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_108_forgiveness_and_growth_knowledge',
          category: 'forgiveness_and_growth',
          subcategory: 'knowledge',
          title: 'Beneficial Knowledge',
          arabic:
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
          transliteration:
              'Allahumma inni as\'aluka \'ilman nafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbalan.',
          translation:
              'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
          whenToSay:
              'After Fajr and whenever asking Allah for knowledge that benefits and work that bears fruit.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Ibn Majah 925',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['knowledge', 'benefit', 'morning', 'growth'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_109_forgiveness_and_growth_rizq',
          category: 'forgiveness_and_growth',
          subcategory: 'rizq',
          title: 'Beneficial Provision',
          arabic:
              'اللّهُـمَّ اكْفِـني بِحَلالِـكَ عَنْ حَـرامِـك، وَأَغْنِـني بِفَضْـلِكَ عَمَّـنْ سِـواك',
          transliteration:
              'Allahummak-fini bihalalika \'an haramik, wa aghnini bifadlika \'amman siwak.',
          translation:
              'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and enrich me by Your bounty from need of anyone besides You.',
          whenToSay:
              'When asking Allah for halal provision, independence, and freedom from blameworthy need.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3563',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['rizq', 'halal', 'provision', 'independence'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_110_forgiveness_and_growth_deeds',
          category: 'forgiveness_and_growth',
          subcategory: 'deeds',
          title: 'Acceptance of Deeds',
          arabic:
              'رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ',
          transliteration:
              'Rabbana taqabbal minna innaka anta al-Sami\' al-\'Alim.',
          translation:
              'Our Lord, accept from us. Indeed, You are the All-Hearing, the All-Knowing.',
          whenToSay:
              'After worship, charity, effort, and whenever asking Allah to accept a deed.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:127',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['deeds', 'acceptance', 'worship', 'quran'],
          audioKey: '',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_111_quran_2_127_128',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Accept from Us and Make Us Submissive',
          arabic:
              'رَبَّنَا تَقَبَّلْ مِنَّآ ۖ إِنَّكَ أَنتَ ٱلسَّمِيعُ ٱلْعَلِيمُ رَبَّنَا وَٱجْعَلْنَا مُسْلِمَيْنِ لَكَ وَمِن ذُرِّيَّتِنَآ أُمَّةً مُّسْلِمَةً لَّكَ وَأَرِنَا مَنَاسِكَنَا وَتُبْ عَلَيْنَآ ۖ إِنَّكَ أَنتَ ٱلتَّوَّابُ ٱلرَّحِيمُ',
          transliteration:
              'Rabbana taqabbal minna innaka anta al-Sami\' al-\'Alim. Rabbana waj\'alna muslimayni laka wa min dhurriyyatina ummatan muslimatan laka wa arina manasikana wa tub \'alayna innaka anta al-Tawwab al-Rahim.',
          translation:
              'Our Lord, accept from us. Indeed, You are the Hearing, the Knowing. Our Lord, make us submissive to You, and from our descendants a nation submissive to You. Show us our rites and accept our repentance. Indeed, You are the Accepter of repentance, the Merciful.',
          whenToSay:
              'General dua for accepted worship, submission, and righteous descendants.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 2:127-128',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'acceptance', 'submission', 'family'],
          audioKey: 'quran_002_127_128_accept_from_us_make_us_submissive.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_112_quran_3_9',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Gather Us on the Day Without Doubt',
          arabic:
              'رَبَّنَآ إِنَّكَ جَامِعُ ٱلنَّاسِ لِيَوْمٍ لَّا رَيْبَ فِيهِ ۚ إِنَّ ٱللَّهَ لَا يُخْلِفُ ٱلْمِيعَادَ',
          transliteration:
              'Rabbana innaka jami\'u al-nasi li-yawmin la rayba fihi inna Allaha la yukhlifu al-mi\'ad.',
          translation:
              'Our Lord, surely You will gather the people for a Day about which there is no doubt. Indeed, Allah does not fail in His promise.',
          whenToSay:
              'When remembering the Last Day and asking for steadiness upon truth.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:9',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'hereafter', 'certainty'],
          audioKey: 'quran_003_009_gather_us_on_the_day_without_doubt.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_113_quran_3_53',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Register Us Among the Witnesses',
          arabic:
              'رَبَّنَآ ءَامَنَّا بِمَآ أَنزَلْتَ وَٱتَّبَعْنَا ٱلرَّسُولَ فَٱكْتُبْنَا مَعَ ٱلشَّـٰهِدِينَ',
          transliteration:
              'Rabbana amanna bima anzalta wa ittaba\'na al-rasula faktubna ma\'a al-shahidin.',
          translation:
              'Our Lord, we have believed in what You revealed and have followed the messenger, so register us among the witnesses to truth.',
          whenToSay:
              'When renewing faith in revelation and asking to be counted among the truthful.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:53',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'faith', 'truth'],
          audioKey: 'quran_003_053_register_us_among_the_witnesses.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_114_quran_3_147',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive Us, Make Our Feet Firm',
          arabic:
              'رَبَّنَا ٱغْفِرْ لَنَا ذُنُوبَنَا وَإِسْرَافَنَا فِىٓ أَمْرِنَا وَثَبِّتْ أَقْدَامَنَا وَٱنصُرْنَا عَلَى ٱلْقَوْمِ ٱلْكَـٰفِرِينَ',
          transliteration:
              'Rabbana ighfir lana dhunubana wa israfana fi amrina wa thabbit aqdamana wa ansurna \'ala al-qawmi al-kafirin.',
          translation:
              'Our Lord, forgive us our sins and our excess in our affairs, make our feet firm, and give us victory over the disbelieving people.',
          whenToSay:
              'During hardship, struggle, and when asking for forgiveness and steadfastness.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 3:147',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'forgiveness', 'steadfastness', 'victory'],
          audioKey: 'quran_003_147_forgive_us_make_our_feet_firm.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_115_quran_5_114',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Send Down Provision and Blessing',
          arabic:
              'ٱللَّهُمَّ رَبَّنَآ أَنزِلْ عَلَيْنَا مَآئِدَةً مِّنَ ٱلسَّمَآءِ تَكُونُ لَنَا عِيدًا لِّأَوَّلِنَا وَءَاخِرِنَا وَءَايَةً مِّنكَ ۖ وَٱرْزُقْنَا وَأَنتَ خَيْرُ ٱلرَّٰزِقِينَ',
          transliteration:
              'Allahumma Rabbana anzil \'alayna ma\'idatan mina al-sama\'i takunu lana \'idan li-awwalina wa akhirina wa ayatan minka warzuqna wa anta khayru al-raziqin.',
          translation:
              'O Allah, our Lord, send down to us a table from heaven to be for us a festival for the first of us and the last of us and a sign from You. Provide for us, for You are the best of providers.',
          whenToSay:
              'When asking Allah for provision, blessing, and a clear sign of His mercy.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 5:114',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'provision', 'gratitude'],
          audioKey: 'quran_005_114_send_down_provision_and_blessing.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_116_quran_10_85_86',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Do Not Make Us a Trial and Save Us',
          arabic:
              'رَبَّنَا لَا تَجْعَلْنَا فِتْنَةً لِّلْقَوْمِ ٱلظَّـٰلِمِينَ وَنَجِّنَا بِرَحْمَتِكَ مِنَ ٱلْقَوْمِ ٱلْكَـٰفِرِينَ',
          transliteration:
              'Rabbana la taj\'alna fitnatan lil-qawmi al-zalimin. Wa najjina bi-rahmatika mina al-qawmi al-kafirin.',
          translation:
              'Our Lord, do not make us a trial for the wrongdoing people. Save us by Your mercy from the disbelieving people.',
          whenToSay:
              'When facing oppression and asking Allah for protection and rescue.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 10:85-86',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'protection', 'oppression', 'mercy'],
          audioKey: 'quran_010_085_086_do_not_make_us_a_trial_and_save_us.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_117_quran_12_101',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Cause Me to Die a Muslim',
          arabic:
              'رَبِّ قَدْ ءَاتَيْتَنِى مِنَ ٱلْمُلْكِ وَعَلَّمْتَنِى مِن تَأْوِيلِ ٱلْأَحَادِيثِ ۚ فَاطِرَ ٱلسَّمَـٰوَٰتِ وَٱلْأَرْضِ أَنتَ وَلِىِّۦ فِى ٱلدُّنْيَا وَٱلْـَٔاخِرَةِ ۖ تَوَفَّنِى مُسْلِمًا وَأَلْحِقْنِى بِٱلصَّـٰلِحِينَ',
          transliteration:
              'Rabbi qad ataytani mina al-mulki wa \'allamtani min ta\'wili al-ahadithi fatira al-samawati wa al-ardi anta waliyyi fi al-dunya wa al-akhirati tawaffani musliman wa alhiqni bi al-salihin.',
          translation:
              'My Lord, You have given me some sovereignty and taught me the interpretation of matters. Creator of the heavens and the earth, You are my protector in this world and the Hereafter. Cause me to die a Muslim and join me with the righteous.',
          whenToSay:
              'For gratitude, a good ending, and companionship with the righteous.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 12:101',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'good_ending', 'gratitude', 'righteous'],
          audioKey: 'quran_012_101_cause_me_to_die_a_muslim.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_118_quran_14_35',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Make This Land Secure',
          arabic:
              'رَبِّ ٱجْعَلْ هَـٰذَا ٱلْبَلَدَ ءَامِنًا وَٱجْنُبْنِى وَبَنِىَّ أَن نَّعْبُدَ ٱلْأَصْنَامَ',
          transliteration:
              'Rabbi ij\'al hadha al-balada aminan wa ujnubni wa baniyya an na\'buda al-asnam.',
          translation:
              'My Lord, make this land secure and keep me and my children away from worshipping idols.',
          whenToSay:
              'For safety, tawhid, and protection from shirk for oneself and one\'s family.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 14:35',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'safety', 'tawhid', 'family'],
          audioKey: 'quran_014_035_make_this_land_secure.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_119_quran_20_25_28',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Expand My Chest and Ease My Task',
          arabic:
              'رَبِّ ٱشْرَحْ لِى صَدْرِى وَيَسِّرْ لِىٓ أَمْرِى وَٱحْلُلْ عُقْدَةً مِّن لِّسَانِى يَفْقَهُوا۟ قَوْلِى',
          transliteration:
              'Rabbi ishrah li sadri wa yassir li amri wa uhlul \'uqdatan min lisani yafqahu qawli.',
          translation:
              'My Lord, expand my chest for me, ease my task for me, untie the knot from my tongue, and let them understand my speech.',
          whenToSay:
              'Before speaking, teaching, presenting, or taking on a difficult task.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 20:25-28',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'ease', 'speech', 'knowledge'],
          audioKey: 'quran_020_025_028_expand_my_chest_and_ease_my_task.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_120_quran_21_87',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'There Is No God but You, I Was Wrong',
          arabic:
              'لَّآ إِلَـٰهَ إِلَّآ أَنتَ سُبْحَـٰنَكَ إِنِّى كُنتُ مِنَ ٱلظَّـٰلِمِينَ',
          transliteration:
              'La ilaha illa anta subhanaka inni kuntu mina al-zalimin.',
          translation:
              'There is no god but You. Glory be to You. Indeed, I have been among the wrongdoers.',
          whenToSay:
              'In repentance, distress, and when turning back to Allah after error.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 21:87',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'repentance', 'distress', 'forgiveness'],
          audioKey: 'quran_021_087_there_is_no_god_but_you_i_was_wrong.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_121_quran_21_89',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Do Not Leave Me Alone',
          arabic: 'رَبِّ لَا تَذَرْنِى فَرْدًا وَأَنتَ خَيْرُ ٱلْوَٰرِثِينَ',
          transliteration:
              'Rabbi la tadharni fardan wa anta khayru al-warithin.',
          translation:
              'My Lord, do not leave me alone, while You are the best of inheritors.',
          whenToSay:
              'When asking Allah for righteous family and not feeling left without support.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 21:89',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'family', 'children', 'inheritance'],
          audioKey: 'quran_021_089_do_not_leave_me_alone.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_122_quran_23_29',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Settle Me in a Blessed Place',
          arabic:
              'رَبِّ أَنزِلْنِى مُنزَلًا مُّبَارَكًا وَأَنتَ خَيْرُ ٱلْمُنزِلِينَ',
          transliteration:
              'Rabbi anzilni munzalan mubarakan wa anta khayru al-munzilin.',
          translation:
              'My Lord, let me land at a blessed landing place, for You are the best to settle and accommodate.',
          whenToSay:
              'For travel, transition, relocation, and asking for a blessed destination.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 23:29',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'travel', 'blessing', 'transition'],
          audioKey: 'quran_023_029_settle_me_in_a_blessed_place.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_123_quran_23_94',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Do Not Place Me Among Wrongdoers',
          arabic: 'رَبِّ فَلَا تَجْعَلْنِى فِى ٱلْقَوْمِ ٱلظَّـٰلِمِينَ',
          transliteration: 'Rabbi fala taj\'alni fi al-qawmi al-zalimin.',
          translation: 'My Lord, do not place me among the wrongdoing people.',
          whenToSay:
              'When asking Allah to keep you away from wrongdoing and corrupt company.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 23:94',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'protection', 'wrongdoing'],
          audioKey: 'quran_023_094_do_not_place_me_among_wrongdoers.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_124_quran_23_97_98',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'I Seek Refuge from the Devils',
          arabic:
              'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَٰتِ ٱلشَّيَـٰطِينِ وَأَعُوذُ بِكَ رَبِّ أَن يَحْضُرُونِ',
          transliteration:
              'Rabbi a\'udhu bika min hamazat al-shayatin wa a\'udhu bika Rabbi an yahdurun.',
          translation:
              'My Lord, I seek refuge in You from the whispers and incitements of the devils, and I seek refuge in You, my Lord, lest they be present with me.',
          whenToSay:
              'When seeking refuge from whispers, agitation, and harmful spiritual distractions.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 23:97-98',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'protection', 'shaytan', 'refuge'],
          audioKey: 'quran_023_097_098_i_seek_refuge_from_the_devils.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_125_quran_25_65',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Avert from Us the Punishment of Hell',
          arabic:
              'رَبَّنَا ٱصْرِفْ عَنَّا عَذَابَ جَهَنَّمَ ۖ إِنَّ عَذَابَهَا كَانَ غَرَامًا',
          transliteration:
              'Rabbana isrif \'anna \'adhaba Jahannama inna \'adhabaha kana gharama.',
          translation:
              'Our Lord, avert from us the punishment of Hell. Indeed, its punishment is ever clinging and severe.',
          whenToSay:
              'For fear of Allah, humility, and asking for salvation in the Hereafter.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 25:65',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'hereafter', 'hellfire', 'protection'],
          audioKey: 'quran_025_065_avert_from_us_the_punishment_of_hell.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_126_quran_26_83_85',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Grant Me Wisdom and a Lasting Good Name',
          arabic:
              'رَبِّ هَبْ لِى حُكْمًا وَأَلْحِقْنِى بِٱلصَّـٰلِحِينَ وَٱجْعَل لِّى لِسَانَ صِدْقٍ فِى ٱلْـَٔاخِرِينَ وَٱجْعَلْنِى مِن وَرَثَةِ جَنَّةِ ٱلنَّعِيمِ',
          transliteration:
              'Rabbi hab li hukman wa alhiqni bi al-salihin. Waj\'al li lisana sidqin fi al-akhirin. Waj\'alni min warathati Jannat al-Na\'im.',
          translation:
              'My Lord, grant me wisdom and join me with the righteous. Grant me an honorable mention among later generations. Make me among the inheritors of the Garden of Bliss.',
          whenToSay:
              'For wisdom, righteous company, honorable legacy, and Paradise.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 26:83-85',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'wisdom', 'legacy', 'paradise'],
          audioKey:
              'quran_026_083_085_grant_me_wisdom_and_a_lasting_good_name.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_127_quran_27_19',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Enable Me to Be Grateful',
          arabic:
              'رَبِّ أَوْزِعْنِىٓ أَنْ أَشْكُرَ نِعْمَتَكَ ٱلَّتِىٓ أَنْعَمْتَ عَلَىَّ وَعَلَىٰ وَٰلِدَىَّ وَأَنْ أَعْمَلَ صَـٰلِحًا تَرْضَىٰهُ وَأَدْخِلْنِى بِرَحْمَتِكَ فِى عِبَادِكَ ٱلصَّـٰلِحِينَ',
          transliteration:
              'Rabbi awzi\'ni an ashkura ni\'mataka allati an\'amta \'alayya wa \'ala walidayya wa an a\'mala salihan tardahu wa adkhilni bi-rahmatika fi \'ibadika al-salihin.',
          translation:
              'My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents, to do righteousness that pleases You, and admit me by Your mercy among Your righteous servants.',
          whenToSay:
              'For gratitude, righteous action, and mercy with the righteous.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 27:19',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'gratitude', 'righteousness', 'parents'],
          audioKey: 'quran_027_019_enable_me_to_be_grateful.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_128_quran_28_16',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'I Have Wronged Myself, So Forgive Me',
          arabic: 'رَبِّ إِنِّى ظَلَمْتُ نَفْسِى فَٱغْفِرْ لِى',
          transliteration: 'Rabbi inni zalamtu nafsi faghfir li.',
          translation: 'My Lord, indeed I have wronged myself, so forgive me.',
          whenToSay: 'In sincere repentance after sin or personal wrongdoing.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 28:16',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'repentance', 'forgiveness'],
          audioKey: 'quran_028_016_i_have_wronged_myself_so_forgive_me.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_129_quran_29_30',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Support Me Against the Corrupting People',
          arabic: 'رَبِّ ٱنصُرْنِى عَلَى ٱلْقَوْمِ ٱلْمُفْسِدِينَ',
          transliteration: 'Rabbi unsurni \'ala al-qawmi al-mufsidin.',
          translation: 'My Lord, support me against the corrupting people.',
          whenToSay:
              'When asking Allah for help against corruption, harm, and oppression.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 29:30',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'help', 'corruption', 'protection'],
          audioKey:
              'quran_029_030_support_me_against_the_corrupting_people.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_130_quran_37_100',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Grant Me a Righteous Child',
          arabic: 'رَبِّ هَبْ لِى مِنَ ٱلصَّـٰلِحِينَ',
          transliteration: 'Rabbi hab li mina al-salihin.',
          translation: 'My Lord, grant me a child from among the righteous.',
          whenToSay:
              'When asking Allah for righteous children and blessed family life.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 37:100',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'children', 'family'],
          audioKey: 'quran_037_100_grant_me_a_righteous_child.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_131_quran_38_35',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive Me and Grant Me a Unique Kingdom',
          arabic:
              'رَبِّ ٱغْفِرْ لِى وَهَبْ لِى مُلْكًا لَّا يَنۢبَغِى لِأَحَدٍ مِّنۢ بَعْدِىٓ ۖ إِنَّكَ أَنتَ ٱلْوَهَّابُ',
          transliteration:
              'Rabbi ighfir li wa hab li mulkan la yanbaghi li-ahadin min ba\'di innaka anta al-Wahhab.',
          translation:
              'My Lord, forgive me and grant me a kingdom such as will not belong to anyone after me. Indeed, You are the Bestower.',
          whenToSay:
              'For forgiveness and asking Allah for a special opening that serves His obedience.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 38:35',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'forgiveness', 'favor', 'authority'],
          audioKey:
              'quran_038_035_forgive_me_and_grant_me_a_unique_kingdom.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_132_quran_40_7_9',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive the Believers and Admit Them to Paradise',
          arabic:
              'رَبَّنَا وَسِعْتَ كُلَّ شَىْءٍ رَّحْمَةً وَعِلْمًا فَٱغْفِرْ لِلَّذِينَ تَابُوا۟ وَٱتَّبَعُوا۟ سَبِيلَكَ وَقِهِمْ عَذَابَ ٱلْجَحِيمِ رَبَّنَا وَأَدْخِلْهُمْ جَنَّـٰتِ عَدْنٍ ٱلَّتِى وَعَدتَّهُمْ وَمَن صَلَحَ مِنْ ءَابَآئِهِمْ وَأَزْوَٰجِهِمْ وَذُرِّيَّـٰتِهِمْ ۚ إِنَّكَ أَنتَ ٱلْعَزِيزُ ٱلْحَكِيمُ وَقِهِمُ ٱلسَّيِّـَٔاتِ ۚ وَمَن تَقِ ٱلسَّيِّـَٔاتِ يَوْمَئِذٍ فَقَدْ رَحِمْتَهُۥ ۚ وَذَٰلِكَ هُوَ ٱلْفَوْزُ ٱلْعَظِيمُ',
          transliteration:
              'Rabbana wasi\'ta kulla shay\'in rahmatan wa \'ilman faghfir lilladhina tabu wa ittaba\'u sabilaka wa qihim \'adhaba al-jahim. Rabbana wa adkhilhum jannati \'Adnin allati wa\'adtahum wa man salaha min aba\'ihim wa azwajihim wa dhurriyyatihim innaka anta al-\'Aziz al-Hakim. Wa qihimu al-sayyi\'at wa man taqi al-sayyi\'ati yawma\'idhin faqad rahimtahu wa dhalika huwa al-fawzu al-\'azim.',
          translation:
              'Our Lord, You have encompassed all things in mercy and knowledge, so forgive those who repent and follow Your way and protect them from the punishment of Hellfire. Our Lord, admit them to gardens of everlasting residence which You promised them, along with the righteous among their parents, spouses, and descendants. Protect them from the evil consequences of their deeds. Whoever You protect that Day, You have surely shown mercy to, and that is the great success.',
          whenToSay:
              'A broad dua for repentance, family, forgiveness, and protection from evil consequences.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 40:7-9',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'forgiveness', 'ummah', 'paradise', 'family'],
          audioKey:
              'quran_040_007_009_forgive_the_believers_and_admit_them_to_paradise.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_133_quran_40_44',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'I Entrust My Affair to Allah',
          arabic:
              'وَأُفَوِّضُ أَمْرِىٓ إِلَى ٱللَّهِ ۚ إِنَّ ٱللَّهَ بَصِيرٌۢ بِٱلْعِبَادِ',
          transliteration:
              'Wa ufawwidu amri ila Allah. Inna Allaha basirun bil-\'ibad.',
          translation:
              'I entrust my affair to Allah. Indeed, Allah is Seeing of His servants.',
          whenToSay:
              'When matters feel overwhelming and you need to place your affair with Allah.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 40:44',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['quran', 'trust', 'tawakkul'],
          audioKey: 'quran_040_044_i_entrust_my_affair_to_allah.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_134_quran_46_15',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Enable Me to Thank You and Rectify My Offspring',
          arabic:
              'رَبِّ أَوْزِعْنِىٓ أَنْ أَشْكُرَ نِعْمَتَكَ ٱلَّتِىٓ أَنْعَمْتَ عَلَىَّ وَعَلَىٰ وَٰلِدَىَّ وَأَنْ أَعْمَلَ صَـٰلِحًا تَرْضَىٰهُ وَأَصْلِحْ لِى فِى ذُرِّيَّتِىٓ ۖ إِنِّى تُبْتُ إِلَيْكَ وَإِنِّى مِنَ ٱلْمُسْلِمِينَ',
          transliteration:
              'Rabbi awzi\'ni an ashkura ni\'mataka allati an\'amta \'alayya wa \'ala walidayya wa an a\'mala salihan tardahu wa aslih li fi dhurriyyati inni tubtu ilayka wa inni mina al-muslimin.',
          translation:
              'My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents, to do righteousness that pleases You, and rectify my offspring for me. Indeed, I have repented to You, and indeed I am among the Muslims.',
          whenToSay:
              'For gratitude, righteous deeds, repentance, and upright children.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 46:15',
          difficulty: DuaDifficulty.advanced,
          tags: <String>[
            'quran',
            'gratitude',
            'children',
            'repentance',
            'parents',
          ],
          audioKey:
              'quran_046_015_enable_me_to_thank_you_and_rectify_my_offspring.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_135_quran_59_10',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive Us and Those Before Us in Faith',
          arabic:
              'رَبَّنَا ٱغْفِرْ لَنَا وَلِإِخْوَٰنِنَا ٱلَّذِينَ سَبَقُونَا بِٱلْإِيمَـٰنِ وَلَا تَجْعَلْ فِى قُلُوبِنَا غِلًّا لِّلَّذِينَ ءَامَنُوا۟ رَبَّنَآ إِنَّكَ رَءُوفٌ رَّحِيمٌ',
          transliteration:
              'Rabbana ighfir lana wa li-ikhwanina alladhina sabaquna bi al-iman wa la taj\'al fi qulubina ghillan lilladhina amanu Rabbana innaka ra\'ufun Rahim.',
          translation:
              'Our Lord, forgive us and our brothers who preceded us in faith, and do not place in our hearts any resentment toward those who believe. Our Lord, indeed You are Kind and Merciful.',
          whenToSay:
              'For unity of heart, forgiveness, and love for the believers.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 59:10',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'forgiveness', 'ummah', 'hearts'],
          audioKey: 'quran_059_010_forgive_us_and_those_before_us_in_faith.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_136_quran_60_4_5',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Upon You We Rely, So Do Not Make Us a Trial',
          arabic:
              'رَّبَّنَا عَلَيْكَ تَوَكَّلْنَا وَإِلَيْكَ أَنَبْنَا وَإِلَيْكَ ٱلْمَصِيرُ رَبَّنَا لَا تَجْعَلْنَا فِتْنَةً لِّلَّذِينَ كَفَرُوا۟ وَٱغْفِرْ لَنَا رَبَّنَآ ۖ إِنَّكَ أَنتَ ٱلْعَزِيزُ ٱلْحَكِيمُ',
          transliteration:
              'Rabbana \'alayka tawakkalna wa ilayka anabna wa ilayka al-masir. Rabbana la taj\'alna fitnatan lilladhina kafaru wa ighfir lana Rabbana innaka anta al-\'Aziz al-Hakim.',
          translation:
              'Our Lord, upon You we have relied, to You we have returned, and to You is the destination. Our Lord, do not make us a trial for the disbelievers and forgive us. Our Lord, indeed You are the Exalted in Might, the Wise.',
          whenToSay:
              'For tawakkul, return to Allah, forgiveness, and protection from becoming a trial.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 60:4-5',
          difficulty: DuaDifficulty.advanced,
          tags: <String>['quran', 'tawakkul', 'forgiveness', 'protection'],
          audioKey:
              'quran_060_004_005_upon_you_we_rely_so_do_not_make_us_a_trial.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'stub_137_quran_71_28',
          category: 'forgiveness_and_growth',
          subcategory: 'quran_dua',
          title: 'Forgive Me, My Parents, and the Believers',
          arabic:
              'رَّبِّ ٱغْفِرْ لِى وَلِوَٰلِدَىَّ وَلِمَن دَخَلَ بَيْتِىَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَٱلْمُؤْمِنَـٰتِ وَلَا تَزِدِ ٱلظَّـٰلِمِينَ إِلَّا تَبَارًۢا',
          transliteration:
              'Rabbi ighfir li wa liwalidayya wa liman dakhala baytiya mu\'minan wa lil-mu\'minina wa al-mu\'minati wa la tazidi al-zalimina illa tabara.',
          translation:
              'My Lord, forgive me, my parents, whoever enters my house as a believer, and the believing men and women. Do not increase the wrongdoers except in destruction.',
          whenToSay:
              'For oneself, parents, guests of faith, and the believing men and women.',
          sourceType: 'quran',
          sourceRef: 'Qur\'an 71:28',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['quran', 'forgiveness', 'parents', 'ummah'],
          audioKey: 'quran_071_028_forgive_me_my_parents_and_the_believers.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_quran_foundation',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_after_eating_short_gratitude',
          category: 'daily_life',
          subcategory: 'food',
          title: 'After Eating',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          transliteration:
              'Alhamdu lillahi alladhi at\'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah.',
          translation:
              'Praise is to Allah who fed me this and provided it for me without any power or strength from me.',
          whenToSay: 'After finishing food.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Ibn Majah 3285; Hisn al-Muslim 180',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['food', 'gratitude', 'daily', 'sunnah'],
          audioKey: 'sunnah_after_eating_short_gratitude.mp3',
          isCore: true,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_seeing_someone_afflicted',
          category: 'situational',
          subcategory: 'tribulation',
          title: 'Upon Seeing Someone Afflicted',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلَاكَ بِهِ وَفَضَّلَنِي عَلَىٰ كَثِيرٍ مِمَّنْ خَلَقَ تَفْضِيلًا',
          transliteration:
              'Alhamdu lillahi alladhi \'afani mimma ibtalaka bihi wa faddalani \'ala kathirin mimman khalaqa tafdila.',
          translation:
              'Praise is to Allah who spared me from what He tested you with and greatly favored me over much of what He created.',
          whenToSay:
              'When seeing someone being tested with illness or hardship, without saying it in a way that harms them.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3431; Hisn al-Muslim 194',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['tribulation', 'gratitude', 'protection', 'adab'],
          audioKey: 'sunnah_upon_seeing_someone_afflicted.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_wearing_a_garment',
          category: 'daily_life',
          subcategory: 'clothing',
          title: 'Upon Wearing a Garment',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          transliteration:
              'Alhamdu lillahi alladhi kasani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah.',
          translation:
              'Praise is to Allah who clothed me with this and provided it for me without any power or strength from me.',
          whenToSay: 'When putting on a garment.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Ibn Majah 3286; Hisn al-Muslim 5',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['clothing', 'daily', 'gratitude'],
          audioKey: 'sunnah_upon_wearing_a_garment.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_receiving_good_news',
          category: 'situational',
          subcategory: 'news',
          title: 'Upon Receiving Good News',
          arabic:
              'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ',
          transliteration:
              'Alhamdu lillahi alladhi bini\'matihi tatimmu al-salihat.',
          translation:
              'Praise is to Allah by whose favor righteous deeds are completed.',
          whenToSay: 'When something happens that pleases you.',
          sourceType: 'sunnah',
          sourceRef:
              'Ibn as-Sunni, \'Amal al-Yawm wa al-Laylah; al-Hakim 1/499; Hisn al-Muslim 218',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['news', 'gratitude', 'praise', 'daily'],
          audioKey: 'sunnah_upon_receiving_good_news.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_secondary',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_for_someone_wearing_new_clothes',
          category: 'daily_life',
          subcategory: 'clothing',
          title: 'For Someone Wearing New Clothes',
          arabic: 'تُبْلِي وَيُخْلِفُ اللَّهُ تَعَالَى',
          transliteration: 'Tubli wa yukhlifu Allahu ta\'ala.',
          translation: 'May you wear it out, and may Allah replace it for you.',
          whenToSay: 'To someone who has put on new clothes.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan Abi Dawud 4020; Hisn al-Muslim 7',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['clothing', 'dua_for_others', 'daily', 'adab'],
          audioKey: 'sunnah_for_someone_wearing_new_clothes.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_receiving_bad_news',
          category: 'situational',
          subcategory: 'news',
          title: 'Upon Receiving Distressing News',
          arabic: 'الْحَمْدُ لِلَّهِ عَلَىٰ كُلِّ حَالٍ',
          transliteration: 'Alhamdu lillahi \'ala kulli hal.',
          translation: 'Praise is to Allah in every circumstance.',
          whenToSay: 'When something happens that displeases or saddens you.',
          sourceType: 'sunnah',
          sourceRef:
              'Ibn as-Sunni, \'Amal al-Yawm wa al-Laylah; al-Hakim 1/499; Hisn al-Muslim 218',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['news', 'sabr', 'gratitude', 'remembrance'],
          audioKey: 'sunnah_upon_receiving_bad_news.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_secondary',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_before_marital_relations',
          category: 'daily_life',
          subcategory: 'family',
          title: 'Before Marital Relations',
          arabic:
              'بِاسْمِ اللَّهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا',
          transliteration:
              'Bismillah, Allahumma jannibna al-shaytan wa jannib al-shaytana ma razaqtana.',
          translation:
              'In the name of Allah. O Allah, keep Satan away from us and keep Satan away from what You provide for us.',
          whenToSay: 'Before marital relations with one\'s spouse.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6388; Sahih Muslim 1434',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['family', 'marriage', 'protection', 'daily'],
          audioKey: 'sunnah_before_marital_relations.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_fear_of_shirk',
          category: 'situational',
          subcategory: 'faith',
          title: 'Fear of Shirk',
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أُشْرِكَ بِكَ وَأَنَا أَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ',
          transliteration:
              'Allahumma inni a\'udhu bika an ushrika bika wa ana a\'lam, wa astaghfiruka lima la a\'lam.',
          translation:
              'O Allah, I seek refuge in You from associating anything with You knowingly, and I ask Your forgiveness for what I do not know.',
          whenToSay:
              'When seeking purity in tawhid and asking Allah to protect you from hidden or open shirk.',
          sourceType: 'sunnah',
          sourceRef:
              'Musnad Ahmad 19606; al-Adab al-Mufrad 716; authenticated by al-Albani',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['tawhid', 'shirk', 'forgiveness', 'faith'],
          audioKey: 'sunnah_fear_of_shirk.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_bedtime_surrender_dua',
          category: 'daily_life',
          subcategory: 'sleep',
          title: 'Bedtime Surrender Dua',
          arabic:
              'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          transliteration:
              'Allahumma aslamtu nafsi ilayk, wa fawwadtu amri ilayk, wa wajjahtu wajhi ilayk, wa alja\'tu zahri ilayk, raghbatan wa rahbatan ilayk, la malja\'a wa la manja minka illa ilayk, amantu bikitabika alladhi anzalta wa binabiyyika alladhi arsalta.',
          translation:
              'O Allah, I submit myself to You, entrust my affair to You, turn my face to You, and rely on You in hope and fear of You. There is no refuge and no escape from You except to You. I believe in Your Book which You sent down and in Your Prophet whom You sent.',
          whenToSay: 'When going to bed after preparing to sleep.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6313; Sahih Muslim 2710',
          difficulty: DuaDifficulty.intermediate,
          tags: <String>['sleep', 'trust', 'night', 'sunnah'],
          audioKey: 'sunnah_bedtime_surrender_dua.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_distress_relief',
          category: 'situational',
          subcategory: 'distress',
          title: 'In Distress: Seek Relief',
          arabic: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ',
          transliteration: 'Ya Hayyu ya Qayyumu bi rahmatika astaghith.',
          translation:
              'O Ever-Living, O Sustainer, in Your mercy I seek relief.',
          whenToSay: 'When something distresses you or becomes overwhelming.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 3524',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['distress', 'relief', 'mercy', 'remembrance'],
          audioKey: 'sunnah_distress_relief.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_hearing_a_rooster',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Upon Hearing a Rooster Crow',
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
          transliteration: 'Allahumma inni as\'aluka min fadlik.',
          translation: 'O Allah, I ask You from Your bounty.',
          whenToSay: 'When hearing a rooster crow.',
          sourceType: 'sunnah',
          sourceRef:
              'Sahih al-Bukhari 3303; Sahih Muslim 2729; Hisn al-Muslim 228',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'bounty', 'creation', 'remembrance'],
          audioKey: 'sunnah_upon_hearing_a_rooster.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_visiting_the_sick_purification',
          category: 'situational',
          subcategory: 'illness',
          title: 'Visiting the Sick: It Is a Purification',
          arabic: 'لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ',
          transliteration: 'La ba\'sa tahurun in sha\' Allah.',
          translation: 'No harm; it is a purification, if Allah wills.',
          whenToSay: 'When visiting someone who is ill.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 5662; Hisn al-Muslim 147',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['illness', 'visiting_sick', 'comfort', 'adab'],
          audioKey: 'sunnah_visiting_the_sick_purification.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_upon_hearing_a_donkey_or_dog',
          category: 'daily_life',
          subcategory: 'daily',
          title: 'Upon Hearing a Donkey Bray or a Dog Bark at Night',
          arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          transliteration: 'A\'udhu billahi min al-shaytan al-rajim.',
          translation: 'I seek refuge in Allah from Satan, the expelled one.',
          whenToSay:
              'When hearing a donkey bray, or a dog bark at night, seeking refuge in Allah.',
          sourceType: 'sunnah',
          sourceRef:
              'Sahih al-Bukhari 3303; Sahih Muslim 2729; Hisn al-Muslim 228',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'protection', 'shaytan', 'remembrance'],
          audioKey: 'sunnah_upon_hearing_a_donkey_or_dog.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_refuge_from_four_harmful_things',
          category: 'situational',
          subcategory: 'protection',
          title: 'Refuge from Four Harmful Things',
          arabic:
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عِلْمٍ لَا يَنْفَعُ، وَقَلْبٍ لَا يَخْشَعُ، وَنَفْسٍ لَا تَشْبَعُ، وَدُعَاءٍ لَا يُسْمَعُ',
          transliteration:
              'Allahumma inni a\'udhu bika min \'ilmin la yanfa\', wa qalbin la yakhsha\', wa nafsin la tashba\', wa du\'a\'in la yusma\'.',
          translation:
              'O Allah, I seek refuge in You from knowledge that does not benefit, a heart that does not humble itself, a soul that is never satisfied, and a supplication that is not heard.',
          whenToSay:
              'When seeking protection from harmful inner states and asking Allah for benefit and sincerity.',
          sourceType: 'sunnah',
          sourceRef: 'Sunan an-Nasa\'i 5470',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['protection', 'knowledge', 'heart', 'dua'],
          audioKey: 'sunnah_refuge_from_four_harmful_things.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_when_sneezing',
          category: 'daily_life',
          subcategory: 'etiquette',
          title: 'When Sneezing',
          arabic: 'الْحَمْدُ لِلَّهِ',
          transliteration: 'Alhamdu lillah.',
          translation: 'All praise is for Allah.',
          whenToSay: 'When you sneeze.',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6224; Hisn al-Muslim 188',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'etiquette', 'sneezing', 'praise'],
          audioKey: 'sunnah_when_sneezing.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_responding_to_a_sneeze',
          category: 'daily_life',
          subcategory: 'etiquette',
          title: 'Responding to a Sneeze',
          arabic:
              'يَرْحَمُكَ اللَّهُ، وَيَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ',
          transliteration:
              'Yarhamuk Allah. Yahdikum Allahu wa yuslihu balakum.',
          translation:
              'May Allah have mercy on you. May Allah guide you and set your affairs right.',
          whenToSay:
              'Say “Yarhamuk Allah” to the one who sneezes and praises Allah; the sneezer replies, “Yahdikum Allahu wa yuslihu balakum.”',
          sourceType: 'sunnah',
          sourceRef: 'Sahih al-Bukhari 6224; Hisn al-Muslim 188',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'etiquette', 'sneezing', 'dua_for_others'],
          audioKey: 'sunnah_responding_to_a_sneeze.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_bukhari_muslim',
          completionStatus: DuaCompletionStatus.complete,
        ),
        DuaItem(
          id: 'sunnah_jazakallahu_khayran',
          category: 'daily_life',
          subcategory: 'etiquette',
          title: 'For Someone Who Does You a Favor',
          arabic: 'جَزَاكَ اللَّهُ خَيْرًا',
          transliteration: 'Jazakallahu khayran.',
          translation: 'May Allah reward you with goodness.',
          whenToSay:
              'To someone who has done you a favor or shown you kindness.',
          sourceType: 'sunnah',
          sourceRef: 'Jami\' at-Tirmidhi 2035; Riyad as-Salihin 1496',
          difficulty: DuaDifficulty.beginner,
          tags: <String>['daily', 'gratitude', 'etiquette', 'dua_for_others'],
          audioKey: 'sunnah_jazakallahu_khayran.mp3',
          isCore: false,
          verificationStatus: 'source_seeded_sunnah',
          completionStatus: DuaCompletionStatus.complete,
        ),
      ]),
    ),
  ),
);

const Map<String, String> _duaPrimaryCategoryLabels = <String, String>{
  'quranic': 'Qur\'anic',
  'daily_life': 'Daily Life',
  'situational': 'Situational',
  'travel': 'Travel',
  'weather': 'Weather',
  'forgiveness': 'Forgiveness',
  'after_salah': 'After Salah',
  'morning': 'Morning',
  'evening': 'Evening',
  'sleep': 'Sleep',
  'waking': 'Waking',
  'masjid': 'Masjid',
  'fasting': 'Fasting',
  'special_moments': 'Special Moments',
  'illness': 'Illness',
  'social_interactions': 'Social Interactions',
  'food_drink': 'Food & Drink',
  'home': 'Home',
  'clothing': 'Clothing',
};

const Map<String, String> _subcategoryPrimaryCategoryMap = <String, String>{
  'quran_dua': 'quranic',
  'hardship': 'situational',
  'repentance': 'forgiveness',
  'children': 'home',
  'salah': 'daily_life',
  'parents': 'home',
  'guidance': 'daily_life',
  'knowledge': 'daily_life',
  'illness': 'illness',
  'family': 'home',
  'need': 'situational',
  'akhirah': 'situational',
  'food': 'food_drink',
  'sleep': 'sleep',
  'leaving_home': 'home',
  'home': 'home',
  'masjid': 'masjid',
  'adhan': 'daily_life',
  'ramadan': 'fasting',
  'protection': 'situational',
  'morning_evening': 'morning',
  'daily': 'daily_life',
  'clothing': 'clothing',
  'toilet': 'daily_life',
  'after_salah': 'after_salah',
  'wudu': 'daily_life',
  'quran': 'quranic',
  'friday': 'special_moments',
  'istikhara': 'special_moments',
  'hajj_umrah': 'special_moments',
  'marriage': 'home',
  'relatives': 'social_interactions',
  'guests': 'social_interactions',
  'vehicle': 'travel',
  'journey': 'travel',
  'weather': 'weather',
  'location': 'travel',
  'anxiety': 'situational',
  'debt': 'situational',
  'fear': 'situational',
  'anger': 'situational',
  'calamity': 'situational',
  'grief': 'situational',
  'oppression': 'situational',
  'confusion': 'situational',
  'distress': 'situational',
  'sin': 'forgiveness',
  'trial': 'situational',
  'envy': 'situational',
  'evil_eye': 'situational',
  'rizq': 'daily_life',
  'eid': 'special_moments',
  'arafah': 'special_moments',
  'dhul_hijjah': 'special_moments',
  'new_moon': 'special_moments',
  'rain': 'weather',
  'eclipse': 'special_moments',
  'istighfar': 'forgiveness',
  'gratitude': 'daily_life',
  'light': 'daily_life',
  'faith': 'daily_life',
  'character': 'daily_life',
  'deeds': 'daily_life',
  'tribulation': 'situational',
  'news': 'social_interactions',
  'etiquette': 'social_interactions',
};

const Map<String, List<String>> _subcategorySecondaryCategoryMap =
    <String, List<String>>{
      'quran_dua': <String>['quranic'],
      'hardship': <String>['hardship', 'patience', 'tawakkul'],
      'repentance': <String>['forgiveness', 'mercy'],
      'children': <String>['barakah', 'community'],
      'salah': <String>['worship'],
      'parents': <String>['community', 'mercy'],
      'guidance': <String>['guidance'],
      'knowledge': <String>['guidance'],
      'illness': <String>['healing', 'mercy'],
      'family': <String>['community', 'daily_routine'],
      'need': <String>['ease', 'tawakkul'],
      'akhirah': <String>['guidance'],
      'food': <String>['food_drink', 'daily_routine', 'gratitude'],
      'sleep': <String>['sleep', 'daily_routine'],
      'leaving_home': <String>[
        'daily_routine',
        'entering_leaving',
        'protection',
        'tawakkul',
      ],
      'home': <String>['dhikr', 'daily_routine', 'entering_leaving'],
      'masjid': <String>['dhikr', 'entering_leaving', 'worship'],
      'adhan': <String>['dhikr', 'worship'],
      'ramadan': <String>['ramadan', 'worship'],
      'protection': <String>['dhikr', 'protection'],
      'morning_evening': <String>['dhikr', 'daily_routine', 'evening'],
      'daily': <String>['dhikr', 'daily_routine'],
      'clothing': <String>['daily_routine', 'gratitude'],
      'toilet': <String>['daily_routine', 'entering_leaving'],
      'after_salah': <String>['dhikr', 'worship', 'forgiveness'],
      'wudu': <String>['daily_routine', 'worship'],
      'quran': <String>['quranic', 'worship'],
      'friday': <String>['community', 'worship'],
      'istikhara': <String>['guidance', 'tawakkul'],
      'hajj_umrah': <String>['journey', 'worship'],
      'marriage': <String>['barakah', 'community'],
      'relatives': <String>['community', 'mercy'],
      'guests': <String>['community', 'gratitude'],
      'vehicle': <String>['journey', 'protection', 'tawakkul'],
      'journey': <String>['journey', 'protection', 'tawakkul'],
      'weather': <String>['weather', 'mercy', 'protection'],
      'location': <String>['journey', 'protection'],
      'anxiety': <String>['anxiety', 'hardship', 'tawakkul'],
      'debt': <String>['ease', 'hardship', 'tawakkul'],
      'fear': <String>['protection', 'tawakkul'],
      'anger': <String>['anger', 'dhikr', 'protection'],
      'calamity': <String>['hardship', 'patience', 'tawakkul'],
      'grief': <String>['mercy', 'sadness'],
      'oppression': <String>['hardship', 'tawakkul'],
      'confusion': <String>['guidance', 'tawakkul'],
      'distress': <String>['ease', 'hardship', 'mercy'],
      'sin': <String>['forgiveness'],
      'trial': <String>['patience', 'tawakkul'],
      'envy': <String>['protection'],
      'evil_eye': <String>['protection'],
      'rizq': <String>['barakah', 'ease'],
      'eid': <String>['community', 'worship'],
      'arafah': <String>['community', 'worship'],
      'dhul_hijjah': <String>['community', 'worship'],
      'new_moon': <String>['worship'],
      'rain': <String>['gratitude', 'mercy', 'weather'],
      'eclipse': <String>['forgiveness', 'worship'],
      'istighfar': <String>['dhikr', 'forgiveness'],
      'gratitude': <String>['dhikr', 'gratitude'],
      'light': <String>['guidance'],
      'faith': <String>['guidance', 'protection'],
      'character': <String>['community', 'guidance'],
      'deeds': <String>['daily_routine', 'guidance'],
      'tribulation': <String>['gratitude', 'protection'],
      'news': <String>['community', 'gratitude'],
      'etiquette': <String>['community', 'daily_routine'],
    };

const Set<String> _allowedTagDrivenSecondaryCategories = <String>{
  'dhikr',
  'forgiveness',
  'gratitude',
  'protection',
  'mercy',
  'guidance',
  'patience',
  'ease',
  'hardship',
  'anxiety',
  'sadness',
  'anger',
  'healing',
  'barakah',
  'tawakkul',
  'worship',
  'quranic',
  'sunnah',
  'daily_routine',
  'entering_leaving',
  'food_drink',
  'weather',
  'journey',
  'sleep',
  'waking',
  'community',
  'ramadan',
  'laylat_al_qadr',
};

const Set<String> _allowedTimeContexts = <String>{
  'morning',
  'afternoon',
  'evening',
  'night',
  'before_sleep',
  'upon_waking',
  'any',
};

const Set<String> _allowedDateContexts = <String>{
  'friday',
  'ramadan',
  'laylat_al_qadr',
  'eid',
  'arafah',
  'any',
};

const Set<String> _allowedWeatherContexts = <String>{
  'rain',
  'wind',
  'storm',
  'thunder',
  'any',
};

const Set<String> _allowedLocationContexts = <String>{
  'home_entering',
  'home_leaving',
  'masjid_entering',
  'masjid_leaving',
  'travel',
  'new_place',
  'bathroom_entering',
  'bathroom_leaving',
  'any',
};

const Set<String> _allowedPrayerContexts = <String>{
  'before_salah',
  'after_salah',
  'fajr_window',
  'jumuah',
  'iftar',
  'suhoor',
  'any',
};

const Set<String> _allowedSituationContexts = <String>{
  'forgiveness',
  'gratitude',
  'anxiety',
  'sadness',
  'anger',
  'hardship',
  'illness',
  'good_news',
  'sneezing',
  'protection',
  'guidance',
  'social_interactions',
  'any',
};

const Set<String> _allowedSurfaceEligibility = <String>{
  'in_app',
  'daily_card',
  'home_widget',
  'lockscreen',
  'watch',
  'standby',
};

const Set<String> _verifiedStrongOverrides = <String>{
  'sunnah_before_eating_bismillah',
  'sunnah_if_forgot_bismillah',
  'sunnah_leaving_home',
  'stub_020_daily_life_toilet',
  'stub_021_daily_life_toilet',
  'sunnah_laylatul_qadr',
  'stub_035_prayer_and_worship_after_salah',
  'stub_102_forgiveness_and_growth_istighfar',
  'stub_059_travel_and_movement_vehicle',
  'stub_061_travel_and_movement_journey',
  'stub_065_travel_and_movement_weather',
  'sunnah_entering_mosque',
  'sunnah_leaving_mosque',
};

const Set<String> _verifiedGeneralOverrides = <String>{
  'stub_015_daily_life_food',
  'stub_016_daily_life_food',
  'stub_018_daily_life_clothing',
  'stub_021_daily_life_toilet',
  'stub_032_prayer_and_worship_sujud',
  'stub_060_travel_and_movement_vehicle',
  'stub_062_travel_and_movement_journey',
  'stub_063_travel_and_movement_weather',
  'stub_064_travel_and_movement_weather',
  'stub_066_travel_and_movement_weather',
  'stub_067_travel_and_movement_weather',
  'stub_069_travel_and_movement_location',
  'stub_070_travel_and_movement_location',
  'stub_091_special_days_ramadan',
  'stub_094_special_days_eid',
  'stub_095_special_days_eid',
  'stub_096_special_days_arafah',
  'stub_097_special_days_dhul_hijjah',
  'stub_098_special_days_new_moon',
  'stub_099_special_days_rain',
  'stub_101_forgiveness_and_growth_istighfar',
  'sunnah_after_eating_short_gratitude',
  'sunnah_upon_seeing_someone_afflicted',
  'sunnah_upon_wearing_a_garment',
  'sunnah_upon_receiving_good_news',
  'sunnah_upon_receiving_bad_news',
  'sunnah_fear_of_shirk',
  'sunnah_distress_relief',
};

const Set<String> _needsReviewOverrides = <String>{
  'sunnah_entering_home',
  'stub_019_daily_life_clothing',
};

const Set<String> _excludeFromDefaultSurfaceOverrides = <String>{
  'stub_092_special_days_ramadan',
  'stub_100_special_days_eclipse',
};

List<DuaItem> _applyDuaTaxonomy(List<DuaItem> items) {
  return items
      .map((item) {
        final primaryCategory = _primaryCategoryFor(item);
        return item.copyWith(
          primaryCategory: primaryCategory,
          secondaryCategories: _secondaryCategoriesFor(item, primaryCategory),
        );
      })
      .toList(growable: false);
}

List<DuaItem> _applyDuaOrchestrationMetadata(List<DuaItem> items) {
  return items
      .map((item) {
        final timeContexts = _normalizeContexts(
          _timeContextsFor(item),
          allowed: _allowedTimeContexts,
        );
        final dateContexts = _normalizeContexts(
          _dateContextsFor(item),
          allowed: _allowedDateContexts,
        );
        final weatherContexts = _normalizeContexts(
          _weatherContextsFor(item),
          allowed: _allowedWeatherContexts,
        );
        final locationContexts = _normalizeContexts(
          _locationContextsFor(item),
          allowed: _allowedLocationContexts,
        );
        final prayerContexts = _normalizeContexts(
          _prayerContextsFor(item),
          allowed: _allowedPrayerContexts,
        );
        final situationContexts = _normalizeContexts(
          _situationContextsFor(item),
          allowed: _allowedSituationContexts,
        );
        final surfaceEligibility = _normalizeContexts(
          _surfaceEligibilityFor(
            item: item,
            timeContexts: timeContexts,
            dateContexts: dateContexts,
            weatherContexts: weatherContexts,
            locationContexts: locationContexts,
            prayerContexts: prayerContexts,
            situationContexts: situationContexts,
          ),
          allowed: _allowedSurfaceEligibility,
        );
        return item.copyWith(
          timeContexts: timeContexts,
          dateContexts: dateContexts,
          weatherContexts: weatherContexts,
          locationContexts: locationContexts,
          prayerContexts: prayerContexts,
          situationContexts: situationContexts,
          surfaceEligibility: surfaceEligibility,
          priorityScore: _priorityScoreFor(
            item: item,
            timeContexts: timeContexts,
            dateContexts: dateContexts,
            weatherContexts: weatherContexts,
            locationContexts: locationContexts,
            prayerContexts: prayerContexts,
            situationContexts: situationContexts,
          ),
        );
      })
      .toList(growable: false);
}

List<DuaItem> _applyDuaReleaseTrust(List<DuaItem> items) {
  return items
      .map((item) {
        var current = _normalizeSourcePresentation(item);
        current = _applyKnownTrustCorrections(current);
        final verificationStatus = _releaseVerificationStatusFor(current);
        return current.copyWith(
          verificationStatus: verificationStatus,
          isCore: current.isCore && verificationStatus == 'verified_strong',
        );
      })
      .toList(growable: false);
}

String _primaryCategoryFor(DuaItem item) {
  return _subcategoryPrimaryCategoryMap[item.subcategory] ?? item.category;
}

List<String> _secondaryCategoriesFor(DuaItem item, String primaryCategory) {
  final categories = <String>{};

  categories.addAll(
    _subcategorySecondaryCategoryMap[item.subcategory] ?? const <String>[],
  );
  categories.addAll(
    item.tags.where(
      (tag) => _allowedTagDrivenSecondaryCategories.contains(tag),
    ),
  );

  if (item.isQuran) {
    categories.add('quranic');
  }
  if (item.isSunnah) {
    categories.add('sunnah');
  }
  if (item.subcategory == 'morning_evening') {
    categories.add('evening');
  }
  if (item.subcategory == 'rain' || item.subcategory == 'weather') {
    categories.add('weather');
  }
  if (item.subcategory == 'after_salah') {
    categories.add('forgiveness');
    categories.add('dhikr');
  }
  if (item.subcategory == 'etiquette') {
    categories.add('community');
  }

  categories.remove(primaryCategory);
  categories.remove(item.category);
  return categories.toList(growable: false)..sort();
}

List<String> _timeContextsFor(DuaItem item) {
  final contexts = <String>{};
  if (item.subcategory == 'morning_evening') {
    contexts.addAll(<String>['morning', 'evening']);
  }
  if (item.subcategory == 'sleep') {
    contexts.addAll(<String>['night', 'before_sleep']);
  }
  if (item.subcategory == 'daily') {
    if (item.id == 'sunnah_upon_waking') {
      contexts.addAll(<String>['upon_waking', 'morning']);
    }
    if (item.id == 'sunnah_upon_hearing_a_rooster') {
      contexts.add('morning');
    }
    if (item.id == 'sunnah_upon_hearing_a_donkey_or_dog') {
      contexts.add('night');
    }
  }
  if (item.subcategory == 'after_salah' || item.subcategory == 'adhan') {
    contexts.add('any');
  }
  if (item.subcategory == 'rain') {
    contexts.add('any');
  }
  if (item.subcategory == 'weather' &&
      (item.id.contains('rain') || item.id.contains('wind'))) {
    contexts.add('any');
  }
  if (item.subcategory == 'ramadan' && item.id.contains('iftar')) {
    contexts.add('evening');
  }

  if (item.id == 'sunnah_before_sleep' ||
      item.id == 'sunnah_bedtime_surrender_dua') {
    contexts.addAll(<String>['before_sleep', 'night']);
  }
  return contexts.toList(growable: false);
}

DuaItem _normalizeSourcePresentation(DuaItem item) {
  final normalizedSourceType = _normalizedSourceType(item.sourceType);
  switch (item.id) {
    case 'quran_002_250_pour_patience':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration:
            'Rabbana afrig \'alayna sabran wa thabbit aqdamana wansurna \'ala al-qawm al-kafirin',
      );
    case 'quran_002_286_forgive_us_mercy':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration:
            'Rabbana la tu\'akhidhna in nasina aw akhta\'na, Rabbana wa la tahmil \'alayna isran kama hamaltahu \'ala alladhina min qablina, Rabbana wa la tuhammilna ma la taqata lana bih, wa\'fu \'anna, waghfir lana, warhamna, anta Mawlana fansurna \'ala al-qawm al-kafirin.',
      );
    case 'sunnah_entering_home':
      return item.copyWith(
        sourceType: normalizedSourceType,
        arabic:
            'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
        transliteration:
            'Bismillahi walajna, wa bismillahi kharajna, wa \'ala Allahi Rabbina tawakkalna.',
        translation:
            'In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we rely.',
        sourceRef:
            'Hisn al-Muslim 18; Muslim 2018 on mentioning Allah when entering; Abu Dawud 5096 for the longer wording.',
      );
    case 'stub_020_daily_life_toilet':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration:
            'Bismillah. Allahumma inni a\'udhu bika min al-khubthi wa al-khaba\'ith.',
      );
    case 'sunnah_entering_mosque':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration: 'Allahumma iftah li abwaba rahmatik.',
        sourceRef: 'Sahih Muslim 713a; Sunan an-Nasa\'i 729; Hisn al-Muslim 20',
      );
    case 'sunnah_leaving_mosque':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration: 'Allahumma inni as\'aluka min fadlik.',
        sourceRef: 'Sahih Muslim 713a; Sunan an-Nasa\'i 729; Hisn al-Muslim 21',
      );
    case 'stub_091_special_days_ramadan':
      return item.copyWith(
        sourceType: normalizedSourceType,
        transliteration:
            'Dhahaba al-zama\' wa abtallati al-\'uruq wa thabata al-ajru in sha\' Allah.',
        sourceRef:
            'Sunan Abi Dawud 2357; classed hasan by al-Albani; retained as the stronger default iftar dhikr.',
      );
    case 'stub_092_special_days_ramadan':
      return item.copyWith(
        sourceType: 'educational_guidance',
        title: 'Fasting Intention Is in the Heart',
      );
    case 'stub_093_special_days_ramadan':
      return item.copyWith(
        sourceType: normalizedSourceType,
        sourceRef:
            'Sunan Ibn Majah 3850; graded sahih by Darussalam; also cited in Hisn al-Muslim.',
      );
    case 'stub_100_special_days_eclipse':
      return item.copyWith(sourceType: 'educational_guidance');
    case 'stub_101_forgiveness_and_growth_istighfar':
      return item.copyWith(sourceType: normalizedSourceType);
    case 'stub_102_forgiveness_and_growth_istighfar':
      return item.copyWith(
        sourceType: normalizedSourceType,
        sourceRef: 'Sahih al-Bukhari 6306; Hisn al-Muslim 126',
      );
    case 'sunnah_after_eating_short_gratitude':
      return item.copyWith(sourceType: normalizedSourceType);
    case 'sunnah_upon_wearing_a_garment':
      return item.copyWith(sourceType: normalizedSourceType);
    case 'sunnah_upon_receiving_good_news':
      return item.copyWith(
        sourceType: normalizedSourceType,
        sourceRef:
            'Sunan Ibn Majah 3803; graded da\'if by Darussalam; retained as a general praise formula.',
      );
    case 'sunnah_upon_receiving_bad_news':
      return item.copyWith(
        sourceType: normalizedSourceType,
        sourceRef:
            'Sunan Ibn Majah 3803; graded da\'if by Darussalam; retained as a general praise formula.',
      );
    case 'sunnah_visiting_the_sick_purification':
      return item.copyWith(sourceType: normalizedSourceType);
    case 'sunnah_when_sneezing':
    case 'sunnah_responding_to_a_sneeze':
      return item.copyWith(sourceType: normalizedSourceType);
    default:
      return item.copyWith(sourceType: normalizedSourceType);
  }
}

DuaItem _applyKnownTrustCorrections(DuaItem item) {
  if (item.id == 'stub_092_special_days_ramadan' ||
      item.id == 'stub_100_special_days_eclipse') {
    return item.copyWith(isCore: false);
  }
  if (item.id == 'sunnah_entering_home' ||
      item.id == 'stub_019_daily_life_clothing' ||
      item.id == 'sunnah_upon_receiving_good_news' ||
      item.id == 'sunnah_upon_receiving_bad_news') {
    return item.copyWith(isCore: false);
  }
  return item;
}

String _releaseVerificationStatusFor(DuaItem item) {
  if (_excludeFromDefaultSurfaceOverrides.contains(item.id)) {
    return 'exclude_from_default_surface';
  }
  if (_needsReviewOverrides.contains(item.id)) {
    return 'needs_review';
  }
  if (_verifiedGeneralOverrides.contains(item.id)) {
    return 'verified_general';
  }
  if (_verifiedStrongOverrides.contains(item.id)) {
    return 'verified_strong';
  }
  if (item.isQuran) {
    return 'verified_strong';
  }
  final sourceRef = item.sourceRef.toLowerCase();
  if (sourceRef.contains('sahih al-bukhari') ||
      sourceRef.contains('sahih muslim') ||
      sourceRef.contains('al-bukhari') && sourceRef.contains('muslim')) {
    return 'verified_strong';
  }
  if (sourceRef.contains('graded sahih') ||
      sourceRef.contains('authenticated by al-albani') ||
      sourceRef.contains('authenticated by darussalam')) {
    return 'verified_strong';
  }
  if (item.verificationStatus == 'source_seeded_secondary' ||
      item.verificationStatus == 'source_seeded_athar' ||
      item.verificationStatus == 'source_seeded_life_with_allah') {
    return 'verified_general';
  }
  if (item.sourceType == 'athar' ||
      item.sourceType == 'companion_practice' ||
      item.sourceType == 'early_muslim_practice') {
    return 'verified_general';
  }
  return 'verified_general';
}

String _normalizedSourceType(String sourceType) {
  final normalized = sourceType.trim().toLowerCase();
  if (normalized.contains('qur')) {
    return 'quran';
  }
  if (normalized.contains('athar')) {
    return 'athar';
  }
  if (normalized.contains('companion practice')) {
    return 'companion_practice';
  }
  if (normalized.contains('early muslim practice')) {
    return 'early_muslim_practice';
  }
  if (normalized.contains('hadith') ||
      normalized.contains('sunnah') ||
      normalized == 'quran_sunnah') {
    return 'sunnah';
  }
  return sourceType;
}

List<String> _dateContextsFor(DuaItem item) {
  final contexts = <String>{};
  if (item.subcategory == 'friday') {
    contexts.add('friday');
  }
  if (item.subcategory == 'ramadan') {
    contexts.add('ramadan');
  }
  if (item.subcategory == 'eid') {
    contexts.add('eid');
  }
  if (item.subcategory == 'arafah') {
    contexts.add('arafah');
  }
  if (item.subcategory == 'new_moon') {
    contexts.add('any');
  }
  if (item.id == 'sunnah_laylatul_qadr') {
    contexts.addAll(<String>['ramadan', 'laylat_al_qadr']);
  }
  return contexts.toList(growable: false);
}

List<String> _weatherContextsFor(DuaItem item) {
  final contexts = <String>{};
  final normalizedId = item.id.toLowerCase();
  final normalizedTitle = item.title.toLowerCase();
  if (item.subcategory == 'rain' || normalizedId.contains('rain')) {
    contexts.add('rain');
  }
  if (normalizedId.contains('wind') || normalizedTitle.contains('wind')) {
    contexts.add('wind');
  }
  if (normalizedTitle.contains('storm')) {
    contexts.add('storm');
  }
  if (normalizedTitle.contains('thunder')) {
    contexts.add('thunder');
  }
  return contexts.toList(growable: false);
}

List<String> _locationContextsFor(DuaItem item) {
  final contexts = <String>{};
  if (item.id == 'sunnah_entering_home') {
    contexts.add('home_entering');
  }
  if (item.id == 'sunnah_leaving_home') {
    contexts.add('home_leaving');
  }
  if (item.id == 'sunnah_entering_mosque') {
    contexts.add('masjid_entering');
  }
  if (item.id == 'sunnah_leaving_mosque') {
    contexts.add('masjid_leaving');
  }
  if (item.id == 'sunnah_entering_bathroom') {
    contexts.add('bathroom_entering');
  }
  if (item.id == 'sunnah_leaving_bathroom') {
    contexts.add('bathroom_leaving');
  }
  if (item.subcategory == 'journey' || item.subcategory == 'vehicle') {
    contexts.add('travel');
  }
  if (item.subcategory == 'location' &&
      (item.id.contains('new') || item.title.toLowerCase().contains('new'))) {
    contexts.add('new_place');
  }
  if (item.subcategory == 'location' &&
      item.title.toLowerCase().contains('marketplace')) {
    contexts.add('any');
  }
  return contexts.toList(growable: false);
}

List<String> _prayerContextsFor(DuaItem item) {
  final contexts = <String>{};
  if (item.subcategory == 'after_salah') {
    contexts.add('after_salah');
  }
  if (item.subcategory == 'adhan') {
    contexts.add('before_salah');
  }
  if (item.subcategory == 'friday') {
    contexts.add('jumuah');
  }
  if (item.subcategory == 'ramadan') {
    if (item.id.contains('iftar')) {
      contexts.add('iftar');
    }
    if (item.id.contains('suhoor') || item.id.contains('suhur')) {
      contexts.add('suhoor');
    }
    if (item.id.contains('fasting_intention')) {
      contexts.add('suhoor');
    }
  }
  if (item.subcategory == 'morning_evening') {
    contexts.add('fajr_window');
  }
  return contexts.toList(growable: false);
}

List<String> _situationContextsFor(DuaItem item) {
  final contexts = <String>{};
  final secondary = item.secondaryCategories.toSet();
  if (secondary.contains('forgiveness') || item.subcategory == 'istighfar') {
    contexts.add('forgiveness');
  }
  if (secondary.contains('gratitude') ||
      item.subcategory == 'gratitude' ||
      item.subcategory == 'food') {
    contexts.add('gratitude');
  }
  if (item.subcategory == 'anxiety') {
    contexts.add('anxiety');
  }
  if (item.subcategory == 'grief') {
    contexts.add('sadness');
  }
  if (item.subcategory == 'anger') {
    contexts.add('anger');
  }
  if (item.subcategory == 'hardship' ||
      item.subcategory == 'distress' ||
      item.subcategory == 'calamity' ||
      item.subcategory == 'trial' ||
      item.subcategory == 'debt') {
    contexts.add('hardship');
  }
  if (item.subcategory == 'illness') {
    contexts.add('illness');
  }
  if (item.subcategory == 'news' &&
      item.title.toLowerCase().contains('good news')) {
    contexts.add('good_news');
  }
  if (item.id == 'sunnah_when_sneezing' ||
      item.id == 'sunnah_responding_to_a_sneeze') {
    contexts.addAll(<String>['sneezing', 'social_interactions']);
  }
  if (secondary.contains('protection') ||
      item.subcategory == 'protection' ||
      item.subcategory == 'fear' ||
      item.subcategory == 'evil_eye' ||
      item.subcategory == 'envy') {
    contexts.add('protection');
  }
  if (secondary.contains('guidance') ||
      item.subcategory == 'guidance' ||
      item.subcategory == 'istikhara') {
    contexts.add('guidance');
  }
  return contexts.toList(growable: false);
}

List<String> _surfaceEligibilityFor({
  required DuaItem item,
  required List<String> timeContexts,
  required List<String> dateContexts,
  required List<String> weatherContexts,
  required List<String> locationContexts,
  required List<String> prayerContexts,
  required List<String> situationContexts,
}) {
  final surfaces = <String>{'in_app'};
  final isFrequentContext =
      timeContexts.isNotEmpty ||
      prayerContexts.isNotEmpty ||
      dateContexts.isNotEmpty ||
      weatherContexts.isNotEmpty ||
      locationContexts.isNotEmpty ||
      situationContexts.isNotEmpty;

  if (item.isCore || isFrequentContext) {
    surfaces.add('daily_card');
  }

  if (timeContexts.isNotEmpty ||
      prayerContexts.isNotEmpty ||
      dateContexts.isNotEmpty ||
      weatherContexts.isNotEmpty) {
    surfaces.add('lockscreen');
  }

  if ((timeContexts.contains('upon_waking') ||
      timeContexts.contains('morning') ||
      timeContexts.contains('before_sleep') ||
      prayerContexts.contains('after_salah') ||
      prayerContexts.contains('fajr_window'))) {
    surfaces.add('watch');
  }

  if ((dateContexts.contains('laylat_al_qadr') ||
          dateContexts.contains('ramadan') ||
          timeContexts.contains('morning') ||
          timeContexts.contains('before_sleep') ||
          weatherContexts.contains('rain')) &&
      item.isCore) {
    surfaces.add('home_widget');
  }

  if (item.isQuran &&
      (timeContexts.isNotEmpty || dateContexts.isNotEmpty) &&
      item.isCore) {
    surfaces.add('standby');
  }

  if (item.id == 'sunnah_responding_to_a_sneeze') {
    return const <String>['in_app'];
  }

  return surfaces.toList(growable: false);
}

int _priorityScoreFor({
  required DuaItem item,
  required List<String> timeContexts,
  required List<String> dateContexts,
  required List<String> weatherContexts,
  required List<String> locationContexts,
  required List<String> prayerContexts,
  required List<String> situationContexts,
}) {
  var score = item.isCore ? 8 : 5;

  if (timeContexts.contains('upon_waking') ||
      timeContexts.contains('before_sleep') ||
      prayerContexts.contains('after_salah')) {
    score += 1;
  }

  if (dateContexts.contains('laylat_al_qadr') ||
      dateContexts.contains('eid') ||
      dateContexts.contains('arafah')) {
    score -= 1;
  }

  if (weatherContexts.isNotEmpty) {
    score = item.isCore ? score : score - 1;
  }

  if (locationContexts.contains('travel') ||
      locationContexts.contains('new_place')) {
    score = item.isCore ? score : score - 1;
  }

  if (situationContexts.contains('hardship') ||
      situationContexts.contains('illness') ||
      situationContexts.contains('anxiety')) {
    score += 1;
  }

  if (item.subcategory == 'etiquette' || item.subcategory == 'news') {
    score -= 1;
  }

  if (item.id == 'sunnah_responding_to_a_sneeze') {
    score = 3;
  }

  if (item.id == 'sunnah_when_sneezing') {
    score = 4;
  }

  return score.clamp(1, 10);
}

List<String> _normalizeContexts(
  Iterable<String> values, {
  required Set<String> allowed,
}) {
  final normalized = <String>{};
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !allowed.contains(trimmed)) continue;
    normalized.add(trimmed);
  }
  return normalized.toList(growable: false)..sort();
}
