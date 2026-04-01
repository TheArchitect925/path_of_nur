# Qur’an Beginner Soft Bridge Backlog

Date: 2026-03-31

## Enhancement Options

### High Impact / Low Risk

1. Add a small completion-aware card on the soft bridge page that acknowledges users who already started `quranDailyCompanion`.
2. Add one tiny note on the bridge that gently distinguishes reading, listening, and reflection if QA shows beginners still feel unsure how to begin.
3. Teach personalization to recommend the soft bridge more confidently for learners with Foundations complete and no recent Qur’an activity.

### Medium Impact / Low Risk

1. Add one calm follow-up bridge for the step between `quranSummaryPage` and `quranExplorer` if the full explorer still feels too abrupt after QA.
2. Revisit whether `quranSummaryPage` or another canonical `/quran/*` surface is the best second step once beginner user testing is available.
3. Add a small “return to today’s ayah” shortcut on the bridge page if product wants repeat visits without opening a second hub.

### Medium Impact / Medium Risk

1. Audit the `quranSummaryPage` itself for beginner-friendliness if learners still feel overwhelmed after the new soft bridge.
2. Consider one lightweight Qur’an-intimidation onboarding metric for future personalization, but only if it stays local, explainable, and non-invasive.

## Do Not Break

- keep `quran-beginner-starter` path id stable
- keep existing Qur’an Beginner step ids stable unless a real migration plan is added
- preserve `/quran/*` as canonical
- do not duplicate reader, playback, or tafsir ownership under Learn
- keep the bridge lightweight and avoid turning it into a second Qur’an hub

## Recommended Next Pass

If continuing curriculum hardening in order, the safest next pass is:

1. Kids Starter Path progression hardening
2. Stories starter-path hardening
3. Character path closure hardening
