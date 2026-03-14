package com.pathofnur.watch.refresh

import com.pathofnur.watch.data.WatchRepository
import java.time.LocalDate
import java.time.ZoneId

data class DayRolloverOutcome(
    val performed: Boolean
)

class DayRolloverEngine(private val repository: WatchRepository) {
    fun performIfNeeded(): DayRolloverOutcome {
        val snapshot = repository.snapshot()
        val today = LocalDate.now(ZoneId.systemDefault()).toString()
        if (snapshot.date == today) return DayRolloverOutcome(false)
        repository.rolloverToToday(today)
        return DayRolloverOutcome(true)
    }
}

