import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_quote_block.dart';

class LearnHubPageScaffold extends StatelessWidget {
  const LearnHubPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.headerIcon,
    this.quote = const QuranQuote(
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni ilma',
      translation: 'My Lord, increase me in knowledge.',
      surah: 20,
      verse: 114,
      locationLabel: 'Qur’an 20:114',
    ),
  });

  final String title;
  final String subtitle;
  final IconData? headerIcon;
  final List<Widget> children;
  final QuranQuote? quote;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      quote: quote,
      children: [...children, const SizedBox(height: 96)],
    );
  }
}
