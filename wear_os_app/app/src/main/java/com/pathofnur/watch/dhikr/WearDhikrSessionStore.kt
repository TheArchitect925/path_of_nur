package com.pathofnur.watch.dhikr

import android.content.Context
import com.pathofnur.watch.domain.DhikrMode
import com.pathofnur.watch.domain.DhikrInteractionMode
import com.pathofnur.watch.domain.SourceType
import com.pathofnur.watch.domain.WatchDhikrSession
import java.time.Instant
import java.util.UUID

class WearDhikrSessionStore(context: Context) {
    private val prefs = context.getSharedPreferences("path_of_nur_watch", Context.MODE_PRIVATE)

    fun loadSession(): WatchDhikrSession {
        val mode = DhikrMode.valueOf(prefs.getString("dhikrMode", DhikrMode.Preset33.name)!!)
        val target = prefs.getInt("dhikrTarget", 33).takeIf { it > 0 }
        return WatchDhikrSession(
            sessionId = prefs.getString("dhikrSessionId", UUID.randomUUID().toString())!!,
            mode = mode,
            targetCount = target,
            currentCount = prefs.getInt("dhikrCount", 0),
            startedAt = Instant.ofEpochMilli(prefs.getLong("dhikrStartedAt", Instant.now().toEpochMilli())),
            updatedAt = Instant.ofEpochMilli(prefs.getLong("dhikrUpdatedAt", Instant.now().toEpochMilli())),
            completed = prefs.getBoolean("dhikrCompleted", false),
            completionMilestoneReached = prefs.getBoolean("dhikrCompletionMilestoneReached", false),
            rewardEligible = prefs.getBoolean("dhikrRewardEligible", false),
            rewardGranted = prefs.getBoolean("dhikrRewardGranted", false),
            interactionMode = DhikrInteractionMode.valueOf(prefs.getString("dhikrInteractionMode", DhikrInteractionMode.ManualTap.name)!!),
            pulseIntervalSeconds = prefs.getLong("dhikrPulseIntervalMillis", 2500L).toDouble() / 1000.0,
            isPulseRunning = prefs.getBoolean("dhikrPulseRunning", false),
            pulseTargetCount = prefs.getInt("dhikrPulseTarget", 0).takeIf { it > 0 },
            pulseCurrentStep = prefs.getInt("dhikrPulseStep", 0),
            paceReminderShownAt = prefs.getLong("dhikrPaceReminderShownAt", 0L).takeIf { it > 0L }?.let(Instant::ofEpochMilli),
            pausedAt = prefs.getLong("dhikrPausedAt", 0L).takeIf { it > 0L }?.let(Instant::ofEpochMilli),
            source = SourceType.Watch
        )
    }

    fun saveSession(session: WatchDhikrSession) {
        prefs.edit()
            .putString("dhikrSessionId", session.sessionId)
            .putString("dhikrMode", session.mode.name)
            .putInt("dhikrTarget", session.targetCount ?: 0)
            .putInt("dhikrCount", session.currentCount)
            .putLong("dhikrStartedAt", session.startedAt.toEpochMilli())
            .putLong("dhikrUpdatedAt", session.updatedAt.toEpochMilli())
            .putBoolean("dhikrCompleted", session.completed)
            .putBoolean("dhikrCompletionMilestoneReached", session.completionMilestoneReached)
            .putBoolean("dhikrRewardEligible", session.rewardEligible)
            .putBoolean("dhikrRewardGranted", session.rewardGranted)
            .putString("dhikrInteractionMode", session.interactionMode.name)
            .putLong("dhikrPulseIntervalMillis", ((session.pulseIntervalSeconds ?: 2.5) * 1000).toLong())
            .putBoolean("dhikrPulseRunning", session.isPulseRunning)
            .putInt("dhikrPulseTarget", session.pulseTargetCount ?: 0)
            .putInt("dhikrPulseStep", session.pulseCurrentStep)
            .putLong("dhikrPaceReminderShownAt", session.paceReminderShownAt?.toEpochMilli() ?: 0L)
            .putLong("dhikrPausedAt", session.pausedAt?.toEpochMilli() ?: 0L)
            .apply()
    }
}
