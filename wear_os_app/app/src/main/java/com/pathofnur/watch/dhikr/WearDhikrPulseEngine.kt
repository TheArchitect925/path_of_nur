package com.pathofnur.watch.dhikr

import kotlinx.coroutines.*

class WearDhikrPulseEngine {
    private var job: Job? = null

    fun start(scope: CoroutineScope, intervalSeconds: Double, onPulse: suspend () -> Unit) {
        stop()
        job = scope.launch {
            while (isActive) {
                delay((intervalSeconds * 1000).toLong())
                onPulse()
            }
        }
    }

    fun stop() {
        job?.cancel()
        job = null
    }
}
