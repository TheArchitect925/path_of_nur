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
