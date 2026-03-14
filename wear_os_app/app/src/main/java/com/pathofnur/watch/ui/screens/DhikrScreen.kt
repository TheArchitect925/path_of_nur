package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.*
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.CompactChip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.domain.DhikrMode
import com.pathofnur.watch.domain.DhikrInteractionMode
import com.pathofnur.watch.domain.WatchDhikrSession
import com.pathofnur.watch.ui.components.WatchStatCard

@Composable
fun DhikrScreen(
    session: WatchDhikrSession,
    todayTotal: Int,
    onIncrement: () -> Unit,
    onMode: (DhikrMode) -> Unit,
    onInteractionMode: (DhikrInteractionMode) -> Unit,
    onPulseFaster: () -> Boolean,
    onPulseSlower: () -> Unit,
    onPulseResetSteady: () -> Unit,
    onGuidedStart: () -> Unit,
    onGuidedPause: () -> Unit,
    onGuidedStop: () -> Unit,
    onReset: () -> Unit,
    onBack: () -> Unit
) {
    var pendingMode by remember { mutableStateOf<DhikrMode?>(null) }
    var pendingInteractionMode by remember { mutableStateOf<DhikrInteractionMode?>(null) }
    var confirmReset by remember { mutableStateOf(false) }
    var showPaceReminder by remember { mutableStateOf(false) }

    WatchStatCard("Dhikr", "${session.currentCount}")
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.ManualTap) pendingInteractionMode = DhikrInteractionMode.ManualTap else onInteractionMode(DhikrInteractionMode.ManualTap)
        },
        label = { Text("Manual") }
    )
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.SilentTap) pendingInteractionMode = DhikrInteractionMode.SilentTap else onInteractionMode(DhikrInteractionMode.SilentTap)
        },
        label = { Text("Silent") }
    )
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.GuidedPulse) pendingInteractionMode = DhikrInteractionMode.GuidedPulse else onInteractionMode(DhikrInteractionMode.GuidedPulse)
        },
        label = { Text("Guided") }
    )
    if (session.targetCount != null) {
        Text("${minOf(session.currentCount, session.targetCount)} / ${session.targetCount}")
    }
    if (session.completed) {
        Text(if (session.mode == DhikrMode.Preset33) "33 complete" else if (session.mode == DhikrMode.Preset99) "99 complete" else "Session complete")
    }
    if (session.interactionMode == DhikrInteractionMode.GuidedPulse) {
        Text("Pulse ${String.format("%.2fs", session.pulseIntervalSeconds ?: 2.5).replace(".00", "")}")
        Chip(onClick = onPulseSlower, label = { Text("Slower") })
        Chip(onClick = {
            if (!onPulseFaster()) {
                showPaceReminder = true
            }
        }, label = { Text("Faster") })
        if (session.isPulseRunning) {
            Button(onClick = onGuidedPause) { Text("Pause") }
        } else {
            Button(onClick = onGuidedStart) { Text(if (session.currentCount == 0) "Start" else "Resume") }
        }
        CompactChip(onClick = onGuidedStop, label = { Text("Stop") })
        Text("Follow the pulse calmly.")
    } else {
        Button(onClick = onIncrement) { Text("Tap to count") }
    }
    if (pendingMode != null || pendingInteractionMode != null) {
        Text("Start a new dhikr session?")
        CompactChip(
            onClick = {
                pendingMode?.let(onMode)
                pendingInteractionMode?.let(onInteractionMode)
                pendingMode = null
                pendingInteractionMode = null
            },
            label = { Text("Start New") }
        )
        CompactChip(onClick = {
            pendingMode = null
            pendingInteractionMode = null
        }, label = { Text("Cancel") })
    } else if (confirmReset) {
        Text("Reset session?")
        CompactChip(
            onClick = {
                onReset()
                confirmReset = false
            },
            label = { Text("Reset") }
        )
        CompactChip(onClick = { confirmReset = false }, label = { Text("Cancel") })
    } else if (showPaceReminder) {
        Text("Take your time")
        Text("Dhikr is better with reflection than rushing.")
        CompactChip(
            onClick = { showPaceReminder = false },
            label = { Text("Keep pace") }
        )
        CompactChip(
            onClick = {
                onPulseResetSteady()
                showPaceReminder = false
            },
            label = { Text("Steady pace") }
        )
    } else {
        Chip(
            onClick = {
                if (session.currentCount > 0 && session.mode != DhikrMode.Preset33) pendingMode = DhikrMode.Preset33 else onMode(DhikrMode.Preset33)
            },
            label = { Text("33") }
        )
        Chip(
            onClick = {
                if (session.currentCount > 0 && session.mode != DhikrMode.Preset99) pendingMode = DhikrMode.Preset99 else onMode(DhikrMode.Preset99)
            },
            label = { Text("99") }
        )
        Chip(
            onClick = {
                if (session.currentCount > 0 && session.mode != DhikrMode.Free) pendingMode = DhikrMode.Free else onMode(DhikrMode.Free)
            },
            label = { Text("Free") }
        )
        CompactChip(onClick = { if (session.currentCount > 0) confirmReset = true else onReset() }, label = { Text("Reset") })
    }
    Text("Today $todayTotal")
    Chip(onClick = onBack, label = { Text("Back") })
}
