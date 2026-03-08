import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/quran_quote_block.dart';
import '../../../shared/widgets/section_title.dart';

class WorshipPageLegacy extends StatelessWidget {
  const WorshipPageLegacy({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: l10n.worshipTitle,
      subtitle: l10n.worshipSubtitle,
      quote: const QuranQuote(
        arabic: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
        transliteration: 'Wastaeenoo bis-sabri was-salah',
        translation: 'Seek help through patience and prayer.',
        surah: 2,
        verse: 45,
        locationLabel: 'Qur’an 2:45',
      ),
      onQuoteTap: (quote) => openQuranQuoteLocation(context, quote),
      children: [
        const SectionTitle(
          title: 'Worship Pillars',
          subtitle: 'Primary actions that ground your day.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTile(
                icon: Icons.spa_outlined,
                title: 'Prayer',
                subtitle: 'Complete and log daily ṣalāt sessions.',
                onTap: () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': 'prayer'},
                ),
              ),
              const Divider(),
              _SectionTile(
                icon: Icons.auto_awesome,
                title: 'Dhikr',
                subtitle: 'Keep your remembrance sessions intentional.',
                onTap: () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': 'dhikr'},
                ),
              ),
              const Divider(),
              _SectionTile(
                icon: Icons.restaurant_outlined,
                title: 'Fasting',
                subtitle: 'Track fast status and reflection checkpoints.',
                onTap: () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': 'fasting'},
                ),
              ),
              const Divider(),
              _SectionTile(
                icon: Icons.self_improvement_outlined,
                title: 'Khusū Mode',
                subtitle: 'Distraction-minimized focus space for remembrance.',
                onTap: () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': 'khusu'},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(
          title: 'Daily Worship Summary',
          subtitle: 'A lightweight dashboard placeholder.',
        ),
        PremiumCard(
          child: InkWell(
            onTap: () => context.pushNamed(
              'featureSection',
              pathParameters: {'sectionId': 'worshipSummary'},
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.accentGoldSoft,
                  child: Icon(Icons.checklist_rtl, color: AppColors.background),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 of 5 worship pillars touched today',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('Keep the rhythm steady and gentle.'),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.onSurfaceSubtle),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle(
          title: 'Quick Access',
          subtitle: 'Fast open-in placeholders for future actions.',
        ),
        PremiumCard(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickActionChip(
                label: 'Start Prayer',
                sectionId: 'prayer',
              ),
              _QuickActionChip(
                label: 'Launch Dhikr',
                sectionId: 'dhikr',
              ),
              _QuickActionChip(
                label: 'Mark Fast',
                sectionId: 'fasting',
              ),
              _QuickActionChip(
                label: 'Enter Khusū',
                sectionId: 'khusu',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentGold),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.onSurfaceSubtle,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.label, required this.sectionId});

  final String label;
  final String sectionId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        'featureSection',
        pathParameters: {'sectionId': sectionId},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accentGoldSoft.withValues(alpha: 0.45),
          ),
          color: AppColors.surfaceSoft.withValues(alpha: 0.4),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

