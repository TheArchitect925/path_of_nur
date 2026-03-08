import 'package:flutter/material.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/quran_quote_block.dart';

class QuranVersePage extends StatelessWidget {
  const QuranVersePage({
    super.key,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.surah,
    this.ayah,
    this.locationLabel,
  });

  final String arabic;
  final String transliteration;
  final String translation;
  final int? surah;
  final int? ayah;
  final String? locationLabel;

  @override
  Widget build(BuildContext context) {
    final quote = QuranQuote(
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      surah: surah,
      verse: ayah,
      locationLabel: locationLabel,
    );

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: 'Qur’aan Verse',
      subtitle: quote.locationText,
      quote: quote,
      children: const [
        SizedBox(height: 4),
        _GuideCard(),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF4EEE8).withValues(alpha: 0.74),
        border: Border.all(
          color: const Color(0xFFD8C49A).withValues(alpha: 0.45),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Text(
          'This is where that verse would open in the Qur’an reader once the reader module is added.',
          style: TextStyle(
            color: Color(0xFF4A4036),
            fontSize: 13.8,
            height: 1.4,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

