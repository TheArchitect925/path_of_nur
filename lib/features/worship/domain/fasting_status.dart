enum FastingStatus {
  notFasting,
  intending,
  completed,
  broken,
}

extension FastingStatusX on FastingStatus {
  String get label {
    switch (this) {
      case FastingStatus.notFasting:
        return 'Not fasting';
      case FastingStatus.intending:
        return 'Intending to fast';
      case FastingStatus.completed:
        return 'Completed';
      case FastingStatus.broken:
        return 'Missed / Broken';
    }
  }
}

