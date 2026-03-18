# Codex Context Engine Backlog

Last updated: 2026-03-17

1. Add a lightweight local helper script that opens `.codex_context_engine/state.json`, `.codex_memory/current_state.md`, `.codex_memory/route_map.md`, and task-relevant inventories in one command.
2. Add a repo-aware packet builder that maps a task string to planner sources and outputs a minimal context pack from the local memory layer.
3. Seed richer memory-graph nodes and edges from canonical routes, alias routes, feature owners, and removed-item constraints.
4. Add a small telemetry append script so future Codex runs can record task/phase events without manual JSON edits.
5. Create a knowledge mod for release/platform validation and ingest the existing release docs into `.codex_library/`.
6. Create a knowledge mod for Islamic content governance so source-verification rules and content review notes are easier to retrieve.
7. Add a catch-up refresh checklist for major product passes so `current_state`, `route_map`, and `feature_inventory` stay synchronized after large changes.
8. Add a contributor-facing doc in the main repo describing the local engine workflow and which memory files to read first.
9. Expand failure memory with concrete recurring issues from real debug sessions instead of only audit findings.
10. Add a localization-specific task-memory profile that points directly to high-traffic debt files and ARB ownership.
