import 'package:flutter/material.dart';

class QuranQuote {
  const QuranQuote({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.surah,
    this.verse,
    this.locationLabel,
  });

  final String arabic;
  final String transliteration;
  final String translation;
  final int? surah;
  final int? verse;
  final String? locationLabel;

  String get locationText {
    if (locationLabel != null && locationLabel!.isNotEmpty) {
      return locationLabel!;
    }
    if (surah != null && verse != null) {
      return 'Qur’an $surah:$verse';
    }
    return 'Qur’an';
  }
}

class QuranQuoteBlock extends StatelessWidget {
  const QuranQuoteBlock({
    super.key,
    required this.quote,
    this.compact = false,
    this.onTap,
  });

  final QuranQuote quote;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8C49A).withValues(alpha: 0.35)),
        color: const Color(0xFFF4EEE8).withValues(alpha: 0.68),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            quote.arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF30231A),
              fontFamily: 'serif',
              fontSize: 16,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quote.transliteration,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF564638),
              fontFamily: 'serif',
              fontSize: 13.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            quote.translation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF504035),
              fontSize: 12.8,
              height: 1.35,
            ),
          ),
          if (!compact) const SizedBox(height: 8),
          if (!compact)
            Text(
              quote.locationText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5E554A),
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: card,
    );
  }
}
