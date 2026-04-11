# Phase 1.75 — Dua Contextual Orchestration Metadata

Prepare the dua dataset for future context-aware surfacing by adding orchestration metadata.

Scope:
- `lib/features/learn/dua/data/dua_seed_data.dart`
- any directly related dua model/repository/provider files only if required for schema support
- do not expand scope beyond dua metadata access paths

Constraints:
- audit first
- preserve existing app behavior
- metadata preparation only
- do not build the orchestration engine
- do not implement widgets, lock screen, watch, or daily card UI
- keep the model conservative and production-ready

Requested metadata fields:
- `timeContexts`
- `dateContexts`
- `weatherContexts`
- `locationContexts`
- `prayerContexts`
- `situationContexts`
- `surfaceEligibility`
- `priorityScore`
