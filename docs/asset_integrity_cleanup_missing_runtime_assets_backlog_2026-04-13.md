# Asset Integrity Cleanup Backlog — Missing Runtime Assets

Date: 2026-04-13
Status: Audit complete, no safe auto-rewire performed

## Summary

- The `kids_stories` and `quran_teacher` image issues are primarily true missing-content gaps, not PNG/WebP migration fallout.
- No confident on-disk replacement assets were found elsewhere in the repo for the referenced missing images.
- Existing runtime surfaces already degrade safely:
  - bedtime stories fall back to built-in artwork when cover/backdrop/scene assets are missing
  - Qur'an teacher visual tiles fall back to an icon tile when image assets are missing

## Findings

- `kids_stories`
  - Missing concrete image references: 22
  - Root cause: true missing image content under `assets/images/kids_stories/...`
  - Current on-disk state: only `assets/images/kids_stories/README.md` exists
- `quran_teacher`
  - Missing concrete image references: 13 unique assets across 60 active references
  - Root cause: true missing image content under `assets/images/quran_teacher/...`
  - Current on-disk state: no image files under `assets/images/quran_teacher/...`; only `assets/data/quran_teacher/manifests/README.md` documents the intended pack layout

## Follow-Up Options

1. Create the missing kids story artwork pack:
   - covers
   - backdrops
   - the first story scene set
2. Create the missing Qur'an teacher visual pack:
   - placeholder
   - letter visuals
   - word visuals
3. Add a CI-friendly integrity audit step later, but only after the current true missing-content debt is intentionally resolved.
4. If product wants stronger non-art fallbacks later, add explicit editorial fallback metadata instead of pretending art exists.

## Notes

- No runtime path fix was applied in this pass because there was no confident asset match to redirect toward.
- This backlog is intentionally separate from the WebP migration track.
