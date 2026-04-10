import '../../l10n/app_localizations.dart';

String buildCompactRewardSummary(
  AppLocalizations l10n, {
  required int xp,
  required int drops,
}) {
  if (xp > 0 && drops > 0) {
    return l10n.rewardQuietCompletionSummaryXpDrops(xp, drops);
  }
  if (xp > 0) {
    return l10n.rewardQuietCompletionSummaryXpOnly(xp);
  }
  if (drops > 0) {
    return l10n.rewardQuietCompletionSummaryDropsOnly(drops);
  }
  return l10n.rewardQuietProgressSaved;
}
