package com.pathofnur.watch.dhikr

import com.pathofnur.watch.domain.DhikrMilestone
import com.pathofnur.watch.domain.DhikrMode

class DhikrMilestonePolicy {
    fun evaluate(
        mode: DhikrMode,
        previousCount: Int,
        newCount: Int,
        targetCount: Int?,
        previousTodayTotal: Int
    ): Evaluation {
        val completed = targetCount != null && previousCount < targetCount && newCount >= targetCount
        val rewardFromPreset = completed && mode != DhikrMode.Free
        val crossedHundred = mode == DhikrMode.Free && (previousTodayTotal / 100) < ((previousTodayTotal + 1) / 100)
        val rewardGranted = rewardFromPreset || crossedHundred

        if (completed) return Evaluation(DhikrMilestone.TargetCompleted, true, true, rewardGranted)
        if (previousCount < 99 && newCount >= 99) return Evaluation(DhikrMilestone.Milestone99, false, false, rewardGranted)
        if (mode == DhikrMode.Preset99 && previousCount < 66 && newCount >= 66) return Evaluation(DhikrMilestone.Milestone66, false, false, rewardGranted)
        if (previousCount < 33 && newCount >= 33) return Evaluation(DhikrMilestone.Milestone33, false, false, rewardGranted)
        return Evaluation(DhikrMilestone.None, false, false, rewardGranted)
    }

    data class Evaluation(
        val milestone: DhikrMilestone,
        val completed: Boolean,
        val rewardEligible: Boolean,
        val rewardGranted: Boolean
    )
}

