package com.pathofnur.watch.ui.screens

import androidx.compose.runtime.*
import androidx.compose.ui.res.stringResource
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.CompactChip
import androidx.wear.compose.material.Text
import com.pathofnur.watch.R
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

    WatchStatCard(stringResource(R.string.label_dhikr), "${session.currentCount}")
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.ManualTap) pendingInteractionMode = DhikrInteractionMode.ManualTap else onInteractionMode(DhikrInteractionMode.ManualTap)
        },
        label = { Text(stringResource(R.string.dhikr_mode_manual)) }
    )
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.SilentTap) pendingInteractionMode = DhikrInteractionMode.SilentTap else onInteractionMode(DhikrInteractionMode.SilentTap)
        },
        label = { Text(stringResource(R.string.dhikr_mode_silent)) }
    )
    Chip(
        onClick = {
            if (session.currentCount > 0 && session.interactionMode != DhikrInteractionMode.GuidedPulse) pendingInteractionMode = DhikrInteractionMode.GuidedPulse else onInteractionMode(DhikrInteractionMode.GuidedPulse)
        },
        label = { Text(stringResource(R.string.dhikr_mode_guided)) }
    )
    if (session.targetCount != null) {
        Text("${minOf(session.currentCount, session.targetCount)} / ${session.targetCount}")
    }
    if (session.completed) {
        Text(
            stringResource(
                when (session.mode) {
                    DhikrMode.Preset33 -> R.string.dhikr_preset_33_complete
                    DhikrMode.Preset99 -> R.string.dhikr_preset_99_complete
                    DhikrMode.Free -> R.string.dhikr_session_complete
                }
            )
        )
    }
    if (session.interactionMode == DhikrInteractionMode.GuidedPulse) {
        Text(stringResource(R.string.dhikr_pulse, String.format("%.2fs", session.pulseIntervalSeconds ?: 2.5).replace(".00", "")))
        Chip(onClick = onPulseSlower, label = { Text(stringResource(R.string.dhikr_pace_slower)) })
        Chip(onClick = {
            if (!onPulseFaster()) {
                showPaceReminder = true
            }
        }, label = { Text(stringResource(R.string.dhikr_pace_faster)) })
        if (session.isPulseRunning) {
            Button(onClick = onGuidedPause) { Text(stringResource(R.string.action_pause)) }
        } else {
            Button(onClick = onGuidedStart) {
                Text(stringResource(if (session.currentCount == 0) R.string.action_start else R.string.action_resume))
            }
        }
        CompactChip(onClick = onGuidedStop, label = { Text(stringResource(R.string.action_stop)) })
        Text(stringResource(R.string.dhikr_follow_pulse))
    } else {
        Button(onClick = onIncrement) { Text(stringResource(R.string.dhikr_tap_to_count)) }
    }
    if (pendingMode != null || pendingInteractionMode != null) {
        Text(stringResource(R.string.dhikr_start_new_question))
        CompactChip(
            onClick = {
                pendingMode?.let(onMode)
                pendingInteractionMode?.let(onInteractionMode)
                pendingMode = null
                pendingInteractionMode = null
            },
            label = { Text(stringResource(R.string.dhikr_start_new)) }
        )
        CompactChip(onClick = {
            pendingMode = null
            pendingInteractionMode = null
        }, label = { Text(stringResource(R.string.action_cancel)) })
    } else if (confirmReset) {
        Text(stringResource(R.string.dhikr_reset_question))
        CompactChip(
            onClick = {
                onReset()
                confirmReset = false
            },
            label = { Text(stringResource(R.string.action_reset)) }
        )
        CompactChip(onClick = { confirmReset = false }, label = { Text(stringResource(R.string.action_cancel)) })
    } else if (showPaceReminder) {
        Text(stringResource(R.string.dhikr_take_your_time))
        Text(stringResource(R.string.dhikr_reflection_over_rushing))
        CompactChip(
            onClick = { showPaceReminder = false },
            label = { Text(stringResource(R.string.dhikr_keep_pace)) }
        )
        CompactChip(
            onClick = {
                onPulseResetSteady()
                showPaceReminder = false
            },
            label = { Text(stringResource(R.string.dhikr_steady_pace)) }
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
            label = { Text(stringResource(R.string.dhikr_free)) }
        )
        CompactChip(onClick = { if (session.currentCount > 0) confirmReset = true else onReset() }, label = { Text(stringResource(R.string.action_reset)) })
    }
    Text(stringResource(R.string.dhikr_today_total, todayTotal))
    Chip(onClick = onBack, label = { Text(stringResource(R.string.action_back)) })
}
