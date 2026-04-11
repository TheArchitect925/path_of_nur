===== PHASE — INGEST AND NORMALIZE 40 NAWAWI + RIYAD AS-SALIHIN INTO THE CANONICAL HADITH PIPELINE =====

PRIMARY OBJECTIVE === EXPAND THE VERIFIED HADITH CORPUS BY ADDING 40 NAWAWI AND RIYAD AS-SALIHIN THROUGH THE EXISTING CANONICAL INGESTION, NORMALIZATION, VERIFICATION, AND RELEASE-GATE PIPELINE

You are working in the existing Flutter codebase for Path of Nūr.

This is a content-pipeline and dataset-expansion task.
Do not redesign the app.
Do not build Hadith search yet.
Do not guess. Use the existing canonical Hadith pipeline, trust rules, taxonomy, and runtime ownership already established.

CONTEXT
Completed groundwork already exists:
- one canonical public Hadith content owner
- verified-only/default public surfacing rules
- normalized Hadith source/book/chapter/reference metadata
- first-class source collection/book display fields
- canonical category/subcategory taxonomy
- canonical Hadith reader/detail page
- canonical Qur’an ↔ Hadith graph ids
- canonical cross-domain editorial relation model
- ingestion/normalization/inventory tooling
- current corpus inventory showing only 88 public-ready Hadith entries

The next best content expansion is:
1. 40 Nawawi
2. Riyad as-Salihin

These should be added through the canonical pipeline, not manually hacked into runtime code.

GOAL
Ingest, normalize, enrich, verify, and release-gate 40 Nawawi and Riyad as-Salihin into the canonical Hadith corpus so they become trustworthy, structured, public-ready Hadith entries inside Path of Nūr.

IMPORTANT PRODUCT RULES
- Only launch-ready, verified entries may reach the public runtime corpus.
- Do not bypass the canonical repository or public-content policy.
- Do not broaden trust rules.
- Do not mix source collections, app collections, themes, tags, and lessons into one blurred structure.
- Keep legacy curriculum lessons separate from canonical public Hadith ownership.

IMPLEMENT THE FOLLOWING

A. ADD RAW SOURCE INPUTS FOR 40 NAWAWI AND RIYAD AS-SALIHIN
- Create or extend the raw input dataset(s) so 40 Nawawi and Riyad as-Salihin entries can be ingested through the canonical tooling path.
- Raw source records should include as much trustworthy metadata as available:
  - source collection/book
  - book/chapter/reference
  - hadith number
  - Arabic text
  - translation
  - transliteration if available
  - narrator if available
  - grading
  - source URL / source reference
- Keep the raw import structure consistent with the current pipeline.

B. NORMALIZE INTO THE CANONICAL HADITH FORMAT
- Use the existing canonical normalization path to map these collections into the standardized Hadith model.
- Generate stable canonical ids using the agreed canonical id strategy.
- Normalize:
  - source collection/book
  - book/chapter/reference
  - hadith number
  - narrator
  - grading
  - source URLs and references
- Ensure source collection/book remains a first-class canonical/display-ready field.

C. APPLY CATEGORY / SUBCATEGORY TAXONOMY
- Assign canonical category and subcategory values to the newly added entries.
- Keep category/subcategory distinct from themes/tags/lessons.
- Reuse existing taxonomy structure rather than inventing a competing one.

D. ADD EDITORIAL ENRICHMENT SAFELY
Where feasible and trustworthy, enrich the new entries with:
- themeId
- themeTag
- tags
- lessons
- Qur’an connections
- relatedHadithIds if already justified
Do not fabricate theological links loosely.
If some enrichment is missing, leave it incomplete rather than inventing it.

E. APPLY TRUST / VERIFICATION RULES
- Run the existing verification and release-gate rules.
- Only entries satisfying the verified public criteria should enter the public runtime corpus.
- Entries missing trust-critical metadata should stay out of the public runtime set until completed.

F. UPDATE THE CANONICAL DATASET OUTPUT
- Regenerate the canonical Hadith dataset artifacts.
- Ensure the canonical public repository continues to read from the proper verified output path.
- Do not change runtime ownership away from the canonical public foundation repository.

G. UPDATE THE CORPUS INVENTORY
- Rebuild the normalized corpus inventory so we can see:
  - new total verified/public-ready count
  - counts by collection
  - counts by category/subcategory
  - counts by grade
  - metadata completeness for the newly added collections
- Explicitly show how much 40 Nawawi and Riyad as-Salihin increased the usable public corpus.

H. REVIEW FOR DUPLICATES / COLLISIONS
- Check for canonical id collisions and source-reference duplication while adding these collections.
- Flag suspicious duplicates clearly rather than silently collapsing them.
- Keep deterministic behavior.

I. PRESERVE CURRENT APP BEHAVIOR
- Do not break:
  - `/learn/hadith`
  - Hadith reader/detail routes
  - verified-only public surfacing
  - saved Hadith persistence
  - daily Hadith flow
  - kids Hadith routes
  - Hadith Reflection routes
  - editorial override flow
  - localization

J. ADD TEST COVERAGE
Add or update focused tests for:
- successful ingestion/normalization of 40 Nawawi entries
- successful ingestion/normalization of Riyad as-Salihin entries
- canonical id generation stability
- verified-only/public surfacing still holds
- metadata normalization correctness
- corpus inventory updates correctly
- current runtime Hadith repository remains valid

K. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- normalized metadata structure
- category/subcategory taxonomy
- Hadith reader/detail page
- Qur’an ↔ Hadith graph canonical ids
- editorial relation model
- existing route names and persistence keys

L. KEEP THE CHANGESET TIGHT
- Focus on ingesting and normalizing 40 Nawawi and Riyad as-Salihin only.
- Do not build search in this phase.
- Do not redesign UI in this phase.
- Do not import broad additional collections yet unless they are already partially present and clearly part of the same safe batch.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files created/changed
3. What raw source inputs were added
4. How 40 Nawawi was normalized into the canonical format
5. How Riyad as-Salihin was normalized into the canonical format
6. How category/subcategory and editorial enrichment were applied
7. How trust/release-gate rules were enforced
8. Updated corpus inventory, including:
   - total verified/public-ready count
   - count added from 40 Nawawi
   - count added from Riyad as-Salihin
   - updated counts by collection
   - updated counts by category/subcategory
9. Duplicate/collision findings if any
10. Analyzer results
11. Test results
12. Recommended next collection expansion priorities after this batch

IMPORTANT
At the very end, explicitly provide:
- new approximate total number of usable public-ready Hadith entries
- whether 40 Nawawi is now represented
- whether Riyad as-Salihin is now represented
- whether verified-only public surfacing still holds

===== END =====
