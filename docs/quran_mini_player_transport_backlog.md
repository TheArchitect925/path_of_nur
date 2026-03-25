# Qur'an Mini-Player Transport Backlog

Last updated: 2026-03-24

## Recommended enhancements

1. Add a router-backed reader test that exercises previous-surah and next-surah transitions through the real `GoRouter` stack instead of only controller/global-state coverage.
2. Run real-device QA for the shell mini-player on small phones, including long titles, background playback return, bottom-nav overlap, and paused-session recovery.
3. Decide whether whole-surah repeat should become a first-class surfaced playback mode or remain intentionally limited to repeat-range plus loop-count settings until device QA validates the simpler contract.
4. Evaluate whether the shell mini-player should expose `replay current ayah` when previous/next ayah transport is unavailable, but only if that stays calmer than a denser transport bar.
5. Review watch/tvOS Qur'an playback consumers against the new global mini-player and normalized transport metadata contract so mirrored playback surfaces do not regress into shell-vs-reader drift.
6. Add a compact mini-player repeat indicator only if QA shows the current reader-only repeat summary is not visible enough during long listening sessions.
7. Decide whether adjacent-surah playback should later auto-advance through the shared controller path or remain explicit button-driven until the route and session contract is validated on device.
