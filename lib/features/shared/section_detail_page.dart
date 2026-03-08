import 'package:flutter/material.dart';

import '../../shared/widgets/quran_quote_block.dart';
import '../../shared/widgets/app_page_scaffold.dart';
import '../../shared/widgets/premium_card.dart';
import '../../shared/widgets/quran_navigation.dart';

class FeatureSectionPage extends StatelessWidget {
  const FeatureSectionPage({
    super.key,
    required this.sectionId,
    required this.title,
    required this.subtitle,
    required this.quote,
  });

  final String sectionId;
  final String title;
  final String subtitle;
  final QuranQuote quote;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      subtitle: subtitle,
      quote: quote,
      headerIcon: _sectionIcon(sectionId),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _sectionSummary(sectionId),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              ..._placeholderRows(context),
            ],
          ),
        ),
      ],
    );
  }

  String _sectionSummary(String id) {
    switch (id) {
      case 'prayer':
        return 'Use this section to refine prayer rhythm, reminders, and completion notes for today.';
      case 'dhikr':
        return 'Use this section for remembrance sessions, counters, and reflective pauses.';
      case 'fasting':
        return 'Use this section to track fast intention, completion, and progress checks.';
      case 'khusu':
        return 'Use this section for focused worship moments with reduced visual noise.';
      case 'worshipSummary':
        return 'Daily worship summary with meaningful progress and gentle momentum indicators.';
      case 'quickAccess':
        return 'Fast actions that can jump you into the next intentional practice.';
      case 'quran':
        return 'Structured entry point to Qur\'aan reading and reflection pages.';
      case 'lifeThroughQuran':
        return 'Reflection prompts based on practical verses and themes.';
      case 'worldThroughQuran':
        return 'Connect timeless teachings with modern life in calm daily snapshots.';
      case 'hadithLessons':
        return 'Companion teachings for character development and consistency.';
      case 'reflections':
        return 'Capture notes and gentle reflections after each practice cycle.';
      case 'continueLearning':
        return 'Return quickly to where your attention paused previously.';
      case 'journey-home':
        return 'Growth overview for this moment and next intent.';
      case 'journey-rings':
        return 'Habit rings with placeholder readiness for future streak visuals.';
      case 'journey-streak':
        return 'Progress memory for continuity with encouragement not pressure.';
      case 'journey-milestones':
        return 'Milestones you can unlock through consistent practice.';
      case 'journey-unlocks':
        return 'Rewards and milestones preview area for future growth layers.';
      case 'journey-garden':
        return 'Character and garden evolution preview with planned next growth stage.';
      case 'journey-ocean':
        return 'A calming representation of persistence flowing over time.';
      case 'home-daily-nur':
        return 'Personal progress for the daily light-focused rhythm.';
      case 'home-prayer-summary':
        return 'A compact summary of today\'s prayer milestones and momentum.';
      case 'home-dhikr-quick':
        return 'Quick start points for Dhikr sessions and continuity reminders.';
      case 'home-quran-continue':
        return 'Continue Qur\'aan reading from your last saved place.';
      default:
        return 'Dedicated section view with structured placeholder content.';
    }
  }

  List<Widget> _placeholderRows(BuildContext context) {
    return List.generate(
      3,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.black54, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Placeholder item ${index + 1}: refined action cards appear here.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _sectionIcon(String id) {
  switch (id) {
    case 'prayer':
    case 'worshipSummary':
    case 'home-prayer-summary':
      return Icons.spa_outlined;
    case 'dhikr':
    case 'home-dhikr-quick':
      return Icons.auto_awesome;
    case 'fasting':
      return Icons.restaurant_outlined;
    case 'khusu':
    case 'quickAccess':
      return Icons.self_improvement;
    case 'quran':
    case 'home-quran-continue':
    case 'lifeThroughQuran':
    case 'worldThroughQuran':
    case 'reflections':
      return Icons.menu_book_rounded;
    case 'journey-home':
    case 'journey-rings':
    case 'journey-streak':
    case 'journey-milestones':
    case 'journey-unlocks':
    case 'journey-garden':
    case 'journey-ocean':
      return Icons.route_outlined;
    default:
      return Icons.sticky_note_2_rounded;
  }
}

final Map<String, QuranQuote> sectionQuotes = {
  'prayer': const QuranQuote(
    arabic: 'إِقَامَةُ الصَّلاَةِ تَنَالُ بِهَا',
    transliteration: 'Iqaamat-us-salaah tuni al',
    translation: 'Regular prayer grants closeness and stability in the heart.',
    surah: 2,
    verse: 238,
    locationLabel: 'Qur’an 2:238',
  ),
  'dhikr': const QuranQuote(
    arabic: 'اذْكُرُوا اللهَ تَسْتَطِيعُوا',
    transliteration: 'Udhkuru Allaha tastaTAAWU',
    translation: 'Remembering God lifts the heart from distraction.',
    surah: 33,
    verse: 41,
    locationLabel: 'Qur’an 33:41',
  ),
  'fasting': const QuranQuote(
    arabic: 'وَكُلُّ نَفْسٍ بِمَا كَسَبَتْ رَهِينَةٌ',
    transliteration: 'Wa kulla nafsin bimaa kasabat raheenah',
    translation: 'Restraint cultivates accountability and intention.',
    surah: 74,
    verse: 38,
    locationLabel: 'Qur’an 74:38',
  ),
  'khusu': const QuranQuote(
    arabic: 'الْقُرْبُ مِنَ اللَّهِ فِي خَفَاءِ الْقَلْبِ',
    transliteration: 'Al-qubdu mina Allahi fi khafa al-qalb',
    translation: 'Closeness grows in a heart made still and focused.',
    surah: 13,
    verse: 28,
    locationLabel: 'Qur’an 13:28',
  ),
  'learn': const QuranQuote(
    arabic: 'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ',
    transliteration: "Walaqad yassarna al-qur'an lildhikr",
    translation:
        "The Qur'an has been made easy for remembrance and reflection.",
    surah: 54,
    verse: 17,
    locationLabel: 'Qur’an 54:17',
  ),
  'journey': const QuranQuote(
    arabic: 'وَالصَّبْرُ جَنَّةٌ',
    transliteration: 'Was-sabru jannah',
    translation: 'Patience and consistency are paths to sustained growth.',
    surah: 47,
    verse: 35,
    locationLabel: 'Qur’an 47:35',
  ),
  'profile': const QuranQuote(
    arabic: 'قُلِ اعْمَلُوا',
    transliteration: 'Qul iAmalu',
    translation:
        'Set your intention and choose your path with gentle intention.',
    surah: 2,
    verse: 2,
    locationLabel: 'Qur’an 2:2',
  ),
  'home': const QuranQuote(
    arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
    transliteration: 'Wastaeenoo bis-sabri was-salah',
    translation: 'Seek help through patience and prayer.',
    surah: 2,
    verse: 45,
    locationLabel: 'Qur’an 2:45',
  ),
};

final Map<String, QuranQuote> journeySectionQuotes = {
  'journey-home': const QuranQuote(
    arabic: 'وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا',
    transliteration: 'Walladheena jahadoo feena lan-hadheena subulana',
    translation: 'For those who strive, guidance opens steady paths.',
    surah: 29,
    verse: 69,
    locationLabel: 'Qur’an 29:69',
  ),
  'journey-rings': const QuranQuote(
    arabic: 'مَا جَعَلَ عَلَيْكُمْ فِي الدِّينِ مِنْ حَرَجٍ',
    transliteration: 'Ma jaala alaikum fee ad-deeni min haraj',
    translation: 'No undue burden is placed in this way of life.',
    surah: 22,
    verse: 78,
    locationLabel: 'Qur’an 22:78',
  ),
  'journey-streak': const QuranQuote(
    arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
    transliteration: 'Inna ma al-ushri yusra',
    translation: 'With hardship comes ease, with each consistent return.',
    surah: 94,
    verse: 6,
    locationLabel: 'Qur’an 94:6',
  ),
  'journey-milestones': const QuranQuote(
    arabic: 'وَلَا تَيْأَسُوا مِن رَوْحِ الرَّحْمَةِ',
    transliteration: 'Wala ta-asu min rouhi ar-rahmah',
    translation: 'Do not lose hope in mercy and continual progress.',
    surah: 12,
    verse: 87,
    locationLabel: 'Qur’an 12:87',
  ),
  'journey-unlocks': const QuranQuote(
    arabic: 'وَلِلَّهِ الْمَغَارِبُ وَالْمَشَارِقُ',
    transliteration: 'Wallahi lmagaaribu walmashaariq',
    translation: 'Growth opens in stages; no stage is wasted.',
    surah: 55,
    verse: 9,
    locationLabel: 'Qur’an 55:9',
  ),
  'journey-garden': const QuranQuote(
    arabic: 'وَهُوَ مَعَكُمْ أَيْنَمَا كُنتُمْ',
    transliteration: "Wa huwa ma'akum aynamaa kuntum",
    translation: 'He is with you wherever intention is sincere.',
    surah: 57,
    verse: 4,
    locationLabel: 'Qur’an 57:4',
  ),
  'journey-ocean': const QuranQuote(
    arabic: 'نُرْبِيْكُمْ فِي سُلُوكِهِ',
    transliteration: 'Nurbikum fee sulookihi',
    translation: 'Your consistency becomes a flowing stream of mercy.',
    surah: 14,
    verse: 7,
    locationLabel: 'Qur’an 14:7',
  ),
};
