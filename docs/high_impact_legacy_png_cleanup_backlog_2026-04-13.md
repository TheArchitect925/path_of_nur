# High-Impact Legacy PNG Cleanup Backlog

1. Completed 2026-04-13: Audited the migrated high-impact cleanup scope and classified `53` legacy PNGs as safe to delete, with `assets/images/backgrounds/Loading.png` retained as the only intentional holdout.
2. Completed 2026-04-13: Added a narrow verified cleanup helper at `tooling/scripts/remove_verified_high_impact_legacy_pngs.sh` that only targets the approved high-impact folders, archives files before deletion, and refuses to delete when a sibling `.webp` is missing or a live runtime `.png` reference still exists.
3. Completed 2026-04-13: Archived the verified delete set before cleanup under `/Users/shahabmansoor/Developer/Path of Nur Deleted and Cleaned Items/2026-04-13/high-impact-legacy-png-cleanup/`.
4. Completed 2026-04-13: Removed the verified legacy PNGs for the migrated high-impact set while preserving `Loading.png` and leaving all native/platform PNGs untouched.

## Notes

- The cleanup scope is intentionally limited to `assets/images/backgrounds`, `assets/images/wudu`, and `assets/images/prophets`.
- The helper script defaults to dry-run mode and requires `DELETE_CONFIRMED=true` for actual deletion.
- The archive copy is a convenience recovery layer in addition to git history.

## Validation

- Baseline cleanup-scope PNG count: `54`
- Safely deleted: `53`
- Intentionally kept: `1`
- Manual review: `0`
- `Loading.png` remains untouched.
- The runtime PNG policy check should continue to pass after cleanup, with migrated legacy counts in those folders dropping because the old PNGs are gone.

## Enhancement Options

- Phase 11: run the same convert -> migrate refs -> tighten policy -> audit -> cleanup workflow for `assets/icons/` and `assets/images/kids_dua_stories/`.
- Phase 12: resolve unrelated missing asset integrity debt in `kids_stories` and `quran_teacher`.
- Phase 13: tighten the runtime PNG allowlist further as additional folders finish migration.
