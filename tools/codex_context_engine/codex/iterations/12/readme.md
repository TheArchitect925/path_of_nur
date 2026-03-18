# Iteration 12 — Knowledge Processing Pipeline

## Purpose

Install the **document processing pipeline** used by generic mods created in Iteration 11.

This pipeline turns raw local documents into **cheap derived knowledge artifacts** so future queries can retrieve small notes, summaries and indices instead of re-reading full source documents.

## Processing stages

1. Detect pending documents
2. Extract text
3. Normalize text
4. Split content semantically
5. Identify major topics
6. Generate notes
7. Generate summaries
8. Generate indices
9. Generate retrieval maps
10. Update manifests and processed state

## Target outputs

For each processed document, the pipeline should generate artifacts under the relevant mod:

```text
sources/
processed/
notes/
summaries/
indices/
manifests/
```

These outputs become the low-cost knowledge layer used in future executions.

## MCP support

The pipeline should be ready to use these MCPs when available:

- **filesystem MCP** — file IO and source artifact writes
- **git MCP** — optional repo-aware context
- **fetch MCP** — optional enrichment
- **playwright MCP** — optional UI-derived captures for relevant mods

All MCPs remain optional.
