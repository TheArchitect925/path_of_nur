import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/kids_dua_learning_models.dart';

class KidsDuaReadAlongView extends StatelessWidget {
  const KidsDuaReadAlongView({
    super.key,
    required this.item,
    required this.readAlongMode,
    this.activeSegmentId,
  });

  final KidsDuaLearningItem item;
  final KidsDuaReadAlongMode readAlongMode;
  final String? activeSegmentId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showTransliteration =
        readAlongMode != KidsDuaReadAlongMode.arabicOnly;
    final showTranslation = readAlongMode == KidsDuaReadAlongMode.full;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaReadAlongSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...item.segments.map((segment) {
            final highlighted = activeSegmentId == segment.segmentId;
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: highlighted
                    ? const Color(0xFFFFF7EB)
                    : const Color(0xFFFCFBF8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: highlighted
                      ? const Color(0xFFE0C89F)
                      : const Color(0xFFEAE0D4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      segment.arabicSegmentText,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (showTransliteration) ...[
                    const SizedBox(height: 8),
                    Text(
                      segment.transliterationSegmentText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF655A4C),
                      ),
                    ),
                  ],
                  if (showTranslation &&
                      segment.translationSegmentText != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      segment.translationSegmentText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF766856),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          if (showTranslation) ...[
            const SizedBox(height: 4),
            Text(
              item.translation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF554C42),
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
