package com.pathofnur.watch.dhikr

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import com.pathofnur.watch.domain.DhikrMilestone

class WearDhikrHapticEngine(context: Context) {
    private val vibrator: Vibrator? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        val manager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
        manager.defaultVibrator
    } else {
        @Suppress("DEPRECATION")
        context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
    }

    fun playConfirmation() {
        vibrate(12L)
    }

    fun playGuidancePulse() {
        vibrate(14L)
    }

    fun play(milestone: DhikrMilestone) {
        val duration = when (milestone) {
            DhikrMilestone.None -> return
            DhikrMilestone.Milestone33, DhikrMilestone.Milestone66, DhikrMilestone.Milestone99 -> 20L
            DhikrMilestone.TargetCompleted -> 35L
        }
        vibrate(duration)
    }

    private fun vibrate(duration: Long) {
        vibrator?.vibrate(VibrationEffect.createOneShot(duration, VibrationEffect.DEFAULT_AMPLITUDE))
    }
}
