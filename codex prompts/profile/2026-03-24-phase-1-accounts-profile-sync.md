# Phase 1 Prompt — Accounts, Profile & Sync

PRIMARY OBJECTIVE === BUILDING ACCOUNTS, PROFILE & SYNC

You are working in the existing Flutter codebase for Path of Nūr.

Build a production-ready Accounts, Profile & Sync system under the existing settings/profile architecture so users can safely back up and restore their progress through:
- Sign in with Apple
- Sign in with Google
- Sign in with Email
- Manual export
- Manual import
- Local-only usage without any account

CRITICAL PRODUCT RULES
- The app must remain offline-first.
- Account creation/sign-in must be optional, never forced.
- This feature is for backup, restore, sync readiness, and account identity management.
- Do not rebuild unrelated areas.
- Do not remove or break any current local-only flows.
- Do not delete, overwrite, reset, or corrupt any existing user progress for any reason.
- Do not introduce fake working flows. If something is scaffolded but not fully wired, the UI must state that honestly.
- Build on top of the current implementation. Extend, organize, and stabilize. Do not rip out working systems.

CRITICAL DATA SAFETY RULES
- Audit first before making changes.
- Never delete records unnecessarily.
- Never blindly overwrite local data during import/restore.
- Any destructive action must require explicit user confirmation.
- Import files must be validated before any write happens.
- If restore/import fails, preserve current local data.
- Prefer merge-safe patterns where practical.
- If merge is too risky in V1 for some domains, implement safe replace with full confirmation and backup snapshot protection.
- Create temporary safety snapshots before risky restore/import actions where practical.

==================================================
PHASE GOALS
==================================================

Create a real, production-ready Accounts, Profile & Sync area that gives the user:
1. Account sign-in options
2. Clear sync / backup status
3. Manual export
4. Manual import
5. Restore foundation
6. Safe architecture for future cloud sync
7. Honest UI for what works now vs what needs backend/platform configuration

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing anything, audit the current codebase and summarize:

- existing profile page(s)
- existing settings page(s)
- any account or sync related UI
- any current auth packages already installed
- any Apple Sign-In implementation
- any Google Sign-In implementation
- any email auth implementation
- existing local storage architecture
- all major user progress storage locations
- current export/import support if any
- any cloud sync or backup abstractions already present
- where this feature should live inside the current IA without breaking existing flows

Identify the safest additive implementation path.

Do not start rebuilding from scratch if the existing structure can be extended.

==================================================
STEP 2 — INFORMATION ARCHITECTURE
==================================================

Add or refine a dedicated section named:

Accounts, Profile & Sync

This should live in the most natural place within the current Profile / Settings structure.

Recommended subsections:
- Account
- Backup & Sync
- Import / Export
- Privacy & Data Control

Recommended items/cards/actions:
- Continue with Apple
- Continue with Google
- Continue with Email
- Continue Local Only
- Account status
- Backup status
- Last backup timestamp
- Export my data
- Import data
- Restore from backup
- Sync preferences
- Sign out
- Data stored on this device

Keep the Path of Nūr visual language:
- calm
- elegant
- premium
- simple
- not cluttered
- not overly corporate

==================================================
STEP 3 — DOMAIN / MODEL LAYER
==================================================

Create or refine clean domain models for account and sync state.

Support at minimum:
- auth provider enum
- account identity model
- sync status model
- backup metadata model
- import/export package model
- restore result / conflict model
- sync preferences model

Auth provider states:
- local_only
- apple
- google
- email

Sync / backup states:
- local_only
- signed_in_no_backup
- backup_available
- backup_in_progress
- restore_available
- sync_error

Backup metadata should support fields such as:
- provider
- account identifier or display label
- last backup timestamp
- schema version
- app version
- backup source type
- optional device info if useful

Keep models production-ready, but do not overengineer.

==================================================
STEP 4 — AUTHENTICATION ARCHITECTURE
==================================================

Implement a proper auth abstraction.

Use repository/service boundaries such as:
- AuthRepository
- AccountRepository
- SyncRepository
- BackupRepository

Do not place auth logic directly inside the UI.

If packages are available and can be wired safely:
- implement Sign in with Apple
- implement Google Sign-In

If Email auth backend is not yet ready:
- build the architecture and UI shell honestly
- do not fake success
- clearly show if Email is “coming next” or “not yet connected”

Handle:
- cancellation
- sign-in failure
- sign-out
- provider-specific account state
- localization
- state refresh after auth changes

==================================================
STEP 5 — APPLE / GOOGLE / EMAIL OPTIONS
==================================================

Add the sign-in options into Accounts, Profile & Sync.

Requirements:
- Continue with Apple
- Continue with Google
- Continue with Email
- Continue Local Only

Behavior expectations:
- User can remain fully local with no account
- Sign-in should not erase local progress
- Signing in should connect account state to backup/sync readiness
- If backend remote backup is not yet active, still capture/use auth state where possible and show backup as not yet configured rather than pretending it works

Email option:
- If a real email auth flow already exists, integrate it properly
- If not, build the architecture shell and honest UI, not fake completion

==================================================
STEP 6 — MANUAL EXPORT
==================================================

Implement a real manual export feature.

Export should create a structured backup file, preferably JSON-based, with metadata and versioning.

Export as much relevant user data as safely available, including where applicable:
- profile basics
- settings/preferences
- prayer tracking history
- dhikr history/counters
- Qur’an progress / bookmarks / recents
- streaks
- rings/goals
- XP / levels
- drops / ocean progress
- learning progress
- journal/notes if local and appropriate
- reminders/preferences
- theme/accessibility settings
- any other important user progress

Requirements:
- include schema version
- include app version
- validate serialization before finalizing export
- exclude secrets/tokens/internal credentials
- provide user feedback on success/failure
- use a safe save/share flow appropriate to platform

==================================================
STEP 7 — MANUAL IMPORT
==================================================

Implement a real manual import flow.

Requirements:
- user selects an import file
- validate schema
- validate version compatibility
- reject malformed/incomplete files safely
- preview what is about to be imported
- do not write any data before validation completes
- allow confirmation before applying

Support these user choices if practical:
- Merge with current local data
- Replace current local data
- Cancel

If a safe merge is not practical for all data domains in V1:
- implement safe replace only where necessary
- clearly explain it
- create a safety snapshot before applying
- never do silent replace

After import:
- refresh providers/state
- preserve app stability
- surface any partial unsupported data clearly

==================================================
STEP 8 — BACKUP / RESTORE FOUNDATION
==================================================

Build the backup/restore foundation even if remote transport is not fully wired yet.

Create:
- backup status UI
- restore flow shell
- repository interfaces for remote backup
- sync preferences UI
- “Back up now” and “Restore backup” entry points
- last backup display
- account-linked backup state model

If remote backup is not actually active yet:
- keep UI honest
- disable or annotate unavailable actions
- do not fake backup existence
- structure code so real cloud sync can be added cleanly in the next phase

==================================================
STEP 9 — LOCAL DATA PROTECTION
==================================================

Before risky restore/import actions:
- create a temporary local backup snapshot if practical
- write atomically where possible
- guard against malformed payloads
- guard against schema mismatch
- guard against unsupported future schema versions
- fail safely
- preserve previous local state on failure

Never leave the app in a half-imported corrupted state.

==================================================
STEP 10 — UI / UX REQUIREMENTS
==================================================

The UI must clearly communicate:
- You can use Path of Nūr without an account
- Signing in helps with backup and restore
- Your data may still be local-only unless backed up
- Manual export/import is always available as a fallback

Recommended top status card content:
- Current mode: Local only / Connected
- Provider: Apple / Google / Email / None
- Backup status: Never backed up / Last backup [date]
- CTA: Back up now / Export data

Recommended helper copy tone:
- calm
- concise
- reassuring
- clear
- non-technical

Keep everything aligned to the existing Path of Nūr theme.

==================================================
STEP 11 — STATE MANAGEMENT
==================================================

Use the existing app state management architecture consistently.

Likely required:
- account state provider
- auth action controller
- backup/sync status provider
- import/export controller
- restore controller

Ensure correct refresh/invalidation after:
- sign in
- sign out
- export
- import
- restore
- sync status changes

==================================================
STEP 12 — LOCALIZATION
==================================================

All new user-facing strings must go through the existing localization system.

Do not hardcode strings into widgets.

==================================================
STEP 13 — TESTING
==================================================

Add or update tests for the new implementation.

At minimum cover:
- account state mapping
- auth provider state transitions
- export serialization
- import validation
- malformed file rejection
- schema version handling
- restore/import safety rules
- sign-out does not delete local progress
- local-only vs signed-in UI states

==================================================
STEP 14 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on all changed files
- fix warnings/errors where reasonable
- clean up dead placeholder account/sync code only if it is truly obsolete
- keep naming consistent
- keep file ownership boundaries clean
- avoid duplicate abstractions

==================================================
DELIVERABLES
==================================================

At the end, provide:

1. Audit summary before changes
2. Files changed
3. What was fully implemented
4. What was scaffolded but not yet backend-wired
5. Where Accounts, Profile & Sync now lives
6. How Apple sign-in works
7. How Google sign-in works
8. How Email works or what is pending
9. How export works
10. How import works
11. How restore/backup status works
12. What platform/backend setup is still required outside code
13. Risks or follow-up notes

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, run a final audit and provide one complete summary of:
- what is complete
- what is partial
- what still needs credentials/platform setup
- what should be done in Phase 2
- any risk areas
- any cleanup still recommended

Do not stop at placeholders.
Build this into a real production-ready extension of the existing app.
Always preserve existing user progress.
Always prefer safe additive implementation.
Never go haywire and remove/delete records for no reason.

===== END PROMPT =====
