# Advanced Enrichment, Milestones & Long-Term Delight

## Executive summary

This pass adds a lightweight Learn enrichment layer on top of guided-path progress. It introduces calm milestones, simple learning memories, a gentle landing-card moment for newly unlocked milestones, and richer path-completion meaning without changing route ownership, canonical Qur'an ownership, kids ownership, or the existing reward ledgers.

The new layer is intentionally quiet. It does not add streak pressure, badge walls, or noisy celebration effects. Instead it notices meaningful learning moments and reflects them back with dignity.

## Audit findings before changes

- Guided paths already had safe XP and Ocean Drop hooks for step completion and path completion.
- Path completion feedback was still mostly a snackbar plus existing progress state.
- Learn had clearer progression than before, but long-term delight was thin.
- Kids Arabic and some other domains already had their own reward moments, so Learn enrichment needed to complement those rather than replace them.
- The safest authoritative milestone seam was guided-path progress, not route visits or broad content opens.

## Milestone model

New domain and state live in:

- `lib/features/learn/enrichment/domain/learn_enrichment_models.dart`
- `lib/features/learn/enrichment/application/learn_enrichment_provider.dart`

The milestone set is intentionally small and explainable:

- first path started
- first step completed
- first path completed
- Foundations completed
- first Qur'an step completed
- first kids path completed
- Stories completed
- three guided steps in a week
- return after a break

State stores:

- unlocked milestone timestamps
- acknowledged milestone timestamps
- recent learning memories
- recent step completion timestamps for consistency checks

## Trigger rules

- `first path started`
  - first time any guided path is started
- `first step completed`
  - first time any guided path step is completed
- `first path completed`
  - first guided path completion
- `Foundations completed`
  - completing `foundations-starter`
- `first Qur'an step completed`
  - completing any step in a `quran`-bucket path
- `first kids path completed`
  - completing a kids-audience path
- `Stories completed`
  - completing `stories-starter`
- `three guided steps in a week`
  - at least three guided step completions in the recent 7-day window
- `return after a break`
  - reopening a guided path after at least a 7-day pause

Milestones are deduped. A milestone only unlocks once.

## Milestone moments

The Learn landing now surfaces one pending milestone moment at a time through:

- `LearnMilestoneMomentCard`

This moment:

- uses calm language
- offers a simple open-path action when relevant
- can be acknowledged and dismissed
- avoids full-screen interruption

## Learning memories

The Learn landing now also shows lightweight memory highlights through:

- `LearnMemoryHighlightsCard`

These memories are:

- persisted locally
- tied to meaningful milestone unlocks
- capped and lightweight
- rendered as a short recent-history reflection, not a scrapbook system

## Path completion enrichment

Completed path detail pages now show a richer completion card through:

- `LearnPathCompletionCard`

It adds:

- a meaningful completion title
- a calm completion body
- a memory line when one exists
- a gentle encouragement line
- 1 to 2 sequenced next-path suggestions where available

This preserves existing guided-path completion state while making completion feel more like a finished chapter than a silent checkbox.

## Encouragement logic

Encouragement is intentionally sparse and rule-based.

Current encouragement lines come from:

- a pending milestone moment
- an active guided path without a pending milestone
- recent learning memories when no active milestone is pending

The tone stays calm:

- small step encouragement
- steady rhythm encouragement
- welcome-back encouragement
- next-chapter encouragement
- kids-safe encouragement

## Ocean / XP integration notes

No new reward ledger was created.

This pass reuses the existing guided-path reward boundaries:

- guided path step completion still uses existing XP / Ocean hooks
- guided path completion still uses existing XP / Ocean hooks
- milestone moments themselves do not add new inflated reward multipliers

This keeps the system non-exploitable and consistent with existing reward balance.

## Kids-safe delight notes

Kids-related enrichment:

- uses warmer copy
- keeps the moment brief
- avoids overstimulating celebration patterns
- does not change kids route ownership or replace kids-owned progression systems

## Qur'an ownership notes

- Qur'an milestones are triggered from guided-path orchestration only
- `/quran/*` remains canonical
- no Qur'an reader, playback, or route ownership changes were introduced

## Performance and offline notes

- state persists locally via the existing local-store pattern
- no remote dependency was added
- milestone checks run only at real guided-path state transitions
- no heavy animation loop or overlay system was added
- the landing cards are provider-driven and lightweight

## Localization impact

New enrichment keys were added and generated through the existing localization flow.

Examples include:

- section titles
- milestone titles and bodies
- encouragement copy
- completion-card copy
- action labels

All `lib/l10n/app_*.arb` files were updated, and generated localization files in `lib/l10n/` were regenerated.

Non-English entries currently follow the repo's existing English-fallback pattern for newly added keys.

## Test impact

Added focused coverage in:

- `test/features/learn/enrichment/application/learn_enrichment_provider_test.dart`

Covered behavior:

- milestone unlocking
- milestone deduping
- weekly consistency milestone
- kids completion milestone
- encouragement availability

## Follow-up opportunities

- add a small profile or progression-surface summary for major Learn memories if product wants more visibility later
- add a few more path-specific completion summaries when content hardening deepens
- connect selected milestone unlocks into minimal analytics if later tuning needs them
- audit whether watch or tvOS should reflect a subset of these moments once mirrored Learn parity is in scope
