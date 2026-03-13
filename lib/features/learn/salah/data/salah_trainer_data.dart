import '../models/salah_trainer_models.dart';

String _husaryAyahAssetPath(int surahNumber, int ayahNumber) {
  final code =
      '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
  return 'assets/audio/salah/husary/$code.mp3';
}

PrayerStepModel _step({
  required String id,
  required String title,
  required SalahRecitationKind kind,
  required PrayerPostureType posture,
  required String arabic,
  required String transliteration,
  required String translation,
  required int pauseAfterMs,
  String? helperText,
  bool isOptional = false,
  bool isDynamicSurah = false,
}) {
  return PrayerStepModel(
    id: id,
    title: title,
    kind: kind,
    posture: posture,
    arabicText: arabic,
    transliteration: transliteration,
    translation: translation,
    pauseAfterMs: pauseAfterMs,
    helperText: helperText,
    isOptional: isOptional,
    isDynamicSurah: isDynamicSurah,
    ttsText: arabic,
  );
}

List<String> _splitWords(String text) {
  return text
      .trim()
      .split(RegExp(r'\s+'))
      .where((item) => item.trim().isNotEmpty)
      .toList(growable: false);
}

RecitationTimingModel _timingForVerse({
  required String idPrefix,
  required String arabic,
  required String transliteration,
  required String translation,
  required int totalDurationMs,
}) {
  final arabicWords = _splitWords(arabic);
  final transliterationWords = _splitWords(transliteration);
  final translationWords = _splitWords(translation);
  if (arabicWords.isEmpty) {
    return const RecitationTimingModel(
      totalDurationMs: 1400,
      wordTimings: <RecitationWordTimingModel>[],
    );
  }

  final weights = arabicWords
      .map((word) => word.runes.length.clamp(2, 12))
      .toList(growable: false);
  final totalWeight = weights.fold<int>(0, (sum, value) => sum + value);
  final segments = <RecitationWordTimingModel>[];
  var cursor = 0;
  for (var i = 0; i < arabicWords.length; i += 1) {
    final width = ((weights[i] / totalWeight) * totalDurationMs).round();
    final end = i == arabicWords.length - 1 ? totalDurationMs : cursor + width;
    segments.add(
      RecitationWordTimingModel(
        wordId: '$idPrefix-$i',
        arabicText: arabicWords[i],
        transliteration: i < transliterationWords.length
            ? transliterationWords[i]
            : '',
        translation: i < translationWords.length ? translationWords[i] : '',
        startMs: cursor,
        endMs: end,
      ),
    );
    cursor = end;
  }

  return RecitationTimingModel(
    totalDurationMs: totalDurationMs,
    wordTimings: segments,
  );
}

final PrayerStepModel niyyahReminderStep = _step(
  id: 'niyyah',
  title: 'Niyyah reminder',
  kind: SalahRecitationKind.reminder,
  posture: PrayerPostureType.qiyam,
  arabic: 'النِّيَّةُ مَحَلُّهَا الْقَلْبُ',
  transliteration: 'An-niyyatu mahalluha al-qalb.',
  translation:
      'Intention is in the heart. Make a quiet intention for the prayer you are beginning.',
  pauseAfterMs: 1200,
  helperText:
      'No verbal formula is required. Simply know which prayer you are offering.',
);

final PrayerStepModel takbirStep = _step(
  id: 'takbir_al_ihram',
  title: 'Takbir al-Ihram',
  kind: SalahRecitationKind.takbir,
  posture: PrayerPostureType.qiyam,
  arabic: 'اللَّهُ أَكْبَرُ',
  transliteration: 'Allahu akbar.',
  translation: 'Allah is the Greatest.',
  pauseAfterMs: 1400,
);

final PrayerStepModel openingSupplicationStep = _step(
  id: 'opening_supplication',
  title: 'Opening supplication',
  kind: SalahRecitationKind.openingSupplication,
  posture: PrayerPostureType.qiyam,
  arabic:
      'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلَٰهَ غَيْرُكَ',
  transliteration:
      'Subhanakallahumma wa bihamdika wa tabarakasmuka wa ta\'ala jadduka wa la ilaha ghayruk.',
  translation:
      'Glory is to You, O Allah, and praise. Blessed is Your Name, exalted is Your majesty, and none has the right to be worshipped besides You.',
  pauseAfterMs: 2200,
  isOptional: true,
);

final PrayerStepModel fatihahStep = _step(
  id: 'surah_al_fatihah',
  title: 'Surah al-Fatihah',
  kind: SalahRecitationKind.fatihah,
  posture: PrayerPostureType.qiyam,
  arabic:
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ... الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ...',
  transliteration:
      'Bismillahir-Rahmanir-Rahim ... Alhamdu lillahi rabbil alamin ...',
  translation:
      'Recite Surah al-Fatihah with calmness and reflection in every rakah.',
  pauseAfterMs: 2600,
  helperText: 'This is required in every rakah.',
);

final PrayerStepModel additionalSurahStep = _step(
  id: 'additional_surah',
  title: 'Additional surah',
  kind: SalahRecitationKind.additionalSurah,
  posture: PrayerPostureType.qiyam,
  arabic: 'سُورَةٌ قَصِيرَةٌ مِنْ مَحْفُوظَاتِكَ',
  transliteration: 'Suratun qasiratan min mahfuzatika.',
  translation:
      'Recite one short surah from your learned surah pool after al-Fatihah in the first two rakahs.',
  pauseAfterMs: 1800,
  helperText: 'The guided mode will insert a selected surah here.',
  isDynamicSurah: true,
);

final PrayerStepModel qunutStep = _step(
  id: 'qunut',
  title: 'Dua al-Qunut',
  kind: SalahRecitationKind.finalDua,
  posture: PrayerPostureType.qiyam,
  arabic:
      'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ وَعَافِنِي فِيمَنْ عَافَيْتَ وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ وَبَارِكْ لِي فِيمَا أَعْطَيْتَ وَقِنِي شَرَّ مَا قَضَيْتَ فَإِنَّكَ تَقْضِي وَلَا يُقْضَىٰ عَلَيْكَ',
  transliteration:
      'Allahumma ihdini fiman hadayt, wa afini fiman afayt, wa tawallani fiman tawallayt, wa barik li fima a\'tayt, wa qini sharra ma qadayt, fa innaka taqdi wa la yuqda alayk.',
  translation:
      'O Allah, guide me among those You have guided, grant me well-being among those You have granted well-being, take me into Your care among those You have taken into Your care, bless for me what You have given, and protect me from the evil of what You have decreed. Indeed, You decree and none can decree over You.',
  pauseAfterMs: 3200,
  helperText:
      'Often recited in Witr. The exact placement and wording can vary by madhhab.',
);

final PrayerStepModel rukuStep = _step(
  id: 'ruku',
  title: 'Ruku',
  kind: SalahRecitationKind.ruku,
  posture: PrayerPostureType.ruku,
  arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
  transliteration: 'Subhana rabbiyal azim.',
  translation: 'Glory is to my Lord, the Magnificent.',
  pauseAfterMs: 1800,
);

final PrayerStepModel standingAfterRukuStep = _step(
  id: 'standing_after_ruku',
  title: 'Standing after ruku',
  kind: SalahRecitationKind.standingAfterRuku,
  posture: PrayerPostureType.qawmah,
  arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ رَبَّنَا وَلَكَ الْحَمْدُ',
  transliteration: 'Sami Allahu liman hamidah. Rabbana wa lakal hamd.',
  translation:
      'Allah hears the one who praises Him. Our Lord, and to You belongs all praise.',
  pauseAfterMs: 2000,
);

final PrayerStepModel firstSujudStep = _step(
  id: 'first_sujud',
  title: 'First sujud',
  kind: SalahRecitationKind.sujud,
  posture: PrayerPostureType.sujud,
  arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
  transliteration: 'Subhana rabbiyal a\'la.',
  translation: 'Glory is to my Lord, the Most High.',
  pauseAfterMs: 1800,
);

final PrayerStepModel sittingBetweenSujudStep = _step(
  id: 'sitting_between_sujud',
  title: 'Sitting between sujud',
  kind: SalahRecitationKind.sittingBetweenSujud,
  posture: PrayerPostureType.jalsah,
  arabic:
      'رَبِّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَاجْبُرْنِي وَعَافِنِي وَارْزُقْنِي',
  transliteration: 'Rabbighfir li warhamni wahdini wajburni wa afini warzuqni.',
  translation:
      'My Lord, forgive me, have mercy on me, guide me, strengthen me, grant me well-being, and provide for me.',
  pauseAfterMs: 2200,
);

final PrayerStepModel secondSujudStep = _step(
  id: 'second_sujud',
  title: 'Second sujud',
  kind: SalahRecitationKind.sujud,
  posture: PrayerPostureType.sujud,
  arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
  transliteration: 'Subhana rabbiyal a\'la.',
  translation: 'Glory is to my Lord, the Most High.',
  pauseAfterMs: 1800,
);

final PrayerStepModel tashahhudStep = _step(
  id: 'tashahhud',
  title: 'Tashahhud',
  kind: SalahRecitationKind.tashahhud,
  posture: PrayerPostureType.tashahhud,
  arabic:
      'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
  transliteration:
      'At-tahiyyatu lillahi was-salawatu wat-tayyibat, as-salamu alayka ayyuhan-nabiyyu wa rahmatullahi wa barakatuh, as-salamu alayna wa ala ibadillahis-salihin, ashhadu an la ilaha illallah wa ashhadu anna Muhammadan abduhu wa rasuluh.',
  translation:
      'All greetings, prayers, and pure words belong to Allah. Peace be upon you, O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no god except Allah, and I bear witness that Muhammad is His servant and Messenger.',
  pauseAfterMs: 4200,
);

final PrayerStepModel salawatStep = _step(
  id: 'salawat',
  title: 'Salawat Ibrahimiyyah',
  kind: SalahRecitationKind.salawat,
  posture: PrayerPostureType.tashahhud,
  arabic:
      'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ اللَّهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
  transliteration:
      'Allahumma salli ala Muhammad wa ala ali Muhammad kama sallayta ala Ibrahim wa ala ali Ibrahim innaka hamidun majid. Allahumma barik ala Muhammad wa ala ali Muhammad kama barakta ala Ibrahim wa ala ali Ibrahim innaka hamidun majid.',
  translation:
      'O Allah, send prayers upon Muhammad and upon the family of Muhammad as You sent prayers upon Ibrahim and the family of Ibrahim; indeed, You are Praiseworthy and Glorious. O Allah, bless Muhammad and the family of Muhammad as You blessed Ibrahim and the family of Ibrahim; indeed, You are Praiseworthy and Glorious.',
  pauseAfterMs: 4300,
);

final PrayerStepModel finalDuaStep = _step(
  id: 'final_dua',
  title: 'Final dua',
  kind: SalahRecitationKind.finalDua,
  posture: PrayerPostureType.tashahhud,
  arabic:
      'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ وَمِنْ عَذَابِ الْقَبْرِ وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ',
  transliteration:
      'Allahumma inni a\'udhu bika min adhabi jahannam wa min adhabil qabr wa min fitnatil mahya wal mamat wa min sharri fitnatil masihid-dajjal.',
  translation:
      'O Allah, I seek refuge in You from the punishment of Hell, the punishment of the grave, the trials of life and death, and the evil trial of the false messiah.',
  pauseAfterMs: 3600,
  isOptional: true,
);

final PrayerStepModel taslimRightStep = _step(
  id: 'taslim_right',
  title: 'Taslim right',
  kind: SalahRecitationKind.taslim,
  posture: PrayerPostureType.salamRight,
  arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
  transliteration: 'As-salamu alaykum wa rahmatullah.',
  translation: 'Peace and the mercy of Allah be upon you.',
  pauseAfterMs: 1200,
);

final PrayerStepModel taslimLeftStep = _step(
  id: 'taslim_left',
  title: 'Taslim left',
  kind: SalahRecitationKind.taslim,
  posture: PrayerPostureType.salamLeft,
  arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
  transliteration: 'As-salamu alaykum wa rahmatullah.',
  translation: 'Peace and the mercy of Allah be upon you.',
  pauseAfterMs: 1200,
);

List<PrayerStepModel> _firstTwoRakahSteps({required bool includeOpening}) => [
  if (includeOpening) niyyahReminderStep,
  takbirStep,
  if (includeOpening) openingSupplicationStep,
  fatihahStep,
  additionalSurahStep,
  rukuStep,
  standingAfterRukuStep,
  firstSujudStep,
  sittingBetweenSujudStep,
  secondSujudStep,
];

List<PrayerStepModel> _laterRakahSteps({required bool includeTakbir}) => [
  if (includeTakbir) takbirStep,
  fatihahStep,
  rukuStep,
  standingAfterRukuStep,
  firstSujudStep,
  sittingBetweenSujudStep,
  secondSujudStep,
];

List<PrayerStepModel> _finalSittingSteps() => [
  tashahhudStep,
  salawatStep,
  finalDuaStep,
  taslimRightStep,
  taslimLeftStep,
];

PrayerModel _buildPrayer({
  required SalahPrayerId id,
  required String title,
  required String arabicTitle,
  required String shortDescription,
  required String sunnahRakahs,
  required String fardRakahs,
  required String recitationStyle,
  required String overview,
  required int fardRakahCount,
  Map<String, String> madhhabGuidance = const <String, String>{},
  List<String> specialNotes = const <String>[],
  List<List<PrayerStepModel>>? customRakahSteps,
}) {
  final rakahs = <RakaaModel>[];
  for (var i = 1; i <= fardRakahCount; i += 1) {
    final isFirst = i == 1;
    final isSecond = i == 2;
    final isFinal = i == fardRakahCount;
    final steps = customRakahSteps != null
        ? customRakahSteps[i - 1]
        : <PrayerStepModel>[
            ...(i <= 2
                ? _firstTwoRakahSteps(includeOpening: isFirst)
                : _laterRakahSteps(includeTakbir: true)),
            if (isSecond && !isFinal) tashahhudStep,
            if (isFinal) ..._finalSittingSteps(),
          ];
    rakahs.add(RakaaModel(index: i, title: 'Rakah $i', steps: steps));
  }
  return PrayerModel(
    id: id,
    title: title,
    arabicTitle: arabicTitle,
    shortDescription: shortDescription,
    sunnahRakahs: sunnahRakahs,
    fardRakahs: fardRakahs,
    recitationStyle: recitationStyle,
    overview: overview,
    guidedRakahs: rakahs,
    madhhabGuidance: madhhabGuidance,
    specialNotes: specialNotes,
  );
}

final salahPrayers = <PrayerModel>[
  _buildPrayer(
    id: SalahPrayerId.fajr,
    title: 'Fajr',
    arabicTitle: 'الفجر',
    shortDescription: 'The opening prayer of the day, prayed before sunrise.',
    sunnahRakahs: '2 Sunnah',
    fardRakahs: '2 Fard',
    recitationStyle: 'Loud recitation in the fard prayer.',
    overview:
        'Fajr begins the day with calmness, clarity, and dependence on Allah. The guided trainer focuses on the 2 fard rakahs while still showing the sunnah overview.',
    fardRakahCount: 2,
  ),
  _buildPrayer(
    id: SalahPrayerId.dhuhr,
    title: 'Dhuhr',
    arabicTitle: 'الظهر',
    shortDescription:
        'The midday prayer offered after the sun passes its peak.',
    sunnahRakahs: '4 Sunnah before, 2 Sunnah after',
    fardRakahs: '4 Fard',
    recitationStyle: 'Silent recitation.',
    overview:
        'Dhuhr centers the middle of the day. The guided trainer follows the 4 fard rakahs, with the first two including an additional surah after al-Fatihah.',
    fardRakahCount: 4,
  ),
  _buildPrayer(
    id: SalahPrayerId.asr,
    title: 'Asr',
    arabicTitle: 'العصر',
    shortDescription: 'The late afternoon prayer before sunset.',
    sunnahRakahs: '4 Sunnah optional before',
    fardRakahs: '4 Fard',
    recitationStyle: 'Silent recitation.',
    overview:
        'Asr is a prayer of steadfastness. The trainer keeps the structure simple and repeatable so the user can focus on calm movement and consistency.',
    fardRakahCount: 4,
  ),
  _buildPrayer(
    id: SalahPrayerId.maghrib,
    title: 'Maghrib',
    arabicTitle: 'المغرب',
    shortDescription: 'The sunset prayer offered immediately after sunset.',
    sunnahRakahs: '2 Sunnah after',
    fardRakahs: '3 Fard',
    recitationStyle: 'Loud in the first two rakahs, quieter in the third.',
    overview:
        'Maghrib closes the day quickly after sunset. The first two rakahs include an added surah; the third rakah returns to al-Fatihah only before the final sitting.',
    fardRakahCount: 3,
  ),
  _buildPrayer(
    id: SalahPrayerId.isha,
    title: 'Isha',
    arabicTitle: 'العشاء',
    shortDescription: 'The night prayer that closes the daily five prayers.',
    sunnahRakahs: '2 Sunnah after',
    fardRakahs: '4 Fard',
    recitationStyle: 'Loud in the first two rakahs, quieter in the last two.',
    overview:
        'Isha closes the day with stillness. The trainer walks through the 4 fard rakahs and is designed to pair well with slower recitation practice at night.',
    fardRakahCount: 4,
  ),
  _buildPrayer(
    id: SalahPrayerId.witr,
    title: 'Witr',
    arabicTitle: 'الوتر',
    shortDescription:
        'The odd-numbered night prayer prayed after Isha before sleep or before Fajr.',
    sunnahRakahs: 'Night prayer and Witr',
    fardRakahs: 'Commonly 1 or 3 Witr',
    recitationStyle: 'Usually audible enough to hear yourself at night.',
    overview:
        'Witr closes the night prayer with an odd number of rakahs. This trainer models a common 3-rakah flow and includes Qunut guidance in the final rakah.',
    fardRakahCount: 3,
    customRakahSteps: [
      [
        niyyahReminderStep,
        takbirStep,
        openingSupplicationStep,
        fatihahStep,
        additionalSurahStep,
        rukuStep,
        standingAfterRukuStep,
        firstSujudStep,
        sittingBetweenSujudStep,
        secondSujudStep,
      ],
      [
        takbirStep,
        fatihahStep,
        additionalSurahStep,
        rukuStep,
        standingAfterRukuStep,
        firstSujudStep,
        sittingBetweenSujudStep,
        secondSujudStep,
        tashahhudStep,
      ],
      [
        takbirStep,
        fatihahStep,
        additionalSurahStep,
        qunutStep,
        rukuStep,
        standingAfterRukuStep,
        firstSujudStep,
        sittingBetweenSujudStep,
        secondSujudStep,
        ..._finalSittingSteps(),
      ],
    ],
    madhhabGuidance: const {
      'Hanafi':
          'Hanafi guidance commonly treats Witr as 3 rakahs together, with Qunut after the surah in the third rakah before ruku.',
      "Shafi'i":
          "Shafi'i guidance allows 1 or 3 rakahs of Witr, with Qunut commonly associated with the latter part of Ramadan in Fajr and variations in Witr practice.",
      'Maliki':
          'Maliki practice commonly emphasizes Witr as a distinct odd closing prayer, often prayed as one rakah after shaf.',
      'Hanbali':
          'Hanbali guidance allows multiple valid forms of Witr, including 1, 3, 5, and more, while keeping the prayer odd-numbered.',
    },
    specialNotes: const [
      'Valid Witr forms differ across madhhabs and established teaching traditions.',
      'This trainer shows one common guided flow, not the only valid form.',
    ],
  ),
  _buildPrayer(
    id: SalahPrayerId.jummah,
    title: 'Jumu\'ah',
    arabicTitle: 'الجمعة',
    shortDescription:
        'The Friday congregational prayer that replaces Dhuhr for those obligated to attend.',
    sunnahRakahs: 'Sunnah before and after vary',
    fardRakahs: '2 Fard after khutbah',
    recitationStyle: 'Recited aloud in congregation.',
    overview:
        'Jumu\'ah includes the khutbah before the prayer and two rakahs prayed in congregation. The guided flow here focuses on the two prayer rakahs and reminds the user of the khutbah context.',
    fardRakahCount: 2,
    madhhabGuidance: const {
      'Hanafi':
          'Hanafi guidance emphasizes the congregational obligation, khutbah conditions, and attending before the imam ascends the pulpit.',
      "Shafi'i":
          "Shafi'i guidance places detailed conditions on congregation size, khutbah order, and settlement context.",
      'Maliki':
          'Maliki guidance emphasizes the imam-led khutbah, congregation, and the public nature of Jumu\'ah.',
      'Hanbali':
          'Hanbali guidance emphasizes congregational attendance, khutbah attentiveness, and the replacement of Dhuhr by Jumu\'ah for those obligated.',
    },
    specialNotes: const [
      'Jumu\'ah includes two khutbahs before the prayer itself.',
      'If Jumu\'ah is missed or not obligatory in a person\'s circumstance, Dhuhr remains the fallback prayer.',
    ],
  ),
];

final salahRecitations = <RecitationModel>[
  RecitationModel(
    id: 'takbir',
    title: 'Opening Takbir',
    category: 'Opening',
    arabicText: takbirStep.arabicText,
    transliteration: takbirStep.transliteration,
    translation: takbirStep.translation,
    searchTags: const ['takbir', 'allahu akbar', 'opening'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: takbirStep.arabicText,
  ),
  RecitationModel(
    id: 'opening_supplication',
    title: 'Opening Supplication',
    category: 'Opening',
    arabicText: openingSupplicationStep.arabicText,
    transliteration: openingSupplicationStep.transliteration,
    translation: openingSupplicationStep.translation,
    searchTags: const ['thana', 'opening supplication', 'subhanaka'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: openingSupplicationStep.arabicText,
  ),
  RecitationModel(
    id: 'fatihah',
    title: 'Surah al-Fatihah',
    category: 'Standing',
    arabicText:
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    transliteration:
        'Bismillahir-Rahmanir-Rahim. Alhamdu lillahi rabbil alamin. Ar-Rahmanir-Rahim. Maliki yawmid-din. Iyyaka na\'budu wa iyyaka nasta\'in. Ihdinas-siratal-mustaqim. Siratal-ladhina an\'amta alayhim ghayril-maghdubi alayhim wa lad-dallin.',
    translation:
        'In the name of Allah, the Entirely Merciful, the Especially Merciful... Guide us to the straight path.',
    searchTags: const ['fatihah', 'surah al fatihah', 'standing'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText:
        'بسم الله الرحمن الرحيم الحمد لله رب العالمين الرحمن الرحيم مالك يوم الدين إياك نعبد وإياك نستعين اهدنا الصراط المستقيم صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين',
  ),
  RecitationModel(
    id: 'ruku',
    title: 'Ruku Dhikr',
    category: 'Ruku',
    arabicText: rukuStep.arabicText,
    transliteration: rukuStep.transliteration,
    translation: rukuStep.translation,
    searchTags: const ['ruku', 'subhana rabbiyal azim'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: rukuStep.arabicText,
  ),
  RecitationModel(
    id: 'standing_after_ruku',
    title: 'Standing After Ruku',
    category: 'Standing',
    arabicText: standingAfterRukuStep.arabicText,
    transliteration: standingAfterRukuStep.transliteration,
    translation: standingAfterRukuStep.translation,
    searchTags: const ['sami allahu liman hamidah', 'standing after ruku'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: standingAfterRukuStep.arabicText,
  ),
  RecitationModel(
    id: 'sujud',
    title: 'Sujud Dhikr',
    category: 'Sujud',
    arabicText: firstSujudStep.arabicText,
    transliteration: firstSujudStep.transliteration,
    translation: firstSujudStep.translation,
    searchTags: const ['sujud', 'subhana rabbiyal ala'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: firstSujudStep.arabicText,
  ),
  RecitationModel(
    id: 'between_sujud',
    title: 'Sitting Between Sujud',
    category: 'Sitting',
    arabicText: sittingBetweenSujudStep.arabicText,
    transliteration: sittingBetweenSujudStep.transliteration,
    translation: sittingBetweenSujudStep.translation,
    searchTags: const ['between sujud', 'rabbighfir li'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: sittingBetweenSujudStep.arabicText,
  ),
  RecitationModel(
    id: 'tashahhud',
    title: 'Tashahhud',
    category: 'Final Sitting',
    arabicText: tashahhudStep.arabicText,
    transliteration: tashahhudStep.transliteration,
    translation: tashahhudStep.translation,
    searchTags: const ['tashahhud', 'attahiyyatu'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: tashahhudStep.arabicText,
  ),
  RecitationModel(
    id: 'salawat',
    title: 'Salawat Ibrahimiyyah',
    category: 'Final Sitting',
    arabicText: salawatStep.arabicText,
    transliteration: salawatStep.transliteration,
    translation: salawatStep.translation,
    searchTags: const ['salawat', 'allahumma salli ala muhammad'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: salawatStep.arabicText,
  ),
  RecitationModel(
    id: 'final_dua',
    title: 'Final Dua',
    category: 'Final Sitting',
    arabicText: finalDuaStep.arabicText,
    transliteration: finalDuaStep.transliteration,
    translation: finalDuaStep.translation,
    searchTags: const ['final dua', 'allahumma inni audhu bika'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: finalDuaStep.arabicText,
  ),
  RecitationModel(
    id: 'qunut',
    title: 'Dua al-Qunut',
    category: 'Witr',
    arabicText: qunutStep.arabicText,
    transliteration: qunutStep.transliteration,
    translation: qunutStep.translation,
    searchTags: const ['qunut', 'witr dua', 'night prayer'],
    relatedPrayerIds: const [SalahPrayerId.witr],
    ttsText: qunutStep.arabicText,
  ),
  RecitationModel(
    id: 'taslim',
    title: 'Taslim',
    category: 'Closing',
    arabicText: taslimRightStep.arabicText,
    transliteration: taslimRightStep.transliteration,
    translation: taslimRightStep.translation,
    searchTags: const ['taslim', 'assalamu alaykum'],
    relatedPrayerIds: SalahPrayerId.values,
    ttsText: taslimRightStep.arabicText,
  ),
];

final salahEssentials = <SalahEssentialTopic>[
  const SalahEssentialTopic(
    id: 'conditions',
    title: 'Conditions of prayer',
    summary: 'Before salah begins, the foundations around it must be in place.',
    bullets: [
      'Prayer time must have entered.',
      'The body, clothing, and place of prayer should be clean.',
      'Awrah should be covered appropriately.',
      'Face the qiblah as best as you can.',
      'Make the intention in the heart for the prayer you are offering.',
    ],
  ),
  const SalahEssentialTopic(
    id: 'invalidators',
    title: 'What invalidates prayer',
    summary: 'Some things break salah and require starting again.',
    bullets: [
      'Breaking wudu invalidates the prayer.',
      'Intentional speaking unrelated to prayer invalidates it.',
      'Large unnecessary movements break the calmness and can invalidate salah.',
      'Intentionally eating or drinking invalidates prayer.',
      'Losing awareness of the prayer entirely or deliberately turning away from the qiblah invalidates it.',
    ],
  ),
  const SalahEssentialTopic(
    id: 'loud_silent',
    title: 'Loud vs silent prayers',
    summary:
        'Some prayers are recited aloud in the fard prayer and others silently.',
    bullets: [
      'Fajr is recited aloud.',
      'Maghrib and Isha are recited aloud in the first two rakahs.',
      'Dhuhr and Asr are recited silently.',
      'A person praying alone may still follow the normal style of the prayer.',
    ],
  ),
  const SalahEssentialTopic(
    id: 'mistakes',
    title: 'Common beginner mistakes',
    summary:
        'Many mistakes come from rushing or uncertainty rather than neglect.',
    bullets: [
      'Rushing through ruku and sujud without pausing calmly.',
      'Not standing fully after ruku before going down to sujud.',
      'Forgetting that al-Fatihah is recited in every rakah.',
      'Confusing the final sitting with the middle sitting in 3- and 4-rakah prayers.',
      'Letting worry about perfection remove the calmness of prayer.',
    ],
  ),
  const SalahEssentialTopic(
    id: 'intention_timing',
    title: 'Intention and prayer timing',
    summary: 'Prayer is strongest when offered on time with presence.',
    bullets: [
      'Intention is a quiet inward act, not a required spoken formula.',
      'Try to pray early in the prayer window when possible.',
      'Build consistency before chasing complexity.',
      'If you are learning, steady accuracy matters more than speed.',
    ],
  ),
];

SurahModel _surah({
  required String id,
  required int surahNumber,
  required String name,
  required String arabicName,
  required String summary,
  required String reflection,
  required List<(int, String, String, String)> verses,
}) {
  final ayahAudio = verses
      .map((verse) {
        final totalDurationMs =
            1100 + (_splitWords(verse.$2).length * 320).clamp(0, 4000);
        return AyahAudioModel(
          surahNumber: surahNumber,
          ayahNumber: verse.$1,
          localAudioAssetPath: _husaryAyahAssetPath(surahNumber, verse.$1),
          totalDurationMs: totalDurationMs,
          timing: _timingForVerse(
            idPrefix: '$id-${verse.$1}',
            arabic: verse.$2,
            transliteration: verse.$3,
            translation: verse.$4,
            totalDurationMs: totalDurationMs,
          ),
        );
      })
      .toList(growable: false);

  return SurahModel(
    id: id,
    surahNumber: surahNumber,
    name: name,
    arabicName: arabicName,
    summary: summary,
    reflection: reflection,
    verses: List<SurahVerseModel>.generate(verses.length, (index) {
      final verse = verses[index];
      return SurahVerseModel(
        ayahNumber: verse.$1,
        arabicText: verse.$2,
        transliteration: verse.$3,
        translation: verse.$4,
        audio: ayahAudio[index],
      );
    }),
    audio: SurahAudioModel(
      surahId: id,
      reciterId: 'local_guided',
      ayahs: ayahAudio,
    ),
  );
}

final salahSurahs = <SurahModel>[
  _surah(
    id: 'al_fatihah',
    surahNumber: 1,
    name: 'Al-Fatihah',
    arabicName: 'الفاتحة',
    summary: 'The opening surah recited in every rakah of salah.',
    reflection:
        'Al-Fatihah gathers praise, worship, dependence, and dua into one foundational surah repeated throughout the day.',
    verses: const [
      (
        1,
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'Bismillahir-Rahmanir-Rahim.',
        'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      ),
      (
        2,
        'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'Alhamdu lillahi rabbil alamin.',
        '[All] praise is [due] to Allah, Lord of the worlds -',
      ),
      (
        3,
        'الرَّحْمَٰنِ الرَّحِيمِ',
        'Ar-Rahmanir-Rahim.',
        'The Entirely Merciful, the Especially Merciful,',
      ),
      (
        4,
        'مَالِكِ يَوْمِ الدِّينِ',
        'Maliki yawmid-din.',
        'Sovereign of the Day of Recompense.',
      ),
      (
        5,
        'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'Iyyaka na\'budu wa iyyaka nasta\'in.',
        'It is You we worship and You we ask for help.',
      ),
      (
        6,
        'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'Ihdinas-siratal-mustaqim.',
        'Guide us to the straight path -',
      ),
      (
        7,
        'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        'Siratal-ladhina an\'amta alayhim ghayril-maghdubi alayhim wa lad-dallin.',
        'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
      ),
    ],
  ),
  _surah(
    id: 'al_fil',
    surahNumber: 105,
    name: 'Al-Fil',
    arabicName: 'الفيل',
    summary: 'A short surah about the defeat of the army of the elephant.',
    reflection:
        'This surah strengthens trust that Allah protects His sacred signs and can overturn overwhelming power.',
    verses: const [
      (
        1,
        'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ',
        'Alam tara kayfa fa\'ala rabbuka bi-ashabil fil.',
        'Have you not considered, [O Muhammad], how your Lord dealt with the companions of the elephant?',
      ),
      (
        2,
        'أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ',
        'Alam yaj\'al kaydahum fi tadlil.',
        'Did He not make their plan into misguidance?',
      ),
      (
        3,
        'وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ',
        'Wa arsala alayhim tayran ababil.',
        'And He sent against them birds in flocks,',
      ),
      (
        4,
        'تَرْمِيهِمْ بِحِجَارَةٍ مِنْ سِجِّيلٍ',
        'Tarmihim bihijaratin min sijjil.',
        'Striking them with stones of hard clay,',
      ),
      (
        5,
        'فَجَعَلَهُمْ كَعَصْفٍ مَأْكُولٍ',
        'Faja\'alahum ka\'asfin ma\'kul.',
        'And He made them like eaten straw.',
      ),
    ],
  ),
  _surah(
    id: 'quraysh',
    surahNumber: 106,
    name: 'Quraysh',
    arabicName: 'قريش',
    summary:
        'A reminder to Quraysh to worship the Lord who secured and provided for them.',
    reflection:
        'This surah joins gratitude to worship. Security and provision should deepen obedience, not forgetfulness.',
    verses: const [
      (
        1,
        'لِإِيلَافِ قُرَيْشٍ',
        'Li-ilafi Quraysh.',
        'For the accustomed security of Quraysh,',
      ),
      (
        2,
        'إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ',
        'Ilafihim rihlatas-shita\'i was-sayf.',
        'Their accustomed security [in] the caravan of winter and summer,',
      ),
      (
        3,
        'فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ',
        'Fal ya\'budu rabba hadhal-bayt.',
        'Let them worship the Lord of this House,',
      ),
      (
        4,
        'الَّذِي أَطْعَمَهُمْ مِنْ جُوعٍ وَآمَنَهُمْ مِنْ خَوْفٍ',
        'Alladhi at\'amahum min ju\'in wa amanahum min khawf.',
        'Who has fed them, [saving them] from hunger and made them safe, [saving them] from fear.',
      ),
    ],
  ),
  _surah(
    id: 'al_maun',
    surahNumber: 107,
    name: 'Al-Ma\'un',
    arabicName: 'الماعون',
    summary:
        'A warning against neglecting prayer and withholding small acts of care.',
    reflection:
        'Prayer without mercy and sincerity becomes hollow. This surah keeps worship tied to character.',
    verses: const [
      (
        1,
        'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ',
        'Ara\'aytal-ladhi yukadhdhibu bid-din.',
        'Have you seen the one who denies the Recompense?',
      ),
      (
        2,
        'فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ',
        'Fadhalikal-ladhi yadu\'ul-yatim.',
        'For that is the one who drives away the orphan',
      ),
      (
        3,
        'وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ',
        'Wa la yahuddu ala ta\'amil miskin.',
        'And does not encourage the feeding of the poor.',
      ),
      (
        4,
        'فَوَيْلٌ لِلْمُصَلِّينَ',
        'Fawaylun lil-musallin.',
        'So woe to those who pray',
      ),
      (
        5,
        'الَّذِينَ هُمْ عَنْ صَلَاتِهِمْ سَاهُونَ',
        'Alladhina hum an salatihim sahun.',
        'But who are heedless of their prayer -',
      ),
      (
        6,
        'الَّذِينَ هُمْ يُرَاءُونَ',
        'Alladhina hum yura\'un.',
        'Those who make show [of their deeds]',
      ),
      (
        7,
        'وَيَمْنَعُونَ الْمَاعُونَ',
        'Wa yamna\'unal-ma\'un.',
        'And withhold [simple] assistance.',
      ),
    ],
  ),
  _surah(
    id: 'al_kawthar',
    surahNumber: 108,
    name: 'Al-Kawthar',
    arabicName: 'الكوثر',
    summary:
        'A short surah of abundance, prayer, and sacrifice for Allah alone.',
    reflection:
        'This surah teaches the heart to answer blessing with prayer and sincere devotion.',
    verses: const [
      (
        1,
        'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        'Inna a\'taynaka al-kawthar.',
        'Indeed, We have granted you, [O Muhammad], al-Kawthar.',
      ),
      (
        2,
        'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
        'Fasalli lirabbika wanhar.',
        'So pray to your Lord and sacrifice [to Him alone].',
      ),
      (
        3,
        'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
        'Inna shani\'aka huwal-abtar.',
        'Indeed, your enemy is the one cut off.',
      ),
    ],
  ),
  _surah(
    id: 'al_kafirun',
    surahNumber: 109,
    name: 'Al-Kafirun',
    arabicName: 'الكافرون',
    summary:
        'A clear declaration of worshiping Allah alone without compromise.',
    reflection:
        'This surah steadies intention. Worship belongs to Allah alone, without negotiation or blending.',
    verses: const [
      (
        1,
        'قُلْ يَا أَيُّهَا الْكَافِرُونَ',
        'Qul ya ayyuhal-kafirun.',
        'Say, "O disbelievers,',
      ),
      (
        2,
        'لَا أَعْبُدُ مَا تَعْبُدُونَ',
        'La a\'budu ma ta\'budun.',
        'I do not worship what you worship.',
      ),
      (
        3,
        'وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ',
        'Wa la antum abiduna ma a\'bud.',
        'Nor are you worshippers of what I worship.',
      ),
      (
        4,
        'وَلَا أَنَا عَابِدٌ مَا عَبَدْتُمْ',
        'Wa la ana abidum ma abadtum.',
        'Nor will I be a worshipper of what you worship.',
      ),
      (
        5,
        'وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ',
        'Wa la antum abiduna ma a\'bud.',
        'Nor will you be worshippers of what I worship.',
      ),
      (
        6,
        'لَكُمْ دِينُكُمْ وَلِيَ دِينِ',
        'Lakum dinukum wa liya din.',
        'For you is your religion, and for me is my religion."',
      ),
    ],
  ),
  _surah(
    id: 'an_nasr',
    surahNumber: 110,
    name: 'An-Nasr',
    arabicName: 'النصر',
    summary:
        'A surah about Allah\'s help, victory, and ending success with praise and repentance.',
    reflection:
        'Even in victory, the believer responds with tasbih, gratitude, and repentance rather than self-congratulation.',
    verses: const [
      (
        1,
        'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
        'Idha ja\'a nasrullahi wal-fath.',
        'When the victory of Allah has come and the conquest,',
      ),
      (
        2,
        'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
        'Wa ra\'aytan-nasa yadkhuluna fi dinillahi afwaja.',
        'And you see the people entering into the religion of Allah in multitudes,',
      ),
      (
        3,
        'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا',
        'Fasabbih bihamdi rabbika wastaghfirh, innahu kana tawwaba.',
        'Then exalt [Him] with praise of your Lord and ask forgiveness of Him. Indeed, He is ever Accepting of repentance.',
      ),
    ],
  ),
  _surah(
    id: 'al_masad',
    surahNumber: 111,
    name: 'Al-Masad',
    arabicName: 'المسد',
    summary: 'A warning against arrogance, hostility, and relying on wealth.',
    reflection:
        'This surah reminds the heart that lineage, wealth, and status do not protect a person from truth or accountability.',
    verses: const [
      (
        1,
        'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ',
        'Tabbat yada abi lahabin wa tabb.',
        'May the hands of Abu Lahab be ruined, and ruined is he.',
      ),
      (
        2,
        'مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ',
        'Ma aghna anhu maluhu wa ma kasab.',
        'His wealth will not avail him or that which he gained.',
      ),
      (
        3,
        'سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ',
        'Sayasla naran dhata lahab.',
        'He will [enter to] burn in a Fire of [blazing] flame',
      ),
      (
        4,
        'وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ',
        'Wamra\'atuhu hammalatal-hatab.',
        'And his wife [as well] - the carrier of firewood.',
      ),
      (
        5,
        'فِي جِيدِهَا حَبْلٌ مِنْ مَسَدٍ',
        'Fi jidiha hablun mim masad.',
        'Around her neck is a rope of [twisted] fiber.',
      ),
    ],
  ),
  _surah(
    id: 'al_ikhlas',
    surahNumber: 112,
    name: 'Al-Ikhlas',
    arabicName: 'الإخلاص',
    summary: 'A foundational surah on the oneness and uniqueness of Allah.',
    reflection:
        'This surah purifies belief and centers the heart on Allah alone. It is short, but immense in meaning.',
    verses: const [
      (
        1,
        'قُلْ هُوَ اللَّهُ أَحَدٌ',
        'Qul huwa Allahu ahad.',
        'Say, "He is Allah, [who is] One,',
      ),
      (
        2,
        'اللَّهُ الصَّمَدُ',
        'Allahu as-samad.',
        'Allah, the Eternal Refuge.',
      ),
      (
        3,
        'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        'Lam yalid wa lam yulad.',
        'He neither begets nor is born,',
      ),
      (
        4,
        'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
        'Wa lam yakun lahu kufuwan ahad.',
        'Nor is there to Him any equivalent."',
      ),
    ],
  ),
  _surah(
    id: 'al_falaq',
    surahNumber: 113,
    name: 'Al-Falaq',
    arabicName: 'الفلق',
    summary: 'A surah of seeking Allah\'s protection from external harms.',
    reflection:
        'This surah trains the heart to seek refuge in Allah when harm, envy, darkness, or hidden evil feels close.',
    verses: const [
      (
        1,
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        'Qul a\'udhu birabbil-falaq.',
        'Say, "I seek refuge in the Lord of daybreak',
      ),
      (
        2,
        'مِنْ شَرِّ مَا خَلَقَ',
        'Min sharri ma khalaq.',
        'From the evil of that which He created',
      ),
      (
        3,
        'وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        'Wa min sharri ghasiqin idha waqab.',
        'And from the evil of darkness when it settles',
      ),
      (
        4,
        'وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
        'Wa min sharrin-naffathati fil-uqad.',
        'And from the evil of the blowers in knots',
      ),
      (
        5,
        'وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        'Wa min sharri hasidin idha hasad.',
        'And from the evil of an envier when he envies."',
      ),
    ],
  ),
  _surah(
    id: 'an_nas',
    surahNumber: 114,
    name: 'An-Nas',
    arabicName: 'الناس',
    summary: 'A surah of seeking Allah\'s protection from inward whisperings.',
    reflection:
        'This surah builds inward vigilance. It reminds the believer to return to the Lord of humankind when whispers disturb the heart.',
    verses: const [
      (
        1,
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        'Qul a\'udhu birabbin-nas.',
        'Say, "I seek refuge in the Lord of mankind,',
      ),
      (2, 'مَلِكِ النَّاسِ', 'Malikin-nas.', 'The Sovereign of mankind.'),
      (3, 'إِلَٰهِ النَّاسِ', 'Ilahin-nas.', 'The God of mankind,'),
      (
        4,
        'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
        'Min sharril-waswasil-khannas.',
        'From the evil of the retreating whisperer -',
      ),
      (
        5,
        'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
        'Alladhi yuwaswisu fi sudurin-nas.',
        'Who whispers [evil] into the breasts of mankind -',
      ),
      (
        6,
        'مِنَ الْجِنَّةِ وَالنَّاسِ',
        'Minal-jinnati wan-nas.',
        'From among the jinn and mankind."',
      ),
    ],
  ),
];

const initialUnlockedSurahIds = <String>{'al_ikhlas', 'al_falaq', 'an_nas'};
