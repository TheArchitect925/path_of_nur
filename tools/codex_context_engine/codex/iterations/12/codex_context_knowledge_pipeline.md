# Iteration 12 Implementation Prompt — codex_context_knowledge_pipeline

Implement the **knowledge processing pipeline** for documents detected by the generic mod runtime from Iteration 11.

## Goal

Convert raw documents placed in:

```text
.codex_library/mods/<mod_id>/inbox/
```

into compact reusable artifacts that keep future context costs low.

The pipeline must support any mod, not just UX.

---

## 1. Detect pending documents

For each mod, inspect:

```text
.codex_library/mods/<mod_id>/inbox/
```

Supported input extensions:

- `.pdf`
- `.md`
- `.txt`
- `.html`

Only process documents that are:

- new
- changed
- not yet represented in processed/manifests state

Already-processed documents must be skipped.

---

## 2. Extract text

Extract source text and store normalized source artifacts under:

```text
.codex_library/mods/<mod_id>/sources/
```

Examples:

- extracted text files
- source metadata
- fingerprints / hashes
- document manifests

For PDFs, use available local tooling or MCP-assisted file access when available.

---

## 3. Normalize

Normalize extracted content so later stages operate on stable text:

- remove obvious extraction noise where reasonable
- preserve headings if possible
- keep structure when it helps semantic splitting
- store normalized outputs under:

```text
.codex_library/mods/<mod_id>/processed/
```

---

## 4. Semantic splitting

Split content by semantic boundaries whenever possible:

Preferred:
- chapter / section / heading boundaries
- topic boundaries
- explicit document structure

Fallback:
- paragraph groups or chunk windows

Store chunk metadata under `processed/`.

---

## 5. Topic extraction

Identify major topics / concepts from the document and generate a compact topic map.

Examples:
- topic labels
- keyword lists
- concept clusters
- section-to-topic mapping

Do not aim for perfection; aim for useful retrieval.

---

## 6. Generate notes

Create practical topical notes under:

```text
.codex_library/mods/<mod_id>/notes/
```

These notes should be:
- compact
- reusable
- retrieval-friendly
- oriented toward operational use

Prefer multiple smaller topical notes over one large dump.

---

## 7. Generate summaries

Create summary artifacts under:

```text
.codex_library/mods/<mod_id>/summaries/
```

Suggested outputs:
- executive summary
- practical summary
- rules / takeaways summary

The exact format may vary, but it should remain compact.

---

## 8. Generate indices

Create retrieval-oriented indices under:

```text
.codex_library/mods/<mod_id>/indices/
```

Suggested artifacts:
- keyword index
- topic index
- retrieval map

Example role of retrieval map:
- map a topic or query category to the most relevant notes / summaries

---

## 9. Update manifests

Record processed state under:

```text
.codex_library/mods/<mod_id>/manifests/
```

and/or update the per-mod `mod.json` / global registry state so the system can detect:

- already processed files
- changed files that need reprocessing
- last ingestion timestamps

This state must be enough to avoid duplicate work later.

---

## 10. Runtime outcome

After processing, future `learn <mod>` / `aprende <mod>` requests should prefer:

- notes
- summaries
- indices
- retrieval maps

instead of re-reading raw source documents from `inbox/`.

That is the core purpose of this iteration.

---

## 11. MCP integration

Be ready to use these MCPs when available:

- **filesystem MCP**
  - read source docs
  - write derived artifacts
- **git MCP**
  - optional repo-aware context and file-change awareness
- **fetch MCP**
  - optional external enrichment when explicitly needed
- **playwright MCP**
  - optional extraction from live UI contexts for relevant mods

Important:
- all MCP integrations remain optional
- the pipeline must still function in local-only mode
- do not add GitHub MCP dependency

---

## 12. Documentation updates

Create or update:

1. `codex/iterations/12/readme.md`
2. `codex/iterations/12/codex_context_knowledge_pipeline.md`
3. `codex/iterations/12/root_readme_update.md`

The root README update should explain that Iteration 12 transforms raw documents into compact retrieval artifacts.

---

## 13. Acceptance criteria

Implementation is correct if all of the following are true:

- new documents in a mod inbox are detected
- raw documents are extracted and normalized
- compact notes are generated
- compact summaries are generated
- indices / retrieval maps are generated
- processed-state manifests are updated
- already processed documents are skipped on future runs
- future requests can use derived artifacts instead of raw documents
- MCP support is present but optional

---

## 14. Output quality bar

Prefer a simple, durable pipeline over a clever brittle one.

Make the artifacts readable and easy to inspect.

Optimize for low-cost future retrieval, not perfect one-shot summarization.
