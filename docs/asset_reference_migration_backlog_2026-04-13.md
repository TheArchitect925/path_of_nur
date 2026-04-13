# Asset Reference Migration Backlog

Last updated: 2026-04-13

## Current Blocker

- Phase 2 safe migration is currently blocked because the source-controlled `assets/` tree does not contain matching `.webp` files for the runtime `.png` references that were audited.
- The repo currently has only a small set of existing WebP files under `assets/images/prophets/Stories/` plus one prophet card, while the active source references point to many other PNG assets.

## Recommended Enhancement Options

1. Run the Phase 1 conversion for real so the actual source-controlled `assets/` tree contains the expected `.webp` siblings before attempting reference replacement.
2. Add a narrow audit helper that reports only source-controlled runtime asset references and excludes generated, ephemeral, platform-icon, and documentation noise.
3. After real conversion, rerun Phase 2 and update only app-owned source files under `lib/`, relevant tests, and `pubspec.yaml` where matching WebPs truly exist.
4. Add a post-conversion verification step that compares every candidate `.png` reference against on-disk `.webp` files before any edits are applied.
5. Consider a future CI check that blocks Phase 3 deletion until all runtime references are migrated and verified.

## Notes

- Search/indexing impact: none.
- Localization impact: none.
- No safe source-file replacement was performed in this pass because matching source-controlled WebP assets were not present.
