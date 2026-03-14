package com.pathofnur.watch.sync

interface WatchSyncBridge {
    suspend fun requestSnapshot()
    suspend fun flushPendingActions()
}

class StubWatchSyncBridge : WatchSyncBridge {
    override suspend fun requestSnapshot() = Unit
    override suspend fun flushPendingActions() = Unit
}
