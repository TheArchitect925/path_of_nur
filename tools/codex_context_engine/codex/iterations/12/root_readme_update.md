# Root README Update — Iteration 12

Add a new section to the root `README.md` documenting the knowledge processing pipeline.

## Suggested section title

## Knowledge Processing Pipeline

Iteration 12 introduces the pipeline that converts raw documents from a mod inbox into compact reusable knowledge artifacts.

### Generated artifacts

For processed documents, the engine generates:

```text
notes/
summaries/
indices/
manifests/
```

### Why this matters

Future requests can use these small derived artifacts instead of loading full source documents again, which keeps context cost low and makes the engine faster and more reusable.
