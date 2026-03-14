package com.pathofnur.watch.domain

import java.time.Instant

enum class PrayerState { Pending, Completed }
enum class SourceType { Watch, Phone, Synced }
enum class DhikrMode { Preset33, Preset99, Free }
enum class DhikrInteractionMode { ManualTap, SilentTap, GuidedPulse }
enum class SyncItemType { PrayerComplete, PrayerUncomplete, DhikrIncrement, DhikrReset, SessionComplete, QuranPlaybackCommand }
enum class SyncStatus { Pending, Synced, Failed }

data class WatchDaySnapshot(
    val date: String,
    val timezone: String,
    val nextPrayerId: String,
    val nextPrayerTimeLabel: String,
    val nextPrayerCountdownLabel: String?,
    val currentPrayerId: String?,
    val completedPrayerCount: Int,
    val totalPrayerCount: Int,
    val dhikrTodayCount: Int,
    val xpToday: Int,
    val oceanDropsToday: Int,
    val streakDays: Int,
    val lastSyncLabel: String?
)

data class WatchPrayerStatus(
    val prayerId: String,
    val displayName: String,
    val scheduledTimeLabel: String,
    val status: PrayerState,
    val completedAt: Instant?,
    val source: SourceType
)

data class WatchDhikrSession(
    val sessionId: String,
    val mode: DhikrMode,
    val targetCount: Int?,
    val currentCount: Int,
    val startedAt: Instant,
    val updatedAt: Instant,
    val completed: Boolean,
    val completionMilestoneReached: Boolean,
    val rewardEligible: Boolean,
    val rewardGranted: Boolean,
    val interactionMode: DhikrInteractionMode,
    val pulseIntervalSeconds: Double?,
    val isPulseRunning: Boolean,
    val pulseTargetCount: Int?,
    val pulseCurrentStep: Int,
    val paceReminderShownAt: Instant?,
    val pausedAt: Instant?,
    val source: SourceType
)

enum class QuranPlaybackSourceType { Phone, Watch }
enum class QuranPlaybackCommand {
    Play,
    Pause,
    Next,
    Previous,
    SeekForward15,
    SeekBack15,
    SwitchOutputPhone,
    SwitchOutputWatch,
    ResumeLast
}

data class QuranPlaybackSnapshot(
    val playbackSessionId: String,
    val sourceType: QuranPlaybackSourceType,
    val isPlaying: Boolean,
    val surahId: Int?,
    val surahName: String,
    val reciterId: String,
    val reciterName: String,
    val currentAyah: Int?,
    val positionSeconds: Int,
    val durationSeconds: Int?,
    val isBuffering: Boolean,
    val lastUpdatedAt: Instant
)

data class WatchAudioAvailabilitySnapshot(
    val watchPlaybackAvailable: Boolean,
    val downloadedSurahIds: List<Int>,
    val recentPlayableItems: List<String>,
    val lastSyncedAt: Instant?
)

data class WatchSyncQueueItem(
    val id: String,
    val type: SyncItemType,
    val payload: Map<String, String>,
    val createdAt: Instant,
    val syncStatus: SyncStatus,
    val retryCount: Int
)

enum class WatchNotificationKind { Initial, FollowUp, Snooze, Dhikr }
enum class WatchReminderStatus { Scheduled, Fired, Cancelled, Expired }
enum class WatchNotificationActionType { MarkPrayed, Snooze, OpenApp, OpenDhikr, Dismiss }

data class WatchNotificationSettings(
    val prayerNotificationsEnabled: Boolean,
    val enabledPrayerIds: List<String>,
    val followUpReminderEnabled: Boolean,
    val followUpDelayMinutes: Int,
    val snoozeDurationMinutes: Int,
    val quietModeEnabled: Boolean,
    val dhikrReminderEnabled: Boolean
) {
    companion object {
        val Default = WatchNotificationSettings(
            prayerNotificationsEnabled = true,
            enabledPrayerIds = listOf("fajr", "dhuhr", "asr", "maghrib", "isha"),
            followUpReminderEnabled = true,
            followUpDelayMinutes = 20,
            snoozeDurationMinutes = 10,
            quietModeEnabled = false,
            dhikrReminderEnabled = false
        )
    }
}

data class ScheduledPrayerReminder(
    val id: String,
    val prayerId: String,
    val date: String,
    val kind: WatchNotificationKind,
    val scheduledAt: Instant,
    val status: WatchReminderStatus,
    val dedupKey: String
)

data class NotificationActionLog(
    val id: String,
    val prayerId: String?,
    val actionType: WatchNotificationActionType,
    val timestamp: Instant,
    val source: String
)

data class NotificationDedupState(
    val dedupKey: String,
    val lastScheduledAt: Instant?,
    val lastFiredAt: Instant?,
    val lastCancelledAt: Instant?
)

enum class DhikrMilestone { None, Milestone33, Milestone66, Milestone99, TargetCompleted }

data class DhikrIncrementOutcome(
    val session: WatchDhikrSession,
    val todayTotal: Int,
    val milestone: DhikrMilestone,
    val rewardGranted: Boolean,
    val shouldQueueCompletion: Boolean
)
