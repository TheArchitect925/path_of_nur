import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'growth_statistics_provider.dart';

final growthStatisticsShareServiceProvider =
    Provider<GrowthStatisticsShareService>((ref) {
      return const GrowthStatisticsShareService();
    });

class GrowthStatisticsShareService {
  const GrowthStatisticsShareService();

  Future<void> shareText(String text) {
    return Share.share(text);
  }

  String buildWeeklySummaryShareText({
    required String localeTag,
    required GrowthStatisticsDashboardData dashboard,
  }) {
    return _buildShareText(
      localeTag: localeTag,
      title: 'Path of Nur Growth Report',
      periodLabel: 'This week',
      summary: dashboard.weeklySummary,
      comparison: dashboard.previousWeeklySummary,
      rewards: dashboard.rewardsInsight,
      bestDay: dashboard.bestDay,
    );
  }

  String buildMonthlySummaryShareText({
    required String localeTag,
    required GrowthStatisticsDashboardData dashboard,
  }) {
    return _buildShareText(
      localeTag: localeTag,
      title: 'Path of Nur Growth Report',
      periodLabel: 'This month',
      summary: dashboard.monthlySummary,
      comparison: dashboard.previousMonthlySummary,
      rewards: dashboard.rewardsInsight,
      bestDay: dashboard.bestDay,
    );
  }

  String buildSnapshotShareText({
    required String localeTag,
    required GrowthStatisticsDashboardData dashboard,
  }) {
    final countFormat = NumberFormat.decimalPattern(localeTag);
    final percentFormat = NumberFormat.decimalPercentPattern(
      locale: localeTag,
      decimalDigits: 0,
    );
    final weekly = dashboard.weeklySummary;
    final monthly = dashboard.monthlySummary;
    final lines = <String>[
      'Path of Nur Growth Snapshot',
      '',
      'This week',
      '- Prayers completed: ${countFormat.format(weekly.prayersCompleted)}',
      '- Adhkar completed: ${countFormat.format(weekly.dhikrCount)}',
      '- Qur’an time: ${_formatMinutes(localeTag, weekly.quranSeconds)}',
      '- XP gained: ${countFormat.format(weekly.xpGained)}',
      '- Drops gathered: ${countFormat.format(weekly.dropsGained)}',
      '- Consistency: ${percentFormat.format(weekly.averageDayScore.clamp(0, 1))}',
      '',
      'This month',
      '- Prayers completed: ${countFormat.format(monthly.prayersCompleted)}',
      '- Adhkar completed: ${countFormat.format(monthly.dhikrCount)}',
      '- Qur’an time: ${_formatMinutes(localeTag, monthly.quranSeconds)}',
      '- XP gained: ${countFormat.format(monthly.xpGained)}',
      '- Drops gathered: ${countFormat.format(monthly.dropsGained)}',
    ];

    final bestDay = dashboard.bestDay;
    if (bestDay != null) {
      lines.add('');
      lines.add(
        'Best day: ${DateFormat.yMMMd(localeTag).format(bestDay.day)} '
        'with ${countFormat.format(bestDay.prayersCompleted)} prayers, '
        '${countFormat.format(bestDay.dhikrCount)} adhkar, '
        '${countFormat.format(bestDay.xpGained)} XP, and '
        '${countFormat.format(bestDay.dropsGained)} drops.',
      );
    }

    return lines.join('\n');
  }

  String _buildShareText({
    required String localeTag,
    required String title,
    required String periodLabel,
    required GrowthStatsPeriodSummary summary,
    required GrowthStatsPeriodSummary? comparison,
    required GrowthRewardsInsight rewards,
    required GrowthBestDayInsight? bestDay,
  }) {
    final countFormat = NumberFormat.decimalPattern(localeTag);
    final dateFormat = DateFormat.yMMMd(localeTag);
    final lines = <String>[
      title,
      '',
      '$periodLabel (${dateFormat.format(summary.start)} - ${dateFormat.format(summary.end)})',
      '- Prayers completed: ${countFormat.format(summary.prayersCompleted)}',
      '- Adhkar completed: ${countFormat.format(summary.dhikrCount)}',
      '- Qur’an time: ${_formatMinutes(localeTag, summary.quranSeconds)}',
      '- Reflections: ${countFormat.format(summary.reflectionEntries)}',
      '- Learning completions: ${countFormat.format(summary.learningCompletions)}',
      '- XP gained: ${countFormat.format(summary.xpGained)}',
      '- Drops gathered: ${countFormat.format(summary.dropsGained)}',
      '- Active days: ${countFormat.format(summary.activeDays)}',
    ];

    if (comparison != null && comparison.hasActivity) {
      lines.add('');
      lines.add(
        'Compared with the previous period: '
        '${_buildChangeSentence(countFormat, summary, comparison)}',
      );
    }

    if (rewards.hasAnyRewardSignal) {
      lines.add('');
      lines.add(
        'Rewards insight: ${countFormat.format(rewards.weeklyXp)} XP and '
        '${countFormat.format(rewards.weeklyDrops)} drops in the last 7 days.',
      );
    }

    if (bestDay != null) {
      lines.add('');
      lines.add(
        'Best day so far: ${dateFormat.format(bestDay.day)} '
        'with ${countFormat.format(bestDay.prayersCompleted)} prayers, '
        '${countFormat.format(bestDay.dhikrCount)} adhkar, and '
        '${countFormat.format(bestDay.xpGained)} XP.',
      );
    }

    return lines.join('\n');
  }

  String _buildChangeSentence(
    NumberFormat countFormat,
    GrowthStatsPeriodSummary current,
    GrowthStatsPeriodSummary previous,
  ) {
    final changes = <String>[];
    final prayerDiff = current.prayersCompleted - previous.prayersCompleted;
    final xpDiff = current.xpGained - previous.xpGained;
    final dropsDiff = current.dropsGained - previous.dropsGained;
    if (prayerDiff != 0) {
      changes.add(
        '${prayerDiff > 0 ? '+' : ''}${countFormat.format(prayerDiff)} prayers',
      );
    }
    if (xpDiff != 0) {
      changes.add('${xpDiff > 0 ? '+' : ''}${countFormat.format(xpDiff)} XP');
    }
    if (dropsDiff != 0) {
      changes.add(
        '${dropsDiff > 0 ? '+' : ''}${countFormat.format(dropsDiff)} drops',
      );
    }
    if (changes.isEmpty) {
      return 'steady progress across the same core areas.';
    }
    return changes.join(', ');
  }

  String _formatMinutes(String localeTag, int seconds) {
    final minutes = Duration(seconds: seconds).inMinutes;
    return '${NumberFormat.decimalPattern(localeTag).format(minutes)} min';
  }
}
