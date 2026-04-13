# ===== PHASE X PROMPT — HADITH TRANSLITERATION CONFLICT-REVIEW TOOLING =====

PRIMARY OBJECTIVE === BUILD SAFE CONFLICT-REVIEW TOOLING FOR HADITH TRANSLITERATION CURATION WITHOUT IMPORTING UNTRUSTED CONTENT

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready curation/reporting tooling for trusted hadith transliteration ingestion.

Background:
The transliteration pipeline foundation is already in place.
A Riyad import was intentionally NOT performed because there is no clearly trusted repo-local transliteration source file available yet.

This phase should improve safety and readiness by building better conflict-review tooling before any real source import happens.

CRITICAL RULES:
1. DO NOT generate transliteration.
2. DO NOT import untrusted transliteration.
3. DO NOT guess matches.
4. DO NOT overwrite verified content silently.

Execution rules:
1. Audit the current transliteration pipeline first.
2. Reuse the existing source-reference canonical model.
3. Keep runtime hadith behavior unchanged.
4. Build production-ready tooling, not throwaway scripts.
5. Run tests/analyzer and summarize results.

Implement the following:

A. Strengthen ingestion conflict reporting
Improve reporting for:
- duplicate import records
- conflicting transliteration payloads for the same source reference
- unmatched runtime references
- unmatched import records
- review-required records

B. Add explicit review-state workflows
Support clean statuses such as:
- verified
- needs_review
- rejected
- unmatched
Use the existing trust model where practical.

C. Add curator-friendly review outputs
Create review artifacts that are easy to inspect, such as:
- JSON review queue
- CSV export if practical
- grouped conflict reports by source/reference

D. Preserve canonical ownership
Ensure all review items remain anchored to canonical source-reference identity, not themed entry ids.

E. Keep this phase scoped
DO implement:
- stronger review reporting
- curator-facing conflict artifacts
- stable review-state handling

DO NOT implement:
- real transliteration import from untrusted sources
- AI generation
- reader UI redesign
- broad hadith architecture rewrites

Validation:
Confirm:
1. conflicts are surfaced clearly
2. review candidates are easy to inspect
3. canonical reference ownership is preserved
4. runtime behavior remains unchanged
5. tests/analyzer pass

Deliverables:
Provide a concise summary with:
- files changed
- what review tooling was added
- what new report artifacts were produced
- how conflicts are classified
- analyzer/test results

At the very end, include a short audit note on the best next phase after this:
1. trusted source evaluation matrix for Riyad as-Salihin
2. first real trusted transliteration import
3. reader display rules for verified vs missing transliteration

===== END =====
