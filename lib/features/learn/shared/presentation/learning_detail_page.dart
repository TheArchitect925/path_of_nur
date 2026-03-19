import 'package:flutter/material.dart';

import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/quran_quote_block.dart';
import 'learning_header.dart';

class LearningDetailPage extends StatelessWidget {
  const LearningDetailPage({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    this.quote,
    this.onQuoteTap,
    this.header,
    required this.sections,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final QuranQuote? quote;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final LearningHeader? header;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      quote: quote ?? buildLearningCompactQuote(),
      onQuoteTap: onQuoteTap,
      children: [
        if (header != null) ...[header!, const SizedBox(height: 10)],
        ...sections,
      ],
    );
  }
}
