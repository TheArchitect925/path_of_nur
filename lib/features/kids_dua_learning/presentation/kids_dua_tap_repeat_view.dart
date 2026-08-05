import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/kids_dua_learning_models.dart';

class KidsDuaTapRepeatView extends StatelessWidget {
  const KidsDuaTapRepeatView({
    super.key,
    required this.item,
    required this.activeSegmentId,
    required this.onTapSegment,
    required this.hasAudio,
    required this.isSegmentFallback,
  });

  final KidsDuaLearningItem item;
  final String? activeSegmentId;
  final ValueChanged<KidsDuaSegment> onTapSegment;
  final bool hasAudio;
  final bool isSegmentFallback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n.kidsDuaTapRepeatSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            hasAudio
                ? (isSegmentFallback
                      ? l10n.kidsDuaTapRepeatFallbackWholeAudio
                      : l10n.kidsDuaTapRepeatBody)
                : l10n.kidsDuaTapRepeatNoAudioBody,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF655A4C)),
          ),
          const SizedBox(height: 12),
          ...item.segments.map((segment) {
            final selected = activeSegmentId == segment.segmentId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTapSegment(segment),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFFF7EB)
                        : const Color(0xFFFCFBF8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFCFB27D)
                          : const Color(0xFFE8DDD0),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        hasAudio
                            ? Icons.volume_up_rounded
                            : Icons.menu_book_rounded,
                        color: const Color(0xFF8A6A45),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                segment.arabicSegmentText,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              segment.transliterationSegmentText,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFF655A4C)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
