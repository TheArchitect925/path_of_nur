# Riyad as-Salihin Trusted Transliteration Source Evaluation Matrix

Date: 2026-04-11

Scope:
- This document evaluates candidate source paths for `Riyad as-Salihin` transliteration only.
- It does not approve any import by itself.
- It is meant to guide the next trusted-source acquisition step for the existing canonical source-reference pipeline.

## Current repo readiness

- Runtime Riyad entries in the public corpus: `1068`
- Distinct canonical Riyad source-reference keys: `1068`
- Current trusted transliteration matches: `0`

This means the pipeline is ready for a one-reference-to-one-reference import if a trusted source is approved.

## Evaluation criteria

Each candidate was evaluated against:

1. Provenance / attribution
2. Scholarly trust
3. Licensing / reuse rights
4. Reference compatibility with current canonical source-reference keys
5. Transliteration consistency
6. Corpus completeness
7. Machine-readable structure
8. Manual review burden
9. Long-term maintainability

Status meanings:

- `approved`
  - Safe to ingest once mapped and validated.
- `approved with review`
  - Promising, but requires written rights confirmation, sample validation, or normalization review before import.
- `rejected`
  - Should not be used for runtime transliteration import.
- `insufficient evidence`
  - Not enough evidence of rights, completeness, or transliteration suitability yet.

## Matrix

| Candidate | Provenance / scholarly trust | Rights / reuse | Reference fit | Transliteration fit | Structure | Manual review burden | Classification | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Direct licensed digital export from the rights-holder or publisher of a Riyad transliteration edition | Strong if contract identifies edition, editor, and transliteration owner | Must be explicit in writing | Medium to high; likely needs normalization mapping | High if the edition uses one consistent transliteration scheme across the corpus | Medium; depends on export format | Medium | `approved with review` | Best long-term option if rights and source metadata are explicit. This is the safest path for a real first import. |
| Sunnah.com official data access for Riyad, if they can provide a transliteration-bearing API snapshot or dump | Strong. Sunnah.com documents a verification-oriented process and an official API request path | Better than scraped mirrors, but still requires confirmation that transliteration reuse is permitted for our use | High. Their reference-normalization posture is closest to our canonical source-reference model | Currently unproven for Riyad transliteration specifically | High if delivered through API or official dump | Low to medium | `insufficient evidence` | Strong candidate for outreach, but no public evidence was found on 2026-04-11 that Riyad transliteration is presently available as an ingestible official field. |
| Public Sunnah.com website pages alone | Strong site-level trust for Arabic/reference work | Not sufficient for ingestion by scraping; site explicitly disallows scraping and mass reproduction | High for references | Unclear for transliteration; public Riyad pages reviewed did not establish a dedicated transliteration corpus | Low for bulk import without API | High | `rejected` | Good research source, not an approved import source by itself. |
| Darussalam retail editions or publisher storefront listings without a direct export/license agreement | Strong publisher reputation in Sunni publishing | Commercial product pages do not create repo import rights | Medium; printed numbering may need mapping | Unknown until the exact edition and transliteration coverage are verified | Low | High | `insufficient evidence` | Promising only if converted into a direct licensed source agreement with machine-readable delivery. |
| PDF mirrors or scans of Riyad editions on third-party sites | Weak chain of custody even if the underlying book is respected | Rights unclear or likely not suitable | Medium | Unknown and often OCR-damaged | Low | Very high | `rejected` | Too much provenance and copyright risk for production import. |
| IslamHouse Riyad excerpts / related PDFs | Good organizational reputation for da'wah materials, but not a full Riyad transliteration source | Reuse terms for a transliteration corpus are not clearly established here | Low for full-corpus Riyad import | Not a complete Riyad transliteration corpus | Low | High | `rejected` | Useful for reading or reference, not suitable as the canonical transliteration source for Riyad. |
| Community GitHub / scraped hadith datasets derived from Sunnah.com or other websites | Weak to mixed; often unclear chain of custody | High risk if scraped or relicensed without permission | Often medium | Unknown, inconsistent, or absent | High | Very high | `rejected` | Convenient but too risky for trusted Islamic content ingestion. |

## Candidate review notes

### 1. Direct licensed rights-holder or publisher export

This is the cleanest import path if we can secure:

- the exact edition or transliteration owner
- explicit reuse rights for app distribution
- machine-readable delivery or a conversion right
- reference metadata that can be mapped to canonical source references

This is the only candidate in this review that is close to future-ready for a true `trusted` import, provided the rights and edition provenance are documented.

### 2. Sunnah.com official API / dump path

Sunnah.com publicly states that:

- it aims to provide an open platform for hadith
- it offers an API
- it may provide offline dumps later
- it verifies numbering against printed editions
- it does not permit scraping or mass reproduction from the website itself

That makes Sunnah.com a strong outreach target, but not yet an approved transliteration source for Riyad in this repo because public evidence of a reusable Riyad transliteration corpus was not established in this review.

### 3. Retail or mirrored PDFs

These are not safe for production ingestion.

Main blockers:

- unclear import rights
- unclear chain of custody
- weak machine readability
- high OCR or formatting damage risk
- uncertain transliteration coverage across the full Riyad corpus

## Recommendation

### Current recommendation

No publicly reviewed candidate is `approved` today for a real Riyad transliteration import.

### Best practical next source path

1. `Primary recommendation`
   - Pursue a direct licensed machine-readable export from the rights-holder or publisher of a Riyad transliteration edition.
   - Target status: upgrade this path from `approved with review` to `approved`.

2. `Parallel outreach path`
   - Contact Sunnah.com to determine whether Riyad transliteration exists in an official API, dump, or partner-access form with explicit reuse permission.
   - If yes, re-evaluate quickly because this would likely have the lowest reference-mapping burden.

### Not recommended

- scraping Sunnah.com pages
- importing from mirror PDFs
- importing from community GitHub dumps
- treating storefront listings as permission

## Minimum approval package before import

Before any Riyad transliteration import is allowed, the source package should include:

- source owner / publisher identity
- exact edition or dataset identity
- explicit reuse rights for this app and repository workflow
- whether transliteration is complete or partial
- at least one representative sample covering source references
- enough structure to match canonical source-reference keys

## Source links reviewed on 2026-04-11

- Sunnah.com Riyad collection: https://sunnah.com/riyadussalihin
- Sunnah.com About: https://beta.sunnah.com/about
- Sunnah.com Developers: https://beta.sunnah.com/developers
- Sunnah.com GitHub org: https://github.com/sunnah-com
- Darussalam About: https://darussalam.com/about-us/
- Darussalam Riyad-related catalog results: https://darussalam.com/authentic-islamic-hadiths-full-collection-with-free-shipping-to-uk-and-usa/
- Islamic Foundation mirror PDF found in search: https://islamicfoundation.ie/site/assets/files/1068/riyad-us-saliheen.pdf
- IslamHouse Riyad excerpts PDF: https://d1.islamhouse.com/data/en/ih_books/single2/en_Excerpts_from_Riyadh_us-Saliheen.pdf
