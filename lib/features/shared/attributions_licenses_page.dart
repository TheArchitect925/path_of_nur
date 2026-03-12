import 'package:flutter/material.dart';

import '../../shared/widgets/app_page_scaffold.dart';
import '../../shared/widgets/premium_card.dart';

class AttributionsLicensesPage extends StatelessWidget {
  const AttributionsLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.verified_outlined,
      title: 'Attributions & Licenses',
      subtitle: 'Quran text, translations, transliteration, audio and API usage.',
      children: const [
        _AttributionCard(
          title: 'Qur’an Text & Translations',
          body:
              'The app currently uses the Flutter package "quran" for Arabic text and translation integrations.\n\n'
              'Source links:\n'
              'https://pub.dev/packages/quran\n'
              'https://github.com/aqeelshamz/quran',
        ),
        SizedBox(height: 10),
        _AttributionCard(
          title: 'Transliteration',
          body:
              'Transliteration is fetched from AlQuran.cloud (edition: en.transliteration) and cached on device.\n\n'
              'Source links:\n'
              'https://alquran.cloud/api',
        ),
        SizedBox(height: 10),
        _AttributionCard(
          title: 'Recitation Audio',
          body:
              'Audio recitations are streamed/downloaded from EveryAyah sources (e.g., Husary, Alafasy, Abdul Basit).\n\n'
              'Source links:\n'
              'https://everyayah.com/\n'
              'https://everyayah.com/data/',
        ),
        SizedBox(height: 10),
        _AttributionCard(
          title: 'Adhan Notification Audio',
          body:
              'Bundled adhan reminder clip source:\n'
              'https://commons.wikimedia.org/wiki/File:Adhan_wiki.oga\n\n'
              'Original file URL:\n'
              'https://upload.wikimedia.org/wikipedia/commons/1/16/Adhan_wiki.oga\n\n'
              'Author listed on source page: Jarih (own work)\n'
              'License: Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA 3.0)',
        ),
        SizedBox(height: 10),
        _AttributionCard(
          title: 'Word Timing (Live Sync Beta)',
          body:
              'Word timing segments are requested from Quran.com API v4.\n\n'
              'Source links:\n'
              'https://api-docs.quran.com/',
        ),
        SizedBox(height: 10),
        _AttributionCard(
          title: 'Compliance Note',
          body:
              'Before public release, verify all production usage terms and attribution requirements, '
              'especially translation rights and audio redistribution permissions.',
        ),
      ],
    );
  }
}

class _AttributionCard extends StatelessWidget {
  const _AttributionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          SelectableText(
            body,
            style: const TextStyle(height: 1.35, color: Color(0xFF4A4036)),
          ),
        ],
      ),
    );
  }
}
