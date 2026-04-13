# Runtime PNG Policy Backlog

Last updated: 2026-04-13

## Follow-up Options

1. Replace the temporary directory-prefix allowlist with narrower file-level entries as each runtime PNG group is migrated to WebP.
2. Add a tiny helper command that prints just the current allowlisted runtime PNG counts by prefix so reviewers can track the migration backlog more easily.
3. Extend the checker later to suggest candidate WebP conversion commands for newly detected violations without auto-modifying assets.
4. Add a future asset dashboard or audit report that combines runtime PNG policy, oversized image checks, and migration status in one place.
5. Consider a later low-noise informational check for runtime `.png` source references that are not backed by an on-disk asset, but keep it non-blocking unless proven reliable.

## Current Policy Shape

- Runtime PNGs under `assets/` are blocked by default unless allowlisted.
- Native/platform PNGs remain approved by path.
- CI now enforces the check in the main validation workflow.
