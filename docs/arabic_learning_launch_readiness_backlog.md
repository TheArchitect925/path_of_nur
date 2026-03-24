# Arabic Learning Launch Readiness Backlog

1. Add one widget-level regression test for the adult review page so future copy, filter, or replay-audio changes cannot quietly reintroduce hardcoded labels or break the session flow.
2. Run on-device Arabic launch-readiness QA on small screens, large text, screen readers, and airplane mode across Kids home, adult Arabic landing, review, Qur’an readiness, short surahs, and guided passages.
3. Audit the remaining seeded adult lesson-step and quiz feedback strings to decide which high-traffic review/lesson content should move into structured localization next without over-localizing low-value seed internals.
4. Add one widget-level regression test for the adult landing page review sync path so future state changes cannot quietly reintroduce per-build `ensureTodaySession` scheduling.
5. Decide whether the Qur’an bridge and themed vocabulary surfaces should later expose one tiny shared “related words” preview row in search/discovery results, or stay intentionally title/subtitle-first for launch simplicity.
