# Quran Playback Follow Fix Follow-ups

Date: 2026-04-10

## Recommended next enhancement options

1. Add one clearer playback-only visual cue in the ayah card once logic QA is confirmed on device, so route highlight and playback highlight are easier to distinguish without redesigning the card.
2. Add one focused reader-page harness test for “manual scroll during playback, settle, then next ayah auto-resumes follow” once the existing broader harness timer debt is cleaned up.
3. Audit whether `QuranPlaybackSourceState.ready` should preserve the last transition target more explicitly during source swaps, or whether the new remembered-active-ayah fallback is sufficient after device QA.
4. Consider a tiny non-intrusive “following playback” vs “follow paused” state hint only if product QA still finds follow ownership unclear after this logic fix.
5. Run real-device QA on longer surahs and reciter switching during surah playback to confirm the new transition-safe ayah ownership stays stable outside test harness timing.

## Notes

- This pass intentionally fixed logic first and did not redesign playback visuals.
- A future visual polish pass should only happen after on-device confirmation that current-ayah ownership and follow resume behavior now feel correct.
