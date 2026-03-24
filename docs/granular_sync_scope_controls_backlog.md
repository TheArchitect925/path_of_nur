# Granular Sync Scope Controls Backlog

Last updated: 2026-03-24

Enhancement options saved after Phase 5:

1. Add widget-level coverage for the new Sync Scope card and restore-preview scope summary so partial/full backup messaging cannot regress quietly.
2. Add richer per-domain serialization boundaries for currently grouped snapshot domains so future scope controls can separate Qur'an, reminders, settings, and theme data more precisely.
3. Decide whether manual export should gain an optional “export current sync scope only” mode while preserving the current full-export fallback.
4. Add a backup-history comparison surface that shows scope differences across older backups, not just the currently selected remote payload.
5. Introduce per-domain last-modified metadata so restore comparison and auto-backup dirty detection can move beyond whole-payload fingerprinting.
6. Add explicit “remote backup is partial” status wording to the top backup-status card when the latest remote metadata excludes optional domains.
7. Evaluate whether journal media or richer note attachments need a separate optional sync domain before expanding the journal feature.
8. Add real-device QA across Apple and Google backup providers for scope changes, partial backup upload, restore preview mismatch messaging, and excluded-domain preservation after restore.
