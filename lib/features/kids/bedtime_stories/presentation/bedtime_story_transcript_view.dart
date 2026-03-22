import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';

class BedtimeStoryTranscriptView extends StatelessWidget {
  const BedtimeStoryTranscriptView({
    super.key,
    required this.title,
    required this.rawText,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.completionButton,
  });

  final String title;
  final String rawText;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final Widget? completionButton;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final paragraphs = _paragraphsFor(rawText);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bedtimeStoriesTranscriptSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (primaryActionLabel != null && onPrimaryAction != null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onPrimaryAction,
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(primaryActionLabel!),
            ),
          ],
          const SizedBox(height: 14),
          ...paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                paragraph,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.75),
              ),
            ),
          ),
          if (completionButton != null) ...[
            const SizedBox(height: 8),
            completionButton!,
          ],
        ],
      ),
    );
  }

  List<String> _paragraphsFor(String raw) {
    return raw
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }
}
