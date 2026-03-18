# Session Start Guide

Last updated: 2026-03-17

Use this file at the start of a task to avoid a broad repo rescan.

## Always read first

1. `.codex_context_engine/state.json`
2. `.codex_memory/working_assumptions.md`
3. `.codex_memory/do_not_rebuild.md`
4. `.codex_memory/continuation_backlog.md`

## Canonical ownership defaults

- settings/profile ownership:
  - `.codex_memory/settings_inventory.md`
  - canonical routes live under `/settings/*`
- route ownership:
  - `.codex_memory/route_map.md`
- feature ownership:
  - `.codex_memory/feature_inventory.md`
- architecture direction:
  - `.codex_memory/architecture_map.md`

## Read-by-task routing

### Routing / navigation work

Read first:

1. `.codex_memory/route_map.md`
2. `.codex_memory/do_not_rebuild.md`
3. `.codex_memory/feature_inventory.md`
4. `lib/app/app_router.dart`
5. `lib/app/routes/core_support_routes.dart`

Focus:

- prefer canonical routes over aliases
- keep compatibility aliases only when needed
- do not recreate removed placeholder/profile ownership patterns

### Learn work

Read first:

1. `.codex_memory/learn_inventory.md`
2. `.codex_memory/route_map.md`
3. `.codex_memory/do_not_rebuild.md`
4. `.codex_memory/continuation_backlog.md`
5. `lib/features/learn/presentation/data/learn_category_catalog.dart`
6. `lib/features/learn/journey/data/learning_journey_registry.dart`

Focus:

- `/learn` is journey-first
- avoid parallel hubs
- do not re-expand legacy Learn ownership without explicit migration intent

### Journey work

Read first:

1. `.codex_memory/journey_inventory.md`
2. `.codex_memory/learn_inventory.md`
3. `.codex_memory/do_not_rebuild.md`
4. `.codex_memory/continuation_backlog.md`
5. `lib/features/journey/*`
6. `lib/features/learn/journey/*`

Focus:

- growth journey and Learning Journey are separate systems
- do not recreate `journey_legacy_page` or placeholder node-detail concepts

### Settings / localization work

Read first:

1. `.codex_memory/settings_inventory.md`
2. `.codex_memory/feature_inventory.md`
3. `.codex_memory/do_not_rebuild.md`
4. `LOCALIZATION_INTEGRITY_BACKLOG.md`
5. relevant `lib/l10n/*.arb` files
6. `lib/features/profile/presentation/settings_page.dart`

Focus:

- settings owns profile/personalization direction now
- do not rebuild a separate profile page/tab
- preserve generated localization flow

### Accounts / sync work

Read first:

1. `.codex_memory/accounts_sync_inventory.md`
2. `.codex_memory/route_map.md`
3. `.codex_memory/working_assumptions.md`
4. `docs/release_target_readiness.md`
5. `docs/apple_icloud_sync_release_checklist.md`
6. `lib/features/accounts_sync/application/*`

Focus:

- local-first is the real current posture
- do not imply full production cloud sync exists here

### Watch / TV / platform work

Read first:

1. `.codex_memory/platform_inventory.md`
2. `.codex_memory/feature_inventory.md`
3. `docs/release_target_readiness.md`
4. `docs/watch_qa_matrix.md`
5. `IOS_PLATFORM_BACKLOG.md`

Focus:

- code presence is not release readiness
- use docs as source of truth for platform claims

### Cleanup / consolidation work

Read first:

1. `.codex_memory/do_not_rebuild.md`
2. `.codex_memory/technical_debt.md`
3. `.codex_memory/continuation_backlog.md`
4. `.codex_memory/route_map.md`
5. `.codex_memory/feature_inventory.md`

Focus:

- remove duplication without reviving retired patterns
- preserve canonical ownership direction

### Launch-readiness work

Read first:

1. `.codex_memory/platform_inventory.md`
2. `.codex_memory/continuation_backlog.md`
3. `RELEASE_READINESS_CHECKLIST.md`
4. `docs/release_target_readiness.md`
5. `docs/apple_icloud_sync_release_checklist.md`
6. `docs/watch_qa_matrix.md`

Focus:

- prioritize iOS/iPadOS
- keep release claims aligned with validated platform reality

## Do not rebuild checklist

Before editing, confirm you are not reviving:

- top-level Profile ownership
- generic Learn placeholder pages
- legacy journey/worship pages
- fake production cloud sync assumptions
- duplicate Qur'an ownership flows

If any of those seem relevant, re-read `.codex_memory/do_not_rebuild.md`.
