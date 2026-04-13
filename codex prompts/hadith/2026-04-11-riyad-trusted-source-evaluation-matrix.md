# Prompt Archive

===== PHASE X PROMPT — RIYAD AS-SALIHIN TRUSTED SOURCE EVALUATION MATRIX =====

PRIMARY OBJECTIVE === EVALUATE AND DOCUMENT TRUSTED SOURCE OPTIONS FOR RIYAD AS-SALIHIN TRANSLITERATION BEFORE ANY IMPORT

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Source evaluation and policy documentation only. Do not import transliteration in this phase.

Background:
The Hadith transliteration pipeline foundation and conflict-review tooling are already implemented.
No trusted repo-local Riyad as-Salihin transliteration source has been approved yet.

This phase should identify candidate sources and evaluate them using a clear, production-safe trust matrix.

CRITICAL RULES:
1. DO NOT generate transliteration.
2. DO NOT import transliteration in this phase.
3. DO NOT approve a source without documenting why.
4. DO NOT rely on vague or weak provenance.

Execution rules:
1. Audit the current transliteration pipeline and existing policy constraints first.
2. Build a concise but serious evaluation matrix for Riyad as-Salihin transliteration sources.
3. Focus on practical ingestion suitability, trust, and maintainability.
4. Keep the output production-usable, not just brainstorming notes.

Implement the following:

A. Create a Riyad transliteration source evaluation matrix
Evaluate candidate sources against:
- provenance / attribution
- scholarly trust
- licensing / reuse rights
- reference compatibility with current canonical source-reference keys
- transliteration consistency
- corpus completeness
- machine-readable structure
- manual review burden
- long-term maintainability

B. Produce a clear recommendation
For each candidate source, classify:
- approved
- approved with review
- rejected
- insufficient evidence

C. Add a policy artifact
Create a short repo-friendly policy doc that defines:
- what counts as an acceptable transliteration source
- what disqualifies a source
- what review is required before import
- what happens to ambiguous or partial matches

D. Keep this phase scoped
DO implement:
- evaluation matrix
- recommendation
- policy artifact

DO NOT implement:
- real transliteration import
- reader UI changes
- new ingestion logic unless a tiny documentation-related adjustment is needed

Validation:
Provide a concise summary with:
- candidate sources reviewed
- evaluation criteria
- recommendation
- files created or changed

At the very end, include a short note on the best next phase after this:
1. first real trusted Riyad transliteration import
2. reader display rules for verified vs missing transliteration
3. manual curation workflow improvements

===== END =====
