# Root README Update — Iteration 13

Add a new section to the root `README.md` documenting the knowledge retrieval engine.

## Suggested section title

## Knowledge Retrieval Engine

Iteration 13 adds the retrieval layer that selects the most relevant learned artifacts from `.codex_library/` for a request.

Instead of re-reading raw source documents, the engine now prefers compact artifacts such as:

```text
notes/
summaries/
indices/
```

This keeps context costs low while making learned local corpora practically usable in real tasks.
