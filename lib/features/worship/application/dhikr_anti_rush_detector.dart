class DhikrAntiRushDetector {
  DhikrAntiRushDetector({
    this.thresholdTapCount = 8,
    this.rapidTapWindow = const Duration(seconds: 2),
    this.minimumAverageInterval = const Duration(milliseconds: 250),
    this.cooldown = const Duration(seconds: 45),
  });

  final int thresholdTapCount;
  final Duration rapidTapWindow;
  final Duration minimumAverageInterval;
  final Duration cooldown;

  final List<DateTime> _recentTapTimes = <DateTime>[];
  DateTime? _lastTriggeredAt;

  bool registerTap(DateTime timestamp) {
    _recentTapTimes.add(timestamp);
    _trimWindow(timestamp);

    if (_recentTapTimes.length < thresholdTapCount) {
      return false;
    }
    if (_lastTriggeredAt != null &&
        timestamp.difference(_lastTriggeredAt!) < cooldown) {
      return false;
    }

    final first = _recentTapTimes.first;
    final totalWindow = timestamp.difference(first);
    if (totalWindow > rapidTapWindow) {
      return false;
    }

    final intervalCount = _recentTapTimes.length - 1;
    if (intervalCount <= 0) {
      return false;
    }
    final averageIntervalMicros = totalWindow.inMicroseconds / intervalCount;
    if (averageIntervalMicros >
        minimumAverageInterval.inMicroseconds.toDouble()) {
      return false;
    }

    _lastTriggeredAt = timestamp;
    _recentTapTimes.clear();
    return true;
  }

  void reset() {
    _recentTapTimes.clear();
  }

  void _trimWindow(DateTime timestamp) {
    final cutoff = timestamp.subtract(rapidTapWindow);
    _recentTapTimes.removeWhere((tapTime) => tapTime.isBefore(cutoff));
  }
}
