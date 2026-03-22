# Content Expansion System Backlog

## Next Enhancements

- Add a runtime import bridge from `content/` JSON into the existing game seed layers once the catalog format is stable.
- Normalize crossword pack metadata through a dedicated repository export path instead of leaving crossword packs as the current outlier.
- Add dev-only file save/load actions inside the internal builder instead of JSON copy-only export.
- Add preview widgets that render real game surfaces for each content type, not just metadata summaries.
- Add widget tests for the builder form, validation states, and preview chips.
- Add batch validation commands so CI can fail fast on malformed exported content files.
- Add structured localization export support for large authored teaching text.
