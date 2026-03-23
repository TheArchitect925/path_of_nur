import '../../../l10n/app_localizations.dart';
import '../application/growth_statistics_provider.dart';
import '../drops/domain/journey_drops_models.dart';

extension GrowthStatisticsLocalizations on AppLocalizations {
  String get growthStatisticsTitleText => 'Statistics';

  String get growthStatisticsSubtitleText =>
      'Review your recent worship, learning, and reward progress in one place.';

  String get growthStatisticsOpenJourneyActionText => 'Open journey';

  String get growthStatisticsSummaryTitleText => 'Summary';

  String get growthStatisticsSummarySubtitleText =>
      'A calm view of your recent worship, learning, and reward progress.';

  String get growthStatisticsMonthlySummaryTitleText => 'Monthly summary';

  String get growthStatisticsMonthlySummarySubtitleText =>
      'Your broader rhythm across the last four weeks.';

  String get growthStatisticsTrendsTitleText => 'Trends';

  String get growthStatisticsTrendsSubtitleText =>
      'Simple activity charts built from recent real progress.';

  String get growthStatisticsWeeklyTrendTitleText => 'Weekly trend';

  String get growthStatisticsWeeklyTrendSubtitleText =>
      'Daily momentum across the last 7 days.';

  String get growthStatisticsMonthlyTrendTitleText => 'Monthly trend';

  String get growthStatisticsMonthlyTrendSubtitleText =>
      'Week-by-week rhythm across the last 28 days.';

  String get growthStatisticsInsightsTitleText => 'Insights';

  String get growthStatisticsInsightsSubtitleText =>
      'Grounded highlights from your recent growth.';

  String get growthStatisticsBestDayTitleText => 'Your best day';

  String get growthStatisticsBestDayEmptyText =>
      'Keep going. This insight will appear once you have a stronger spread of activity.';

  String get growthStatisticsBestDayReasonPrefixText =>
      'Best day means your strongest combined consistency score, with XP and drops used as tie-breakers.';

  String get growthStatisticsRewardsInsightsTitleText => 'Rewards insights';

  String get growthStatisticsRewardsInsightsEmptyText =>
      'Keep logging prayers, Qur’an, dhikr, and learning to see how they shape your rewards.';

  String get growthStatisticsReportsTitleText => 'Reports and sharing';

  String get growthStatisticsReportsSubtitleText =>
      'Share a clean snapshot without exposing raw app data.';

  String get growthStatisticsShareWeeklyActionText => 'Share weekly report';

  String get growthStatisticsShareMonthlyActionText => 'Share monthly report';

  String get growthStatisticsShareSnapshotActionText => 'Share snapshot';

  String get growthStatisticsEmptyTrendText =>
      'Not enough recent activity yet for a meaningful chart.';

  String get growthStatisticsThisWeekLabelText => 'This week';

  String get growthStatisticsThisMonthLabelText => 'This month';

  String get growthStatisticsComparedToPreviousLabelText =>
      'Compared with the previous period';

  String get growthStatisticsPrayersLabelText => 'Prayers';

  String get growthStatisticsAdhkarLabelText => 'Adhkar';

  String get growthStatisticsQuranLabelText => 'Qur’an';

  String get growthStatisticsReflectionsLabelText => 'Reflections';

  String get growthStatisticsLearningLabelText => 'Learning';

  String get growthStatisticsXpLabelText => 'XP';

  String get growthStatisticsDropsLabelText => 'Drops';

  String get growthStatisticsActiveDaysLabelText => 'Active days';

  String get growthStatisticsConsistencyLabelText => 'Consistency';

  String growthStatisticsBestDayBodyText(
    String dateLabel,
    String prayers,
    String adhkar,
    String quranMinutes,
    String xp,
    String drops,
  ) {
    return '$dateLabel was your strongest day so far, with $prayers prayers, $adhkar adhkar, $quranMinutes of Qur’an time, $xp XP, and $drops drops.';
  }

  String growthStatisticsRewardsBodyText(
    String xp,
    String drops,
    String topXpSource,
    String topDropSource,
  ) {
    return 'Over the last 7 days you gained $xp XP and $drops drops. Your strongest XP source was $topXpSource, and your main drop source was $topDropSource.';
  }

  String growthStatisticsWeeklyChangeText(String change) {
    return 'Compared with the previous period: $change';
  }

  String growthStatisticsPeriodDateRangeText(String start, String end) {
    return '$start - $end';
  }

  String growthStatisticsReportCardBodyText(String title, String body) {
    return '$title\n$body';
  }

  String localizedRewardSourceLabel(String? sourceModule) {
    switch (sourceModule) {
      case 'worship':
      case 'prayer':
        return 'prayer';
      case 'quran':
        return 'Qur’an';
      case 'learn':
      case 'learning':
        return 'learning';
      case 'dhikr':
        return 'dhikr';
      case 'fasting':
        return 'fasting';
      default:
        return 'steady worship';
    }
  }

  String localizedDropSourceLabel(DropSourceType? sourceType) {
    switch (sourceType) {
      case DropSourceType.prayer:
        return 'prayer';
      case DropSourceType.dhikr:
        return 'dhikr';
      case DropSourceType.learning:
        return 'learning';
      case DropSourceType.quran:
        return 'Qur’an';
      case DropSourceType.fasting:
        return 'fasting';
      case null:
        return 'steady worship';
    }
  }

  String growthStatisticsComparisonSummaryText(
    GrowthStatsPeriodSummary current,
    GrowthStatsPeriodSummary previous,
  ) {
    final prayerDiff = current.prayersCompleted - previous.prayersCompleted;
    final xpDiff = current.xpGained - previous.xpGained;
    final dropDiff = current.dropsGained - previous.dropsGained;
    final changes = <String>[];
    if (prayerDiff != 0) {
      changes.add('${prayerDiff > 0 ? '+' : ''}$prayerDiff prayers');
    }
    if (xpDiff != 0) {
      changes.add('${xpDiff > 0 ? '+' : ''}$xpDiff XP');
    }
    if (dropDiff != 0) {
      changes.add('${dropDiff > 0 ? '+' : ''}$dropDiff drops');
    }
    if (changes.isEmpty) {
      return 'Steady across the same core areas.';
    }
    return changes.join(' • ');
  }
}
