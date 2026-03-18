# Iteration 11 Implementation Prompt — codex_context_mod_runtime

Implement a **generic mod runtime** and **local knowledge library bootstrap** for `codex_context_engine`.

## Goal

Enable the engine to support commands like:

- `learn <mod>`
- `aprende <mod>`
- `study <mod>`
- `ingest <mod>`

Where `<mod>` is any domain identifier, not just UX.

Examples:

- `learn ux`
- `aprende accessibility`
- `study architecture`
- `ingest product_design`

The runtime must automatically create local mod directories and manifests, guide the user to add documents, and avoid repeating work unnecessarily.

---

## 1. Bootstrap `.codex_library/`

If `.codex_library/` does not exist at repo root, create it automatically.

Required structure:

```text
.codex_library/
  README.md
  registry.json
  mods/
```

### `.codex_library/README.md`
Create a user-facing README that explains:

- what this folder is
- that it is local workspace state
- that it is ignored by git
- how to add documents to a mod
- how to trigger learning / ingestion

### `.codex_library/registry.json`
Create if missing.

Initial shape:

```json
{
  "mods": {}
}
```

---

## 2. Update `.gitignore`

At repo root:

- if `.gitignore` does not exist, create it
- if `.codex_library/` is not already listed, add it

Use this exact block if missing:

```gitignore
# Codex Context Engine local knowledge library
.codex_library/
```

This must be idempotent.

---

## 3. Normalize mod requests

Detect intents such as:

- `learn <mod>`
- `aprende <mod>`
- `study <mod>`
- `ingest <mod>`

Normalize `<mod>` to a stable id:

- lowercase
- trim spaces
- replace internal spaces with underscores if needed
- keep it generic

Examples:

- `UX` -> `ux`
- `Product Design` -> `product_design`
- `frontend` -> `frontend`

---

## 4. Create mod library on demand

If requested mod `<mod_id>` does not exist, create:

```text
.codex_library/mods/<mod_id>/
  inbox/
  sources/
  processed/
  notes/
  summaries/
  indices/
  manifests/
  mod.json
```

### `mod.json`
Create a per-mod manifest with at least:

```json
{
  "id": "<mod_id>",
  "display_name": "<mod_id>",
  "status": "ready_for_documents",
  "supported_inputs": [".pdf", ".md", ".txt", ".html"],
  "created_by_iteration": 11,
  "documents": []
}
```

### Register the mod
Update `.codex_library/registry.json` to include:

```json
{
  "enabled": true,
  "library_root": ".codex_library/mods/<mod_id>",
  "manifest_path": ".codex_library/mods/<mod_id>/mod.json",
  "supported_inputs": [".pdf", ".md", ".txt", ".html"],
  "last_ingestion": null,
  "documents": []
}
```

---

## 5. Detect pending documents

For a requested mod, inspect:

```text
.codex_library/mods/<mod_id>/inbox/
```

Supported inputs:

- `.pdf`
- `.md`
- `.txt`
- `.html`

Determine which files are:

- new
- changed
- already processed

Do not treat already-processed files as pending.

Use manifest/state to avoid duplicate work.

---

## 6. Runtime behavior

### Case A — mod does not exist
Do all bootstrap steps and respond with guidance:

```text
Place documents in:
.codex_library/mods/<mod_id>/inbox/

Then run again:
learn <mod_id>
```

### Case B — mod exists and inbox has unprocessed documents
Do **not** implement the full processing logic here. Instead, route those pending documents into the document pipeline installed in Iteration 12.

### Case C — mod exists and nothing is pending
Return a concise status saying the mod library is already up to date.

---

## 7. MCP integration

Be ready to use these MCPs when available:

- **filesystem MCP**
  - read local documents
  - write generated artifacts
- **git MCP**
  - inspect repo status / changed files for better context
- **fetch MCP**
  - optional external enrichment if the user explicitly wants it
- **playwright MCP**
  - optional for mods that need live UI inspection

Important:
- MCP usage must remain optional
- local-only mode must still work
- do not make GitHub MCP a dependency

---

## 8. Documentation updates

Create or update:

1. `codex/iterations/11/readme.md`
2. `codex/iterations/11/codex_context_mod_runtime.md`
3. `codex/iterations/11/root_readme_update.md`

Also update the project root README with a section documenting:

- generic mods
- `.codex_library/`
- automatic bootstrap behavior
- example commands
- where users should place documents

---

## 9. Acceptance criteria

Implementation is correct if all of the following are true:

- `.codex_library/` is created automatically if missing
- `.codex_library/` is added to `.gitignore` automatically if missing
- `learn <mod>` creates the mod if it does not exist
- user gets clear instructions when no documents are present
- existing processed documents are not reprocessed
- unprocessed documents are routed into Iteration 12 pipeline
- design remains generic and reusable for any future mod
- MCP support is wired in as optional capability

---

## 10. Output quality bar

Prefer small, robust, composable helpers over large monolithic logic.

Keep naming generic and aligned with existing `codex_context_engine` conventions.

Do not hardcode UX-specific behavior into the runtime. UX is only the canonical first example.
