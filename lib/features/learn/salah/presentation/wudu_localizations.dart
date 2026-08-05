import '../../../../l10n/app_localizations.dart';

extension WuduLocalizations on AppLocalizations {
  String wuduTrainerRewardFeedbackText(int xp, int drops) {
    if (xp > 0 && drops > 0) {
      return wuduTrainerRewardFeedbackXpDrops(xp, drops);
    }
    if (xp > 0) return wuduTrainerRewardFeedbackXpOnly(xp);
    if (drops > 0) return wuduTrainerRewardFeedbackDropsOnly(drops);
    return wuduTrainerRewardFeedbackAlreadyCounted;
  }

  String wuduQuizRewardFeedbackText(int xp, int drops) {
    if (xp > 0 && drops > 0) return wuduQuizRewardFeedback(xp, drops);
    if (xp > 0) return wuduQuizRewardFeedbackXpOnly(xp);
    if (drops > 0) return wuduQuizRewardFeedbackDropsOnly(drops);
    return wuduQuizRewardFeedbackAlreadyCounted;
  }
}
