import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/quran_providers.dart';

class QuranContinueListeningCard extends StatelessWidget {
  const QuranContinueListeningCard({
    super.key,
    required this.session,
    required this.onResume,
    required this.onRestartSurah,
    required this.formatPosition,
  });

  final QuranRecitationSession session;
  final VoidCallback? onResume;
  final VoidCallback? onRestartSurah;
  final String Function(Duration value) formatPosition;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      key: const ValueKey('quran-reader-continue-listening-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_outline_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.quranReaderResumeAudioRecitationTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                key: const ValueKey('quran-reader-restart-surah-button'),
                onPressed: onRestartSurah,
                child: Text(l10n.quranReaderRestartSurahAction),
              ),
              FilledButton.tonal(
                key: const ValueKey('quran-reader-resume-session-button'),
                onPressed: onResume,
                child: Text(l10n.quranReaderResumeAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
