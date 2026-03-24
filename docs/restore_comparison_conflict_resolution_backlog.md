# Restore Comparison & Conflict Resolution Backlog

Date: 2026-03-24

Enhancement options and next steps after Phase 3:

1. Add a richer domain-comparison detail sheet with record counts and timestamp provenance for each merge-safe domain.
2. Expand safe merge beyond prayer and dhikr only after the app has explicit per-domain timestamps or traceable event IDs for more domains.
3. Add dedicated backup-history selection so users can compare multiple restore points instead of only the latest remote snapshot.
4. Add a rollback shortcut that imports the just-created safety snapshot from the restore result summary.
5. Add widget coverage for the new remote restore preview page and its warning/action states.
6. Add explicit provider/account mismatch badges on the main backup screen when remote metadata is already known.
7. Add domain-specific “why merge is unavailable” copy for replace-only domains such as Qur’an recents, learning progress snapshots, and accessibility settings.
8. Consider per-domain last-modified metadata in future backup payloads so snapshot-based domains can graduate from uncertain-difference heuristics.
9. Add a small restore history log in Accounts, Profile & Sync so users can review the last remote restore date, provider, and safety snapshot path.
10. Add device QA for preview wording and large-text layout on iPhone/iPad/macOS before release signoff.
