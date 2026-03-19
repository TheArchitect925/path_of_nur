// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Pushto Pashto (`ps`).
class AppLocalizationsPs extends AppLocalizations {
  AppLocalizationsPs([String locale = 'ps']) : super(locale);

  @override
  String get appTitle => 'Path of Nur';

  @override
  String get notificationsFastingMomentsChannelName => 'د روژې شېبې';

  @override
  String get notificationsFastingMomentsChannelDescription =>
      'د روژې د پيل او پای لپاره د وخت-حساس يادونې';

  @override
  String get notificationsPrayerNotificationOnlyChannelName =>
      'د لمانځه يادونې (خبرتیا)';

  @override
  String get notificationsPrayerNotificationOnlyChannelDescription =>
      'د اذان له غږ پرته د لمانځه خبرتياوې';

  @override
  String notificationsPrayerAdhanChannelName(String adhanTitle) {
    return 'د لمانځه يادونې ($adhanTitle)';
  }

  @override
  String get notificationsPrayerAdhanChannelDescription =>
      'له اذان غږ سره د لمانځه خبرتياوې';

  @override
  String get notificationsPrayerBeforeQazaChannelName =>
      'د لمانځه يادونې (له قضا مخکې)';

  @override
  String get notificationsPrayerBeforeQazaChannelDescription =>
      'له قضا کېدو مخکې د لمانځه خبرتياوې';

  @override
  String get notificationsDailyRemindersChannelName => 'ورځنۍ يادونې';

  @override
  String get notificationsDailyRemindersChannelDescription =>
      'د ذکر، قرآن، او تامل يادونې';

  @override
  String get notificationsGrowthRemindersChannelName => 'د ودې يادونې';

  @override
  String get notificationsGrowthRemindersQuietChannelName =>
      'د ودې يادونې (ارام)';

  @override
  String get notificationsGrowthRemindersChannelDescription =>
      'د ودې عادتونو لپاره نرمې يادونې';

  @override
  String notificationsPrayerAtTimeTitle(String prayerName, Object prayer) {
    return 'د $prayerName لمونځ';
  }

  @override
  String notificationsPrayerBeforeQazaTitle(String prayerName, Object prayer) {
    return 'د $prayerName د وخت يادونه';
  }

  @override
  String get notificationsDhikrTitle => 'د ذکر يادونه';

  @override
  String get notificationsQuranTitle => 'قرآني تامل';

  @override
  String get notificationsReflectionTitle => 'ورځنی تامل';

  @override
  String get notificationsFastingTitle => 'د روژې يادونه';

  @override
  String get notificationsCycleCheckTitle => 'د عادت کتنه';

  @override
  String notificationsPrayerAtTimeBody(String prayerName, Object prayer) {
    return 'د $prayerName وخت دی. له خپل لمانځه سره تړلي پاتې شئ.';
  }

  @override
  String notificationsPrayerBeforeQazaBody(String prayerName, Object prayer) {
    return 'د $prayerName وخت د پای ته رسېدو په حال کې دی. تر قضا کېدو مخکې يې ادا کړئ.';
  }

  @override
  String get notificationsDhikrBody => 'د ذکر لپاره يو ارام شېبه واخلئ.';

  @override
  String get notificationsQuranBody =>
      'له نيت سره خپل قرآن لوست ته بېرته راستانه شئ.';

  @override
  String get notificationsReflectionBody =>
      'مخکې له دې چې ورځ مو پای ته ورسېږي، يو لنډ تامل وليکئ.';

  @override
  String get notificationsFastingBody =>
      'د نن ورځې روژې لپاره خپل نيت چمتو کړئ.';

  @override
  String get notificationsCycleCheckBody =>
      'خپل حالت وګورئ او کله چې چمتو ياست د لمانځه يادونې بېرته پيل کړئ.';

  @override
  String notificationsRecoveredReminderBody(String body) {
    return 'تاسې دا يادونه مخکې له لاسه ورکړې وه. $body';
  }

  @override
  String get notificationsPrayerActionMarkPrayed => 'Mark as prayed';

  @override
  String get notificationsPrayerActionMarkPrayedLate => 'Mark as prayed late';

  @override
  String get notificationsPrayerActionSnooze => 'Snooze';

  @override
  String get notificationsPrayerActionOpen => 'Open';

  @override
  String get notificationsPrayerNameTahajjud => 'تهجد';

  @override
  String get notificationsGenericPrayerName => 'لمونځ';

  @override
  String get notificationsFastingBeginsNowTitle => 'روژه اوس پيلېږي';

  @override
  String get notificationsFastingBeginsNowBody =>
      'له فجر مخکې د روژې نيت تازه کړئ. نيت په زړه کې وي.';

  @override
  String get notificationsIftarTimeTitle => 'اوس د روژه مات وخت دی';

  @override
  String get notificationsIftarTimeBody =>
      'تنده ولاړه، رګونه لمده شول، او اجر ثابت شو، که الله وغواړي.';

  @override
  String get notificationsFastingLiveFastBeginsTitle => 'روژه پيلېږي';

  @override
  String get notificationsFastingLiveFastBeginsArabicTitle => 'يبدأ الصوم';

  @override
  String notificationsFastingLiveStartsIn(Object duration) {
    return 'پيل په';
  }

  @override
  String get notificationsFastingLiveRenewIntentionTitle => 'خپل نيت تازه کړئ';

  @override
  String get notificationsFastingLiveRenewIntentionArabic => '';

  @override
  String get notificationsFastingLiveRenewIntentionTranslation =>
      'دلته کومه ځانګړې ويل شوې دعا ثابته نه ده. له فجر مخکې د روژې نيت په زړه کې ونيسئ.';

  @override
  String get notificationsFastingLiveFastEndsTitle => 'روژه پای ته رسېږي';

  @override
  String get notificationsFastingLiveFastEndsArabicTitle => 'يفطر الصائم';

  @override
  String notificationsFastingLiveEndsIn(Object duration) {
    return 'پای په';
  }

  @override
  String get notificationsFastingLiveIftarDuaTitle => 'د افطار دعا';

  @override
  String get notificationsFastingLiveIftarDuaArabic =>
      'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ العُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ';

  @override
  String get notificationsFastingLiveIftarDuaTranslation =>
      'تنده ولاړه، رګونه لمده شول، او اجر ثابت شو، که الله وغواړي.';

  @override
  String get notificationsFastingLiveIftarTitle => 'افطار';

  @override
  String get notificationsFastingLiveIftarArabicTitle => 'الإفطار';

  @override
  String get notificationsFastingLiveJustEntered => 'همدا اوس داخل شو';

  @override
  String get navDhikr => 'Worship';

  @override
  String get navLearning => 'Learn';

  @override
  String get navHome => 'Home';

  @override
  String get navPrayer => 'Growth';

  @override
  String get navGarden => 'Profile';

  @override
  String get greetingArabic => 'السلام عليكم ورحمة الله وبركاته';

  @override
  String get brotherName => 'Brother Shahab';

  @override
  String get peaceUponYou => 'Peace be upon you';

  @override
  String get ayahArabic => 'واستعينوا بالصبر والصلاة';

  @override
  String get ayahTranslit => 'Wastaeenu bi-s-sabri wa-s-salah';

  @override
  String get ayahTranslation => 'Seek help through patience and prayer. (2:45)';

  @override
  String get quranTitle => 'Quran';

  @override
  String get quranSubtitle => 'Read • Search • Notes';

  @override
  String get quranHubTitle => 'Qur’an';

  @override
  String get quranHubSubtitle =>
      'A calm entry for reading, study, memorization, words, topics, and notes.';

  @override
  String get quranHubJourneysTitle => 'Journeys';

  @override
  String get quranHubJourneysSubtitle =>
      'Follow a guided path when you want structure, continuity, and clearer next steps.';

  @override
  String get quranHubJourneyOfQuranTitle => 'Journey of the Qur’an';

  @override
  String get quranHubJourneyOfQuranSubtitle =>
      'Open the Book, navigate it, and build a first relationship.';

  @override
  String get quranHubFatihahJourneyTitle => 'Understanding Al-Fatihah';

  @override
  String get quranHubFatihahJourneySubtitle =>
      'Begin with the surah you recite every day and connect it to salah.';

  @override
  String get quranHubShortSurahsJourneyTitle => 'Short Surahs';

  @override
  String get quranHubShortSurahsJourneySubtitle =>
      'Use the shorter surahs as a bridge between recitation, prayer, and meaning.';

  @override
  String get quranHubModesTitle => 'Modes';

  @override
  String get quranHubModesSubtitle =>
      'Choose the Qur’an mode that fits what you want to do right now.';

  @override
  String get quranHubReadTitle => 'Read';

  @override
  String get quranHubReadSubtitle =>
      'Open the reader from where you last left off or begin a new passage.';

  @override
  String get quranHubStudyTitle => 'Study';

  @override
  String get quranHubStudySubtitle =>
      'Open the study hub for explanation, reflection, and guided learning paths.';

  @override
  String get quranHubMemorizeTitle => 'Memorize';

  @override
  String get quranHubMemorizeSubtitle =>
      'Review and strengthen recall through the current memorization tools.';

  @override
  String get quranHubWordsTitle => 'Words';

  @override
  String get quranHubWordsSubtitle =>
      'Learn recurring Qur’anic vocabulary and build recognition gradually.';

  @override
  String get quranHubTopicsTitle => 'Topics';

  @override
  String get quranHubTopicsSubtitle =>
      'Follow themes and verses without browsing the whole text first.';

  @override
  String get quranHubNotesTitle => 'Notes';

  @override
  String get quranHubNotesSubtitle =>
      'Return to saved reflections, highlights, and verse-linked notes.';

  @override
  String get quranHubDailyLightTitle => 'Today’s Light';

  @override
  String get quranHubOpenVerseAction => 'Open Verse';

  @override
  String get quranHubRelatedToolsTitle => 'Related Tools';

  @override
  String get quranHubRelatedToolsSubtitle =>
      'Keep secondary Qur’an tools close without crowding the main flow.';

  @override
  String get quranHubUniverseToolTitle => 'Universe';

  @override
  String get duaHubTitle => 'Duas';

  @override
  String get duaHubSubtitle =>
      'Verified Qur’anic and Prophetic supplications, organized for daily life, worship, family, travel, and hardship.';

  @override
  String get duaHubTabLearn => 'Learn';

  @override
  String get duaHubTabCategories => 'Categories';

  @override
  String get duaHubTabSaved => 'Saved';

  @override
  String get duaHubTabDaily => 'Daily';

  @override
  String get duaHubSearchHint => 'Search duas, sources, categories, tags...';

  @override
  String get duaHubOverviewTitle => 'Dataset overview';

  @override
  String duaHubOverviewVerifiedNow(int count) {
    return '$count verified now';
  }

  @override
  String duaHubOverviewPlanned(int count) {
    return '$count planned in scaffold';
  }

  @override
  String duaHubOverviewTracked(int count) {
    return '$count total tracked';
  }

  @override
  String get duaHubOverviewBody =>
      'Only verified entries are surfaced as readable duas right now. The remaining scaffold items stay tracked for later scholarly completion.';

  @override
  String get duaHubAllCategories => 'All categories';

  @override
  String get duaHubEmptyFiltered => 'No verified duas match this filter yet.';

  @override
  String get duaHubEmptyCategories => 'No dua categories available yet.';

  @override
  String get duaHubEmptySaved =>
      'Save duas here to build your personal collection.';

  @override
  String get duaHubEmptyDaily => 'No daily dua available right now.';

  @override
  String duaHubLoadError(String error) {
    return 'Unable to load duas right now. $error';
  }

  @override
  String get duaHubDailyTitle => 'Daily dua';

  @override
  String duaHubOpenDuaSemantics(String title) {
    return 'Open dua: $title';
  }

  @override
  String duaHubOpenCategorySemantics(String category) {
    return 'Open dua category: $category';
  }

  @override
  String duaHubCategorySummary(int readyCount, int plannedCount) {
    return '$readyCount ready • $plannedCount planned';
  }

  @override
  String duaHubCategoryTag(String name, int count) {
    return '$name · $count';
  }

  @override
  String get duaHubSave => 'Save dua';

  @override
  String get duaHubRemoveSaved => 'Remove saved dua';

  @override
  String get duaSourceQuran => 'Qur’an';

  @override
  String get duaSourceSunnah => 'Sunnah';

  @override
  String get duaCoreVerified => 'Core verified';

  @override
  String get duaDetailAppBarTitle => 'Dua';

  @override
  String get duaDetailNotFound => 'Dua not found.';

  @override
  String duaDetailLoadError(String error) {
    return 'Unable to load dua. $error';
  }

  @override
  String get duaDetailSupplicationTitle => 'Supplication';

  @override
  String get duaDetailWhenToSayTitle => 'When to say it';

  @override
  String get duaDetailMarkReflected => 'Mark reflected';

  @override
  String get duaDetailOpenInQuranReader => 'Open in Quran reader';

  @override
  String get duaDetailTagsTitle => 'Tags';

  @override
  String get duaDetailPlannedTitle => 'Planned content';

  @override
  String get duaDetailPlannedBody =>
      'This entry exists in the dua scaffold, but the source text and verification details have not been completed yet. It stays tracked so the final dua library can expand without changing the architecture.';

  @override
  String get nextSalah => 'Next Salah';

  @override
  String get allSalahTimes => 'All Salah Times';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get dhuhrArabic => 'الظهر';

  @override
  String get remainingTime => '2h 3m';

  @override
  String get atTime => 'at 1:30 PM';

  @override
  String get salahCompleted => 'Salah completed';

  @override
  String get dhikrToday => 'Dhikr today';

  @override
  String get salahStreak => 'Salah Streak';

  @override
  String get homeSectionDailyNurTitle => 'Daily Nur Progress';

  @override
  String get homeSectionDailyNurSubtitle =>
      'A high-level snapshot for reflection.';

  @override
  String get homePrayerSummaryTitle => 'Prayer Summary';

  @override
  String get homePrayerSummarySubtitle =>
      'Quick view into daily worship rhythm.';

  @override
  String get homeDhikrLearningTitle => 'Dhikr and Learning';

  @override
  String get homeDhikrLearningSubtitle => 'Fast access to spiritual practices.';

  @override
  String get homeReflectionTitle => 'Reflection / Reminder';

  @override
  String get homeReflectionSubtitle => 'Centerpiece message for the day.';

  @override
  String get homeLevelStreakTitle => 'Level and Streak';

  @override
  String get homeLevelStreakSubtitle => 'Growth signals without pressure.';

  @override
  String get homeOverviewHeroTitle => 'Daily Nur Overview';

  @override
  String get homeOverviewHeroSubtitle =>
      'A compact summary of worship, learning, and growth.';

  @override
  String get homePrayerProgressTitle => 'Prayer progress';

  @override
  String get homeDhikrProgressTitle => 'Dhikr progress';

  @override
  String get homeCurrentStreakTitle => 'Current streak';

  @override
  String get homeXpLevelTitle => 'Level and XP';

  @override
  String get homeDaysLabel => 'days';

  @override
  String get homeXpToNextLevel => 'تر بلې کچې پورې XP';

  @override
  String get homeWorshipSummaryTitle => 'Worship Summary';

  @override
  String get homeWorshipSummarySubtitle =>
      'Prayer, dhikr, fasting, and Khusu in one place.';

  @override
  String get homeFastingStatusTitle => 'Fasting status';

  @override
  String get homeKhusuQuickEntryTitle => 'Khusu quick entry';

  @override
  String get homeKhusuQuickEntryValue => 'Enter focus mode';

  @override
  String get homeKhusuQuickEntryShort => 'Khusu';

  @override
  String get homeFastingNotFasting => 'Not fasting';

  @override
  String get homeFastingIntending => 'Intending to fast';

  @override
  String get homeFastingCompleted => 'Completed';

  @override
  String get homeFastingBroken => 'Missed / Broken';

  @override
  String get worshipPrayerHubTitle => 'د لمانځه مرکز';

  @override
  String get worshipPrayerHubSubtitle =>
      'د لمانځه وختونه، تعقيب، ثبات، رکعتونه، او عملي لارښوونه په يوه متمرکز بهير کې.';

  @override
  String get worshipPrayerTabTimes => 'وختونه';

  @override
  String get worshipPrayerTabQada => 'قضا';

  @override
  String get worshipPrayerTabStats => 'احصايې';

  @override
  String get worshipPrayerTabRakat => 'رکعت';

  @override
  String get worshipPrayerSisterCyclePauseTitle => 'د خور د عادت وقفه';

  @override
  String worshipPrayerCycleDay(String dayNumber, Object day) {
    return 'د عادت ورځ $dayNumber';
  }

  @override
  String get worshipPrayerExpectedDurationTitle => 'اټکل شوې موده';

  @override
  String get worshipPrayerAutoAdjustRemindersTitle => 'يادونې پخپله تنظيمول';

  @override
  String get worshipPrayerAutoAdjustRemindersSubtitle =>
      'د لمانځه او روژې يادونې دروي او نرم بديلونه ساتي.';

  @override
  String get worshipPrayerPurityCheckReminderTitle => 'د پاکۍ د کتنې يادونه';

  @override
  String get worshipPrayerPurityCheckReminderSubtitle =>
      'ستاسې د اټکل شوې پای ورځې ته نږدې يو نرم يادونه ولېږئ.';

  @override
  String get worshipPrayerOptionalPrivateNotesHint => 'اختیاري شخصي يادښتونه';

  @override
  String worshipPrayerHijriDateValue(String day, String month, String year) {
    return '$day $month $year هـ';
  }

  @override
  String get worshipPrayerHijriMonthMuharram => 'محرم';

  @override
  String get worshipPrayerHijriMonthSafar => 'صفر';

  @override
  String get worshipPrayerHijriMonthRabiAlAwwal => 'ربيع الاول';

  @override
  String get worshipPrayerHijriMonthRabiAlThani => 'ربيع الثاني';

  @override
  String get worshipPrayerHijriMonthJumadaAlAwwal => 'جمادی الاول';

  @override
  String get worshipPrayerHijriMonthJumadaAlThani => 'جمادی الثاني';

  @override
  String get worshipPrayerHijriMonthRajab => 'رجب';

  @override
  String get worshipPrayerHijriMonthShaban => 'شعبان';

  @override
  String get worshipPrayerHijriMonthRamadan => 'رمضان';

  @override
  String get worshipPrayerHijriMonthShawwal => 'شوال';

  @override
  String get worshipPrayerHijriMonthDhuAlQidah => 'ذو القعدة';

  @override
  String get worshipPrayerHijriMonthDhuAlHijjah => 'ذو الحجة';

  @override
  String get worshipPrayerSalahTimesTitle => 'د لمانځه وختونه';

  @override
  String worshipPrayerSalahWindowValue(
    String offerTime,
    String windowStart,
    String windowEnd,
    Object end,
    Object start,
  ) {
    return '$offerTime • د لمانځه موده: $windowStart–$windowEnd';
  }

  @override
  String get worshipPrayerQadaOverviewTitle => 'د قضا عمومي کتنه';

  @override
  String get worshipPrayerQadaOverviewSubtitle =>
      'وګورئ چې د کوم لمانځه قطار ډېر دروند دی او خپله د پوره کولو لاره روښانه جوړه کړئ.';

  @override
  String get worshipPrayerQadaGuidanceTitle =>
      'د فوت شوي لمانځه د قضا لارښوونه';

  @override
  String get worshipPrayerQadaGuidanceBody =>
      '1. اوسنۍ لمونځونه پر خپل وخت ساتل لومړيتوب وګرځوئ.\n2. رښتينې توبه وباسئ او له الله نه د دوام غوښتنه وکړئ.\n3. د قضا يو د سمبالېدو وړ عادت جوړ کړئ (مثلاً: له هر اوسني لمانځه وروسته يوه قضا).\n4. د لمانځه په ډول تعقيب يې کړئ څو ستړيا کمه او پرمختګ ثابت وي.\n5. که ستاسې حالت پېچلی وي، خپل پلان له يو باوري ځايي عالم سره هم وڅېړئ.';

  @override
  String get worshipPrayerHistoryTitle => 'د لمانځه تاريخچه';

  @override
  String worshipPrayerHistorySubtitle(String date) {
    return 'د $date لپاره ثبت شوي د ادا وختونه.';
  }

  @override
  String worshipPrayerCompletedAt(String time) {
    return 'په $time ادا شو';
  }

  @override
  String get worshipPrayerMarkedMissed => 'فوت شوی وټاکل شو';

  @override
  String get worshipPrayerNoRecordedCompletionYet => 'لا د ادا کوم ثبت نشته';

  @override
  String worshipPrayerQueuedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count په قطار کې',
      one: '1 په قطار کې',
      zero: '0 په قطار کې',
    );
    return '$_temp0';
  }

  @override
  String get worshipPrayerMonthlyOverviewTitle => 'د مياشتني لمانځه عمومي کتنه';

  @override
  String worshipPrayerTrackedDays(String count) {
    return 'ثبت شوې ورځې: $count';
  }

  @override
  String worshipPrayerOfferedSalahs(String count) {
    return 'ادا شوي لمونځونه: $count';
  }

  @override
  String worshipPrayerMissedSalahs(String count) {
    return 'فوت شوي لمونځونه: $count';
  }

  @override
  String get worshipPrayerOnTimeRateTitle => 'پر وخت کچه';

  @override
  String get worshipPrayerMasjidCountTitle => 'د مسجد شمېر';

  @override
  String get worshipPrayerQadaCountTitle => 'د قضا شمېر';

  @override
  String worshipPrayerPercentValue(String value) {
    return '$value%';
  }

  @override
  String worshipPrayerCompletionValue(
    String value,
    Object completed,
    Object total,
  ) {
    return 'بشپړتيا $value%';
  }

  @override
  String get worshipPrayerMonthlyConsistencyTitle => 'مياشتنی ثبات';

  @override
  String get worshipPrayerWeeklyTrendTitle => 'د اوونيز ثبات بهير';

  @override
  String get worshipPrayerWeeklyTrendSubtitle =>
      'په وروستيو 8 اوونيو کې بشپړتيا.';

  @override
  String get worshipPrayerMonthlyTrendTitle => 'د مياشتني ثبات بهير';

  @override
  String get worshipPrayerMonthlyTrendSubtitle =>
      'په وروستيو 6 مياشتو کې بشپړتيا.';

  @override
  String get worshipPrayerRakatGuideTitle => 'د رکعت لارښود (فرض)';

  @override
  String worshipPrayerRakatGuideValue(
    Object count,
    Object prayer,
    Object prayerName,
    Object rakat,
  ) {
    return 'فجر: 2 • ظهر: 4 • عصر: 4 • مغرب: 3 • عشاء: 4';
  }

  @override
  String get worshipPrayerRakatGuideTip =>
      'لارښوونه: لومړی په فرضو کې ثبات وساتئ. سنت او نفل ورو ورو ورزيات کړئ.';

  @override
  String get worshipPrayerMoonPhaseTitle => 'د سپوږمۍ پړاو';

  @override
  String worshipPrayerMoonPhaseIllumination(
    String phaseLabel,
    String percent,
    Object value,
  ) {
    return '$phaseLabel • $percent% روښانه';
  }

  @override
  String get worshipPrayerMoonPhaseNewMoon => 'نوې سپوږمۍ';

  @override
  String get worshipPrayerMoonPhaseWaxingCrescent => 'مخ پر زياتېدو هلال';

  @override
  String get worshipPrayerMoonPhaseFirstQuarter => 'لومړۍ ربعه';

  @override
  String get worshipPrayerMoonPhaseWaxingGibbous => 'مخ پر زياتېدو ګردۍ';

  @override
  String get worshipPrayerMoonPhaseFullMoon => 'بشپړه سپوږمۍ';

  @override
  String get worshipPrayerMoonPhaseWaningGibbous => 'مخ پر کمېدو ګردۍ';

  @override
  String get worshipPrayerMoonPhaseLastQuarter => 'وروستۍ ربعه';

  @override
  String get worshipPrayerMoonPhaseWaningCrescent => 'مخ پر کمېدو هلال';

  @override
  String worshipPrayerSunriseValue(String time) {
    return 'لمر ختل • $time';
  }

  @override
  String worshipPrayerSunsetValue(String time) {
    return 'لمر لوېدل • $time';
  }

  @override
  String worshipPrayerMoonriseValue(String time) {
    return 'سپوږمۍ ختل • $time';
  }

  @override
  String worshipPrayerMoonsetValue(String time) {
    return 'سپوږمۍ لوېدل • $time';
  }

  @override
  String get worshipPrayerNoUpcomingPrayer =>
      'د ټاکلي وخت لپاره راتلونکی لمونځ نشته.';

  @override
  String worshipPrayerNextPrayerIn(String prayerName, String duration) {
    return 'راتلونکی لمونځ: $prayerName په $duration کې';
  }

  @override
  String worshipPrayerOverlayLabel(String prayerName, String time) {
    return '$prayerName $time';
  }

  @override
  String get worshipPrayerQadaPlannerTitle => 'د قضا پلان جوړوونکی';

  @override
  String worshipPrayerCadenceValue(String value) {
    return 'اندازه: $value';
  }

  @override
  String get worshipPrayerCadenceQueueClear =>
      'قطار پاک دی. پر وخت لمونځونه وساتئ.';

  @override
  String get worshipPrayerCadenceLight =>
      'سپک بهير: له فجر يا عشاء وروسته 1 اضافه قضا.';

  @override
  String get worshipPrayerCadenceSteady =>
      'ثابت بهير: هره ورځ 2 قضا (يوه له فجر وروسته، يوه له عشاء وروسته).';

  @override
  String get worshipPrayerCadenceFocused =>
      'متمرکز بهير: هره ورځ 3 قضا په کوچنيو برخو او ثبات سره.';

  @override
  String worshipPrayerEstimatedDaysToClear(String days, Object count) {
    return 'د پاکېدو اټکل شوې ورځې: $days';
  }

  @override
  String worshipPrayerTodaysQadaTarget(
    String completed,
    String target,
    Object count,
  ) {
    return 'د نن قضا هدف: $completed / $target';
  }

  @override
  String get worshipPrayerDoneOneAction => 'يوه بشپړه شوه';

  @override
  String get worshipPrayerNextInQueueTitle => 'په قطار کې بل';

  @override
  String get worshipPrayerNoQueuedQadaLeft =>
      'نورې قضاوې په قطار کې نشته. د نن لمونځونه خوندي وساتئ.';

  @override
  String get worshipPrayerNoRecordsThisMonth =>
      'د دې مياشتې لپاره لا د لمانځه کوم ثبت نشته.';

  @override
  String get worshipPrayerHeatmapTitle => 'د لمانځه په کچه تودوخه نقشه';

  @override
  String get worshipPrayerHeatmapSubtitle =>
      'هر قطار يو لمونځ دی. شين ادا شوی، ژېړ فوت شوی، نرمه خړه په تمه.';

  @override
  String get worshipPrayerGregorianCalendarTitle => 'عادي جنتري (Gregorian)';

  @override
  String get worshipPrayerIslamicCalendarTitle => 'اسلامي جنتري (د ښودنې حالت)';

  @override
  String get worshipPrayerIslamicCalendarSubtitle =>
      'له هماغه ثبت شوې ورځې معلوماتو سره د هجري نېټې ښودنه ته اوړي.';

  @override
  String worshipPrayerDurationHoursMinutes(String hours, String minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String worshipPrayerDurationMinutes(String minutes) {
    return '$minutesد';
  }

  @override
  String worshipPrayerWeekLabel(int weekNumber, Object index, Object number) {
    return 'او$weekNumber';
  }

  @override
  String get worshipPrayerStatusPending => 'په تمه';

  @override
  String get worshipPrayerStatusCompleted => 'بشپړ شوی';

  @override
  String get worshipPrayerStatusMissed => 'فوت شوی';

  @override
  String get worshipPrayerChooseLocationTitle => 'ځای وټاکئ';

  @override
  String get worshipPrayerUseCurrentLocationTitle => 'اوسنی ځای وکاروئ';

  @override
  String get worshipPrayerUseDeviceAction => 'د آلې ځای وکاروئ';

  @override
  String get worshipPrayerSearchLocationHint => 'يو ښار يا ځای ولټوئ';

  @override
  String get worshipPrayerRecentPlacesTitle => 'وروستي ځایونه';

  @override
  String get worshipPrayerStartTypingToSearch =>
      'د ځای لټون لپاره ليکل پيل کړئ.';

  @override
  String get worshipPrayerLocationSearchUnavailable =>
      'اوس مهال ځایونه نه شو موندلی.';

  @override
  String get homeLearnSummaryTitle => 'Learn Summary';

  @override
  String get homeLearnSummarySubtitle =>
      'Continue your knowledge path with focused previews.';

  @override
  String get homeLearnContinueQuran => 'Continue Quran';

  @override
  String homeLearnContinueQuranValue(Object surah, Object verse) {
    return 'Resume last reading';
  }

  @override
  String get homeLearnFeaturedLife => 'Featured Life topic';

  @override
  String get homeLearnFeaturedLifeValue => 'Patience';

  @override
  String get homeLearnFeaturedWorld => 'Featured World topic';

  @override
  String get homeLearnFeaturedWorldValue => 'Mountains';

  @override
  String get homeLearnFeaturedHadith => 'Featured Hadith topic';

  @override
  String get homeLearnFeaturedHadithValue => 'Character and Manners';

  @override
  String get homeLearnResumeNotes => 'Notes and reflection';

  @override
  String get homeLearnResumeNotesValue => 'Resume your latest note';

  @override
  String get homeJourneySummaryTitle => 'Journey Summary';

  @override
  String get homeJourneySummarySubtitle =>
      'Track progression, rings, and next unlocks.';

  @override
  String get homeJourneyXpProgressTitle => 'XP progress';

  @override
  String get homeJourneyDailyRingsTitle => 'Daily rings';

  @override
  String get homeJourneyNextUnlockTitle => 'Next unlock';

  @override
  String homeJourneyNextUnlockValue(Object item) {
    return 'Wallpaper reward preview';
  }

  @override
  String get homeQuickActionsTitle => 'Quick Actions';

  @override
  String get homeQuickActionsSubtitle =>
      'Jump into your core sections quickly.';

  @override
  String get homeReflectionReminder =>
      '\"Return softly to your intention. Small sincere acts build lasting light.\"';

  @override
  String get homeWelcomeDailyIntentionTitle => 'Daily Intention';

  @override
  String get homeWelcomeDailyIntentionSubtitle =>
      'Start the day with gentle focus, reflection, and consistency.';

  @override
  String get homeWelcomePrayerRhythmTitle => 'Prayer Rhythm';

  @override
  String get homeWelcomePrayerRhythmSubtitle =>
      'Today\'s next salah and guidance are synced and visible below.';

  @override
  String get homeWelcomeDhikrQuietTitle => 'Dhikr and Quiet';

  @override
  String get homeWelcomeDhikrQuietSubtitle =>
      'Choose calm moments to track reminders and intention.';

  @override
  String get homeLocationPromptTitle => 'Use location while using app?';

  @override
  String get homeLocationPromptSubtitle =>
      'Enable foreground location for accurate prayer times.';

  @override
  String get homeLocationEnabledWhileUsing =>
      'Location access is enabled while you use the app.';

  @override
  String get homeLocationAllowWhileUsingForPrayer =>
      'Allow location only while using the app for accurate prayer times.';

  @override
  String get homeLocationBlockedOpenSettings =>
      'Location access is blocked. Open settings to enable while using app.';

  @override
  String get homeLocationStatusCanUpdate =>
      'Location permission status can be updated anytime.';

  @override
  String get worshipQiblaFinderTitle => 'Qibla Finder';

  @override
  String get worshipQiblaFinderSubtitle =>
      'Find the direction of the Kaaba with calm, clear guidance.';

  @override
  String get worshipQiblaCompassDirectionTitle => 'Qibla direction';

  @override
  String get worshipQiblaDetectingLocation => 'Detecting your location...';

  @override
  String get worshipQiblaUnableToDetermineLocation =>
      'Unable to determine your location right now.';

  @override
  String get worshipQiblaArOptionTitle => 'AR mode';

  @override
  String get worshipQiblaArOptionSubtitle =>
      'Use a larger directional view for easier alignment.';

  @override
  String get worshipQiblaDisableArMode => 'Disable AR mode';

  @override
  String get worshipQiblaEnableArMode => 'Enable AR mode';

  @override
  String get worshipQiblaArModeBetaHint =>
      'AR mode is still lightweight and may vary by device.';

  @override
  String get worshipQiblaLocationServicesDisabled =>
      'Location services are disabled. Enable them to use the Qibla finder.';

  @override
  String get worshipQiblaLocationPermissionRequired =>
      'Location permission is required to determine the Qibla from where you are.';

  @override
  String get worshipQiblaUnableToReadLocation =>
      'Unable to read your location right now.';

  @override
  String get worshipQiblaCompassUnavailable =>
      'Compass data is unavailable on this device right now.';

  @override
  String get worshipQiblaCardinalNorth => 'N';

  @override
  String get worshipQiblaCardinalSouth => 'S';

  @override
  String get worshipQiblaCardinalWest => 'W';

  @override
  String get worshipQiblaCardinalEast => 'E';

  @override
  String worshipQiblaBearingValue(Object degrees) {
    return 'Qibla bearing: $degrees°';
  }

  @override
  String worshipQiblaDeviceHeadingValue(Object degrees) {
    return 'Device heading: $degrees°';
  }

  @override
  String worshipQiblaAlignmentOffsetValue(Object degrees) {
    return 'Alignment offset: $degrees°';
  }

  @override
  String get worshipQiblaAlignedMessage => 'You are aligned with the Qibla.';

  @override
  String get worshipQiblaRotateMessage =>
      'Rotate gently until the arrow aligns.';

  @override
  String get homeSearchTooltip => 'Search the app';

  @override
  String get homeSearchHint => 'Search pages, features, and sections';

  @override
  String get homeSearchNoResults => 'No matching section found.';

  @override
  String get homeSearchClearTooltip => 'Clear search';

  @override
  String get homeSearchCloseTooltip => 'Close search';

  @override
  String get homeStartWelcomeCarousel => 'د ښه راغلاست کاروسل پيل کړئ';

  @override
  String get homeSearchQiblaFinderTitle => 'د قبلې موندونکی';

  @override
  String get homeSearchQiblaFinderSubtitle =>
      'د کعبې پر لور د قطب‌نما لارښوونه';

  @override
  String get homeSearchQuranTopWordsTitle => 'د قرآن ډېر کارېدونکي لغتونه';

  @override
  String get homeSearchQuranTopWordsSubtitle =>
      'له خپلې سرچينې سند څخه ډېر تکرارېدونکي قرآني لغتونه زده کړئ.';

  @override
  String get homeSearchNamesOfAllahTitle => 'د الله 99 نومونه';

  @override
  String get homeSearchNamesOfAllahSubtitle =>
      'عربي نومونه، ليکلدود، او لنډې معناوې.';

  @override
  String get homeSearchGuidanceHubTitle => 'د اسلامي لارښوونې مرکز';

  @override
  String get homeSearchGuidanceHubSubtitle =>
      'د حج، عمرې، نوي/مستبصر مسلمان ملاتړ، او عملي لارښودونه.';

  @override
  String get homeSearchQuranLessonsMappingTitle => 'د قرآن د 50 درسونو نقشه';

  @override
  String get homeSearchQuranLessonsMappingSubtitle =>
      'له درسي PDF څخه سرچينه-تر-کټګورۍ نقشه.';

  @override
  String get homeSearchImportantHadithTitle => '50 مهم احاديث';

  @override
  String get homeSearchImportantHadithSubtitle =>
      'ستاسې له پورته شوې زده‌کړيزې سرچينې څخه د احاديثو بنسټيزه ټولګه.';

  @override
  String homeTimeRemainingToOffer(
    Object prayerName,
    Object duration,
    Object prayer,
  ) {
    return 'د $prayerName د ادا کولو پاتې وخت';
  }

  @override
  String homePrayerBecomesQada(Object prayerName, Object prayer, Object time) {
    return '$prayerName قضا کېږي';
  }

  @override
  String homeFractionValue(Object current, Object total) {
    return '$current / $total';
  }

  @override
  String homeDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ورځې',
      one: '1 ورځ',
      zero: '0 ورځې',
    );
    return '$_temp0';
  }

  @override
  String homeUntilTime(Object time) {
    return 'تر $time پورې';
  }

  @override
  String get homePrayerForbiddenSunrise => 'اوس لمونځ اجازه نه لري • لمر ختل';

  @override
  String get homePrayerForbiddenZenith => 'اوس لمونځ اجازه نه لري • زوال';

  @override
  String get homePrayerForbiddenSunset => 'اوس لمونځ اجازه نه لري • لمر لوېدل';

  @override
  String homeLevelValue(Object level, Object value) {
    return 'کچه $level';
  }

  @override
  String homeXpValue(Object xp, Object value) {
    return '$xp XP';
  }

  @override
  String homeXpToNextLevelValue(Object xp, Object value) {
    return 'تر بلې کچې پورې $xp XP';
  }

  @override
  String get homeDailyBadgesTitle => 'ورځنۍ نښانې';

  @override
  String homeContinueQuranValue(
    Object surahName,
    Object ayahNumber,
    Object surah,
    Object verse,
  ) {
    return '$surahName $ayahNumber';
  }

  @override
  String homeJourneyRingsValue(
    Object prayerPercent,
    Object dhikrPercent,
    Object quranPercent,
    Object completed,
    Object count,
    Object total,
  ) {
    return 'P $prayerPercent% · D $dhikrPercent% · Q $quranPercent%';
  }

  @override
  String homeCountAndLabel(Object count, Object label) {
    return '$count • $label';
  }

  @override
  String get homeShortcutQiblaLabel => 'قبله';

  @override
  String get homeShortcutSalahLabel => 'لمونځ';

  @override
  String get homeShortcutDhikrLabel => 'ذکر';

  @override
  String get homeShortcutDailyCaption => 'ورځنی';

  @override
  String homeShortcutMissedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فوت',
      one: '1 فوت',
      zero: '0 فوت',
    );
    return '$_temp0';
  }

  @override
  String get homeShortcutDailyDhikrGoalReached => 'د نن د ذکر موخه پوره شوه';

  @override
  String get homeShortcutClose => 'بندول';

  @override
  String get homeShortcutOpen => 'لنډلارې';

  @override
  String get homePrayerOfferedStatus => 'ادا شوی';

  @override
  String homePrayerBeginsAt(Object time) {
    return 'پيلېږي په';
  }

  @override
  String homeDurationMinutes(String minutes) {
    return '$minutesد';
  }

  @override
  String homeDurationHoursMinutes(String hours, String minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String get durationCompactHourSuffix => 'h';

  @override
  String get durationCompactMinuteSuffix => 'm';

  @override
  String homeLearnCategoryFallbackSubtitle(String category) {
    return 'د زده کړې کټګوري • $category';
  }

  @override
  String homeBadgeEarnedCount(String count) {
    return '$count تر لاسه شوې';
  }

  @override
  String get homeBadgeEarnedToday => 'نن تر لاسه شوې';

  @override
  String get homeDailyLearningQuizzesTitle => 'ورځنۍ زده کړه او کويزونه';

  @override
  String get homeDailyLearningQuizzesSubtitle =>
      'ورځنۍ وحي، د انبياوو بياکتنه، ټرېويا، او لارښود کويزونه په يوه ځای کې وساتئ.';

  @override
  String get homeDailyLearningProphetsQuiz => 'د انبياوو کويز';

  @override
  String get homeDailyLearningIslamicTrivia => 'اسلامي ټرېويا';

  @override
  String get homeDailyLearningKnowledgePaths => 'د پوهې لارې';

  @override
  String get homeDailyLearningReviewMistakes => 'غلطۍ بيا وګورئ';

  @override
  String get homeTapVerseCardHint => 'Tap this card to change verse';

  @override
  String get prayerHistory => 'Prayer history';

  @override
  String get missedReminder => 'Missed reminder';

  @override
  String get gentleSchedule => 'Gentle schedule';

  @override
  String get start33Recitation => 'Start 33 recitation';

  @override
  String get resumeWhereLeft => 'Resume where left';

  @override
  String get reflectionQuote =>
      '\"One sincere reminder can outweigh many scattered efforts.\"';

  @override
  String get levelLabel => 'Level';

  @override
  String get streakLabel => 'Streak';

  @override
  String get prayersCompletedLabel => 'Prayers completed';

  @override
  String get dhikrSessionsLabel => 'Dhikr sessions';

  @override
  String get oneToday => '1 today';

  @override
  String get sevenDays => '7 days';

  @override
  String get worshipTitle => 'Worship';

  @override
  String get worshipSubtitle =>
      'Daily acts of devotion centered into a calm, intentional flow.';

  @override
  String get learnTitle => 'Learn';

  @override
  String get learnSubtitle =>
      'A focused knowledge path for reflection and deeper understanding.';

  @override
  String get homeTitle => 'Home';

  @override
  String get journeyTitle => 'Growth';

  @override
  String get journeySubtitle => 'Long-term growth, light by light.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSubtitle => 'Intention, preferences, and personalization.';

  @override
  String get profileQuoteTranslation =>
      'Whoever is mindful of الله is guided toward balance and intention.';

  @override
  String get profileSummarySubtitle =>
      'Keep your intention steady and your settings aligned with ease.';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profileAddressMeAs => 'Address me as:';

  @override
  String get profileBrother => 'Brother';

  @override
  String get profileSister => 'Sister';

  @override
  String get profilePrayerSettingsTitle => 'Prayer & Prayer Time Settings';

  @override
  String get profilePrayerSettingsSubtitle =>
      'Set location and calculation preferences.';

  @override
  String get profileLocationLabel => 'Location';

  @override
  String get profileMadhabLabel => 'Madhab';

  @override
  String get profileCalculationMethodLabel => 'Prayer calculation method';

  @override
  String get profileAppearanceTitle => 'Appearance';

  @override
  String get profileAppearanceSubtitle => 'Visual and atmosphere preferences.';

  @override
  String get profileThemeModeLabel => 'Theme mode';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileReduceMotion => 'Reduce motion effects';

  @override
  String get profileHighContrastText => 'High contrast text';

  @override
  String get profileModesTitle => 'Modes';

  @override
  String get profileModesSubtitle =>
      'Mode presets to support focus and consistency.';

  @override
  String get profileRamadanModeTitle => 'Ramadan Mode';

  @override
  String get profileRamadanModeSubtitle =>
      'Prioritize fasting rhythm and devotional consistency.';

  @override
  String get profileLossModeTitle => 'Loss Mode';

  @override
  String get profileLossModeSubtitle =>
      'Gentle structure for spiritually heavy days.';

  @override
  String get profileGentleModeTitle => 'Gentle Mode';

  @override
  String get profileGentleModeSubtitle =>
      'Lighter reminders and softer daily expectations.';

  @override
  String get profileTrackingPrivacyTitle => 'Tracking & Privacy';

  @override
  String get profileTrackingPrivacySubtitle =>
      'Controls for reminders, summaries, and data intent.';

  @override
  String get profileLocationWhileUsingApp => 'Location while using app';

  @override
  String get profileLocationEnabledSubtitle =>
      'Enabled for foreground use only.';

  @override
  String get profileLocationDisabledSubtitle =>
      'Enable to keep prayer times accurate.';

  @override
  String get profileOpenSettings => 'Open settings';

  @override
  String get profileAllow => 'Allow';

  @override
  String get profilePrivateTrackingModeTitle => 'Private tracking mode';

  @override
  String get profilePrivateTrackingModeSubtitle =>
      'Keep progress visible only on this device.';

  @override
  String get profileMinimalTrackingModeTitle => 'Minimal tracking mode';

  @override
  String get profileMinimalTrackingModeSubtitle =>
      'Track only key essentials with reduced metrics.';

  @override
  String get profileHideGrowthVisualsTitle => 'Hide growth visuals';

  @override
  String get profileHideGrowthVisualsSubtitle =>
      'Limit streak and level visuals for a quieter experience.';

  @override
  String get profileReflectionOnlyModeTitle => 'Reflection-only mode';

  @override
  String get profileReflectionOnlyModeSubtitle =>
      'Prioritize reminders and notes over progress visuals.';

  @override
  String get profileEntrustDeedsTitle => 'Entrust deeds';

  @override
  String get profileEntrustDeedsSubtitle =>
      'A gentle reminder: sincere deeds are with الله.';

  @override
  String get profileNotificationsTitle => 'Notifications & Reminders';

  @override
  String get profileNotificationsSubtitle =>
      'Placeholder controls for future scheduling.';

  @override
  String get profilePrayerReminders => 'Prayer reminders';

  @override
  String get profileDhikrReminders => 'Dhikr reminders';

  @override
  String get profileQuranReminders => 'Qur\'an reminders';

  @override
  String get profileReflectionReminders => 'Reflection reminders';

  @override
  String get profileFastingReminders => 'Fasting reminders';

  @override
  String get profileLanguageExpandTitle => 'Language options';

  @override
  String get profileLanguageExpandSubtitle => 'Select language below';

  @override
  String get profileAboutTitle => 'About';

  @override
  String get profileAboutSubtitle => 'Product and app information.';

  @override
  String get profileMissionLine =>
      'A calm spiritual companion built for consistent, sincere growth.';

  @override
  String get profileVersionPlaceholder => 'Version 0.1.7 (placeholder)';

  @override
  String profilePlannedRemindersToday(int count) {
    return '$count planned reminders today';
  }

  @override
  String get languageOptionsTitle => 'Language Options';

  @override
  String get languageOptionsSubtitle =>
      'Choose your app language. Persian options include Farsi, Dari, and Tajik.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get languageMalay => 'Malay';

  @override
  String get languageBengali => 'Bengali';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageGerman => 'German';

  @override
  String get languageFarsi => 'Persian (Farsi)';

  @override
  String get languageDari => 'Persian (Dari)';

  @override
  String get languageTajik => 'Persian (Tajik)';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languagePunjabi => 'Punjabi';

  @override
  String get languageHausa => 'Hausa';

  @override
  String get languagePashto => 'Pashto';

  @override
  String get languageKurdish => 'Kurdish';

  @override
  String get learnTabQuran => 'Quran';

  @override
  String get learnTabLife => 'Life';

  @override
  String get learnTabWorld => 'World';

  @override
  String get learnTabHadith => 'Hadith';

  @override
  String get learnTabNotes => 'Notes';

  @override
  String get learnQuranSectionTitle => 'Quran Hub';

  @override
  String get learnQuranSectionSubtitle =>
      'Structured entry points for reading and review.';

  @override
  String get learnQuranContinueTitle => 'Continue Reading';

  @override
  String get learnQuranContinueSubtitle => 'Resume your last reading session.';

  @override
  String get learnQuranDailyVerseTitle => 'Daily Verse';

  @override
  String get learnQuranDailyVerseSubtitle =>
      'One verse for today\'s reflection.';

  @override
  String get learnQuranExplorerTitle => 'Surah Explorer';

  @override
  String get learnQuranExplorerSubtitle => 'Browse surahs by name and theme.';

  @override
  String get learnQuranBookmarksTitle => 'Bookmarks';

  @override
  String get learnQuranBookmarksSubtitle =>
      'Return to your saved ayat quickly.';

  @override
  String get learnQuranProgressTitle => 'Reading Streak and Progress';

  @override
  String get learnQuranProgressSubtitle =>
      'Track consistency and growth with balance.';

  @override
  String get learnLifeSectionTitle => 'Life through the Quran';

  @override
  String get learnLifeSectionSubtitle =>
      'Practical topics grounded in revelation.';

  @override
  String get learnLifeMarriage => 'Marriage';

  @override
  String get learnLifeParents => 'Parents';

  @override
  String get learnLifeChildren => 'Children';

  @override
  String get learnLifeWealth => 'Wealth';

  @override
  String get learnLifePatience => 'Patience';

  @override
  String get learnLifeJustice => 'Justice';

  @override
  String get learnLifeCharacter => 'Character';

  @override
  String get learnLifeGratitude => 'Gratitude';

  @override
  String get learnWorldSectionTitle => 'World through the Quran';

  @override
  String get learnWorldSectionSubtitle =>
      'Creation-focused categories for reflection.';

  @override
  String get learnWorldMoon => 'Moon';

  @override
  String get learnWorldBees => 'Bees';

  @override
  String get learnWorldMountains => 'Mountains';

  @override
  String get learnWorldRain => 'Rain';

  @override
  String get learnWorldOceans => 'Oceans';

  @override
  String get learnWorldAnimals => 'Animals';

  @override
  String get learnWorldPlants => 'Plants';

  @override
  String get learnWorldNightDay => 'Night and Day';

  @override
  String get learnHadithSectionTitle => 'Hadith Learning';

  @override
  String get learnHadithSectionSubtitle =>
      'Companion pathways for applied understanding.';

  @override
  String get learnHadithLifeLessonsTitle => 'Life Lessons of Hadith';

  @override
  String get learnHadithLifeLessonsSubtitle =>
      'Everyday guidance from authentic narrations.';

  @override
  String get learnHadithWorldLessonsTitle => 'World Lessons through Hadith';

  @override
  String get learnHadithWorldLessonsSubtitle =>
      'Wider perspective through prophetic insight.';

  @override
  String get learnHadithCharacterTitle => 'Character and Manners';

  @override
  String get learnHadithCharacterSubtitle =>
      'Adab, mercy, and conduct foundations.';

  @override
  String get learnHadithWorshipTitle => 'Worship and Intention';

  @override
  String get learnHadithWorshipSubtitle =>
      'Actions anchored in sincerity and purpose.';

  @override
  String get learnHadithFamilyTitle => 'Family and Society';

  @override
  String get learnHadithFamilySubtitle =>
      'Relationships, rights, and social balance.';

  @override
  String get learnNotesSectionTitle => 'Notes and Reflection';

  @override
  String get learnNotesSectionSubtitle =>
      'Study captures and personal insight placeholders.';

  @override
  String get learnNotesSavedTitle => 'Saved Notes';

  @override
  String get learnNotesSavedSubtitle =>
      'Your authored notes and study snippets.';

  @override
  String get learnNotesReflectionsTitle => 'Reflections';

  @override
  String get learnNotesReflectionsSubtitle =>
      'Journal-style reflection entries.';

  @override
  String get learnNotesHighlightsTitle => 'Highlights';

  @override
  String get learnNotesHighlightsSubtitle =>
      'Collected passages and marked excerpts.';

  @override
  String get learnNotesContinueTitle => 'Continue Learning';

  @override
  String get learnNotesContinueSubtitle =>
      'Resume your latest learning thread.';

  @override
  String get learnCommonNewBadge => 'نوی';

  @override
  String get learnCategoryHolyQuranTitle => 'سپېڅلی قرآن';

  @override
  String get learnCategoryQuranLearningTitle => 'د قرآن زده کړه';

  @override
  String get learnCategoryQuranicArabicTitle => 'قرآني عربي زده کړئ';

  @override
  String get learnCategoryIslamicTriviaTitle => 'اسلامي ټرېويا';

  @override
  String get learnCategoryHadithTitle => 'حديث';

  @override
  String get learnCategoryDivineLifeLessonsTitle => 'الهي د ژوند درسونه';

  @override
  String get learnCategoryWorldCreationTitle => 'نړۍ او پيدايښت';

  @override
  String get learnCategoryStoriesOfProphetsTitle => 'د انبياوو کيسې';

  @override
  String get learnCategoryBabyNamesTitle => 'د ماشومانو نومونه';

  @override
  String get learnCategoryQuizzesTitle => 'کويزونه';

  @override
  String get learnCategoryDuasTitle => 'دعاوې';

  @override
  String get learnCategorySalahTrainerTitle => 'د لمانځه روزونکی';

  @override
  String get learnCategoryNotesTitle => 'يادښتونه';

  @override
  String get learnHubTitle => 'د زده کړې مرکز';

  @override
  String get learnShortcutOpen => 'Shortcuts';

  @override
  String get learnShortcutClose => 'Close shortcuts';

  @override
  String get learnSectionLandingSubtitle =>
      'Follow a clearer path through foundations, belief, Prophets, Qur\'an learning, worship, and character.';

  @override
  String get learningSectionLandingShortcutJourneys => 'Open journeys';

  @override
  String get learningSectionLandingFoundationsTitle => 'Foundations';

  @override
  String get learningSectionLandingFoundationsSubtitle =>
      'Start with the essential building blocks of Islam.';

  @override
  String get learningSectionLandingBeliefTitle => 'Who is Allah?';

  @override
  String get learningSectionLandingBeliefSubtitle =>
      'Belief basics and the first questions of faith.';

  @override
  String get learningSectionLandingProphetsTitle => 'Prophets';

  @override
  String get learningSectionLandingProphetsSubtitle =>
      'Learn from the lives, tests, and examples of the Prophets.';

  @override
  String get learningSectionLandingQuranTitle => 'Qur\'an Learning';

  @override
  String get learningSectionLandingQuranSubtitle =>
      'Study recitation, themes, and Qur\'anic understanding.';

  @override
  String get learningSectionLandingWorshipTitle => 'Worship Learning';

  @override
  String get learningSectionLandingWorshipSubtitle =>
      'Learn salah, wudu, dhikr, and practical worship guidance.';

  @override
  String get learningSectionLandingCharacterTitle => 'Character & Adab';

  @override
  String get learningSectionLandingCharacterSubtitle =>
      'Grow mercy, manners, sincerity, and everyday adab.';

  @override
  String get learningSectionLandingBrowseAllTitle => 'Browse All Knowledge';

  @override
  String get learningSectionLandingBrowseAllSubtitle =>
      'Explore every learning island in one place.';

  @override
  String get worshipSectionLandingPrayerShortcut =>
      'Times, tracking, and guidance';

  @override
  String get worshipSectionLandingDhikrShortcut =>
      'Counter, sessions, and calm remembrance';

  @override
  String get worshipSectionLandingPrayerTitle => 'Prayer';

  @override
  String get worshipSectionLandingPrayerSubtitle =>
      'Prayer times, tracking, qada, and practical guidance.';

  @override
  String get worshipSectionLandingDhikrTitle => 'Dhikr';

  @override
  String get worshipSectionLandingDhikrSubtitle =>
      'Keep remembrance close with guided and manual sessions.';

  @override
  String get worshipSectionLandingDuasTitle => 'Duas';

  @override
  String get worshipSectionLandingDuasSubtitle =>
      'Open the dua collection and find what fits the moment.';

  @override
  String get worshipSectionLandingFastingSubtitle =>
      'Review your fasting status, intention, and key moments.';

  @override
  String get worshipTrackingPageTitle => 'Tracking & History';

  @override
  String get worshipTrackingPageSubtitle =>
      'See prayer, dhikr, and fasting records without crowding the main worship hub.';

  @override
  String worshipTrackingPrayerSummary(int count, String date) {
    return '$count prayer entries recorded. Reviewing $date.';
  }

  @override
  String worshipTrackingDhikrSummary(int current, int target, int sessions) {
    return '$current of $target today, with $sessions recent sessions saved.';
  }

  @override
  String worshipTrackingFastingSummary(String status) {
    return 'Today\'s fasting status: $status.';
  }

  @override
  String get worshipRemindersPageTitle => 'Reminders';

  @override
  String get worshipRemindersPageSubtitle =>
      'Keep prayer and worship reminders together without overloading the main worship page.';

  @override
  String worshipRemindersPrayerSummary(int count) {
    return '$count prayer reminder types are currently active.';
  }

  @override
  String worshipRemindersGeneralSummary(
    String dhikr,
    String quran,
    String reflection,
  ) {
    return 'Dhikr: $dhikr, Qur\'an: $quran, Reflection: $reflection.';
  }

  @override
  String get worshipRemindersDevicesSummary =>
      'Manage widget, lock screen, and watch-related worship surfaces.';

  @override
  String get settingsReminderStateOn => 'On';

  @override
  String get settingsReminderStateOff => 'Off';

  @override
  String get settingsLandingTitle => 'Settings';

  @override
  String get settingsLandingSubtitle =>
      'Choose a focused settings area instead of browsing one long page.';

  @override
  String get settingsCategoryAccountSyncSubtitle =>
      'Profiles, backup, sync status, and account safety.';

  @override
  String get settingsCategoryAppearanceSubtitle =>
      'Theme, motion, contrast, and calm reading preferences.';

  @override
  String get settingsCategoryPrayerWorshipSubtitle =>
      'Prayer times, adhan, and worship setup.';

  @override
  String get settingsCategoryLearningSubtitle =>
      'Learning entry points, family management, and study-related settings.';

  @override
  String get settingsCategoryNotificationsSubtitle =>
      'Prayer reminders and general reminder controls.';

  @override
  String get settingsCategoryWidgetsWatchTitle =>
      'Widgets, Live Activities & Watch';

  @override
  String get settingsCategoryWidgetsWatchSubtitle =>
      'Manage lock screen, Dynamic Island, and connected watch surfaces.';

  @override
  String get settingsCategoryLanguageDownloadsSubtitle =>
      'Language choices and download-ready content settings.';

  @override
  String get settingsCategoryPrivacyDataSubtitle =>
      'Control tracking visibility, privacy, and sensitive data behavior.';

  @override
  String get settingsCategoryKidsFamilyTitle => 'Kids & Family';

  @override
  String get settingsCategoryKidsFamilySubtitle =>
      'Adjust family learning and kid-friendly presentation settings.';

  @override
  String get settingsCategoryAboutSubtitle =>
      'Version notes, support, legal details, and what is coming next.';

  @override
  String get settingsLearningHubSubtitle =>
      'Open the learning hub and family learning tools from one focused place.';

  @override
  String get learnHubSubtitle =>
      'يوه ګډه زده‌کړيزه تجربه د حديث، انبياوو، د ژوند درسونو، لارښود تمرين، کويزونو، او يادښتونو ترمنځ.';

  @override
  String get learnHubQuoteTranslation => 'زما ربه، زما پوهه زياته کړه.';

  @override
  String get learnHubQuoteLocation => 'قرآن 20:114';

  @override
  String get learnHubExploreCategoriesTitle => 'کټګورۍ وپلټئ';

  @override
  String get learnHubExploreCategoriesSubtitle =>
      'د زده کړې ټولې کټګورۍ وګورئ او د برخې له مخې فلټر يې کړئ.';

  @override
  String get learnHubExploreByThemeTitle => 'د موضوع له مخې پلټنه';

  @override
  String get learnHubExploreByThemeSubtitle =>
      'په ټولو زده‌کړيزو برخو کې ګډه موضوعي طبقه‌بندي وکاروئ.';

  @override
  String get learnHubGuidedPathsTitle => 'لارښود لارې';

  @override
  String get learnHubGuidedPathsSubtitle =>
      'ګډ-منځپانګې لارې چې د يو واحد path engine له خوا چلېږي.';

  @override
  String get learnHubSavedAndNotesTitle => 'ساتل شوي او يادښتونه';

  @override
  String get learnHubSavedAndNotesSubtitle =>
      'په زده‌کړيزو برخو کې يو واحد خوندي شوی او يادښت ليد.';

  @override
  String get learnHubKnowledgeConstellationSubtitle =>
      'په بېلابېلو برخو کې ګډ اړيکيز ګراف وپلټئ.';

  @override
  String learnHubSavedNotesSummary(Object saved, Object notes, Object count) {
    return 'ساتل شوي توکي: $saved • يادښتونه: $notes';
  }

  @override
  String get learnHubNoSavedItems =>
      'لا تر اوسه هېڅ خوندي شوی توکی نشته. هر درس، آيت، حديث، يا نبي خوندي کړئ څو دلته پاتې شي.';

  @override
  String learnHubIndexedRelationshipsCount(Object count) {
    return '$count شاخص شوي اړيکې';
  }

  @override
  String get learnHubOpenKnowledgeConstellation =>
      'د پوهې constellation پرانيزئ';

  @override
  String get learnHubContinueWhereYouLeftOff => 'له هماغه ځايه دوام ورکړئ';

  @override
  String get learnHubResumeAction => 'دوام';

  @override
  String get learnHubDailyLearningTitle => 'ورځنۍ زده کړه';

  @override
  String learnHubDailyThemeLabel(Object theme) {
    return 'موضوع: $theme';
  }

  @override
  String get learnHubOpenDailyReflectionAction => 'ورځنی تامل پرانيزئ';

  @override
  String get learnHubWriteReflectionAction => 'تامل وليکئ';

  @override
  String get learnHubSearchHint =>
      'په قرآن، حديث، انبياوو، درسونو، نومونو کې ولټوئ...';

  @override
  String get learnHubClearSearchTooltip => 'لټون پاک کړئ';

  @override
  String get learnHubFilterTypeTooltip => 'د ډول له مخې فلټر';

  @override
  String get learnHubFilterThemeTooltip => 'د موضوع له مخې فلټر';

  @override
  String get learnHubFilterDifficultyTooltip => 'د ستونزمنتيا له مخې فلټر';

  @override
  String get learnHubFilterPathTooltip => 'د لارې له مخې فلټر';

  @override
  String get learnHubTypeAnyLabel => 'ډول: هر يو';

  @override
  String learnHubTypeValueLabel(Object type, Object value) {
    return 'ډول: $type';
  }

  @override
  String get learnHubAnyTypeOption => 'هر ډول';

  @override
  String get learnHubThemeAnyLabel => 'موضوع: هره يوه';

  @override
  String learnHubThemeValueLabel(Object theme, Object value) {
    return 'موضوع: $theme';
  }

  @override
  String get learnHubAnyThemeOption => 'هره موضوع';

  @override
  String get learnHubDifficultyAnyLabel => 'ستونزمنتيا: هره يوه';

  @override
  String learnHubDifficultyValueLabel(Object difficulty, Object value) {
    return 'ستونزمنتيا: $difficulty';
  }

  @override
  String get learnHubAnyDifficultyOption => 'هره ستونزمنتيا';

  @override
  String get learnHubPathAnyLabel => 'لاره: هره يوه';

  @override
  String get learnHubPathActiveLabel => 'لاره: فعاله';

  @override
  String get learnHubAnyPathOption => 'هره لاره';

  @override
  String get learnHubSavedOnlyFilter => 'يوازې خوندي شوي';

  @override
  String learnHubResultsCount(Object count) {
    return '$count پايلې';
  }

  @override
  String get learnHubNoMatchingItems =>
      'هېڅ برابر توکي نشته. لږ پراخ فلټرونه وازمايئ.';

  @override
  String learnHubPathProgress(
    Object completed,
    Object total,
    Object progress,
    Object value,
  ) {
    return '$completed / $total بشپړ شوي';
  }

  @override
  String get learnHubItemTypeVerse => 'آيت';

  @override
  String get learnHubItemTypeHadith => 'حديث';

  @override
  String get learnHubItemTypeProphet => 'نبي';

  @override
  String get learnHubItemTypeLifeLesson => 'د ژوند درس';

  @override
  String get learnHubItemTypeSalahPrayer => 'د لمانځه برخه';

  @override
  String get learnHubItemTypeSurah => 'سورت';

  @override
  String get learnHubItemTypeRecitation => 'تلاوت';

  @override
  String get learnHubItemTypeNameOfAllah => 'د الله نوم';

  @override
  String get learnHubItemTypeBabyName => 'د ماشوم نوم';

  @override
  String get learnHubItemTypeQuiz => 'کويز';

  @override
  String get learnHubItemTypeNote => 'يادښت';

  @override
  String get learnHubItemTypeReflection => 'تامل';

  @override
  String get learnHubItemTypePathStep => 'د لارې ګام';

  @override
  String get learnHubDifficultyIntermediate => 'منځنی';

  @override
  String get learnHubDifficultyAdvanced => 'لوړ';

  @override
  String get learnHubCategoryGroupAll => 'ټول';

  @override
  String get learnHubCategoryGroupCore => 'بنسټيز';

  @override
  String get learnHubCategoryGroupWorship => 'عبادت';

  @override
  String get learnHubCategoryGroupFamilyUtility => 'کورنۍ او ګټه';

  @override
  String get learnHubCategoryGroupNewMuslim => 'نوی مسلمان';

  @override
  String get learnHubCategoryGroupPilgrimage => 'حج';

  @override
  String get learningReferencesShowLess => 'لږ وښيئ';

  @override
  String get learningReferencesShowAll => 'ټولې حوالې وښيئ';

  @override
  String quranReferenceViewerReferenceLabel(Object reference) {
    return 'قرآن $reference';
  }

  @override
  String get quranReferenceBlockLoadError =>
      'Unable to load verse content right now.';

  @override
  String get quranReferenceBlockTransliterationUnavailable =>
      'Transliteration is not available for this ayah yet.';

  @override
  String get quranReferenceBlockLoadingTranslation => 'Loading translation...';

  @override
  String get quranReferenceBlockSurahLabel => 'Surah';

  @override
  String get quranReferenceViewerNotFound => 'حواله ونه موندل شوه.';

  @override
  String get quranReferenceViewerOpenInReader => 'آيت په لوستونکي کې پرانيزئ';

  @override
  String get quranReferenceViewerRelatedLifeLessons => 'اړوند د ژوند درسونه';

  @override
  String get quranReferenceViewerRelatedHadith => 'اړوند حديث';

  @override
  String get quranReferenceViewerRelatedProphets => 'اړوند انبيا';

  @override
  String get quranReferenceViewerRelatedJourneys => 'اړوند سفرونه';

  @override
  String get triviaModeQuickChallenge => 'چټک چيلنج';

  @override
  String get triviaModeQuickChallengeSubtitle =>
      'د ثابت تمرين لپاره يوه لنډه ګډه ناسته.';

  @override
  String get triviaModeDeepDive => 'ژوره کتنه';

  @override
  String get triviaModeDeepDiveSubtitle =>
      'يو اوږد او متمرکز پړاو له زياتې ژورتيا سره.';

  @override
  String get triviaModeDailyQuiz => 'ورځنی کويز';

  @override
  String get triviaModeDailyQuizSubtitle =>
      'د نن لپاره يوه غوره شوې ټولګه له د لومړۍ بشپړتيا انعامونو سره.';

  @override
  String get triviaModeSurvival => 'د بقا حالت';

  @override
  String get triviaModeSurvivalSubtitle =>
      'تر هغې دوام ورکړئ څو تېروتنه وکړئ يا ټول پوله بشپړه شي.';

  @override
  String get triviaModeReviewMistakes => 'غلطۍ بيا وګورئ';

  @override
  String get triviaModeReviewMistakesSubtitle =>
      'هغو پوښتنو ته بېرته لاړ شئ چې يو بل ځل ته اړتیا لري.';

  @override
  String get triviaDifficultyEasy => 'اسانه';

  @override
  String get triviaDifficultyMedium => 'منځنی';

  @override
  String get triviaDifficultyHard => 'سخت';

  @override
  String get triviaStageStateCompleted => 'بشپړ شوی';

  @override
  String get triviaStageStateUnlocked => 'پرانيستل شوی';

  @override
  String get triviaStageStateLocked => 'قفل';

  @override
  String get triviaMasteryNew => 'نوی';

  @override
  String get triviaMasteryLearning => 'په زده کړه کې';

  @override
  String get triviaMasteryImproving => 'ښه کېږي';

  @override
  String get triviaMasteryMastered => 'پياوړی شوی';

  @override
  String get triviaStartAction => 'پيل';

  @override
  String get triviaQuickStartAction => 'چټک پيل';

  @override
  String get triviaOpenPathAction => 'لاره پرانيزئ';

  @override
  String get triviaOpenStageTooltip => 'پړاو پرانيزئ';

  @override
  String triviaQuestionsCount(Object count) {
    return '$count پوښتنې';
  }

  @override
  String get triviaHomeSubtitle =>
      'د لنډو کويزونو، ورځنۍ بياکتنې، او نرمې پياوړتيا لپاره د پوهې يو ارام ځای.';

  @override
  String get triviaHomeCurrentStreakLabel => 'اوسنی لړۍ';

  @override
  String triviaHomeLongestStreakCaption(Object count) {
    return 'تر ټولو اوږده $count';
  }

  @override
  String get triviaHomeAccuracyLabel => 'دقت';

  @override
  String triviaHomeAnsweredCount(Object count) {
    return '$count ځواب شوي';
  }

  @override
  String get triviaHomeTriviaXpLabel => 'ټرېويا XP';

  @override
  String triviaHomeQuizzesCompletedCount(Object count) {
    return '$count بشپړ شوي کويزونه';
  }

  @override
  String get triviaHomeOceanDropsLabel => 'د سمندر څاڅکي';

  @override
  String triviaHomeBestSurvivalCaption(Object count) {
    return 'تر ټولو ښه بقا $count';
  }

  @override
  String get triviaHomeContinuePreviousSessionTitle => 'مخکنۍ ناسته ادامه کړئ';

  @override
  String get triviaHomeContinuePreviousSessionSubtitle =>
      'ستاسې ناتمام پړاو لا هم درته په تمه دی.';

  @override
  String triviaHomeAnsweredProgress(Object answered, Object total) {
    return '$answered له $total څخه ځواب شوي.';
  }

  @override
  String get triviaHomeTodayTitle => 'نن';

  @override
  String get triviaHomeTodaySubtitle =>
      'له يوې لنډې ورځنۍ ناستې پيل وکړئ يا هغه څه بيا وګورئ چې يو بل ځل ته اړتیا لري.';

  @override
  String get triviaCompletedTodayLabel => 'نن بشپړ شوي';

  @override
  String get triviaAvailableLabel => 'شته';

  @override
  String get triviaNoDueItemsLabel => 'هېڅ پاتې توکي نشته';

  @override
  String triviaDueCount(Object count) {
    return '$count پاتې';
  }

  @override
  String get triviaHomeKnowledgePathsTitle => 'د پوهې لارې';

  @override
  String get triviaHomeKnowledgePathsSubtitle =>
      'له لنډو درسونو او متمرکزو پړاويزو کويزونو سره يو لارښود سفر تعقيب کړئ.';

  @override
  String get triviaHomeStructuredLearningTitle => 'جوړښتي زده کړه';

  @override
  String get triviaHomeStructuredLearningSubtitle =>
      'په ارامۍ سره، يو پړاو په يو وخت، د موضوع-پر بنسټ سفرونو له لارې پر مخ لاړ شئ.';

  @override
  String get triviaHomeOpenKnowledgePathsAction => 'د پوهې لارې پرانيزئ';

  @override
  String get triviaHomeCoreModesTitle => 'اصلي حالتونه';

  @override
  String get triviaHomeCoreModesSubtitle =>
      'يوه لنډه ګډه ناسته وټاکئ يا له يوې موضوع سره اوږد پاتې شئ.';

  @override
  String get triviaHomeCategoriesTitle => 'کټګورۍ';

  @override
  String get triviaHomeCategoriesSubtitle =>
      'له يوې متمرکزې کټګورۍ پيل وکړئ يا وګورئ چې په کومه برخه کې پياوړي ياست.';

  @override
  String get triviaHomeNoAnswersYet => 'لا ځوابونه نشته';

  @override
  String triviaHomeCategoryAccuracy(
    Object percent,
    Object accuracy,
    Object category,
  ) {
    return 'دقت $percent%';
  }

  @override
  String get triviaHomeReviewQueueAction => 'د بياکتنې قطار';

  @override
  String get triviaHomeProgressStatsAction => 'پرمختګ او احصايې';

  @override
  String get triviaHomeRecentPerformanceTitle => 'وروستۍ کارکردګي';

  @override
  String get triviaHomeRecentPerformanceSubtitle =>
      'ستاسې د وروستيو ناستو يوه ارامه کتنه.';

  @override
  String get triviaHomeNoSessionsYetTitle => 'لا ناستې نشته';

  @override
  String get triviaHomeNoSessionsYetSubtitle =>
      'يو لنډ کويز پيل کړئ او وروستی پرمختګ به مو دلته ښکاره شي.';

  @override
  String get triviaMixedLabel => 'ګډ';

  @override
  String triviaHomeRecentPerformanceSummary(
    Object category,
    Object correct,
    Object total,
    Object xp,
    Object accuracy,
    Object incorrect,
    Object sessions,
  ) {
    return '$category • $correct/$total سم • +$xp XP';
  }

  @override
  String get triviaResultsTitle => 'د ناستې پايلې';

  @override
  String get triviaResultsSubtitle =>
      'وګورئ څه ښه شول او څه بايد په راتلونکې بياکتنه کې راشي.';

  @override
  String get triviaResultsScoreLabel => 'نمره';

  @override
  String get triviaResultsXpGainedLabel => 'ترلاسه شوی XP';

  @override
  String get triviaResultsPerfectBonusIncluded => 'د بشپړې نمرې بونس شامل دی';

  @override
  String get triviaResultsReplayRewardsLighter => 'د بيا لوبولو انعامونه لږ وي';

  @override
  String triviaResultsCompletedSummary(
    Object seconds,
    Object missed,
    Object completed,
    Object correct,
    Object total,
  ) {
    return 'په ${seconds}s کې بشپړ شو • $missed پاتې';
  }

  @override
  String triviaResultsBestRunInSession(Object count) {
    return 'په دې ناسته کې تر ټولو ښه پړاو: $count';
  }

  @override
  String get triviaResultsRetryStageAction => 'پړاو بيا وکړئ';

  @override
  String get triviaResultsRetryAction => 'بيا وکړئ';

  @override
  String get triviaReviewMistakesAction => 'غلطۍ بيا وګورئ';

  @override
  String get triviaResultsBackToPathAction => 'بېرته لارې ته';

  @override
  String get triviaResultsGoHomeAction => 'کور ته لاړ شئ';

  @override
  String get triviaResultsMissedQuestionsTitle => 'له لاسه وتلې پوښتنې';

  @override
  String get triviaResultsMissedQuestionsSubtitle =>
      'دا به ستاسې د بياکتنې قطار ته هم ولاړې شي څو مو پياوړتيا زياته کړي.';

  @override
  String get triviaResultsNoMissedQuestionsTitle => 'هېڅ پوښتنه پاتې نه شوه';

  @override
  String get triviaResultsNoMissedQuestionsSubtitle =>
      'دا ناسته پاکه پاتې شوه. ستاسې د بياکتنې قطار اوس لږ سپک دی.';

  @override
  String get triviaReviewMistakesTitle => 'غلطۍ بيا وګورئ';

  @override
  String get triviaReviewMistakesSubtitle =>
      'هغه پوښتنې چې تاسې پرې غلط شوي ياست، دلته په نرمه توګه بېرته راګرځي تر څو پياوړې شي.';

  @override
  String get triviaReviewDueNowLabel => 'اوس پاتې';

  @override
  String get triviaReviewImprovingLabel => 'ښه کېږي';

  @override
  String get triviaReviewMasteredLabel => 'پياوړی شوی';

  @override
  String get triviaReviewNoQuestionsDueTitle =>
      'د بياکتنې کومې پوښتنې پاتې نه دي';

  @override
  String get triviaReviewNoQuestionsDueSubtitle =>
      'تمرين ته دوام ورکړئ. هغه پوښتنې چې تاسې پرې غلط شئ، دلته به بېرته راشي.';

  @override
  String get triviaReviewStartSessionTitle => 'د بياکتنې ناسته پيل کړئ';

  @override
  String triviaReviewStartSessionSubtitle(Object count) {
    return '$count توکي چمتو دي. قطار هغه څه لومړيتوب ورکوي چې تازه غلط شوي يا لا بې‌ثباته دي.';
  }

  @override
  String get triviaReviewStartAction => 'بياکتنه پيل کړئ';

  @override
  String get triviaReviewPriorityItemsTitle => 'لومړيتوب لرونکي توکي';

  @override
  String get triviaReviewPriorityItemsSubtitle =>
      'دا پوښتنې ژر راځي ځکه ډېرې غلطې شوې دي.';

  @override
  String get triviaUnknownCategory => 'ناپېژندل شوی';

  @override
  String triviaReviewSeenCorrectIncorrect(
    Object seen,
    Object correct,
    Object incorrect,
  ) {
    return 'لیدل شوي $seen • سم $correct • غلط $incorrect';
  }

  @override
  String get triviaStageNotFoundTitle => 'پړاو ونه موندل شو';

  @override
  String get triviaStageNotFoundSubtitle =>
      'دا د پوهې لارې پړاو اوس مهال نشته.';

  @override
  String get triviaStageQuizTitle => 'د پړاو کويز';

  @override
  String triviaStageQuizSubtitle(Object count) {
    return '$count متمرکزې پوښتنې ځواب کړئ. غلط ځوابونه بيا هم ستاسې د بياکتنې قطار ته ځي.';
  }

  @override
  String get triviaContinueQuizAction => 'کويز ته دوام ورکړئ';

  @override
  String get triviaStartQuizAction => 'کويز پيل کړئ';

  @override
  String get triviaIncludedQuestionsTitle => 'شاملې پوښتنې';

  @override
  String get triviaIncludedQuestionsSubtitle =>
      'يوه لنډه کتنه د دې چې دا پړاو به څه پياوړي کړي.';

  @override
  String get triviaNoQuestionsAvailableTitle => 'هېڅ پوښتنې نشته';

  @override
  String get triviaNoQuestionsAvailableSubtitle =>
      'دا پړاو د سمې ټرېويا پوښتنې-اړوندتيا ته اړتیا لري.';

  @override
  String get triviaKnowledgePathNotFoundTitle => 'د پوهې لاره ونه موندل شوه';

  @override
  String get triviaKnowledgePathNotFoundSubtitle =>
      'دا لارښود لاره اوس مهال نشته.';

  @override
  String triviaKnowledgePathStagesCompleted(Object completed, Object total) {
    return '$completed له $total پړاوونو څخه بشپړ شوي';
  }

  @override
  String get triviaKnowledgePathCompleteSubtitle =>
      'دا لاره بشپړه شوې. تاسې کولی شئ هر پړاو د بياکتنې لپاره بېرته وګورئ.';

  @override
  String get triviaKnowledgePathIncompleteSubtitle =>
      'هر پړاو يو لنډ درس او يو متمرکز کويز لري.';

  @override
  String get triviaContinueStageAction => 'پړاو ته دوام ورکړئ';

  @override
  String get triviaStartPathAction => 'لاره پيل کړئ';

  @override
  String get triviaContinuePathAction => 'لارې ته دوام ورکړئ';

  @override
  String get triviaStagesTitle => 'پړاوونه';

  @override
  String get triviaStagesSubtitle =>
      'په ترتيب سره مخکې لاړ شئ. هر بشپړ شوی پړاو بل پرانيزي.';

  @override
  String triviaKnowledgeStageSummary(
    Object count,
    Object xp,
    Object difficulty,
    Object index,
    Object questionCount,
    Object questions,
    Object status,
    Object total,
  ) {
    return '$count پوښتنې • +$xp XP';
  }

  @override
  String get learnQuizzesHubSubtitle =>
      'Practice what you have learned across the different learning sections with one organized quiz hub.';

  @override
  String get learnQuizzesSearchHint => 'Search quiz titles, modules, topics...';

  @override
  String get learnQuizzesNoMatchTitle => 'No quizzes match this filter.';

  @override
  String get learnQuizzesNoMatchSubtitle =>
      'Try a broader keyword or switch categories.';

  @override
  String get learnQuizzesProphetsSectionTitle => 'Prophets Quizzes';

  @override
  String get learnQuizzesProphetsSectionSubtitle =>
      'Mode-based quizzes from the Prophets module.';

  @override
  String get learnQuizzesHadithSectionTitle => 'Hadith Chapter Quizzes';

  @override
  String get learnQuizzesHadithSectionSubtitle =>
      'Path and chapter quizzes from the Hadith module.';

  @override
  String get learnQuizzesReviewSectionTitle => 'Hadith Review Quizzes';

  @override
  String get learnQuizzesReviewSectionSubtitle =>
      'Review-style quizzes from your Hadith learning.';

  @override
  String learnQuizzesAvailableCount(Object count) {
    return '$count quizzes available';
  }

  @override
  String learnQuizzesHadithChapterCount(Object count) {
    return '$count hadith chapter quizzes';
  }

  @override
  String learnQuizzesProphetModeCount(Object count) {
    return '$count prophet quiz modes';
  }

  @override
  String learnQuizzesLearningModulesLive(Object count) {
    return '$count learning modules live';
  }

  @override
  String get learnQuizzesStartsAtEasy => 'Starts at Easy';

  @override
  String get learnQuizzesOpenProphetQuiz => 'Open prophet quiz';

  @override
  String get learnQuizzesStartChapterQuiz => 'Start chapter quiz';

  @override
  String get learnQuizzesRandomHadithReviewSubtitle =>
      'Mixed review from completed or available hadith lessons.';

  @override
  String get learnQuizzesWeeklyKnowledgeCheck => 'Weekly Knowledge Check';

  @override
  String get learnQuizzesWeeklyKnowledgeCheckSubtitle =>
      'A weekly hadith check-in pulled from learned material.';

  @override
  String get learnQuizzesStartWeeklyQuiz => 'Start weekly quiz';

  @override
  String get learnQuizzesFilterReview => 'Review';

  @override
  String get learnQuizzesProphetModeIdentification => 'Prophet Identification';

  @override
  String get learnQuizzesProphetModeTimeline => 'Timeline Order';

  @override
  String get learnQuizzesProphetModeStoryMatching => 'Story Matching';

  @override
  String get learnQuizzesProphetModeQuranReference => 'Qur’an Reference';

  @override
  String get learnQuizzesProphetModeLessonRecognition => 'Lesson Recognition';

  @override
  String get learnQuizzesProphetModeIdentificationSubtitle =>
      'Recognize prophets through names, roles, and core traits.';

  @override
  String get learnQuizzesProphetModeTimelineSubtitle =>
      'Practice chronology and placement across prophetic history.';

  @override
  String get learnQuizzesProphetModeStoryMatchingSubtitle =>
      'Match prophets to events, tests, and story details.';

  @override
  String get learnQuizzesProphetModeQuranReferenceSubtitle =>
      'Connect prophets with their Qur’anic references and contexts.';

  @override
  String get learnQuizzesProphetModeLessonRecognitionSubtitle =>
      'Identify the life lessons each prophetic story teaches.';

  @override
  String get learnQuizzesModeQuizGroup => 'Mode Quiz';

  @override
  String get learnQuizzesChapterQuizGroup => 'Chapter Quiz';

  @override
  String get babyNamesTitle => 'Muslim Baby Names';

  @override
  String get babyNamesSubtitle =>
      'A calm family naming library with meaning, context, and guidance.';

  @override
  String get babyNamesNameOfDay => 'Name of the Day';

  @override
  String get babyNamesBrowseSearchTitle => 'Browse & Search';

  @override
  String get babyNamesBrowseSearchSubtitle =>
      'Explore names by meaning, region, and style.';

  @override
  String get babyNamesSmartFinderTitle => 'Smart Name Finder';

  @override
  String get babyNamesSmartFinderSubtitle =>
      'Get thoughtful suggestions based on family preferences.';

  @override
  String get babyNamesFavoritesTitle => 'Favorites & Shortlist';

  @override
  String get babyNamesFavoritesSubtitle =>
      'Your saved names, private notes, and final picks.';

  @override
  String get babyNamesCompareTitle => 'Compare Names';

  @override
  String get babyNamesCompareSubtitle =>
      'See key details side by side before deciding.';

  @override
  String get babyNamesOverviewTitle => 'Library Overview';

  @override
  String get babyNamesCollectionsTitle => 'Curated Collections';

  @override
  String get babyNamesBoysLabel => 'Boys';

  @override
  String get babyNamesGirlsLabel => 'Girls';

  @override
  String get babyNamesUnisexLabel => 'Unisex';

  @override
  String get babyNamesQuranicLabel => 'Qur’anic';

  @override
  String get babyNamesCompanionLabel => 'Companion';

  @override
  String get babyNamesSavedCountLabel => 'saved';

  @override
  String get babyNamesShortlistCountLabel => 'in shortlist';

  @override
  String get babyNamesSelectedCountLabel => 'selected';

  @override
  String get babyNamesSearchHint =>
      'Search by name, Arabic, transliteration, meaning, origin, or tags';

  @override
  String get babyNamesFiltersTitle => 'Filters';

  @override
  String get babyNamesGenderLabel => 'Gender';

  @override
  String get babyNamesGenderAny => 'Any';

  @override
  String get babyNamesRegionFilterLabel => 'Region';

  @override
  String get babyNamesOriginFilterLabel => 'Origin';

  @override
  String get babyNamesRarityLabel => 'Rarity';

  @override
  String get babyNamesQuranicOnlyLabel => 'Qur’anic names only';

  @override
  String get babyNamesCompanionOnlyLabel => 'Companion names only';

  @override
  String get babyNamesAnyOption => 'Any';

  @override
  String get babyNamesSortLabel => 'Sort';

  @override
  String get babyNamesSortAlphabetical => 'Alphabetical';

  @override
  String get babyNamesSortPopularity => 'Popularity';

  @override
  String get babyNamesSortQuranicPriority => 'Qur’anic priority';

  @override
  String get babyNamesSortShortest => 'Shortest';

  @override
  String get babyNamesSortMostSaved => 'Most saved';

  @override
  String get babyNamesClearFilters => 'Clear';

  @override
  String get babyNamesResultsLabel => 'results';

  @override
  String get babyNamesNoResults =>
      'No names match this combination yet. Try easing one or two filters.';

  @override
  String get babyNamesFavoriteAction => 'Favorite';

  @override
  String get babyNamesShortlistAction => 'Shortlist';

  @override
  String get babyNamesCompareAction => 'Compare';

  @override
  String get babyNamesOpenCompare => 'Open compare';

  @override
  String get babyNamesMeaningTags => 'Meaning Tags';

  @override
  String get babyNamesStyleTags => 'Style Tags';

  @override
  String get babyNamesHistoricalTags => 'Historical Tags';

  @override
  String get babyNamesRegionsTitle => 'Common Regions';

  @override
  String get babyNamesVariantsTitle => 'Variants & Spellings';

  @override
  String get babyNamesQuranicAssociationsTitle => 'Qur’anic Associations';

  @override
  String get babyNamesHistoricalAssociationsTitle => 'Historical Associations';

  @override
  String get babyNamesReflectionTitle => 'Reflection';

  @override
  String get babyNamesPrivateNotesTitle => 'Private Notes';

  @override
  String get babyNamesPrivateNotesHint =>
      'Write why this name stands out for your family.';

  @override
  String get babyNamesSaveNote => 'Save note';

  @override
  String get babyNamesRelatedNamesTitle => 'Related Names';

  @override
  String get babyNamesFatherNameLabel => 'Father name (optional)';

  @override
  String get babyNamesMotherNameLabel => 'Mother name (optional)';

  @override
  String get babyNamesFirstLetterLabel => 'Preferred first letter';

  @override
  String get babyNamesClassicRareLabel => 'Style preference';

  @override
  String get babyNamesClassicRareBalanced => 'Balanced';

  @override
  String get babyNamesClassicRareClassic => 'Classic';

  @override
  String get babyNamesClassicRareRare => 'Rare';

  @override
  String get babyNamesEasyEnglishLabel => 'Prefer easy-in-English names';

  @override
  String get babyNamesPreferredMeaningTags => 'Preferred meaning themes';

  @override
  String get babyNamesSuggestionsLabel => 'suggestions';

  @override
  String get babyNamesFinderEmpty =>
      'Add a few preferences to generate suggestions.';

  @override
  String get babyNamesShortlistTitle => 'Shortlist';

  @override
  String get babyNamesFavoritesEmpty =>
      'No saved names yet. Favorite names from Browse or Detail pages.';

  @override
  String get babyNamesClearCompare => 'Clear compare';

  @override
  String get babyNamesCompareEmpty =>
      'Select at least 2 names to compare them side by side.';

  @override
  String get babyNamesFieldOrigin => 'Origin';

  @override
  String get babyNamesFieldGender => 'Gender';

  @override
  String get babyNamesFieldRoot => 'Root';

  @override
  String get babyNamesFieldTags => 'Tags';

  @override
  String get babyNamesOpenDetails => 'Open details';

  @override
  String get babyNamesRarityClassic => 'Classic';

  @override
  String get babyNamesRarityCommon => 'Common';

  @override
  String get babyNamesRarityUncommon => 'Uncommon';

  @override
  String get babyNamesRarityRare => 'Rare';

  @override
  String get journeyLevelSectionTitle => 'Level and XP';

  @override
  String get journeyLevelSectionSubtitle =>
      'Long-term growth with steady progression.';

  @override
  String get journeyLevelValue => 'Level 7';

  @override
  String get journeyXpValue => '1620 XP';

  @override
  String get journeyNextLevelText => '380 XP to next level';

  @override
  String get journeyLevelMotivation =>
      'Consistency builds depth. Small acts keep your journey moving.';

  @override
  String get journeyLightSectionTitle => 'Light Progress';

  @override
  String get journeyLightSectionSubtitle =>
      'A calm visual of accumulated light and effort.';

  @override
  String get journeyLightCardTitle => 'Light Accumulation';

  @override
  String get journeyLightCardSubtitle =>
      'Each sincere act adds light over time. Keep it gentle and consistent.';

  @override
  String get journeyRingsSectionTitle => 'Daily Rings';

  @override
  String get journeyRingsSectionSubtitle =>
      'Five daily focus rings for balanced growth.';

  @override
  String get journeyRingPrayer => 'Prayer';

  @override
  String get journeyRingDhikr => 'Dhikr';

  @override
  String get journeyRingQuran => 'Quran';

  @override
  String get journeyRingReflection => 'Reflection';

  @override
  String get journeyRingFasting => 'Fasting';

  @override
  String get journeyStreakSectionTitle => 'Streaks';

  @override
  String get journeyStreakSectionSubtitle =>
      'Current and best consistency snapshots.';

  @override
  String get journeyCurrentStreakLabel => 'Current streak';

  @override
  String get journeyCurrentStreakValue => '6 days';

  @override
  String get journeyBestStreakLabel => 'Best streak';

  @override
  String get journeyBestStreakValue => '18 days';

  @override
  String get journeyWeeklyConsistencyLabel => 'Weekly consistency';

  @override
  String get journeyMilestoneSectionTitle => 'Milestones';

  @override
  String get journeyMilestoneSectionSubtitle =>
      'Progress markers for key early achievements.';

  @override
  String get journeyMilestoneFirst7Days => 'First 7 days completed';

  @override
  String get journeyMilestoneDhikr100 => '100 dhikr completed';

  @override
  String get journeyMilestonePrayerWeek => 'First week of prayer consistency';

  @override
  String get journeyMilestoneLearningStreak => 'First learning streak achieved';

  @override
  String get journeyUnlocksSectionTitle => 'Unlocks';

  @override
  String get journeyUnlocksSectionSubtitle =>
      'Previews of rewards tied to consistency.';

  @override
  String get journeyUnlockWallpaper => 'Wallpaper unlock preview';

  @override
  String get journeyUnlockReflection => 'Reflection unlock preview';

  @override
  String get journeyUnlockTheme => 'Theme reward preview';

  @override
  String get journeyUnlockFuture => 'Future reward placeholder';

  @override
  String get journeyGrowthSectionTitle =>
      'Garden / Tree / Character Progression';

  @override
  String get journeyGrowthSectionSubtitle =>
      'A visual reflection of long-term spiritual growth.';

  @override
  String get journeyGrowthCardTitle => 'Growth Visual Preview';

  @override
  String get journeyGrowthCardSubtitle =>
      'Your tree, garden, and character progression will evolve as your habits mature.';

  @override
  String get journeyOceanSectionTitle => 'Ocean of Drops';

  @override
  String get journeyOceanSectionSubtitle =>
      'A symbolic collective view of accumulated drops.';

  @override
  String get journeyOceanCardTitle => 'Community-inspired Drops';

  @override
  String get journeyOceanCardSubtitle =>
      'Every drop matters. Over time, small drops become a meaningful ocean.';

  @override
  String get quranExplorerTitle => 'Surah Explorer';

  @override
  String get quranExplorerSubtitle =>
      'Browse surahs and open your reading flow.';

  @override
  String get quranSearchTitle => 'Quran Search';

  @override
  String get quranSearchSubtitle => 'Find surahs and verses quickly.';

  @override
  String get quranSearchHint => 'Search by surah, number, or phrase';

  @override
  String get quranAyahsLabel => 'ayahs';

  @override
  String get quranBookmarksPageSubtitle =>
      'Saved ayah locations from your reading.';

  @override
  String get quranBookmarksEmpty =>
      'No bookmarks yet. Save an ayah from the reader.';

  @override
  String get quranUnknownSurah => 'Unknown surah';

  @override
  String get quranRemoveBookmark => 'Remove bookmark';

  @override
  String get quranNotesTitle => 'Quran Notes';

  @override
  String get quranNotesSubtitle => 'Your saved reflections and highlights.';

  @override
  String get quranNotesEmpty => 'No notes yet. Add one from the reader.';

  @override
  String get quranDeleteNote => 'Delete note';

  @override
  String get quranOpenInReader => 'Open in reader';

  @override
  String get quranRecentSearches => 'Recent searches';

  @override
  String get quranSearchNoRecent => 'No recent searches yet.';

  @override
  String get quranClearRecent => 'Clear recent';

  @override
  String get quranSearchNoResults =>
      'No matches found. Try a different keyword.';

  @override
  String get salahCurrentPrayerBadge => 'Current prayer';

  @override
  String get salahNextPrayerBadge => 'Next prayer';

  @override
  String get salahNotificationOff => 'Off';

  @override
  String get worshipPrayerNextPrefix => 'بل';

  @override
  String get worshipPrayerUpcomingPrefix => 'راتلونکی';

  @override
  String get salahDailyGuideNote =>
      'Use this as a practical daily guide. Protect the fard first, then build sunnah, nafl, and witr with consistency.';

  @override
  String get salahQadaRuleTitle => 'Qada rule';

  @override
  String get salahCloseAction => 'Close';

  @override
  String salahTrackedProgress(String tracked, String total) {
    return '$tracked of $total salah tracked';
  }

  @override
  String get salahReflectionHeaderTitle => 'Qur’anic reflection for salah';

  @override
  String get salahReflectionHeaderNote =>
      'Pinned as the spiritual header for this section.';

  @override
  String get salahOpenInQuranAction => 'Open in Quran';

  @override
  String get salahTrackSalahTitle => 'Track Salah';

  @override
  String get salahQuickActionsTitle => 'Quick actions';

  @override
  String get salahQuickTrackOnTime => 'On time';

  @override
  String get salahQuickTrackLate => 'Late';

  @override
  String get salahQuickTrackQada => 'Qada';

  @override
  String get salahMoreOptionsAction => 'More options';

  @override
  String get salahTrackAction => 'Track';

  @override
  String get salahStatusTitle => 'Salah status';

  @override
  String get salahHowOfferedTitle => 'How was it offered?';

  @override
  String get salahWhereOfferedTitle => 'Where was it offered?';

  @override
  String get salahOptionalNotesLabel => 'Optional notes';

  @override
  String get salahOptionalNotesHint => 'Travelling, work, jama\'ah...';

  @override
  String get quranReaderSubtitle => 'Read and reflect verse by verse.';

  @override
  String get quranTranslationLabel => 'Translation';

  @override
  String get quranUpdatedContinueReading => 'Continue reading was updated.';

  @override
  String get quranAddNote => 'Add note';

  @override
  String get quranNoteHint => 'Write a short reflection';

  @override
  String get quranCancel => 'Cancel';

  @override
  String get quranSave => 'Save';

  @override
  String get quranBookmark => 'Bookmark';

  @override
  String get quranSetContinueReading => 'Set as continue reading';

  @override
  String get quranTapToResume => 'Tap to resume';

  @override
  String get quranSavedLocations => 'saved locations';

  @override
  String get quranNotesHighlightsTitle => 'Notes and Highlights';

  @override
  String get quranSavedNotes => 'saved notes';

  @override
  String get quranConsistencyNote => 'Consistency in reading';

  @override
  String get modeRamadanHomeTitle => 'Ramadan Focus';

  @override
  String get modeRamadanHomeSubtitle =>
      'Center today on fasting, Quran, and gentle reflection.';

  @override
  String get modeRamadanActionFasting => 'Fasting';

  @override
  String get modeRamadanActionQuran => 'Quran';

  @override
  String get modeRamadanActionReflect => 'Reflect';

  @override
  String get modeLossHomeTitle => 'Loss Support';

  @override
  String get modeLossHomeSubtitle =>
      'Move softly today with remembrance, patience, and mercy.';

  @override
  String get modeLossActionDhikr => 'Dhikr';

  @override
  String get modeLossActionKhusu => 'Khusu';

  @override
  String get modeLossActionMercy => 'Mercy Verses';

  @override
  String get modeGentleHomeTitle => 'Gentle Mode Active';

  @override
  String get modeGentleHomeSubtitle =>
      'Keep one sincere step at a time and avoid pressure.';

  @override
  String get modeGentleActionOneStep => 'One Step';

  @override
  String get modeGentleActionReflect => 'Reflection';

  @override
  String get modeRamadanWorshipTitle => 'Ramadan Worship Focus';

  @override
  String get modeRamadanWorshipSubtitle =>
      'Fasting and nightly worship are highlighted for this season.';

  @override
  String get modeRamadanWorshipTaraweeh => 'Taraweeh';

  @override
  String get modeRamadanWorshipQiyam => 'Qiyam';

  @override
  String get modeLossWorshipSubtitle =>
      'Focus on simple remembrance and compassionate consistency.';

  @override
  String get modeGentleWorshipSubtitle =>
      'Keep worship steady and light, with mercy toward yourself.';

  @override
  String get modeRamadanLearnTitle => 'Ramadan Learning';

  @override
  String get modeRamadanLearnSubtitle =>
      'Prioritize Quran recitation and short reflection sessions.';

  @override
  String get modeLossLearnTitle => 'Supportive Learning';

  @override
  String get modeLossLearnSubtitle =>
      'Choose healing reminders, mercy verses, and soft reflection.';

  @override
  String get modeGentleLearnTitle => 'Gentle Learning';

  @override
  String get modeGentleLearnSubtitle =>
      'Keep learning concise and consistent without overload.';

  @override
  String get modeRamadanJourneyTitle => 'Ramadan Season Progress';

  @override
  String get modeRamadanJourneySubtitle =>
      'Track intention, fasting rhythm, and nightly consistency.';

  @override
  String get modeLossJourneyTitle => 'Compassionate Journey';

  @override
  String get modeLossJourneySubtitle =>
      'Growth is measured gently through patience and remembrance.';

  @override
  String get modeGentleJourneyTitle => 'Gentle Journey';

  @override
  String get modeGentleJourneySubtitle =>
      'Reduce pressure and focus on calm consistency.';

  @override
  String get profileRamadanDateRangeTitle => 'Ramadan date range';

  @override
  String get profileRamadanStartDate => 'Start date';

  @override
  String get profileRamadanEndDate => 'End date';

  @override
  String get profileRamadanDateWindowActive =>
      'Today falls inside your Ramadan date window.';

  @override
  String get profileRamadanDateWindowInactive =>
      'Today is outside your Ramadan date window.';

  @override
  String get profileRamadanSetDates => 'Set dates';

  @override
  String get profileRamadanClearDates => 'Clear dates';

  @override
  String get learnContentTopicLabel => 'Topic';

  @override
  String get learnContentUnavailableSubtitle =>
      'This topic is not available yet.';

  @override
  String get learnContentNotFound => 'Content not found.';

  @override
  String get learnContentOverviewTitle => 'Overview';

  @override
  String get learnContentThemesTitle => 'Key themes';

  @override
  String get learnContentReferencesTitle => 'Related references';

  @override
  String get learnContentReflectionPromptTitle => 'Reflection prompt';

  @override
  String get learnContentRelatedTopicsTitle => 'Related topics';

  @override
  String get learnContentContinueTitle => 'Continue learning';

  @override
  String get learnContentPathComplete =>
      'You reached the end of this staged path.';

  @override
  String get learnContentPathContinue => 'Continue to the next related topic.';

  @override
  String get lifeProgressOverviewTitle => 'Life curriculum progress';

  @override
  String lifeProgressOverviewBody(int completed, int total, int inProgress) {
    return '$completed completed of $total lessons, with $inProgress in progress.';
  }

  @override
  String get lifeContinueLearningTitle => 'Continue learning';

  @override
  String get lifeFeaturedLessonTitle => 'Featured lesson';

  @override
  String get lifeSuggestedNextLessonTitle => 'Suggested next lesson';

  @override
  String get lifeSuggestedPathTitle => 'Suggested learning path';

  @override
  String get lifeBrowseByThemeTitle => 'Browse by theme';

  @override
  String get lifeRecentOpenedTitle => 'Recently opened';

  @override
  String get lifeThemeLabel => 'Major theme';

  @override
  String get lifeSubcategoryLabel => 'Subcategory';

  @override
  String get lifeQuranicPerspectiveTitle => 'Qur\'anic perspective';

  @override
  String get lifePracticalTakeawayTitle => 'Practical life takeaway';

  @override
  String get lifeComparativeTeachingsTitle =>
      'Related teachings in other traditions';

  @override
  String get lifeMarkInProgress => 'Mark in progress';

  @override
  String get lifeMarkCompleted => 'Mark completed';

  @override
  String get lifeAddReflectionTitle => 'Add a reflection';

  @override
  String get lifeAddReflectionSubtitle =>
      'Capture what stood out to you from this lesson.';

  @override
  String get lifeStatusNotStarted => 'Status: not started';

  @override
  String get lifeStatusInProgress => 'Status: in progress';

  @override
  String get lifeStatusCompleted => 'Status: completed';

  @override
  String lifeSubcategoryProgress(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get lifeLessonsTitle => 'Lessons';

  @override
  String get lifeThemeWhyMattersTitle => 'Why this theme matters';

  @override
  String lifeThemeProgress(int completed, int total) {
    return '$completed of $total lessons completed in this theme';
  }

  @override
  String get lifeThemeNextSubcategoryTitle => 'Recommended next subcategory';

  @override
  String get lifeSubcategoriesTitle => 'Subcategories';

  @override
  String get worldProgressOverviewTitle => 'World curriculum progress';

  @override
  String worldProgressOverviewBody(int completed, int total, int inProgress) {
    return '$completed completed of $total lessons, with $inProgress in progress.';
  }

  @override
  String get worldContinueLearningTitle => 'Continue learning';

  @override
  String get worldFeaturedLessonTitle => 'Featured lesson';

  @override
  String get worldSuggestedNextLessonTitle => 'Suggested next lesson';

  @override
  String get worldSuggestedPathTitle => 'Suggested learning path';

  @override
  String get worldBrowseByThemeTitle => 'Browse by theme';

  @override
  String get worldRecentOpenedTitle => 'Recently opened';

  @override
  String get worldThemeLabel => 'Major theme';

  @override
  String get worldSubcategoryLabel => 'Subcategory';

  @override
  String get worldQuranicPerspectiveTitle => 'Qur\'anic perspective';

  @override
  String get worldReflectiveTakeawayTitle => 'Reflective takeaway';

  @override
  String get worldPracticalTakeawayTitle => 'Practical takeaway';

  @override
  String get worldObservationPromptTitle => 'Observation prompt';

  @override
  String get worldComparativeTeachingsTitle =>
      'Related teachings in other traditions';

  @override
  String get worldMarkInProgress => 'Mark in progress';

  @override
  String get worldMarkCompleted => 'Mark completed';

  @override
  String get worldAddReflectionTitle => 'Add a reflection';

  @override
  String get worldAddReflectionSubtitle =>
      'Capture what this sign in creation stirred in you.';

  @override
  String get worldObservationCtaTitle => 'Record an observation';

  @override
  String get worldObservationCtaSubtitle =>
      'Create a journal entry with optional photo reference.';

  @override
  String get worldStatusNotStarted => 'Status: not started';

  @override
  String get worldStatusInProgress => 'Status: in progress';

  @override
  String get worldStatusCompleted => 'Status: completed';

  @override
  String worldSubcategoryProgress(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get worldLessonsTitle => 'Lessons';

  @override
  String get worldThemeWhyMattersTitle => 'Why this theme matters';

  @override
  String worldThemeProgress(int completed, int total) {
    return '$completed of $total lessons completed in this theme';
  }

  @override
  String get worldThemeNextSubcategoryTitle => 'Recommended next subcategory';

  @override
  String get worldSubcategoriesTitle => 'Subcategories';

  @override
  String get quranTranslationSahih => 'Sahih International';

  @override
  String get quranTranslationPickthallPlaceholder => 'Pickthall (placeholder)';

  @override
  String get quranTranslationClearQuran => 'The Clear Quran';

  @override
  String get quranTranslationUrdu => 'Urdu Translation';

  @override
  String get quranTranslationBengali => 'Bengali Translation';

  @override
  String get quranTranslationIndonesian => 'Indonesian Translation';

  @override
  String get quranTranslationTurkish => 'Turkish Translation';

  @override
  String get quranTranslationDari => 'Dari Translation';

  @override
  String get quranShowTransliteration => 'Transliteration';

  @override
  String get quranShowTranslation => 'Translation text';

  @override
  String get quranWordTranslationChip => 'Word by Word Translation';

  @override
  String get quranWordTranslationBetaTitle => 'Word by Word Translation (Beta)';

  @override
  String get quranWordTranslationBetaSubtitle =>
      'This feature is currently in Beta and may still be refined.';

  @override
  String get quranAudioV2Title => 'Audio v2';

  @override
  String get quranRepeatFromLabel => 'Repeat from';

  @override
  String get quranRepeatToLabel => 'Repeat to';

  @override
  String get quranNoneLabel => 'None';

  @override
  String quranAyahNumberLabel(int ayah) {
    return 'Ayah $ayah';
  }

  @override
  String get quranLoopCountLabel => 'Loop count';

  @override
  String get quranPlayLoopLabel => 'Play loop';

  @override
  String get quranLoopRangeHint =>
      'Set both range edges to enable loop playback.';

  @override
  String get quranMemorizationTitle => 'Memorization (Hifz)';

  @override
  String get quranHifzRevealModeFull => 'Reveal';

  @override
  String get quranHifzRevealModeFirstWord => 'First word';

  @override
  String get quranHifzRevealModeHidden => 'Hide';

  @override
  String quranDailyRevisionPlanLabel(int count) {
    return 'Daily revision plan ($count ayahs)';
  }

  @override
  String get quranDailyRevisionEmpty =>
      'No checkpoints yet. Add one while reviewing ayahs.';

  @override
  String quranOpenReviewDeckLabel(int count) {
    return 'Open review deck ($count)';
  }

  @override
  String get quranPinForReviewLabel => 'Pin for review';

  @override
  String get quranUnpinWordLabel => 'Unpin word';

  @override
  String get quranPlayAyahTooltip => 'Play ayah';

  @override
  String get quranHifzCheckpointTooltip => 'Hifz checkpoint';

  @override
  String get quranNotesFoldersTagsTitle => 'Folders and tags';

  @override
  String get quranNotesFolderLabel => 'Folder';

  @override
  String get quranNotesTagLabel => 'Tag';

  @override
  String get quranNotesFolderHint => 'General';

  @override
  String get quranNotesFolderDefault => 'General';

  @override
  String get quranNotesTagsLabel => 'Tags';

  @override
  String get quranNotesTagsHint => 'gratitude, dua, patience';

  @override
  String get quranSaveAsHighlightLabel => 'Save as highlight';

  @override
  String get quranHighlightLabelInput => 'Highlight label';

  @override
  String get quranHighlightHint => 'Key reminder';

  @override
  String get quranHighlightLabel => 'Highlight';

  @override
  String get quranUnknownDateLabel => 'Unknown date';

  @override
  String get quranTopWordsTitle => 'Quran Top Words';

  @override
  String get quranTopWordsSubtitle =>
      'Study frequent Quran vocabulary with transliteration and meaning.';

  @override
  String get quranWordReviewTitle => 'Word Review Deck';

  @override
  String get quranWordReviewSubtitle =>
      'Pin words from reader word-by-word mode to study here.';

  @override
  String get quranWordReviewEmpty =>
      'No pinned words yet. Open any ayah, tap a word, and pin it first.';

  @override
  String quranWordReviewProgressLabel(int current, int total) {
    return '$current of $total pinned words';
  }

  @override
  String get quranWordReviewRevealHint =>
      'Tap reveal to check transliteration and meaning.';

  @override
  String get quranWordReviewHide => 'Hide';

  @override
  String get quranWordReviewReveal => 'Reveal';

  @override
  String get quranWordReviewAgain => 'Again';

  @override
  String get quranWordReviewEasy => 'Easy';

  @override
  String quranWordReviewHubSubtitle(int count) {
    return '$count pinned words • review and strengthen recall.';
  }

  @override
  String get quranNamesOfAllahTitle => '99 Names of الله';

  @override
  String get quranNamesOfAllahSubtitle =>
      'Learn each name in Arabic with transliteration and meaning.';

  @override
  String get quranCleanReadingMode => 'Clean mode';

  @override
  String get quranArabicTextSize => 'Arabic size';

  @override
  String get quranTranslationTextSize => 'Translation size';

  @override
  String get oceanTitle => 'Ocean of Drops';

  @override
  String get oceanSubtitle =>
      'Your local drops and symbolic contribution journey.';

  @override
  String get oceanLocalDropsLabel => 'Local drops';

  @override
  String get oceanTodayDropsLabel => 'Drops today';

  @override
  String get oceanWeekDropsLabel => 'Drops this week';

  @override
  String get oceanSourcesTitle => 'Drop sources';

  @override
  String get oceanNoSourceData =>
      'No source data yet. Complete daily actions to add drops.';

  @override
  String get oceanSourcePrayer => 'Prayer completion';

  @override
  String get oceanSourceDhikr => 'Dhikr sessions';

  @override
  String get oceanSourceFasting => 'Fasting completion';

  @override
  String get oceanSourceQuran => 'Qur\'an engagement';

  @override
  String get oceanSourceReflection => 'Reflection / journal';

  @override
  String get oceanSourceLearning => 'Learning engagement';

  @override
  String get oceanSourceMilestone => 'Milestone / unlock';

  @override
  String get oceanOpenPage => 'Open Ocean';

  @override
  String oceanCommunityPlaceholder(int count) {
    return 'Community ocean placeholder: $count drops';
  }

  @override
  String get wallpaperLibraryTitle => 'Wallpaper Library';

  @override
  String get wallpaperLibrarySubtitle =>
      'Unlock and select wallpapers through growth.';

  @override
  String get wallpaperSelected => 'Selected';

  @override
  String get wallpaperApply => 'Apply';

  @override
  String get kidsModeTitle => 'Kids Mode';

  @override
  String get kidsModeSubtitle =>
      'Simpler wording and gentler guidance for younger users.';

  @override
  String get kidsHomeHint =>
      'Kids mode is active with simpler guidance and gentle next steps.';

  @override
  String get kidsHomeReflectionHint =>
      '\"Small kind actions shine brightly. What is one good thing from today?\"';

  @override
  String get kidsWorshipHint =>
      'Kids mode: focus on simple steps and calm consistency.';

  @override
  String get kidsLearnHint =>
      'Kids mode: explore stories and short lessons one at a time.';

  @override
  String get kidsJourneyHint =>
      'Kids mode: your journey grows with every sincere step.';

  @override
  String get kidsHomeQuickLearning => 'Let\'s learn';

  @override
  String get kidsHomeQuickJournal => 'Write it down';

  @override
  String get kidsHomeQuickPrayer => 'Prayer path';

  @override
  String get kidsHomeQuickDhikr => 'Remember Allah';

  @override
  String get kidsHomeShortcutSalahLabel => 'Prayer check';

  @override
  String get kidsHomeShortcutDhikrLabel => 'Dhikr count';

  @override
  String get kidsHomeShortcutDailyCaption => 'Today\'s goal';

  @override
  String kidsHomeShortcutMissedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prayers need care',
      one: '1 prayer needs care',
    );
    return '$_temp0';
  }

  @override
  String get kidsHomeShortcutDailyDhikrGoalReached =>
      'Great job - today\'s dhikr goal is done.';

  @override
  String get kidsHomeShortcutOpen => 'Show tools';

  @override
  String get kidsHomeShortcutClose => 'Hide tools';

  @override
  String kidsHomeBadgeEarnedCount(String count) {
    return 'Earned $count times';
  }

  @override
  String get kidsHomeBadgeEarnedToday => 'You earned this today!';

  @override
  String get kidsDhikrTargetReachedMessage =>
      'Amazing work! You reached your dhikr goal.';

  @override
  String get kidsDhikrUndoOneTooltip => 'Undo one count';

  @override
  String get kidsDhikrAddManuallyAction => 'Add some';

  @override
  String get kidsDhikrResetAction => 'Start over';

  @override
  String get kidsDhikrFinishSessionAction => 'All done';

  @override
  String get kidsDhikrDailyGoalTitle => 'Today\'s dhikr goal';

  @override
  String get kidsDhikrDailyGoalSubtitle =>
      'Every remembrance counts. Keep going with a calm heart.';

  @override
  String get kidsWorshipTabPrayer => 'Prayer';

  @override
  String get kidsWorshipTabDhikr => 'Dhikr';

  @override
  String get kidsWorshipTabFasting => 'Fasting';

  @override
  String get kidsWorshipTabKhusu => 'Calm focus';

  @override
  String get kidsJourneyHomeCompletedBadge => 'Great job';

  @override
  String get kidsJourneyHomeContinueBadge => 'Keep going';

  @override
  String get kidsJourneyHomeExploreNextAction => 'See what\'s next';

  @override
  String get kidsJourneyHomeContinueAction => 'Keep going';

  @override
  String get kidsJourneyHomeStartFirstJourneyTitle =>
      'Let\'s begin your journey';

  @override
  String get kidsJourneyHomeStartFirstJourneySubtitle =>
      'Start with one short step and grow from there.';

  @override
  String get kidsJourneyHomeExploreJourneys => 'Start journey';

  @override
  String kidsJourneyHomeStreakMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Great job - $count days in a row.',
      one: 'Great job - 1 day in a row.',
    );
    return '$_temp0';
  }

  @override
  String get kidsJourneyDetailProgressTitle => 'Your journey';

  @override
  String get kidsJourneyFeedbackFirstStageOpened =>
      'You opened a new step. Take your time and enjoy it.';

  @override
  String get kidsJourneyLessonSectionIntroduction => 'Let\'s begin';

  @override
  String get kidsJourneyLessonActionOpenDhikrCounter => 'Open dhikr';

  @override
  String get kidsJourneyLessonActionCompleted => 'Great job';

  @override
  String get kidsJourneyLessonActionNextLesson => 'Next step';

  @override
  String get kidsJourneyLessonActionMarkComplete => 'I did this';

  @override
  String get kidsJourneyLessonActionReturnToJourney => 'Back to journey';

  @override
  String get kidsJourneyPlaceholderLearnLabel => 'Let\'s learn';

  @override
  String get kidsJourneyPlaceholderActionCompleted => 'Great job';

  @override
  String get kidsJourneyPlaceholderActionMarkComplete => 'I did this';

  @override
  String get assistantTitle => 'Nur Assistant';

  @override
  String get assistantSubtitle =>
      'A calm companion for guidance, reflection, and app navigation.';

  @override
  String get assistantEmptyState =>
      'Ask for a focus suggestion, reflection prompt, or where to go next.';

  @override
  String get assistantInputHint => 'Type your message';

  @override
  String get circlesTitle => 'Community Circles';

  @override
  String get circlesSubtitle =>
      'Discover circles for learning, reflection, and shared growth.';

  @override
  String get circlesNotFound => 'Circle not found.';

  @override
  String get circlesJoin => 'Join';

  @override
  String get circlesLeave => 'Leave';

  @override
  String get circlesGuidance =>
      'Keep interactions respectful, gentle, and centered on beneficial growth.';

  @override
  String circlesJoinedCount(int count) {
    return 'Joined circles: $count';
  }

  @override
  String circlesMembers(int count) {
    return 'Members: $count';
  }

  @override
  String get journalTitle => 'Journal & Timeline';

  @override
  String get journalSubtitle =>
      'Record reflections, observations, and memory moments.';

  @override
  String get journalTimelineIntro =>
      'Capture intentional memories and revisit meaningful moments over time.';

  @override
  String get journalCreateAction => 'New entry';

  @override
  String get journalMemoryResurfaceTitle => 'This time last year';

  @override
  String get journalEmptyState =>
      'No entries yet. Start your first reflection.';

  @override
  String get journalUntitled => 'Untitled entry';

  @override
  String get journalPhotoAttached => 'Photo reference attached';

  @override
  String get journalCreateTitle => 'Create Journal Entry';

  @override
  String get journalCreateSubtitle =>
      'Write a reflection, observation, or gratitude note.';

  @override
  String get journalTitleField => 'Title (optional)';

  @override
  String get journalBodyField => 'Reflection';

  @override
  String get journalTypeField => 'Entry type';

  @override
  String get journalPhotoReferenceField => 'Photo reference (optional)';

  @override
  String get journalPhotoReferenceHelper =>
      'For now, add a local path or short photo note.';

  @override
  String get journalTypeReflection => 'Reflection';

  @override
  String get journalTypeGratitude => 'Gratitude';

  @override
  String get journalTypeObservation => 'Observation';

  @override
  String get journalTypeLearning => 'Learning';

  @override
  String get journalTypeMemory => 'Memory';

  @override
  String get learnContentModeFocusTitle => 'Mode focus';

  @override
  String get learnContentReflectionIdeasTitle => 'Reflection ideas';

  @override
  String get learnContentProgressTitle => 'Progress tracking';

  @override
  String get learnContentMarkComplete => 'Mark complete';

  @override
  String get learnContentMarkIncomplete => 'Mark incomplete';

  @override
  String get learnContentSave => 'Save topic';

  @override
  String get learnContentSaved => 'Saved';

  @override
  String get learnContentFavorite => 'Favorite topic';

  @override
  String get learnContentFavorited => 'Favorited';

  @override
  String learnContentReflectionProgress(int percent) {
    return 'Reflection $percent%';
  }

  @override
  String learnProgressSummary(int started, int completed, int favorite) {
    return 'Started: $started  Completed: $completed  Favorites: $favorite';
  }

  @override
  String get learnProgressCardTitle => 'Learning progress';

  @override
  String learnProgressCardSubtitle(int started, int completed, int favorite) {
    return 'Started $started, completed $completed, favorites $favorite';
  }

  @override
  String get learnResumeTopicTitle => 'Resume topic';

  @override
  String get learnResumeTopicSubtitleEmpty =>
      'Start with any topic and continue steadily.';

  @override
  String learnResumeTopicSubtitle(String topicId) {
    return 'Continue: $topicId';
  }

  @override
  String get learnContentFavoritesTitle => 'Favorite topics';

  @override
  String learnContentFavoritesSubtitle(int count) {
    return '$count favorited topics';
  }

  @override
  String get journalSearchLabel => 'Search journal';

  @override
  String get journalFilterAll => 'All';

  @override
  String get journalFilterFavorites => 'Favorites';

  @override
  String get journalLinkedTopicLabel => 'Linked topic (optional)';

  @override
  String get journalLinkedQuranLabel => 'Linked Qur\'an reference (optional)';

  @override
  String get journalLinkedHadithLabel => 'Linked Hadith reference (optional)';

  @override
  String get journalTagsLabel => 'Tags (comma separated)';

  @override
  String get journalTagsHelper => 'Example: moon, patience, family';

  @override
  String get assistantQuickPromptsTitle => 'Suggestions';

  @override
  String get assistantRecentPromptsTitle => 'Recent prompts';

  @override
  String get assistantQuickActionsTitle => 'Quick actions';

  @override
  String get circlesJoinedPageTitle => 'Joined circles';

  @override
  String get circlesJoinedPageSubtitle =>
      'Your active and saved circles in one place.';

  @override
  String get circlesJoinedEmpty => 'You have not joined any circles yet.';

  @override
  String get circlesSavedTitle => 'Saved circles';

  @override
  String get circlesRecommendedTitle => 'Recommended circles';

  @override
  String get circlesActivityPreviewTitle => 'Activity preview';

  @override
  String get circlesEventsTitle => 'Upcoming events';

  @override
  String get oceanHistoryTitle => 'Recent drop history';

  @override
  String oceanStageLabel(String stage) {
    return 'Stage: $stage';
  }

  @override
  String oceanNextMilestone(int count) {
    return 'Next milestone: $count drops';
  }

  @override
  String get oceanStageSpring => 'Spring';

  @override
  String get oceanStageStream => 'Stream';

  @override
  String get oceanStageFlowing => 'Flowing';

  @override
  String get oceanStageRising => 'Rising Tide';

  @override
  String get oceanStageVast => 'Vast Ocean';

  @override
  String wallpaperRewardSummary(int unlocked, int total, String hint) {
    return 'Unlocked $unlocked/$total. Next: $hint';
  }

  @override
  String get journeyRewardSummaryTitle => 'Rewards and learning';

  @override
  String journeyRewardSummaryBody(int unlocked, int total) {
    return '$unlocked wallpapers unlocked out of $total.';
  }

  @override
  String journeyLearnSummaryBody(int completed, int started) {
    return '$completed completed learn topics from $started started.';
  }

  @override
  String get journeyGraceTokenTitle => 'Streak protection';

  @override
  String journeyGraceTokenBody(
    int remaining,
    int allowance,
    int protectedDays,
  ) {
    return '$remaining/$allowance grace tokens left this month. Protected days this week: $protectedDays.';
  }

  @override
  String get journeyMonthlyBadgesTitle => 'Monthly badges';

  @override
  String get journeyMonthlyBadgesSubtitle =>
      'Tiered consistency challenges with unlock effects.';

  @override
  String journeyBadgeTier(String tier, int current, int target) {
    return '$tier • $current/$target';
  }

  @override
  String get journeyTierStarting => 'Starting';

  @override
  String get journeyTierBronze => 'Bronze';

  @override
  String get journeyTierSilver => 'Silver';

  @override
  String get journeyTierGold => 'Gold';

  @override
  String get journeyTierPlatinum => 'Platinum';

  @override
  String get journeyWeeklyReflectionTitle => 'Weekly reflection review';

  @override
  String journeyWeeklyReflectionStats(
    int worship,
    int learning,
    int journal,
    int favorites,
  ) {
    return 'Worship actions: $worship. Learning completions: $learning. Journal entries: $journal. Favorites: $favorites.';
  }

  @override
  String journeyWeeklyReflectionTags(String tags) {
    return 'Top themes: $tags';
  }

  @override
  String get journeyWeeklyHighlightWorship =>
      'This week leaned into steady worship and presence.';

  @override
  String get journeyWeeklyHighlightLearning =>
      'This week showed clear learning growth.';

  @override
  String get journeyWeeklyHighlightReflection =>
      'This week held meaningful reflection moments.';

  @override
  String get journeyWeeklyHighlightSmallSteps =>
      'Small steps were present this week; keep building gently.';

  @override
  String get oceanProgressionMapTitle => 'Progression map';

  @override
  String oceanTimelineSources(int count) {
    return '$count active sources';
  }

  @override
  String get oceanRecentDaysLabel => 'Recent day snapshots';

  @override
  String get wallpaperStoryCardsTitle => 'Unlock stories';

  @override
  String wallpaperStoryHint(String hint) {
    return 'Path: $hint';
  }

  @override
  String wallpaperStoryProgress(
    int requiredLevel,
    int currentLevel,
    int requiredTopics,
    int currentTopics,
  ) {
    return 'Level $requiredLevel required • current level $currentLevel. Learn target $requiredTopics • current $currentTopics.';
  }

  @override
  String wallpaperStoryMilestone(String milestone) {
    return 'Milestone link: $milestone';
  }

  @override
  String get homeEcosystemSummaryTitle => 'Growth ecosystem';

  @override
  String get homeEcosystemSummarySubtitle =>
      'Ocean, rewards, circles, journal, and assistant previews.';

  @override
  String get learnTrackSelectorTitle => 'وړاندیز شوی د زده کړې لاره';

  @override
  String get learnBundleManagerTitle => 'د آفلاین منځپانګې بنډلونه';

  @override
  String get learnBundleManagerSubtitle =>
      'پړاويز بنډلونه همدا اوس نصب کړئ. جوړښت د راتلونکي لیرې همغږي لپاره چمتو دی.';

  @override
  String get learnTrackBeginner => 'پیل کوونکی';

  @override
  String get learnTrackFamily => 'کورنۍ';

  @override
  String get learnTrackCharacter => 'اخلاق';

  @override
  String get learnTrackRamadan => 'رمضان';

  @override
  String get learnTrackRevert => 'نوی مسلمان';

  @override
  String get learnCitationPanelTitle => 'سرچينې او د باور يادښتونه';

  @override
  String get learnCompletionQualityTitle => 'د بشپړولو کیفیت';

  @override
  String get learnQualityNotRead => 'لا نه دی لوستل شوی';

  @override
  String get learnQualityRead => 'لوستل شوی';

  @override
  String get learnQualityReflected => 'پرې تأمل شوی';

  @override
  String get learnQualityApplied => 'عملي شوی';

  @override
  String learnQualityLabel(Object quality) {
    return 'کیفیت: $quality';
  }

  @override
  String learnContinueReasonWithTrack(Object track) {
    return 'دا ستاسو د $track لارې لپاره د نوښت او نیت پر بنسټ درجه بندي شوی دی.';
  }

  @override
  String get circlesV2HubSubtitle =>
      'Community forum + mosque buddy spaces are local-first and respectful.';

  @override
  String get circlesEventsCalendarTitle => 'Events calendar';

  @override
  String get circlesEventsCalendarSubtitle =>
      'Upcoming local events with RSVP tracking.';

  @override
  String get circlesMosqueBuddyPrefsTitle => 'Mosque Buddy';

  @override
  String get circlesMosqueBuddyPrefsSubtitle =>
      'Set distance, prayer habits, interests, and availability windows.';

  @override
  String get circlesModerationTitle => 'Moderation & Safety';

  @override
  String get circlesModerationSubtitle =>
      'Reporting, trust level, and content policy surfaces.';

  @override
  String get circlesAccountabilityTitle => 'Accountability groups';

  @override
  String get circlesAccountabilitySubtitle =>
      'Private support groups for prayer and habit streaks.';

  @override
  String get circlesNearbyMosquesTitle => 'Nearby mosques';

  @override
  String get circlesNearbyMosquesSubtitle =>
      'Import local prayer timetables and keep one selected.';

  @override
  String get circlesOpen => 'Open';

  @override
  String get circlesRsvpGoing => 'Going';

  @override
  String get circlesRsvpInterested => 'Interested';

  @override
  String get circlesRsvpNotGoing => 'Not going';

  @override
  String get circlesNoEvents => 'No upcoming events right now.';

  @override
  String get circlesBuddyDistance => 'Max distance';

  @override
  String get circlesBuddyPrayerConsistency => 'Prayer habits';

  @override
  String get circlesBuddyInterests => 'Interests';

  @override
  String get circlesBuddyAvailability => 'Availability windows';

  @override
  String get circlesBuddyMatchesTitle => 'Suggested buddies';

  @override
  String get circlesNoMatches =>
      'No close matches yet. Adjust your preferences.';

  @override
  String get circlesTrustLevelTitle => 'Trust level';

  @override
  String get circlesPolicyTitle => 'Community policy';

  @override
  String get circlesPolicyBody =>
      'Respectful conduct, verified meetups, no harassment, and no harmful/offensive content. Report concerns early.';

  @override
  String get circlesReportLogTitle => 'Report log';

  @override
  String get circlesReportLogEmpty => 'No reports submitted yet.';

  @override
  String get circlesTrustLevelLow => 'New member';

  @override
  String get circlesTrustLevelMedium => 'Trusted';

  @override
  String get circlesTrustLevelHigh => 'Steward';

  @override
  String get circlesReport => 'Report';

  @override
  String get circlesReportSubmitted =>
      'Report submitted for moderation review.';

  @override
  String get circlesAccountabilityCheckIn => 'Check in';

  @override
  String get circlesAccountabilityJoined => 'Joined';

  @override
  String get circlesAccountabilityStreak => 'Check-in streak';

  @override
  String get circlesImportTimetable => 'Import timetable';

  @override
  String get circlesImported => 'Imported';

  @override
  String get circlesMosqueSelected => 'Selected mosque timetable';

  @override
  String get circlesCityLabel => 'City';

  @override
  String get circlesFocusLabel => 'Focus';

  @override
  String get circlesMosqueBuddyActive => 'Mosque buddy active';

  @override
  String get circlesMosqueBuddyFind => 'Find mosque buddy';

  @override
  String circlesEventCapacity(
    Object going,
    Object capacity,
    Object interested,
  ) {
    return 'Going $going/$capacity • Interested $interested';
  }

  @override
  String get circlesWaitlistActive =>
      'Capacity reached. New Going responses are moved to interested/waitlist.';

  @override
  String get circlesEventFiltersTitle => 'Event filters';

  @override
  String get circlesFilterCircle => 'Circle';

  @override
  String get circlesFilterCategory => 'Category';

  @override
  String get circlesFilterCity => 'City';

  @override
  String get circlesFilterAll => 'All';

  @override
  String get circlesRosterPreviewTitle => 'Roster preview';

  @override
  String circlesRosterGoingPreview(Object names) {
    return 'Going: $names';
  }

  @override
  String circlesRosterInterestedPreview(Object names) {
    return 'Interested: $names';
  }

  @override
  String circlesRosterWaitlistCount(Object count) {
    return 'Waitlist count: $count';
  }

  @override
  String get circlesCreateEvent => 'Create event';

  @override
  String get circlesCreateEventModerationHint =>
      'User-created events are local for now. Future releases can enable mosque moderator approval workflows.';

  @override
  String get circlesCreateEventTitleLabel => 'Event title';

  @override
  String get circlesCreateEventLocationLabel => 'Location';

  @override
  String get circlesCreateEventDescriptionLabel => 'Description';

  @override
  String get circlesCreateEventCreatorLabel => 'Organizer name (optional)';

  @override
  String get circlesCreateEventRoleLabel => 'Creation role';

  @override
  String get circlesCreateEventRoleUser => 'Community member';

  @override
  String get circlesCreateEventRoleModerator => 'Mosque moderator';

  @override
  String circlesCreateEventDateValue(Object date) {
    return 'Date: $date';
  }

  @override
  String circlesCreateEventCapacityLabel(Object count) {
    return 'Capacity: $count';
  }

  @override
  String get circlesCreateEventValidation =>
      'Please fill title, location, and description.';

  @override
  String get circlesCreateEventSubmit => 'Save event';

  @override
  String get circlesCreateEventSuccess =>
      'Event created and added to calendar.';

  @override
  String get circlesCreateEventPendingReview =>
      'Event submitted and pending moderation review.';

  @override
  String get circlesCreatedEventsStatusTitle => 'Submitted events';

  @override
  String circlesCreatedEventsStatusBody(int pending, int rejected) {
    return '$pending pending review • $rejected rejected';
  }

  @override
  String get circlesModeratorCreateReady =>
      'Moderator posting is enabled for your account.';

  @override
  String get circlesModeratorCreatePending =>
      'Moderator posting unlocks after steward trust level and mosque import.';

  @override
  String get circlesPendingEventsTitle => 'Pending event queue';

  @override
  String get circlesPendingEventsEmpty =>
      'No events are waiting for moderation.';

  @override
  String get circlesApproveEvent => 'Approve';

  @override
  String get circlesRejectEvent => 'Reject';

  @override
  String get circlesModerationAccessReady =>
      'You can approve/reject pending events.';

  @override
  String get circlesModerationAccessLimited =>
      'Approval actions unlock at steward trust level.';

  @override
  String get circlesMosqueVerifiedBadge => 'Mosque verified';

  @override
  String circlesEventReportCount(int count) {
    return '$count report(s) linked';
  }

  @override
  String circlesEventApprovedAudit(String name, String date) {
    return 'Approved by $name on $date';
  }

  @override
  String get onboardingDisclaimerBody =>
      'This app is a companion for guidance and consistency. It does not replace local mosque community, scholars, or real-world support.';

  @override
  String get legalPrivacyBody =>
      'Path of Nūr stores your progress and preferences locally by default. You can review and clear settings in Profile at any time.';

  @override
  String get legalTermsBody =>
      'Path of Nūr is a companion app for learning, worship consistency, and reflection. It does not replace qualified scholarship or local community guidance.';

  @override
  String get legalSupportBody =>
      'For support, use in-app feedback channels and local community resources. If something looks incorrect, report it from the relevant page.';

  @override
  String get legalBuildInfoTitle => 'Build information';

  @override
  String legalBuildFlavorLabel(String flavor) {
    return 'Flavor: $flavor';
  }

  @override
  String legalCrashLogCountLabel(int count) {
    return 'Stored crash reports: $count';
  }

  @override
  String get routerNotFoundTitle => 'Route not found';

  @override
  String get learningJourneyLessonSectionIntroduction => 'Introduction';

  @override
  String get learningJourneyLessonSectionArabicMeaning => 'Arabic and meaning';

  @override
  String get learningJourneyLessonSectionTakeaways => 'Key takeaways';

  @override
  String get learningJourneyLessonSectionReflection => 'Reflection prompt';

  @override
  String get learningJourneyLessonSectionReferences => 'References';

  @override
  String get learningJourneyLessonSectionExploreNow => 'Explore now';

  @override
  String get learningJourneyLessonActionOpenDhikrCounter =>
      'Open Dhikr Counter';

  @override
  String get learningJourneyLessonActionCompleted => 'Completed';

  @override
  String get learningJourneyLessonActionMarkComplete => 'Mark as Complete';

  @override
  String get learningJourneyLessonActionNextLesson => 'Next Lesson';

  @override
  String get learningJourneyLessonActionReturnToJourney => 'Return to Journey';

  @override
  String get learningJourneyToolQuranReaderTitle => 'Qur’an Reader';

  @override
  String get learningJourneyToolQuranReaderSubtitle =>
      'Open the reader and continue slowly.';

  @override
  String get learningJourneyToolQuranStudyTitle => 'Qur’an Study';

  @override
  String get learningJourneyToolQuranStudySubtitle =>
      'Use the study hub for connected practice.';

  @override
  String get learningJourneyToolQuranArabicTitle => 'Qur’anic Arabic';

  @override
  String get learningJourneyToolQuranArabicSubtitle =>
      'Return to the Arabic learning path.';

  @override
  String get learningJourneyToolSalahHubTitle => 'Salah Hub';

  @override
  String get learningJourneyToolSalahHubSubtitle =>
      'Reconnect these phrases to worship practice.';

  @override
  String get learningJourneyStageReciteFatihahLessonTitle =>
      'Understanding Al-Fatihah';

  @override
  String get learningJourneyStageReciteFatihahIntro =>
      'Al-Fatihah is the surah you repeat most often in salah. Learning its core meaning turns familiar recitation into conscious worship.';

  @override
  String get learningJourneyStageReciteFatihahSection1Title =>
      'A simple map of the surah';

  @override
  String get learningJourneyStageReciteFatihahSection1Body =>
      'Al-Fatihah begins with praise of Allah, then reminds you that He is Lord, Master of the Day of Judgment, and the One alone you worship and ask for help. It ends as a dua for guidance to the straight path.';

  @override
  String get learningJourneyStageReciteFatihahSection2Title =>
      'How to carry it into prayer';

  @override
  String get learningJourneyStageReciteFatihahSection2Body =>
      'When you recite Al-Fatihah, slow down enough to feel the movement of the surah: praise, dependence, and asking to be guided.';

  @override
  String get learningJourneyStageReciteFatihahSection2Bullet1 =>
      'Praise Allah before asking for anything.';

  @override
  String get learningJourneyStageReciteFatihahSection2Bullet2 =>
      'Remember that worship and help both belong to Him alone.';

  @override
  String get learningJourneyStageReciteFatihahSection2Bullet3 =>
      'Treat the last verses as a living dua for guidance.';

  @override
  String get learningJourneyStageReciteFatihahTakeaway1 =>
      'Al-Fatihah is both praise and dua.';

  @override
  String get learningJourneyStageReciteFatihahTakeaway2 =>
      'Its meaning can make every rak‘ah more attentive.';

  @override
  String get learningJourneyStageReciteFatihahTakeaway3 =>
      'Understanding a little well is better than reciting without thought.';

  @override
  String get learningJourneyStageReciteFatihahReflection =>
      'Which line of Al-Fatihah do you want to recite more consciously in your next prayer?';

  @override
  String get learningJourneyStageReciteFatihahInvocation1Title =>
      'Opening praise';

  @override
  String get learningJourneyStageReciteFatihahInvocation1Meaning =>
      'All praise belongs to Allah, Lord of all worlds.';

  @override
  String get learningJourneyStageReciteFatihahInvocation1Context =>
      'This phrase reminds you that praise comes before requests.';

  @override
  String get learningJourneyStageReciteShortSurahsLessonTitle =>
      'Common Phrases in Salah';

  @override
  String get learningJourneyStageReciteShortSurahsIntro =>
      'Prayer includes short repeated phrases that shape humility, praise, and reverence. Knowing their meaning helps the body and heart move together.';

  @override
  String get learningJourneyStageReciteShortSurahsSection1Title =>
      'What these phrases are doing';

  @override
  String get learningJourneyStageReciteShortSurahsSection1Body =>
      'Takbir magnifies Allah. Tasbih in ruku and sujud glorifies Him. These short phrases are not filler between positions. They are part of the inner life of salah.';

  @override
  String get learningJourneyStageReciteShortSurahsSection2Title =>
      'How to begin using them with understanding';

  @override
  String get learningJourneyStageReciteShortSurahsSection2Body =>
      'Choose one phrase to pay attention to in your next prayer. Repeat it slowly enough that the meaning stays present for at least one moment.';

  @override
  String get learningJourneyStageReciteShortSurahsTakeaway1 =>
      'Short phrases can carry deep meaning inside prayer.';

  @override
  String get learningJourneyStageReciteShortSurahsTakeaway2 =>
      'Understanding grows khushu more naturally than forcing emotion.';

  @override
  String get learningJourneyStageReciteShortSurahsTakeaway3 =>
      'One attentive phrase is a strong place to begin.';

  @override
  String get learningJourneyStageReciteShortSurahsReflection =>
      'Which phrase in salah do you want to stop rushing past?';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation1Title => 'Takbir';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation1Meaning =>
      'Allah is greater than everything competing for your attention.';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation1Context =>
      'Said when moving into major parts of the prayer.';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation2Title =>
      'Tasbih in bowing';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation2Meaning =>
      'Glory be to my Lord, the Most Great.';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation2Context =>
      'Said in ruku to glorify Allah with humility.';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation3Title =>
      'Tasbih in prostration';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation3Meaning =>
      'Glory be to my Lord, the Most High.';

  @override
  String get learningJourneyStageReciteShortSurahsInvocation3Context =>
      'Said in sujud while you are physically lowest before Allah.';

  @override
  String get learningJourneyStageReciteMeaningLessonTitle =>
      'Simple Dhikr Meanings';

  @override
  String get learningJourneyStageReciteMeaningIntro =>
      'A few short phrases appear again and again in Muslim life. When you understand them, dhikr becomes lighter to carry and easier to keep.';

  @override
  String get learningJourneyStageReciteMeaningSection1Title =>
      'Start with the smallest phrases';

  @override
  String get learningJourneyStageReciteMeaningSection1Body =>
      'SubhanAllah clears Allah of نقص and imperfection. Alhamdulillah fills the heart with praise and gratitude. Short dhikr works because it can stay with you in ordinary moments.';

  @override
  String get learningJourneyStageReciteMeaningSection2Title =>
      'Bridge meaning into daily rhythm';

  @override
  String get learningJourneyStageReciteMeaningSection2Body =>
      'Use one phrase after prayer, one during a quiet walk, and one when something good happens. That is enough to start a sincere daily rhythm.';

  @override
  String get learningJourneyStageReciteMeaningSection2Bullet1 =>
      'Say SubhanAllah when you want to remember Allah’s perfection.';

  @override
  String get learningJourneyStageReciteMeaningSection2Bullet2 =>
      'Say Alhamdulillah when you notice a blessing.';

  @override
  String get learningJourneyStageReciteMeaningSection2Bullet3 =>
      'Keep the phrases short enough to remain present and sincere.';

  @override
  String get learningJourneyStageReciteMeaningTakeaway1 =>
      'Short dhikr becomes stronger when you understand it.';

  @override
  String get learningJourneyStageReciteMeaningTakeaway2 =>
      'Meaning makes repetition more alive, not less simple.';

  @override
  String get learningJourneyStageReciteMeaningTakeaway3 =>
      'Daily remembrance grows best through small steady anchors.';

  @override
  String get learningJourneyStageReciteMeaningReflection =>
      'Which short phrase do you want to carry more intentionally through your day?';

  @override
  String get learningJourneyStageReciteMeaningInvocation1Title => 'Tasbih';

  @override
  String get learningJourneyStageReciteMeaningInvocation1Meaning =>
      'Glory be to Allah.';

  @override
  String get learningJourneyStageReciteMeaningInvocation1Context =>
      'Use when remembering Allah’s perfection and greatness.';

  @override
  String get learningJourneyStageReciteMeaningInvocation2Title => 'Hamd';

  @override
  String get learningJourneyStageReciteMeaningInvocation2Meaning =>
      'All praise belongs to Allah.';

  @override
  String get learningJourneyStageReciteMeaningInvocation2Context =>
      'Use when you notice mercy, provision, or any blessing.';

  @override
  String get learningJourneyStageReadingBasicsOpenLessonTitle =>
      'Harakat and Reading Clues';

  @override
  String get learningJourneyStageReadingBasicsOpenIntro =>
      'Before smooth reading comes a smaller skill: seeing the marks around the letters clearly enough to know how the sound should move.';

  @override
  String get learningJourneyStageReadingBasicsOpenSection1Title =>
      'What to notice first';

  @override
  String get learningJourneyStageReadingBasicsOpenSection1Body =>
      'Harakat are the short vowel signs that tell you whether the sound opens, lowers, or rounds. Start by noticing the mark before worrying about speed.';

  @override
  String get learningJourneyStageReadingBasicsOpenSection1Bullet1 =>
      'Fathah usually gives a light “a” sound.';

  @override
  String get learningJourneyStageReadingBasicsOpenSection1Bullet2 =>
      'Kasrah usually gives a light “i” sound.';

  @override
  String get learningJourneyStageReadingBasicsOpenSection1Bullet3 =>
      'Dammah usually gives a light “u” sound.';

  @override
  String get learningJourneyStageReadingBasicsOpenSection2Title =>
      'A gentle way to practice';

  @override
  String get learningJourneyStageReadingBasicsOpenSection2Body =>
      'Read one letter at a time, say the sound, then repeat the same pattern across two or three examples. Accuracy first. Speed later.';

  @override
  String get learningJourneyStageReadingBasicsOpenTakeaway1 =>
      'Reading improves when your eye sees the mark before your tongue rushes ahead.';

  @override
  String get learningJourneyStageReadingBasicsOpenTakeaway2 =>
      'Small accurate repetition is more useful than fast guessing.';

  @override
  String get learningJourneyStageReadingBasicsOpenTakeaway3 =>
      'Harakat are a doorway into confidence, not a burden.';

  @override
  String get learningJourneyStageReadingBasicsOpenReflection =>
      'Which sound pattern still feels least stable for you right now?';

  @override
  String get learningJourneyStageReadingBasicsPracticeLessonTitle =>
      'Joining Letters into Reading';

  @override
  String get learningJourneyStageReadingBasicsPracticeIntro =>
      'After letter recognition, the next step is learning to stay calm when letters change shape and join together inside words.';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection1Title =>
      'Why joined letters feel harder';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection1Body =>
      'Arabic letters can look different at the beginning, middle, or end of a word. That is normal. The goal is not instant mastery. The goal is learning to recognize the same letter in more than one form.';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection2Title =>
      'How to practice without overload';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection2Body =>
      'Work with short groups of letters and simple words. Trace the sound from one letter to the next instead of trying to swallow the whole word at once.';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection2Bullet1 =>
      'Pause when a familiar letter looks unfamiliar.';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection2Bullet2 =>
      'Break the word into smaller sound groups.';

  @override
  String get learningJourneyStageReadingBasicsPracticeSection2Bullet3 =>
      'Repeat one short line several times before moving on.';

  @override
  String get learningJourneyStageReadingBasicsPracticeTakeaway1 =>
      'Joined letters become easier through pattern recognition, not force.';

  @override
  String get learningJourneyStageReadingBasicsPracticeTakeaway2 =>
      'Short words are enough for real progress.';

  @override
  String get learningJourneyStageReadingBasicsPracticeTakeaway3 =>
      'Calm repetition helps more than pushing for speed.';

  @override
  String get learningJourneyStageReadingBasicsPracticeReflection =>
      'Do you need more patience with letter shapes or with sounding out words?';

  @override
  String get learningJourneyStageReadingBasicsCheckpointLessonTitle =>
      'Reading Checkpoint';

  @override
  String get learningJourneyStageReadingBasicsCheckpointIntro =>
      'A checkpoint is not a final exam. It is a quiet pause to notice what is becoming easier and what still needs one more calm pass.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection1Title =>
      'Simple self-checks';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection1Body =>
      'Use a few short checks before moving forward. You do not need perfection. You need enough clarity to keep building without confusion.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection1Bullet1 =>
      'Can you identify the basic harakat without panic?';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection1Bullet2 =>
      'Can you follow a short joined word more slowly and correctly?';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection1Bullet3 =>
      'Do you know which sound or shape still needs extra review?';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection2Title =>
      'What to do next';

  @override
  String get learningJourneyStageReadingBasicsCheckpointSection2Body =>
      'If one area still feels weak, return to that area on purpose. Steady loops build reading confidence better than pretending you are ready for everything.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointTakeaway1 =>
      'Checkpoints are for clarity, not discouragement.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointTakeaway2 =>
      'Knowing your weak spot is part of progress.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointTakeaway3 =>
      'A calm return to basics is often the fastest way forward.';

  @override
  String get learningJourneyStageReadingBasicsCheckpointReflection =>
      'Which small reading skill needs another week of focused attention before you move on?';

  @override
  String get learningJourneyHomeTitle => 'Learning';

  @override
  String get learningJourneyHomeSubtitle =>
      'A calmer learning home built around journeys, today’s guidance, and five clear islands.';

  @override
  String get learningJourneyHomeContinueBadge => 'Continue';

  @override
  String get learningJourneyHomeContinueAction => 'Continue';

  @override
  String get learningJourneyHomeCompletedBadge => 'Completed';

  @override
  String get learningJourneyHomeCompletedSuffix => 'completed';

  @override
  String get learningJourneyHomeCompletedMessage =>
      'Great work—marking your journey complete and ready for what comes next.';

  @override
  String get learningJourneyHomeExploreNextAction => 'Open next';

  @override
  String learningJourneyHomeSuggestedNextIntro(String journeyTitle) {
    return 'Next suggestion: $journeyTitle';
  }

  @override
  String get learningJourneyHomeStartFirstJourneyTitle =>
      'Start Your First Journey';

  @override
  String get learningJourneyHomeStartFirstJourneySubtitle =>
      'Begin with a simple guided path instead of browsing everything at once.';

  @override
  String get learningJourneyHomeExploreJourneys => 'Explore Journeys';

  @override
  String get learningJourneyHomeRecommendedTitle => 'Recommended Journeys';

  @override
  String get learningJourneyHomeRecommendedReasonDefault =>
      'A small set of paths that fit what you have already opened or completed.';

  @override
  String get learningJourneyHomeRecommendedReasonWorship =>
      'Try a worship-focused path to build consistency from what you already started.';

  @override
  String get learningJourneyHomeRecommendedReasonArabic =>
      'Try an Arabic path next to strengthen understanding as you continue.';

  @override
  String get learningJourneyHomeRecommendedReasonNearCompletion =>
      'You’re close to a completion point—continue with the next journey.';

  @override
  String get learningJourneyHomeRecommendedReasonCompleted =>
      'You have completed this phase, so here is a thoughtful next step.';

  @override
  String get learningJourneyHomeRecommendedReasonFallback =>
      'Try one of these paths to keep your learning rhythm steady.';

  @override
  String get learningJourneyHomeIslandsTitle => '5 Islands';

  @override
  String get learningJourneyHomeIslandsSubtitle =>
      'Start from the island that fits what you want to learn now. Each island leads into real journeys and staged content.';

  @override
  String get learningJourneyHomeBrowseAllTitle => 'Browse All Knowledge';

  @override
  String get learningJourneyHomeBrowseAllSubtitle =>
      'Open the wider map of islands, tools, collections, and secondary exploration.';

  @override
  String get learningJourneyHomeLegacyTitle => 'Legacy Learning Material';

  @override
  String get learningJourneyHomeLegacySubtitle =>
      'Explore the original learning library while the journey architecture continues to grow.';

  @override
  String get learningJourneyTodayLightOpenAction => 'Open';

  @override
  String get learningJourneyTodayLightBadgeProphet => 'Prophet Daily';

  @override
  String get learningJourneyTodayLightBadgeHadith => 'Hadith Daily';

  @override
  String get learningJourneyTodayLightBadgeVerse => 'Daily Verse';

  @override
  String get learningJourneyTodayLightBadgeReflection => 'Daily Reflection';

  @override
  String get learningJourneyTodayLightBadgeTrivia => 'Trivia Daily';

  @override
  String get learningJourneyTodayLightBadgeDhikr => 'Dhikr Focus';

  @override
  String get learningJourneyTodayLightProphetTitleFallback =>
      'Daily Prophet Reflection';

  @override
  String get learningJourneyTodayLightProphetSubtitleFallback =>
      'Open the Prophet daily reflection for today.';

  @override
  String get learningJourneyTodayLightHadithTitleFallback =>
      'Today’s Hadith Reflection';

  @override
  String get learningJourneyTodayLightHadithSubtitleFallback =>
      'Open the current daily hadith reflection.';

  @override
  String get learningJourneyTodayLightVerseTitleFallback => 'Daily Verse';

  @override
  String get learningJourneyTodayLightVerseSubtitleFallback =>
      'Read today\'s selected verse with meaning and reflection.';

  @override
  String get learningJourneyTodayLightReflectionTitleFallback =>
      'Creation Reflection';

  @override
  String get learningJourneyTodayLightReflectionSubtitleFallback =>
      'Reflect on the short prompt and carry it into your day.';

  @override
  String get learningJourneyTodayLightTriviaTitleFallback =>
      'Today’s Trivia Round';

  @override
  String get learningJourneyTodayLightTriviaSubtitleFallback =>
      'Open a short trivia session and keep learning in motion.';

  @override
  String get learningJourneyTodayLightDhikrTitleFallback => 'Dhikr Focus';

  @override
  String get learningJourneyTodayLightDhikrSubtitleFallback =>
      'Open the Daily Dhikr journey and continue with a short remembrance rhythm.';

  @override
  String learningJourneyTodayLightStreakFallback(int days) {
    return 'You are on a $days day learning streak.';
  }

  @override
  String get learningJourneyIslandOpenAction => 'Open island';

  @override
  String get learningJourneyIslandCoreKnowledgeTitle => 'Core Knowledge';

  @override
  String get learningJourneyIslandCoreKnowledgeSubtitle =>
      'Qur’an, Prophets, Seerah, and Hadith.';

  @override
  String get learningJourneyIslandCoreKnowledgeDescription =>
      'Build your foundations through the core sources and sacred history of Islam.';

  @override
  String get learningJourneyIslandPracticeWorshipTitle => 'Practice & Worship';

  @override
  String get learningJourneyIslandPracticeWorshipSubtitle =>
      'Salah, Dhikr, and Duas for daily life.';

  @override
  String get learningJourneyIslandPracticeWorshipDescription =>
      'Learn the acts of worship that shape daily rhythm, remembrance, and presence.';

  @override
  String get learningJourneyIslandUnderstandingIslamTitle =>
      'Understanding Islam';

  @override
  String get learningJourneyIslandUnderstandingIslamSubtitle =>
      'Faith, fiqh, and the larger historical frame.';

  @override
  String get learningJourneyIslandUnderstandingIslamDescription =>
      'Understand the essentials of belief, practice, and historical development with clarity.';

  @override
  String get learningJourneyIslandArabicLearningTitle => 'Arabic Learning';

  @override
  String get learningJourneyIslandArabicLearningSubtitle =>
      'Alphabet, reading, words, and tajweed basics.';

  @override
  String get learningJourneyIslandArabicLearningDescription =>
      'Grow from letter recognition toward meaning, recitation, and confident repetition.';

  @override
  String get learningJourneyIslandDiscoveryTitle => 'Discovery';

  @override
  String get learningJourneyIslandDiscoverySubtitle =>
      'Trivia, daily wisdom, stories, and reflective exploration.';

  @override
  String get learningJourneyIslandDiscoveryDescription =>
      'Explore lighter entry points that still lead into real understanding and reflection.';

  @override
  String get learningJourneyIslandKidsLearningTitle => 'Kids Learning';

  @override
  String get learningJourneyIslandKidsLearningSubtitle =>
      'Stories, habits, memorization, and guided learning for children.';

  @override
  String get learningJourneyIslandKidsLearningDescription =>
      'Keep children’s learning in one dedicated island so future kids journeys, tools, and activities have a clear home.';

  @override
  String get learningJourneyIslandBrowseAllTitle => 'Browse All';

  @override
  String get learningJourneyIslandBrowseAllSubtitle =>
      'See the wider map of journeys, tools, collections, and exploration.';

  @override
  String get learningJourneyIslandBrowseAllDescription =>
      'Use one island as the front door to the full learning map when you want everything available in one place.';

  @override
  String get learningJourneyIslandToolsOtherTitle => 'Tools & Other';

  @override
  String get learningJourneyIslandToolsOtherSubtitle =>
      'Utilities, family tools, and supporting learning spaces.';

  @override
  String get learningJourneyIslandToolsOtherDescription =>
      'Keep non-journey utilities and supporting spaces in one dedicated island instead of scattering them across the legacy learning hub.';

  @override
  String get learningJourneyIslandLegacyLearningTitle => 'Legacy Learning';

  @override
  String get learningJourneyIslandLegacyLearningSubtitle =>
      'Older learning surfaces and migrated sections that still remain in use.';

  @override
  String get learningJourneyIslandLegacyLearningDescription =>
      'Keep the legacy learning library in one explicit island while the newer journey structure continues to absorb and replace it over time.';

  @override
  String get learningJourneyFeedbackFirstStageOpened =>
      'Learning started. Stay present and take just one meaningful step.';

  @override
  String learningJourneyFeedbackStageCompleted(int streak) {
    return 'Stage complete. You’re on a $streak day streak.';
  }

  @override
  String learningJourneyHomeStreakMessage(int days) {
    return 'You’re on a $days day learning streak.';
  }

  @override
  String learningJourneyCardStageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stages',
      one: '$count stage',
    );
    return '$_temp0';
  }

  @override
  String learningJourneyCardProgressLabel(int complete, int total) {
    return '$complete of $total complete';
  }

  @override
  String get learningJourneyCardActionStart => 'Start';

  @override
  String get learningJourneyCardActionContinue => 'Continue';

  @override
  String get learningJourneyStageCurrentBadge => 'Current';

  @override
  String get learningJourneyStagePreviewBadge => 'Preview';

  @override
  String get learningJourneyStageStatusReady => 'Ready';

  @override
  String get learningJourneyStageStatusPartial => 'Partial';

  @override
  String get learningJourneyStageStatusPlanned => 'Planned';

  @override
  String get learningJourneyPlaceholderBuiltTitle =>
      'This lesson is being built';

  @override
  String get learningJourneyPlaceholderExploreTitle => 'Explore now';

  @override
  String get learningJourneyPlaceholderExploreSubtitle =>
      'Use the available real content below while this stage is still being finished.';

  @override
  String get learningJourneyPlaceholderBackAction => 'Back to Journey';

  @override
  String get learningJourneyIslandNotFoundTitle => 'Island not found';

  @override
  String get learningJourneyIslandNotFoundSubtitle =>
      'This learning island could not be located.';

  @override
  String get learningJourneyIslandNotFoundBody =>
      'Return to the Learning Journey home and choose another path.';

  @override
  String get learningJourneyIslandActionStart => 'Start';

  @override
  String get learningJourneyIslandActionContinue => 'Continue';

  @override
  String get learningJourneyIslandJourneysTitle => 'Journeys';

  @override
  String get learningJourneyIslandJourneysSubtitle =>
      'Structured paths come first here. Related tools stay available below when you need them.';

  @override
  String get learningJourneyIslandRelatedToolsTitle =>
      'Related Tools & Exploration';

  @override
  String get learningJourneyIslandRelatedToolsSubtitle =>
      'Use these as supporting paths when you want to explore outside the main staged journeys.';

  @override
  String get learningJourneyIslandWhyCoreKnowledge =>
      'Core sources and sacred history give the rest of the learning path its center and coherence.';

  @override
  String get learningJourneyIslandWhyPracticeWorship =>
      'Practice-based learning is where knowledge starts shaping the rhythm of real daily worship.';

  @override
  String get learningJourneyIslandWhyUnderstandingIslam =>
      'This island gives users a steadier frame for belief, law, and the bigger picture behind practice.';

  @override
  String get learningJourneyIslandWhyArabicLearning =>
      'Arabic learning becomes sustainable when it is broken into calmer stages with clear next steps.';

  @override
  String get learningJourneyIslandWhyDiscovery =>
      'Discovery keeps the system welcoming and reflective while still guiding users toward deeper journeys.';

  @override
  String get learningJourneyIslandWhyKidsLearning =>
      'Kids learning needs its own home so child-focused journeys, stories, and habits can grow without being scattered across the wider learning system.';

  @override
  String get learningJourneyIslandWhyBrowseAll =>
      'Some users still need a clear full-library view, so Browse All should exist as an explicit island instead of a secondary buried action.';

  @override
  String get learningJourneyIslandWhyToolsOther =>
      'Support tools like Baby Names still belong in the learning ecosystem, but they should live in a clear utility island instead of cluttering the main journey islands.';

  @override
  String get learningJourneyIslandWhyLegacyLearning =>
      'Legacy learning still contains real material, but it should be boxed into its own island so the newer journey system can stay clear and intentional.';

  @override
  String get kidsArabicHomeTitle => 'Write and Learn Arabic Letters';

  @override
  String get kidsArabicHomeSubtitle =>
      'A calm place for children to see, hear, trace, and review Arabic letters.';

  @override
  String get kidsArabicProgressTitle => 'Today in letters';

  @override
  String kidsArabicLettersCompletedValue(int count) {
    return '$count letters';
  }

  @override
  String kidsArabicLessonsDoneValue(int count) {
    return '$count lessons';
  }

  @override
  String kidsArabicCurrentStreakValue(int count) {
    return '$count day streak';
  }

  @override
  String kidsArabicDropsValue(int count) {
    return '$count drops';
  }

  @override
  String get kidsArabicReviewTitle => 'Letter Review';

  @override
  String get kidsArabicReviewSubtitle =>
      'Short, gentle review rounds for learned letters.';

  @override
  String get kidsArabicRewardsTitle => 'Rewards & Stickers';

  @override
  String get kidsArabicRewardsSubtitle =>
      'Warm little rewards from steady letter learning.';

  @override
  String get kidsArabicParentDashboardTitle => 'Parent Dashboard';

  @override
  String get kidsArabicParentDashboardSubtitle =>
      'A simple view of progress, streak, and letters that may need review.';

  @override
  String get kidsArabicDailyJourneyTitle => 'Daily Journey';

  @override
  String get kidsArabicDailyJourneyContinueAction => 'Continue Journey';

  @override
  String get kidsArabicDailyJourneyCompletedSubtitle =>
      'Today’s mission is complete.';

  @override
  String get kidsArabicDailyJourneyReturnTomorrow =>
      'A gentle new step will be ready tomorrow.';

  @override
  String get kidsArabicDailyJourneyTomorrowHint =>
      'Come back tomorrow for a new small step.';

  @override
  String kidsArabicDailyJourneyStreakValue(int count) {
    return '$count day streak';
  }

  @override
  String kidsArabicDailyJourneyRewardPreview(int xp, int drops) {
    return '+$xp XP and +$drops Ocean Drop';
  }

  @override
  String kidsArabicDailyJourneyGraceValue(int count) {
    return '$count grace day';
  }

  @override
  String kidsArabicDailyMissionNewLetterTitle(Object letterName) {
    return 'Learn $letterName';
  }

  @override
  String kidsArabicDailyMissionNewLetterDescription(Object letterName) {
    return 'Open $letterName, trace it gently, and finish one lesson.';
  }

  @override
  String kidsArabicDailyMissionReviewTitle(Object letterName) {
    return 'Review $letterName';
  }

  @override
  String kidsArabicDailyMissionReviewDescription(Object letterName) {
    return 'Do one gentle review for $letterName.';
  }

  @override
  String kidsArabicDailyMissionTraceTitle(Object letterName) {
    return 'Trace $letterName';
  }

  @override
  String kidsArabicDailyMissionTraceDescription(Object letterName) {
    return 'Trace $letterName one more time to keep it close.';
  }

  @override
  String get kidsArabicDailyMissionCompletedTitle => 'Daily mission complete';

  @override
  String kidsArabicDailyMissionCompletedSubtitle(int streak) {
    return 'Your streak is now $streak days.';
  }

  @override
  String kidsArabicDailyMissionRewardRow(int xp, int drops) {
    return '+$xp XP and +$drops Ocean Drop';
  }

  @override
  String get kidsArabicDailyMissionTomorrowPrompt =>
      'A new mission will be waiting tomorrow.';

  @override
  String get kidsArabicDailyMissionGraceUsed =>
      'Grace day used to keep the streak warm.';

  @override
  String get kidsArabicRecommendedTitle => 'Start with these letters';

  @override
  String get kidsArabicRecommendedSubtitle =>
      'Begin with Alif, Ba, Meem, Noon, and Seen.';

  @override
  String get kidsArabicStartHereBadge => 'Start here';

  @override
  String get kidsArabicAlphabetTitle => 'All letters';

  @override
  String get kidsArabicAlphabetSubtitle =>
      'Finish one letter to gently unlock the next in order.';

  @override
  String get kidsArabicLockedTitle => 'Keep going gently';

  @override
  String get kidsArabicLockedSubtitle =>
      'This letter opens after the one before it is complete.';

  @override
  String get kidsArabicLockedBody =>
      'Finish the previous letter first, then this one will unlock.';

  @override
  String get kidsArabicLockedStatus => 'Locked for now';

  @override
  String get kidsArabicReadyToStart => 'Ready';

  @override
  String kidsArabicLessonTitle(String glyph) {
    return 'Letter $glyph';
  }

  @override
  String kidsArabicLessonSubtitle(String letterName) {
    return 'Trace and hear $letterName with a calm guided lesson.';
  }

  @override
  String get kidsArabicLetterMissingTitle => 'Letter not found';

  @override
  String get kidsArabicLetterMissingSubtitle =>
      'This letter lesson could not be opened.';

  @override
  String get kidsArabicLetterMissingBody =>
      'Return to the letters home and choose another lesson.';

  @override
  String get kidsArabicPronunciationAction => 'Listen';

  @override
  String get kidsArabicClearTraceAction => 'Try again';

  @override
  String get kidsArabicTraceTitle => 'Trace together';

  @override
  String kidsArabicTraceSubtitle(int count) {
    return 'Try $count gentle stroke shapes.';
  }

  @override
  String kidsArabicTraceStrokeProgress(int current, int total) {
    return 'Stroke $current of $total';
  }

  @override
  String get kidsArabicTraceEncouragementStart => 'Trace slowly together.';

  @override
  String get kidsArabicTraceEncouragementNice => 'Nice tracing.';

  @override
  String get kidsArabicTraceEncouragementGreat => 'Great job.';

  @override
  String get kidsArabicTraceEncouragementBeautiful => 'Beautiful work.';

  @override
  String get kidsArabicTraceEncouragementRetry => 'Let’s try again together.';

  @override
  String get kidsArabicWordCardTitle => 'Word friend';

  @override
  String get kidsArabicWordCardSubtitle =>
      'A simple word helps the letter stay close.';

  @override
  String get kidsArabicLessonRewardTitle => 'Lesson reward';

  @override
  String kidsArabicLessonRewardFooter(int xp, int drops) {
    return '+$xp XP and +$drops Ocean Drop for this lesson.';
  }

  @override
  String get kidsArabicCompleteLessonAction => 'Continue';

  @override
  String kidsArabicCompletionTitle(String result) {
    return '$result';
  }

  @override
  String kidsArabicCompletionSubtitle(String glyph, int xp) {
    return '$glyph is now part of today’s learning.';
  }

  @override
  String kidsArabicStickerUnlocked(int count) {
    return '$count new sticker earned';
  }

  @override
  String get kidsArabicBackToLettersAction => 'Letters home';

  @override
  String get kidsArabicNextLetterAction => 'Next';

  @override
  String kidsArabicCompletionRewardRow(int xp, int drops) {
    return '+$xp XP and +$drops Ocean Drop';
  }

  @override
  String kidsArabicCompletionNextUnlock(String glyph) {
    return 'Next letter: $glyph';
  }

  @override
  String get kidsArabicTraceResultCompleted => 'Nice tracing';

  @override
  String get kidsArabicTraceResultGood => 'Great job';

  @override
  String get kidsArabicTraceResultExcellent => 'Beautiful work';

  @override
  String get kidsArabicReviewModeMatchSound => 'Match sound';

  @override
  String get kidsArabicReviewModeTapCorrectLetter => 'Tap the letter';

  @override
  String kidsArabicQuestionCounter(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String kidsArabicReviewQuestionMatchSound(String glyph) {
    return 'Which sound matches this letter?';
  }

  @override
  String kidsArabicReviewQuestionTapCorrect(String transliteration) {
    return 'Tap the letter for $transliteration.';
  }

  @override
  String get kidsArabicReviewCorrectFeedback => 'Great job.';

  @override
  String get kidsArabicReviewRetryFeedback => 'Let’s try again together.';

  @override
  String get kidsArabicReviewFinishedTitle => 'Review finished';

  @override
  String kidsArabicReviewFinishedSubtitle(int correct, int total) {
    return 'You answered $correct of $total. Keep going gently.';
  }

  @override
  String get kidsArabicStickerFirstLetterTitle => 'First Letter';

  @override
  String get kidsArabicStickerFirstLetterSubtitle =>
      'The first gentle step is done.';

  @override
  String get kidsArabicStickerFirstFiveTitle => 'First Five';

  @override
  String get kidsArabicStickerFirstFiveSubtitle =>
      'The first five starter letters are underway.';

  @override
  String get kidsArabicStickerTenLettersTitle => 'Steady Ten';

  @override
  String get kidsArabicStickerTenLettersSubtitle =>
      'Ten letters are now part of the path.';

  @override
  String get kidsArabicStickerFullAlphabetTitle => 'Full Alphabet';

  @override
  String get kidsArabicStickerFullAlphabetSubtitle =>
      'All 28 letters have been completed at least once.';

  @override
  String get kidsArabicStickerEarned => 'Earned';

  @override
  String get kidsArabicStickerLocked => 'Locked';

  @override
  String get kidsArabicLettersCompletedLabel => 'Letters completed';

  @override
  String get kidsArabicLessonsDoneLabel => 'Total lessons done';

  @override
  String get kidsArabicCurrentStreakLabel => 'Current streak';

  @override
  String get kidsArabicParentBestStreakLabel => 'Best streak';

  @override
  String get kidsArabicParentActiveDaysThisWeekLabel => 'Active days this week';

  @override
  String get kidsArabicParentTodayMissionLabel => 'Today’s mission';

  @override
  String get kidsArabicParentTodayMissionCompleted => 'Completed';

  @override
  String get kidsArabicParentTodayMissionPending => 'Still to do';

  @override
  String get kidsArabicParentReviewNeededTitle => 'Letters to review';

  @override
  String get kidsArabicParentReviewNeededEmpty =>
      'No letters need review right now.';

  @override
  String get kidsArabicColoringPagesTitle => 'Coloring Pages';

  @override
  String get kidsArabicColoringPagesSubtitle =>
      'Printable letter pages unlock as each letter is completed.';

  @override
  String kidsArabicColoringPagesProgressValue(int unlocked, int total) {
    return '$unlocked of $total pages unlocked';
  }

  @override
  String get kidsArabicColoringUnlockedLabel => 'Ready to color';

  @override
  String get kidsArabicColoringUnlockHint =>
      'Finish the matching letter lesson to unlock this page.';

  @override
  String get kidsArabicColoringViewerSubtitle =>
      'Pinch to zoom and view the printable page clearly.';

  @override
  String get kidsArabicColoringViewerHint =>
      'Use the copied asset path to print or export from your release workflow.';

  @override
  String get kidsArabicColoringOpenAssetAction => 'Copy asset path';

  @override
  String get kidsArabicColoringAssetCopiedMessage =>
      'Coloring page asset path copied.';

  @override
  String get kidsArabicColoringMissingTitle => 'Coloring page not found';

  @override
  String get kidsArabicColoringMissingSubtitle =>
      'This coloring page could not be opened.';

  @override
  String get kidsArabicColoringMissingBody =>
      'Return to Coloring Pages and choose another page.';

  @override
  String get kidsArabicColoringLockedTitle => 'Coloring page locked';

  @override
  String get kidsArabicColoringLockedSubtitle =>
      'This page unlocks after the matching letter is completed.';

  @override
  String get kidsArabicColoringPageAlifTitle => 'Alif Coloring Page';

  @override
  String get kidsArabicColoringPageBaTitle => 'Ba Coloring Page';

  @override
  String get kidsArabicColoringPageMeemTitle => 'Meem Coloring Page';

  @override
  String get kidsArabicColoringPageNoonTitle => 'Noon Coloring Page';

  @override
  String get kidsArabicColoringPageSeenTitle => 'Seen Coloring Page';

  @override
  String get kidsArabicParentSettingsTitle => 'Parent Settings';

  @override
  String get kidsArabicParentSettingsSubtitle =>
      'Gentle tools to guide letters, review, and support at home.';

  @override
  String get kidsArabicParentGuidedProgressionTitle => 'Guided progression';

  @override
  String get kidsArabicParentGuidedProgressionSubtitle =>
      'Keep the home page focused on the next calm step.';

  @override
  String get kidsArabicParentPrioritizeReviewTitle => 'Prioritize review';

  @override
  String get kidsArabicParentPrioritizeReviewSubtitle =>
      'Bring a chosen review letter forward when it needs a little care.';

  @override
  String get kidsArabicParentShowTransliterationTitle => 'Show transliteration';

  @override
  String get kidsArabicParentShowTransliterationSubtitle =>
      'Keep transliteration visible in letter lessons.';

  @override
  String get kidsArabicParentAudioAutoplayTitle => 'Audio autoplay';

  @override
  String get kidsArabicParentAudioAutoplaySubtitle =>
      'Play the letter sound gently when the lesson opens.';

  @override
  String get kidsArabicParentAllowAssignedFocusTitle => 'Allow parent focus';

  @override
  String get kidsArabicParentAllowAssignedFocusSubtitle =>
      'Let one chosen letter become today’s gentle focus.';

  @override
  String get kidsArabicParentSupportLevelTitle => 'Lesson support level';

  @override
  String get kidsArabicParentSupportLevelSubtitle =>
      'Choose how much extra guidance the lesson shows.';

  @override
  String get kidsArabicParentSupportLevelGentle => 'Gentle';

  @override
  String get kidsArabicParentSupportLevelStandard => 'Standard';

  @override
  String get kidsArabicParentSupportLevelExtraHelp => 'Extra help';

  @override
  String get kidsArabicParentFocusLetterTitle => 'Focus letter';

  @override
  String get kidsArabicParentFocusLetterSubtitle =>
      'Choose one unlocked letter to guide next.';

  @override
  String get kidsArabicParentReviewLetterTitle => 'Review letter';

  @override
  String get kidsArabicParentReviewLetterSubtitle =>
      'Choose one learned letter to bring into review next.';

  @override
  String get kidsArabicParentNoFocusOption => 'No focus letter';

  @override
  String get kidsArabicParentNoReviewOption => 'No review letter';

  @override
  String get kidsArabicParentInvalidFocusMessage =>
      'That focus letter is not available yet.';

  @override
  String get kidsArabicParentInvalidReviewMessage =>
      'That review letter is not available yet.';

  @override
  String get kidsArabicParentTodayFocusTitle => 'Today’s focus';

  @override
  String kidsArabicParentTodayFocusSubtitle(Object letterName) {
    return 'A parent chose $letterName as the next gentle step.';
  }

  @override
  String get kidsArabicParentReviewNextTitle => 'Review this letter next';

  @override
  String kidsArabicParentReviewNextSubtitle(Object letterName) {
    return 'A parent brought $letterName forward for a warm review.';
  }

  @override
  String get kidsArabicFamilySummaryTitle => 'Family summary';

  @override
  String kidsArabicFamilySummarySubtitle(Object streak, Object stickers) {
    return '$streak day streak and $stickers stickers earned so far.';
  }

  @override
  String get kidsArabicFamilySummaryAction => 'Show parent summary';

  @override
  String get kidsArabicParentWeeklyCompletionLabel => 'Weekly completions';

  @override
  String get kidsArabicParentOverviewTitle => 'This week at a glance';

  @override
  String kidsArabicParentOverviewBody(Object latestLetter, Object nextLetter) {
    return 'Latest letter: $latestLetter. Next suggested letter: $nextLetter.';
  }

  @override
  String get kidsArabicParentNoLatestLetter => 'Not yet started';

  @override
  String get kidsArabicParentNoNextLetter => 'No next letter';

  @override
  String get kidsArabicParentAssignmentsTitle => 'Parent guidance';

  @override
  String kidsArabicParentAssignmentsBody(
    Object focusLetter,
    Object reviewLetter,
  ) {
    return 'Focus: $focusLetter. Review: $reviewLetter.';
  }

  @override
  String get kidsArabicParentAssignmentsOff => 'Off';

  @override
  String get kidsArabicParentWeeklyConsistencyTitle => 'Weekly consistency';

  @override
  String get kidsArabicWeekdayMon => 'M';

  @override
  String get kidsArabicWeekdayTue => 'T';

  @override
  String get kidsArabicWeekdayWed => 'W';

  @override
  String get kidsArabicWeekdayThu => 'T';

  @override
  String get kidsArabicWeekdayFri => 'F';

  @override
  String get kidsArabicWeekdaySat => 'S';

  @override
  String get kidsArabicWeekdaySun => 'S';

  @override
  String get kidsArabicParentSupportNoteTitle => 'Parent support';

  @override
  String get kidsArabicParentSupportNoteGentle =>
      'Take one small step and keep it light.';

  @override
  String get kidsArabicParentSupportNoteExtraHelp =>
      'Go slowly, listen once more, and trace with a little extra care.';

  @override
  String get kidsArabicLetterAlifChildLine => 'Alif reminds us of Allah.';

  @override
  String get kidsArabicLetterBaChildLine => 'Ba begins Bismillah.';

  @override
  String get kidsArabicLetterTaChildLine => 'Ta reminds us of taqwa.';

  @override
  String get kidsArabicLetterThaChildLine => 'Tha reminds us of thawab.';

  @override
  String get kidsArabicLetterJimChildLine => 'Jeem reminds us of Jannah.';

  @override
  String get kidsArabicLetterHaChildLine => 'Ha reminds us of halal.';

  @override
  String get kidsArabicLetterKhaChildLine => 'Kha reminds us of khayr.';

  @override
  String get kidsArabicLetterDalChildLine => 'Dal reminds us of deen.';

  @override
  String get kidsArabicLetterDhalChildLine => 'Dhal reminds us of dhikr.';

  @override
  String get kidsArabicLetterRaChildLine => 'Ra reminds us of rahmah.';

  @override
  String get kidsArabicLetterZayChildLine => 'Zay reminds us of zakah.';

  @override
  String get kidsArabicLetterSeenChildLine => 'Seen reminds us of sujood.';

  @override
  String get kidsArabicLetterSheenChildLine => 'Sheen reminds us of shukr.';

  @override
  String get kidsArabicLetterSadChildLine => 'Sad reminds us of salah.';

  @override
  String get kidsArabicLetterDadChildLine => 'Dad reminds us of light.';

  @override
  String get kidsArabicLetterTaaChildLine => 'Ta reminds us of taharah.';

  @override
  String get kidsArabicLetterZaaChildLine => 'Za reminds us of Zuhr.';

  @override
  String get kidsArabicLetterAinChildLine => 'Ain reminds us of ilm.';

  @override
  String get kidsArabicLetterGhainChildLine => 'Ghain reminds us of mercy.';

  @override
  String get kidsArabicLetterFaChildLine => 'Fa reminds us of Fajr.';

  @override
  String get kidsArabicLetterQafChildLine => 'Qaf reminds us of Qur’an.';

  @override
  String get kidsArabicLetterKafChildLine => 'Kaf reminds us of kitab.';

  @override
  String get kidsArabicLetterLamChildLine => 'Lam reminds us of layl.';

  @override
  String get kidsArabicLetterMeemChildLine => 'Meem reminds us of masjid.';

  @override
  String get kidsArabicLetterNoonChildLine => 'Noon reminds us of noor.';

  @override
  String get kidsArabicLetterHa2ChildLine => 'Ha reminds us of huda.';

  @override
  String get kidsArabicLetterWawChildLine => 'Waw reminds us of wudu.';

  @override
  String get kidsArabicLetterYaChildLine => 'Ya reminds us of yaqeen.';

  @override
  String get learningJourneyDetailAboutTitle => 'About this journey';

  @override
  String get learningJourneyDetailLearnTitle => 'What you will learn';

  @override
  String get learningJourneyDetailWhyThisMattersTitle => 'Why this matters';

  @override
  String get learningJourneyDetailProgressTitle => 'Progress';

  @override
  String learningJourneyDetailProgressLabel(int complete, int total) {
    return '$complete of $total stages complete';
  }

  @override
  String learningJourneyDetailReadyChip(int count) {
    return '$count ready';
  }

  @override
  String learningJourneyDetailPartialChip(int count) {
    return '$count partial';
  }

  @override
  String learningJourneyDetailPlannedChip(int count) {
    return '$count planned';
  }

  @override
  String get learningJourneyDetailRelatedToolsTitle => 'Related Tools';

  @override
  String get learningJourneyDetailRelatedToolsSubtitle =>
      'These stay secondary to the stages, but they are useful when you want to branch out.';

  @override
  String get learningJourneyDetailCurrentMappingTitle => 'Current mapping';

  @override
  String get learningJourneyDetailStagesTitle => 'Stages';

  @override
  String get learningJourneyDetailStagesSubtitle =>
      'Move one stage at a time. Current and completed stages are highlighted gently.';

  @override
  String get learningJourneyDetailActionStart => 'Start Journey';

  @override
  String get learningJourneyDetailActionContinue => 'Continue';

  @override
  String get learningJourneyDetailActionNextLesson => 'Next Lesson';

  @override
  String get learningJourneyDetailMissingTitle => 'Journey not found';

  @override
  String get learningJourneyDetailMissingSubtitle =>
      'This learning journey could not be located.';

  @override
  String get learningJourneyDetailMissingBody =>
      'Return to the island page and choose another journey.';

  @override
  String get learningJourneyPlaceholderLearnLabel => 'What you’ll learn';

  @override
  String get learningJourneyPlaceholderMessage =>
      'This lesson is being built with the same structure as the rest of the journey so it feels coherent when it opens.';

  @override
  String get learningJourneyPlaceholderPlannedIncludesTitle =>
      'What this lesson will include later';

  @override
  String get learningJourneyPlaceholderActionCompleted => 'Completed';

  @override
  String get learningJourneyPlaceholderActionMarkComplete => 'Mark as Complete';

  @override
  String get learningJourneyBrowseAllTitle => 'Browse All';

  @override
  String get learningJourneyBrowseAllSubtitle =>
      'Browse the journey architecture first, then reach for related tools, collections, and the original learning library where needed.';

  @override
  String get learningJourneyBrowseIslandsTitle => 'Journey Islands';

  @override
  String get learningJourneyBrowseIslandsSubtitle =>
      'The five islands remain the primary browse model. Everything else here is secondary exploration.';

  @override
  String get learningJourneyBrowseToolsTitle => 'Tools & Collections';

  @override
  String get learningJourneyBrowseToolsSubtitle =>
      'Secondary tools and utility surfaces live here without replacing the journey-first structure.';

  @override
  String get learningJourneyBrowseQuranTitle => 'Qur’an';

  @override
  String get learningJourneyBrowseQuranSubtitle =>
      'Open the primary Qur’an home for journeys, modes, and related tools.';

  @override
  String get learningJourneyBrowseQuranStudyTitle => 'Qur’an Study';

  @override
  String get learningJourneyBrowseQuranStudySubtitle =>
      'Open the study-focused layer for understanding, reflection, and memorization support.';

  @override
  String get learningJourneyBrowseQuranArabicTitle => 'Qur’anic Arabic';

  @override
  String get learningJourneyBrowseQuranArabicSubtitle =>
      'Keep the dedicated Arabic path available as a secondary Qur’an tool.';

  @override
  String get learningJourneyBrowseQuranUniverseTitle => 'Qur’an Universe';

  @override
  String get learningJourneyBrowseQuranUniverseSubtitle =>
      'Explore connected themes, concepts, and verse-linked relationships.';

  @override
  String get learningJourneyBrowseBabyNamesTitle => 'Baby Names';

  @override
  String get learningJourneyBrowseBabyNamesSubtitle =>
      'Browse names, meanings, favorites, and comparison tools from the current system.';

  @override
  String get learningJourneyBrowseNotesTitle => 'Notes';

  @override
  String get learningJourneyBrowseNotesSubtitle =>
      'Open the existing Learn notes landing page.';

  @override
  String get learningJourneyBrowseQuranBookmarksTitle => 'Qur’an Bookmarks';

  @override
  String get learningJourneyBrowseQuranBookmarksSubtitle =>
      'Return to saved Qur’an locations and reading marks.';

  @override
  String get learningJourneyBrowseQuranNotesTitle => 'Qur’an Notes';

  @override
  String get learningJourneyBrowseQuranNotesSubtitle =>
      'Review saved verse notes and highlights.';

  @override
  String get learningJourneyBrowseKnowledgeConstellationTitle =>
      'Knowledge Constellation';

  @override
  String get learningJourneyBrowseKnowledgeConstellationSubtitle =>
      'Explore existing cross-domain relationships and learning links.';

  @override
  String get learningJourneyBrowseLegacySubtitle =>
      'Explore the original learning library while the new journey architecture continues to mature.';

  @override
  String get learningJourneyStageNotFoundTitle => 'Stage not found';

  @override
  String get learningJourneyStageNotFoundSubtitle =>
      'This learning stage could not be located.';

  @override
  String get learningJourneyStageNotFoundBody =>
      'Return to the journey page and choose another stage.';

  @override
  String get learningJourneyStageOpeningSubtitle =>
      'Opening available content for this stage.';

  @override
  String get learningJourneyStageLaunchingBody => 'Launching stage content…';

  @override
  String get learningJourneyToolSearchTitle => 'Search';

  @override
  String get learningJourneyToolBookmarksTitle => 'Bookmarks';

  @override
  String get learningJourneyToolNotesTitle => 'Notes';

  @override
  String get learningJourneyToolExplorerTitle => 'Explorer';

  @override
  String get learningJourneyToolWuduGuideTitle => 'Wudu Guide';

  @override
  String get learningJourneyToolWuduTrainerTitle => 'Wudu Trainer';

  @override
  String get learningJourneyToolDuaHubTitle => 'Dua Hub';

  @override
  String get learningJourneyToolNamesOfAllahTitle => 'Names of Allah';

  @override
  String get learningJourneyToolProphetsTitle => 'Prophets';

  @override
  String get learningJourneyToolProphetsTimelineTitle => 'Prophets Timeline';

  @override
  String get learningJourneyToolProphetsMapTitle => 'Prophets Map';

  @override
  String get learningJourneyToolFamilyTreeTitle => 'Family Tree';

  @override
  String get learningJourneyToolWordsTitle => 'Words';

  @override
  String get learningJourneyToolWordReviewTitle => 'Word Review';

  @override
  String get learningJourneyToolGuidedPrayerTitle => 'Guided Prayer';

  @override
  String get learningJourneyToolHadithHubTitle => 'Hadith Hub';

  @override
  String get learningJourneyToolEssentialHadithTitle => 'Essential Hadith';

  @override
  String get learningJourneyToolHadithReviewTitle => 'Hadith Review';

  @override
  String get learningJourneyToolTriviaPathsTitle => 'Trivia Paths';

  @override
  String get learningJourneyToolTriviaReviewTitle => 'Trivia Review';

  @override
  String get learningJourneyToolWorldCreationTitle => 'World & Creation';

  @override
  String get learningJourneyToolExploreCreationTitle => 'Explore Creation';

  @override
  String get learningJourneyToolSignsExplorerTitle => 'Signs Explorer';

  @override
  String get learningJourneyToolReflectionModeTitle => 'Reflection Mode';

  @override
  String get learningJourneyToolLearnNotesTitle => 'Learn Notes';

  @override
  String get learningJourneyToolKnowledgeConstellationTitle =>
      'Knowledge Constellation';

  @override
  String get learningJourneyToolProphetsSubtitle =>
      'Open the current Prophets system.';

  @override
  String get learningJourneyToolWordsSubtitle =>
      'Browse recurring Qur’anic vocabulary.';

  @override
  String get learningJourneyToolWordReviewSubtitle =>
      'Review saved and repeated word sets.';

  @override
  String get learningJourneySeerahEarlyLifeTitle =>
      'Early Life of the Prophet ﷺ';

  @override
  String get learningJourneySeerahEarlyLifeIntro =>
      'The early life of the Prophet Muhammad ﷺ teaches trust in Allah, quiet preparation, and noble character before public prophethood.';

  @override
  String get learningJourneySeerahEarlyLifeSection1Title => 'Key events';

  @override
  String get learningJourneySeerahEarlyLifeSection1Body =>
      'He ﷺ was born in Makkah, lost his father before birth, lost his mother in childhood, and was then cared for by his grandfather and uncle. These early losses did not diminish him. Allah cared for him and prepared him.';

  @override
  String get learningJourneySeerahEarlyLifeSection2Title =>
      'Lessons from the early years';

  @override
  String get learningJourneySeerahEarlyLifeSection2Body =>
      'Before revelation, people already knew him as truthful and trustworthy. The early Seerah shows that prophetic character was visible long before public mission.';

  @override
  String get learningJourneySeerahEarlyLifeBullet1 =>
      'Hardship can refine a person instead of destroying them.';

  @override
  String get learningJourneySeerahEarlyLifeBullet2 =>
      'Truthfulness and trust are foundations of da‘wah.';

  @override
  String get learningJourneySeerahEarlyLifeBullet3 =>
      'Allah prepares people long before a visible mission begins.';

  @override
  String get learningJourneySeerahEarlyLifeTakeaway1 =>
      'The Prophet ﷺ grew under Allah’s care through hardship and dignity.';

  @override
  String get learningJourneySeerahEarlyLifeTakeaway2 =>
      'Character is part of preparation for leadership.';

  @override
  String get learningJourneySeerahEarlyLifeTakeaway3 =>
      'The early Seerah teaches patience without self-pity.';

  @override
  String get learningJourneySeerahEarlyLifeReflection =>
      'Which quality from the Prophet’s early life would most strengthen your own character right now?';

  @override
  String get learningJourneySeerahFirstRevelationTitle => 'First Revelation';

  @override
  String get learningJourneySeerahFirstRevelationIntro =>
      'The first revelation opened the mission of prophethood with a call to read in the name of Allah.';

  @override
  String get learningJourneySeerahFirstRevelationSection1Title =>
      'What happened in Hira';

  @override
  String get learningJourneySeerahFirstRevelationSection1Body =>
      'The Prophet ﷺ sought quiet reflection in the cave of Hira. There Jibril came with the first revelation and the command to read in the name of the Lord who created.';

  @override
  String get learningJourneySeerahFirstRevelationSection2Title =>
      'Why this moment matters';

  @override
  String get learningJourneySeerahFirstRevelationSection2Body =>
      'The beginning of revelation joined knowledge, worship, humility, and awe. It was a heavy moment, yet it became mercy for the world.';

  @override
  String get learningJourneySeerahFirstRevelationBullet1 =>
      'Revelation began with knowledge connected to Allah.';

  @override
  String get learningJourneySeerahFirstRevelationBullet2 =>
      'The Prophet ﷺ felt the weight of responsibility, not pride.';

  @override
  String get learningJourneySeerahFirstRevelationBullet3 =>
      'The Qur’an entered history gradually and purposefully.';

  @override
  String get learningJourneySeerahFirstRevelationTakeaway1 =>
      'Knowledge in Islam begins in the name of Allah.';

  @override
  String get learningJourneySeerahFirstRevelationTakeaway2 =>
      'The first revelation teaches humility before responsibility.';

  @override
  String get learningJourneySeerahFirstRevelationTakeaway3 =>
      'The Qur’an is revelation, not human wisdom.';

  @override
  String get learningJourneySeerahFirstRevelationReflection =>
      'How would your approach to learning change if you began it consciously in the name of Allah?';

  @override
  String get learningJourneySeerahMakkahTitle => 'Makkah Period';

  @override
  String get learningJourneySeerahMakkahIntro =>
      'The Makkan years were years of tawheed, patience, sacrifice, and steady calling under pressure.';

  @override
  String get learningJourneySeerahMakkahSection1Title => 'The Makkan call';

  @override
  String get learningJourneySeerahMakkahSection1Body =>
      'In Makkah the Prophet ﷺ called people to worship Allah alone while facing mockery, pressure, and persecution. The early believers were formed in a difficult environment.';

  @override
  String get learningJourneySeerahMakkahSection2Title => 'What Makkah built';

  @override
  String get learningJourneySeerahMakkahSection2Body =>
      'The Makkan Qur’an built belief first: who Allah is, what the Hereafter means, why worship matters, and how patience steadies the heart.';

  @override
  String get learningJourneySeerahMakkahBullet1 =>
      'Belief is strengthened before public power arrives.';

  @override
  String get learningJourneySeerahMakkahBullet2 =>
      'Patience in truth is part of the prophetic path.';

  @override
  String get learningJourneySeerahMakkahBullet3 =>
      'The Qur’an shaped hearts before society was reshaped.';

  @override
  String get learningJourneySeerahMakkahTakeaway1 =>
      'The Makkan years centered tawheed and endurance.';

  @override
  String get learningJourneySeerahMakkahTakeaway2 =>
      'Strong worship often begins in difficult conditions.';

  @override
  String get learningJourneySeerahMakkahTakeaway3 =>
      'Early believers were trained through pressure and sincerity.';

  @override
  String get learningJourneySeerahMakkahReflection =>
      'When your beliefs feel tested, what helps you stay gentle and steady instead of reactive?';

  @override
  String get learningJourneySeerahHijrahTitle => 'Hijrah';

  @override
  String get learningJourneySeerahHijrahIntro =>
      'Hijrah was a move for worship, safety, and the future of the Muslim community.';

  @override
  String get learningJourneySeerahHijrahSection1Title => 'What hijrah required';

  @override
  String get learningJourneySeerahHijrahSection1Body =>
      'The migration to Madinah required planning, secrecy, courage, sacrifice, and complete reliance on Allah. It was not escape for comfort, but movement for faith.';

  @override
  String get learningJourneySeerahHijrahSection2Title =>
      'Trust and planning together';

  @override
  String get learningJourneySeerahHijrahSection2Body =>
      'Hijrah teaches that tawakkul is not passive. The Prophet ﷺ trusted Allah completely while still taking wise practical means.';

  @override
  String get learningJourneySeerahHijrahBullet1 =>
      'Trust in Allah includes responsible action.';

  @override
  String get learningJourneySeerahHijrahBullet2 =>
      'Leaving something for Allah can become a mercy.';

  @override
  String get learningJourneySeerahHijrahBullet3 =>
      'Major transitions can open entirely new doors of good.';

  @override
  String get learningJourneySeerahHijrahTakeaway1 =>
      'Hijrah joined courage with careful preparation.';

  @override
  String get learningJourneySeerahHijrahTakeaway2 =>
      'Faithfulness sometimes requires hard transitions.';

  @override
  String get learningJourneySeerahHijrahTakeaway3 =>
      'Tawakkul means trust plus effort.';

  @override
  String get learningJourneySeerahHijrahReflection =>
      'What important decision in your life needs both better planning and deeper trust in Allah?';

  @override
  String get learningJourneySeerahMadinahTitle => 'Madinah Society';

  @override
  String get learningJourneySeerahMadinahIntro =>
      'In Madinah, Islam was lived as worship, community, justice, brotherhood, and responsibility.';

  @override
  String get learningJourneySeerahMadinahSection1Title =>
      'What was built in Madinah';

  @override
  String get learningJourneySeerahMadinahSection1Body =>
      'The Prophet ﷺ established a masjid-centered community with worship, learning, brotherhood, agreements, teaching, family life, and leadership during peace and difficulty.';

  @override
  String get learningJourneySeerahMadinahSection2Title =>
      'Why this stage matters';

  @override
  String get learningJourneySeerahMadinahSection2Body =>
      'The Madinan period shows that Islam is not only personal belief. It also shapes society, relationships, public responsibility, and mutual care.';

  @override
  String get learningJourneySeerahMadinahBullet1 =>
      'Islam builds individuals and community together.';

  @override
  String get learningJourneySeerahMadinahBullet2 =>
      'The masjid is a center of worship, learning, and service.';

  @override
  String get learningJourneySeerahMadinahBullet3 =>
      'Brotherhood and justice are part of lived faith.';

  @override
  String get learningJourneySeerahMadinahTakeaway1 =>
      'Madinah shows Islam lived collectively, not privately alone.';

  @override
  String get learningJourneySeerahMadinahTakeaway2 =>
      'Community life is part of Islamic growth.';

  @override
  String get learningJourneySeerahMadinahTakeaway3 =>
      'Worship and public responsibility belong together.';

  @override
  String get learningJourneySeerahMadinahReflection =>
      'How can your worship become more connected to service, relationships, and community life?';

  @override
  String get learningJourneySeerahLeadershipTitle => 'Leadership and Character';

  @override
  String get learningJourneySeerahLeadershipIntro =>
      'The Prophet ﷺ led through mercy, truth, patience, courage, and concern for people.';

  @override
  String get learningJourneySeerahLeadershipSection1Title =>
      'What prophetic leadership looked like';

  @override
  String get learningJourneySeerahLeadershipSection1Body =>
      'He ﷺ listened, forgave, consulted, showed courage when needed, and remained gentle with people while firm on truth. His leadership never became self-promotion.';

  @override
  String get learningJourneySeerahLeadershipSection2Title =>
      'Character as leadership';

  @override
  String get learningJourneySeerahLeadershipSection2Body =>
      'Mercy, patience, and trustworthiness were not separate from his leadership. They were the very way he led.';

  @override
  String get learningJourneySeerahLeadershipBullet1 =>
      'Mercy strengthens leadership rather than weakening it.';

  @override
  String get learningJourneySeerahLeadershipBullet2 =>
      'Consultation and patience are prophetic habits.';

  @override
  String get learningJourneySeerahLeadershipBullet3 =>
      'Character gives da‘wah its credibility.';

  @override
  String get learningJourneySeerahLeadershipTakeaway1 =>
      'Prophetic leadership is worshipful, not ego-driven.';

  @override
  String get learningJourneySeerahLeadershipTakeaway2 =>
      'Character and influence cannot be separated.';

  @override
  String get learningJourneySeerahLeadershipTakeaway3 =>
      'Mercy and firmness both have their proper place.';

  @override
  String get learningJourneySeerahLeadershipReflection =>
      'Which prophetic quality would most improve the way you influence family, friends, or colleagues?';

  @override
  String get learningJourneySeerahFinalSermonTitle => 'Final Sermon';

  @override
  String get learningJourneySeerahFinalSermonIntro =>
      'The Farewell Sermon gathered major principles of dignity, justice, trust, and faithfulness near the end of the Prophet’s mission.';

  @override
  String get learningJourneySeerahFinalSermonSection1Title =>
      'Key themes of the sermon';

  @override
  String get learningJourneySeerahFinalSermonSection1Body =>
      'The Prophet ﷺ emphasized the sanctity of life, wealth, and honor, the rights people owe one another, and the obligation to hold firmly to divine guidance.';

  @override
  String get learningJourneySeerahFinalSermonSection2Title =>
      'Why it remains urgent';

  @override
  String get learningJourneySeerahFinalSermonSection2Body =>
      'The Farewell Sermon gives a closing frame for the Seerah: worship Allah, honor people, protect trust, and remain faithful to revelation.';

  @override
  String get learningJourneySeerahFinalSermonBullet1 =>
      'Human dignity and trust are sacred in Islam.';

  @override
  String get learningJourneySeerahFinalSermonBullet2 =>
      'The Prophetic mission joined worship with justice and responsibility.';

  @override
  String get learningJourneySeerahFinalSermonBullet3 =>
      'Guidance must remain central after the Prophet ﷺ has passed on.';

  @override
  String get learningJourneySeerahFinalSermonTakeaway1 =>
      'The Final Sermon summarizes core prophetic values.';

  @override
  String get learningJourneySeerahFinalSermonTakeaway2 =>
      'Justice and mercy are public Islamic responsibilities.';

  @override
  String get learningJourneySeerahFinalSermonTakeaway3 =>
      'The Seerah ends by pointing believers back to revelation.';

  @override
  String get learningJourneySeerahFinalSermonReflection =>
      'Which principle from the Final Sermon feels most urgent for the time you live in?';

  @override
  String get learningJourneyDhikrWhatIsTitle => 'What Is Dhikr?';

  @override
  String get learningJourneyDhikrWhatIsIntro =>
      'Dhikr is remembering Allah with the heart, tongue, and life through praise, gratitude, repentance, and returning to Him often.';

  @override
  String get learningJourneyDhikrWhatIsSection1Title =>
      'A simple understanding';

  @override
  String get learningJourneyDhikrWhatIsSection1Body =>
      'Dhikr is not only repeating words. It is keeping Allah present in awareness through truthful phrases that soften the heart and direct the day.';

  @override
  String get learningJourneyDhikrWhatIsSection2Title => 'How to begin a habit';

  @override
  String get learningJourneyDhikrWhatIsSection2Body =>
      'Begin with a few short remembrances that you understand and can keep consistently. Small steady dhikr is better than overload that disappears.';

  @override
  String get learningJourneyDhikrWhatIsBullet1 =>
      'Choose short authentic phrases first.';

  @override
  String get learningJourneyDhikrWhatIsBullet2 =>
      'Attach remembrance to existing parts of your day.';

  @override
  String get learningJourneyDhikrWhatIsBullet3 =>
      'Understanding meaning keeps dhikr sincere.';

  @override
  String get learningJourneyDhikrWhatIsTakeaway1 =>
      'Dhikr is remembrance with meaning, not empty repetition.';

  @override
  String get learningJourneyDhikrWhatIsTakeaway2 =>
      'Consistency matters more than size at the beginning.';

  @override
  String get learningJourneyDhikrWhatIsTakeaway3 =>
      'The heart becomes calmer when Allah is remembered often.';

  @override
  String get learningJourneyDhikrWhatIsReflection =>
      'Which daily moment could most easily become a steady remembrance anchor for you?';

  @override
  String get learningJourneyDhikrMorningTitle => 'Morning Adhkar';

  @override
  String get learningJourneyDhikrMorningIntro =>
      'Morning adhkar begin the day with dependence on Allah, gratitude, and spiritual protection.';

  @override
  String get learningJourneyDhikrMorningSection1Title => 'When to say them';

  @override
  String get learningJourneyDhikrMorningSection1Body =>
      'Morning adhkar are best read after Fajr or in the early part of the day. A beginner can start with one or two authentic remembrances and keep them steady.';

  @override
  String get learningJourneyDhikrMorningSection2Title => 'Building the habit';

  @override
  String get learningJourneyDhikrMorningSection2Body =>
      'Keep the morning set small at first. Tie it to a clear moment such as after prayer, before leaving the house, or before opening your phone.';

  @override
  String get learningJourneyDhikrMorningBullet1 =>
      'Begin with a short authentic opening remembrance.';

  @override
  String get learningJourneyDhikrMorningBullet2 =>
      'Use the same moment each day so the habit becomes easier.';

  @override
  String get learningJourneyDhikrMorningBullet3 =>
      'Read with understanding, not rush.';

  @override
  String get learningJourneyDhikrMorningTakeaway1 =>
      'Morning adhkar set the tone of the day around Allah.';

  @override
  String get learningJourneyDhikrMorningTakeaway2 =>
      'A short protected routine is better than an abandoned long list.';

  @override
  String get learningJourneyDhikrMorningTakeaway3 =>
      'The day begins more calmly when remembrance comes before distraction.';

  @override
  String get learningJourneyDhikrMorningReflection =>
      'What would change in your mornings if remembrance came before hurry?';

  @override
  String get learningJourneyDhikrMorningInvocationTitle =>
      'Morning opening remembrance';

  @override
  String get learningJourneyDhikrMorningInvocationMeaning =>
      'O Allah, by You we enter the morning, by You we enter the evening, by You we live, by You we die, and to You is the resurrection.';

  @override
  String get learningJourneyDhikrMorningInvocationContext =>
      'Read in the morning to begin the day with trust in Allah.';

  @override
  String get learningJourneyDhikrEveningTitle => 'Evening Adhkar';

  @override
  String get learningJourneyDhikrEveningIntro =>
      'Evening adhkar close the day with reliance on Allah, gratitude, and calm before night.';

  @override
  String get learningJourneyDhikrEveningSection1Title => 'When to say them';

  @override
  String get learningJourneyDhikrEveningSection1Body =>
      'Evening adhkar are read after Asr or around sunset. They help the heart leave the noise of the day and return to Allah before sleep.';

  @override
  String get learningJourneyDhikrEveningSection2Title => 'How they help';

  @override
  String get learningJourneyDhikrEveningSection2Body =>
      'A short evening routine creates spiritual closure. It is a gentle way to end the day with remembrance instead of heaviness or heedlessness.';

  @override
  String get learningJourneyDhikrEveningBullet1 =>
      'Choose one or two evening remembrances first.';

  @override
  String get learningJourneyDhikrEveningBullet2 =>
      'Keep the routine light enough to survive tired days.';

  @override
  String get learningJourneyDhikrEveningBullet3 =>
      'Treat the evening set as a return, not a burden.';

  @override
  String get learningJourneyDhikrEveningTakeaway1 =>
      'Evening adhkar settle the heart before night.';

  @override
  String get learningJourneyDhikrEveningTakeaway2 =>
      'A short evening habit can be built gradually.';

  @override
  String get learningJourneyDhikrEveningTakeaway3 =>
      'Closing the day with dhikr changes how you carry its weight.';

  @override
  String get learningJourneyDhikrEveningReflection =>
      'What usually fills the end of your day, and how can remembrance reclaim part of it?';

  @override
  String get learningJourneyDhikrEveningInvocationTitle =>
      'Evening opening remembrance';

  @override
  String get learningJourneyDhikrEveningInvocationMeaning =>
      'O Allah, by You we enter the evening, by You we enter the morning, by You we live, by You we die, and to You is the final return.';

  @override
  String get learningJourneyDhikrEveningInvocationContext =>
      'Read in the evening to close the day with remembrance.';

  @override
  String get learningJourneyDhikrAfterSalahTitle => 'After Salah Dhikr';

  @override
  String get learningJourneyDhikrAfterSalahIntro =>
      'After each prayer, a simple set of adhkar helps protect the prayer and extend its effect into the rest of the day.';

  @override
  String get learningJourneyDhikrAfterSalahSection1Title =>
      'Why post-prayer dhikr matters';

  @override
  String get learningJourneyDhikrAfterSalahSection1Body =>
      'Because salah already gathers the heart, the moments after salam are one of the easiest places to build a stable dhikr habit.';

  @override
  String get learningJourneyDhikrAfterSalahSection2Title =>
      'How to keep it steady';

  @override
  String get learningJourneyDhikrAfterSalahSection2Body =>
      'Start after one prayer each day if needed. Keep the rhythm calm and attentive instead of turning it into a rushed formula.';

  @override
  String get learningJourneyDhikrAfterSalahBullet1 =>
      'Choose one prayer if all five feel too much at first.';

  @override
  String get learningJourneyDhikrAfterSalahBullet2 =>
      'Understand the praise and glorification you are saying.';

  @override
  String get learningJourneyDhikrAfterSalahBullet3 =>
      'Let the dhikr extend the calm of salah.';

  @override
  String get learningJourneyDhikrAfterSalahTakeaway1 =>
      'Post-salah dhikr is one of the easiest daily anchors for remembrance.';

  @override
  String get learningJourneyDhikrAfterSalahTakeaway2 =>
      'Short formulas can carry deep meaning when done with attention.';

  @override
  String get learningJourneyDhikrAfterSalahTakeaway3 =>
      'Prayer becomes more continuous when remembrance follows it.';

  @override
  String get learningJourneyDhikrAfterSalahReflection =>
      'Which prayer is the easiest place for you to begin a stable after-salah dhikr habit?';

  @override
  String get learningJourneyDhikrAfterSalahInvocationTitle =>
      'Post-prayer glorification';

  @override
  String get learningJourneyDhikrAfterSalahInvocationMeaning =>
      'Glory be to Allah, praise be to Allah, Allah is the Greatest.';

  @override
  String get learningJourneyDhikrAfterSalahInvocationContext =>
      'A simple dhikr set read after salah.';

  @override
  String get learningJourneyDhikrRoutineTitle => 'Simple Daily Routine';

  @override
  String get learningJourneyDhikrRoutineIntro =>
      'A beginner dhikr routine should be small, clear, and sustainable.';

  @override
  String get learningJourneyDhikrRoutineSection1Title => 'A workable routine';

  @override
  String get learningJourneyDhikrRoutineSection1Body =>
      'Choose three anchor moments: morning, after one prayer, and before sleep. Attach one short remembrance to each moment and keep it for a week before adding more.';

  @override
  String get learningJourneyDhikrRoutineSection2Title =>
      'What keeps the routine alive';

  @override
  String get learningJourneyDhikrRoutineSection2Body =>
      'Clarity matters more than intensity. A small routine that survives real life will benefit you more than a large routine that collapses quickly.';

  @override
  String get learningJourneyDhikrRoutineBullet1 =>
      'Morning: one opening remembrance.';

  @override
  String get learningJourneyDhikrRoutineBullet2 =>
      'After salah: one short fixed set.';

  @override
  String get learningJourneyDhikrRoutineBullet3 =>
      'Night: one closing remembrance before sleep.';

  @override
  String get learningJourneyDhikrRoutineTakeaway1 =>
      'Tie dhikr to moments that already exist in your day.';

  @override
  String get learningJourneyDhikrRoutineTakeaway2 =>
      'Build slowly enough that the habit survives difficulty.';

  @override
  String get learningJourneyDhikrRoutineTakeaway3 =>
      'Steady remembrance is formed by clarity, not pressure.';

  @override
  String get learningJourneyDhikrRoutineReflection =>
      'Which three moments could become your personal remembrance anchors this week?';

  @override
  String get learningJourneyDhikrIstighfarTitle => 'Istighfar';

  @override
  String get learningJourneyDhikrIstighfarIntro =>
      'Istighfar is seeking Allah’s forgiveness with humility, honesty, and hope in His mercy.';

  @override
  String get learningJourneyDhikrIstighfarSection1Title =>
      'Why istighfar matters daily';

  @override
  String get learningJourneyDhikrIstighfarSection1Body =>
      'A believer returns often to Allah, not only after major mistakes. Istighfar softens pride, cleans the heart, and keeps the servant close to mercy.';

  @override
  String get learningJourneyDhikrIstighfarSection2Title =>
      'How to build the habit';

  @override
  String get learningJourneyDhikrIstighfarSection2Body =>
      'Use istighfar after a sin, after heedlessness, after prayer, or whenever the heart feels dry and needs to return to Allah.';

  @override
  String get learningJourneyDhikrIstighfarBullet1 =>
      'Repent quickly instead of delaying return.';

  @override
  String get learningJourneyDhikrIstighfarBullet2 =>
      'Treat forgiveness as a daily need, not a rare emergency.';

  @override
  String get learningJourneyDhikrIstighfarBullet3 =>
      'Say it with awareness of both weakness and hope.';

  @override
  String get learningJourneyDhikrIstighfarTakeaway1 =>
      'Istighfar is a daily spiritual need.';

  @override
  String get learningJourneyDhikrIstighfarTakeaway2 =>
      'Repentance joins honesty about sin with hope in mercy.';

  @override
  String get learningJourneyDhikrIstighfarTakeaway3 =>
      'Short sincere repentance is better than thoughtless repetition.';

  @override
  String get learningJourneyDhikrIstighfarReflection =>
      'What would change if repentance became one of your daily habits instead of a rare reaction?';

  @override
  String get learningJourneyDhikrIstighfarInvocationTitle => 'Simple istighfar';

  @override
  String get learningJourneyDhikrIstighfarInvocationMeaning =>
      'I seek Allah’s forgiveness and I turn to Him in repentance.';

  @override
  String get learningJourneyDhikrIstighfarInvocationContext =>
      'A short daily formula of repentance and return.';

  @override
  String get learningJourneyDhikrSalawatTitle => 'Salawat';

  @override
  String get learningJourneyDhikrSalawatIntro =>
      'Sending prayers upon the Prophet ﷺ is an act of love, gratitude, and obedience to Allah.';

  @override
  String get learningJourneyDhikrSalawatSection1Title => 'Why salawat matters';

  @override
  String get learningJourneyDhikrSalawatSection1Body =>
      'Salawat keeps the heart connected to the Messenger ﷺ and reminds you that your path to Allah is shaped by following him with love and respect.';

  @override
  String get learningJourneyDhikrSalawatSection2Title =>
      'How to make it steady';

  @override
  String get learningJourneyDhikrSalawatSection2Body =>
      'Use a short form daily, after hearing the Prophet’s name ﷺ, on Fridays, and in quiet moments when you want to renew love for his guidance.';

  @override
  String get learningJourneyDhikrSalawatBullet1 =>
      'Keep a short form ready for frequent repetition.';

  @override
  String get learningJourneyDhikrSalawatBullet2 =>
      'Let salawat renew love, not become empty habit.';

  @override
  String get learningJourneyDhikrSalawatBullet3 =>
      'Use it often enough that gratitude becomes natural.';

  @override
  String get learningJourneyDhikrSalawatTakeaway1 =>
      'Salawat grows love for the Prophet ﷺ in daily life.';

  @override
  String get learningJourneyDhikrSalawatTakeaway2 =>
      'A short form used often is better than a long form rarely used.';

  @override
  String get learningJourneyDhikrSalawatTakeaway3 =>
      'This remembrance connects worship to gratitude for guidance.';

  @override
  String get learningJourneyDhikrSalawatReflection =>
      'How can you make salawat part of your day in a way that feels sincere and frequent?';

  @override
  String get learningJourneyDhikrSalawatInvocationTitle => 'Short salawat';

  @override
  String get learningJourneyDhikrSalawatInvocationMeaning =>
      'O Allah, send prayers upon Muhammad.';

  @override
  String get learningJourneyDhikrSalawatInvocationContext =>
      'A short form for daily remembrance and frequent salawat.';

  @override
  String get learningJourneyFaithBooksTitle => 'Books';

  @override
  String get learningJourneyFaithBooksIntro =>
      'Allah sent revelation for guidance, mercy, and truth. Muslims believe in the revealed books and hold the Qur’an as the final preserved revelation.';

  @override
  String get learningJourneyFaithBooksSection1Title => 'Why revelation matters';

  @override
  String get learningJourneyFaithBooksSection1Body =>
      'Allah did not leave humanity without guidance. He sent scriptures and messages so people could know truth, worship correctly, and live with justice and mercy.';

  @override
  String get learningJourneyFaithBooksSection2Title => 'How the Qur’an fits';

  @override
  String get learningJourneyFaithBooksSection2Body =>
      'Belief in the books deepens gratitude for the Qur’an. It is the final revelation, preserved and sufficient as guidance for the Ummah.';

  @override
  String get learningJourneyFaithBooksBullet1 =>
      'Revelation is a mercy from Allah.';

  @override
  String get learningJourneyFaithBooksBullet2 =>
      'The Qur’an confirms truth and stands as final guidance.';

  @override
  String get learningJourneyFaithBooksBullet3 =>
      'Belief in the books makes the Qur’an feel even more precious.';

  @override
  String get learningJourneyFaithBooksTakeaway1 =>
      'Guidance is one of Allah’s great mercies to humanity.';

  @override
  String get learningJourneyFaithBooksTakeaway2 =>
      'The Qur’an holds a unique place as final revelation.';

  @override
  String get learningJourneyFaithBooksTakeaway3 =>
      'A believer should receive the Qur’an with gratitude and seriousness.';

  @override
  String get learningJourneyFaithBooksReflection =>
      'How would you treat the Qur’an differently if you saw it as direct guidance from Allah to you?';

  @override
  String get learningJourneyFaithProphetsTitle => 'Prophets';

  @override
  String get learningJourneyFaithProphetsIntro =>
      'Allah sent prophets to teach truth, model obedience, and call people back to worshipping Him alone.';

  @override
  String get learningJourneyFaithProphetsSection1Title =>
      'Why Allah sent prophets';

  @override
  String get learningJourneyFaithProphetsSection1Body =>
      'Prophets were chosen by Allah to deliver His message, teach His worship, and model what obedience looks like in real life.';

  @override
  String get learningJourneyFaithProphetsSection2Title =>
      'How prophets shape faith';

  @override
  String get learningJourneyFaithProphetsSection2Body =>
      'Their stories teach patience, trust, courage, mercy, repentance, and steadfastness. Belief becomes easier to live when it is seen in prophetic examples.';

  @override
  String get learningJourneyFaithProphetsBullet1 =>
      'Prophets carry revelation and model obedience.';

  @override
  String get learningJourneyFaithProphetsBullet2 =>
      'Their stories teach faith through real human examples.';

  @override
  String get learningJourneyFaithProphetsBullet3 =>
      'Love and respect for the prophets are part of faith.';

  @override
  String get learningJourneyFaithProphetsTakeaway1 =>
      'Prophets connect revelation to lived example.';

  @override
  String get learningJourneyFaithProphetsTakeaway2 =>
      'Their stories teach both belief and character.';

  @override
  String get learningJourneyFaithProphetsTakeaway3 =>
      'Respect for all prophets is part of Muslim faith.';

  @override
  String get learningJourneyFaithProphetsReflection =>
      'Which prophetic quality feels most necessary for your own growth right now?';

  @override
  String get learningJourneyFaithJudgmentTitle => 'Day of Judgment';

  @override
  String get learningJourneyFaithJudgmentIntro =>
      'Muslims believe that life has an end, people will be raised, and every soul will stand before Allah.';

  @override
  String get learningJourneyFaithJudgmentSection1Title =>
      'Why the Last Day matters';

  @override
  String get learningJourneyFaithJudgmentSection1Body =>
      'Belief in the Hereafter means life is meaningful, deeds matter, and justice belongs fully to Allah even when the world feels unfair.';

  @override
  String get learningJourneyFaithJudgmentSection2Title =>
      'How it changes daily life';

  @override
  String get learningJourneyFaithJudgmentSection2Body =>
      'Remembering the Last Day encourages honesty, repentance, patience, and responsibility even when nobody else is watching.';

  @override
  String get learningJourneyFaithJudgmentBullet1 =>
      'The Hereafter gives seriousness to daily choices.';

  @override
  String get learningJourneyFaithJudgmentBullet2 =>
      'Allah’s judgment is perfect and just.';

  @override
  String get learningJourneyFaithJudgmentBullet3 =>
      'Remembering the Last Day encourages repentance and integrity.';

  @override
  String get learningJourneyFaithJudgmentTakeaway1 =>
      'The Last Day gives life moral weight and hope.';

  @override
  String get learningJourneyFaithJudgmentTakeaway2 =>
      'Justice ultimately belongs to Allah.';

  @override
  String get learningJourneyFaithJudgmentTakeaway3 =>
      'Accountability changes how a believer acts in private and public.';

  @override
  String get learningJourneyFaithJudgmentReflection =>
      'What daily habit would change if your meeting with Allah felt more present in your mind?';

  @override
  String get learningJourneyFaithQadrTitle => 'Qadr';

  @override
  String get learningJourneyFaithQadrIntro =>
      'Qadr means Allah knows, writes, and wills all things with perfect wisdom, while people still make real choices and remain responsible.';

  @override
  String get learningJourneyFaithQadrSection1Title => 'A simple understanding';

  @override
  String get learningJourneyFaithQadrSection1Body =>
      'Nothing escapes Allah’s knowledge or power. At the same time, a believer is still commanded to choose obedience, make effort, and repent when they fall short.';

  @override
  String get learningJourneyFaithQadrSection2Title =>
      'A common misunderstanding';

  @override
  String get learningJourneyFaithQadrSection2Body =>
      'Qadr is not an excuse for laziness or sin. Trust in Allah’s decree should increase patience and effort, not passivity.';

  @override
  String get learningJourneyFaithQadrBullet1 =>
      'Allah’s decree is wise even when you do not understand it.';

  @override
  String get learningJourneyFaithQadrBullet2 =>
      'Trust in qadr brings calm without removing effort.';

  @override
  String get learningJourneyFaithQadrBullet3 =>
      'Belief in qadr should increase tawakkul, not passivity.';

  @override
  String get learningJourneyFaithQadrTakeaway1 =>
      'Allah’s decree is perfect and wise.';

  @override
  String get learningJourneyFaithQadrTakeaway2 =>
      'Human effort and divine decree are not opposites.';

  @override
  String get learningJourneyFaithQadrTakeaway3 =>
      'A believer trusts Allah while still acting responsibly.';

  @override
  String get learningJourneyFaithQadrReflection =>
      'Where do you most need trust in Allah’s decree while still doing your part well?';

  @override
  String get learningJourneyWordsTopTitle => 'Open top Qur’anic words';

  @override
  String get learningJourneyWordsTopIntro =>
      'Recurring Qur’anic words are one of the fastest ways to increase familiarity and comprehension.';

  @override
  String get learningJourneyWordsTopSection1Title => 'Why recurring words help';

  @override
  String get learningJourneyWordsTopSection1Body =>
      'When you keep meeting the same words, the Qur’an starts feeling less distant. A small vocabulary can unlock many ayat more than people expect.';

  @override
  String get learningJourneyWordsTopSection2Title => 'How to begin well';

  @override
  String get learningJourneyWordsTopSection2Body =>
      'Choose a small cluster, repeat it often, and connect each word to one simple meaning instead of trying to collect too many terms at once.';

  @override
  String get learningJourneyWordsTopBullet1 =>
      'Start with small repeated groups of words.';

  @override
  String get learningJourneyWordsTopBullet2 =>
      'Use repetition to recognize words in real verses.';

  @override
  String get learningJourneyWordsTopBullet3 =>
      'Let frequency guide what you learn first.';

  @override
  String get learningJourneyWordsTopTakeaway1 =>
      'Recurring words create fast progress in comprehension.';

  @override
  String get learningJourneyWordsTopTakeaway2 =>
      'Small focused sets are easier to retain.';

  @override
  String get learningJourneyWordsTopTakeaway3 =>
      'Vocabulary should support real Qur’an reading, not remain isolated lists.';

  @override
  String get learningJourneyWordsTopReflection =>
      'What kind of word set would feel easiest for you to revisit consistently?';

  @override
  String get learningJourneyWordsReviewTitle => 'Review and retain';

  @override
  String get learningJourneyWordsReviewIntro =>
      'Vocabulary only becomes useful when it is reviewed often enough to stay active in memory.';

  @override
  String get learningJourneyWordsReviewSection1Title => 'Why review matters';

  @override
  String get learningJourneyWordsReviewSection1Body =>
      'Words fade quickly when they are only seen once. Review brings them back until recognition feels natural rather than forced.';

  @override
  String get learningJourneyWordsReviewSection2Title => 'A calm memory loop';

  @override
  String get learningJourneyWordsReviewSection2Body =>
      'Use short frequent review sessions instead of long exhausting ones. Recognition grows through return and repetition.';

  @override
  String get learningJourneyWordsReviewBullet1 =>
      'Review a little, but review often.';

  @override
  String get learningJourneyWordsReviewBullet2 =>
      'Return to weak words before adding many new ones.';

  @override
  String get learningJourneyWordsReviewBullet3 =>
      'Tie review to a moment you already use for learning.';

  @override
  String get learningJourneyWordsReviewTakeaway1 =>
      'Retention grows through steady return.';

  @override
  String get learningJourneyWordsReviewTakeaway2 =>
      'A calm review loop is better than overloaded memorization.';

  @override
  String get learningJourneyWordsReviewTakeaway3 =>
      'Weak areas become easier when revisited without pressure.';

  @override
  String get learningJourneyWordsReviewReflection =>
      'Which review habit would make your Qur’anic vocabulary more stable this month?';

  @override
  String get learningJourneyWordsPatternsTitle => 'Patterns and meaning groups';

  @override
  String get learningJourneyWordsPatternsIntro =>
      'Words become easier to remember when you notice families, themes, and repeated meaning clusters instead of isolated entries.';

  @override
  String get learningJourneyWordsPatternsSection1Title => 'Grouping by meaning';

  @override
  String get learningJourneyWordsPatternsSection1Body =>
      'Try collecting words around worship, mercy, guidance, gratitude, or the Hereafter. Grouping by theme helps memory attach words to meaning.';

  @override
  String get learningJourneyWordsPatternsSection2Title =>
      'Reinforcement through patterns';

  @override
  String get learningJourneyWordsPatternsSection2Body =>
      'Notice when related words keep returning in similar contexts. That repetition is a memory tool, not an accident.';

  @override
  String get learningJourneyWordsPatternsBullet1 =>
      'Group words by theme instead of only by list order.';

  @override
  String get learningJourneyWordsPatternsBullet2 =>
      'Reconnect reviewed words to real verses when possible.';

  @override
  String get learningJourneyWordsPatternsBullet3 =>
      'Use repeated patterns to reinforce memory gently.';

  @override
  String get learningJourneyWordsPatternsTakeaway1 =>
      'Meaning groups make vocabulary easier to retain.';

  @override
  String get learningJourneyWordsPatternsTakeaway2 =>
      'Patterns help the Qur’an feel more connected.';

  @override
  String get learningJourneyWordsPatternsTakeaway3 =>
      'Memory grows when words are linked to themes and contexts.';

  @override
  String get learningJourneyWordsPatternsReflection =>
      'Which theme would you like to build a small Qur’anic word group around first?';

  @override
  String get learningJourneyLessonSectionContinueWith => 'Continue with';

  @override
  String get learningJourneyLessonSectionRelatedJourneys => 'Related journeys';

  @override
  String get learningJourneyLessonSectionActionStep => 'Small action step';

  @override
  String get learningJourneyLessonSectionReviewSuggestion =>
      'Review suggestion';

  @override
  String get learningJourneyDetailCompletionTitle => 'Journey complete';

  @override
  String get learningJourneyDetailCompletionSubtitle =>
      'You have reached the end of this journey. Revisit the final stage, review what stayed with you, and choose one next step to carry into daily life.';

  @override
  String learningJourneyDetailActionNextJourney(String journeyTitle) {
    return 'Next journey: $journeyTitle';
  }

  @override
  String get learningJourneyDetailActionReviewJourney => 'Review Journey';

  @override
  String get learningJourneyBeautifulCharacterTitle => 'Beautiful Character';

  @override
  String get learningJourneyBeautifulCharacterSubtitle =>
      'Grow through the qualities that beautify faith and daily life.';

  @override
  String get learningJourneyBeautifulCharacterDescription =>
      'Follow a guided journey through sincerity, patience, gratitude, humility, forgiveness, self-control, kindness, and final reflection.';

  @override
  String get learningJourneyBeautifulCharacterOutcome1 =>
      'Understand core qualities of beautiful Islamic character';

  @override
  String get learningJourneyBeautifulCharacterOutcome2 =>
      'Connect character to worship, relationships, and daily choices';

  @override
  String get learningJourneyBeautifulCharacterOutcome3 =>
      'Leave with one clear next step for personal growth';

  @override
  String get learningJourneyBeautifulCharacterWhyThisMatters =>
      'Knowledge becomes lived Islam when it shapes character, speech, reactions, and service to others.';

  @override
  String get learningJourneyCharacterIkhlasStageTitle => 'Sincerity';

  @override
  String get learningJourneyCharacterIkhlasStageSummary =>
      'Begin with ikhlas so your actions are rooted in Allah alone.';

  @override
  String get learningJourneyCharacterSabrStageTitle => 'Patience';

  @override
  String get learningJourneyCharacterSabrStageSummary =>
      'Learn how sabr steadies faith through hardship, delay, and discipline.';

  @override
  String get learningJourneyCharacterShukrStageTitle => 'Gratitude';

  @override
  String get learningJourneyCharacterShukrStageSummary =>
      'See gratitude as worship of the heart, tongue, and daily choices.';

  @override
  String get learningJourneyCharacterHumilityStageTitle => 'Humility';

  @override
  String get learningJourneyCharacterHumilityStageSummary =>
      'Practice a humble heart while still standing firm on truth.';

  @override
  String get learningJourneyCharacterForgivenessStageTitle => 'Forgiveness';

  @override
  String get learningJourneyCharacterForgivenessStageSummary =>
      'Learn when forgiveness heals the heart and restores dignity.';

  @override
  String get learningJourneyCharacterAngerStageTitle => 'Controlling anger';

  @override
  String get learningJourneyCharacterAngerStageSummary =>
      'Train yourself to pause, restrain anger, and respond with wisdom.';

  @override
  String get learningJourneyCharacterKindnessStageTitle => 'Kindness';

  @override
  String get learningJourneyCharacterKindnessStageSummary =>
      'Carry mercy into speech, service, and everyday relationships.';

  @override
  String get learningJourneyCharacterCompletionStageTitle =>
      'Completion reflection';

  @override
  String get learningJourneyCharacterCompletionStageSummary =>
      'Gather what you learned and choose one character trait to keep practicing.';

  @override
  String get learningJourneyWordsTopReviewSuggestion =>
      'Review a small word set again tomorrow, then notice those words the next time you read Qur’an.';

  @override
  String get learningJourneyWordsReviewSuggestion =>
      'Use short, frequent review instead of long sessions so recognition stays light and steady.';

  @override
  String get learningJourneyWordsPatternsActionStep =>
      'Choose one small word family to notice in your next recitation or reading session.';

  @override
  String get learningJourneyWordsPatternsReviewSuggestion =>
      'Come back tomorrow and see whether the same meanings appear again in familiar verses.';

  @override
  String get learningJourneyWisdomDailyQuoteTitle =>
      'Receive one wise reminder';

  @override
  String get learningJourneyWisdomDailyQuoteIntro =>
      'A daily wisdom item should be small enough to carry and deep enough to reopen later in the day.';

  @override
  String get learningJourneyWisdomDailyQuoteSection1Title =>
      'What Daily Wisdom gathers';

  @override
  String get learningJourneyWisdomDailyQuoteSection1Body =>
      'Daily Wisdom brings short reminders from Qur’an, Hadith, prophetic example, and reflection into one calm entry point. The goal is not volume. The goal is one truthful reminder that stays with you.';

  @override
  String get learningJourneyWisdomDailyQuoteSection2Title =>
      'How to use one item well';

  @override
  String get learningJourneyWisdomDailyQuoteSection2Body =>
      'Read slowly, keep one idea, and let it shape one decision or dua before the day moves on.';

  @override
  String get learningJourneyWisdomDailyQuoteBullet1 =>
      'Choose one line instead of trying to remember everything.';

  @override
  String get learningJourneyWisdomDailyQuoteBullet2 =>
      'Return to it once later in the day.';

  @override
  String get learningJourneyWisdomDailyQuoteBullet3 =>
      'Let it point you toward a deeper journey when you are ready.';

  @override
  String get learningJourneyWisdomDailyQuoteTakeaway1 =>
      'One small reminder can be enough for a whole day.';

  @override
  String get learningJourneyWisdomDailyQuoteTakeaway2 =>
      'Daily wisdom works best when it stays simple and consistent.';

  @override
  String get learningJourneyWisdomDailyQuoteTakeaway3 =>
      'Short reminders should lead into deeper learning, not replace it.';

  @override
  String get learningJourneyWisdomDailyQuoteReflection =>
      'What reminder do you need today more than extra information?';

  @override
  String get learningJourneyWisdomShortLessonTitle =>
      'Turn wisdom into a short lesson';

  @override
  String get learningJourneyWisdomShortLessonIntro =>
      'A brief lesson helps a daily reminder grow roots. It explains just enough to make the reminder usable.';

  @override
  String get learningJourneyWisdomShortLessonSection1Title =>
      'Consistent explanation style';

  @override
  String get learningJourneyWisdomShortLessonSection1Body =>
      'Whether the source is a hadith, a verse, a prophetic event, or a reflection prompt, the explanation should stay calm, practical, and beginner-friendly. That keeps Daily Wisdom coherent.';

  @override
  String get learningJourneyWisdomShortLessonSection2Title =>
      'Where the lesson should lead';

  @override
  String get learningJourneyWisdomShortLessonSection2Body =>
      'A short lesson should end with a next step. That next step might be a journey, a tool, a short act of worship, or a practical decision.';

  @override
  String get learningJourneyWisdomShortLessonBullet1 =>
      'Keep the explanation short enough to reread quickly.';

  @override
  String get learningJourneyWisdomShortLessonBullet2 =>
      'Tie the reminder to daily life.';

  @override
  String get learningJourneyWisdomShortLessonBullet3 =>
      'Offer one clear way to go deeper.';

  @override
  String get learningJourneyWisdomShortLessonTakeaway1 =>
      'Good daily teaching is clear, not crowded.';

  @override
  String get learningJourneyWisdomShortLessonTakeaway2 =>
      'A short lesson should help the heart and mind together.';

  @override
  String get learningJourneyWisdomShortLessonTakeaway3 =>
      'Daily Wisdom should naturally point into the wider journey system.';

  @override
  String get learningJourneyWisdomShortLessonReflection =>
      'Which kind of daily reminder opens you most: a verse, a hadith, a story, or a reflection question?';

  @override
  String get learningJourneyWisdomPracticeTitle => 'Carry wisdom into practice';

  @override
  String get learningJourneyWisdomPracticeIntro =>
      'The purpose of daily wisdom is not to collect quotes. It is to gently change speech, intention, habits, and attention.';

  @override
  String get learningJourneyWisdomPracticeSection1Title =>
      'One action is enough';

  @override
  String get learningJourneyWisdomPracticeSection1Body =>
      'Choose one small action that matches the reminder: pause before speaking, thank Allah aloud, forgive quickly, review one verse, or return to dhikr.';

  @override
  String get learningJourneyWisdomPracticeSection2Title =>
      'Build a repeatable rhythm';

  @override
  String get learningJourneyWisdomPracticeSection2Body =>
      'A stable rhythm might be: open one wisdom item, keep one sentence, act on one step, and revisit one related journey later.';

  @override
  String get learningJourneyWisdomPracticeBullet1 =>
      'Do not overload the day with too many goals.';

  @override
  String get learningJourneyWisdomPracticeBullet2 =>
      'Let repetition turn insight into habit.';

  @override
  String get learningJourneyWisdomPracticeBullet3 =>
      'Use related journeys when you want depth.';

  @override
  String get learningJourneyWisdomPracticeTakeaway1 =>
      'Wisdom becomes useful when it changes action.';

  @override
  String get learningJourneyWisdomPracticeTakeaway2 =>
      'A small repeated act is stronger than a large short-lived intention.';

  @override
  String get learningJourneyWisdomPracticeTakeaway3 =>
      'Daily Wisdom should send you back into the wider learning system.';

  @override
  String get learningJourneyWisdomPracticeReflection =>
      'What is one small action you can do today so this reminder becomes lived knowledge?';

  @override
  String get learningJourneyWisdomPracticeActionStep =>
      'Before the day ends, return to this reminder once and ask whether it changed one choice, one word, or one dua.';

  @override
  String get learningJourneyCharacterIkhlasTitle => 'Sincerity (Ikhlas)';

  @override
  String get learningJourneyCharacterIkhlasIntro =>
      'Ikhlas means doing what is right for Allah, not for showing off, praise, or control.';

  @override
  String get learningJourneyCharacterIkhlasSection1Title =>
      'What sincerity does';

  @override
  String get learningJourneyCharacterIkhlasSection1Body =>
      'Sincerity purifies actions from the inside. Two people may do the same outward deed, but the one who seeks Allah alone carries a different weight with Him.';

  @override
  String get learningJourneyCharacterIkhlasSection2Title =>
      'How sincerity appears in real life';

  @override
  String get learningJourneyCharacterIkhlasSection2Body =>
      'Ikhlas shows up when you keep doing good even if no one notices, and when you correct your intention whenever pride tries to enter.';

  @override
  String get learningJourneyCharacterIkhlasBullet1 =>
      'Renew your intention before a good deed.';

  @override
  String get learningJourneyCharacterIkhlasBullet2 =>
      'Do some good privately when possible.';

  @override
  String get learningJourneyCharacterIkhlasBullet3 =>
      'If praise reaches you, thank Allah and keep your heart steady.';

  @override
  String get learningJourneyCharacterIkhlasTakeaway1 =>
      'Sincerity begins in the heart before it appears in action.';

  @override
  String get learningJourneyCharacterIkhlasTakeaway2 =>
      'Private worship helps protect sincerity.';

  @override
  String get learningJourneyCharacterIkhlasTakeaway3 =>
      'Ikhlas needs regular renewal, not a one-time decision.';

  @override
  String get learningJourneyCharacterIkhlasReflection =>
      'Which part of your worship or service needs a quieter intention?';

  @override
  String get learningJourneyCharacterIkhlasActionStep =>
      'Choose one small act today that only Allah knows you intended for Him.';

  @override
  String get learningJourneyCharacterSabrTitle => 'Patience (Sabr)';

  @override
  String get learningJourneyCharacterSabrIntro =>
      'Sabr is not passive weakness. It is steady obedience, self-restraint, and trust in Allah through difficulty.';

  @override
  String get learningJourneyCharacterSabrSection1Title =>
      'Where patience is needed';

  @override
  String get learningJourneyCharacterSabrSection1Body =>
      'Patience is needed in hardship, in delay, in resisting sin, and in staying consistent with worship when the heart feels low.';

  @override
  String get learningJourneyCharacterSabrSection2Title =>
      'A practical form of sabr';

  @override
  String get learningJourneyCharacterSabrSection2Body =>
      'Sabr often looks ordinary: lowering your reaction, continuing a duty, waiting without complaint, and asking Allah for help before speaking or acting.';

  @override
  String get learningJourneyCharacterSabrBullet1 =>
      'Pause before reacting when frustrated.';

  @override
  String get learningJourneyCharacterSabrBullet2 =>
      'Keep one obligation steady even on difficult days.';

  @override
  String get learningJourneyCharacterSabrBullet3 =>
      'Ask Allah for help instead of collapsing into panic.';

  @override
  String get learningJourneyCharacterSabrTakeaway1 =>
      'Patience is active strength, not passivity.';

  @override
  String get learningJourneyCharacterSabrTakeaway2 =>
      'Sabr is needed in both hardship and obedience.';

  @override
  String get learningJourneyCharacterSabrTakeaway3 =>
      'Short pauses can protect you from long regret.';

  @override
  String get learningJourneyCharacterSabrReflection =>
      'Where do you most need to slow down and trust Allah more?';

  @override
  String get learningJourneyCharacterSabrActionStep =>
      'The next time you feel pressure, pause, breathe, and delay your response for a few seconds.';

  @override
  String get learningJourneyCharacterShukrTitle => 'Gratitude (Shukr)';

  @override
  String get learningJourneyCharacterShukrIntro =>
      'Shukr means recognizing blessings from Allah and responding with praise, obedience, and better use of what He gave.';

  @override
  String get learningJourneyCharacterShukrSection1Title =>
      'Gratitude is more than words';

  @override
  String get learningJourneyCharacterShukrSection1Body =>
      'Saying Alhamdulillah matters, but gratitude also includes how you use time, health, wealth, knowledge, and relationships.';

  @override
  String get learningJourneyCharacterShukrSection2Title =>
      'How gratitude grows';

  @override
  String get learningJourneyCharacterShukrSection2Body =>
      'Gratitude grows when you notice specific blessings, name them, and turn them into worship and service instead of entitlement.';

  @override
  String get learningJourneyCharacterShukrBullet1 =>
      'Name one blessing clearly instead of vaguely.';

  @override
  String get learningJourneyCharacterShukrBullet2 =>
      'Use a blessing in a way Allah loves.';

  @override
  String get learningJourneyCharacterShukrBullet3 =>
      'Do not let comfort make you forget the Giver.';

  @override
  String get learningJourneyCharacterShukrTakeaway1 =>
      'Gratitude is a response of heart, tongue, and action.';

  @override
  String get learningJourneyCharacterShukrTakeaway2 =>
      'Blessings become safer when they increase thankfulness.';

  @override
  String get learningJourneyCharacterShukrTakeaway3 =>
      'Gratitude protects the heart from constant dissatisfaction.';

  @override
  String get learningJourneyCharacterShukrReflection =>
      'Which blessing have you become too used to noticing with gratitude?';

  @override
  String get learningJourneyCharacterShukrActionStep =>
      'Thank Allah specifically for one blessing today, then use it in one good way.';

  @override
  String get learningJourneyCharacterHumilityTitle => 'Humility';

  @override
  String get learningJourneyCharacterHumilityIntro =>
      'Humility means seeing your need for Allah clearly and treating people without arrogance.';

  @override
  String get learningJourneyCharacterHumilitySection1Title =>
      'Humility and truth';

  @override
  String get learningJourneyCharacterHumilitySection1Body =>
      'Humility does not mean weakness or self-erasure. It means accepting truth, lowering pride, and refusing to treat others with superiority.';

  @override
  String get learningJourneyCharacterHumilitySection2Title =>
      'How arrogance enters';

  @override
  String get learningJourneyCharacterHumilitySection2Body =>
      'Arrogance can hide inside knowledge, talent, worship, wealth, or social standing. Humility asks: do I still listen, learn, and respect others?';

  @override
  String get learningJourneyCharacterHumilityBullet1 =>
      'Accept correction without defensiveness.';

  @override
  String get learningJourneyCharacterHumilityBullet2 =>
      'Do not measure people only by status or outward polish.';

  @override
  String get learningJourneyCharacterHumilityBullet3 =>
      'Remember that every gift is from Allah.';

  @override
  String get learningJourneyCharacterHumilityTakeaway1 =>
      'Humility protects knowledge from becoming pride.';

  @override
  String get learningJourneyCharacterHumilityTakeaway2 =>
      'A humble person can be firm without being arrogant.';

  @override
  String get learningJourneyCharacterHumilityTakeaway3 =>
      'Remembering Allah reduces self-importance.';

  @override
  String get learningJourneyCharacterHumilityReflection =>
      'Where does pride make it harder for you to listen or change?';

  @override
  String get learningJourneyCharacterHumilityActionStep =>
      'Listen carefully to one person today without preparing your answer while they speak.';

  @override
  String get learningJourneyCharacterForgivenessTitle => 'Forgiveness';

  @override
  String get learningJourneyCharacterForgivenessIntro =>
      'Forgiveness softens the heart and frees it from carrying every injury forever.';

  @override
  String get learningJourneyCharacterForgivenessSection1Title =>
      'What forgiveness is and is not';

  @override
  String get learningJourneyCharacterForgivenessSection1Body =>
      'Forgiveness is not pretending harm was good. It is letting go of the desire to keep feeding resentment when forgiveness is wise and safe.';

  @override
  String get learningJourneyCharacterForgivenessSection2Title =>
      'Why forgiveness matters';

  @override
  String get learningJourneyCharacterForgivenessSection2Body =>
      'When a person forgives for Allah, the heart becomes lighter. Forgiveness can protect you from becoming shaped by the very harm you suffered.';

  @override
  String get learningJourneyCharacterForgivenessBullet1 =>
      'Ask Allah to heal your heart before forcing yourself into words.';

  @override
  String get learningJourneyCharacterForgivenessBullet2 =>
      'Keep justice and safety in view where needed.';

  @override
  String get learningJourneyCharacterForgivenessBullet3 =>
      'Do not let resentment become your identity.';

  @override
  String get learningJourneyCharacterForgivenessTakeaway1 =>
      'Forgiveness is strongest when done for Allah.';

  @override
  String get learningJourneyCharacterForgivenessTakeaway2 =>
      'A soft heart can still keep wise boundaries.';

  @override
  String get learningJourneyCharacterForgivenessTakeaway3 =>
      'Resentment harms the one carrying it.';

  @override
  String get learningJourneyCharacterForgivenessReflection =>
      'Is there one hurt you need to place before Allah so it stops ruling your heart?';

  @override
  String get learningJourneyCharacterForgivenessActionStep =>
      'Make dua for heart-healing before you think about how to respond to an old hurt.';

  @override
  String get learningJourneyCharacterAngerTitle => 'Controlling anger';

  @override
  String get learningJourneyCharacterAngerIntro =>
      'Anger itself may come, but Islamic character teaches restraint before anger becomes words or harm.';

  @override
  String get learningJourneyCharacterAngerSection1Title =>
      'Why anger needs discipline';

  @override
  String get learningJourneyCharacterAngerSection1Body =>
      'Anger narrows judgment quickly. A single uncontrolled moment can damage worship, relationships, and trust built over years.';

  @override
  String get learningJourneyCharacterAngerSection2Title =>
      'How to respond well';

  @override
  String get learningJourneyCharacterAngerSection2Body =>
      'Step back, lower your tone, seek refuge in Allah, change posture if needed, and avoid speaking while the heart is still inflamed.';

  @override
  String get learningJourneyCharacterAngerBullet1 =>
      'Do not answer every irritation immediately.';

  @override
  String get learningJourneyCharacterAngerBullet2 =>
      'Use silence before regretful words.';

  @override
  String get learningJourneyCharacterAngerBullet3 =>
      'Return to dhikr to cool the heart.';

  @override
  String get learningJourneyCharacterAngerTakeaway1 =>
      'Strength includes restraining yourself when angry.';

  @override
  String get learningJourneyCharacterAngerTakeaway2 =>
      'Most anger mistakes happen in the first moments.';

  @override
  String get learningJourneyCharacterAngerTakeaway3 =>
      'A calmer response protects dignity for everyone involved.';

  @override
  String get learningJourneyCharacterAngerReflection =>
      'What usually happens just before your anger becomes speech?';

  @override
  String get learningJourneyCharacterAngerActionStep =>
      'Choose one reset habit now: silence, changing posture, stepping away, or saying a short dhikr.';

  @override
  String get learningJourneyCharacterKindnessTitle => 'Kindness';

  @override
  String get learningJourneyCharacterKindnessIntro =>
      'Kindness is one of the clearest signs that knowledge has reached the heart.';

  @override
  String get learningJourneyCharacterKindnessSection1Title =>
      'Kindness in ordinary life';

  @override
  String get learningJourneyCharacterKindnessSection1Body =>
      'Kindness appears in small things: gentle speech, patient listening, thoughtful timing, service, smiling, and making room for others.';

  @override
  String get learningJourneyCharacterKindnessSection2Title =>
      'Why mercy matters';

  @override
  String get learningJourneyCharacterKindnessSection2Body =>
      'Mercy makes faith visible. People often feel Islam first through a Muslim’s character before they understand its deeper teachings.';

  @override
  String get learningJourneyCharacterKindnessBullet1 =>
      'Make your speech softer without becoming unclear.';

  @override
  String get learningJourneyCharacterKindnessBullet2 =>
      'Look for one hidden need you can ease today.';

  @override
  String get learningJourneyCharacterKindnessBullet3 =>
      'Treat family and those closest to you with extra care.';

  @override
  String get learningJourneyCharacterKindnessTakeaway1 =>
      'Kindness is one of the strongest forms of dawah in everyday life.';

  @override
  String get learningJourneyCharacterKindnessTakeaway2 =>
      'Mercy belongs in speech, service, and correction.';

  @override
  String get learningJourneyCharacterKindnessTakeaway3 =>
      'Gentleness often opens hearts that force cannot reach.';

  @override
  String get learningJourneyCharacterKindnessReflection =>
      'Who in your daily life most needs gentleness from you right now?';

  @override
  String get learningJourneyCharacterKindnessActionStep =>
      'Do one small act of gentleness today for someone who usually sees you in a rushed state.';

  @override
  String get learningJourneyCharacterCompletionTitle => 'Completion reflection';

  @override
  String get learningJourneyCharacterCompletionIntro =>
      'You have reached the end of this journey. Now the task is not more information. It is steady application.';

  @override
  String get learningJourneyCharacterCompletionSection1Title =>
      'Look back honestly';

  @override
  String get learningJourneyCharacterCompletionSection1Body =>
      'Which quality came easiest? Which one exposed your weakness? Honest reflection makes future growth real.';

  @override
  String get learningJourneyCharacterCompletionSection2Title =>
      'Choose one trait to carry';

  @override
  String get learningJourneyCharacterCompletionSection2Body =>
      'Do not try to perfect everything at once. Choose one quality that most needs attention in this season of life and keep returning to it.';

  @override
  String get learningJourneyCharacterCompletionBullet1 =>
      'Choose one trait, not seven.';

  @override
  String get learningJourneyCharacterCompletionBullet2 =>
      'Attach it to one daily situation.';

  @override
  String get learningJourneyCharacterCompletionBullet3 =>
      'Revisit related journeys for reinforcement.';

  @override
  String get learningJourneyCharacterCompletionTakeaway1 =>
      'Character grows by repetition, not intensity alone.';

  @override
  String get learningJourneyCharacterCompletionTakeaway2 =>
      'Reflection helps you see where to begin again.';

  @override
  String get learningJourneyCharacterCompletionTakeaway3 =>
      'The best completion is a small ongoing change.';

  @override
  String get learningJourneyCharacterCompletionReflection =>
      'Which single character trait will you keep working on over the next week?';

  @override
  String get learningJourneyCharacterCompletionActionStep =>
      'Write down one trait and one situation where you will consciously practice it this week.';

  @override
  String get learningJourneyDhikrRoutineActionStep =>
      'Choose one dhikr for the morning, one for the evening, and one after salah so your routine stays small and sustainable.';

  @override
  String get learningJourneyHadithEssentialsTitle => 'Hadith Essentials';

  @override
  String get learningJourneyHadithEssentialsSubtitle =>
      'Start with the most foundational hadith collections and themes.';

  @override
  String get learningJourneyHadithEssentialsDescription =>
      'Use a calm beginner path that explains what hadith is, how to start, and how review strengthens understanding.';

  @override
  String get learningJourneyHadithEssentialsOutcome1 =>
      'Understand why hadith matters in daily Muslim life';

  @override
  String get learningJourneyHadithEssentialsOutcome2 =>
      'Start with foundational collections and themes';

  @override
  String get learningJourneyHadithEssentialsOutcome3 =>
      'Use review as reinforcement instead of random browsing';

  @override
  String get learningJourneyHadithEssentialsWhyThisMatters =>
      'Hadith grounds everyday practice, character, and understanding of prophetic guidance.';

  @override
  String get learningJourneySalahFoundationsTitle => 'Salah Foundations';

  @override
  String get learningJourneySalahFoundationsSubtitle =>
      'Build confidence in the structure and flow of prayer.';

  @override
  String get learningJourneySalahFoundationsDescription =>
      'Learn why salah matters, how to prepare for it, and how its words and movements work together.';

  @override
  String get learningJourneySalahFoundationsOutcome1 =>
      'Understand why salah is central to a Muslim day';

  @override
  String get learningJourneySalahFoundationsOutcome2 =>
      'Prepare for prayer with wudu, intention, and calm';

  @override
  String get learningJourneySalahFoundationsOutcome3 =>
      'Connect movements, words, meaning, and consistency';

  @override
  String get learningJourneySalahFoundationsWhyThisMatters =>
      'Salah is a daily pillar, so even a small increase in clarity changes lived practice quickly.';

  @override
  String get learningJourneyWuduJourneyTitle => 'Journey of Wudu';

  @override
  String get learningJourneyWuduJourneySubtitle =>
      'Learn the sequence, sunnah elements, and practice flow of wudu.';

  @override
  String get learningJourneyWuduJourneyDescription =>
      'Move from understanding wudu to practicing it, checking what breaks it, and avoiding common mistakes.';

  @override
  String get learningJourneyWuduJourneyOutcome1 =>
      'Understand why wudu matters before prayer';

  @override
  String get learningJourneyWuduJourneyOutcome2 =>
      'Practice the sequence with confidence';

  @override
  String get learningJourneyWuduJourneyOutcome3 =>
      'Recognize what breaks wudu and how to self-check calmly';

  @override
  String get learningJourneyWuduJourneyWhyThisMatters =>
      'Wudu is the daily gate into salah, so clarity here removes friction from worship.';

  @override
  String get learningJourneyRamadanFoundationsTitle => 'Ramadan Foundations';

  @override
  String get learningJourneyRamadanFoundationsSubtitle =>
      'A staged preparation path for fasting and Ramadan worship.';

  @override
  String get learningJourneyRamadanFoundationsDescription =>
      'Move through a simple beginner path that explains fasting, daily rhythm, spiritual goals, and common mistakes in Ramadan.';

  @override
  String get learningJourneyRamadanFoundationsOutcome1 =>
      'Understand what Ramadan is and why Muslims fast';

  @override
  String get learningJourneyRamadanFoundationsOutcome2 =>
      'Build a practical rhythm from suhoor to iftar';

  @override
  String get learningJourneyRamadanFoundationsOutcome3 =>
      'Carry Ramadan with reflection, care, and spiritual goals';

  @override
  String get learningJourneyRamadanFoundationsWhyThisMatters =>
      'Ramadan is high impact and time-bound, so it benefits from a dedicated guided preparation path.';

  @override
  String get learningJourneyArabicAlphabetTitle => 'Arabic Alphabet Journey';

  @override
  String get learningJourneyArabicAlphabetSubtitle =>
      'Start with letters, sounds, and recognition.';

  @override
  String get learningJourneyArabicAlphabetDescription =>
      'Learn the Arabic letters in calm groups, reinforce their sounds, and build a useful review habit before moving into reading.';

  @override
  String get learningJourneyArabicAlphabetOutcome1 =>
      'Recognize the Arabic letters in manageable groups';

  @override
  String get learningJourneyArabicAlphabetOutcome2 =>
      'Improve pronunciation through repetition';

  @override
  String get learningJourneyArabicAlphabetOutcome3 =>
      'Build a review habit that prepares you for reading basics';

  @override
  String get learningJourneyArabicAlphabetWhyThisMatters =>
      'Letter confidence is the first real threshold into Qur’anic Arabic and reading.';

  @override
  String get learningJourneyReadingBasicsTitle => 'Reading Basics';

  @override
  String get learningJourneyReadingBasicsSubtitle =>
      'Move from letters toward recitation and reading flow.';

  @override
  String get learningJourneyReadingBasicsDescription =>
      'Bridge the alphabet into harakat, joined letters, and calm reading checkpoints before wider recitation.';

  @override
  String get learningJourneyReadingBasicsOutcome1 =>
      'Recognize the core reading marks and how they change sound';

  @override
  String get learningJourneyReadingBasicsOutcome2 =>
      'Move from individual letters into joined reading';

  @override
  String get learningJourneyReadingBasicsOutcome3 =>
      'Use review loops before advancing into wider recitation';

  @override
  String get learningJourneyReadingBasicsWhyThisMatters =>
      'Users often need a middle layer between alphabet exposure and full recitation.';

  @override
  String get learningJourneyTriviaPathsTitle => 'Trivia Knowledge Paths';

  @override
  String get learningJourneyTriviaPathsSubtitle =>
      'Guided trivia paths that still teach in sequence.';

  @override
  String get learningJourneyTriviaPathsDescription =>
      'Use trivia as reinforcement with clear path selection, focused sessions, and guided follow-up into deeper journeys.';

  @override
  String get learningJourneyTriviaPathsOutcome1 =>
      'Choose a trivia path with a learning purpose';

  @override
  String get learningJourneyTriviaPathsOutcome2 =>
      'Use short sessions as reinforcement rather than isolated play';

  @override
  String get learningJourneyTriviaPathsOutcome3 =>
      'Return from review into related journeys for depth';

  @override
  String get learningJourneyTriviaPathsWhyThisMatters =>
      'Trivia can become a low-friction entry point into structured knowledge when it is staged well.';

  @override
  String get learningJourneyStageHadithEssentialCollectionTitle =>
      'Why hadith matters';

  @override
  String get learningJourneyStageHadithEssentialCollectionSummary =>
      'Begin with a simple frame for how hadith guides worship, character, and daily life.';

  @override
  String get learningJourneyStageHadithThemesTitle => 'Collections and themes';

  @override
  String get learningJourneyStageHadithThemesSummary =>
      'Learn how to begin with essential collections and then browse themes without overload.';

  @override
  String get learningJourneyStageHadithReviewTitle =>
      'Review and live the lesson';

  @override
  String get learningJourneyStageHadithReviewSummary =>
      'Use review as reinforcement and connect what you read to character and daily wisdom.';

  @override
  String get learningJourneyStageSalahWhyTitle => 'Why we pray';

  @override
  String get learningJourneyStageSalahWhySummary =>
      'Begin with the meaning of salah as a daily meeting with Allah and the anchor of worship.';

  @override
  String get learningJourneyStageSalahPrepareTitle => 'Prepare for prayer';

  @override
  String get learningJourneyStageSalahPrepareSummary =>
      'Learn how wudu, intention, timing, and calm prepare the heart and body for salah.';

  @override
  String get learningJourneyStageSalahMovementsTitle => 'Movements of salah';

  @override
  String get learningJourneyStageSalahMovementsSummary =>
      'Walk through the prayer posture by posture so the sequence feels calm and understandable.';

  @override
  String get learningJourneyStageSalahWordsMeaningTitle =>
      'Words, meaning, and focus';

  @override
  String get learningJourneyStageSalahWordsMeaningSummary =>
      'Connect the words of salah to meaning so attention and khushu begin to grow together.';

  @override
  String get learningJourneyStageSalahConsistencyTitle =>
      'Consistency and khushu';

  @override
  String get learningJourneyStageSalahConsistencySummary =>
      'Finish by building a realistic rhythm for protecting prayer and returning after weak days.';

  @override
  String get learningJourneyStageSalahCompletionTitle => 'Carry salah forward';

  @override
  String get learningJourneyStageSalahCompletionSummary =>
      'Finish by choosing one concrete way to protect prayer, deepen focus, and continue learning.';

  @override
  String get learningJourneyStageWuduWhyTitle => 'Why wudu matters';

  @override
  String get learningJourneyStageWuduWhySummary =>
      'Begin with wudu as preparation, purification, and readiness for salah.';

  @override
  String get learningJourneyStageWuduPracticeTitle => 'Steps and practice flow';

  @override
  String get learningJourneyStageWuduPracticeSummary =>
      'Walk through the sequence calmly and use guided practice to stabilize the order.';

  @override
  String get learningJourneyStageWuduBreaksTitle => 'What breaks wudu';

  @override
  String get learningJourneyStageWuduBreaksSummary =>
      'Learn the common states that break wudu and how to stay calm instead of confused.';

  @override
  String get learningJourneyStageWuduMistakesTitle =>
      'Common mistakes and self-check';

  @override
  String get learningJourneyStageWuduMistakesSummary =>
      'Finish with practical reminders, confidence checks, and a gentle plan for improvement.';

  @override
  String get learningJourneyStageWuduCompletionTitle =>
      'Carry wudu into worship';

  @override
  String get learningJourneyStageWuduCompletionSummary =>
      'Finish by connecting confident wudu to calmer prayer preparation and steady worship.';

  @override
  String get learningJourneyStageRamadanWhatIsTitle => 'What is Ramadan';

  @override
  String get learningJourneyStageRamadanWhatIsSummary =>
      'Begin with what Ramadan is, why it is honored, and how it becomes a month of worship and mercy.';

  @override
  String get learningJourneyStageRamadanWhyFastTitle => 'Why we fast';

  @override
  String get learningJourneyStageRamadanWhyFastSummary =>
      'Learn the purpose of fasting and how it trains taqwa, gratitude, and restraint.';

  @override
  String get learningJourneyStageRamadanSuhoorIftarTitle => 'Suhoor and iftar';

  @override
  String get learningJourneyStageRamadanSuhoorIftarSummary =>
      'Build a practical daily rhythm from pre-dawn preparation to breaking the fast with gratitude.';

  @override
  String get learningJourneyStageRamadanBreaksFastTitle =>
      'What breaks the fast';

  @override
  String get learningJourneyStageRamadanBreaksFastSummary =>
      'Learn the common things that break the fast and how to avoid anxious uncertainty.';

  @override
  String get learningJourneyStageRamadanLaylatTitle => 'Laylat al-Qadr';

  @override
  String get learningJourneyStageRamadanLaylatSummary =>
      'Understand the weight of the last nights and how to seek Laylat al-Qadr with sincerity.';

  @override
  String get learningJourneyStageRamadanSpiritualGoalsTitle =>
      'Spiritual goals';

  @override
  String get learningJourneyStageRamadanSpiritualGoalsSummary =>
      'Set simple spiritual goals so Ramadan changes more than your meal schedule.';

  @override
  String get learningJourneyStageRamadanMistakesTitle => 'Common mistakes';

  @override
  String get learningJourneyStageRamadanMistakesSummary =>
      'Finish with practical reminders that protect fasting from confusion, burnout, and distraction.';

  @override
  String get learningJourneyStageAlphabetOpenTitle => 'Meet the letters';

  @override
  String get learningJourneyStageAlphabetOpenSummary =>
      'Start with calm letter groups so recognition feels manageable from the first session.';

  @override
  String get learningJourneyStageAlphabetRepeatTitle =>
      'Repeat and hear the sounds';

  @override
  String get learningJourneyStageAlphabetRepeatSummary =>
      'Use repetition and listening to make letter sounds steadier and easier to recall.';

  @override
  String get learningJourneyStageAlphabetReviewTitle =>
      'Review and prepare for reading';

  @override
  String get learningJourneyStageAlphabetReviewSummary =>
      'Use short review loops so the alphabet stays stable before you move into harakat and words.';

  @override
  String get learningJourneyStageReadingFathahTitle => 'Fathah';

  @override
  String get learningJourneyStageReadingFathahSummary =>
      'Begin reading with the short a sound and learn how it opens the mouth gently.';

  @override
  String get learningJourneyStageReadingKasrahTitle => 'Kasrah';

  @override
  String get learningJourneyStageReadingKasrahSummary =>
      'Learn the short i sound and how it changes the feel of a letter when reading.';

  @override
  String get learningJourneyStageReadingDammahTitle => 'Dammah';

  @override
  String get learningJourneyStageReadingDammahSummary =>
      'Practice the short u sound and notice how rounded reading stays calm and precise.';

  @override
  String get learningJourneyStageReadingSukunTitle => 'Sukun';

  @override
  String get learningJourneyStageReadingSukunSummary =>
      'Understand how a resting letter sounds when there is no vowel movement attached to it.';

  @override
  String get learningJourneyStageReadingShaddahTitle => 'Shaddah';

  @override
  String get learningJourneyStageReadingShaddahSummary =>
      'Learn how doubled letters sound and how to slow down enough to pronounce them clearly.';

  @override
  String get learningJourneyStageReadingJoiningLettersTitle =>
      'Joining letters';

  @override
  String get learningJourneyStageReadingJoiningLettersSummary =>
      'Move from single sounds into joined letters and short words without rushing.';

  @override
  String get learningJourneyStageReadingCheckpointTitle =>
      'Review and checkpoint';

  @override
  String get learningJourneyStageReadingCheckpointSummary =>
      'Pause, review, and notice which reading skill is ready and which one still needs another calm pass.';

  @override
  String get learningJourneyStageTriviaPathsTitle => 'Choose a knowledge path';

  @override
  String get learningJourneyStageTriviaPathsSummary =>
      'Begin by choosing a trivia path that matches a real learning goal, not just random questions.';

  @override
  String get learningJourneyStageTriviaSessionTitle =>
      'Use a short session well';

  @override
  String get learningJourneyStageTriviaSessionSummary =>
      'Treat each trivia round as focused reinforcement and pay attention to what you miss.';

  @override
  String get learningJourneyStageTriviaReviewTitle =>
      'Review and continue learning';

  @override
  String get learningJourneyStageTriviaReviewSummary =>
      'Use weak answers as signals for what to revisit, then continue into related real journeys.';

  @override
  String get learningJourneyToolWuduGuideSubtitle =>
      'Open the full wudu guide.';

  @override
  String get learningJourneyToolWuduTrainerSubtitle => 'Practice step by step.';

  @override
  String get learningJourneyToolGuidedPrayerSubtitle =>
      'Open a guided prayer flow.';

  @override
  String get learningJourneyToolEssentialHadithSubtitle =>
      'Start with the curated essentials.';

  @override
  String get learningJourneyToolHadithHubSubtitle =>
      'Open themes, collections, and paths.';

  @override
  String get learningJourneyToolHadithReviewSubtitle =>
      'Revisit due or weak hadith material.';

  @override
  String get learningJourneyToolDuaHubSubtitle =>
      'Open the current verified dua hub.';

  @override
  String get learningJourneyToolTriviaPathsSubtitle =>
      'Open the guided trivia path system.';

  @override
  String get learningJourneyToolTriviaReviewSubtitle =>
      'Review what is due next.';

  @override
  String get learningJourneyHadithEssentialCollectionLessonIntro =>
      'Hadith preserves the words, actions, and approvals of the Prophet ﷺ so Muslims can learn how revelation is lived.';

  @override
  String get learningJourneyHadithEssentialCollectionSection1Title =>
      'Why beginners need hadith';

  @override
  String get learningJourneyHadithEssentialCollectionSection1Body =>
      'The Qur’an gives guidance and command, and hadith shows how that guidance was embodied in prayer, character, mercy, and daily choices.';

  @override
  String get learningJourneyHadithEssentialCollectionSection2Title =>
      'How to start without overload';

  @override
  String get learningJourneyHadithEssentialCollectionSection2Body =>
      'Start with a small curated collection. Read slowly, keep one lesson, and let that lesson shape action before rushing into quantity.';

  @override
  String get learningJourneyHadithEssentialCollectionBullet1 =>
      'Choose a trusted, beginner-safe collection.';

  @override
  String get learningJourneyHadithEssentialCollectionBullet2 =>
      'Read for guidance, not for completion points.';

  @override
  String get learningJourneyHadithEssentialCollectionBullet3 =>
      'Return to one hadith more than once before moving on.';

  @override
  String get learningJourneyHadithEssentialCollectionTakeaway1 =>
      'Hadith explains how prophetic guidance becomes lived practice.';

  @override
  String get learningJourneyHadithEssentialCollectionTakeaway2 =>
      'A small trusted starting point is enough for real growth.';

  @override
  String get learningJourneyHadithEssentialCollectionTakeaway3 =>
      'Slow review is better than collecting texts without reflection.';

  @override
  String get learningJourneyHadithEssentialCollectionReflection =>
      'Which part of your daily life most needs prophetic guidance right now?';

  @override
  String get learningJourneyHadithEssentialCollectionActionStep =>
      'Open one essential hadith today and keep one sentence from it with you until evening.';

  @override
  String get learningJourneyHadithThemesLessonIntro =>
      'After a small essential set, themes help you learn hadith by need: worship, character, family life, repentance, and mercy.';

  @override
  String get learningJourneyHadithThemesSection1Title =>
      'Why themes help beginners';

  @override
  String get learningJourneyHadithThemesSection1Body =>
      'Themes gather related guidance together so learning feels practical. They help you see that hadith is not a random archive but a map for living.';

  @override
  String get learningJourneyHadithThemesSection2Title =>
      'How to use themed study well';

  @override
  String get learningJourneyHadithThemesSection2Body =>
      'Choose one theme for a few days. Read one hadith, understand its point, and ask how it should appear in your speech, worship, or relationships.';

  @override
  String get learningJourneyHadithThemesBullet1 =>
      'Stay with one theme long enough to notice patterns.';

  @override
  String get learningJourneyHadithThemesBullet2 =>
      'Do not jump topics every few minutes.';

  @override
  String get learningJourneyHadithThemesBullet3 =>
      'Pair reading with one small change in behavior.';

  @override
  String get learningJourneyHadithThemesTakeaway1 =>
      'Themes turn hadith study into a calmer guided path.';

  @override
  String get learningJourneyHadithThemesTakeaway2 =>
      'One theme lived well is better than many themes skimmed quickly.';

  @override
  String get learningJourneyHadithThemesTakeaway3 =>
      'Hadith learning should move from text to conduct.';

  @override
  String get learningJourneyHadithThemesReflection =>
      'Which theme would most help your life this week: worship, character, family, or repentance?';

  @override
  String get learningJourneyHadithThemesReviewSuggestion =>
      'After reading a theme, return the next day and ask what you still remember without reopening the page.';

  @override
  String get learningJourneyHadithReviewLessonIntro =>
      'Review keeps hadith from remaining inspirational for one moment and forgotten the next. It helps guidance become memory and habit.';

  @override
  String get learningJourneyHadithReviewSection1Title => 'What review protects';

  @override
  String get learningJourneyHadithReviewSection1Body =>
      'Without review, useful hadith fades quickly. A short return visit helps you notice what stuck, what blurred, and what still needs explanation.';

  @override
  String get learningJourneyHadithReviewSection2Title =>
      'How to review with purpose';

  @override
  String get learningJourneyHadithReviewSection2Body =>
      'Review is not only about right answers. It is about asking whether the hadith changed your choices, speech, or attention after you first read it.';

  @override
  String get learningJourneyHadithReviewBullet1 =>
      'Revisit weak or forgotten items first.';

  @override
  String get learningJourneyHadithReviewBullet2 =>
      'Link each hadith to one practical action.';

  @override
  String get learningJourneyHadithReviewBullet3 =>
      'Let review send you back into deeper journeys.';

  @override
  String get learningJourneyHadithReviewTakeaway1 =>
      'Review turns short exposure into steady knowledge.';

  @override
  String get learningJourneyHadithReviewTakeaway2 =>
      'Weak spots show where more reflection is needed.';

  @override
  String get learningJourneyHadithReviewTakeaway3 =>
      'The best review ends in better character, not just recall.';

  @override
  String get learningJourneyHadithReviewReflection =>
      'Which hadith lesson do you need to revisit until it becomes part of your conduct?';

  @override
  String get learningJourneyHadithReviewActionStep =>
      'Choose one reviewed hadith and write one action it should change today.';

  @override
  String get learningJourneySalahWhyLessonIntro =>
      'Salah is not only a duty on a list. It is the daily act that reorders the heart, brings the servant back to Allah, and gives the day structure.';

  @override
  String get learningJourneySalahWhySection1Title =>
      'What salah gives the believer';

  @override
  String get learningJourneySalahWhySection1Body =>
      'Prayer gathers remembrance, humility, recitation, gratitude, and need before Allah. It keeps the day from becoming fully controlled by distraction or impulse.';

  @override
  String get learningJourneySalahWhySection2Title =>
      'A beginner way to think about prayer';

  @override
  String get learningJourneySalahWhySection2Body =>
      'Start by seeing salah as a return, not a performance. Each prayer is another chance to stand before Allah with honesty, even after weak days.';

  @override
  String get learningJourneySalahWhyBullet1 =>
      'Prayer reconnects the day to Allah.';

  @override
  String get learningJourneySalahWhyBullet2 =>
      'It is a return even when you do not feel perfect.';

  @override
  String get learningJourneySalahWhyBullet3 =>
      'Consistency matters more than emotional intensity.';

  @override
  String get learningJourneySalahWhyTakeaway1 =>
      'Salah is an anchor, not an interruption.';

  @override
  String get learningJourneySalahWhyTakeaway2 =>
      'Prayer gathers the heart around remembrance and obedience.';

  @override
  String get learningJourneySalahWhyTakeaway3 =>
      'A sincere return is always better than delay through guilt.';

  @override
  String get learningJourneySalahWhyReflection =>
      'What usually makes prayer feel heavy, and how would it change if you saw it as a return?';

  @override
  String get learningJourneySalahPrepareLessonIntro =>
      'Preparation shapes the quality of salah. Wudu, intention, timing, and a little calm make prayer more focused before the first takbir.';

  @override
  String get learningJourneySalahPrepareSection1Title =>
      'Prepare the body and heart';

  @override
  String get learningJourneySalahPrepareSection1Body =>
      'Wudu cleans and settles you. Clear intention reminds you who the prayer is for. Reaching prayer in time gives your heart more room to arrive before your tongue begins.';

  @override
  String get learningJourneySalahPrepareSection2Title =>
      'Keep preparation simple and repeatable';

  @override
  String get learningJourneySalahPrepareSection2Body =>
      'You do not need a perfect atmosphere every time. You need a few reliable habits that help you arrive with care.';

  @override
  String get learningJourneySalahPrepareBullet1 => 'Renew wudu with attention.';

  @override
  String get learningJourneySalahPrepareBullet2 =>
      'Pause briefly before takbir.';

  @override
  String get learningJourneySalahPrepareBullet3 =>
      'Let prayer time shape your schedule instead of always reacting late.';

  @override
  String get learningJourneySalahPrepareTakeaway1 =>
      'Good preparation makes prayer gentler.';

  @override
  String get learningJourneySalahPrepareTakeaway2 =>
      'Wudu and intention are part of the path into salah.';

  @override
  String get learningJourneySalahPrepareTakeaway3 =>
      'A small pause before prayer can change its whole feel.';

  @override
  String get learningJourneySalahPrepareReflection =>
      'Which part of preparing for prayer would most improve your focus right now?';

  @override
  String get learningJourneySalahMovementsLessonIntro =>
      'The movements of salah are not empty motions. Each posture carries meaning: standing, bowing, prostrating, and sitting before Allah.';

  @override
  String get learningJourneySalahMovementsSection1Title =>
      'Follow the sequence calmly';

  @override
  String get learningJourneySalahMovementsSection1Body =>
      'Prayer becomes easier when you stop trying to rush through the whole unit at once. Learn the sequence one posture at a time and connect each movement to its purpose.';

  @override
  String get learningJourneySalahMovementsSection2Title =>
      'What the postures teach';

  @override
  String get learningJourneySalahMovementsSection2Body =>
      'Standing teaches attention, bowing teaches humility, and sujud teaches nearness and surrender. The body helps train the heart.';

  @override
  String get learningJourneySalahMovementsBullet1 =>
      'Slow down enough to recognize each posture.';

  @override
  String get learningJourneySalahMovementsBullet2 =>
      'Link movement to meaning.';

  @override
  String get learningJourneySalahMovementsBullet3 =>
      'Use guided practice when the order still feels unstable.';

  @override
  String get learningJourneySalahMovementsTakeaway1 =>
      'The sequence becomes lighter with calm repetition.';

  @override
  String get learningJourneySalahMovementsTakeaway2 =>
      'Each posture trains humility in a different way.';

  @override
  String get learningJourneySalahMovementsTakeaway3 =>
      'Learning prayer is easier when you break it into parts.';

  @override
  String get learningJourneySalahMovementsReflection =>
      'Which posture in salah feels least familiar or least meaningful to you right now?';

  @override
  String get learningJourneySalahWordsMeaningLessonIntro =>
      'The words of salah become more powerful when you know what you are saying and why those words were placed in prayer.';

  @override
  String get learningJourneySalahWordsMeaningSection1Title =>
      'Meaning helps khushu';

  @override
  String get learningJourneySalahWordsMeaningSection1Body =>
      'Understanding Al-Fatihah, takbir, tasbih, and simple remembrances gives the heart something to hold during prayer. Meaning does not replace concentration, but it helps awaken it.';

  @override
  String get learningJourneySalahWordsMeaningSection2Title =>
      'Start with the most repeated phrases';

  @override
  String get learningJourneySalahWordsMeaningSection2Body =>
      'You do not need to understand everything at once. Begin with the phrases you recite every day and let familiarity grow into attention.';

  @override
  String get learningJourneySalahWordsMeaningBullet1 =>
      'Start with Al-Fatihah and takbir.';

  @override
  String get learningJourneySalahWordsMeaningBullet2 =>
      'Notice what you say in ruku and sujud.';

  @override
  String get learningJourneySalahWordsMeaningBullet3 =>
      'Use repetition to deepen meaning, not flatten it.';

  @override
  String get learningJourneySalahWordsMeaningTakeaway1 =>
      'Meaning helps the heart stay present.';

  @override
  String get learningJourneySalahWordsMeaningTakeaway2 =>
      'A few understood phrases can change the quality of prayer quickly.';

  @override
  String get learningJourneySalahWordsMeaningTakeaway3 =>
      'Understanding grows best in small repeated steps.';

  @override
  String get learningJourneySalahWordsMeaningReflection =>
      'Which phrase in salah do you most want to understand more deeply?';

  @override
  String get learningJourneySalahConsistencyLessonIntro =>
      'Consistency in salah is built through return, not through waiting to feel perfect. Khushu also grows gradually through repetition, understanding, and honest effort.';

  @override
  String get learningJourneySalahConsistencySection1Title =>
      'Protect the habit';

  @override
  String get learningJourneySalahConsistencySection1Body =>
      'A protected prayer habit often begins with one or two strong anchors, then expands. Even after weak days, the answer is return, not self-abandonment.';

  @override
  String get learningJourneySalahConsistencySection2Title =>
      'Build calm focus over time';

  @override
  String get learningJourneySalahConsistencySection2Body =>
      'Khushu is helped by preparation, understanding, and lowering distraction before prayer. It is not all-or-nothing.';

  @override
  String get learningJourneySalahConsistencyBullet1 =>
      'Return quickly after a weak day.';

  @override
  String get learningJourneySalahConsistencyBullet2 =>
      'Keep one prayer especially guarded if all five feel shaky.';

  @override
  String get learningJourneySalahConsistencyBullet3 =>
      'Reduce one distraction before each prayer.';

  @override
  String get learningJourneySalahConsistencyTakeaway1 =>
      'Consistency grows through quick return.';

  @override
  String get learningJourneySalahConsistencyTakeaway2 =>
      'Khushu is built, not instantly achieved.';

  @override
  String get learningJourneySalahConsistencyTakeaway3 =>
      'A small protected routine is stronger than grand temporary effort.';

  @override
  String get learningJourneySalahConsistencyReflection =>
      'What one change would help you protect salah more consistently this week?';

  @override
  String get learningJourneySalahConsistencyActionStep =>
      'Choose one prayer today to guard with extra care, from preparation to final salam.';

  @override
  String get learningJourneySalahCompletionLessonIntro =>
      'You have moved through the meaning, preparation, movements, and consistency of salah. Now choose how to keep prayer alive beyond this journey.';

  @override
  String get learningJourneySalahCompletionSection1Title =>
      'What this journey gave you';

  @override
  String get learningJourneySalahCompletionSection1Body =>
      'You now have a calmer frame for why salah matters, how to prepare for it, and how meaning and focus can grow together in prayer.';

  @override
  String get learningJourneySalahCompletionSection2Title => 'What to do next';

  @override
  String get learningJourneySalahCompletionSection2Body =>
      'Protect one concrete next step: steadier timing, better preparation, more presence in Al-Fatihah, or a stronger return after weak days.';

  @override
  String get learningJourneySalahCompletionBullet1 =>
      'Choose one prayer habit to protect first.';

  @override
  String get learningJourneySalahCompletionBullet2 =>
      'Use Wudu and meaning journeys as reinforcement.';

  @override
  String get learningJourneySalahCompletionBullet3 =>
      'Return quickly after weak days instead of delaying.';

  @override
  String get learningJourneySalahCompletionTakeaway1 =>
      'Salah grows through steady return.';

  @override
  String get learningJourneySalahCompletionTakeaway2 =>
      'Meaning, preparation, and focus belong together.';

  @override
  String get learningJourneySalahCompletionTakeaway3 =>
      'One protected habit can change the whole prayer day.';

  @override
  String get learningJourneySalahCompletionReflection =>
      'Which one part of salah most deserves focused care from you this week?';

  @override
  String get learningJourneySalahCompletionActionStep =>
      'Choose one specific prayer improvement for this week and keep it small enough to stay consistent.';

  @override
  String get learningJourneyWuduWhyLessonIntro =>
      'Wudu prepares the believer to stand before Allah with cleanliness, readiness, and respect.';

  @override
  String get learningJourneyWuduWhySection1Title => 'More than washing';

  @override
  String get learningJourneyWuduWhySection1Body =>
      'Wudu is physical preparation, but it also slows the body down and signals that prayer is approaching. It helps you enter worship with intention.';

  @override
  String get learningJourneyWuduWhySection2Title => 'A calm beginner frame';

  @override
  String get learningJourneyWuduWhySection2Body =>
      'Think of wudu as a regular doorway into salah. When the doorway becomes familiar, worship feels less heavy.';

  @override
  String get learningJourneyWuduWhyBullet1 =>
      'Wudu prepares you for prayer, not only cleanliness.';

  @override
  String get learningJourneyWuduWhyBullet2 =>
      'Regular repetition makes the sequence easier.';

  @override
  String get learningJourneyWuduWhyBullet3 =>
      'Clarity in wudu reduces stress before salah.';

  @override
  String get learningJourneyWuduWhyTakeaway1 =>
      'Wudu is preparation with purpose.';

  @override
  String get learningJourneyWuduWhyTakeaway2 =>
      'A familiar doorway makes prayer easier to enter.';

  @override
  String get learningJourneyWuduWhyTakeaway3 =>
      'Small confidence in wudu removes worship friction.';

  @override
  String get learningJourneyWuduWhyReflection =>
      'What part of wudu still feels uncertain enough to slow you down before prayer?';

  @override
  String get learningJourneyWuduPracticeLessonIntro =>
      'The wudu sequence becomes stable when you practice it step by step instead of trying to hold everything in your head at once.';

  @override
  String get learningJourneyWuduPracticeSection1Title =>
      'Learn the order gently';

  @override
  String get learningJourneyWuduPracticeSection1Body =>
      'Move through the acts in order and let repetition make the pattern familiar. Calm practice is more useful than anxious speed.';

  @override
  String get learningJourneyWuduPracticeSection2Title => 'Use the trainer well';

  @override
  String get learningJourneyWuduPracticeSection2Body =>
      'A trainer helps when you need visual repetition or a guided pass through the steps. It is there to support memory, not replace attention.';

  @override
  String get learningJourneyWuduPracticeBullet1 =>
      'Practice one clear pass at a time.';

  @override
  String get learningJourneyWuduPracticeBullet2 =>
      'Repeat the order until it feels natural.';

  @override
  String get learningJourneyWuduPracticeBullet3 =>
      'Use guided support when confusion returns.';

  @override
  String get learningJourneyWuduPracticeTakeaway1 =>
      'Order becomes easier through repetition.';

  @override
  String get learningJourneyWuduPracticeTakeaway2 =>
      'Guided practice lowers uncertainty.';

  @override
  String get learningJourneyWuduPracticeTakeaway3 =>
      'You do not need to rush to build confidence.';

  @override
  String get learningJourneyWuduPracticeReflection =>
      'Which step in the sequence do you still mentally check twice?';

  @override
  String get learningJourneyWuduBreaksLessonIntro =>
      'Knowing what breaks wudu protects you from both carelessness and unnecessary anxiety.';

  @override
  String get learningJourneyWuduBreaksSection1Title =>
      'Learn the common cases first';

  @override
  String get learningJourneyWuduBreaksSection1Body =>
      'Start with the most common situations that clearly break wudu. Beginners do not need to begin with rare edge cases.';

  @override
  String get learningJourneyWuduBreaksSection2Title =>
      'Avoid anxious overchecking';

  @override
  String get learningJourneyWuduBreaksSection2Body =>
      'Islam is not asking you to live in suspicion. Learn the clear cases and do not let whispering turn worship into constant uncertainty.';

  @override
  String get learningJourneyWuduBreaksBullet1 =>
      'Focus on clear common cases first.';

  @override
  String get learningJourneyWuduBreaksBullet2 =>
      'Do not keep reopening doubtful situations without reason.';

  @override
  String get learningJourneyWuduBreaksBullet3 =>
      'Ask for clarity when a real confusion remains.';

  @override
  String get learningJourneyWuduBreaksTakeaway1 =>
      'Clarity protects worship from anxiety.';

  @override
  String get learningJourneyWuduBreaksTakeaway2 =>
      'Beginners should learn the clear cases first.';

  @override
  String get learningJourneyWuduBreaksTakeaway3 =>
      'Not every doubt deserves equal attention.';

  @override
  String get learningJourneyWuduBreaksReflection =>
      'Do you tend to struggle more with not knowing the rule or with overthinking it?';

  @override
  String get learningJourneyWuduMistakesLessonIntro =>
      'Confidence in wudu grows when you notice a few common mistakes and learn how to correct them without harshness.';

  @override
  String get learningJourneyWuduMistakesSection1Title => 'Common mistakes';

  @override
  String get learningJourneyWuduMistakesSection1Body =>
      'People often rush the order, skip attention, or let uncertainty keep them repeating more than needed. Calm correction is better than constant restarting.';

  @override
  String get learningJourneyWuduMistakesSection2Title => 'A simple self-check';

  @override
  String get learningJourneyWuduMistakesSection2Body =>
      'Ask yourself whether you know the sequence, can complete it without panic, and know when to repeat a step and when to move on.';

  @override
  String get learningJourneyWuduMistakesBullet1 =>
      'Slow down before restarting everything.';

  @override
  String get learningJourneyWuduMistakesBullet2 =>
      'Review the sequence after mistakes instead of only feeling frustrated.';

  @override
  String get learningJourneyWuduMistakesBullet3 =>
      'Use practice to remove one weak point at a time.';

  @override
  String get learningJourneyWuduMistakesTakeaway1 =>
      'Mistakes are corrected through calm review.';

  @override
  String get learningJourneyWuduMistakesTakeaway2 =>
      'Confidence comes from clarity, not from repeating endlessly.';

  @override
  String get learningJourneyWuduMistakesTakeaway3 =>
      'Self-check should support worship, not burden it.';

  @override
  String get learningJourneyWuduMistakesReflection =>
      'Which one weak point in wudu would be most useful to fix this week?';

  @override
  String get learningJourneyWuduMistakesActionStep =>
      'Practice one full calm pass of wudu today and note only one step that still needs attention.';

  @override
  String get learningJourneyWuduCompletionLessonIntro =>
      'You have moved from understanding wudu to practice, clarity, and self-check. Now connect that confidence to calmer worship.';

  @override
  String get learningJourneyWuduCompletionSection1Title =>
      'What this journey built';

  @override
  String get learningJourneyWuduCompletionSection1Body =>
      'You now know why wudu matters, how to practice it, what breaks it, and how to correct common mistakes without panic.';

  @override
  String get learningJourneyWuduCompletionSection2Title => 'What to do next';

  @override
  String get learningJourneyWuduCompletionSection2Body =>
      'Let confident wudu reduce friction before salah. Treat it as the doorway to prayer, dhikr, and steadier worship instead of a repeated source of stress.';

  @override
  String get learningJourneyWuduCompletionBullet1 =>
      'Keep one calm full wudu routine alive.';

  @override
  String get learningJourneyWuduCompletionBullet2 =>
      'Use what you learned before each prayer.';

  @override
  String get learningJourneyWuduCompletionBullet3 =>
      'Let wudu support calmer entry into salah and dhikr.';

  @override
  String get learningJourneyWuduCompletionTakeaway1 =>
      'Clarity in wudu supports clarity in worship.';

  @override
  String get learningJourneyWuduCompletionTakeaway2 =>
      'Confidence grows through repetition and calm correction.';

  @override
  String get learningJourneyWuduCompletionTakeaway3 =>
      'The goal is worship readiness, not anxious perfection.';

  @override
  String get learningJourneyWuduCompletionReflection =>
      'How would your prayer life change if wudu felt calm and familiar every day?';

  @override
  String get learningJourneyWuduCompletionActionStep =>
      'Before your next prayer, complete wudu slowly and notice how that changes your entry into salah.';

  @override
  String get learningJourneyAlphabetOpenLessonIntro =>
      'The Arabic alphabet becomes easier when you stop seeing it as one large wall and begin meeting the letters in small memorable groups.';

  @override
  String get learningJourneyAlphabetOpenSection1Title => 'Focus of this stage';

  @override
  String get learningJourneyAlphabetOpenSection1Body =>
      'Notice the broad shapes of the letters and how groups of letters can be learned together. The goal is recognition first, not perfect pronunciation in one sitting.';

  @override
  String get learningJourneyAlphabetOpenSection2Title =>
      'Simple examples and next step';

  @override
  String get learningJourneyAlphabetOpenSection2Body =>
      'Work through a few letters, say their names out loud, and point out which shapes feel similar or different. That keeps your eyes active and your memory engaged.';

  @override
  String get learningJourneyAlphabetOpenBullet1 =>
      'Learn a small letter group at a time.';

  @override
  String get learningJourneyAlphabetOpenBullet2 =>
      'Say each letter aloud as you see it.';

  @override
  String get learningJourneyAlphabetOpenBullet3 =>
      'Notice one feature that helps you remember the shape.';

  @override
  String get learningJourneyAlphabetOpenTakeaway1 =>
      'Recognition comes before speed.';

  @override
  String get learningJourneyAlphabetOpenTakeaway2 =>
      'Small groups are easier to retain than the whole alphabet at once.';

  @override
  String get learningJourneyAlphabetOpenTakeaway3 =>
      'Active noticing makes letters stick better.';

  @override
  String get learningJourneyAlphabetOpenReflection =>
      'Which letter shapes already feel familiar, and which ones still blur together?';

  @override
  String get learningJourneyAlphabetRepeatLessonIntro =>
      'Repetition turns alphabet exposure into alphabet memory. Hearing and repeating the sounds helps the letters settle more deeply.';

  @override
  String get learningJourneyAlphabetRepeatSection1Title =>
      'What you are strengthening';

  @override
  String get learningJourneyAlphabetRepeatSection1Body =>
      'This stage is about sound recognition and steady repetition. When your tongue and ear work together, letter recall improves.';

  @override
  String get learningJourneyAlphabetRepeatSection2Title => 'How to repeat well';

  @override
  String get learningJourneyAlphabetRepeatSection2Body =>
      'Repeat a short group several times instead of jumping quickly through everything. Slow repetition is more useful than tired repetition.';

  @override
  String get learningJourneyAlphabetRepeatBullet1 =>
      'Repeat one small group until it feels lighter.';

  @override
  String get learningJourneyAlphabetRepeatBullet2 =>
      'Listen carefully before copying the sound.';

  @override
  String get learningJourneyAlphabetRepeatBullet3 =>
      'Return to difficult letters more often.';

  @override
  String get learningJourneyAlphabetRepeatTakeaway1 =>
      'Hearing and speaking reinforce each other.';

  @override
  String get learningJourneyAlphabetRepeatTakeaway2 =>
      'Short focused repetition works better than random drilling.';

  @override
  String get learningJourneyAlphabetRepeatTakeaway3 =>
      'The hardest letters need gentler extra review, not frustration.';

  @override
  String get learningJourneyAlphabetRepeatReflection =>
      'Which sound still feels least stable when you say it aloud?';

  @override
  String get learningJourneyAlphabetReviewLessonIntro =>
      'Review prepares you for reading. The alphabet becomes useful when you can return to it easily without feeling lost.';

  @override
  String get learningJourneyAlphabetReviewSection1Title =>
      'Use review as reinforcement';

  @override
  String get learningJourneyAlphabetReviewSection1Body =>
      'A quick review loop helps you notice which letters stayed clear and which ones still need another pass before reading marks are added.';

  @override
  String get learningJourneyAlphabetReviewSection2Title =>
      'Prepare for the next journey';

  @override
  String get learningJourneyAlphabetReviewSection2Body =>
      'Once the letters feel familiar, you are ready to start reading marks and joined forms. You do not need perfection. You need workable confidence.';

  @override
  String get learningJourneyAlphabetReviewBullet1 =>
      'Return to weak letters on purpose.';

  @override
  String get learningJourneyAlphabetReviewBullet2 =>
      'Check whether you can recognize letters out of order.';

  @override
  String get learningJourneyAlphabetReviewBullet3 =>
      'Move into reading basics once recognition feels workable.';

  @override
  String get learningJourneyAlphabetReviewTakeaway1 =>
      'Review turns exposure into readiness.';

  @override
  String get learningJourneyAlphabetReviewTakeaway2 =>
      'You can move forward with workable confidence, not perfection.';

  @override
  String get learningJourneyAlphabetReviewTakeaway3 =>
      'Preparation makes the next journey less intimidating.';

  @override
  String get learningJourneyAlphabetReviewReflection =>
      'Are you more ready to move on, or do you need one more calm alphabet pass?';

  @override
  String get learningJourneyAlphabetReviewActionStep =>
      'Open one short alphabet review session and note the two letters you want to remember best this week.';

  @override
  String get learningJourneyReadingKasrahLessonIntro =>
      'Kasrah gives a short i sound. This small mark changes the feel of a letter and is one of the first keys to real reading.';

  @override
  String get learningJourneyReadingKasrahSection1Title => 'What to watch for';

  @override
  String get learningJourneyReadingKasrahSection1Body =>
      'Look beneath the letter and let your eye catch the mark before your tongue moves. That pause helps prevent guessing.';

  @override
  String get learningJourneyReadingKasrahSection2Title => 'Practice suggestion';

  @override
  String get learningJourneyReadingKasrahSection2Body =>
      'Read short examples with one letter at a time, then repeat two or three examples until the pattern begins to feel natural.';

  @override
  String get learningJourneyReadingKasrahBullet1 =>
      'Notice the mark before saying the sound.';

  @override
  String get learningJourneyReadingKasrahBullet2 =>
      'Use short repeated examples.';

  @override
  String get learningJourneyReadingKasrahBullet3 =>
      'Do not rush from recognition into speed.';

  @override
  String get learningJourneyReadingKasrahTakeaway1 =>
      'Kasrah trains careful seeing.';

  @override
  String get learningJourneyReadingKasrahTakeaway2 =>
      'Short repetition stabilizes the sound.';

  @override
  String get learningJourneyReadingKasrahTakeaway3 =>
      'Accuracy now makes later reading smoother.';

  @override
  String get learningJourneyReadingKasrahReflection =>
      'Does kasrah feel different from fathah in your mouth and attention yet?';

  @override
  String get learningJourneyReadingDammahLessonIntro =>
      'Dammah gives a short u sound and teaches the reader to stay calm with rounded pronunciation.';

  @override
  String get learningJourneyReadingDammahSection1Title =>
      'What the mark changes';

  @override
  String get learningJourneyReadingDammahSection1Body =>
      'The sound rounds differently from fathah and kasrah. Noticing that difference helps you stop treating all marks as the same.';

  @override
  String get learningJourneyReadingDammahSection2Title => 'Practice suggestion';

  @override
  String get learningJourneyReadingDammahSection2Body =>
      'Alternate between a few examples of the three short vowels so your ear and tongue learn to separate them clearly.';

  @override
  String get learningJourneyReadingDammahBullet1 =>
      'Compare it with the other short vowels.';

  @override
  String get learningJourneyReadingDammahBullet2 =>
      'Read slowly enough to hear the rounding.';

  @override
  String get learningJourneyReadingDammahBullet3 =>
      'Repeat until the sound feels distinct.';

  @override
  String get learningJourneyReadingDammahTakeaway1 =>
      'Each vowel mark deserves its own attention.';

  @override
  String get learningJourneyReadingDammahTakeaway2 =>
      'Comparison helps memory.';

  @override
  String get learningJourneyReadingDammahTakeaway3 =>
      'Rounded reading still needs calm precision.';

  @override
  String get learningJourneyReadingDammahReflection =>
      'Which short vowel still feels easiest to mix up with another one?';

  @override
  String get learningJourneyReadingSukunLessonIntro =>
      'Sukun teaches you what happens when a letter rests without a vowel. That resting sound is important for clearer reading.';

  @override
  String get learningJourneyReadingSukunSection1Title => 'How sukun feels';

  @override
  String get learningJourneyReadingSukunSection1Body =>
      'A letter with sukun does not carry a new vowel movement. Instead, you stop on the letter and hear its rest clearly.';

  @override
  String get learningJourneyReadingSukunSection2Title => 'Practice suggestion';

  @override
  String get learningJourneyReadingSukunSection2Body =>
      'Use simple examples where the contrast between a moving letter and a resting letter is easy to hear.';

  @override
  String get learningJourneyReadingSukunBullet1 =>
      'Notice the difference between movement and rest.';

  @override
  String get learningJourneyReadingSukunBullet2 =>
      'Pause enough to hear the resting letter.';

  @override
  String get learningJourneyReadingSukunBullet3 =>
      'Use simple examples before longer words.';

  @override
  String get learningJourneyReadingSukunTakeaway1 =>
      'Sukun teaches stillness in reading.';

  @override
  String get learningJourneyReadingSukunTakeaway2 =>
      'Resting letters help words sound correct.';

  @override
  String get learningJourneyReadingSukunTakeaway3 =>
      'Small listening differences matter.';

  @override
  String get learningJourneyReadingSukunReflection =>
      'Do resting letters still make you want to add a vowel automatically?';

  @override
  String get learningJourneyReadingShaddahLessonIntro =>
      'Shaddah shows a doubled sound. It asks you to slow down enough to hear and pronounce the letter with more care.';

  @override
  String get learningJourneyReadingShaddahSection1Title =>
      'Why shaddah matters';

  @override
  String get learningJourneyReadingShaddahSection1Body =>
      'A doubled letter changes how a word sounds. Missing it can flatten the word and make recitation less precise.';

  @override
  String get learningJourneyReadingShaddahSection2Title =>
      'Practice suggestion';

  @override
  String get learningJourneyReadingShaddahSection2Body =>
      'Use short words and exaggerate the doubled sound slightly at first. Once the pattern is clear, soften into normal reading.';

  @override
  String get learningJourneyReadingShaddahBullet1 =>
      'Slow down at the doubled letter.';

  @override
  String get learningJourneyReadingShaddahBullet2 =>
      'Use short words before longer lines.';

  @override
  String get learningJourneyReadingShaddahBullet3 =>
      'Listen for the difference between one sound and two.';

  @override
  String get learningJourneyReadingShaddahTakeaway1 =>
      'Shaddah rewards slower reading.';

  @override
  String get learningJourneyReadingShaddahTakeaway2 =>
      'Pronunciation improves when the doubled sound is respected.';

  @override
  String get learningJourneyReadingShaddahTakeaway3 =>
      'Small sound details matter in recitation.';

  @override
  String get learningJourneyReadingShaddahReflection =>
      'Does slowing down at a doubled letter make reading feel calmer or heavier for you right now?';

  @override
  String get learningJourneyTriviaPathsLessonIntro =>
      'Trivia works best when it supports a learning goal. A path gives your questions context and helps reinforcement feel purposeful.';

  @override
  String get learningJourneyTriviaPathsSection1Title => 'Why paths matter';

  @override
  String get learningJourneyTriviaPathsSection1Body =>
      'A themed path keeps questions connected. That makes it easier to remember what you learned and to continue into a deeper journey later.';

  @override
  String get learningJourneyTriviaPathsSection2Title => 'How to choose well';

  @override
  String get learningJourneyTriviaPathsSection2Body =>
      'Choose a path that matches something you are already studying or something you genuinely want to understand better.';

  @override
  String get learningJourneyTriviaPathsBullet1 =>
      'Choose one path instead of random jumping.';

  @override
  String get learningJourneyTriviaPathsBullet2 =>
      'Let curiosity and current study guide your choice.';

  @override
  String get learningJourneyTriviaPathsBullet3 =>
      'Use paths as entry points into deeper learning.';

  @override
  String get learningJourneyTriviaPathsTakeaway1 =>
      'Trivia is stronger when it has a clear theme.';

  @override
  String get learningJourneyTriviaPathsTakeaway2 =>
      'Connected questions are easier to retain.';

  @override
  String get learningJourneyTriviaPathsTakeaway3 =>
      'A good path should point beyond the quiz itself.';

  @override
  String get learningJourneyTriviaPathsReflection =>
      'Which area would you rather reinforce right now: Prophets, Qur’an, worship, or history?';

  @override
  String get learningJourneyTriviaSessionLessonIntro =>
      'A short trivia session can reinforce knowledge well if you use it as learning, not only as scoring.';

  @override
  String get learningJourneyTriviaSessionSection1Title => 'How to answer well';

  @override
  String get learningJourneyTriviaSessionSection1Body =>
      'Slow down before guessing. Let each question teach you something, especially when you miss it.';

  @override
  String get learningJourneyTriviaSessionSection2Title =>
      'How to learn from mistakes';

  @override
  String get learningJourneyTriviaSessionSection2Body =>
      'A missed answer is a clue. It shows you which topic needs another pass through a real lesson or journey.';

  @override
  String get learningJourneyTriviaSessionBullet1 =>
      'Treat mistakes as direction, not embarrassment.';

  @override
  String get learningJourneyTriviaSessionBullet2 =>
      'Pause after wrong answers long enough to notice the lesson.';

  @override
  String get learningJourneyTriviaSessionBullet3 =>
      'Return to related journeys after the session.';

  @override
  String get learningJourneyTriviaSessionTakeaway1 =>
      'Questions can reinforce memory and reveal gaps.';

  @override
  String get learningJourneyTriviaSessionTakeaway2 =>
      'Learning matters more than scoring.';

  @override
  String get learningJourneyTriviaSessionTakeaway3 =>
      'A short session can still teach deeply when used well.';

  @override
  String get learningJourneyTriviaSessionReflection =>
      'Do you usually rush to answer, or do you slow down enough to learn from the question?';

  @override
  String get learningJourneyTriviaReviewLessonIntro =>
      'Review is where trivia becomes reinforcement. It helps weak questions turn into clearer understanding.';

  @override
  String get learningJourneyTriviaReviewSection1Title =>
      'What review shows you';

  @override
  String get learningJourneyTriviaReviewSection1Body =>
      'Review reveals patterns in what you forget. That makes it easier to decide whether you need more repetition or a deeper lesson.';

  @override
  String get learningJourneyTriviaReviewSection2Title => 'Where to go next';

  @override
  String get learningJourneyTriviaReviewSection2Body =>
      'After review, choose one related journey or tool so the quiz points back into meaningful study instead of becoming isolated.';

  @override
  String get learningJourneyTriviaReviewBullet1 =>
      'Use review to spot patterns, not only isolated misses.';

  @override
  String get learningJourneyTriviaReviewBullet2 =>
      'Choose one topic to revisit after the quiz.';

  @override
  String get learningJourneyTriviaReviewBullet3 =>
      'Let reinforcement lead back into the journey system.';

  @override
  String get learningJourneyTriviaReviewTakeaway1 =>
      'Review turns quizzes into guidance.';

  @override
  String get learningJourneyTriviaReviewTakeaway2 =>
      'Weak answers can point to your next best lesson.';

  @override
  String get learningJourneyTriviaReviewTakeaway3 =>
      'Reinforcement works best when it reconnects to deeper content.';

  @override
  String get learningJourneyTriviaReviewReflection =>
      'Which wrong answer category keeps showing you the same gap in knowledge?';

  @override
  String get learningJourneyRamadanWhatIsLessonIntro =>
      'Ramadan is the month in which the Qur’an was revealed and the month in which fasting was made obligatory for believers.';

  @override
  String get learningJourneyRamadanWhatIsSection1Title =>
      'What makes Ramadan special';

  @override
  String get learningJourneyRamadanWhatIsSection1Body =>
      'Ramadan is a month of fasting, Qur’an, dua, charity, patience, and mercy. It is not only about hunger. It is a season of worship and return.';

  @override
  String get learningJourneyRamadanWhatIsSection2Title =>
      'How to enter the month';

  @override
  String get learningJourneyRamadanWhatIsSection2Body =>
      'Begin Ramadan with reverence and hope. Let the month feel different because your intention, schedule, and attention become more worship-centered.';

  @override
  String get learningJourneyRamadanWhatIsBullet1 =>
      'Ramadan is a month of mercy and discipline.';

  @override
  String get learningJourneyRamadanWhatIsBullet2 =>
      'It is linked deeply to the Qur’an.';

  @override
  String get learningJourneyRamadanWhatIsBullet3 =>
      'You enter it best with intention and humility.';

  @override
  String get learningJourneyRamadanWhatIsTakeaway1 =>
      'Ramadan is a worship month before it is a food schedule.';

  @override
  String get learningJourneyRamadanWhatIsTakeaway2 =>
      'The month is honored because Allah honored it.';

  @override
  String get learningJourneyRamadanWhatIsTakeaway3 =>
      'Intention changes how you live the month.';

  @override
  String get learningJourneyRamadanWhatIsReflection =>
      'What do you most want Ramadan to change in you this year?';

  @override
  String get learningJourneyRamadanWhyFastLessonIntro =>
      'Fasting trains taqwa by teaching the believer to leave what is normally permitted for the sake of Allah.';

  @override
  String get learningJourneyRamadanWhyFastSection1Title =>
      'The purpose of fasting';

  @override
  String get learningJourneyRamadanWhyFastSection1Body =>
      'Fasting teaches restraint, gratitude, dependence on Allah, and awareness that worship is not only visible action but also hidden discipline.';

  @override
  String get learningJourneyRamadanWhyFastSection2Title =>
      'How purpose changes the day';

  @override
  String get learningJourneyRamadanWhyFastSection2Body =>
      'When you remember why you are fasting, hunger and tiredness feel connected to worship rather than only discomfort.';

  @override
  String get learningJourneyRamadanWhyFastBullet1 =>
      'Fasting trains self-restraint.';

  @override
  String get learningJourneyRamadanWhyFastBullet2 =>
      'It grows gratitude for ordinary blessings.';

  @override
  String get learningJourneyRamadanWhyFastBullet3 =>
      'It teaches worship in private and public.';

  @override
  String get learningJourneyRamadanWhyFastTakeaway1 =>
      'Fasting is a path to taqwa.';

  @override
  String get learningJourneyRamadanWhyFastTakeaway2 =>
      'Its purpose is spiritual, not only physical.';

  @override
  String get learningJourneyRamadanWhyFastTakeaway3 =>
      'Remembered purpose makes hardship lighter.';

  @override
  String get learningJourneyRamadanWhyFastReflection =>
      'When fasting feels difficult, which purpose of fasting most helps you remain sincere?';

  @override
  String get learningJourneyRamadanSuhoorIftarLessonIntro =>
      'A healthy Ramadan rhythm begins before dawn and ends after sunset, but the whole day is shaped by what happens between those points.';

  @override
  String get learningJourneyRamadanSuhoorIftarSection1Title =>
      'Suhoor and beginning the day';

  @override
  String get learningJourneyRamadanSuhoorIftarSection1Body =>
      'Suhoor gives strength and barakah. Beginning the day with intention, prayer, and remembrance helps the fast start with steadiness.';

  @override
  String get learningJourneyRamadanSuhoorIftarSection2Title =>
      'Iftar and ending the day';

  @override
  String get learningJourneyRamadanSuhoorIftarSection2Body =>
      'Iftar is a moment of gratitude, dua, and relief. Keep it balanced enough that the evening still has room for prayer, Qur’an, and rest.';

  @override
  String get learningJourneyRamadanSuhoorIftarBullet1 =>
      'Treat suhoor as preparation, not only fuel.';

  @override
  String get learningJourneyRamadanSuhoorIftarBullet2 =>
      'Break the fast with gratitude and dua.';

  @override
  String get learningJourneyRamadanSuhoorIftarBullet3 =>
      'Keep the evening balanced enough for worship.';

  @override
  String get learningJourneyRamadanSuhoorIftarTakeaway1 =>
      'The daily rhythm shapes the whole Ramadan experience.';

  @override
  String get learningJourneyRamadanSuhoorIftarTakeaway2 =>
      'Suhoor and iftar are spiritual moments, not only meals.';

  @override
  String get learningJourneyRamadanSuhoorIftarTakeaway3 =>
      'A balanced evening protects worship energy.';

  @override
  String get learningJourneyRamadanSuhoorIftarReflection =>
      'Which part of your Ramadan day most needs a calmer structure?';

  @override
  String get learningJourneyRamadanBreaksFastLessonIntro =>
      'Knowing what breaks the fast gives confidence and keeps worship away from both negligence and needless panic.';

  @override
  String get learningJourneyRamadanBreaksFastSection1Title =>
      'Learn the clear cases first';

  @override
  String get learningJourneyRamadanBreaksFastSection1Body =>
      'Begin with the common matters that clearly invalidate the fast. A beginner foundation does not need every detailed edge case on day one.';

  @override
  String get learningJourneyRamadanBreaksFastSection2Title =>
      'Guard the heart from anxious uncertainty';

  @override
  String get learningJourneyRamadanBreaksFastSection2Body =>
      'Do not let fasting turn into constant worry. Learn the clear rules, ask when you need help, and avoid feeding every passing doubt.';

  @override
  String get learningJourneyRamadanBreaksFastBullet1 =>
      'Focus on the clear common invalidators first.';

  @override
  String get learningJourneyRamadanBreaksFastBullet2 =>
      'Ask for clarity when a real confusion remains.';

  @override
  String get learningJourneyRamadanBreaksFastBullet3 =>
      'Do not let doubt consume the month.';

  @override
  String get learningJourneyRamadanBreaksFastTakeaway1 =>
      'Clarity protects the fast.';

  @override
  String get learningJourneyRamadanBreaksFastTakeaway2 =>
      'Beginners do not need every rare scenario at once.';

  @override
  String get learningJourneyRamadanBreaksFastTakeaway3 =>
      'Islam does not want worship built on constant panic.';

  @override
  String get learningJourneyRamadanBreaksFastReflection =>
      'Do you struggle more with not knowing the rules or with overthinking them?';

  @override
  String get learningJourneyRamadanLaylatLessonIntro =>
      'Laylat al-Qadr is better than a thousand months. The believer seeks it in the last nights with worship, dua, and sincerity.';

  @override
  String get learningJourneyRamadanLaylatSection1Title =>
      'Why the last nights matter';

  @override
  String get learningJourneyRamadanLaylatSection1Body =>
      'The last ten nights carry special weight because Laylat al-Qadr is hidden within them. That hiddenness encourages steady effort rather than one-night intensity.';

  @override
  String get learningJourneyRamadanLaylatSection2Title => 'How to seek it';

  @override
  String get learningJourneyRamadanLaylatSection2Body =>
      'Seek the night through prayer, Qur’an, dua, repentance, and quiet sincerity. Keep the focus on Allah more than on chasing signs.';

  @override
  String get learningJourneyRamadanLaylatBullet1 =>
      'Increase worship across the last nights.';

  @override
  String get learningJourneyRamadanLaylatBullet2 =>
      'Use dua and repentance often.';

  @override
  String get learningJourneyRamadanLaylatBullet3 =>
      'Seek sincerity more than spectacle.';

  @override
  String get learningJourneyRamadanLaylatTakeaway1 =>
      'Laylat al-Qadr invites sustained effort.';

  @override
  String get learningJourneyRamadanLaylatTakeaway2 =>
      'The hidden night encourages sincerity and consistency.';

  @override
  String get learningJourneyRamadanLaylatTakeaway3 =>
      'Simple worship done sincerely can carry immense weight.';

  @override
  String get learningJourneyRamadanLaylatReflection =>
      'What kind of worship helps your heart feel closest to Allah in the quiet hours?';

  @override
  String get learningJourneyRamadanSpiritualGoalsLessonIntro =>
      'Ramadan changes people most when they enter it with a few clear spiritual goals instead of a vague wish to do better.';

  @override
  String get learningJourneyRamadanSpiritualGoalsSection1Title =>
      'Choose a few goals only';

  @override
  String get learningJourneyRamadanSpiritualGoalsSection1Body =>
      'Good goals are small enough to repeat: more Qur’an, more dhikr, more guarded speech, more dua, or stronger salah.';

  @override
  String get learningJourneyRamadanSpiritualGoalsSection2Title =>
      'Keep goals linked to worship';

  @override
  String get learningJourneyRamadanSpiritualGoalsSection2Body =>
      'A goal should help you turn to Allah more steadily. If it only increases stress or comparison, make it smaller and clearer.';

  @override
  String get learningJourneyRamadanSpiritualGoalsBullet1 =>
      'Choose a few goals, not too many.';

  @override
  String get learningJourneyRamadanSpiritualGoalsBullet2 =>
      'Tie goals to real daily moments.';

  @override
  String get learningJourneyRamadanSpiritualGoalsBullet3 =>
      'Review them gently through the month.';

  @override
  String get learningJourneyRamadanSpiritualGoalsTakeaway1 =>
      'Clarity helps Ramadan feel purposeful.';

  @override
  String get learningJourneyRamadanSpiritualGoalsTakeaway2 =>
      'Small repeated goals are stronger than grand vague plans.';

  @override
  String get learningJourneyRamadanSpiritualGoalsTakeaway3 =>
      'Good goals move the heart back to Allah.';

  @override
  String get learningJourneyRamadanSpiritualGoalsReflection =>
      'Which one spiritual habit would most change your Ramadan if you protected it daily?';

  @override
  String get learningJourneyRamadanMistakesLessonIntro =>
      'Some Ramadan mistakes do not come from bad intention. They come from hurry, excess, burnout, or losing sight of the month’s purpose.';

  @override
  String get learningJourneyRamadanMistakesSection1Title => 'Common traps';

  @override
  String get learningJourneyRamadanMistakesSection1Body =>
      'A person may focus on food more than worship, stay up in ways that damage prayer, waste time heavily, or become harsh and impatient while fasting.';

  @override
  String get learningJourneyRamadanMistakesSection2Title =>
      'How to protect the month';

  @override
  String get learningJourneyRamadanMistakesSection2Body =>
      'Keep the month simple enough that worship remains central. Reduce one distraction, one excess habit, and one pattern of heedlessness.';

  @override
  String get learningJourneyRamadanMistakesBullet1 =>
      'Do not let food planning consume the month.';

  @override
  String get learningJourneyRamadanMistakesBullet2 =>
      'Protect prayer and sleep enough to keep worship steady.';

  @override
  String get learningJourneyRamadanMistakesBullet3 =>
      'Treat manners and speech as part of fasting.';

  @override
  String get learningJourneyRamadanMistakesTakeaway1 =>
      'Ramadan is weakened by distraction and excess.';

  @override
  String get learningJourneyRamadanMistakesTakeaway2 =>
      'Good fasting includes guarding speech and conduct.';

  @override
  String get learningJourneyRamadanMistakesTakeaway3 =>
      'Simplicity often protects the month better than busyness.';

  @override
  String get learningJourneyRamadanMistakesReflection =>
      'Which one Ramadan habit tends to pull you away from the real purpose of the month?';

  @override
  String get learningJourneyRamadanMistakesActionStep =>
      'Choose one distraction to reduce this Ramadan so worship has more room to breathe.';

  @override
  String get learningJourneyQuranJourneyTitle => 'Journey of the Qur’an';

  @override
  String get learningJourneyQuranJourneySubtitle =>
      'Open the Book, navigate it, and build a first relationship.';

  @override
  String get learningJourneyQuranJourneyDescription =>
      'Start with the Qur’an as a living source of guidance through reading, structure, themes, and practical next steps.';

  @override
  String get learningJourneyQuranJourneyOutcome1 =>
      'Understand how to approach the Qur’an as guidance';

  @override
  String get learningJourneyQuranJourneyOutcome2 =>
      'Build a first reading rhythm from clear entry points';

  @override
  String get learningJourneyQuranJourneyOutcome3 =>
      'Use themes, notes, and tools as support rather than distraction';

  @override
  String get learningJourneyQuranJourneyWhyThisMatters =>
      'A stable relationship with the Qur’an gives the rest of the learning journey its center.';

  @override
  String get learningJourneyFatihahTitle => 'Understanding Al-Fatihah';

  @override
  String get learningJourneyFatihahSubtitle =>
      'Begin with the surah you recite every day.';

  @override
  String get learningJourneyFatihahDescription =>
      'Study Al-Fatihah verse by verse as the opening of the Qur’an and the heart of daily salah.';

  @override
  String get learningJourneyFatihahOutcome1 =>
      'Follow Al-Fatihah verse by verse';

  @override
  String get learningJourneyFatihahOutcome2 =>
      'Connect its words to daily salah';

  @override
  String get learningJourneyFatihahOutcome3 =>
      'Leave with a reflective understanding of its central themes';

  @override
  String get learningJourneyFatihahWhyThisMatters =>
      'Al-Fatihah is recited every day, so understanding it raises the meaning of salah immediately.';

  @override
  String get learningJourneyShortSurahsTitle => 'Short Surahs Journey';

  @override
  String get learningJourneyShortSurahsSubtitle =>
      'Build familiarity with the short surahs used often in prayer.';

  @override
  String get learningJourneyShortSurahsDescription =>
      'Use short surahs as an early bridge between recitation, prayer, context, and practical meaning.';

  @override
  String get learningJourneyShortSurahsOutcome1 =>
      'Learn the short surahs used often in prayer with context';

  @override
  String get learningJourneyShortSurahsOutcome2 =>
      'Notice key themes and simple takeaways from each surah';

  @override
  String get learningJourneyShortSurahsOutcome3 =>
      'Connect memorized recitation to practical reflection';

  @override
  String get learningJourneyShortSurahsWhyThisMatters =>
      'Short surahs are the easiest place to connect memorization, recitation, and meaning.';

  @override
  String get learningJourneyStageQuranOpenTitle => 'How to approach the Qur’an';

  @override
  String get learningJourneyStageQuranOpenSummary =>
      'Begin with a simple frame for reading the Qur’an as guidance, worship, and daily return.';

  @override
  String get learningJourneyStageQuranReadTitle => 'Begin reading with clarity';

  @override
  String get learningJourneyStageQuranReadSummary =>
      'Start from Al-Fatihah and learn how to make a first reading rhythm feel realistic.';

  @override
  String get learningJourneyStageQuranThemesTitle =>
      'Themes, notes, and reflection';

  @override
  String get learningJourneyStageQuranThemesSummary =>
      'Use themes and simple note-taking to notice recurring guidance without losing the main path.';

  @override
  String get learningJourneyStageQuranNextStepsTitle =>
      'Carry the Qur’an forward';

  @override
  String get learningJourneyStageQuranNextStepsSummary =>
      'Finish by choosing your next Qur’an path and a simple way to keep the relationship alive.';

  @override
  String get learningJourneyStageFatihahReadTitle =>
      'Verses 1-2: Praise and Lordship';

  @override
  String get learningJourneyStageFatihahReadSummary =>
      'Begin with the opening praise of Allah and what it means to call Him the Lord of all worlds.';

  @override
  String get learningJourneyStageFatihahRecitationTitle =>
      'Verses 3-5: Mercy, judgment, and worship';

  @override
  String get learningJourneyStageFatihahRecitationSummary =>
      'See how mercy, accountability, and exclusive worship sit at the center of Al-Fatihah.';

  @override
  String get learningJourneyStageFatihahReflectionTitle =>
      'Verses 6-7: Guidance and the straight path';

  @override
  String get learningJourneyStageFatihahReflectionSummary =>
      'Reflect on what it means to ask Allah for guidance every day inside salah.';

  @override
  String get learningJourneyStageFatihahCompletionTitle =>
      'Carry Al-Fatihah into salah';

  @override
  String get learningJourneyStageFatihahCompletionSummary =>
      'Gather the themes of Al-Fatihah and choose how to remember them when you stand in prayer.';

  @override
  String get learningJourneyStageShortSurahIkhlasTitle => 'Surah Al-Ikhlas';

  @override
  String get learningJourneyStageShortSurahIkhlasSummary =>
      'Learn the short surah of pure tawheed and why it is so central in meaning.';

  @override
  String get learningJourneyStageShortSurahFalaqTitle => 'Surah Al-Falaq';

  @override
  String get learningJourneyStageShortSurahFalaqSummary =>
      'Study this surah of seeking refuge and notice how it teaches protection through Allah.';

  @override
  String get learningJourneyStageShortSurahNasTitle => 'Surah An-Nas';

  @override
  String get learningJourneyStageShortSurahNasSummary =>
      'Learn how this short surah teaches refuge, dependence, and protection of the heart.';

  @override
  String get learningJourneyStageShortSurahKafirunTitle => 'Surah Al-Kafirun';

  @override
  String get learningJourneyStageShortSurahKafirunSummary =>
      'See how this short surah teaches clarity, loyalty to worship, and respectful firmness.';

  @override
  String get learningJourneyStageShortSurahKawtharTitle => 'Surah Al-Kawthar';

  @override
  String get learningJourneyStageShortSurahKawtharSummary =>
      'Study this short surah of abundance, gratitude, and worship through sacrifice.';

  @override
  String get learningJourneyStageShortSurahCompletionTitle =>
      'Carry short surahs into prayer';

  @override
  String get learningJourneyStageShortSurahCompletionSummary =>
      'Finish by choosing how these short surahs can deepen recitation, memory, and reflection in salah.';

  @override
  String get learningJourneyStageAlphabetCompletionTitle =>
      'Ready for reading basics';

  @override
  String get learningJourneyStageAlphabetCompletionSummary =>
      'Finish the alphabet journey by reviewing what is stable and moving into reading marks with confidence.';

  @override
  String get learningJourneyStageReadingCompletionTitle =>
      'Move into recitation understanding';

  @override
  String get learningJourneyStageReadingCompletionSummary =>
      'Finish by linking your new reading confidence to Qur’an meaning and familiar recitation.';

  @override
  String get learningJourneyStageReciteCompletionTitle =>
      'Carry meaning into worship';

  @override
  String get learningJourneyStageReciteCompletionSummary =>
      'Finish by connecting familiar phrases to prayer, dhikr, and your next Arabic or Qur’an step.';

  @override
  String get learningJourneyQuranToolSearchSubtitle =>
      'Use search when you need help finding a passage or theme.';

  @override
  String get learningJourneyQuranBookmarksSupportSubtitle =>
      'Return to places you want to revisit after reading.';

  @override
  String get learningJourneyQuranNotesSupportSubtitle =>
      'Keep brief reflections tied to verses and passages.';

  @override
  String get learningJourneyQuranOpenIntro =>
      'The Qur’an is not only a text to browse. It is guidance, recitation, remembrance, and a daily return to Allah.';

  @override
  String get learningJourneyQuranOpenSection1Title => 'A simple frame';

  @override
  String get learningJourneyQuranOpenSection1Body =>
      'Begin by seeing the Qur’an as the center of guidance. You do not need to master structure on day one. You need a calm entry and a sincere relationship.';

  @override
  String get learningJourneyQuranOpenSection2Title => 'How to begin well';

  @override
  String get learningJourneyQuranOpenSection2Body =>
      'Use one clear entry point, keep the reading gentle, and let curiosity grow after the relationship begins.';

  @override
  String get learningJourneyQuranOpenBullet1 =>
      'Start with consistency, not volume.';

  @override
  String get learningJourneyQuranOpenBullet2 =>
      'Use the reader and search as support, not the main path.';

  @override
  String get learningJourneyQuranOpenBullet3 =>
      'Return with reverence, even if the session is short.';

  @override
  String get learningJourneyQuranOpenTakeaway1 =>
      'The Qur’an should feel like a return, not a burden.';

  @override
  String get learningJourneyQuranOpenTakeaway2 =>
      'A simple starting point is enough.';

  @override
  String get learningJourneyQuranOpenTakeaway3 =>
      'Tools should support the relationship, not replace it.';

  @override
  String get learningJourneyQuranOpenReflection =>
      'What kind of Qur’an relationship are you trying to build: occasional browsing or steady return?';

  @override
  String get learningJourneyQuranReadIntro =>
      'A first reading rhythm should feel realistic enough to survive normal life. Slow, steady return is better than intense starts that disappear.';

  @override
  String get learningJourneyQuranReadSection1Title =>
      'Choose a clear beginning';

  @override
  String get learningJourneyQuranReadSection1Body =>
      'Al-Fatihah is an ideal starting point because it is short, central to prayer, and rich in meaning. It gives both structure and immediate relevance.';

  @override
  String get learningJourneyQuranReadSection2Title => 'Build a rhythm';

  @override
  String get learningJourneyQuranReadSection2Body =>
      'Tie reading to one repeatable moment. Let the habit be small enough that it survives travel, stress, and ordinary tiredness.';

  @override
  String get learningJourneyQuranReadBullet1 =>
      'Keep the first reading sessions short.';

  @override
  String get learningJourneyQuranReadBullet2 =>
      'Return to the same place if needed.';

  @override
  String get learningJourneyQuranReadBullet3 =>
      'Use bookmarks to protect continuity.';

  @override
  String get learningJourneyQuranReadTakeaway1 =>
      'Small steady reading is real progress.';

  @override
  String get learningJourneyQuranReadTakeaway2 =>
      'Al-Fatihah is a strong first doorway.';

  @override
  String get learningJourneyQuranReadTakeaway3 =>
      'Continuity matters more than intensity.';

  @override
  String get learningJourneyQuranReadReflection =>
      'Which moment of your day could realistically become your Qur’an anchor?';

  @override
  String get learningJourneyQuranThemesIntro =>
      'Themes help you notice that the Qur’an returns again and again to guidance, mercy, accountability, worship, patience, and hope.';

  @override
  String get learningJourneyQuranThemesSection1Title => 'Why themes matter';

  @override
  String get learningJourneyQuranThemesSection1Body =>
      'Themes help beginners connect verses without feeling lost. They show that the Qur’an is a coherent source of guidance, not a pile of unrelated passages.';

  @override
  String get learningJourneyQuranThemesSection2Title =>
      'Use themes without losing the path';

  @override
  String get learningJourneyQuranThemesSection2Body =>
      'Themed exploration should deepen your reading, not replace it. Use themes to notice patterns, then return to steady reading and reflection.';

  @override
  String get learningJourneyQuranThemesBullet1 =>
      'Use themes to connect recurring ideas.';

  @override
  String get learningJourneyQuranThemesBullet2 =>
      'Keep notes brief and meaningful.';

  @override
  String get learningJourneyQuranThemesBullet3 =>
      'Return to reading after thematic exploration.';

  @override
  String get learningJourneyQuranThemesTakeaway1 =>
      'Themes show the coherence of the Qur’an.';

  @override
  String get learningJourneyQuranThemesTakeaway2 =>
      'Notes help retention when kept simple.';

  @override
  String get learningJourneyQuranThemesTakeaway3 =>
      'Theme study should support, not fragment, the journey.';

  @override
  String get learningJourneyQuranThemesReflection =>
      'Which recurring theme do you most need from the Qur’an right now: mercy, guidance, patience, or accountability?';

  @override
  String get learningJourneyQuranNextStepsIntro =>
      'The best end to a Qur’an introduction is a practical next step. Choose one path that keeps the relationship alive after the first lessons.';

  @override
  String get learningJourneyQuranNextStepsSection1Title =>
      'What you have built';

  @override
  String get learningJourneyQuranNextStepsSection1Body =>
      'You now have a calmer frame for reading, structure, and themes. The next step is choosing how to deepen that relationship without clutter.';

  @override
  String get learningJourneyQuranNextStepsSection2Title =>
      'Choose one next direction';

  @override
  String get learningJourneyQuranNextStepsSection2Body =>
      'You might go deeper into Al-Fatihah, short surahs, or familiar recitation meaning. The key is to keep one clear path instead of opening everything at once.';

  @override
  String get learningJourneyQuranNextStepsBullet1 =>
      'Choose one next Qur’an journey.';

  @override
  String get learningJourneyQuranNextStepsBullet2 =>
      'Keep one reading anchor in your week.';

  @override
  String get learningJourneyQuranNextStepsBullet3 =>
      'Use notes or bookmarks only where they help continuity.';

  @override
  String get learningJourneyQuranNextStepsTakeaway1 =>
      'Clarity protects the relationship from clutter.';

  @override
  String get learningJourneyQuranNextStepsTakeaway2 =>
      'The next step should deepen the same relationship, not replace it.';

  @override
  String get learningJourneyQuranNextStepsTakeaway3 =>
      'Simple ongoing return is the real goal.';

  @override
  String get learningJourneyQuranNextStepsReflection =>
      'Which next Qur’an path feels most alive for you now: Al-Fatihah, short surahs, or familiar recitation meanings?';

  @override
  String get learningJourneyQuranNextStepsActionStep =>
      'Choose one Qur’an journey to continue this week and one day you will return to the reader again.';

  @override
  String get learningJourneyFatihahReadIntro =>
      'Al-Fatihah opens with praise, gratitude, and recognition of Allah as Lord over every world and every creature.';

  @override
  String get learningJourneyFatihahReadSection1Title => 'Verse-by-verse focus';

  @override
  String get learningJourneyFatihahReadSection1Body =>
      '“In the name of Allah” begins with dependence. “All praise is for Allah” teaches gratitude. “Lord of the worlds” reminds you that Allah cares for all creation and governs it fully.';

  @override
  String get learningJourneyFatihahReadSection2Title => 'How it enters salah';

  @override
  String get learningJourneyFatihahReadSection2Body =>
      'These opening verses teach that prayer begins with praise before asking. They re-center the heart before the rest of the surah unfolds.';

  @override
  String get learningJourneyFatihahReadBullet1 =>
      'Praise comes before requests.';

  @override
  String get learningJourneyFatihahReadBullet2 =>
      'Lordship means care, authority, and nurture.';

  @override
  String get learningJourneyFatihahReadBullet3 =>
      'Opening with Allah changes the tone of prayer.';

  @override
  String get learningJourneyFatihahReadTakeaway1 =>
      'Al-Fatihah begins with gratitude and praise.';

  @override
  String get learningJourneyFatihahReadTakeaway2 =>
      'Allah’s Lordship gives the surah its foundation.';

  @override
  String get learningJourneyFatihahReadTakeaway3 =>
      'The opening verses prepare the heart to ask.';

  @override
  String get learningJourneyFatihahReadReflection =>
      'When you begin prayer, do you feel the praise in these verses or mostly move past them quickly?';

  @override
  String get learningJourneyFatihahRecitationIntro =>
      'The middle of Al-Fatihah joins Allah’s mercy, the reality of judgment, and the believer’s promise to worship and seek help only from Him.';

  @override
  String get learningJourneyFatihahRecitationSection1Title =>
      'Verse-by-verse focus';

  @override
  String get learningJourneyFatihahRecitationSection1Body =>
      'Allah is the Most Merciful and the One who owns the Day of Judgment. Then the servant responds: You alone we worship, and You alone we ask for help.';

  @override
  String get learningJourneyFatihahRecitationSection2Title =>
      'How it enters salah';

  @override
  String get learningJourneyFatihahRecitationSection2Body =>
      'Every rak‘ah renews this promise. Salah is not only recitation. It is a repeated declaration of worship, dependence, and accountability.';

  @override
  String get learningJourneyFatihahRecitationBullet1 =>
      'Mercy and judgment appear together.';

  @override
  String get learningJourneyFatihahRecitationBullet2 =>
      'Worship and dependence belong to Allah alone.';

  @override
  String get learningJourneyFatihahRecitationBullet3 =>
      'These verses are central to the meaning of prayer.';

  @override
  String get learningJourneyFatihahRecitationTakeaway1 =>
      'The middle of Al-Fatihah teaches exclusive worship.';

  @override
  String get learningJourneyFatihahRecitationTakeaway2 =>
      'Mercy and accountability shape the believer together.';

  @override
  String get learningJourneyFatihahRecitationTakeaway3 =>
      'Salah repeats this covenant every day.';

  @override
  String get learningJourneyFatihahRecitationReflection =>
      'Which phrase feels strongest to you in prayer right now: mercy, judgment, worship, or seeking help?';

  @override
  String get learningJourneyFatihahReflectionIntro =>
      'The end of Al-Fatihah turns directly into dua: guide us to the straight path and keep us away from misguidance.';

  @override
  String get learningJourneyFatihahReflectionSection1Title =>
      'Verse-by-verse focus';

  @override
  String get learningJourneyFatihahReflectionSection1Body =>
      'Guidance is not asked for once. It is asked for repeatedly because the heart always needs help remaining straight, sincere, and steady.';

  @override
  String get learningJourneyFatihahReflectionSection2Title =>
      'How it enters salah';

  @override
  String get learningJourneyFatihahReflectionSection2Body =>
      'Every time you recite these verses in salah, you are making a direct request to Allah for direction, clarity, and protection.';

  @override
  String get learningJourneyFatihahReflectionBullet1 =>
      'Guidance is a daily need.';

  @override
  String get learningJourneyFatihahReflectionBullet2 =>
      'The straight path requires help from Allah.';

  @override
  String get learningJourneyFatihahReflectionBullet3 =>
      'Prayer ends the surah with active need, not self-sufficiency.';

  @override
  String get learningJourneyFatihahReflectionTakeaway1 =>
      'Al-Fatihah ends as a living dua.';

  @override
  String get learningJourneyFatihahReflectionTakeaway2 =>
      'Repeated guidance-seeking is part of a healthy heart.';

  @override
  String get learningJourneyFatihahReflectionTakeaway3 =>
      'The straight path is walked with divine help.';

  @override
  String get learningJourneyFatihahReflectionReflection =>
      'When you ask for guidance in Al-Fatihah, what area of life most needs it right now?';

  @override
  String get learningJourneyFatihahCompletionIntro =>
      'You have moved through Al-Fatihah as praise, worship, and dua. Now the task is to carry those meanings into daily salah.';

  @override
  String get learningJourneyFatihahCompletionSection1Title =>
      'What you have learned';

  @override
  String get learningJourneyFatihahCompletionSection1Body =>
      'Al-Fatihah begins with praise, centers worship and dependence, and ends with guidance-seeking. It teaches a full relationship between the servant and Allah.';

  @override
  String get learningJourneyFatihahCompletionSection2Title => 'What to do next';

  @override
  String get learningJourneyFatihahCompletionSection2Body =>
      'Keep one meaning alive each day in prayer. Let Al-Fatihah become something you understand and feel, not only something you repeat.';

  @override
  String get learningJourneyFatihahCompletionBullet1 =>
      'Choose one verse theme to remember in salah.';

  @override
  String get learningJourneyFatihahCompletionBullet2 =>
      'Return to the reader when needed.';

  @override
  String get learningJourneyFatihahCompletionBullet3 =>
      'Use this journey as a base for short surahs and prayer meaning.';

  @override
  String get learningJourneyFatihahCompletionTakeaway1 =>
      'Al-Fatihah contains praise, worship, and dua together.';

  @override
  String get learningJourneyFatihahCompletionTakeaway2 =>
      'Understanding it deepens every rak‘ah.';

  @override
  String get learningJourneyFatihahCompletionTakeaway3 =>
      'The next step is lived remembrance in prayer.';

  @override
  String get learningJourneyFatihahCompletionReflection =>
      'Which theme from Al-Fatihah do you most want to carry consciously into salah this week?';

  @override
  String get learningJourneyFatihahCompletionActionStep =>
      'Before one prayer today, choose one verse from Al-Fatihah and remember its meaning before you begin.';

  @override
  String get learningJourneyShortSurahContextTitle => 'Simple context';

  @override
  String get learningJourneyShortSurahThemesTitle => 'Key themes and takeaway';

  @override
  String get learningJourneyShortSurahIkhlasIntro =>
      'Surah Al-Ikhlas is short in length but immense in meaning because it teaches pure tawheed and Allah’s absolute uniqueness.';

  @override
  String get learningJourneyShortSurahIkhlasContext =>
      'This surah was revealed as a direct clarification of who Allah is: One, absolutely needed by all, and unlike creation.';

  @override
  String get learningJourneyShortSurahIkhlasThemes =>
      'Its key theme is pure monotheism. It teaches that Allah is unique, self-sufficient, and beyond human comparison, lineage, or dependence.';

  @override
  String get learningJourneyShortSurahIkhlasTakeaway1 =>
      'This surah centers pure belief in Allah’s oneness.';

  @override
  String get learningJourneyShortSurahIkhlasTakeaway2 =>
      'It clears away wrong ideas about Allah.';

  @override
  String get learningJourneyShortSurahIkhlasTakeaway3 =>
      'Its short length hides very deep meaning.';

  @override
  String get learningJourneyShortSurahIkhlasReflection =>
      'How would your worship change if Allah’s uniqueness felt more present in your heart?';

  @override
  String get learningJourneyShortSurahFalaqIntro =>
      'Surah Al-Falaq teaches the believer to seek refuge in Allah from outer harms and unseen dangers.';

  @override
  String get learningJourneyShortSurahFalaqContext =>
      'This surah was revealed as part of the Mu‘awwidhatayn, the two surahs of seeking refuge, and is often recited for protection.';

  @override
  String get learningJourneyShortSurahFalaqThemes =>
      'Its key theme is turning to Allah for protection from harm, darkness, envy, and evil that lies beyond human control.';

  @override
  String get learningJourneyShortSurahFalaqTakeaway1 =>
      'Protection begins with refuge in Allah.';

  @override
  String get learningJourneyShortSurahFalaqTakeaway2 =>
      'The surah names real harms without producing fearfulness.';

  @override
  String get learningJourneyShortSurahFalaqTakeaway3 =>
      'Seeking refuge is an act of trust, not weakness.';

  @override
  String get learningJourneyShortSurahFalaqReflection =>
      'When you feel vulnerable, do you remember refuge in Allah as quickly as you remember other protections?';

  @override
  String get learningJourneyShortSurahNasIntro =>
      'Surah An-Nas teaches refuge in Allah from the whispers that enter the heart and try to disturb faith, peace, and clarity.';

  @override
  String get learningJourneyShortSurahNasContext =>
      'Like Al-Falaq, this surah is part of the two refuge surahs and is recited regularly for protection and spiritual steadiness.';

  @override
  String get learningJourneyShortSurahNasThemes =>
      'Its key theme is protection from inner whispering, hidden harm, and the subtle influences that confuse the heart.';

  @override
  String get learningJourneyShortSurahNasTakeaway1 =>
      'The heart needs protection as much as the body.';

  @override
  String get learningJourneyShortSurahNasTakeaway2 =>
      'Allah alone can protect you from hidden whispering.';

  @override
  String get learningJourneyShortSurahNasTakeaway3 =>
      'This surah teaches vigilance without panic.';

  @override
  String get learningJourneyShortSurahNasReflection =>
      'What kind of whispering pulls your attention away from Allah most often?';

  @override
  String get learningJourneyShortSurahKafirunIntro =>
      'Surah Al-Kafirun is a short surah of clarity in worship and respectful firmness in faith.';

  @override
  String get learningJourneyShortSurahKafirunContext =>
      'It was revealed in a context where compromise in worship was proposed, and the surah answered with clear loyalty to Allah alone.';

  @override
  String get learningJourneyShortSurahKafirunThemes =>
      'Its key theme is clarity in worship. It teaches that worship cannot be mixed with compromise when it comes to who is truly worshipped.';

  @override
  String get learningJourneyShortSurahKafirunTakeaway1 =>
      'The surah teaches clarity without aggression.';

  @override
  String get learningJourneyShortSurahKafirunTakeaway2 =>
      'Worship belongs to Allah alone.';

  @override
  String get learningJourneyShortSurahKafirunTakeaway3 =>
      'Respectful firmness is part of faith.';

  @override
  String get learningJourneyShortSurahKafirunReflection =>
      'Where do you most need clearer boundaries in worship or values?';

  @override
  String get learningJourneyShortSurahKawtharIntro =>
      'Surah Al-Kawthar is a short surah of abundance, gratitude, and worship in response to Allah’s gifts.';

  @override
  String get learningJourneyShortSurahKawtharContext =>
      'It came as consolation and honor for the Prophet ﷺ, teaching that Allah’s gifts are greater than the insults of people.';

  @override
  String get learningJourneyShortSurahKawtharThemes =>
      'Its key theme is abundance from Allah and the right response to that abundance: prayer, gratitude, and sacrifice.';

  @override
  String get learningJourneyShortSurahKawtharTakeaway1 =>
      'Allah’s gifts are greater than people’s insults.';

  @override
  String get learningJourneyShortSurahKawtharTakeaway2 =>
      'Gratitude should turn into worship.';

  @override
  String get learningJourneyShortSurahKawtharTakeaway3 =>
      'A short surah can hold deep comfort and strength.';

  @override
  String get learningJourneyShortSurahKawtharReflection =>
      'How do you usually respond when Allah gives you a blessing: gratitude, distraction, or delay?';

  @override
  String get learningJourneyShortSurahCompletionIntro =>
      'These short surahs are brief enough to memorize yet deep enough to shape prayer, protection, gratitude, and belief.';

  @override
  String get learningJourneyShortSurahCompletionSection1Title =>
      'What these surahs gave you';

  @override
  String get learningJourneyShortSurahCompletionSection1Body =>
      'Together they teach tawheed, refuge, gratitude, and clarity in worship. They are not only short recitations. They are living reminders.';

  @override
  String get learningJourneyShortSurahCompletionSection2Title =>
      'How to carry them forward';

  @override
  String get learningJourneyShortSurahCompletionSection2Body =>
      'Use one short surah in prayer with extra attention this week. Let meaning travel with recitation instead of staying separate from it.';

  @override
  String get learningJourneyShortSurahCompletionBullet1 =>
      'Choose one surah to recite with more awareness.';

  @override
  String get learningJourneyShortSurahCompletionBullet2 =>
      'Connect its theme to your day.';

  @override
  String get learningJourneyShortSurahCompletionBullet3 =>
      'Use this path as a bridge into understanding what you recite.';

  @override
  String get learningJourneyShortSurahCompletionTakeaway1 =>
      'Short surahs are rich in practical guidance.';

  @override
  String get learningJourneyShortSurahCompletionTakeaway2 =>
      'Meaning deepens recitation quickly.';

  @override
  String get learningJourneyShortSurahCompletionTakeaway3 =>
      'Prayer becomes richer when familiar surahs are understood.';

  @override
  String get learningJourneyShortSurahCompletionReflection =>
      'Which short surah do you want to carry with more awareness in prayer this week?';

  @override
  String get learningJourneyShortSurahCompletionActionStep =>
      'Pick one short surah for your next few prayers and pause briefly before reciting it to remember its main theme.';

  @override
  String get learningJourneyAlphabetCompletionIntro =>
      'You now have a foundation in letter recognition and sound repetition. The next step is learning how those letters behave inside reading.';

  @override
  String get learningJourneyAlphabetCompletionSection1Title =>
      'What is stable now';

  @override
  String get learningJourneyAlphabetCompletionSection1Body =>
      'You have begun to recognize letter shapes, repeat their sounds, and return to weak points with more calm than when you started.';

  @override
  String get learningJourneyAlphabetCompletionSection2Title =>
      'Where to go next';

  @override
  String get learningJourneyAlphabetCompletionSection2Body =>
      'Reading basics adds the marks and sound rules that let letters become real words. That is the natural next step after alphabet familiarity.';

  @override
  String get learningJourneyAlphabetCompletionBullet1 =>
      'Move forward with workable confidence.';

  @override
  String get learningJourneyAlphabetCompletionBullet2 =>
      'Keep short review loops alive.';

  @override
  String get learningJourneyAlphabetCompletionBullet3 =>
      'Let reading basics build on what you now know.';

  @override
  String get learningJourneyAlphabetCompletionTakeaway1 =>
      'Letter familiarity is real progress.';

  @override
  String get learningJourneyAlphabetCompletionTakeaway2 =>
      'Review still matters after the first journey.';

  @override
  String get learningJourneyAlphabetCompletionTakeaway3 =>
      'The next step is learning how reading marks guide sound.';

  @override
  String get learningJourneyAlphabetCompletionReflection =>
      'Do you feel ready to add reading marks, or do you need one more week of alphabet review?';

  @override
  String get learningJourneyAlphabetCompletionActionStep =>
      'Open Reading Basics next and carry one short alphabet review session with you this week.';

  @override
  String get learningJourneyReadingCompletionIntro =>
      'You have moved from letters to marks, pauses, doubled sounds, and joined forms. Now those skills need to connect to living recitation.';

  @override
  String get learningJourneyReadingCompletionSection1Title =>
      'What this journey built';

  @override
  String get learningJourneyReadingCompletionSection1Body =>
      'Reading marks and joined letters are no longer abstract. You now have the beginning of reading confidence and know where your weak spots still are.';

  @override
  String get learningJourneyReadingCompletionSection2Title =>
      'Where to go next';

  @override
  String get learningJourneyReadingCompletionSection2Body =>
      'The natural next step is familiar recitation meaning: understanding what you recite in prayer and Qur’an through the reading confidence you have started to build.';

  @override
  String get learningJourneyReadingCompletionBullet1 =>
      'Take your new reading confidence into meaning.';

  @override
  String get learningJourneyReadingCompletionBullet2 =>
      'Keep reviewing the marks that still feel weak.';

  @override
  String get learningJourneyReadingCompletionBullet3 =>
      'Use Qur’an and salah journeys as the next layer.';

  @override
  String get learningJourneyReadingCompletionTakeaway1 =>
      'Reading basics is a real bridge, not a side path.';

  @override
  String get learningJourneyReadingCompletionTakeaway2 =>
      'Weak spots can still travel forward with review.';

  @override
  String get learningJourneyReadingCompletionTakeaway3 =>
      'Meaning becomes easier when reading feels less fragile.';

  @override
  String get learningJourneyReadingCompletionReflection =>
      'Which reading skill now feels strong enough to carry into actual recitation understanding?';

  @override
  String get learningJourneyReadingCompletionActionStep =>
      'Open Understand What You Recite next and take one reading mark you want to keep watching carefully.';

  @override
  String get learningJourneyReciteFatihahActionStep =>
      'In your next prayer, pause for one second before Al-Fatihah and remember that you are beginning with praise.';

  @override
  String get learningJourneyReciteShortSurahsActionStep =>
      'Choose one short surah you recite often and connect one clear theme to it before your next salah.';

  @override
  String get learningJourneyReciteMeaningActionStep =>
      'In your next prayer or dhikr, hold one phrase in your mind and let its meaning stay present while you say it.';

  @override
  String get learningJourneyReadingCheckpointActionStep =>
      'Choose one reading mark that still feels weak and give it one more calm practice loop before moving on.';

  @override
  String get learningJourneyReciteCompletionIntro =>
      'You have connected familiar recitation to meaning. Now the task is to let that meaning travel into worship, dhikr, and your next learning step.';

  @override
  String get learningJourneyReciteCompletionSection1Title =>
      'What changed in this journey';

  @override
  String get learningJourneyReciteCompletionSection1Body =>
      'Familiar phrases no longer need to stay empty or automatic. You now have simple anchors that can bring more attention into prayer and remembrance.';

  @override
  String get learningJourneyReciteCompletionSection2Title => 'What to do next';

  @override
  String get learningJourneyReciteCompletionSection2Body =>
      'Use one phrase in salah with more presence, then keep building through Qur’an journeys, dhikr routines, and Arabic learning.';

  @override
  String get learningJourneyReciteCompletionBullet1 =>
      'Choose one phrase to carry into worship.';

  @override
  String get learningJourneyReciteCompletionBullet2 =>
      'Keep connecting Arabic to actual usage.';

  @override
  String get learningJourneyReciteCompletionBullet3 =>
      'Let meaning lead you into deeper Qur’an learning.';

  @override
  String get learningJourneyReciteCompletionTakeaway1 =>
      'Meaning makes repeated phrases feel alive.';

  @override
  String get learningJourneyReciteCompletionTakeaway2 =>
      'Prayer and dhikr become more connected when phrases are understood.';

  @override
  String get learningJourneyReciteCompletionTakeaway3 =>
      'This journey is a bridge, not an endpoint.';

  @override
  String get learningJourneyReciteCompletionReflection =>
      'Which familiar phrase do you most want to keep consciously alive in worship this week?';

  @override
  String get learningJourneyReciteCompletionActionStep =>
      'Pick one phrase from prayer or dhikr and keep its meaning present the next three times you say it.';

  @override
  String get learningJourneyFaithFoundationsTitle => 'Foundations of Faith';

  @override
  String get learningJourneyFaithFoundationsSubtitle =>
      'A calm beginner path through the core beliefs of Islam.';

  @override
  String get learningJourneyFaithFoundationsDescription =>
      'Learn the main beliefs every Muslim should know, with simple explanations, Qur\'anic anchors, and clear next steps.';

  @override
  String get learningJourneyFaithFoundationsOutcome1 =>
      'Understand the main beliefs of Islam in a clear way.';

  @override
  String get learningJourneyFaithFoundationsOutcome2 =>
      'See how belief shapes worship, character, and daily life.';

  @override
  String get learningJourneyFaithFoundationsOutcome3 =>
      'Move from abstract terms to confident understanding.';

  @override
  String get learningJourneyFaithFoundationsWhyThisMatters =>
      'Strong belief gives worship direction, patience in difficulty, and clarity in daily choices.';

  @override
  String get learningJourneyFiqhBasicsTitle => 'Fiqh Basics';

  @override
  String get learningJourneyFiqhBasicsSubtitle =>
      'Practical guidance for everyday worship and choices.';

  @override
  String get learningJourneyFiqhBasicsDescription =>
      'A simple journey through core practical rulings so daily Muslim life feels clearer and less intimidating.';

  @override
  String get learningJourneyFiqhBasicsOutcome1 =>
      'Understand the difference between basic obligations and common mistakes.';

  @override
  String get learningJourneyFiqhBasicsOutcome2 =>
      'Gain confidence in cleanliness, prayer, fasting, and zakat basics.';

  @override
  String get learningJourneyFiqhBasicsOutcome3 =>
      'Handle simple everyday questions with more calm and clarity.';

  @override
  String get learningJourneyFiqhBasicsWhyThisMatters =>
      'Practical knowledge helps worship stay steady and keeps daily life grounded in what Allah loves.';

  @override
  String get learningJourneyTimelineTitle => 'Timeline of Islam';

  @override
  String get learningJourneyTimelineSubtitle =>
      'A guided historical overview from the prophets to the modern world.';

  @override
  String get learningJourneyTimelineDescription =>
      'Build a simple mental map of major Islamic eras so stories, people, and events connect more clearly.';

  @override
  String get learningJourneyTimelineOutcome1 =>
      'Understand the main eras in Islamic history.';

  @override
  String get learningJourneyTimelineOutcome2 =>
      'See how one era leads into the next.';

  @override
  String get learningJourneyTimelineOutcome3 =>
      'Place prophetic guidance and later Muslim history into a clearer story.';

  @override
  String get learningJourneyTimelineWhyThisMatters =>
      'History gives context. It helps you see how revelation shaped real communities across time.';

  @override
  String get learningJourneyDailyWisdomTitle => 'Daily Wisdom';

  @override
  String get learningJourneyDailyWisdomSubtitle =>
      'One focused reminder each day from Qur\'an, Hadith, reflection, or dhikr.';

  @override
  String get learningJourneyDailyWisdomDescription =>
      'A gentle daily touchpoint that keeps learning active without overwhelming the rest of the day.';

  @override
  String get learningJourneyDailyWisdomOutcome1 =>
      'Return to one meaningful reminder each day.';

  @override
  String get learningJourneyDailyWisdomOutcome2 =>
      'Connect daily inspiration to deeper journeys.';

  @override
  String get learningJourneyDailyWisdomOutcome3 =>
      'Keep learning alive through small, steady moments.';

  @override
  String get learningJourneyDailyWisdomWhyThisMatters =>
      'Small, consistent reminders are often more sustainable than long bursts of learning.';

  @override
  String get learningJourneyStoriesSignsTitle => 'Stories & Signs';

  @override
  String get learningJourneyStoriesSignsSubtitle =>
      'Reflect on creation through Qur\'anic signs in the world around you.';

  @override
  String get learningJourneyStoriesSignsDescription =>
      'A reflective journey through the sky, oceans, mountains, animals, human creation, and the rhythm of day and night.';

  @override
  String get learningJourneyStoriesSignsOutcome1 =>
      'Notice Qur\'anic signs in the world more intentionally.';

  @override
  String get learningJourneyStoriesSignsOutcome2 =>
      'Link reflection on creation to gratitude and faith.';

  @override
  String get learningJourneyStoriesSignsOutcome3 =>
      'Turn observation into remembrance and humility.';

  @override
  String get learningJourneyStoriesSignsWhyThisMatters =>
      'Allah repeatedly calls us to reflect on creation so our hearts soften, our minds awaken, and our gratitude grows.';

  @override
  String get learningJourneyStageFaithCompletionTitle =>
      'Completion Reflection';

  @override
  String get learningJourneyStageFaithCompletionSummary =>
      'Gather the core beliefs together and decide what to study next.';

  @override
  String get learningJourneyStageFiqhHalalTitle => 'Halal and Haram';

  @override
  String get learningJourneyStageFiqhHalalSummary =>
      'Learn a simple way to think about what is allowed, forbidden, and doubtful.';

  @override
  String get learningJourneyStageFiqhCleanlinessTitle => 'Cleanliness';

  @override
  String get learningJourneyStageFiqhCleanlinessSummary =>
      'See why purity and cleanliness matter in worship and daily living.';

  @override
  String get learningJourneyStageFiqhPrayerTitle => 'Prayer Basics';

  @override
  String get learningJourneyStageFiqhPrayerSummary =>
      'Understand the core rules that frame salah without getting lost in detail.';

  @override
  String get learningJourneyStageFiqhFastingTitle => 'Fasting Basics';

  @override
  String get learningJourneyStageFiqhFastingSummary =>
      'Learn the foundations of fasting, intention, and common misunderstandings.';

  @override
  String get learningJourneyStageFiqhZakatTitle => 'Zakat Basics';

  @override
  String get learningJourneyStageFiqhZakatSummary =>
      'Understand the purpose of zakat and when it becomes important to learn more.';

  @override
  String get learningJourneyStageFiqhDailyLifeTitle => 'Daily Life Scenarios';

  @override
  String get learningJourneyStageFiqhDailyLifeSummary =>
      'Apply simple fiqh thinking to ordinary questions and choices.';

  @override
  String get learningJourneyStageFiqhCompletionTitle => 'Practical Review';

  @override
  String get learningJourneyStageFiqhCompletionSummary =>
      'Review the essentials and choose the next worship journey to strengthen.';

  @override
  String get learningJourneyStageTimelineEarlyProphetsTitle =>
      'Early Prophets Overview';

  @override
  String get learningJourneyStageTimelineEarlyProphetsSummary =>
      'Start with the earliest prophetic stories and the pattern they establish.';

  @override
  String get learningJourneyStageTimelineProphetEraTitle =>
      'The Era of Prophet Muhammad';

  @override
  String get learningJourneyStageTimelineProphetEraSummary =>
      'See how revelation transformed a community during the life of the Prophet.';

  @override
  String get learningJourneyStageTimelineKhulafaTitle =>
      'The Rightly Guided Caliphs';

  @override
  String get learningJourneyStageTimelineKhulafaSummary =>
      'Learn how leadership continued after the Prophet with service and responsibility.';

  @override
  String get learningJourneyStageTimelineExpansionTitle => 'Expansion of Islam';

  @override
  String get learningJourneyStageTimelineExpansionSummary =>
      'Understand how Islam spread across lands, peoples, and cultures.';

  @override
  String get learningJourneyStageTimelineGoldenAgeTitle => 'The Golden Age';

  @override
  String get learningJourneyStageTimelineGoldenAgeSummary =>
      'See how knowledge, scholarship, and civilization developed over time.';

  @override
  String get learningJourneyStageTimelineModernTitle => 'Modern Context';

  @override
  String get learningJourneyStageTimelineModernSummary =>
      'Reflect on the modern Muslim world with humility and perspective.';

  @override
  String get learningJourneyStageTimelineCompletionTitle =>
      'Timeline Reflection';

  @override
  String get learningJourneyStageTimelineCompletionSummary =>
      'Pull the major eras together and choose where to go deeper next.';

  @override
  String get learningJourneyStageStoriesSkyTitle => 'Sky and Stars';

  @override
  String get learningJourneyStageStoriesSkySummary =>
      'Reflect on the order, beauty, and signs in the heavens.';

  @override
  String get learningJourneyStageStoriesOceanTitle => 'Ocean';

  @override
  String get learningJourneyStageStoriesOceanSummary =>
      'Reflect on power, provision, and dependence through the sea.';

  @override
  String get learningJourneyStageStoriesMountainsTitle => 'Mountains';

  @override
  String get learningJourneyStageStoriesMountainsSummary =>
      'Reflect on stability, scale, and quiet signs of Allah\'s wisdom.';

  @override
  String get learningJourneyStageStoriesAnimalsTitle => 'Animals';

  @override
  String get learningJourneyStageStoriesAnimalsSummary =>
      'Notice mercy, design, and benefit in the creatures around us.';

  @override
  String get learningJourneyStageStoriesHumanCreationTitle => 'Human Creation';

  @override
  String get learningJourneyStageStoriesHumanCreationSummary =>
      'Reflect on origin, purpose, and the dignity Allah gave human beings.';

  @override
  String get learningJourneyStageStoriesDayNightTitle => 'Day and Night';

  @override
  String get learningJourneyStageStoriesDayNightSummary =>
      'Reflect on rhythm, rest, and the passage of life through time.';

  @override
  String get learningJourneyStageStoriesCompletionTitle =>
      'Reflection and Next Steps';

  @override
  String get learningJourneyStageStoriesCompletionSummary =>
      'Gather the signs you noticed and carry them into deeper learning.';

  @override
  String get learningJourneyFaithSection1Title => 'What this teaches';

  @override
  String get learningJourneyFaithSection2Title => 'What this means in life';

  @override
  String get learningJourneyFaithWhoIsAllahTitle => 'Who is Allah?';

  @override
  String get learningJourneyFaithWhoIsAllahIntro =>
      'This lesson introduces the most important truth: Allah is the Creator, Sustainer, and only One worthy of worship.';

  @override
  String get learningJourneyFaithWhoIsAllahSection1Body =>
      'Allah created everything, owns everything, and is perfect in every way. He is not like creation. He was not born, and He does not depend on anyone.';

  @override
  String get learningJourneyFaithWhoIsAllahSection2Body =>
      'Knowing Allah changes how you live. It brings trust in difficulty, gratitude in blessings, and sincerity in worship because your heart turns to Him first.';

  @override
  String get learningJourneyFaithWhoIsAllahTakeaway1 =>
      'Allah is unique and unlike His creation.';

  @override
  String get learningJourneyFaithWhoIsAllahTakeaway2 =>
      'All worship belongs to Allah alone.';

  @override
  String get learningJourneyFaithWhoIsAllahTakeaway3 =>
      'Knowing Allah gives the heart direction and peace.';

  @override
  String get learningJourneyFaithWhoIsAllahReflection =>
      'When you call upon Allah today, what does it mean to remember who He is?';

  @override
  String get learningJourneyFaithTawheedTitle => 'Tawheed';

  @override
  String get learningJourneyFaithTawheedIntro =>
      'Tawheed means singling out Allah alone in worship, love, hope, fear, and reliance.';

  @override
  String get learningJourneyFaithTawheedSection1Body =>
      'A Muslim believes that Allah alone deserves prayer, trust, sacrifice, and ultimate obedience. Tawheed is not only a statement. It is a way of turning the heart fully to Allah.';

  @override
  String get learningJourneyFaithTawheedSection2Body =>
      'In daily life, tawheed means asking Allah before creation, seeking His help first, and guarding your worship from showing off or depending on what cannot truly save you.';

  @override
  String get learningJourneyFaithTawheedTakeaway1 =>
      'Tawheed is the center of Islam.';

  @override
  String get learningJourneyFaithTawheedTakeaway2 =>
      'Worship is not only rituals. It includes the state of the heart.';

  @override
  String get learningJourneyFaithTawheedTakeaway3 =>
      'Tawheed gives life a single clear direction.';

  @override
  String get learningJourneyFaithTawheedReflection =>
      'Where in your life do you most need to renew your reliance on Allah alone?';

  @override
  String get learningJourneyFaithNamesTitle => 'Names of Allah';

  @override
  String get learningJourneyFaithNamesIntro =>
      'Allah has beautiful names that teach us who He is and how we should turn to Him.';

  @override
  String get learningJourneyFaithNamesSection1Body =>
      'The names of Allah are not random labels. Each name teaches perfection, mercy, knowledge, power, wisdom, and care. They help the heart know Allah more deeply.';

  @override
  String get learningJourneyFaithNamesSection2Body =>
      'When you learn a name such as Ar-Rahman or Al-Hakim, you begin to notice that Allah\'s mercy and wisdom touch every part of life. This brings hope, patience, and awe.';

  @override
  String get learningJourneyFaithNamesTakeaway1 =>
      'Allah\'s names help you know Him more truly.';

  @override
  String get learningJourneyFaithNamesTakeaway2 =>
      'Every name points to perfection, not limitation.';

  @override
  String get learningJourneyFaithNamesTakeaway3 =>
      'Learning the names of Allah can deepen worship and dua.';

  @override
  String get learningJourneyFaithNamesReflection =>
      'Which name of Allah do you want to learn more deeply this week, and why?';

  @override
  String get learningJourneyFaithAngelsTitle => 'Angels';

  @override
  String get learningJourneyFaithAngelsIntro =>
      'Angels are honored servants of Allah who obey Him completely and carry out the tasks He assigns.';

  @override
  String get learningJourneyFaithAngelsSection1Body =>
      'Angels are part of the unseen world. They do not disobey Allah. Some bring revelation, some record deeds, and some have responsibilities known only to Allah.';

  @override
  String get learningJourneyFaithAngelsSection2Body =>
      'Belief in angels reminds you that life is not only what you can see. It encourages sincerity, careful speech, and reverence for Allah\'s perfect order.';

  @override
  String get learningJourneyFaithAngelsTakeaway1 =>
      'Angels belong to the unseen creation of Allah.';

  @override
  String get learningJourneyFaithAngelsTakeaway2 =>
      'They obey Allah without rebellion.';

  @override
  String get learningJourneyFaithAngelsTakeaway3 =>
      'Belief in angels nurtures awareness and sincerity.';

  @override
  String get learningJourneyFaithAngelsReflection =>
      'How would your habits change if you stayed more aware that your deeds are being recorded?';

  @override
  String get learningJourneyFaithCompletionIntro =>
      'You have moved through the core beliefs of Islam. This final stage gathers them into one clear picture and points you toward the next step.';

  @override
  String get learningJourneyFaithCompletionSection1Title =>
      'What you now carry';

  @override
  String get learningJourneyFaithCompletionSection1Body =>
      'Faith is not a set of isolated topics. Belief in Allah, His angels, His books, His messengers, the Last Day, and qadr all work together to shape how you worship, hope, fear, and live.';

  @override
  String get learningJourneyFaithCompletionSection2Title => 'Where to go next';

  @override
  String get learningJourneyFaithCompletionSection2Body =>
      'The strongest next step is to let these beliefs deepen through Qur\'an, prophetic stories, and daily worship. The more belief is revisited, the more it becomes lived conviction rather than vocabulary.';

  @override
  String get learningJourneyFaithCompletionTakeaway1 =>
      'Faith is a connected worldview, not a list to memorize.';

  @override
  String get learningJourneyFaithCompletionTakeaway2 =>
      'Core beliefs should shape daily worship and character.';

  @override
  String get learningJourneyFaithCompletionTakeaway3 =>
      'The next step is to revisit belief through Qur\'an and prophetic guidance.';

  @override
  String get learningJourneyFaithCompletionReflection =>
      'Which part of your faith feels clearest now, and which part do you want to revisit next?';

  @override
  String get learningJourneyFaithCompletionActionStep =>
      'Choose one belief to revisit this week through Qur\'an recitation or a prophet story.';

  @override
  String get learningJourneyFiqhSection1Title => 'Practical idea';

  @override
  String get learningJourneyFiqhSection2Title => 'Everyday example';

  @override
  String get learningJourneyFiqhHalalIntro =>
      'Fiqh begins with learning how to obey Allah in a practical way. One of the first ideas is understanding what is halal, haram, and doubtful.';

  @override
  String get learningJourneyFiqhHalalSection1Body =>
      'Halal means what Allah has allowed. Haram means what He has forbidden. Between them are matters that may feel unclear to ordinary people and require caution, learning, or asking someone qualified.';

  @override
  String get learningJourneyFiqhHalalSection2Body =>
      'If you are unsure about something, a safe pattern is to slow down, avoid guessing, and seek knowledge. This protects the heart from treating religion casually.';

  @override
  String get learningJourneyFiqhHalalTakeaway1 =>
      'Not every question needs a rushed answer.';

  @override
  String get learningJourneyFiqhHalalTakeaway2 =>
      'Clear halal and clear haram help anchor daily life.';

  @override
  String get learningJourneyFiqhHalalTakeaway3 =>
      'Caution is part of sincerity when knowledge is limited.';

  @override
  String get learningJourneyFiqhHalalReflection =>
      'What is one area of life where you need more carefulness instead of assumptions?';

  @override
  String get learningJourneyFiqhCleanlinessIntro =>
      'Islam gives great importance to purity, cleanliness, and preparation. This is part of honoring worship and daily dignity.';

  @override
  String get learningJourneyFiqhCleanlinessSection1Body =>
      'Cleanliness in Islam is both physical and spiritual. Keeping the body, clothes, and prayer place clean supports worship and reflects respect for Allah\'s commands.';

  @override
  String get learningJourneyFiqhCleanlinessSection2Body =>
      'Simple habits such as keeping prayer clothes clean, learning basic purification, and staying orderly before salah make worship feel steadier and less rushed.';

  @override
  String get learningJourneyFiqhCleanlinessTakeaway1 =>
      'Purity matters because worship matters.';

  @override
  String get learningJourneyFiqhCleanlinessTakeaway2 =>
      'Clean habits support focused prayer.';

  @override
  String get learningJourneyFiqhCleanlinessTakeaway3 =>
      'Practical preparation reduces confusion before worship.';

  @override
  String get learningJourneyFiqhCleanlinessReflection =>
      'Which small habit would make your prayer preparation cleaner and calmer?';

  @override
  String get learningJourneyFiqhPrayerIntro =>
      'Prayer has an outward structure and inward purpose. This stage gives you the basic fiqh frame without overloading you with differences of detail.';

  @override
  String get learningJourneyFiqhPrayerSection1Body =>
      'Every Muslim should know that salah has set times, required conditions, and essential actions. Learning the basics first is better than becoming overwhelmed by advanced differences.';

  @override
  String get learningJourneyFiqhPrayerSection2Body =>
      'If you are new or rebuilding consistency, focus on praying on time, learning the essentials correctly, and improving one step at a time with humility.';

  @override
  String get learningJourneyFiqhPrayerTakeaway1 =>
      'Prayer has a clear framework that can be learned step by step.';

  @override
  String get learningJourneyFiqhPrayerTakeaway2 =>
      'Starting with the essentials is the soundest path for beginners.';

  @override
  String get learningJourneyFiqhPrayerTakeaway3 =>
      'Consistency matters more than perfection on day one.';

  @override
  String get learningJourneyFiqhPrayerReflection =>
      'What part of your prayer routine would benefit most from calm review instead of pressure?';

  @override
  String get learningJourneyFiqhFastingIntro =>
      'Fasting is one of the major acts of worship in Islam. Its basics are simple, but knowing them clearly helps avoid uncertainty.';

  @override
  String get learningJourneyFiqhFastingSection1Body =>
      'Fasting in Ramadan means making the intention, avoiding what breaks the fast from dawn to sunset, and protecting the heart and limbs from harmful behavior.';

  @override
  String get learningJourneyFiqhFastingSection2Body =>
      'If questions come up, such as travel, illness, or mistakes, the best path is to learn the foundations first and then ask qualified scholars about personal situations.';

  @override
  String get learningJourneyFiqhFastingTakeaway1 =>
      'Fasting is both bodily restraint and spiritual discipline.';

  @override
  String get learningJourneyFiqhFastingTakeaway2 =>
      'Basic knowledge reduces unnecessary anxiety during Ramadan.';

  @override
  String get learningJourneyFiqhFastingTakeaway3 =>
      'More detailed cases should be learned with trustworthy guidance.';

  @override
  String get learningJourneyFiqhFastingReflection =>
      'How could clearer fasting knowledge help you focus more on worship than uncertainty?';

  @override
  String get learningJourneyFiqhZakatIntro =>
      'Zakat purifies wealth and helps care for people in need. Even before zakat becomes due, understanding its purpose is important.';

  @override
  String get learningJourneyFiqhZakatSection1Body =>
      'Zakat is not only a financial rule. It is an act of worship, gratitude, and social responsibility. It reminds Muslims that wealth is a trust from Allah.';

  @override
  String get learningJourneyFiqhZakatSection2Body =>
      'If you do not yet own enough wealth for zakat, it is still beneficial to understand its purpose so generosity and care for others grow early in the heart.';

  @override
  String get learningJourneyFiqhZakatTakeaway1 =>
      'Zakat is worship, not just accounting.';

  @override
  String get learningJourneyFiqhZakatTakeaway2 =>
      'Wealth is a trust from Allah.';

  @override
  String get learningJourneyFiqhZakatTakeaway3 =>
      'Learning zakat early builds a healthier view of money and responsibility.';

  @override
  String get learningJourneyFiqhZakatReflection =>
      'How can you practice generosity now, even before detailed zakat questions apply to you?';

  @override
  String get learningJourneyFiqhDailyLifeIntro =>
      'Fiqh becomes most useful when it helps you think clearly in ordinary situations instead of feeling lost or intimidated.';

  @override
  String get learningJourneyFiqhDailyLifeSection1Body =>
      'Daily life questions often begin small: Is this clean enough for prayer? Do I need wudu again? Is this action safe or doubtful? Sound fiqh starts with calm basics rather than panic.';

  @override
  String get learningJourneyFiqhDailyLifeSection2Body =>
      'A practical Muslim learns what is needed, avoids pretending to know what they do not know, and asks trustworthy scholars when a personal case becomes more complex.';

  @override
  String get learningJourneyFiqhDailyLifeTakeaway1 =>
      'Fiqh should help daily life feel clearer, not heavier.';

  @override
  String get learningJourneyFiqhDailyLifeTakeaway2 =>
      'Not knowing everything is normal. Honest learning matters.';

  @override
  String get learningJourneyFiqhDailyLifeTakeaway3 =>
      'Good questions are part of sincere worship.';

  @override
  String get learningJourneyFiqhDailyLifeReflection =>
      'What ordinary worship question do you want to learn properly next?';

  @override
  String get learningJourneyFiqhCompletionIntro =>
      'You now have a simple practical map for several important areas of Muslim life. This final stage helps you turn knowledge into steady action.';

  @override
  String get learningJourneyFiqhCompletionSection1Title => 'What fiqh is for';

  @override
  String get learningJourneyFiqhCompletionSection1Body =>
      'Fiqh is not meant to create fear or arguments. It is meant to help you worship Allah correctly, avoid confusion, and live with more confidence and discipline.';

  @override
  String get learningJourneyFiqhCompletionSection2Title => 'Your next step';

  @override
  String get learningJourneyFiqhCompletionSection2Body =>
      'The best next step is to deepen one practical area you need right now, such as wudu, salah, or Ramadan. Focused learning is easier to apply than trying to master everything at once.';

  @override
  String get learningJourneyFiqhCompletionTakeaway1 =>
      'Practical knowledge should lead to practice.';

  @override
  String get learningJourneyFiqhCompletionTakeaway2 =>
      'Focused study is more sustainable than scattered study.';

  @override
  String get learningJourneyFiqhCompletionTakeaway3 =>
      'Wudu, salah, and Ramadan are natural next areas to strengthen.';

  @override
  String get learningJourneyFiqhCompletionReflection =>
      'Which practical worship area would most improve your daily life if you strengthened it next?';

  @override
  String get learningJourneyFiqhCompletionActionStep =>
      'Choose one worship area to review again this week and act on one lesson from it.';

  @override
  String get learningJourneyTimelineSection1Title => 'What happened';

  @override
  String get learningJourneyTimelineSection2Title => 'Why it matters';

  @override
  String get learningJourneyTimelineEarlyProphetsIntro =>
      'Islamic history begins long before the final Prophet. The earliest prophetic stories establish patterns of guidance, struggle, and mercy.';

  @override
  String get learningJourneyTimelineEarlyProphetsSection1Body =>
      'From Adam to Nuh, Ibrahim, Musa, and Isa, the prophets called people back to Allah again and again. Their stories differ, but the call to worship Allah alone stays consistent.';

  @override
  String get learningJourneyTimelineEarlyProphetsSection2Body =>
      'This early history gives you a foundation. It shows that Islam is not a disconnected new idea. It is the continuation of the same message taught by the prophets.';

  @override
  String get learningJourneyTimelineEarlyProphetsTakeaway1 =>
      'Islam continues the message of earlier prophets.';

  @override
  String get learningJourneyTimelineEarlyProphetsTakeaway2 =>
      'The core call stayed the same across generations.';

  @override
  String get learningJourneyTimelineEarlyProphetsTakeaway3 =>
      'History begins with guidance, not random events.';

  @override
  String get learningJourneyTimelineEarlyProphetsReflection =>
      'How does seeing the prophets as one connected chain change your view of Islam?';

  @override
  String get learningJourneyTimelineProphetEraIntro =>
      'The life of Prophet Muhammad brought revelation into a real community, with hardship, worship, teaching, and social transformation.';

  @override
  String get learningJourneyTimelineProphetEraSection1Body =>
      'The Makkan years built faith, patience, and steadfastness. The Madinan years built community, law, leadership, and social order under revelation.';

  @override
  String get learningJourneyTimelineProphetEraSection2Body =>
      'This era matters because it shows how belief moved from private conviction into lived community. It is the model Muslims keep returning to for guidance.';

  @override
  String get learningJourneyTimelineProphetEraTakeaway1 =>
      'The Prophetic era joined belief, worship, and community life.';

  @override
  String get learningJourneyTimelineProphetEraTakeaway2 =>
      'Makkah and Madinah each taught different lessons.';

  @override
  String get learningJourneyTimelineProphetEraTakeaway3 =>
      'This period remains the central lived model for Muslims.';

  @override
  String get learningJourneyTimelineProphetEraReflection =>
      'Which part of the Prophetic era do you most want to understand better right now?';

  @override
  String get learningJourneyTimelineKhulafaIntro =>
      'After the Prophet, the rightly guided caliphs carried major responsibility for preserving unity, justice, and service.';

  @override
  String get learningJourneyTimelineKhulafaSection1Body =>
      'Abu Bakr, Umar, Uthman, and Ali each faced different tests. Their era included leadership decisions, expansion, challenges, and the heavy work of guiding a growing community.';

  @override
  String get learningJourneyTimelineKhulafaSection2Body =>
      'Learning about this period helps you see that strong leadership requires knowledge, humility, courage, and patience during both ease and conflict.';

  @override
  String get learningJourneyTimelineKhulafaTakeaway1 =>
      'The khulafa led in very demanding times.';

  @override
  String get learningJourneyTimelineKhulafaTakeaway2 =>
      'Leadership in Islam involves service and accountability.';

  @override
  String get learningJourneyTimelineKhulafaTakeaway3 =>
      'Historical complexity should lead to humility, not shallow judgment.';

  @override
  String get learningJourneyTimelineKhulafaReflection =>
      'What quality of leadership stands out most to you from this era?';

  @override
  String get learningJourneyTimelineExpansionIntro =>
      'Islam spread across many lands and peoples over time, bringing new languages, cultures, and responsibilities into the Muslim story.';

  @override
  String get learningJourneyTimelineExpansionSection1Body =>
      'As Muslim lands expanded, communities carried worship, scholarship, trade, and governance into many regions. Expansion brought opportunities as well as tests.';

  @override
  String get learningJourneyTimelineExpansionSection2Body =>
      'This stage helps you see that Muslim history became global very early. Islam was not limited to one tribe or one region. Its guidance reached many peoples and contexts.';

  @override
  String get learningJourneyTimelineExpansionTakeaway1 =>
      'Islamic history quickly became wider than Arabia.';

  @override
  String get learningJourneyTimelineExpansionTakeaway2 =>
      'Growth brings both opportunity and responsibility.';

  @override
  String get learningJourneyTimelineExpansionTakeaway3 =>
      'A global Muslim history requires broad perspective.';

  @override
  String get learningJourneyTimelineExpansionReflection =>
      'How does seeing Islam as a global history change the way you think about the ummah?';

  @override
  String get learningJourneyTimelineGoldenAgeIntro =>
      'Across different centuries, Muslim civilization produced scholarship, institutions, and contributions that served both faith and society.';

  @override
  String get learningJourneyTimelineGoldenAgeSection1Body =>
      'Scholars, jurists, teachers, scientists, and builders contributed to a rich civilization rooted in revelation and learning. This period included study, preservation, commentary, and service.';

  @override
  String get learningJourneyTimelineGoldenAgeSection2Body =>
      'This matters because it shows that faith and learning are not enemies. A community grounded in revelation can also cultivate knowledge, beauty, and social benefit.';

  @override
  String get learningJourneyTimelineGoldenAgeTakeaway1 =>
      'Islamic civilization valued knowledge deeply.';

  @override
  String get learningJourneyTimelineGoldenAgeTakeaway2 =>
      'Faith and learning can strengthen each other.';

  @override
  String get learningJourneyTimelineGoldenAgeTakeaway3 =>
      'Muslim history includes intellectual and civilizational achievement.';

  @override
  String get learningJourneyTimelineGoldenAgeReflection =>
      'What kind of beneficial knowledge do you hope Muslims continue to revive today?';

  @override
  String get learningJourneyTimelineModernIntro =>
      'The modern period is complex. Muslims live in many societies and face new questions while still returning to timeless revelation.';

  @override
  String get learningJourneyTimelineModernSection1Body =>
      'Modern Muslim life includes diversity of cultures, political realities, migration, technology, and new social pressures. Not every modern problem has a simple summary.';

  @override
  String get learningJourneyTimelineModernSection2Body =>
      'This stage encourages perspective rather than despair. The ummah has passed through many changes before. Muslims still return to Qur\'an, Sunnah, and trustworthy scholarship for direction.';

  @override
  String get learningJourneyTimelineModernTakeaway1 =>
      'Modern life is complex, but guidance remains available.';

  @override
  String get learningJourneyTimelineModernTakeaway2 =>
      'The ummah is diverse and global.';

  @override
  String get learningJourneyTimelineModernTakeaway3 =>
      'Perspective and grounded learning protect against confusion.';

  @override
  String get learningJourneyTimelineModernReflection =>
      'What helps you stay grounded in guidance amid modern noise and complexity?';

  @override
  String get learningJourneyTimelineCompletionIntro =>
      'You now have a simple map of major Islamic eras. This final stage is about turning that map into deeper curiosity and more focused study.';

  @override
  String get learningJourneyTimelineCompletionSection1Title =>
      'The connected story';

  @override
  String get learningJourneyTimelineCompletionSection1Body =>
      'Islamic history is not a pile of separate facts. Prophetic guidance, community life, scholarship, and global expansion all connect into one long story of revelation, response, struggle, and service.';

  @override
  String get learningJourneyTimelineCompletionSection2Title => 'Your next step';

  @override
  String get learningJourneyTimelineCompletionSection2Body =>
      'Choose one lane to deepen next: prophets, seerah, Qur\'an, or character. Deeper study becomes easier once you know where each era fits in the broader story.';

  @override
  String get learningJourneyTimelineCompletionTakeaway1 =>
      'A simple historical map makes deeper study easier.';

  @override
  String get learningJourneyTimelineCompletionTakeaway2 =>
      'The Muslim story includes revelation, leadership, knowledge, and global change.';

  @override
  String get learningJourneyTimelineCompletionTakeaway3 =>
      'Focused next steps are better than trying to learn all history at once.';

  @override
  String get learningJourneyTimelineCompletionReflection =>
      'Which era of Islamic history do you most want to explore more deeply now?';

  @override
  String get learningJourneyTimelineCompletionActionStep =>
      'Pick one era and connect it to a journey, such as Seerah, Prophets, or Qur\'an.';

  @override
  String get learningJourneyStoriesSection1Title => 'What you can notice';

  @override
  String get learningJourneyStoriesSection2Title => 'What it means for you';

  @override
  String get learningJourneyStoriesSkyIntro =>
      'The sky and stars invite quiet reflection. The Qur\'an repeatedly calls people to notice the order and beauty above them.';

  @override
  String get learningJourneyStoriesSkySection1Body =>
      'The heavens show proportion, beauty, and order beyond human power. Looking up can become a form of reflection that leads the heart toward awe of Allah\'s creation.';

  @override
  String get learningJourneyStoriesSkySection2Body =>
      'This is not only information about space. It is a reminder that your life sits inside a vast creation ruled perfectly by Allah. That can reduce pride and increase gratitude.';

  @override
  String get learningJourneyStoriesSkyTakeaway1 =>
      'The sky invites awe and humility.';

  @override
  String get learningJourneyStoriesSkyTakeaway2 =>
      'Order in creation points to Allah\'s wisdom.';

  @override
  String get learningJourneyStoriesSkyTakeaway3 =>
      'Reflection begins by paying attention.';

  @override
  String get learningJourneyStoriesSkyReflection =>
      'When was the last time you looked at the sky and let it lead you to remembrance?';

  @override
  String get learningJourneyStoriesOceanIntro =>
      'The ocean reflects power, provision, beauty, and danger all at once. The Qur\'an points to the sea as a sign for those who reflect.';

  @override
  String get learningJourneyStoriesOceanSection1Body =>
      'The sea carries people, feeds communities, and reveals human weakness before Allah\'s power. Its depth and movement remind us that creation is both useful and humbling.';

  @override
  String get learningJourneyStoriesOceanSection2Body =>
      'Reflecting on the sea can teach dependence on Allah. Even powerful people become small before storms, distance, and forces they do not control.';

  @override
  String get learningJourneyStoriesOceanTakeaway1 =>
      'The sea shows both mercy and power.';

  @override
  String get learningJourneyStoriesOceanTakeaway2 =>
      'Creation can provide for us while reminding us of our limits.';

  @override
  String get learningJourneyStoriesOceanTakeaway3 =>
      'Dependence on Allah becomes clearer through reflection.';

  @override
  String get learningJourneyStoriesOceanReflection =>
      'Where in life do you most need to remember your dependence on Allah?';

  @override
  String get learningJourneyStoriesMountainsIntro =>
      'Mountains appear throughout the Qur\'an as signs of stability, power, and perspective.';

  @override
  String get learningJourneyStoriesMountainsSection1Body =>
      'Mountains anchor landscapes and tower over what is around them. Their presence reminds people that Allah created the earth with wisdom and balance.';

  @override
  String get learningJourneyStoriesMountainsSection2Body =>
      'For the believer, mountains can become a reminder to seek steadiness in faith. Not everything around you should move your heart so easily.';

  @override
  String get learningJourneyStoriesMountainsTakeaway1 =>
      'Mountains point to stability and strength.';

  @override
  String get learningJourneyStoriesMountainsTakeaway2 =>
      'Creation teaches with scale as well as detail.';

  @override
  String get learningJourneyStoriesMountainsTakeaway3 =>
      'Steadiness in faith is a quality worth seeking.';

  @override
  String get learningJourneyStoriesMountainsReflection =>
      'What would steadiness in faith look like in your life this week?';

  @override
  String get learningJourneyStoriesAnimalsIntro =>
      'Animals are signs of Allah\'s mercy, design, and care. They are part of the world we benefit from and reflect upon.';

  @override
  String get learningJourneyStoriesAnimalsSection1Body =>
      'Animals provide food, transport, companionship, and lessons. The Qur\'an draws attention to them so people notice design, provision, and the diversity of creation.';

  @override
  String get learningJourneyStoriesAnimalsSection2Body =>
      'Reflecting on animals can soften the heart. You begin to see mercy, dependence, and the wisdom of a Lord who provides for countless creatures every day.';

  @override
  String get learningJourneyStoriesAnimalsTakeaway1 =>
      'Animals are signs, not background details.';

  @override
  String get learningJourneyStoriesAnimalsTakeaway2 =>
      'Creation reflects Allah\'s mercy and care.';

  @override
  String get learningJourneyStoriesAnimalsTakeaway3 =>
      'Looking closely can turn ordinary sights into remembrance.';

  @override
  String get learningJourneyStoriesAnimalsReflection =>
      'What creature around you most easily reminds you of Allah\'s care?';

  @override
  String get learningJourneyStoriesHumanCreationIntro =>
      'Reflecting on human creation helps us remember both our dignity and our dependence on Allah.';

  @override
  String get learningJourneyStoriesHumanCreationSection1Body =>
      'Human beings were created with purpose, honored by Allah, and given responsibility. At the same time, our beginning is humble and our need for Allah never disappears.';

  @override
  String get learningJourneyStoriesHumanCreationSection2Body =>
      'This reflection guards against two extremes: pride and self-neglect. You are not meaningless, but you are not self-sufficient either.';

  @override
  String get learningJourneyStoriesHumanCreationTakeaway1 =>
      'Human life has purpose and dignity.';

  @override
  String get learningJourneyStoriesHumanCreationTakeaway2 =>
      'Our beginning and end call us to humility.';

  @override
  String get learningJourneyStoriesHumanCreationTakeaway3 =>
      'Purpose grows when we remember who created us.';

  @override
  String get learningJourneyStoriesHumanCreationReflection =>
      'How can remembering your origin and purpose change the way you live today?';

  @override
  String get learningJourneyStoriesDayNightIntro =>
      'The rhythm of day and night is one of the clearest signs around us. It shapes worship, work, rest, and reflection.';

  @override
  String get learningJourneyStoriesDayNightSection1Body =>
      'Day and night alternate with perfect order. This rhythm makes life possible and reminds us that time itself is a gift entrusted to us by Allah.';

  @override
  String get learningJourneyStoriesDayNightSection2Body =>
      'When you reflect on time, you begin to treat your day more carefully. Morning, evening, work, worship, and rest all become spaces to remember Allah intentionally.';

  @override
  String get learningJourneyStoriesDayNightTakeaway1 =>
      'Day and night are signs of order and mercy.';

  @override
  String get learningJourneyStoriesDayNightTakeaway2 =>
      'Time is one of the most valuable trusts you carry.';

  @override
  String get learningJourneyStoriesDayNightTakeaway3 =>
      'Reflection on time can improve daily intention.';

  @override
  String get learningJourneyStoriesDayNightReflection =>
      'Which part of your day would benefit most from more intentional remembrance?';

  @override
  String get learningJourneyStoriesCompletionIntro =>
      'You have reflected on signs around you in the sky, the sea, the earth, living creatures, and your own life. The next step is to carry that reflection forward.';

  @override
  String get learningJourneyStoriesCompletionSection1Title =>
      'What signs can do';

  @override
  String get learningJourneyStoriesCompletionSection1Body =>
      'Reflection on creation is not a side activity. It can soften the heart, renew gratitude, and make Qur\'anic verses feel more alive because the signs of Allah become easier to notice.';

  @override
  String get learningJourneyStoriesCompletionSection2Title =>
      'Where to go next';

  @override
  String get learningJourneyStoriesCompletionSection2Body =>
      'If these signs moved you, continue with Qur\'an study, prophetic stories, or a reflection-based daily practice. The goal is not only to observe. It is to return to Allah more often.';

  @override
  String get learningJourneyStoriesCompletionTakeaway1 =>
      'Creation can lead the heart back to Allah.';

  @override
  String get learningJourneyStoriesCompletionTakeaway2 =>
      'Reflection becomes stronger when it is regular.';

  @override
  String get learningJourneyStoriesCompletionTakeaway3 =>
      'Qur\'an and reflection belong together.';

  @override
  String get learningJourneyStoriesCompletionReflection =>
      'Which sign of Allah around you do you want to notice more consciously from now on?';

  @override
  String get learningJourneyStoriesCompletionActionStep =>
      'Choose one daily moment outdoors or in quiet to pause, reflect, and remember Allah.';

  @override
  String get learningJourneyToolNamesOfAllahSubtitle =>
      'Learn names that deepen awe, hope, and trust.';

  @override
  String get learningPathBeginnerTitle => 'Beginner Path';

  @override
  String get learningPathBeginnerDescription =>
      'A calm first route through Islam, worship, and identity.';

  @override
  String get learningPathPracticingTitle => 'Practicing Path';

  @override
  String get learningPathPracticingDescription =>
      'Strengthen consistency in worship and understanding.';

  @override
  String get learningPathSeekerTitle => 'Knowledge Seeker Path';

  @override
  String get learningPathSeekerDescription =>
      'A more structured route through belief, history, and integration.';

  @override
  String get learningPathAdvancedTitle => 'Advanced Path';

  @override
  String get learningPathAdvancedDescription =>
      'A quieter route focused on refinement, reflection, and action.';

  @override
  String get learningPathPhaseBeginnerFoundationsTitle => 'Foundations';

  @override
  String get learningPathPhaseBeginnerFoundationsDescription =>
      'Start with Islam, Allah, and the pillars.';

  @override
  String get learningPathPhaseBeginnerDailyPracticeTitle => 'Daily Practice';

  @override
  String get learningPathPhaseBeginnerDailyPracticeDescription =>
      'Build the essentials of worship one calm step at a time.';

  @override
  String get learningPathPhaseBeginnerConnectionTitle => 'Connection';

  @override
  String get learningPathPhaseBeginnerConnectionDescription =>
      'Deepen prayer, recitation, and a first hadith rhythm.';

  @override
  String get learningPathPhaseBeginnerIdentityTitle => 'Identity';

  @override
  String get learningPathPhaseBeginnerIdentityDescription =>
      'Grow through stories, belonging, and beautiful character.';

  @override
  String get learningPathPhasePracticingWorshipTitle => 'Strengthen Worship';

  @override
  String get learningPathPhasePracticingWorshipDescription =>
      'Rebuild daily worship through salah, dhikr, and duas.';

  @override
  String get learningPathPhasePracticingUnderstandingTitle => 'Understanding';

  @override
  String get learningPathPhasePracticingUnderstandingDescription =>
      'Connect Quran reading, meaning, and recurring words.';

  @override
  String get learningPathPhasePracticingCharacterTitle => 'Character';

  @override
  String get learningPathPhasePracticingCharacterDescription =>
      'Keep worship connected to manners, reflection, and hadith.';

  @override
  String get learningPathPhasePracticingStructureTitle => 'Structure';

  @override
  String get learningPathPhasePracticingStructureDescription =>
      'Add Ramadan preparation and a steady daily rhythm.';

  @override
  String get learningPathPhaseSeekerFoundationsTitle => 'Foundations';

  @override
  String get learningPathPhaseSeekerFoundationsDescription =>
      'Strengthen belief, practice, and historical context.';

  @override
  String get learningPathPhaseSeekerQuranDepthTitle => 'Quran Depth';

  @override
  String get learningPathPhaseSeekerQuranDepthDescription =>
      'Move from reading toward themes, surahs, and guided reflection.';

  @override
  String get learningPathPhaseSeekerArabicTitle => 'Arabic';

  @override
  String get learningPathPhaseSeekerArabicDescription =>
      'Build reading fluency and recurring word recognition.';

  @override
  String get learningPathPhaseSeekerIntegrationTitle => 'Integration';

  @override
  String get learningPathPhaseSeekerIntegrationDescription =>
      'Tie history, signs, and prophetic life together.';

  @override
  String get learningPathPhaseAdvancedReflectionTitle => 'Reflection';

  @override
  String get learningPathPhaseAdvancedReflectionDescription =>
      'Keep learning alive through daily reflection and synthesis.';

  @override
  String get learningPathPhaseAdvancedRefinementTitle => 'Refinement';

  @override
  String get learningPathPhaseAdvancedRefinementDescription =>
      'Refine recitation and deepen understanding with intention.';

  @override
  String get learningPathPhaseAdvancedCharacterActionTitle =>
      'Character and Action';

  @override
  String get learningPathPhaseAdvancedCharacterActionDescription =>
      'Connect refinement to habit, service, and sustained worship.';

  @override
  String get learningPathHomeTitle => 'Your Path';

  @override
  String learningPathHomeSubtitle(String pathTitle) {
    return '$pathTitle is guiding what appears first so the next step stays clear.';
  }

  @override
  String learningPathHomePhaseLabel(int current, int total) {
    return 'Phase $current of $total';
  }

  @override
  String get learningPathHomeContinueAction => 'Continue Path';

  @override
  String get learningPathHomeNextTitle => 'Coming Up';

  @override
  String get learningPathHomeNextSubtitle =>
      'These journeys are next in your current path.';

  @override
  String get learningPathHomeNextSubtitleEase =>
      'Keep the next step light. These journeys reinforce what you already started.';

  @override
  String get learningPathHomeNextSubtitleDepth =>
      'You are moving steadily, so these recommendations add a little more depth without changing your path.';

  @override
  String get learningPathAdaptiveEaseLoad =>
      'Keeping the load light so the next step stays manageable.';

  @override
  String get learningPathAdaptiveDepth =>
      'You are moving well, so a little extra depth is being surfaced.';

  @override
  String get learningPathAdaptiveSteady =>
      'Your path is staying steady and focused on the next step.';

  @override
  String get learningPathNoSelectionTitle => 'Choose a learning path';

  @override
  String get learningPathNoSelectionSubtitle =>
      'Pick a path so Learning can guide you step by step instead of showing everything equally.';

  @override
  String get learningAgeGroupHintKids =>
      'Age mode: simpler lessons, story-first guidance, and lighter next steps.';

  @override
  String get learningAgeGroupHintTeens =>
      'Age mode: practical examples, identity-focused guidance, and relatable next steps.';

  @override
  String get learningAgeGroupHintAdults =>
      'Age mode: full explanations, deeper connections, and the full learning map.';

  @override
  String learningAgeKidsLessonIntro(String lessonTitle) {
    return '$lessonTitle is being shown in a simpler child-friendly format.';
  }

  @override
  String learningAgeTeensLessonIntro(String lessonTitle) {
    return '$lessonTitle is being shown with a shorter, more relatable teen-friendly focus.';
  }

  @override
  String get learningAgeKidsActionStep =>
      'Try one small step with family or a trusted adult today.';

  @override
  String get learningAgeTeensActionStep =>
      'Think about one place in real life where you can use this today.';

  @override
  String get learningAgeKidsReviewSuggestion =>
      'Come back later and tell someone what you learned.';

  @override
  String get learningAgeTeensReviewSuggestion =>
      'Review this again after salah or later today and connect it to your own routine.';

  @override
  String get learningPathAlsoExploringTitle => 'Also Exploring';

  @override
  String get learningPathAlsoExploringSubtitle =>
      'These journeys sit outside your primary path, but your progress there is still remembered.';

  @override
  String get learningPathCompletedTitle => 'Current path completed';

  @override
  String learningPathCompletedSubtitle(String pathTitle) {
    return 'You finished what is currently available here. Next suggested level: $pathTitle';
  }

  @override
  String get learningPathFallbackTitle => 'Explore a review path';

  @override
  String get learningPathFallbackSubtitle =>
      'Your main recommendation pool is currently light, so a reinforcement journey is being surfaced instead.';

  @override
  String get learningPathChangeAction => 'Change';

  @override
  String get learningPathSwitchConfirmTitle => 'Switch learning path?';

  @override
  String get learningPathSwitchConfirmBody =>
      'Your journey progress will stay intact. Only the path guidance and recommendations will change.';

  @override
  String get learningPathSwitchCancel => 'Cancel';

  @override
  String get learningPathSwitchConfirm => 'Switch Path';

  @override
  String learningPathPhaseCompletedTitle(String phaseTitle) {
    return '$phaseTitle completed';
  }

  @override
  String learningPathPhaseCompletedSubtitle(String phaseTitle) {
    return 'Next up: $phaseTitle';
  }

  @override
  String get learningPathJourneyTitle => 'Path Placement';

  @override
  String learningPathJourneyPartOfPath(String pathTitle) {
    return 'Part of your path: $pathTitle';
  }

  @override
  String learningPathJourneyPhaseLabel(String phaseTitle) {
    return 'Phase: $phaseTitle';
  }

  @override
  String learningPathNextJourneyLabel(String journeyTitle) {
    return 'Next journey: $journeyTitle';
  }

  @override
  String get learningPathNextJourneyAction => 'Open Next Journey';

  @override
  String get learningPathTodayLightBadge => 'For Your Path';

  @override
  String learningPathTodayLightSubtitle(String journeySubtitle) {
    return 'Today, continue with: $journeySubtitle';
  }

  @override
  String get learningJourneyStageUnavailableTitle =>
      'This lesson is not fully available right now';

  @override
  String get learningJourneyStageUnavailableBody =>
      'This stage cannot open its intended content at the moment. Use the fallback below or return to the journey and continue with another available step.';

  @override
  String get learningJourneyStageUnavailableFallbackTitle =>
      'Back to this journey';

  @override
  String get learningJourneyStageUnavailableFallbackSubtitle =>
      'Return to the journey detail page and choose another available stage.';

  @override
  String get onboardingLearningAgeGroupTitle => 'What best describes you?';

  @override
  String get onboardingLearningAgeGroupSubtitle =>
      'We use this to adapt lesson wording, pacing, and which journeys are surfaced more prominently.';

  @override
  String get onboardingLearningAgeGroupKids =>
      'I’m a child / learning with family';

  @override
  String get onboardingLearningAgeGroupTeens => 'I’m a teenager';

  @override
  String get onboardingLearningAgeGroupAdults => 'I’m an adult';

  @override
  String get learningJourneyIslamFoundationsTitle => 'What Is Islam?';

  @override
  String get learningJourneyIslamFoundationsSubtitle =>
      'A calm first path through Islam, belief, and the pillars.';

  @override
  String get learningJourneyIslamFoundationsDescription =>
      'Start with the meaning of Islam, who Allah is, the five pillars, and the first steady steps of Muslim life.';

  @override
  String get learningJourneyIslamFoundationsOutcome1 =>
      'Understand Islam as surrender, worship, and mercy.';

  @override
  String get learningJourneyIslamFoundationsOutcome2 =>
      'See the five pillars as a lived structure rather than a list.';

  @override
  String get learningJourneyIslamFoundationsOutcome3 =>
      'Leave with a calm first plan for daily Muslim life.';

  @override
  String get learningJourneyIslamFoundationsWhyThisMatters =>
      'Beginners need one clear first path before they are exposed to the rest of the learning library.';

  @override
  String get learningJourneyDailyRoutinesTitle => 'Daily Routines';

  @override
  String get learningJourneyDailyRoutinesSubtitle =>
      'A gentle rhythm for prayer, Qur\'an, dhikr, and steadiness.';

  @override
  String get learningJourneyDailyRoutinesDescription =>
      'Build a realistic daily Muslim routine that begins small, anchors itself to salah, and stays sustainable.';

  @override
  String get learningJourneyDailyRoutinesOutcome1 =>
      'Create a simple daily worship rhythm without overwhelm.';

  @override
  String get learningJourneyDailyRoutinesOutcome2 =>
      'Use salah as the anchor for Qur\'an, dhikr, and duas.';

  @override
  String get learningJourneyDailyRoutinesOutcome3 =>
      'Build habits through small, repeatable actions.';

  @override
  String get learningJourneyDailyRoutinesWhyThisMatters =>
      'Many users do not need more information first. They need a realistic structure they can actually live.';

  @override
  String get learningJourneyStageIslamWhatIsIslamTitle => 'What is Islam?';

  @override
  String get learningJourneyStageIslamWhatIsIslamSummary =>
      'Begin with the meaning of Islam as surrender to Allah, worship, and a complete way of life.';

  @override
  String get learningJourneyStageIslamWhoIsAllahTitle => 'Who is Allah?';

  @override
  String get learningJourneyStageIslamWhoIsAllahSummary =>
      'Learn the first clear foundations of knowing Allah as Creator, Lord, and the One worthy of worship.';

  @override
  String get learningJourneyStageIslamFivePillarsTitle => 'The five pillars';

  @override
  String get learningJourneyStageIslamFivePillarsSummary =>
      'See the pillars as the practical structure that shapes a Muslim life day by day.';

  @override
  String get learningJourneyStageIslamFirstStepsTitle => 'Your first steps';

  @override
  String get learningJourneyStageIslamFirstStepsSummary =>
      'Finish with a calm starting plan built around prayer, learning, and beautiful character.';

  @override
  String get learningJourneyStageIslamCompletionTitle =>
      'Carry Islam into daily life';

  @override
  String get learningJourneyStageIslamCompletionSummary =>
      'Review what you have learned and choose the next steady journey in worship and connection.';

  @override
  String get learningJourneyStageDailyRoutinesStartDayTitle =>
      'Start your day with intention';

  @override
  String get learningJourneyStageDailyRoutinesStartDaySummary =>
      'Build a gentle opening rhythm that begins with intention, remembrance, and a realistic first step.';

  @override
  String get learningJourneyStageDailyRoutinesPrayerAnchorTitle =>
      'Let salah anchor the day';

  @override
  String get learningJourneyStageDailyRoutinesPrayerAnchorSummary =>
      'Use prayer times as the stable structure that keeps the rest of your routine from drifting.';

  @override
  String get learningJourneyStageDailyRoutinesQuranAnchorTitle =>
      'Keep a small Qur\'an rhythm';

  @override
  String get learningJourneyStageDailyRoutinesQuranAnchorSummary =>
      'Choose a manageable way to read, listen, or reflect on the Qur\'an every day without pressure.';

  @override
  String get learningJourneyStageDailyRoutinesEveningResetTitle =>
      'End the day with a reset';

  @override
  String get learningJourneyStageDailyRoutinesEveningResetSummary =>
      'Use evening dhikr, duas, and reflection to close the day with calm rather than drift.';

  @override
  String get learningJourneyStageDailyRoutinesHabitBuildingTitle =>
      'Build habits that last';

  @override
  String get learningJourneyStageDailyRoutinesHabitBuildingSummary =>
      'Learn how to stay consistent through small actions, gentle review, and patience with yourself.';

  @override
  String get learningJourneyStageDailyRoutinesCompletionTitle =>
      'Carry your routine forward';

  @override
  String get learningJourneyStageDailyRoutinesCompletionSummary =>
      'Review your rhythm and choose the next journey that will deepen what you are already practicing.';

  @override
  String get learningJourneyIslamSection1Title => 'Understand the foundation';

  @override
  String get learningJourneyIslamSection2Title => 'Put it into life';

  @override
  String get learningJourneyIslamWhatIsIslamIntro =>
      'Islam is not only information. It is a relationship of surrender, trust, and worship directed to Allah alone.';

  @override
  String get learningJourneyIslamWhatIsIslamSection1Body =>
      'The word Islam carries the meaning of surrendering yourself to Allah in peace. A Muslim turns to Allah with belief, worship, obedience, and hope for mercy.';

  @override
  String get learningJourneyIslamWhatIsIslamSection2Body =>
      'This means Islam shapes daily life. Prayer, good character, remembrance, and learning are not separate from faith. They are how faith becomes lived.';

  @override
  String get learningJourneyIslamWhatIsIslamTakeaway1 =>
      'Islam begins with surrender to Allah.';

  @override
  String get learningJourneyIslamWhatIsIslamTakeaway2 =>
      'Worship and daily life belong together.';

  @override
  String get learningJourneyIslamWhatIsIslamTakeaway3 =>
      'A steady path matters more than rushing.';

  @override
  String get learningJourneyIslamWhatIsIslamReflection =>
      'What changes when you see Islam as a lived relationship with Allah rather than a list of facts?';

  @override
  String get learningJourneyIslamWhoIsAllahIntro =>
      'Knowing Allah is the center of belief. The heart becomes steady when it knows who created it and who it is returning to.';

  @override
  String get learningJourneyIslamWhoIsAllahSection1Body =>
      'Allah is the Creator, the Provider, the Lord of all worlds, and the One worthy of worship. He is not like creation, and nothing compares to Him.';

  @override
  String get learningJourneyIslamWhoIsAllahSection2Body =>
      'When you know Allah through His perfection, mercy, and lordship, worship begins to feel rooted. Prayer becomes conversation, trust, and return.';

  @override
  String get learningJourneyIslamWhoIsAllahTakeaway1 =>
      'Allah alone created and sustains everything.';

  @override
  String get learningJourneyIslamWhoIsAllahTakeaway2 =>
      'Nothing is equal to Allah.';

  @override
  String get learningJourneyIslamWhoIsAllahTakeaway3 =>
      'Knowing Allah deepens worship and trust.';

  @override
  String get learningJourneyIslamWhoIsAllahReflection =>
      'Which name or quality of Allah helps your heart feel closest to Him right now?';

  @override
  String get learningJourneyIslamFivePillarsIntro =>
      'The five pillars give structure to Muslim life. They are not random duties. They train the heart, body, time, and wealth around worship.';

  @override
  String get learningJourneyIslamFivePillarsSection1Body =>
      'The pillars are shahadah, salah, zakat, fasting Ramadan, and Hajj for those able. Together they keep belief connected to daily action, community, and obedience.';

  @override
  String get learningJourneyIslamFivePillarsSection2Body =>
      'A beginner does not need to master every detail at once. The right first move is to understand the pillars, then begin with the ones that shape daily rhythm most directly.';

  @override
  String get learningJourneyIslamFivePillarsTakeaway1 =>
      'The pillars give Islam a lived structure.';

  @override
  String get learningJourneyIslamFivePillarsTakeaway2 =>
      'Salah becomes the daily anchor first.';

  @override
  String get learningJourneyIslamFivePillarsTakeaway3 =>
      'Learning can happen step by step.';

  @override
  String get learningJourneyIslamFivePillarsReflection =>
      'Which pillar feels most immediate in your life, and what is one calm next step you can take with it?';

  @override
  String get learningJourneyIslamFirstStepsIntro =>
      'A strong beginning is simple, repeatable, and sincere. You do not need to carry everything at once.';

  @override
  String get learningJourneyIslamFirstStepsSection1Body =>
      'Start by protecting the daily prayers as best you can, learning a small amount regularly, and keeping a few daily duas and adhkar close.';

  @override
  String get learningJourneyIslamFirstStepsSection2Body =>
      'Good company, patience with yourself, and beautiful character matter from the beginning. Growth in Islam is not only information. It is worship with steadiness.';

  @override
  String get learningJourneyIslamFirstStepsTakeaway1 =>
      'Protect the basics before adding more.';

  @override
  String get learningJourneyIslamFirstStepsTakeaway2 =>
      'Consistency is more important than intensity.';

  @override
  String get learningJourneyIslamFirstStepsTakeaway3 =>
      'Character is part of practicing Islam.';

  @override
  String get learningJourneyIslamFirstStepsReflection =>
      'What would a calm first week of Muslim life look like for you?';

  @override
  String get learningJourneyIslamCompletionIntro =>
      'You have built a first frame for Islam, belief, and practice. The next step is to carry that frame into daily worship and connection.';

  @override
  String get learningJourneyIslamCompletionSection1Title => 'What you now have';

  @override
  String get learningJourneyIslamCompletionSection1Body =>
      'You now have a simple map: know Allah, understand the pillars, and build your practice through prayer, Qur\'an, duas, and character.';

  @override
  String get learningJourneyIslamCompletionSection2Title => 'What to do next';

  @override
  String get learningJourneyIslamCompletionSection2Body =>
      'Move into salah, Al-Fatihah, and short surahs so belief becomes something you recite, live, and return to every day.';

  @override
  String get learningJourneyIslamCompletionTakeaway1 =>
      'Belief and worship now have a clear shape.';

  @override
  String get learningJourneyIslamCompletionTakeaway2 =>
      'Your next journey should deepen daily practice.';

  @override
  String get learningJourneyIslamCompletionTakeaway3 =>
      'A calm foundation protects long-term growth.';

  @override
  String get learningJourneyIslamCompletionReflection =>
      'Which next journey will help your faith become most lived this week?';

  @override
  String get learningJourneyIslamCompletionActionStep =>
      'Choose salah or Al-Fatihah as your next steady step.';

  @override
  String get learningJourneyDailyRoutinesSection1Title => 'Choose the anchor';

  @override
  String get learningJourneyDailyRoutinesSection2Title => 'Keep it sustainable';

  @override
  String get learningJourneyDailyRoutinesStartDayIntro =>
      'A daily routine becomes easier when the day starts with intention rather than reacting to whatever comes first.';

  @override
  String get learningJourneyDailyRoutinesStartDaySection1Body =>
      'Begin with one small act that reminds you why the day matters: a short dua, a moment of dhikr, or opening the Qur\'an for even a few verses.';

  @override
  String get learningJourneyDailyRoutinesStartDaySection2Body =>
      'The goal is not a perfect morning routine. The goal is a repeatable opening that points your heart back to Allah and makes the next good action easier.';

  @override
  String get learningJourneyDailyRoutinesStartDayTakeaway1 =>
      'Start small enough that you can repeat it.';

  @override
  String get learningJourneyDailyRoutinesStartDayTakeaway2 =>
      'Intention changes the tone of the day.';

  @override
  String get learningJourneyDailyRoutinesStartDayTakeaway3 =>
      'One opening act can lead to the rest.';

  @override
  String get learningJourneyDailyRoutinesStartDayReflection =>
      'What is one opening practice you could realistically repeat tomorrow morning?';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorIntro =>
      'Salah is the strongest daily structure a Muslim has. When prayer becomes the anchor, the rest of the routine stops floating.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorSection1Body =>
      'Instead of treating prayer as one more task, build your day around it. Let prayer times shape when you pause, reset, and return to what matters.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorSection2Body =>
      'This also makes other habits easier. A small Qur\'an reading after Fajr, dhikr after salah, or a dua before leaving home becomes attached to something already fixed.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorTakeaway1 =>
      'Prayer gives the day its structure.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorTakeaway2 =>
      'Attach small habits to salah.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorTakeaway3 =>
      'Returning to prayer helps the rest stay steady.';

  @override
  String get learningJourneyDailyRoutinesPrayerAnchorReflection =>
      'Which prayer is the easiest place for you to attach one small habit right now?';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorIntro =>
      'A daily Qur\'an rhythm should feel possible, not heavy. Even a small amount can keep the relationship alive.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorSection1Body =>
      'Choose a form you can keep: a few verses after Fajr, reading one page, listening during a walk, or opening a note and writing one reflection.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorSection2Body =>
      'The point is consistency with presence. A short steady relationship with the Qur\'an is better than waiting for rare ideal moments.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorTakeaway1 =>
      'A small Qur\'an habit is still meaningful.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorTakeaway2 =>
      'Use the form that fits your real day.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorTakeaway3 =>
      'Presence matters more than volume.';

  @override
  String get learningJourneyDailyRoutinesQuranAnchorReflection =>
      'What Qur\'an rhythm fits your current day without creating pressure?';

  @override
  String get learningJourneyDailyRoutinesEveningResetIntro =>
      'Evening can either scatter the heart or gently gather it again. A short reset helps the day end with remembrance.';

  @override
  String get learningJourneyDailyRoutinesEveningResetSection1Body =>
      'Use evening adhkar, a bedtime dua, or one quiet moment of gratitude and istighfar to close the day with intention rather than exhaustion alone.';

  @override
  String get learningJourneyDailyRoutinesEveningResetSection2Body =>
      'This kind of reset is also a mercy after imperfect days. Instead of guilt taking over, remembrance helps you return and begin again tomorrow.';

  @override
  String get learningJourneyDailyRoutinesEveningResetTakeaway1 =>
      'Evening remembrance closes the day with calm.';

  @override
  String get learningJourneyDailyRoutinesEveningResetTakeaway2 =>
      'A reset helps after imperfect days.';

  @override
  String get learningJourneyDailyRoutinesEveningResetTakeaway3 =>
      'Closing well supports starting well tomorrow.';

  @override
  String get learningJourneyDailyRoutinesEveningResetReflection =>
      'What would help your evenings feel more like a return than a drift?';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingIntro =>
      'Good routines last when they stay merciful, realistic, and tied to purpose rather than pressure.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingSection1Body =>
      'Keep habits small at first. Repeat them in the same place or after the same prayer. Review them gently instead of treating one missed day as failure.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingSection2Body =>
      'Habit building in worship is not about control. It is about building doors back to Allah that are easy to open again and again.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingTakeaway1 =>
      'Small repeated acts build stronger habits.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingTakeaway2 =>
      'Tie habits to existing anchors.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingTakeaway3 =>
      'Missing once should not break the whole path.';

  @override
  String get learningJourneyDailyRoutinesHabitBuildingReflection =>
      'Which one habit should stay small for now so it can actually last?';

  @override
  String get learningJourneyDailyRoutinesCompletionIntro =>
      'You now have a simple daily rhythm. The next step is to keep deepening it without adding clutter or pressure.';

  @override
  String get learningJourneyDailyRoutinesCompletionSection1Title =>
      'What you now have';

  @override
  String get learningJourneyDailyRoutinesCompletionSection1Body =>
      'You have a practical frame for mornings, prayer anchors, Qur\'an connection, evening reset, and habit-building through small repeated actions.';

  @override
  String get learningJourneyDailyRoutinesCompletionSection2Title =>
      'What to deepen next';

  @override
  String get learningJourneyDailyRoutinesCompletionSection2Body =>
      'Choose the next journey that strengthens what you are already doing, such as dhikr, Ramadan preparation, or beautiful character.';

  @override
  String get learningJourneyDailyRoutinesCompletionTakeaway1 =>
      'A calm rhythm is better than an overloaded plan.';

  @override
  String get learningJourneyDailyRoutinesCompletionTakeaway2 =>
      'The next journey should deepen what is already working.';

  @override
  String get learningJourneyDailyRoutinesCompletionTakeaway3 =>
      'Routine becomes worship when it stays connected to Allah.';

  @override
  String get learningJourneyDailyRoutinesCompletionReflection =>
      'Which practice from this journey feels most ready to become part of your normal day?';

  @override
  String get learningJourneyDailyRoutinesCompletionActionStep =>
      'Choose one habit to protect this week and one journey to deepen it.';

  @override
  String get familyLearningManagementTitle => 'Family Learning';

  @override
  String get familyLearningManagementSubtitle =>
      'Create child learning profiles, guide their path, and keep shared-device progress separate.';

  @override
  String get familyLearningManagementUnavailable =>
      'Family learning is managed from an adult or guardian profile.';

  @override
  String get familyLearningGuardianTitle => 'Guardian profile';

  @override
  String get familyLearningNoGuardianSelected => 'No guardian profile selected';

  @override
  String get familyLearningAddChildAction => 'Add child';

  @override
  String get familyLearningEmptyTitle => 'No child profiles yet';

  @override
  String get familyLearningEmptySubtitle =>
      'Create a child profile to assign a calm learning path and keep their progress separate.';

  @override
  String get familyLearningAddFirstChildAction => 'Create first child profile';

  @override
  String get familyLearningEditChildAction => 'Edit child profile';

  @override
  String familyLearningChildProgressLabel(int completed, int total) {
    return '$completed of $total journeys complete';
  }

  @override
  String familyLearningCurrentPhaseLabel(Object phase) {
    return 'Current phase: $phase';
  }

  @override
  String familyLearningCurrentJourneyLabel(Object journey) {
    return 'Current journey: $journey';
  }

  @override
  String familyLearningStreakLabel(int days) {
    return 'Streak: $days days';
  }

  @override
  String familyLearningRecentActivityLabel(Object lesson) {
    return 'Recent activity: $lesson';
  }

  @override
  String get familyLearningSwitchToChildAction => 'Switch to child';

  @override
  String get familyLearningContinueTogetherAction => 'Continue together';

  @override
  String get familyLearningPromptProphets =>
      'Ask your child what stood out from this prophet story and what lesson they want to remember together.';

  @override
  String get familyLearningPromptDua =>
      'Review this dua together and practice when to say it in real life today.';

  @override
  String get familyLearningPromptDhikr =>
      'Practice this dhikr together tonight and talk about what its meaning gives the heart.';

  @override
  String get familyLearningPromptGeneral =>
      'Review the next lesson together and ask what small action your child wants to carry into the day.';

  @override
  String get familyLearningChildNameLabel => 'Child name';

  @override
  String get familyLearningChildAvatarLabel => 'Avatar';

  @override
  String get familyLearningChildAgeGroupLabel => 'Age group';

  @override
  String get familyLearningChildPathLabel => 'Assigned path';

  @override
  String get familyLearningGuidedOnlyLabel => 'Guided only';

  @override
  String get familyLearningGuidedPlusExploreLabel => 'Guided + explore';

  @override
  String get familyLearningAllowBrowseAll => 'Allow Browse All';

  @override
  String get familyLearningAllowDiscovery => 'Allow discovery journeys';

  @override
  String get familyLearningAllowTrivia => 'Allow trivia paths';

  @override
  String get familyLearningAllowLegacy => 'Allow legacy learning';

  @override
  String get familyLearningAllowAdvanced => 'Allow advanced journeys';

  @override
  String get familyLearningAllowExploration => 'Allow secondary exploration';

  @override
  String get familyLearningCancelAction => 'Cancel';

  @override
  String get familyLearningDefaultChildName => 'New child';

  @override
  String get familyLearningSaveAction => 'Save';

  @override
  String get familyLearningAgeGroupKids => 'Kids';

  @override
  String get familyLearningAgeGroupTeens => 'Teens';

  @override
  String get familyLearningAgeGroupAdults => 'Adults';

  @override
  String familyLearningHomeChildTitle(Object name) {
    return '$name\'s learning';
  }

  @override
  String get familyLearningHomeChildSubtitle =>
      'This child profile keeps learning calmer, path-first, and age-appropriate.';

  @override
  String get familyLearningHomeGuardianTitle => 'Family learning';

  @override
  String familyLearningHomeGuardianSubtitle(int count) {
    return '$count child profiles are ready for guided learning.';
  }

  @override
  String get familyLearningHomeGuardianEmptySubtitle =>
      'Create a child profile when you want to guide learning on a shared device.';

  @override
  String get familyLearningSwitchAction => 'Switch profile';

  @override
  String get familyLearningManageAction => 'Manage';

  @override
  String get familyLearningProfileTypeAdult => 'د لويانو پروفايل';

  @override
  String get familyLearningProfileTypeYouth => 'د ځوانانو پروفايل';

  @override
  String get familyLearningProfileTypeChild => 'د ماشوم پروفايل';

  @override
  String get familyLearningProfileTypeGuest => 'د مېلمه پروفايل';

  @override
  String get familyLearningGuidedHomeTitle => 'Guided learning is on';

  @override
  String get familyLearningGuidedHomeSubtitle =>
      'This child profile stays focused on the assigned path first. Extra browsing can be opened later if you allow it.';

  @override
  String get familyLearningBrowseAllChildSubtitle =>
      'Browse safely through the sections this child profile is allowed to explore.';

  @override
  String get familyLearningContinueTogetherTitle => 'Continue together';

  @override
  String familyLearningContinueTogetherSubtitle(Object prompt) {
    return '$prompt';
  }

  @override
  String get familyLearningBrowseReducedTitle => 'Browse is reduced here';

  @override
  String get familyLearningBrowseReducedSubtitle =>
      'This child profile is set to guided learning, so broad exploration is kept lighter.';

  @override
  String get familyLearningIslandReducedSubtitle =>
      'This island is reduced for the current child profile. Return to the assigned path for the clearest next step.';

  @override
  String get familyLearningSettingsTitle => 'Family Learning';

  @override
  String get familyLearningSettingsSubtitle =>
      'Create child profiles, assign paths, and review progress for shared-device learning.';

  @override
  String get kidsUiThemeSettingTitle => 'Kids UI Theme';

  @override
  String get kidsUiThemeSettingSubtitle =>
      'Use age range and a simple override to keep learning easier to scan for children.';

  @override
  String get kidsUiThemeSettingModeTitle => 'Kids UI mode';

  @override
  String kidsUiThemeSettingModeHelper(Object state) {
    return 'Current result: $state';
  }

  @override
  String get kidsUiAgeRangeTitle => 'Age range';

  @override
  String get kidsUiAgeRangeChild => 'Child';

  @override
  String get kidsUiAgeRangeTeen => 'Teen';

  @override
  String get kidsUiAgeRangeAdult => 'Adult';

  @override
  String get kidsUiThemeModeAuto => 'Auto';

  @override
  String get kidsUiThemeModeOn => 'On';

  @override
  String get kidsUiThemeModeOff => 'Off';

  @override
  String get learnTogetherTitle => 'Learn Together';

  @override
  String get learnTogetherLessonIntro =>
      'Open this lesson together so the story or teaching can become a calm conversation.';

  @override
  String get learnTogetherJourneyIntro =>
      'Choose a child profile and open this journey together with discussion prompts and parent guidance.';

  @override
  String get learnTogetherDiscussionTitle => 'Talk about this together';

  @override
  String get learnTogetherParentGuidanceTitle => 'Parent guidance';

  @override
  String get learnTogetherFamilyPromptTitle => 'Try this together';

  @override
  String get learnTogetherHomeSubtitle =>
      'Open shared lessons, use guided prompts, and review what your child is learning.';

  @override
  String get learnTogetherHomeContinueSubtitle =>
      'Continue a shared lesson or open a new one together.';

  @override
  String get learnTogetherChildHomeSubtitle =>
      'Open the current lesson with shared prompts and talk through it together.';

  @override
  String learnTogetherStartWithChild(Object name) {
    return 'Start with $name';
  }

  @override
  String get learnTogetherReviewTogetherAction => 'Review together';

  @override
  String get learnTogetherLearnedTogetherLabel => 'Learned together';

  @override
  String get learnTogetherPromptStory1 => 'What did you learn from this story?';

  @override
  String get learnTogetherPromptStory2 => 'How can we live this lesson today?';

  @override
  String get learnTogetherPromptStoryKids1 =>
      'What happened in this story that you want to remember?';

  @override
  String get learnTogetherPromptStoryKids2 =>
      'What good thing can we try after this lesson?';

  @override
  String get learnTogetherPromptCharacter1 =>
      'Which part of good character feels hardest sometimes?';

  @override
  String get learnTogetherPromptCharacter2 =>
      'What is one small way we can practice this today?';

  @override
  String get learnTogetherPromptDua1 =>
      'When can we say this dua together today?';

  @override
  String get learnTogetherPromptDua2 => 'What does this dua help us remember?';

  @override
  String get learnTogetherPromptDhikr1 =>
      'How does this dhikr help the heart slow down and remember Allah?';

  @override
  String get learnTogetherPromptDhikr2 =>
      'When would be a calm time for us to say this together?';

  @override
  String get learnTogetherPromptSigns1 =>
      'What part of Allah’s creation stood out to you most here?';

  @override
  String get learnTogetherPromptSigns2 =>
      'What does this make us want to notice more carefully today?';

  @override
  String get learnTogetherGuidancePatience =>
      'Keep the explanation short, then ask your child to retell the lesson in their own words. If the story teaches patience or trust, invite one real-life example from today.';

  @override
  String get learnTogetherGuidanceCharacter =>
      'This lesson is strongest when it becomes a small action. Let your child pick one simple behavior to practice before the day ends.';

  @override
  String get learnTogetherGuidanceDua =>
      'Read the dua slowly together, explain when it is used, and repeat it once more in the real situation if possible.';

  @override
  String get learnTogetherGuidanceDhikr =>
      'Focus more on meaning than quantity. One calm repetition with understanding is better than rushing through many repetitions.';

  @override
  String get learnTogetherGuidanceSigns =>
      'Help your child connect the lesson to something visible around them so the reflection feels real and not abstract.';

  @override
  String get learnTogetherFamilyPromptStory =>
      'Tonight, ask your child to retell this story in their own words and choose one lesson to carry into tomorrow.';

  @override
  String get learnTogetherFamilyPromptCharacter =>
      'Pick one character trait from this lesson and practice it together once before the day ends.';

  @override
  String get learnTogetherFamilyPromptDua =>
      'Use this dua together at the next real moment it applies so the words become part of daily life.';

  @override
  String get learnTogetherFamilyPromptDhikr =>
      'Practice this dhikr together tonight and talk about what its meaning gives the heart.';

  @override
  String get learnTogetherFamilyPromptSigns =>
      'Take one quiet moment today to notice Allah’s creation together and mention one thing that fills you with gratitude.';

  @override
  String get learningCommunityFeedbackStageAdult =>
      'Your learning added a drop to the Ocean.';

  @override
  String get learningCommunityFeedbackStageKids =>
      'You added a drop. Your lesson helped the Ocean grow.';

  @override
  String get learningCommunityFeedbackSharedAdult =>
      'Learning together added to the Ocean.';

  @override
  String get learningCommunityFeedbackSharedKids =>
      'You learned together and added a drop.';

  @override
  String get learningCommunityFeedbackJourneyBonus =>
      'This completed journey added an extra drop to the shared good.';

  @override
  String get learningCommunityFeedbackPhaseBonus =>
      'This phase milestone added another drop to the Ocean.';

  @override
  String get learningCommunityFeedbackTodayLightAdult =>
      'Today’s learning added a quiet drop to the Ocean.';

  @override
  String get learningCommunityFeedbackTodayLightKids =>
      'Today’s light helped the Ocean grow.';

  @override
  String get learningCommunitySummaryTitle => 'Learning and the Ocean';

  @override
  String learningCommunitySummarySubtitle(int count) {
    return 'Your learning this week added $count drops to the Ocean.';
  }

  @override
  String learningCommunitySummaryFamilySubtitle(int count) {
    return 'Your family’s learning this week added $count drops to the Ocean.';
  }

  @override
  String learningCommunitySummaryKidsSubtitle(int count) {
    return 'You added $count drops this week. The Ocean is growing.';
  }

  @override
  String get learningCommunitySummaryEmpty =>
      'Every lesson adds to shared good. Your next learning step can begin a new ripple.';

  @override
  String learningCommunitySummaryTogetherNote(int count) {
    return '$count shared learning moments added family drops.';
  }

  @override
  String get settingsCurrentLocation => 'Current location';

  @override
  String get settingsProfilePersonalizationTitle => 'Profile & Personalization';

  @override
  String get settingsProfilePersonalizationSubtitle =>
      'Keep your name, address preference, modes, and profile-related shortcuts here now that Profile is no longer a top-level tab.';

  @override
  String settingsProfileDisplayNameSummary(String title, String name) {
    return '$title $name';
  }

  @override
  String settingsProfileLevelStreakSummary(
    String levelSummary,
    String streakSummary,
    Object days,
    Object level,
    Object streak,
    Object streakDays,
  ) {
    return '$levelSummary • $streakSummary';
  }

  @override
  String get settingsWhatsNewTitle => 'What\'s new';

  @override
  String get settingsWhatsNewSubtitle =>
      'See the latest app changes and earlier updates.';

  @override
  String get settingsComingSoonTitle => 'Coming soon';

  @override
  String get settingsComingSoonSubtitle =>
      'Preview the next improvements planned for the app.';

  @override
  String get shellQuranPlaybackPauseTooltip => 'د قرآن غږول ودرول';

  @override
  String get shellQuranPlaybackResumeTooltip => 'د قرآن غږول بېرته پيلول';

  @override
  String get profileWhatsNewChangelogTitle => 'د بدلونونو لړليک';

  @override
  String get profileWhatsNewChangelogSubtitle =>
      'تر ټولو نوې اوسمهالنه لومړی پرانيستل کېږي. زاړه اوسمهالونه تر هغې پورې تړلي پاتې کېږي چې تاسو يې وغځوئ.';

  @override
  String get profileWhatsNewDateMarch2026 => 'مارچ 2026';

  @override
  String get profileWhatsNewDateFebruary2026 => 'فبروري 2026';

  @override
  String get profileWhatsNewEntry113Title =>
      'ښه شوی پېل، خوځښت، او د لمونځ ويجېټونه';

  @override
  String get profileWhatsNewEntry113Summary =>
      'دې اوسمهال د اپ لومړنی تنظيم لا منظم کړ، د پاڼو لېږدونه يې نرم کړل، او د لمونځ ويجېټونه يې لا ارام او کنټرول شوي کړل.';

  @override
  String get profileWhatsNewEntry113Item1 =>
      'نوم او د ورور/خور ټاکنه په يوه پېل پړاو کې يوځای شول او نوم په تلواله توګه تش پاتې کېږي.';

  @override
  String get profileWhatsNewEntry113Item2 =>
      'د عادتونو تعقيب په پيل کې اختیاري شو، څو کاروونکي وروسته په خپل ارام وخت کې دا فعال کړي.';

  @override
  String get profileWhatsNewEntry113Item3 =>
      'په ګډو پاڼو او پېل کې نرمه د ننوتلو خوځښت زياته شوه، او د Reduce Motion درناوی پوره ساتل شوی.';

  @override
  String get profileWhatsNewEntry113Item4 =>
      'د Prayer Live Activity د هرې ثانيې شمېرنې لرې شوې او د Dynamic Island او لاک سکرین ويجېټونو لپاره جلا باثباته کنټرولونه زيات شول.';

  @override
  String get profileWhatsNewEntry113Item5 =>
      'د بڼې حالت ساده شو، نو د Path of Nūr ارامه بڼه اوس تلواله بڼه ده.';

  @override
  String get profileWhatsNewEntry112Title =>
      'د باوري سرچينو پر بنسټ د قرآني عربي ښه والی';

  @override
  String get profileWhatsNewEntry112Summary =>
      'د Learn Quranic Arabic منځپانګه اوس لا سخت د سرچينو چلند کاروي، څو ښکاره قرآني بېلګې لا روښانه او يو شان پاتې شي.';

  @override
  String get profileWhatsNewEntry112Item1 =>
      'توري، د لغت بېلګې، د عبارت درسونه، او د قاعدو بېلګې وکتل شوې څو چېرته مناسب وي باوري قرآني حوالې وکارول شي.';

  @override
  String get profileWhatsNewEntry112Item2 =>
      'د سرچينو حوالې نېغ په درس بهير کې ورزياتې شوې، څو بېلګې په روښانه ډول تعقيب کېدای شي.';

  @override
  String get profileWhatsNewEntry112Item3 =>
      'د قرآني عربي د 100 لغتونو بنسټيز ډيټاسېټ د سرچينې له مخې تړل شوی، څو راتلونکې زياتونې د سرچينې مالوماتو ته اړې وي.';

  @override
  String get profileWhatsNewEntry111Title => 'اسلامي ټرېويا او د پوهې لارې';

  @override
  String get profileWhatsNewEntry111Summary =>
      'ټرېويا اوس د زده کړې بشپړه ځانګړنه شوې، له منظم پوښتن-بستو او لارښود موضوعي سفرونو سره.';

  @override
  String get profileWhatsNewEntry111Item1 =>
      'اسلامي ټرېويا د کټګورۍ-پر بنسټ پوښتنو، د بياکتنې بهير، ورځنۍ کويز چلند، احصايې، او انعامونو يوځای کېدو سره ورزياته شوه.';

  @override
  String get profileWhatsNewEntry111Item2 =>
      'د پوهې لارې ورپېژندل شوې، څو د لنډو زده‌کړيزو کارتونو او پړاويزو کويزونو له لارې لارښود سفرونه برابر کړي.';

  @override
  String get profileWhatsNewEntry111Item3 =>
      'د انبياوو، د قرآن بنسټونو، لمانځه، رمضان، دعا، سيرت، او اسلامي تاريخ لپاره غوره شوي ټرېويا بستونه پراخ شول.';

  @override
  String get profileWhatsNewEntry110Title => 'هوښيار قرآني عربي تمرين';

  @override
  String get profileWhatsNewEntry110Summary =>
      'د قرآني عربي زده کړه اوس لا تطبیقي شوې، او د ښوونې په بهير کې يې بياکتنه او لارښوونه لا معنا لرونکې شوې.';

  @override
  String get profileWhatsNewEntry110Item1 =>
      'هوښيار ورځنی بياکتنې سيستم ورزيات شو، له واټن-پر بنسټ بياکتنې او د کمزوريو برخو د نښه کولو سره.';

  @override
  String get profileWhatsNewEntry110Item2 =>
      'د حافظې-ځواک تعقيب، د بياکتنې تاريخچه، او په ښوونې ډشبورډ کې د پرمختګ ارامه ښودنه ورپېژندل شوه.';

  @override
  String get profileWhatsNewEntry110Item3 =>
      'Learn Quranic Arabic خپل جلا Learn ځای ته ولېږدول شو، څو موندل يې اسانه شي.';

  @override
  String get profileComingSoonRoadmapTitle => 'په لارې نقشه کې';

  @override
  String get profileComingSoonRoadmapSubtitle =>
      'دا هغه راتلونکې برخې دي چې د راتلونکو اوسمهالونو لپاره چمتو کېږي.';

  @override
  String get profileComingSoonCard1Title => 'لا ژوره د قرآني عربي لارښوونه';

  @override
  String get profileComingSoonCard1Description =>
      'نورې تاييد شوې سرچينه-تړلې بېلګې، پياوړې بياکتنه مرسته، او لا روښانه د درس پرمختګ وروسته پلان دی.';

  @override
  String get profileComingSoonCard2Title => 'لا پراخ ټرېويا سفرونه';

  @override
  String get profileComingSoonCard2Description =>
      'نورې غوره شوې د پوهې لارې، د کټګوريو لا پراخ پوښښ، او د منځپانګې غوره تشخيصونه پلان شوي.';

  @override
  String get profileComingSoonCard3Title => 'ښه شوي د لمونځ ويجېټونه';

  @override
  String get profileComingSoonCard3Description =>
      'په لاک سکرین او Dynamic Island کې لا زيات نرموالی، له لا کلکې وړاندې کولو او باثباته ښودنې انتخابونو سره.';

  @override
  String get profileComingSoonCard4Title => 'لا نرم شخصي کول';

  @override
  String get profileComingSoonCard4Description =>
      'نور اختیاري پېل او پروفايل کنټرولونه پلان شوي، څو اپ بې له دروند احساسه ځان برابر کړي.';

  @override
  String get settingsAccountsSyncTitle => 'Accounts, Profiles & Sync';

  @override
  String get settingsAccountsSyncSubtitle =>
      'Manage shared devices, protected profiles, sync mode, and backups without disturbing your current journey.';

  @override
  String get settingsCurrentProfileTitle => 'Current Profile';

  @override
  String get settingsNoProfileSelected => 'No profile selected';

  @override
  String get settingsSyncStatusTitle => 'Sync Status';

  @override
  String get settingsBackupRestoreTitle => 'Backup & Restore';

  @override
  String get settingsBackupRecommended => 'Backup recommended';

  @override
  String get settingsNoManualBackupYet => 'No manual backup yet';

  @override
  String get settingsLastExportRecorded => 'Last export recorded';

  @override
  String get accountsSyncCurrentProfileSectionSubtitle =>
      'وګورئ چې اوس کوم پروفايل فعال دی او دا پروفايل څنګه خوندي شوی دی.';

  @override
  String get accountsSyncNoActiveProfileTitle => 'هیڅ فعال پروفايل نشته';

  @override
  String get accountsSyncChooseProfileToBegin =>
      'د پيل لپاره يو پروفايل وټاکئ.';

  @override
  String accountsSyncProfileStatusSummary(
    String profileType,
    String syncMode,
    Object profile,
    Object profileName,
    Object status,
  ) {
    return '$profileType • $syncMode';
  }

  @override
  String get accountsSyncSwitchProfileTitle => 'پروفايل بدلول';

  @override
  String get accountsSyncSwitchProfileSubtitle =>
      'د پرمختګ له ګډېدو پرته د پروفايلونو ترمنځ لاړ شئ.';

  @override
  String get accountsSyncProfilesInAccountTitle => 'په دې حساب کې پروفايلونه';

  @override
  String get accountsSyncProfilesInAccountCreateSubtitle =>
      'د لويانو، ځوانانو، ماشومانو يا مېلمنو لپاره پروفايلونه جوړ کړئ.';

  @override
  String accountsSyncProfilesInAccountManageSubtitle(String accountName) {
    return 'هغه پروفايلونه اداره کړئ چې د $accountName لاندې زېرمه شوي دي.';
  }

  @override
  String get accountsSyncProfilesInAccountPageSubtitle =>
      'د لويانو، ځوانانو، ماشومانو يا مېلمنو لپاره جلا سفرونه جوړ کړئ، بې له دې چې د هغوی معلومات ګډ شي.';

  @override
  String get accountsSyncAccountsOnDeviceTitle => 'په دې آله کې حسابونه';

  @override
  String get accountsSyncAccountsOnDeviceSubtitle =>
      'په يوه تليفون يا ټابليټ کې ګڼ ننوتي هويتونه جلا وساتئ.';

  @override
  String get accountsSyncSignedInAccountsTitle => 'په دې آله کې ننوتلي حسابونه';

  @override
  String get accountsSyncSignedInAccountsSubtitle =>
      'په يوه آله کې بېلابېل هويتونه د هغوی د سفرونو له ګډېدو پرته جلا وساتئ.';

  @override
  String accountsSyncAccountsAvailableCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حسابونه شته',
      one: '1 حساب شته',
      zero: '0 حسابونه شته',
    );
    return '$_temp0';
  }

  @override
  String get accountsSyncSyncStatusSectionSubtitle =>
      'وپوهېږئ چې څه په ځايي ډول ساتل شوي، څه همغږي شوي، او څه پاملرنې ته اړتیا لري.';

  @override
  String get accountsSyncConnectedDevicesTitle => 'وصل شوې آلې';

  @override
  String get accountsSyncConnectedDevicesSubtitle =>
      'وګورئ چې کوم تليفونونه، ټابليټونه، ساعتونه، او تلويزيونونه له دې سفر سره تړلي دي.';

  @override
  String accountsSyncDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آلې',
      one: '1 آله',
      zero: '0 آلې',
    );
    return '$_temp0';
  }

  @override
  String get accountsSyncBackupRestoreSectionSubtitleRecommended =>
      'بېک اپ سپارښتنه کېږي. دا سفر په وروستیو کې نه دی صادر شوی.';

  @override
  String get accountsSyncBackupRestoreSectionSubtitleDefault =>
      'لاسي بېک اپ صادر کړئ يا له پخواني ارشيف څخه بېرته راواستوئ.';

  @override
  String get accountsSyncNoManualBackupExportedYet =>
      'لا تر اوسه هېڅ لاسي بېک اپ نه دی صادر شوی.';

  @override
  String accountsSyncLastExportLabel(String time) {
    return 'وروستی صادرول $time';
  }

  @override
  String get accountsSyncSharedDeviceSafetyTitle => 'د شريکې آلې خوندیتوب';

  @override
  String get accountsSyncSharedDeviceSafetySubtitle =>
      'د اپ په پرانېستلو کې د پروفايل ټاکنه اړينه کړئ او د ماشوم يا لويانو پروفايلونه خوندي وساتئ.';

  @override
  String get accountsSyncSharedDeviceSafetyPageSubtitle =>
      'د اپ په پرانېستلو کې د پروفايل ټاکنه اړينه کړئ، د لويانو پروفايلونه خوندي کړئ، او د ماشومانو تجربه لا خوندي وساتئ.';

  @override
  String get accountsSyncSharedDeviceModeActive => 'د شريکې آلې حالت فعال دی.';

  @override
  String get accountsSyncSharedDeviceModeDirectOpen =>
      'دا آله اوس نېغ په نېغه يو پروفايل پرانيزي.';

  @override
  String get accountsSyncSharedDeviceModeLabel => 'د شريکې آلې حالت';

  @override
  String get accountsSyncSharedDeviceModeHelper =>
      'په شريکو ټابليټونو او تلويزيونونو کې د پروفايل ټاکونکی وښيئ.';

  @override
  String get accountsSyncChooseProfileTitle => 'يو پروفايل وټاکئ';

  @override
  String get accountsSyncChooseProfileSubtitle =>
      'دا آله د شريک کارونې لپاره جوړه شوې. هغه پروفايل وټاکئ چې دوام ورسره ورکوئ.';

  @override
  String accountsSyncProfileListSubtitle(
    String profileType,
    String syncMode,
    String lastActive,
  ) {
    return '$profileType • $syncMode • وروستی فعال $lastActive';
  }

  @override
  String get accountsSyncAddProfileTitle => 'پروفايل زياتول';

  @override
  String get accountsSyncAddProfileSubtitle =>
      'د لوي، ځوان، ماشوم يا مېلمه پروفايل جوړ کړئ.';

  @override
  String get accountsSyncSignInAnotherAccountTitle => 'بل حساب ته ننوتل';

  @override
  String get accountsSyncSignInAnotherAccountSubtitle =>
      'په دې آله کې تر يو څخه ډېر Path of Nūr هويتونه وساتئ.';

  @override
  String get accountsSyncManageSharedDeviceSettingsTitle =>
      'د شريکې آلې امستنې اداره کړئ';

  @override
  String get accountsSyncManageSharedDeviceSettingsSubtitle =>
      'د پيل ساتنه او د ماشوم محدوديتونه سم کړئ.';

  @override
  String get accountsSyncProtectedProfileTitle => 'دا پروفايل خوندي شوی دی';

  @override
  String get accountsSyncEnterPinHint => 'PIN دننه کړئ';

  @override
  String get accountsSyncPinMismatch => 'PIN برابر نه و.';

  @override
  String get accountsSyncOpenProfileAction => 'پرانيستل';

  @override
  String accountsSyncProfileActivated(String name) {
    return '$name اوس فعال دی.';
  }

  @override
  String get accountsSyncAddProfileSectionSubtitle =>
      'د پروفايل ډول وټاکئ، دا چې څنګه احساس ولري، او معلومات يې څنګه وساتل شي.';

  @override
  String get accountsSyncDisplayNameLabel => 'د ښودنې نوم';

  @override
  String get accountsSyncAvatarLabel => 'اوتار';

  @override
  String get accountsSyncProfileTypeLabel => 'د پروفايل ډول';

  @override
  String get accountsSyncExperienceModeLabel => 'د تجربې حالت';

  @override
  String get accountsSyncDataModeLabel => 'د معلوماتو حالت';

  @override
  String get accountsSyncSyncModeLabel => 'د همغږۍ حالت';

  @override
  String get accountsSyncOptionalPinLabel => 'اختیاري PIN';

  @override
  String get accountsSyncOptionalPinHelper =>
      'تش يې پرېږدئ که دا پروفايل بايد خوندي نه وي.';

  @override
  String get accountsSyncDefaultNewProfileName => 'نوی پروفايل';

  @override
  String get accountsSyncProfileCreated => 'پروفايل جوړ شو';

  @override
  String get accountsSyncCreateProfileAction => 'پروفايل جوړ کړئ';

  @override
  String accountsSyncAccountSummary(
    String provider,
    String identifier,
    String syncMode,
    Object account,
    Object profiles,
  ) {
    return '$provider • $identifier • $syncMode';
  }

  @override
  String get accountsSyncSignInMethodLabel => 'د ننوتلو طریقه';

  @override
  String get accountsSyncEmailOrIdentifierLabel => 'برېښنالیک يا پېژند';

  @override
  String get accountsSyncDefaultAccountDisplayName => 'د Path of Nūr کارن';

  @override
  String get accountsSyncAccountAddedOnDevice => 'حساب په دې آله کې زيات شو';

  @override
  String get accountsSyncAddAccountAction => 'حساب زيات کړئ';

  @override
  String get accountsSyncRequireProfileSelectionOnLaunch =>
      'د پيل پر مهال د پروفايل ټاکنه اړينه کړئ';

  @override
  String get accountsSyncRequirePinForAdultProfiles =>
      'د لويانو پروفايلونو لپاره PIN اړين کړئ';

  @override
  String get accountsSyncAutoLockAfterInactivity =>
      'له غیرفعالۍ وروسته پروفايل پخپله قفل کړئ';

  @override
  String get accountsSyncRestrictChildProfileSettings =>
      'د ماشوم پروفايل امستنې محدودې کړئ';

  @override
  String get accountsSyncHideAdvancedToolsFromChildProfiles =>
      'له ماشوم پروفايلونو پرمختللي اوزار پټ کړئ';

  @override
  String accountsSyncDeviceSummary(
    String platform,
    String lastActive,
    Object device,
    Object deviceName,
    Object status,
  ) {
    return '$platform • وروستی فعال $lastActive';
  }

  @override
  String get accountsSyncCurrentDeviceChip => 'اوسنۍ';

  @override
  String get accountsSyncBackupRestorePageSubtitle =>
      'که تاسو يوازې ځايي يا يوازې بېک اپ زېرمه غوره کوئ، د خپل سفر يوه لاسي کاپي وساتئ.';

  @override
  String get accountsSyncBackupRecommendedSubtitle =>
      'دا پروفايل په ځايي ډول ساتل شوی او په وروستیو کې نه دی صادر شوی.';

  @override
  String get accountsSyncExportBackupTitle => 'بېک اپ صادرول';

  @override
  String get accountsSyncExportBackupSubtitleDefault =>
      'خپل اوسنی پروفايل يا حساب د JSON په بڼه صادر کړئ.';

  @override
  String get accountsSyncImportBackupTitle => 'بېک اپ راواردول';

  @override
  String get accountsSyncImportBackupSubtitle =>
      'دا د نوي پروفايل په توګه بېرته راواستوئ، يوځای يې کړئ، يا شته معلومات بدل کړئ.';

  @override
  String get accountsSyncExportBackupPageSubtitle =>
      'د خپل سفر يو د بېرته راګرځولو وړ نقل جوړ کړئ چې په ځايي ډول يې وساتئ، د AirDrop له لارې يې ولېږدوئ، يا يې په Files کې کېږدئ.';

  @override
  String get accountsSyncCurrentProfileOnlyTitle => 'یوازې اوسنی پروفايل';

  @override
  String get accountsSyncCurrentProfileOnlySubtitle =>
      'د بشپړ ځايي حساب پرځای يوازې فعال پروفايل صادر کړئ.';

  @override
  String get accountsSyncEncryptedExportTitle => 'کوډ شوی صادرول';

  @override
  String get accountsSyncEncryptedExportSubtitle =>
      'تر دې مخکې چې بېک اپ په ډيسک وليکل شي، د هغې منځپانګه کوډ کړئ.';

  @override
  String get accountsSyncExportNowAction => 'اوس صادر کړئ';

  @override
  String get accountsSyncImportBackupPageSubtitle =>
      'صادره شوې بېک اپ منځپانګه دلته ننباسئ او دا د نوي په توګه بېرته راواستوئ، ورسره يوځای يې کړئ، يا اوسنی ځايي ټولګه بدله کړئ.';

  @override
  String get accountsSyncBackupPayloadLabel => 'د بېک اپ منځپانګه';

  @override
  String get accountsSyncBackupPayloadHint =>
      'صادر شوی JSON يا کوډ شوی بېک اپ دلته ننباسئ.';

  @override
  String get accountsSyncEncryptedPayloadTitle => 'کوډ شوې منځپانګه';

  @override
  String get accountsSyncCreateNewProfilesTitle => 'نوي پروفايلونه جوړ کړئ';

  @override
  String get accountsSyncReplaceExistingLocalDataTitle =>
      'شاته ځايي معلومات بدل کړئ';

  @override
  String get accountsSyncBackupImported => 'بېک اپ راوارد شو';

  @override
  String get accountsSyncRestoreBackupAction => 'بېک اپ بېرته راوړئ';

  @override
  String get accountsSyncSyncDetailsTitle => 'د همغږۍ جزييات';

  @override
  String get accountsSyncSyncDetailsSubtitle =>
      'تمه شوې پورته لېږدونې، وروستۍ همغږۍ پېښې، او دا چې دې آلې ته پاملرنه پکار ده که نه، وګورئ.';

  @override
  String get accountsSyncCurrentProviderTitle => 'اوسنی برابروونکی';

  @override
  String accountsSyncCurrentProviderSummary(
    String syncMode,
    String transport,
    Object provider,
  ) {
    return '$syncMode • $transport';
  }

  @override
  String get accountsSyncCurrentStateTitle => 'اوسنی حالت';

  @override
  String get accountsSyncLastResultTitle => 'وروستۍ پايله';

  @override
  String get accountsSyncPendingUploadsTitle => 'تمه شوې پورته لېږدونې';

  @override
  String accountsSyncPendingChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تمه شوي بدلونونه',
      one: '1 تمه شوی بدلون',
      zero: '0 تمه شوې بدلونونه',
    );
    return '$_temp0';
  }

  @override
  String get accountsSyncLastSuccessfulSyncTitle => 'وروستۍ بريالۍ همغږي';

  @override
  String get accountsSyncTransportAvailabilityTitle => 'د لېږد شتون';

  @override
  String get accountsSyncTransportAvailable => 'شته';

  @override
  String get accountsSyncTransportUnavailableOffline => 'نشته يا افلاین';

  @override
  String get accountsSyncLastErrorTitle => 'وروستۍ تېروتنه';

  @override
  String get accountsSyncRecentSyncEventsTitle => 'وروستۍ همغږۍ پېښې';

  @override
  String accountsSyncRecentSyncEventBullet(String event) {
    return '• $event';
  }

  @override
  String get accountsSyncSyncNowAction => 'اوس همغږي کړئ';

  @override
  String get accountsSyncLastSyncTitle => 'وروستۍ همغږي';

  @override
  String get accountsSyncPendingChangesTitle => 'تمه شوي بدلونونه';

  @override
  String accountsSyncPendingChangesWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بدلونونه په تمه دي',
      one: '1 بدلون په تمه دی',
      zero: '0 بدلونونه په تمه دي',
    );
    return '$_temp0';
  }

  @override
  String get accountsSyncTransportTitle => 'لېږد';

  @override
  String accountsSyncTransportSummary(String transport, String status) {
    return '$transport • $status';
  }

  @override
  String get accountsSyncViewDetailsAction => 'جزييات وګورئ';

  @override
  String get accountsSyncTimeNotYet => 'لا نه';

  @override
  String get accountsSyncTimeUnknown => 'ناڅرګند';

  @override
  String get accountsSyncTimeJustNow => 'همدا اوس';

  @override
  String accountsSyncTimeMinutesAgo(int count) {
    return '$countد مخکې';
  }

  @override
  String accountsSyncTimeHoursAgo(int count) {
    return '$countس مخکې';
  }

  @override
  String accountsSyncTimeDaysAgo(int count) {
    return '$countورځې مخکې';
  }

  @override
  String get accountsSyncTransportLocalStorage => 'ځايي زېرمه';

  @override
  String get accountsSyncProviderSignInWithApple => 'له Apple سره ننوتل';

  @override
  String get accountsSyncProviderGoogle => 'ګوګل';

  @override
  String get accountsSyncProviderEmailMagicLink => 'د برېښنالیک جادويي لینک';

  @override
  String get accountsSyncProviderLocalOnly => 'یوازې ځايي';

  @override
  String get accountsSyncExperienceModeFull => 'بشپړ';

  @override
  String get accountsSyncExperienceModeSimplified => 'ساده شوی';

  @override
  String get accountsSyncExperienceModeLearningFocused => 'پر زده کړه متمرکز';

  @override
  String get accountsSyncExperienceModePrayerFocused => 'پر لمونځ متمرکز';

  @override
  String get accountsSyncDevicePlatformIPhone => 'iPhone';

  @override
  String get accountsSyncDevicePlatformIPad => 'iPad';

  @override
  String get accountsSyncDevicePlatformAppleWatch => 'Apple Watch';

  @override
  String get accountsSyncDevicePlatformAppleDevice => 'Apple آله';

  @override
  String get accountsSyncDevicePlatformAndroidPhone => 'Android تليفون';

  @override
  String get accountsSyncDevicePlatformAndroidTablet => 'Android ټابليټ';

  @override
  String get accountsSyncDevicePlatformWearOsWatch => 'Wear OS ساعت';

  @override
  String get accountsSyncDevicePlatformAndroidTv => 'Android TV';

  @override
  String get settingsAdhanTitle => 'Adhan';

  @override
  String get settingsAdhanSubtitle =>
      'Choose a dedicated Fajr Adhan, preview the bundled clips, and keep prayer audio offline.';

  @override
  String get settingsEnableAdhanAudioTitle => 'Enable Adhan audio';

  @override
  String get settingsEnableAdhanAudioSubtitle =>
      'Prayer reminders can play the selected Adhan when this is on.';

  @override
  String get settingsRegularAdhanTitle => 'Regular Adhan';

  @override
  String get settingsFajrAdhanTitle => 'Fajr Adhan';

  @override
  String get settingsPreviewVolumeTitle => 'Preview & volume';

  @override
  String settingsPercentValue(String value) {
    return '$value%';
  }

  @override
  String get settingsAdhanPickerFajrTitle => 'د فجر اذان وټاکئ';

  @override
  String get settingsAdhanPickerFajrSubtitle =>
      'يوازې د فجر د لمانځه د غږولو لپاره کارېږي.';

  @override
  String get settingsAdhanPickerRegularTitle => 'عادي اذان وټاکئ';

  @override
  String get settingsAdhanPickerRegularSubtitle =>
      'د ظهر، عصر، مغرب، او عشاء لپاره کارېږي.';

  @override
  String get settingsAdhanPreviewStopTooltip => 'مخکتنه ودروئ';

  @override
  String get settingsAdhanPreviewPlayTooltip => 'مخکتنه وغږوئ';

  @override
  String get settingsTestRegularAdhan => 'Test Regular Adhan';

  @override
  String get settingsTestFajrAdhan => 'Test Fajr Adhan';

  @override
  String get settingsUseAppVolumeTitle => 'Use App Volume';

  @override
  String get settingsUseAppVolumeSubtitle =>
      'Keep preview playback aligned with the app volume level.';

  @override
  String get settingsAdhanPreviewVolume => 'Adhan preview volume';

  @override
  String get settingsUsingAppVolume => 'Using app volume';

  @override
  String get settingsRestoreDefaultAdhanSettings =>
      'Restore Default Adhan Settings';

  @override
  String get settingsMadhabShafii => 'Shafi\'i';

  @override
  String get settingsMadhabHanafi => 'Hanafi';

  @override
  String get settingsMadhabMaliki => 'Maliki';

  @override
  String get settingsMadhabHanbali => 'Hanbali';

  @override
  String get settingsCalculationMethodMuslimWorldLeague =>
      'Muslim World League';

  @override
  String get settingsCalculationMethodEgyptian => 'Egyptian';

  @override
  String get settingsCalculationMethodIsna => 'ISNA';

  @override
  String get settingsCalculationMethodKarachi => 'Karachi';

  @override
  String get settingsCalculationMethodUmmAlQura => 'Umm Al-Qura';

  @override
  String get settingsStableDynamicIslandTitle => 'Stable Dynamic Island';

  @override
  String get settingsStableDynamicIslandSubtitle =>
      'Keep the prayer Dynamic Island in a calmer, fixed layout.';

  @override
  String get settingsStableLockScreenWidgetTitle => 'Stable Lock Screen Widget';

  @override
  String get settingsStableLockScreenWidgetSubtitle =>
      'Keep the prayer lock screen Live Activity in a calmer, fixed layout.';

  @override
  String get settingsThemeChoiceDefault => 'Default';

  @override
  String get settingsThemeChoiceEasyRead => 'Easy Read';

  @override
  String get settingsThemeChangedSuccessfully => 'Theme changed successfully';

  @override
  String get settingsVisualPreferencesTitle => 'Visual Preferences';

  @override
  String get settingsDisableGlassTransparencyTitle =>
      'Disable Glass Transparency';

  @override
  String get settingsDisableGlassTransparencySubtitle =>
      'Use solid surfaces instead of translucent glass.';

  @override
  String get settingsVisualPreferenceUpdated => 'Visual preference updated';

  @override
  String get settingsDisableBackgroundTitle => 'Disable Background';

  @override
  String get settingsDisableBackgroundSubtitle =>
      'Hide decorative background imagery for a cleaner view.';

  @override
  String get settingsAppearanceNoContentChangeNote =>
      'These settings change the look of the app without changing your content or progress.';

  @override
  String get settingsDefaultAppearanceActive => 'Default appearance active';

  @override
  String get settingsAppearanceResetToDefault => 'Appearance reset to default';

  @override
  String get settingsResetAppearance => 'Reset Appearance';

  @override
  String get settingsPrayerNotificationsTitle => 'Prayer Notifications';

  @override
  String get settingsPrayerNotificationsSubtitle =>
      'Keep all prayer reminder behavior in one place, with one mode for each salah.';

  @override
  String get settingsPrayerRemindersToggleSubtitle =>
      'Turn all prayer reminders on or off without changing your saved per-prayer modes.';

  @override
  String get settingsPrayerTimeModeTitle => 'Prayer Time Mode';

  @override
  String get settingsPrayerTimeModeSubtitle =>
      'Choose how Path of Nūr handles your prayer schedule. Most users should keep calculated prayer times and apply small adjustments if needed.';

  @override
  String get settingsPrayerTimeModeCalculatedAdjustedTitle =>
      'Calculated Times + Adjustments';

  @override
  String get settingsPrayerTimeModeCalculatedAdjustedDescription =>
      'Best for most users. Path of Nūr calculates prayer times for your location and method each day, then applies your saved per-prayer adjustments automatically.';

  @override
  String get settingsPrayerTimeModeManualTitle => 'Fully Manual Prayer Times';

  @override
  String get settingsPrayerTimeModeManualDescription =>
      'Use exact prayer times that you enter yourself. This overrides normal daily prayer calculation for tracked salah times and should only be used if you intentionally want a fixed manual schedule.';

  @override
  String get settingsManualTimesPrefilledFromToday =>
      'Manual times were prefilled from today\'s active prayer schedule.';

  @override
  String get settingsPrayerTimeModeManualNote =>
      'Manual mode is an advanced option. If your local prayer times change seasonally, you may need to update them yourself.';

  @override
  String get settingsRecommendedBadge => 'Recommended';

  @override
  String get settingsPrayerTimeAdjustmentsTitle => 'Prayer Time Adjustments';

  @override
  String get settingsPrayerTimeAdjustmentsSubtitle =>
      'Fine-tune your calculated salah times by a few minutes. Path of Nūr will continue calculating prayer times normally for your location and method, then apply your saved adjustments automatically.';

  @override
  String get settingsPrayerTimeAdjustmentsExample =>
      'If Fajr is calculated as 5:00 AM and you change it to 4:55 AM, the app saves a -5 minute adjustment for Fajr. Future Fajr times will also use that same saved adjustment.';

  @override
  String get settingsPrayerTimeAdjustmentsScope =>
      'Your adjustments are used across the app for prayer display, reminders, countdowns, and daily prayer tracking.';

  @override
  String get settingsCustomAdjustmentsActive => 'Custom adjustments active';

  @override
  String get settingsResetAllAdjustmentsTitle => 'Reset all adjustments?';

  @override
  String get settingsResetAllAdjustmentsBody =>
      'This will return Fajr, Dhuhr, Asr, Maghrib, and Isha to their calculated times.';

  @override
  String get settingsResetAllAdjustments => 'Reset All Adjustments';

  @override
  String get settingsResetAdjustmentsNote =>
      'Resetting removes all saved offsets and returns each salah to its calculated time.';

  @override
  String get settingsManualPrayerTimesTitle => 'Manual Prayer Times';

  @override
  String get settingsManualPrayerTimesSubtitle =>
      'These manual times will be used across the app for reminders, countdowns, and prayer tracking while manual mode is active.';

  @override
  String get settingsUseTodaysCalculatedTimes =>
      'Use Today\'s Calculated Times';

  @override
  String get settingsResetManualTimes => 'Reset Manual Times';

  @override
  String get settingsReturnToRecommendedMode => 'Return to Recommended Mode';

  @override
  String get settingsMosqueTimeComparisonTitle => 'Mosque Time Comparison';

  @override
  String get settingsMosqueTimeComparisonSubtitle =>
      'Compare your local masjid timetable with Path of Nūr\'s calculated and adjusted prayer times. This stays local and helps you review how close your current adjustments are.';

  @override
  String get settingsApplySuggestedAdjustments => 'Apply Suggested Adjustments';

  @override
  String get settingsJumuahSettingsTitle => 'Jumu\'ah Settings';

  @override
  String get settingsJumuahSettingsSubtitle =>
      'Use a Friday-specific reminder time if your Jumu\'ah timing differs from standard Dhuhr.';

  @override
  String get settingsEnableJumuahOverrideTitle => 'Enable Jumu\'ah override';

  @override
  String get settingsEnableJumuahOverrideSubtitle =>
      'Use a dedicated Friday midday reminder without changing the tracked prayer schedule.';

  @override
  String get settingsJumuahTimeTitle => 'Jumu\'ah time';

  @override
  String get settingsJumuahTimeSubtitle =>
      'Used for Friday reminder behavior when selected.';

  @override
  String get settingsNotSet => 'Not set';

  @override
  String get settingsUnavailable => 'Unavailable';

  @override
  String get settingsNoChange => 'No change';

  @override
  String get settingsModified => 'Modified';

  @override
  String get settingsApplySuggestedAdjustmentsTitle =>
      'Apply Suggested Adjustments';

  @override
  String get settingsApplySuggestedAdjustmentsSubtitle =>
      'Review the proposed offsets before replacing your current calculated-time adjustments.';

  @override
  String get settingsPrayerAdjustmentEditorFutureUseNote =>
      'This adjustment will be applied to future calculated prayer times for this salah as well.';

  @override
  String get settingsResetThisPrayer => 'Reset this prayer';

  @override
  String get settingsFridayReminderModeNormalDhuhr => 'Normal Dhuhr timing';

  @override
  String get settingsFridayReminderModeCustomJumuah => 'Custom Jumu\'ah time';

  @override
  String get settingsPrayerNameFajr => 'Fajr';

  @override
  String get settingsPrayerNameDhuhr => 'Dhuhr';

  @override
  String get settingsPrayerNameAsr => 'Asr';

  @override
  String get settingsPrayerNameMaghrib => 'Maghrib';

  @override
  String get settingsPrayerNameIsha => 'Isha';

  @override
  String get settingsNotificationModeNotification => 'Notification';

  @override
  String get settingsNotificationModeAdhan => 'Adhan';

  @override
  String get settingsNotificationModeBeforeQaza => 'Before qaza';

  @override
  String get settingsAttributionsLicensesTitle => 'Attributions & Licenses';

  @override
  String get settingsSyncModePathOfNurCloud => 'Path of Nūr Cloud';

  @override
  String get settingsSyncModeICloud => 'iCloud';

  @override
  String get settingsSyncModeLocalOnly => 'Local only';

  @override
  String get settingsSyncModeManualBackupOnly => 'Manual backup only';

  @override
  String get settingsSyncStateAllCaughtUp => 'All caught up';

  @override
  String get settingsSyncStateSyncing => 'Syncing';

  @override
  String get settingsSyncStateOfflinePending => 'Offline with pending changes';

  @override
  String get settingsSyncStateNeedsAttention => 'Needs attention';

  @override
  String get settingsSyncStateLocalOnly => 'Local only';

  @override
  String get settingsSyncStateICloudActive => 'iCloud active';

  @override
  String get settingsThemeModeDefaultDescription =>
      'The default Path of Nūr look with a soft, elegant feel and gentle depth.';

  @override
  String get settingsThemeModeEasyReadDescription =>
      'Cleaner surfaces and stronger contrast for focused reading. Recommended for longer reading sessions.';

  @override
  String get settingsThemeModeDarkDescription =>
      'A calm low-light appearance for night use. Recommended for low-light environments.';

  @override
  String settingsCurrentProfileSummary(String name, String syncMode) {
    return '$name • $syncMode';
  }

  @override
  String settingsSyncStatusSummary(int count, String syncState) {
    return '$count pending • $syncState';
  }

  @override
  String settingsMosqueTimeLabel(String time) {
    return 'Mosque: $time';
  }

  @override
  String settingsCalculatedTimeLabel(String time) {
    return 'Calculated: $time';
  }

  @override
  String settingsAdjustmentValueLabel(String value) {
    return 'Adjustment: $value';
  }

  @override
  String settingsEffectiveTimeLabel(String time) {
    return 'Effective: $time';
  }

  @override
  String settingsDifferenceValueLabel(String value) {
    return 'Difference: $value';
  }

  @override
  String settingsMinutesValue(String value) {
    return '$value دقیقې';
  }

  @override
  String settingsBaseTimeLabel(String time) {
    return 'Base: $time';
  }

  @override
  String settingsFinalTimeLabel(String time) {
    return 'Final: $time';
  }

  @override
  String settingsPrayerAdjustmentEditorBaseCalculatedTime(String time) {
    return 'Base calculated time: $time';
  }

  @override
  String settingsPrayerAdjustmentEditorCurrentAdjustment(String value) {
    return 'Current adjustment: $value';
  }

  @override
  String settingsSuggestedAdjustmentChangeRow(
    String prayerName,
    String currentValue,
    String suggestedValue,
    Object change,
    Object prayer,
    Object value,
  ) {
    return '$prayerName: $currentValue → $suggestedValue';
  }

  @override
  String settingsPrayerAdjustmentEditorFinalEffectiveTime(String time) {
    return 'Final effective time: $time';
  }

  @override
  String get dhikrResetSessionTitle => 'Reset session?';

  @override
  String get dhikrResetSessionBody =>
      'This will clear the current Dhikr count for this session.';

  @override
  String get dhikrResetAction => 'Reset';

  @override
  String get dhikrCustomTargetTitle => 'Set custom target';

  @override
  String get dhikrCustomTargetHint => 'Enter a session target';

  @override
  String get dhikrApplyAction => 'Apply';

  @override
  String get dhikrAddManualTitle => 'Add count manually';

  @override
  String get dhikrAddManualHint => 'Enter how many to add';

  @override
  String get dhikrAddAction => 'Add';

  @override
  String get dhikrSectionTitle => 'Dhikr';

  @override
  String get dhikrSectionSubtitle =>
      'Keep a simple count, finish sessions, and review your recent remembrance.';

  @override
  String get dhikrTapToCountSemantics => 'Tap to count Dhikr';

  @override
  String get dhikrTapToCount => 'Tap to count';

  @override
  String get dhikrAntiRushTitle => 'Slow down gently';

  @override
  String get dhikrAntiRushBody =>
      'Dhikr is not only in number, but in presence. Slow down, breathe, and remember with sincerity.';

  @override
  String get dhikrAntiRushAcknowledgeAction => 'Continue with presence';

  @override
  String get dhikrTargetReachedMessage =>
      'Session target reached. Alhamdulillah.';

  @override
  String get dhikrUndoOneTooltip => 'Undo one count';

  @override
  String get dhikrAddManuallyAction => 'Add manually';

  @override
  String get dhikrFinishSessionAction => 'Finish session';

  @override
  String get dhikrChoosePhraseTitle => 'Choose phrase';

  @override
  String get dhikrChoosePhraseSubtitle =>
      'Select the remembrance you want to count in this session.';

  @override
  String get dhikrSessionTargetTitle => 'Session target';

  @override
  String get dhikrSessionTargetSubtitle =>
      'Choose a target that fits your current Dhikr session.';

  @override
  String get dhikrCustomTargetChip => 'Custom';

  @override
  String get dhikrDailyGoalTitle => 'Daily goal';

  @override
  String get dhikrDailyGoalSubtitle =>
      'A gentle daily Dhikr target to help you keep a steady rhythm.';

  @override
  String get dhikrSessionVsDailyTitle => 'Session and daily progress';

  @override
  String dhikrCurrentSessionValue(String value) {
    return 'Current session: $value';
  }

  @override
  String dhikrCompletedTodayValue(String value) {
    return 'Completed today: $value';
  }

  @override
  String dhikrDailyTotalValue(String value) {
    return 'Daily total: $value';
  }

  @override
  String dhikrSessionsCompletedTodayValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions completed today',
      one: '1 session completed today',
      zero: '0 sessions completed today',
    );
    return '$_temp0';
  }

  @override
  String dhikrFavoritePhraseValue(String value) {
    return 'Most repeated phrase: $value';
  }

  @override
  String get dhikrRecentSessionsTitle => 'Recent sessions';

  @override
  String get dhikrNoCompletedSessionsYet => 'No completed Dhikr sessions yet.';

  @override
  String dhikrSessionSummaryValue(String progress, String duration) {
    return '$progress • $duration';
  }

  @override
  String get dhikrDurationJustNow => 'Just now';

  @override
  String dhikrDurationMinutes(String value) {
    return '$value min';
  }

  @override
  String get growthTabToday => 'Today';

  @override
  String get growthTabPaths => 'Paths';

  @override
  String get growthTabHabits => 'Habits';

  @override
  String get growthTabJourney => 'Journey';

  @override
  String get growthTabReflection => 'Reflection';

  @override
  String get growthCategoryDailyWorship => 'Daily Worship';

  @override
  String get growthCategorySunnahPractices => 'Sunnah Practices';

  @override
  String get growthCategoryCharacter => 'Character';

  @override
  String get growthCategoryKnowledge => 'Knowledge';

  @override
  String get growthCategoryCharityService => 'Charity & Service';

  @override
  String get growthCategoryHealthDiscipline => 'Health & Discipline';

  @override
  String get growthCategoryReflectionGratitude => 'Reflection & Gratitude';

  @override
  String get growthHomeHeaderSubtitle =>
      'A steady space for habits, paths, reflection, and quiet progress.';

  @override
  String get growthHomeTodaySubtitle =>
      'See today’s rhythm, seasonal moments, and what is gently moving forward.';

  @override
  String get growthHomePathsSubtitle =>
      'Follow focused spiritual paths without carrying everything at once.';

  @override
  String get growthHomeHabitsSubtitle =>
      'Track the habits that quietly shape your day.';

  @override
  String get growthHomeJourneySubtitle =>
      'Review your level, unlocks, and steady progress.';

  @override
  String get growthHomeReflectionSubtitle =>
      'Pause for gratitude, tawbah, and honest review.';

  @override
  String get growthHomePrivateModeTitle => 'Quiet progress';

  @override
  String get growthHomePublicModeTitle => 'Growth in motion';

  @override
  String get growthHomeAllUnlocksPresent =>
      'All current unlocks are already present.';

  @override
  String growthHomeNextUnlock(String title) {
    return 'Next unlock: $title';
  }

  @override
  String growthHomeSymbolicGiftsPresent(String count) {
    return '$count symbolic gifts present';
  }

  @override
  String growthHomeCalmGiftsPresent(String count) {
    return '$count calm gifts present';
  }

  @override
  String get growthHomeHabitTrackerTitle => 'Habit Tracker';

  @override
  String get growthHomeNoHabitsSelected => 'No active habits selected yet.';

  @override
  String growthHomeHabitsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits selected',
      one: '1 habit selected',
      zero: '0 habits selected',
    );
    return '$_temp0';
  }

  @override
  String get growthHomeBrowseAllTitle => 'Browse All';

  @override
  String get growthHomeBrowseAllSubtitle =>
      'Open the full journey map and browse everything.';

  @override
  String get growthHomeLegacyLearningTitle => 'Legacy Learning Material';

  @override
  String get growthHomeLegacyLearningSubtitle =>
      'Keep the current Learn hub fully available during migration.';

  @override
  String growthPercentValue(String value) {
    return '$value%';
  }

  @override
  String get growthTodaySummaryTitle => 'Today Summary';

  @override
  String growthTodayCompletedSummary(String completed, String due) {
    return '$completed/$due gently completed';
  }

  @override
  String growthTodayInProgressSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count still in progress',
      one: '1 still in progress',
    );
    return '$_temp0';
  }

  @override
  String growthTodayLightAdded(String value) {
    return 'Light added today: $value';
  }

  @override
  String get growthTodayQuietProgressNote =>
      'Some progress is entrusted and tracked quietly.';

  @override
  String growthTodaySteadyDaysSummary(String current, String best) {
    return 'Steady days: $current (best $best)';
  }

  @override
  String growthTodayGentleReturnSupport(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gentle return support used this week: $count',
      one: 'Gentle return support used this week: 1',
    );
    return '$_temp0';
  }

  @override
  String get growthTodaySeasonalJourneyTitle => '🌙 Seasonal Journey';

  @override
  String get growthTodaySeasonalRhythmTitle => '🗓 Seasonal Rhythm';

  @override
  String growthJourneyHijriDateCompactValue(String day, String month) {
    return '$day $month';
  }

  @override
  String get growthTodayRamadanModeOverrideTitle => 'Ramadan mode override';

  @override
  String get growthTodayRamadanModeOverrideSubtitle =>
      'Enable manually when you want Ramadan journeys active.';

  @override
  String get growthTodayRamadanSnapshotTitle => 'Ramadan Snapshot';

  @override
  String growthTodayJuzJourneyValue(String progress) {
    return 'Juz journey $progress/30';
  }

  @override
  String growthTodayFastTrackingValue(String value) {
    return 'Fast tracking: $value';
  }

  @override
  String get growthTodayHabitTrackerTitle => 'Habit Tracker';

  @override
  String get growthTodayHabitTrackerSubtitle =>
      'All habit tracking now lives in its own dedicated page, with day selection, fast tracking, progress, and end-of-day review.';

  @override
  String get growthTodayOpenHabitTracker => 'Open Habit Tracker';

  @override
  String get growthTodayEndOfDayTitle => 'End of Day';

  @override
  String growthTodayEndOfDaySummary(
    String percent,
    String completed,
    String partial,
    String missed,
  ) {
    return '$percent% tended • $completed completed • $partial on your path • $missed to revisit gently';
  }

  @override
  String get growthFastTypeRamadan => 'Ramadan';

  @override
  String get growthFastTypeMondayThursday => 'Monday/Thursday';

  @override
  String get growthFastTypeWhiteDays => 'White Days';

  @override
  String get growthFastTypeArafah => 'Arafah';

  @override
  String get growthFastTypeAshura => 'Ashura';

  @override
  String get growthFastTypeCustom => 'Custom';

  @override
  String get growthDifficultyDeep => 'Deep';

  @override
  String get growthDifficultySteady => 'Steady';

  @override
  String get growthDifficultyFoundation => 'Foundation';

  @override
  String get growthStatusDue => 'Due';

  @override
  String get growthMoodCalm => 'Calm';

  @override
  String get growthMoodGrateful => 'Grateful';

  @override
  String get growthMoodHopeful => 'Hopeful';

  @override
  String get growthMoodTired => 'Tired';

  @override
  String get growthMoodHeavy => 'Heavy';

  @override
  String get growthHabitsPageSubtitle =>
      'Track today’s habits with a clearer, dedicated space.';

  @override
  String get growthHabitsSummaryTitle => 'Habit Summary';

  @override
  String get growthHabitsRamadanTrackingTitle => 'Ramadan Habit Tracking';

  @override
  String get growthHabitsSeasonalTrackingTitle => 'Seasonal Habit Tracking';

  @override
  String get growthHabitsSeasonalPillFast => 'Fast';

  @override
  String get growthHabitsSeasonalPillQuran => 'Qur’an';

  @override
  String get growthHabitsSeasonalPillCharity => 'Charity';

  @override
  String get growthHabitsQuranCompletionPlan => 'Qur’an completion plan';

  @override
  String growthHabitsJuzJourneySummary(String progress, String remaining) {
    return 'Juz journey $progress/30 · $remaining to continue';
  }

  @override
  String growthHabitsGentlePaceSummary(String juzPerDay, String days) {
    return 'A gentle pace: ~$juzPerDay juz/day over $days days';
  }

  @override
  String get growthHabitsFastTrackingTitle => 'Fast Tracking';

  @override
  String growthHabitsRecommendedValue(String value) {
    return 'Recommended: $value';
  }

  @override
  String get growthHabitsFastNotedToday => 'Fast noted for today';

  @override
  String get growthHabitsNoteTodaysFast => 'Note today’s fast';

  @override
  String get growthHabitsNoHabitsDue =>
      'No habits are due right now. Continue your path with a light review.';

  @override
  String get growthHabitsProgressLabel => 'Progress';

  @override
  String get growthHabitsSetPartialCompletion => 'Set partial completion';

  @override
  String get growthReflectionRecentChangesTitle => 'Recent Changes';

  @override
  String get growthReflectionRecentChangesEmpty =>
      'Reflection nourishes quiet growth over time.';

  @override
  String get growthReflectionRecentUnlockNote =>
      'A recent unlock appeared through steady reflection and small steps.';

  @override
  String get growthReflectionSeasonalPromptsTitle => 'Seasonal prompts';

  @override
  String get growthReflectionNoSeasonalPrompt =>
      'No seasonal prompt today. Continue your path with sincerity.';

  @override
  String get growthReflectionIntro =>
      'This space is for honest review, gratitude, tawbah, and entrusting your efforts to Allah.';

  @override
  String get growthReflectionPrivateModeTitle =>
      'Private mode (quiet growth visuals)';

  @override
  String get growthReflectionPromptSuggestionsTitle => 'Prompt suggestions';

  @override
  String get growthReflectionPromptLibraryTitle => 'Prompt library';

  @override
  String get growthReflectionDailyPromptTitle => 'Daily reflection prompt';

  @override
  String get growthReflectionDailyPromptHint => 'What shaped your heart today?';

  @override
  String get growthReflectionMoodTitle => 'Mood / state';

  @override
  String get growthReflectionRelatedHabitLabel => 'Related habit (optional)';

  @override
  String get growthReflectionNoneOption => 'None';

  @override
  String get growthReflectionGratitudeTitle => 'Gratitude';

  @override
  String get growthReflectionGratitudeHint => 'Name one blessing from today';

  @override
  String get growthReflectionTawbahTitle => 'Tawbah / review of the day';

  @override
  String get growthReflectionTawbahHint => 'What do you seek forgiveness for?';

  @override
  String get growthReflectionShortNotesTitle => 'Short notes';

  @override
  String get growthReflectionShortNotesHint => 'Keep this simple and sincere';

  @override
  String get growthReflectionEntrustToAllahTitle => 'Entrust deeds to Allah';

  @override
  String get growthReflectionEntrustToAllahSubtitle =>
      'When enabled, this entry is tracked quietly without celebratory emphasis.';

  @override
  String get growthReflectionSaveAction => 'Save Reflection';

  @override
  String get growthReflectionTodayEntriesTitle => 'Today entries';

  @override
  String get growthReflectionBeginAgain =>
      'Begin again today with a short reflection.';

  @override
  String growthReflectionMoodValue(String value) {
    return 'Mood: $value';
  }

  @override
  String growthReflectionPromptValue(String value) {
    return 'Prompt: $value';
  }

  @override
  String growthReflectionGratitudeValue(String value) {
    return 'Gratitude: $value';
  }

  @override
  String growthReflectionTawbahValue(String value) {
    return 'Tawbah: $value';
  }

  @override
  String growthReflectionNoteValue(String value) {
    return 'Note: $value';
  }

  @override
  String get growthReflectionEntrustedQuietly => 'Entrusted quietly to Allah';

  @override
  String get growthReflectionGratitudeHistoryTitle => 'Gratitude history';

  @override
  String get growthReflectionNoGratitudeHistory => 'No gratitude history yet.';

  @override
  String get growthReflectionRecentReflectionsTitle => 'Recent reflections';

  @override
  String get growthReflectionEntryFallbackTitle => 'Reflection entry';

  @override
  String get growthJourneyQuietProgressTitle => 'Quiet Progress';

  @override
  String get growthJourneyOverviewTitle => 'Growth Overview';

  @override
  String growthJourneyNextStageValue(String value) {
    return 'Next stage: $value';
  }

  @override
  String growthJourneyNextUnlockValue(String value) {
    return 'Next unlock: $value';
  }

  @override
  String get growthJourneyUnlockablesTitle => 'Unlockables';

  @override
  String get growthJourneyUnlocksAppear => 'Unlocks appear as your path grows.';

  @override
  String growthJourneyUnlockTypeValue(String type, String title) {
    return '$type • $title';
  }

  @override
  String get growthJourneyRecentUnlocksTitle => 'Recent unlocks';

  @override
  String growthJourneyUnlockEventValue(String subtitle, String date) {
    return '$subtitle • $date';
  }

  @override
  String get growthJourneyUnlockedWallpapersTitle => 'Unlocked Wallpapers';

  @override
  String get growthJourneyWallpapersAppear =>
      'Wallpapers appear quietly as your progress grows.';

  @override
  String growthJourneyPreviewPlaceholderReady(String subtitle) {
    return '$subtitle • preview placeholder ready';
  }

  @override
  String get growthJourneyVisualThemesTitle => 'Visual Themes';

  @override
  String get growthJourneyThemesAppear =>
      'Theme accents appear through steady consistency.';

  @override
  String get growthJourneySeasonalJourneysTitle => 'Seasonal Journeys';

  @override
  String get growthJourneyNoSeasonalJourney =>
      'No seasonal journey is active. Keep walking your steady path.';

  @override
  String growthJourneyHijriDateValue(String day, String month, String year) {
    return '$day $month $year AH';
  }

  @override
  String get growthJourneyMainJourneyTitle => 'Journey';

  @override
  String growthJourneyPrivateModeSummary(String value) {
    return 'Private mode is on. Visible light remains quiet while your progress continues ($value).';
  }

  @override
  String growthJourneyLevelSummary(
    String level,
    String visibleLight,
    String remaining,
  ) {
    return 'Level $level • $visibleLight visible light • $remaining light to the next stage';
  }

  @override
  String growthJourneySteadyDaysPill(String value) {
    return 'Steady days $value';
  }

  @override
  String growthJourneyBestSteadyRunPill(String value) {
    return 'Best steady run $value';
  }

  @override
  String growthJourneyActsTendedPill(String value) {
    return '$value acts tended';
  }

  @override
  String growthJourneyGentleReturnDayPill(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gentle return days',
      one: '1 gentle return day',
      zero: '0 gentle return days',
    );
    return '$_temp0';
  }

  @override
  String get growthJourneyWeeklySummaryTitle => 'Weekly summary';

  @override
  String growthJourneyWeeklyRhythmSummary(String percent, String note) {
    return 'Weekly rhythm $percent% • $note';
  }

  @override
  String get growthJourneyMonthlySummaryTitle => 'Monthly summary';

  @override
  String growthJourneyMonthlyRhythmSummary(String days, String percent) {
    return '$days rooted days • $percent% monthly rhythm';
  }

  @override
  String get growthJourneyCategoryConsistencyTitle => 'Category consistency';

  @override
  String get growthJourneyPathProgressTitle => 'Path progress';

  @override
  String growthJourneyPathProgressValue(String percent, String nextStep) {
    return '$percent% complete • $nextStep';
  }

  @override
  String get growthJourneyMilestonesTitle => 'Milestones';

  @override
  String get growthJourneyMilestonesAppear =>
      'Milestones will appear as your consistency builds.';

  @override
  String get growthJourneyRecentGrowthActivityTitle => 'Recent growth activity';

  @override
  String growthJourneyEntrustedQuietly(String subtitle) {
    return '$subtitle • entrusted quietly';
  }

  @override
  String get growthUnlockTypeWallpaper => 'Wallpaper';

  @override
  String get growthUnlockTypeVisual => 'Visual';

  @override
  String get growthUnlockTypeTheme => 'Theme';

  @override
  String get growthUnlockTypeReflectionPack => 'Reflection Pack';

  @override
  String get growthUnlockTypeMilestone => 'Milestone';

  @override
  String get growthUnlockTypeSeasonal => 'Seasonal';

  @override
  String get growthEncouragementCompletion1 =>
      'A small act completed with sincerity carries weight.';

  @override
  String get growthEncouragementCompletion2 =>
      'Steady, sincere steps matter more than intensity.';

  @override
  String get growthEncouragementCompletion3 =>
      'What was completed today still carries light.';

  @override
  String get growthEncouragementReturning1 =>
      'Begin again gently. A quiet return still counts.';

  @override
  String get growthEncouragementReturning2 =>
      'Return with one small step today.';

  @override
  String get growthEncouragementReturning3 =>
      'Gentle consistency is better than force.';

  @override
  String get growthEncouragementStreak1 => 'Steadiness is forming quietly.';

  @override
  String get growthEncouragementStreak2 => 'A gentle rhythm is taking root.';

  @override
  String get growthEncouragementStreak3 =>
      'Consistency grows through small returns.';

  @override
  String get growthEncouragementDayEnd1 =>
      'Today held sincere effort. Keep walking gently.';

  @override
  String get growthEncouragementDayEnd2 =>
      'Some good took root today. Continue with calm steadiness.';

  @override
  String get growthEncouragementDayEnd3 => 'A quiet review can renew tomorrow.';

  @override
  String get growthEncouragementPath1 =>
      'This path is strengthening through steady steps.';

  @override
  String get growthEncouragementPath2 =>
      'Keep this path warm with one sincere action.';

  @override
  String get growthEncouragementPath3 =>
      'Small consistency builds lasting direction.';

  @override
  String get growthEncouragementReminder1 =>
      'Return gently when you are ready.';

  @override
  String get growthEncouragementReminder2 =>
      'One small step is enough to begin again.';

  @override
  String get growthEncouragementReminder3 => 'Quiet progress still matters.';

  @override
  String get growthPathRecommendedNextStepDefault =>
      'Keep this path active with one small step today.';

  @override
  String growthPathRecommendedNextStepCompleteToday(String title) {
    return 'Complete $title today.';
  }

  @override
  String growthPathRecommendedNextStepFocus(String title) {
    return 'Next focus: $title';
  }

  @override
  String growthRamadanProgressLabel(int percent) {
    return '$percent% of today\'s Ramadan path tended';
  }

  @override
  String growthReflectionPromptCompleted(String title) {
    return 'How did \"$title\" shape your heart today?';
  }

  @override
  String growthReflectionPromptRevisit(String title) {
    return 'How can you return gently to \"$title\" and take one small step?';
  }

  @override
  String get growthReflectionPromptSincereMoment =>
      'What was your most sincere moment today?';

  @override
  String get growthRecentActivityReflectionRecorded => 'Reflection recorded';

  @override
  String get growthRecentActivityPrivateNote => 'Private note';

  @override
  String get growthWeeklySummaryStrong =>
      'A steady, nourishing rhythm is forming.';

  @override
  String get growthWeeklySummaryBalanced =>
      'A balanced week with gentle momentum.';

  @override
  String get growthWeeklySummaryRestart =>
      'Begin again today. Reflection can softly renew your rhythm.';

  @override
  String get growthMonthlySummaryStrong =>
      'This month reflects steady patience and gentle continuity.';

  @override
  String get growthMonthlySummaryGentle =>
      'Continue with small, sincere steps.';

  @override
  String get growthStatusCompleted => 'Done with care';

  @override
  String get growthStatusPartial => 'On your path';

  @override
  String get growthStatusSkipped => 'Paused for today';

  @override
  String get growthStatusSnoozed => 'Return later';

  @override
  String get growthStatusDeferred => 'Carry forward';

  @override
  String get oceanCommunityTitle => 'Community Ocean';

  @override
  String get oceanCommunitySubtitle =>
      'Every act adds a drop. Together, the drops gather into an ocean.';

  @override
  String oceanHeroGreeting(String name) {
    return 'Peaceful contribution, $name';
  }

  @override
  String get oceanHeroSubtitle =>
      'Your drops travel a personal water path while also joining something far larger than any one person can finish alone.';

  @override
  String get oceanMetricCommunityStage => 'Community stage';

  @override
  String get oceanMetricYourWaterPath => 'Your water path';

  @override
  String get oceanMetricDropsToday => 'Drops today';

  @override
  String get oceanMetricCommunityTotal => 'Community total';

  @override
  String get oceanSharedWatersTitle => 'Shared waters';

  @override
  String oceanSharedWatersFlowingIn(String stage) {
    return 'The community is presently flowing in $stage.';
  }

  @override
  String oceanSharedWatersMovingToward(String stage) {
    return 'The first visible gathering is still moving toward $stage.';
  }

  @override
  String get oceanCommunityStageProgressTitle => 'Community stage progress';

  @override
  String get oceanCurrentStageLabel => 'Current stage';

  @override
  String oceanGatheringToward(String stage) {
    return 'Gathering toward $stage';
  }

  @override
  String get oceanTotalCommunityDropsLabel => 'Total community drops';

  @override
  String oceanLargeAndExactDropCount(String large, String exact) {
    return '$large ($exact)';
  }

  @override
  String get oceanNextStageLabel => 'Next stage';

  @override
  String get oceanOceanOfCreationReached => 'Ocean of Creation reached';

  @override
  String get oceanRemainingLabel => 'Remaining';

  @override
  String get oceanNone => 'None';

  @override
  String oceanReadableStageDistance(String drops, String water) {
    return '$drops drops • $water';
  }

  @override
  String get oceanCrossedOceanOfCreation =>
      'The community has crossed the symbolic horizon of Ocean of Creation.';

  @override
  String oceanProgressTowardStage(String percent, String stage) {
    return '$percent of the way to $stage.';
  }

  @override
  String get oceanFinalBenchmarkTitle => 'Final benchmark';

  @override
  String oceanBenchmarkTowardCreation(String percent) {
    return '$percent toward Ocean of Creation.';
  }

  @override
  String get oceanYourContributionTitle => 'Your contribution';

  @override
  String oceanContributionSummary(String today, String lifetime) {
    return 'You added $today drops today. Your lifetime contribution is $lifetime drops.';
  }

  @override
  String get oceanStatLifetime => 'Lifetime';

  @override
  String get oceanStatToday => 'Today';

  @override
  String get oceanStatWater => 'Water';

  @override
  String get oceanStatOfCommunity => 'Of community';

  @override
  String get oceanStatTowardNextStage => 'Toward next stage';

  @override
  String get oceanContributionQuietNote =>
      'Your drops help move the community forward without needing to be loud to matter.';

  @override
  String get oceanContributionFirstDropsNote =>
      'Your first drops will help begin the visible gathering.';

  @override
  String get oceanPersonalWaterPathTitle => 'Personal water path';

  @override
  String get oceanPersonalWaterPathSubtitle =>
      'An intimate view of your own gathering water.';

  @override
  String get oceanPersonalPathComplete =>
      'Your path has reached Flowing Water and can continue deepening.';

  @override
  String oceanPersonalPathRemaining(
    String gathered,
    String remaining,
    String stage,
  ) {
    return '$gathered drops gathered. $remaining remain until $stage.';
  }

  @override
  String get oceanRealWaterScaleTitle => 'Real water scale';

  @override
  String get oceanWaterYourDropsLabel => 'Your drops';

  @override
  String get oceanWaterCommunityWatersLabel => 'Community waters';

  @override
  String get oceanWaterRemainingToNextStageLabel => 'Remaining to next stage';

  @override
  String get oceanWaterRemainingToCreationLabel =>
      'Remaining to Ocean of Creation';

  @override
  String get oceanMilestoneExplorerTitle => 'Milestone explorer';

  @override
  String get oceanYourPathTitle => 'Your path';

  @override
  String get oceanRequiredDropsLabel => 'Required drops';

  @override
  String get oceanWaterEquivalentLabel => 'Water equivalent';

  @override
  String get oceanCurrentProgressLabel => 'Current progress';

  @override
  String oceanDropsRemain(String count) {
    return '$count drops remain';
  }

  @override
  String get oceanSourceEchoTitle => 'Where drops have come from';

  @override
  String get oceanSourceEchoEmpty =>
      'As you pray, learn, reflect, and remember, each area will begin to leave a trace here.';

  @override
  String oceanDropsAdded(String count) {
    return '+$count';
  }

  @override
  String get oceanSourceQuizzes => 'Quizzes';

  @override
  String get oceanSourceHabits => 'Habits';

  @override
  String get oceanSourceSalahTrainer => 'Salah trainer';

  @override
  String get oceanSourceDua => 'Dua';

  @override
  String get oceanSourceReflections => 'Reflections';

  @override
  String get oceanSourceGrowth => 'Growth';

  @override
  String get oceanStageCurrent => 'Current';

  @override
  String get oceanStageReached => 'Reached';

  @override
  String get oceanStageAhead => 'Ahead';

  @override
  String get oceanReflectionLine1 => 'Small acts gather into deep waters.';

  @override
  String get oceanReflectionLine2 => 'Every drop still matters.';

  @override
  String get oceanReflectionLine3 => 'Vast creation, meaningful contribution.';

  @override
  String get oceanReflectionLine4 => 'Today’s drops joined something greater.';

  @override
  String get oceanCommunityStageSpringTitle => 'Spring';

  @override
  String get oceanCommunityStageSpringDescription =>
      'The first quiet gathering where shared drops begin to pool.';

  @override
  String get oceanCommunityStageStreamTitle => 'Stream';

  @override
  String get oceanCommunityStageStreamDescription =>
      'A steady current shaped by many small acts arriving together.';

  @override
  String get oceanCommunityStagePondTitle => 'Pond';

  @override
  String get oceanCommunityStagePondDescription =>
      'Still water deep enough to reflect a wider sky.';

  @override
  String get oceanCommunityStageLakeTitle => 'Lake';

  @override
  String get oceanCommunityStageLakeDescription =>
      'A broad body of water formed by patient, persistent offering.';

  @override
  String get oceanCommunityStageGreatLakeTitle => 'Great Lake';

  @override
  String get oceanCommunityStageGreatLakeDescription =>
      'A scale that reminds the heart how much can gather slowly.';

  @override
  String get oceanCommunityStageInlandSeaTitle => 'Inland Sea';

  @override
  String get oceanCommunityStageInlandSeaDescription =>
      'An inland expanse carrying the weight of countless contributions.';

  @override
  String get oceanCommunityStageGreatWatersTitle => 'Great Waters';

  @override
  String get oceanCommunityStageGreatWatersDescription =>
      'Waters so vast that the horizon itself begins to soften.';

  @override
  String get oceanCommunityStageOceanOfCreationTitle => 'Ocean of Creation';

  @override
  String get oceanCommunityStageOceanOfCreationDescription =>
      'A symbolic horizon of immensity, awe, and shared striving.';

  @override
  String get oceanPersonalStageDropTitle => 'Drop';

  @override
  String get oceanPersonalStageDropDescription =>
      'A first offering has entered the water path.';

  @override
  String get oceanPersonalStageRippleTitle => 'Ripple';

  @override
  String get oceanPersonalStageRippleDescription =>
      'Small steady acts begin to leave a visible trace.';

  @override
  String get oceanPersonalStageSpringTitle => 'Spring';

  @override
  String get oceanPersonalStageSpringDescription =>
      'Your path begins to gather into a gentle source.';

  @override
  String get oceanPersonalStageStreamTitle => 'Stream';

  @override
  String get oceanPersonalStageStreamDescription =>
      'Consistency forms a living current of devotion.';

  @override
  String get oceanPersonalStageBrookTitle => 'Brook';

  @override
  String get oceanPersonalStageBrookDescription =>
      'A quiet brook shaped by regular acts over time.';

  @override
  String get oceanPersonalStagePondTitle => 'Pond';

  @override
  String get oceanPersonalStagePondDescription =>
      'Your drops begin to gather into something still and lasting.';

  @override
  String get oceanPersonalStageQuietLakeTitle => 'Quiet Lake';

  @override
  String get oceanPersonalStageQuietLakeDescription =>
      'A calmer depth now reflects a longer journey.';

  @override
  String get oceanPersonalStageFlowingWaterTitle => 'Flowing Water';

  @override
  String get oceanPersonalStageFlowingWaterDescription =>
      'A mature, continuous current shaped by many sincere days.';

  @override
  String get gardenGalleryTitle => 'Garden Gallery';

  @override
  String get gardenGallerySubtitle =>
      'Drops quietly unlock the first garden milestones for Journey and Ocean.';

  @override
  String gardenGalleryTotalDropsValue(String count) {
    return '$count total drops';
  }

  @override
  String get gardenGalleryAllUnlocked => 'All ten milestones are unlocked.';

  @override
  String gardenGalleryNextUnlockValue(String title, String count) {
    return 'Next unlock: $title at $count drops';
  }

  @override
  String get gardenGalleryUnlocked => 'Unlocked';

  @override
  String gardenGalleryLockedAtValue(String count) {
    return 'Unlocks at $count drops';
  }

  @override
  String gardenGalleryRequiresValue(String count) {
    return 'Requires $count drops';
  }

  @override
  String gardenGalleryTileProgressValue(String current, String required) {
    return '$current / $required Drops';
  }

  @override
  String get gardenPageTitle => 'Garden';

  @override
  String get gardenPageSubtitle =>
      'A quiet gallery of growth shaped by your drops over time.';

  @override
  String get gardenPageHeroTitle => 'Your Garden';

  @override
  String get gardenPageHeroSubtitle =>
      'Each unlocked image reflects steady worship, learning, and return without turning the journey into a game.';

  @override
  String get gardenPageTotalDrops => 'Total drops';

  @override
  String get gardenPageUnlockedImages => 'Unlocked';

  @override
  String gardenPageUnlockedCountValue(String unlocked, String total) {
    return '$unlocked / $total images';
  }

  @override
  String get gardenPageMeaningTitle => 'What the garden reflects';

  @override
  String get gardenPagePrayerMeaningTitle => 'Prayer';

  @override
  String get gardenPagePrayerMeaningBody =>
      'Prayer forms the roots and trunk: steady, grounding, and essential.';

  @override
  String get gardenPageLearningMeaningTitle => 'Learning and wisdom';

  @override
  String get gardenPageLearningMeaningBody =>
      'Learning matures into fruit: insight, understanding, and better action.';

  @override
  String get gardenPageDropsMeaningTitle => 'Drops';

  @override
  String get gardenPageDropsMeaningBody =>
      'Drops bring greenery and life, marking sincere acts that nourish the whole garden.';

  @override
  String get gardenPageNextUnlockTitle => 'Next unlock';

  @override
  String get gardenPageAllUnlockedTitle => 'Garden gallery complete';

  @override
  String get gardenPageAllUnlockedBody =>
      'All ten V1 garden images are unlocked. Future phases can build on this calm foundation without changing your Drops history.';

  @override
  String gardenPageNextUnlockRequiredValue(String count) {
    return 'Unlocks at $count drops';
  }

  @override
  String gardenPageDropsRemainingValue(String count) {
    return '$count drops remaining';
  }

  @override
  String gardenPageEntrySubtitle(String drops, String title) {
    return '$drops drops gathered. Next image: $title.';
  }

  @override
  String get gardenPageEntryHomeSubtitle =>
      'Open your unlocked images, meaning, and next milestone in one calm view.';

  @override
  String get gardenMilestoneTitle1 => 'First Seed';

  @override
  String get gardenMilestoneDescription1 =>
      'Your first drop plants the earliest sign of steady return.';

  @override
  String get gardenMilestoneTitle2 => 'Gentle Rain';

  @override
  String get gardenMilestoneDescription2 =>
      'Ten drops bring the first soft rain over the garden.';

  @override
  String get gardenMilestoneTitle3 => 'Olive Shoot';

  @override
  String get gardenMilestoneDescription3 =>
      'Twenty-five drops reveal a rooted young olive shoot.';

  @override
  String get gardenMilestoneTitle4 => 'Morning Path';

  @override
  String get gardenMilestoneDescription4 =>
      'Fifty drops open a brighter path through the garden.';

  @override
  String get gardenMilestoneTitle5 => 'Quiet Fountain';

  @override
  String get gardenMilestoneDescription5 =>
      'One hundred drops uncover a calm fountain of remembrance.';

  @override
  String get gardenMilestoneTitle6 => 'Olive Courtyard';

  @override
  String get gardenMilestoneDescription6 =>
      'Two hundred drops widen the garden into a shaded courtyard.';

  @override
  String get gardenMilestoneTitle7 => 'Lamp Walk';

  @override
  String get gardenMilestoneDescription7 =>
      'Three hundred and fifty drops light a gentle walkway for continued worship.';

  @override
  String get gardenMilestoneTitle8 => 'Rain of Mercy';

  @override
  String get gardenMilestoneDescription8 =>
      'Five hundred drops bring a fuller season of mercy and renewal.';

  @override
  String get gardenMilestoneTitle9 => 'Star Reflection';

  @override
  String get gardenMilestoneDescription9 =>
      'Seven hundred and fifty drops unveil a reflective night garden under the stars.';

  @override
  String get gardenMilestoneTitle10 => 'Path of Nūr';

  @override
  String get gardenMilestoneDescription10 =>
      'One thousand drops complete the first garden gallery with a path of light.';

  @override
  String get learnMetadataDomainQuranSubtitle =>
      'Verses, surahs, and guided reflection from the Qur’an.';

  @override
  String get learnMetadataDomainHadithSubtitle =>
      'Foundational hadith with practical lessons and reflection.';

  @override
  String get learnMetadataDomainProphetsSubtitle =>
      'Stories, patterns, and lessons from the prophets.';

  @override
  String get learnMetadataDomainLifeLessonsSubtitle =>
      'Qur’anic guidance for real situations and decisions.';

  @override
  String get learnMetadataDomainSalahSubtitle =>
      'Prayer learning, rak‘ahs, and recitation practice.';

  @override
  String get learnMetadataDomainNamesSubtitle =>
      'Names of Allah with meaning and reflection.';

  @override
  String get learnMetadataDomainBabyNamesSubtitle =>
      'Meaningful names with origins and gentle guidance.';

  @override
  String get learnMetadataDomainQuizzesSubtitle =>
      'Review what you have learned through structured quizzes.';

  @override
  String get learnMetadataDomainNotesSubtitle =>
      'Private notes and saved reflections across learning.';

  @override
  String learnMetadataQuranVerseTitle(int surah, int ayah) {
    return 'Qur’an $surah:$ayah';
  }

  @override
  String learnMetadataHadithSubtitle(String collection, String grading) {
    return '$collection • $grading';
  }

  @override
  String learnMetadataSalahPrayerSubtitle(
    String rakahs,
    String recitationStyle,
  ) {
    return '$rakahs rak‘ahs • $recitationStyle';
  }

  @override
  String learnMetadataSurahSubtitle(String surahNumber) {
    return 'Surah $surahNumber';
  }

  @override
  String learnMetadataQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: '0 questions',
    );
    return '$_temp0';
  }

  @override
  String get learnMetadataProphetsReviewQuizTitle => 'Prophets Review Quiz';

  @override
  String learnMetadataQuestionsInPool(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions in pool',
      one: '1 question in pool',
      zero: '0 questions in pool',
    );
    return '$_temp0';
  }

  @override
  String get learnMetadataProphetsReviewQuizSummary =>
      'A mixed review of prophet stories, lessons, and timeline knowledge.';

  @override
  String learnMetadataQuranNoteTitle(String surahNumber, String ayahNumber) {
    return 'Note on Qur’an $surahNumber:$ayahNumber';
  }

  @override
  String learnMetadataQuranNoteSubtitle(String surahNumber, String ayahNumber) {
    return 'Saved reflection for Qur’an $surahNumber:$ayahNumber';
  }

  @override
  String get learnMetadataPathFaithFoundationsTitle => 'Faith Foundations';

  @override
  String get learnMetadataPathFaithFoundationsSummary =>
      'Build a grounded understanding of belief, worship, and guidance.';

  @override
  String get learnMetadataPathFaithStep1 => 'Read a foundational verse';

  @override
  String get learnMetadataPathFaithStep2 => 'Study a core hadith';

  @override
  String get learnMetadataPathFaithStep3 => 'Review a prophet lesson';

  @override
  String get learnMetadataPathFaithStep4 => 'Practice salah basics';

  @override
  String get learnMetadataPathFaithStep5 => 'Write one reflection';

  @override
  String get learnMetadataPathCharacterTitle => 'Character and Conduct';

  @override
  String get learnMetadataPathCharacterSummary =>
      'Grow honesty, patience, gratitude, and mercy through guided steps.';

  @override
  String get learnMetadataPathCharacterStep1 => 'Read a character verse';

  @override
  String get learnMetadataPathCharacterStep2 => 'Study a manners hadith';

  @override
  String get learnMetadataPathCharacterStep3 => 'Review one life lesson';

  @override
  String get learnMetadataPathCharacterStep4 => 'Choose one practice action';

  @override
  String get learnMetadataPathCharacterStep5 => 'Save one note';

  @override
  String get learnMetadataPathReturnTitle => 'Returning to Practice';

  @override
  String get learnMetadataPathReturnSummary =>
      'A gentle path back into learning, prayer, and remembrance.';

  @override
  String get learnMetadataPathReturnStep1 => 'Open today’s daily learning';

  @override
  String get learnMetadataPathReturnStep2 => 'Read one short hadith';

  @override
  String get learnMetadataPathReturnStep3 => 'Review a prophet lesson';

  @override
  String get learnMetadataPathReturnStep4 => 'Practice one salah item';

  @override
  String get learnMetadataPathReturnStep5 => 'Write a private reflection';

  @override
  String get learningJourneyProphetsJourneyTitle => 'Prophets Journey';

  @override
  String get learningJourneyProphetsJourneySubtitle =>
      'Travel through the stories, lessons, and patterns of the prophets.';

  @override
  String get learningJourneyProphetsJourneyDescription =>
      'A guided journey through the prophets with reflection, timeline context, and key lessons.';

  @override
  String get learningJourneySeerahJourneyTitle => 'Seerah Journey';

  @override
  String get learningJourneySeerahJourneySubtitle =>
      'Learn the life, mercy, and mission of the Messenger ﷺ.';

  @override
  String get learningJourneySeerahJourneyDescription =>
      'A guided path through the seerah with milestones, lessons, and reflection.';

  @override
  String get learningJourneyDuasDailyLifeTitle => 'Duas for Daily Life';

  @override
  String get learningJourneyDuasDailyLifeSubtitle =>
      'Daily supplications for everyday moments and needs.';

  @override
  String get learningJourneyDuasDailyLifeDescription =>
      'A practical journey through duas for daily routines, transitions, and hopes.';

  @override
  String get learningJourneyDailyDhikrTitle => 'Daily Dhikr';

  @override
  String get learningJourneyDailyDhikrSubtitle =>
      'Remember Allah through steady daily dhikr.';

  @override
  String get learningJourneyDailyDhikrDescription =>
      'A simple journey through morning, evening, and everyday remembrance.';

  @override
  String get prophetsPageTitle => 'Stories of the Prophets';

  @override
  String get prophetsPageSubtitle =>
      'Explore the prophets through stories, timeline, map, family tree, and guided journey.';

  @override
  String get prophetsContinueLastOpenedTitle => 'Continue where you left off';

  @override
  String prophetsContinueLastOpenedSubtitle(String name, String era) {
    return '$name • $era';
  }

  @override
  String get prophetsOpenAction => 'Open';

  @override
  String get prophetsSearchHint => 'Search prophets, eras, or regions';

  @override
  String get prophetsFilterAll => 'All';

  @override
  String get prophetsFilterFeatured => 'Featured';

  @override
  String get prophetsFilterAny => 'Any';

  @override
  String prophetsFilterEra(String value) {
    return 'Era: $value';
  }

  @override
  String prophetsFilterRegion(String value) {
    return 'Region: $value';
  }

  @override
  String get prophetsFilterClear => 'Clear filters';

  @override
  String prophetsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prophets shown',
      one: '1 prophet shown',
      zero: 'No prophets shown',
    );
    return '$_temp0';
  }

  @override
  String get prophetsQuizTabSubtitle =>
      'Test what you remember through quick review modes.';

  @override
  String get prophetsFamilyTreeTabSubtitle =>
      'See how prophetic families and lineages connect.';

  @override
  String get prophetsJourneyTabSubtitle =>
      'Follow revelation across eras, peoples, and shared calls to truth.';

  @override
  String get prophetsAnyEra => 'Any era';

  @override
  String get prophetsAnyRegion => 'Any region';

  @override
  String get prophetsEmptySearch => 'No prophets match these filters yet.';

  @override
  String get prophetsRemoveBookmark => 'Remove bookmark';

  @override
  String get prophetsSaveBookmark => 'Save bookmark';

  @override
  String get prophetsDetailOverviewTitle => 'Overview';

  @override
  String get prophetsDetailStoryTitle => 'Story';

  @override
  String get prophetsDetailLessonsTitle => 'Lessons';

  @override
  String get prophetsDetailReferencesTitle => 'References';

  @override
  String get prophetsDetailReflectTitle => 'Reflect';

  @override
  String get prophetsDetailRelatedTitle => 'Related';

  @override
  String get prophetsViewInTimeline => 'View in timeline';

  @override
  String get prophetsViewOnMap => 'View on map';

  @override
  String get prophetsViewInFamilyTree => 'View in family tree';

  @override
  String prophetsTimelineMeta(String era, String region) {
    return '$era • $region';
  }

  @override
  String get prophetsMapLocationGuidanceTitle => 'Map guidance';

  @override
  String get prophetsMapLocationGuidanceSubtitle =>
      'Map locations are presented with respectful care and may be symbolic, approximate, or traditionally identified.';

  @override
  String get prophetsMapUnmappedTitle => 'Not shown on the map yet';

  @override
  String prophetsMapMarkerTooltip(String name, String location) {
    return '$name • $location';
  }

  @override
  String get prophetsFamilyTreeTitle => 'Family Tree';

  @override
  String get prophetsFamilyTreeSubtitle =>
      'Follow family lines, close relations, and linked prophetic households.';

  @override
  String get prophetsFamilyTreeAllLines => 'All lines';

  @override
  String get prophetsFamilyTreeFeaturedLines => 'Featured lines';

  @override
  String get prophetsFamilyTreeLinkedNote =>
      'Linked lines show notable family ties mentioned in trusted sources and study notes.';

  @override
  String get prophetsFamilyTreeScopeNote =>
      'This view is a learning map, not an exhaustive genealogical chart.';

  @override
  String get prophetsOpenFullProfile => 'Open full profile';

  @override
  String get prophetsEraEarlyHumanityTitle => 'Early Humanity';

  @override
  String get prophetsEraEarlyHumanitySubtitle =>
      'The beginning of humanity, repentance, and the first call to worship Allah alone.';

  @override
  String get prophetsEraEarlyCivilizationsTitle => 'Early Civilizations';

  @override
  String get prophetsEraEarlyCivilizationsSubtitle =>
      'Communities formed, guidance arrived, and truth was met with both faith and resistance.';

  @override
  String get prophetsEraPostFloodPeoplesTitle => 'Post-Flood Peoples';

  @override
  String get prophetsEraPostFloodPeoplesSubtitle =>
      'New nations rose after Nuh and were reminded to return to Allah with humility.';

  @override
  String get prophetsEraAgeOfIbrahimTitle => 'Age of Ibrahim';

  @override
  String get prophetsEraAgeOfIbrahimSubtitle =>
      'Tawhid, sacrifice, trust, and a blessed family line shaped this era.';

  @override
  String get prophetsEraChildrenOfIsraelTitle => 'Children of Israel';

  @override
  String get prophetsEraChildrenOfIsraelSubtitle =>
      'Deliverance, law, worship, and repeated reminders defined this stage of guidance.';

  @override
  String get prophetsEraLaterIsraeliteProphetsTitle =>
      'Later Israelite Prophets';

  @override
  String get prophetsEraLaterIsraeliteProphetsSubtitle =>
      'Kingship, wisdom, exile, and repeated calls back to obedience marked these generations.';

  @override
  String get prophetsEraFinalMessengerTitle => 'Final Messenger';

  @override
  String get prophetsEraFinalMessengerSubtitle =>
      'The final revelation completed the prophetic chain with mercy and clarity for all people.';

  @override
  String get prophetsLocationConfidenceSymbolic => 'Symbolic';

  @override
  String get prophetsLocationConfidenceApproximate => 'Approximate';

  @override
  String get prophetsLocationConfidenceTraditional => 'Traditional';

  @override
  String get prophetsLocationConfidenceStrong => 'Strong';

  @override
  String get prophetsLocationConfidenceSymbolicGuidance =>
      'This location is shown symbolically for learning context.';

  @override
  String get prophetsLocationConfidenceApproximateGuidance =>
      'This location is an approximate learning marker.';

  @override
  String get prophetsLocationConfidenceTraditionalGuidance =>
      'This location follows a traditional identification used in study references.';

  @override
  String get prophetsLocationConfidenceStrongGuidance =>
      'This location has stronger support in the learning references used here.';

  @override
  String get prophetsJourneyTitle => 'Journey of Revelation';

  @override
  String get prophetsJourneySubtitle =>
      'Walk the prophetic message across eras, regions, and recurring calls to truth.';

  @override
  String prophetsJourneyProgressSummary(
    String opened,
    String total,
    String completed,
    String eras,
  ) {
    return 'Progress: $opened/$total prophets explored • $completed/$eras eras completed';
  }

  @override
  String prophetsJourneyContinueFrom(String details) {
    return 'Continue from: $details';
  }

  @override
  String get prophetsJourneyGenericEra => 'Era';

  @override
  String get prophetsJourneyStartAction => 'Start journey';

  @override
  String get prophetsJourneyContinueAction => 'Continue journey';

  @override
  String get prophetsJourneyExploreFreely => 'Explore freely';

  @override
  String get prophetsJourneyContinuityTitle => 'One Message Across Time';

  @override
  String get prophetsJourneyContinuitySubtitle =>
      'Across different eras and peoples, the prophetic call remains clear and connected.';

  @override
  String prophetsJourneyFeaturedLabel(String names) {
    return 'Featured: $names';
  }

  @override
  String get prophetsJourneyBeginEra => 'Begin era';

  @override
  String get prophetsJourneyContinueEra => 'Continue era';

  @override
  String get prophetsJourneyTimelineAction => 'Timeline';

  @override
  String get prophetsJourneyViewRegionOnMap => 'View region on map';

  @override
  String get prophetsJourneyQuizAction => 'Quiz';

  @override
  String get prophetsJourneyStatusCompleted => 'Completed';

  @override
  String get prophetsJourneyStatusCurrent => 'Current';

  @override
  String get prophetsJourneyStatusStarted => 'Started';

  @override
  String get prophetsJourneyStatusNotStarted => 'Not started';

  @override
  String get prophetsJourneyMainMessageTitle => 'Main Message of This Era';

  @override
  String get prophetsJourneyHumanPatternsTitle => 'Human Patterns in This Era';

  @override
  String get prophetsJourneyEraReflectionTitle => 'Era Reflection';

  @override
  String get prophetsJourneyPracticeThisEraTitle => 'Practice This Era';

  @override
  String get prophetsJourneyPracticeThisEraSubtitle =>
      'Bring today’s learning into gentle action through small consistent habits.';

  @override
  String prophetsRegionChip(String value) {
    return 'Region • $value';
  }

  @override
  String prophetsCivilizationChip(String value) {
    return 'Civilization • $value';
  }

  @override
  String prophetsPracticeChip(String value) {
    return 'Practice • $value';
  }

  @override
  String prophetsReferenceChip(String value) {
    return 'Reference • $value';
  }

  @override
  String prophetsLessonChip(String value) {
    return 'Lesson • $value';
  }

  @override
  String prophetsCoreCallChip(String value) {
    return 'Core call • $value';
  }

  @override
  String get prophetsOpenDetailAction => 'Open detail';

  @override
  String get prophetsOpenFamilyTree => 'Open family tree';

  @override
  String get prophetsRelatedProphetsTitle => 'Related Prophets';

  @override
  String get prophetsRelatedLifeLessonsTitle => 'Related Life Lessons';

  @override
  String get prophetsRelatedGrowthHabitsTitle => 'Related Growth Habits';

  @override
  String get prophetsRelatedQuranTopicsTitle => 'Related Qur’an Topics';

  @override
  String prophetsLifeChip(String value) {
    return 'Life • $value';
  }

  @override
  String prophetsGrowthChip(String value) {
    return 'Growth • $value';
  }

  @override
  String prophetsQuranChip(String value) {
    return 'Qur’an • $value';
  }

  @override
  String get prophetsPreviousProphetFallback => 'Previous prophet';

  @override
  String get prophetsNextProphetFallback => 'Next prophet';

  @override
  String get prophetsHabitDailyIstighfar => 'Daily istighfar';

  @override
  String get prophetsHabitDailyDua => 'Daily dua';

  @override
  String get prophetsHabitStudyKnowledge => 'Study knowledge';

  @override
  String get prophetsHabitPracticePatience => 'Practice patience';

  @override
  String get prophetsHabitReadQuran => 'Read Qur’an';

  @override
  String get prophetsHabitPracticeHumility => 'Practice humility';

  @override
  String get prophetsHabitPracticeGratitude => 'Practice gratitude';

  @override
  String get prophetsHabitNightReflection => 'Night reflection';

  @override
  String get prophetsHabitReconnectFamily => 'Reconnect with family';

  @override
  String get prophetsHabitHelpSomeone => 'Help someone';

  @override
  String get prophetsHabitSendSalawat => 'Send salawat';

  @override
  String get triviaQuestionTypeMultipleChoice => 'څو-اختیاري';

  @override
  String get triviaQuestionTypeTrueFalse => 'سم يا غلط';

  @override
  String get triviaCategoryQuranTitle => 'قرآن';

  @override
  String get triviaCategoryQuranSubtitle =>
      'آيتونه، سورتونه، موضوعات، او پوهه.';

  @override
  String get triviaCategoryProphetsTitle => 'انبيا';

  @override
  String get triviaCategoryProphetsSubtitle =>
      'کيسې، درسونه، او د انبياوو مهال‌وېشونه.';

  @override
  String get triviaCategoryHadithTitle => 'حديث';

  @override
  String get triviaCategoryHadithSubtitle => 'بنسټيز روايات او د هغوی معناوې.';

  @override
  String get triviaCategoryHistoryTitle => 'تاريخ';

  @override
  String get triviaCategoryHistorySubtitle =>
      'اشخاص، ځایونه، او د اسلامي تاريخ مهمې شېبې.';

  @override
  String get triviaCategoryGeneralTitle => 'عمومي پوهه';

  @override
  String get triviaCategoryGeneralSubtitle =>
      'د اسلامي بنسټيزو موضوعاتو پراخه بياکتنه.';

  @override
  String get triviaCategoryRamadanTitle => 'رمضان';

  @override
  String get triviaCategoryRamadanSubtitle =>
      'روژه، فضيلتونه، شپې، او د رمضان عملونه.';

  @override
  String get triviaCategorySalahTitle => 'لمونځ';

  @override
  String get triviaCategorySalahSubtitle =>
      'د لمانځه وختونه، رکعتونه، شرطونه، او ادب.';

  @override
  String get triviaCategoryDuaTitle => 'دعا';

  @override
  String get triviaCategoryDuaSubtitle => 'مناجات، ذکر، او ورځنۍ دعاوې.';

  @override
  String get triviaCategorySeerahTitle => 'سيرت';

  @override
  String get triviaCategorySeerahSubtitle => 'د رسول ﷺ ژوند او رسالت.';

  @override
  String get triviaCategoryWomenInIslamTitle => 'په اسلام کې ښځې';

  @override
  String get triviaCategoryWomenInIslamSubtitle => 'مهمې ښځې، بېلګې، او ونډې.';

  @override
  String get triviaCategoryAkhlaqTitle => 'اخلاق';

  @override
  String get triviaCategoryAkhlaqSubtitle => 'ادب، اخلاص، صبر، رحمت، او چلند.';

  @override
  String get triviaKnowledgePathsPageTitle => 'د پوهې لارې';

  @override
  String get triviaKnowledgePathsPageSubtitle =>
      'جوړښتي کويز لارې چې پوهه ګام په ګام جوړوي.';

  @override
  String get triviaKnowledgePathsEmptyTitle => 'لا د پوهې لارې نشته';

  @override
  String get triviaKnowledgePathsEmptySubtitle =>
      'لارې به دلته راڅرګندې شي کله چې جوړښتي درسي ماډيولونه چمتو شي.';

  @override
  String triviaKnowledgePathsProgressLabel(String completed, String total) {
    return '$completed/$total پړاوونه بشپړ شوي';
  }

  @override
  String get triviaKnowledgePathFoundationsTitle => 'د اسلام بنسټونه';

  @override
  String get triviaKnowledgePathFoundationsDescription =>
      'د بنسټيزو عقيدو، وحي، لمانځه، او دعا له لارې يو د پيل لپاره دوستانه سفر.';

  @override
  String get triviaKnowledgePathProphetsTitle => 'د انبياوو سفر';

  @override
  String get triviaKnowledgePathProphetsDescription =>
      'د انبياوو، د هغوی کيسو، او درسونو له لارې يو جوړښتي سفر.';

  @override
  String get triviaKnowledgePathQuranTitle => 'د قرآن پوهه';

  @override
  String get triviaKnowledgePathQuranDescription =>
      'له وحي، جوړښت، مشهورو سورتونو، او له قرآن سره د ژوند کولو سره اشنايي پيدا کړئ.';

  @override
  String get triviaKnowledgePathSalahTitle => 'د لمانځه زده کړه';

  @override
  String get triviaKnowledgePathSalahDescription =>
      'د لمانځه، شرطونو، رکعتونو، او خشوع په اړه خپله پوهه پياوړې کړئ.';

  @override
  String get triviaKnowledgeStageFoundationsWhatIsIslam => 'اسلام څه دی؟';

  @override
  String get triviaKnowledgeStageFoundationsRevelation => 'وحي او لارښوونه';

  @override
  String get triviaKnowledgeStageFoundationsProphets => 'انبيا';

  @override
  String get triviaKnowledgeStageFoundationsPrayer => 'لمونځ او عبادت';

  @override
  String get triviaKnowledgeStageFoundationsFastingDua => 'روژه او دعا';

  @override
  String get triviaKnowledgeStageProphetsFirst => 'لومړي انبيا';

  @override
  String get triviaKnowledgeStageProphetsNuhHudSalih => 'نوح، هود، او صالح';

  @override
  String get triviaKnowledgeStageProphetsIbrahimFamily =>
      'ابراهيم او د هغه کورنۍ';

  @override
  String get triviaKnowledgeStageProphetsMusaHarun => 'موسی او هارون';

  @override
  String get triviaKnowledgeStageProphetsKingsWisdomTrial =>
      'پاچاهان، حکمت، او ازموينه';

  @override
  String get triviaKnowledgeStageProphetsIsaFinalMessenger =>
      'عیسی او وروستی رسول';

  @override
  String get triviaKnowledgeStageQuranWhatIs => 'قرآن څه دی؟';

  @override
  String get triviaKnowledgeStageQuranRevelationBegins => 'د وحي پيل';

  @override
  String get triviaKnowledgeStageQuranStructureTerms => 'جوړښت او اصطلاحات';

  @override
  String get triviaKnowledgeStageQuranFamousSurahs => 'مشهوره سورتونه';

  @override
  String get triviaKnowledgeStageQuranLivingWithIt => 'له قرآن سره ژوند کول';

  @override
  String get triviaKnowledgeStageSalahFiveDailyPrayers => 'پنځه وخته لمونځونه';

  @override
  String get triviaKnowledgeStageSalahConditions => 'د لمانځه شرطونه';

  @override
  String get triviaKnowledgeStageSalahInsideRakah => 'د يو رکعت دننه';

  @override
  String get triviaKnowledgeStageSalahCongregationJumuah => 'جماعت او جمعه';

  @override
  String get triviaKnowledgeStageSalahSunnahKhushu => 'سنت او خشوع';

  @override
  String get triviaSessionPageTitle => 'د ټرېويا ناسته';

  @override
  String get triviaSessionNoActiveTitle => 'کومه فعاله کويز ناسته نشته';

  @override
  String get triviaSessionNoActiveSubtitle =>
      'کويز له مرکز څخه پيل کړئ يا خپله مخکنۍ ناسته له هماغه ځايه بېرته جاري کړئ.';

  @override
  String get triviaSessionCorrectAnswer => 'سم ځواب';

  @override
  String get triviaSessionReviewThisPoint => 'دا ټکی بيا وګورئ';

  @override
  String get triviaSessionSeeResults => 'پايلې وګورئ';

  @override
  String get triviaSessionFinish => 'پای';

  @override
  String get triviaSessionNext => 'بل';

  @override
  String get triviaSessionLeaveTitle => 'له دې ناستې ووځئ؟';

  @override
  String get triviaSessionLeaveSubtitle =>
      'تاسې کولی شئ دا ناسته وساتئ او وروسته يې جاري کړئ، يا اوس يې لغوه کړئ.';

  @override
  String get triviaSessionResumeLater => 'وروسته يې جاري کړئ';

  @override
  String get triviaSessionDiscard => 'لغوه کول';

  @override
  String get triviaStatsTitle => 'د ټرېويا احصايې';

  @override
  String get triviaStatsSubtitle =>
      'خپل د زده‌کړې بهير، د بياکتنې پياوړتيا، او د کټګورۍ کارکردګي تعقيب کړئ.';

  @override
  String get triviaStatsQuestionsAnswered => 'ځواب شوې پوښتنې';

  @override
  String get triviaStatsQuizzesCompleted => 'بشپړ شوي کويزونه';

  @override
  String get triviaStatsCorrect => 'سم';

  @override
  String get triviaStatsIncorrect => 'غلط';

  @override
  String get triviaStatsOverallAccuracy => 'ټوليز دقت';

  @override
  String get triviaStatsDailyQuizStreak => 'د ورځني کويز لړۍ';

  @override
  String triviaStatsLongestStreak(String value) {
    return 'تر ټولو اوږده لړۍ: $value';
  }

  @override
  String get triviaStatsXp => 'ټرېويا XP';

  @override
  String get triviaStatsOceanDrops => 'د سمندر څاڅکي';

  @override
  String get triviaStatsPerformanceSnapshotTitle => 'د کارکردګۍ لنډه کتنه';

  @override
  String get triviaStatsNotEnoughData => 'لا کافي معلومات نشته';

  @override
  String triviaStatsPerformanceSnapshotBody(
    String strongest,
    String weakest,
    String dueCount,
    String masteredCount,
    Object correct,
    Object incorrect,
  ) {
    return 'تر ټولو قوي: $strongest • تر ټولو کمزوری: $weakest • اوس پاتې: $dueCount • پياوړي شوي: $masteredCount';
  }

  @override
  String get triviaStatsCategoryBreakdownTitle => 'د کټګورۍ وېش';

  @override
  String get triviaStatsCategoryBreakdownSubtitle =>
      'وګورئ چې هره درسي برخه څنګه روانه ده.';

  @override
  String triviaStatsCategoryBreakdownRow(
    String answered,
    String accuracy,
    String quizzes,
    Object category,
    Object correct,
    Object total,
  ) {
    return '$answered ځواب شوي • $accuracy% دقت • $quizzes کويزونه';
  }

  @override
  String get batch9SortBy => 'Sort by';

  @override
  String get batch9SortAlphabetical => 'Alphabetical';

  @override
  String get batch9Unavailable => 'Unavailable';

  @override
  String get batch9TryAgainMessage => 'Try again in a moment.';

  @override
  String get batch9ContinueAction => 'Continue';

  @override
  String batch9QuestionProgress(String current, String total) {
    return 'Question $current of $total';
  }

  @override
  String get batch9AnswerCorrect => 'Correct';

  @override
  String get batch9AnswerNotQuite => 'Not quite';

  @override
  String get batch9QuizResultsTitle => 'Quiz Results';

  @override
  String batch9QuizScoreSummary(String score, String total) {
    return 'Score: $score/$total';
  }

  @override
  String batch9QuizAccuracySummary(String percent) {
    return 'Accuracy: $percent%';
  }

  @override
  String batch9BestScoreSummary(String value) {
    return 'Best score: $value';
  }

  @override
  String batch9LastScoreSummary(String value) {
    return 'Last score: $value';
  }

  @override
  String batch9TotalQuizzesTakenSummary(String value) {
    return 'Total quizzes taken: $value';
  }

  @override
  String get batch9RetryQuizAction => 'Retry quiz';

  @override
  String get batch9LearningNotesTitle => 'Learning Notes';

  @override
  String get batch9DifficultyTitle => 'Difficulty';

  @override
  String get batch9ModeTitle => 'Mode';

  @override
  String get batch9ProphetFocusTitle => 'Prophet Focus';

  @override
  String get batch9EraFocusTitle => 'Era Focus';

  @override
  String get batch9AllProphets => 'All Prophets';

  @override
  String get batch9AllEras => 'All Eras';

  @override
  String batch9QuestionPoolSummary(String count) {
    return 'Question pool: $count';
  }

  @override
  String batch9LastFocusSummary(String prophet, String era) {
    return 'Last focus: $prophet • $era';
  }

  @override
  String get batch9ReviewProphetsAction => 'انبيا بيا وګورئ';

  @override
  String get batch9ProphetQuizTitle => 'Prophet Quiz';

  @override
  String get batch9ProphetQuizSubtitle =>
      'Test knowledge of prophetic stories, timelines, lessons, and Qur’anic references.';

  @override
  String get batch9HadithChapterQuizTitle => 'Chapter Quiz';

  @override
  String get batch9HadithReviewQuizTitle => 'Hadith Review Quiz';

  @override
  String get batch9HadithQuizUnavailable =>
      'No quiz is available for this selection yet. Complete more lessons and try again.';

  @override
  String get batch9SubmitAnswerAction => 'Submit answer';

  @override
  String get batch9FinishQuizAction => 'Finish quiz';

  @override
  String get batch9NextQuestionAction => 'Next question';

  @override
  String batch9HadithQuizResultHeadline(
    String score,
    String total,
    String percent,
  ) {
    return '$score / $total correct • $percent%';
  }

  @override
  String batch9XpReward(String value) {
    return 'XP Reward: +$value';
  }

  @override
  String get batch9ChapterCompleted => 'Chapter completed';

  @override
  String get batch9PathCompletionMilestone => 'Path completion milestone';

  @override
  String get batch9QuranReflectionVerseTitle => 'د قرآني تامل آيت';

  @override
  String get batch9ReviewRelatedLessonAction => 'اړوند درس بيا وګورئ';

  @override
  String get batch9PracticeAsAudioTooltip => 'د غږ په توګه تمرين';

  @override
  String get batch9CompleteLessonAction => 'درس بشپړ کړئ';

  @override
  String get batch9TryQuickQuizAction => 'يو چټک کويز وازمايئ';

  @override
  String get batch9CheckAnswerAction => 'ځواب وګورئ';

  @override
  String get batch9FinishLessonAction => 'درس پای ته ورسوئ';

  @override
  String batch9AudioNotAddedYet(String label) {
    return 'د $label لپاره غږ لا نه دی زيات شوی.';
  }

  @override
  String batch9AudioReady(String label) {
    return 'د $label لپاره غږ چمتو دی.';
  }

  @override
  String get batch9DailyReviewTitle => 'ورځنۍ بياکتنه';

  @override
  String get batch9DailyReviewFallbackSummary =>
      'يوه لنډه ګډه بياکتنه چې تر اوسه له هغه څه جوړه شوې چې تاسو زده کړي دي.';

  @override
  String get batch9ReviewCorrectFeedback => 'ښه ده. دا توکی لا پياوړی کېږي.';

  @override
  String get batch9ReviewRetryFeedback =>
      'ستونزه نشته. دا توکی به ژر بېرته راشي.';

  @override
  String get batch9ListenOnlyTitle => 'يوازې اورېدل';

  @override
  String get batch9AudioPracticeTitle => 'غږيز تمرين';

  @override
  String get quranTeachingDailyReviewEmptyStart =>
      'Start a few lessons and your daily review will appear here.';

  @override
  String get quranTeachingDailyReviewEmptyNoDue =>
      'No review is due right now. Try a new lesson or open extra practice later.';

  @override
  String get quranTeachingDailyReviewItemUnavailable =>
      'This review item is no longer available.';

  @override
  String get quranTeachingDailyReviewRememberedAction => 'I remembered it';

  @override
  String get quranTeachingDailyReviewNeedAnotherPassAction =>
      'Need another pass';

  @override
  String get quranTeachingDailyReviewNextItemAction => 'Next review item';

  @override
  String get quranTeachingDailyReviewMoreLaterAction => 'Review more later';

  @override
  String get quranTeachingDailyReviewRevealAction => 'Reveal';

  @override
  String get quranTeachingDailyReviewReplayAudioAction => 'Replay audio';

  @override
  String get quranTeachingDailyReviewCorrectFeedback =>
      'Correct. This item is settling in.';

  @override
  String get quranTeachingDailyReviewRetryFeedback =>
      'Not quite. This one will return sooner.';

  @override
  String get quranTeachingDailyReviewTrue => 'True';

  @override
  String get quranTeachingDailyReviewFalse => 'False';

  @override
  String get quranTeachingListenOnlySubtitle =>
      'Low-distraction listening for walks, chores, bedtime review, and calm repetition.';

  @override
  String get quranTeachingListenOnlyContentSetLabel => 'Content set';

  @override
  String get quranTeachingListenOnlyCheckingLocalAudio =>
      'Checking local audio...';

  @override
  String quranTeachingListenOnlyAudioAvailability(
    String available,
    String total,
  ) {
    return '$available of $total items currently have local audio.';
  }

  @override
  String get quranTeachingListenOnlyChoosePack => 'Choose a pack';

  @override
  String get quranTeachingListenOnlySelectPackToBegin =>
      'Select a listening set to begin.';

  @override
  String quranTeachingListenOnlyProgress(String current, String total) {
    return '$current of $total';
  }

  @override
  String quranTeachingListenOnlyEstimatedPackLength(String seconds) {
    return 'Estimated pack length: ${seconds}s';
  }

  @override
  String get quranTeachingListenOnlyDefaultAudioLabel => 'Audio';

  @override
  String get quranTeachingListenOnlyDefaultContextLabel => 'Listen Only';

  @override
  String get quranTeachingListenOnlyAudioUnavailable =>
      'Audio for this item is not added yet.';

  @override
  String get quranTeachingListenOnlyReplayAction => 'Replay';

  @override
  String get quranTeachingListenOnlyReplayCurrentItem => 'Replay current item';

  @override
  String get quranTeachingListenOnlySpeedLabel => 'Speed';

  @override
  String get quranTeachingListenOnlyModeOptionsTitle => 'Mode options';

  @override
  String get quranTeachingListenOnlyAutoPlayNextItem => 'Auto-play next item';

  @override
  String get quranTeachingListenOnlyRepeatCurrentItem => 'Repeat current item';

  @override
  String get quranTeachingListenOnlyShuffleOrder => 'Shuffle order';

  @override
  String get quranTeachingListenOnlyVisualMode => 'Visual mode';

  @override
  String get quranTeachingListenOnlyArabic => 'Arabic';

  @override
  String get quranTeachingListenOnlyArabicTransliteration =>
      'Arabic + Transliteration';

  @override
  String get quranTeachingListenOnlyAudioOnly => 'Audio only';

  @override
  String get quranTeachingListenOnlyListeningFocus => 'Listening focus';

  @override
  String batch9AudioCue(String context, String label) {
    return '$context • $label';
  }

  @override
  String get batch9QuranWordsSubtitle =>
      'له پورته شوې بنسټيزې لغت-لېست څخه د قرآن ډېر تکرارېدونکي لغتونه زده کړئ.';

  @override
  String get batch9QuranWordsStudyBands => 'د مطالعې کچې';

  @override
  String get batch9QuranWordsTop25 => 'غوره 25';

  @override
  String get batch9QuranWordsTop50 => 'غوره 50';

  @override
  String get batch9QuranWordsTop100 => 'غوره 100';

  @override
  String get batch9QuranWordsAllLoaded => 'ټول پورته شوي';

  @override
  String get batch9QuranWordsSortMostFrequent => 'تر ټولو ډېر تکرار';

  @override
  String get batch9QuranWordsSortRank => 'د لېست درجه';

  @override
  String get batch9QuranWordsSearchHint => 'ليکلدود يا معنا ولټوئ';

  @override
  String batch9QuranWordsMasteredSummary(
    String mastered,
    String total,
    Object count,
  ) {
    return '$mastered / $total mastered';
  }

  @override
  String batch9QuranWordsFlashCard(String transliteration, String meaning) {
    return 'فلېش کارت: $transliteration • $meaning';
  }

  @override
  String get batch9QuranWordsEmpty =>
      'لا تر اوسه هېڅ لغت له دې فلټر سره برابر نه دی.';

  @override
  String batch9QuranWordsOccurrenceSummary(String meaning, String count) {
    return '$meaning • په قرآن کې $count ځله';
  }

  @override
  String batch9QuranWordsLoadError(String error) {
    return 'د قرآن لغتونه نه شو پورته کولی: $error';
  }

  @override
  String get batch9NamesOfAllahTitle => '99 Names of Allah';

  @override
  String get batch9NamesOfAllahSubtitle =>
      'Arabic, transliteration, and concise meanings for reflection.';

  @override
  String get batch9NamesOfAllahSearchHint =>
      'Search by Arabic, transliteration, or meaning';

  @override
  String batch9NamesOfAllahCount(String visible, String total) {
    return '$visible / $total names';
  }

  @override
  String get batch9FaqTitle => 'Islam FAQ';

  @override
  String get batch9FaqSubtitle =>
      'Clear, gentle answers to common questions about Islam, with calm clarification where misconceptions exist.';

  @override
  String get batch9FaqScholarNote =>
      'For deeper study, always ask qualified scholars.';

  @override
  String get batch9FaqFeaturedTitle => 'Featured Questions';

  @override
  String get batch9FaqFeaturedSubtitle =>
      'Start with common foundational questions.';

  @override
  String get batch9FaqBrowseTitle => 'Browse by Category';

  @override
  String get batch9FaqBrowseSubtitle => 'Explore questions by theme and level.';

  @override
  String get batch9FaqSearchHint =>
      'Search common questions, answers, topics...';

  @override
  String batch9FaqOverviewSummary(String questions, String categories) {
    return '$questions questions across $categories categories.';
  }

  @override
  String get batch9FaqFeaturedEmpty =>
      'No featured questions available right now.';

  @override
  String get accessibilityReminderHelp => 'Reminder help';

  @override
  String get accessibilityIncreaseDhikrCount => 'Increase dhikr count';

  @override
  String get accessibilityJumpToCurrentSalah => 'Jump to current salah';

  @override
  String get accessibilityReadQadaRule => 'Read qada rule';

  @override
  String get accessibilityRefreshCamera => 'Refresh camera';

  @override
  String get accessibilityCreationCategoryNotDetected =>
      'No stable creation category detected yet';

  @override
  String accessibilityCreationCategoryDetected(String category) {
    return '$category detected. Open reflection card.';
  }

  @override
  String get accessibilityRemoveFavorite => 'Remove favorite';

  @override
  String get accessibilitySaveFavorite => 'Save favorite';

  @override
  String get accessibilityDeleteObservation => 'Delete observation';

  @override
  String get accessibilityRemoveFromSaved => 'Remove from saved';

  @override
  String get accessibilitySaveHadith => 'Save hadith';

  @override
  String get accessibilityPlayAudio => 'Play audio';

  @override
  String get accessibilityAudioNotAddedYet => 'Audio not added yet';

  @override
  String get accessibilitySavedForReview => 'Saved for review';

  @override
  String get accessibilityReviewLater => 'Review later';

  @override
  String get accessibilityLearningSettings => 'Learning settings';

  @override
  String get accessibilitySourcesAndLicensing => 'Sources and licensing';

  @override
  String get accessibilityClosePlayer => 'Close player';

  @override
  String get accessibilityBack15Seconds => 'Back 15 seconds';

  @override
  String get accessibilityForward15Seconds => 'Forward 15 seconds';

  @override
  String get accessibilityPreparingPlayback => 'Preparing playback';

  @override
  String get accessibilityPause => 'Pause';

  @override
  String get accessibilityPlay => 'Play';

  @override
  String get accessibilityRemoveFromFavorites => 'Remove from favorites';

  @override
  String get accessibilitySaveNameToFavorites => 'Save name to favorites';

  @override
  String get creationExplorerTitle => 'Creation Explorer';

  @override
  String get creationExplorerSubtitle =>
      'Observe the world, notice a sign, and connect it with Qur’anic reflection.';

  @override
  String get creationExplorerMetricObservations => 'Observations';

  @override
  String get creationExplorerMetricCategories => 'Categories';

  @override
  String get creationExplorerMetricVerses => 'Verses';

  @override
  String get creationExplorerMetricCamera => 'Camera';

  @override
  String get creationExplorerMetricCameraDeviceOnly => 'Device only';

  @override
  String get creationExplorerMetricCameraOff => 'Off';

  @override
  String get creationExplorerMetricCameraReady => 'Ready';

  @override
  String get creationExplorerMetricCameraPending => 'Pending';

  @override
  String get creationExplorerTodaysChallenge => 'Today’s challenge';

  @override
  String get creationExplorerHistoryAction => 'History';

  @override
  String get creationExplorerOpenAction => 'Open';

  @override
  String get creationExplorerDeviceOnlyTitle =>
      'Image labeling runs on device only';

  @override
  String get creationExplorerDeviceOnlyBody =>
      'Use a physical iPhone or iPad to explore with the camera.';

  @override
  String get creationExplorerCameraAccessTitle => 'Camera access is needed';

  @override
  String get creationExplorerCameraAccessBody =>
      'Creation Explorer runs entirely on-device. Camera access lets the app detect broad categories like birds, plants, water, and sky without uploading images.';

  @override
  String get creationExplorerAllowCameraAction => 'Allow camera';

  @override
  String get creationExplorerOpenSettingsAction => 'Open settings';

  @override
  String get creationExplorerCameraUnavailable => 'Camera unavailable';

  @override
  String get creationExplorerCameraUnavailableBody =>
      'Creation Explorer could not start the camera right now.';

  @override
  String get creationExplorerRetryAction => 'Retry';

  @override
  String get creationExplorerOnDeviceDetection => 'On-device detection';

  @override
  String get creationExplorerDetectionPromptTitle =>
      'Look at a plant, animal, bird, or landscape.';

  @override
  String get creationExplorerDetectionPromptSubtitle =>
      'Labels appear only when the signal is stable.';

  @override
  String get creationExplorerTapToReflect => 'Tap to reflect';

  @override
  String get creationExplorerHowItWorksTitle => 'How it works';

  @override
  String get creationExplorerHowItWorksBody =>
      'Creation Explorer uses on-device labeling to detect broad categories only. It waits for a stable signal before showing a label, then offers a Qur’anic reflection connected to what you are seeing.';

  @override
  String get creationExplorerCurrentDetectedSign => 'Current detected sign';

  @override
  String get creationExplorerReflectAction => 'Reflect';

  @override
  String get creationExplorerAlsoExploreSkyTitle => 'Also explore the sky';

  @override
  String get creationExplorerAlsoExploreSkySubtitle =>
      'Creation Explorer and Sky Explorer are complementary: one notices what is around you, the other what is above you.';

  @override
  String get creationExplorerSkyExplorerAction => 'Sky Explorer';

  @override
  String get creationExplorerNoObservationsTitle => 'No observations saved yet';

  @override
  String get creationExplorerNoObservationsBody =>
      'Save a moment from the camera view and it will appear here with its verse, category, and your reflection.';

  @override
  String get creationExplorerOpenCameraExploreAction => 'Open camera explore';

  @override
  String get creationExplorerYourReflectionLabel => 'Your reflection';

  @override
  String get creationExplorerYourReflectionHint =>
      'What did you notice? What did it remind you of?';

  @override
  String get creationExplorerCloseAction => 'Close';

  @override
  String get creationExplorerSaveObservationAction => 'Save observation';

  @override
  String get creationExplorerNoReflectionSaved => 'No reflection saved yet.';

  @override
  String get creationExplorerEditReflectionAction => 'Edit reflection';

  @override
  String get creationExplorerEditReflectionHint =>
      'Write what this observation reminded you of.';

  @override
  String get creationExplorerTabCamera => 'Camera';

  @override
  String get creationExplorerTabDiscover => 'Discover';

  @override
  String get creationExplorerTabJournal => 'Journal';

  @override
  String get fastingSectionTitle => 'روژه';

  @override
  String get fastingSectionSubtitle =>
      'ستاسې د نيت او بهير لپاره ساده لاسي تعقيب.';

  @override
  String get fastingTodayTitle => 'نن';

  @override
  String fastingStatusValue(String value, Object status) {
    return 'حالت: $value';
  }

  @override
  String fastingTypeValue(String value, Object type) {
    return 'ډول: $value';
  }

  @override
  String get fastingFastTypeTitle => 'د روژې ډول';

  @override
  String get fastingFastTypeSubtitle => 'هغه څه وټاکئ چې د نن نيت ښه څرګندوي.';

  @override
  String get fastingTodayStatusTitle => 'د نن حالت';

  @override
  String get fastingTodayStatusSubtitle =>
      'خپله روژه په روښانتيا او اسانتيا سره وټاکئ.';

  @override
  String get fastingRecentHistoryTitle => 'د وروستۍ روژې تاريخچه';

  @override
  String get fastingRecentHistorySubtitle =>
      'د لومړني پلي کولو لپاره يوه لنډه بېلګه کتنه.';

  @override
  String fastingHistoryEntry(String type, String status, Object date) {
    return '$type • $status';
  }

  @override
  String get fastingGentleReminderTitle => 'نرمه يادونه';

  @override
  String get fastingGentleReminderBody =>
      'دا د سختې بشپړتيا پر ځای د ثابتو عادتونو لپاره وکاروئ. ورځ په رښتيا وټاکئ او ثبات ولمانځئ.';

  @override
  String get fastingStatusNotFasting => 'روژه نه ده';

  @override
  String get fastingStatusIntending => 'د روژې نيت لري';

  @override
  String get fastingStatusCompleted => 'بشپړه شوې';

  @override
  String get fastingStatusBroken => 'فوت / ماته شوې';

  @override
  String get fastingTypeRamadan => 'د رمضان روژه';

  @override
  String get fastingTypeSunnah => 'سنت روژه';

  @override
  String get fastingTypeQada => 'د قضا روژه';

  @override
  String get fastingTypeVoluntary => 'نفلي روژه';

  @override
  String get fastingTypeOther => 'نور / ځانګړی';

  @override
  String get prayerQadaRuleFajrSummary =>
      'فجر د لمر په ختو قضا کېږي. که درڅخه فوت شو، د لمر ختو د منع وخت څخه ډډه وکړئ او لږ وروسته يې قضا کړئ.';

  @override
  String get prayerQadaRuleDhuhrSummary =>
      'که فوت شي، د عصر په داخلېدو قضا کېږي. ژر تر ژره يې قضا کړئ چې مناسب وي.';

  @override
  String get prayerQadaRuleAsrSummary =>
      'که فوت شي، د مغرب په داخلېدو قضا کېږي. د لمر لوېدو د منع وخت پر مهال لمونځ مه کوئ.';

  @override
  String get prayerQadaRuleMaghribSummary =>
      'که فوت شي، د عشاء په داخلېدو قضا کېږي. ژر تر ژره يې قضا کړئ چې مناسب وي.';

  @override
  String get prayerQadaRuleIshaSummary =>
      'که فوت شي، دا اپ يې په فجر کې قضا بولي. ډېری علما د شپې ډېر ناوخته ځنډ هم د ملامتۍ وړ بولي، نو که وکولای شئ مخکې يې ادا کړئ.';

  @override
  String get prayerQadaRuleDefaultSummary =>
      'فوت شوي فرض لمونځونه ژر تر ژره قضا کړئ، خو د منع شويو وختونو څخه ډډه وکړئ.';

  @override
  String get prayerUnknownAdjustment => 'د لمانځه ناپېژندل شوی تعديل.';

  @override
  String prayerValidationMustRemainBefore(
    String current,
    String next,
    Object first,
    Object label,
    Object otherLabel,
    Object second,
  ) {
    return '$current بايد له $next مخکې پاتې شي.';
  }

  @override
  String get prayerValidationEnterAllFiveDailySalahTimes =>
      'د لاسي حالت د کارولو لپاره د پنځو واړو لمونځونو وختونه دننه کړئ.';

  @override
  String get prayerValidationFajrBeforeSunrise =>
      'فجر بايد د لمر له ختو مخکې پاتې شي.';

  @override
  String get prayerCadenceQueueClear => 'قطار پاک دی. پر وخت لمونځونه وساتئ.';

  @override
  String get prayerCadenceLight =>
      'سپک بهير: له فجر يا عشاء وروسته 1 اضافه قضا.';

  @override
  String get prayerCadenceSteady =>
      'ثابت بهير: هره ورځ 2 قضا (يوه له فجر وروسته، يوه له عشاء وروسته).';

  @override
  String get prayerCadenceFocused =>
      'متمرکز بهير: هره ورځ 3 قضا په کوچنيو برخو او ثبات سره.';

  @override
  String get adhanOptionMakkahDefaultTitle => 'Makkah Default';

  @override
  String get adhanOptionMakkahDefaultSubtitle =>
      'Clear, balanced, and suitable for the daily prayers.';

  @override
  String get adhanOptionMadinahSoftTitle => 'Madinah Soft';

  @override
  String get adhanOptionMadinahSoftSubtitle =>
      'A softer bundled option for a calmer reminder tone.';

  @override
  String get adhanOptionClearMasjidTitle => 'Clear Masjid';

  @override
  String get adhanOptionClearMasjidSubtitle =>
      'Focused and direct for prayer-time playback.';

  @override
  String get adhanOptionFajrDefaultTitle => 'Fajr Default';

  @override
  String get adhanOptionFajrDefaultSubtitle =>
      'Temporary bundled fallback for Fajr-specific routing.';

  @override
  String get adhanOptionFajrSoftTitle => 'Fajr Soft';

  @override
  String get adhanOptionFajrSoftSubtitle =>
      'Temporary bundled fallback with a gentler Fajr label.';

  @override
  String get accountsSyncThisDeviceGeneric => 'دا آله';

  @override
  String get accountsSyncThisDeviceIPhone => 'دا iPhone';

  @override
  String get accountsSyncThisDeviceIPad => 'دا iPad';

  @override
  String get accountsSyncThisDeviceAppleWatch => 'Apple Watch';

  @override
  String get accountsSyncThisDeviceAppleTv => 'دا Apple آله';

  @override
  String get accountsSyncThisDeviceAndroidPhone => 'دا Android تليفون';

  @override
  String get accountsSyncThisDeviceAndroidTablet => 'دا Android ټابليټ';

  @override
  String get accountsSyncThisDeviceAndroidWatch => 'Wear OS ساعت';

  @override
  String get accountsSyncThisDeviceAndroidTv => 'Android TV';

  @override
  String get accountsSyncThisDeviceApple => 'دا Apple آله';

  @override
  String get accountsSyncThisDeviceAndroid => 'دا Android آله';

  @override
  String get accountsSyncThisDeviceMac => 'دا Mac';

  @override
  String get accountsSyncThisDeviceWindows => 'دا Windows کمپيوټر';

  @override
  String get accountsSyncThisDeviceLinux => 'دا Linux آله';

  @override
  String get accountsSyncResultLocalOnlyModeActive => 'یوازې-ځايي حالت فعال دی';

  @override
  String get accountsSyncResultNoChanges => 'د همغږۍ لپاره هېڅ بدلون نشته';

  @override
  String get accountsSyncResultCompletedSuccessfully =>
      'همغږي په برياليتوب بشپړه شوه';

  @override
  String get accountsSyncEventLocalOnlyModeActive => 'یوازې-ځايي حالت فعال دی';

  @override
  String get accountsSyncEventNoChanges => 'د همغږۍ لپاره هېڅ بدلون نشته';

  @override
  String accountsSyncEventUploadedChanges(int count) {
    return '$count بدلونونه پورته ولېږدول شول';
  }

  @override
  String accountsSyncEventAppliedInboundChanges(int count) {
    return '$count راتلونکي بدلونونه وکارول شول';
  }

  @override
  String get accountsSyncErrorOffline => 'افلاین';

  @override
  String get accountsSyncErrorSyncUnavailable => 'همغږي نشته';

  @override
  String get accountsSyncErrorICloudUnsupportedPlatform =>
      'iCloud همغږي يوازې په Apple آلو کې شته';

  @override
  String get accountsSyncErrorICloudUnavailable =>
      'iCloud شته نه دی يا ننوتل پکې نه دي شوي';

  @override
  String get accountsSyncErrorICloudWriteFailed =>
      'iCloud ته ليکل ناکام شول. ننوتل او iCloud وړتیا وګورئ.';

  @override
  String get accountsSyncErrorTransportFailure => 'د لېږد ناکامي';

  @override
  String get kidsDuaLandingTitle => 'Kids Dua Learning';

  @override
  String get kidsDuaLandingSubtitle =>
      'Learn small duas with calm steps, kind repetition, and gentle rewards.';

  @override
  String get kidsDuaContinueTitle => 'Continue learning';

  @override
  String get kidsDuaTodayTitle => 'Today’s dua';

  @override
  String get kidsDuaCategoriesTitle => 'Dua categories';

  @override
  String get kidsDuaCategoriesSubtitle =>
      'Pick a small moment and learn one dua at a time.';

  @override
  String get kidsDuaContinueAction => 'Continue lesson';

  @override
  String get kidsDuaLearnSmallDuaAction => 'Let’s learn a small dua';

  @override
  String get kidsDuaStatusNotStarted => 'Not started';

  @override
  String get kidsDuaStatusInProgress => 'In progress';

  @override
  String get kidsDuaStatusLearned => 'Learned';

  @override
  String get kidsDuaPracticeTitle => 'Quick practice';

  @override
  String get kidsDuaPracticeModeMatchSituation => 'Match the dua to the moment';

  @override
  String get kidsDuaPracticeModeMeaning => 'Meaning match';

  @override
  String get kidsDuaPracticeModeBehavior => 'What should you do?';

  @override
  String get kidsDuaPracticeCheckAction => 'Check answer';

  @override
  String get kidsDuaPracticeNextAction => 'Next one';

  @override
  String get kidsDuaPracticeRetryAction => 'Try again';

  @override
  String get kidsDuaPracticeAgainAction => 'Practice again';

  @override
  String get kidsDuaPracticeNiceWork => 'Nice work';

  @override
  String get kidsDuaPracticeMashaAllah => 'MashaAllah!';

  @override
  String get kidsDuaPracticeTryAgain => 'Let’s try again together';

  @override
  String get kidsDuaPracticeEmpty =>
      'Learn a few duas first, then come back to practice.';

  @override
  String get kidsDuaPracticeSummaryTitle => 'Practice complete';

  @override
  String kidsDuaPracticeSummaryBody(int correct, int total) {
    return 'You got $correct out of $total right today.';
  }

  @override
  String get kidsDuaRewardsTitle => 'My rewards';

  @override
  String get kidsDuaRewardsEncouragement =>
      'Each small dua grows into a beautiful habit.';

  @override
  String get kidsDuaMeaningSection => 'Meaning';

  @override
  String get kidsDuaWhenSection => 'When to say it';

  @override
  String get kidsDuaMiniLessonSection => 'Small lesson';

  @override
  String get kidsDuaRepeatAfterMeSection => 'Repeat after me';

  @override
  String get kidsDuaMiniChallengeSection => 'Mini challenge';

  @override
  String get kidsDuaSourceSection => 'Source';

  @override
  String get kidsDuaPlayAudioAction => 'Play audio';

  @override
  String get kidsDuaAudioComingSoon => 'Audio will come here';

  @override
  String get kidsDuaCompleteLessonAction => 'I learned this dua';

  @override
  String get kidsDuaCompleteAgainAction => 'Practice again';

  @override
  String get kidsDuaCompletionTitle => 'Beautiful work';

  @override
  String kidsDuaCompletionBody(String duaTitle) {
    return 'You finished $duaTitle.';
  }

  @override
  String kidsDuaCompletionXpValue(int xp) {
    return '+$xp XP';
  }

  @override
  String kidsDuaCompletionDropsValue(int drops) {
    return '+$drops Ocean Drop';
  }

  @override
  String kidsDuaCompletionRewardsValue(int count) {
    return '+$count reward';
  }

  @override
  String kidsDuaLearnedCountValue(int count) {
    return '$count learned';
  }

  @override
  String kidsDuaPracticeCountValue(int count) {
    return '$count practices';
  }

  @override
  String kidsDuaRewardsCountValue(int count) {
    return '$count rewards';
  }

  @override
  String kidsDuaDropsCountValue(int count) {
    return '$count drops';
  }

  @override
  String kidsDuaCategoryProgressValue(int completed, int total) {
    return '$completed of $total learned';
  }

  @override
  String get kidsDuaCategoryTableFoodTitle => 'Meals & thanks';

  @override
  String get kidsDuaCategoryTableFoodSubtitle =>
      'Small duas before and after eating.';

  @override
  String get kidsDuaCategorySleepRestTitle => 'Sleep & waking';

  @override
  String get kidsDuaCategorySleepRestSubtitle =>
      'Gentle duas for rest and a new morning.';

  @override
  String get kidsDuaCategoryCleanCalmTitle => 'Clean & calm';

  @override
  String get kidsDuaCategoryCleanCalmSubtitle =>
      'Simple duas for private moments and cleanliness.';

  @override
  String get kidsDuaCategoryHomeGoingOutTitle => 'Home & going out';

  @override
  String get kidsDuaCategoryHomeGoingOutSubtitle =>
      'Duas for leaving home and coming back with peace.';

  @override
  String get kidsDuaCategoryLearningFamilyTitle => 'Learning & family';

  @override
  String get kidsDuaCategoryLearningFamilySubtitle =>
      'Ask Allah for knowledge and mercy for parents.';

  @override
  String get kidsDuaBeforeEatingTitle => 'Before eating';

  @override
  String get kidsDuaBeforeEatingMeaning => 'In the name of Allah.';

  @override
  String get kidsDuaBeforeEatingWhen => 'Say it before your first bite.';

  @override
  String get kidsDuaBeforeEatingLesson =>
      'We begin with Allah’s name before we eat.';

  @override
  String get kidsDuaBeforeEatingSituation =>
      'You are about to start your meal.';

  @override
  String get kidsDuaAfterEatingTitle => 'After eating';

  @override
  String get kidsDuaAfterEatingMeaning =>
      'All praise is for Allah who fed me and gave it to me without my own power.';

  @override
  String get kidsDuaAfterEatingWhen => 'Say it after you finish eating.';

  @override
  String get kidsDuaAfterEatingLesson =>
      'After a meal, we thank Allah for every bite.';

  @override
  String get kidsDuaAfterEatingSituation =>
      'You finished your food and want to say thank you.';

  @override
  String get kidsDuaBeforeSleepTitle => 'Before sleep';

  @override
  String get kidsDuaBeforeSleepMeaning =>
      'In Your name, O Allah, I die and I live.';

  @override
  String get kidsDuaBeforeSleepWhen => 'Say it when you are getting into bed.';

  @override
  String get kidsDuaBeforeSleepLesson =>
      'We sleep while trusting Allah’s care.';

  @override
  String get kidsDuaBeforeSleepSituation =>
      'It is bedtime and you are ready to rest.';

  @override
  String get kidsDuaAfterWakingTitle => 'After waking up';

  @override
  String get kidsDuaAfterWakingMeaning =>
      'All praise is for Allah who gave us life after sleep, and to Him is the return.';

  @override
  String get kidsDuaAfterWakingWhen => 'Say it when you wake up.';

  @override
  String get kidsDuaAfterWakingLesson => 'A new morning is a gift from Allah.';

  @override
  String get kidsDuaAfterWakingSituation =>
      'You just woke up and want to begin with thanks.';

  @override
  String get kidsDuaEnteringWashroomTitle => 'Entering the washroom';

  @override
  String get kidsDuaEnteringWashroomMeaning =>
      'O Allah, I seek Your protection from impurity and harm.';

  @override
  String get kidsDuaEnteringWashroomWhen =>
      'Say it before entering the washroom.';

  @override
  String get kidsDuaEnteringWashroomLesson =>
      'Even private moments can begin with a small dua.';

  @override
  String get kidsDuaEnteringWashroomSituation =>
      'You are about to enter the washroom.';

  @override
  String get kidsDuaLeavingWashroomTitle => 'Leaving the washroom';

  @override
  String get kidsDuaLeavingWashroomMeaning => 'I ask for Your forgiveness.';

  @override
  String get kidsDuaLeavingWashroomWhen => 'Say it when you come out.';

  @override
  String get kidsDuaLeavingWashroomLesson =>
      'A very short dua can still be full of adab.';

  @override
  String get kidsDuaLeavingWashroomSituation =>
      'You have come out of the washroom.';

  @override
  String get kidsDuaLeavingHomeTitle => 'Leaving home';

  @override
  String get kidsDuaLeavingHomeMeaning =>
      'In the name of Allah, I trust in Allah, and there is no power except with Allah.';

  @override
  String get kidsDuaLeavingHomeWhen => 'Say it when you step out of the house.';

  @override
  String get kidsDuaLeavingHomeLesson => 'We leave home with trust in Allah.';

  @override
  String get kidsDuaLeavingHomeSituation => 'You are heading outside.';

  @override
  String get kidsDuaEnteringHomeTitle => 'Entering home';

  @override
  String get kidsDuaEnteringHomeMeaning =>
      'O Allah, I ask You for a good entrance and a good exit. In Allah’s name we enter and leave, and in Allah we trust.';

  @override
  String get kidsDuaEnteringHomeWhen => 'Say it when you come into your home.';

  @override
  String get kidsDuaEnteringHomeLesson =>
      'Our homes feel warmer when we enter with Allah’s name.';

  @override
  String get kidsDuaEnteringHomeSituation => 'You are coming back home.';

  @override
  String get kidsDuaRabbiZidniIlmaTitle => 'Rabbi zidni ilma';

  @override
  String get kidsDuaRabbiZidniIlmaMeaning =>
      'My Lord, increase me in knowledge.';

  @override
  String get kidsDuaRabbiZidniIlmaWhen =>
      'Say it before learning, reading, or studying.';

  @override
  String get kidsDuaRabbiZidniIlmaLesson =>
      'We ask Allah to open our minds and hearts to learning.';

  @override
  String get kidsDuaRabbiZidniIlmaSituation =>
      'You are about to learn something new.';

  @override
  String get kidsDuaForParentsTitle => 'Dua for parents';

  @override
  String get kidsDuaForParentsMeaning =>
      'My Lord, have mercy on them as they raised me when I was small.';

  @override
  String get kidsDuaForParentsWhen =>
      'Say it when you want to pray for your parents.';

  @override
  String get kidsDuaForParentsLesson =>
      'A small dua can be a beautiful gift for parents.';

  @override
  String get kidsDuaForParentsSituation =>
      'You want to make a kind dua for your parents.';

  @override
  String get kidsDuaRewardFirstDuaTitle => 'First dua star';

  @override
  String get kidsDuaRewardFirstDuaSubtitle =>
      'Unlocked after your first learned dua.';

  @override
  String get kidsDuaRewardMealSmileTitle => 'Meal smile';

  @override
  String get kidsDuaRewardMealSmileSubtitle =>
      'Learn the duas around food time.';

  @override
  String get kidsDuaRewardNightStarTitle => 'Night star';

  @override
  String get kidsDuaRewardNightStarSubtitle =>
      'Learn the duas for sleep and waking.';

  @override
  String get kidsDuaRewardCleanStartTitle => 'Clean start';

  @override
  String get kidsDuaRewardCleanStartSubtitle =>
      'Learn the duas for entering and leaving the washroom.';

  @override
  String get kidsDuaRewardHomeLightTitle => 'Home light';

  @override
  String get kidsDuaRewardHomeLightSubtitle =>
      'Learn the duas for leaving and entering home.';

  @override
  String get kidsDuaRewardLearningLanternTitle => 'Learning lantern';

  @override
  String get kidsDuaRewardLearningLanternSubtitle =>
      'Learn the duas for knowledge and parents.';

  @override
  String get kidsDuaRewardPracticeBloomTitle => 'Practice bloom';

  @override
  String get kidsDuaRewardPracticeBloomSubtitle =>
      'Complete a few practice rounds.';

  @override
  String get kidsDuaRewardAllStarterTitle => 'Starter garden';

  @override
  String get kidsDuaRewardAllStarterSubtitle => 'Learn all 10 starter duas.';

  @override
  String get kidsDuaRewardMorningBloomTitle => 'Morning bloom';

  @override
  String get kidsDuaRewardMorningBloomSubtitle =>
      'Keep growing through your early lessons.';

  @override
  String get kidsDuaRewardParentHeartTitle => 'Parent heart';

  @override
  String get kidsDuaRewardParentHeartSubtitle =>
      'Reach the family duas with love and care.';

  @override
  String kidsDuaLibraryCountValue(int count) {
    return '$count duas';
  }

  @override
  String kidsDuaCategoryCountValue(int count) {
    return '$count categories';
  }

  @override
  String get kidsDuaHeroTitle => 'My daily life with Allah';

  @override
  String get kidsDuaHeroSubtitle =>
      'Learn small duas for meals, sleep, home, feelings, and family life.';

  @override
  String get kidsDuaCompletionCelebrateTitle => 'MashaAllah!';

  @override
  String kidsDuaCompletionCelebrateBody(String duaTitle) {
    return 'You learned $duaTitle.';
  }

  @override
  String get kidsDuaNextDuaAction => 'Next dua';

  @override
  String get kidsDuaBackToCategoryAction => 'Back to library';

  @override
  String get kidsDuaLearnTodayAction => 'Learn today\'s dua';

  @override
  String get kidsDuaContinueTodayAction => 'Continue today\'s dua';

  @override
  String get kidsDuaPracticeTodayAction => 'Practice today\'s dua';

  @override
  String get kidsDuaStickerCollectionTitle => 'Sticker collection';

  @override
  String get kidsDuaStickerCollectionEmpty =>
      'Learn a full category to unlock your first sticker.';

  @override
  String get kidsDuaStickerLockedLabel => 'Locked';

  @override
  String kidsDuaStickerUnlockedValue(int count) {
    return '$count sticker';
  }

  @override
  String get kidsDuaStickerDailyBasics => 'Daily basics star';

  @override
  String get kidsDuaStickerFoodDrink => 'Food and drink lantern';

  @override
  String get kidsDuaStickerSleep => 'Sleep moon';

  @override
  String get kidsDuaStickerHomeDaily => 'Home light';

  @override
  String get kidsDuaStickerMannersSocial => 'Kind manners heart';

  @override
  String get kidsDuaStickerFeelingsProtection => 'Protection shield';

  @override
  String get kidsDuaStickerLearningFamily => 'Learning book';

  @override
  String get kidsDuaStickerTravelNature => 'Travel garden';

  @override
  String get kidsDuaMyDayTitle => 'My Day With Duas';

  @override
  String get kidsDuaMyDaySubtitle =>
      'Walk through a few small moments and remember Allah through your day.';

  @override
  String get kidsDuaMyDayStartAction => 'Start my day';

  @override
  String get kidsDuaMyDayContinueAction => 'Continue my day';

  @override
  String get kidsDuaMyDayReviewAction => 'Review my day';

  @override
  String get kidsDuaMyDayDoneTitle => 'Day complete';

  @override
  String get kidsDuaMyDayCompleteBody =>
      'You remembered Allah throughout your day';

  @override
  String get kidsDuaMyDayMorningTitle => 'Morning';

  @override
  String get kidsDuaMyDayMealsTitle => 'Meals';

  @override
  String get kidsDuaMyDayGoingOutTitle => 'Going out';

  @override
  String get kidsDuaMyDayNightTitle => 'Night';

  @override
  String get kidsDuaMyDaySectionOpenLabel => 'Open';

  @override
  String get kidsDuaMyDaySectionNowLabel => 'Now';

  @override
  String get kidsDuaMyDaySectionNextLabel => 'Next';

  @override
  String get kidsDuaMyDaySectionDoneLabel => 'Done';

  @override
  String get kidsDuaMyDayPendingTodayLabel => 'Not done today';

  @override
  String get kidsDuaMyDayCompletedTodayLabel => 'Done today';

  @override
  String get kidsDuaMyDayRightNowTitle => 'Right now';

  @override
  String get kidsDuaMyDayNextUpTitle => 'Next up';

  @override
  String get kidsDuaMyDayNextUpAction => 'See what comes next';

  @override
  String get kidsDuaMyDayUseNowAction => 'Use now';

  @override
  String get kidsDuaMyDayJourneyTitle => 'Today’s journey';

  @override
  String get kidsDuaMyDayJourneySubtitle =>
      'See what fits now, what comes next, and how your day is going.';

  @override
  String get kidsDuaMyDayQuestionTitle => 'One small question';

  @override
  String get kidsDuaMyDayQuestionRecapTitle => 'A short day recap';

  @override
  String get kidsDuaMyDayQuestionContinueAction => 'Keep going';

  @override
  String get kidsDuaMyDayQuestionTryAction => 'Let’s try again';

  @override
  String get kidsDuaMyDayQuestionBackToDayAction => 'Back to My Day';

  @override
  String get kidsDuaMyDayQuestionMashaAllah => 'MashaAllah!';

  @override
  String get kidsDuaMyDayQuestionTryAgain => 'Let’s try again.';

  @override
  String kidsDuaMyDayMatchPrompt(Object situation) {
    return 'What do you say $situation?';
  }

  @override
  String kidsDuaMyDayMeaningPrompt(Object duaTitle) {
    return 'What does $duaTitle mean?';
  }

  @override
  String get kidsDuaMyDayRecapCompleteTitle =>
      'You remembered through your day';

  @override
  String kidsDuaMyDayRecapCompleteBody(Object correct, Object total) {
    return 'You answered $correct of $total recap questions and kept your day moving with Allah.';
  }

  @override
  String kidsDuaMyDayRecapBonusValue(Object xp, Object drops) {
    return '+$xp XP and +$drops Ocean Drop';
  }

  @override
  String get kidsDuaMyDayRightNowMorningReason =>
      'A gentle morning start with Allah.';

  @override
  String get kidsDuaMyDayRightNowMealsReason =>
      'A small dua for food and thankfulness.';

  @override
  String get kidsDuaMyDayRightNowGoingOutReason =>
      'A good moment to remember Allah before going out.';

  @override
  String get kidsDuaMyDayRightNowNightReason =>
      'A calm evening and night reminder with Allah.';

  @override
  String kidsDuaMyDayLandingDetail(String reason, String nextTitle) {
    return '$reason Next up: $nextTitle.';
  }

  @override
  String kidsDuaMyDayCompleteRewardValue(int xp, int drops) {
    return '+$xp XP and +$drops drop';
  }

  @override
  String get kidsDuaSuggestedTitle => 'Suggested right now';

  @override
  String get kidsDuaSuggestedLearnNow => 'Learn now';

  @override
  String get kidsDuaSuggestedPracticeNow => 'Practice now';

  @override
  String get kidsDuaSuggestedReasonMorning =>
      'A gentle way to begin the morning with Allah.';

  @override
  String get kidsDuaSuggestedReasonLearning =>
      'A beautiful dua before learning something new.';

  @override
  String get kidsDuaSuggestedReasonMeals => 'A helpful dua for meal time.';

  @override
  String get kidsDuaSuggestedReasonGratitude =>
      'A small way to thank Allah right now.';

  @override
  String get kidsDuaSuggestedReasonGoingOut =>
      'A good dua for going out and meeting people.';

  @override
  String get kidsDuaSuggestedReasonPeople =>
      'A kind dua for being with others.';

  @override
  String get kidsDuaSuggestedReasonFamily => 'A loving dua for family time.';

  @override
  String get kidsDuaSuggestedReasonCalm =>
      'A calm dua for this part of the day.';

  @override
  String get kidsDuaSuggestedReasonNight => 'A peaceful dua for the night.';

  @override
  String get kidsDuaLightCardTitle => 'Keep your light shining';

  @override
  String get kidsDuaMyDayLightTitle => 'Your light today';

  @override
  String kidsDuaLightValue(Object light) {
    return 'Your light: $light';
  }

  @override
  String kidsDuaStreakValue(Object days) {
    return 'Streak: $days days';
  }

  @override
  String get kidsDuaLightSeedLabel => 'Gentle Seed';

  @override
  String get kidsDuaLightGlowLabel => 'Soft Glow';

  @override
  String get kidsDuaLightLanternLabel => 'Bright Lantern';

  @override
  String get kidsDuaLightMoonLabel => 'Calm Moon';

  @override
  String get kidsDuaLightStarLabel => 'Steady Star';

  @override
  String get kidsDuaLightRadiantLabel => 'Radiant Light';

  @override
  String get kidsDuaLightStartMessage => 'One small dua can brighten your day.';

  @override
  String get kidsDuaLightBuildMessage => 'Let’s keep your light shining today.';

  @override
  String get kidsDuaLightSteadyMessage =>
      'Your light is growing with each small dua.';

  @override
  String get kidsDuaLightRadiantMessage => 'Your light is shining beautifully.';

  @override
  String get kidsDuaLightRecoveryMessage =>
      'Come back today to brighten your light again.';

  @override
  String get kidsDuaLightCompleteTodayMessage =>
      'You kept your light shining today.';

  @override
  String get kidsDuaMyDayLightContinue =>
      'One small dua can brighten your day.';

  @override
  String get kidsDuaMyDayLightComplete => 'You kept your light shining today.';

  @override
  String get kidsDuaReminderMorningTitle => 'A gentle morning dua';

  @override
  String get kidsDuaReminderMorningBody => 'A small dua can brighten your day.';

  @override
  String get kidsDuaReminderMiddayTitle => 'A dua for this moment';

  @override
  String get kidsDuaReminderMiddayBody => 'Let’s do one small dua together.';

  @override
  String get kidsDuaReminderEveningTitle => 'A calm return to Allah';

  @override
  String get kidsDuaReminderEveningBody => 'Keep your light shining today.';

  @override
  String get kidsDuaReminderBedtimeTitle => 'A peaceful bedtime dua';

  @override
  String get kidsDuaReminderBedtimeBody =>
      'It’s bedtime. Let’s remember Allah before sleep.';

  @override
  String get kidsDuaReminderRecoveryTitle => 'Your light is waiting';

  @override
  String get kidsDuaReminderRecoveryBody =>
      'Come back for one small dua today.';

  @override
  String get kidsDuaDrawAction => 'Draw this dua';

  @override
  String get kidsDuaDrawTitle => 'Draw your dua';

  @override
  String get kidsDuaDrawHint => 'Draw what this dua reminds you of.';

  @override
  String get kidsDuaDrawBrushSmall => 'Small';

  @override
  String get kidsDuaDrawBrushMedium => 'Medium';

  @override
  String get kidsDuaDrawBrushLarge => 'Large';

  @override
  String get kidsDuaDrawEraseAction => 'Erase';

  @override
  String get kidsDuaDrawClearAction => 'Clear';

  @override
  String get kidsDuaDrawUndoAction => 'Undo';

  @override
  String get kidsDuaDrawSaveAction => 'Save drawing';

  @override
  String get kidsDuaDrawSavingAction => 'Saving...';

  @override
  String get kidsDuaDrawDeleteAction => 'Delete drawing';

  @override
  String get kidsDuaDrawingsTitle => 'My drawings';

  @override
  String get kidsDuaDrawingsEmpty => 'No drawings yet.';

  @override
  String get kidsDuaDrawingsUntitled => 'Dua drawing';

  @override
  String kidsDuaDrawingsLandingSubtitle(Object count) {
    return '$count saved drawings';
  }

  @override
  String get kidsDuaParentTitle => 'Parent view';

  @override
  String get kidsDuaParentViewToggleTitle => 'Show parent view';

  @override
  String get kidsDuaParentViewToggleBody =>
      'Use a calm shared view of learning, activity, and drawings.';

  @override
  String get kidsDuaParentLandingEnabled => 'Progress, activity, and drawings';

  @override
  String get kidsDuaParentLandingDisabled => 'Turn on the shared parent view';

  @override
  String get kidsDuaParentOverviewTitle => 'Overview';

  @override
  String get kidsDuaParentTodayDone => 'Today complete';

  @override
  String get kidsDuaParentTodayPending => 'Today in progress';

  @override
  String get kidsDuaParentLearningTitle => 'Learning progress';

  @override
  String kidsDuaParentCategoryProgress(Object learned, Object total) {
    return '$learned of $total learned';
  }

  @override
  String get kidsDuaParentActivityTitle => 'Daily activity';

  @override
  String get kidsDuaParentActivityEmpty => 'No activity yet today.';

  @override
  String get kidsDuaParentActivityLessonDone => 'Completed a dua lesson';

  @override
  String get kidsDuaParentActivityMyDayDone => 'Completed My Day With Duas';

  @override
  String get kidsDuaParentActivityStepDone => 'Completed a My Day step';

  @override
  String get kidsDuaParentActivityPracticeDone =>
      'Answered a practice question correctly';

  @override
  String get kidsDuaParentActivityDrawingSaved => 'Saved a dua drawing';

  @override
  String get kidsDuaParentActivityStoryDone => 'Finished a dua story';

  @override
  String get kidsDuaParentDrawingsTitle => 'Drawings';

  @override
  String get kidsDuaParentDrawingsEmpty => 'No saved drawings yet.';

  @override
  String get kidsDuaParentOpenGalleryAction => 'Open gallery';

  @override
  String get kidsDuaStoriesTitle => 'Dua Stories';

  @override
  String get kidsDuaStoriesSubtitle =>
      'Short calm stories that help a child feel a dua in real life.';

  @override
  String get kidsDuaStoriesAction => 'Listen to story';

  @override
  String kidsDuaStoriesLandingSubtitle(Object count) {
    return '$count gentle stories';
  }

  @override
  String kidsDuaStoriesDurationValue(Object minutes) {
    return '$minutes min story';
  }

  @override
  String get kidsDuaStoriesFeaturedTitle => 'Featured story';

  @override
  String get kidsDuaStoriesContinueTitle => 'Continue story';

  @override
  String get kidsDuaStoriesBrowseTitle => 'Story categories';

  @override
  String get kidsDuaStoriesBrowseAllAction => 'Browse all stories';

  @override
  String get kidsDuaStoriesBrowseAllTitle => 'All stories';

  @override
  String get kidsDuaStoriesCategoryBedtime => 'Bedtime Stories';

  @override
  String get kidsDuaStoriesCategoryDailyLife => 'Daily Life Stories';

  @override
  String get kidsDuaStoriesCategoryFeelings => 'Feelings Stories';

  @override
  String get kidsDuaStoriesCategoryLearning => 'Learning Stories';

  @override
  String get kidsDuaStoriesCategoryTravelNature => 'Travel & Nature Stories';

  @override
  String kidsDuaStoriesSceneValue(Object current, Object total) {
    return 'Scene $current of $total';
  }

  @override
  String get kidsDuaStoriesBackAction => 'Back';

  @override
  String get kidsDuaStoriesAutoplayAction => 'Auto play';

  @override
  String get kidsDuaStoriesPauseAction => 'Pause';

  @override
  String get kidsDuaStoriesNextAction => 'Next scene';

  @override
  String get kidsDuaStoriesCompleteTitle => 'A gentle story ending';

  @override
  String get kidsDuaStoriesSayDuaAction => 'Now let’s say the dua';

  @override
  String get kidsDuaStoriesBackToStoriesAction => 'Back to stories';

  @override
  String kidsDuaStoriesLessonHint(Object title) {
    return 'Next: learn $title';
  }

  @override
  String get kidsDuaStoriesMyDayDetail => 'A calm story for this moment.';

  @override
  String get xpLevelTitle1 => 'Niyyah';

  @override
  String get xpLevelTitle2 => 'Bidayah';

  @override
  String get xpLevelTitle3 => 'Yaqzah';

  @override
  String get xpLevelTitle4 => 'Tawbah';

  @override
  String get xpLevelTitle5 => 'Wudu';

  @override
  String get xpLevelTitle6 => 'Salah';

  @override
  String get xpLevelTitle7 => 'Dhikr';

  @override
  String get xpLevelTitle8 => 'Sabr';

  @override
  String get xpLevelTitle9 => 'Shukr';

  @override
  String get xpLevelTitle10 => 'Taqwa';

  @override
  String get xpLevelTitle11 => 'Seeker of Light';

  @override
  String get xpLevelTitle12 => 'Walker of the Path';

  @override
  String get xpLevelTitle13 => 'Keeper of Prayer';

  @override
  String get xpLevelTitle14 => 'Steady in Dhikr';

  @override
  String get xpLevelTitle15 => 'Student of Knowledge';

  @override
  String get xpLevelTitle16 => 'Lover of Qur’an';

  @override
  String get xpLevelTitle17 => 'Guardian of Time';

  @override
  String get xpLevelTitle18 => 'Companion of Sabr';

  @override
  String get xpLevelTitle19 => 'Companion of Shukr';

  @override
  String get xpLevelTitle20 => 'Companion of Taqwa';

  @override
  String get xpLevelTitle21 => 'Dawn Seeker';

  @override
  String get xpLevelTitle22 => 'Fajr Riser';

  @override
  String get xpLevelTitle23 => 'Keeper of Wudu';

  @override
  String get xpLevelTitle24 => 'Heart in Remembrance';

  @override
  String get xpLevelTitle25 => 'Listener of Qur’an';

  @override
  String get xpLevelTitle26 => 'Reader of Signs';

  @override
  String get xpLevelTitle27 => 'Friend of Jumu‘ah';

  @override
  String get xpLevelTitle28 => 'Walker to the Masjid';

  @override
  String get xpLevelTitle29 => 'Keeper of Adab';

  @override
  String get xpLevelTitle30 => 'Builder of Habits';

  @override
  String get xpLevelTitle31 => 'Rooted in Salah';

  @override
  String get xpLevelTitle32 => 'Rooted in Dhikr';

  @override
  String get xpLevelTitle33 => 'Rooted in Qur’an';

  @override
  String get xpLevelTitle34 => 'Rooted in Sabr';

  @override
  String get xpLevelTitle35 => 'Rooted in Shukr';

  @override
  String get xpLevelTitle36 => 'Rooted in Taqwa';

  @override
  String get xpLevelTitle37 => 'Keeper of Amanah';

  @override
  String get xpLevelTitle38 => 'Watcher of the Heart';

  @override
  String get xpLevelTitle39 => 'Servant in Gratitude';

  @override
  String get xpLevelTitle40 => 'Servant in Hope';

  @override
  String get xpLevelTitle41 => 'Light of Consistency';

  @override
  String get xpLevelTitle42 => 'Light of Discipline';

  @override
  String get xpLevelTitle43 => 'Light of Reflection';

  @override
  String get xpLevelTitle44 => 'Light of Presence';

  @override
  String get xpLevelTitle45 => 'Light of Intention';

  @override
  String get xpLevelTitle46 => 'Light of Worship';

  @override
  String get xpLevelTitle47 => 'Light of Restraint';

  @override
  String get xpLevelTitle48 => 'Light of Reliance';

  @override
  String get xpLevelTitle49 => 'Light of Humility';

  @override
  String get xpLevelTitle50 => 'Light of Ihsan';

  @override
  String get xpLevelTitle51 => 'Garden Tender';

  @override
  String get xpLevelTitle52 => 'Garden Keeper';

  @override
  String get xpLevelTitle53 => 'Garden Grower';

  @override
  String get xpLevelTitle54 => 'Bearer of Sabr';

  @override
  String get xpLevelTitle55 => 'Bearer of Shukr';

  @override
  String get xpLevelTitle56 => 'Bearer of Taqwa';

  @override
  String get xpLevelTitle57 => 'Bearer of Adab';

  @override
  String get xpLevelTitle58 => 'Bearer of Rahmah';

  @override
  String get xpLevelTitle59 => 'Bearer of Dhikr';

  @override
  String get xpLevelTitle60 => 'Bearer of Nur';

  @override
  String get xpLevelTitle61 => 'Path Companion';

  @override
  String get xpLevelTitle62 => 'Path Builder';

  @override
  String get xpLevelTitle63 => 'Path Guardian';

  @override
  String get xpLevelTitle64 => 'Path Illuminated';

  @override
  String get xpLevelTitle65 => 'One Who Returns';

  @override
  String get xpLevelTitle66 => 'One Who Remembers';

  @override
  String get xpLevelTitle67 => 'One Who Perseveres';

  @override
  String get xpLevelTitle68 => 'One Who Gives Thanks';

  @override
  String get xpLevelTitle69 => 'One Who Stands in Prayer';

  @override
  String get xpLevelTitle70 => 'One Who Seeks Nearness';

  @override
  String get xpLevelTitle71 => 'Lantern of the Path';

  @override
  String get xpLevelTitle72 => 'Lantern of Dawn';

  @override
  String get xpLevelTitle73 => 'Lantern of Prayer';

  @override
  String get xpLevelTitle74 => 'Lantern of Qur’an';

  @override
  String get xpLevelTitle75 => 'Lantern of Dhikr';

  @override
  String get xpLevelTitle76 => 'Lantern of Patience';

  @override
  String get xpLevelTitle77 => 'Lantern of Gratitude';

  @override
  String get xpLevelTitle78 => 'Lantern of Reflection';

  @override
  String get xpLevelTitle79 => 'Lantern of Mercy';

  @override
  String get xpLevelTitle80 => 'Lantern of Hope';

  @override
  String get xpLevelTitle81 => 'Radiance of Niyyah';

  @override
  String get xpLevelTitle82 => 'Radiance of Salah';

  @override
  String get xpLevelTitle83 => 'Radiance of Dhikr';

  @override
  String get xpLevelTitle84 => 'Radiance of Qur’an';

  @override
  String get xpLevelTitle85 => 'Radiance of Sabr';

  @override
  String get xpLevelTitle86 => 'Radiance of Shukr';

  @override
  String get xpLevelTitle87 => 'Radiance of Taqwa';

  @override
  String get xpLevelTitle88 => 'Radiance of Ihsan';

  @override
  String get xpLevelTitle89 => 'Radiance of Rahmah';

  @override
  String get xpLevelTitle90 => 'Radiance of Nur';

  @override
  String get xpLevelTitle91 => 'The Steadfast';

  @override
  String get xpLevelTitle92 => 'The Grateful';

  @override
  String get xpLevelTitle93 => 'The Remembering';

  @override
  String get xpLevelTitle94 => 'The Reflective';

  @override
  String get xpLevelTitle95 => 'The Worshipful';

  @override
  String get xpLevelTitle96 => 'The Hopeful';

  @override
  String get xpLevelTitle97 => 'The Humble';

  @override
  String get xpLevelTitle98 => 'The Constant';

  @override
  String get xpLevelTitle99 => 'The Illuminated';

  @override
  String get xpLevelTitle100 => 'Path of Nūr';

  @override
  String get xpCardTitle => 'Path XP';

  @override
  String xpCardLevelValue(Object level, Object title) {
    return 'Level $level · $title';
  }

  @override
  String xpCardTotalXpValue(Object xp) {
    return '$xp total XP';
  }

  @override
  String xpCardNextLevelValue(Object title) {
    return 'Next: $title';
  }

  @override
  String xpCardRemainingValue(Object xp) {
    return '$xp XP to go';
  }

  @override
  String get xpCardMaxLevel => 'Path of Nūr';

  @override
  String get xpCardMaxLevelReached =>
      'You have reached the current peak of this path.';

  @override
  String get growthTrackingOverviewTitle => 'Tracking Overview';

  @override
  String get growthTrackingOverviewSubtitle =>
      'A cleaner view of your habits, worship, rhythm, and steady progress.';

  @override
  String get growthTrackingOverviewTodayTitle => 'Today at a glance';

  @override
  String get growthTrackingOverviewHabits => 'Habits';

  @override
  String growthTrackingOverviewHabitsDetail(Object count) {
    return '$count due today';
  }

  @override
  String get growthTrackingOverviewPrayerDetail => 'Prayer progress for today';

  @override
  String get growthTrackingOverviewStreakDetail => 'Current steady rhythm';

  @override
  String growthTrackingOverviewXpDetail(Object xp) {
    return '$xp total XP';
  }

  @override
  String get growthTrackingOverviewDropsDetail =>
      'Drops gathered for Garden and Ocean';

  @override
  String get growthTrackingDashboardsTitle => 'Open dashboards';

  @override
  String get growthTrackingPrayerDashboardSubtitle =>
      'Review prayer and worship tracking in Worship.';

  @override
  String get growthTrackingSuggestionsTitle => 'Suggested next steps';

  @override
  String get growthTrackingSuggestionKidsTitle => 'Kids learning rhythm';

  @override
  String get growthTrackingSuggestionKidsSubtitle =>
      'Keep habits gentle and connected to the current learning journey.';

  @override
  String get growthTrackingSuggestionTeensTitle => 'Teen growth focus';

  @override
  String get growthTrackingSuggestionTeensSubtitle =>
      'Balance steady habits with a simple review rhythm you can keep.';

  @override
  String get growthTrackingSuggestionBeginnerTitle => 'New Muslim support';

  @override
  String get growthTrackingSuggestionBeginnerSubtitle =>
      'Start with a few steady habits and pair them with your current learning path.';

  @override
  String get growthTrackingSuggestionPracticingTitle =>
      'Strengthen your current path';

  @override
  String get growthTrackingSuggestionPracticingSubtitle =>
      'Use the habit dashboard to reinforce what you are already learning.';

  @override
  String get growthTrackingSuggestionAdvancedTitle =>
      'Review your longer pattern';

  @override
  String get growthTrackingSuggestionAdvancedSubtitle =>
      'Use the calendar to notice consistency, missed days, and return points.';

  @override
  String get growthTrackingCalendarTitle => 'Habit Calendar';

  @override
  String get growthTrackingCalendarSubtitle =>
      'Review completed, missed, and due habits over time.';

  @override
  String get growthTrackingCalendarNoHabits => 'No habits';

  @override
  String growthTrackingCalendarMissedValue(Object count) {
    return '$count missed';
  }

  @override
  String get growthOceanDashboardTitle => 'Ocean Dashboard';

  @override
  String get growthOceanDashboardSubtitle =>
      'One place for your drops, Garden progress, and shared water impact.';

  @override
  String growthOceanDashboardSummary(Object drops, Object community) {
    return 'You have gathered $drops drops, contributing to a shared ocean now holding $community drops.';
  }

  @override
  String get growthOceanDashboardYourDrops => 'Your drops';

  @override
  String get growthOceanDashboardToday => 'Today';

  @override
  String get growthOceanDashboardCommunity => 'Community';

  @override
  String get growthOceanDashboardOpenCommunity => 'Open full Ocean view';

  @override
  String get growthHabitDashboardTitle => 'Habit Dashboard';

  @override
  String get growthHabitDashboardSubtitle =>
      'Review your enabled habits, custom setup, and today’s rhythm in one place.';

  @override
  String get growthHabitDashboardSummaryTitle => 'Habit summary';

  @override
  String get growthHabitDashboardEnabledHabits => 'Enabled';

  @override
  String get growthHabitDashboardDueToday => 'Due today';

  @override
  String get growthHabitDashboardCustomHabits => 'Custom habits';

  @override
  String get growthHabitDashboardCustomCategories => 'Custom categories';

  @override
  String growthHabitDashboardCompletionSummary(Object completed, Object due) {
    return '$completed of $due completed today';
  }

  @override
  String get growthHabitDashboardActionsTitle => 'Open tools';

  @override
  String get growthHabitDashboardOpenTracker => 'Open Habit Tracker';

  @override
  String get growthHabitSettingsTitle => 'Habit Settings';

  @override
  String get growthHabitSettingsSubtitle =>
      'Choose what stays visible, what gets tracked, and add your own custom habits and categories.';

  @override
  String get growthHabitSettingsCustomCategoriesTitle => 'Custom categories';

  @override
  String get growthHabitSettingsNoCustomCategories =>
      'No custom categories yet.';

  @override
  String get growthHabitSettingsAddCategory => 'Add Category';

  @override
  String get growthHabitSettingsCustomHabitsTitle => 'Custom habits';

  @override
  String get growthHabitSettingsAddHabit => 'Add Custom Habit';

  @override
  String get growthHabitSettingsManageHabitsTitle => 'Manage tracked habits';

  @override
  String get growthHabitSettingsTrackWhenEnabled =>
      'Track this habit in normal flows';

  @override
  String get growthHabitSettingsCategoryNameLabel => 'Category name';

  @override
  String get growthHabitSettingsCategoryDescriptionLabel =>
      'Category description';

  @override
  String get growthHabitSettingsHabitNameLabel => 'Habit name';

  @override
  String get growthHabitSettingsHabitSubtitleLabel => 'Short subtitle';

  @override
  String get growthHabitSettingsHabitDescriptionLabel => 'Description';

  @override
  String get growthHabitSettingsBaseCategoryLabel => 'Base category';

  @override
  String get growthHabitSettingsOptionalCustomCategory => 'Custom category';

  @override
  String get growthHabitSettingsNoCustomCategory => 'No custom category';

  @override
  String get growthHabitSettingsCustomHabitFallbackSubtitle =>
      'A custom habit for your journey';

  @override
  String get growthHabitSettingsCancelAction => 'Cancel';

  @override
  String get growthHabitSettingsSaveAction => 'Save';
}
