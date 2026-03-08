import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/prayer_controller.dart';
import '../../domain/daily_prayer_record.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_status.dart';
import '../../domain/prayer_summary.dart';

class PrayerSection extends ConsumerWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(prayerControllerProvider);
    final summary = ref.watch(prayerSummaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Prayer',
          subtitle: 'Track the five daily prayers with intention, not pressure.',
        ),
        _PrayerSummaryCard(summary: summary),
        const SizedBox(height: 14),
        ...records.map(
          (record) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PrayerItemCard(record: record),
          ),
        ),
        const SizedBox(height: 6),
        const SectionTitle(
          title: 'Weekly Consistency',
          subtitle: 'Simple mood-first streak preview for today and the week.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '7-day snapshot',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  _ConsistencyDot(completed: true),
                  _ConsistencyDot(completed: true),
                  _ConsistencyDot(completed: false),
                  _ConsistencyDot(completed: true),
                  _ConsistencyDot(completed: false),
                  _ConsistencyDot(completed: true),
                  _ConsistencyDot(completed: true),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Keep it gentle. Even one mindful cycle matters.',
                style: TextStyle(color: AppColors.onSurfaceSubtle),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Reminder',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Small, steady steps shape rhythm. Pause for intention before every prayer, and return with mercy if you miss one.',
                style: TextStyle(
                  color: AppColors.onSurfaceSubtle,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrayerSummaryCard extends StatelessWidget {
  const _PrayerSummaryCard({required this.summary});

  final PrayerSummary summary;

  @override
  Widget build(BuildContext context) {
    final progress = summary.progress;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${summary.completed}/${summary.total}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      backgroundColor: AppColors.surfaceSoft,
                      color: AppColors.accentGoldSoft,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Completion today is a compass, not a scorecard. Stay balanced and kind to your pace.',
                  style: TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerItemCard extends ConsumerWidget {
  const _PrayerItemCard({required this.record});

  final DailyPrayerRecord record;

  Color _statusColor(PrayerStatus status) {
    switch (status) {
      case PrayerStatus.pending:
        return AppColors.caution;
      case PrayerStatus.completed:
        return AppColors.success;
      case PrayerStatus.missed:
        return AppColors.onSurfaceSubtle;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () =>
            ref.read(prayerControllerProvider.notifier).cycleStatus(record.prayer),
        child: Row(
          children: [
            Icon(record.prayer.icon, color: AppColors.onSurface),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.prayer.label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 3),
                Text(record.prayer.arabic, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: _statusColor(record.status).withValues(alpha: 0.15),
                border: Border.all(
                  color: _statusColor(record.status).withValues(alpha: 0.40),
                ),
              ),
              child: Text(
                record.status.label,
                style: TextStyle(
                  color: _statusColor(record.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsistencyDot extends StatelessWidget {
  const _ConsistencyDot({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: completed
              ? AppColors.success.withValues(alpha: 0.75)
              : AppColors.surfaceSoft,
        ),
      ),
    );
  }
}
