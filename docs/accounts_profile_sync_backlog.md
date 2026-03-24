# Accounts, Profile & Sync Backlog

Last updated: 2026-03-24

## Enhancement options

1. Add a backend-backed email sign-in flow with real verification, account recovery, and device-scoped session refresh.
2. Connect authenticated Apple and Google accounts to a real remote backup transport instead of the current honest local/manual-backup posture.
3. Add a dedicated remote-backup history view with multiple restore points instead of the current latest-backup summary only.
4. Add import preview support for unsupported-domain reporting so users can see exactly which backup sections will be skipped before restore.
5. Add a stronger post-import reconciliation pass for profile/account linking when imported accounts differ from the device's previously connected account identities.
6. Add widget-level regression coverage for the main Accounts, Profiles & Sync page, the signed-in accounts page, and backup import/export flows.
7. Add a native device-info layer to backup metadata so exports can show richer source labels than the current app/device summary fields.
8. Add a share-after-export confirmation sheet that offers `Share`, `Reveal in Files`, and `Done` instead of the current one-tap share action after export creation.
9. Decide whether remote backup should prefer Apple iCloud for Apple-only users and a backend transport for Google/email users, or unify all remote backup behind one backend.
10. Add large-text and screen-reader QA for the Accounts, Profiles & Sync surfaces before release signoff.
