# tvOS Enhancement Backlog

Last updated: 2026-03-18

## Recommended next enhancements

1. Replace seeded Home prayer data with logic and presentation that stays in lockstep with the mobile Home prayer section.
2. Expand Qur'an parity so tvOS tracks the current mobile Qur'an page structure, browsing depth, continue-reading state, and playback behavior more closely.
3. Move seeded Home and Qur'an content into shared bundled assets or bridged data sources so tvOS does not drift from the mobile app.
4. Add richer playback support:
   `AVPlayer` state polish, Now Playing metadata, remote handling, and more faithful parity with the mobile Qur'an experience.
5. Finish tvOS asset work:
   layered app icon, Top Shelf artwork, accent color assets, and release-ready branding.
6. Decide whether Top Shelf is in scope; if yes, wire the extension into the main project and provide real content instead of `nil`.
7. Add tvOS QA coverage:
   target build check, simulator smoke pass, focus navigation verification, and asset validation.
8. Add a parity checklist so every future mobile Home prayer or Qur'an change gets a same-pass tvOS review.
9. Align docs with code reality so release posture, target wiring, and backlog status are no longer contradictory.

## Prompt-ready work items

- Prompt 1: Replace the seeded Home prayer snapshot in `ios/PathOfNurTV` with a data path that reuses or mirrors the current mobile Home prayer logic without creating a second ownership model.
- Prompt 2: Expand the canonical tvOS Qur'an page so surah browsing, continue reading, and playback controls track the current mobile Qur'an experience more closely.
- Prompt 3: Wire richer audio state into the canonical tvOS Qur'an page, including Now Playing metadata, remote control behavior, and safer end-of-track handling.
- Prompt 4: Add release-readiness checks for tvOS assets, Top Shelf posture, build validation, and parity verification against the mirrored mobile surfaces.
