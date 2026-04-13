# ===== PHASE X PROMPT — HADITH TRUSTED TRANSLITERATION PIPELINE FOUNDATION =====

PRIMARY OBJECTIVE === BUILD THE FOUNDATION FOR TRUSTED HADITH TRANSLITERATION INGESTION WITHOUT GENERATING OR GUESSING ANY TRANSLITERATION

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready data model and ingestion foundation for Hadith transliteration.

Background:
A completed audit found that the public runtime hadith corpus currently has:
- Arabic present: 100%
- Translation present: 100%
- Transliteration present: 0%

So this is not a cleanup of bad transliteration.
This is a trusted-source ingestion and ownership problem.

CRITICAL RULES:
1. DO NOT generate transliteration.
2. DO NOT guess transliteration.
3. DO NOT use AI-created transliteration.
4. DO NOT overwrite runtime hadith text blindly.
5. Build only the safe foundation for trusted transliteration support.

Execution rules:
1. Audit the current hadith data model and ingestion pipeline first.
2. Reuse the existing data architecture where practical.
3. Preserve current runtime behavior for Arabic and translation.
4. Keep this production-ready and maintainable.
5. Do not break reader, browse, search, saved state, daily hadith, paths, or continuity.
6. Run analyzer on changed Dart files and summarize results.

Implement the following:

A. Add transliteration trust metadata support
Extend the hadith data model and ingestion pipeline to support transliteration metadata such as:
- transliteration text
- transliteration source
- transliteration quality/status
- optional review metadata if the current architecture supports it cleanly

Prefer a simple, explicit structure over a vague free-form field.

B. Support canonical ownership by source reference
Design the enrichment path so transliteration can be attached to a canonical source-reference layer rather than duplicated independently across every themed derivative entry.
Reuse current source-reference identity where practical.

C. Add safe ingestion hooks
Create the foundation for importing trusted transliteration from external structured data later.
This phase should support:
- matching by source/reference
- validation
- reporting on matched/unmatched records
Do not import real transliteration yet unless there is already a clearly trusted local source file in the repo.

D. Preserve runtime safety
If transliteration is missing or unverified:
- current reader behavior should remain safe
- no fake transliteration should appear
- keep UI behavior stable for now unless a tiny safe status hook is needed

E. Add audit/report support
Create a small reporting path so future ingestion runs can summarize:
- matched entries
- unmatched entries
- duplicate-reference groups
- records requiring manual review

F. Keep this phase scoped
DO implement:
- data model support
- ingestion foundation
- canonical ownership approach
- safe validation/reporting hooks

DO NOT implement:
- AI generation
- heuristic transliteration creation
- mass import from untrusted sources
- broad reader UI redesign
- unnecessary rewrites of hadith architecture

G. Validation
Confirm:
1. the hadith model can represent trusted transliteration and its source
2. transliteration can be owned canonically by source reference
3. the ingestion path can validate and report matches safely
4. runtime behavior remains safe when transliteration is absent
5. analyzer passes

Deliverables:
Provide a concise summary with:
- files changed
- new model/schema support added
- how canonical ownership is handled
- what ingestion/reporting hooks were added
- what was intentionally deferred
- analyzer results

At the very end, include a short audit note on the best next phase after this:
1. trusted source import for Riyad as-Salihin
2. runtime reader display rules for transliteration trust states
3. duplicate-reference ownership consolidation

===== END =====
