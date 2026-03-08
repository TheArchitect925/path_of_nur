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
  /// **'Journey'**
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

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
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
  /// **'Whoever is mindful of Allah is guided toward balance and intention.'**
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
  /// **'A gentle reminder: sincere deeds are with Allah.'**
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
