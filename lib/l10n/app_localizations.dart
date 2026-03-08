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
