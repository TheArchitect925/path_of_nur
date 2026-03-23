# Qur'an Reader Playback Backlog

Last updated: 2026-03-22

## Enhancement options

1. Add a focused widget/integration test harness for reader playback state so play, pause, resume, and ayah highlight behavior can be exercised without relying on string-scan coverage.
2. Cache per-ayah word timing metadata locally for the active reciter so repeat playback and pause/resume flows do not depend on repeated network timing fetches.
3. Add a subtle paused-state ayah treatment distinct from the active-playing treatment so the current ayah remains visually anchored without looking like audio is still running.
4. Expand live sync support beyond the current supported reciters only if the timing source is trustworthy and consistent with existing Qur'an audio ownership.
5. Audit tvOS Qur'an playback parity after this mobile restoration so mirrored playback and active-ayah behavior do not drift.
