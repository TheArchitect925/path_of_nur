import 'package:quran/quran.dart' as quran;

import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/salah_trainer_models.dart';

String _husaryAyahAssetPath(int surahNumber, int ayahNumber) {
  final code =
      '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
  return 'assets/audio/salah/husary/$code.mp3';
}

/// Where a human recording of a dhikr or dua lives once it ships. The audio
/// service falls back to speech while the slot is empty, so declaring a path
/// here never breaks playback.
String salahAdhkarAssetPath(String audioId) =>
    'assets/audio/salah/adhkar/$audioId.mp3';

/// Every recording slot the trainer can fill. Drop `<id>.mp3` files with
/// these names into `assets/audio/salah/adhkar/` to replace speech.
const salahAdhkarAudioIds = <String>[
  'takbir',
  'opening_supplication',
  'qunut',
  'ruku',
  'standing_after_ruku',
  'sujud',
  'sitting_between_sujud',
  'tashahhud',
  'salawat',
  'final_dua',
  'taslim',
];

/// The short surahs a learner can be given in guided prayer, in the order
/// they unlock. Al-Fatihah is not in the pool: it is recited in every rakah.
const salahShortSurahIds = <String>[
  'al_fil',
  'quraysh',
  'al_maun',
  'al_kawthar',
  'al_kafirun',
  'an_nasr',
  'al_masad',
  'al_ikhlas',
  'al_falaq',
  'an_nas',
];

const initialUnlockedSurahIds = <String>{'al_ikhlas', 'al_falaq', 'an_nas'};

/// The trainer's content for one language. Structure, Arabic text,
/// transliteration and audio are fixed; every title, meaning and note comes
/// from the ARB files, and ayah meanings from the Qur'an package's
/// translation for that language.
class SalahTrainerContent {
  const SalahTrainerContent({
    required this.prayers,
    required this.surahs,
    required this.recitations,
    required this.essentials,
    required this.takbirSegment,
  });

  final List<PrayerModel> prayers;
  final List<SurahModel> surahs;
  final List<RecitationModel> recitations;
  final List<SalahEssentialTopic> essentials;

  /// "Allahu akbar" as recited when moving between postures.
  final RecitationSegment takbirSegment;

  PrayerModel? prayerById(SalahPrayerId id) {
    for (final prayer in prayers) {
      if (prayer.id == id) return prayer;
    }
    return null;
  }

  SurahModel? surahById(String id) {
    for (final surah in surahs) {
      if (surah.id == id) return surah;
    }
    return null;
  }
}

SalahTrainerContent buildSalahTrainerContent(AppLocalizations l10n) {
  final steps = _SalahSteps(l10n);
  final surahs = _buildSurahs(l10n);
  final fatihah = surahs.firstWhere((surah) => surah.id == 'al_fatihah');
  return SalahTrainerContent(
    prayers: _buildPrayers(l10n, steps),
    surahs: surahs,
    recitations: _buildRecitations(l10n, steps, fatihah),
    essentials: _buildEssentials(l10n),
    takbirSegment: RecitationSegment(
      id: 'takbir',
      arabicText: steps.takbirStep.segments.single.arabicText,
      transliteration: steps.takbirStep.segments.single.transliteration,
      translation: l10n.salahTrainerStepTakbirTranslation,
      audioAssetPath: salahAdhkarAssetPath('takbir'),
    ),
  );
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
  String? audioId,
  String? surahId,
  int repeatCount = 1,
  bool entryTakbir = false,
  bool isSilent = false,
  bool isOptional = false,
  bool isDynamicSurah = false,
}) {
  return PrayerStepModel(
    id: id,
    title: title,
    kind: kind,
    posture: posture,
    segments: [
      RecitationSegment(
        id: id,
        arabicText: arabic,
        transliteration: transliteration,
        translation: translation,
        audioAssetPath: isSilent ? null : salahAdhkarAssetPath(audioId ?? id),
      ),
    ],
    pauseAfterMs: pauseAfterMs,
    helperText: helperText,
    surahId: surahId,
    repeatCount: repeatCount,
    entryTakbir: entryTakbir,
    isSilent: isSilent,
    isOptional: isOptional,
    isDynamicSurah: isDynamicSurah,
  );
}

/// The building blocks of every rakah, in one language.
class _SalahSteps {
  _SalahSteps(AppLocalizations l10n) {
    niyyahReminderStep = _step(
      id: 'niyyah',
      title: l10n.salahTrainerStepNiyyahTitle,
      kind: SalahRecitationKind.reminder,
      posture: PrayerPostureType.qiyam,
      arabic: 'النِّيَّةُ مَحَلُّهَا الْقَلْبُ',
      transliteration: 'An-niyyatu mahalluha al-qalb.',
      translation: l10n.salahTrainerStepNiyyahTranslation,
      pauseAfterMs: 1200,
      helperText: l10n.salahTrainerStepNiyyahHelper,
      isSilent: true,
    );
    takbirStep = _step(
      id: 'takbir_al_ihram',
      title: l10n.salahTrainerStepTakbirAlIhramTitle,
      kind: SalahRecitationKind.takbir,
      posture: PrayerPostureType.qiyam,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu akbar.',
      translation: l10n.salahTrainerStepTakbirTranslation,
      pauseAfterMs: 1400,
      audioId: 'takbir',
    );
    risingTakbirStep = _step(
      id: 'takbir_rising',
      title: l10n.salahTrainerStepTakbirRisingTitle,
      kind: SalahRecitationKind.takbir,
      posture: PrayerPostureType.qiyam,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu akbar.',
      translation: l10n.salahTrainerStepTakbirTranslation,
      pauseAfterMs: 1000,
      helperText: l10n.salahTrainerStepTakbirRisingHelper,
      audioId: 'takbir',
    );
    openingSupplicationStep = _step(
      id: 'opening_supplication',
      title: l10n.salahTrainerStepOpeningSupplicationTitle,
      kind: SalahRecitationKind.openingSupplication,
      posture: PrayerPostureType.qiyam,
      arabic:
          'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلَٰهَ غَيْرُكَ',
      transliteration:
          'Subhanakallahumma wa bihamdika wa tabarakasmuka wa ta\'ala jadduka wa la ilaha ghayruk.',
      translation: l10n.salahTrainerStepOpeningSupplicationTranslation,
      pauseAfterMs: 2200,
      isOptional: true,
    );
    fatihahStep = _step(
      id: 'surah_al_fatihah',
      title: l10n.salahTrainerStepFatihahTitle,
      kind: SalahRecitationKind.fatihah,
      posture: PrayerPostureType.qiyam,
      arabic:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ... الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ...',
      transliteration:
          'Bismillahir-Rahmanir-Rahim ... Alhamdu lillahi rabbil alamin ...',
      translation: l10n.salahTrainerStepFatihahTranslation,
      pauseAfterMs: 2600,
      helperText: l10n.salahTrainerStepFatihahHelper,
      surahId: 'al_fatihah',
    );
    additionalSurahStep = _step(
      id: 'additional_surah',
      title: l10n.salahTrainerStepAdditionalSurahTitle,
      kind: SalahRecitationKind.additionalSurah,
      posture: PrayerPostureType.qiyam,
      arabic: 'سُورَةٌ قَصِيرَةٌ مِنْ مَحْفُوظَاتِكَ',
      transliteration: 'Suratun qasiratan min mahfuzatika.',
      translation: l10n.salahTrainerStepAdditionalSurahTranslation,
      pauseAfterMs: 1800,
      helperText: l10n.salahTrainerStepAdditionalSurahHelper,
      isSilent: true,
      isDynamicSurah: true,
    );
    qunutStep = _step(
      id: 'qunut',
      title: l10n.salahTrainerStepQunutTitle,
      kind: SalahRecitationKind.finalDua,
      posture: PrayerPostureType.qiyam,
      arabic:
          'اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ وَعَافِنِي فِيمَنْ عَافَيْتَ وَتَوَلَّنِي فِيمَنْ تَوَلَّيْتَ وَبَارِكْ لِي فِيمَا أَعْطَيْتَ وَقِنِي شَرَّ مَا قَضَيْتَ فَإِنَّكَ تَقْضِي وَلَا يُقْضَىٰ عَلَيْكَ',
      transliteration:
          'Allahumma ihdini fiman hadayt, wa afini fiman afayt, wa tawallani fiman tawallayt, wa barik li fima a\'tayt, wa qini sharra ma qadayt, fa innaka taqdi wa la yuqda alayk.',
      translation: l10n.salahTrainerStepQunutTranslation,
      pauseAfterMs: 3200,
      helperText: l10n.salahTrainerStepQunutHelper,
    );
    rukuStep = _step(
      id: 'ruku',
      title: l10n.salahTrainerStepRukuTitle,
      kind: SalahRecitationKind.ruku,
      posture: PrayerPostureType.ruku,
      arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      transliteration: 'Subhana rabbiyal azim.',
      translation: l10n.salahTrainerStepRukuTranslation,
      pauseAfterMs: 1800,
      repeatCount: 3,
      entryTakbir: true,
    );
    standingAfterRukuStep = _step(
      id: 'standing_after_ruku',
      title: l10n.salahTrainerStepStandingAfterRukuTitle,
      kind: SalahRecitationKind.standingAfterRuku,
      posture: PrayerPostureType.qawmah,
      arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ رَبَّنَا وَلَكَ الْحَمْدُ',
      transliteration: 'Sami Allahu liman hamidah. Rabbana wa lakal hamd.',
      translation: l10n.salahTrainerStepStandingAfterRukuTranslation,
      pauseAfterMs: 2000,
    );
    firstSujudStep = _step(
      id: 'first_sujud',
      title: l10n.salahTrainerStepFirstSujudTitle,
      kind: SalahRecitationKind.sujud,
      posture: PrayerPostureType.sujud,
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
      transliteration: 'Subhana rabbiyal a\'la.',
      translation: l10n.salahTrainerStepSujudTranslation,
      pauseAfterMs: 1800,
      audioId: 'sujud',
      repeatCount: 3,
      entryTakbir: true,
    );
    sittingBetweenSujudStep = _step(
      id: 'sitting_between_sujud',
      title: l10n.salahTrainerStepSittingBetweenSujudTitle,
      kind: SalahRecitationKind.sittingBetweenSujud,
      posture: PrayerPostureType.jalsah,
      arabic:
          'رَبِّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَاجْبُرْنِي وَعَافِنِي وَارْزُقْنِي',
      transliteration:
          'Rabbighfir li warhamni wahdini wajburni wa afini warzuqni.',
      translation: l10n.salahTrainerStepSittingBetweenSujudTranslation,
      pauseAfterMs: 2200,
      entryTakbir: true,
    );
    secondSujudStep = _step(
      id: 'second_sujud',
      title: l10n.salahTrainerStepSecondSujudTitle,
      kind: SalahRecitationKind.sujud,
      posture: PrayerPostureType.sujud,
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَىٰ',
      transliteration: 'Subhana rabbiyal a\'la.',
      translation: l10n.salahTrainerStepSujudTranslation,
      pauseAfterMs: 1800,
      audioId: 'sujud',
      repeatCount: 3,
      entryTakbir: true,
    );
    tashahhudStep = _step(
      id: 'tashahhud',
      title: l10n.salahTrainerStepTashahhudTitle,
      kind: SalahRecitationKind.tashahhud,
      posture: PrayerPostureType.tashahhud,
      arabic:
          'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      transliteration:
          'At-tahiyyatu lillahi was-salawatu wat-tayyibat, as-salamu alayka ayyuhan-nabiyyu wa rahmatullahi wa barakatuh, as-salamu alayna wa ala ibadillahis-salihin, ashhadu an la ilaha illallah wa ashhadu anna Muhammadan abduhu wa rasuluh.',
      translation: l10n.salahTrainerStepTashahhudTranslation,
      pauseAfterMs: 4200,
      entryTakbir: true,
    );
    salawatStep = _step(
      id: 'salawat',
      title: l10n.salahTrainerStepSalawatTitle,
      kind: SalahRecitationKind.salawat,
      posture: PrayerPostureType.tashahhud,
      arabic:
          'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ اللَّهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      transliteration:
          'Allahumma salli ala Muhammad wa ala ali Muhammad kama sallayta ala Ibrahim wa ala ali Ibrahim innaka hamidun majid. Allahumma barik ala Muhammad wa ala ali Muhammad kama barakta ala Ibrahim wa ala ali Ibrahim innaka hamidun majid.',
      translation: l10n.salahTrainerStepSalawatTranslation,
      pauseAfterMs: 4300,
    );
    finalDuaStep = _step(
      id: 'final_dua',
      title: l10n.salahTrainerStepFinalDuaTitle,
      kind: SalahRecitationKind.finalDua,
      posture: PrayerPostureType.tashahhud,
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ وَمِنْ عَذَابِ الْقَبْرِ وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ',
      transliteration:
          'Allahumma inni a\'udhu bika min adhabi jahannam wa min adhabil qabr wa min fitnatil mahya wal mamat wa min sharri fitnatil masihid-dajjal.',
      translation: l10n.salahTrainerStepFinalDuaTranslation,
      pauseAfterMs: 3600,
      isOptional: true,
    );
    taslimRightStep = _step(
      id: 'taslim_right',
      title: l10n.salahTrainerStepTaslimRightTitle,
      kind: SalahRecitationKind.taslim,
      posture: PrayerPostureType.salamRight,
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      transliteration: 'As-salamu alaykum wa rahmatullah.',
      translation: l10n.salahTrainerStepTaslimTranslation,
      pauseAfterMs: 1200,
      audioId: 'taslim',
    );
    taslimLeftStep = _step(
      id: 'taslim_left',
      title: l10n.salahTrainerStepTaslimLeftTitle,
      kind: SalahRecitationKind.taslim,
      posture: PrayerPostureType.salamLeft,
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      transliteration: 'As-salamu alaykum wa rahmatullah.',
      translation: l10n.salahTrainerStepTaslimTranslation,
      pauseAfterMs: 1200,
      audioId: 'taslim',
    );
  }

  late final PrayerStepModel niyyahReminderStep;
  late final PrayerStepModel takbirStep;
  late final PrayerStepModel risingTakbirStep;
  late final PrayerStepModel openingSupplicationStep;
  late final PrayerStepModel fatihahStep;
  late final PrayerStepModel additionalSurahStep;
  late final PrayerStepModel qunutStep;
  late final PrayerStepModel rukuStep;
  late final PrayerStepModel standingAfterRukuStep;
  late final PrayerStepModel firstSujudStep;
  late final PrayerStepModel sittingBetweenSujudStep;
  late final PrayerStepModel secondSujudStep;
  late final PrayerStepModel tashahhudStep;
  late final PrayerStepModel salawatStep;
  late final PrayerStepModel finalDuaStep;
  late final PrayerStepModel taslimRightStep;
  late final PrayerStepModel taslimLeftStep;

  List<PrayerStepModel> firstTwoRakahs({required bool includeOpening}) => [
    if (includeOpening) niyyahReminderStep,
    // The opening takbir happens once; every later rakah rises with a plain one.
    includeOpening ? takbirStep : risingTakbirStep,
    if (includeOpening) openingSupplicationStep,
    fatihahStep,
    additionalSurahStep,
    rukuStep,
    standingAfterRukuStep,
    firstSujudStep,
    sittingBetweenSujudStep,
    secondSujudStep,
  ];

  List<PrayerStepModel> laterRakah({required bool includeTakbir}) => [
    if (includeTakbir) risingTakbirStep,
    fatihahStep,
    rukuStep,
    standingAfterRukuStep,
    firstSujudStep,
    sittingBetweenSujudStep,
    secondSujudStep,
  ];

  List<PrayerStepModel> get finalSitting => [
    tashahhudStep,
    salawatStep,
    finalDuaStep,
    taslimRightStep,
    taslimLeftStep,
  ];
}

PrayerModel _buildPrayer(
  _SalahSteps steps, {
  required SalahPrayerId id,
  required String title,
  required String arabicTitle,
  required String shortDescription,
  required String sunnahRakahs,
  required String fardRakahs,
  required String recitationStyle,
  required String overview,
  required int fardRakahCount,
  Map<PrayerMadhab, String> madhhabGuidance = const <PrayerMadhab, String>{},
  List<String> specialNotes = const <String>[],
  List<List<PrayerStepModel>>? customRakahSteps,
}) {
  final rakahs = <RakaaModel>[];
  for (var i = 1; i <= fardRakahCount; i += 1) {
    final isFirst = i == 1;
    final isSecond = i == 2;
    final isFinal = i == fardRakahCount;
    final rakahSteps = customRakahSteps != null
        ? customRakahSteps[i - 1]
        : <PrayerStepModel>[
            ...(i <= 2
                ? steps.firstTwoRakahs(includeOpening: isFirst)
                : steps.laterRakah(includeTakbir: true)),
            if (isSecond && !isFinal) steps.tashahhudStep,
            if (isFinal) ...steps.finalSitting,
          ];
    rakahs.add(RakaaModel(index: i, steps: rakahSteps));
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

List<PrayerModel> _buildPrayers(AppLocalizations l10n, _SalahSteps steps) {
  return <PrayerModel>[
    _buildPrayer(
      steps,
      id: SalahPrayerId.fajr,
      arabicTitle: 'الفجر',
      fardRakahCount: 2,
      title: l10n.salahTrainerPrayerFajrTitle,
      shortDescription: l10n.salahTrainerPrayerFajrDescription,
      sunnahRakahs: l10n.salahTrainerPrayerFajrSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerFajrFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerFajrRecitationStyle,
      overview: l10n.salahTrainerPrayerFajrOverview,
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.dhuhr,
      arabicTitle: 'الظهر',
      fardRakahCount: 4,
      title: l10n.salahTrainerPrayerDhuhrTitle,
      shortDescription: l10n.salahTrainerPrayerDhuhrDescription,
      sunnahRakahs: l10n.salahTrainerPrayerDhuhrSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerDhuhrFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerDhuhrRecitationStyle,
      overview: l10n.salahTrainerPrayerDhuhrOverview,
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.asr,
      arabicTitle: 'العصر',
      fardRakahCount: 4,
      title: l10n.salahTrainerPrayerAsrTitle,
      shortDescription: l10n.salahTrainerPrayerAsrDescription,
      sunnahRakahs: l10n.salahTrainerPrayerAsrSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerAsrFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerAsrRecitationStyle,
      overview: l10n.salahTrainerPrayerAsrOverview,
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.maghrib,
      arabicTitle: 'المغرب',
      fardRakahCount: 3,
      title: l10n.salahTrainerPrayerMaghribTitle,
      shortDescription: l10n.salahTrainerPrayerMaghribDescription,
      sunnahRakahs: l10n.salahTrainerPrayerMaghribSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerMaghribFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerMaghribRecitationStyle,
      overview: l10n.salahTrainerPrayerMaghribOverview,
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.isha,
      arabicTitle: 'العشاء',
      fardRakahCount: 4,
      title: l10n.salahTrainerPrayerIshaTitle,
      shortDescription: l10n.salahTrainerPrayerIshaDescription,
      sunnahRakahs: l10n.salahTrainerPrayerIshaSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerIshaFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerIshaRecitationStyle,
      overview: l10n.salahTrainerPrayerIshaOverview,
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.witr,
      arabicTitle: 'الوتر',
      fardRakahCount: 3,
      title: l10n.salahTrainerPrayerWitrTitle,
      shortDescription: l10n.salahTrainerPrayerWitrDescription,
      sunnahRakahs: l10n.salahTrainerPrayerWitrSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerWitrFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerWitrRecitationStyle,
      overview: l10n.salahTrainerPrayerWitrOverview,
      customRakahSteps: [
        [
          steps.niyyahReminderStep,
          steps.takbirStep,
          steps.openingSupplicationStep,
          steps.fatihahStep,
          steps.additionalSurahStep,
          steps.rukuStep,
          steps.standingAfterRukuStep,
          steps.firstSujudStep,
          steps.sittingBetweenSujudStep,
          steps.secondSujudStep,
        ],
        [
          steps.risingTakbirStep,
          steps.fatihahStep,
          steps.additionalSurahStep,
          steps.rukuStep,
          steps.standingAfterRukuStep,
          steps.firstSujudStep,
          steps.sittingBetweenSujudStep,
          steps.secondSujudStep,
          steps.tashahhudStep,
        ],
        [
          steps.risingTakbirStep,
          steps.fatihahStep,
          steps.additionalSurahStep,
          steps.qunutStep,
          steps.rukuStep,
          steps.standingAfterRukuStep,
          steps.firstSujudStep,
          steps.sittingBetweenSujudStep,
          steps.secondSujudStep,
          ...steps.finalSitting,
        ],
      ],
      madhhabGuidance: {
        PrayerMadhab.hanafi: l10n.salahTrainerWitrGuidanceHanafi,
        PrayerMadhab.shafii: l10n.salahTrainerWitrGuidanceShafii,
        PrayerMadhab.maliki: l10n.salahTrainerWitrGuidanceMaliki,
        PrayerMadhab.hanbali: l10n.salahTrainerWitrGuidanceHanbali,
      },
      specialNotes: [l10n.salahTrainerWitrNote1, l10n.salahTrainerWitrNote2],
    ),
    _buildPrayer(
      steps,
      id: SalahPrayerId.jummah,
      arabicTitle: 'الجمعة',
      fardRakahCount: 2,
      title: l10n.salahTrainerPrayerJummahTitle,
      shortDescription: l10n.salahTrainerPrayerJummahDescription,
      sunnahRakahs: l10n.salahTrainerPrayerJummahSunnahRakahs,
      fardRakahs: l10n.salahTrainerPrayerJummahFardRakahs,
      recitationStyle: l10n.salahTrainerPrayerJummahRecitationStyle,
      overview: l10n.salahTrainerPrayerJummahOverview,
      madhhabGuidance: {
        PrayerMadhab.hanafi: l10n.salahTrainerJummahGuidanceHanafi,
        PrayerMadhab.shafii: l10n.salahTrainerJummahGuidanceShafii,
        PrayerMadhab.maliki: l10n.salahTrainerJummahGuidanceMaliki,
        PrayerMadhab.hanbali: l10n.salahTrainerJummahGuidanceHanbali,
      },
      specialNotes: [
        l10n.salahTrainerJummahNote1,
        l10n.salahTrainerJummahNote2,
      ],
    ),
  ];
}

List<RecitationModel> _buildRecitations(
  AppLocalizations l10n,
  _SalahSteps steps,
  SurahModel fatihah,
) {
  return <RecitationModel>[
    RecitationModel(
      id: 'takbir',
      title: l10n.salahTrainerRecitationTakbirTitle,
      category: l10n.salahTrainerRecitationCategoryOpening,
      segments: steps.takbirStep.segments,
      searchTags: const ['takbir', 'allahu akbar', 'opening'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'opening_supplication',
      title: l10n.salahTrainerRecitationOpeningSupplicationTitle,
      category: l10n.salahTrainerRecitationCategoryOpening,
      segments: steps.openingSupplicationStep.segments,
      searchTags: const ['thana', 'opening supplication', 'subhanaka'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'fatihah',
      title: l10n.salahTrainerRecitationFatihahTitle,
      category: l10n.salahTrainerRecitationCategoryStanding,
      segments: fatihah.segments,
      searchTags: const ['fatihah', 'surah al fatihah', 'standing'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'ruku',
      title: l10n.salahTrainerRecitationRukuTitle,
      category: l10n.salahTrainerRecitationCategoryRuku,
      segments: steps.rukuStep.segments,
      searchTags: const ['ruku', 'subhana rabbiyal azim'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'standing_after_ruku',
      title: l10n.salahTrainerRecitationStandingAfterRukuTitle,
      category: l10n.salahTrainerRecitationCategoryStanding,
      segments: steps.standingAfterRukuStep.segments,
      searchTags: const ['sami allahu liman hamidah', 'standing after ruku'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'sujud',
      title: l10n.salahTrainerRecitationSujudTitle,
      category: l10n.salahTrainerRecitationCategorySujud,
      segments: steps.firstSujudStep.segments,
      searchTags: const ['sujud', 'subhana rabbiyal ala'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'between_sujud',
      title: l10n.salahTrainerRecitationBetweenSujudTitle,
      category: l10n.salahTrainerRecitationCategorySitting,
      segments: steps.sittingBetweenSujudStep.segments,
      searchTags: const ['between sujud', 'rabbighfir li'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'tashahhud',
      title: l10n.salahTrainerRecitationTashahhudTitle,
      category: l10n.salahTrainerRecitationCategoryFinalSitting,
      segments: steps.tashahhudStep.segments,
      searchTags: const ['tashahhud', 'attahiyyatu'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'salawat',
      title: l10n.salahTrainerRecitationSalawatTitle,
      category: l10n.salahTrainerRecitationCategoryFinalSitting,
      segments: steps.salawatStep.segments,
      searchTags: const ['salawat', 'allahumma salli ala muhammad'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'final_dua',
      title: l10n.salahTrainerRecitationFinalDuaTitle,
      category: l10n.salahTrainerRecitationCategoryFinalSitting,
      segments: steps.finalDuaStep.segments,
      searchTags: const ['final dua', 'allahumma inni audhu bika'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
    RecitationModel(
      id: 'qunut',
      title: l10n.salahTrainerRecitationQunutTitle,
      category: l10n.salahTrainerRecitationCategoryWitr,
      segments: steps.qunutStep.segments,
      searchTags: const ['qunut', 'witr dua', 'night prayer'],
      relatedPrayerIds: const [SalahPrayerId.witr],
    ),
    RecitationModel(
      id: 'taslim',
      title: l10n.salahTrainerRecitationTaslimTitle,
      category: l10n.salahTrainerRecitationCategoryClosing,
      segments: steps.taslimRightStep.segments,
      searchTags: const ['taslim', 'assalamu alaykum'],
      relatedPrayerIds: SalahPrayerId.values,
    ),
  ];
}

List<SalahEssentialTopic> _buildEssentials(AppLocalizations l10n) {
  return <SalahEssentialTopic>[
    SalahEssentialTopic(
      id: 'conditions',
      title: l10n.salahTrainerEssentialConditionsTitle,
      summary: l10n.salahTrainerEssentialConditionsSummary,
      bullets: [
        l10n.salahTrainerEssentialConditionsBullet1,
        l10n.salahTrainerEssentialConditionsBullet2,
        l10n.salahTrainerEssentialConditionsBullet3,
        l10n.salahTrainerEssentialConditionsBullet4,
        l10n.salahTrainerEssentialConditionsBullet5,
      ],
    ),
    SalahEssentialTopic(
      id: 'invalidators',
      title: l10n.salahTrainerEssentialInvalidatorsTitle,
      summary: l10n.salahTrainerEssentialInvalidatorsSummary,
      bullets: [
        l10n.salahTrainerEssentialInvalidatorsBullet1,
        l10n.salahTrainerEssentialInvalidatorsBullet2,
        l10n.salahTrainerEssentialInvalidatorsBullet3,
        l10n.salahTrainerEssentialInvalidatorsBullet4,
        l10n.salahTrainerEssentialInvalidatorsBullet5,
      ],
    ),
    SalahEssentialTopic(
      id: 'loud_silent',
      title: l10n.salahTrainerEssentialLoudSilentTitle,
      summary: l10n.salahTrainerEssentialLoudSilentSummary,
      bullets: [
        l10n.salahTrainerEssentialLoudSilentBullet1,
        l10n.salahTrainerEssentialLoudSilentBullet2,
        l10n.salahTrainerEssentialLoudSilentBullet3,
        l10n.salahTrainerEssentialLoudSilentBullet4,
      ],
    ),
    SalahEssentialTopic(
      id: 'mistakes',
      title: l10n.salahTrainerEssentialMistakesTitle,
      summary: l10n.salahTrainerEssentialMistakesSummary,
      bullets: [
        l10n.salahTrainerEssentialMistakesBullet1,
        l10n.salahTrainerEssentialMistakesBullet2,
        l10n.salahTrainerEssentialMistakesBullet3,
        l10n.salahTrainerEssentialMistakesBullet4,
        l10n.salahTrainerEssentialMistakesBullet5,
      ],
    ),
    SalahEssentialTopic(
      id: 'intention_timing',
      title: l10n.salahTrainerEssentialIntentionTimingTitle,
      summary: l10n.salahTrainerEssentialIntentionTimingSummary,
      bullets: [
        l10n.salahTrainerEssentialIntentionTimingBullet1,
        l10n.salahTrainerEssentialIntentionTimingBullet2,
        l10n.salahTrainerEssentialIntentionTimingBullet3,
        l10n.salahTrainerEssentialIntentionTimingBullet4,
      ],
    ),
  ];
}

/// The Qur'an package translation that matches the app language, mirroring
/// the reader's enabled set. Arabic needs none; unmapped languages read the
/// English rendering.
quran.Translation? salahAyahTranslationFor(String localeName) {
  switch (localeName.split('_').first) {
    case 'ar':
      return null;
    case 'ur':
      return quran.Translation.urdu;
    case 'bn':
      return quran.Translation.bengali;
    case 'id':
      return quran.Translation.indonesian;
    case 'tr':
      return quran.Translation.trSaheeh;
    case 'fa':
      return quran.Translation.faHusseinDari;
    default:
      return quran.Translation.enSaheeh;
  }
}

SurahModel _surah(
  AppLocalizations l10n, {
  required String id,
  required int surahNumber,
  required String name,
  required String arabicName,
  required String summary,
  required String reflection,
  required List<(int, String, String)> verses,
}) {
  final translation = salahAyahTranslationFor(l10n.localeName);
  return SurahModel(
    id: id,
    surahNumber: surahNumber,
    name: name,
    arabicName: arabicName,
    summary: summary,
    reflection: reflection,
    verses: verses
        .map(
          (verse) => SurahVerseModel(
            ayahNumber: verse.$1,
            arabicText: verse.$2,
            transliteration: verse.$3,
            translation: translation == null
                ? ''
                : quran.getVerseTranslation(
                    surahNumber,
                    verse.$1,
                    translation: translation,
                  ),
            audio: AyahAudioModel(
              surahNumber: surahNumber,
              ayahNumber: verse.$1,
              localAudioAssetPath: _husaryAyahAssetPath(surahNumber, verse.$1),
            ),
          ),
        )
        .toList(growable: false),
  );
}

List<SurahModel> _buildSurahs(AppLocalizations l10n) {
  return <SurahModel>[
    _surah(
      l10n,
      id: 'al_fatihah',
      surahNumber: 1,
      name: 'Al-Fatihah',
      arabicName: 'الفاتحة',
      summary: l10n.salahTrainerSurahAlFatihahSummary,
      reflection: l10n.salahTrainerSurahAlFatihahReflection,
      verses: const [
        (
          1,
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'Bismillahir-Rahmanir-Rahim.',
        ),
        (
          2,
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'Alhamdu lillahi rabbil alamin.',
        ),
        (3, 'الرَّحْمَٰنِ الرَّحِيمِ', 'Ar-Rahmanir-Rahim.'),
        (4, 'مَالِكِ يَوْمِ الدِّينِ', 'Maliki yawmid-din.'),
        (
          5,
          'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
          'Iyyaka na\'budu wa iyyaka nasta\'in.',
        ),
        (6, 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'Ihdinas-siratal-mustaqim.'),
        (
          7,
          'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
          'Siratal-ladhina an\'amta alayhim ghayril-maghdubi alayhim wa lad-dallin.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'al_fil',
      surahNumber: 105,
      name: 'Al-Fil',
      arabicName: 'الفيل',
      summary: l10n.salahTrainerSurahAlFilSummary,
      reflection: l10n.salahTrainerSurahAlFilReflection,
      verses: const [
        (
          1,
          'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ',
          'Alam tara kayfa fa\'ala rabbuka bi-ashabil fil.',
        ),
        (
          2,
          'أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ',
          'Alam yaj\'al kaydahum fi tadlil.',
        ),
        (
          3,
          'وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ',
          'Wa arsala alayhim tayran ababil.',
        ),
        (
          4,
          'تَرْمِيهِمْ بِحِجَارَةٍ مِنْ سِجِّيلٍ',
          'Tarmihim bihijaratin min sijjil.',
        ),
        (
          5,
          'فَجَعَلَهُمْ كَعَصْفٍ مَأْكُولٍ',
          'Faja\'alahum ka\'asfin ma\'kul.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'quraysh',
      surahNumber: 106,
      name: 'Quraysh',
      arabicName: 'قريش',
      summary: l10n.salahTrainerSurahQurayshSummary,
      reflection: l10n.salahTrainerSurahQurayshReflection,
      verses: const [
        (1, 'لِإِيلَافِ قُرَيْشٍ', 'Li-ilafi Quraysh.'),
        (
          2,
          'إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ',
          'Ilafihim rihlatas-shita\'i was-sayf.',
        ),
        (
          3,
          'فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ',
          'Fal ya\'budu rabba hadhal-bayt.',
        ),
        (
          4,
          'الَّذِي أَطْعَمَهُمْ مِنْ جُوعٍ وَآمَنَهُمْ مِنْ خَوْفٍ',
          'Alladhi at\'amahum min ju\'in wa amanahum min khawf.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'al_maun',
      surahNumber: 107,
      name: 'Al-Ma\'un',
      arabicName: 'الماعون',
      summary: l10n.salahTrainerSurahAlMaunSummary,
      reflection: l10n.salahTrainerSurahAlMaunReflection,
      verses: const [
        (
          1,
          'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ',
          'Ara\'aytal-ladhi yukadhdhibu bid-din.',
        ),
        (
          2,
          'فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ',
          'Fadhalikal-ladhi yadu\'ul-yatim.',
        ),
        (
          3,
          'وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ',
          'Wa la yahuddu ala ta\'amil miskin.',
        ),
        (4, 'فَوَيْلٌ لِلْمُصَلِّينَ', 'Fawaylun lil-musallin.'),
        (
          5,
          'الَّذِينَ هُمْ عَنْ صَلَاتِهِمْ سَاهُونَ',
          'Alladhina hum an salatihim sahun.',
        ),
        (6, 'الَّذِينَ هُمْ يُرَاءُونَ', 'Alladhina hum yura\'un.'),
        (7, 'وَيَمْنَعُونَ الْمَاعُونَ', 'Wa yamna\'unal-ma\'un.'),
      ],
    ),
    _surah(
      l10n,
      id: 'al_kawthar',
      surahNumber: 108,
      name: 'Al-Kawthar',
      arabicName: 'الكوثر',
      summary: l10n.salahTrainerSurahAlKawtharSummary,
      reflection: l10n.salahTrainerSurahAlKawtharReflection,
      verses: const [
        (1, 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', 'Inna a\'taynaka al-kawthar.'),
        (2, 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'Fasalli lirabbika wanhar.'),
        (3, 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', 'Inna shani\'aka huwal-abtar.'),
      ],
    ),
    _surah(
      l10n,
      id: 'al_kafirun',
      surahNumber: 109,
      name: 'Al-Kafirun',
      arabicName: 'الكافرون',
      summary: l10n.salahTrainerSurahAlKafirunSummary,
      reflection: l10n.salahTrainerSurahAlKafirunReflection,
      verses: const [
        (1, 'قُلْ يَا أَيُّهَا الْكَافِرُونَ', 'Qul ya ayyuhal-kafirun.'),
        (2, 'لَا أَعْبُدُ مَا تَعْبُدُونَ', 'La a\'budu ma ta\'budun.'),
        (
          3,
          'وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ',
          'Wa la antum abiduna ma a\'bud.',
        ),
        (
          4,
          'وَلَا أَنَا عَابِدٌ مَا عَبَدْتُمْ',
          'Wa la ana abidum ma abadtum.',
        ),
        (
          5,
          'وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ',
          'Wa la antum abiduna ma a\'bud.',
        ),
        (6, 'لَكُمْ دِينُكُمْ وَلِيَ دِينِ', 'Lakum dinukum wa liya din.'),
      ],
    ),
    _surah(
      l10n,
      id: 'an_nasr',
      surahNumber: 110,
      name: 'An-Nasr',
      arabicName: 'النصر',
      summary: l10n.salahTrainerSurahAnNasrSummary,
      reflection: l10n.salahTrainerSurahAnNasrReflection,
      verses: const [
        (
          1,
          'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
          'Idha ja\'a nasrullahi wal-fath.',
        ),
        (
          2,
          'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
          'Wa ra\'aytan-nasa yadkhuluna fi dinillahi afwaja.',
        ),
        (
          3,
          'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا',
          'Fasabbih bihamdi rabbika wastaghfirh, innahu kana tawwaba.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'al_masad',
      surahNumber: 111,
      name: 'Al-Masad',
      arabicName: 'المسد',
      summary: l10n.salahTrainerSurahAlMasadSummary,
      reflection: l10n.salahTrainerSurahAlMasadReflection,
      verses: const [
        (
          1,
          'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ',
          'Tabbat yada abi lahabin wa tabb.',
        ),
        (
          2,
          'مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ',
          'Ma aghna anhu maluhu wa ma kasab.',
        ),
        (3, 'سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ', 'Sayasla naran dhata lahab.'),
        (
          4,
          'وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ',
          'Wamra\'atuhu hammalatal-hatab.',
        ),
        (5, 'فِي جِيدِهَا حَبْلٌ مِنْ مَسَدٍ', 'Fi jidiha hablun mim masad.'),
      ],
    ),
    _surah(
      l10n,
      id: 'al_ikhlas',
      surahNumber: 112,
      name: 'Al-Ikhlas',
      arabicName: 'الإخلاص',
      summary: l10n.salahTrainerSurahAlIkhlasSummary,
      reflection: l10n.salahTrainerSurahAlIkhlasReflection,
      verses: const [
        (1, 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'Qul huwa Allahu ahad.'),
        (2, 'اللَّهُ الصَّمَدُ', 'Allahu as-samad.'),
        (3, 'لَمْ يَلِدْ وَلَمْ يُولَدْ', 'Lam yalid wa lam yulad.'),
        (
          4,
          'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
          'Wa lam yakun lahu kufuwan ahad.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'al_falaq',
      surahNumber: 113,
      name: 'Al-Falaq',
      arabicName: 'الفلق',
      summary: l10n.salahTrainerSurahAlFalaqSummary,
      reflection: l10n.salahTrainerSurahAlFalaqReflection,
      verses: const [
        (1, 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'Qul a\'udhu birabbil-falaq.'),
        (2, 'مِنْ شَرِّ مَا خَلَقَ', 'Min sharri ma khalaq.'),
        (
          3,
          'وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ',
          'Wa min sharri ghasiqin idha waqab.',
        ),
        (
          4,
          'وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
          'Wa min sharrin-naffathati fil-uqad.',
        ),
        (
          5,
          'وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
          'Wa min sharri hasidin idha hasad.',
        ),
      ],
    ),
    _surah(
      l10n,
      id: 'an_nas',
      surahNumber: 114,
      name: 'An-Nas',
      arabicName: 'الناس',
      summary: l10n.salahTrainerSurahAnNasSummary,
      reflection: l10n.salahTrainerSurahAnNasReflection,
      verses: const [
        (1, 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', 'Qul a\'udhu birabbin-nas.'),
        (
          4,
          'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
          'Min sharril-waswasil-khannas.',
        ),
        (
          5,
          'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
          'Alladhi yuwaswisu fi sudurin-nas.',
        ),
        (6, 'مِنَ الْجِنَّةِ وَالنَّاسِ', 'Minal-jinnati wan-nas.'),
      ],
    ),
  ];
}
