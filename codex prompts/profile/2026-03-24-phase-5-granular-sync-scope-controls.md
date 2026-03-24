# PHASE 5 PROMPT — GRANULAR SYNC SCOPE CONTROLS

PRIMARY OBJECTIVE === BUILDING GRANULAR SYNC SCOPE CONTROLS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- Accounts, Profile & Sync
- Remote backup transport layer
- Restore comparison & conflict resolution
- Auto-backup engine & backup scheduling

Your task is to implement a production-ready granular sync scope control system so users can decide exactly which categories of data are included in backup/sync and which remain local-only.

This phase is about user trust, clarity, privacy, and control.

CRITICAL PRODUCT RULES
- The app must remain offline-first.
- Users must still be able to use the app fully without signing in.
- Backup/sync must remain optional.
- Users must be able to choose local-only behavior for specific data domains if they want.
- Do not rebuild unrelated account/profile/settings architecture.
- Build on top of the current implementation.

CRITICAL DATA SAFETY RULES
- Audit first before editing anything.
- Never remove/delete records for no reason.
- Never silently stop backing up data without clearly updating user settings/state.
- Never allow scope changes to accidentally wipe local or remote data.
- Never mislead the user about what is or is not included in backup.
- Scope exclusions must affect future backups safely and predictably.
- Existing data must remain intact unless the user explicitly performs a destructive action.
- If scope changes create restore ambiguity, surface it honestly.

STEP 1 — AUDIT FIRST

Before making changes, audit the current implementation and summarize:
- current Accounts, Profile & Sync UI
- current backup/export/import architecture
- current remote transport layer
- current restore comparison system
- current auto-backup engine
- current payload schema
- current domain models for user data
- current serialization boundaries
- which data domains can already be isolated cleanly
- which domains are currently tightly coupled and may need refactoring
- where sync scope controls should live in the current IA

Determine the safest additive implementation path.

STEP 2 — DEFINE THE SYNC SCOPE MODEL

Create or refine production-ready models for sync scope preferences.

Suggested models:
- SyncScopePreferences
- SyncableDomain
- DomainBackupInclusionState
- BackupScopeSummary
- ScopeValidationResult
- ScopeChangeImpactPreview

Support a clear set of syncable domains, such as:
- profile basics
- settings/preferences
- prayer tracking/history
- dhikr progress/history
- Qur’an progress/bookmarks/recents
- streaks/rings/goals
- XP/levels/drops/ocean progress
- learning progress
- journal/notes
- reminders/preferences
- theme/accessibility preferences

STEP 3 — DEFINE CORE VS OPTIONAL DOMAINS

Classify domains into sensible categories.

Examples:
CORE / strongly recommended
- profile basics
- essential progress metadata
- prayer tracking
- Qur’an progress
- learning progress
- streaks/rings/goals
- XP/levels/drops/ocean progress

OPTIONAL / user-controlled
- journal/notes
- reminders
- settings/preferences
- theme/accessibility preferences

STEP 4 — PAYLOAD SCOPING ARCHITECTURE

Refine the backup payload generation so it respects sync scope preferences.

Requirements:
- payload generation must include only domains enabled for backup
- excluded domains must remain local-only
- payload metadata should clearly describe included domains
- remote metadata/manifest should reflect backup scope
- restore preview should know what was included/excluded

STEP 5 — SCOPE-AWARE SERIALIZATION

Update serialization logic so each domain can be independently included/excluded where practical.

Requirements:
- clean domain boundaries
- deterministic output
- version-safe schema evolution
- stable behavior when optional domains are missing
- restore/import should not treat intentionally excluded domains as corruption

STEP 6 — SCOPE-AWARE REMOTE BACKUP METADATA

Enhance remote/local backup metadata to include scope summary.

Examples:
- included domains
- excluded domains
- whether backup is “full” or “partial”
- timestamp
- provider
- schema version
- app version

STEP 7 — SCOPE SETTINGS UI

Add a dedicated Sync Scope section under Accounts, Profile & Sync.

Recommended UI:
- simple grouped list of data categories
- toggle per optional domain
- clear indicator for required/core domains
- helper text explaining local-only vs backed-up behavior
- “recommended defaults” behavior
- “include all” / “restore recommended defaults” actions if appropriate

STEP 8 — DEFAULTS & USER GUARDRAILS

Implement safe defaults and concise impact messaging.

STEP 9 — SCOPE CHANGE IMPACT PREVIEW

When the user changes sync scope meaningfully, provide an impact preview or clear confirmation where appropriate.

STEP 10 — RESTORE PREVIEW INTEGRATION

Integrate scope awareness into restore comparison and preview.

Restore preview should clearly show:
- which domains exist in the remote backup
- which were intentionally excluded
- which local-only domains will remain untouched
- whether the remote backup is partial/full
- whether current user scope settings differ from the backup’s original scope

STEP 11 — AUTO-BACKUP INTEGRATION

Update the auto-backup engine so it respects sync scope preferences.

STEP 12 — IMPORT / EXPORT INTEGRATION

Decide and implement how manual import/export should interact with sync scope.

At minimum:
- be consistent
- be honest
- document/export metadata clearly
- ensure restore/import logic understands partial backups properly

STEP 13 — PROVIDER / ACCOUNT STATE INTEGRATION

Ensure sync scope state works cleanly across local-only, Apple, Google, Email, provider-unavailable, and signed-out states.

STEP 14 — STATE MANAGEMENT

Use the existing app architecture consistently.

STEP 15 — TESTING

Add/update tests for:
- scope preference persistence
- payload generation with included/excluded domains
- metadata summary generation
- restore preview for partial backups
- auto-backup dirty-state behavior with excluded domains
- scope change impact messaging logic
- core/required domain handling
- UI state for full vs partial backup

STEP 16 — LOCALIZATION

All new user-facing strings must go through the existing localization system.

STEP 17 — ANALYZER / CLEANUP

After implementation:
- run analyzer on changed files
- fix warnings/errors where reasonable
- keep serialization logic centralized
- avoid duplicate domain-mapping logic

DELIVERABLES

At the end, provide:
1. Audit summary before changes
2. Files changed
3. What sync scope models/preferences were added
4. Which domains are core vs optional
5. How payload generation now respects scope
6. How metadata/restore preview reflects partial backups
7. How auto-backup integrates with scope controls
8. What UI/settings were added
9. Any limitations still remaining
10. Recommended next phase

FINAL AUDIT AT THE VERY END

At the very end, run one final audit and provide one complete summary of:
- what is complete
- what is partial
- what domains are truly scope-aware now
- what still needs deeper refactoring for full granularity
- any remaining risk areas
- what should be built in Phase 6 next
