import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_reference_block.dart';
import '../models/faq_item.dart';
import '../providers/faq_providers.dart';

class FaqDetailPage extends ConsumerWidget {
  const FaqDetailPage({super.key, required this.faqId});

  final String faqId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(faqItemByIdProvider(faqId));
    final datasetAsync = ref.watch(faqDatasetProvider);
    final l10n = AppLocalizations.of(context);

    return itemAsync.when(
      data: (item) {
        if (item == null) {
          return AppPageScaffold(
            title: l10n.batch9FaqTitle,
            subtitle: l10n.batch9FaqSubtitle,
            children: const [Center(child: Text('FAQ item not found.'))],
          );
        }
        return datasetAsync.when(
          data: (dataset) {
            final categoryTitle = dataset.categoryLabel(item.category);
            return AppPageScaffold(
              title: item.question,
              subtitle: categoryTitle,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(context, categoryTitle),
                    _chip(context, item.difficulty.label),
                    if (item.misconceptionTag != null)
                      _badge(
                        context,
                        item.category == 'misconceptions_about_islam'
                            ? 'Clarification'
                            : 'Misconception',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Short answer',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(item.shortAnswer),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Answer',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(item.answer),
                    ],
                  ),
                ),
                if (item.quranRefs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Qur’an references',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...item.quranRefs.map(
                    (refText) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _quranReferenceCard(context, refText),
                    ),
                  ),
                ],
                if (item.hadithRefs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hadith references',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ...item.hadithRefs.map(
                          (refText) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(refText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (item.relatedTopics.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Related topics',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.relatedTopics
                              .map((topic) => _chip(context, topic))
                              .toList(growable: false),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => AppPageScaffold(
            title: l10n.batch9FaqTitle,
            subtitle: l10n.batch9FaqSubtitle,
            children: const [Center(child: CircularProgressIndicator())],
          ),
          error: (error, _) => AppPageScaffold(
            title: l10n.batch9FaqTitle,
            subtitle: l10n.batch9FaqSubtitle,
            children: [Center(child: Text('Unable to load FAQ. $error'))],
          ),
        );
      },
      loading: () => AppPageScaffold(
        title: l10n.batch9FaqTitle,
        subtitle: l10n.batch9FaqSubtitle,
        children: const [Center(child: CircularProgressIndicator())],
      ),
      error: (error, _) => AppPageScaffold(
        title: l10n.batch9FaqTitle,
        subtitle: l10n.batch9FaqSubtitle,
        children: [Center(child: Text('Unable to load FAQ. $error'))],
      ),
    );
  }

  Widget _quranReferenceCard(BuildContext context, String refText) {
    final parsed = _parseReference(refText);
    if (parsed == null) {
      return PremiumCard(child: Text(refText));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuranReferenceBlock(
          surahNumber: parsed.$1,
          ayahStart: parsed.$2,
          ayahEnd: parsed.$3,
          title: 'Qur’an $refText',
        ),
      ],
    );
  }

  (int, int, int?)? _parseReference(String raw) {
    final match = RegExp(r'^(\d+):(\d+)(?:-(\d+))?$').firstMatch(raw.trim());
    if (match == null) return null;
    final surah = int.tryParse(match.group(1) ?? '');
    final start = int.tryParse(match.group(2) ?? '');
    final end = int.tryParse(match.group(3) ?? '');
    if (surah == null || start == null) return null;
    return (surah, start, end);
  }

  Widget _chip(BuildContext context, String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _badge(BuildContext context, String label) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
      tintColor: AppColors.accentGold,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.accentGold,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
