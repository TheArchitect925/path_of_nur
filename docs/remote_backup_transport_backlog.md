# Remote Backup Transport Backlog

Date: 2026-03-24

Enhancement options and next steps after Phase 2:

1. Add a true remote-backup history list with multiple restore points instead of the current single latest-backup transport contract.
2. Add a richer restore-comparison sheet with per-domain counts and clearer “remote newer/local newer” risk messaging before confirmed replace.
3. Build the backend-backed email remote backup transport and reuse the new `BackupTransport` contract instead of adding a parallel cloud path.
4. Add real-device Apple QA for signed builds with iCloud disabled, unavailable, and switching-account edge cases.
5. Add real-device Google Drive QA for revoked auth, expired sessions, and Drive API permission changes.
6. Add a remote-backup checksum/integrity banner in the UI if a downloaded payload validates structurally but fails checksum expectations.
7. Add a restore rollback shortcut that can immediately re-import the safety snapshot if a user intentionally wants to undo a remote replace.
8. Add platform-specific setup diagnostics for missing Apple ubiquity container identifiers and missing Google Drive API enablement.
9. Add widget coverage for the new remote-backup section on the Accounts, Profile & Sync page once the current settings test harness is less brittle.
10. Consider encrypted remote backup payloads later, but only if key management is solved cleanly without weakening the local/manual path.
