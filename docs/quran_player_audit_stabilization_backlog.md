# Quran Player Audit Stabilization Backlog

Date: 2026-03-24

## Recommended Enhancements

- Add a dedicated `QuranReaderPlaybackState` provider so `quran_reader_page.dart`, readiness bridge pages, and future tvOS parity work read the same active ayah/playback snapshot instead of each surface deriving it separately.
- Add widget-level regression coverage for the real `QuranReaderPage` with a fake player stream so pause, seek, and current-ayah highlight behavior are tested end to end instead of only via harness widgets.
- Surface reciter-switch behavior more explicitly during active playback. Right now reciter persistence exists, but the “switch while already playing” flow is still implicit and should either hot-reload safely or prompt clearly.
- Add a stronger visible “Now reciting” ayah treatment that survives reduced-motion and large-text layouts, not just border/shadow emphasis.
- Persist and restore follow-mode state per session so long-form recitation resumes more predictably after background/foreground transitions.
- Audit tvOS Qur'an playback parity against the stabilized mobile orchestrator and move tvOS to the same active-ayah resolution rules if it still derives playback state differently.

## Technical Follow-up

- Extract more of the reader-page playback lifecycle into shared helpers/providers; `quran_reader_page.dart` is still too heavy and still owns too many subscriptions.
- Introduce richer per-track timing readiness state so the UI can distinguish “word sync unavailable”, “loading”, and “ayah-only fallback” instead of treating them as one path.
- Add a controlled reciter sample flow separate from the main player session so sample playback never mutates reader-session assumptions.
