# Hadith Transliteration Source Policy

Date: 2026-04-11

Scope:
- Applies to Hadith transliteration imports in Path of Nūr.
- Intended for the canonical source-reference ingestion pipeline.
- Does not authorize AI generation, guesswork, or website scraping.

## Acceptable source standard

A transliteration source is acceptable only when all of the following are true:

1. The source owner or publisher is identifiable.
2. The transliteration is attributable to a named edition, dataset, publisher, or stewarded platform.
3. Reuse rights are explicit enough for app distribution and repository ingestion.
4. The data can be matched to canonical source-reference identity without guessing.
5. The transliteration style is internally consistent enough to support production display.
6. The source can be preserved in a reviewable, auditable format.

## Automatic disqualifiers

Reject a source if any of the following is true:

1. The transliteration was AI-generated or cannot be proven human-curated.
2. The source depends on scraping a website that disallows scraping or mass reproduction.
3. Rights are unclear, implied, or based only on public availability.
4. The source is a third-party mirror or scan with broken custody.
5. Reference mapping would require speculative matching.
6. The transliteration is partial, mixed-style, or OCR-damaged with no reliable review path.

## Review required before import

Even a promising source must not be imported until these checks are complete:

1. Rights review
   - Confirm the project can store, transform, and ship the transliteration data.
2. Sample review
   - Validate a representative sample of references against canonical source-reference keys.
3. Consistency review
   - Check that transliteration style is not erratic across the corpus.
4. Conflict review
   - Quarantine duplicate or conflicting payloads instead of auto-resolving them.
5. Coverage review
   - Record whether the source is complete, partial, or selective.

## Import decision rules

- `verified`
  - Source rights are clear, reference matching is confident, and sample validation passes.
- `needs_review`
  - Source is promising but has unresolved rights, mapping, or consistency issues.
- `rejected`
  - Source fails trust, rights, or provenance checks.
- `unmatched`
  - Runtime references have no approved source payload yet.

## Handling ambiguous or partial matches

1. Do not auto-fill ambiguous references.
2. Do not silently overwrite an already verified transliteration.
3. Keep ambiguous records out of verified runtime import.
4. Route them into the review queue with canonical `referenceKey` ownership.
5. Preserve the current safe runtime behavior when transliteration is absent.

## Preferred acquisition order

1. Direct licensed export from rights-holder or publisher
2. Official partner-access API or dump from a stewarded hadith platform
3. Everything else is non-default and requires explicit exception review

## Riyad-specific decision as of 2026-04-11

- No source is currently approved for automatic Riyad transliteration import.
- The preferred next step is to secure either:
  - a direct licensed Riyad transliteration export from the rights-holder or publisher, or
  - official confirmation from Sunnah.com that Riyad transliteration is available for licensed API or dump-based reuse
