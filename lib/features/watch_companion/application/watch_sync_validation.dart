import 'watch_sync_contract.dart';

class WatchValidationIssue {
  const WatchValidationIssue(this.message);

  final String message;
}

List<WatchValidationIssue> validateWatchDailySnapshot(
  WatchDailySnapshot snapshot,
) {
  final issues = <WatchValidationIssue>[];
  if (snapshot.snapshotId.isEmpty) {
    issues.add(const WatchValidationIssue('snapshotId is required'));
  }
  if (snapshot.date.isEmpty) {
    issues.add(const WatchValidationIssue('date is required'));
  }
  if (snapshot.totalPrayerCount != 5) {
    issues.add(const WatchValidationIssue('totalPrayerCount must be 5'));
  }
  if (snapshot.completedPrayerCount < 0 ||
      snapshot.completedPrayerCount > snapshot.totalPrayerCount) {
    issues.add(
      const WatchValidationIssue('completedPrayerCount is out of bounds'),
    );
  }
  if (snapshot.prayers.length != 5) {
    issues.add(const WatchValidationIssue('snapshot must contain 5 prayers'));
  }
  issues.addAll(validatePrayerStatuses(snapshot.prayers));
  if (snapshot.activeDhikrSession != null) {
    issues.addAll(validateDhikrSession(snapshot.activeDhikrSession!));
  }
  return issues;
}

List<WatchValidationIssue> validatePrayerStatuses(
  List<WatchPrayerStatusContract> prayers,
) {
  final issues = <WatchValidationIssue>[];
  final ids = <String>{};
  const expected = {'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'};
  for (final prayer in prayers) {
    if (!expected.contains(prayer.prayerId)) {
      issues.add(
        WatchValidationIssue('Unknown prayerId ${prayer.prayerId}'),
      );
    }
    if (!ids.add(prayer.prayerId)) {
      issues.add(
        WatchValidationIssue('Duplicate prayerId ${prayer.prayerId}'),
      );
    }
    if (prayer.displayName.isEmpty) {
      issues.add(
        WatchValidationIssue('displayName missing for ${prayer.prayerId}'),
      );
    }
    if (prayer.status != 'pending' && prayer.status != 'completed') {
      issues.add(
        WatchValidationIssue('Invalid prayer status for ${prayer.prayerId}'),
      );
    }
  }
  return issues;
}

List<WatchValidationIssue> validateDhikrSession(
  WatchDhikrSessionSnapshot session,
) {
  final issues = <WatchValidationIssue>[];
  if (session.sessionId.isEmpty) {
    issues.add(const WatchValidationIssue('sessionId is required'));
  }
  if (session.currentCount < 0) {
    issues.add(const WatchValidationIssue('currentCount cannot be negative'));
  }
  if (session.targetCount != null && session.targetCount! <= 0) {
    issues.add(const WatchValidationIssue('targetCount must be positive'));
  }
  if (session.mode != 'preset_33' &&
      session.mode != 'preset_99' &&
      session.mode != 'free') {
    issues.add(const WatchValidationIssue('Invalid dhikr mode'));
  }
  return issues;
}

List<WatchValidationIssue> validateWatchActionEnvelope(
  WatchActionEnvelope action,
) {
  final issues = <WatchValidationIssue>[];
  if (action.actionId.isEmpty) {
    issues.add(const WatchValidationIssue('actionId is required'));
  }
  if (DateTime.tryParse('${action.logicalDate}T00:00:00') == null) {
    issues.add(const WatchValidationIssue('logicalDate is invalid'));
  }
  switch (action.actionType) {
    case WatchActionType.prayerComplete:
    case WatchActionType.prayerUncomplete:
      final prayerId = action.payload['prayerId']?.toString();
      if (prayerId == null ||
          !const {'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'}.contains(prayerId)) {
        issues.add(const WatchValidationIssue('payload.prayerId is invalid'));
      }
      break;
    case WatchActionType.dhikrSessionStarted:
    case WatchActionType.dhikrIncrement:
    case WatchActionType.dhikrReset:
    case WatchActionType.dhikrSessionCompleted:
      final sessionId = action.payload['sessionId']?.toString();
      if (sessionId == null || sessionId.isEmpty) {
        issues.add(const WatchValidationIssue('payload.sessionId is required'));
      }
      break;
    case WatchActionType.snoozeRequested:
    case WatchActionType.notificationActionLogged:
      break;
  }
  return issues;
}

List<WatchValidationIssue> validateSettingsSnapshot(
  WatchSettingsSnapshot settings,
) {
  final issues = <WatchValidationIssue>[];
  if (settings.enabledPrayerIds.isEmpty) {
    issues.add(
      const WatchValidationIssue('enabledPrayerIds must not be empty'),
    );
  }
  if (settings.followUpDelayMinutes < 0) {
    issues.add(
      const WatchValidationIssue('followUpDelayMinutes cannot be negative'),
    );
  }
  if (settings.snoozeDurationMinutes <= 0) {
    issues.add(
      const WatchValidationIssue('snoozeDurationMinutes must be positive'),
    );
  }
  return issues;
}

