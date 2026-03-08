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

  String get durationLabel {
    final minutes = finishedAt.difference(startedAt).inMinutes;
    if (minutes <= 0) {
      return 'just now';
    }
    return '$minutes min';
  }
}

