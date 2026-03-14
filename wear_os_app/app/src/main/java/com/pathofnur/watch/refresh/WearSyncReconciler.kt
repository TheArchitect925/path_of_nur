package com.pathofnur.watch.refresh

import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.sync.WatchSyncBridge

class WearSyncReconciler(
    private val repository: WatchRepository,
    private val syncBridge: WatchSyncBridge
) {
    suspend fun attemptSync(): Boolean {
        syncBridge.flushPendingActions()
        return repository.queue().isEmpty()
    }
}

