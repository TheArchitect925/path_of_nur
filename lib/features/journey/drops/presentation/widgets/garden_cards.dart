import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/journey_drops_models.dart';
import 'garden_gallery.dart';

class GardenHeroCard extends StatelessWidget {
  const GardenHeroCard({
    super.key,
    required this.totalDrops,
    required this.unlockedCount,
    required this.totalMilestones,
  });

  final int totalDrops;
  final int unlockedCount;
  final int totalMilestones;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gardenPageHeroTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.gardenPageHeroSubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6A5A4A),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _GardenMetricPill(
                label: l10n.gardenPageTotalDrops,
                value: countFormat.format(totalDrops),
              ),
              _GardenMetricPill(
                label: l10n.gardenPageUnlockedImages,
                value: l10n.gardenPageUnlockedCountValue(
                  countFormat.format(unlockedCount),
                  countFormat.format(totalMilestones),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GardenMeaningCard extends StatelessWidget {
  const GardenMeaningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gardenPageMeaningTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _MeaningLine(
            icon: Icons.account_tree_rounded,
            title: l10n.gardenPagePrayerMeaningTitle,
            subtitle: l10n.gardenPagePrayerMeaningBody,
          ),
          const SizedBox(height: 10),
          _MeaningLine(
            icon: Icons.auto_stories_rounded,
            title: l10n.gardenPageLearningMeaningTitle,
            subtitle: l10n.gardenPageLearningMeaningBody,
          ),
          const SizedBox(height: 10),
          _MeaningLine(
            icon: Icons.water_drop_rounded,
            title: l10n.gardenPageDropsMeaningTitle,
            subtitle: l10n.gardenPageDropsMeaningBody,
          ),
        ],
      ),
    );
  }
}

class GardenNextUnlockCard extends StatelessWidget {
  const GardenNextUnlockCard({
    super.key,
    required this.summary,
    required this.nextMilestone,
  });

  final GardenProgressSummary summary;
  final GardenMilestone? nextMilestone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gardenPageNextUnlockTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (nextMilestone == null) ...[
            Text(
              l10n.gardenPageAllUnlockedTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.gardenPageAllUnlockedBody,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6A5A4A),
                height: 1.35,
              ),
            ),
          ] else ...[
            Text(
              gardenTitleForKey(l10n, nextMilestone!.titleKey),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.gardenPageNextUnlockRequiredValue(
                countFormat.format(nextMilestone!.requiredDrops),
              ),
              style: const TextStyle(fontSize: 13, color: Color(0xFF6A5A4A)),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.gardenPageDropsRemainingValue(
                countFormat.format(summary.dropsRemaining),
              ),
              style: const TextStyle(fontSize: 13, color: Color(0xFF6A5A4A)),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(value: summary.progressToNext),
            ),
          ],
        ],
      ),
    );
  }
}

class GardenEntryCard extends StatelessWidget {
  const GardenEntryCard({
    super.key,
    required this.summary,
    required this.nextMilestone,
    required this.onTap,
  });

  final GardenProgressSummary summary;
  final GardenMilestone? nextMilestone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    return PremiumCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE7D7AE), Color(0xFF8BA06B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_florist_rounded,
                  color: Color(0xFF2C2318),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.gardenPageHeroTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextMilestone == null
                          ? l10n.gardenPageAllUnlockedTitle
                          : l10n.gardenPageEntrySubtitle(
                              countFormat.format(summary.totalDrops),
                              gardenTitleForKey(l10n, nextMilestone!.titleKey),
                            ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6A5A4A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _GardenMetricPill extends StatelessWidget {
  const _GardenMetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MeaningLine extends StatelessWidget {
  const _MeaningLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF5EEE3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF7A6241)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6A5A4A),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
