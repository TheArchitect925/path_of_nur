package com.pathofnur.watch.tiles

import android.content.Context
import androidx.wear.tiles.TileService

object TileUpdateCoordinator {
    fun refreshAll(context: Context) {
        TileService.getUpdater(context).requestUpdate(NextPrayerTileService::class.java)
        TileService.getUpdater(context).requestUpdate(PrayerProgressTileService::class.java)
        TileService.getUpdater(context).requestUpdate(DhikrTileService::class.java)
    }
}

