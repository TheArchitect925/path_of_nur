===== PHASE — BUILD HADITH CONTENT INGESTION + NORMALIZATION + VERIFICATION PIPELINE =====

PRIMARY OBJECTIVE === CREATE A PRODUCTION-SAFE HADITH CONTENT PIPELINE THAT INGESTS, NORMALIZES, VERIFIES, AND BUILDS A TRUSTED DATASET FOR THE APP

You are working in the existing Flutter codebase for Path of Nūr.

This is a backend/data-layer implementation task (local + tooling), not a UI task.
Do not redesign the app.
Do not build Hadith search yet.
Do not change the canonical runtime model unnecessarily.

CONTEXT
We already have:
- canonical Hadith foundation model
- verified-only public surfacing rules
- normalized metadata structure
- reader/detail page
- category/subcategory taxonomy
- cross-domain relation model

We do NOT yet have:
- a proper ingestion pipeline
- a structured normalization pipeline
- a verified dataset build pipeline

Currently, content is mostly seeded manually.

GOAL
Build a pipeline that:
1. ingests Hadith from trusted sources
2. normalizes them into the canonical model
3. applies verification rules
4. allows editorial enrichment
5. outputs a clean, release-ready dataset used by the app

IMPLEMENT THE FOLLOWING

A. DEFINE RAW INPUT FORMAT
- Support ingesting Hadith from structured sources (JSON or equivalent).
- Input should include:
  - source collection
  - book/chapter/reference
  - hadith number
  - Arabic text
  - translation
  - grading
  - narrator (if available)
- Keep this flexible for future sources.

B. BUILD NORMALIZATION LAYER
- Convert raw input into canonical Hadith foundation model:
  - normalize source collection/book
  - normalize reference and hadith number
  - normalize grading
  - normalize narrator
  - align Arabic + translation
- Generate canonical `HadithEntry.id`

C. ADD VERIFICATION FLAGS
- Add/derive:
  - isVerifiedSource
  - isVerifiedText
  - isVerifiedTranslation
- Ensure missing critical fields fail verification.

D. ADD EDITORIAL ENRICHMENT HOOK
- Allow adding:
  - category/subcategory
  - theme/topic
  - tags
  - lessons
  - Qur’an links (optional at this stage)
- Keep this editable and maintainable.

E. APPLY RELEASE-GATE RULES
- Reuse or extend the existing release gate logic.
- Only include entries that meet:
  - source present
  - reference present
  - grade present
  - verified flags true
- Everything else excluded from public dataset.

F. BUILD FINAL DATASET
- Output a clean dataset file:
  - e.g. `hadith_master_dataset.json`
- This dataset must:
  - match the canonical Hadith model
  - be ready for runtime usage
  - contain only verified entries

G. INTEGRATE WITH EXISTING REPOSITORY
- Ensure the canonical Hadith repository can:
  - read from this dataset
  - remain the single source of truth
- Do not bypass the repository.

H. ADD TEST COVERAGE
Add tests for:
- normalization correctness
- id generation stability
- grading normalization
- verification rules
- release gate enforcement
- dataset output validity

I. DO NOT BREAK
- canonical Hadith foundation model
- verified-only public surfacing
- current Hadith reader
- current routes
- editorial override path

J. KEEP THE CHANGESET TIGHT
- Focus only on pipeline and dataset building.
- Do not build UI or search in this phase.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files created/changed
3. How ingestion works
4. How normalization works
5. How verification works
6. How release gating works
7. How dataset output is structured
8. Validation notes
9. Analyzer results
10. Test results

At the very end, explicitly confirm:
- a full ingestion + normalization + verification pipeline exists
- dataset output is clean and trusted
- only verified Hadith reach runtime

===== END =====
