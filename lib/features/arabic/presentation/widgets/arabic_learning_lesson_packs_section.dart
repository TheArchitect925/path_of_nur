import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../domain/arabic_learning_lesson_pack_models.dart';
import '../arabic_learning_lesson_pack_localizations.dart';

enum ArabicLearningLessonPacksVariant { kids, adult }

class ArabicLearningLessonPacksSection extends StatelessWidget {
  const ArabicLearningLessonPacksSection({
    super.key,
    required this.variant,
    required this.packs,
    required this.onOpenPack,
  });

  final ArabicLearningLessonPacksVariant variant;
  final List<ArabicLearningLessonPack> packs;
  final ValueChanged<ArabicLearningLessonPack> onOpenPack;

  bool get _isKids => variant == ArabicLearningLessonPacksVariant.kids;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isKids
              ? l10n.arabicLearningLessonPacksKidsTitle
              : l10n.arabicLearningLessonPacksAdultTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          _isKids
              ? l10n.arabicLearningLessonPacksKidsSubtitle
              : l10n.arabicLearningLessonPacksAdultSubtitle,
        ),
        const SizedBox(height: 12),
        ...packs.map(
          (pack) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PackCard(
              pack: pack,
              isKids: _isKids,
              onOpen: () => onOpenPack(pack),
            ),
          ),
        ),
      ],
    );

    if (_isKids) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F2E8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE4D9C9)),
        ),
        child: body,
      );
    }
    return PremiumCard(child: body);
  }
}

class _PackCard extends StatelessWidget {
  const _PackCard({
    required this.pack,
    required this.isKids,
    required this.onOpen,
  });

  final ArabicLearningLessonPack pack;
  final bool isKids;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isKids ? Colors.white : const Color(0xFFFBFAF7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: pack.isRecommended
                ? (isKids ? const Color(0xFFD2B58A) : const Color(0xFFC6B27C))
                : (isKids ? const Color(0xFFE3D6C3) : const Color(0xFFDDD8CF)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  localizedArabicLearningLessonPackType(l10n, pack.type),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6C5A43),
                  ),
                ),
                if (pack.isRecommended)
                  Text(
                    l10n.arabicLearningLessonPacksRecommended,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8A6630),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              localizedArabicLearningLessonPackTitle(l10n, pack.id),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(localizedArabicLearningLessonPackSubtitle(l10n, pack.id)),
            if (pack.previewArabic.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                pack.previewArabic.take(3).join('  •  '),
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'AmiriQuran',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onOpen,
              child: Text(
                pack.isRecommended
                    ? l10n.arabicLearningLessonPacksContinueAction
                    : l10n.arabicLearningLessonPacksOpenAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
