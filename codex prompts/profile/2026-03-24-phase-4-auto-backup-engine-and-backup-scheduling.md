# Phase 4 Prompt — Auto-Backup Engine & Backup Scheduling

PRIMARY OBJECTIVE === BUILDING AUTO-BACKUP ENGINE & BACKUP SCHEDULING

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- Accounts, Profile & Sync
- Remote backup transport layer
- Restore comparison & conflict resolution

Your task is to implement a production-ready auto-backup engine so users do not have to manually remember to back up their progress, while still preserving the app’s offline-first nature, user control, and data safety.

This phase must make backups smarter, safer, and more automatic without becoming intrusive or risky.

CRITICAL PRODUCT RULES
- The app must remain offline-first.
- Auto-backup must be optional and user-controlled.
- Manual backup must still remain available at all times.
- Users must be able to use the app fully without signing in or enabling auto-backup.
- Do not rebuild unrelated account/profile/settings areas.
- Build on top of the current implementation.

CRITICAL DATA SAFETY RULES
- Audit first before editing anything.
- Never remove/delete records for no reason.
- Never run auto-restore.
- Never let auto-backup overwrite local data.
- Never mark a backup successful unless it actually completed successfully.
- Never spam the remote provider with unnecessary uploads.
- Never auto-run destructive actions.
- If auto-backup fails, preserve all local data and surface the failure honestly.
- Use safe retry/debounce/throttling logic.
- Backups must only upload validated payloads.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before making changes, audit the current implementation and summarize:

- current Accounts, Profile & Sync UI
- current remote backup transport layer
- current manual backup flow
- current restore comparison/preview system
- current auth/account/provider state
- current sync status metadata
- whether any backup timestamps already exist locally
- whether any app lifecycle hooks already exist for background/foreground events
- whether reminder/task scheduling infrastructure already exists that can be reused
- where auto-backup settings should live in the current IA
- what signals exist to determine “meaningful progress changed”

Determine the safest additive implementation path.

Do not rebuild architecture if the existing system can be extended cleanly.

==================================================
STEP 2 — DEFINE THE AUTO-BACKUP POLICY MODEL
==================================================

Create or refine production-ready models for auto-backup preferences and state.

Suggested models:
- AutoBackupPreferences
- AutoBackupTrigger
- AutoBackupEligibilityResult
- AutoBackupRunResult
- AutoBackupPolicyState
- BackupThrottleState
- PendingBackupReason

Support settings such as:
- auto-backup enabled/disabled
- backup frequency
- backup on meaningful progress change
- backup on app background/close if eligible
- backup only on Wi-Fi if such distinction is practical
- backup only when signed in and provider available
- last attempted backup timestamp
- last successful backup timestamp
- last failure reason
- minimum interval between auto-backups

Do not overengineer, but make it robust.

==================================================
STEP 3 — DEFINE AUTO-BACKUP TRIGGERS
==================================================

Implement a controlled set of backup triggers.

Possible triggers:
- manual backup still available
- first successful sign-in with a backup-capable provider
- significant local progress change
- app entering background if enough new progress exists
- app launch if backup is overdue
- scheduled daily backup
- scheduled weekly backup
- pre-upgrade or pre-migration backup hook if practical
- after import/restore completion if explicitly appropriate and safe

At minimum, implement the most reliable and non-intrusive triggers first.

Do not create noisy or excessive uploads.

==================================================
STEP 4 — DEFINE “MEANINGFUL PROGRESS CHANGED”
==================================================

Implement logic to determine whether enough progress changed to justify a new backup.

Use safe and clear signals such as:
- prayer tracking updates
- dhikr history changes
- Qur’an progress/bookmarks changes
- streak/ring changes
- XP/levels/drops changes
- learning progress changes
- journal/notes additions if supported
- settings/profile changes if considered backup-worthy

Add a mechanism to mark the backup state as “dirty” when meaningful user data changes.

Requirements:
- avoid triggering backup for trivial non-user-impacting state churn
- avoid repeated uploads for tiny rapid-fire updates
- centralize the dirty-state logic where practical

==================================================
STEP 5 — BACKUP DIRTY FLAG / CHANGE TRACKING
==================================================

Implement a centralized backup-dirty tracking mechanism.

This should:
- know whether local data has changed since the last successful backup
- track approximate domains changed if practical
- reset only after confirmed successful backup
- survive app restarts if appropriate
- remain safe if provider/account state changes

Support signals like:
- no pending changes
- pending progress changes
- pending settings changes
- pending journal/note changes
- backup overdue even without obvious dirty state if policy requires

Do not rely purely on UI state.

==================================================
STEP 6 — AUTO-BACKUP ELIGIBILITY ENGINE
==================================================

Implement an eligibility engine that decides whether auto-backup should run.

Eligibility factors may include:
- user enabled auto-backup
- signed-in provider available
- provider supports backup
- no backup currently in progress
- local dirty state present
- enough time passed since last backup
- enough time passed since last attempt
- app/platform state allows it
- account/session still valid
- remote transport available
- backup payload can be generated safely

Possible outcomes:
- eligible now
- not signed in
- provider unavailable
- auto-backup disabled
- no meaningful changes
- throttled
- backup already running
- waiting for next schedule window

==================================================
STEP 7 — SCHEDULING / THROTTLING / DEBOUNCING
==================================================

Implement safe scheduling behavior.

Requirements:
- debounce bursts of data change events
- throttle repeated backup runs
- prevent multiple simultaneous backups
- avoid repeated retries in failure loops
- schedule backups sensibly when the app is backgrounded or resumed if practical
- keep platform constraints in mind

If true background execution is limited by platform, handle that honestly and implement the best foreground/lifecycle-based approximation rather than faking full background reliability.

==================================================
STEP 8 — AUTO-BACKUP EXECUTION FLOW
==================================================

Implement the actual auto-backup run flow.

Flow should:
1. confirm eligibility
2. gather current local payload through existing export serialization
3. validate payload
4. upload via active provider
5. update backup metadata after success
6. clear dirty state only after confirmed success
7. record failure state honestly if it fails
8. refresh providers/state/UI as needed

Auto-backup must reuse the existing validated backup pipeline, not create a parallel unsafe path.

==================================================
STEP 9 — AUTO-BACKUP SETTINGS UI
==================================================

Enhance Accounts, Profile & Sync with a dedicated Auto-Backup section.

Recommended controls:
- Auto-backup toggle
- Backup frequency selector
  - smart / when needed
  - daily
  - weekly
  - manual only
- Back up on meaningful progress changes toggle
- Back up when app is backgrounded toggle if practical
- Last successful backup
- Last attempted backup
- Pending backup status
- Failure state and retry action
- Provider/account shown clearly

Recommended helper text:
- simple
- calm
- clear
- non-technical

Example concepts:
- “Back up your journey automatically when meaningful progress changes.”
- “Your backup runs only when eligible and never replaces local data.”
- “Manual export remains available anytime.”

==================================================
STEP 10 — USER FEEDBACK / STATUS SURFACES
==================================================

Add clear backup status surfaces.

Support statuses such as:
- auto-backup off
- ready
- pending changes
- backup due
- backing up now
- last backup successful
- backup failed
- provider unavailable
- sign-in required

The user should clearly understand:
- whether auto-backup is enabled
- whether their latest progress is backed up
- whether backup is pending
- whether action is required

Keep UI elegant and not stressful.

==================================================
STEP 11 — FAILURE HANDLING / RETRY LOGIC
==================================================

Implement safe failure handling.

Requirements:
- do not clear dirty state on failure
- record last failure reason/state
- provide retry path
- avoid endless retry loops
- distinguish temporary issues from configuration issues
- handle revoked auth/provider unavailable/network issues gracefully

If a provider is unavailable:
- surface it honestly
- keep local data untouched
- keep pending backup state if appropriate

==================================================
STEP 12 — APP LIFECYCLE INTEGRATION
==================================================

Integrate auto-backup with app lifecycle carefully.

Possible integration points:
- app resumed
- app backgrounded
- user signs in
- meaningful progress saved
- manual restore completed
- manual import completed
- settings changed

Do not run heavy operations recklessly on every lifecycle event.
Use the eligibility engine first.

==================================================
STEP 13 — PROVIDER-AWARE RULES
==================================================

Refine auto-backup behavior by provider.

Examples:
- Apple backup provider available but iCloud disabled
- Google signed in but Drive/app-data permission unavailable
- Email provider signed in but backend transport unavailable
- account session expired
- provider temporarily unavailable

Auto-backup must not pretend to be active if the provider cannot actually back up.

==================================================
STEP 14 — STATE MANAGEMENT
==================================================

Use the existing app architecture consistently.

Likely refine/add:
- auto-backup preferences provider
- backup dirty-state provider/service
- auto-backup eligibility provider
- auto-backup controller
- backup schedule/throttle state provider
- backup failure/status provider

Ensure correct refresh/invalidation after:
- sign in
- sign out
- backup success/failure
- settings changes
- meaningful progress changes
- provider availability changes

==================================================
STEP 15 — TESTING
==================================================

Add/update tests for:
- auto-backup eligibility decisions
- dirty-state transitions
- meaningful-change detection
- backup throttle/debounce rules
- success path clears dirty state
- failure path preserves dirty state
- provider unavailable state
- auto-backup off vs on behavior
- UI settings state
- lifecycle-triggered backup decisions

Prioritize logic correctness and data safety.

==================================================
STEP 16 — LOCALIZATION
==================================================

All new user-facing strings must go through the existing localization system.

Do not hardcode strings into widgets.

==================================================
STEP 17 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on changed files
- fix warnings/errors where reasonable
- remove only truly obsolete placeholder auto-backup code
- keep logic centralized
- avoid duplicate scheduling or backup decision logic
- keep naming/file boundaries clean

==================================================
DELIVERABLES
==================================================

At the end, provide:

1. Audit summary before changes
2. Files changed
3. What auto-backup models/settings were added
4. What triggers were implemented
5. How meaningful progress changes are detected
6. How dirty-state tracking works
7. How eligibility/throttling works
8. How lifecycle integration works
9. What UI/settings were added
10. How failure/retry handling works
11. What provider/platform limitations still exist
12. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, run one final audit and provide one complete summary of:
- what is complete
- what is partial
- what auto-backup behavior is truly working
- what depends on provider/platform setup
- any remaining risk areas
- what should be built in Phase 5 next

Do not go haywire.
Do not remove/delete records for no reason.
Do not fake background backup behavior.
Build a real, trustworthy, production-ready auto-backup engine on top of the existing backup and restore system.
