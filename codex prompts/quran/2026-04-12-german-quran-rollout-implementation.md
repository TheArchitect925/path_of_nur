PLEASE IMPLEMENT THIS PLAN:
## German Qur'an Translation Rollout Plan

### Summary
Plan this as **5 phases**.

German will be the **first real language rollout**, but the implementation should become the **template for all future trusted Qur'an translation languages**. The first shipped German version should be **bundled/local-first**, and “done” means **all current repository-backed Qur'an translation consumers** work, not just the main reader.

### Phase Plan
1. **Source Lock + Import Contract**
   - Confirm the exact approved German translation resource and translator metadata for the chosen candidate: **Frank Bubenheim and Nadeem Elyas**.
   - Freeze the source policy for this lane: one approved edition, no auto-translation, no mixed-source fallback.
   - Finalize the import artifact shape for a reviewed bundled translation file keyed by `verse_key`.
   - Acceptance: a decision-complete German source record exists with translator name, provider, source identifier, and import format.

2. **German Bundle Ingestion**
   - Build the ingestion step that converts the reviewed German source into the repo bundle shape already prepared by the import boundary.
   - Validate completeness for all verses and fail on any missing or duplicate verse keys.
   - Persist source metadata alongside the bundle so future audits can trace the translator and provider.
   - Acceptance: one complete German bundle exists locally and passes structural validation.

3. **Repository Integration**
   - Enable the German translation resource in the shared translation registry and settings allowlist.
   - Route German through the imported-bundle path in the Qur'an repository while leaving current bundled languages unchanged.
   - Preserve strict behavior: if the German imported bundle is incomplete, fail in development/QA rather than silently falling back.
   - Acceptance: repository methods for ayah loading, daily verse, and search can all resolve German from the imported bundle.

4. **Consumer Rollout**
   - Turn on German for every current repository-backed Qur'an translation consumer:
     - main Qur'an reader
     - search
     - daily verse / quote content
     - existing quote-content and repository-backed secondary surfaces
   - Ensure the reader settings label is clean and source-aware, while still keeping Arabic text untouched.
   - Acceptance: selecting German produces German translation text consistently across all current Qur'an consumers.

5. **German QA + Template Hardening**
   - Run German QA across verse accuracy, search relevance, daily verse rendering, and reader behavior.
   - Add regression checks so future language imports follow the same rules and do not reintroduce silent fallback.
   - Extract the German flow into the standard rollout template for future trusted languages.
   - Acceptance: German is approved for release and the workflow is reusable for the next language.

### Important Interface / Type Changes
- Use the existing source-aware translation registry as the canonical place for:
  - translation code
  - source type
  - runtime status
  - translator metadata
- Keep the imported translation bundle contract as the canonical non-bundled translation format:
  - `code`
  - `translatorName`
  - `sourceProvider`
  - optional source resource metadata
  - `verseTextsByVerseKey`
- Do not introduce runtime auto-translation or generic “fetch any language” behavior.
- Do not merge Qur'an translation governance with dua or hadith translation pipelines; keep them separate but philosophically aligned.

### Test Plan
- Import validation:
  - rejects missing verses
  - rejects empty translation entries
  - rejects duplicate verse keys
- Repository behavior:
  - German ayah retrieval returns imported German text
  - German daily verse uses imported German text
  - German search indexes imported German text
  - non-German existing bundled translations remain unchanged
- UI behavior:
  - German appears in translation settings only after the complete imported bundle is ready
  - switching to German updates all current Qur'an translation consumers consistently
- QA scenarios:
  - spot-check known verses in German
  - validate German search terms return expected ayahs
  - confirm no fallback to English occurs when German is selected

### Assumptions and Defaults
- German is the **first live lane**, but the rollout is designed as the **future template**.
- Delivery is **bundled/local-first**, not live remote-fetch first.
- The first release bar is **all current repository-backed Qur'an translation consumers**, not reader-only.
- Translator choice is **Frank Bubenheim and Nadeem Elyas**, pending exact approved source-resource confirmation.
- If the exact source metadata changes during verification, the phase structure stays the same; only the approved German source record changes.
