# Final Asset Verification Audit Backlog

Date: 2026-04-13
Status: Verification audit complete

## What Verified Cleanly

- High-impact migrated runtime batches are linked correctly:
  - `assets/images/backgrounds` migrated set
  - `assets/images/wudu`
  - `assets/images/prophets`
  - `assets/images/kids_dua_stories`
- Live runtime owners for those migrated batches now point to `.webp`
- The verified legacy PNG cleanup for those batches held
- The runtime PNG policy passes without broad exemptions for the migrated folders

## Intentional Runtime PNGs Still Present

- `assets/images/backgrounds/Loading.png`
- `assets/icons/*` runtime PNGs still intentionally allowlisted pending a separate staged migration

## Separate Integrity Debt Still Present

- `kids_stories` missing art pack
- `quran_teacher` missing visual pack

These remain content-availability issues, not migrated-scope regression.

## Suggested Next Steps

1. Run a dedicated icons migration workflow instead of treating `assets/icons/` as a cleanup-only task.
2. Run a focused content-fill phase for the missing `kids_stories` and `quran_teacher` assets.
3. After icons or missing-content packs land, rerun `tooling/scripts/final_asset_verification_audit.sh`.
