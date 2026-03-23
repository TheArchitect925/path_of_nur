# Qur'an tvOS Parity Audit

Date: 2026-03-22

## Scope checked

- tvOS Qur'an playback controls
- tvOS active ayah indication
- parity with the current mobile Qur'an reader playback/highlight restoration

## Findings

1. tvOS pause/play behavior is present and functionally mirrors the basic mobile control loop.
2. tvOS advances ayah-to-ayah through `TVQuranViewModel` selection state and `AVPlayer` item completion.
3. tvOS did not have a strong active-playback visual treatment comparable to the restored mobile active ayah state.
4. tvOS does not currently implement mobile-style player-position-driven word sync highlight.

## Safe parity change applied

- `TVQuranAyahCard` now adds a clearer active playback border and glow when the selected ayah is actively playing.

## Remaining intentional divergence

- tvOS still uses ayah-level active playback highlighting only.
- tvOS does not yet have a word timing metadata pipeline comparable to mobile.
- That divergence is acceptable for now because the current tvOS Qur'an surface is still seed-backed and does not own the same synced timing architecture as mobile.

## Recommended next parity step

- If tvOS Qur'an playback moves beyond the current seed-backed V1 surface, add a shared active-ayah playback state contract before attempting any word-level sync parity.
