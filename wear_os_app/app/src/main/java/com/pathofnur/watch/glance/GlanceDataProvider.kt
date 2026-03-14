package com.pathofnur.watch.glance

import android.content.Context
import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.domain.WatchDaySnapshot
import com.pathofnur.watch.domain.WatchPrayerStatus

data class WatchGlanceData(
    val nextPrayerName: String,
    val nextPrayerTime: String,
    val nextPrayerCountdown: String,
    val todayPrayerProgress: String,
    val dhikrToday: Int,
    val streakDays: Int,
    val xpToday: Int,
    val oceanDropsToday: Int,
    val lastSyncAt: String
)

class GlanceDataProvider(context: Context) {
    private val repository = WatchRepository(context)

    fun data(): WatchGlanceData {
        val snapshot = repository.snapshot()
        val prayers = repository.prayers()
        val nextPrayer = getNextPrayer(prayers, snapshot)
        return WatchGlanceData(
            nextPrayerName = nextPrayer?.displayName ?: snapshot.nextPrayerId.replaceFirstChar { it.uppercase() },
            nextPrayerTime = nextPrayer?.scheduledTimeLabel ?: snapshot.nextPrayerTimeLabel,
            nextPrayerCountdown = snapshot.nextPrayerCountdownLabel ?: "--",
            todayPrayerProgress = getPrayerProgress(snapshot),
            dhikrToday = getDhikrToday(snapshot),
            streakDays = getStreak(snapshot),
            xpToday = getXP(snapshot),
            oceanDropsToday = getOceanDrops(snapshot),
            lastSyncAt = getLastSync(snapshot)
        )
    }

    fun getNextPrayer(): WatchPrayerStatus? = getNextPrayer(repository.prayers(), repository.snapshot())

    fun getPrayerProgress(): String = getPrayerProgress(repository.snapshot())

    fun getDhikrToday(): Int = getDhikrToday(repository.snapshot())

    fun getStreak(): Int = getStreak(repository.snapshot())

    fun getXP(): Int = getXP(repository.snapshot())

    fun getOceanDrops(): Int = getOceanDrops(repository.snapshot())

    fun getLastSync(): String = getLastSync(repository.snapshot())

    private fun getNextPrayer(prayers: List<WatchPrayerStatus>, snapshot: WatchDaySnapshot): WatchPrayerStatus? {
        return prayers.firstOrNull { it.prayerId == snapshot.nextPrayerId } ?: prayers.firstOrNull()
    }

    private fun getPrayerProgress(snapshot: WatchDaySnapshot): String {
        return "${snapshot.completedPrayerCount}/${snapshot.totalPrayerCount}"
    }

    private fun getDhikrToday(snapshot: WatchDaySnapshot): Int = snapshot.dhikrTodayCount

    private fun getStreak(snapshot: WatchDaySnapshot): Int = snapshot.streakDays

    private fun getXP(snapshot: WatchDaySnapshot): Int = snapshot.xpToday

    private fun getOceanDrops(snapshot: WatchDaySnapshot): Int = snapshot.oceanDropsToday

    private fun getLastSync(snapshot: WatchDaySnapshot): String = snapshot.lastSyncLabel ?: "Not synced yet"
}

