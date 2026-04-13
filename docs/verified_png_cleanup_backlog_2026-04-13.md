# Verified PNG Cleanup Backlog

Last updated: 2026-04-13

## Current Cleanup Posture

- No source-controlled runtime asset PNGs were safe to delete in this pass.
- All `80` PNGs under `assets/` currently remain because none of them have sibling `.webp` files in the source-controlled `assets/` tree.
- Platform PNGs under `ios/`, `android/`, `macos/`, `web/`, and tvOS remain intentionally preserved because they are packaging or native-resource assets.

## Recommended Enhancement Options

1. Complete the real source-controlled PNG-to-WebP conversion before attempting another cleanup pass.
2. Rerun the Phase 2 reference migration after actual WebP assets exist, then use this cleanup helper to identify truly removable PNGs.
3. Add a reporting mode that writes `SAFE TO DELETE`, `KEEP`, and `REVIEW` results to a checked-in Markdown or CSV audit artifact.
4. Add an optional allowlist for platform-native PNG paths so cleanup reports stay quieter and focus on Flutter asset candidates.
5. Add a future CI check that blocks deletion unless a matching WebP exists and no live source reference remains.

## Notes

- Search/indexing impact: none.
- Localization impact: none.
- No meaningful files were deleted in this pass, so the cleanup archive workflow was not triggered.
