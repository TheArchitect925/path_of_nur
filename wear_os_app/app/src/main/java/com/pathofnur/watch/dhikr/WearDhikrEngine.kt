package com.pathofnur.watch.dhikr

import com.pathofnur.watch.domain.DhikrIncrementOutcome
import com.pathofnur.watch.domain.DhikrMode
import com.pathofnur.watch.domain.SourceType
import com.pathofnur.watch.domain.WatchDhikrSession
import java.time.Instant
import java.util.UUID

class WearDhikrEngine {
    private val policy = DhikrMilestonePolicy()
    private var lastIncrementAt: Instant? = null
    private val debounceMillis = 35L

    fun increment(session: WatchDhikrSession, todayTotal: Int, now: Instant = Instant.now()): DhikrIncrementOutcome? {
        val last = lastIncrementAt
        if (last != null && now.toEpochMilli() - last.toEpochMilli() < debounceMillis) return null
        lastIncrementAt = now

        val newCount = session.currentCount + 1
        val evaluation = policy.evaluate(session.mode, session.currentCount, newCount, session.targetCount, todayTotal)
        val nextSession = session.copy(
            currentCount = newCount,
            updatedAt = now,
            completed = session.completed || evaluation.completed,
            completionMilestoneReached = session.completionMilestoneReached || evaluation.completed,
            rewardEligible = session.rewardEligible || evaluation.rewardEligible,
            rewardGranted = session.rewardGranted || evaluation.rewardGranted,
            pulseCurrentStep = newCount,
            source = SourceType.Watch
        )
        return DhikrIncrementOutcome(
            session = nextSession,
            todayTotal = todayTotal + 1,
            milestone = evaluation.milestone,
            rewardGranted = evaluation.rewardGranted,
            shouldQueueCompletion = evaluation.completed
        )
    }

    fun newSession(mode: DhikrMode, now: Instant = Instant.now()): WatchDhikrSession {
        val target = when (mode) {
            DhikrMode.Preset33 -> 33
            DhikrMode.Preset99 -> 99
            DhikrMode.Free -> null
        }
        return WatchDhikrSession(
            sessionId = UUID.randomUUID().toString(),
            mode = mode,
            targetCount = target,
            currentCount = 0,
            startedAt = now,
            updatedAt = now,
            completed = false,
            completionMilestoneReached = false,
            rewardEligible = false,
            rewardGranted = false,
            interactionMode = com.pathofnur.watch.domain.DhikrInteractionMode.ManualTap,
            pulseIntervalSeconds = 2.5,
            isPulseRunning = false,
            pulseTargetCount = target,
            pulseCurrentStep = 0,
            paceReminderShownAt = null,
            pausedAt = null,
            source = SourceType.Watch
        )
    }
}
