import '../../../l10n/app_localizations.dart';

class DhikrSession {
  const DhikrSession({
    required this.phraseLabel,
    required this.count,
    required this.target,
    required this.startedAt,
    required this.finishedAt,
  });

  final String phraseLabel;
  final int count;
  final int target;
  final DateTime startedAt;
  final DateTime finishedAt;

  Duration get duration {
    final difference = finishedAt.difference(startedAt);
    if (difference.isNegative) {
      return Duration.zero;
    }
    return difference;
  }

  String localizedDurationLabel(AppLocalizations l10n) {
    final minutes = duration.inMinutes;
    if (minutes <= 0) {
      return l10n.dhikrDurationJustNow;
    }
    return l10n.dhikrDurationMinutes('$minutes');
  }
}
