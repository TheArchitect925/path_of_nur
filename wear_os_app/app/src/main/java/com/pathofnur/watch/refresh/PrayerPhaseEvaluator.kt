package com.pathofnur.watch.refresh

import com.pathofnur.watch.domain.WatchPrayerStatus
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

data class PrayerPhaseEvaluation(
    val state: PrayerPhaseState,
    val didTransition: Boolean
)

class PrayerPhaseEvaluator {
    private val formatter = DateTimeFormatter.ofPattern("h:mm a").withZone(ZoneId.systemDefault())

    fun evaluate(prayers: List<WatchPrayerStatus>, nextPrayerId: String?, nextPrayerTime: Instant?, previous: PrayerPhaseState?): PrayerPhaseEvaluation {
        val next = prayers.firstOrNull { it.prayerId == nextPrayerId } ?: prayers.firstOrNull()
        val state = PrayerPhaseState(
            currentPrayerId = previous?.nextPrayerId,
            nextPrayerId = next?.prayerId,
            nextPrayerTimeLabel = nextPrayerTime?.let { formatter.format(it) } ?: next?.scheduledTimeLabel,
            lastEvaluatedAt = System.currentTimeMillis()
        )
        val didTransition = previous?.nextPrayerId != state.nextPrayerId
        return PrayerPhaseEvaluation(state, didTransition)
    }
}

