# Working Assumptions

Last updated: 2026-03-17

## Source-of-truth order for future Codex runs

1. current code in the repository
2. repo docs/backlogs created during recent passes
3. `.codex_memory/*` artifacts
4. older boilerplate docs only if still consistent

## Operational assumptions

- the repository may stay dirty between runs
- existing uncommitted app changes are not permission to revert anything
- localization and Islamic-content constraints in `AGENTS.md` remain authoritative
- global theme and core architecture should remain stable unless the user explicitly asks otherwise

## Product-direction assumptions

- first practical release target is iOS/iPadOS
- sync is local-first with manual backup and Apple iCloud support
- Learn is in migration, not greenfield
- Settings owns profile/personalization direction now

## Future-session default behavior

- consult local memory files before broad rescans
- extend partial systems instead of rebuilding new parallel ones
- prefer canonical routes over aliases for new work
- check `do_not_rebuild.md` before reviving old patterns
