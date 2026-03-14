package com.pathofnur.watch.dhikr

import java.time.Instant

sealed interface WearDhikrPaceDecision {
    data class Updated(val seconds: Double) : WearDhikrPaceDecision
    data object Blocked : WearDhikrPaceDecision
}

object WearDhikrPacePolicy {
    const val defaultInterval = 2.5
    const val steadyInterval = 2.5
    const val minimumAllowed = 1.8
    const val maximumAllowed = 3.5
    const val step = 0.25

    fun faster(current: Double): WearDhikrPaceDecision {
        val next = ((current - step) * 100.0).toInt() / 100.0
        return if (next < minimumAllowed) WearDhikrPaceDecision.Blocked else WearDhikrPaceDecision.Updated(next)
    }

    fun slower(current: Double): WearDhikrPaceDecision {
        val next = ((current + step) * 100.0).toInt() / 100.0
        return WearDhikrPaceDecision.Updated(minOf(maximumAllowed, next))
    }

    fun shouldShowReminder(lastShownAt: Instant?, now: Instant = Instant.now()): Boolean {
        return lastShownAt == null || now.toEpochMilli() - lastShownAt.toEpochMilli() > 300_000L
    }
}
