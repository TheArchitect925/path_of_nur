# Root README Update — Iteration 11

Add a new section to the root `README.md` explaining the generic mod runtime and local knowledge library.

## Suggested section title

## Generic Mods & Local Knowledge Library

`codex_context_engine` now supports **generic mods** backed by a local `.codex_library/` workspace.

This lets the engine create and manage domain-specific knowledge areas on demand.

### Example commands

```text
aprende ux
learn ux
aprende accessibility
study architecture
```

### How it works

When a requested mod does not exist yet, the engine automatically creates:

```text
.codex_library/mods/<mod_id>/
```

with:

```text
inbox/
sources/
processed/
notes/
summaries/
indices/
manifests/
mod.json
```

Users can then place source documents in:

```text
.codex_library/mods/<mod_id>/inbox/
```

When the engine is asked to learn that mod again, it will process pending documents into compact artifacts for cheaper future retrieval.

### Git behavior

`.codex_library/` is automatically ignored by git because it is local workspace state and may contain large or private documents.
