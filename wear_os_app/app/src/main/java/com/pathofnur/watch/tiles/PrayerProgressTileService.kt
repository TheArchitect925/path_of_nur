package com.pathofnur.watch.tiles

import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.Futures
import com.google.common.util.concurrent.ListenableFuture
import com.pathofnur.watch.R
import com.pathofnur.watch.glance.GlanceDataProvider

class PrayerProgressTileService : TileService() {
    override fun onTileRequest(requestParams: RequestBuilders.TileRequest): ListenableFuture<TileBuilders.Tile> {
        val data = GlanceDataProvider(this).data()
        val nextPrayer = GlanceDataProvider(this).getNextPrayer()?.displayName ?: data.nextPrayerName
        val root = materialTile(
            title = getString(R.string.tile_todays_prayers),
            main = listOf(
                text("${data.todayPrayerProgress} Completed", 22f, true),
                text("Next: $nextPrayer", 16f, false)
            ),
            bottom = emptyList(),
            clickable = launchAction(TileRoutes.SCREEN_PRAYERS)
        )

        return Futures.immediateFuture(
            TileBuilders.Tile.Builder()
                .setResourcesVersion("1")
                .setFreshnessIntervalMillis(30 * 60 * 1000L)
                .setTileTimeline(
                    TimelineBuilders.Timeline.Builder()
                        .addTimelineEntry(
                            TimelineBuilders.TimelineEntry.Builder()
                                .setLayout(
                                    LayoutElementBuilders.Layout.Builder()
                                        .setRoot(root(requestParams.deviceParameters!!, root))
                                        .build()
                                )
                                .build()
                        )
                        .build()
                )
                .build()
        )
    }

    override fun onResourcesRequest(requestParams: RequestBuilders.ResourcesRequest): ListenableFuture<ResourceBuilders.Resources> {
        return Futures.immediateFuture(ResourceBuilders.Resources.Builder().setVersion("1").build())
    }
}

