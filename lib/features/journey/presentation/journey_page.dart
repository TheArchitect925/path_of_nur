import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/quran_navigation.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      headerIcon: Icons.route_outlined,
      title: l10n.journeyTitle,
      subtitle: l10n.journeySubtitle,
      quote: const QuranQuote(
        arabic: 'وَتَوَكَّلْتُ عَلَى اللَّهِ فَسَيَهْدِينِي',
        transliteration: 'Wa tawakkaltu ' 'ala Allahi faya-hdeenee',
        translation: 'Trusting Allah brings steady guidance on every path.',
        surah: 3,
        verse: 159,
        locationLabel: 'Qur’an 3:159',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        const SectionTitle(
          title: 'Level / XP Hero',
          subtitle: 'Progression summary and destination markers.',
        ),
        PremiumCard(
          child: _JourneyClickableCard(
            sectionId: 'journey-home',
            child: const _JourneyKpiRow(
              values: ['Lv 4', 'XP 1,620', 'Next: 380'],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Light Progress',
          subtitle: 'Visual rhythm of consistency and flow.',
        ),
        PremiumCard(
          child: const _JourneyKpiRow(
            values: ['Faith', 'Discipline', 'Mercy'],
            showBadges: true,
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Daily Rings',
          subtitle: 'Compact placeholders for habit rings.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'journey-rings'},
            ),
            child: const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip('Prayer 62%'),
              _StatusChip('Dhikr 45%'),
              _StatusChip('Learning 29%'),
              _StatusChip('Reflection 18%'),
            ],
          ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Streak Summary',
          subtitle: 'Momentum insights.',
        ),
        PremiumCard(
          child: _JourneyClickableCard(
            sectionId: 'journey-streak',
            child: const Text('Current streak: 6 days · Longest streak: 18 days'),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Milestones & Unlocks',
          subtitle: 'Future progression points.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'journey-milestones'},
            ),
            child: const _BulletList([
            'Complete 30 focused days',
            'First Dhikr milestone',
            'Read completion',
            'Calm session chain',
          ]),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Garden / Tree / Character',
          subtitle: 'Spiritual growth companion preview.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'journey-garden'},
            ),
            child: Column(
              children: [
                _JourneyVisualPlaceholder('Garden preview', Icons.park),
                const SizedBox(height: 10),
                _JourneyVisualPlaceholder(
                  'Character growth',
                  Icons.cruelty_free_outlined,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle(
          title: 'Ocean of Drops',
          subtitle: 'Reward stream for persistence.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'journey-ocean'},
            ),
            child: Row(
              children: const [
                Icon(Icons.water_drop, color: AppColors.homeAccent),
                SizedBox(width: 10),
                Text('Drop count and milestone markers go here.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JourneyClickableCard extends StatelessWidget {
  const _JourneyClickableCard({
    required this.sectionId,
    required this.child,
  });

  final String sectionId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        'featureSection',
        pathParameters: {'sectionId': sectionId},
      ),
      child: child,
    );
  }
}

class _JourneyKpiRow extends StatelessWidget {
  const _JourneyKpiRow({required this.values, this.showBadges = false});

  final List<String> values;
  final bool showBadges;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values
          .map(
            (e) => Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBadges)
                    Container(
                      height: 16,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.accentGoldSoft),
                        color: AppColors.surfaceSoft.withValues(alpha: 0.3),
                      ),
                      child: const Center(
                        child: Text('ON', style: TextStyle(fontSize: 9)),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(e, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.4),
        ),
        color: AppColors.surfaceSoft.withValues(alpha: 0.3),
      ),
      child: Text(label),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList(this.entries);
  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: AppColors.accentGold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(entry)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _JourneyVisualPlaceholder extends StatelessWidget {
  const _JourneyVisualPlaceholder(this.label, this.icon);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.4),
        ),
        color: AppColors.surface.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accentGold),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
