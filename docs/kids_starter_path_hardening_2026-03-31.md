# Kids Starter Path Hardening

## Executive Summary

The `kids-starter` guided path was safe but too tour-like. It opened broad kids surfaces without a strong sense of progression, underused the strongest beginner content, and ended without a clear handoff into deeper kids learning lanes.

This pass hardens the path into a clearer starter journey:

1. warm welcome
2. first Arabic letter
3. one short story
4. one simple dua plus clear next-lane choices

## Before

Previous sequence:

1. Kids Qur'an hub
2. Kids Arabic home
3. Kids story library
4. Kids games

Main issues:

- felt like a feature tour instead of a learning arc
- opened broad surfaces too early
- did not use kids dua as part of the starter path
- had weak completion meaning
- lacked a strong handoff into the next kids lanes

## After

Updated sequence:

1. `kids-quran` -> `learnKidsStarterBridge`
2. `kids-arabic` -> `kidsArabicLesson(letterId: alif)`
3. `kids-stories` -> `kidsStoryDetail(storyId: story_bismillah_before_eating_v1)`
4. `kids-games` -> `learnKidsStarterNextSteps`

## Step Change Reasoning

### Step 1

The first step is now a child-friendly welcome instead of dropping the learner into a broad surface immediately. This gives the path a true "start here" feeling.

### Step 2

The path now opens directly into the first Arabic letter lesson instead of the full kids Arabic home, which makes the first learning action short and concrete.

### Step 3

The story step now points to one short, meaningful story rather than the full library. `Bismillah Before Eating` was chosen because it is gentle, short, and prepares the learner naturally for the simple dua step.

### Step 4

The final step now combines simple dua reinforcement with a clear handoff into deeper kids lanes. It surfaces the real kids dua lesson for `Bismillah` and then points the learner into Arabic, stories, or more duas.

## Strong Content Reused

- Kids Arabic first-letter lesson via `kidsArabicLesson`
- Kids story detail via `kidsStoryDetail`
- Kids dua lesson via `kidsDuaLesson`

No kids content owners were duplicated or replaced.

## Completion Behavior

The final step now gives the path a clearer meaning:

- the child has started gently
- met a first letter
- heard a short story
- been shown a simple dua
- received a calm next-step choice

## Risks

- existing users who already completed the old path will now see more purposeful step content under the same step ids
- the final dua-and-handoff step is still one combined step rather than two separate curriculum steps

## Follow-up Ideas

- add a dedicated kids story-to-dua reinforcement step later if we want slightly more repetition
- create a deeper Kids Arabic path and let this starter hand off into it more explicitly
- add a kids duas starter path if we want a stronger supplication lane later
