# PHASE 3 PROMPT — RESTORE COMPARISON & CONFLICT RESOLUTION

PRIMARY OBJECTIVE === BUILDING RESTORE COMPARISON & CONFLICT RESOLUTION

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the existing Accounts, Profile & Sync foundation and the remote backup transport layer.

Your task is to implement a production-ready restore comparison and conflict resolution system so users can safely understand the difference between:
- current local device data
- available remote backup data

before any restore action is applied.

This phase is about safety, transparency, trust, and preventing accidental data loss.

CRITICAL PRODUCT RULES
- The app must remain offline-first.
- Users must still be able to use the app without signing in.
- Restore must never silently overwrite local progress.
- The user must clearly understand whether the remote backup is newer, older, or different.
- Do not rebuild unrelated account/profile/settings areas.
- Build on top of the current implementation.

CRITICAL DATA SAFETY RULES
- Audit first before editing anything.
- Never remove/delete records for no reason.
- Never blindly replace local data.
- Never auto-merge without deterministic and safe rules.
- If merge confidence is low, require explicit user choice.
- If data cannot be safely merged, surface that honestly and fall back to replace/cancel paths.
- Always protect the current local state before risky restore operations.
- Never leave the app in a half-restored corrupted state.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before making changes, audit the current implementation and summarize:

- current Accounts, Profile & Sync UI
- current remote backup transport layer
- current restore flow
- current import/export schema
- current local storage domains
- current metadata available for local data
- current metadata available for remote backup
- whether any merge logic already exists
- whether per-domain last-updated timestamps already exist anywhere
- where comparison/conflict UI should live in the current flow

Determine the safest additive implementation strategy.

Do not rebuild the architecture if a structured extension is enough.

==================================================
STEP 2 — DEFINE THE RESTORE COMPARISON MODEL
==================================================

Create or refine production-ready comparison/conflict models.

Suggested models:
- RestoreComparisonSummary
- RestoreDomainComparison
- RestoreConflictType
- RestoreDecisionMode
- RestorePreviewData
- MergeEligibilityResult
- RestoreSafetySnapshotMetadata

At minimum support comparison states such as:
- identical
- remote_newer
- local_newer
- remote_only_data
- local_only_data
- incompatible_schema
- uncertain_difference
- account_mismatch
- provider_mismatch

Decision modes should support:
- cancel
- replace_local_with_remote
- merge_safe_domains
- keep_local_only

Do not overengineer, but make the structure extensible.

==================================================
STEP 3 — BUILD A DOMAIN-AWARE COMPARISON ENGINE
==================================================

Implement a comparison engine that evaluates local vs remote data before restore.

Compare at least these logical domains where practical:
- profile basics
- settings/preferences
- prayer tracking
- dhikr progress/history
- Qur’an progress/bookmarks/recents
- streaks/rings/goals
- XP/levels/drops/ocean progress
- learning progress
- journal/notes if supported
- reminders/preferences
- theme/accessibility preferences

For each domain, determine if the remote backup is:
- same
- clearly newer
- clearly older
- contains unique remote data
- contains unique local data
- cannot be safely compared

Use deterministic rules where possible.
Do not fake precision if the data model does not support it.

==================================================
STEP 4 — LOCAL VS REMOTE TIMESTAMP / VERSION SIGNALS
==================================================

Improve the metadata layer so restore decisions can be safer.

Use or add, where practical:
- backup created timestamp
- local data last updated timestamp
- per-domain last modified timestamps
- schema version
- app version
- provider/account identity
- device/source label if available

If exact per-domain timestamps are not yet available, introduce safe heuristics and clearly mark them as approximate in logic/comments, not in misleading UI language.

==================================================
STEP 5 — RESTORE PREVIEW UI
==================================================

Build a real restore preview screen/surface before the user confirms restore.

The preview should clearly show:
- current signed-in provider/account
- backup source/provider
- remote backup date/time
- local data recency if available
- whether remote appears older/newer/same
- what domains will be affected
- warnings when local progress may be replaced
- whether safe merge is available
- final available actions

Recommended sections:
- Overall backup summary
- Comparison summary
- Per-domain changes
- Risks / warnings
- Action options

Keep the UI calm, elegant, and easy to understand.
No clutter, no technical overload, no scary chaos.

==================================================
STEP 6 — CONFLICT TYPES & WARNING STATES
==================================================

Implement clear conflict/warning handling for scenarios such as:
- remote backup is older than local device
- remote backup belongs to different provider/account
- schema mismatch
- remote backup missing domains
- local device has newer progress in key domains
- both local and remote contain unique progress
- merge is unsafe or unsupported
- restore would replace meaningful current progress

Warnings must be honest and specific.
Do not use generic “something may happen” messaging if exact risk is known.

==================================================
STEP 7 — SAFE MERGE ELIGIBILITY
==================================================

Implement merge eligibility logic per domain.

For each domain, determine whether it is:
- safe to merge
- safe to replace
- unsafe / manual choice required
- unsupported for merge in this phase

Examples:
- additive histories may be mergeable
- simple scalar “last chosen theme” may prefer latest timestamp
- complex conflicting records may be replace-only for now

Do not implement broad blind merging.
Only merge domains where deterministic rules are trustworthy.

==================================================
STEP 8 — MERGE RULES FOR SAFE DOMAINS
==================================================

Where safe, implement real merge rules.

Possible examples:
- reminders/preferences: latest timestamp wins
- bookmarks/recents: union with dedupe
- completed learning items: union with dedupe
- drops/XP if event-based and traceable: merge carefully, avoid double counting
- journal entries with unique ids: union if safe
- settings/preferences: timestamp-based choice if deterministic

Do not merge:
- if it risks duplication
- if it risks double counting
- if there is insufficient metadata
- if conflict rules are ambiguous

If uncertain, require replace/cancel instead of pretending merge is safe.

==================================================
STEP 9 — REPLACE LOCAL WITH REMOTE FLOW
==================================================

Refine the replace flow.

Requirements:
- create temporary local safety snapshot before replace
- display explicit confirmation
- explain which domains will be replaced
- validate remote payload again before applying
- apply restore atomically where practical
- refresh all dependent providers/state after success
- preserve rollback path if supported

Never silently replace live local data.

==================================================
STEP 10 — OPTIONAL SAFE MERGE FLOW
==================================================

If safe merge is supported for selected domains in this phase, implement it properly.

Requirements:
- show which domains will merge
- show which domains cannot merge
- show whether any domains will still be replaced or skipped
- create temporary safety snapshot
- apply via centralized restore service
- produce result summary after merge

If full merge is not yet safe enough, then:
- implement comparison + warnings + replace/cancel only
- leave clear architecture hooks for later phases
- do not fake merge support

==================================================
STEP 11 — RESULT SUMMARY AFTER RESTORE
==================================================

After restore or merge, show a real completion summary.

Examples:
- restored from Apple backup dated [date]
- replaced local prayer history and settings
- merged bookmarks and learning progress
- skipped unsupported journal media
- local safety snapshot created

This summary should help the user trust what happened.

==================================================
STEP 12 — ACCOUNT / PROVIDER MISMATCH PROTECTION
==================================================

Add protections for:
- restoring from a backup tied to a different provider
- restoring from a different email/account identity
- stale auth state
- revoked session
- cross-provider ambiguity

If backup ownership is unclear, warn the user clearly before any restore action.

==================================================
STEP 13 — STATE MANAGEMENT
==================================================

Use the existing architecture consistently.

Likely refine/add:
- restore comparison provider
- restore preview controller
- merge eligibility provider
- restore execution controller
- post-restore summary state

Ensure correct refresh/invalidation after:
- fetching remote backup
- generating preview
- confirming replace
- confirming merge
- canceling restore
- restore completion/failure

==================================================
STEP 14 — TESTING
==================================================

Add/update tests for:
- comparison summary generation
- per-domain comparison mapping
- merge eligibility decisions
- schema mismatch warnings
- account/provider mismatch warnings
- remote older vs local newer detection
- safe replace flow
- safe merge flow where implemented
- rollback/snapshot protection on failure
- UI states for restore preview and warnings

Focus especially on logic correctness and data safety.

==================================================
STEP 15 — LOCALIZATION
==================================================

All new user-facing strings must go through the existing localization system.

Do not hardcode strings into widgets.

==================================================
STEP 16 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on changed files
- fix warnings/errors where reasonable
- remove only truly obsolete placeholder comparison/restore code
- keep repository boundaries clean
- keep naming consistent
- keep restore logic centralized and testable

==================================================
DELIVERABLES
==================================================

At the end, provide:

1. Audit summary before changes
2. Files changed
3. What comparison/conflict models were added
4. How local vs remote comparison works
5. Which domains support safe merge
6. Which domains are replace-only
7. What warnings are shown to users
8. How rollback/safety snapshot protection works
9. What restore preview UI now shows
10. Any limitations still remaining
11. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, run one final audit and provide one complete summary of:
- what is complete
- what is partial
- what merge logic is truly safe
- what domains still should not be merged yet
- any remaining risk areas
- what should be built in Phase 4 next

Do not go haywire.
Do not remove/delete records for no reason.
Do not fake conflict resolution.
Build a real, trustworthy, production-ready restore comparison and conflict resolution system on top of the existing Accounts, Profile & Sync and remote backup transport layers.

===== END PROMPT =====
