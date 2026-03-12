import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
    Locale('fa'),
    Locale('fa', 'AF'),
    Locale('ha'),
    Locale('hi'),
    Locale('id'),
    Locale('ku'),
    Locale('ms'),
    Locale('pa'),
    Locale('ps'),
    Locale('tg'),
    Locale('tr'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Path of Nur'**
  String get appTitle;

  /// No description provided for @navDhikr.
  ///
  /// In en, this message translates to:
  /// **'Worship'**
  String get navDhikr;

  /// No description provided for @navLearning.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearning;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get navPrayer;

  /// No description provided for @navGarden.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navGarden;

  /// No description provided for @greetingArabic.
  ///
  /// In en, this message translates to:
  /// **'السلام عليكم ورحمة الله وبركاته'**
  String get greetingArabic;

  /// No description provided for @brotherName.
  ///
  /// In en, this message translates to:
  /// **'Brother Shahab'**
  String get brotherName;

  /// No description provided for @peaceUponYou.
  ///
  /// In en, this message translates to:
  /// **'Peace be upon you'**
  String get peaceUponYou;

  /// No description provided for @ayahArabic.
  ///
  /// In en, this message translates to:
  /// **'واستعينوا بالصبر والصلاة'**
  String get ayahArabic;

  /// No description provided for @ayahTranslit.
  ///
  /// In en, this message translates to:
  /// **'Wastaeenu bi-s-sabri wa-s-salah'**
  String get ayahTranslit;

  /// No description provided for @ayahTranslation.
  ///
  /// In en, this message translates to:
  /// **'Seek help through patience and prayer. (2:45)'**
  String get ayahTranslation;

  /// No description provided for @quranTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quranTitle;

  /// No description provided for @quranSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read • Search • Notes'**
  String get quranSubtitle;

  /// No description provided for @nextSalah.
  ///
  /// In en, this message translates to:
  /// **'Next Salah'**
  String get nextSalah;

  /// No description provided for @allSalahTimes.
  ///
  /// In en, this message translates to:
  /// **'All Salah Times'**
  String get allSalahTimes;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @dhuhrArabic.
  ///
  /// In en, this message translates to:
  /// **'الظهر'**
  String get dhuhrArabic;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'2h 3m'**
  String get remainingTime;

  /// No description provided for @atTime.
  ///
  /// In en, this message translates to:
  /// **'at 1:30 PM'**
  String get atTime;

  /// No description provided for @salahCompleted.
  ///
  /// In en, this message translates to:
  /// **'Salah completed'**
  String get salahCompleted;

  /// No description provided for @dhikrToday.
  ///
  /// In en, this message translates to:
  /// **'Dhikr today'**
  String get dhikrToday;

  /// No description provided for @salahStreak.
  ///
  /// In en, this message translates to:
  /// **'Salah Streak'**
  String get salahStreak;

  /// No description provided for @homeSectionDailyNurTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Nur Progress'**
  String get homeSectionDailyNurTitle;

  /// No description provided for @homeSectionDailyNurSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A high-level snapshot for reflection.'**
  String get homeSectionDailyNurSubtitle;

  /// No description provided for @homePrayerSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Summary'**
  String get homePrayerSummaryTitle;

  /// No description provided for @homePrayerSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick view into daily worship rhythm.'**
  String get homePrayerSummarySubtitle;

  /// No description provided for @homeDhikrLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr and Learning'**
  String get homeDhikrLearningTitle;

  /// No description provided for @homeDhikrLearningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast access to spiritual practices.'**
  String get homeDhikrLearningSubtitle;

  /// No description provided for @homeReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection / Reminder'**
  String get homeReflectionTitle;

  /// No description provided for @homeReflectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Centerpiece message for the day.'**
  String get homeReflectionSubtitle;

  /// No description provided for @homeLevelStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Level and Streak'**
  String get homeLevelStreakTitle;

  /// No description provided for @homeLevelStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Growth signals without pressure.'**
  String get homeLevelStreakSubtitle;

  /// No description provided for @homeOverviewHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Nur Overview'**
  String get homeOverviewHeroTitle;

  /// No description provided for @homeOverviewHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact summary of worship, learning, and growth.'**
  String get homeOverviewHeroSubtitle;

  /// No description provided for @homePrayerProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer progress'**
  String get homePrayerProgressTitle;

  /// No description provided for @homeDhikrProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr progress'**
  String get homeDhikrProgressTitle;

  /// No description provided for @homeCurrentStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get homeCurrentStreakTitle;

  /// No description provided for @homeXpLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level and XP'**
  String get homeXpLevelTitle;

  /// No description provided for @homeDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get homeDaysLabel;

  /// No description provided for @homeXpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'XP to next level'**
  String get homeXpToNextLevel;

  /// No description provided for @homeWorshipSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Worship Summary'**
  String get homeWorshipSummaryTitle;

  /// No description provided for @homeWorshipSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer, dhikr, fasting, and Khusu in one place.'**
  String get homeWorshipSummarySubtitle;

  /// No description provided for @homeFastingStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Fasting status'**
  String get homeFastingStatusTitle;

  /// No description provided for @homeKhusuQuickEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Khusu quick entry'**
  String get homeKhusuQuickEntryTitle;

  /// No description provided for @homeKhusuQuickEntryValue.
  ///
  /// In en, this message translates to:
  /// **'Enter focus mode'**
  String get homeKhusuQuickEntryValue;

  /// No description provided for @homeKhusuQuickEntryShort.
  ///
  /// In en, this message translates to:
  /// **'Khusu'**
  String get homeKhusuQuickEntryShort;

  /// No description provided for @homeFastingNotFasting.
  ///
  /// In en, this message translates to:
  /// **'Not fasting'**
  String get homeFastingNotFasting;

  /// No description provided for @homeFastingIntending.
  ///
  /// In en, this message translates to:
  /// **'Intending to fast'**
  String get homeFastingIntending;

  /// No description provided for @homeFastingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeFastingCompleted;

  /// No description provided for @homeFastingBroken.
  ///
  /// In en, this message translates to:
  /// **'Missed / Broken'**
  String get homeFastingBroken;

  /// No description provided for @homeLearnSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Summary'**
  String get homeLearnSummaryTitle;

  /// No description provided for @homeLearnSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your knowledge path with focused previews.'**
  String get homeLearnSummarySubtitle;

  /// No description provided for @homeLearnContinueQuran.
  ///
  /// In en, this message translates to:
  /// **'Continue Quran'**
  String get homeLearnContinueQuran;

  /// No description provided for @homeLearnContinueQuranValue.
  ///
  /// In en, this message translates to:
  /// **'Resume last reading'**
  String get homeLearnContinueQuranValue;

  /// No description provided for @homeLearnFeaturedLife.
  ///
  /// In en, this message translates to:
  /// **'Featured Life topic'**
  String get homeLearnFeaturedLife;

  /// No description provided for @homeLearnFeaturedLifeValue.
  ///
  /// In en, this message translates to:
  /// **'Patience'**
  String get homeLearnFeaturedLifeValue;

  /// No description provided for @homeLearnFeaturedWorld.
  ///
  /// In en, this message translates to:
  /// **'Featured World topic'**
  String get homeLearnFeaturedWorld;

  /// No description provided for @homeLearnFeaturedWorldValue.
  ///
  /// In en, this message translates to:
  /// **'Mountains'**
  String get homeLearnFeaturedWorldValue;

  /// No description provided for @homeLearnFeaturedHadith.
  ///
  /// In en, this message translates to:
  /// **'Featured Hadith topic'**
  String get homeLearnFeaturedHadith;

  /// No description provided for @homeLearnFeaturedHadithValue.
  ///
  /// In en, this message translates to:
  /// **'Character and Manners'**
  String get homeLearnFeaturedHadithValue;

  /// No description provided for @homeLearnResumeNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes and reflection'**
  String get homeLearnResumeNotes;

  /// No description provided for @homeLearnResumeNotesValue.
  ///
  /// In en, this message translates to:
  /// **'Resume your latest note'**
  String get homeLearnResumeNotesValue;

  /// No description provided for @homeJourneySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Journey Summary'**
  String get homeJourneySummaryTitle;

  /// No description provided for @homeJourneySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track progression, rings, and next unlocks.'**
  String get homeJourneySummarySubtitle;

  /// No description provided for @homeJourneyXpProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'XP progress'**
  String get homeJourneyXpProgressTitle;

  /// No description provided for @homeJourneyDailyRingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily rings'**
  String get homeJourneyDailyRingsTitle;

  /// No description provided for @homeJourneyNextUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Next unlock'**
  String get homeJourneyNextUnlockTitle;

  /// No description provided for @homeJourneyNextUnlockValue.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper reward preview'**
  String get homeJourneyNextUnlockValue;

  /// No description provided for @homeQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActionsTitle;

  /// No description provided for @homeQuickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jump into your core sections quickly.'**
  String get homeQuickActionsSubtitle;

  /// No description provided for @homeReflectionReminder.
  ///
  /// In en, this message translates to:
  /// **'\"Return softly to your intention. Small sincere acts build lasting light.\"'**
  String get homeReflectionReminder;

  /// No description provided for @homeWelcomeDailyIntentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Intention'**
  String get homeWelcomeDailyIntentionTitle;

  /// No description provided for @homeWelcomeDailyIntentionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start the day with gentle focus, reflection, and consistency.'**
  String get homeWelcomeDailyIntentionSubtitle;

  /// No description provided for @homeWelcomePrayerRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Rhythm'**
  String get homeWelcomePrayerRhythmTitle;

  /// No description provided for @homeWelcomePrayerRhythmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'\'s next salah and guidance are synced and visible below.'**
  String get homeWelcomePrayerRhythmSubtitle;

  /// No description provided for @homeWelcomeDhikrQuietTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr and Quiet'**
  String get homeWelcomeDhikrQuietTitle;

  /// No description provided for @homeWelcomeDhikrQuietSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose calm moments to track reminders and intention.'**
  String get homeWelcomeDhikrQuietSubtitle;

  /// No description provided for @homeLocationPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Use location while using app?'**
  String get homeLocationPromptTitle;

  /// No description provided for @homeLocationPromptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable foreground location for accurate prayer times.'**
  String get homeLocationPromptSubtitle;

  /// No description provided for @homeLocationEnabledWhileUsing.
  ///
  /// In en, this message translates to:
  /// **'Location access is enabled while you use the app.'**
  String get homeLocationEnabledWhileUsing;

  /// No description provided for @homeLocationAllowWhileUsingForPrayer.
  ///
  /// In en, this message translates to:
  /// **'Allow location only while using the app for accurate prayer times.'**
  String get homeLocationAllowWhileUsingForPrayer;

  /// No description provided for @homeLocationBlockedOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Location access is blocked. Open settings to enable while using app.'**
  String get homeLocationBlockedOpenSettings;

  /// No description provided for @homeLocationStatusCanUpdate.
  ///
  /// In en, this message translates to:
  /// **'Location permission status can be updated anytime.'**
  String get homeLocationStatusCanUpdate;

  /// No description provided for @homeSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search the app'**
  String get homeSearchTooltip;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search pages, features, and sections'**
  String get homeSearchHint;

  /// No description provided for @homeSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching section found.'**
  String get homeSearchNoResults;

  /// No description provided for @homeSearchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get homeSearchClearTooltip;

  /// No description provided for @homeSearchCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get homeSearchCloseTooltip;

  /// No description provided for @homeTapVerseCardHint.
  ///
  /// In en, this message translates to:
  /// **'Tap this card to change verse'**
  String get homeTapVerseCardHint;

  /// No description provided for @prayerHistory.
  ///
  /// In en, this message translates to:
  /// **'Prayer history'**
  String get prayerHistory;

  /// No description provided for @missedReminder.
  ///
  /// In en, this message translates to:
  /// **'Missed reminder'**
  String get missedReminder;

  /// No description provided for @gentleSchedule.
  ///
  /// In en, this message translates to:
  /// **'Gentle schedule'**
  String get gentleSchedule;

  /// No description provided for @start33Recitation.
  ///
  /// In en, this message translates to:
  /// **'Start 33 recitation'**
  String get start33Recitation;

  /// No description provided for @resumeWhereLeft.
  ///
  /// In en, this message translates to:
  /// **'Resume where left'**
  String get resumeWhereLeft;

  /// No description provided for @reflectionQuote.
  ///
  /// In en, this message translates to:
  /// **'\"One sincere reminder can outweigh many scattered efforts.\"'**
  String get reflectionQuote;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// No description provided for @prayersCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayers completed'**
  String get prayersCompletedLabel;

  /// No description provided for @dhikrSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Dhikr sessions'**
  String get dhikrSessionsLabel;

  /// No description provided for @oneToday.
  ///
  /// In en, this message translates to:
  /// **'1 today'**
  String get oneToday;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get sevenDays;

  /// No description provided for @worshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Worship'**
  String get worshipTitle;

  /// No description provided for @worshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily acts of devotion centered into a calm, intentional flow.'**
  String get worshipSubtitle;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// No description provided for @learnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A focused knowledge path for reflection and deeper understanding.'**
  String get learnSubtitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get journeyTitle;

  /// No description provided for @journeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Long-term growth, light by light.'**
  String get journeySubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Intention, preferences, and personalization.'**
  String get profileSubtitle;

  /// No description provided for @profileQuoteTranslation.
  ///
  /// In en, this message translates to:
  /// **'Whoever is mindful of الله is guided toward balance and intention.'**
  String get profileQuoteTranslation;

  /// No description provided for @profileSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your intention steady and your settings aligned with ease.'**
  String get profileSummarySubtitle;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileAddressMeAs.
  ///
  /// In en, this message translates to:
  /// **'Address me as:'**
  String get profileAddressMeAs;

  /// No description provided for @profileBrother.
  ///
  /// In en, this message translates to:
  /// **'Brother'**
  String get profileBrother;

  /// No description provided for @profileSister.
  ///
  /// In en, this message translates to:
  /// **'Sister'**
  String get profileSister;

  /// No description provided for @profilePrayerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Prayer Time Settings'**
  String get profilePrayerSettingsTitle;

  /// No description provided for @profilePrayerSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set location and calculation preferences.'**
  String get profilePrayerSettingsSubtitle;

  /// No description provided for @profileLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileLocationLabel;

  /// No description provided for @profileMadhabLabel.
  ///
  /// In en, this message translates to:
  /// **'Madhab'**
  String get profileMadhabLabel;

  /// No description provided for @profileCalculationMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayer calculation method'**
  String get profileCalculationMethodLabel;

  /// No description provided for @profileAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearanceTitle;

  /// No description provided for @profileAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visual and atmosphere preferences.'**
  String get profileAppearanceSubtitle;

  /// No description provided for @profileThemeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get profileThemeModeLabel;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion effects'**
  String get profileReduceMotion;

  /// No description provided for @profileHighContrastText.
  ///
  /// In en, this message translates to:
  /// **'High contrast text'**
  String get profileHighContrastText;

  /// No description provided for @profileModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modes'**
  String get profileModesTitle;

  /// No description provided for @profileModesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mode presets to support focus and consistency.'**
  String get profileModesSubtitle;

  /// No description provided for @profileRamadanModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mode'**
  String get profileRamadanModeTitle;

  /// No description provided for @profileRamadanModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prioritize fasting rhythm and devotional consistency.'**
  String get profileRamadanModeSubtitle;

  /// No description provided for @profileLossModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Loss Mode'**
  String get profileLossModeTitle;

  /// No description provided for @profileLossModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle structure for spiritually heavy days.'**
  String get profileLossModeSubtitle;

  /// No description provided for @profileGentleModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle Mode'**
  String get profileGentleModeTitle;

  /// No description provided for @profileGentleModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lighter reminders and softer daily expectations.'**
  String get profileGentleModeSubtitle;

  /// No description provided for @profileTrackingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking & Privacy'**
  String get profileTrackingPrivacyTitle;

  /// No description provided for @profileTrackingPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Controls for reminders, summaries, and data intent.'**
  String get profileTrackingPrivacySubtitle;

  /// No description provided for @profileLocationWhileUsingApp.
  ///
  /// In en, this message translates to:
  /// **'Location while using app'**
  String get profileLocationWhileUsingApp;

  /// No description provided for @profileLocationEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enabled for foreground use only.'**
  String get profileLocationEnabledSubtitle;

  /// No description provided for @profileLocationDisabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to keep prayer times accurate.'**
  String get profileLocationDisabledSubtitle;

  /// No description provided for @profileOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get profileOpenSettings;

  /// No description provided for @profileAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get profileAllow;

  /// No description provided for @profilePrivateTrackingModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Private tracking mode'**
  String get profilePrivateTrackingModeTitle;

  /// No description provided for @profilePrivateTrackingModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep progress visible only on this device.'**
  String get profilePrivateTrackingModeSubtitle;

  /// No description provided for @profileMinimalTrackingModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimal tracking mode'**
  String get profileMinimalTrackingModeTitle;

  /// No description provided for @profileMinimalTrackingModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track only key essentials with reduced metrics.'**
  String get profileMinimalTrackingModeSubtitle;

  /// No description provided for @profileHideGrowthVisualsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide growth visuals'**
  String get profileHideGrowthVisualsTitle;

  /// No description provided for @profileHideGrowthVisualsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Limit streak and level visuals for a quieter experience.'**
  String get profileHideGrowthVisualsSubtitle;

  /// No description provided for @profileReflectionOnlyModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection-only mode'**
  String get profileReflectionOnlyModeTitle;

  /// No description provided for @profileReflectionOnlyModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prioritize reminders and notes over progress visuals.'**
  String get profileReflectionOnlyModeSubtitle;

  /// No description provided for @profileEntrustDeedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Entrust deeds'**
  String get profileEntrustDeedsTitle;

  /// No description provided for @profileEntrustDeedsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A gentle reminder: sincere deeds are with الله.'**
  String get profileEntrustDeedsSubtitle;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Reminders'**
  String get profileNotificationsTitle;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Placeholder controls for future scheduling.'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profilePrayerReminders.
  ///
  /// In en, this message translates to:
  /// **'Prayer reminders'**
  String get profilePrayerReminders;

  /// No description provided for @profileDhikrReminders.
  ///
  /// In en, this message translates to:
  /// **'Dhikr reminders'**
  String get profileDhikrReminders;

  /// No description provided for @profileQuranReminders.
  ///
  /// In en, this message translates to:
  /// **'Qur\'\'an reminders'**
  String get profileQuranReminders;

  /// No description provided for @profileReflectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reflection reminders'**
  String get profileReflectionReminders;

  /// No description provided for @profileFastingReminders.
  ///
  /// In en, this message translates to:
  /// **'Fasting reminders'**
  String get profileFastingReminders;

  /// No description provided for @profileLanguageExpandTitle.
  ///
  /// In en, this message translates to:
  /// **'Language options'**
  String get profileLanguageExpandTitle;

  /// No description provided for @profileLanguageExpandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select language below'**
  String get profileLanguageExpandSubtitle;

  /// No description provided for @profileAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAboutTitle;

  /// No description provided for @profileAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Product and app information.'**
  String get profileAboutSubtitle;

  /// No description provided for @profileMissionLine.
  ///
  /// In en, this message translates to:
  /// **'A calm spiritual companion built for consistent, sincere growth.'**
  String get profileMissionLine;

  /// No description provided for @profileVersionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Version 0.1.7 (placeholder)'**
  String get profileVersionPlaceholder;

  /// No description provided for @profilePlannedRemindersToday.
  ///
  /// In en, this message translates to:
  /// **'{count} planned reminders today'**
  String profilePlannedRemindersToday(int count);

  /// No description provided for @languageOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language Options'**
  String get languageOptionsTitle;

  /// No description provided for @languageOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language. Persian options include Farsi, Dari, and Tajik.'**
  String get languageOptionsSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @languageMalay.
  ///
  /// In en, this message translates to:
  /// **'Malay'**
  String get languageMalay;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageFarsi.
  ///
  /// In en, this message translates to:
  /// **'Persian (Farsi)'**
  String get languageFarsi;

  /// No description provided for @languageDari.
  ///
  /// In en, this message translates to:
  /// **'Persian (Dari)'**
  String get languageDari;

  /// No description provided for @languageTajik.
  ///
  /// In en, this message translates to:
  /// **'Persian (Tajik)'**
  String get languageTajik;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languagePunjabi.
  ///
  /// In en, this message translates to:
  /// **'Punjabi'**
  String get languagePunjabi;

  /// No description provided for @languageHausa.
  ///
  /// In en, this message translates to:
  /// **'Hausa'**
  String get languageHausa;

  /// No description provided for @languagePashto.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get languagePashto;

  /// No description provided for @languageKurdish.
  ///
  /// In en, this message translates to:
  /// **'Kurdish'**
  String get languageKurdish;

  /// No description provided for @learnTabQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get learnTabQuran;

  /// No description provided for @learnTabLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get learnTabLife;

  /// No description provided for @learnTabWorld.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get learnTabWorld;

  /// No description provided for @learnTabHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get learnTabHadith;

  /// No description provided for @learnTabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get learnTabNotes;

  /// No description provided for @learnQuranSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran Hub'**
  String get learnQuranSectionTitle;

  /// No description provided for @learnQuranSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Structured entry points for reading and review.'**
  String get learnQuranSectionSubtitle;

  /// No description provided for @learnQuranContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get learnQuranContinueTitle;

  /// No description provided for @learnQuranContinueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resume your last reading session.'**
  String get learnQuranContinueSubtitle;

  /// No description provided for @learnQuranDailyVerseTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Verse'**
  String get learnQuranDailyVerseTitle;

  /// No description provided for @learnQuranDailyVerseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One verse for today\'\'s reflection.'**
  String get learnQuranDailyVerseSubtitle;

  /// No description provided for @learnQuranExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Surah Explorer'**
  String get learnQuranExplorerTitle;

  /// No description provided for @learnQuranExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse surahs by name and theme.'**
  String get learnQuranExplorerSubtitle;

  /// No description provided for @learnQuranBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get learnQuranBookmarksTitle;

  /// No description provided for @learnQuranBookmarksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Return to your saved ayat quickly.'**
  String get learnQuranBookmarksSubtitle;

  /// No description provided for @learnQuranProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Streak and Progress'**
  String get learnQuranProgressTitle;

  /// No description provided for @learnQuranProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track consistency and growth with balance.'**
  String get learnQuranProgressSubtitle;

  /// No description provided for @learnLifeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Life through the Quran'**
  String get learnLifeSectionTitle;

  /// No description provided for @learnLifeSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practical topics grounded in revelation.'**
  String get learnLifeSectionSubtitle;

  /// No description provided for @learnLifeMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get learnLifeMarriage;

  /// No description provided for @learnLifeParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get learnLifeParents;

  /// No description provided for @learnLifeChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get learnLifeChildren;

  /// No description provided for @learnLifeWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get learnLifeWealth;

  /// No description provided for @learnLifePatience.
  ///
  /// In en, this message translates to:
  /// **'Patience'**
  String get learnLifePatience;

  /// No description provided for @learnLifeJustice.
  ///
  /// In en, this message translates to:
  /// **'Justice'**
  String get learnLifeJustice;

  /// No description provided for @learnLifeCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get learnLifeCharacter;

  /// No description provided for @learnLifeGratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get learnLifeGratitude;

  /// No description provided for @learnWorldSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'World through the Quran'**
  String get learnWorldSectionTitle;

  /// No description provided for @learnWorldSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Creation-focused categories for reflection.'**
  String get learnWorldSectionSubtitle;

  /// No description provided for @learnWorldMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get learnWorldMoon;

  /// No description provided for @learnWorldBees.
  ///
  /// In en, this message translates to:
  /// **'Bees'**
  String get learnWorldBees;

  /// No description provided for @learnWorldMountains.
  ///
  /// In en, this message translates to:
  /// **'Mountains'**
  String get learnWorldMountains;

  /// No description provided for @learnWorldRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get learnWorldRain;

  /// No description provided for @learnWorldOceans.
  ///
  /// In en, this message translates to:
  /// **'Oceans'**
  String get learnWorldOceans;

  /// No description provided for @learnWorldAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get learnWorldAnimals;

  /// No description provided for @learnWorldPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get learnWorldPlants;

  /// No description provided for @learnWorldNightDay.
  ///
  /// In en, this message translates to:
  /// **'Night and Day'**
  String get learnWorldNightDay;

  /// No description provided for @learnHadithSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith Learning'**
  String get learnHadithSectionTitle;

  /// No description provided for @learnHadithSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Companion pathways for applied understanding.'**
  String get learnHadithSectionSubtitle;

  /// No description provided for @learnHadithLifeLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Lessons of Hadith'**
  String get learnHadithLifeLessonsTitle;

  /// No description provided for @learnHadithLifeLessonsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday guidance from authentic narrations.'**
  String get learnHadithLifeLessonsSubtitle;

  /// No description provided for @learnHadithWorldLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'World Lessons through Hadith'**
  String get learnHadithWorldLessonsTitle;

  /// No description provided for @learnHadithWorldLessonsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wider perspective through prophetic insight.'**
  String get learnHadithWorldLessonsSubtitle;

  /// No description provided for @learnHadithCharacterTitle.
  ///
  /// In en, this message translates to:
  /// **'Character and Manners'**
  String get learnHadithCharacterTitle;

  /// No description provided for @learnHadithCharacterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adab, mercy, and conduct foundations.'**
  String get learnHadithCharacterSubtitle;

  /// No description provided for @learnHadithWorshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Worship and Intention'**
  String get learnHadithWorshipTitle;

  /// No description provided for @learnHadithWorshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Actions anchored in sincerity and purpose.'**
  String get learnHadithWorshipSubtitle;

  /// No description provided for @learnHadithFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family and Society'**
  String get learnHadithFamilyTitle;

  /// No description provided for @learnHadithFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Relationships, rights, and social balance.'**
  String get learnHadithFamilySubtitle;

  /// No description provided for @learnNotesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes and Reflection'**
  String get learnNotesSectionTitle;

  /// No description provided for @learnNotesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study captures and personal insight placeholders.'**
  String get learnNotesSectionSubtitle;

  /// No description provided for @learnNotesSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Notes'**
  String get learnNotesSavedTitle;

  /// No description provided for @learnNotesSavedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your authored notes and study snippets.'**
  String get learnNotesSavedSubtitle;

  /// No description provided for @learnNotesReflectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflections'**
  String get learnNotesReflectionsTitle;

  /// No description provided for @learnNotesReflectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Journal-style reflection entries.'**
  String get learnNotesReflectionsSubtitle;

  /// No description provided for @learnNotesHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get learnNotesHighlightsTitle;

  /// No description provided for @learnNotesHighlightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Collected passages and marked excerpts.'**
  String get learnNotesHighlightsSubtitle;

  /// No description provided for @learnNotesContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get learnNotesContinueTitle;

  /// No description provided for @learnNotesContinueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resume your latest learning thread.'**
  String get learnNotesContinueSubtitle;

  /// No description provided for @babyNamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Muslim Baby Names'**
  String get babyNamesTitle;

  /// No description provided for @babyNamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm family naming library with meaning, context, and guidance.'**
  String get babyNamesSubtitle;

  /// No description provided for @babyNamesNameOfDay.
  ///
  /// In en, this message translates to:
  /// **'Name of the Day'**
  String get babyNamesNameOfDay;

  /// No description provided for @babyNamesBrowseSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse & Search'**
  String get babyNamesBrowseSearchTitle;

  /// No description provided for @babyNamesBrowseSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore names by meaning, region, and style.'**
  String get babyNamesBrowseSearchSubtitle;

  /// No description provided for @babyNamesSmartFinderTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Name Finder'**
  String get babyNamesSmartFinderTitle;

  /// No description provided for @babyNamesSmartFinderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get thoughtful suggestions based on family preferences.'**
  String get babyNamesSmartFinderSubtitle;

  /// No description provided for @babyNamesFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites & Shortlist'**
  String get babyNamesFavoritesTitle;

  /// No description provided for @babyNamesFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved names, private notes, and final picks.'**
  String get babyNamesFavoritesSubtitle;

  /// No description provided for @babyNamesCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Names'**
  String get babyNamesCompareTitle;

  /// No description provided for @babyNamesCompareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See key details side by side before deciding.'**
  String get babyNamesCompareSubtitle;

  /// No description provided for @babyNamesOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Library Overview'**
  String get babyNamesOverviewTitle;

  /// No description provided for @babyNamesCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Curated Collections'**
  String get babyNamesCollectionsTitle;

  /// No description provided for @babyNamesBoysLabel.
  ///
  /// In en, this message translates to:
  /// **'Boys'**
  String get babyNamesBoysLabel;

  /// No description provided for @babyNamesGirlsLabel.
  ///
  /// In en, this message translates to:
  /// **'Girls'**
  String get babyNamesGirlsLabel;

  /// No description provided for @babyNamesUnisexLabel.
  ///
  /// In en, this message translates to:
  /// **'Unisex'**
  String get babyNamesUnisexLabel;

  /// No description provided for @babyNamesQuranicLabel.
  ///
  /// In en, this message translates to:
  /// **'Qur’anic'**
  String get babyNamesQuranicLabel;

  /// No description provided for @babyNamesCompanionLabel.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get babyNamesCompanionLabel;

  /// No description provided for @babyNamesSavedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get babyNamesSavedCountLabel;

  /// No description provided for @babyNamesShortlistCountLabel.
  ///
  /// In en, this message translates to:
  /// **'in shortlist'**
  String get babyNamesShortlistCountLabel;

  /// No description provided for @babyNamesSelectedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get babyNamesSelectedCountLabel;

  /// No description provided for @babyNamesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, Arabic, transliteration, meaning, origin, or tags'**
  String get babyNamesSearchHint;

  /// No description provided for @babyNamesFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get babyNamesFiltersTitle;

  /// No description provided for @babyNamesGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get babyNamesGenderLabel;

  /// No description provided for @babyNamesGenderAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get babyNamesGenderAny;

  /// No description provided for @babyNamesRegionFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get babyNamesRegionFilterLabel;

  /// No description provided for @babyNamesOriginFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get babyNamesOriginFilterLabel;

  /// No description provided for @babyNamesRarityLabel.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get babyNamesRarityLabel;

  /// No description provided for @babyNamesQuranicOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qur’anic names only'**
  String get babyNamesQuranicOnlyLabel;

  /// No description provided for @babyNamesCompanionOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Companion names only'**
  String get babyNamesCompanionOnlyLabel;

  /// No description provided for @babyNamesAnyOption.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get babyNamesAnyOption;

  /// No description provided for @babyNamesSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get babyNamesSortLabel;

  /// No description provided for @babyNamesSortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get babyNamesSortAlphabetical;

  /// No description provided for @babyNamesSortPopularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get babyNamesSortPopularity;

  /// No description provided for @babyNamesSortQuranicPriority.
  ///
  /// In en, this message translates to:
  /// **'Qur’anic priority'**
  String get babyNamesSortQuranicPriority;

  /// No description provided for @babyNamesSortShortest.
  ///
  /// In en, this message translates to:
  /// **'Shortest'**
  String get babyNamesSortShortest;

  /// No description provided for @babyNamesSortMostSaved.
  ///
  /// In en, this message translates to:
  /// **'Most saved'**
  String get babyNamesSortMostSaved;

  /// No description provided for @babyNamesClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get babyNamesClearFilters;

  /// No description provided for @babyNamesResultsLabel.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get babyNamesResultsLabel;

  /// No description provided for @babyNamesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No names match this combination yet. Try easing one or two filters.'**
  String get babyNamesNoResults;

  /// No description provided for @babyNamesFavoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get babyNamesFavoriteAction;

  /// No description provided for @babyNamesShortlistAction.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get babyNamesShortlistAction;

  /// No description provided for @babyNamesCompareAction.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get babyNamesCompareAction;

  /// No description provided for @babyNamesOpenCompare.
  ///
  /// In en, this message translates to:
  /// **'Open compare'**
  String get babyNamesOpenCompare;

  /// No description provided for @babyNamesMeaningTags.
  ///
  /// In en, this message translates to:
  /// **'Meaning Tags'**
  String get babyNamesMeaningTags;

  /// No description provided for @babyNamesStyleTags.
  ///
  /// In en, this message translates to:
  /// **'Style Tags'**
  String get babyNamesStyleTags;

  /// No description provided for @babyNamesHistoricalTags.
  ///
  /// In en, this message translates to:
  /// **'Historical Tags'**
  String get babyNamesHistoricalTags;

  /// No description provided for @babyNamesRegionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Common Regions'**
  String get babyNamesRegionsTitle;

  /// No description provided for @babyNamesVariantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Variants & Spellings'**
  String get babyNamesVariantsTitle;

  /// No description provided for @babyNamesQuranicAssociationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Qur’anic Associations'**
  String get babyNamesQuranicAssociationsTitle;

  /// No description provided for @babyNamesHistoricalAssociationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Historical Associations'**
  String get babyNamesHistoricalAssociationsTitle;

  /// No description provided for @babyNamesReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get babyNamesReflectionTitle;

  /// No description provided for @babyNamesPrivateNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Notes'**
  String get babyNamesPrivateNotesTitle;

  /// No description provided for @babyNamesPrivateNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write why this name stands out for your family.'**
  String get babyNamesPrivateNotesHint;

  /// No description provided for @babyNamesSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get babyNamesSaveNote;

  /// No description provided for @babyNamesRelatedNamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Related Names'**
  String get babyNamesRelatedNamesTitle;

  /// No description provided for @babyNamesFatherNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Father name (optional)'**
  String get babyNamesFatherNameLabel;

  /// No description provided for @babyNamesMotherNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Mother name (optional)'**
  String get babyNamesMotherNameLabel;

  /// No description provided for @babyNamesFirstLetterLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred first letter'**
  String get babyNamesFirstLetterLabel;

  /// No description provided for @babyNamesClassicRareLabel.
  ///
  /// In en, this message translates to:
  /// **'Style preference'**
  String get babyNamesClassicRareLabel;

  /// No description provided for @babyNamesClassicRareBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get babyNamesClassicRareBalanced;

  /// No description provided for @babyNamesClassicRareClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get babyNamesClassicRareClassic;

  /// No description provided for @babyNamesClassicRareRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get babyNamesClassicRareRare;

  /// No description provided for @babyNamesEasyEnglishLabel.
  ///
  /// In en, this message translates to:
  /// **'Prefer easy-in-English names'**
  String get babyNamesEasyEnglishLabel;

  /// No description provided for @babyNamesPreferredMeaningTags.
  ///
  /// In en, this message translates to:
  /// **'Preferred meaning themes'**
  String get babyNamesPreferredMeaningTags;

  /// No description provided for @babyNamesSuggestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'suggestions'**
  String get babyNamesSuggestionsLabel;

  /// No description provided for @babyNamesFinderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a few preferences to generate suggestions.'**
  String get babyNamesFinderEmpty;

  /// No description provided for @babyNamesShortlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get babyNamesShortlistTitle;

  /// No description provided for @babyNamesFavoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved names yet. Favorite names from Browse or Detail pages.'**
  String get babyNamesFavoritesEmpty;

  /// No description provided for @babyNamesClearCompare.
  ///
  /// In en, this message translates to:
  /// **'Clear compare'**
  String get babyNamesClearCompare;

  /// No description provided for @babyNamesCompareEmpty.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 names to compare them side by side.'**
  String get babyNamesCompareEmpty;

  /// No description provided for @babyNamesFieldOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get babyNamesFieldOrigin;

  /// No description provided for @babyNamesFieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get babyNamesFieldGender;

  /// No description provided for @babyNamesFieldRoot.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get babyNamesFieldRoot;

  /// No description provided for @babyNamesFieldTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get babyNamesFieldTags;

  /// No description provided for @babyNamesOpenDetails.
  ///
  /// In en, this message translates to:
  /// **'Open details'**
  String get babyNamesOpenDetails;

  /// No description provided for @babyNamesRarityClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get babyNamesRarityClassic;

  /// No description provided for @babyNamesRarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get babyNamesRarityCommon;

  /// No description provided for @babyNamesRarityUncommon.
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get babyNamesRarityUncommon;

  /// No description provided for @babyNamesRarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get babyNamesRarityRare;

  /// No description provided for @journeyLevelSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Level and XP'**
  String get journeyLevelSectionTitle;

  /// No description provided for @journeyLevelSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Long-term growth with steady progression.'**
  String get journeyLevelSectionSubtitle;

  /// No description provided for @journeyLevelValue.
  ///
  /// In en, this message translates to:
  /// **'Level 7'**
  String get journeyLevelValue;

  /// No description provided for @journeyXpValue.
  ///
  /// In en, this message translates to:
  /// **'1620 XP'**
  String get journeyXpValue;

  /// No description provided for @journeyNextLevelText.
  ///
  /// In en, this message translates to:
  /// **'380 XP to next level'**
  String get journeyNextLevelText;

  /// No description provided for @journeyLevelMotivation.
  ///
  /// In en, this message translates to:
  /// **'Consistency builds depth. Small acts keep your journey moving.'**
  String get journeyLevelMotivation;

  /// No description provided for @journeyLightSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Progress'**
  String get journeyLightSectionTitle;

  /// No description provided for @journeyLightSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm visual of accumulated light and effort.'**
  String get journeyLightSectionSubtitle;

  /// No description provided for @journeyLightCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Accumulation'**
  String get journeyLightCardTitle;

  /// No description provided for @journeyLightCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each sincere act adds light over time. Keep it gentle and consistent.'**
  String get journeyLightCardSubtitle;

  /// No description provided for @journeyRingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Rings'**
  String get journeyRingsSectionTitle;

  /// No description provided for @journeyRingsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Five daily focus rings for balanced growth.'**
  String get journeyRingsSectionSubtitle;

  /// No description provided for @journeyRingPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get journeyRingPrayer;

  /// No description provided for @journeyRingDhikr.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get journeyRingDhikr;

  /// No description provided for @journeyRingQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get journeyRingQuran;

  /// No description provided for @journeyRingReflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get journeyRingReflection;

  /// No description provided for @journeyRingFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get journeyRingFasting;

  /// No description provided for @journeyStreakSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get journeyStreakSectionTitle;

  /// No description provided for @journeyStreakSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current and best consistency snapshots.'**
  String get journeyStreakSectionSubtitle;

  /// No description provided for @journeyCurrentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get journeyCurrentStreakLabel;

  /// No description provided for @journeyCurrentStreakValue.
  ///
  /// In en, this message translates to:
  /// **'6 days'**
  String get journeyCurrentStreakValue;

  /// No description provided for @journeyBestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get journeyBestStreakLabel;

  /// No description provided for @journeyBestStreakValue.
  ///
  /// In en, this message translates to:
  /// **'18 days'**
  String get journeyBestStreakValue;

  /// No description provided for @journeyWeeklyConsistencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly consistency'**
  String get journeyWeeklyConsistencyLabel;

  /// No description provided for @journeyMilestoneSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get journeyMilestoneSectionTitle;

  /// No description provided for @journeyMilestoneSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Progress markers for key early achievements.'**
  String get journeyMilestoneSectionSubtitle;

  /// No description provided for @journeyMilestoneFirst7Days.
  ///
  /// In en, this message translates to:
  /// **'First 7 days completed'**
  String get journeyMilestoneFirst7Days;

  /// No description provided for @journeyMilestoneDhikr100.
  ///
  /// In en, this message translates to:
  /// **'100 dhikr completed'**
  String get journeyMilestoneDhikr100;

  /// No description provided for @journeyMilestonePrayerWeek.
  ///
  /// In en, this message translates to:
  /// **'First week of prayer consistency'**
  String get journeyMilestonePrayerWeek;

  /// No description provided for @journeyMilestoneLearningStreak.
  ///
  /// In en, this message translates to:
  /// **'First learning streak achieved'**
  String get journeyMilestoneLearningStreak;

  /// No description provided for @journeyUnlocksSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlocks'**
  String get journeyUnlocksSectionTitle;

  /// No description provided for @journeyUnlocksSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Previews of rewards tied to consistency.'**
  String get journeyUnlocksSectionSubtitle;

  /// No description provided for @journeyUnlockWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper unlock preview'**
  String get journeyUnlockWallpaper;

  /// No description provided for @journeyUnlockReflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection unlock preview'**
  String get journeyUnlockReflection;

  /// No description provided for @journeyUnlockTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme reward preview'**
  String get journeyUnlockTheme;

  /// No description provided for @journeyUnlockFuture.
  ///
  /// In en, this message translates to:
  /// **'Future reward placeholder'**
  String get journeyUnlockFuture;

  /// No description provided for @journeyGrowthSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Garden / Tree / Character Progression'**
  String get journeyGrowthSectionTitle;

  /// No description provided for @journeyGrowthSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A visual reflection of long-term spiritual growth.'**
  String get journeyGrowthSectionSubtitle;

  /// No description provided for @journeyGrowthCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Visual Preview'**
  String get journeyGrowthCardTitle;

  /// No description provided for @journeyGrowthCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your tree, garden, and character progression will evolve as your habits mature.'**
  String get journeyGrowthCardSubtitle;

  /// No description provided for @journeyOceanSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ocean of Drops'**
  String get journeyOceanSectionTitle;

  /// No description provided for @journeyOceanSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A symbolic collective view of accumulated drops.'**
  String get journeyOceanSectionSubtitle;

  /// No description provided for @journeyOceanCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Community-inspired Drops'**
  String get journeyOceanCardTitle;

  /// No description provided for @journeyOceanCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every drop matters. Over time, small drops become a meaningful ocean.'**
  String get journeyOceanCardSubtitle;

  /// No description provided for @quranExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Surah Explorer'**
  String get quranExplorerTitle;

  /// No description provided for @quranExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse surahs and open your reading flow.'**
  String get quranExplorerSubtitle;

  /// No description provided for @quranSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran Search'**
  String get quranSearchTitle;

  /// No description provided for @quranSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find surahs and verses quickly.'**
  String get quranSearchSubtitle;

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by surah, number, or phrase'**
  String get quranSearchHint;

  /// No description provided for @quranAyahsLabel.
  ///
  /// In en, this message translates to:
  /// **'ayahs'**
  String get quranAyahsLabel;

  /// No description provided for @quranBookmarksPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved ayah locations from your reading.'**
  String get quranBookmarksPageSubtitle;

  /// No description provided for @quranBookmarksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet. Save an ayah from the reader.'**
  String get quranBookmarksEmpty;

  /// No description provided for @quranUnknownSurah.
  ///
  /// In en, this message translates to:
  /// **'Unknown surah'**
  String get quranUnknownSurah;

  /// No description provided for @quranRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get quranRemoveBookmark;

  /// No description provided for @quranNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran Notes'**
  String get quranNotesTitle;

  /// No description provided for @quranNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved reflections and highlights.'**
  String get quranNotesSubtitle;

  /// No description provided for @quranNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Add one from the reader.'**
  String get quranNotesEmpty;

  /// No description provided for @quranDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get quranDeleteNote;

  /// No description provided for @quranOpenInReader.
  ///
  /// In en, this message translates to:
  /// **'Open in reader'**
  String get quranOpenInReader;

  /// No description provided for @quranRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get quranRecentSearches;

  /// No description provided for @quranSearchNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent searches yet.'**
  String get quranSearchNoRecent;

  /// No description provided for @quranClearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear recent'**
  String get quranClearRecent;

  /// No description provided for @quranSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matches found. Try a different keyword.'**
  String get quranSearchNoResults;

  /// No description provided for @salahCurrentPrayerBadge.
  ///
  /// In en, this message translates to:
  /// **'Current prayer'**
  String get salahCurrentPrayerBadge;

  /// No description provided for @salahNextPrayerBadge.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get salahNextPrayerBadge;

  /// No description provided for @salahNotificationOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get salahNotificationOff;

  /// No description provided for @worshipPrayerNextPrefix.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get worshipPrayerNextPrefix;

  /// No description provided for @worshipPrayerUpcomingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get worshipPrayerUpcomingPrefix;

  /// No description provided for @quranReaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read and reflect verse by verse.'**
  String get quranReaderSubtitle;

  /// No description provided for @quranTranslationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get quranTranslationLabel;

  /// No description provided for @quranUpdatedContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading was updated.'**
  String get quranUpdatedContinueReading;

  /// No description provided for @quranAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get quranAddNote;

  /// No description provided for @quranNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short reflection'**
  String get quranNoteHint;

  /// No description provided for @quranCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get quranCancel;

  /// No description provided for @quranSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get quranSave;

  /// No description provided for @quranBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get quranBookmark;

  /// No description provided for @quranSetContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Set as continue reading'**
  String get quranSetContinueReading;

  /// No description provided for @quranTapToResume.
  ///
  /// In en, this message translates to:
  /// **'Tap to resume'**
  String get quranTapToResume;

  /// No description provided for @quranSavedLocations.
  ///
  /// In en, this message translates to:
  /// **'saved locations'**
  String get quranSavedLocations;

  /// No description provided for @quranNotesHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes and Highlights'**
  String get quranNotesHighlightsTitle;

  /// No description provided for @quranSavedNotes.
  ///
  /// In en, this message translates to:
  /// **'saved notes'**
  String get quranSavedNotes;

  /// No description provided for @quranConsistencyNote.
  ///
  /// In en, this message translates to:
  /// **'Consistency in reading'**
  String get quranConsistencyNote;

  /// No description provided for @modeRamadanHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Focus'**
  String get modeRamadanHomeTitle;

  /// No description provided for @modeRamadanHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Center today on fasting, Quran, and gentle reflection.'**
  String get modeRamadanHomeSubtitle;

  /// No description provided for @modeRamadanActionFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get modeRamadanActionFasting;

  /// No description provided for @modeRamadanActionQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get modeRamadanActionQuran;

  /// No description provided for @modeRamadanActionReflect.
  ///
  /// In en, this message translates to:
  /// **'Reflect'**
  String get modeRamadanActionReflect;

  /// No description provided for @modeLossHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Loss Support'**
  String get modeLossHomeTitle;

  /// No description provided for @modeLossHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move softly today with remembrance, patience, and mercy.'**
  String get modeLossHomeSubtitle;

  /// No description provided for @modeLossActionDhikr.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get modeLossActionDhikr;

  /// No description provided for @modeLossActionKhusu.
  ///
  /// In en, this message translates to:
  /// **'Khusu'**
  String get modeLossActionKhusu;

  /// No description provided for @modeLossActionMercy.
  ///
  /// In en, this message translates to:
  /// **'Mercy Verses'**
  String get modeLossActionMercy;

  /// No description provided for @modeGentleHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle Mode Active'**
  String get modeGentleHomeTitle;

  /// No description provided for @modeGentleHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep one sincere step at a time and avoid pressure.'**
  String get modeGentleHomeSubtitle;

  /// No description provided for @modeGentleActionOneStep.
  ///
  /// In en, this message translates to:
  /// **'One Step'**
  String get modeGentleActionOneStep;

  /// No description provided for @modeGentleActionReflect.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get modeGentleActionReflect;

  /// No description provided for @modeRamadanWorshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Worship Focus'**
  String get modeRamadanWorshipTitle;

  /// No description provided for @modeRamadanWorshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fasting and nightly worship are highlighted for this season.'**
  String get modeRamadanWorshipSubtitle;

  /// No description provided for @modeRamadanWorshipTaraweeh.
  ///
  /// In en, this message translates to:
  /// **'Taraweeh'**
  String get modeRamadanWorshipTaraweeh;

  /// No description provided for @modeRamadanWorshipQiyam.
  ///
  /// In en, this message translates to:
  /// **'Qiyam'**
  String get modeRamadanWorshipQiyam;

  /// No description provided for @modeLossWorshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus on simple remembrance and compassionate consistency.'**
  String get modeLossWorshipSubtitle;

  /// No description provided for @modeGentleWorshipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep worship steady and light, with mercy toward yourself.'**
  String get modeGentleWorshipSubtitle;

  /// No description provided for @modeRamadanLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Learning'**
  String get modeRamadanLearnTitle;

  /// No description provided for @modeRamadanLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prioritize Quran recitation and short reflection sessions.'**
  String get modeRamadanLearnSubtitle;

  /// No description provided for @modeLossLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Supportive Learning'**
  String get modeLossLearnTitle;

  /// No description provided for @modeLossLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose healing reminders, mercy verses, and soft reflection.'**
  String get modeLossLearnSubtitle;

  /// No description provided for @modeGentleLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle Learning'**
  String get modeGentleLearnTitle;

  /// No description provided for @modeGentleLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep learning concise and consistent without overload.'**
  String get modeGentleLearnSubtitle;

  /// No description provided for @modeRamadanJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Season Progress'**
  String get modeRamadanJourneyTitle;

  /// No description provided for @modeRamadanJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track intention, fasting rhythm, and nightly consistency.'**
  String get modeRamadanJourneySubtitle;

  /// No description provided for @modeLossJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Compassionate Journey'**
  String get modeLossJourneyTitle;

  /// No description provided for @modeLossJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Growth is measured gently through patience and remembrance.'**
  String get modeLossJourneySubtitle;

  /// No description provided for @modeGentleJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle Journey'**
  String get modeGentleJourneyTitle;

  /// No description provided for @modeGentleJourneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce pressure and focus on calm consistency.'**
  String get modeGentleJourneySubtitle;

  /// No description provided for @profileRamadanDateRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Ramadan date range'**
  String get profileRamadanDateRangeTitle;

  /// No description provided for @profileRamadanStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get profileRamadanStartDate;

  /// No description provided for @profileRamadanEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get profileRamadanEndDate;

  /// No description provided for @profileRamadanDateWindowActive.
  ///
  /// In en, this message translates to:
  /// **'Today falls inside your Ramadan date window.'**
  String get profileRamadanDateWindowActive;

  /// No description provided for @profileRamadanDateWindowInactive.
  ///
  /// In en, this message translates to:
  /// **'Today is outside your Ramadan date window.'**
  String get profileRamadanDateWindowInactive;

  /// No description provided for @profileRamadanSetDates.
  ///
  /// In en, this message translates to:
  /// **'Set dates'**
  String get profileRamadanSetDates;

  /// No description provided for @profileRamadanClearDates.
  ///
  /// In en, this message translates to:
  /// **'Clear dates'**
  String get profileRamadanClearDates;

  /// No description provided for @learnContentTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get learnContentTopicLabel;

  /// No description provided for @learnContentUnavailableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This topic is not available yet.'**
  String get learnContentUnavailableSubtitle;

  /// No description provided for @learnContentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Content not found.'**
  String get learnContentNotFound;

  /// No description provided for @learnContentOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get learnContentOverviewTitle;

  /// No description provided for @learnContentThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Key themes'**
  String get learnContentThemesTitle;

  /// No description provided for @learnContentReferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Related references'**
  String get learnContentReferencesTitle;

  /// No description provided for @learnContentReflectionPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection prompt'**
  String get learnContentReflectionPromptTitle;

  /// No description provided for @learnContentRelatedTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related topics'**
  String get learnContentRelatedTopicsTitle;

  /// No description provided for @learnContentContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get learnContentContinueTitle;

  /// No description provided for @learnContentPathComplete.
  ///
  /// In en, this message translates to:
  /// **'You reached the end of this staged path.'**
  String get learnContentPathComplete;

  /// No description provided for @learnContentPathContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to the next related topic.'**
  String get learnContentPathContinue;

  /// No description provided for @lifeProgressOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Life curriculum progress'**
  String get lifeProgressOverviewTitle;

  /// No description provided for @lifeProgressOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'{completed} completed of {total} lessons, with {inProgress} in progress.'**
  String lifeProgressOverviewBody(int completed, int total, int inProgress);

  /// No description provided for @lifeContinueLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get lifeContinueLearningTitle;

  /// No description provided for @lifeFeaturedLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured lesson'**
  String get lifeFeaturedLessonTitle;

  /// No description provided for @lifeSuggestedNextLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested next lesson'**
  String get lifeSuggestedNextLessonTitle;

  /// No description provided for @lifeSuggestedPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested learning path'**
  String get lifeSuggestedPathTitle;

  /// No description provided for @lifeBrowseByThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by theme'**
  String get lifeBrowseByThemeTitle;

  /// No description provided for @lifeRecentOpenedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently opened'**
  String get lifeRecentOpenedTitle;

  /// No description provided for @lifeThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Major theme'**
  String get lifeThemeLabel;

  /// No description provided for @lifeSubcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get lifeSubcategoryLabel;

  /// No description provided for @lifeQuranicPerspectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Qur\'\'anic perspective'**
  String get lifeQuranicPerspectiveTitle;

  /// No description provided for @lifePracticalTakeawayTitle.
  ///
  /// In en, this message translates to:
  /// **'Practical life takeaway'**
  String get lifePracticalTakeawayTitle;

  /// No description provided for @lifeComparativeTeachingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related teachings in other traditions'**
  String get lifeComparativeTeachingsTitle;

  /// No description provided for @lifeMarkInProgress.
  ///
  /// In en, this message translates to:
  /// **'Mark in progress'**
  String get lifeMarkInProgress;

  /// No description provided for @lifeMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get lifeMarkCompleted;

  /// No description provided for @lifeAddReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a reflection'**
  String get lifeAddReflectionTitle;

  /// No description provided for @lifeAddReflectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture what stood out to you from this lesson.'**
  String get lifeAddReflectionSubtitle;

  /// No description provided for @lifeStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Status: not started'**
  String get lifeStatusNotStarted;

  /// No description provided for @lifeStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'Status: in progress'**
  String get lifeStatusInProgress;

  /// No description provided for @lifeStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Status: completed'**
  String get lifeStatusCompleted;

  /// No description provided for @lifeSubcategoryProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String lifeSubcategoryProgress(int completed, int total);

  /// No description provided for @lifeLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lifeLessonsTitle;

  /// No description provided for @lifeThemeWhyMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this theme matters'**
  String get lifeThemeWhyMattersTitle;

  /// No description provided for @lifeThemeProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed in this theme'**
  String lifeThemeProgress(int completed, int total);

  /// No description provided for @lifeThemeNextSubcategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended next subcategory'**
  String get lifeThemeNextSubcategoryTitle;

  /// No description provided for @lifeSubcategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Subcategories'**
  String get lifeSubcategoriesTitle;

  /// No description provided for @worldProgressOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'World curriculum progress'**
  String get worldProgressOverviewTitle;

  /// No description provided for @worldProgressOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'{completed} completed of {total} lessons, with {inProgress} in progress.'**
  String worldProgressOverviewBody(int completed, int total, int inProgress);

  /// No description provided for @worldContinueLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get worldContinueLearningTitle;

  /// No description provided for @worldFeaturedLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured lesson'**
  String get worldFeaturedLessonTitle;

  /// No description provided for @worldSuggestedNextLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested next lesson'**
  String get worldSuggestedNextLessonTitle;

  /// No description provided for @worldSuggestedPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested learning path'**
  String get worldSuggestedPathTitle;

  /// No description provided for @worldBrowseByThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by theme'**
  String get worldBrowseByThemeTitle;

  /// No description provided for @worldRecentOpenedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently opened'**
  String get worldRecentOpenedTitle;

  /// No description provided for @worldThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Major theme'**
  String get worldThemeLabel;

  /// No description provided for @worldSubcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get worldSubcategoryLabel;

  /// No description provided for @worldQuranicPerspectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Qur\'\'anic perspective'**
  String get worldQuranicPerspectiveTitle;

  /// No description provided for @worldReflectiveTakeawayTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflective takeaway'**
  String get worldReflectiveTakeawayTitle;

  /// No description provided for @worldPracticalTakeawayTitle.
  ///
  /// In en, this message translates to:
  /// **'Practical takeaway'**
  String get worldPracticalTakeawayTitle;

  /// No description provided for @worldObservationPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Observation prompt'**
  String get worldObservationPromptTitle;

  /// No description provided for @worldComparativeTeachingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related teachings in other traditions'**
  String get worldComparativeTeachingsTitle;

  /// No description provided for @worldMarkInProgress.
  ///
  /// In en, this message translates to:
  /// **'Mark in progress'**
  String get worldMarkInProgress;

  /// No description provided for @worldMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get worldMarkCompleted;

  /// No description provided for @worldAddReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a reflection'**
  String get worldAddReflectionTitle;

  /// No description provided for @worldAddReflectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture what this sign in creation stirred in you.'**
  String get worldAddReflectionSubtitle;

  /// No description provided for @worldObservationCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Record an observation'**
  String get worldObservationCtaTitle;

  /// No description provided for @worldObservationCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a journal entry with optional photo reference.'**
  String get worldObservationCtaSubtitle;

  /// No description provided for @worldStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Status: not started'**
  String get worldStatusNotStarted;

  /// No description provided for @worldStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'Status: in progress'**
  String get worldStatusInProgress;

  /// No description provided for @worldStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Status: completed'**
  String get worldStatusCompleted;

  /// No description provided for @worldSubcategoryProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String worldSubcategoryProgress(int completed, int total);

  /// No description provided for @worldLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get worldLessonsTitle;

  /// No description provided for @worldThemeWhyMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this theme matters'**
  String get worldThemeWhyMattersTitle;

  /// No description provided for @worldThemeProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed in this theme'**
  String worldThemeProgress(int completed, int total);

  /// No description provided for @worldThemeNextSubcategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended next subcategory'**
  String get worldThemeNextSubcategoryTitle;

  /// No description provided for @worldSubcategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Subcategories'**
  String get worldSubcategoriesTitle;

  /// No description provided for @quranTranslationSahih.
  ///
  /// In en, this message translates to:
  /// **'Sahih International'**
  String get quranTranslationSahih;

  /// No description provided for @quranTranslationPickthallPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Pickthall (placeholder)'**
  String get quranTranslationPickthallPlaceholder;

  /// No description provided for @quranTranslationClearQuran.
  ///
  /// In en, this message translates to:
  /// **'The Clear Quran'**
  String get quranTranslationClearQuran;

  /// No description provided for @quranTranslationUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu Translation'**
  String get quranTranslationUrdu;

  /// No description provided for @quranTranslationBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali Translation'**
  String get quranTranslationBengali;

  /// No description provided for @quranTranslationIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian Translation'**
  String get quranTranslationIndonesian;

  /// No description provided for @quranTranslationTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish Translation'**
  String get quranTranslationTurkish;

  /// No description provided for @quranTranslationDari.
  ///
  /// In en, this message translates to:
  /// **'Dari Translation'**
  String get quranTranslationDari;

  /// No description provided for @quranShowTransliteration.
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get quranShowTransliteration;

  /// No description provided for @quranShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation text'**
  String get quranShowTranslation;

  /// No description provided for @quranWordTranslationChip.
  ///
  /// In en, this message translates to:
  /// **'Word by Word Translation'**
  String get quranWordTranslationChip;

  /// No description provided for @quranAudioV2Title.
  ///
  /// In en, this message translates to:
  /// **'Audio v2'**
  String get quranAudioV2Title;

  /// No description provided for @quranRepeatFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat from'**
  String get quranRepeatFromLabel;

  /// No description provided for @quranRepeatToLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat to'**
  String get quranRepeatToLabel;

  /// No description provided for @quranNoneLabel.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get quranNoneLabel;

  /// No description provided for @quranAyahNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Ayah {ayah}'**
  String quranAyahNumberLabel(int ayah);

  /// No description provided for @quranLoopCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Loop count'**
  String get quranLoopCountLabel;

  /// No description provided for @quranPlayLoopLabel.
  ///
  /// In en, this message translates to:
  /// **'Play loop'**
  String get quranPlayLoopLabel;

  /// No description provided for @quranLoopRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Set both range edges to enable loop playback.'**
  String get quranLoopRangeHint;

  /// No description provided for @quranMemorizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Memorization (Hifz)'**
  String get quranMemorizationTitle;

  /// No description provided for @quranHifzRevealModeFull.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get quranHifzRevealModeFull;

  /// No description provided for @quranHifzRevealModeFirstWord.
  ///
  /// In en, this message translates to:
  /// **'First word'**
  String get quranHifzRevealModeFirstWord;

  /// No description provided for @quranHifzRevealModeHidden.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get quranHifzRevealModeHidden;

  /// No description provided for @quranDailyRevisionPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily revision plan ({count} ayahs)'**
  String quranDailyRevisionPlanLabel(int count);

  /// No description provided for @quranDailyRevisionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No checkpoints yet. Add one while reviewing ayahs.'**
  String get quranDailyRevisionEmpty;

  /// No description provided for @quranOpenReviewDeckLabel.
  ///
  /// In en, this message translates to:
  /// **'Open review deck ({count})'**
  String quranOpenReviewDeckLabel(int count);

  /// No description provided for @quranPinForReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Pin for review'**
  String get quranPinForReviewLabel;

  /// No description provided for @quranUnpinWordLabel.
  ///
  /// In en, this message translates to:
  /// **'Unpin word'**
  String get quranUnpinWordLabel;

  /// No description provided for @quranPlayAyahTooltip.
  ///
  /// In en, this message translates to:
  /// **'Play ayah'**
  String get quranPlayAyahTooltip;

  /// No description provided for @quranHifzCheckpointTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hifz checkpoint'**
  String get quranHifzCheckpointTooltip;

  /// No description provided for @quranNotesFoldersTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Folders and tags'**
  String get quranNotesFoldersTagsTitle;

  /// No description provided for @quranNotesFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get quranNotesFolderLabel;

  /// No description provided for @quranNotesTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get quranNotesTagLabel;

  /// No description provided for @quranNotesFolderHint.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get quranNotesFolderHint;

  /// No description provided for @quranNotesFolderDefault.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get quranNotesFolderDefault;

  /// No description provided for @quranNotesTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get quranNotesTagsLabel;

  /// No description provided for @quranNotesTagsHint.
  ///
  /// In en, this message translates to:
  /// **'gratitude, dua, patience'**
  String get quranNotesTagsHint;

  /// No description provided for @quranSaveAsHighlightLabel.
  ///
  /// In en, this message translates to:
  /// **'Save as highlight'**
  String get quranSaveAsHighlightLabel;

  /// No description provided for @quranHighlightLabelInput.
  ///
  /// In en, this message translates to:
  /// **'Highlight label'**
  String get quranHighlightLabelInput;

  /// No description provided for @quranHighlightHint.
  ///
  /// In en, this message translates to:
  /// **'Key reminder'**
  String get quranHighlightHint;

  /// No description provided for @quranHighlightLabel.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get quranHighlightLabel;

  /// No description provided for @quranUnknownDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get quranUnknownDateLabel;

  /// No description provided for @quranTopWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran Top Words'**
  String get quranTopWordsTitle;

  /// No description provided for @quranTopWordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study frequent Quran vocabulary with transliteration and meaning.'**
  String get quranTopWordsSubtitle;

  /// No description provided for @quranWordReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Word Review Deck'**
  String get quranWordReviewTitle;

  /// No description provided for @quranWordReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pin words from reader word-by-word mode to study here.'**
  String get quranWordReviewSubtitle;

  /// No description provided for @quranWordReviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pinned words yet. Open any ayah, tap a word, and pin it first.'**
  String get quranWordReviewEmpty;

  /// No description provided for @quranWordReviewProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} pinned words'**
  String quranWordReviewProgressLabel(int current, int total);

  /// No description provided for @quranWordReviewRevealHint.
  ///
  /// In en, this message translates to:
  /// **'Tap reveal to check transliteration and meaning.'**
  String get quranWordReviewRevealHint;

  /// No description provided for @quranWordReviewHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get quranWordReviewHide;

  /// No description provided for @quranWordReviewReveal.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get quranWordReviewReveal;

  /// No description provided for @quranWordReviewAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get quranWordReviewAgain;

  /// No description provided for @quranWordReviewEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get quranWordReviewEasy;

  /// No description provided for @quranWordReviewHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} pinned words • review and strengthen recall.'**
  String quranWordReviewHubSubtitle(int count);

  /// No description provided for @quranNamesOfAllahTitle.
  ///
  /// In en, this message translates to:
  /// **'99 Names of الله'**
  String get quranNamesOfAllahTitle;

  /// No description provided for @quranNamesOfAllahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn each name in Arabic with transliteration and meaning.'**
  String get quranNamesOfAllahSubtitle;

  /// No description provided for @quranCleanReadingMode.
  ///
  /// In en, this message translates to:
  /// **'Clean mode'**
  String get quranCleanReadingMode;

  /// No description provided for @quranArabicTextSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic size'**
  String get quranArabicTextSize;

  /// No description provided for @quranTranslationTextSize.
  ///
  /// In en, this message translates to:
  /// **'Translation size'**
  String get quranTranslationTextSize;

  /// No description provided for @oceanTitle.
  ///
  /// In en, this message translates to:
  /// **'Ocean of Drops'**
  String get oceanTitle;

  /// No description provided for @oceanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your local drops and symbolic contribution journey.'**
  String get oceanSubtitle;

  /// No description provided for @oceanLocalDropsLabel.
  ///
  /// In en, this message translates to:
  /// **'Local drops'**
  String get oceanLocalDropsLabel;

  /// No description provided for @oceanTodayDropsLabel.
  ///
  /// In en, this message translates to:
  /// **'Drops today'**
  String get oceanTodayDropsLabel;

  /// No description provided for @oceanWeekDropsLabel.
  ///
  /// In en, this message translates to:
  /// **'Drops this week'**
  String get oceanWeekDropsLabel;

  /// No description provided for @oceanSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop sources'**
  String get oceanSourcesTitle;

  /// No description provided for @oceanNoSourceData.
  ///
  /// In en, this message translates to:
  /// **'No source data yet. Complete daily actions to add drops.'**
  String get oceanNoSourceData;

  /// No description provided for @oceanSourcePrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer completion'**
  String get oceanSourcePrayer;

  /// No description provided for @oceanSourceDhikr.
  ///
  /// In en, this message translates to:
  /// **'Dhikr sessions'**
  String get oceanSourceDhikr;

  /// No description provided for @oceanSourceFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting completion'**
  String get oceanSourceFasting;

  /// No description provided for @oceanSourceQuran.
  ///
  /// In en, this message translates to:
  /// **'Qur\'\'an engagement'**
  String get oceanSourceQuran;

  /// No description provided for @oceanSourceReflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection / journal'**
  String get oceanSourceReflection;

  /// No description provided for @oceanSourceLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning engagement'**
  String get oceanSourceLearning;

  /// No description provided for @oceanSourceMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone / unlock'**
  String get oceanSourceMilestone;

  /// No description provided for @oceanOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Open Ocean'**
  String get oceanOpenPage;

  /// No description provided for @oceanCommunityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Community ocean placeholder: {count} drops'**
  String oceanCommunityPlaceholder(int count);

  /// No description provided for @wallpaperLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper Library'**
  String get wallpaperLibraryTitle;

  /// No description provided for @wallpaperLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock and select wallpapers through growth.'**
  String get wallpaperLibrarySubtitle;

  /// No description provided for @wallpaperSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get wallpaperSelected;

  /// No description provided for @wallpaperApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get wallpaperApply;

  /// No description provided for @kidsModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Kids Mode'**
  String get kidsModeTitle;

  /// No description provided for @kidsModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simpler wording and gentler guidance for younger users.'**
  String get kidsModeSubtitle;

  /// No description provided for @kidsHomeHint.
  ///
  /// In en, this message translates to:
  /// **'Kids mode is active with simpler guidance and gentle next steps.'**
  String get kidsHomeHint;

  /// No description provided for @kidsHomeReflectionHint.
  ///
  /// In en, this message translates to:
  /// **'\"Small kind actions shine brightly. What is one good thing from today?\"'**
  String get kidsHomeReflectionHint;

  /// No description provided for @kidsWorshipHint.
  ///
  /// In en, this message translates to:
  /// **'Kids mode: focus on simple steps and calm consistency.'**
  String get kidsWorshipHint;

  /// No description provided for @kidsLearnHint.
  ///
  /// In en, this message translates to:
  /// **'Kids mode: explore stories and short lessons one at a time.'**
  String get kidsLearnHint;

  /// No description provided for @kidsJourneyHint.
  ///
  /// In en, this message translates to:
  /// **'Kids mode: your journey grows with every sincere step.'**
  String get kidsJourneyHint;

  /// No description provided for @assistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Nur Assistant'**
  String get assistantTitle;

  /// No description provided for @assistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm companion for guidance, reflection, and app navigation.'**
  String get assistantSubtitle;

  /// No description provided for @assistantEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Ask for a focus suggestion, reflection prompt, or where to go next.'**
  String get assistantEmptyState;

  /// No description provided for @assistantInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get assistantInputHint;

  /// No description provided for @circlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Circles'**
  String get circlesTitle;

  /// No description provided for @circlesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover circles for learning, reflection, and shared growth.'**
  String get circlesSubtitle;

  /// No description provided for @circlesNotFound.
  ///
  /// In en, this message translates to:
  /// **'Circle not found.'**
  String get circlesNotFound;

  /// No description provided for @circlesJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get circlesJoin;

  /// No description provided for @circlesLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get circlesLeave;

  /// No description provided for @circlesGuidance.
  ///
  /// In en, this message translates to:
  /// **'Keep interactions respectful, gentle, and centered on beneficial growth.'**
  String get circlesGuidance;

  /// No description provided for @circlesJoinedCount.
  ///
  /// In en, this message translates to:
  /// **'Joined circles: {count}'**
  String circlesJoinedCount(int count);

  /// No description provided for @circlesMembers.
  ///
  /// In en, this message translates to:
  /// **'Members: {count}'**
  String circlesMembers(int count);

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal & Timeline'**
  String get journalTitle;

  /// No description provided for @journalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record reflections, observations, and memory moments.'**
  String get journalSubtitle;

  /// No description provided for @journalTimelineIntro.
  ///
  /// In en, this message translates to:
  /// **'Capture intentional memories and revisit meaningful moments over time.'**
  String get journalTimelineIntro;

  /// No description provided for @journalCreateAction.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get journalCreateAction;

  /// No description provided for @journalMemoryResurfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'This time last year'**
  String get journalMemoryResurfaceTitle;

  /// No description provided for @journalEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No entries yet. Start your first reflection.'**
  String get journalEmptyState;

  /// No description provided for @journalUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled entry'**
  String get journalUntitled;

  /// No description provided for @journalPhotoAttached.
  ///
  /// In en, this message translates to:
  /// **'Photo reference attached'**
  String get journalPhotoAttached;

  /// No description provided for @journalCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Journal Entry'**
  String get journalCreateTitle;

  /// No description provided for @journalCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write a reflection, observation, or gratitude note.'**
  String get journalCreateSubtitle;

  /// No description provided for @journalTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get journalTitleField;

  /// No description provided for @journalBodyField.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get journalBodyField;

  /// No description provided for @journalTypeField.
  ///
  /// In en, this message translates to:
  /// **'Entry type'**
  String get journalTypeField;

  /// No description provided for @journalPhotoReferenceField.
  ///
  /// In en, this message translates to:
  /// **'Photo reference (optional)'**
  String get journalPhotoReferenceField;

  /// No description provided for @journalPhotoReferenceHelper.
  ///
  /// In en, this message translates to:
  /// **'For now, add a local path or short photo note.'**
  String get journalPhotoReferenceHelper;

  /// No description provided for @journalTypeReflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get journalTypeReflection;

  /// No description provided for @journalTypeGratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get journalTypeGratitude;

  /// No description provided for @journalTypeObservation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get journalTypeObservation;

  /// No description provided for @journalTypeLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get journalTypeLearning;

  /// No description provided for @journalTypeMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get journalTypeMemory;

  /// No description provided for @learnContentModeFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode focus'**
  String get learnContentModeFocusTitle;

  /// No description provided for @learnContentReflectionIdeasTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection ideas'**
  String get learnContentReflectionIdeasTitle;

  /// No description provided for @learnContentProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress tracking'**
  String get learnContentProgressTitle;

  /// No description provided for @learnContentMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark complete'**
  String get learnContentMarkComplete;

  /// No description provided for @learnContentMarkIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark incomplete'**
  String get learnContentMarkIncomplete;

  /// No description provided for @learnContentSave.
  ///
  /// In en, this message translates to:
  /// **'Save topic'**
  String get learnContentSave;

  /// No description provided for @learnContentSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get learnContentSaved;

  /// No description provided for @learnContentFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite topic'**
  String get learnContentFavorite;

  /// No description provided for @learnContentFavorited.
  ///
  /// In en, this message translates to:
  /// **'Favorited'**
  String get learnContentFavorited;

  /// No description provided for @learnContentReflectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Reflection {percent}%'**
  String learnContentReflectionProgress(int percent);

  /// No description provided for @learnProgressSummary.
  ///
  /// In en, this message translates to:
  /// **'Started: {started}  Completed: {completed}  Favorites: {favorite}'**
  String learnProgressSummary(int started, int completed, int favorite);

  /// No description provided for @learnProgressCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning progress'**
  String get learnProgressCardTitle;

  /// No description provided for @learnProgressCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Started {started}, completed {completed}, favorites {favorite}'**
  String learnProgressCardSubtitle(int started, int completed, int favorite);

  /// No description provided for @learnResumeTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume topic'**
  String get learnResumeTopicTitle;

  /// No description provided for @learnResumeTopicSubtitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start with any topic and continue steadily.'**
  String get learnResumeTopicSubtitleEmpty;

  /// No description provided for @learnResumeTopicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue: {topicId}'**
  String learnResumeTopicSubtitle(String topicId);

  /// No description provided for @learnContentFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite topics'**
  String get learnContentFavoritesTitle;

  /// No description provided for @learnContentFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} favorited topics'**
  String learnContentFavoritesSubtitle(int count);

  /// No description provided for @journalSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search journal'**
  String get journalSearchLabel;

  /// No description provided for @journalFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get journalFilterAll;

  /// No description provided for @journalFilterFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get journalFilterFavorites;

  /// No description provided for @journalLinkedTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked topic (optional)'**
  String get journalLinkedTopicLabel;

  /// No description provided for @journalLinkedQuranLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked Qur\'\'an reference (optional)'**
  String get journalLinkedQuranLabel;

  /// No description provided for @journalLinkedHadithLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked Hadith reference (optional)'**
  String get journalLinkedHadithLabel;

  /// No description provided for @journalTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get journalTagsLabel;

  /// No description provided for @journalTagsHelper.
  ///
  /// In en, this message translates to:
  /// **'Example: moon, patience, family'**
  String get journalTagsHelper;

  /// No description provided for @assistantQuickPromptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get assistantQuickPromptsTitle;

  /// No description provided for @assistantRecentPromptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent prompts'**
  String get assistantRecentPromptsTitle;

  /// No description provided for @assistantQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get assistantQuickActionsTitle;

  /// No description provided for @circlesJoinedPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Joined circles'**
  String get circlesJoinedPageTitle;

  /// No description provided for @circlesJoinedPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your active and saved circles in one place.'**
  String get circlesJoinedPageSubtitle;

  /// No description provided for @circlesJoinedEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have not joined any circles yet.'**
  String get circlesJoinedEmpty;

  /// No description provided for @circlesSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved circles'**
  String get circlesSavedTitle;

  /// No description provided for @circlesRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended circles'**
  String get circlesRecommendedTitle;

  /// No description provided for @circlesActivityPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity preview'**
  String get circlesActivityPreviewTitle;

  /// No description provided for @circlesEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get circlesEventsTitle;

  /// No description provided for @oceanHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent drop history'**
  String get oceanHistoryTitle;

  /// No description provided for @oceanStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage: {stage}'**
  String oceanStageLabel(String stage);

  /// No description provided for @oceanNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone: {count} drops'**
  String oceanNextMilestone(int count);

  /// No description provided for @oceanStageSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get oceanStageSpring;

  /// No description provided for @oceanStageStream.
  ///
  /// In en, this message translates to:
  /// **'Stream'**
  String get oceanStageStream;

  /// No description provided for @oceanStageFlowing.
  ///
  /// In en, this message translates to:
  /// **'Flowing'**
  String get oceanStageFlowing;

  /// No description provided for @oceanStageRising.
  ///
  /// In en, this message translates to:
  /// **'Rising Tide'**
  String get oceanStageRising;

  /// No description provided for @oceanStageVast.
  ///
  /// In en, this message translates to:
  /// **'Vast Ocean'**
  String get oceanStageVast;

  /// No description provided for @wallpaperRewardSummary.
  ///
  /// In en, this message translates to:
  /// **'Unlocked {unlocked}/{total}. Next: {hint}'**
  String wallpaperRewardSummary(int unlocked, int total, String hint);

  /// No description provided for @journeyRewardSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards and learning'**
  String get journeyRewardSummaryTitle;

  /// No description provided for @journeyRewardSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} wallpapers unlocked out of {total}.'**
  String journeyRewardSummaryBody(int unlocked, int total);

  /// No description provided for @journeyLearnSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'{completed} completed learn topics from {started} started.'**
  String journeyLearnSummaryBody(int completed, int started);

  /// No description provided for @journeyGraceTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak protection'**
  String get journeyGraceTokenTitle;

  /// No description provided for @journeyGraceTokenBody.
  ///
  /// In en, this message translates to:
  /// **'{remaining}/{allowance} grace tokens left this month. Protected days this week: {protectedDays}.'**
  String journeyGraceTokenBody(int remaining, int allowance, int protectedDays);

  /// No description provided for @journeyMonthlyBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly badges'**
  String get journeyMonthlyBadgesTitle;

  /// No description provided for @journeyMonthlyBadgesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tiered consistency challenges with unlock effects.'**
  String get journeyMonthlyBadgesSubtitle;

  /// No description provided for @journeyBadgeTier.
  ///
  /// In en, this message translates to:
  /// **'{tier} • {current}/{target}'**
  String journeyBadgeTier(String tier, int current, int target);

  /// No description provided for @journeyTierStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get journeyTierStarting;

  /// No description provided for @journeyTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get journeyTierBronze;

  /// No description provided for @journeyTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get journeyTierSilver;

  /// No description provided for @journeyTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get journeyTierGold;

  /// No description provided for @journeyTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get journeyTierPlatinum;

  /// No description provided for @journeyWeeklyReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly reflection review'**
  String get journeyWeeklyReflectionTitle;

  /// No description provided for @journeyWeeklyReflectionStats.
  ///
  /// In en, this message translates to:
  /// **'Worship actions: {worship}. Learning completions: {learning}. Journal entries: {journal}. Favorites: {favorites}.'**
  String journeyWeeklyReflectionStats(
    int worship,
    int learning,
    int journal,
    int favorites,
  );

  /// No description provided for @journeyWeeklyReflectionTags.
  ///
  /// In en, this message translates to:
  /// **'Top themes: {tags}'**
  String journeyWeeklyReflectionTags(String tags);

  /// No description provided for @journeyWeeklyHighlightWorship.
  ///
  /// In en, this message translates to:
  /// **'This week leaned into steady worship and presence.'**
  String get journeyWeeklyHighlightWorship;

  /// No description provided for @journeyWeeklyHighlightLearning.
  ///
  /// In en, this message translates to:
  /// **'This week showed clear learning growth.'**
  String get journeyWeeklyHighlightLearning;

  /// No description provided for @journeyWeeklyHighlightReflection.
  ///
  /// In en, this message translates to:
  /// **'This week held meaningful reflection moments.'**
  String get journeyWeeklyHighlightReflection;

  /// No description provided for @journeyWeeklyHighlightSmallSteps.
  ///
  /// In en, this message translates to:
  /// **'Small steps were present this week; keep building gently.'**
  String get journeyWeeklyHighlightSmallSteps;

  /// No description provided for @oceanProgressionMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Progression map'**
  String get oceanProgressionMapTitle;

  /// No description provided for @oceanTimelineSources.
  ///
  /// In en, this message translates to:
  /// **'{count} active sources'**
  String oceanTimelineSources(int count);

  /// No description provided for @oceanRecentDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent day snapshots'**
  String get oceanRecentDaysLabel;

  /// No description provided for @wallpaperStoryCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock stories'**
  String get wallpaperStoryCardsTitle;

  /// No description provided for @wallpaperStoryHint.
  ///
  /// In en, this message translates to:
  /// **'Path: {hint}'**
  String wallpaperStoryHint(String hint);

  /// No description provided for @wallpaperStoryProgress.
  ///
  /// In en, this message translates to:
  /// **'Level {requiredLevel} required • current level {currentLevel}. Learn target {requiredTopics} • current {currentTopics}.'**
  String wallpaperStoryProgress(
    int requiredLevel,
    int currentLevel,
    int requiredTopics,
    int currentTopics,
  );

  /// No description provided for @wallpaperStoryMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone link: {milestone}'**
  String wallpaperStoryMilestone(String milestone);

  /// No description provided for @homeEcosystemSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth ecosystem'**
  String get homeEcosystemSummaryTitle;

  /// No description provided for @homeEcosystemSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ocean, rewards, circles, journal, and assistant previews.'**
  String get homeEcosystemSummarySubtitle;

  /// No description provided for @learnTrackSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested learning track'**
  String get learnTrackSelectorTitle;

  /// No description provided for @learnBundleManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline content bundles'**
  String get learnBundleManagerTitle;

  /// No description provided for @learnBundleManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Install staged bundles now. Structure is ready for future remote sync.'**
  String get learnBundleManagerSubtitle;

  /// No description provided for @learnTrackBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get learnTrackBeginner;

  /// No description provided for @learnTrackFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get learnTrackFamily;

  /// No description provided for @learnTrackCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get learnTrackCharacter;

  /// No description provided for @learnTrackRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get learnTrackRamadan;

  /// No description provided for @learnTrackRevert.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get learnTrackRevert;

  /// No description provided for @learnCitationPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Source and confidence notes'**
  String get learnCitationPanelTitle;

  /// No description provided for @learnCompletionQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Completion quality'**
  String get learnCompletionQualityTitle;

  /// No description provided for @learnQualityNotRead.
  ///
  /// In en, this message translates to:
  /// **'Not read'**
  String get learnQualityNotRead;

  /// No description provided for @learnQualityRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get learnQualityRead;

  /// No description provided for @learnQualityReflected.
  ///
  /// In en, this message translates to:
  /// **'Reflected'**
  String get learnQualityReflected;

  /// No description provided for @learnQualityApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get learnQualityApplied;

  /// No description provided for @learnQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quality: {quality}'**
  String learnQualityLabel(Object quality);

  /// No description provided for @learnContinueReasonWithTrack.
  ///
  /// In en, this message translates to:
  /// **'Ranked for your {track} track using recency and intent.'**
  String learnContinueReasonWithTrack(Object track);

  /// No description provided for @circlesV2HubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Community forum + mosque buddy spaces are local-first and respectful.'**
  String get circlesV2HubSubtitle;

  /// No description provided for @circlesEventsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Events calendar'**
  String get circlesEventsCalendarTitle;

  /// No description provided for @circlesEventsCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming local events with RSVP tracking.'**
  String get circlesEventsCalendarSubtitle;

  /// No description provided for @circlesMosqueBuddyPrefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque Buddy'**
  String get circlesMosqueBuddyPrefsTitle;

  /// No description provided for @circlesMosqueBuddyPrefsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set distance, prayer habits, interests, and availability windows.'**
  String get circlesMosqueBuddyPrefsSubtitle;

  /// No description provided for @circlesModerationTitle.
  ///
  /// In en, this message translates to:
  /// **'Moderation & Safety'**
  String get circlesModerationTitle;

  /// No description provided for @circlesModerationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reporting, trust level, and content policy surfaces.'**
  String get circlesModerationSubtitle;

  /// No description provided for @circlesAccountabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accountability groups'**
  String get circlesAccountabilityTitle;

  /// No description provided for @circlesAccountabilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Private support groups for prayer and habit streaks.'**
  String get circlesAccountabilitySubtitle;

  /// No description provided for @circlesNearbyMosquesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby mosques'**
  String get circlesNearbyMosquesTitle;

  /// No description provided for @circlesNearbyMosquesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import local prayer timetables and keep one selected.'**
  String get circlesNearbyMosquesSubtitle;

  /// No description provided for @circlesOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get circlesOpen;

  /// No description provided for @circlesRsvpGoing.
  ///
  /// In en, this message translates to:
  /// **'Going'**
  String get circlesRsvpGoing;

  /// No description provided for @circlesRsvpInterested.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get circlesRsvpInterested;

  /// No description provided for @circlesRsvpNotGoing.
  ///
  /// In en, this message translates to:
  /// **'Not going'**
  String get circlesRsvpNotGoing;

  /// No description provided for @circlesNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events right now.'**
  String get circlesNoEvents;

  /// No description provided for @circlesBuddyDistance.
  ///
  /// In en, this message translates to:
  /// **'Max distance'**
  String get circlesBuddyDistance;

  /// No description provided for @circlesBuddyPrayerConsistency.
  ///
  /// In en, this message translates to:
  /// **'Prayer habits'**
  String get circlesBuddyPrayerConsistency;

  /// No description provided for @circlesBuddyInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get circlesBuddyInterests;

  /// No description provided for @circlesBuddyAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability windows'**
  String get circlesBuddyAvailability;

  /// No description provided for @circlesBuddyMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested buddies'**
  String get circlesBuddyMatchesTitle;

  /// No description provided for @circlesNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No close matches yet. Adjust your preferences.'**
  String get circlesNoMatches;

  /// No description provided for @circlesTrustLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Trust level'**
  String get circlesTrustLevelTitle;

  /// No description provided for @circlesPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Community policy'**
  String get circlesPolicyTitle;

  /// No description provided for @circlesPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Respectful conduct, verified meetups, no harassment, and no harmful/offensive content. Report concerns early.'**
  String get circlesPolicyBody;

  /// No description provided for @circlesReportLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Report log'**
  String get circlesReportLogTitle;

  /// No description provided for @circlesReportLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reports submitted yet.'**
  String get circlesReportLogEmpty;

  /// No description provided for @circlesTrustLevelLow.
  ///
  /// In en, this message translates to:
  /// **'New member'**
  String get circlesTrustLevelLow;

  /// No description provided for @circlesTrustLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get circlesTrustLevelMedium;

  /// No description provided for @circlesTrustLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'Steward'**
  String get circlesTrustLevelHigh;

  /// No description provided for @circlesReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get circlesReport;

  /// No description provided for @circlesReportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted for moderation review.'**
  String get circlesReportSubmitted;

  /// No description provided for @circlesAccountabilityCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get circlesAccountabilityCheckIn;

  /// No description provided for @circlesAccountabilityJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get circlesAccountabilityJoined;

  /// No description provided for @circlesAccountabilityStreak.
  ///
  /// In en, this message translates to:
  /// **'Check-in streak'**
  String get circlesAccountabilityStreak;

  /// No description provided for @circlesImportTimetable.
  ///
  /// In en, this message translates to:
  /// **'Import timetable'**
  String get circlesImportTimetable;

  /// No description provided for @circlesImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get circlesImported;

  /// No description provided for @circlesMosqueSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected mosque timetable'**
  String get circlesMosqueSelected;

  /// No description provided for @circlesCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get circlesCityLabel;

  /// No description provided for @circlesFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get circlesFocusLabel;

  /// No description provided for @circlesMosqueBuddyActive.
  ///
  /// In en, this message translates to:
  /// **'Mosque buddy active'**
  String get circlesMosqueBuddyActive;

  /// No description provided for @circlesMosqueBuddyFind.
  ///
  /// In en, this message translates to:
  /// **'Find mosque buddy'**
  String get circlesMosqueBuddyFind;

  /// No description provided for @circlesEventCapacity.
  ///
  /// In en, this message translates to:
  /// **'Going {going}/{capacity} • Interested {interested}'**
  String circlesEventCapacity(Object going, Object capacity, Object interested);

  /// No description provided for @circlesWaitlistActive.
  ///
  /// In en, this message translates to:
  /// **'Capacity reached. New Going responses are moved to interested/waitlist.'**
  String get circlesWaitlistActive;

  /// No description provided for @circlesEventFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Event filters'**
  String get circlesEventFiltersTitle;

  /// No description provided for @circlesFilterCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get circlesFilterCircle;

  /// No description provided for @circlesFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get circlesFilterCategory;

  /// No description provided for @circlesFilterCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get circlesFilterCity;

  /// No description provided for @circlesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get circlesFilterAll;

  /// No description provided for @circlesRosterPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Roster preview'**
  String get circlesRosterPreviewTitle;

  /// No description provided for @circlesRosterGoingPreview.
  ///
  /// In en, this message translates to:
  /// **'Going: {names}'**
  String circlesRosterGoingPreview(Object names);

  /// No description provided for @circlesRosterInterestedPreview.
  ///
  /// In en, this message translates to:
  /// **'Interested: {names}'**
  String circlesRosterInterestedPreview(Object names);

  /// No description provided for @circlesRosterWaitlistCount.
  ///
  /// In en, this message translates to:
  /// **'Waitlist count: {count}'**
  String circlesRosterWaitlistCount(Object count);

  /// No description provided for @circlesCreateEvent.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get circlesCreateEvent;

  /// No description provided for @circlesCreateEventModerationHint.
  ///
  /// In en, this message translates to:
  /// **'User-created events are local for now. Future releases can enable mosque moderator approval workflows.'**
  String get circlesCreateEventModerationHint;

  /// No description provided for @circlesCreateEventTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get circlesCreateEventTitleLabel;

  /// No description provided for @circlesCreateEventLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get circlesCreateEventLocationLabel;

  /// No description provided for @circlesCreateEventDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get circlesCreateEventDescriptionLabel;

  /// No description provided for @circlesCreateEventCreatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Organizer name (optional)'**
  String get circlesCreateEventCreatorLabel;

  /// No description provided for @circlesCreateEventRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Creation role'**
  String get circlesCreateEventRoleLabel;

  /// No description provided for @circlesCreateEventRoleUser.
  ///
  /// In en, this message translates to:
  /// **'Community member'**
  String get circlesCreateEventRoleUser;

  /// No description provided for @circlesCreateEventRoleModerator.
  ///
  /// In en, this message translates to:
  /// **'Mosque moderator'**
  String get circlesCreateEventRoleModerator;

  /// No description provided for @circlesCreateEventDateValue.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String circlesCreateEventDateValue(Object date);

  /// No description provided for @circlesCreateEventCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capacity: {count}'**
  String circlesCreateEventCapacityLabel(Object count);

  /// No description provided for @circlesCreateEventValidation.
  ///
  /// In en, this message translates to:
  /// **'Please fill title, location, and description.'**
  String get circlesCreateEventValidation;

  /// No description provided for @circlesCreateEventSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save event'**
  String get circlesCreateEventSubmit;

  /// No description provided for @circlesCreateEventSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event created and added to calendar.'**
  String get circlesCreateEventSuccess;

  /// No description provided for @circlesCreateEventPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Event submitted and pending moderation review.'**
  String get circlesCreateEventPendingReview;

  /// No description provided for @circlesCreatedEventsStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted events'**
  String get circlesCreatedEventsStatusTitle;

  /// No description provided for @circlesCreatedEventsStatusBody.
  ///
  /// In en, this message translates to:
  /// **'{pending} pending review • {rejected} rejected'**
  String circlesCreatedEventsStatusBody(int pending, int rejected);

  /// No description provided for @circlesModeratorCreateReady.
  ///
  /// In en, this message translates to:
  /// **'Moderator posting is enabled for your account.'**
  String get circlesModeratorCreateReady;

  /// No description provided for @circlesModeratorCreatePending.
  ///
  /// In en, this message translates to:
  /// **'Moderator posting unlocks after steward trust level and mosque import.'**
  String get circlesModeratorCreatePending;

  /// No description provided for @circlesPendingEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending event queue'**
  String get circlesPendingEventsTitle;

  /// No description provided for @circlesPendingEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events are waiting for moderation.'**
  String get circlesPendingEventsEmpty;

  /// No description provided for @circlesApproveEvent.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get circlesApproveEvent;

  /// No description provided for @circlesRejectEvent.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get circlesRejectEvent;

  /// No description provided for @circlesModerationAccessReady.
  ///
  /// In en, this message translates to:
  /// **'You can approve/reject pending events.'**
  String get circlesModerationAccessReady;

  /// No description provided for @circlesModerationAccessLimited.
  ///
  /// In en, this message translates to:
  /// **'Approval actions unlock at steward trust level.'**
  String get circlesModerationAccessLimited;

  /// No description provided for @circlesMosqueVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Mosque verified'**
  String get circlesMosqueVerifiedBadge;

  /// No description provided for @circlesEventReportCount.
  ///
  /// In en, this message translates to:
  /// **'{count} report(s) linked'**
  String circlesEventReportCount(int count);

  /// No description provided for @circlesEventApprovedAudit.
  ///
  /// In en, this message translates to:
  /// **'Approved by {name} on {date}'**
  String circlesEventApprovedAudit(String name, String date);

  /// No description provided for @onboardingDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'This app is a companion for guidance and consistency. It does not replace local mosque community, scholars, or real-world support.'**
  String get onboardingDisclaimerBody;

  /// No description provided for @legalPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Path of Nūr stores your progress and preferences locally by default. You can review and clear settings in Profile at any time.'**
  String get legalPrivacyBody;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Path of Nūr is a companion app for learning, worship consistency, and reflection. It does not replace qualified scholarship or local community guidance.'**
  String get legalTermsBody;

  /// No description provided for @legalSupportBody.
  ///
  /// In en, this message translates to:
  /// **'For support, use in-app feedback channels and local community resources. If something looks incorrect, report it from the relevant page.'**
  String get legalSupportBody;

  /// No description provided for @legalBuildInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Build information'**
  String get legalBuildInfoTitle;

  /// No description provided for @legalBuildFlavorLabel.
  ///
  /// In en, this message translates to:
  /// **'Flavor: {flavor}'**
  String legalBuildFlavorLabel(String flavor);

  /// No description provided for @legalCrashLogCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Stored crash reports: {count}'**
  String legalCrashLogCountLabel(int count);

  /// No description provided for @routerNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Route not found'**
  String get routerNotFoundTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'en',
    'fa',
    'ha',
    'hi',
    'id',
    'ku',
    'ms',
    'pa',
    'ps',
    'tg',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'fa':
      {
        switch (locale.countryCode) {
          case 'AF':
            return AppLocalizationsFaAf();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ha':
      return AppLocalizationsHa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ku':
      return AppLocalizationsKu();
    case 'ms':
      return AppLocalizationsMs();
    case 'pa':
      return AppLocalizationsPa();
    case 'ps':
      return AppLocalizationsPs();
    case 'tg':
      return AppLocalizationsTg();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
