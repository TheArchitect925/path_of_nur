# Post-Migration WebP Audit Backlog

1. Completed 2026-04-13: Re-ran the full WebP migration audit after the high-impact conversion, live runtime reference migration, and tightened runtime PNG policy so the counts now reflect the real current repo state.
2. Completed 2026-04-13: Verified that the high-impact runtime folders now have sibling `.webp` files on disk for all converted items, with `assets/images/backgrounds/Loading.png` remaining the only intentional PNG holdout in that migrated set.
3. Completed 2026-04-13: Confirmed the tightened runtime PNG policy passes for the right reasons, with migrated legacy PNGs recognized via sibling `.webp` plus no live runtime `.png` reference rather than broad folder-level exemptions.
4. Completed 2026-04-13: Reconfirmed exact pairwise high-impact savings at `70,833,434` bytes (`67.55 MB`, `52.15%`) across the `53` converted PNG/WebP pairs.

## Notes

- Current runtime inventory is now `80` PNG files and `62` WebP files under `assets/`.
- Remaining live runtime PNG references are outside the migrated high-impact slice and are concentrated in app icons/branding plus the kids dua story image set.
- High-impact folder verification shows no stale runtime `.png` references under backgrounds, Wudu, or prophets after the migration pass.
- `assets/images/backgrounds/Loading.png` remains allowlisted and unmatched by design pending separate visual review.

## Remaining Debt

- Next conversion targets:
  - `assets/icons/`
  - `assets/images/kids_dua_stories/`
- Policy follow-up:
  - shrink the remaining runtime allowlist after future folder conversions land
- Asset integrity debt:
  - missing `assets/images/kids_stories/...` runtime references
  - missing `assets/images/quran_teacher/...` runtime references
- Manual review:
  - decide whether `Loading.png` should stay PNG or join a later targeted conversion pass

## Enhancement Options

- Phase 10: delete only the verified legacy PNGs for the migrated high-impact set now that references and policy are aligned.
- Phase 11: repeat the same conversion, reference migration, and policy tightening pattern for `assets/icons/` and `assets/images/kids_dua_stories/`.
- Phase 12: separately resolve the unrelated missing asset integrity debt in `kids_stories` and `quran_teacher` so future audits stop mixing migration work with absent-file issues.
