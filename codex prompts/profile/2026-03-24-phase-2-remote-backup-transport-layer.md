# PHASE 2 PROMPT — REMOTE BACKUP TRANSPORT LAYER

PRIMARY OBJECTIVE === BUILDING REMOTE BACKUP TRANSPORT LAYER

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the already-added Accounts, Profile & Sync foundation.

Your task is to implement the real remote backup transport layer so authenticated users can safely back up and restore their progress across devices, while preserving the app’s offline-first architecture and without risking data loss.

SUPPORTED DIRECTIONS FOR THIS PHASE
- Apple account backup path
- Google account backup path
- Email account backup path architecture
- Real remote backup metadata handling
- Real backup upload/download flow
- Restore from remote backup flow
- Sync status visibility
- Safe conflict-aware restore preparation

CRITICAL PRODUCT RULES
- The app must remain offline-first.
- Users must still be able to use the app fully without signing in.
- Remote backup is optional.
- Do not delete, reset, migrate, or overwrite local progress unless the user explicitly confirms a restore/replace action.
- Do not create fake cloud success states.
- If one provider is fully supported before the others, surface that honestly in the UI.
- Build on top of the existing implementation. Do not rebuild unrelated account/profile/settings architecture.

CRITICAL SAFETY RULES
- Audit first before making changes.
- Never remove/delete records for no reason.
- Never silently overwrite local data during restore.
- Never upload malformed/incomplete payloads.
- Never accept malformed remote payloads into live local state.
- Backup and restore operations must fail safely.
- Preserve the current local state if remote operations fail.
- Use schema/version checks.
- Use temporary safety snapshots before risky restore/replace flows where practical.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing anything, audit the current implementation and summarize:

- what Phase 1 already added
- current Accounts, Profile & Sync UI
- current auth provider support status
- current backup/export/import models
- current repository boundaries
- current local storage architecture
- any existing remote/cloud packages already installed
- any existing iCloud / Apple cloud usage
- any existing Google cloud usage
- any existing backend/email account infrastructure
- whether a single provider should be implemented first behind a shared abstraction if all three cannot be safely completed equally in this phase

Determine the safest real implementation path.

Do not rebuild the existing structure if a clean extension is enough.

==================================================
STEP 2 — DEFINE THE REMOTE BACKUP STRATEGY
==================================================

Implement a production-ready abstraction for remote backup transport.

Create/refine boundaries such as:
- RemoteBackupRepository
- BackupTransport
- RemoteBackupMetadata
- RemoteBackupPayload
- RestorePreview
- SyncOperationResult

Design the system so multiple providers can plug into the same flow:
- Apple-linked provider
- Google-linked provider
- Email-linked provider/backend provider

The architecture must separate:
1. authentication
2. local export serialization
3. remote upload/download transport
4. restore validation
5. restore application

Do not tightly couple cloud logic into UI widgets.

==================================================
STEP 3 — BACKUP PAYLOAD STANDARDIZATION
==================================================

Standardize the remote backup package.

The payload should include:
- schema version
- app version
- backup timestamp
- provider/account metadata
- serialized user progress data
- optional device metadata if useful
- optional checksum or integrity metadata if practical

Requirements:
- payload format must be deterministic and versioned
- remote payload should reuse the manual export schema as much as practical
- do not store auth tokens/secrets in the backup payload
- validate before upload
- validate after download before restore

If helpful, separate:
- backup manifest / metadata
- backup body / user data

==================================================
STEP 4 — APPLE BACKUP PATH
==================================================

Implement the Apple-linked backup transport path in a production-ready way.

Use the safest realistic Apple-compatible approach based on the app’s current architecture and packages.

Possible acceptable direction depending on the codebase and platform constraints:
- iCloud/CloudKit-backed account data storage
- app-private cloud document/container backup path
- a structured Apple-account-linked storage transport abstraction if native integration is required next

Requirements:
- tied to authenticated Apple account state where appropriate
- can upload backup payload
- can check whether a remote backup exists
- can fetch remote backup metadata
- can download backup payload
- can surface “last backup” state in UI
- handle unavailable iCloud/cloud environment honestly
- do not fake availability if device/account/cloud setup is missing

If native bridge/platform work is required, implement it properly and minimally rather than faking it.

==================================================
STEP 5 — GOOGLE BACKUP PATH
==================================================

Implement the Google-linked backup transport path.

Use the safest realistic approach for Google-linked user backup based on the app’s current auth setup and backend realities.

Possible directions depending on current architecture:
- Google Drive app-data/private app folder
- backend-mediated storage keyed to Google-authenticated account
- another secure Google-linked remote storage path if already established

Requirements:
- tied to authenticated Google account state
- upload backup payload
- detect existing remote backup
- fetch metadata
- download payload
- surface status in UI
- handle revoked auth / expired session / unavailable storage gracefully

Do not hardcode assumptions if provider setup is incomplete.

==================================================
STEP 6 — EMAIL ACCOUNT BACKUP PATH
==================================================

Implement the email account backup path architecture.

If a real backend already exists:
- wire it properly

If a real backend does not yet exist:
- build the production-ready repository boundary and UI state
- keep the UI honest
- do not fake working cloud backup

The email account flow should support eventual:
- account-linked remote backup
- restore by signed-in email account
- backup metadata retrieval
- secure account association

If backend is missing, implement the shared architecture cleanly so Phase 3 can wire it fast.

==================================================
STEP 7 — BACKUP NOW FLOW
==================================================

Implement the “Back up now” flow.

Requirements:
- gather current local app data through the existing export/serialization layer
- validate the outgoing payload
- upload through the active remote backup provider
- persist backup metadata locally after confirmed success
- update UI/provider state
- show real success/failure states
- prevent duplicate spam operations where necessary

If upload fails:
- keep local data untouched
- show honest error state
- do not mark as backed up

==================================================
STEP 8 — CHECK REMOTE BACKUP STATUS
==================================================

Implement provider-aware backup status checks.

Support:
- no remote backup exists
- remote backup exists
- metadata available
- backup unavailable
- provider unavailable
- auth expired
- sync error

Status should surface:
- current provider
- remote backup existence
- last backup timestamp
- backup source/device if available
- last known sync/restore issue if useful

==================================================
STEP 9 — RESTORE FROM REMOTE BACKUP
==================================================

Implement the restore-from-remote-backup flow.

Restore flow requirements:
1. fetch remote metadata
2. download remote payload
3. validate schema/version/integrity
4. build restore preview
5. show the user what will happen
6. require explicit confirmation before applying
7. create temporary local safety snapshot where practical
8. apply restore through centralized importer/restore logic
9. refresh dependent providers/state

Never silently restore over current local data.

If merge is not safe in this phase:
- implement confirmed replace flow
- clearly explain that local data will be replaced
- preserve a temporary rollback snapshot where practical

==================================================
STEP 10 — CONFLICT / COMPARISON PREPARATION
==================================================

Even if full conflict resolution UI is a later phase, prepare the foundation now.

At minimum support comparison signals such as:
- local last updated
- remote backup timestamp
- provider
- schema version
- rough data summary counts if feasible

Use these to power:
- “Remote backup is older than this device”
- “Remote backup is newer”
- “Different account/provider”
- “Restore may replace newer local progress”

Do not build a fake merge engine if it is not ready.
Lay the groundwork properly.

==================================================
STEP 11 — MULTI-PROVIDER ACCOUNT / BACKUP STATE
==================================================

Refine the account state so the app can clearly handle:
- local only
- Apple signed in
- Google signed in
- Email signed in
- backup available
- backup not configured
- provider temporarily unavailable

If more than one provider can theoretically sign in, handle the UX and data model clearly.
Do not create ambiguous ownership of backups.

If needed, define a primary backup provider concept.

==================================================
STEP 12 — UI / UX UPDATES
==================================================

Enhance Accounts, Profile & Sync with real backup transport states.

Recommended surfaces:
- Connected account card
- Backup provider card
- Last backup card
- Back up now button
- Check backup status action
- Restore from backup action
- Provider unavailable warning
- Local-only reassurance copy

The user should clearly understand:
- whether they are signed in
- whether remote backup exists
- when the last backup happened
- whether restore is safe / risky
- whether a provider still needs platform setup

Keep the Path of Nūr style:
- calm
- clean
- elegant
- not cluttered
- trustworthy

==================================================
STEP 13 — PLATFORM / CREDENTIAL / CONFIG GUARDS
==================================================

Implement platform/configuration guardrails.

Examples:
- missing Apple/iCloud capability
- missing Google Drive/API configuration
- missing backend config for email
- revoked auth session
- unsupported platform state
- simulator/device limitations

Do not crash or fake success.
Surface actionable, honest UI states.

==================================================
STEP 14 — STATE MANAGEMENT
==================================================

Use the existing app architecture consistently.

Likely refine/add:
- remote backup status provider
- backup action controller
- restore action controller
- provider capability state
- remote metadata provider

Ensure correct refresh/invalidation after:
- sign in
- sign out
- backup upload
- remote metadata fetch
- restore completion
- auth/session failure

==================================================
STEP 15 — TESTING
==================================================

Add or update tests for:

- remote backup payload generation
- remote metadata mapping
- provider capability state mapping
- backup success/failure flows
- restore validation
- invalid remote payload rejection
- schema mismatch handling
- local data protection on failed restore
- account/provider state transitions
- UI state for provider unavailable vs backup available

If platform integrations are partly native, add the maximum practical unit/widget test coverage around Dart-side logic.

==================================================
STEP 16 — LOCALIZATION
==================================================

All new strings must go through the app’s localization system.

Do not hardcode user-facing strings.

==================================================
STEP 17 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on changed files
- fix warnings/errors where reasonable
- remove only truly obsolete placeholder backup transport code
- keep repository boundaries clear
- avoid duplicate backup logic
- keep imports and naming clean

==================================================
DELIVERABLES
==================================================

At the end, provide:

1. Audit summary before changes
2. Files changed
3. Which provider paths are fully implemented
4. Which provider paths are partially scaffolded
5. How Apple backup works
6. How Google backup works
7. How Email backup works or what is pending
8. How backup payloads are structured
9. How remote restore works
10. How local data safety is protected
11. What external setup is still required
12. Any limitations by platform/provider
13. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, run one final audit and provide one complete summary of:
- what is complete
- what is partial
- what still needs credentials/platform setup
- what still needs backend work
- key risk areas
- what Phase 3 should implement next

Do not go haywire.
Do not remove/delete records for no reason.
Do not fake working cloud sync.
Build this as a real production-ready transport layer on top of the existing Accounts, Profile & Sync foundation.

===== END PROMPT =====
