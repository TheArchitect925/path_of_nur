# Asset WebP Migration Backlog

Last updated: 2026-04-13

## Enhancement Options

1. Add an optional report mode that writes a CSV or Markdown summary of source PNG size versus generated WebP size for easier review before reference updates.
2. Add path-based heuristics so `assets/icons/` defaults to lossless regardless of file size while large backgrounds and illustrations default to lossy.
3. Add a verification mode that checks for Flutter code and `pubspec.yaml` references still pointing to PNG files after a controlled migration pass.
4. Add a `MAX_FILES` flag for small canary runs against a subset of assets before full-repo conversion.
5. Add CI linting that blocks newly added oversized PNGs when an equivalent WebP is expected.
6. Add a second-phase helper to generate a reference-rewrite report without editing code automatically.
7. After visual QA, add a separately gated cleanup mode for removing original PNGs only when matching WebPs are verified and code references are updated.

## Notes

- This backlog is intentionally separate from the script so the first pass stays safe and reviewable.
- Search/indexing impact: none for this phase.
- Localization impact: none for this phase.
