# Iteration 13 — Knowledge Retrieval Engine

## Purpose

Install the **knowledge retrieval engine** that makes Iterations 11 and 12 operationally powerful.

Iteration 11 creates mods and local libraries.
Iteration 12 processes raw documents into compact artifacts.
Iteration 13 selects the **right artifacts** for a given request so the engine loads minimal, relevant context instead of entire corpora.

## Core responsibilities

The retrieval engine should:

1. Detect which mod(s) are relevant to the current request
2. Infer likely topic / subtopic from the request
3. Use indices and retrieval maps generated in Iteration 12
4. Select the smallest useful set of artifacts
5. Prefer notes / summaries over raw sources
6. Respect context budget constraints
7. Feed selected artifacts into the broader context assembly flow

## Example

User request:

```text
how can I improve onboarding clarity?
```

Retrieval engine:

- infers likely mod: `ux`
- infers likely topic: `onboarding`
- reads lightweight indices
- selects the most relevant note and summary files
- avoids loading the full original source material

## MCP support

The retrieval engine should be ready to use these MCPs when available:

- **filesystem MCP** — load notes, summaries, indices and manifests
- **git MCP** — optional repo-aware relevance hints
- **fetch MCP** — optional enrichment if explicitly required
- **playwright MCP** — optional runtime UI context for relevant domains

MCP usage remains optional.
