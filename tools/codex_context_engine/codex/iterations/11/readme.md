# Iteration 11 — Generic Mod Runtime & Local Knowledge Library

## Purpose

Introduce a **generic mod runtime** to `codex_context_engine` and bootstrap a **local knowledge library** that lets the engine learn arbitrary domains from local documents.

This iteration is **not UX-specific**. UX is only the first example. The runtime must support any future mod requested by the user, such as:

- `ux`
- `accessibility`
- `product_design`
- `architecture`
- `frontend`
- `security`
- `ruby_backend`

The runtime should react to user intents such as:

- `learn ux`
- `aprende ux`
- `study accessibility`
- `ingest architecture`

## Core capabilities

Iteration 11 installs the capability to:

1. Create `.codex_library/` automatically if it does not exist.
2. Add `.codex_library/` to `.gitignore` automatically if missing.
3. Create a **global mod registry**.
4. Create **per-mod library directories** on demand.
5. Create **per-mod manifests** on demand.
6. Detect whether a mod:
   - does not exist yet
   - exists but has no documents
   - exists and has unprocessed documents
   - exists and is already up to date
7. Guide the user to place documents in the correct location.

## Local library layout

The runtime should ensure this local workspace exists:

```text
.codex_library/
  README.md
  registry.json
  mods/
    <mod_id>/
      inbox/
      sources/
      processed/
      notes/
      summaries/
      indices/
      manifests/
      mod.json
```

## Intended behavior

### Case A — user asks to learn a new mod that does not exist

Example:

```text
aprende ux
```

Expected behavior:

- create `.codex_library/` if missing
- create `.codex_library/mods/ux/` and its subdirectories
- create or update `.codex_library/registry.json`
- create `.codex_library/mods/ux/mod.json`
- tell the user to place documents in:

```text
.codex_library/mods/ux/inbox/
```

### Case B — mod exists and there are unprocessed documents

Expected behavior:

- detect pending documents in `inbox/`
- pass those documents to the processing pipeline installed in Iteration 12
- update manifests and status

### Case C — mod exists and everything is already processed

Expected behavior:

- do not redo expensive work
- report that the mod library is already up to date

## MCP support

The implementation should be ready to use these MCPs when available:

- **filesystem MCP** — read and write local files
- **git MCP** — inspect repository state and changed files
- **fetch MCP** — optional external enrichment or source retrieval
- **playwright MCP** — optional runtime UI inspection for mods that benefit from it

These MCP integrations must be **optional**, not mandatory. The iteration must still work in local-only mode.

## Design rules

- Generic, not domain-hardcoded
- Idempotent
- Safe on existing repos
- Cheap to operate after bootstrap
- Compatible with the current memory / telemetry layers
- Clear user guidance when documents are missing
- No duplicate processing when artifacts already exist
